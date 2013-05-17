;;load path modifications
(add-to-list 'load-path "~/.emacs.d/")

;;show line numbers
(global-linum-mode 1)
(setq linum-format "%4d \u2502 ")

;;ido mode "Interactively Do Things"
(ido-mode 1)
(setq ido-enable-flex-matching t)
(setq ido-everywhere t)

;;set tab width
(setq default-tab-width 2)

;;set javascript tab width
(setq js-indent-level 2)

;;auto indent
(define-key global-map (kbd "RET") 'newline-and-indent)

(load "coffee-mode-master/coffee-mode.el")
(setq whitespace-action '(auto-cleanup)) ;; automatically clean up bad whitespace
(setq whitespace-style '(trailing space-before-tab indentation empty space-after-tab)) ;; only show bad whitespace
(defun coffee-custom ()
  "coffee-mode-hook"
 (set (make-local-variable 'tab-width) 2))

(add-hook 'coffee-mode-hook
  '(lambda() (coffee-custom)))

;; libraries
(load "nxhtml/autostart.el")
;; M-x mumamo-no-chunk-coloring
(setq warning-minimum-level :error) 

;;Auto Mode Alist
(add-to-list 'auto-mode-alist '("\\.json\\'" . javascript-mode))
(add-to-list 'auto-mode-alist '("\\.hbs\\'" . html-mode))

;;stylus/jade mode
(add-to-list 'load-path "~/.emacs.d/vendor/jade-mode")
(require 'sws-mode)
(require 'jade-mode)
(add-to-list 'auto-mode-alist '("\\.styl$" . sws-mode))
(add-to-list 'auto-mode-alist '("\\.jade$" . jade-mode))

(setq ispell-program-name "aspell")
(setq ispell-list-command "list")

;;move lines and regions
(require 'move-lines-region)

;; super turbo imenu using ido
(defun ido-goto-symbol (&optional symbol-list)
      "Refresh imenu and jump to a place in the buffer using Ido."
      (interactive)
      (unless (featurep 'imenu)
        (require 'imenu nil t))
      (cond
       ((not symbol-list)
        (let ((ido-mode ido-mode)
              (ido-enable-flex-matching
               (if (boundp 'ido-enable-flex-matching)
                   ido-enable-flex-matching t))
              name-and-pos symbol-names position)
          (unless ido-mode
            (ido-mode 1)
            (setq ido-enable-flex-matching t))
          (while (progn
                   (imenu--cleanup)
                   (setq imenu--index-alist nil)
                   (ido-goto-symbol (imenu--make-index-alist))
                   (setq selected-symbol
                         (ido-completing-read "Symbol? " symbol-names))
                   (string= (car imenu--rescan-item) selected-symbol)))
          (unless (and (boundp 'mark-active) mark-active)
            (push-mark nil t nil))
          (setq position (cdr (assoc selected-symbol name-and-pos)))
          (cond
           ((overlayp position)
            (goto-char (overlay-start position)))
           (t
            (goto-char position)))))
       ((listp symbol-list)
        (dolist (symbol symbol-list)
          (let (name position)
            (cond
             ((and (listp symbol) (imenu--subalist-p symbol))
              (ido-goto-symbol symbol))
             ((listp symbol)
              (setq name (car symbol))
              (setq position (cdr symbol)))
             ((stringp symbol)
              (setq name symbol)
              (setq position
                    (get-text-property 1 'org-imenu-marker symbol))))
            (unless (or (null position) (null name)
                        (string= (car imenu--rescan-item) name))
              (add-to-list 'symbol-names name)
              (add-to-list 'name-and-pos (cons name position))))))))
    (global-set-key (kbd "M-i") 'ido-goto-symbol) ; or any key you see fit======= end
