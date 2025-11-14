{ config, pkgs, ... }:

let
  rPackagesList = with pkgs.rPackages; [
    tidyverse
    data_table
    devtools
    languageserver
    rmarkdown
    readxl
    psych
    corrplot
    FactoMineR
    factoextra
    #more chatgpt suggestions
    janitor   #quick variable cleaning tabulations
    broom   #tidy model summaries
    modelsummary  #regression tables (to gt or kableExtra)
    gt
    kableExtra  #both table rendering backends
    here  #stable project paths
    knitr #chunk options when knitting from Quarto/Rmd
    #chatgpt said for nvim
    lintr
    styler
  ];

  R-with-my-packages = pkgs.rWrapper.override {
    packages = rPackagesList;
  };

  RStudio-with-my-packages = pkgs.rstudioWrapper.override {
    packages = rPackagesList;
  };
in
{
  home.packages = [
    R-with-my-packages
    RStudio-with-my-packages
    pkgs.pandoc
    pkgs.quarto
    pkgs.texliveFull
  ];
}
