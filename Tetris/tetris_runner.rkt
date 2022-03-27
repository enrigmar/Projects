#lang racket

;; This file was written by members of the CSE341 course staff at the University of Washington.
;; It is included for functionality purposes.

(require "tetris_provided.rkt")
(require "tetris_game.rkt")

(define mode (make-parameter 'enhanced))

(define (top-level)
  (command-line
   #:program "tetris_runner"
   #:once-any
   ("--original" "Run the provided (base) game."
                 (mode 'original))
   ("--enhanced" "Run your enhanced version of the game game."
                 (mode 'enhanced))
   ; Uncomment this line if you do the challenge problem
   #;("--challenge" "Run your challenge problem version of the game game."
                    (mode 'challenge)))

  (println (mode))

  (match (mode)
    ['original (new tetris%)]
    ['enhanced (new my-tetris%)]
    ; Uncomment this line if you do the challenge problem
    #;['challenge (new my-tetris-challenge%)]))

(module* main #f
  (define the-game (top-level)))
