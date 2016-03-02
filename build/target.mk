# Target startup and linker
STARTUP_FILE := stm32f031x6.s
LDSCRIPTS += STM32F031G6_FLASH.ld

# Compilation flags common to .c .cpp and .s files 
COMMON_FLAGS += -mcpu=cortex-m0
COMMON_FLAGS += -mthumb -fmessage-length=0 -fsigned-char -ffunction-sections
COMMON_FLAGS += -fdata-sections -Wall -Wextra -g3

# Disable some specific warnings:
COMMON_FLAGS += -Wno-unused-parameter

# Linker options (g++ used for linking, so Xlinker for arguments straight to ld)
LDFLAGS := -Xlinker --gc-sections --specs=nano.specs

# Disable startup files (comment out to allow startup files)
LDFLAGS += -nostartfiles
COMMON_FLAGS += -DLD_NOSTARTFILES # for conditional code based on startup files

# Language-specific compiler flags
CFLAGS += -MMD -MP -std=gnu11
CXXFLAGS += -MMD -MP -fabi-version=0 -fno-exceptions -fno-rtti -fno-use-cxa-atexit -fno-threadsafe-statics
ASFLAGS += -x assembler-with-cpp

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
