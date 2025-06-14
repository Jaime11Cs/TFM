library(caret)
library(ranger)
library(doParallel)

cl <- makeCluster(parallel::detectCores() - 1)
registerDoParallel(cl)


M <- readRDS("ROSMAP_RINPMIAGESEX_resids.rds")
C <- readRDS("ROSMAP_RINPMIAGESEX_covs.rds")
C$Alzheimer <- factor(
  C$cogdx,
  levels = c("1", "2", "3", "4", "5"),
  labels = c("NCI", "MCI", "MCI_Comorbid", "AD", "AD_Comorbid")
)

set.seed(123)
train_index <- createDataPartition(C$Alzheimer, p = 0.8, list = FALSE)
M_train <- M[train_index, ]
C_train <- C[train_index, ]
Y_train <- C_train$Alzheimer

df_M_msex <- cbind(M_train, msex = C_train$msex)

tune_grid <- expand.grid(
  mtry = c(100, 200, 400, 800, 1000),
  splitrule = "gini",
  min.node.size = c(5, 10, 20, 25, 30)
)

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
  sampling = "up",
  allowParallel = TRUE
)

modelos_boot_Mmsex <- list()

for (i in 1:15) {
  set.seed(100 + i)
  
  df_train <- upSample(x = df_M_msex, y = Y_train)
  df_train$Alzheimer <- df_train$Class
  df_train$Class <- NULL
  
  modelo_cv <- train(
    Alzheimer ~ .,
    data = df_train,
    method = "ranger",
    tuneGrid = tune_grid,
    metric = "Accuracy",
    trControl = control_cv,
    importance = "impurity"
  )
  
  best_grid <- modelo_cv$bestTune
  
  modelo_boot <- train(
    Alzheimer ~ .,
    data = df_train,
    method = "ranger",
    tuneGrid = best_grid,
    metric = "Accuracy",
    trControl = control_boot,
    importance = "permutation"
  )
  

  modelos_boot_Mmsex[[i]] <- modelo_boot
}

saveRDS(modelos_boot_Mmsex, "modelos_boot_Mmsex.rds")

stopCluster(cl)
