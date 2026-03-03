#lang racket

;; Mode detection logic
(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))

(define (tokenize str)
  (string-split str))
         
(define (evaluate tokens history)
  (cond
    [(empty? tokens) (error "Invalid Expression")]
    [else
     (let ([token (first tokens)]
           [rest-tokens (rest tokens)])
       (cond
         ;; Binary Addition
         [(string=? token "+")
          (let* ([left (evaluate rest-tokens history)]
                 [right (evaluate (second left) history)])
            (list (+ (first left) (first right)) (second right)))]
         
         ;; Binary Multiplication
         [(string=? token "*")
          (let* ([left (evaluate rest-tokens history)]
                 [right (evaluate (second left) history)])
            (list (* (first left) (first right)) (second right)))]))]))
