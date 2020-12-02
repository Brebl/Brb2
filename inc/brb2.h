#pragma once
#include <string>
#include <ctime>
#include <iostream>
#include <fstream>
#include <climits>

#ifdef _WIN32
#include <Windows.h>
#define WIN32_LEAN_AND_MEAN // Exclude rarely-used stuff from Windows headers
#undef max
#ifdef BRB2_EXPORTS
#define BRB2_API __declspec(dllexport)
#else
#define BRB2_API __declspec(dllimport)
#endif //brb2_exports
#endif	//win32

#ifdef __linux__
#define BRB2_API
#endif //linux

//for compile-time checks
#define BRB2_MAJOR_VERSION 1
#define BRB2_MINOR_VERSION 2
#define BRB2_PATCH_VERSION 0

namespace brb 
{	
	using buff = char[32];

	enum class Mode {
		all,
		release_only,
		debug_only
	};

	struct Version {
		size_t major;
		size_t minor;
		size_t patch;
	};

	BRB2_API extern bool sb_err;
	BRB2_API extern FILE* stream;
	
	BRB2_API void timeNow(buff);				//put formatted current time to buff
	BRB2_API void redirect(const char* filename); //globally redirect clog & cerr to file	
	BRB2_API void cleanup();					//delete log-file if no errors and program flow reaches program end
	BRB2_API void ctoc(const std::wstring&);	//copy wstring to clipboard
	BRB2_API void cls();						//clear console screen
	BRB2_API void wait();						//wait console until enter key
	BRB2_API Version versionCheck();			//for run-time checks

	template<typename T, typename U> void log(T t, U u, Mode m = Mode::all) //log message
	{
#ifdef _DEBUG	//debug
		if (m == Mode::release_only) {
			return;
		}
#endif
#ifndef _DEBUG	//release
		if (m == Mode::debug_only) {
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

	template<typename T> void input(T& num)
	{
		while (!(std::wcin >> num)) {
			std::wcin.clear();
			std::wcin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
	}

	template<typename T> T input()
	{
		T num;
		while (!(std::wcin >> num)) {
			std::wcin.clear();
			std::wcin.ignore(std::numeric_limits<std::streamsize>::max(), '\n');
		}
		return num;
	}
}
