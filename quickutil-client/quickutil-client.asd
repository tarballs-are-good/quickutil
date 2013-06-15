;;;; quickutil-client.asd
;;;; Copyright (c) 2013 Robert Smith

(asdf:defsystem #:quickutil-client
  :serial t
  :description "The Quickutil client for downloading utility code."
  :author "Robert Smith <quad@symbo1ics.com>"
  :license "BSD 3-clause. See LICENSE file."
  :components ((:file "package")
               (:file "conditions")
               (:file "host")
               (:file "quickutil-client")
               (:file "autoload"))
  :depends-on ("drakma" "temporary-file"))
