#include <stdio.h>
extern "C"
{
#include "..\CommonCode\CommFuncs.h"
}

void SendDataToDevice()
{
	//DoSomething;
	return;
}

int GetDataFromDevice()
{
	
	//DoSomething;
	return 50;
}

int main()
{

	do 
	{
		SendDataToDevice();
		if(Return100()==GetDataFromDevice())
		{

		}
		//DoSomethingMore;
	} while (1);
	return 0;
}