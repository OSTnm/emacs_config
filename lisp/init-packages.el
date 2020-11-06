;; load theme
(require 'monokai-theme)
(load-theme 'monokai t)

;; window-numbering
(require 'window-numbering)
(window-numbering-mode t)

;; show parent mode
(show-paren-mode t)

;; smart parent
(require 'smartparens)
(smartparens-global-mode t)
(sp-local-pair 'emacs-lisp-mode "'" nil :actions nil)
(sp-local-pair 'lisp-interaction-mode "'" nil :actions nil)
(sp-local-pair 'emacs-lisp-mode "`" nil :actions nil)
(sp-local-pair 'lisp-interaction-mode "`" nil :actions nil)

;; undo tree
(require 'undo-tree)
(global-undo-tree-mode)

;; yasnippet
(yas-global-mode t)

;; hugry delete mode
(global-hungry-delete-mode t)

;; magit
(require 'magit)

;; company
(global-company-mode t)
(setq company-show-numbers t)

;; flycheck
(require 'flycheck)
(global-flycheck-mode)

;; helm mode
(require 'helm-config)
(helm-mode t)

;; helm-gtags
(require 'helm-gtags)
(add-hook 'c-mode-hook 'helm-gtags-mode)
(add-hook 'c++-mode-hook 'helm-gtags-mode)
(add-hook 'asm-mode-hook 'helm-gtags-mode)
(setq helm-gtags-auto-update t
      helm-gtags-use-input-at-cursor t
      helm-gtags-pulse-at-cursor t)

;; auto load init file
(global-auto-revert-mode t)

;; lsp mode
(add-hook 'c-mode-hook 'lsp)
(add-hook 'cpp-mode-hook 'lsp)

(setq gc-cons-threshold (* 100 1024 1024)
      read-process-output-max (* 1024 1024)
      treemacs-space-between-root-nodes nil
      company-idle-delay 0.0
      company-minimum-prefix-length 1
      lsp-idle-delay 0.1 ;; clangd is fast
      ;; be more ide-ish
      lsp-headerline-breadcrumb-enable t)

(with-eval-after-load 'lsp-mode
  (add-hook 'lsp-mode-hook #'lsp-enable-which-key-integration)
  (require 'dap-cpptools)
  (yas-global-mode))

(defun my-toggle-web-indent ()
  (interactive)
  ;; web development
  (if (or (eq major-mode 'js-mode) (eq major-mode 'js2-mode))
      (progn
	(setq js-indent-level (if (= js-indent-level 2) 4 2))
	(setq js2-basic-offset (if (= js2-basic-offset 2) 4 2))))

  (if (eq major-mode 'web-mode)
      (progn (setq web-mode-markup-indent-offset (if (= web-mode-markup-indent-offset 2) 4 2))
	     (setq web-mode-css-indent-offset (if (= web-mode-css-indent-offset 2) 4 2))
	     (setq web-mode-code-indent-offset (if (= web-mode-code-indent-offset 2) 4 2))))
  (if (eq major-mode 'css-mode)
      (setq css-indent-offset (if (= css-indent-offset 2) 4 2)))

  (setq indent-tabs-mode nil))

(global-set-key (kbd "C-c t i") 'my-toggle-web-indent)

;; column enforce mode
(require 'column-enforce-mode)
(add-hook 'c-mode-hook 'column-enforce-mode)

;; rainbow-delimiters-mode
(require 'rainbow-delimiters)
(add-hook 'c-mode-hook 'rainbow-delimiters-mode)
(add-hook 'java-mode-hook 'rainbow-delimiters-mode)

(defun ostnm/rainbow-identifiers-predefined-choose-face (hash)
  "Use HASH to choose one of the `rainbow-identifiers-identifier-N' faces."
  (intern-soft "rainbow-identifiers-identifier-9"))
;; (setq rainbow-identifiers-predefined-choose-face ostnm/rainbow-identifiers-predefined-choose-face)

;; goto-line-preview
(require 'goto-line-preview)
(global-set-key [remap goto-line] 'goto-line-preview)

;; move-text
(require 'move-text)
(move-text-default-bindings)

;; org-download
(require 'org-download)
;; Drag-and-drop to `dired`
(add-hook 'dired-mode-hook 'org-download-enable)

(defvar cmd nil nil)
(defvar cflow-buf nil nil)
(defvar cflow-buf-name nil nil)

(require 'cflow-mode)
(defun ostnm/cflow-function (function-name)
  "Get call graph of inputed function. "
  (interactive "sFunction name:\n")
  (setq cmd (format "cflow  -b --main=%s %s" function-name buffer-file-name))
  (setq cflow-buf-name (format "**cflow-%s:%s**"
                               (file-name-nondirectory buffer-file-name)
                               function-name))
  (setq cflow-buf (get-buffer-create cflow-buf-name))
  (set-buffer cflow-buf)
  (setq buffer-read-only nil)
  (erase-buffer)
  (insert (shell-command-to-string cmd))
  (pop-to-buffer cflow-buf)
  (goto-char (point-min))
  (cflow-mode)
  )

(defun ostnm/bing-dict-ee (word)
  "Get english explaination of word. "
  (interactive "sWord:\n")
  (insert (shell-command-to-string (concat "LC_CTYPE=UTF-8 translate.py " word))))

;; This is an Emacs package that creates graphviz directed graphs from
;; the headings of an org file
;; mind map
(require 'ox)
(require 'ox-org)

(provide 'init-packages)
