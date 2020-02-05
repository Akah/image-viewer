;;;; image-viewer.asd

(asdf:defsystem #:image-viewer
  :description "Displays a scaled image in a window"
  :author "Robin White <robin.white280@gmail.com>"
  :license  "GPL v3.0"
  :version "0.0.1"
  :serial t
  :build-operation "asdf:program-op"
  :entry-point "image-viewer:main"
  :depends-on (#:unix-opts
	       #:sdl2
	       #:sdl2-image)
  :components ((:file "package")
               (:file "image-viewer")))

#+sb-core-compression
(defmethod asdf:perform ((o asdf:image-op) (c asdf:system))
  (uiop:dump-image (asdf:output-file o c) :executable t :compression 9))

