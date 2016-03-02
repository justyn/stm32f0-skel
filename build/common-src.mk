PROJECT=panel1642

# Compilation flags common to Tests and Target
COMMON_FLAGS += -DUSE_HAL_DRIVER
COMMON_FLAGS += -DSTM32F031x6

# Add all source directories, use trailing slash
SRCDIRS += ../src/
SRCDIRS += ../system/semihosting-cortexm-uos/src/
SRCDIRS += ../system/STM32F0xx_HAL_Driver/Src/
SRCDIRS += ../system/CMSIS_STM32F0/Device/ST/STM32F0xx/Source/Templates/

STARTUP_DIR = ../system/CMSIS_STM32F0/Device/ST/STM32F0xx/Source/Templates/gcc/
AS_SRCS = $(STARTUP_DIR)startup_$(STARTUP_FILE)

# Object dirs contain .o and .d files.
OBJDIRS += $(patsubst ../%/,%/,$(SRCDIRS))
OBJDIRS += $(patsubst ../%/,%/,$(STARTUP_DIR))
OBJDIRS += $(patsubst ../%/,%/,$(FREERTOS_MEMDIR))

# Find all sources
C_SRCS += $(wildcard $(addsuffix *.c,$(SRCDIRS)))
CXX_SRCS += $(wildcard $(addsuffix *.cpp,$(SRCDIRS)))

# Add all include directories
INCDIRS += ../system/CMSIS_STM32F0/Include
INCDIRS += ../system/CMSIS_STM32F0/Device/ST/STM32F0xx/Include
INCDIRS += ../system/STM32F0xx_HAL_Driver/Inc
INCDIRS += ../inc
INCDIRS += ../system/semihosting-cortexm-uos/inc
INCDIRS += ../system/FreeRTOS_STM32/Source/include
INCDIRS += ../system/FreeRTOS_STM32/Source/portable/GCC/ARM_CM0
INCDIRS += ../system/FreeRTOS_STM32/Source/CMSIS_RTOS

# Add library/linker script search paths
LIBDIRS += ../ldscripts

# Add libraries:
LDLIBS +=

