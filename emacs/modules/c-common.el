;; Hooks
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)

(use-package company
  :defer t
  :ensure t
  :diminish company-mode
  :hook (after-init . global-company-mode)
  :config
  (setq company-idle-delay 0.05)
  (setq company-tooltip-align-annotations t))

;; company-dabbrev-code completes in code
;; company-dabbrev completes in comments/strings
(use-package company-dabbrev
  :defer t
  :ensure company
  :config
  (setq company-dabbrev-downcase nil)
  (setq company-dabbrev-ignore-case t))
(use-package company-dabbrev-code
  :defer t
  :ensure company
  :config
  ;; (setq company-dabbrev-code-modes t)
  (setq company-dabbrev-code-everywhere t))

(use-package company-clang
  :defer t
  :ensure company
  :config
  (add-hook 'c++-mode-hook
            (lambda () (setq company-clang-arguments '("")))
	    (lambda () (setq company-clang-arguments '("-std=c++17")))))

(use-package irony
  :diminish irony-mode
  :config
  (setq irony-additional-clang-options '("-std=c++11"))
  (setq irony-additional-clang-options
      (append '("-I" "/usr/local/Cellar/llvm/7.0.0/include/c++/v1") irony-additional-clang-options))
  (setq irony-additional-clang-options
	(append '("-I" "/Library/Developer/CommandLineTools/SDKs/MacOSX.sdk/usr/include") irony-additional-clang-options))
  (setq irony-additional-clang-options
	(append '("-std=c++17") irony-additional-clang-options))
  ;;(push 'company-irony company-backends)
  (add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)
  (add-hook 'c-mode-hook 'irony-mode)
  (add-hook 'c++-mode-hook 'irony-mode))



  
(use-package flycheck
  :defer t
  :ensure t
  :hook (after-init . global-flycheck-mode)
  :config
  (add-hook 'c++-mode-hook
  (lambda () (setq flycheck-clang-language-standard "c++17"))))

(use-package flycheck-irony
  :defer t
  :if (locate-library "flycheck")
  :config (flycheck-irony-setup))


(eval-after-load 'company
  '(add-to-list 'company-backends 'company-irony))

;; Integrate Irony with Flycheck
(eval-after-load 'flycheck
  '(add-hook 'flycheck-mode-hook #'flycheck-irony-setup))

(eval-after-load 'flycheck
  '(add-to-list 'flycheck-checkers 'c/c++-clang))


;; projectile configuration
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(define-key prog-mode-map (kbd "M-RET") 'emr-show-refactor-menu)


(defun c-mode-style-hook ()
  ;; Set the default style
  (setq c-default-ostyle "linux"
        c-basic-offset 8))
(add-hook 'c-mode-common-hook 'c-mode-style-hook)
(add-hook 'c-mode-common-hook 'rainbow-delimiters-mode)
(add-hook 'c-mode-common-hook 'column-enforce-mode)


(provide 'c-common)
