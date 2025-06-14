library(caret)
library(doParallel)
library(foreach)

set.seed(123)

# Iniciar cluster
cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

# Cargar datos y partición
M <- readRDS("ROSMAP_RINPMIAGESEX_resids.rds")
C <- readRDS("ROSMAP_RINPMIAGESEX_covs.rds")

# Recodificar etiquetas de Alzheimer
C$Alzheimer <- factor(
  C$cogdx,
  levels = c(1, 2, 3, 4, 5),
  labels = c("NCI", "MCI", "MCI_Comorbid", "AD", "AD_Comorbid")
)

# Partición
train_index <- createDataPartition(C$Alzheimer, p = 0.8, list = FALSE)
train_ids <- train_index
M_train <- M[train_ids, ]
C_train <- C[train_ids, ]
Y_train <- as.factor(C_train$Alzheimer)

# Variables clínicas a probar
vars_C <- c("msex", "pmi", "rin", "braaksc", "ceradsc", "batch")

# Inicializar listas globales
varimp_total_list <- list()
ranking_total_list <- list()

# Hiperparámetros
tune_grid <- expand.grid(
  mtry = c(100, 200, 400, 800, 1000),
  splitrule = "gini",
  min.node.size = c(5, 10, 20, 25, 30)
)

# Control CV y boot
control_cv <- trainControl(
  method = "cv",
  number = 10,
  classProbs = TRUE,
  sampling = "up",
  allowParallel = TRUE
)

control_boot <- trainControl(
  method = "boot",
  number = 30,
  classProbs = TRUE,
  allowParallel = TRUE
)

# Bucle principal
for (var_c in vars_C) {
  cat(paste0("Procesando variable: ", var_c, "...\n"))
  
  varimp_list <- list()
  ranking_matrix <- matrix(nrow = ncol(M_train), ncol = 15)
  rownames(ranking_matrix) <- colnames(M_train)
  
  results <- foreach(i = 1:15, .packages = c("caret", "ranger")) %dopar% {
    set.seed(100 + i)
    
    # Crear dataset con variable clínica
    df_tmp <- cbind(M_train, varC = C_train[[var_c]])
    colnames(df_tmp)[ncol(df_tmp)] <- var_c
    
    # Balanceo
    train_data <- upSample(x = df_tmp, y = Y_train)
    train_data$Alzheimer <- train_data$Class
    train_data$Class <- NULL
    
    # CV
    modelo_cv <- train(
      Alzheimer ~ .,
      data = train_data,
      method = "ranger",
      tuneGrid = tune_grid,
      trControl = control_cv,
      metric = "Accuracy",
      importance = "impurity"
    )
    
    best_grid <- modelo_cv$bestTune
    
    # Boot
    modelo_boot <- train(
      Alzheimer ~ .,
      data = train_data,
      method = "ranger",
      tuneGrid = best_grid,
      trControl = control_boot,
      metric = "Accuracy",
      importance = "permutation"
    )
    
    # Extraer importancia y ranking
    varimp <- varImp(modelo_boot)$importance
    varimp_genes <- varimp[setdiff(rownames(varimp), var_c), , drop = FALSE]
    ranking <- rank(-varimp_genes$Overall, ties.method = "random")
    
    list(varimp = varimp_genes, ranking = ranking)
  }
  
  for (i in 1:15) {
    varimp_list[[i]] <- results[[i]]$varimp
    ranking_matrix[, i] <- results[[i]]$ranking
  }
  
  varimp_total_list[[var_c]] <- varimp_list
  ranking_total_list[[var_c]] <- ranking_matrix
  
  cat(paste0("✔ Finalizado: ", var_c, "\n"))
}

# Guardar resultados
saveRDS(varimp_total_list, "varimp_total_list_Mplus_15rep.rds")
saveRDS(ranking_total_list, "ranking_total_list_Mplus_15rep.rds")

stopCluster(cl)
cat("Todos los experimentos completados.\n")
