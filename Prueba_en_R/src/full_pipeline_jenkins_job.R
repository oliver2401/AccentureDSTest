source('src/Model.R')

original.consolidated.data <- CreateConsolidatedDataset()

#Create full data and plot relevant EDA findings
full.EDA.report <- GenerateFullEDAAndPlots(original.consolidated.data)
full.EDA.report$categorical_distributions
full.EDA.report$numerical_distributions
full.EDA.report$outliers
full.EDA.report$important_variables
full.EDA.report$missing_data
full.EDA.report$histograms

# Create model and generate metrics
full.training.results <- GenerateFullTrainingProcess()
predictions <- full.training.results$test_predictions
summary.performance <- full.training.results$metrics
