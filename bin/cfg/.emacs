(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(ansi-color-faces-vector
   [default default default italic underline success warning error])
 '(ansi-color-names-vector
   ["#212526" "#ff4b4b" "#b4fa70" "#fce94f" "#729fcf" "#e090d7" "#8cc4ff" "#eeeeec"])
 '(bookmark-save-flag 0)
 '(column-number-mode t)
 '(custom-enabled-themes (quote (wheatgrass)))
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
(add-to-list 'load-path "~/.emacs.d/lisp")
(require 'editorconfig)
(editorconfig-mode 1)
(semantic-mode 1)

;;
;; ace jump mode major function
;;
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

;; install the company package first
;; http://company-mode.github.io/
(add-hook 'after-init-hook 'global-company-mode)

;;Shell mode completion,
(require 'readline-complete)

