#lang racket

;; This file was contributed to by Margot Enright-Down and
;; members of the CSE341 course staff

(require racket/random)

(require "hw6provided.rkt")
(provide my-tetris% my-board%)

;; overrride tetris class to add 'u' and 'c' key codes
(define my-tetris%
  (class tetris%
    (super-new)
    (inherit set-board!)
    (define/override (reset-board)
      (set-board! (new my-board% [game this])))
    
    (define/augment (on-char event)
      (define keycode (send event get-key-code))
      (match keycode
        [#\u (send (send this get-board) rotate-clockwise)(send (send this get-board) rotate-clockwise)]
        [#\c (unless (< (send (send this get-board) get-score) 100) ; check if score is currently <100
             ; set the cheat flag, subtract 100 from current score     
             (begin(send (send this get-board) set-cheat!)
                   (unless (send (send this get-board) get-hit-c) ; check if c has already been hit before adjusting the score
                     (send (send this get-board) set-score! (- (send (send this get-board) get-score) 100))) ; adjust the score
                   (send (send this get-board) set-hit-c! #t)))] ; set c flag so cheating cannot happen again this round
        [_ (inner #f on-char event)]))

    ))

;; build the board for the modified tetris game with rotation and cheat sequence upgrades
(define my-board%
  (class board%
    (define cheat-shape #f) ; flag for if we are cheating
    (define hit-c #f) ; flag for if c has been hit during this round 
    (super-new)
    (inherit set-delay!)
    (inherit remove-filled)
    (define/public (set-cheat!) (set! cheat-shape #t)) ; setter for cheat flag
    (define/public (set-hit-c! x) (set! hit-c x)) ; setter for c flag
    (define/public (get-hit-c) hit-c) ; getter for c flag

    (define/override (select-shape)
      (if cheat-shape
          ; if the cheat flag is set use the single shape for the next piece
          ; update the c flag so cheating can occur again next round
          (begin (set! cheat-shape #f)(set! hit-c #f)(vector (vector '(0 . 0))))
          ; otherwise use a random shape from the 7 classic and 3 new shapes
          (random-ref (vector-append all-shapes (vector (rotations (vector '(0 . 0) '(1 . 0) '(0 . 1) '(1 . 1) '(2 . 0)))) ;extended square
                                     (vector (vector (vector '(0 . 0) '(1 . 0) '(2 . 0) '(-1 . 0) '(-2 . 0)) ;5 long
                                                     (vector '(0 . 0) '(0 . -1) '(0 . 1) '(0 . 2) '(0 . -2))))
                                     (vector (rotations (vector '(0 . 1) '(0 . 0) '(1 . 0)))))))) ;right angle


    (define/override (store-current)
      (define points (send (send this get-current-piece) get-points))
      (for ([idx (in-range (vector-length points))]) ;get the correct number of points for the current piece
        (match-define (cons x y) (vector-ref points idx))
        (when (>= y 0)
          (vector-set! (vector-ref (send this get-grid) y) x (send (send this get-current-piece) get-color))))
      (remove-filled)
      (set-delay!(max (- (send this get-delay) 2) 80)))
    ))









    


