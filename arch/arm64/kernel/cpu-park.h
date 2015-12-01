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
void __attribute__((noreturn)) cpu_park(phys_addr_t park,
					unsigned long park_address,
					unsigned long el2_switch);
#endif
