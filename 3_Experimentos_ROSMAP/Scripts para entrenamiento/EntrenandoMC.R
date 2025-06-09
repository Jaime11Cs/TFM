library(caret)
library(doParallel)

set.seed(123)

cl <- makeCluster(detectCores() - 1)  
registerDoParallel(cl)

train_dataMC <- readRDS("train_dataMC.rds")

train_dataMC$Class <- as.factor(train_dataMC$Class)
levels(train_dataMC$Class) <- make.names(levels(train_dataMC$Class))

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

modelo_cv_MC <- train(
  Class ~ .,
  data = train_dataMC,
  method = "ranger",
  tuneGrid = tune_grid,
  metric = "Accuracy",
  trControl = control_cv,
  importance = "impurity"
)

saveRDS(modelo_cv_MC, "modelo_cv_MC.rds")
best_grid <- modelo_cv_MC$bestTune

control_boot <- trainControl(
  method = "boot",
  number = 30,
  classProbs = TRUE,
  allowParallel = TRUE
)

modelo_bootMC <- train(
  Class ~ .,
  data = train_dataMC,
  method = "ranger",
  tuneGrid = best_grid,
  metric = "Accuracy",
  trControl = control_boot,
  importance = "impurity"
)

saveRDS(modelo_bootMC, "modelo_bootMC.rds")
print("Entrenamiento completado con éxito")
stopCluster(cl)
