# 1 "lab4c_app.c"
# 1 "<built-in>"
# 1 "<command-line>"
# 1 "/usr/include/stdc-predef.h" 1 3 4
# 1 "<command-line>" 2
# 1 "lab4c_app.c"






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
# 8 "lab4c_app.c" 2
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
extern int YKIdleCount;

void YKEnterMutex();
void YKExitMutex();
void YKDispatcher(int * sp, task_t * tcb);
void saveContext();
void restoreContext();
void NoOp();

void YKEnterISR();

void YKExitISR();



void YKInitialize();

void InitStack(void (*task)(void));


void YKNewTask(void (*task)(void), void* taskStack, unsigned char priority);

void YKIdleTask();

void YKRun();

void YKDelayTask(unsigned delay);

void YKScheduler();



void YKTickHandler();
# 9 "lab4c_app.c" 2



int TaskStack[256];

void Task(void);

void main(void)
{
    YKInitialize();

    printString("Creating task...\n");
    YKNewTask(Task, (void *) &TaskStack[256], 0);

    printString("Starting kernel...\n");
    YKRun();
}

void Task(void)
{
    unsigned idleCount;
    unsigned numCtxSwitches;

    printString("Task started.\n");
    while (1)
    {
        printString("Delaying task...\n");

        YKDelayTask(2);

        YKEnterMutex();
        numCtxSwitches = YKCtxSwCount;
        idleCount = YKIdleCount;
        YKIdleCount = 0;
        YKExitMutex();

        printString("Task running after ");
        printUInt(numCtxSwitches);
        printString(" context switches! YKIdleCount is ");
        printUInt(idleCount);
        printString(".\n");
    }
}
