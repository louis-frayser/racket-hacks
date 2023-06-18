#lang racket

(provide strings->string unlines)

;; A list of strings to a single string with each previous string  quoted
(define (strings->string_0 ss) (apply string-append (map (lambda (s) (format " ~s " s)) ss)))

(define (strings->string_1 ss)
 (string-join ss "\" \"" #:before-first "\"" #:after-last "\""))

(define strings->string strings->string_0)

(define (unlines ss) (string-split ss "\n"))

;; ==============================================================================================
#;(strings->string '("abc" "def" "ghi"))
