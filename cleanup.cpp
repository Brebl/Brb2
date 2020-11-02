#include "pch.h"

namespace brb {
	bool sb_err = false;
}

void brb::cleanup()
{
	if (!sb_err && brb::stream) {
		fclose(brb::stream);
		remove("log.txt");
	}
}