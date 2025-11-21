/*
 * Code for class ISE_SCOOP_RUNTIME
 */

#include "eif_eiffel.h"
#include "../E1/estructure.h"


#ifdef __cplusplus
extern "C" {
#endif

extern EIF_TYPED_VALUE F7_726(EIF_REFERENCE);
extern EIF_TYPED_VALUE F7_727(EIF_REFERENCE, EIF_TYPED_VALUE);
extern void F7_728(EIF_REFERENCE);
extern void F7_729(EIF_REFERENCE, EIF_TYPED_VALUE);
extern EIF_TYPED_VALUE F7_730(EIF_REFERENCE, EIF_TYPED_VALUE);
extern void F7_731(EIF_REFERENCE, EIF_TYPED_VALUE);
extern void EIF_Minit7(void);

#ifdef __cplusplus
}
#endif

#include "eif_scoop.h"
#include "eif_macros.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef INLINE_F7_730
static EIF_NATURAL_16 inline_F7_730 (EIF_POINTER arg1)
{
	return RTS_PID(arg1)
	;
}
#define INLINE_F7_730
#endif
#ifndef INLINE_F7_731
static void inline_F7_731 (EIF_NATURAL_16 arg1)
{
	eif_scoop_set_is_impersonation_allowed (arg1, EIF_FALSE)
	;
}
#define INLINE_F7_731
#endif

#ifdef __cplusplus
}
#endif


#ifdef __cplusplus
extern "C" {
#endif

/* {ISE_SCOOP_RUNTIME}.invalid_region_id */
EIF_TYPED_VALUE F7_726 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "invalid_region_id";
	RTEX;
	EIF_NATURAL_16 Result = ((EIF_NATURAL_16) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_UINT16, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 6, Current, 0, 0, 723);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(6, Current, 723);
	RTIV(Current, RTAL);
	Result = (EIF_NATURAL_16) EIF_NULL_PROCESSOR;
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_UINT16; r.it_n2 = Result; return r; }
}

/* {ISE_SCOOP_RUNTIME}.region_id */
EIF_TYPED_VALUE F7_727 (EIF_REFERENCE Current, EIF_TYPED_VALUE arg1x)
{
	GTCX
	char *l_feature_name = "region_id";
	RTEX;
#define arg1 arg1x.it_r
	EIF_BOOLEAN uarg1;
	EIF_BOOLEAN uarg;
	RTS_SD;
	EIF_TYPED_VALUE up1x = {{0}, SK_POINTER};
#define up1 up1x.it_p
	EIF_NATURAL_16 tu2_1;
	EIF_NATURAL_16 Result = ((EIF_NATURAL_16) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	
	RTLI(2);
	RTLR(0,Current);
	RTLR(1,arg1);
	RTLIU(2);
	RTLU (SK_UINT16, &Result);
	RTLU(SK_REF,&arg1);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 6, Current, 0, 1, 724);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(6, Current, 724);
	uarg1 = (EIF_BOOLEAN) RTS_OU (arg1);
	uarg = uarg1;
	if (uarg) {
		RTS_RC;
		RTS_RS (arg1);
		RTS_RW;
	}
	RTIV(Current, RTAL);
	RTHOOK(1);
	RTDBGAL(0, 0x34000000, 1,0); /* Result */
	up1 = arg1;
	tu2_1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTWF(733, dtype))(Current, up1x)).it_n2);
	Result = (EIF_NATURAL_16) tu2_1;
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(2);
	RTDBGLE;
	RTMD(0);
	if (uarg) {
		RTS_RD;
	}
	RTLE;
	RTLO(3);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_UINT16; r.it_n2 = Result; return r; }
#undef up1
#undef arg1
}

/* {ISE_SCOOP_RUNTIME}.pin_to_thread */
void F7_728 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "pin_to_thread";
	RTEX;
	EIF_TYPED_VALUE up1x = {{0}, SK_POINTER};
#define up1 up1x.it_p
	EIF_TYPED_VALUE uu2_1x = {{0}, SK_UINT16};
#define uu2_1 uu2_1x.it_n2
	EIF_NATURAL_16 tu2_1;
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_VOID, NULL);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 6, Current, 0, 0, 725);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(6, Current, 725);
	RTIV(Current, RTAL);
	RTHOOK(1);
	up1 = Current;
	tu2_1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTWF(733, dtype))(Current, up1x)).it_n2);
	uu2_1 = tu2_1;
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTWF(734, dtype))(Current, uu2_1x);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(2);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
#undef up1
#undef uu2_1
}

/* {ISE_SCOOP_RUNTIME}.pin_processor_to_thread */
void F7_729 (EIF_REFERENCE Current, EIF_TYPED_VALUE arg1x)
{
	GTCX
	char *l_feature_name = "pin_processor_to_thread";
	RTEX;
#define arg1 arg1x.it_r
	EIF_BOOLEAN uarg1;
	EIF_BOOLEAN uarg;
	RTS_SD;
	RTS_SDC;
	EIF_TYPED_VALUE up1x = {{0}, SK_POINTER};
#define up1 up1x.it_p
	EIF_TYPED_VALUE uu2_1x = {{0}, SK_UINT16};
#define uu2_1 uu2_1x.it_n2
	EIF_POINTER tp1;
	EIF_NATURAL_16 tu2_1;
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	
	RTLI(2);
	RTLR(0,Current);
	RTLR(1,arg1);
	RTLIU(2);
	RTLU (SK_VOID, NULL);
	RTLU(SK_REF,&arg1);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 6, Current, 0, 1, 726);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(6, Current, 726);
	uarg1 = (EIF_BOOLEAN) RTS_OU (arg1);
	uarg = uarg1;
	if (uarg) {
		RTS_RC;
		RTS_RS (arg1);
		RTS_RW;
	}
	RTIV(Current, RTAL);
	RTHOOK(1);
	if (RTS_CI (EIF_TRUE, arg1)) {
		RTS_BI (arg1);
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTVF(36, "default_pointer", arg1))(arg1)).it_p);
		RTS_EI;
	} else {
		RTS_AC (0, arg1);
		RTS_CALL (36, SK_POINTER);
		tp1 = l_scoop_result.it_p;
	}
	eif_do_nothing_value.it_p = tp1;
	RTHOOK(2);
	up1 = arg1;
	tu2_1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTWF(733, dtype))(Current, up1x)).it_n2);
	uu2_1 = tu2_1;
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTWF(734, dtype))(Current, uu2_1x);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(3);
	RTDBGLE;
	RTMD(0);
	if (uarg) {
		RTS_RD;
	}
	RTLE;
	RTLO(3);
	RTEE;
#undef up1
#undef uu2_1
#undef arg1
}

/* {ISE_SCOOP_RUNTIME}.c_region_id */
EIF_TYPED_VALUE F7_730 (EIF_REFERENCE Current, EIF_TYPED_VALUE arg1x)
{
	GTCX
	char *l_feature_name = "c_region_id";
	RTEX;
#define arg1 arg1x.it_p
	EIF_NATURAL_16 Result = ((EIF_NATURAL_16) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	if ((arg1x.type & SK_HEAD) == SK_REF) arg1x.it_p = * (EIF_POINTER *) arg1x.it_r;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_UINT16, &Result);
	RTLU(SK_POINTER,&arg1);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 6, Current, 0, 1, 727);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(6, Current, 727);
	RTIV(Current, RTAL);
	Result = inline_F7_730 ((EIF_POINTER) arg1);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(3);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_UINT16; r.it_n2 = Result; return r; }
#undef arg1
}

/* {ISE_SCOOP_RUNTIME}.c_disable_impersonation */
void F7_731 (EIF_REFERENCE Current, EIF_TYPED_VALUE arg1x)
{
	GTCX
	char *l_feature_name = "c_disable_impersonation";
	RTEX;
#define arg1 arg1x.it_n2
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	if ((arg1x.type & SK_HEAD) == SK_REF) arg1x.it_n2 = * (EIF_NATURAL_16 *) arg1x.it_r;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_VOID, NULL);
	RTLU(SK_UINT16,&arg1);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 6, Current, 0, 1, 728);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(6, Current, 728);
	RTIV(Current, RTAL);
	inline_F7_731 ((EIF_NATURAL_16) arg1);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(3);
	RTEE;
#undef arg1
}

void EIF_Minit7 (void)
{
	GTCX
}


#ifdef __cplusplus
}
#endif
