CFLAGS :=
CXXFLAGS :=
ASFLAGS :=
COMMON_FLAGS :=
SRCDIRS :=
OBJDIRS :=
C_SRCS :=
CXX_SRCS :=
INCDIRS :=
LIBDIRS :=
LDLIBS :=
LDSCRIPTS :=


# Local environment settings
include env-settings.mk

# Source paths and flags common for both Tests and Target
include common-src.mk

# Paths and flags for running on Target (rather than Testing locally)
include target.mk

# Target compilation rules set up here
include arm-gcc-buildtree.mk

# Custom rules for programming and debugging
include programming.mk
