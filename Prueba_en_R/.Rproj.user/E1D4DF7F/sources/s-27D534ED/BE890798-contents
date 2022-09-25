library(data.table)
library(DataExplorer)
library(readxl)
library(SmartEDA)


CreateConsolidatedDataset <- function(data.file = "data/data_sample.xlsx") {
  charges <- setDT(read_excel(data.file, sheet = "Charges"))
  
  other.data <- setDT(read_excel(data.file, sheet = "Other data"))
  
  churn <- setDT(read_excel(data.file, sheet = "Churn"))
  
  consolidated.data <- merge(other.data, charges, by = c('customerID'))
  consolidated.data <- merge(consolidated.data, churn, by = c('customerID'))
  
  return(consolidated.data)
}


GenerateFullEDAAndPlots <- function(consolidated.data) {
  columns.with.missing.data <- plot_missing(consolidated.data)
  
  numerical.variables.outliers <- ExpNumStat(
    consolidated.data,
    by="G",
    gp="Churn",
    MesofShape = 2,
    Outlier = TRUE,
    round = 2)
  
  all.variables.histograms <- plot_bar(consolidated.data, by = "Churn")
  
  numerical.distributions.vs.target <- ExpNumViz(
    consolidated.data,
    target="Churn",
    type=1,
    nlim=3,
    fname=NULL,
    col=c("darkgreen","springgreen3","springgreen1"),
    Page=c(2,2))[[1]]
  
  categorical.distributions.vs.target <- ExpCatViz(
    consolidated.data,
    target="Churn",
    fname=NULL,
    clim=5,
    col=c("slateblue4","slateblue1"),
    margin=2,
    Page = c(2,1))[[1]]
  
  
  relevant.variables <- ExpCatStat(
    consolidated.data,
    Target ="Churn",
    result = "Stat",
    clim=10,
    nlim=5,
    bins=10,
    Pclass="Yes",
    plot=TRUE,
    top=5,
    Round=2)
  
  plots <- list(
    "missing_data" = columns.with.missing.data,
    "outliers" = numerical.variables.outliers,
    "histograms" = all.variables.histograms,
    "numerical_distributions" = numerical.distributions.vs.target,
    "categorical_distributions" = categorical.distributions.vs.target,
    "important_variables" = relevant.variables
  )
  return(plots)
}


