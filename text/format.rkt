#lang racket ; format.rkt

(provide ~$ ~0 ~e ~si  string-quote)
(provide qq string-cat-macro)

(define (~0 n) (~a #:width 2 #:left-pad-string "0" #:align 'right n))
(define (string-quote s)
  (format "~s" s))  


(define-syntax-rule (string-cat-macro . strings)
  ;;; Enter a long line of text as multiple lines of strings
  (apply string-append strings))

(define-syntax-rule (qq) string-cat-macro)

(define (~$ amt #:precision (prec 2) #:min-with (minw 4))
  (~r amt #:precision prec #:min-width minw  #:group-sep ","))

(define (~e number #:precision ( prec 0) #:min-width (minw 8))
  (define pwr  (floor (log number 10)))
  (define-values (epwr0 mplr0)  (quotient/remainder pwr 3))
  (define epwr  (inexact->exact (* epwr0 3)))
  (define mplr (expt 10 mplr0))
  (define base  (* (/ number (expt 10 pwr))  mplr))
  (format "~ae~a"  (~r #:precision prec base #:min-width minw) epwr)
  )

(define (~si number #:precision ( prec 0) #:min-width (minw 8) )
  (define dict `((0 . "") (3 . "K") (6 . "M") (9 . "G") (12 . "T") 
                          (15 . "P") (18 . "E")))
  (define pwr  (floor (log number 10)))
  (define-values (epwr0 mplr0)  (quotient/remainder pwr 3))
  (define epwr  (inexact->exact (* epwr0 3)))
  (define mplr (expt 10 mplr0))
  (define base  (* (/ number (expt 10 pwr))  mplr))
  (format "~a~a"  (~r #:precision prec #:min-width minw base) (dict-ref dict epwr))
  )
#|
(~e 1.2345e5 )
(~si 1.2345e5 )
(~si 23399995.8)
|#