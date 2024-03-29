(load "~/.emacs.d/plugins/theme.el")
(defun add-subfolders-to-load-path (parent-dir)
  "Add subfolders to load path"
  (dolist (f (directory-files parent-dir))
    (let ((name (concat parent-dir f)))
      (when (and (file-directory-p name)
                 (not (equal f ".."))
                 (not (equal f ".")))
        (add-to-list 'load-path name)))))
(add-to-list 'load-path "~/.emacs.d/")
(add-to-list 'load-path "~/.emacs.d/plugins/")
(add-subfolders-to-load-path "~/.emacs.d/plugins/")
(require 'undo-tree)
(global-undo-tree-mode)

(setq evil-want-C-u-scroll t)
(setq show-paren-delay 0)
(show-paren-mode)

(require 'evil)
(evil-mode 0)

(define-key evil-normal-state-map [escape] 'keyboard-quit)
(define-key evil-visual-state-map [escape] 'keyboard-quit)
(define-key evil-replace-state-map [escape] 'keyboard-quit)
(define-key evil-motion-state-map [escape] 'keyboard-quit)
(define-key evil-operator-state-map [escape] 'keyboard-quit)

(define-key evil-visual-state-map ";" 'comment-or-uncomment-region)
(define-key evil-visual-state-map "\\c " 'comment-or-uncomment-region)
(define-key evil-normal-state-map "\C-n" nil)
(define-key evil-normal-state-map "\C-p" nil)

(setq ac-use-menu-map t)
;;; esc quits
(global-set-key [escape] 'keyboard-escape-quit)
;(global-set-key "\C-s" 'save-buffer)
(define-key isearch-mode-map [escape] 'isearch-abort)
(define-key minibuffer-local-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-filename-completion-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-filename-must-match-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-must-match-filename-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-shell-command-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-ns-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-completion-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-must-match-map [escape] 'keyboard-escape-quit)
(define-key minibuffer-local-isearch-map [escape] 'keyboard-escape-quit)

(require 'yasnippet)
(yas/initialize)

(require 'auto-complete-config)
(add-to-list 'ac-dictionary-directories "~/.emacs.d/plugins/ac-install/ac-dict")
(ac-config-default)
(global-auto-complete-mode t)

(set-language-environment "utf-8")
(load (expand-file-name "~/quicklisp/slime-helper.el"))
(setq slime-lisp-implementations
      '(
        (sbcl ("/usr/bin/sbcl") :coding-system utf-8-unix)
        (ccl64 ("/usr/bin/ccl64" "-K" "'utf-8-unix") :coding-system utf-8-unix)
        (ccl ("/usr/bin/ccl" "-K" "'utf-8-unix") :coding-system utf-8-unix)))

;(add-to-list 'load-path "/usr/share/emacs/site-lisp/slime/")
(add-to-list 'load-path "~/.emacs.d/slime/")
(require 'slime)
(setq slime-net-coding-system 'utf-8-unix)
(slime-setup '(slime-fancy))

(require 'ac-slime)

(add-hook 'slime-mode-hook 'set-up-slime-ac)
(add-hook 'slime-repl-mode-hook 'set-up-slime-ac)
(eval-after-load "auto-complete"
  '(progn
     ;; (add-to-list 'ac-modes 'slime-repl-mode)
     (add-to-list 'ac-modes 'lisp-mode)
     (add-to-list 'ac-modes 'common-lisp-mode)
     (add-to-list 'ac-modes 'slime-mode)))

(require 'paredit)
(autoload 'enable-paredit-mode "paredit"
  "Turn on pseudo-structural editing of Lisp code."
  t)

;;;
;;; Org Mode
;;;
(add-to-list 'auto-mode-alist '("\\.\\(org\\|org_archive\\|txt\\)$" . org-mode))
(global-font-lock-mode 1)

(add-hook 'org-mode-hook
          '(lambda ()
             (setq evil-auto-indent nil)
             (setq whitespace-style
                   (quote
                    (face tabs spaces space-before-tab newline
                          indentation empty space-after-tab space-mark
                          tab-mark)))))

(defun my-indent-sexp ()
  (interactive)
  (save-excursion
    (if (equal (string (following-char)) ")")
        (progn
          (forward-char)
          (backward-sexp))
      (if (equal (string (preceding-char)) ")")
          (backward-sexp)))
    (indent-sexp)))

(define-key evil-normal-state-map (kbd "C-M-q") 'my-indent-sexp)
(define-key evil-insert-state-map (kbd "C-M-q") 'my-indent-sexp)
(define-key evil-visual-state-map (kbd "C-M-q") 'my-indent-sexp)
(require 'redshank-loader)

(eval-after-load "redshank-loader"
   `(redshank-setup '(lisp-mode-hook
                    slime-repl-mode-hook) t))

;(require 'haskell-mode)
;(require 'lua-mode)
;(require 'sclang
(require 'flymake)
(require 'csharp-mode)
;; (autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
;; (setq auto-mode-alist
;;       (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))o
;; Basic code required for C# mode
(autoload 'csharp-mode "csharp-mode" "Major mode for editing C# code." t)
(setq auto-mode-alist  (append '(("\\.cs$" . csharp-mode)) auto-mode-alist))

;; Custom code to use a default compiler string for all C# files
(defvar my-csharp-default-compiler nil)
(setq my-csharp-default-compiler "mono @@FILE@@")

(defun my-csharp-get-value-from-comments (marker-string line-limit)
  my-csharp-default-compiler)

(defun my-csharp-mode-fn ()
  "my function that runs when csharp-mode is initialized for a buffer."
  (turn-on-font-lock)
  (turn-on-auto-revert-mode) ;; helpful when also using Visual Studio
  (setq indent-tabs-mode nil) ;; tabs are evil
  (flymake-mode 1)
  (yas/minor-mode-on)
  (setq default-tab-width 4)
  (require 'rfringe)  ;; handy for flymake
  (require 'flymake-cursor) ;; also handy for flymake
  )
(add-hook  'csharp-mode-hook 'my-csharp-mode-fn t)

;; (add-hook 'csharp-mode-hook (lambda ()
;;                               (if my-csharp-default-compiler
;;                                   (progn
;;                                     (fset 'orig-csharp-get-value-from-comments
;;                                           (symbol-function 'csharp-get-value-from-comments))
;;                                     (fset 'csharp-get-value-from-comments
;;                                           (symbol-function 'my-csharp-get-value-from-comments))))
;;                               (flymake-mode)))


(require 'markdown-mode)

(require 'monky)

;; Available only on mercurial versions 1.9 or higher
(setq monky-process-type 'cmdserver)

(require 'magit)

(require 'autopair)
(autopair-global-mode) ;; enable autopair in all buffers

(setq auto-mode-alist (cons '("wscript" . python-mode) auto-mode-alist))
(setq c-default-style (quote ((java-mode . "java")
                              (awk-mode . "awk")
                              (other . "linux")
                              )))

(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(auto-image-file-mode t)
 '(auto-save-file-name-transforms (quote ((".*" "~/.emacs.d/autosaves/\\1" t))))
 '(backup-directory-alist (quote ((".*" . "~/.emacs.d/backups/"))))
 '(backward-delete-char-untabify-method nil)
 '(blink-cursor-mode nil)
 '(compile-command "waf build")
 '(evil-cross-lines t)
 '(evil-want-C-u-scroll t)
 '(follow-auto t)
 ;'(global-whitespace-mode t)
 '(ido-create-new-buffer (quote always))
 '(ido-enable-flex-matching t)
 '(ido-enable-prefix t)
 '(ido-enter-matching-directory (quote first))
 '(ido-everywhere t)
 '(ido-mode (quote file) nil (ido))
 '(image-dired-append-when-browsing t)
 '(indent-tabs-mode nil)
 '(inhibit-startup-screen t)
 '(org-agenda-files (quote ("~/Documents/todo.txt")))
 '(python-python-command "python2")
 '(save-place t nil (saveplace))
 '(show-trailing-whitespace t)
 '(tab-always-indent (quote complete))
 '(x-select-enable-clipboard t)
 '(yas/global-mode t nil (yasnippet))
 '(yas/snippet-dirs (quote ("~/.emacs.d/snippets")) nil (yasnippet)))

(setq whitespace-style
      (quote (face tabs spaces space-before-tab indentation
      space-after-tab space-mark tab-mark)))

(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(whitespace-empty ((t (:background "grey5" :foreground "grey5"))))
 '(whitespace-hspace ((t (:foreground "darkgray"))))
 '(whitespace-indentation ((t (:foreground "grey10"))))
 '(whitespace-line ((t (:foreground "violet"))))
 '(whitespace-space ((t (:foreground "grey10"))))
 '(whitespace-space-after-tab ((t (:foreground "grey10"))))
 '(whitespace-space-before-tab ((t (:foreground "grey10"))))
 '(whitespace-tab ((t (:foreground "grey10")))))

(add-hook 'slime-repl-mode-hook
          '(lambda ()
             (autopair-mode -1)
             (whitespace-mode f)
             (electric-pair-mode -1)))

(when (load "slime-autoloads" t)
  (setq slime-auto-connect 'always)
  (slime-setup '(slime-fancy slime-asdf inferior-slime)))


(defun all-lisp-mode-hook ()
  (setq indent-tabs-mode nil)
  (setq evil-word "[:word:]_-"))

(add-hook 'emacs-lisp-mode-hook 'all-lisp-mode-hook)

(add-hook 'lisp-mode-hook 'all-lisp-mode-hook)

(add-hook 'python-mode-hook
          '(lambda ()
             (setq indent-tabs-mode nil)
             (setq evil-shift-width 4)))

(defun std-indent-mode ()
  (interactive)
  (setq c-basic-offset 4)
  (c-set-offset 'case-label '+)
  (setq tab-width 4)
  (setq standard-indent 4)
  (setq tab-stop-list (quote (4 8 12 16 20 24 28)))
  (setq evil-shift-width 4))

(defun custom-indent-mode ()
  (interactive)
  (c-set-offset 'case-label '+)
  (setq c-basic-offset 2)
  (setq tab-width 2)
  (setq standard-indent 2)
  (setq tab-stop-list (quote (2 4 6 8 10 12 14 16 18 20 22 24 26 28 30)))
  (setq evil-shift-width 2))

;(add-hook 'c-mode-common-hook 'std-indent-mode)
(defun my-c-mode-common-hook ()
  (setq c-basic-offset 4)
  (c-set-offset 'substatement-open 0))
(add-hook 'c-mode-common-hook 'my-c-mode-common-hook)
(add-hook 'lisp-mode-hook 'custom-indent-mode)

(tool-bar-mode -1)
(unless (display-graphic-p)
  (menu-bar-mode -1))

(setf indent-line-function 'insert-tab)

(require 'whitespace)

(setq frame-title-format '(buffer-file-name "%f" ("%b")))

(require 'smart-tabs-mode)

(autoload 'smart-tabs-mode "smart-tabs-mode"
  "Intelligently indent with tabs, align with spaces!")
(autoload 'smart-tabs-mode-enable "smart-tabs-mode")
(autoload 'smart-tabs-advice "smart-tabs-mode")

(add-hook 'c-mode-hook 'smart-tabs-mode-enable)
(add-hook 'javascript-mode-hook 'smart-tabs-mode-enable)
(smart-tabs-advice c-indent-line c-basic-offset)
(smart-tabs-advice c-indent-region c-basic-offset)

(evil-define-command repeat-no-move (&optional count)
  :repeat ignore
  (interactive)
  (evil-repeat count t))

(define-key evil-normal-state-map (kbd ".") 'repeat-no-move)

(evil-define-command repeat-and-next-line (&optional count)
  :repeat ignore
  (interactive)
  (repeat-no-move count)
  (next-line))

(define-key evil-normal-state-map (kbd ",") 'repeat-and-next-line)
(defvar hexcolour-keywords
  '(("#[[:xdigit:]]\\{6\\}"
     (0 (put-text-property (match-beginning 0)
                           (match-end 0)
                           'face (list :background
                                       (match-string-no-properties 0)))))))

(defun hexcolour-add-to-font-lock ()
  (font-lock-add-keywords nil hexcolour-keywords))

(when (display-graphic-p)
  (add-hook 'emacs-lisp-mode-hook 'hexcolour-add-to-font-lock))

(defun setup-compile-command ()
  (define-key evil-normal-state-map (kbd "C-c k") 'compile)
  (define-key evil-normal-state-map (kbd "C-c C-k") 'compile))

(add-hook 'c-mode-common-hook 'setup-compile-command)

;; Javascript escape
(setq js-indent-level 2)

;;; Hide menu bar
(global-set-key (kbd "<f12>") 'menu-bar-mode)
(menu-bar-mode 0)

;; Disabling escape
(global-set-key (kbd "<escape>") 'keyboard-quit)

; scrollbar on right()
(set-scroll-bar-mode 'right)



;; Scheme
;(add-hook 'slime-load-hook (lambda () (require 'slime-scheme)))
(setf scheme-program-name "stk" )

;; Turn on warn highlighting for characters outside of the 'width' char limit
(defun font-lock-width-keyword (width)
  "Return a font-lock style keyword for a string beyond width WIDTH
   that uses 'font-lock-warning-face'."
  `((,(format "^%s\\(.+\\)" (make-string width ?.))
     (1 font-lock-warning-face t))))

(font-lock-add-keywords 'csharp-mode (font-lock-width-keyword 80))

(defun iwb ()
  "indent whole buffer"
  (interactive)
  (delete-trailing-whitespace)
  (indent-region (point-min) (point-max) nil)
  (untabify (point-min) (point-max)))



;; BSD style brace placement
(setq c-default-style "bsd"
  c-basic-offset 4)

;; Indenting
(setq tab-width 4)
(setq-default indent-tabs-mode nil)
(setq-default tab-width 4)
(setq indent-line-function 'insert-tab)