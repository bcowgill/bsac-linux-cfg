;;; personal emacs functions
;;; Brent S.A. Cowgill
(defun bsac-smart-home
   ()
   "Move point to the first non-whitespace character on this line or to the beginning of current line as displayed.\nRepeated calls alternate between these positions."
   (interactive)
   (let ((where (point)))
   		(back-to-indentation)
		(if (equal where (point))
			(move-beginning-of-line 1))
		where
   ))
(define-key global-map (kbd "<home>") 'bsac-smart-home)

;; standard bindings for 'home' keys
;;(define-key global-map (kbd "M-m") 'back-to-indentation)

;;(define-key global-map (kbd "<home>") 'move-beginning-of-line)
(defun bsac-open-line
	()
    "Open a new line after the current one and put point on the new line."
    (interactive)
	(move-end-of-line 1)
	;; TODO indent to previous line...
    (newline))
;; newline = Enter
;; split-line = C-M-o
