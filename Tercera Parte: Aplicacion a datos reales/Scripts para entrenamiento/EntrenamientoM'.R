library(caret)
library(doParallel)

set.seed(123)

cl <- makeCluster(detectCores() - 1)  
registerDoParallel(cl)

train_dataMprima <- readRDS("train_dataMprima.rds")

train_dataMprima$Class <- as.factor(train_dataMprima$Class)
levels(train_dataMprima$Class) <- make.names(levels(train_dataMprima$Class))

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

modelo_cv_Mprima <- train(
  Class ~ .,
  data = train_dataMprima,
  method = "ranger",
  tuneGrid = tune_grid,
  metric = "Accuracy",
  trControl = control_cv,
  importance = "impurity"
)

saveRDS(modelo_cv_Mprima, "modelo_cv_Mprima.rds")
best_grid <- modelo_cv_Mprima$bestTune

control_boot <- trainControl(
  method = "boot",
  number = 30,
  classProbs = TRUE,
  allowParallel = TRUE
)

modelo_bootMprima <- train(
  Class ~ .,
  data = train_dataMprima,
  method = "ranger",
  tuneGrid = best_grid,
  metric = "Accuracy",
  trControl = control_boot,
  importance = "impurity"
)

saveRDS(modelo_bootMprima, "modelo_bootMprima.rds")
print("Entrenamiento completado con éxito")
stopCluster(cl)
