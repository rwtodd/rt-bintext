(defsystem "rt-bintext"
  :description "rt-bintext: binary-text encodings"
  :version "1.0"
  :author "Richard Todd <richard.wesley.todd@gmail.com>"
  :licence "MIT"
;;  :depends-on ("optima.ppcre" "command-line-arguments")
  :components ((:file "packages")
               (:file "base64" :depends-on ("packages"))
	       (:file "hex" :depends-on ("packages"))))

