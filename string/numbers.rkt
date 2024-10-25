#lang racket ; numbers.rkt

(provide string-si->number)
(require (only-in srfi/13 string-take-right string-drop-right))

;; Copnvert Number Strings with SI suffixes into numbers
;; > (string-si->number "1.25K")
;; 1250.0

(define (string-si->number si-str)
  (define det
    (let ((det0 (string-take-right si-str 1)))
      (if (string-contains? "KMGTPEZY" det0)
          det0
          #f)))        
  (define base 
    (if det
        (string-drop-right si-str 1)
        si-str))
  (define a-list '((#f . "e1")
                   ("K" . "e3")
                   ("M" . "e6")
                   ("G" . "e9")
                   ("T" . "e12")
                   ("P" . "e15")
                   ("E" . "e18")
                   ("Z" . "e21")))
  (define pwr (dict-ref a-list det))
  (string->number (string-append base pwr)))

