/*
 * Code for class OPERATING_ENVIRONMENT
 */

#include "eif_eiffel.h"
#include "../E1/estructure.h"


#ifdef __cplusplus
extern "C" {
#endif

extern EIF_TYPED_VALUE F55_3027(EIF_REFERENCE);
extern EIF_TYPED_VALUE F55_3028(EIF_REFERENCE);
extern EIF_TYPED_VALUE F55_3029(EIF_REFERENCE);
extern EIF_TYPED_VALUE F55_3030(EIF_REFERENCE);
extern EIF_TYPED_VALUE F55_3031(EIF_REFERENCE);
extern EIF_TYPED_VALUE F55_3032(EIF_REFERENCE);
extern EIF_TYPED_VALUE F55_3033(EIF_REFERENCE);
extern void EIF_Minit55(void);

#ifdef __cplusplus
}
#endif

#include "eif_dir.h"
#include "eif_path_name.h"

#ifdef __cplusplus
extern "C" {
#endif


#ifdef __cplusplus
}
#endif


#ifdef __cplusplus
extern "C" {
#endif

/* {OPERATING_ENVIRONMENT}.directory_separator */
RTOID (F55_3027)
EIF_TYPED_VALUE F55_3027 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "directory_separator";
	RTEX;
	EIF_CHARACTER_8 tc1;
	RTCDD;
	RTSN;
	RTDA;
	RTLD;
	
#define Result RTOTRB(EIF_CHARACTER_8)
	RTOTDB(EIF_CHARACTER_8, F55_3027);
	dtype = Dtype(Current);

	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_CHAR8, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3060);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(54, Current, 3060);
	RTIV(Current, RTAL);
	RTOTP;
	RTHOOK(1);
	RTDBGAL(0, 0x08000000, 1,0); /* Result */
	tc1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(3032, dtype))(Current)).it_c1);
	Result = (EIF_CHARACTER_8) tc1;
	RTVI(Current, RTAL);
	RTRS;
	RTOTE;
	RTHOOK(2);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_CHAR8; r.it_c1 = Result; return r; }
#undef Result
}

/* {OPERATING_ENVIRONMENT}.current_directory_name_representation */
RTOID (F55_3028)
EIF_TYPED_VALUE F55_3028 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "current_directory_name_representation";
	RTEX;
	EIF_TYPED_VALUE up1x = {{0}, SK_POINTER};
#define up1 up1x.it_p
	EIF_REFERENCE tr1 = NULL;
	RTCDD;
	RTSN;
	RTDA;
	RTLD;
	
#define Result RTOTRR
	RTOTDR(F55_3028);
	dtype = Dtype(Current);

	RTLI(2);
	RTLR(0,Current);
	RTLR(1,tr1);
	RTLIU(2);
	RTLU (SK_REF, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3061);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(54, Current, 3061);
	RTIV(Current, RTAL);
	RTOTP;
	RTHOOK(1);
	RTDBGAL(0, 0xF80001D2, 0,0); /* Result */
	tr1 = ((up1x = (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(3033, dtype))(Current)), (((up1x.type & SK_HEAD) == SK_REF)? (EIF_REFERENCE) 0: (up1x.it_r = RTBU(up1x))), (up1x.type = SK_POINTER), up1x.it_r);
	Result = (EIF_REFERENCE) RTCCL(tr1);
	RTVI(Current, RTAL);
	RTRS;
	RTOTE;
	RTHOOK(2);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_REF; r.it_r = Result; return r; }
#undef up1
#undef Result
}

/* {OPERATING_ENVIRONMENT}.home_directory_supported */
EIF_TYPED_VALUE F55_3029 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "home_directory_supported";
	RTEX;
	EIF_BOOLEAN Result = ((EIF_BOOLEAN) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_BOOL, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3062);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(54, Current, 3062);
	RTIV(Current, RTAL);Result = (EIF_BOOLEAN) EIF_TEST(eif_home_dir_supported());
	
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_BOOL; r.it_b = Result; return r; }
}

/* {OPERATING_ENVIRONMENT}.root_directory_supported */
EIF_TYPED_VALUE F55_3030 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "root_directory_supported";
	RTEX;
	EIF_BOOLEAN Result = ((EIF_BOOLEAN) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_BOOL, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3063);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(54, Current, 3063);
	RTIV(Current, RTAL);Result = (EIF_BOOLEAN) EIF_TEST(eif_root_dir_supported());
	
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_BOOL; r.it_b = Result; return r; }
}

/* {OPERATING_ENVIRONMENT}.case_sensitive_path_names */
EIF_TYPED_VALUE F55_3031 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "case_sensitive_path_names";
	RTEX;
	EIF_BOOLEAN Result = ((EIF_BOOLEAN) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_BOOL, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3064);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(54, Current, 3064);
	RTIV(Current, RTAL);Result = (EIF_BOOLEAN) EIF_TEST(eif_case_sensitive_path_names());
	
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_BOOL; r.it_b = Result; return r; }
}

/* {OPERATING_ENVIRONMENT}.c_dir_separator */
EIF_TYPED_VALUE F55_3032 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "c_dir_separator";
	RTEX;
	EIF_CHARACTER_8 Result = ((EIF_CHARACTER_8) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_CHAR8, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3065);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(54, Current, 3065);
	RTIV(Current, RTAL);Result = (EIF_CHARACTER_8) eif_dir_separator();
	
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_CHAR8; r.it_c1 = Result; return r; }
}

/* {OPERATING_ENVIRONMENT}.eif_current_dir_representation */
EIF_TYPED_VALUE F55_3033 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "eif_current_dir_representation";
	RTEX;
	EIF_REFERENCE Result = ((EIF_REFERENCE) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(2);
	RTLR(0,Result);
	RTLR(1,Current);
	RTLIU(2);
	RTLU (SK_REF, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 54, Current, 0, 0, 3066);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(54, Current, 3066);
	RTIV(Current, RTAL);Result = (EIF_REFERENCE) eif_current_dir_representation();
	
	RTVI(Current, RTAL);
	RTRS;
	if (!Result) {RTEC(EN_FAIL);}
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_REF; r.it_r = Result; return r; }
}

void EIF_Minit55 (void)
{
	GTCX
	RTOTS (3027,F55_3027)
	RTOTS (3028,F55_3028)
}


#ifdef __cplusplus
}
#endif
