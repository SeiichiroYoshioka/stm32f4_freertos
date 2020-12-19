#include "stm32f401xe.h"
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