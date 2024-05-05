#lang racket ;; prelude.rkt
;; functions from Haskell Prelude

(require (only-in srfi/1 (take scm:take) (drop scm:drop) (take-right scm:take-right)))

(provide drop take take-end flip)

(define (take n xs)
  (if (> n  (length xs))
      xs
      (scm:take xs n)))

(define (take-end n xs)
  (if (> n (length xs))
      xs
      (scm:take-right xs n)))

;; Haskell drop
(define (drop n xs)
  (if (>= n (length xs))
      '()
      (scm:drop xs n)))

(define (flip f) (lambda(x y)( f y x)))

#|
;;; Tests
(map (lambda(x)(take x '(1 2 3 4 5 6 7 8 9 10 11)))
     '(10 11 12))
(define xs11 '(1 2 3 4 5 6 7 8 9 10 11))
  
(map (lambda(n)(take-end n xs11))
     '(10 11 12))
|#
