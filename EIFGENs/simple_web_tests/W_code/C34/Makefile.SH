case $CONFIG in
'')
	if test ! -f ../config.sh; then
		(echo "Can't find ../config.sh."; exit 1)
	fi 2>/dev/null
	. ../config.sh
	;;
esac
case "$O" in
*/*) cd `expr X$0 : 'X\(.*\)/'` ;;
esac
echo "Compiling C code in C34"
$spitshell >Makefile <<!GROK!THIS!
INCLUDE_PATH =  -I"\$(ISE_LIBRARY)\library\time\spec\include" -I"\$(ISE_LIBRARY)\library\process\base\platform\windows\include" -I"\$(ISE_LIBRARY)\library\wel\spec\windows\include" -I"\$(ISE_LIBRARY)\unstable\library\network\openssl\spec\include" -I"\$(ISE_LIBRARY)\C_library\openssl\spec\$(ISE_PLATFORM)\include" -I"\$(ISE_LIBRARY)/library/runtime/logging/Clib" -I"\$(ISE_LIBRARY)\library\cURL\spec\include" -I"\$(ISE_LIBRARY)\C_library\curl\include" -I"c:\program files\eiffel software\eiffelstudio 25.02 standard\contrib\library\web\framework\ewf\libfcgi\spec\include\libfcgi"
SHELL = /bin/sh
CC = $cc
CPP = $cpp
CFLAGS = $wkoptimize $mtccflags $large -DWORKBENCH -I"$rt_include" -I. \$(INCLUDE_PATH)
CPPFLAGS = $wkoptimize $mtcppflags $large -DWORKBENCH -I"$rt_include" -I. \$(INCLUDE_PATH)
LDFLAGS = $ldflags
CCLDFLAGS = $ccldflags  $console_flags
LDSHAREDFLAGS =  $mtldsharedflags
EIFLIB = "$rt_lib/$prefix$mt_prefix$wkeiflib$suffix"
EIFTEMPLATES = $rt_templates
LIBS = $mtlibs
MAKE = $make
AR = $ar
LD = $ld
MKDEP = $mkdep \$(DPFLAGS) --
MV = $mv
CP = $cp
RANLIB = $ranlib
RM = $rm -f
FILE_EXIST = $file_exist
RMDIR = $rmdir
X2C = "$x2c"
SHAREDLINK = $sharedlink
SHAREDLIBS = $sharedlibs
SHARED_SUFFIX = $shared_suffix
COMMAND_MAKEFILE = 
START_TEST = $start_test 
END_TEST = $end_test 
CREATE_TEST = $create_test 
SYSTEM_IN_DYNAMIC_LIB = simple_web$shared_suffix 
!GROK!THIS!
$spitshell >>Makefile <<'!NO!SUBS!'

.SUFFIXES:.cpp .o

.c.o:
	$(CC) $(CFLAGS) -c $<

.cpp.o:
	$(CPP) $(CPPFLAGS) -c $<

OBJECTS = big_file_C34_c.obj 

OLDOBJECTS =  sp1106.o sp1106d.o ar1107.o ar1107d.o na1110.o na1110d.o sp1105.o \
	sp1105d.o re1120.o re1120d.o ar1104.o ar1104d.o it1108.o it1108d.o \
	it1109.o it1109d.o li1114.o li1114d.o re1091.o re1091d.o in1100.o \
	in1100d.o to1103.o to1103d.o dy1097.o dy1097d.o li1102.o li1102d.o \
	ge1090.o ge1090d.o in1121.o in1121d.o se1093.o se1093d.o ar1089.o \
	ar1089d.o dy1095.o dy1095d.o cu1115.o cu1115d.o tr1119.o tr1119d.o \
	bo1092.o bo1092d.o ta1098.o ta1098d.o fi1112.o fi1112d.o un1101.o \
	un1101d.o ch1099.o ch1099d.o ac1116.o ac1116d.o bi1094.o bi1094d.o \
	dy1096.o dy1096d.o co1111.o co1111d.o ba1117.o ba1117d.o bo1113.o \
	bo1113d.o co1118.o co1118d.o 

all: Cobj34.o

Cobj34.o: $(OBJECTS) Makefile
	$(LD) $(LDFLAGS) -r -o Cobj34.o $(OBJECTS)
	$(RM) $(OBJECTS)
	$(CREATE_TEST)

clean: local_clean
clobber: local_clobber

local_clean::
	$(RM) core finished *.o

local_clobber:: local_clean
	$(RM) Makefile

!NO!SUBS!
chmod 644 Makefile
$eunicefix Makefile

