#lang debug racket ; time.rkt (string-time.rkt)

(provide  cs-to-hms-str mins->time-string
         string-time->mins tstamp to-cs
         string-time+ string-time/ string-time-subtract string-time-mul string-time-div)
(require (only-in srfi/1 car+cdr))
(require (only-in racket/date current-date))
;;====================================================================
(define (~0 n) (~a #:width 2 #:left-pad-string "0" #:align 'right n))
;;====================================================================
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
;;----------------------------------------------------------------------

;
(define (string-time->mins hh:mm-str)
  (let*-values ( ((h m0) (car+cdr (map string->number
                                       (string-split hh:mm-str ":") )))
                 ( (m) (first m0)))
    (+ (* h 60) m)))

(define (mins->time-string mins)
  (let*-values ( ((hrs mins ) (quotient/remainder (round mins) 60)) )
    (string-join (map number->string `(,hrs ,mins)) ":")
    (string-append
     (~a hrs) ":" (~a mins #:width 2 #:align 'right #:left-pad-string "0"))))

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
;;; -------------------------------------------------------------------
;;; Add time-duration strings
(define (string-time+ .  strings)
  (with-handlers ((exn:fail? (lambda(exn)(eprintf "strtime+: ~v ~v~n"
                                                  strings  exn))))
    (let*((lists (map (lambda(s)(string-split s ":")) strings))
          (nlists (map (lambda(ls)(map string->number ls)) lists))
          (mins-ea (map (lambda(nlist)
                          (+ (* 60 (car nlist)) (cadr nlist))) nlists))
          (tmins (apply + mins-ea)))
      (call-with-values
       (lambda()(quotient/remainder tmins 60))
       (lambda(hrs mins)
         (string-append
          (~a hrs) ":" (~a mins #:align 'right
                           #:min-width 2 #:left-pad-string "0" )))))))
(define (string-time/ stime . divisors)
  (mins->time-string ( apply / (cons (string-time->mins  stime) divisors))))

;;; ......................................................................
(define (string-time-subtract time1 time2)
  (let* ([time1-parts (map string->number (string-split time1 ":"))]
         [time2-parts (map string->number (string-split time2 ":"))]
         [minutes1 (+ (* (first time1-parts) 60) (second time1-parts))]
         [minutes2 (+ (* (first time2-parts) 60) (second time2-parts))]
         [diff-minutes (- minutes1 minutes2)]
         [hours-diff (quotient diff-minutes 60)]
         [minutes-diff (remainder diff-minutes 60)])
    (format "~a:~a" (if (< hours-diff 0) (+ hours-diff 24) hours-diff)
            (~r minutes-diff #:min-width 2 #:pad-string "0"))))

;; Multiply time by scalor
(define (string-time-mul st num)
  (mins->time-string (* (string-time->mins st) num)))

;; string-time-div ::  time_strng -> time_strng -> time->tring
(define (string-time-div ts1 ts2)
  ;; Divide time 2 into time 1
  (apply /  (map string-time->mins `(,ts1 ,ts2))))                                  
                                  

