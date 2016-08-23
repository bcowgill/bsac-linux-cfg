./emacs-card.pl > emacs-keyref.html 2>&1
./emacs-card.pl ergo > emacs-ergo-keyref.html 2>&1
./emacs-card.pl emacs-tutorial.markup.txt > emacs-tutorial.txt
./emacs-card.pl emacsercises.markup.txt > emacsercises.txt

if [ "$1" == "launch" ]; then
	edit.sh emacs-card.pl emacs-tutorial.markup.txt emacsercises.markup.txt emacs-keyref.html emacs-ergo-keyref.html emacs-tutorial.txt emacsercises.txt
	browser.sh emacs-keyref.html emacs-ergo-keyref.html
fi
