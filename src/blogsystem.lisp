(in-package #:blogsystem)

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

(defun updateContents (uid contents)
  (when (null (getContents uid)) nil)
  (removeContents uid)
  (addContents contents uid))

(defun removeContents (uid)
  (setf contents-list (remove-if #'(lambda (x) (equal (getf x :uid) uid))
                                 contents-list)))
