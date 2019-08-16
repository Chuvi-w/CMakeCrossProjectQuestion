#include "..\DeviceLib\DeviceLibCode.h"
#include "..\CommonCode\CommFuncs.h"

void SendDataToPC()
{
	//DoSomething;
	return;
}

void ReadDataFromPC()
{
	//DoSomethingElse;
	return;
}

void main_c()
{
	do 
	{
		SendDataToPC();
		ReadDataFromPC();
		if(DeviceLibFunction()==(int)Return100())
		{
			//DoSomething
		}
	} while (1);


}