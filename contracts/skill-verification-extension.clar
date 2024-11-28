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
