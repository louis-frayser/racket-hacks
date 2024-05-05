#lang setup/infotab

(define version "0.1")
(define collection "racket-hacks")
(define name "racket-hacks")
(define deps '("db-lib"
               "srfi-lib"
               "srfi-lite-lib"
               "base" ))

#;(define build-deps '("racket-doc" "scribble-lib"))
(define scribblings '(("scribblings/racket-hacks.scrbl" ())))
(define build-deps '("debug"))
