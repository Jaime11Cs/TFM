library(caret)
library(doParallel)
library(ranger)
library(foreach)

set.seed(123)

cl <- makeCluster(detectCores() - 1)  
registerDoParallel(cl)

# Cargar datos
train_dataM <- readRDS("train_dataM.rds")
train_dataM$Class <- as.factor(train_dataM$Class)
levels(train_dataM$Class) <- make.names(levels(train_dataM$Class))

# Crear matriz de ranking (solo para predictores, no la variable objetivo)
genes <- setdiff(colnames(train_dataM), "Class")
ranking_matrix <- matrix(nrow = length(genes), ncol = 15)
rownames(ranking_matrix) <- genes

# Grilla de hiperparámetros
tune_grid <- expand.grid(
  mtry = c(100, 200, 400, 800, 1000),
  splitrule = "gini",
  min.node.size = c(5, 10, 20, 25, 30)
)

# Control de entrenamiento
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

varimp_list <- list()

results <- foreach(i = 1:15, .packages = c("caret", "ranger")) %dopar% {
  set.seed(100 + i)
  
  modelo_cv_M <- train(
    Class ~ .,
    data = train_dataM,
    method = "ranger",
    tuneGrid = tune_grid,
    metric = "Accuracy",
    trControl = control_cv,
    importance = "impurity"
  )
  
  best_grid <- modelo_cv_M$bestTune
  
  modelo_boot_M <- train(
    Class ~ .,
    data = train_dataM,
    method = "ranger",
    tuneGrid = best_grid,
    metric = "Accuracy",
    trControl = control_boot,
    importance = "permutation"
  )
  
  varimp <- varImp(modelo_boot_M)$importance
  ranking <- rank(-varimp$Overall, ties.method = "random")
  
  list(varimp = varimp, ranking = ranking)
}

for (i in 1:15) {
  varimp_list[[i]] <- results[[i]]$varimp
  ranking_matrix[, i] <- results[[i]]$ranking
}

saveRDS(varimp_list, "varimp_list_M_cvboot_15rep.rds")
saveRDS(ranking_matrix, "ranking_matrix_M_cvboot_15rep.rds")

print("Entrenamiento completado con éxito")
stopCluster(cl)
