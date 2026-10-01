{ pkgs, ... }:

{
  # TeX Live for compiling .tex → PDF (latexmk, pdflatex, biber, chktex, …)
  # scheme-medium covers most academic writing without the full multi-GB set.
  home.packages = with pkgs; [
    (texlive.combine {
      inherit (texlive)
        scheme-medium
        latexmk
        latexindent
        collection-latexextra
        collection-fontsrecommended
        collection-bibtexextra
        chktex
        synctex
        ;
    })
  ];
}
