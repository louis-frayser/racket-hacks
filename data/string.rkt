#lang racket
(provide strings->string)

;; A list of strings to a single string with each previous string  quoted
(define (strings->string ss)
  (apply string-append (map (lambda (s) (format " ~s " s)) ss)))

#;(strings->string '("abc" "def" "ghi"))
