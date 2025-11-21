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
echo "Compiling C code in C36"
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

OBJECTS = big_file_C36_c.obj 

OLDOBJECTS =  sp1165.o sp1165d.o ar1166.o ar1166d.o na1169.o na1169d.o sp1164.o \
	sp1164d.o re1179.o re1179d.o ar1163.o ar1163d.o it1167.o it1167d.o \
	it1168.o it1168d.o ar1183.o ar1183d.o li1173.o li1173d.o re1186.o \
	re1186d.o in1159.o in1159d.o to1162.o to1162d.o li1161.o li1161d.o \
	ge1185.o ge1185d.o re1181.o re1181d.o in1180.o in1180d.o ar1184.o \
	ar1184d.o dy1156.o dy1156d.o cu1174.o cu1174d.o tr1178.o tr1178d.o \
	bo1187.o bo1187d.o fi1171.o fi1171d.o un1160.o un1160d.o ch1158.o \
	ch1158d.o ty1182.o ty1182d.o ac1175.o ac1175d.o bi1155.o bi1155d.o \
	dy1157.o dy1157d.o co1170.o co1170d.o ba1176.o ba1176d.o bo1172.o \
	bo1172d.o co1177.o co1177d.o 

all: Cobj36.o

Cobj36.o: $(OBJECTS) Makefile
	$(LD) $(LDFLAGS) -r -o Cobj36.o $(OBJECTS)
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

