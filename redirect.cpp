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

	errno_t err;
	err = freopen_s(&stream, filename, "a", stderr);
	if (err != 0) {
		fprintf(stdout, "error on freopen: %i\n", err);
	}
	else {
		fprintf(stdout, "stderr stream redirected to: %s\n", filename);
	}
}