#lang debug racket ; dates.rkt

(provide a-month-ago-str ymd->doy fill-missing-dates string-date-succ  
         string->sql-interval string->sql-timestamp
         ymd->date ymd->year-day  ymd date->date*)

(require (only-in srfi/19 
                  string->date 
                  current-julian-day date->julian-day julian-day->date
                  date->string))
(require (only-in racket/date current-date date->seconds find-seconds))
(require (only-in db sql-timestamp sql-interval))
(require "../math.rkt")
         
;; ------------------------------------ string-date ---------------------------
;; Return the next YYYY-MM-DD string
(define (string-date-succ datestring)

  (define (~0 n) (~a n #:left-pad-string "0" #:align 'right #:min-width 2))
  (let* ((d  (string->date datestring "~Y~m~d"))
         (d2 (julian-day->date (+ 1 (date->julian-day d)))))
    (format "~a-~a-~a"
            (date-year d2) (~0 (date-month d2))  (~0 (date-day d2)))))

(define (date->date* d)(seconds->date (date->seconds d))) 

(define (ymd y m d)
  (date->date* (struct-copy date (current-date) (year y) (month m) (day d))))

(define ymd->date ymd)

;; ............................................................................

(define (a-month-ago-str) ; -> "YYYY-MM0DD"
  ;; Returns last-month on the cadinal day 1 before today
  (let*((jdn (current-julian-day))
        (jmonth-ago (integer (- jdn 30)))
        (month-ago (julian-day->date jmonth-ago)))
    (date->string month-ago "~Y-~m-~d")))
;; .............................................................................

(define (fill-missing-dates date-data-list deflvalue
                            #:start (sdate #f) #:end (edate #f))
  (when (and (null? date-data-list) (nor sdate edate))
    (error 'insufficient-instantiation
           "racket-hacks/data/dates.rkt: #'fill-missing-dates"))
  (let ((mts date-data-list)
        (start-date (or sdate (caar date-data-list)))
        (end-date (or edate (car (last date-data-list)))))
    ;; Insert dummy record for any missing dates in
    ;; list of ("YYYY-MM-DD "Data1" "Data2"...)
    (let loop  ( (rest mts) (ckey start-date)  (acc '() ))
      (let-values (( (nkey head) (if (pair? rest) 
                                     (values (caar rest) (car rest)) 
                                     (values #f #f))))
        (cond 
          ((null? rest ) (reverse acc #;(cons head  acc)))
          ((string=? nkey ckey)
           (loop (cdr rest) (string-date-succ ckey) (cons head acc)))
          ((string>? ckey nkey)
           (error 'internal-program "ckey is too large!"))
          (else (loop rest (string-date-succ ckey)
                      (cons (cons ckey deflvalue) acc))))
        ))))
;; ............................................................................
(define (string->sql-timestamp s)
  (define l (map string->number (string-split s #px"[\\s|T|:-]+")))
  (sql-timestamp (first l) (second l) (third l) (fourth l) (fifth l) 0 0 #f)) 

(define (string->sql-interval s)
  ;; Only for HH:MM 
  (define l  (map string->number (string-split s #px"[\\s|T|:-]+")))
  (if (not (= (length l) 2))
      (error 'format-error "#'string->sql-interval: Hrs:Mins only") 
      (sql-interval 0 0 0 (first l) (second l) 0 0 )))
;; ............................................................................
;; Google Gemini -- Ordinal day of  year
(define (ymd->year-day year month day)
  ;; find-seconds gets the number of seconds since the epoch for a local time,
  ;; we can pass #t for is-dst (daylight saving time) which is generally fine
  ;; for just a date calculation as it relates to a specific local time.
  (define local-secs
    (find-seconds 0 0 0 day month year #t))

  ;; seconds->date converts those seconds into a 'date' struct
  (define the-date
    (seconds->date local-secs))

  ;; date-year-day extracts the ordinal day (0-indexed, so 0 is Jan 1st)
  ;; We add 1 to make it 1-indexed (1 to 365 or 366) as per the usual definition
  (+ (date-year-day the-date) 1))
(define ymd->doy ymd->year-day) ;; an alias

#;(begin
    ;; Example Usage:
    ;; April 19, 2024 is the 110th day of the year (2024 is a leap year)
    (display "April 19, 2024 is day ")
    (display (ymd->year-day #;date->ordinal-day 2024 4 19)) ; Output: 110
    (newline))
;; ============================================================================
