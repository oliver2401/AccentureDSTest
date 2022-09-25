library(caret)
library(xgboost)
source('src/EDA.R')


CreateTrainTestSplit <- function(consolidated.data) {
  set.seed(7)
  indexes = createDataPartition(consolidated.data$Churn, p=.7, list=F)
  training.dataset = consolidated.data[indexes, ]
  test.dataset = consolidated.data[-indexes, ]
  
  string.cols <- names(Filter(is.character, training.dataset))
  training.dataset[, (string.cols) := lapply(.SD, as.factor), .SDcols = string.cols]
  test.dataset[, (string.cols) := lapply(.SD, as.factor), .SDcols = string.cols]
  
  splitted.datasets <- list("training" = training.dataset, "test" = test.dataset)
  return(splitted.datasets)
}

ConvertDatasetsToMatrices <- function(training.dataset, test.dataset) {
  training.variables <- data.matrix(training.dataset[, .SD, .SDcols = !c('Churn')])
  training.target <- training.dataset[, .(Churn = ifelse(Churn == 'Yes', 1, 0))]$Churn
  
  test.variables <- data.matrix(test.dataset[,.SD, .SDcols = !c('Churn')])
  test.target <- test.dataset[, .(Churn = ifelse(Churn == 'Yes', 1, 0))]$Churn
  
  training.test.targets.and.variables <- list(
    "training_variables" = training.variables,
    "training_target" = training.target,
    "test_variables" = test.variables,
    "test_target" = test.target)
  
  return(training.test.targets.and.variables)
}

TrainModel <- function(training.test.targets.and.variables) {
  training.variables <- training.test.targets.and.variables$training_variables
  training.target <- training.test.targets.and.variables$training_target
  
  xgb_train = xgb.DMatrix(data=training.variables, label=training.target)
  
  set.seed(7)
  xgbmodel = xgboost(data=xgb_train, max.depth=3, nrounds=50, verbose = 0)
  
  return(xgbmodel)
}

PredictTestClasses <- function(xgbmodel, training.test.targets.and.variables) {
  test.variables <- training.test.targets.and.variables$test_variables
  test.target <- training.test.targets.and.variables$test_target
  
  xgb_test = xgb.DMatrix(data=test.variables, label=test.target)
  
  prediction = predict(xgbmodel, xgb_test)
  
  prediction = as.factor(round(prediction))
  
  predictions.and.real.values <- list("prediction" = prediction, "test_targets" = as.factor(test.target))
  return(predictions.and.real.values)
}

GenerateMetrics <- function(predictions.and.real.values) {
  conf.matrix.results = confusionMatrix(
    predictions.and.real.values$test_target,
    predictions.and.real.values$prediction)
  
  return(conf.matrix.results)
}

GenerateFullTrainingProcess <- function() {
  consolidated.data <- CreateConsolidatedDataset()
  
  splitted.datasets_test <- CreateTrainTestSplit(consolidated.data)
  
  training.test.targets.and.variables_test <- ConvertDatasetsToMatrices(
    training.dataset =  splitted.datasets_test$training,
    test.dataset = splitted.datasets_test$training
  )
  
  xgbmodel_test <- TrainModel(training.test.targets.and.variables_test)
  
  predictions.and.real.values_test <- PredictTestClasses(xgbmodel = xgbmodel_test, training.test.targets.and.variables = training.test.targets.and.variables_test)
  
  conf.matrix.results_test <- GenerateMetrics(predictions.and.real.values_test)
  
  model.and.datasets <- list(
    "original_data" = consolidated.data,
    "splitted_data" = splitted.datasets_test,
    "model" = xgbmodel_test,
    "test_predictions" = predictions.and.real.values_test,
    "metrics" = conf.matrix.results_test
    )
  
  return(model.and.datasets)
}
