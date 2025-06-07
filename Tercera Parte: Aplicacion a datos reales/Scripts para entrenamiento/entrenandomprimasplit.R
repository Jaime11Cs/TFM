library(caret)
library(doParallel)
library(ranger)

set.seed(123)
cl <- makeCluster(detectCores() - 1)
registerDoParallel(cl)

MprimavarC_split_bal <- readRDS("MprimavarC_split_bal.rds")


tune_grid <- expand.grid(
  mtry = c(100, 200, 400, 800, 1000),
  splitrule = "gini",
  min.node.size = c(5, 10, 20, 25, 30)
)

control_cv <- trainControl(
  method = "cv",
  number = 10,
  classProbs = TRUE,
  allowParallel = TRUE
)

modelo_cv_split <- list()
mejores_hiperparametros_split <- list()

for (var_c in names(MprimavarC_split_bal)) {
  cat("\n➡ Entrenando CV - Variable:", var_c, "\n")
  
  data_train <- MprimavarC_split_bal[[var_c]]
  
  x_train <- data_train[, setdiff(colnames(data_train), "Alzheimer")]
  y_train <- data_train$Alzheimer
  
  modelo_cv <- train(
    x = x_train,
    y = y_train,
    method = "ranger",
    tuneGrid = tune_grid,
    metric = "Accuracy",
    trControl = control_cv,
    importance = "impurity",
    always.split.variables = var_c
  )
  
  modelo_cv_split[[var_c]] <- modelo_cv
  mejores_hiperparametros_split[[var_c]] <- modelo_cv$bestTune
}

saveRDS(modelo_cv_split, "modelo_cv_splitMprima.rds")

# Control bootstrap
control_boot <- trainControl(
  method = "boot",
  number = 1000,
  classProbs = TRUE,
  allowParallel = TRUE
)

modelo_boot_split <- list()

for (var_c in names(MprimavarC_split_bal)) {
  cat("\n➡ Entrenando Bootstrap - Variable:", var_c, "\n")
  
  data_train <- MprimavarC_split_bal[[var_c]]
  
  x_train <- data_train[, setdiff(colnames(data_train), "Alzheimer")]
  y_train <- data_train$Alzheimer
  
  modelo_boot <- train(
    x = x_train,
    y = y_train,
    method = "ranger",
    tuneGrid = mejores_hiperparametros_split[[var_c]],
    metric = "Accuracy",
    trControl = control_boot,
    importance = "impurity",
    always.split.variables = var_c
  )
  
  modelo_boot_split[[var_c]] <- modelo_boot
}

saveRDS(modelo_boot_split, "modelo_boot_splitMprima.rds")

stopCluster(cl)
