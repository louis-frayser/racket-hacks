#lang racket

(provide tstamp)

(define (~0 n) (~a #:width 2 #:left-pad-string "0" #:align 'right))
(require (only-in racket/date current-date))


(define (tstamp)
  (define date  (current-date))         
  (format "~a-~a-~a ~a:~a"
          (date-year date)
          (~0 (date-month date))
          (date-day date)
          (date-hour date)
          (date-minute date)))


#;(displayln (tstamp))

