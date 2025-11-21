/*
 * Code for class WEL_PROCESS_TOOLHELP_CONSTANTS
 */

#include "eif_eiffel.h"
#include "../E1/estructure.h"


#ifdef __cplusplus
extern "C" {
#endif

extern EIF_TYPED_VALUE F103_4172(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4173(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4174(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4175(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4176(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4177(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4178(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4179(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4180(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4181(EIF_REFERENCE);
extern EIF_TYPED_VALUE F103_4182(EIF_REFERENCE);
extern void EIF_Minit103(void);

#ifdef __cplusplus
}
#endif

#include <Tlhelp32.h>

#ifdef __cplusplus
extern "C" {
#endif

#ifndef INLINE_F103_4172
static EIF_INTEGER_32 inline_F103_4172 (void)
{
	return (EIF_INTEGER_32) (PROCESS_ALL_ACCESS)
	;
}
#define INLINE_F103_4172
#endif
#ifndef INLINE_F103_4173
static EIF_INTEGER_32 inline_F103_4173 (void)
{
	return (EIF_INTEGER_32) (PROCESS_TERMINATE)
	;
}
#define INLINE_F103_4173
#endif
#ifndef INLINE_F103_4174
static EIF_INTEGER_32 inline_F103_4174 (void)
{
	return (EIF_INTEGER_32) (PROCESS_CREATE_PROCESS)
	;
}
#define INLINE_F103_4174
#endif
#ifndef INLINE_F103_4175
static EIF_INTEGER_32 inline_F103_4175 (void)
{
	return (EIF_INTEGER_32) (PROCESS_DUP_HANDLE)
	;
}
#define INLINE_F103_4175
#endif
#ifndef INLINE_F103_4176
static EIF_INTEGER_32 inline_F103_4176 (void)
{
	return (EIF_INTEGER_32) (PROCESS_QUERY_INFORMATION)
	;
}
#define INLINE_F103_4176
#endif
#ifndef INLINE_F103_4177
static EIF_INTEGER_32 inline_F103_4177 (void)
{
	return (EIF_INTEGER_32) (PROCESS_SET_QUOTA)
	;
}
#define INLINE_F103_4177
#endif
#ifndef INLINE_F103_4178
static EIF_INTEGER_32 inline_F103_4178 (void)
{
	return (EIF_INTEGER_32) (PROCESS_SET_INFORMATION)
	;
}
#define INLINE_F103_4178
#endif
#ifndef INLINE_F103_4179
static EIF_INTEGER_32 inline_F103_4179 (void)
{
	return (EIF_INTEGER_32) (PROCESS_VM_OPERATION)
	;
}
#define INLINE_F103_4179
#endif
#ifndef INLINE_F103_4180
static EIF_INTEGER_32 inline_F103_4180 (void)
{
	return (EIF_INTEGER_32) (PROCESS_VM_READ)
	;
}
#define INLINE_F103_4180
#endif
#ifndef INLINE_F103_4181
static EIF_INTEGER_32 inline_F103_4181 (void)
{
	return (EIF_INTEGER_32) (PROCESS_VM_WRITE)
	;
}
#define INLINE_F103_4181
#endif
#ifndef INLINE_F103_4182
static EIF_INTEGER_32 inline_F103_4182 (void)
{
	return (EIF_INTEGER_32) (SYNCHRONIZE)
	;
}
#define INLINE_F103_4182
#endif

#ifdef __cplusplus
}
#endif


#ifdef __cplusplus
extern "C" {
#endif

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_all_access */
EIF_TYPED_VALUE F103_4172 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_all_access";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4276);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4276);
	RTIV(Current, RTAL);
	Result = inline_F103_4172 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_terminate */
EIF_TYPED_VALUE F103_4173 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_terminate";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4277);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4277);
	RTIV(Current, RTAL);
	Result = inline_F103_4173 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_create_process */
EIF_TYPED_VALUE F103_4174 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_create_process";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4278);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4278);
	RTIV(Current, RTAL);
	Result = inline_F103_4174 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_dup_handle */
EIF_TYPED_VALUE F103_4175 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_dup_handle";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4279);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4279);
	RTIV(Current, RTAL);
	Result = inline_F103_4175 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_query_information */
EIF_TYPED_VALUE F103_4176 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_query_information";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4280);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4280);
	RTIV(Current, RTAL);
	Result = inline_F103_4176 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_set_quota */
EIF_TYPED_VALUE F103_4177 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_set_quota";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4281);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4281);
	RTIV(Current, RTAL);
	Result = inline_F103_4177 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_set_information */
EIF_TYPED_VALUE F103_4178 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_set_information";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4282);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4282);
	RTIV(Current, RTAL);
	Result = inline_F103_4178 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_vm_operation */
EIF_TYPED_VALUE F103_4179 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_vm_operation";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4283);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4283);
	RTIV(Current, RTAL);
	Result = inline_F103_4179 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_vm_read */
EIF_TYPED_VALUE F103_4180 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_vm_read";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4284);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4284);
	RTIV(Current, RTAL);
	Result = inline_F103_4180 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_vm_write */
EIF_TYPED_VALUE F103_4181 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_vm_write";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4285);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4285);
	RTIV(Current, RTAL);
	Result = inline_F103_4181 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

/* {WEL_PROCESS_TOOLHELP_CONSTANTS}.cwin_process_synchronize */
EIF_TYPED_VALUE F103_4182 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "cwin_process_synchronize";
	RTEX;
	EIF_INTEGER_32 Result = ((EIF_INTEGER_32) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_INT32, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 102, Current, 0, 0, 4286);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(102, Current, 4286);
	RTIV(Current, RTAL);
	Result = inline_F103_4182 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_INT32; r.it_i4 = Result; return r; }
}

void EIF_Minit103 (void)
{
	GTCX
}


#ifdef __cplusplus
}
#endif
