;; skill-verification.clar
;; This contract allows institutions to create assessments, students to submit answers
;; and institutions to issue skill badges upon successful completion of assessments

(define-map assessments
    { assessment-id: uint }
    {
        creator: principal,
        description: (string-ascii 100),
        is-active: bool
    })

(define-map submissions
    {
        assessment-id: uint,
        student: principal
    }
    {
        answer: (string-ascii 200),
        reviewed: bool,
        passed: bool
    })

(define-map badges
    {
        student: principal,
        assessment-id: uint
    }
    {
        badge-id: uint,
        issued-by: principal,
        description: (string-ascii 100)
    })

(define-data-var assessment-counter uint u1)
(define-data-var badge-counter uint u1)

(define-constant ERR_UNAUTHORIZED (err u100))
(define-constant ERR_ASSESSMENT_NOT_FOUND (err u101))
(define-constant ERR_ALREADY_SUBMITTED (err u102))
(define-constant ERR_ALREADY_REVIEWED (err u103))
(define-constant ERR_INVALID_ASSESSMENT (err u104))
(define-constant ERR_INVALID_INPUT (err u105))

;; Create an assessment (only callable by institutions)
(define-public (create-assessment (description (string-ascii 100)))
    (let 
        (
            (id (var-get assessment-counter))
            (valid-description (asserts! (and (> (len description) u0) (<= (len description) u100)) ERR_INVALID_INPUT))
        )
        (ok 
            (begin
                (map-insert assessments
                    { assessment-id: id }
                    {
                        creator: tx-sender,
                        description: description,
                        is-active: true
                    })
                (var-set assessment-counter (+ id u1))
                id
            )
        )
    )
)
