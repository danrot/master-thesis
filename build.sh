if [ "$1" == "-i" ]
then
    for txt in diagrams/*.txt
    do
        ditaa -o -E $txt
    done

    for txt in diagrams/uml/*.txt
    do
        plantuml $txt
    done
fi

pandoc --template template.latex --standalone --chapters -V linestretch=1.5 --toc --number-sections --bibliography sources.bib 00_title.md 01_introduction.md 02_state-of-the-art.md 03_implementation.md 04_discussion.md 05_conclusion.md -o thesis.pdf

