;; b i n t e x t -- h e x

(in-package "RT-BINTEXT")

(defun hex-encode (src &optional tgt)
  "Encode a hexadecimal string from SRC into TGT, if provided"
  (declare (type (simple-array (unsigned-byte 8) 1) src)
	   (optimize (speed 3) (safety 0) (debug 0)))
  (let ((real-tgt (if (and tgt
			   (array-has-fill-pointer-p tgt)
			   (adjustable-array-p tgt))
		      tgt
		      (make-array (* 2 (length src))
				  :element-type 'character
				  :fill-pointer 0
				  :adjustable t))))
    (declare (type (vector character) real-tgt))
    (loop :for x :across src
	  :do (format real-tgt "~(~2,'0X~)" x)
	  :finally (return real-tgt))))
