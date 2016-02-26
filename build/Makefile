PROJECT=panel1642

# In debug mode the suffix _debug is added to targets and objects to prevent contamination.
ifeq ($(MODE),DEBUG)
	SUFFIX=_debug
else
	SUFFIX=
endif

# Add suffix to create target name
TARGET:=$(PROJECT)$(SUFFIX)

# Hardware-specific settings
include hw-settings.mk

# Path to toolchain binaries, or blank to use system path
TOOLPATH:=

# Add all source directories, use trailing slash
SRCDIRS :=
SRCDIRS += ../src/
SRCDIRS += ../system/semihosting-cortexm-uos/src/
SRCDIRS += ../system/STM32F0xx_HAL_Driver/Src/
SRCDIRS += ../system/CMSIS_STM32F0/Device/ST/STM32F0xx/Source/Templates/

# Assembly startup file for MCU, specified in hw-settings.mk
STARTUP_DIR = ../system/CMSIS_STM32F0/Device/ST/STM32F0xx/Source/Templates/gcc/
AS_SRCS = $(STARTUP_DIR)startup_$(STARTUP_FILE)

# Object dirs contain .o and .d files.
OBJDIRS := $(patsubst ../%/,%/,$(SRCDIRS))
OBJDIRS += $(patsubst ../%/,%/,$(STARTUP_DIR))
OBJDIRS += $(patsubst ../%/,%/,$(FREERTOS_MEMDIR))

# Find all sources
C_SRCS := $(wildcard $(addsuffix *.c,$(SRCDIRS)))
CXX_SRCS := $(wildcard $(addsuffix *.cpp,$(SRCDIRS)))

# Add all include directories
INCDIRS :=
INCDIRS += ../system/CMSIS_STM32F0/Include
INCDIRS += ../system/CMSIS_STM32F0/Device/ST/STM32F0xx/Include
INCDIRS += ../system/STM32F0xx_HAL_Driver/Inc
INCDIRS += ../inc
INCDIRS += ../system/semihosting-cortexm-uos/inc

# Add library/linker script search paths
LIBDIRS := ../ldscripts

# Add libraries:
LDLIBS :=

# Compilation flags common to .c .cpp and .s files 
COMMON_FLAGS := -mthumb -fmessage-length=0 -fsigned-char -ffunction-sections
COMMON_FLAGS += -fdata-sections -Wall -Wextra -g3
COMMON_FLAGS += -std=gnu99
COMMON_FLAGS += -DUSE_HAL_DRIVER
COMMON_FLAGS += $(HWFLAGS) # add hardware settings (from hw-settings.mk)

# Disable some specific warnings:
COMMON_FLAGS += -Wno-unused-parameter

# Linker options (g++ used for linking, so Xlinker for arguments straight to ld)
LDFLAGS := -Xlinker --gc-sections --specs=nano.specs

# Disable startup files (comment out to allow startup files)
LDFLAGS += -nostartfiles
COMMON_FLAGS += -DLD_NOSTARTFILES # for conditional code based on startup files

# Language-specific compiler flags
CFLAGS := -MMD -MP
CXXFLAGS := -MMD -MP -fabi-version=0 -fno-exceptions -fno-rtti -fno-use-cxa-atexit -fno-threadsafe-statics
ASFLAGS := -x assembler-with-cpp

# Set up debug specific options
ifeq ($(MODE),DEBUG)
	COMMON_FLAGS += -DDEBUG -DUSE_FULL_ASSERT -DTRACE -DOS_USE_TRACE_SEMIHOSTING_DEBUG -Og
	COMMON_FLAGS += -DUDEBUG_LEVEL=2
	CFLAGS +=
	CXXFLAGS +=
	LDFLAGS+= --specs=rdimon.specs # rdimon.specs needed for semihosting
else
	COMMON_FLAGS += -DUDEBUG_LEVEL=0 -O3 -flto
	CFLAGS += 
	CXXFLAGS +=
	LDFLAGS +=
endif

# Add in all the common flags
CFLAGS += $(COMMON_FLAGS)
CXXFLAGS += $(COMMON_FLAGS)
ASFLAGS += $(COMMON_FLAGS)

# Compilation rules set up here
include arm-gcc-buildtree.mk

# Custom rules for programming and debugging
include programming.mk
