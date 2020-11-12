#pragma once
#include <string>
#include <ctime>
#include <iostream>
#include <fstream>
#include <Windows.h>
#include <climits>
#undef max

namespace brb {
	extern bool sb_err;
	extern FILE* stream;

	void redirect(const char* filename); //globally redirect clog & cerr to file
	
	template<typename T>void input(T& luku) {	//cin number
		while (!(std::wcin >> luku)) {
			std::wcin.clear();
			std::wcin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
	}
	
	template<typename T> T input() {		//cin number
		T luku;
		while (!(std::wcin >> luku)) {
			std::wcin.clear();
			std::wcin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
		return luku;
	}
	
	void ctoc(const std::wstring&);	//copy wstring to clipboard
	void cls();			//clear console screen
	void wait();		//wait console until enter key
	void cleanup();		//delete log-file if no errors and progFlow reaches progEnd
	using buff = char[32];
	void timeNow(buff);

	enum class mode {
		all,
		release_only,
		debug_only
	};
	template<typename T, typename U> void log(T t, U u, mode m = mode::all) //log message
	{
#ifdef _DEBUG	//debug
		if (m == mode::release_only) {
			return;
		}
#endif
#ifndef _DEBUG	//release
		if (m == mode::debug_only) {
			return;
		}
		redirect("log.txt");
#endif
		buff buffer;
		timeNow(buffer);
		std::clog << "--LOG--   " << buffer << t << " : " << u << "\n";
	}

	template<typename T, typename U> void err(T t, U u) //log error message
	{
		redirect("log.txt");
		sb_err = true;	//prevent cleanup
		buff buffer;
		timeNow(buffer);	
		std::cerr << "--ERROR-- " << buffer << t << " : " << u << "\n";
	}
}