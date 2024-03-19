;;! target = "s390x"
;;! test = "compile"
;;! flags = " -C cranelift-enable-heap-access-spectre-mitigation=false -O static-memory-forced -O static-memory-guard-size=0 -O dynamic-memory-guard-size=0"

;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
;; !!! GENERATED BY 'make-load-store-tests.sh' DO NOT EDIT !!!
;; !!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!

(module
  (memory i32 1)

  (func (export "do_store") (param i32 i32)
    local.get 0
    local.get 1
    i32.store8 offset=0x1000)

  (func (export "do_load") (param i32) (result i32)
    local.get 0
    i32.load8_u offset=0x1000))

;; function u0:0:
;;   lg %r1, 8(%r2)
;;   lg %r1, 0(%r1)
;;   clgrtle %r15, %r1
;;   unwind DefineNewFrame { offset_upward_to_caller_sp: 160, offset_downward_to_clobbers: 0 }
;;   unwind StackAlloc { size: 0 }
;; block0:
;;   llgfr %r4, %r4
;;   clgfi %r4, 4294963199
;;   jgh label3 ; jg label1
;; block1:
;;   ag %r4, 80(%r2)
;;   lghi %r3, 4096
;;   stc %r5, 0(%r3,%r4)
;;   jg label2
;; block2:
;;   br %r14
;; block3:
;;   .word 0x0000 # trap=heap_oob
;;
;; function u0:1:
;;   lg %r1, 8(%r2)
;;   lg %r1, 0(%r1)
;;   clgrtle %r15, %r1
;;   unwind DefineNewFrame { offset_upward_to_caller_sp: 160, offset_downward_to_clobbers: 0 }
;;   unwind StackAlloc { size: 0 }
;; block0:
;;   llgfr %r4, %r4
;;   clgfi %r4, 4294963199
;;   jgh label3 ; jg label1
;; block1:
;;   ag %r4, 80(%r2)
;;   lghi %r3, 4096
;;   llc %r2, 0(%r3,%r4)
;;   jg label2
;; block2:
;;   br %r14
;; block3:
;;   .word 0x0000 # trap=heap_oob