#include "stm32f401xe.h"
#include "stm32f4xx_hal_def.h"
#include "stm32f4xx_nucleo.h"
#include "FreeRTOS.h"
#include "task.h"
#include "queue.h"
#include "SEGGER_RTT.h"

void prvSetupHardware(void);
void prvTaskA(void *pvParameters);
void prvTaskB(void *pvParameters);
void taskInit(void);

void prvSetupHardware(void)
{
    if ( HAL_OK == HAL_Init() ) {
        SEGGER_RTT_printf(0,"HAL OK\n");
    }
    else {
        SEGGER_RTT_printf(0,"HAL Error\n");      
    }
    Led_TypeDef led_init = LED2;
    BSP_LED_Init(led_init);

    return;
}

void prvTaskA(void *pvParameters)
{
    while(1) {
        SEGGER_RTT_printf(0,"TaskA\n");
    }
}

void prvTaskB(void *pvParameters)
{
    while(1) {
        SEGGER_RTT_printf(0,"TaskB\n");
    }
}

void taskInit(void)
{
    xTaskCreate(prvTaskA, (signed portCHAR *)"TaskA", 192, NULL, 1, NULL);
    xTaskCreate(prvTaskB, (signed portCHAR *)"TaskB", 192, NULL, 1, NULL);
}
int main(void)
{
    prvSetupHardware();
    taskInit();
    vTaskStartScheduler();
    while (1) {

    }
    return 0;
}