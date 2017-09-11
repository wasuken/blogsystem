(in-package :cl-user)
(defpackage blogsystem-test
  (:use :cl :prove :blogsystem))
(in-package #:blogsystem-test)

(defvar sample-contents "Hello BlogSystem!!")

;;いちいちクリーンするのめんどくさいよぉぉ・・・
;;という気持ちから生まれたマクロ（笑）
;;テスト前の準備とかまとめて書きたいよね。
(defmacro subtest-clean (&body body)
  (let ((lst `(subtest ,@body)))
    (if (> (length lst) 1)
        (append lst (list `(blogsystem::all-remove-contents)))
        lst)))

(plan 4)
(subtest-clean "基本機能テスト"
               (diag "登録(3件)")
               ;;contentsを登録する
               ;;連番で登録予定。登録時に発行したIDを返す
               ;;他にも返すようにするかもしれないので一応キーワード付
               (is (blogsystem::addContents sample-contents) '(:uid 0))
               (blogsystem::addContents "lisp lisp")
               (blogsystem::addContents "common lisp")
               ;;contentsを取得する
               (diag "取得")
               (is (getf (blogsystem::getContents 0) :contents)
                   sample-contents)
               ;;contentsを更新する。
               (diag "更新")
               (blogsystem::updateContents 0 "Update BlogSystem!!")
               (is (getf (blogsystem::getContents 0) :contents)
                   "Update BlogSystem!!")
               ;;contentsを削除する
               (diag "削除")
               (blogsystem::removeContents 0)
               (is (blogsystem::getContents 0) nil))

(subtest-clean "その他機能"
               (blogsystem::addContents "テスト・テスト1")
               (blogsystem::addContents "テスト・テスト2")
               (blogsystem::updateContents 0 "Update BlogSystem!!")
               (blogsystem::removeContents 1)
               (is (length (blogsystem::archive)) 1)
               (is (getf (blogsystem::getContents 0) :contents)
                   "Update BlogSystem!!"))
(subtest-clean "失敗確認テスト"
               (diag "存在しないアイテムを更新(仕様上nilを返す)")
               (is (blogsystem::updateContents 10000 "aaaa") nil)
               (diag "存在しないアイテムの削除")
               (is (blogsystem::removeContents 1000) nil))

(subtest-clean "データ保存・読み込みテスト"
               (blogsystem::addContents "test")
               (blogsystem::saveContents)
               (if (probe-file "./database.txt")
                   (pass "save file exists!")
                   (fail "save file not exists!"))
               (delete-file "./database.txt"))
