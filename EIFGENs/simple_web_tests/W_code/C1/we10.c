/*
 * Code for class WEL_GDIP_STARTER
 */

#include "eif_eiffel.h"
#include "../E1/estructure.h"


#ifdef __cplusplus
extern "C" {
#endif

extern void F10_745(EIF_REFERENCE);
extern void F10_746(EIF_REFERENCE);
extern EIF_TYPED_VALUE F10_747(EIF_REFERENCE);
extern EIF_TYPED_VALUE F10_748(EIF_REFERENCE);
extern EIF_TYPED_VALUE F10_749(EIF_REFERENCE);
extern EIF_TYPED_VALUE F10_750(EIF_REFERENCE);
extern EIF_TYPED_VALUE F10_751(EIF_REFERENCE, EIF_TYPED_VALUE);
extern void F10_752(EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE);
extern void EIF_Minit10(void);

#ifdef __cplusplus
}
#endif

#include <windows.h>
#include "wel_gdi_plus.h"

#ifdef __cplusplus
extern "C" {
#endif

#ifndef INLINE_F10_750
static EIF_POINTER inline_F10_750 (void)
{
	return (EIF_POINTER) LoadLibrary (L"gdiplus.dll");
	;
}
#define INLINE_F10_750
#endif
#ifndef INLINE_F10_751
static EIF_POINTER inline_F10_751 (EIF_POINTER arg1)
{
	{
				GdiplusStartupInput gdiplusStartupInput = {1, NULL, FALSE, FALSE};
		   		ULONG_PTR gdiplusToken;
			  	FARPROC GdiplusStartup = NULL;
				HMODULE user32_module = (HMODULE) arg1;
				
				GdiplusStartup = GetProcAddress (user32_module, "GdiplusStartup");
				if (GdiplusStartup) {
					(FUNCTION_CAST_TYPE(GpStatus, WINAPI, (ULONG_PTR *, const GdiplusStartupInput *,  GdiplusStartupOutput *)) GdiplusStartup)					
								(&gdiplusToken, &gdiplusStartupInput, NULL);
				}
				return (EIF_POINTER) gdiplusToken;
   			}
	;
}
#define INLINE_F10_751
#endif
#ifndef INLINE_F10_752
static void inline_F10_752 (EIF_POINTER arg1, EIF_POINTER arg2)
{
	{
  	FARPROC GdiplusShutdown = NULL;
	HMODULE user32_module = (HMODULE) arg1;
	GdiplusShutdown = GetProcAddress (user32_module, "GdiplusShutdown");
	if (GdiplusShutdown) {
		(FUNCTION_CAST_TYPE(void, WINAPI, (ULONG_PTR)) GdiplusShutdown) ((ULONG_PTR) arg2);
	}
}
	;
}
#define INLINE_F10_752
#endif

#ifdef __cplusplus
}
#endif


#ifdef __cplusplus
extern "C" {
#endif

/* {WEL_GDIP_STARTER}.gdi_plus_init */
RTOID (F10_745)
void F10_745 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "gdi_plus_init";
	RTEX;
	EIF_POINTER loc1 = (EIF_POINTER) 0;
	EIF_POINTER tp1;
	EIF_BOOLEAN tb1;
	RTCDD;
	RTSN;
	RTDA;
	RTLD;
	
	RTOTDV(F10_745);
	dtype = Dtype(Current);

	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_VOID, NULL);
	RTLU (SK_REF, &Current);
	RTLU(SK_POINTER, &loc1);
	
	RTEAA(l_feature_name, 9, Current, 1, 0, 742);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(9, Current, 742);
	RTIV(Current, RTAL);
	RTOTP;
	RTHOOK(1);
	tb1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(752, dtype))(Current)).it_b);
	if (tb1) {
		RTHOOK(2);
		RTDBGAL(1, 0x40000000, 1, 0); /* loc1 */
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(751, dtype))(Current)).it_p);
		loc1 = (EIF_POINTER) tp1;
	}
	RTVI(Current, RTAL);
	RTRS;
	RTOTE;
	RTHOOK(3);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(3);
	RTEE;
#undef Result
}

/* {WEL_GDIP_STARTER}.gdi_plus_shutdown */
RTOID (F10_746)
void F10_746 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "gdi_plus_shutdown";
	RTEX;
	EIF_TYPED_VALUE up1x = {{0}, SK_POINTER};
#define up1 up1x.it_p
	EIF_TYPED_VALUE up2x = {{0}, SK_POINTER};
#define up2 up2x.it_p
	EIF_POINTER tp1;
	EIF_POINTER tp2;
	EIF_BOOLEAN tb1;
	RTCDD;
	RTSN;
	RTDA;
	RTLD;
	
	RTOTDV(F10_746);
	dtype = Dtype(Current);

	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_VOID, NULL);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 9, Current, 0, 0, 743);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(9, Current, 743);
	RTIV(Current, RTAL);
	RTOTP;
	RTHOOK(1);
	tb1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(752, dtype))(Current)).it_b);
	if (tb1) {
		RTHOOK(2);
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(750, dtype))(Current)).it_p);
		up1 = tp1;
		tp2 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(751, dtype))(Current)).it_p);
		up2 = tp2;
		(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTWF(755, dtype))(Current, up1x, up2x);
	}
	RTVI(Current, RTAL);
	RTRS;
	RTOTE;
	RTHOOK(3);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
#undef up1
#undef up2
#undef Result
}

/* {WEL_GDIP_STARTER}.gdi_plus_handle */
RTOID (F10_747)
EIF_TYPED_VALUE F10_747 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "gdi_plus_handle";
	RTEX;
	EIF_POINTER tp1;
	RTCDD;
	RTSN;
	RTDA;
	RTLD;
	
#define Result RTOTRB(EIF_POINTER)
	RTOTDB(EIF_POINTER, F10_747);
	dtype = Dtype(Current);

	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_POINTER, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 9, Current, 0, 0, 744);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(9, Current, 744);
	RTIV(Current, RTAL);
	RTOTP;
	RTHOOK(1);
	RTDBGAL(0, 0x40000000, 1,0); /* Result */
	tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(753, dtype))(Current)).it_p);
	Result = (EIF_POINTER) tp1;
	RTVI(Current, RTAL);
	RTRS;
	RTOTE;
	RTHOOK(2);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_POINTER; r.it_p = Result; return r; }
#undef Result
}

/* {WEL_GDIP_STARTER}.gdi_plus_token */
RTOID (F10_748)
EIF_TYPED_VALUE F10_748 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "gdi_plus_token";
	RTEX;
	EIF_TYPED_VALUE up1x = {{0}, SK_POINTER};
#define up1 up1x.it_p
	EIF_POINTER tp1;
	EIF_BOOLEAN tb1;
	RTCDD;
	RTSN;
	RTDA;
	RTLD;
	
#define Result RTOTRB(EIF_POINTER)
	RTOTDB(EIF_POINTER, F10_748);
	dtype = Dtype(Current);

	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_POINTER, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 9, Current, 0, 0, 745);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(9, Current, 745);
	RTIV(Current, RTAL);
	RTOTP;
	RTHOOK(1);
	tb1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(752, dtype))(Current)).it_b);
	if (tb1) {
		RTHOOK(2);
		RTDBGAL(0, 0x40000000, 1,0); /* Result */
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(750, dtype))(Current)).it_p);
		up1 = tp1;
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTWF(754, dtype))(Current, up1x)).it_p);
		Result = (EIF_POINTER) tp1;
	}
	RTVI(Current, RTAL);
	RTRS;
	RTOTE;
	RTHOOK(3);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_POINTER; r.it_p = Result; return r; }
#undef up1
#undef Result
}

/* {WEL_GDIP_STARTER}.is_gdi_plus_installed */
EIF_TYPED_VALUE F10_749 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "is_gdi_plus_installed";
	RTEX;
	EIF_POINTER tp1;
	EIF_POINTER tp2;
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
	
	RTEAA(l_feature_name, 9, Current, 0, 0, 746);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 0);
	RTGC;
	RTDBGEAA(9, Current, 746);
	RTIV(Current, RTAL);
	RTHOOK(1);
	RTDBGAL(0, 0x04000000, 1,0); /* Result */
	tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(750, dtype))(Current)).it_p);
	tp2 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(36, dtype))(Current)).it_p);
	Result = (EIF_BOOLEAN) (EIF_BOOLEAN)(tp1 != tp2);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(2);
	RTDBGLE;
	RTMD(0);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_BOOL; r.it_b = Result; return r; }
}

/* {WEL_GDIP_STARTER}.c_load_gdip_dll */
EIF_TYPED_VALUE F10_750 (EIF_REFERENCE Current)
{
	GTCX
	char *l_feature_name = "c_load_gdip_dll";
	RTEX;
	EIF_POINTER Result = ((EIF_POINTER) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_POINTER, &Result);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 9, Current, 0, 0, 747);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(9, Current, 747);
	RTIV(Current, RTAL);
	Result = inline_F10_750 ();
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(1);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(2);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_POINTER; r.it_p = Result; return r; }
}

/* {WEL_GDIP_STARTER}.c_gdi_plus_startup */
EIF_TYPED_VALUE F10_751 (EIF_REFERENCE Current, EIF_TYPED_VALUE arg1x)
{
	GTCX
	char *l_feature_name = "c_gdi_plus_startup";
	RTEX;
#define arg1 arg1x.it_p
	EIF_POINTER tp1;
	EIF_POINTER Result = ((EIF_POINTER) 0);
	
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	if ((arg1x.type & SK_HEAD) == SK_REF) arg1x.it_p = * (EIF_POINTER *) arg1x.it_r;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_POINTER, &Result);
	RTLU(SK_POINTER,&arg1);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 9, Current, 0, 1, 748);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(9, Current, 748);
	RTIV(Current, RTAL);
	if ((RTAL & CK_REQUIRE) || RTAC) {
		RTHOOK(1);
		RTCT("a_gdiplus_handle_not_null", EX_PRE);
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(36, dtype))(Current)).it_p);
		RTTE((EIF_BOOLEAN)(arg1 != tp1), label_1);
		RTCK;
		RTJB;
label_1:
		RTCF;
	}
body:;
	Result = inline_F10_751 ((EIF_POINTER) arg1);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(2);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(3);
	RTEE;
	{ EIF_TYPED_VALUE r; r.type = SK_POINTER; r.it_p = Result; return r; }
#undef arg1
}

/* {WEL_GDIP_STARTER}.c_gdi_plus_shutdown */
void F10_752 (EIF_REFERENCE Current, EIF_TYPED_VALUE arg1x, EIF_TYPED_VALUE arg2x)
{
	GTCX
	char *l_feature_name = "c_gdi_plus_shutdown";
	RTEX;
#define arg1 arg1x.it_p
#define arg2 arg2x.it_p
	EIF_POINTER tp1;
	RTCDT;
	RTSN;
	RTDA;
	RTLD;
	
	if ((arg2x.type & SK_HEAD) == SK_REF) arg2x.it_p = * (EIF_POINTER *) arg2x.it_r;
	if ((arg1x.type & SK_HEAD) == SK_REF) arg1x.it_p = * (EIF_POINTER *) arg1x.it_r;
	
	RTLI(1);
	RTLR(0,Current);
	RTLIU(1);
	RTLU (SK_VOID, NULL);
	RTLU(SK_POINTER,&arg1);
	RTLU(SK_POINTER,&arg2);
	RTLU (SK_REF, &Current);
	
	RTEAA(l_feature_name, 9, Current, 0, 2, 749);
	RTSA(dtype);
	RTSC;
	RTME(dtype, 1);
	RTDBGEAA(9, Current, 749);
	RTIV(Current, RTAL);
	if ((RTAL & CK_REQUIRE) || RTAC) {
		RTHOOK(1);
		RTCT("a_gdiplus_handle_not_null", EX_PRE);
		tp1 = (((FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) RTWF(36, dtype))(Current)).it_p);
		RTTE((EIF_BOOLEAN)(arg1 != tp1), label_1);
		RTCK;
		RTJB;
label_1:
		RTCF;
	}
body:;
	inline_F10_752 ((EIF_POINTER) arg1, (EIF_POINTER) arg2);
	RTVI(Current, RTAL);
	RTRS;
	RTHOOK(2);
	RTDBGLE;
	RTMD(1);
	RTLE;
	RTLO(4);
	RTEE;
#undef arg2
#undef arg1
}

void EIF_Minit10 (void)
{
	GTCX
	RTOTS (745,F10_745)
	RTOTS (746,F10_746)
	RTOTS (747,F10_747)
	RTOTS (748,F10_748)
}


#ifdef __cplusplus
}
#endif
