;; skill-verification-extension.clar
;; This contract extends the base skill verification system with additional features
;; while maintaining compatibility with the original contract

;; Constants for error handling
(define-constant ERR_UNAUTHORIZED (err u200)) ;; Different error codes from base contract
(define-constant ERR_INVALID_INPUT (err u201))
(define-constant ERR_NOT_FOUND (err u202))
(define-constant ERR_ALREADY_EXISTS (err u203))

;; Data Variables
(define-data-var template-counter uint u1)
(define-data-var category-counter uint u1)
;; Assessment Categories
(define-map assessment-categories
    { category-id: uint }
    {
        name: (string-ascii 50),
        description: (string-ascii 200),
        created-by: principal
    }
)

;; Links assessment IDs to categories
(define-map assessment-category-links
    { assessment-id: uint }
    {
        category-id: uint,
        added-by: principal,
        timestamp: uint
    }
)

;; Templates for standardized assessments
(define-map assessment-templates
    { template-id: uint }
    {
        name: (string-ascii 50),
        description: (string-ascii 200),
        created-by: principal,
        category-id: uint,
        required-score: uint,
        time-limit: uint  ;; in blocks
    }
)

;; Institution verification status
(define-map verified-institutions
    { institution: principal }
    {
        name: (string-ascii 50),
        verification-date: uint,
        status: (string-ascii 20),  ;; "pending", "verified", "suspended"
        verification-level: uint     ;; 1-3 indicating trust level
    }
)

;; Tracks prerequisites for assessments
(define-map assessment-prerequisites
    { assessment-id: uint }
    {
        required-assessments: (list 10 uint),
        required-badges: (list 10 uint),
        minimum-score: uint
    }
)
;; Create a new assessment category
(define-public (create-category (name (string-ascii 50)) (description (string-ascii 200)))
    (let
        ((category-id (var-get category-counter)))
        (ok
            (begin
                (map-insert assessment-categories
                    { category-id: category-id }
                    {
                        name: name,
                        description: description,
                        created-by: tx-sender
                    })
                (var-set category-counter (+ category-id u1))
                category-id
            )
        )
    )
)

;; Link an existing assessment to a category
(define-public (link-assessment-to-category (assessment-id uint) (category-id uint))
    (let
        (
            (category (unwrap! (map-get? assessment-categories { category-id: category-id }) ERR_NOT_FOUND))
            (existing-link (map-get? assessment-category-links { assessment-id: assessment-id }))
        )
        (asserts! (is-none existing-link) ERR_ALREADY_EXISTS)
        (ok
            (map-insert assessment-category-links
                { assessment-id: assessment-id }
                {
                    category-id: category-id,
                    added-by: tx-sender,
                    timestamp: block-height
                }
            )
        )
    )
)

;; Create an assessment template
(define-public (create-template 
    (name (string-ascii 50))
    (description (string-ascii 200))
    (category-id uint)
    (required-score uint)
    (time-limit uint)
)
    (let
        ((template-id (var-get template-counter)))
        (ok
            (begin
                (map-insert assessment-templates
                    { template-id: template-id }
                    {
                        name: name,
                        description: description,
                        created-by: tx-sender,
                        category-id: category-id,
                        required-score: required-score,
                        time-limit: time-limit
                    })
                (var-set template-counter (+ template-id u1))
                template-id
            )
        )
    )
)
;; Create a new assessment category
(define-public (create-category (name (string-ascii 50)) (description (string-ascii 200)))
    (let
        ((category-id (var-get category-counter)))
        (ok
            (begin
                (map-insert assessment-categories
                    { category-id: category-id }
                    {
                        name: name,
                        description: description,
                        created-by: tx-sender
                    })
                (var-set category-counter (+ category-id u1))
                category-id
            )
        )
    )
)

;; Link an existing assessment to a category
(define-public (link-assessment-to-category (assessment-id uint) (category-id uint))
    (let
        (
            (category (unwrap! (map-get? assessment-categories { category-id: category-id }) ERR_NOT_FOUND))
            (existing-link (map-get? assessment-category-links { assessment-id: assessment-id }))
        )
        (asserts! (is-none existing-link) ERR_ALREADY_EXISTS)
        (ok
            (map-insert assessment-category-links
                { assessment-id: assessment-id }
                {
                    category-id: category-id,
                    added-by: tx-sender,
                    timestamp: block-height
                }
            )
        )
    )
)

;; Create an assessment template
(define-public (create-template 
    (name (string-ascii 50))
    (description (string-ascii 200))
    (category-id uint)
    (required-score uint)
    (time-limit uint)
)
    (let
        ((template-id (var-get template-counter)))
        (ok
            (begin
                (map-insert assessment-templates
                    { template-id: template-id }
                    {
                        name: name,
                        description: description,
                        created-by: tx-sender,
                        category-id: category-id,
                        required-score: required-score,
                        time-limit: time-limit
                    })
                (var-set template-counter (+ template-id u1))
                template-id
            )
        )
    )
)
;; Set prerequisites for an assessment
(define-public (set-prerequisites 
    (assessment-id uint)
    (required-assessments (list 10 uint))
    (required-badges (list 10 uint))
    (minimum-score uint)
)
    (ok
        (map-set assessment-prerequisites
            { assessment-id: assessment-id }
            {
                required-assessments: required-assessments,
                required-badges: required-badges,
                minimum-score: minimum-score
            }
        )
    )
)

;; Register as an institution
(define-public (register-institution (name (string-ascii 50)))
    (ok
        (map-insert verified-institutions
            { institution: tx-sender }
            {
                name: name,
                verification-date: block-height,
                status: "pending",
                verification-level: u1
            }
        )
    )
)
;; Get category details
(define-read-only (get-category-details (category-id uint))
    (map-get? assessment-categories { category-id: category-id })
)

;; Get template details
(define-read-only (get-template-details (template-id uint))
    (map-get? assessment-templates { template-id: template-id })
)

;; Check prerequisites for an assessment
(define-read-only (check-prerequisites (assessment-id uint) (student principal))
    (match (map-get? assessment-prerequisites { assessment-id: assessment-id })
        prerequisites (ok (verify-prerequisites prerequisites student))
        (ok true)  ;; If no prerequisites are set, return true
    )
)
;; Verify if a student meets prerequisites
(define-private (verify-prerequisites (prerequisites {
        required-assessments: (list 10 uint),
        required-badges: (list 10 uint),
        minimum-score: uint
    }) 
    (student principal)
)
    (and
        (verify-required-assessments (get required-assessments prerequisites) student)
        (verify-required-badges (get required-badges prerequisites) student)
    )
)

(define-private (verify-required-assessments (assessments (list 10 uint)) (student principal))
    (match (fold check-assessment-completion assessments true)
        result result
        false
    )
)

(define-private (verify-required-badges (badges (list 10 uint)) (student principal))
    (match (fold check-badge-ownership badges true)
        result result
        false
    )
)

(define-private (check-assessment-completion (assessment-id uint) (acc bool))
    (and 
        acc
        (match (contract-call? .skill-verification get-submission assessment-id tx-sender)
            submission (get passed submission)
            false
        )
    )
)

(define-private (check-badge-ownership (badge-id uint) (acc bool))
    (and
        acc
        (is-some (contract-call? .skill-verification get-student-badges tx-sender))
    )
)
