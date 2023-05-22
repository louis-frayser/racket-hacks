;; mount.rkt
#lang racket
;;; Utilites of /proc/mounts
;;
(require srfi/9)
(provide mt_dev mt_mpt mt_fst mt_opt mt_dmp mt_fsk mntent get-mountpoints get-submounts)

(define-record-type :mntent  (mntent dev mpt fst opt dmp fsk)
  mntent?
  (dev mt_dev) (mpt mt_mpt) (fst mt_fst) (opt mt_opt) (dmp mt_dmp) (fsk mt_fsk) ) 
  
(define (get-mounts)
  (define %mounts
    (file->lines "/proc/mounts"))

  (define %mntents (map (curry apply mntent) (map string-split %mounts)))
  %mntents)

(define (get-mountpoints)
  (map mt_mpt (get-mounts)))

(define (get-submounts abs-path)
(filter (lambda(p)(string-prefix? p abs-path)) 
     (get-mountpoints)))

#;(get-submounts "/volumes/crypt")