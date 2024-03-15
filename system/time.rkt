#lang racket

(provide tstamp to-cs cs-to-hms-str)

(define (~0 n) (~a #:width 2 #:left-pad-string "0" #:align 'right n))
(require (only-in racket/date current-date))

;; tstamp :: IO String
(define (tstamp #:for-html? (ht? #f))
  (define date  (current-date))
  (define-values (~f sep ) (if ht? (values ~0 "T") (values ~a " "))) 
  (format "~a-~a-~a~a~a:~a"
          (date-year date)
          (~0 (date-month  date))
          (~f (date-day    date))
          sep
          (~f (date-hour   date))
          (~f (date-minute date))))

;; to-cs :: String->String
(define (to-cs hhmmsscs-str) ;;; HH:MM:SS.SS => centisecs
  (let* ((lst (map string->number (string-split hhmmsscs-str  #px"[:.]")))
         (hh (first lst))
         (mm (second lst))
         (ss (third lst))
         (cs  (fourth lst)))
    (+ cs  (* 100 ss)  (* 100 60 mm)  (* 100 60 60 hh))))

;; cs-to-hms-str :: String->String
(define (cs-to-hms-str css) ;;; Centisec to HH:MM:S.s (string)
  (let*-values (( (hh cs1) (quotient/remainder css 360000 ))
                ( (mm cs2)  (quotient/remainder cs1 6000))
                ( (ss cs)  (quotient/remainder cs2 100)))
    (format "~a:~a:~a.~a" (~0 hh) (~0 mm) (~0 ss) (~0 cs))))


#;(displayln (tstamp))

