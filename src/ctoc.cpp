//-------------------------------------------------------------------------------------------------
// function:	copy wstring to clipboard
//-------------------------------------------------------------------------------------------------

#include "pch.h"
#ifdef __linux__
#include <qt5/QtGui/qclipboard.h>
#include <qt5/QtGui/qguiapplication.h>
#endif //linux

void brb::ctoc(const std::wstring& text)
{
	#ifdef _WIN32
	const wchar_t* output = text.c_str();
	const size_t len = sizeof(output) + 1;
	HGLOBAL hMem = GlobalAlloc(GMEM_MOVEABLE, len);
	memcpy(GlobalLock(hMem), output, len);
	GlobalUnlock(hMem);
	OpenClipboard(0);
	EmptyClipboard();
	SetClipboardData(CF_TEXT, hMem);
	CloseClipboard();
	#endif //win32
	
	#ifdef __linux__
	QClipboard *clipboard = QGuiApplication::clipboard();
	clipboard->setText(QString::fromStdWString(text));
	#endif //linux
}