# PP4RS Assignment

* Contributors:
    - @krishnasini,  @mangianteg

## Documentation

The R Markdown of our analysis can be found in the folder `/out/paper`

## How to Run

1. Open a terminal and navigate to this directory (Window users should use PowerShell)
2. Check which packages the R script will use by running `sh find_r_packages.sh`
3. Install all the necessary R packages by running `Rscript install_r_packages.R`
4. Run `snakemake all`

## Install instructions

The goal is to make our entire workflow reproducible.
To do this we want
(i) the steps we need to take to process everything (our *workflow*)
    should be explicitly stated;
(ii) any packages we load in our `R` code to be stored so everyone who tries to
    run our code has the same versions installed

### Installing `R`

* Install the latest version of `R` by following the instructions
  [here](https://pp4rs.github.io/installation-guide/r/).
    * You can ignore the RStudio instructions for the purpose of this project.

### Documenting and Executing the Workflow
This project uses `Snakemake` to execute our research workflow.
You can install snakemake as follows:
* Install Snakemake from the command line (needs pip, and Python)
    ```
    pip install snakemake
    ```
    * If you haven't got Python installed click [here](https://pp4rs.github.io/installation-guide/python/) for instructions

### Archiving our `R` packages

To ensure that the same output is returned whenever our code is run we
want to ensure that the same `R` packages are used, and that the save *version* of the package is used. `Packrat` is a package manager that facilitates this task for us.

`packrat` is itself an `R` package. Once you have installed `R` and `Snakemake` we can install packrat as follows:

* Open a terminal and navigate to this folder.
* Install packrat by entering the following into the terminal, and pressing `Return`:
    ```
    snakemake packrat_install
    ```
    This opens an R session to install packrat for us.

* If you are starting a new project, which is likely if you are using
   this template, you need to initialize a new packrat instance to
   track your `R` packages and store them.
   Enter the following command into the same terminal as above
   and press `Return`.
   ```
   snakemake packrat_init
   ```
