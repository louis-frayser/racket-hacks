#lang racket

(provide integer)

;; Round to nearest integer
(define (integer  x)
  (inexact->exact (round x)))