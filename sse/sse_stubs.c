#include <assert.h>
#include <stdlib.h>
#include <stdint.h>

#include <caml/mlvalues.h>

void ocaml_simd_sse_unreachable() {
  assert(!"SIMD is not supported in bytecode mode.");
  abort();
}

// The following intrinsics are always builtins.

#define BUILTIN(name)                                                                    \
  CAMLweakdef void name() {                                                              \
    assert(!"Didn't use [@@builtin] intrinsic.");                                        \
    abort();                                                                             \
  }

BUILTIN(caml_native_pointer_store_unboxed_int64)
BUILTIN(caml_native_pointer_store_unboxed_int32)

BUILTIN(caml_vec128_cast)

BUILTIN(caml_float32x4_const1)
BUILTIN(caml_float32x4_const4)
BUILTIN(caml_float32x4_low_of_float32)
BUILTIN(caml_float32x4_low_to_float32)
BUILTIN(caml_float64x2_const1)
BUILTIN(caml_float64x2_const2)
BUILTIN(caml_float64x2_low_of_float)
BUILTIN(caml_float64x2_low_to_float)
BUILTIN(caml_int16x8_const1)
BUILTIN(caml_int16x8_const8)
BUILTIN(caml_int16x8_low_of_int16)
BUILTIN(caml_int16x8_low_to_int16)
BUILTIN(caml_int32x4_const1)
BUILTIN(caml_int32x4_const4)
BUILTIN(caml_int32x4_low_of_int32)
BUILTIN(caml_int32x4_low_to_int32)
BUILTIN(caml_int64x2_const1)
BUILTIN(caml_int64x2_const2)
BUILTIN(caml_int64x2_low_of_int64)
BUILTIN(caml_int64x2_low_to_int64)
BUILTIN(caml_int8x16_const1)
BUILTIN(caml_int8x16_const16)
BUILTIN(caml_int8x16_low_of_int8)
BUILTIN(caml_int8x16_low_to_int8)

BUILTIN(caml_sse_float32x4_add)
BUILTIN(caml_sse_float32x4_cmp)
BUILTIN(caml_sse_float32x4_div)
BUILTIN(caml_sse_float32x4_max)
BUILTIN(caml_sse_float32x4_min)
BUILTIN(caml_sse_float32x4_mul)
BUILTIN(caml_sse_float32x4_rcp)
BUILTIN(caml_sse_float32x4_rsqrt)
BUILTIN(caml_sse_float32x4_sqrt)
BUILTIN(caml_sse_float32x4_sub)
BUILTIN(caml_sse_vec128_and)
BUILTIN(caml_sse_vec128_andnot)
BUILTIN(caml_sse_vec128_high_64_to_low_64)
BUILTIN(caml_sse_vec128_interleave_high_32)
BUILTIN(caml_sse_vec128_interleave_low_32)
BUILTIN(caml_sse_vec128_low_64_to_high_64)
BUILTIN(caml_sse_vec128_or)
BUILTIN(caml_sse_vec128_xor)
BUILTIN(caml_sse2_cvt_float32x4_float64x2)
BUILTIN(caml_sse2_cvt_float32x4_int32x4)
BUILTIN(caml_sse2_cvt_float64x2_float32x2)
BUILTIN(caml_sse2_cvt_float64x2_int32x2)
BUILTIN(caml_sse2_cvt_int16x8_int8x16_saturating)
BUILTIN(caml_sse2_cvt_int32x4_float32x4)
BUILTIN(caml_sse2_cvt_int32x4_float64x2)
BUILTIN(caml_sse2_cvt_int32x4_int16x8_saturating)
BUILTIN(caml_sse2_cvtt_float32x4_int32x4)
BUILTIN(caml_sse2_cvtt_float64x2_int32x2)
BUILTIN(caml_sse2_float64x2_add)
BUILTIN(caml_sse2_float64x2_cmp)
BUILTIN(caml_sse2_float64x2_div)
BUILTIN(caml_sse2_float64x2_max)
BUILTIN(caml_sse2_float64x2_min)
BUILTIN(caml_sse2_float64x2_mul)
BUILTIN(caml_sse2_float64x2_sqrt)
BUILTIN(caml_sse2_float64x2_sub)
BUILTIN(caml_sse2_int16x8_add_saturating_unsigned)
BUILTIN(caml_sse2_int16x8_add_saturating)
BUILTIN(caml_sse2_int16x8_add)
BUILTIN(caml_sse2_int16x8_cmpeq)
BUILTIN(caml_sse2_int16x8_cmpgt)
BUILTIN(caml_sse2_int16x8_max)
BUILTIN(caml_sse2_int16x8_min)
BUILTIN(caml_sse2_int16x8_mul_high_unsigned)
BUILTIN(caml_sse2_int16x8_mul_high)
BUILTIN(caml_sse2_int16x8_mul_low)
BUILTIN(caml_sse2_int16x8_sll)
BUILTIN(caml_sse2_int16x8_slli)
BUILTIN(caml_sse2_int16x8_sra)
BUILTIN(caml_sse2_int16x8_srai)
BUILTIN(caml_sse2_int16x8_srl)
BUILTIN(caml_sse2_int16x8_srli)
BUILTIN(caml_sse2_int16x8_sub_saturating_unsigned)
BUILTIN(caml_sse2_int16x8_sub_saturating)
BUILTIN(caml_sse2_int16x8_sub)
BUILTIN(caml_sse2_int32x4_add)
BUILTIN(caml_sse2_int32x4_cmpeq)
BUILTIN(caml_sse2_int32x4_cmpgt)
BUILTIN(caml_sse2_int32x4_sll)
BUILTIN(caml_sse2_int32x4_slli)
BUILTIN(caml_sse2_int32x4_sra)
BUILTIN(caml_sse2_int32x4_srai)
BUILTIN(caml_sse2_int32x4_srl)
BUILTIN(caml_sse2_int32x4_srli)
BUILTIN(caml_sse2_int32x4_sub)
BUILTIN(caml_sse2_int64x2_add)
BUILTIN(caml_sse2_int64x2_sll)
BUILTIN(caml_sse2_int64x2_slli)
BUILTIN(caml_sse2_int64x2_srl)
BUILTIN(caml_sse2_int64x2_srli)
BUILTIN(caml_sse2_int64x2_sub)
BUILTIN(caml_sse2_int8x16_add_saturating_unsigned)
BUILTIN(caml_sse2_int8x16_add_saturating)
BUILTIN(caml_sse2_int8x16_add)
BUILTIN(caml_sse2_int8x16_cmpeq)
BUILTIN(caml_sse2_int8x16_cmpgt)
BUILTIN(caml_sse2_int8x16_max_unsigned)
BUILTIN(caml_sse2_int8x16_min_unsigned)
BUILTIN(caml_sse2_int8x16_sub_saturating_unsigned)
BUILTIN(caml_sse2_int8x16_sub_saturating)
BUILTIN(caml_sse2_int8x16_sub)
BUILTIN(caml_sse2_vec128_interleave_high_16)
BUILTIN(caml_sse2_vec128_interleave_high_64)
BUILTIN(caml_sse2_vec128_interleave_high_8)
BUILTIN(caml_sse2_vec128_interleave_low_16)
BUILTIN(caml_sse2_vec128_interleave_low_64)
BUILTIN(caml_sse2_vec128_interleave_low_8)
BUILTIN(caml_sse2_vec128_shift_left_bytes)
BUILTIN(caml_sse2_vec128_shift_right_bytes)
BUILTIN(caml_sse3_float32x4_hadd)
BUILTIN(caml_sse3_float64x2_hadd)
BUILTIN(caml_sse3_vec128_dup_low_64)
BUILTIN(caml_sse41_cvtsx_int16x8_int32x4)
BUILTIN(caml_sse41_cvtsx_int16x8_int64x2)
BUILTIN(caml_sse41_cvtsx_int32x4_int64x2)
BUILTIN(caml_sse41_cvtsx_int8x16_int16x8)
BUILTIN(caml_sse41_cvtsx_int8x16_int32x4)
BUILTIN(caml_sse41_cvtsx_int8x16_int64x2)
BUILTIN(caml_sse41_cvtzx_int16x8_int32x4)
BUILTIN(caml_sse41_cvtzx_int16x8_int64x2)
BUILTIN(caml_sse41_cvtzx_int32x4_int64x2)
BUILTIN(caml_sse41_cvtzx_int8x16_int16x8)
BUILTIN(caml_sse41_cvtzx_int8x16_int32x4)
BUILTIN(caml_sse41_cvtzx_int8x16_int64x2)
BUILTIN(caml_sse41_float32x4_round)
BUILTIN(caml_sse41_float64x2_round)
BUILTIN(caml_sse41_int16x8_extract)
BUILTIN(caml_sse41_int16x8_insert)
BUILTIN(caml_sse41_int16x8_max_unsigned)
BUILTIN(caml_sse41_int16x8_min_unsigned)
BUILTIN(caml_sse41_int32x4_extract)
BUILTIN(caml_sse41_int32x4_insert)
BUILTIN(caml_sse41_int32x4_max_unsigned)
BUILTIN(caml_sse41_int32x4_max)
BUILTIN(caml_sse41_int32x4_min_unsigned)
BUILTIN(caml_sse41_int32x4_min)
BUILTIN(caml_sse41_int32x4_mul_low)
BUILTIN(caml_sse41_int64x2_cmpeq)
BUILTIN(caml_sse41_int64x2_extract)
BUILTIN(caml_sse41_int64x2_insert)
BUILTIN(caml_sse41_int8x16_extract)
BUILTIN(caml_sse41_int8x16_insert)
BUILTIN(caml_sse41_int8x16_max)
BUILTIN(caml_sse41_int8x16_min)
BUILTIN(caml_sse42_int64x2_cmpgt)
BUILTIN(caml_ssse3_int16x8_abs)
BUILTIN(caml_ssse3_int16x8_hadd)
BUILTIN(caml_ssse3_int32x4_abs)
BUILTIN(caml_ssse3_int32x4_hadd)
BUILTIN(caml_ssse3_int8x16_abs)

BUILTIN(caml_neon_cvt_float32x2_to_float64x2)
BUILTIN(caml_neon_cvt_float32x4_to_int32x4)
BUILTIN(caml_neon_cvt_float64x2_to_float32x2)
BUILTIN(caml_neon_cvt_float64x2_to_int64x2)
BUILTIN(caml_neon_cvt_int16x8_to_int8x16_high_saturating_unsigned)
BUILTIN(caml_neon_cvt_int16x8_to_int8x16_high_saturating)
BUILTIN(caml_neon_cvt_int16x8_to_int8x16_low_saturating_unsigned)
BUILTIN(caml_neon_cvt_int16x8_to_int8x16_low_saturating)
BUILTIN(caml_neon_cvt_int32x4_to_float32x4)
BUILTIN(caml_neon_cvt_int32x4_to_int16x8_high_saturating)
BUILTIN(caml_neon_cvt_int32x4_to_int16x8_high)
BUILTIN(caml_neon_cvt_int32x4_to_int16x8_low_saturating)
BUILTIN(caml_neon_cvt_int32x4_to_int16x8_low)
BUILTIN(caml_neon_cvt_int64x2_to_float64x2)
BUILTIN(caml_neon_cvt_int64x2_to_int32x4_low_saturating)
BUILTIN(caml_neon_cvtsx_int16x8_to_int32x4)
BUILTIN(caml_neon_cvtsx_int32x4_to_int64x2)
BUILTIN(caml_neon_cvtsx_int8x16_to_int16x8)
BUILTIN(caml_neon_cvtt_float32x4_to_int32x4)
BUILTIN(caml_neon_cvtt_float64x2_to_int64x2)
BUILTIN(caml_neon_cvtzx_int16x8_to_int32x4)
BUILTIN(caml_neon_cvtzx_int32x4_to_int64x2)
BUILTIN(caml_neon_cvtzx_int8x16_to_int16x8)
BUILTIN(caml_neon_float32x4_add)
BUILTIN(caml_neon_float32x4_cmeq)
BUILTIN(caml_neon_float32x4_cmge)
BUILTIN(caml_neon_float32x4_cmgt)
BUILTIN(caml_neon_float32x4_cmle)
BUILTIN(caml_neon_float32x4_cmlt)
BUILTIN(caml_neon_float32x4_div)
BUILTIN(caml_neon_float32x4_hadd)
BUILTIN(caml_neon_float32x4_max)
BUILTIN(caml_neon_float32x4_min)
BUILTIN(caml_neon_float32x4_mul)
BUILTIN(caml_neon_float32x4_rcp)
BUILTIN(caml_neon_float32x4_round_current)
BUILTIN(caml_neon_float32x4_round_near)
BUILTIN(caml_neon_float32x4_round_neg_inf)
BUILTIN(caml_neon_float32x4_round_pos_inf)
BUILTIN(caml_neon_float32x4_round_towards_zero)
BUILTIN(caml_neon_float32x4_rsqrt)
BUILTIN(caml_neon_float32x4_sqrt)
BUILTIN(caml_neon_float32x4_sub)
BUILTIN(caml_neon_float32x4_zip1)
BUILTIN(caml_neon_float32x4_zip2)
BUILTIN(caml_neon_float64x2_add)
BUILTIN(caml_neon_float64x2_cmeq)
BUILTIN(caml_neon_float64x2_cmge)
BUILTIN(caml_neon_float64x2_cmgt)
BUILTIN(caml_neon_float64x2_cmle)
BUILTIN(caml_neon_float64x2_cmlt)
BUILTIN(caml_neon_float64x2_div)
BUILTIN(caml_neon_float64x2_hadd)
BUILTIN(caml_neon_float64x2_max)
BUILTIN(caml_neon_float64x2_min)
BUILTIN(caml_neon_float64x2_mul)
BUILTIN(caml_neon_float64x2_round_current)
BUILTIN(caml_neon_float64x2_round_near)
BUILTIN(caml_neon_float64x2_round_neg_inf)
BUILTIN(caml_neon_float64x2_round_pos_inf)
BUILTIN(caml_neon_float64x2_round_towards_zero)
BUILTIN(caml_neon_float64x2_sqrt)
BUILTIN(caml_neon_float64x2_sub)
BUILTIN(caml_neon_float64x2_zip1)
BUILTIN(caml_neon_float64x2_zip2)
BUILTIN(caml_neon_int16x8_abs)
BUILTIN(caml_neon_int16x8_add_saturating_unsigned)
BUILTIN(caml_neon_int16x8_add_saturating)
BUILTIN(caml_neon_int16x8_add)
BUILTIN(caml_neon_int16x8_bitwise_and)
BUILTIN(caml_neon_int16x8_bitwise_or)
BUILTIN(caml_neon_int16x8_bitwise_xor)
BUILTIN(caml_neon_int16x8_cmpeq)
BUILTIN(caml_neon_int16x8_cmpgt)
BUILTIN(caml_neon_int16x8_dup)
BUILTIN(caml_neon_int16x8_extract)
BUILTIN(caml_neon_int16x8_hadd)
BUILTIN(caml_neon_int16x8_insert)
BUILTIN(caml_neon_int16x8_max_unsigned)
BUILTIN(caml_neon_int16x8_max)
BUILTIN(caml_neon_int16x8_min_unsigned)
BUILTIN(caml_neon_int16x8_min)
BUILTIN(caml_neon_int16x8_mul_high_long_unsigned)
BUILTIN(caml_neon_int16x8_mul_high_long)
BUILTIN(caml_neon_int16x8_mul_low_long_unsigned)
BUILTIN(caml_neon_int16x8_mul_low_long)
BUILTIN(caml_neon_int16x8_mul_low)
BUILTIN(caml_neon_int16x8_slli)
BUILTIN(caml_neon_int16x8_srai)
BUILTIN(caml_neon_int16x8_srli)
BUILTIN(caml_neon_int16x8_sshl)
BUILTIN(caml_neon_int16x8_sub_saturating_unsigned)
BUILTIN(caml_neon_int16x8_sub_saturating)
BUILTIN(caml_neon_int16x8_sub)
BUILTIN(caml_neon_int16x8_ushl)
BUILTIN(caml_neon_int16x8_zip1)
BUILTIN(caml_neon_int16x8_zip2)
BUILTIN(caml_neon_int32x4_abs)
BUILTIN(caml_neon_int32x4_add)
BUILTIN(caml_neon_int32x4_bitwise_and)
BUILTIN(caml_neon_int32x4_bitwise_or)
BUILTIN(caml_neon_int32x4_bitwise_xor)
BUILTIN(caml_neon_int32x4_cmpeq)
BUILTIN(caml_neon_int32x4_cmpgt)
BUILTIN(caml_neon_int32x4_dup)
BUILTIN(caml_neon_int32x4_extract)
BUILTIN(caml_neon_int32x4_hadd)
BUILTIN(caml_neon_int32x4_insert)
BUILTIN(caml_neon_int32x4_max_unsigned)
BUILTIN(caml_neon_int32x4_max)
BUILTIN(caml_neon_int32x4_min_unsigned)
BUILTIN(caml_neon_int32x4_min)
BUILTIN(caml_neon_int32x4_mul_low)
BUILTIN(caml_neon_int32x4_slli)
BUILTIN(caml_neon_int32x4_srai)
BUILTIN(caml_neon_int32x4_srli)
BUILTIN(caml_neon_int32x4_sshl)
BUILTIN(caml_neon_int32x4_sub)
BUILTIN(caml_neon_int32x4_ushl)
BUILTIN(caml_neon_int64x2_add)
BUILTIN(caml_neon_int64x2_bitwise_and)
BUILTIN(caml_neon_int64x2_bitwise_or)
BUILTIN(caml_neon_int64x2_bitwise_xor)
BUILTIN(caml_neon_int64x2_cmpeq)
BUILTIN(caml_neon_int64x2_cmpgt)
BUILTIN(caml_neon_int64x2_dup)
BUILTIN(caml_neon_int64x2_extract)
BUILTIN(caml_neon_int64x2_insert)
BUILTIN(caml_neon_int64x2_slli)
BUILTIN(caml_neon_int64x2_srai)
BUILTIN(caml_neon_int64x2_srli)
BUILTIN(caml_neon_int64x2_sshl)
BUILTIN(caml_neon_int64x2_sub)
BUILTIN(caml_neon_int64x2_ushl)
BUILTIN(caml_neon_int8x16_abs)
BUILTIN(caml_neon_int8x16_add_saturating_unsigned)
BUILTIN(caml_neon_int8x16_add_saturating)
BUILTIN(caml_neon_int8x16_add)
BUILTIN(caml_neon_int8x16_bitwise_and)
BUILTIN(caml_neon_int8x16_bitwise_or)
BUILTIN(caml_neon_int8x16_bitwise_xor)
BUILTIN(caml_neon_int8x16_cmpeq)
BUILTIN(caml_neon_int8x16_cmpgt)
BUILTIN(caml_neon_int8x16_dup)
BUILTIN(caml_neon_int8x16_extract)
BUILTIN(caml_neon_int8x16_insert)
BUILTIN(caml_neon_int8x16_max_unsigned)
BUILTIN(caml_neon_int8x16_max)
BUILTIN(caml_neon_int8x16_min_unsigned)
BUILTIN(caml_neon_int8x16_min)
BUILTIN(caml_neon_int8x16_sub_saturating_unsigned)
BUILTIN(caml_neon_int8x16_sub_saturating)
BUILTIN(caml_neon_int8x16_sub)
BUILTIN(caml_neon_int8x16_zip1)
BUILTIN(caml_neon_int8x16_zip2)
BUILTIN(caml_neon_vec128_shift_left_bytes)
BUILTIN(caml_neon_vec128_shift_right_bytes)
BUILTIN(caml_neon_vec128_low_64_to_high_64)
BUILTIN(caml_neon_vec128_high_64_to_low_64)

// On amd64, all intrinsics are compiler builtins. On arm64, some are builtins and others
// are emulated using simd-everywhere.
#ifdef __x86_64__

BUILTIN(caml_popcnt_int16)
BUILTIN(caml_popcnt_int32)
BUILTIN(caml_popcnt_int64)

BUILTIN(caml_sse_vec128_load_aligned)
BUILTIN(caml_sse_vec128_load_unaligned)
BUILTIN(caml_sse_vec128_store_aligned)
BUILTIN(caml_sse_vec128_store_unaligned)
BUILTIN(caml_sse_vec128_store_aligned_uncached)
BUILTIN(caml_sse2_int32_store_uncached)
BUILTIN(caml_sse2_int64_store_uncached)
BUILTIN(caml_sse2_vec128_load_low64)
BUILTIN(caml_sse2_vec128_load_low64_copy_high64)
BUILTIN(caml_sse2_vec128_load_high64_copy_low64)
BUILTIN(caml_sse2_vec128_load_zero_low64)
BUILTIN(caml_sse2_vec128_store_low64)
BUILTIN(caml_sse2_vec128_load_low32)
BUILTIN(caml_sse2_vec128_load_zero_low32)
BUILTIN(caml_sse2_vec128_store_low32)
BUILTIN(caml_sse2_vec128_store_mask8)
BUILTIN(caml_sse3_vec128_load_broadcast64)
BUILTIN(caml_sse3_vec128_load_known_unaligned)
BUILTIN(caml_sse41_vec128_load_aligned_uncached)
BUILTIN(caml_sse2_cvt_int16x8_int8x16_saturating_unsigned)
BUILTIN(caml_sse2_cvt_int32x4_int16x8_saturating_unsigned)
BUILTIN(caml_sse2_int16x8_mul_hadd_int32x4)
BUILTIN(caml_sse2_int32x4_mul_even_unsigned)
BUILTIN(caml_sse3_float32x4_addsub)
BUILTIN(caml_sse3_float64x2_addsub)
BUILTIN(caml_sse3_float32x4_hsub)
BUILTIN(caml_sse3_float64x2_hsub)
BUILTIN(caml_sse3_vec128_dup_odd_32)
BUILTIN(caml_sse3_vec128_dup_even_32)
BUILTIN(caml_ssse3_int16x8_hadd_saturating)
BUILTIN(caml_ssse3_int16x8_hsub)
BUILTIN(caml_ssse3_int32x4_hsub)
BUILTIN(caml_ssse3_int16x8_hsub_saturating)
BUILTIN(caml_ssse3_int8x16_mulsign)
BUILTIN(caml_ssse3_int8x16_mul_unsigned_hadd_saturating_int16x8)
BUILTIN(caml_ssse3_int16x8_mul_round)
BUILTIN(caml_sse41_int16x8_minpos_unsigned)
BUILTIN(caml_sse41_int32x4_mul_even)
BUILTIN(caml_ssse3_int16x8_mulsign)
BUILTIN(caml_ssse3_int32x4_mulsign)
BUILTIN(caml_sse2_int8x16_avg_unsigned)
BUILTIN(caml_sse2_int16x8_avg_unsigned)
BUILTIN(caml_sse2_int8x16_sad_unsigned)
BUILTIN(caml_sse41_int8x16_multi_sad_unsigned)
BUILTIN(caml_sse41_float64x2_dp)
BUILTIN(caml_sse41_float32x4_dp)
BUILTIN(caml_sse41_vec128_testz)
BUILTIN(caml_sse41_vec128_testc)
BUILTIN(caml_sse41_vec128_testnzc)
BUILTIN(caml_sse2_vec128_movemask_8)
BUILTIN(caml_sse_vec128_movemask_32)
BUILTIN(caml_sse2_vec128_movemask_64)
BUILTIN(caml_ssse3_vec128_shuffle_8)
BUILTIN(caml_sse2_vec128_shuffle_low_16)
BUILTIN(caml_sse2_vec128_shuffle_high_16)
BUILTIN(caml_sse_vec128_shuffle_32)
BUILTIN(caml_sse2_vec128_shuffle_64)
BUILTIN(caml_ssse3_vec128_align_right_bytes)
BUILTIN(caml_sse41_vec128_blend_16)
BUILTIN(caml_sse41_vec128_blend_32)
BUILTIN(caml_sse41_vec128_blend_64)
BUILTIN(caml_sse41_vec128_blendv_8)
BUILTIN(caml_sse41_vec128_blendv_32)
BUILTIN(caml_sse41_vec128_blendv_64)
BUILTIN(caml_clmul_int64x2)
BUILTIN(caml_sse42_vec128_cmpistrm)
BUILTIN(caml_sse42_vec128_cmpistri)
BUILTIN(caml_sse42_vec128_cmpistra)
BUILTIN(caml_sse42_vec128_cmpistrc)
BUILTIN(caml_sse42_vec128_cmpistro)
BUILTIN(caml_sse42_vec128_cmpistrs)
BUILTIN(caml_sse42_vec128_cmpistrz)
BUILTIN(caml_sse42_vec128_cmpestrm)
BUILTIN(caml_sse42_vec128_cmpestri)
BUILTIN(caml_sse42_vec128_cmpestra)
BUILTIN(caml_sse42_vec128_cmpestrc)
BUILTIN(caml_sse42_vec128_cmpestro)
BUILTIN(caml_sse42_vec128_cmpestrs)
BUILTIN(caml_sse42_vec128_cmpestrz)

#elif defined(__aarch64__)

#define SIMDE_ENABLE_NATIVE_ALIASES
#include <simde/x86/sse.h>
#include <simde/x86/sse2.h>
#include <simde/x86/sse3.h>
#include <simde/x86/ssse3.h>
#include <simde/x86/sse4.1.h>
#include <simde/x86/sse4.2.h>
#include <simde/x86/clmul.h>
typedef __int64_t __int64;

// Instructions that require a compile-time immediate are expanded into a dynamic switch
// for each possible value. This is grossly inefficient, but is only used for emulated
// instructions, which will eventually be replaced.
#define CASE(F, i)                                                                       \
  case (i):                                                                              \
    return F((i));
#define CASE2(F, i) CASE(F, i) CASE(F, i + 1)
#define CASE4(F, i) CASE2(F, i) CASE2(F, i + 2)
#define CASE8(F, i) CASE4(F, i) CASE4(F, i + 4)
#define CASE16(F, i) CASE8(F, i) CASE8(F, i + 8)
#define CASE32(F, i) CASE16(F, i) CASE16(F, i + 16)
#define CASE64(F, i) CASE32(F, i) CASE32(F, i + 32)
#define CASE128(F, i) CASE64(F, i) CASE64(F, i + 64)
#define CASE256(F, i) CASE128(F, i) CASE128(F, i + 128)

uint16_t caml_popcnt_int16(int16_t x) { return __builtin_popcount((uint16_t)x); }
uint32_t caml_popcnt_int32(int32_t x) { return __builtin_popcount(x); }
uint64_t caml_popcnt_int64(int64_t x) { return __builtin_popcountll(x); }

__m128i caml_sse_vec128_load_aligned(intnat addr) {
  return _mm_load_si128((__m128i *)addr);
}

__m128i caml_sse_vec128_load_unaligned(intnat addr) {
  return _mm_loadu_si128((__m128i *)addr);
}

__m128i caml_sse3_vec128_load_known_unaligned(intnat addr) {
  return _mm_lddqu_si128((__m128i *)addr);
}

void caml_sse_vec128_store_aligned(intnat addr, __m128i v) {
  _mm_store_si128((__m128i *)addr, v);
}

void caml_sse_vec128_store_unaligned(intnat addr, __m128i v) {
  _mm_storeu_si128((__m128i *)addr, v);
}

void caml_sse_vec128_store_aligned_uncached(intnat addr, __m128i v) {
  _mm_stream_si128((__m128i *)addr, v);
}

void caml_sse2_int32_store_uncached(intnat addr, int32_t v) {
  _mm_stream_si32((int *)addr, v);
}

void caml_sse2_int64_store_uncached(intnat addr, int64_t v) {
  _mm_stream_si64((int64_t *)addr, v);
}

__m128i caml_sse2_vec128_load_low64(intnat addr) {
  return _mm_loadl_epi64((__m128i *)addr);
}

__m128d caml_sse2_vec128_load_low64_copy_high64(__m128d v, intnat addr) {
  return _mm_loadl_pd(v, (double *)addr);
}

__m128d caml_sse2_vec128_load_high64_copy_low64(__m128d v, intnat addr) {
  return _mm_loadh_pd(v, (double *)addr);
}

__m128i caml_sse2_vec128_load_zero_low64(intnat addr) {
  return _mm_loadl_epi64((__m128i *)addr);
}

void caml_sse2_vec128_store_low64(intnat addr, __m128i v) {
  _mm_storel_epi64((__m128i *)addr, v);
}

__m128i caml_sse2_vec128_load_low32(intnat addr) {
  return _mm_cvtsi32_si128(*(int32_t *)addr);
}

__m128i caml_sse2_vec128_load_zero_low32(intnat addr) {
  return _mm_cvtsi32_si128(*(int32_t *)addr);
}

void caml_sse2_vec128_store_low32(intnat addr, __m128i v) {
  *(int32_t *)addr = _mm_cvtsi128_si32(v);
}

void caml_sse2_vec128_store_mask8(intnat addr, __m128i v, __m128i mask) {
  _mm_maskmoveu_si128(v, mask, (char *)addr);
}

__m128d caml_sse3_vec128_load_broadcast64(intnat addr) {
  return _mm_loaddup_pd((double *)addr);
}

__m128i caml_sse41_vec128_load_aligned_uncached(intnat addr) {
  return _mm_stream_load_si128((__m128i *)addr);
}

__m128i caml_sse2_cvt_int16x8_int8x16_saturating_unsigned(__m128i a, __m128i b) {
  return _mm_packus_epi16(a, b);
}

__m128i caml_sse2_cvt_int32x4_int16x8_saturating_unsigned(__m128i a, __m128i b) {
  return _mm_packus_epi32(a, b);
}

__m128i caml_ssse3_int16x8_hsub(__m128i a, __m128i b) { return _mm_hsub_epi16(a, b); }

__m128i caml_ssse3_int16x8_hadd_saturating(__m128i a, __m128i b) {
  return _mm_hadds_epi16(a, b);
}

__m128i caml_ssse3_int16x8_hsub_saturating(__m128i a, __m128i b) {
  return _mm_hsubs_epi16(a, b);
}

__m128i caml_ssse3_int32x4_hsub(__m128i a, __m128i b) { return _mm_hsub_epi32(a, b); }

__m128i caml_sse2_int16x8_mul_hadd_int32x4(__m128i a, __m128i b) {
  return _mm_madd_epi16(a, b);
}

__m128 caml_sse3_float32x4_addsub(__m128 a, __m128 b) { return _mm_addsub_ps(a, b); }

__m128d caml_sse3_float64x2_addsub(__m128d a, __m128d b) { return _mm_addsub_pd(a, b); }

__m128 caml_sse3_float32x4_hsub(__m128 a, __m128 b) { return _mm_hsub_ps(a, b); }

__m128d caml_sse3_float64x2_hsub(__m128d a, __m128d b) { return _mm_hsub_pd(a, b); }

__m128 caml_sse3_vec128_dup_odd_32(__m128 a) { return _mm_movehdup_ps(a); }

__m128 caml_sse3_vec128_dup_even_32(__m128 a) { return _mm_moveldup_ps(a); }

__m128i caml_ssse3_int8x16_mul_unsigned_hadd_saturating_int16x8(__m128i a, __m128i b) {
  return _mm_maddubs_epi16(a, b);
}

__m128i caml_ssse3_int16x8_mul_round(__m128i a, __m128i b) {
  return _mm_mulhrs_epi16(a, b);
}

__m128i caml_sse2_int32x4_mul_even_unsigned(__m128i a, __m128i b) {
  return _mm_mul_epu32(a, b);
}

__m128i caml_sse41_int32x4_mul_even(__m128i a, __m128i b) { return _mm_mul_epi32(a, b); }

__m128i caml_sse41_int16x8_minpos_unsigned(__m128i a) { return _mm_minpos_epu16(a); }

__m128i caml_ssse3_int8x16_mulsign(__m128i a, __m128i b) { return _mm_sign_epi8(a, b); }

__m128i caml_ssse3_int16x8_mulsign(__m128i a, __m128i b) { return _mm_sign_epi16(a, b); }

__m128i caml_ssse3_int32x4_mulsign(__m128i a, __m128i b) { return _mm_sign_epi32(a, b); }

__m128i caml_sse2_int8x16_avg_unsigned(__m128i a, __m128i b) {
  return _mm_avg_epu8(a, b);
}

__m128i caml_sse2_int16x8_avg_unsigned(__m128i a, __m128i b) {
  return _mm_avg_epu16(a, b);
}

__m128i caml_sse2_int8x16_sad_unsigned(__m128i a, __m128i b) {
  return _mm_sad_epu8(a, b);
}

__m128i caml_sse41_int8x16_multi_sad_unsigned(intnat imm, __m128i a, __m128i b) {
#define F(i) _mm_mpsadbw_epu8(a, b, i)
  switch (imm & 0x7) {
    CASE8(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128d caml_sse41_float64x2_dp(intnat imm, __m128d a, __m128d b) {
#define F(i) _mm_dp_pd(a, b, i)
  switch (imm & 0x33) {
    CASE4(F, 0)
    CASE4(F, 0x10)
    CASE4(F, 0x20)
    CASE4(F, 0x30)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128 caml_sse41_float32x4_dp(intnat imm, __m128 a, __m128 b) {
#define F(i) _mm_dp_ps(a, b, i)
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

intnat caml_sse41_vec128_testz(__m128i a, __m128i b) { return _mm_testz_si128(a, b); }

intnat caml_sse41_vec128_testc(__m128i a, __m128i b) { return _mm_testc_si128(a, b); }

intnat caml_sse41_vec128_testnzc(__m128i a, __m128i b) { return _mm_testnzc_si128(a, b); }

intnat caml_sse2_vec128_movemask_8(__m128i a) { return _mm_movemask_epi8(a); }

intnat caml_sse_vec128_movemask_32(__m128 a) { return _mm_movemask_ps(a); }

intnat caml_sse2_vec128_movemask_64(__m128d a) { return _mm_movemask_pd(a); }

__m128i caml_ssse3_vec128_shuffle_8(__m128i a, __m128i b) {
  return _mm_shuffle_epi8(a, b);
}

__m128i caml_sse2_vec128_shuffle_low_16(intnat imm, __m128i a) {
#define F(i) _mm_shufflelo_epi16(a, i)
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_sse2_vec128_shuffle_high_16(intnat imm, __m128i a) {
#define F(i) _mm_shufflehi_epi16(a, i)
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128 caml_sse_vec128_shuffle_32(intnat imm, __m128 a, __m128 b) {
#define F(i) _mm_shuffle_ps(a, b, i)
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128d caml_sse2_vec128_shuffle_64(intnat imm, __m128d a, __m128d b) {
#define F(i) _mm_shuffle_pd(a, b, i)
  switch (imm & 0x3) {
    CASE4(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_ssse3_vec128_align_right_bytes(intnat imm, __m128i a, __m128i b) {
  if (imm < 0 || imm > 31)
    return _mm_setzero_si128();
#define F(i) _mm_alignr_epi8(a, b, i)
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_sse41_vec128_blend_16(intnat imm, __m128i a, __m128i b) {
#define F(i) _mm_blend_epi16(a, b, i)
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128 caml_sse41_vec128_blend_32(intnat imm, __m128 a, __m128 b) {
#define F(i) _mm_blend_ps(a, b, i)
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128d caml_sse41_vec128_blend_64(intnat imm, __m128d a, __m128d b) {
#define F(i) _mm_blend_pd(a, b, i)
  switch (imm & 0x3) {
    CASE4(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_sse41_vec128_blendv_8(__m128i a, __m128i b, __m128i mask) {
  return _mm_blendv_epi8(a, b, mask);
}

__m128 caml_sse41_vec128_blendv_32(__m128 a, __m128 b, __m128 mask) {
  return _mm_blendv_ps(a, b, mask);
}

__m128d caml_sse41_vec128_blendv_64(__m128d a, __m128d b, __m128d mask) {
  return _mm_blendv_pd(a, b, mask);
}

__m128i caml_clmul_int64x2(intnat imm, __m128i a, __m128i b) {
#define F(i) _mm_clmulepi64_si128(a, b, i)
  switch (imm & 0x11) {
    CASE(F, 0x00)
    CASE(F, 0x01)
    CASE(F, 0x10)
    CASE(F, 0x11)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

typedef struct {
  uint16_t mask;
  int upper_bound;
  int index;
  int is_word;
  int cflag;
  int zflag;
  int sflag;
  int oflag;
} pcmpstr_result_t;

typedef union {
  uint16_t words[8];
  uint8_t bytes[16];
  __m128i vec;
} pcmpstr_vector_t;

// [simde] doesn't provide SSE4.2 string intrinsics, so we implement them in C.
// The following logic is ported from the Intel specification (with fixes), and
// is not at all optimized.
static pcmpstr_result_t pcmpstr(int imm8, __m128i a, int la, __m128i b, int lb,
                                int explicit_len) {
  int is_word = (imm8 >> 0) & 1;
  int is_signed = (imm8 >> 1) & 1;
  int agg_mode = (imm8 >> 2) & 3;
  int polarity = (imm8 >> 4) & 3;
  int index_msb = (imm8 >> 6) & 1;

  int size = is_word ? 16 : 8;
  int upper_bound = (128 / size) - 1;

  pcmpstr_vector_t a_raw, b_raw;
  a_raw.vec = a;
  b_raw.vec = b;

  int32_t a_elems[16], b_elems[16];
  for (int i = 0; i <= upper_bound; i++) {
    if (is_word) {
      uint16_t a_val = a_raw.words[i];
      uint16_t b_val = b_raw.words[i];
      a_elems[i] = is_signed ? (int16_t)a_val : a_val;
      b_elems[i] = is_signed ? (int16_t)b_val : b_val;
    } else {
      uint8_t a_val = a_raw.bytes[i];
      uint8_t b_val = b_raw.bytes[i];
      a_elems[i] = is_signed ? (int8_t)a_val : a_val;
      b_elems[i] = is_signed ? (int8_t)b_val : b_val;
    }
  }

  int a_len, b_len;
  int sflag = 0, zflag = 0;
  if (explicit_len) {
    a_len = (la < 0) ? 0 : ((la > upper_bound + 1) ? upper_bound + 1 : la);
    b_len = (lb < 0) ? 0 : ((lb > upper_bound + 1) ? upper_bound + 1 : lb);
    sflag = (la < upper_bound + 1);
    zflag = (lb < upper_bound + 1);
  } else {
    a_len = upper_bound + 1;
    b_len = upper_bound + 1;
    for (int i = 0; i <= upper_bound; i++) {
      if (a_elems[i] == 0) {
        a_len = i;
        sflag = 1;
        break;
      }
    }
    for (int i = 0; i <= upper_bound; i++) {
      if (b_elems[i] == 0) {
        b_len = i;
        zflag = 1;
        break;
      }
    }
  }

  int BoolRes[16][16];
  for (int i = 0; i <= upper_bound; i++) {
    for (int j = 0; j <= upper_bound; j++) {
      if (agg_mode == 1) {
        if ((i & 1) == 0) {
          BoolRes[i][j] = (b_elems[j] >= a_elems[i]) ? 1 : 0;
        } else {
          BoolRes[i][j] = (b_elems[j] <= a_elems[i]) ? 1 : 0;
        }
      } else {
        BoolRes[i][j] = (a_elems[i] == b_elems[j]) ? 1 : 0;
      }

      int aInvalid = i >= a_len;
      int bInvalid = j >= b_len;

      if (!aInvalid && bInvalid) {
        BoolRes[i][j] = 0;
      } else if (aInvalid && !bInvalid) {
        BoolRes[i][j] = (agg_mode == 3) ? 1 : 0;
      } else if (aInvalid && bInvalid) {
        BoolRes[i][j] = (agg_mode >= 2) ? 1 : 0;
      }
    }
  }

  uint16_t IntRes1 = 0;
  switch (agg_mode) {
  case 0: // Eq_any
    for (int j = 0; j <= upper_bound; j++) {
      for (int i = 0; i <= upper_bound; i++) {
        if (BoolRes[i][j]) {
          IntRes1 |= (1 << j);
        }
      }
    }
    break;
  case 1: // In_range
    for (int j = 0; j <= upper_bound; j++) {
      for (int i = 0; i <= upper_bound - 1; i += 2) {
        if (BoolRes[i][j] && BoolRes[i + 1][j]) {
          IntRes1 |= (1 << j);
        }
      }
    }
    break;
  case 2: // Eq_each
    for (int i = 0; i <= upper_bound; i++) {
      if (BoolRes[i][i]) {
        IntRes1 |= (1 << i);
      }
    }
    break;
  case 3: // Eq_ordered
    IntRes1 = is_word ? 0xFF : 0xFFFF;
    for (int j = 0; j <= upper_bound; j++) {
      for (int i = 0; i <= upper_bound - j; i++) {
        if (!BoolRes[i][j + i]) {
          IntRes1 &= ~(1 << j);
          break;
        }
      }
    }
    break;
  }

  uint16_t IntRes2 = 0;
  for (int i = 0; i <= upper_bound; i++) {
    int bInvalid = i >= b_len;
    int bit = (IntRes1 >> i) & 1;

    if (polarity & 1) {
      if ((polarity & 2) && bInvalid) {
        IntRes2 |= (bit << i);
      } else {
        IntRes2 |= ((bit ^ 1) << i);
      }
    } else {
      IntRes2 |= (bit << i);
    }
  }

  int index = upper_bound + 1;
  if (index_msb) {
    for (int i = upper_bound; i >= 0; i--) {
      if ((IntRes2 >> i) & 1) {
        index = i;
        break;
      }
    }
  } else {
    for (int i = 0; i <= upper_bound; i++) {
      if ((IntRes2 >> i) & 1) {
        index = i;
        break;
      }
    }
  }

  pcmpstr_result_t result;
  result.mask = IntRes2;
  result.upper_bound = upper_bound;
  result.index = index;
  result.is_word = is_word;
  result.cflag = (IntRes2 != 0) ? 1 : 0;
  result.zflag = zflag;
  result.sflag = sflag;
  result.oflag = IntRes2 & 1;
  return result;
}

static __m128i pcmpstr_mask(pcmpstr_result_t result, int imm) {
  int unit_mask = (imm >> 6) & 1;

  pcmpstr_vector_t mask = {0};
  if (unit_mask) {
    for (int i = 0; i <= result.upper_bound; i++) {
      int bit = (result.mask >> i) & 1;
      if (result.is_word) {
        mask.words[i] = bit ? 0xFFFF : 0;
      } else {
        mask.bytes[i] = bit ? 0xFF : 0;
      }
    }
  } else {
    if (result.is_word) {
      mask.bytes[0] = result.mask & 0xFF;
    } else {
      mask.words[0] = result.mask;
    }
  }
  return mask.vec;
}

__m128i caml_sse42_vec128_cmpistrm(intnat imm, __m128i a, __m128i b) {
  pcmpstr_result_t result = pcmpstr(imm, a, 0, b, 0, 0);
  return pcmpstr_mask(result, imm);
}

int caml_sse42_vec128_cmpistri(intnat imm, __m128i a, __m128i b) {
  return pcmpstr(imm, a, 0, b, 0, 0).index;
}

int caml_sse42_vec128_cmpistra(intnat imm, __m128i a, __m128i b) {
  pcmpstr_result_t result = pcmpstr(imm, a, 0, b, 0, 0);
  return !result.cflag && !result.zflag;
}

int caml_sse42_vec128_cmpistrc(intnat imm, __m128i a, __m128i b) {
  return pcmpstr(imm, a, 0, b, 0, 0).cflag;
}

int caml_sse42_vec128_cmpistro(intnat imm, __m128i a, __m128i b) {
  return pcmpstr(imm, a, 0, b, 0, 0).oflag;
}

int caml_sse42_vec128_cmpistrs(intnat imm, __m128i a, __m128i b) {
  return pcmpstr(imm, a, 0, b, 0, 0).sflag;
}

int caml_sse42_vec128_cmpistrz(intnat imm, __m128i a, __m128i b) {
  return pcmpstr(imm, a, 0, b, 0, 0).zflag;
}

__m128i caml_sse42_vec128_cmpestrm(intnat imm, __m128i a, intnat la, __m128i b,
                                   intnat lb) {
  pcmpstr_result_t result = pcmpstr(imm, a, la, b, lb, 1);
  return pcmpstr_mask(result, imm);
}

int caml_sse42_vec128_cmpestri(intnat imm, __m128i a, intnat la, __m128i b, intnat lb) {
  return pcmpstr(imm, a, la, b, lb, 1).index;
}

int caml_sse42_vec128_cmpestra(intnat imm, __m128i a, intnat la, __m128i b, intnat lb) {
  pcmpstr_result_t result = pcmpstr(imm, a, la, b, lb, 1);
  return !result.cflag && !result.zflag;
}

int caml_sse42_vec128_cmpestrc(intnat imm, __m128i a, intnat la, __m128i b, intnat lb) {
  return pcmpstr(imm, a, la, b, lb, 1).cflag;
}

int caml_sse42_vec128_cmpestro(intnat imm, __m128i a, intnat la, __m128i b, intnat lb) {
  return pcmpstr(imm, a, la, b, lb, 1).oflag;
}

int caml_sse42_vec128_cmpestrs(intnat imm, __m128i a, intnat la, __m128i b, intnat lb) {
  return pcmpstr(imm, a, la, b, lb, 1).sflag;
}

int caml_sse42_vec128_cmpestrz(intnat imm, __m128i a, intnat la, __m128i b, intnat lb) {
  return pcmpstr(imm, a, la, b, lb, 1).zflag;
}

#else
#error "Target not supported"
#endif
