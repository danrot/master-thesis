for txt in diagrams/*.txt
do
    ditaa -E $txt
done

pandoc --standalone --toc --number-sections --csl fhv.csl 00_title.md 01_introduction.md 02_current-situation.md -o thesis.pdf
rm diagrams/*.png

