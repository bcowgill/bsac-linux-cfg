(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector [default default default italic underline success warning error])
 '(ansi-color-names-vector ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(bookmark-save-flag 0)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (wheatgrass)))
 '(custom-safe-themes (quote ("a27c00821ccfd5a78b01e4f35dc056706dd9ede09a8b90c6955ae6a390eb1c1e" default)))
 '(desktop-auto-save-timeout 30)
 '(dired-listing-switches "-al")
 '(display-battery-mode t)
 '(display-time-mode t)
 '(double-click-fuzz 5)
 '(dynamic-completion-mode t)
 '(ergoemacs-ctl-c-or-ctl-x-delay 0.2)
 '(ergoemacs-handle-ctl-c-or-ctl-x (quote both))
 '(ergoemacs-keyboard-layout "gb")
 '(ergoemacs-smart-paste nil)
 '(ergoemacs-theme "lvl1")
 '(ergoemacs-theme-options nil)
 '(ergoemacs-use-menus t)
 '(fill-column 76)
 '(font-use-system-font t)
 '(fringe-mode (quote (nil . 0)) nil (fringe))
 '(indicate-empty-lines t)
 '(isearch-allow-scroll t)
 '(isearch-resume-in-command-history t)
 '(kill-whole-line t)
 '(minimap-minimum-width 10)
 '(minimap-mode nil)
 '(minimap-recreate-window nil)
 '(minimap-width-fraction 0.05)
 '(minimap-window-location (quote right))
 '(mouse-avoidance-mode (quote exile) nil (avoid))
 '(mouse-avoidance-nudge-dist 15)
 '(mouse-avoidance-nudge-var 10)
 '(mouse-wheel-inhibit-click-time 0.5)
 '(mouse-yank-at-point t)
 '(msb-mode t)
 '(regexp-search-ring-max 64)
 '(replace-lax-whitespace t)
 '(require-final-newline t)
 '(safe-local-variable-values (quote ((emacs-lisp-docstring-fill-column . 75))))
 '(save-completions-retention-time 1344)
 '(save-interprogram-paste-before-kill t)
 '(save-place t nil (saveplace))
 '(scroll-bar-mode (quote left))
 '(search-ring-max 64)
 '(show-paren-mode t)
 '(show-paren-style (quote expression))
 '(show-trailing-whitespace t)
 '(size-indication-mode t)
 '(tab-width 4)
 '(track-eol t)
 '(woman-fill-frame t)
 '(woman-imenu t)
 '(woman-use-topic-at-point t)
 '(woman-use-topic-at-point-default t))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(default ((t (:family "ProFontWindows" :foundry "unknown" :slant normal :weight normal :height 181 :width normal)))))
(server-start)
(icomplete-mode t)
(desktop-save-mode 1)
(savehist-mode 1)
(setq desktop-restore-eager 15)

;;Configure to use melpa emacs package libraries
;;https://melpa.org/#/getting-started
;;Alt-x package-list-packages
;;Ux  - mark packages for upgrade and execute upgrades
(require 'package)
(add-to-list 'package-archives
             '("melpa-stable" . "https://stable.melpa.org/packages/"))

(add-to-list 'load-path "~/.emacs.d/lisp")
(add-to-list 'load-path "~/.emacs.d/elpa/editorconfig-0.7.9")
(add-to-list 'load-path "~/.emacs.d/elpa/web-mode-14.1")
(add-to-list 'load-path "~/.emacs.d/elpa/company-0.9.3")
(add-to-list 'load-path "~/.emacs.d/elpa/nyan-mode-1.1.2")
(add-to-list 'load-path "~/.emacs.d/elpa/rainbow-mode-0.12")
(add-to-list 'load-path "~/.emacs.d/elpa/writegood-mode-2.0.2")

(require 'editorconfig)
(require 'nyan-mode)
(require 'rainbow-mode)
(editorconfig-mode 1)
(semantic-mode 1)
(nyan-mode 1)
(rainbow-mode 1)
(writegood-mode 1)

;;
;; ace jump mode major function
;;
;; C-c Space and C-c C-' were chosen as bind keys

(autoload
  'ace-jump-mode
  "ace-jump-mode"
  "Emacs quick move minor mode. Start of word or any letter with prefix key or any line with two prefix keys."
  t)
;; you can select the key you prefer to
(define-key global-map (kbd "C-c SPC") 'ace-jump-mode)

;;
;; enable a more powerful jump back function from ace jump mode
;;
(autoload
  'ace-jump-mode-pop-mark
  "ace-jump-mode"
  "Ace jump back:-)"
  t)
(eval-after-load "ace-jump-mode"
  '(ace-jump-mode-enable-mark-sync))
(define-key global-map (kbd "C-c C-SPC") 'ace-jump-mode-pop-mark)

;; configure the ace jump keys to try and keep your fingers on
;; the home row as much as possible
(setq ace-jump-mode-move-keys
      '(?j ?f ?h ?g ?u ?r ?n ?v ?y ?b ?m ?t ?k ?d ?i ?e ?, ?c ?l ?s ?; ?a ?o ?w ?. ?x ?p ?q ?z
       ?J ?F ?H ?G ?U ?R ?N ?V ?Y ?B ?M ?T ?K ?D ?I ?E   ?C ?L ?S   ?A ?O ?W   ?X ?P ?Q ?Z))

;;If you use viper mode :
;;(define-key viper-vi-global-user-map (kbd "SPC") 'ace-jump-mode)
;;If you use evil
;;(define-key evil-normal-state-map (kbd "SPC") 'ace-jump-mode)

;; regular expression builder tool
(require 're-builder)
(setq reb-re-syntax 'string)

;;Keyboard macro definitions
;; Webstorm alt up/down to move a single line up/down
(fset 'bsac-move-line-down-macro
   [down ?\C-x ?\C-t up])
(fset 'bsac-move-line-up-macro
   [?\C-x ?\C-t up up])
(global-set-key [(meta up)] 'bsac-move-line-up-macro)
(global-set-key [(meta down)] 'bsac-move-line-down-macro)
(fset 'bsac-open-line-macro
   [end return tab])

(require 'company)
;; install the company package first
;; http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)
;; TAB/Shift-TAB to cycle through completions
(defun company-complete-common-or-previous-cycle ()
  "Insert the common part of all candidates, or select the next one."
  (interactive)
  (when (company-manual-begin)
    (let ((tick (buffer-chars-modified-tick)))
      (call-interactively 'company-complete-common)
      (when (eq tick (buffer-chars-modified-tick))
        (let ((company-selection-wrap-around t))
          (call-interactively 'company-select-previous))))))
;; ??? generates error on startup, disable key bindings for now
;; (define-key company-active-map (kbd "TAB") 'company-complete-common-or-cycle)
;; (define-key company-active-map (kbd "<backtab>") 'company-complete-common-or-previous-cycle)
;; (define-key company-active-map (kbd "C-n") 'company-complete-common-or-cycle)
;; (define-key company-active-map (kbd "C-p") 'company-complete-common-or-previous-cycle)

;;Shell mode completion,
;;BSAC RESTORE(require 'readline-complete)

(add-to-list 'auto-mode-alist '("mix\\.lock\\'" . elixir-mode))

;;Typescript configurations
(defun setup-tide-mode ()
  (interactive)
  (tide-setup)
  (flycheck-mode +1)
  (setq flycheck-check-syntax-automatically '(save mode-enabled))
  (eldoc-mode +1)
  (tide-hl-identifier-mode +1)
  ;; company is an optional dependency. You have to
  ;; install it separately via package-install
  ;; `M-x package-install [ret] company`
  (company-mode +1))

;; Turn on tsserver debug log
;;(setq tide-tsserver-process-environment '("TSS_LOG=-level verbose -file /tmp/tss.log"))

;; aligns annotation to the right hand side
(setq company-tooltip-align-annotations t)

;; formats the buffer before saving
(add-hook 'before-save-hook 'tide-format-before-save)
(setq tide-format-options '(:baseIndentSize 3 :indentStyle 1 :indentSize 3 :tabSize: 3 :convertTabsToSpaces nil :insertSpaceAfterCommaDelimiter t :insertSpaceAfterSemicolonInForStatements t :insertSpaceBeforeAndAfterBinaryOperators t :insertSpaceAfterKeywordsInControlFlowStatements t :insertSpaceAfterFunctionKeywordForAnonymousFunctions t :insertSpaceAfterOpeningAndBeforeClosingNonemptyParenthesis t :insertSpaceAfterOpeningAndBeforeClosingNonemptyBrackets t :insertSpaceAfterOpeningAndBeforeClosingJsxExpressionBraces nil :placeOpenBraceOnNewLineForFunctions t :placeOpenBraceOnNewLineForControlBlocks t))

(add-hook 'typescript-mode-hook #'setup-tide-mode)

;; tide TSX support
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.tsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "tsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; tide JavaScript support
(add-hook 'js2-mode-hook #'setup-tide-mode)

;; tide JSX
(require 'web-mode)
(add-to-list 'auto-mode-alist '("\\.jsx\\'" . web-mode))
(add-hook 'web-mode-hook
          (lambda ()
            (when (string-equal "jsx" (file-name-extension buffer-file-name))
              (setup-tide-mode))))

;; treat json5 files as json
(add-to-list 'auto-mode-alist '("\\.json5\\'" . json-mode))

;; completion for html, jade, etc
(add-to-list 'company-backends 'company-web-html)
(add-to-list 'company-backends 'company-web-jade)
(add-to-list 'company-backends 'company-web-slim)
