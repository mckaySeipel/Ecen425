
#ifndef YAKK_H
#define YAKK_H


/////////////////////////////
/////Written in Assembly/////
/////////////////////////////



typedef enum{
	READY,
	DELAY
}ready_state_t;

//TCB
typedef struct {
		int * stack_pointer;
		ready_state_t ready;
		int delay_count;
		unsigned char priority;
	} task_t;

extern unsigned int YKCtxSwCount;
extern unsigned int YKIdleCount;

void YKEnterMutex();
void YKExitMutex();
void YKDispatcher(int * sp, task_t * tcb);
void saveContext();
void restoreContext();
void NoOp();
//increment the depth of isr calls
void YKEnterISR();
//decrement the depth of isr calls, call schedular if last isr
void YKExitISR();


//Initialize
void YKInitialize();
//init the stack
void InitStack(void (*task)(void));

//create a new task
void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);
//run the idle task
void YKIdleTask();
//start the kernel
void YKRun();
//delay
void YKDelayTask(unsigned delay);
//the scheduler
void YKScheduler();



void YKTickHandler();

#endif /* YAKK_H */

