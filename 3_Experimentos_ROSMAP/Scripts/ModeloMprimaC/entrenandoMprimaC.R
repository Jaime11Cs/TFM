library(caret)
library(doParallel)

set.seed(123)

cl <- makeCluster(detectCores() - 1)  
registerDoParallel(cl)

train_dataMprimaC <- readRDS("train_dataMprimaC.rds")

train_dataMprimaC$Class <- as.factor(train_dataMprimaC$Class)
levels(train_dataMprimaC$Class) <- make.names(levels(train_dataMprimaC$Class))


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

modelo_cv_MprimaC <- train(
  Class ~ .,
  data = train_dataMprimaC,
  method = "ranger",
  tuneGrid = tune_grid,
  metric = "Accuracy",
  trControl = control_cv,
  importance = "impurity"
)

saveRDS(modelo_cv_MprimaC, "modelo_cv_MprimaC.rds")
best_grid <- modelo_cv_MprimaC$bestTune

control_boot <- trainControl(
  method = "boot",
  number = 30,
  classProbs = TRUE,
  allowParallel = TRUE
)

modelo_bootMprimaC <- train(
  Class ~ .,
  data = train_dataMprimaC,
  method = "ranger",
  tuneGrid = best_grid,
  metric = "Accuracy",
  trControl = control_boot,
  importance = "impurity"
)

saveRDS(modelo_bootMprimaC, "modelo_bootMprimaC.rds")
print("Entrenamiento completado con éxito")
stopCluster(cl)
