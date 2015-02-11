for txt in diagrams/*.txt
do
    ditaa -E $txt
done

pandoc --standalone --toc --number-sections --biblio sources.bib 00_title.md 01_introduction.md 02_state-of-the-art.md 03_implementation.md 04_discussion.md 05_outlook.md -o thesis.pdf
rm diagrams/*.png

