(in-package #:blogsystem)

(defvar db-path "./database.txt")
(defvar contents-list '())

(defun addContents (contents &optional (uid (1+ (max-uid))))
  (setf contents-list
        (sort contents-list #'(lambda (a b)
                                (> (getf a :uid) (getf b :uid)))))
  (setf contents-list
        (append  (list (list
                        :uid uid
                        :contents contents))
                 contents-list))
  (list :uid uid))
;;この実装は後で後悔しそう。
(defun max-uid ()
  (if (null contents-list)
      -1
      (getf (car contents-list) :uid)))

(defun getContents (uid)
  (car (member-if #'(lambda (x) (= (getf x :uid) uid)) contents-list)))
;;対象がないならnilを返す
(defun updateContents (uid contents)
  (cond ((getContents uid)
         (removeContents uid)
         (addContents contents uid))))

(defun removeContents (uid)
  (setf contents-list (remove-if #'(lambda (x) (equal (getf x :uid) uid))
                                 contents-list)))
;;ユーザ認証機能実装したら複雑になる
(defun archive ()
  contents-list)
;;削除前にバックアップとか取れるといいかもね。
(defun all-remove-contents ()
  (setf contents-list nil))

(defun saveContents ()
  (with-open-file (out db-path :direction :output
                       :if-exists :supersede)
    (with-standard-io-syntax
      (print contents-list out))))

(defun loadContents ()
  (with-open-file (in db-path)
    (with-standard-io-syntax
      (setf contents-list (read in)))))
