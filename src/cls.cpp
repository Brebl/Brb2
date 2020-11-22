//-------------------------------------------------------------------------------------------------
// function:	clear console screen
//-------------------------------------------------------------------------------------------------

#include "pch.h"

void brb::cls()
{
	#ifdef _WIN32
	HANDLE                     hStdOut;
	CONSOLE_SCREEN_BUFFER_INFO csbi;
	DWORD                      count;
	DWORD                      cellCount;
	COORD                      homeCoords = { 0, 0 };
	std::string ermss = "brb::cls ";

	hStdOut = GetStdHandle(STD_OUTPUT_HANDLE);
	if (hStdOut == INVALID_HANDLE_VALUE) {
		brb::err(ermss, "INVALID_HANDLE_VALUE");
		return;
	}
	
	/* Get the number of cells in the current buffer */
	if (!GetConsoleScreenBufferInfo(hStdOut, &csbi)) {
		brb::err(ermss, "GetConsoleScreenBufferInfo");
		return;
	}
	cellCount = csbi.dwSize.X * csbi.dwSize.Y;

	/* Fill the entire buffer with spaces */
	if (!FillConsoleOutputCharacter(
		hStdOut,
		(TCHAR)' ',
		cellCount,
		homeCoords,
		&count
	)) {
		brb::err(ermss, "FillConsoleOutputCharacter");
		return;
	}

	/* Fill the entire buffer with the current colors and attributes */
	if (!FillConsoleOutputAttribute(
		hStdOut,
		csbi.wAttributes,
		cellCount,
		homeCoords,
		&count
	)) {
		brb::err(ermss, "FillConsoleOutputAttribute");
		return;
	}

	/* Move the cursor home */
	SetConsoleCursorPosition(hStdOut, homeCoords);
	#endif //win32
	#ifdef __linux__
	std::system("clear");
	#endif //linux
}