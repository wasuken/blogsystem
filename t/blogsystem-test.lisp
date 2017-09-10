(in-package :cl-user)
(defpackage blogsystem-test
  (:use :cl :prove :blogsystem))
(in-package #:blogsystem-test)

(defvar sample-contents "Hello BlogSystem!!")


(plan 2)
(subtest "ある程度普通のテスト"
         ;;contentsを登録する
         ;;連番で登録予定。登録時に発行したIDを返す
         ;;他にも返すようにするかもしれないので一応キーワード付
         (is (blogsystem::addContents sample-contents) '(:uid 0))
         (blogsystem::addContents "lisp lisp")
         (blogsystem::addContents "common lisp")
         ;;contentsを取得する
         (is (getf (blogsystem::getContents 0) :contents)
             sample-contents)
         ;;contentsを更新する。
         (blogsystem::updateContents 0 "Update BlogSystem!!")
         (is (getf (blogsystem::getContents 0) :contents)
             "Update BlogSystem!!")
         ;;contentsを削除する
         (blogsystem::removeContents 0)
         (is (blogsystem::getContents 0) nil))
(subtest "uid周りが怖すぎるのでかき回したテストを入れる。")
(finalize)

