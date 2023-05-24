#lang racket

(provide ~0 string-quote)

(define (~0 n) (~a #:width 2 #:left-pad-string "0" #:align 'right))
(define (string-quote s)
  (format "~s" s))  



#|
(require (only-in racket/date current-date) 
(define date  (current-date))
(displayln date)

(define tstamp (format "~a-~a-~a ~a:~a"
                       (date-year date)
                       (~0 (date-month date))
                       (date-day date)
                       (date-hour date)
                       (date-minute date)))

(displayln tstamp)

|#

