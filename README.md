# Brb2  
  
General logging templates and some cli functions.  
  
makefile builds shared-object (.so) for linux  
vcxproj builds dynamic-link library (.dll) for x86 and x64 windows  
  
## Building in linux  
`git clone https://github.com/Brebl/Brb2.git`  
`cd ~/Brb2`  
run `make` and the library will be compiled and placed in the `./bin/linux` subdirectory.  
run `sudo make install` and the library will be installed in standard place as described in Filesystem Hierarchy Standard. After that it will be accessible to other programs.  
  
### Usage  
To use the full power of this **awsome** library, just give GCC a linker-flag `-lbrb2` and you'r good to go. If you want to link to an older version of this library, you can use `-l:libbrb2.so.[version]` (in case you have that installed...)  
If you want to add something, chuck you'r sources to `./src` with or without subfolders and headers to `./inc`. No need to setup makefile, it parses dependencies for you.  
  
### Uninstall  
If you want to get rid of it, run `make clean` or `sudo make realclean` in case you installed it.  


