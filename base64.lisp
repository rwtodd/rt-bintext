;; b i n t e x t -- h e x

(in-package "RT-BINTEXT")

(defconstant +b64-letters+
  "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/")

(defun base64-encode (src &optional tgt)
  "Encode a hexadecimal string from SRC into TGT, if provided"
  (declare (type (simple-array (unsigned-byte 8) 1) src)
	   (optimize (speed 3) (safety 0) (debug 0)))
  (let ((real-tgt (if (and tgt
			   (array-has-fill-pointer-p tgt)
			   (adjustable-array-p tgt))
		      tgt
		      (make-array (* 4 (ceiling (length src) 3))
				  :element-type 'character
				  :fill-pointer 0
				  :adjustable t)))
	(idx 0)
	(slen (length src)))
    (declare (type (vector character) real-tgt)
	     (type fixnum idx slen))
    ;; do all the complete sets of 3 inputs
    (dotimes (_ (floor slen 3))
      (let ((i1 (aref src idx))
	    (i2 (aref src (1+ idx)))
	    (i3 (aref src (+ idx 2))))
	(declare (type (unsigned-byte 8) i1 i2 i3))
	(incf idx 3)
	(vector-push-extend (aref +b64-letters+ (ash i1 -2)) real-tgt)
	(vector-push-extend (aref +b64-letters+
				  (logand 63 (logior (ash i1 4) (ash i2 -4))))
			    real-tgt)
	(vector-push-extend (aref +b64-letters+
				  (logand 63 (logior (ash i2 2) (ash i3 -6))))
			    real-tgt)
	(vector-push-extend (aref +b64-letters+ (logand 63 i3)) real-tgt)))
    ;; now handle any incomplete sets of 3 inputs
    (ccase (- slen idx)
      (0 t)
      (1
       (let ((i1 (aref src idx)))
	 (vector-push-extend (aref +b64-letters+ (ash i1 -2)) real-tgt)
	 (vector-push-extend (aref +b64-letters+
				   (logand 63 (ash i1 4)))
			     real-tgt))
       (vector-push-extend #\= real-tgt)
       (vector-push-extend #\= real-tgt))
      (2
       (let ((i1 (aref src idx))
	     (i2 (aref src (1+ idx))))
	 (vector-push-extend (aref +b64-letters+ (ash i1 -2)) real-tgt)
	 (vector-push-extend (aref +b64-letters+
				   (logand 63 (logior (ash i1 4) (ash i2 -4))))
			     real-tgt)
	 (vector-push-extend (aref +b64-letters+
				   (logand 63 (ash i2 2)))
			     real-tgt))
       (vector-push-extend #\= real-tgt)))
    real-tgt))
