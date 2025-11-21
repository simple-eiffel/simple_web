INCLUDE_PATH =  -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\time\spec\include" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\process\base\platform\windows\include" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\wel\spec\windows\include" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\unstable\library\network\openssl\spec\include" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\C_library\openssl\spec\win64\include" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\runtime\logging\Clib" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\library\cURL\spec\include" -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\C_library\curl\include" -I"c:\program files\eiffel software\eiffelstudio 25.02 standard\contrib\library\web\framework\ewf\libfcgi\spec\include\libfcgi"
SHELL = \bin\sh
CC = cl
CPP = cl
CFLAGS = -Od -MT -w -nologo -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -D_CRT_SECURE_NO_DEPRECATE -D_UNICODE -DUNICODE -DWIN32_LEAN_AND_MEAN  -DEIF_THREADS  -DWORKBENCH -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\studio\spec\win64\include" -I. $(INCLUDE_PATH)
CPPFLAGS = -Od -MT -w -nologo -D_WIN32_WINNT=0x0500 -DWINVER=0x0500 -D_CRT_SECURE_NO_DEPRECATE -D_UNICODE -DUNICODE -DWIN32_LEAN_AND_MEAN  -DEIF_THREADS  -DWORKBENCH -I"C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\studio\spec\win64\include" -I. $(INCLUDE_PATH)
LDFLAGS = -STACK:5000000 -NODEFAULTLIB:libc
CCLDFLAGS = -STACK:5000000 -NODEFAULTLIB:libc  -SUBSYSTEM:CONSOLE
LDSHAREDFLAGS =  -dll -incremental:no -NODEFAULTLIB:libc
EIFLIB = "C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\studio\spec\win64\lib\msc_vc140\mtwkbench.lib"
EIFTEMPLATES = C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\studio\config\win64\templates
LIBS = 
MAKE = nmake -s -nologo
AR = 
LD = 
MKDEP =   --
MV = copy
CP = copy
RANLIB = echo
RM = del
FILE_EXIST = if exist
RMDIR = rd
X2C = "C:\Program Files\Eiffel Software\EiffelStudio 25.02 Standard\studio\spec\win64\bin\x2c.exe"
SHAREDLINK = link
SHAREDLIBS = USER32.lib WS2_32.lib ADVAPI32.lib GDI32.lib SHELL32.lib MSIMG32.lib \
	COMDLG32.lib UUID.lib OLE32.lib OLEAUT32.lib COMCTL32.lib MPR.LIB SHLWAPI.LIB WINSPOOL.LIB 
SHARED_SUFFIX = .dll
COMMAND_MAKEFILE = 
START_TEST = if not exist finished 
END_TEST =  
CREATE_TEST = echo "finished" >> finished 
SYSTEM_IN_DYNAMIC_LIB = simple_web.dll 

.SUFFIXES:.cpp .obj 

.c.obj:
	$(CC) $(CFLAGS) -c $<

.cpp.obj:
	$(CPP) $(CPPFLAGS) -c $<

OBJECTS = big_file_C25_c.obj 

OLDOBJECTS =  sp792.obj sp792d.obj sp823.obj sp823d.obj ar793.obj ar793d.obj ar824.obj ar824d.obj \
	ty818.obj ty818d.obj na794.obj na794d.obj sp811.obj sp811d.obj ar810.obj ar810d.obj \
	ar795.obj ar795d.obj re798.obj re798d.obj in807.obj in807d.obj dy804.obj dy804d.obj \
	dy813.obj dy813d.obj ha812.obj ha812d.obj ha819.obj ha819d.obj li809.obj li809d.obj \
	ge797.obj ge797d.obj se800.obj se800d.obj ar796.obj ar796d.obj dy802.obj dy802d.obj \
	bo799.obj bo799d.obj ta805.obj ta805d.obj ta814.obj ta814d.obj ha815.obj ha815d.obj \
	ha820.obj ha820d.obj un808.obj un808d.obj ta817.obj ta817d.obj ta822.obj ta822d.obj \
	ch806.obj ch806d.obj bi801.obj bi801d.obj dy803.obj dy803d.obj ta816.obj ta816d.obj \
	ta821.obj ta821d.obj 

all::  Cobj25.lib

Cobj25.lib: $(OBJECTS) Makefile
	if exist $@ $(RM) $@
	lib -nologo -OUT:$@ $(OBJECTS)
	$(CREATE_TEST)
	$(RM) $(OBJECTS)


clean: local_clean
clobber: local_clobber

local_clean::
	$(RM) core finished *.o

local_clobber:: local_clean
	$(RM) Makefile

