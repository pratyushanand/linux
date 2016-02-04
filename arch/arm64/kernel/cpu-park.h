/*
 * cpu park routines
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License version 2 as
 * published by the Free Software Foundation.
 */

#if !defined(_ARM64_CPU_PARK_H)
#define _ARM64_CPU_PARK_H

#include <asm/virt.h>

void __attribute__((noreturn)) __cpu_park(unsigned long park_address,
					unsigned long el2_switch);
static inline void __noreturn cpu_park(unsigned long park_address)
{
	typeof(__cpu_park) *park;

	park = (void *)__pa_symbol(__cpu_park);

	cpu_install_idmap();
	park(park_address, !is_kernel_in_hyp_mode() && is_hyp_mode_available());
	unreachable();
}

#endif
