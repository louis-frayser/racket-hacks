#lang racket ; dates.rkt

(provide fill-missing-dates string-date-succ a-month-ago-str )

(require (only-in srfi/19 string->date current-julian-day julian-day->date date->string))
(require (only-in racket/date date->seconds))
(require "../math.rkt")
         
;; ------------------------------------ string-date ---------------------------------------------
;; Return the next YYYY-MM-DD string
(define (string-date-succ datestring)
  (define secs/day (* 24 3600))
  (define (~0 n) (~a n #:left-pad-string "0" #:align 'right #:min-width 2))
  (let* ((d  (string->date datestring "~Y~m~d"))
         (d2 (seconds->date (+ secs/day (date->seconds d)) )))
    (format "~a-~a-~a" (date-year d2) (~0 (date-month d2))  (~0 (date-day d2)))))
;; ..............................................................................................

(define (a-month-ago-str) ; -> "YYYY-MM0DD"
  ;; Returns last-month on the cadinal day 1 before today
  (let*((jdn (current-julian-day))
        (jmonth-ago (integer (- jdn 30)))
        (month-ago (julian-day->date jmonth-ago)))
    (date->string month-ago "~Y-~m-~d")))
;; ..............................................................................................

(define (fill-missing-dates date-data-list deflvalue #:start (sdate #f) #:end (edate #f))
  (when (and (null? date-data-list) (nor sdate edate))
    (error 'insufficient-instantiation "racket-hacks/data/dates.rkt: #'fill-missing-dates"))
  (let ((mts date-data-list)
        (start-date (or sdate (caar date-data-list)))
        (end-date (or edate (car (last date-data-list)))))
    ;; Insert dummy record for any missing dates in list of ("YYYY-MM-DD "Data1" "Data2"...)
    (let loop  ( (rest mts) (ckey start-date)  (acc '() ))
      (let-values (( (nkey head) (if (pair? rest) 
                                     (values (caar rest) (car rest)) 
                                     (values #f #f))))
        (cond 
          ((null? rest ) (reverse acc #;(cons head  acc)))
          ((string=? nkey ckey) (loop (cdr rest) (string-date-succ ckey) (cons head acc)))
          ((string>? ckey nkey) (error 'internal-program "ckey is too large!"))
          (else (loop rest (string-date-succ ckey)  (cons (cons ckey deflvalue) acc))))
        ))))

;; ==============================================================================================
