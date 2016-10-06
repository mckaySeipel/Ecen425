# 1 "yakk.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "yakk.c"




# 1 "yakk.h" 1
# 12 "yakk.h"
typedef enum{
 READY,
 DELAY
}ready_state_t;


typedef struct {
  int * stack_pointer;
  ready_state_t ready;
  int delay_count;
  unsigned char priority;
 } task_t;

extern unsigned int YKCtxSwCount;

void YKEnterMutex();
void YKExitMutex();
void YKEnterISR();
void YKExitISR();
void YKDispatcher(int * sp, task_t * tcb);
void saveContext();
void restoreContext();
void NoOp();


void YKInitialize();

void InitStack(void (*task)(void));


void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);

void YKIdleTask();

void YKRun();

void YKDelayTask(unsigned delay);

void YKScheduler();



void YKTickHandler();
# 6 "yakk.c" 2
# 1 "clib.h" 1



void print(char *string, int length);
void printNewLine(void);
void printChar(char c);
void printString(char *string);


void printInt(int val);
void printLong(long val);
void printUInt(unsigned val);
void printULong(unsigned long val);


void printByte(char val);
void printWord(int val);
void printDWord(long val);


void exit(unsigned char code);


void signalEOI(void);
# 7 "yakk.c" 2



int IdleStk[256];


task_t tasks[4];
int running = 0;
int* currTask;
int currIndex = 0;
int YKTickNum = 0;

int YKIdleCount = 0;
unsigned int taskCount = 0;

int tick = 0;

unsigned int interrupt_depth = 0;
unsigned int YKCtxSwCount;


void YKInitialize(){
 YKNewTask(*YKIdleTask, (void *)&IdleStk[256], 255);
 YKCtxSwCount = 0;
}


void InitStack(void (*task)(void))
{
 int i;
 int* base_pointer;
 base_pointer = tasks[taskCount].stack_pointer;

 tasks[taskCount].stack_pointer--;
 *(tasks[taskCount].stack_pointer) = 0x200;
 tasks[taskCount].stack_pointer--;

 *(tasks[taskCount].stack_pointer) = 0x0000;

 tasks[taskCount].stack_pointer--;
 *(tasks[taskCount].stack_pointer) = (int)task;
 tasks[taskCount].stack_pointer--;
 *(tasks[taskCount].stack_pointer) = (int) base_pointer;
 for(i = 0 ; i < 7; i++)
 {
  tasks[taskCount].stack_pointer--;

  *(tasks[taskCount].stack_pointer) = 0x0000;
 }
}


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


void YKIdleTask(){
 while(1){
  YKIdleCount++;
  NoOp(); NoOp();
 }
}


void YKRun(){
 running = 1;
 printString("Running...\n");
 YKScheduler();
}


void YKDelayTask(unsigned delay){
 tasks[currIndex].ready = DELAY;
 tasks[currIndex].delay_count = delay;
 YKScheduler();
}


void YKScheduler(){

 int i;

 int index = 0;
 int local_currIndex;
 local_currIndex = currIndex;
 printString("Scheduling...\n");

 for (i = 1; i < taskCount; i++) {

  if(tasks[i].ready == READY && tasks[i].priority < tasks[index].priority) {

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
 int i;

 YKEnterISR();

 YKTickNum++;

 for(i = 0; i< taskCount; i++) {
  if (tasks[i] . delay_count != 0) {
   tasks[i] . delay_count--;
  }
 }

 YKExitISR();
}

void isrHandle_tick()
{


 printNewLine();
 printString("TICK ");
 printInt(tick);
 tick++;
 printNewLine();
 return;
}
