;; ArtisanCraft Smart Contract - with Enhanced Input Validation

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_CRAFT_NOT_FOUND (err u2))
(define-constant ERR_INVALID_INPUT (err u3))
(define-constant ERR_CRAFT_ALREADY_EXISTS (err u4))
(define-constant ERR_INVALID_CONDITION (err u5))
(define-constant MAX_DESCRIPTION_LENGTH u128)
(define-constant MAX_ARTISAN_POINTS u1000000)
(define-constant CRAFTING_THRESHOLD u100)
(define-constant MAX_CRAFTS_PER_ARTISAN u1000)

;; Valid craft conditions
(define-data-var valid-conditions (list 5 (string-ascii 20)) (list "listed" "commissioned" "completed" "restoring" "archived"))

;; Data variables
(define-data-var total-crafts uint u0)

;; Data maps
(define-map crafts 
  { artisan: principal, id: uint } 
  { description: (string-ascii 128), condition: (string-ascii 20) })
(define-map artisan-data
  principal
  { mastery: uint, crafts-count: uint })


(define-read-only (get-total-crafts)
  (ok (var-get total-crafts)))

(define-read-only (can-perform-craft (artisan principal))
  (>= (get mastery (get-artisan-data artisan)) CRAFTING_THRESHOLD))

(define-read-only (get-valid-conditions)
  (ok (var-get valid-conditions)))