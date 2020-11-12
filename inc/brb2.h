#pragma once
#undef max
#ifdef BRB2_EXPORTS
#define BRB2_API __declspec(dllexport)
#else
#define BRB2_API __declspec(dllimport)
#endif

namespace brb {
	BRB2_API extern bool sb_err;
	BRB2_API extern FILE* stream;

	BRB2_API void redirect(const char* filename); //globally redirect clog & cerr to file

	template<typename T> void input(T& luku) {	//cin number
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

	BRB2_API void ctoc(const std::wstring&);	//copy wstring to clipboard
	BRB2_API void cls();			//clear console screen
	BRB2_API void wait();		//wait console until enter key
	BRB2_API void cleanup();		//delete log-file if no errors and program flow reaches program end
	using buff = char[32];
	BRB2_API void timeNow(buff);

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