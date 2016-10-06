#define TASK_NUMBER 4
#define FLAG_VALUE	0x200
#define SIXTEEN_BIT_ZERO	0x0000	

#include "yakk.h"
#include "clib.h"

#define IDLE_STACK_SIZE 256

int IdleStk[IDLE_STACK_SIZE];           /* Space for each task's stack */


task_t tasks[TASK_NUMBER];
int running = 0;
int* currTask;
int currIndex = 0;
int YKTickNum = 0;

int YKIdleCount = 0;
unsigned int taskCount = 0;

int tick = 0;

unsigned int interrupt_depth = 0;
unsigned int YKCtxSwCount;

//Initialize
void YKInitialize(){
	YKNewTask(*YKIdleTask, (void *)&IdleStk[IDLE_STACK_SIZE], 255);	
	YKCtxSwCount = 0;
}

//init the stack
void InitStack(void (*task)(void))
{
	int i;
	int* base_pointer;
	base_pointer = tasks[taskCount].stack_pointer;
	//set the flags' values
	tasks[taskCount].stack_pointer--;
	*(tasks[taskCount].stack_pointer) = FLAG_VALUE;
	tasks[taskCount].stack_pointer--;
	//set code segment to 0
	*(tasks[taskCount].stack_pointer) = SIXTEEN_BIT_ZERO;
	//set instruction pointer
	tasks[taskCount].stack_pointer--;
	*(tasks[taskCount].stack_pointer) = (int)task;
	tasks[taskCount].stack_pointer--;
	*(tasks[taskCount].stack_pointer) = (int) base_pointer;
	for(i = 0 ; i < 7; i++)
	{
		tasks[taskCount].stack_pointer--;
		//all registers should be set to 0
		*(tasks[taskCount].stack_pointer) = SIXTEEN_BIT_ZERO;
	}
}

//create a new task
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){
	tasks[taskCount] . stack_pointer = (int*)taskStack;
	tasks[taskCount] . ready = READY;
	tasks[taskCount] . delay_count = 0;
	tasks[taskCount] . priority = priority;
	InitStack(*task);
	taskCount++;
	if (running){
		YKScheduler();
	}
}

//run the idle task
void YKIdleTask(){
	while(1){
		YKIdleCount++;
		NoOp(); NoOp();
	}
}

//start the kernel
void YKRun(){
	running = 1;
	printString("Running...\n");
	YKScheduler();
}

//delay
void YKDelayTask(unsigned delay){
	tasks[currIndex].ready = DELAY;
	tasks[currIndex].delay_count = delay;
	YKScheduler();
}

//the scheduler
void YKScheduler(){
	//looping variable
	int i;
	//index of highest priority task to run
	int index = 0;
	int local_currIndex;
	local_currIndex = currIndex;
	printString("Scheduling...\n");
	//find the highest priority task and run it
	for (i = 1; i < taskCount; i++) {
		//if the the task is ready, and if the priority is greater than the previous
		if(tasks[i].ready == READY && tasks[i].priority < tasks[index].priority) {
			//set our new task to current index				
			index = i;		
		}
	}
	currIndex = index;
	printString("Task index: ");
	printInt(index);
	printString("\n");
	YKDispatcher(tasks[index].stack_pointer, &(tasks[local_currIndex]));
}


void YKTickHandler(){
	int i;	//looping variable
	//enter ISR
	YKEnterISR();
	//increment the ticks
	YKTickNum++;
	
	for(i = 0; i< taskCount; i++) {
		if (tasks[i] . delay_count != 0) {
			tasks[i] . delay_count--;
		}
	}
	//leave ISR
	YKExitISR();
}

void isrHandle_tick()
{
	//static int tick = 0;
	//this will be the handler for the tick
	printNewLine();            // Print carriage return and line feed
	printString("TICK ");      	 // Print string
	printInt(tick);
	tick++;
	printNewLine();            // Print carriage return and line feed
	return;
}


