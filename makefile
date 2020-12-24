ARC=arm-none-eabi
CC=${ARC}-gcc
AS=${ARC}-gcc
LD=${ARC}-gcc
OBJCOPY=${ARC}-objcopy
OBJDUMP=${ARC}-objdump
SIZE=${ARC}-size

TARGET_ARCH = -mcpu=cortex-m4 -mthumb -mfloat-abi=hard -mfpu=fpv4-sp-d16

DRIVER=./Drivers/CMSIS/Device/ST/STM32F4xx/Source
HAL=./Drivers/STM32F4xx_HAL_Driver/Src
CORE=./Core/src
DEBUG=./Debug/SEGGER
RTOS= ./FreeRTOS/Source
BSP = ./Drivers/BSP/STM32F4xx-Nucleo

SOURCES:= $(wildcard $(CORE)/*.c) \
		 $(wildcard $(DEBUG)/*.c) $(wildcard $(DEBUG)/*.S) \
		 $(wildcard $(HAL)/*.c) \
		 $(wildcard $(DRIVER)/*.c) $(wildcard $(DRIVER)/startup_stm32f401xe.s) \
		 $(wildcard $(RTOS)/*.c) $(wildcard $(RTOS)/portable/GCC/ARM_CM4F/*.c) $(wildcard $(RTOS)/portable/MemMang/heap_3.c) \
		 $(wildcard $(BSP)/*.c)
		 
OBJECTS:= \
	$(patsubst %.c,%.o,$(patsubst %.S,%.o,$(patsubst %.s,%.o,$(SOURCES))))

INCLUDE= \
	-I ./Drivers/CMSIS/Core/Include \
	-I ./Drivers/CMSIS/Device/ST/STM32F4xx/Include \
	-I ./FreeRTOS/Source/include \
	-I ./FreeRTOS/Source/portable/GCC/ARM_CM4F \
	-I ./FreeRTOS/Source/portable/Common \
	-I ./Core/inc \
	-I ./Debug/SEGGER \
	-I ./Drivers/STM32F4xx_HAL_Driver/Inc \
	-I ./Drivers/BSP/STM32F4xx-Nucleo

LSCRIPT=STM32F401RETx_FLASH.ld

CFLAGS:=-Wall -g -O0 -DSTM32F401xE --specs=nosys.specs -ffreestanding\
		${TARGET_ARCH} \
		${INCLUDE}
ASFLAGS:=$(CFLAGS)
LDFLAGS:=-T $(LSCRIPT) -lc -lm --specs=nosys.specs $(TARGET_ARCH)


all: $(SOURCES) stm32f4.bin stm32f4.s stm32f4.srec

stm32f4.bin: stm32f4.elf
	$(OBJCOPY) -O binary $^ $@
	$(SIZE) $<

stm32f4.srec: stm32f4.elf
	$(OBJCOPY) -O srec $^ $@
	$(SIZE) $<

stm32f4.elf: $(OBJECTS) $(LSCRIPT)
	$(LD) $(LDFLAGS) $(OBJECTS) -o $@ 

%.o: %.c
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.S
	$(CC) -c $(CFLAGS) $< -o $@

%.o: %.s
	$(CC) -c $(CFLAGS) $< -o $@

stm32f4.s: stm32f4.elf
	$(OBJDUMP) --disassemble-all $< > $@

clean:
	rm -f stm32f4.bin stm32f4.elf stm32f4.map stm32f4.s ${OBJECTS}

.PHONY: all clean
