;;! target = "x86_64"

(module
    (func (result f64)
        (local f32)  

        (local.get 0)
        (f64.promote_f32)
    )
)
;;      	 55                   	push	rbp
;;      	 4889e5               	mov	rbp, rsp
;;      	 4c8b5f08             	mov	r11, qword ptr [rdi + 8]
;;      	 4d8b1b               	mov	r11, qword ptr [r11]
;;      	 4981c318000000       	add	r11, 0x18
;;      	 4939e3               	cmp	r11, rsp
;;      	 0f8729000000         	ja	0x44
;;   1b:	 4989fe               	mov	r14, rdi
;;      	 4883ec18             	sub	rsp, 0x18
;;      	 48897c2410           	mov	qword ptr [rsp + 0x10], rdi
;;      	 4889742408           	mov	qword ptr [rsp + 8], rsi
;;      	 48c7042400000000     	mov	qword ptr [rsp], 0
;;      	 f30f10442404         	movss	xmm0, dword ptr [rsp + 4]
;;      	 f30f5ac0             	cvtss2sd	xmm0, xmm0
;;      	 4883c418             	add	rsp, 0x18
;;      	 5d                   	pop	rbp
;;      	 c3                   	ret	
;;   44:	 0f0b                 	ud2	