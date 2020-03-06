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


;; Get the dotfile directory
(setq dotfiles-dir (file-name-directory
                    (or (buffer-file-name) (file-chase-links load-file-name))))

(add-to-list 'load-path (concat dotfiles-dir "modules"))


;; C/C++ configurations
(require 'c-common)
(require 'fira-code-mode)



;; add rust mode for Rust programming
(add-to-list 'load-path "/path/to/rust-mode/")
(autoload 'rust-mode "rust-mode" nil t)
(add-to-list 'auto-mode-alist '("\\.rs\\'" . rust-mode))


(menu-bar-mode -1)
(tool-bar-mode -1)
(scroll-bar-mode -1)

(require 'doom-modeline)
(doom-modeline-mode 1)

;; Hooks
(add-hook 'objc-mode-hook 'irony-mode)

(add-hook 'irony-mode-hook 'irony-cdb-autosetup-compile-options)


(add-hook 'prog-mode-hook 'linum-mode)

;; (add-hook 'prog-mode-hook 'treemacs)

;; Remove blinking cursor
(blink-cursor-mode 0)



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
 '(custom-enabled-themes (quote (gruvbox-dark-soft)))
 '(custom-safe-themes
   (quote
    ("939ea070fb0141cd035608b2baabc4bd50d8ecc86af8528df9d41f4d83664c6a" "8e797edd9fa9afec181efbfeeebf96aeafbd11b69c4c85fa229bb5b9f7f7e66c" "8f97d5ec8a774485296e366fdde6ff5589cf9e319a584b845b6f7fa788c9fa9a" "a22f40b63f9bc0a69ebc8ba4fbc6b452a4e3f84b80590ba0a92b4ff599e53ad0" "585942bb24cab2d4b2f74977ac3ba6ddbd888e3776b9d2f993c5704aa8bb4739" "1436d643b98844555d56c59c74004eb158dc85fc55d2e7205f8d9b8c860e177f" default)))
 '(doom-modeline-bar-width 4)
 '(ecb-options-version "2.40")
 '(global-magit-file-mode nil)
 '(inhibit-startup-screen t)
 '(irony-additional-clang-options (quote ("-Wall -Wextra")))
 '(package-selected-packages
   (quote
    (flycheck-clang-analyzer z3-mode graphviz-dot-mode haskell-mode dot-mode all-the-icons-gnus doom-modeline flycheck-rust gruvbox-theme treemacs yasnippet-classic-snippets yasnippet-snippets yasnippet markdown-preview-mode markdown-mode+ docker cuda-mode irony-eldoc ## mutt-mode rust-mode company-auctex auctex column-enforce-mode rainbow-delimiters emr markdown-mode csharp-mode haskell-emacs flymd google-c-style glsl-mode flycheck-irony company-irony-c-headers company-c-headers company-irony linum-relative arduino-mode 2048-game zop-to-char zenburn-theme which-key volatile-highlights undo-tree smartrep smartparens smart-mode-line projectile ov operate-on-number move-text magit imenu-anywhere guru-mode grizzl god-mode gitignore-mode gitconfig-mode git-timemachine gist flycheck expand-region editorconfig easy-kill discover-my-major diminish diff-hl crux browse-kill-ring beacon anzu ace-window)))
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
 '(send-mail-function (quote smtpmail-send-it))
 '(treemacs-git-mode (quote extended)))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(magit-branch-current ((t (:inherit magit-branch-local :underline "#83a598")))))



