(in-package #:quickutil)

(defutil reseed-random-state (:version (1 . 0)
                              :category random)
  #1="Reseed the random state use by the random number generator."
  (defun reseed-random-state ()
    #1#
    (setf *random-state* (make-random-state t))))

(defutil random-between (:version (1 . 0)
                         :category random)
  #1="Generate a random integer between A and B, inclusive."
  (defun random-between (a b)
    #1#
    (assert (>= b a))
    (if (= a b)
        a
        (+ a (random (- (1+ b) a))))))

(defutil random-elt (:version (1 . 0)
                     :depends-on random-between
                     :category (random sequences))
  #1="Choose a random element of SEQ according to DISTRIBUTION. If
DISTRIBUTION is null, the distribution will be uniform. Otherwise,
DISTRIBUTION should be a list of probability values"
  (defun random-elt (seq &optional distribution)
    #1#
    (if (null distribution)
        (elt seq (random-between 0 (1- (length seq))))
        (let* ((cum (loop :for x :in distribution
                          :sum x :into s
                          :collect s))
               (r (random 1.0d0))
               (pos (position-if (lambda (x) (<= r x)) cum)))
          (if (or (null pos)
                  (>= pos (length seq)))
              (error "Bad distribution: ~S" distribution)
              (elt seq pos))))))

(defutil shuffle-vector (:version (1 . 0)
                         :depends-on random-between
                         :category (random vectors))
  #1="Destructively shuffle VECTOR randomly."
  (defun shuffle-vector (vector)
    #1#
    (let ((n (length vector)))
      (loop :for i :below n 
            :for r := (random-between i (1- n))
            :when (/= i r)
              :do (rotatef (aref vector i)
                           (aref vector r))
            :finally (return vector)))))

(defutil shuffle (:version (1 . 0)
                  :depends-on (shuffle-vector
                               copy-array
                               list-to-vector
                               sequence-to-list)
                  :category (random generic shuffle))
  #1="Shuffle a generic object."
  (defgeneric shuffle (obj)
    (:documentation #1#)
    (:method ((obj vector)) (shuffle-vector (copy-array obj)))
    (:method ((obj list)) (let ((vector (list-to-vector obj)))
                            (sequence-to-list (shuffle-vector vector))))))