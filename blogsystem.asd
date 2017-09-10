;; (require \'asdf)

(in-package :cl-user)
(defpackage blogsystem-asd
  (:use :cl :asdf))
(in-package :blogsystem-asd)

(defsystem :blogsystem
    :version "1.0.0"
    :author "wasu"
    :license "MIT"
    :components ((:file "package")
                 (:module "src" :components ((:file "blogsystem")))))

