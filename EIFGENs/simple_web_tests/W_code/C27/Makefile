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

OBJECTS = big_file_C27_c.obj 

OLDOBJECTS =  sp890.obj sp890d.obj fu860.obj fu860d.obj ty869.obj ty869d.obj ty870.obj ty870d.obj \
	ty875.obj ty875d.obj ty876.obj ty876d.obj ty871.obj ty871d.obj ty877.obj ty877d.obj \
	eq878.obj eq878d.obj sp858.obj sp858d.obj dy861.obj dy861d.obj dy885.obj dy885d.obj \
	ha884.obj ha884d.obj st880.obj st880d.obj st883.obj st883d.obj ta862.obj ta862d.obj \
	ta886.obj ta886d.obj li865.obj li865d.obj ha887.obj ha887d.obj ta889.obj ta889d.obj \
	se864.obj se864d.obj li867.obj li867d.obj li868.obj li868d.obj li866.obj li866d.obj \
	rt859.obj rt859d.obj rt872.obj rt872d.obj rt873.obj rt873d.obj rt874.obj rt874d.obj \
	rt881.obj rt881d.obj rt882.obj rt882d.obj ta888.obj ta888d.obj ht863.obj ht863d.obj \
	we879.obj we879d.obj 

all::  Cobj27.lib

Cobj27.lib: $(OBJECTS) Makefile
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

