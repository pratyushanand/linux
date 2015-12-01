/*
 * cpu park routines
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#include <linux/linkage.h>
#include <asm/assembler.h>
#include <asm/sysreg.h>
#include <asm/virt.h>

.text
.pushsection 	.idmap.text, "ax"

.align 5

/*
 * cpu_park(__cpu_park, park_address, el2_switch) - perform cpu park operation
 *
 * @__cpu_park: Physical address of the __cpu_park routine.
 * @park_address - where cpu will keep on looking for address to jump
 * @el2_switch: Flag to indicate a swich to EL2 is needed, passed to cpu_park.
 *
 */

ENTRY(cpu_park)
	mov	x18, x0				// __cpu_park
	mov	x0, x1				// park_address
	mov	x1, x2				// el2_switch
	ret	x18
ENDPROC(cpu_park)

/*
 * __cpu_park(park_address, el2_switch) - Helper for cpu_park
 *
 * @park_address - where cpu will keep on looking for address to jump
 * @el2_switch: Flag to indicate a swich to EL2 is needed, passed to cpu_park.
 *
 * Put the CPU into the wfe and check for valid none zero secondary address
 * at parked address when a event is received. If secondary address is
 * valid then jump to it.
 */

ENTRY(__cpu_park)
	/* Clear sctlr_el1 flags. */
	mrs	x12, sctlr_el1
	ldr	x13, =SCTLR_ELx_FLAGS
	bic	x12, x12, x13
	msr	sctlr_el1, x12
	isb
	mov	x2, 0
	str	x2, [x0]
1:
	wfe
	ldr	x1, [x0]
	cmp	x1, #0
	b.eq	1b

	mov	x2, 0
	str	x2, [x0]

	cbz	x1, 2f				// el2_switch?

	mov	x0, x1				// entry
	hvc	#HVC_CALL_FUNC			// no return

2:
	ret	x1

ENDPROC(__cpu_park)

.popsection
