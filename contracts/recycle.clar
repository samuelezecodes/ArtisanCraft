;; ArtisanCraft Smart Contract - with Enhanced Security and Input Validation

;; Constants
(define-constant CONTRACT_OWNER tx-sender)
(define-constant ERR_UNAUTHORIZED (err u1))
(define-constant ERR_CRAFT_NOT_FOUND (err u2))
(define-constant ERR_INVALID_INPUT (err u3))
(define-constant ERR_CRAFT_ALREADY_EXISTS (err u4))
(define-constant ERR_INVALID_CONDITION (err u5))
(define-constant ERR_INVALID_POINTS (err u6))
(define-constant MAX_DESCRIPTION_LENGTH u128)
(define-constant MAX_ARTISAN_POINTS u1000000)
(define-constant CRAFTING_THRESHOLD u100)
(define-constant MAX_CRAFTS_PER_ARTISAN u1000)
(define-constant MIN_POINTS (to-int (- 0 (to-int MAX_ARTISAN_POINTS))))  ;; Fixed type conversion

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

;; Private functions
(define-private (is-contract-owner)
  (is-eq tx-sender CONTRACT_OWNER))

(define-private (get-and-increment-artisan-crafts (artisan principal))
  (let ((artisan-info (default-to { mastery: u0, crafts-count: u0 } (map-get? artisan-data artisan))))
    (if (< (get crafts-count artisan-info) MAX_CRAFTS_PER_ARTISAN)
      (let ((new-count (+ (get crafts-count artisan-info) u1)))
        (map-set artisan-data 
          artisan 
          (merge artisan-info { crafts-count: new-count }))
        new-count)
      u0)))

(define-private (is-valid-condition (condition (string-ascii 20)))
  (is-some (index-of (var-get valid-conditions) condition)))

(define-private (validate-condition (condition (string-ascii 20)))
  (if (is-valid-condition condition)
    (ok condition)
    ERR_INVALID_CONDITION))

(define-private (validate-points (points int))
  (if (and 
       (>= points MIN_POINTS)
       (<= points (to-int MAX_ARTISAN_POINTS)))
    (ok points)
    ERR_INVALID_POINTS))

(define-private (validate-artisan (artisan principal))
  (if (and 
       (is-some (map-get? artisan-data artisan))
       (not (is-eq artisan CONTRACT_OWNER)))
    (ok artisan)
    ERR_UNAUTHORIZED))

;; Public functions
(define-public (add-craft (description (string-ascii 128)))
  (let ((caller tx-sender)
        (craft-id (get-and-increment-artisan-crafts caller)))
    (if (is-eq craft-id u0)
      ERR_INVALID_INPUT
      (if (> (len description) MAX_DESCRIPTION_LENGTH)
        ERR_INVALID_INPUT
        (if (is-some (map-get? crafts {artisan: caller, id: craft-id}))
          ERR_CRAFT_ALREADY_EXISTS
          (begin
            (map-set crafts 
              {artisan: caller, id: craft-id}
              {description: description, condition: "listed"})
            (var-set total-crafts (+ (var-get total-crafts) u1))
            (ok craft-id)))))))

(define-public (update-craft-condition (craft-id uint) (new-condition (string-ascii 20)))
  (let ((caller tx-sender)
        (artisan-info (default-to { mastery: u0, crafts-count: u0 } (map-get? artisan-data caller))))
    (match (validate-condition new-condition)
      validated-condition
        (if (and (> craft-id u0) (<= craft-id (get crafts-count artisan-info)))
          (match (map-get? crafts {artisan: caller, id: craft-id})
            craft (begin
              (map-set crafts 
                {artisan: caller, id: craft-id}
                (merge craft {condition: validated-condition}))
              (ok true))
            ERR_CRAFT_NOT_FOUND)
          ERR_INVALID_INPUT)
      error error)))

(define-public (remove-craft (craft-id uint))
  (let ((caller tx-sender)
        (artisan-info (default-to { mastery: u0, crafts-count: u0 } (map-get? artisan-data caller))))
    (if (and (> craft-id u0) (<= craft-id (get crafts-count artisan-info)))
      (match (map-get? crafts {artisan: caller, id: craft-id})
        craft (begin
          (map-delete crafts {artisan: caller, id: craft-id})
          (var-set total-crafts (- (var-get total-crafts) u1))
          (map-set artisan-data 
            caller 
            (merge artisan-info { crafts-count: (- (get crafts-count artisan-info) u1) }))
          (ok true))
        ERR_CRAFT_NOT_FOUND)
      ERR_INVALID_INPUT)))

(define-public (update-mastery (artisan principal) (points int))
  (if (is-contract-owner)
    (match (validate-artisan artisan)
      validated-artisan
        (match (validate-points points)
          validated-points
            (let ((current-data (unwrap! (map-get? artisan-data validated-artisan) ERR_UNAUTHORIZED))
                  (new-mastery (+ (get mastery current-data) (to-uint validated-points))))
              (if (<= new-mastery MAX_ARTISAN_POINTS)
                (begin
                  (map-set artisan-data 
                    validated-artisan 
                    (merge current-data { mastery: new-mastery }))
                  (ok new-mastery))
                ERR_INVALID_INPUT))
          error error)
      error error)
    ERR_UNAUTHORIZED))

;; Read-only functions
(define-read-only (get-craft (artisan principal) (craft-id uint))
  (map-get? crafts {artisan: artisan, id: craft-id}))

(define-read-only (get-artisan-data (artisan principal))
  (default-to { mastery: u0, crafts-count: u0 } (map-get? artisan-data artisan)))

(define-read-only (get-total-crafts)
  (ok (var-get total-crafts)))

(define-read-only (can-perform-craft (artisan principal))
  (>= (get mastery (get-artisan-data artisan)) CRAFTING_THRESHOLD))

(define-read-only (get-valid-conditions)
  (ok (var-get valid-conditions)))