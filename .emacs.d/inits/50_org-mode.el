(require 'org-install)
(require 'org-pomodoro)
(add-to-list 'auto-mode-alist '("\\.org\\'" . org-mode))

;; アジェンダ表示の対象ファイル
(setq org-agenda-files '("~/gtd/main.org"))

;; key bindings
(global-set-key "\C-cl" 'org-store-link)
(global-set-key "\C-cc" 'org-capture)
(global-set-key "\C-ca" 'org-agenda)
(global-set-key "\C-cb" 'org-iswitchb)
(global-set-key "\C-c\C-x\C-@" 'org-clock-out)

;; リンクをconkerorで開く
(setq browse-url-browser-function 'browse-url-generic
            browse-url-generic-program "/home/tsu-nera/bin/conkeror")

;; TODO状態
;;(setq org-todo-keywords
;;      '((sequence "TODO(t)" "WAIT(w)" "|" "DONE(d)" "SOMEDAY(s)")))

;; DONEの時刻を記録
(setq org-log-done 'time)


;;; org-clock configuration
(setq org-clock-out-remove-zero-time-clocks t
      org-clock-out-when-done t
      org-clock-modeline-total 'today
      org-clock-persist t
      org-clock-persistence-insinuate)
;;(setq org-clock-clocked-in-display 'both)

;(eval-after-load "org-faces"
;  '(set-face-attribute 'org-mode-line-clock nil
;		       :inherit nil))

;;(setq org-clock-heading-function
;;             (lambda ()
;	       (replace-regexp-in-string
;;		 "\\[\\[.*?\\]\\[\\(.*?\\)\\]\\]" "\\1"
;;		  (nth 4 org-heading-components))))
;;(org-defkey org-agenda-mode-map [(tab)]
;;	    '(lambda () (interactive)
;;	       (org-agenda-goto)
;;	       (with-current-buffer "*Org Agenda*"
;;		 (org-agenda-quit))))
;;

;; NextActionタグを設定
(defvar my-doing-tag "next")
;; nextタグをトグルする
(defun my-toggle-doing-tag ()
  (interactive)
  (when (eq major-mode 'org-mode)
    (save-excursion
      (save-restriction
        (unless (org-at-heading-p)
          (outline-previous-heading))
        (if (string-match (concat ":" my-doing-tag ":") (org-get-tags-string))
            (org-toggle-tag my-doing-tag 'off)
          (org-toggle-tag my-doing-tag 'on))
        (org-reveal)))))
(global-set-key (kbd "<f11>") 'my-toggle-doing-tag)

;; -----------------------------------------------------------------------
;; Function ; 見積り設定
;; ------------------------------------------------------------------------
; Set default column view headings: Task Effort Clock_Summary
(setq org-columns-default-format "%40ITEM(Task) %17Effort(Effort){:} %10CLOCKSUM")
; global Effort estimate values
(setq org-global-properties (quote (("Effort_ALL" . "0:10 0:30 1:00 2:00 3:00 4:00 5:00 6:00 7:00 8:00"))))

;; -----------------------------------------------------------------------
;; Name     : org-capture
;; Function : アイデアをキャプチャーする
;; History  : 2014/02/25
;; Install  : build-in
;; ------------------------------------------------------------------------
(require 'org-capture)
(setq org-capture-templates
      '(
	;;	("t" "Task" entry (file+headline nil "Inbox")
	;;	 "** TODO %?\n %T\n %a\n %i\n")
	;;	("b" "Bug" entry (file+headline nil "Inbox")
	;;	 "** TODO %?   :bug:\n  %T\n %a\n %i\n")
	;;	("m" "Meeting" entry (file+headline nil "Meeting")
	;;	 "** %?\n %U\n %a\n %i\n")
	("i" "Idea" entry (file+headline nil "~/diary/org/idea.org")
	 "** %?\n %U\n %i\n %a\n %i\n")
	("w" "Twitter" entry (file+datetree "~/diary/org/twitter.org")
	 "** %U %?\n")
	)
      )

;; C-oの置き換え tmuxで c-oは使っているので
(define-key org-mode-map "\C-co" 'org-open-at-point)

;; -----------------------------------------------------------------------
;; NextActionの設定
;; http://qiita.com/takaxp/items/4dfa11a81e18b29143ec
;; ------------------------------------------------------------------------
;; タグの色変更
(setq org-tag-faces '(("next" :foreground "#FF0000")))
(defun my-sparse-doing-tree ()
    (interactive)
      (org-tags-view nil "next"))
(define-key org-mode-map (kbd "C-c 3") 'my-sparse-doing-tree)
