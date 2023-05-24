#lang racket ; pathname.rkt

(provide basename)

(define (basename fnamestr) (last (string-split fnamestr "/")))