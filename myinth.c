extern int KeyBuffer;

void isrHandle_reset()
{
	//this will be the handler for the reset
	exit(0);
}

int tick = 0;

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

int i = 0;

void isrHandle_keyPress()
{

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
