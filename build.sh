for txt in diagrams/*.txt
do
    ditaa $txt
done

pandoc --standalone --toc --number-sections 00_title.md 01_introduction.md -o thesis.pdf
rm diagrams/*.png

