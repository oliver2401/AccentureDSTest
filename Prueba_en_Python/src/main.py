import os
import sys
from pathlib import Path

sys.path.append(os.path.abspath(os.path.join(
    os.path.abspath("__file__"), os.pardir, os.pardir, os.pardir)))

from src.EDA import *
from src.Model import *

test_report = EDA().CreateEDAReport()

features_pct_relevance_test, cat_boost_model_test, predictions_test, performance_report_test  = ExtractData().Train_catboost_model()
