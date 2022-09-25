# AccentureDSTest

# R execution
The main code in R is found in `full_pipeline_jenkins_job.R`, which simulates a jenkins job that would be put into production.

In order to successfully run the code, download the repository by running the following command in a Linux/Mac terminal:

```sh
git clone git@github.com:oliver2401/AccentureDSTest.git
```
inside a folder you have created. Then in Rstudio change your "working directory" to the `Test_in_R` folder and if you already have the `renv` package installed just run the following command in the terminal:

```sh
renv::restore()
```
Finally you can execute line by line inside `full_pipeline_jenkins_job.R` to generate the main findings in the EDA and the results/predictions/model/Performance of the XGBoost model

# Python execution

The main Python code is in `main.py`, which simulates a jenkins job that would be put into production.

In order to successfully run the code, download the repository by running the following command in a Linux/Mac terminal:

```sh
git clone git@github.com:oliver2401/AccentureDSTest.git
```
inside a folder you have created (eg `your_folder/AccentureDSTest/TEST_EN_PYTHON`). Afterwards, in your IDE of preference, install the necessary packages to execute the code by means of the following command in a terminal:

```sh
pipenv install
```
Which will install all the necessary dependencies to execute the code in `main.py` and will also generate a virtual environment that will avoid any conflict with the packages you have installed on your machine (For this you must have `pipenv` installed on your computer. If you don't have it installed just run `pip install pipenv`).


Finally you can execute line by line inside `main.py` (using ctrl+enter) to generate the main findings in the EDA and the results/predictions/model/Performance of the XGBoost model