//-------------------------------------------------------------------------------------------------
//function:		redirect stderr stream to file
//-------------------------------------------------------------------------------------------------

#include "pch.h"

namespace brb {
	FILE* stream = nullptr;
}


void brb::redirect(const char* filename)
{
	static bool once = false;
	if (once) {
		return;
	}
	once = true;

#ifdef _WIN32
	errno_t err;
	err = freopen_s(&stream, filename, "a", stderr);
	if (err != 0) {
		fprintf(stdout, "error on freopen: %i\n", err);
	}
	else {
		fprintf(stdout, "logs and error messages redirected to: %s\n", filename);
	}
#endif //win32

#ifdef __linux__
	stream = freopen(filename, "a", stderr);
	if(stream == nullptr){
		fprintf(stdout, "error on freopen: %i\n", errno);
	}
	else {
		fprintf(stdout, "logs and error messages redirected to: %s\n", filename);
	}
#endif //linux
}
