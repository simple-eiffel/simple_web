#include "eif_eiffel.h"
#include "eif_rout_obj.h"
#include "eaddress.h"

#ifdef __cplusplus
extern "C" {
#endif

	/* EQA_SYSTEM_PATH extend */
void _A40_43_2 ( void(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTVF(2695, "extend", closed [1].it_r))(closed [1].it_r, open [1]);
}

	/* EQA_TEST_EVALUATOR [G#1] inline-agent#1 of execute */
EIF_TYPED_VALUE _A878_271 ( EIF_TYPED_VALUE(*f_ptr) (EIF_REFERENCE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE)) F878_14509)(closed [1].it_r);
}

	/* PROCEDURE [G#1] call */
void _A593_140 ( void(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTVF(10568, "call", closed [1].it_r))(closed [1].it_r, closed [2]);
}

	/* EQA_TEST_SET clean */
void _A256_39 ( void(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTVF(5781, "clean", closed [1].it_r))(closed [1].it_r, closed [2]);
}

	/* EQA_EVALUATOR invoke_routine */
void _A309_208_2 ( void(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(5383, "invoke_routine", closed [1].it_r))(closed [1].it_r, open [1], closed [2]);
}

	/* MISMATCH_INFORMATION wipe_out */
void A406_98 (EIF_REFERENCE Current)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE)) RTVF(8964, "wipe_out", Current))(Current);
}

	/* MISMATCH_INFORMATION internal_put */
void A406_162 (EIF_REFERENCE Current, EIF_REFERENCE arg1, EIF_POINTER arg2)
{
	EIF_TYPED_VALUE u [2];
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(9521, "internal_put", Current))(Current, ((u [0].type = SK_REF), (u [0].it_r = arg1), u [0]), ((u [1].type = SK_POINTER), (u [1].it_p = arg2), u [1]));
}

	/* MISMATCH_INFORMATION set_string_versions */
void A406_163 (EIF_REFERENCE Current, EIF_POINTER arg1, EIF_POINTER arg2)
{
	EIF_TYPED_VALUE u [2];
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(9522, "set_string_versions", Current))(Current, ((u [0].type = SK_POINTER), (u [0].it_p = arg1), u [0]), ((u [1].type = SK_POINTER), (u [1].it_p = arg2), u [1]));
}

	/* RT_DBG_CALL_RECORD inline-agent#1 of record_fields */
void _A409_159_2 ( void(*f_ptr) (EIF_REFERENCE, EIF_TYPED_VALUE), EIF_TYPED_VALUE * closed, EIF_TYPED_VALUE * open)
{
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) F409_14552)(closed [1].it_r, open [1]);
}

	/* WEL_WINDOW_ENUMERATOR enumerate_hwnd_callback */
void A524_146 (EIF_REFERENCE Current, EIF_POINTER arg1)
{
	EIF_TYPED_VALUE u [1];
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTVF(11934, "enumerate_hwnd_callback", Current))(Current, ((u [0].type = SK_POINTER), (u [0].it_p = arg1), u [0]));
}

	/* WEL_WINDOW_ENUMERATOR enumerate_child_windows_callback */
void A524_145 (EIF_REFERENCE Current, EIF_POINTER arg1)
{
	EIF_TYPED_VALUE u [1];
	GTCX
	(FUNCTION_CAST(void, (EIF_REFERENCE, EIF_TYPED_VALUE)) RTVF(11933, "enumerate_child_windows_callback", Current))(Current, ((u [0].type = SK_POINTER), (u [0].it_p = arg1), u [0]));
}

	/* WEL_DISPATCHER window_procedure */
EIF_POINTER A531_367 (EIF_REFERENCE Current, EIF_POINTER arg1, EIF_INTEGER_32 arg2, EIF_POINTER arg3, EIF_POINTER arg4)
{
	EIF_TYPED_VALUE u [4];
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(12035, "window_procedure", Current))(Current, ((u [0].type = SK_POINTER), (u [0].it_p = arg1), u [0]), ((u [1].type = SK_INT32), (u [1].it_i4 = arg2), u [1]), ((u [2].type = SK_POINTER), (u [2].it_p = arg3), u [2]), ((u [3].type = SK_POINTER), (u [3].it_p = arg4), u [3])).it_p;
}

	/* WEL_DISPATCHER dialog_procedure */
EIF_POINTER A531_368 (EIF_REFERENCE Current, EIF_POINTER arg1, EIF_INTEGER_32 arg2, EIF_POINTER arg3, EIF_POINTER arg4)
{
	EIF_TYPED_VALUE u [4];
	GTCX
	return (FUNCTION_CAST(EIF_TYPED_VALUE, (EIF_REFERENCE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE, EIF_TYPED_VALUE)) RTVF(12036, "dialog_procedure", Current))(Current, ((u [0].type = SK_POINTER), (u [0].it_p = arg1), u [0]), ((u [1].type = SK_INT32), (u [1].it_i4 = arg2), u [1]), ((u [2].type = SK_POINTER), (u [2].it_p = arg3), u [2]), ((u [3].type = SK_POINTER), (u [3].it_p = arg4), u [3])).it_p;
}


static fnptr feif_address_table[] = {
(fnptr)0,
(fnptr)A406_98,
(fnptr)A406_162,
(fnptr)A406_163,
(fnptr)A524_146,
(fnptr)A524_145,
(fnptr)A531_367,
(fnptr)A531_368,
};

fnptr *egc_address_table_init = feif_address_table;



#ifdef __cplusplus
}
#endif
