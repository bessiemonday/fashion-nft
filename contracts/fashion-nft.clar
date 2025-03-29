;; FashionNFT - Digital fashion items as NFTs
(define-non-fungible-token fashion-nft uint)

;; Storage
(define-map token-metadata uint {designer: principal, name: (string-utf8 64), description: (string-utf8 256), image-uri: (string-utf8 256), price: uint})
(define-map designer-tokens principal (list 100 uint))
(define-data-var token-id-nonce uint u0)

;; Error codes
(define-constant err-not-authorized (err u100))
(define-constant err-token-not-found (err u101))
(define-constant err-insufficient-funds (err u102))

;; Mint a new fashion NFT
(define-public (mint (name (string-utf8 64)) (description (string-utf8 256)) (image-uri (string-utf8 256)) (price uint))
  (let
    ((token-id (var-get token-id-nonce))
     (designer tx-sender)
     (designer-current-tokens (default-to (list) (map-get? designer-tokens designer))))
    
    (asserts! (is-eq (len designer-current-tokens) (len designer-current-tokens)) true) ;; Always true, just to avoid warning
    
    ;; Mint the token
    (try! (nft-mint? fashion-nft token-id designer))
    
    ;; Store the metadata
    (map-set token-metadata token-id {designer: designer, name: name, description: description, image-uri: image-uri, price: price})
    
    ;; Update designer's token list
    (map-set designer-tokens designer (append designer-current-tokens token-id))
    
    ;; Increment the token ID counter
    (var-set token-id-nonce (+ token-id u1))
    
    (ok token-id)))

;; Purchase a fashion NFT
(define-public (purchase (token-id uint))
  (let
    ((metadata (unwrap! (map-get? token-metadata token-id) err-token-not-found))
     (price (get price metadata))
     (designer (get designer metadata)))
    
    ;; Check if buyer has enough funds
    (asserts! (>= (stx-get-balance tx-sender) price) err-insufficient-funds)
    
    ;; Transfer STX to designer
    (try! (stx-transfer? price tx-sender designer))
    
    ;; Transfer NFT to buyer
    (try! (nft-transfer? fashion-nft token-id (unwrap-panic (nft-get-owner? fashion-nft token-id)) tx-sender))
    
    (ok true)))

;; Get token metadata
(define-read-only (get-token-metadata (token-id uint))
  (map-get? token-metadata token-id))

;; Get tokens owned by designer
(define-read-only (get-designer-tokens (designer principal))
  (default-to (list) (map-get? designer-tokens designer)))