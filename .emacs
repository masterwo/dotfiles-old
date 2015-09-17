
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(font-use-system-font t)
 '(initial-frame-alist (quote ((fullscreen . maximized))))
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )

;; List recent files (C-x C-r)
(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(put 'scroll-left 'disabled nil)



;; =================================================================
;; To add more sources to the package managers and to have a function
;; that will load packages and install them if missing (useful if you
;; move your config between computers) put this on your config file:
;; =================================================================
;; packages
(setq package-archives '(("gnu" . "http://elpa.gnu.org/packages/")
                         ("org" . "http://orgmode.org/elpa/")
                        ("marmalade" . "http://marmalade-repo.org/packages/")
                         ("melpa-stable" . "http://melpa-stable.milkbox.net/packages/")))
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)

;; eieio is needs to be included before (package-initialize) for
;; helm-ls-git to work
(require 'eieio) ;; TODO Only necessary when emacs version is < 24.4

(package-initialize)

;; function for downloading missing packages.
(defun require-package (package)
  (setq-default highlight-tabs t)
  "Install given PACKAGE."
  (unless (package-installed-p package)
    (unless (assoc package package-archive-contents)
      (package-refresh-contents))
    (package-install package)))


;; =================================================================
;; Color-Theme
;; =================================================================
(require-package 'molokai-theme)
(require 'molokai-theme)

;; =================================================================
;; Emmet-mode (for HTML/XML coding)
;; =================================================================
(require-package 'emmet-mode)
(add-hook 'sgml-mode-hook 'emmet-mode) ;; Auto-start on any markup modes
(add-hook 'css-mode-hook  'emmet-mode) ;; enable Emmet's css abbreviation.

;; =================================================================
;; Evil-mode: (settings related to evil)
;; =================================================================
(require-package 'evil)
(evil-mode 1)

;; Evil-leader
;; (setq evil-leader/in-all-states 1)
;; (global-evil-leader-mode)
;; (evil-leader/set-leader ",")

;; TODO: install evil-tabs-mode
;;(global-evil-tabs-mode t)

;; "after" macro definition
(if (fboundp 'with-eval-after-load)
    (defmacro after (feature &rest; body)
      "After FEATURE is loaded, evaluate BODY."
      (declare (indent defun))
      `(with-eval-after-load ,feature ,@body))
  (defmacro after (feature &rest; body)
    "After FEATURE is loaded, evaluate BODY."
    (declare (indent defun))
    `(eval-after-load ,feature
       '(progn ,@body))))))

;; Vim-like search highlighting
(require-package 'evil-search-highlight-persist)
(global-evil-search-highlight-persist t)
;; To map a shortcut (leader-space) to clear the highlights I have:
;;(evil-leader/set-key "SPC" 'evil-search-highlight-persist-remove-all)

;; Helm: Unite/CtrlP style fuzzy file/buffer/anything searcher on steroids
(require-package 'helm)
(helm-mode 1)
(define-key evil-normal-state-map " " 'helm-mini)


;; helm settings (TAB in helm window for actions over selected items,
;; C-SPC to select items)
;; (require 'helm-config)
;; (require 'helm-misc)
;; (require-package 'helm-projectile)
;; (require 'helm-locate)
;; (setq helm-quick-update t)
;; (setq helm-bookmark-show-location t)
;; (setq helm-buffers-fuzzy-matching t)
;; 
;; (after 'projectile
  ;; (package 'helm-projectile))
;; (global-set-key (kbd "M-x") 'helm-M-x)
;; 
;; (defun helm-my-buffers ()
  ;; (interactive)
  ;; (let ((helm-ff-transformer-show-only-basename nil))
  ;; (helm-other-buffer '(helm-c-source-buffers-list
                       ;; helm-c-source-elscreen
                       ;; helm-c-source-projectile-files-list
                       ;; helm-c-source-ctags
                       ;; helm-c-source-recentf
                       ;; helm-c-source-locate)
                     ;; "*helm-my-buffers*")))

;; Change cursor color depending on mode
(setq evil-emacs-state-cursor '("red" box))
(setq evil-normal-state-cursor '("green" box))
(setq evil-visual-state-cursor '("orange" box))
(setq evil-insert-state-cursor '("red" bar))
(setq evil-replace-state-cursor '("red" bar))
(setq evil-operator-state-cursor '("red" hollow))

;; Powerline
(require-package 'powerline-evil)
(require-package 'powerline)
(powerline-evil-vim-color-theme)
(display-time-mode t)

;; Smooth Scrolling
(require-package 'smooth-scrolling)
(setq scroll-margin 5
scroll-conservatively 9999
scroll-step 1)

;; Start maximized
 ;; start maximized

;; Scroll-up/down
(define-key evil-normal-state-map (kbd "C-u") (lambda ()
                    (interactive)
                    (evil-scroll-up nil)))
(define-key evil-normal-state-map (kbd "C-d") (lambda ()
                        (interactive)
                        (evil-scroll-down nil)))



(require-package 'helm-ls-git)
(define-key evil-normal-state-map (kbd "C-p") (lambda ()
                        (interactive)
			(helm-ls-git-ls)))

;; =================================================================
;;Sessions (:mksession in Vim)
;; =================================================================

;; Emacs have the commands M-x desktop-save and desktop-read. To have it
;; automatically saved/restored put into the .emacs: (desktop-save-mode
;; 1). If you want to start emacs without auto loading the session (if
;; you configured it), the command is emacs --no-desktop. But Emacs
;; sessions doesn't know about elscreens (which evil-tabs use for
;; creating Vim-like tabs) so if you want to save and restore full
;; sessions including tabs copy these functions into your config file and
;; assign them some shortcut:

;; First define some variables:
;; http://stackoverflow.com/questions/803812/emacs-reopen-buffers-from-last-session-on-startup
(defvar emacs-configuration-directory
    "~/.emacs.d/"
    "The directory where the emacs configuration files are stored.")
(defvar elscreen-tab-configuration-store-filename
    (concat emacs-configuration-directory ".elscreen")
    "The file where the elscreen tab configuration is stored.")

;; Save session including tabs
;; http://stackoverflow.com/questions/22445670/save-and-restore-elscreen-tabs-and-split-frames
(defun session-save ()
    "Store the elscreen tab configuration."
    (interactive)
    (if (desktop-save emacs-configuration-directory)
        (with-temp-file elscreen-tab-configuration-store-filename
            (insert (prin1-to-string (elscreen-display-screen-name-list))))))

;; Load session including tabs
(defun session-load ()
    "Restore the elscreen tab configuration."
    (interactive)
    (if (desktop-read)
        (let ((screens (reverse
                        (read
                         (with-temp-buffer
                          (insert-file-contents elscreen-tab-configuration-store-filename)
                          (buffer-string))))))
            (while screens
                (setq screen (car (car screens)))
                (setq buffers (split-string (cdr (car screens)) ":"))
                (if (eq screen 0)
                    (switch-to-buffer (car buffers))
                    (elscreen-find-and-goto-by-buffer (car buffers) t t))
                (while (cdr buffers)
                    (switch-to-buffer-other-window (car (cdr buffers)))
                    (setq buffers (cdr buffers)))
                (setq screens (cdr screens))))))

;; =================================================================
;; Org-mode
;; =================================================================
(require-package 'org)

;; Start scratch-buffer in org-mode for note-taking
(setq inhibit-splash-screen t
      initial-scratch-message nil
      initial-major-mode 'org-mode)
