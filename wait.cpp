#include "pch.h"
#include <iostream>

void brb::wait()
{
	std::cout << "\n\nPress the ENTER key...";
	std::cin.sync();
	std::cin.get();	
}