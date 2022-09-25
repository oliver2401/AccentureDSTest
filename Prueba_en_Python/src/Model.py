import os
import sys
from pathlib import Path
from typing import Tuple

import matplotlib.pyplot as plt
import numpy as np
from catboost import CatBoostClassifier, metrics
from sklearn.metrics import classification_report
from sklearn.model_selection import train_test_split

sys.path.append(os.path.abspath(os.path.join(
    os.path.abspath("__file__"), os.pardir, os.pardir, os.pardir)))

from src.EDA import *


@dataclass
class ExtractData:
    
    def Generate_train_validation_sets(self):
        consolidated_data = EDA().CreateConsolidatedDataset()

        features_train, features_validation, targets_train, targets_validation = train_test_split(consolidated_data.drop('Churn', axis= 1),
         consolidated_data.Churn,
         train_size=0.75,
         random_state=42
        )

        return features_train, features_validation, targets_train, targets_validation

    def Train_catboost_model(self) -> Tuple[np.ndarray, CatBoostClassifier, np.ndarray, str]:
        features_train, features_validation, targets_train, targets_validation = self.Generate_train_validation_sets()
        
        categorical_columns = list(features_train.select_dtypes(include=['object']).columns)

        cat_boost_model = CatBoostClassifier(
            custom_loss=[metrics.Accuracy()],
            random_seed=42,
            logging_level='Silent',
            loss_function='Logloss',
            eval_metric='Accuracy'
        )

        cat_boost_model.fit(
            features_train, targets_train,
            cat_features = categorical_columns,
            eval_set=(features_validation, targets_validation)
        )

        features_pct_relevance = cat_boost_model.feature_importances_

        predictions = cat_boost_model.predict(features_validation)
        performance_report = classification_report(targets_validation, predictions)

        return features_pct_relevance, cat_boost_model, predictions, performance_report
