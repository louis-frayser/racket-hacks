;; main.rkt
#lang racket

(provide string-max)
(define (string-max . xs)
  ;;; Find the alphabetically maximum string
  (define strmax1
    (lambda(result x)
      (if (string>? x result)
          x
          result)))
  (foldl strmax1 "" xs))
