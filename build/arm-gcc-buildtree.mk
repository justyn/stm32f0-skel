# Requires the following variables to exist:
#  PROJECT
#  SUFFIX
#  TARGET
#  LDLIBS
#  LDSCRIPTS
#  LIBDIRS
#  SRCDIRS
#  INCDIRS
#  CFLAGS
#  CXXFLAGS
#  LDFLAGS
# C_SRCS
# CXX_SRCS
# AS_SRCS

# Objects will be in mirrored folder tree in build folder
OBJS := $(patsubst ../%.c,%$(SUFFIX).o,$(C_SRCS))
OBJS += $(patsubst ../%.cpp,%$(SUFFIX).o,$(CXX_SRCS))
OBJS += $(patsubst ../%.s,%$(SUFFIX).o,$(AS_SRCS))

# Define rm command
RM := rm -f

AS=$(TOOLPATH)arm-none-eabi-as
CC=$(TOOLPATH)arm-none-eabi-gcc
CXX=$(TOOLPATH)arm-none-eabi-g++
NM=$(TOOLPATH)arm-none-eabi-nm
OBJCOPY=$(TOOLPATH)arm-none-eabi-objcopy
OBJDUMP=$(TOOLPATH)arm-none-eabi-objdump
SIZE=$(TOOLPATH)arm-none-eabi-size

# Add include search paths
CFLAGS += $(patsubst %,-I%,$(INCDIRS))
CXXFLAGS += $(patsubst %,-I%,$(INCDIRS))

# Add library/linker script search paths
LDFLAGS += $(patsubst %,-L%,$(LIBDIRS))

# Add libraries
LDFLAGS += $(patsubst %,-l%,$(LDLIBS))

# Add linker scripts
LDFLAGS += $(patsubst %,-T%,$(LDSCRIPTS))

# Source files are in parent directory
VPATH=../

all: dirs $(TARGET).elf $(TARGET).hex $(TARGET).bin dump size

# Include dependencies
-include $(OBJS:.o=.d)

%$(SUFFIX).o: %.c
	@echo 'Building C file: $<'
	$(CC) $(CFLAGS) -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo ' '
	
%$(SUFFIX).o: %.cpp
	@echo 'Building C++ file: $<'
	$(CXX) $(CXXFLAGS) -MF"$(@:%.o=%.d)" -MT"$@" -c -o "$@" "$<"
	@echo ' '
	
%$(SUFFIX).o: %.s
	@echo 'Compiling assembly file: $<'
	$(CC) $(ASFLAGS) -c -o "$@" "$<"
	@echo ' '

$(TARGET).elf: $(OBJS) $(USER_OBJS)
	@echo 'Building target: $@'
	@echo 'Invoking: Cross ARM C++ Linker'
	$(CXX) $(CXXFLAGS) $(LDFLAGS) -Wl,-Map,"$(TARGET).map" -o "$(TARGET).elf" $(OBJS) $(USER_OBJS) $(LIBS)
	@echo 'Finished building target: $@'
	@echo ' '

$(TARGET).hex: $(TARGET).elf
	@echo 'Invoking: Cross ARM GNU Create Flash Image'
	$(OBJCOPY) -O ihex "$(TARGET).elf"  "$(TARGET).hex"
	@echo 'Finished building: $@'
	@echo ' '
	
$(TARGET).bin: $(TARGET).elf
	@echo 'Invoking: Cross ARM GNU Create Binary'
	$(OBJCOPY) -O binary "$(TARGET).elf"  "$(TARGET).bin"
	@echo 'Finished building: $@'
	@echo ' '
	
%.lss: %.elf
	@echo 'Creating disassembly with objdump in: $@'
	$(OBJDUMP) -h -r -C -S $< > $@ 
	
dump: $(TARGET).lss

size: $(TARGET).elf
	@echo 'Invoking: Cross ARM GNU Print Size'
	$(SIZE) --format=berkeley "$(TARGET).elf"
	@echo ' '
	
clean:
	-$(RM) $(wildcard $(addsuffix *.o,$(OBJDIRS))) $(wildcard $(addsuffix *.d,$(OBJDIRS)))
	-$(RM) *.elf *.hex *.bin *.map
	-@echo ' '
	
version:
	$(CC) --version
	
# Create required object directory tree.
#  This will always be done regardless of whether directories already exist (unfortunately).
dirs:
	mkdir -p $(OBJDIRS)

.PHONY: all clean dump size dirs

