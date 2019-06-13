;;; init.el --- Prelude's configuration entry point.
;;
;; Copyright (c) 2011-2017 Bozhidar Batsov
;;
;; Author: Bozhidar Batsov <bozhidar@batsov.com>
;; URL: http://batsov.com/prelude
;; Version: 1.0.0
;; Keywords: convenience

;; This file is not part of GNU Emacs.

;;; Commentary:

;; This file simply sets up the default load path and requires
;; the various modules defined within Emacs Prelude.

;;; License:

;; This program is free software; you can redistribute it and/or
;; modify it under the terms of the GNU General Public License
;; as published by the Free Software Foundation; either version 3
;; of the License, or (at your option) any later version.
;;
;; This program is distributed in the hope that it will be useful,
;; but WITHOUT ANY WARRANTY; without even the implied warranty of
;; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;; GNU General Public License for more details.
;;
;; You should have received a copy of the GNU General Public License
;; along with GNU Emacs; see the file COPYING.  If not, write to the
;; Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor,
;; Boston, MA 02110-1301, USA.

;;; Code:

;; Added by Package.el.  This must come before configurations of
;; installed packages.  Don't delete this line.  If you don't want it,
;; just comment it out by adding a semicolon to the start of the line.
;; You may delete these explanatory comments.
;(package-initialize)

(defvar current-user
  (getenv
   (if (equal system-type 'windows-nt) "USERNAME" "USER")))

;(message "Prelude is powering up... Be patient, Master %s!" current-user)

;(when (version< emacs-version "24.4")
;  (error "Prelude requires at least GNU Emacs 24.4, but you're running %s" emacs-version))

;; Always load newest byte code
(setq load-prefer-newer t)

;(defvar prelude-dir (file-name-directory load-file-name)
;  "The root dir of the Emacs Prelude distribution.")
;(defvar prelude-core-dir (expand-file-name "core" prelude-dir)
;  "The home of Prelude's core functionality.")
;(defvar prelude-modules-dir (expand-file-name  "modules" prelude-dir)
;  "This directory houses all of the built-in Prelude modules.")
;(defvar prelude-personal-dir (expand-file-name "personal" prelude-dir)
;  "This directory is for your personal configuration.

;Users of Emacs Prelude are encouraged to keep their personal configuration
;changes in this directory.  All Emacs Lisp files there are loaded automatically
;by Prelude.")
;(defvar prelude-personal-preload-dir (expand-file-name "preload" prelude-personal-dir)
;  "This directory is for your personal configuration, that you want loaded before Prelude.")
;(defvar prelude-vendor-dir (expand-file-name "vendor" prelude-dir)
;  "This directory houses packages that are not yet available in ELPA (or MELPA).")
;(defvar prelude-savefile-dir (expand-file-name "savefile" prelude-dir)
;  "This folder stores all the automatically generated save/history-files.")
;(defvar prelude-modules-file (expand-file-name "prelude-modules.el" prelude-dir)
;  "This files contains a list of modules that will be loaded by Prelude.")

;(unless (file-exists-p prelude-savefile-dir)
;  (make-directory prelude-savefile-dir))

;(defun prelude-add-subfolders-to-load-path (parent-dir)
; "Add all level PARENT-DIR subdirs to the `load-path'."
; (dolist (f (directory-files parent-dir))
;   (let ((name (expand-file-name f parent-dir)))
;     (when (and (file-directory-p name)
;                (not (string-prefix-p "." f)))
;       (add-to-list 'load-path name)
;       (prelude-add-subfolders-to-load-path name)))))

;; add Prelude's directories to Emacs's `load-path'
;(add-to-list 'load-path prelude-core-dir)
;(add-to-list 'load-path prelude-modules-dir)
;(add-to-list 'load-path prelude-vendor-dir)
;(prelude-add-subfolders-to-load-path prelude-vendor-dir)

;; reduce the frequency of garbage collection by making it happen on
;; each 50MB of allocated data (the default is on every 0.76MB)
(setq gc-cons-threshold 50000000)

;; warn when opening files bigger than 100MB
(setq large-file-warning-threshold 100000000)

;; preload the personal settings from `prelude-personal-preload-dir'
;(when (file-exists-p prelude-personal-preload-dir)
;  (message "Loading personal configuration files in %s..." prelude-personal-preload-dir)
;  (mapc 'load (directory-files prelude-personal-preload-dir 't "^[^#\.].*el$")))

;(message "Loading Prelude's core...")

;; the core stuff
;(require 'prelude-packages)
;(require 'prelude-custom)  ;; Needs to be loaded before core, editor and ui
;(require 'prelude-ui)
;(require 'prelude-core)
;(require 'prelude-mode)
;(require 'prelude-editor)
;(require 'prelude-global-keybindings)

;; OSX specific settings
;(when (eq system-type 'darwin)
;  (require 'prelude-osx))

;(message "Loading Prelude's modules...")

;; the modules
;(if (file-exists-p prelude-modules-file)
;    (load prelude-modules-file)
;  (message "Missing modules file %s" prelude-modules-file)
;  (message "You can get started by copying the bundled example file"))

;; config changes made through the customize UI will be store here
;(setq custom-file (expand-file-name "custom.el" prelude-personal-dir))

;; load the personal settings (this includes `custom-file')
;(when (file-exists-p prelude-personal-dir)
;  (message "Loading personal configuration files in %s..." prelude-personal-dir)
;  (mapc 'load (directory-files prelude-personal-dir 't "^[^#\.].*el$")))

;(message "Prelude is ready to do thy bidding, Master %s!" current-user)

;(prelude-eval-after-init
;; greet the use with some useful tip
;(run-at-time 5 nil 'prelude-tip-of-the-day))


(require 'package)
(let* ((no-ssl (and (memq system-type '(windows-nt ms-dos))
                    (not (gnutls-available-p))))
       (proto (if no-ssl "http" "https")))
  (when no-ssl
    (warn "\
Your version of Emacs does not support SSL connections,
which is unsafe because it allows man-in-the-middle attacks.
There are two things you can do about this warning:
1. Install an Emacs version that does support SSL and be safe.
2. Remove this warning from your init file so you won't see it again."))
  ;; Comment/uncomment these two lines to enable/disable MELPA and MELPA Stable as desired
  (add-to-list 'package-archives (cons "melpa" (concat proto "://melpa.org/packages/")) t)
  ;;(add-to-list 'package-archives (cons "melpa-stable" (concat proto "://stable.melpa.org/packages/")) t)
  (when (< emacs-major-version 24)
    ;; For important compatibility libraries like cl-lib
    (add-to-list 'package-archives (cons "gnu" (concat proto "://elpa.gnu.org/packages/")))))
(package-initialize)

;; add tuareg mode for OCaml programming
;;(load "/home/falvyu/.opam/system/share/emacs/site-lisp/tuareg-site-file")


;; add rust mode for Rust programming
(add-to-list 'load-path "/path/to/rust-mode/")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))


(menu-bar-mode -1)
(tool-bar-mode -1)

;; Hooks
(add-hook 'c++-mode-hook 'irony-mode)
(add-hook 'c-mode-hook 'irony-mode)
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)




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


;; projectile configuration
(projectile-mode +1)
(define-key projectile-mode-map (kbd "s-p") 'projectile-command-map)
(define-key projectile-mode-map (kbd "C-c p") 'projectile-command-map)

(define-key prog-mode-map (kbd "M-RET") 'emr-show-refactor-menu)

(add-hook 'prog-mode-hook 'linum-mode)
(blink-cursor-mode 0)

(defun c-mode-style-hook ()
  ;; Set the default style
  (setq c-default-ostyle "linux"
        c-basic-offset 8))
(add-hook 'c-mode-common-hook 'c-mode-style-hook)
(add-hook 'c-mode-common-hook 'rainbow-delimiters-mode)
(add-hook 'c-mode-common-hook 'column-enforce-mode)


;; Org mode
(add-hook 'org-mode-hook '(lambda () (setq fill-column 80)))
(add-hook 'org-mode-hook 'turn-on-auto-fill)

;; Promela mode
;;(add-to-list 'load-path "~/.emacs.d/promela") ; location where you cloned promela-mode
;;(require 'promela-mode)
;;(add-to-list 'auto-mode-alist '("\\.pml\\'" . promela-mode))

;;; init.el ends here
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (tango-dark)))
 '(ecb-options-version "2.40")
 '(inhibit-startup-screen t)
 '(irony-additional-clang-options (quote ("-Wall -Wextra")))
 '(package-selected-packages
   (quote
    (irony-eldoc ## mutt-mode rust-mode company-auctex auctex column-enforce-mode rainbow-delimiters emr markdown-mode csharp-mode haskell-emacs flymd google-c-style glsl-mode flycheck-irony company-irony-c-headers company-c-headers company-irony linum-relative arduino-mode 2048-game irony zop-to-char zenburn-theme which-key volatile-highlights undo-tree smartrep smartparens smart-mode-line projectile ov operate-on-number move-text magit imenu-anywhere guru-mode grizzl god-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region editorconfig easy-kill discover-my-major diminish diff-hl crux browse-kill-ring beacon anzu ace-window)))
 '(safe-local-variable-values
   (quote
    ((company-clang-arguments . "-iinclude")
     (eval let
	   ((clang-args
	     (quote
	      ("-iinclude" "-icpu"))))
	   (setq-local company-clang-arguments clang-args flycheck-clang-args clang-args))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-proje1ct-root)
		    "headers")
	    (concat "-I"
		    (projectile-project-root)
		    "source/mon")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    "include")
	    (concat "-I"
		    (projectile-project-root)
		    "source/mon")))
     (eval setq flycheck-clang-include-path
	   (list "/home/falvyu/linux/linux-4.19.24/include/"))
     (eval setq flycheck-clang-include-path
	   (list "/home/falvyu/linux/linux-4.19.24/include/" "/home/falvyu/linux/linux-4.19.24/arch/x86/include/"))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat
	     ("/home/falvyu/linux/linux-4.19.24/include/")
	     ("/home/falvyu/linux/linux-4.19.24/arch/x86/include/"))))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat "/home/falvyu/linux/linux-4.19.24/include/" "/home/falvyu/linux/linux-4.19.24/arch/x86/include")))
     (eval setq flycheck-clang-include-path
	   (list
	    (("/home/falvyu/linux/linux-4.19.24/include/")
	     ("/home/falvyu/linux/linux-4.19.24/arch/x86/include"))))
     (eval setq flycheck-clang-include-path
	   (list
	    ("/home/falvyu/linux/linux-4.19.24/include/" "/home/falvyu/linux/linux-4.19.24/arch/x86/include")))
     (eval setq flycheck-clang-include-path
	   (list
	    ("/home/falvyu/linux/linux-4.19.24/include/")
	    ("/home/falvyu/linux/linux-4.19.24/arch/x86/include")))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat "/linux/v4.19.24/source/arch/x86/include:" "/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq company-clang-arguments
	   (list
	    (concat " -I/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    " -I/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    ":/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat "/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I" "/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat
	     (projectile-project-root)
	     "/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    "/home/falvyu/linux/linux-4.19.24/include/")))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat
	     (projectile-project-root)
	     "/home/falvyu/linux/linux-4.19.24/include")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    "/home/falvyu/linux/linux-4.19.24/include")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    "~/linux/linux-4.19.24/include")))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat
	     (projectile-project-root)
	     "~/linux/linux-4.19.24/include")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    ".")))
     (eval setq flycheck-clang-include-path
	   (list
	    (concat
	     (projectile-project-root)
	     "include")))
     (eval setq company-clang-arguments
	   (list
	    (concat "-I"
		    (projectile-project-root)
		    "headers")
	    (concat "-I"
		    (projectile-project-root)
		    "source/mon"))))))
 '(send-mail-function (quote smtpmail-send-it)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )



