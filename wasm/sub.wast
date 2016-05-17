(module
  (memory 1 1)
  (func $sub
    (param $a i64)
    (param $b i64)
    (param $c i64)
    (param $d i64)

    (param $a1 i64)
    (param $b1 i64)
    (param $c1 i64)
    (param $d1 i64)

    (local $carry i32)

    (param $memIndex i32)
    (result i64)

    ;; a
    (set_local $carry (i64.lt_u (get_local $a) (get_local $a1)))
    (set_local $a (i64.sub (get_local $a) (get_local $a1)))
  
    ;; b
    ;; add carry; use a1 as a temp var 
    (set_local $a1 (i64.sub (get_local $b) (i64.extend_u/i32 (get_local $carry))))
    ;; check for overflow
    (set_local $carry (i64.gt_u (get_local $a1) (get_local $b)))
    (set_local $b (i64.sub (get_local $a1) (get_local $b1)))
    (set_local $carry (i32.or (i64.gt_u (get_local $b) (get_local $a1)) (get_local $carry)))

    ;; c
    ;; add carry
    (set_local $a1 (i64.sub (get_local $c) (i64.extend_u/i32 (get_local $carry))))
    ;; check for overflow
    (set_local $carry (i64.gt_u (get_local $a1) (get_local $c)))
    (set_local $c (i64.sub (get_local $a1) (get_local $c1)))
    (set_local $carry (i32.or (i64.gt_u (get_local $c) (get_local $a1)) (get_local $carry)))

    ;; d
    (set_local $d (i64.sub (i64.sub (get_local $d) (i64.extend_u/i32 (get_local $carry))) (get_local $d1)))

    ;; add section done
    (i64.store (i32.const 0) (get_local $a))
    (i64.store (i32.const 8) (get_local $b))
    (i64.store (i32.const 16) (get_local $c))
    (i64.store (i32.const 24) (get_local $d))
    (i64.load  (get_local $memIndex))
  )

  (export "sub" $sub)
)

;; test subtract 2^256 - 2^256  
(assert_return (invoke "sub" (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 0)) (i64.const 0))
(assert_return (invoke "sub" (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 8)) (i64.const 0))
(assert_return (invoke "sub" (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 16)) (i64.const 0))
(assert_return (invoke "sub" (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 24)) (i64.const 0))

;; test adding up to the max interger 0 - 2^256
(assert_return (invoke "sub" (i64.const 0) (i64.const 0) (i64.const 0) (i64.const 0) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 0)) (i64.const 1))
(assert_return (invoke "sub" (i64.const 0) (i64.const 0) (i64.const 0) (i64.const 0) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 8)) (i64.const 0))
(assert_return (invoke "sub" (i64.const 0) (i64.const 0) (i64.const 0) (i64.const 0) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 16)) (i64.const 0))
(assert_return (invoke "sub" (i64.const 0) (i64.const 0) (i64.const 0) (i64.const 0) (i64.const -1) (i64.const -1) (i64.const -1) (i64.const -1) (i32.const 24)) (i64.const 0))
