import os
import sys
from dataclasses import dataclass
from pathlib import Path

import pandas as pd
import sweetviz

sys.path.append(os.path.abspath(os.path.join(
    os.path.abspath("__file__"), os.pardir, os.pardir, os.pardir)))


@dataclass
class EDA:
    file_path: str = 'data/data_sample.xlsx'

    def CreateConsolidatedDataset(self) -> pd.DataFrame:
        charges = pd.read_excel(self.file_path, sheet_name='Charges')
        other_data = pd.read_excel(self.file_path, sheet_name='Other data')
        churn = pd.read_excel(self.file_path, sheet_name='Churn')

        consolidated_data = pd.merge(other_data, charges, on = 'customerID')
        consolidated_data = pd.merge(consolidated_data, churn, on = 'customerID')
        consolidated_data['TotalCharges'] = pd.to_numeric(consolidated_data['TotalCharges'], errors='coerce')
        consolidated_data.fillna(0, inplace=True)

        return consolidated_data
    
    def CreateEDAReport(self) -> sweetviz.DataframeReport:
        consolidated_data = self.CreateConsolidatedDataset()
        my_report  = sweetviz.analyze(consolidated_data, target_feat='Churn') # target_feat='Churn'
        my_report.show_html('FinalReport.html')

        return my_report
