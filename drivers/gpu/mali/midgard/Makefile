# SPDX-License-Identifier: GPL-2.0 WITH Linux-syscall-note
#
# (C) COPYRIGHT 2010-2021 ARM Limited. All rights reserved.
#
# This program is free software and is provided to you under the terms of the
# GNU General Public License version 2 as published by the Free Software
# Foundation, and any use by you of this program is subject to the terms
# of such GNU license.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program; if not, you can access it online at
# http://www.gnu.org/licenses/gpl-2.0.html.
#
#

KERNEL_SRC ?= "$(srctree)"
KDIR ?= $(KERNEL_SRC)
M ?= $(CURDIR)

ifeq ($(KDIR),)
    $(error Must specify KDIR to point to the kernel to target)
endif

ifeq ($(MALI_UNIT_TEST), 1)
EXTRA_SYMBOLS += $(KBASE_PATH_RELATIVE)/tests/internal/src/kernel_assert_module/linux/Module.symvers
endif

#
# Default configuration values
#
# Dependency resolution is done through statements as Kconfig
# is not supported for out-of-tree builds.
#

CONFIG_MALI_MIDGARD ?= m
ifeq ($(CONFIG_MALI_MIDGARD),m)
    CONFIG_MALI_GATOR_SUPPORT ?= y
    CONFIG_MALI_ARBITRATION ?= n
    CONFIG_MALI_PARTITION_MANAGER ?= n

    ifneq ($(CONFIG_MALI_NO_MALI),y)
        # Prevent misuse when CONFIG_MALI_NO_MALI=y
        CONFIG_MALI_REAL_HW ?= y
    endif

    ifeq ($(CONFIG_MALI_MIDGARD_DVFS),y)
        # Prevent misuse when CONFIG_MALI_MIDGARD_DVFS=y
        CONFIG_MALI_DEVFREQ ?= n
    else
        CONFIG_MALI_DEVFREQ ?= y
    endif

    ifeq ($(CONFIG_MALI_DMA_BUF_MAP_ON_DEMAND), y)
        # Prevent misuse when CONFIG_MALI_DMA_BUF_MAP_ON_DEMAND=y
        CONFIG_MALI_DMA_BUF_LEGACY_COMPAT = n
    endif

    ifeq ($(CONFIG_BSP_HAS_HYPERVISOR),y)
        ifneq ($(CONFIG_MALI_ARBITRATION), n)
            CONFIG_MALI_XEN ?= m
        endif
    endif

    #
    # Expert/Debug/Test released configurations
    #
    ifeq ($(CONFIG_MALI_EXPERT), y)
        ifeq ($(CONFIG_MALI_NO_MALI), y)
            CONFIG_MALI_REAL_HW = n
        else
            # Prevent misuse when CONFIG_MALI_NO_MALI=n
            CONFIG_MALI_REAL_HW = y
            CONFIG_MALI_ERROR_INJECT = n
        endif

        ifeq ($(CONFIG_MALI_HW_ERRATA_1485982_NOT_AFFECTED), y)
            # Prevent misuse when CONFIG_MALI_HW_ERRATA_1485982_NOT_AFFECTED=y
            CONFIG_MALI_HW_ERRATA_1485982_USE_CLOCK_ALTERNATIVE = n
        endif

        ifeq ($(CONFIG_MALI_DEBUG), y)
            CONFIG_MALI_MIDGARD_ENABLE_TRACE ?= y
            CONFIG_MALI_SYSTEM_TRACE ?= y

            ifeq ($(CONFIG_SYNC), y)
                CONFIG_MALI_FENCE_DEBUG ?= y
            else
                ifeq ($(CONFIG_SYNC_FILE), y)
                    CONFIG_MALI_FENCE_DEBUG ?= y
                else
                    CONFIG_MALI_FENCE_DEBUG = n
                endif
            endif
        else
            # Prevent misuse when CONFIG_MALI_DEBUG=n
            CONFIG_MALI_MIDGARD_ENABLE_TRACE = n
            CONFIG_MALI_SYSTEM_TRACE = n
            CONFIG_MALI_FENCE_DEBUG = n
        endif
    else
        # Prevent misuse when CONFIG_MALI_EXPERT=n
        CONFIG_MALI_CORESTACK = n
        CONFIG_MALI_2MB_ALLOC = n
        CONFIG_MALI_PWRSOFT_765 = n
        CONFIG_MALI_MEMORY_FULLY_BACKED = n
        CONFIG_MALI_JOB_DUMP = n
        CONFIG_MALI_NO_MALI = n
        CONFIG_MALI_REAL_HW = y
        CONFIG_MALI_ERROR_INJECT = n
        CONFIG_MALI_HW_ERRATA_1485982_NOT_AFFECTED = n
        CONFIG_MALI_HW_ERRATA_1485982_USE_CLOCK_ALTERNATIVE = n
        CONFIG_MALI_PRFCNT_SET_SELECT_VIA_DEBUG_FS = n
        CONFIG_MALI_DEBUG = y
        CONFIG_MALI_MIDGARD_ENABLE_TRACE = n
        CONFIG_MALI_SYSTEM_TRACE = n
        CONFIG_MALI_FENCE_DEBUG = n
    endif

    ifeq ($(CONFIG_MALI_DEBUG), n)
        CONFIG_MALI_KUTF ?= y
        ifeq ($(CONFIG_MALI_KUTF), y)
            CONFIG_MALI_KUTF_IRQ_TEST ?= y
            CONFIG_MALI_KUTF_CLK_RATE_TRACE ?= y
        else
            # Prevent misuse when CONFIG_MALI_KUTF=n
            CONFIG_MALI_KUTF_IRQ_TEST = n
            CONFIG_MALI_KUTF_CLK_RATE_TRACE = n
        endif
    else
        # Prevent misuse when CONFIG_MALI_DEBUG=n
        CONFIG_MALI_KUTF = n
        CONFIG_MALI_KUTF_IRQ_TEST = n
        CONFIG_MALI_KUTF_CLK_RATE_TRACE = n
    endif
else
    # Prevent misuse when CONFIG_MALI_MIDGARD=n
    CONFIG_MALI_ARBITRATION = n
    CONFIG_MALI_KUTF = n
    CONFIG_MALI_KUTF_IRQ_TEST = n
    CONFIG_MALI_KUTF_CLK_RATE_TRACE = n
endif

# All Mali CONFIG should be listed here
CONFIGS := \
    CONFIG_MALI_MIDGARD \
    CONFIG_MALI_CSF_SUPPORT \
    CONFIG_MALI_GATOR_SUPPORT \
    CONFIG_MALI_DMA_FENCE \
    CONFIG_MALI_ARBITER_SUPPORT \
    CONFIG_MALI_ARBITRATION \
    CONFIG_MALI_PARTITION_MANAGER \
    CONFIG_MALI_REAL_HW \
    CONFIG_MALI_GEM5_BUILD \
    CONFIG_MALI_DEVFREQ \
    CONFIG_MALI_MIDGARD_DVFS \
    CONFIG_MALI_DMA_BUF_MAP_ON_DEMAND \
    CONFIG_MALI_DMA_BUF_LEGACY_COMPAT \
    CONFIG_MALI_EXPERT \
    CONFIG_MALI_CORESTACK \
    CONFIG_MALI_2MB_ALLOC \
    CONFIG_MALI_PWRSOFT_765 \
    CONFIG_MALI_MEMORY_FULLY_BACKED \
    CONFIG_MALI_JOB_DUMP \
    CONFIG_MALI_NO_MALI \
    CONFIG_MALI_ERROR_INJECT \
    CONFIG_MALI_HW_ERRATA_1485982_NOT_AFFECTED \
    CONFIG_MALI_HW_ERRATA_1485982_USE_CLOCK_ALTERNATIVE \
    CONFIG_MALI_PRFCNT_SET_PRIMARY \
    CONFIG_MALI_PRFCNT_SET_SECONDARY \
    CONFIG_MALI_PRFCNT_SET_TERTIARY \
    CONFIG_MALI_PRFCNT_SET_SELECT_VIA_DEBUG_FS \
    CONFIG_MALI_DEBUG \
    CONFIG_MALI_MIDGARD_ENABLE_TRACE \
    CONFIG_MALI_SYSTEM_TRACE \
    CONFIG_MALI_FENCE_DEBUG \
    CONFIG_MALI_KUTF \
    CONFIG_MALI_KUTF_IRQ_TEST \
    CONFIG_MALI_KUTF_CLK_RATE_TRACE \
    CONFIG_MALI_XEN


#
# MAKE_ARGS to pass the custom CONFIGs on out-of-tree build
#
# Generate the list of CONFIGs and values.
# $(value config) is the name of the CONFIG option.
# $(value $(value config)) is its value (y, m).
# When the CONFIG is not set to y or m, it defaults to n.
MAKE_ARGS := $(foreach config,$(CONFIGS), \
                    $(if $(filter y m,$(value $(value config))), \
                        $(value config)=$(value $(value config)), \
                        $(value config)=n))

#
# EXTRA_CFLAGS to define the custom CONFIGs on out-of-tree build
#
# Generate the list of CONFIGs defines with values from CONFIGS.
# $(value config) is the name of the CONFIG option.
# When set to y or m, the CONFIG gets defined to 1.
EXTRA_CFLAGS := $(foreach config,$(CONFIGS), \
                    $(if $(filter y m,$(value $(value config))), \
                        -D$(value config)=1))

#
# KBUILD_EXTRA_SYMBOLS to prevent warnings about unknown functions
#

all:
	$(MAKE) -C $(KDIR) M=$(M) $(MAKE_ARGS) EXTRA_CFLAGS="$(EXTRA_CFLAGS)" KBUILD_EXTRA_SYMBOLS="$(EXTRA_SYMBOLS)" modules

modules_install:
	$(MAKE) -C $(KDIR) M=$(M) $(MAKE_ARGS) modules_install

clean:
	$(MAKE) -C $(KDIR) M=$(M) $(MAKE_ARGS) clean
