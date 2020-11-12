#include "pch.h"

namespace brb {
	void timeNow(char* buffer)
	{
		//get current time
		time_t rawtime = 0;
		tm date_time = std::tm();
		time(&rawtime);
		localtime_s(&date_time, &rawtime);
		strftime(buffer, 32, "%F %T ", &date_time);
	}
}