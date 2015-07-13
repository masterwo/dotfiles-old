(put 'narrow-to-region 'disabled nil)
(custom-set-variables
 ;; custom-set-variables was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 '(custom-enabled-themes (quote (wombat)))
 '(custom-safe-themes (quote ("08851585c86abcf44bb1232bced2ae13bc9f6323aeda71adfa3791d6e7fea2b6" default)))
 '(menu-bar-mode nil)
 '(scroll-bar-mode nil)
 '(tool-bar-mode nil))
(custom-set-faces
 ;; custom-set-faces was added by Custom.
 ;; If you edit it by hand, you could mess it up, so be careful.
 ;; Your init file should contain only one such instance.
 ;; If there is more than one, they won't work right.
 )


(require 'package) ;; You might already have this line
(add-to-list 'package-archives
             '("melpa" . "http://melpa.org/packages/") t)
(when (< emacs-major-version 24)
  ;; For important compatibility libraries like cl-lib
  (add-to-list 'package-archives '("gnu" . "http://elpa.gnu.org/packages/")))
(package-initialize) ;; You might already have this line


(require 'projectile)
(projectile-global-mode)

(require 'auto-complete-config)
(ac-config-default)

(require 'erefactor)
(add-hook 'emacs-lisp-mode-hook
	  (lambda ()
	    (define-key emacs-lisp-mode-map "\C-c\C-v" erefactor-map)))

(add-hook 'emacs-lisp-mode-hook 'erefactor-lazy-highlight-turn-on)
(add-hook 'lisp-interaction-mode-hook 'erefactor-lazy-highlight-turn-on)

;; Initiate vim-like keybindings on startup
(require 'evil)
(evil-mode 1)

(require 'molokai-theme)

;; Does aparently not work well with other themes like Molokai for example ;(
(require 'powerline)
(powerline-vim-theme)


(require 'pretty-mode)
(autoload 'js3-mode "js3" nil t)
(add-to-list 'auto-mode-alist '("\\.js$" . js3-mode))
;; (add-hook 'js3-mode-hook
;; 	  (lambda ()
;; 	    (push '("function" . ?ƒ) prettify-symbols-alist)
;; 	    (prettify-symbols-mode)))

(require 'recentf)
(recentf-mode 1)
(setq recentf-max-menu-items 25)
(global-set-key "\C-x\ \C-r" 'recentf-open-files)
(put 'scroll-left 'disabled nil)
