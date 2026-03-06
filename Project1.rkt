#lang racket

;; Mode detection logic
(define prompt?
   (let [(args (current-command-line-arguments))]
     (cond
       [(= (vector-length args) 0) #t]
       [(string=? (vector-ref args 0) "-b") #f]
       [(string=? (vector-ref args 0) "--batch") #f]
       [else #t])))

;; Fetches a value from history using the provided ID
(define (get-history-val id history)
  (let ([rev-hist (reverse history)])
    (if (or (<= id 0) (> id (length rev-hist)))
        (error "Invalid History ID")
        (list-ref rev-hist (- id 1)))))

;; Recursive parser for prefix notation
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
            (list (* (first left) (first right)) (second right)))]
         
         ;; Binary Integer Division with zero-check
         [(string=? token "/")
          (let* ([left (evaluate rest-tokens history)]
                 [right (evaluate (second left) history)])
            (if (= (first right) 0)
                (error "Division by zero")
                (list (quotient (first left) (first right)) (second right))))]
         
         ;; Unary Negation
         [(string=? token "-")
          (let ([val (evaluate rest-tokens history)])
            (list (- (first val)) (second val)))]

         ;; History Reference ($nn)
         [(and (> (string-length token) 1) (char=? (string-ref token 0) #\$))
          (let ([id (string->number (substring token 1))])
            (if id
                (list (get-history-val id history) rest-tokens)
                (error "Invalid Expression")))]

         ;; Numeric values
         [(string->number token)
          (list (string->number token) rest-tokens)]
         
         [else (error "Invalid Expression")]))]))

(define (tokenize str)
  (string-split str))

;; Main program loop
(define (main-loop history)
  (when prompt? (display "Enter expression: "))
  (let ([input (read-line)])
    (unless (or (eof-object? input) (string=? input "quit"))
      (with-handlers ([exn:fail? (lambda (e) 
                                   (displayln "Error: Invalid Expression")
                                   (main-loop history))])
        (let* ([tokens (tokenize input)]
               [eval-result (evaluate tokens history)])
          ;; Error if text remains after parsing
          (if (not (empty? (second eval-result)))
              (error "Trailing text")
              (let* ([result (first eval-result)]
                     [new-history (cons result history)]
                     [id (length new-history)])
                (display id)
                (display ": ")
                ;; Print as float using real->double-flonum
                (displayln (real->double-flonum result))
                (main-loop new-history)))))
      (main-loop history))))

;; Initialize with an empty history list
(main-loop '())
