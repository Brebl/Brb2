//-------------------------------------------------------------------------------------------------
//function:		get time as formatted buffer
//-------------------------------------------------------------------------------------------------


#include "pch.h"

namespace brb 
{
	void timeNow(char* buffer)
	{
		//get current time
		time_t rawtime = 0;
		tm date_time = std::tm();
		time(&rawtime);
		#ifdef _WIN32
		localtime_s(&date_time, &rawtime);
		#endif
		#ifdef __linux__
		date_time = *localtime (&rawtime);
		#endif //linux
		strftime(buffer, 32, "%F %T ", &date_time);
	}
}