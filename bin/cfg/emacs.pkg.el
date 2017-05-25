;; list of emacs packages to install based on emacs.pkg.lst
;; slam this into your ~/.emacs.d/lisp directory then start emacs, then remove from the dir
(package-initialize)
(add-to-list 'package-archives
             '("melpa" . "http://melpa.milkbox.net/packages/") t)
(package-refresh-contents)
;; commands below cannot actually be evaluated must manually be installed in emacs
(package-install 'ace-jump-mode)
(package-install 'auto-complete)
;;auto-complete requires semantic-analyze-current-context, semantic-tag-class,
;;    semantic-tag-function-arguments, yas-expand-snippet,
;;    semantic-format-tag-type, semantic-format-tag-name
(package-install 'color-identifiers-mode)
(package-install 'company)
;;requires     `company-css-property-value-regexp'
;;    company-css-property-values
(package-install 'csv-mode)
(package-install 'dash)
(package-install 'dockerfile-mode)
(package-install 'editorconfig)
(package-install 'editorconfig-custom-majormode)
(package-install 'elixir-mode)
(package-install 'epl)
(package-install 'epoch-view)
(package-install 'feature-mode)
(package-install 'flycheck)
(package-install 'gitignore-mode)
(package-install 'graphviz-dot-mode)
(package-install 'haml-mode)
(package-install 'js2-mode)
(package-install 'js2-refactor)
(package-install 'js3-mode)
(package-install 'json-mode)
(package-install 'json-reformat)
(package-install 'json-snatcher)
(package-install 'jsx-mode)
(package-install 'less-css-mode)
(package-install 'let-alist)
(package-install 'log4e)
(package-install 'log4j-mode)
(package-install 'markdown-mode)
(package-install 'markdown-toc)
(package-install 'mmm-mode)
(package-install 'multi-web-mode)
;;(package-install 'multiple-cursors)
(package-install 'nhexl-mode)
(package-install 'npm-mode)
(package-install 'num3-mode)
(package-install 'nyan-mode)
(package-install 'php-mode)
;;(package-install 'pkg-info)
;;(package-install 'popup)
(package-install 'powerline)
(package-install 'rainbow-mode)
(package-install 'rich-minority)
(package-install 'rope-read-mode)
;;(package-install 's)
(package-install 'sass-mode)
(package-install 'scss-mode)
;;(package-install 'seq)
(package-install 'simple-httpd)
(package-install 'skewer-mode)
(package-install 'smart-mode-line)
(package-install 'smart-mode-line-powerline-theme)
(package-install 'sqlup-mode)
(package-install 'sws-mode)
(package-install 'ten-hundred-mode)
(package-install 'tide)
(package-install 'tss)
(package-install 'typescript-mode)
(package-install 'web-beautify)
;;(package-install 'web-completion-data)
(package-install 'web-mode)
(package-install 'writegood-mode)
(package-install 'yaml-mode)
;;(package-install 'yasnippet)
(package-install 'yaxception)
(package-install 'ztree)

(package-install 'company-emoji)
(package-install 'company-php)
(package-install 'company-statistics)

(package-install 'company-dict);; emacs 24.4
(package-install 'company-quickhelp);; emacs 24.4
(package-install 'company-shell);; emacs-24.4



