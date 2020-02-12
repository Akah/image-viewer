;;;; image-viewer.lisp

(in-package #:image-viewer)

(opts:define-opts
  (:name :path
	 :description "path to the desired image"
	 :short #\p
	 :long "path"
	 :arg-parser #'parse-namestring))

(defmacro when-option ((options opt) &body body)
  `(let ((it (getf ,options ,opt)))
     (when it
       ,@body)))

(defmacro with-image-init (&body body)
  `(progn
    (sdl2-image:init '(:png))
    (unwind-protect
	 (progn
	   ,@body))
    (sdl2-image:quit)))

(defun clear-renderer (renderer)
  (sdl2:set-render-draw-color renderer 255 255 255 0)
  (sdl2:render-clear renderer))

(defun scale (num)
  (* 2 num))

(defun main-loop (renderer texture dst-rect)
  (clear-renderer renderer)
  (sdl2:render-copy renderer texture :dest-rect dst-rect)
  (sdl2:render-present renderer)
  (sdl2:delay 50))

(defun main ()
  (unless (null (getf (opts:get-opts) :path))
    (with-image-init
      (let* ((image (sdl2-image:load-image (getf (opts:get-opts) :path)))
	     (width (scale (sdl2:surface-width image)))
	     (height (scale (sdl2:surface-height image))))
	(sdl2:with-init (:everything)
	  (sdl2:with-window (win
			     :title "file-name.png"
			     :w width
			     :h height
			     :flags '(:shown :resizable))
	    (sdl2:with-renderer (renderer win :flags '(:accelerated))
	      (sdl2:with-event-loop (:method :poll)
		(:idle ()
		       (main-loop renderer
				  (sdl2:create-texture-from-surface renderer image)
				  (sdl2:make-rect 0 0 width height)))
		       ;(format t "~a~%" (sdl2:get-window-size win)))
		(:quit () t))))))))
  (format t "No path provided, ending program~%"))
