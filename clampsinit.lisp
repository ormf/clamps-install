;;; Personal initialization file for common music/clamps, setting up
;;; paths for soundfiles and sfz files and associations between
;;; keywords and sfz files.
;;;
;;; Put this file into your home directory (at
;;; "$HOME/.clampsinit.lisp") and adjust as needed. It will be
;;; executed each time, clamps ist loaded into lisp.

(in-package :cl-user)

(pushnew :cuda-usocket-osc *features*)

;;; The document root for online help of clamps/cm symbols:

(set-clamps-doc-root "http://localhost:8282/")

;;; number of midi ports to open at clamps startup

(setf *num-midi-ports* 2)

;;; The following paths are the default paths, where sfz and
;;; soundfiles are located in the clamps repository. In order to be
;;; able to pull updates of clamps later on it is advisable to add
;;; your own sfz files and soundfiles into a folder of your choice and
;;; push this folder as a pathname to the *sfz-file-path* and
;;; *sfile-path* variables. All directories listed in *sfile-path* or
;;; *sfz-preset-path* will get searched recursively for soundfiles or
;;; sfz files respectively. Additional sfz associations between the
;;; preset keyword and an sfz file should be added using the
;;; "add-sfz-assoc" function.
;;;
;;; Example (you can add the example code at the end of this file to
;;; load it each time, cm/clamps is loaded):
;;;
;;; (pushnew (pathname "~/work/snd/") *sfile-path*)
;;; (pushnew (pathname "~/work/snd/sfz/") *sfz-file-path*)
;;; (pushnew (pathname "~/work/snd/ats/") *ats-file-path*)

(let ((sfz-assoc
        '(:flute-nv "000_Flute-nv.sfz"
          :yamaha-grand-piano "yamaha-grand-piano.sfz")))
  (format t "~&registering ~a sfz-files" (/ (length sfz-assoc) 2))
  (loop for (sym fname) on sfz-assoc by #'cddr
        do (progn
             (format t ".")
             (add-sfz-preset sym fname)))
  (format t "done~%"))
