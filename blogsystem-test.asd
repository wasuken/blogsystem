;; (require \'asdf)

(in-package :cl-user)
(defpackage blogsystem-test-asd
  (:use :cl :asdf))
(in-package :blogsystem-test-asd)

(defsystem blogsystem-test
    :depends-on (:blogsystem)
    :version "1.0.0"
    :author "wasu"
    :license "MIT"
    :components ((:module "t" :components ((:file "blogsystem-test"))))
    :perform (test-op :after (op c)
                    (funcall (intern #.(string :run) :prove) c)))

