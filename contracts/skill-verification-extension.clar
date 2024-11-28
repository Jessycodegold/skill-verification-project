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
