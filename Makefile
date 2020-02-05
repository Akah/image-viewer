build:
	sbcl --load image-viewer.asd \
		--eval '(ql:quickload :image-viewer)' \
		--eval '(asdf:make :image-viewer)' \
		--eval '(quit)'
