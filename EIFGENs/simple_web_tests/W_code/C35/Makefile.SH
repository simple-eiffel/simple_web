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
echo "Compiling C code in C35"
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

OBJECTS = big_file_C35_c.obj 

OLDOBJECTS =  sp1146.o sp1146d.o ar1147.o ar1147d.o ty1143.o ty1143d.o ty1144.o \
	ty1144d.o ty1145.o ty1145d.o na1148.o na1148d.o sp1141.o sp1141d.o \
	ar1140.o ar1140d.o ar1124.o ar1124d.o ar1149.o ar1149d.o re1127.o \
	re1127d.o re1152.o re1152d.o in1136.o in1136d.o to1139.o to1139d.o \
	dy1133.o dy1133d.o li1138.o li1138d.o ge1126.o ge1126d.o ge1151.o \
	ge1151d.o re1122.o re1122d.o se1129.o se1129d.o se1154.o se1154d.o \
	ar1125.o ar1125d.o ar1150.o ar1150d.o dy1131.o dy1131d.o bo1128.o \
	bo1128d.o bo1153.o bo1153d.o ta1134.o ta1134d.o un1137.o un1137d.o \
	ch1135.o ch1135d.o ty1123.o ty1123d.o bi1130.o bi1130d.o dy1132.o \
	dy1132d.o rt1142.o rt1142d.o 

all: Cobj35.o

Cobj35.o: $(OBJECTS) Makefile
	$(LD) $(LDFLAGS) -r -o Cobj35.o $(OBJECTS)
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

