#lang racket ; format.rkt

(provide ~0 string-quote)
(provide qq string-cat-macro)

(define (~0 n) (~a #:width 2 #:left-pad-string "0" #:align 'right n))
(define (string-quote s)
  (format "~s" s))  


(define-syntax-rule (string-cat-macro . strings)
  ;;; Enter a long line of text as multiple lines of strings
  (apply string-append strings))

(define-syntax-rule (qq) string-cat-macro)


