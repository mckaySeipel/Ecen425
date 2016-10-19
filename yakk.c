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

unsigned int YKIdleCount = 0;
unsigned int taskCount = 0;

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
	for(i = 0 ; i < 8; i++)
	{
		tasks[taskCount].stack_pointer--;
		//all registers should be set to 0
		*(tasks[taskCount].stack_pointer) = SIXTEEN_BIT_ZERO;
	}
}

//create a new task
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority){
	YKEnterMutex();
	tasks[taskCount] . stack_pointer = (int*)taskStack;
	tasks[taskCount] . ready = READY;
	tasks[taskCount] . delay_count = 0;
	tasks[taskCount] . priority = priority;
	InitStack(*task);
	taskCount++;
	YKExitMutex();
	if (running){
		YKScheduler();
	}
}

//run the idle task
void YKIdleTask(){
	while(1){
		YKEnterMutex();
		YKIdleCount++;
		YKExitMutex();
	}
}

//start the kernel
void YKRun(){
	YKEnterMutex();
	running = 1;
	YKExitMutex();
	printString("Running...\n");
	YKScheduler();
}

//delay
void YKDelayTask(unsigned delay){
	YKEnterMutex();
	tasks[currIndex].ready = DELAY;
	tasks[currIndex].delay_count = delay;
	YKExitMutex();
	YKScheduler();
}

//the scheduler
void YKScheduler(){
	//looping variable
	int i;
	//index of highest priority task to run
	int index = 0;
	int local_currIndex;
	YKEnterMutex();
	local_currIndex = currIndex;
	//printString("Scheduling...\n");
	//find the highest priority task and run it
	for (i = 1; i < taskCount; i++) {
		//if the the task is ready, and if the priority is greater than the previous
		if(tasks[i].ready == READY && tasks[i].priority < tasks[index].priority) {
			//set our new task to current index				
			index = i;		
		}
	}
	currIndex = index;
	YKExitMutex();
	//printString("Task index: ");
	//printInt(index);
	//printString("\n");
	YKDispatcher(tasks[index].stack_pointer, &(tasks[local_currIndex]));
}


void YKEnterISR(){
	interrupt_depth++;
}

void YKExitISR(){
	if(--interrupt_depth == 0){
		YKScheduler();
	}
}



extern int KeyBuffer;

void YKTickHandler()
{
	//static int tick = 0;
	//this will be the handler for the tick
	int i;	//looping variable
	printNewLine();            // Print carriage return and line feed
	printString("TICK ");      	 // Print string
	printInt(YKTickNum);
	printNewLine();            // Print carriage return and line feed
	//increment the ticks
	YKEnterMutex();
	YKTickNum++;
	for(i = 0; i< taskCount; i++) {
		if (tasks[i] . delay_count != 0) {
			tasks[i] . delay_count--;
			if (tasks[i] . delay_count == 0) {
				tasks[i] . ready = READY;
			}
		}
	}
	YKExitMutex();
}

void isrHandle_reset()
{
	//this will be the handler for the reset
	exit(0);
}



void isrHandle_keyPress()
{
	int i = 0;
	//this will be the handler for the tick
	if(KeyBuffer != 'd')
	{
		printNewLine();            // Print carriage return and line feed
		printString("KEYPRESS (");      	 // Print string
		printChar(KeyBuffer);
		printString(") IGNORED");      	 // Print string
		printNewLine();            // Print carriage return and line feed
		return;
	}

	printNewLine();            // Print carriage return and line feed
	printString("DELAY KEY PRESSED");      	 // Print string
	printNewLine();            // Print carriage return and line feed


	for(i = 0; i < 5000; i++)
	{
		//do nothing
	}

	return;
}

