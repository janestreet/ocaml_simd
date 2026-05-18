#include <assert.h>
#include <stdlib.h>
#include <stdint.h>

#include <caml/mlvalues.h>

void ocaml_simd_avx_unreachable() {
  assert(!"SIMD is not supported in bytecode mode.");
  abort();
}

// On amd64, all intrinsics are compiler builtins. On arm64, some are builtins and others
// are emulated using simd-everywhere.
#ifdef __x86_64__

#include <immintrin.h>

#define caml__m256 __m256
#define caml__m256i __m256i
#define caml__m256d __m256d
#define to_caml(x) (x)
#define of_caml(x) (x)
#define to_camli(x) (x)
#define of_camli(x) (x)
#define to_camld(x) (x)
#define of_camld(x) (x)

#elif defined(__aarch64__)

#include <arm_neon.h>

#define SIMDE_ENABLE_NATIVE_ALIASES
#include <simde/x86/avx.h>
#include <simde/x86/avx2.h>
#include <simde/x86/fma.h>
#include <simde/x86/f16c.h>

// On aarch64, our vec256 calling convention uses unboxed pairs of vec128s,
// which matches the aarch64 C ABI for structs with two vec128 fields. We can't
// directly use the __m256 defined by [simde] because it's a C union with a
// different calling convention.
typedef struct {
  __m128 low, high;
} caml__m256;

typedef struct {
  __m128i low, high;
} caml__m256i;

typedef struct {
  __m128d low, high;
} caml__m256d;

static caml__m256 to_caml(__m256 x) {
  caml__m256 res;
  simde__m256_private x_ = simde__m256_to_private(x);
  res.low = x_.m128[0];
  res.high = x_.m128[1];
  return res;
}

static __m256 of_caml(caml__m256 x) {
  simde__m256_private res;
  res.m128[0] = x.low;
  res.m128[1] = x.high;
  return simde__m256_from_private(res);
}

static caml__m256i to_camli(__m256i x) {
  caml__m256i res;
  simde__m256i_private x_ = simde__m256i_to_private(x);
  res.low = x_.m128i[0];
  res.high = x_.m128i[1];
  return res;
}

static __m256i of_camli(caml__m256i x) {
  simde__m256i_private res;
  res.m128i[0] = x.low;
  res.m128i[1] = x.high;
  return simde__m256i_from_private(res);
}

static caml__m256d to_camld(__m256d x) {
  caml__m256d res;
  simde__m256d_private x_ = simde__m256d_to_private(x);
  res.low = x_.m128d[0];
  res.high = x_.m128d[1];
  return res;
}

static __m256d of_camld(caml__m256d x) {
  simde__m256d_private res;
  res.m128d[0] = x.low;
  res.m128d[1] = x.high;
  return simde__m256d_from_private(res);
}

#else
#error "Target not supported"
#endif

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

uint16_t caml_lzcnt_int16(uint16_t x) {
  if (x == 0)
    return 16;
  return __builtin_clzs(x);
}
uint32_t caml_lzcnt_int32(uint32_t x) {
  if (x == 0)
    return 32;
  return __builtin_clz(x);
}
uint64_t caml_lzcnt_int64(uint64_t x) {
  if (x == 0)
    return 64;
  return __builtin_clzll(x);
}

uint16_t caml_bmi_tzcnt_int16(uint16_t x) {
  if (x == 0)
    return 16;
  return __builtin_ctzs(x);
}
uint32_t caml_bmi_tzcnt_int32(uint32_t x) {
  if (x == 0)
    return 32;
  return __builtin_ctz(x);
}
uint64_t caml_bmi_tzcnt_int64(uint64_t x) {
  if (x == 0)
    return 64;
  return __builtin_ctzll(x);
}

uint32_t caml_bmi_andn_int32(uint32_t x, uint32_t y) { return ~x & y; }
uint64_t caml_bmi_andn_int64(uint64_t x, uint64_t y) { return ~x & y; }

uint32_t caml_bmi_bextr_int32(uint32_t x, uint32_t ctrl) {
  const uint32_t mask = 0xffffffffu;
  uint32_t pos = ctrl & 0xff;
  uint32_t len = (ctrl >> 8) & 0xff;
  if (len == 0 || pos >= 32)
    return 0;
  if (len > 32 - pos)
    len = 32 - pos;
  return (x >> pos) & (mask >> (32 - len));
}

uint64_t caml_bmi_bextr_int64(uint64_t x, uint64_t ctrl) {
  const uint64_t mask = 0xffffffffffffffffull;
  uint32_t pos = ctrl & 0xff;
  uint32_t len = (ctrl >> 8) & 0xff;
  if (len == 0 || pos >= 64)
    return 0;
  if (len > 64 - pos)
    len = 64 - pos;
  return (x >> pos) & (mask >> (64 - len));
}

uint32_t caml_bmi_blsi_int32(uint32_t x) { return x & (-x); }
uint64_t caml_bmi_blsi_int64(uint64_t x) { return x & (-x); }

uint32_t caml_bmi_blsmsk_int32(uint32_t x) { return x ^ (x - 1); }
uint64_t caml_bmi_blsmsk_int64(uint64_t x) { return x ^ (x - 1); }

uint32_t caml_bmi_blsr_int32(uint32_t x) { return x & (x - 1); }
uint64_t caml_bmi_blsr_int64(uint64_t x) { return x & (x - 1); }

uint32_t caml_bmi2_bzhi_int32(uint32_t x, uint32_t pos) {
  if (pos >= 32)
    return x;
  return x & ((1u << pos) - 1);
}

uint64_t caml_bmi2_bzhi_int64(uint64_t x, uint64_t pos) {
  if (pos >= 64)
    return x;
  return x & ((1ull << pos) - 1);
}

typedef struct {
  uint64_t low, high;
} uint64_pair_t;

uint64_pair_t caml_bmi2_mulx_int32(uint32_t x, uint32_t y) {
  uint64_t res = (uint64_t)x * (uint64_t)y;
  return (uint64_pair_t){res, res >> 32};
}

uint64_pair_t caml_bmi2_mulx_int64(uint64_t x, uint64_t y) {
  __uint128_t res = (__uint128_t)x * (__uint128_t)y;
  return (uint64_pair_t){(uint64_t)res, (uint64_t)(res >> 64)};
}

uint32_t caml_bmi2_pext_int32(uint32_t x, uint32_t mask) {
  uint32_t r = 0;
  int k = 0;
  for (uint32_t m = mask; m; m >>= 1, x >>= 1) {
    if (m & 1) {
      r |= (x & 1) << k++;
    }
  }
  return r;
}

// Also defined in ocaml_intrinsics
CAMLweakdef uint64_t caml_bmi2_pext_int64(uint64_t x, uint64_t mask) {
  uint64_t r = 0;
  int k = 0;
  for (uint64_t m = mask; m; m >>= 1, x >>= 1) {
    if (m & 1) {
      r |= (x & 1) << k++;
    }
  }
  return r;
}

uint32_t caml_bmi2_pdep_int32(uint32_t x, uint32_t mask) {
  uint32_t r = 0;
  int k = 0;
  for (uint32_t m = mask; m; m >>= 1, k++) {
    if (m & 1) {
      r |= (x & 1) << k;
      x >>= 1;
    }
  }
  return r;
}

// Also defined in ocaml_intrinsics
CAMLweakdef uint64_t caml_bmi2_pdep_int64(uint64_t x, uint64_t mask) {
  uint64_t r = 0;
  int k = 0;
  for (uint64_t m = mask; m; m >>= 1, k++) {
    if (m & 1) {
      r |= (x & 1) << k;
      x >>= 1;
    }
  }
  return r;
}

uint32_t caml_bmi2_rorx_int32(uint64_t bits, uint32_t x) {
  bits &= 31;
  if (bits == 0)
    return x;
  return (x >> bits) | (x << (32 - bits));
}

uint64_t caml_bmi2_rorx_int64(uint64_t bits, uint64_t x) {
  bits &= 63;
  if (bits == 0)
    return x;
  return (x >> bits) | (x << (64 - bits));
}

int32_t caml_bmi2_sarx_int32(int32_t x, uint32_t bits) {
  bits &= 31;
  return (x >> bits);
}

int64_t caml_bmi2_sarx_int64(int64_t x, uint64_t bits) {
  bits &= 63;
  return (x >> bits);
}

uint32_t caml_bmi2_shrx_int32(uint32_t x, uint32_t bits) {
  bits &= 31;
  return (x >> bits);
}

uint64_t caml_bmi2_shrx_int64(uint64_t x, uint64_t bits) {
  bits &= 63;
  return (x >> bits);
}

uint32_t caml_bmi2_shlx_int32(uint32_t x, uint32_t bits) {
  bits &= 31;
  return (x << bits);
}

uint64_t caml_bmi2_shlx_int64(uint64_t x, uint64_t bits) {
  bits &= 63;
  return (x << bits);
}

caml__m256 caml_vec256_cast(caml__m256 x) { return x; }

caml__m256i caml_avx_vec256_load_aligned(intnat addr) {
  return to_camli(_mm256_load_si256((__m256i *)addr));
}

caml__m256i caml_avx_vec256_load_unaligned(intnat addr) {
  return to_camli(_mm256_loadu_si256((__m256i *)addr));
}

caml__m256i caml_avx_vec256_load_known_unaligned(intnat addr) {
  return to_camli(_mm256_lddqu_si256((__m256i *)addr));
}

void caml_avx_vec256_store_aligned(intnat addr, caml__m256i v) {
  _mm256_store_si256((__m256i *)addr, of_camli(v));
}

void caml_avx_vec256_store_unaligned(intnat addr, caml__m256i v) {
  _mm256_storeu_si256((__m256i *)addr, of_camli(v));
}

caml__m256i caml_avx_vec256_load_aligned_uncached(intnat addr) {
  return to_camli(_mm256_stream_load_si256((__m256i *)addr));
}

void caml_avx_vec256_store_aligned_uncached(intnat addr, caml__m256i v) {
  _mm256_stream_si256((__m256i *)addr, of_camli(v));
}

caml__m256d caml_avx_vec256_load_broadcast128(intnat addr) {
  return to_camld(_mm256_broadcast_pd((__m128d *)addr));
}

caml__m256d caml_avx_vec256_load_broadcast64(intnat addr) {
  return to_camld(_mm256_broadcast_sd((double *)addr));
}

caml__m256 caml_avx_vec256_load_broadcast32(intnat addr) {
  return to_caml(_mm256_broadcast_ss((float *)addr));
}

__m128 caml_avx_vec128_load_broadcast32(intnat addr) {
  return _mm_broadcast_ss((float *)addr);
}

__m128d caml_avx_vec128_load_mask64(__m128i mask, intnat addr) {
  return _mm_maskload_pd((double *)addr, mask);
}

caml__m256d caml_avx_vec256_load_mask64(caml__m256i mask, intnat addr) {
  return to_camld(_mm256_maskload_pd((double *)addr, of_camli(mask)));
}

__m128 caml_avx_vec128_load_mask32(__m128i mask, intnat addr) {
  return _mm_maskload_ps((float *)addr, mask);
}

caml__m256 caml_avx_vec256_load_mask32(caml__m256i mask, intnat addr) {
  return to_caml(_mm256_maskload_ps((float *)addr, of_camli(mask)));
}

void caml_avx_vec256_store_mask64(intnat addr, caml__m256i mask, caml__m256d v) {
  _mm256_maskstore_pd((double *)addr, of_camli(mask), of_camld(v));
}

void caml_avx_vec256_store_mask32(intnat addr, caml__m256i mask, caml__m256 v) {
  _mm256_maskstore_ps((float *)addr, of_camli(mask), of_caml(v));
}

void caml_avx_vec128_store_mask64(intnat addr, __m128i mask, __m128d v) {
  _mm_maskstore_pd((double *)addr, mask, v);
}

void caml_avx_vec128_store_mask32(intnat addr, __m128i mask, __m128 v) {
  _mm_maskstore_ps((float *)addr, mask, v);
}

caml__m256i caml_avx2_vec256_gather64_index64(int64_t scale, caml__m256i onto,
                                              intnat base, caml__m256i offset,
                                              caml__m256i mask) {
  switch (scale) {
  case 1:
    return to_camli(_mm256_mask_i64gather_epi64(of_camli(onto), (const long long *)base,
                                                of_camli(offset), of_camli(mask), 1));
  case 2:
    return to_camli(_mm256_mask_i64gather_epi64(of_camli(onto), (const long long *)base,
                                                of_camli(offset), of_camli(mask), 2));
  case 4:
    return to_camli(_mm256_mask_i64gather_epi64(of_camli(onto), (const long long *)base,
                                                of_camli(offset), of_camli(mask), 4));
  case 8:
    return to_camli(_mm256_mask_i64gather_epi64(of_camli(onto), (const long long *)base,
                                                of_camli(offset), of_camli(mask), 8));
  default:
    assert(!"Invalid scale");
    abort();
  }
}

caml__m256i caml_avx2_vec256_gather64_index32(int64_t scale, caml__m256i onto,
                                              intnat base, __m128i offset,
                                              caml__m256i mask) {
  switch (scale) {
  case 1:
    return to_camli(_mm256_mask_i32gather_epi64(of_camli(onto), (const long long *)base,
                                                offset, of_camli(mask), 1));
  case 2:
    return to_camli(_mm256_mask_i32gather_epi64(of_camli(onto), (const long long *)base,
                                                offset, of_camli(mask), 2));
  case 4:
    return to_camli(_mm256_mask_i32gather_epi64(of_camli(onto), (const long long *)base,
                                                offset, of_camli(mask), 4));
  case 8:
    return to_camli(_mm256_mask_i32gather_epi64(of_camli(onto), (const long long *)base,
                                                offset, of_camli(mask), 8));
  default:
    assert(!"Invalid scale");
    abort();
  }
}

caml__m256i caml_avx2_vec256_gather32_index32(int64_t scale, caml__m256i onto,
                                              intnat base, caml__m256i offset,
                                              caml__m256i mask) {
  switch (scale) {
  case 1:
    return to_camli(_mm256_mask_i32gather_epi32(of_camli(onto), (const int32_t *)base,
                                                of_camli(offset), of_camli(mask), 1));
  case 2:
    return to_camli(_mm256_mask_i32gather_epi32(of_camli(onto), (const int32_t *)base,
                                                of_camli(offset), of_camli(mask), 2));
  case 4:
    return to_camli(_mm256_mask_i32gather_epi32(of_camli(onto), (const int32_t *)base,
                                                of_camli(offset), of_camli(mask), 4));
  case 8:
    return to_camli(_mm256_mask_i32gather_epi32(of_camli(onto), (const int32_t *)base,
                                                of_camli(offset), of_camli(mask), 8));
  default:
    assert(!"Invalid scale");
    abort();
  }
}

__m128i caml_avx2_vec128_gather64_index64(int64_t scale, __m128i onto, intnat base,
                                          __m128i offset, __m128i mask) {
  switch (scale) {
  case 1:
    return _mm_mask_i64gather_epi64(onto, (const long long *)base, offset, mask, 1);
  case 2:
    return _mm_mask_i64gather_epi64(onto, (const long long *)base, offset, mask, 2);
  case 4:
    return _mm_mask_i64gather_epi64(onto, (const long long *)base, offset, mask, 4);
  case 8:
    return _mm_mask_i64gather_epi64(onto, (const long long *)base, offset, mask, 8);
  default:
    assert(!"Invalid scale");
    abort();
  }
}

__m128i caml_avx2_vec128_gather64_index32(int64_t scale, __m128i onto, intnat base,
                                          __m128i offset, __m128i mask) {
  switch (scale) {
  case 1:
    return _mm_mask_i32gather_epi64(onto, (const long long *)base, offset, mask, 1);
  case 2:
    return _mm_mask_i32gather_epi64(onto, (const long long *)base, offset, mask, 2);
  case 4:
    return _mm_mask_i32gather_epi64(onto, (const long long *)base, offset, mask, 4);
  case 8:
    return _mm_mask_i32gather_epi64(onto, (const long long *)base, offset, mask, 8);
  default:
    assert(!"Invalid scale");
    abort();
  }
}

__m128i caml_avx2_vec256_gather32_index64(int64_t scale, __m128i onto, intnat base,
                                          caml__m256i offset, __m128i mask) {
  switch (scale) {
  case 1:
    return _mm256_mask_i64gather_epi32(onto, (const int32_t *)base, of_camli(offset),
                                       mask, 1);
  case 2:
    return _mm256_mask_i64gather_epi32(onto, (const int32_t *)base, of_camli(offset),
                                       mask, 2);
  case 4:
    return _mm256_mask_i64gather_epi32(onto, (const int32_t *)base, of_camli(offset),
                                       mask, 4);
  case 8:
    return _mm256_mask_i64gather_epi32(onto, (const int32_t *)base, of_camli(offset),
                                       mask, 8);
  default:
    assert(!"Invalid scale");
    abort();
  }
}

__m128i caml_avx2_vec128_gather32_index64(int64_t scale, __m128i onto, intnat base,
                                          __m128i offset, __m128i mask) {
  switch (scale) {
  case 1:
    return _mm_mask_i64gather_epi32(onto, (const int32_t *)base, offset, mask, 1);
  case 2:
    return _mm_mask_i64gather_epi32(onto, (const int32_t *)base, offset, mask, 2);
  case 4:
    return _mm_mask_i64gather_epi32(onto, (const int32_t *)base, offset, mask, 4);
  case 8:
    return _mm_mask_i64gather_epi32(onto, (const int32_t *)base, offset, mask, 8);
  default:
    assert(!"Invalid scale");
    abort();
  }
}

__m128i caml_avx2_vec128_gather32_index32(int64_t scale, __m128i onto, intnat base,
                                          __m128i offset, __m128i mask) {
  switch (scale) {
  case 1:
    return _mm_mask_i32gather_epi32(onto, (const int32_t *)base, offset, mask, 1);
  case 2:
    return _mm_mask_i32gather_epi32(onto, (const int32_t *)base, offset, mask, 2);
  case 4:
    return _mm_mask_i32gather_epi32(onto, (const int32_t *)base, offset, mask, 4);
  case 8:
    return _mm_mask_i32gather_epi32(onto, (const int32_t *)base, offset, mask, 8);
  default:
    assert(!"Invalid scale");
    abort();
  }
}

caml__m256i caml_vec256_low_of_vec128(__m128i x) {
  return to_camli(_mm256_castsi128_si256(x));
}

__m128i caml_vec256_low_to_vec128(caml__m256i x) {
  return _mm256_castsi256_si128(of_camli(x));
}

caml__m256 caml_float32x8_low_of_float32(float f) {
  return to_caml(_mm256_castps128_ps256(_mm_set_ss(f)));
}

float caml_float32x8_low_to_float32(caml__m256 v) {
  return _mm_cvtss_f32(_mm256_castps256_ps128(of_caml(v)));
}

caml__m256d caml_float64x4_low_of_float(double f) {
  return to_camld(_mm256_castpd128_pd256(_mm_set_sd(f)));
}

double caml_float64x4_low_to_float(caml__m256d v) {
  return _mm_cvtsd_f64(_mm256_castpd256_pd128(of_camld(v)));
}

caml__m256i caml_int32x8_low_of_int32(int32_t v) {
  return to_camli(_mm256_castsi128_si256(_mm_cvtsi32_si128(v)));
}

int32_t caml_int32x8_low_to_int32(caml__m256i v) {
  return _mm_cvtsi128_si32(_mm256_castsi256_si128(of_camli(v)));
}

caml__m256i caml_int64x4_low_of_int64(int64_t v) {
  return to_camli(_mm256_castsi128_si256(_mm_cvtsi64_si128(v)));
}

int64_t caml_int64x4_low_to_int64(caml__m256i v) {
  return _mm_cvtsi128_si64(_mm256_castsi256_si128(of_camli(v)));
}

caml__m256i caml_int16x16_low_of_int16(int16_t v) {
  return to_camli(_mm256_castsi128_si256(_mm_cvtsi32_si128((int32_t)v)));
}

int16_t caml_int16x16_low_to_int16(caml__m256i v) {
  return (int16_t)_mm_cvtsi128_si32(_mm256_castsi256_si128(of_camli(v)));
}

caml__m256i caml_int8x32_low_of_int8(int8_t v) {
  return to_camli(_mm256_castsi128_si256(_mm_cvtsi32_si128((int32_t)v)));
}

int8_t caml_int8x32_low_to_int8(caml__m256i v) {
  return (int8_t)_mm_cvtsi128_si32(_mm256_castsi256_si128(of_camli(v)));
}

caml__m256 caml_float32x8_const1(float f) { return to_caml(_mm256_set1_ps(f)); }

caml__m256 caml_float32x8_const8(float a, float b, float c, float d, float e, float f,
                                 float g, float h) {
  return to_caml(_mm256_setr_ps(a, b, c, d, e, f, g, h));
}

caml__m256d caml_float64x4_const1(double f) { return to_camld(_mm256_set1_pd(f)); }

caml__m256d caml_float64x4_const4(double a, double b, double c, double d) {
  return to_camld(_mm256_setr_pd(a, b, c, d));
}

caml__m256i caml_int64x4_const1(int64_t v) { return to_camli(_mm256_set1_epi64x(v)); }

caml__m256i caml_int64x4_const4(int64_t a, int64_t b, int64_t c, int64_t d) {
  return to_camli(_mm256_setr_epi64x(a, b, c, d));
}

caml__m256i caml_int32x8_const1(int32_t v) { return to_camli(_mm256_set1_epi32(v)); }

caml__m256i caml_int32x8_const8(int32_t a, int32_t b, int32_t c, int32_t d, int32_t e,
                                int32_t f, int32_t g, int32_t h) {
  return to_camli(_mm256_setr_epi32(a, b, c, d, e, f, g, h));
}

caml__m256i caml_int16x16_const1(int16_t v) { return to_camli(_mm256_set1_epi16(v)); }

caml__m256i caml_int16x16_const16(int16_t a, int16_t b, int16_t c, int16_t d, int16_t e,
                                  int16_t f, int16_t g, int16_t h, int16_t i, int16_t j,
                                  int16_t k, int16_t l, int16_t m, int16_t n, int16_t o,
                                  int16_t p) {
  return to_camli(_mm256_setr_epi16(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p));
}

caml__m256i caml_int8x32_const1(int8_t v) { return to_camli(_mm256_set1_epi8(v)); }

caml__m256i caml_int8x32_const32(int8_t a, int8_t b, int8_t c, int8_t d, int8_t e,
                                 int8_t f, int8_t g, int8_t h, int8_t i, int8_t j,
                                 int8_t k, int8_t l, int8_t m, int8_t n, int8_t o,
                                 int8_t p, int8_t q, int8_t r, int8_t s, int8_t t,
                                 int8_t u, int8_t v, int8_t w, int8_t x, int8_t y,
                                 int8_t z, int8_t aa, int8_t ab, int8_t ac, int8_t ad,
                                 int8_t ae, int8_t af) {
  return to_camli(_mm256_setr_epi8(a, b, c, d, e, f, g, h, i, j, k, l, m, n, o, p, q, r,
                                   s, t, u, v, w, x, y, z, aa, ab, ac, ad, ae, af));
}

caml__m256d caml_avx_float64x4_add(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_add_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x8_add(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_add_ps(of_caml(a), of_caml(b)));
}

caml__m256 caml_avx_float32x8_addsub(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_addsub_ps(of_caml(a), of_caml(b)));
}

caml__m256d caml_avx_float64x4_addsub(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_addsub_pd(of_camld(a), of_camld(b)));
}

caml__m256i caml_avx_vec256_and(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_and_si256(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx_vec256_andnot(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_andnot_si256(of_camli(a), of_camli(b)));
}

caml__m256d caml_avx_vec256_blend_64(intnat imm, caml__m256d a, caml__m256d b) {
  __m256d a_ = of_camld(a);
  __m256d b_ = of_camld(b);
#define F(i) to_camld(_mm256_blend_pd(a_, b_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256 caml_avx_vec256_blend_32(intnat imm, caml__m256 a, caml__m256 b) {
  __m256 a_ = of_caml(a);
  __m256 b_ = of_caml(b);
#define F(i) to_caml(_mm256_blend_ps(a_, b_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_vec256_blendv_64(caml__m256d a, caml__m256d b, caml__m256d mask) {
  return to_camld(_mm256_blendv_pd(of_camld(a), of_camld(b), of_camld(mask)));
}

caml__m256 caml_avx_vec256_blendv_32(caml__m256 a, caml__m256 b, caml__m256 mask) {
  return to_caml(_mm256_blendv_ps(of_caml(a), of_caml(b), of_caml(mask)));
}

caml__m256d caml_avx_vec256_broadcast_64(__m128d a) {
  return to_camld(_mm256_broadcastsd_pd(a));
}

caml__m256 caml_avx_vec256_broadcast_32(__m128 a) {
  return to_caml(_mm256_broadcastss_ps(a));
}

__m128 caml_avx_vec128_broadcast_32(__m128 a) { return _mm_broadcastss_ps(a); }

caml__m256d caml_avx_float64x4_round_pos_inf(caml__m256d a) {
  return to_camld(_mm256_ceil_pd(of_camld(a)));
}

caml__m256 caml_avx_float32x8_round_pos_inf(caml__m256 a) {
  return to_caml(_mm256_ceil_ps(of_caml(a)));
}

caml__m256d caml_avx_float64x4_cmp(intnat imm, caml__m256d a, caml__m256d b) {
  __m256d a_ = of_camld(a);
  __m256d b_ = of_camld(b);
#define F(i) to_camld(_mm256_cmp_pd(a_, b_, i))
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256 caml_avx_float32x8_cmp(intnat imm, caml__m256 a, caml__m256 b) {
  __m256 a_ = of_caml(a);
  __m256 b_ = of_caml(b);
#define F(i) to_caml(_mm256_cmp_ps(a_, b_, i))
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_cvt_int32x4_float64x4(__m128i a) {
  return to_camld(_mm256_cvtepi32_pd(a));
}

caml__m256 caml_avx_cvt_int32x8_float32x8(caml__m256i a) {
  return to_caml(_mm256_cvtepi32_ps(of_camli(a)));
}

__m128i caml_avx_cvt_float64x4_int32x4(caml__m256d a) {
  return _mm256_cvtpd_epi32(of_camld(a));
}

__m128 caml_avx_cvt_float64x4_float32x4(caml__m256d a) {
  return _mm256_cvtpd_ps(of_camld(a));
}

caml__m256i caml_avx_cvt_float32x8_int32x8(caml__m256 a) {
  return to_camli(_mm256_cvtps_epi32(of_caml(a)));
}

caml__m256d caml_avx_cvt_float32x4_float64x4(__m128 a) {
  return to_camld(_mm256_cvtps_pd(a));
}

__m128i caml_avx_cvtt_float64x4_int32x4(caml__m256d a) {
  return _mm256_cvttpd_epi32(of_camld(a));
}

caml__m256i caml_avx_cvtt_float32x8_int32x8(caml__m256 a) {
  return to_camli(_mm256_cvttps_epi32(of_caml(a)));
}

caml__m256d caml_avx_float64x4_div(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_div_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x8_div(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_div_ps(of_caml(a), of_caml(b)));
}

caml__m256 caml_avx_float32x4x2_dp(intnat imm, caml__m256 a, caml__m256 b) {
  __m256 a_ = of_caml(a);
  __m256 b_ = of_caml(b);
#define F(i) to_caml(_mm256_dp_ps(a_, b_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_avx_vec256_extract_128(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) _mm256_extractf128_si256(a_, i)
  switch (imm & 0x1) {
    CASE2(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_float64x4_round_neg_inf(caml__m256d a) {
  return to_camld(_mm256_floor_pd(of_camld(a)));
}

caml__m256 caml_avx_float32x8_round_neg_inf(caml__m256 a) {
  return to_caml(_mm256_floor_ps(of_caml(a)));
}

caml__m256d caml_avx_float64x2x2_hadd(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_hadd_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x4x2_hadd(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_hadd_ps(of_caml(a), of_caml(b)));
}

caml__m256d caml_avx_float64x2x2_hsub(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_hsub_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x4x2_hsub(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_hsub_ps(of_caml(a), of_caml(b)));
}

caml__m256i caml_avx_vec256_insert_128(intnat imm, caml__m256i a, __m128i b) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_insertf128_si256(a_, b, i))
  switch (imm & 0x1) {
    CASE2(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_float64x4_max(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_max_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x8_max(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_max_ps(of_caml(a), of_caml(b)));
}

caml__m256d caml_avx_float64x4_min(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_min_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x8_min(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_min_ps(of_caml(a), of_caml(b)));
}

caml__m256d caml_avx_vec256_dup_even_64(caml__m256d a) {
  return to_camld(_mm256_movedup_pd(of_camld(a)));
}

caml__m256 caml_avx_vec256_dup_odd_32(caml__m256 a) {
  return to_caml(_mm256_movehdup_ps(of_caml(a)));
}

caml__m256 caml_avx_vec256_dup_even_32(caml__m256 a) {
  return to_caml(_mm256_moveldup_ps(of_caml(a)));
}

intnat caml_avx_vec256_movemask_64(caml__m256d a) {
  return _mm256_movemask_pd(of_camld(a));
}

intnat caml_avx_vec256_movemask_32(caml__m256 a) {
  return _mm256_movemask_ps(of_caml(a));
}

caml__m256d caml_avx_float64x4_mul(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_mul_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x8_mul(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_mul_ps(of_caml(a), of_caml(b)));
}

caml__m256i caml_avx_vec256_or(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_or_si256(of_camli(a), of_camli(b)));
}

__m128d caml_avx_vec128_permute_64(intnat imm, __m128d a) {
#define F(i) _mm_permute_pd(a, i)
  switch (imm & 0x3) {
    CASE4(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_vec128x2_permute_64(intnat imm, caml__m256d a) {
  __m256d a_ = of_camld(a);
#define F(i) to_camld(_mm256_permute_pd(a_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128 caml_avx_vec128_permute_32(intnat imm, __m128 a) {
#define F(i) _mm_permute_ps(a, i)
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256 caml_avx_vec128x2_permute_32(intnat imm, caml__m256 a) {
  __m256 a_ = of_caml(a);
#define F(i) to_caml(_mm256_permute_ps(a_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_vec256_permute2_128(intnat imm, caml__m256d a, caml__m256d b) {
  __m256d a_ = of_camld(a);
  __m256d b_ = of_camld(b);
#define F(i) to_camld(_mm256_permute2f128_pd(a_, b_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128d caml_avx_vec128_permutev_64(__m128d a, __m128i idx) {
  return _mm_permutevar_pd(a, idx);
}

caml__m256d caml_avx_vec128x2_permutev_64(caml__m256d a, caml__m256i idx) {
  return to_camld(_mm256_permutevar_pd(of_camld(a), of_camli(idx)));
}

__m128 caml_avx_vec128_permutev_32(__m128 a, __m128i idx) {
  return _mm_permutevar_ps(a, idx);
}

caml__m256 caml_avx_vec128x2_permutev_32(caml__m256 a, caml__m256i idx) {
  return to_caml(_mm256_permutevar_ps(of_caml(a), of_camli(idx)));
}

caml__m256 caml_avx_float32x8_rcp(caml__m256 a) {
  return to_caml(_mm256_rcp_ps(of_caml(a)));
}

caml__m256d caml_avx_float64x4_round(intnat imm, caml__m256d a) {
  __m256d a_ = of_camld(a);
#define F(i) to_camld(_mm256_round_pd(a_, i))
  switch (imm) {
    CASE(F, 0x8)
    CASE(F, 0x9)
    CASE(F, 0xa)
    CASE(F, 0xb)
    CASE(F, 0xc)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256 caml_avx_float32x8_round(intnat imm, caml__m256 a) {
  __m256 a_ = of_caml(a);
#define F(i) to_caml(_mm256_round_ps(a_, i))
  switch (imm) {
    CASE(F, 0x8)
    CASE(F, 0x9)
    CASE(F, 0xa)
    CASE(F, 0xb)
    CASE(F, 0xc)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256 caml_avx_float32x8_rsqrt(caml__m256 a) {
  return to_caml(_mm256_rsqrt_ps(of_caml(a)));
}

caml__m256d caml_avx_vec128x2_shuffle_64(intnat imm, caml__m256d a, caml__m256d b) {
  __m256d a_ = of_camld(a);
  __m256d b_ = of_camld(b);
#define F(i) to_camld(_mm256_shuffle_pd(a_, b_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256 caml_avx_vec128x2_shuffle_32(intnat imm, caml__m256 a, caml__m256 b) {
  __m256 a_ = of_caml(a);
  __m256 b_ = of_caml(b);
#define F(i) to_caml(_mm256_shuffle_ps(a_, b_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256d caml_avx_float64x4_sqrt(caml__m256d a) {
  return to_camld(_mm256_sqrt_pd(of_camld(a)));
}

caml__m256 caml_avx_float32x8_sqrt(caml__m256 a) {
  return to_caml(_mm256_sqrt_ps(of_caml(a)));
}

caml__m256d caml_avx_float64x4_sub(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_sub_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_float32x8_sub(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_sub_ps(of_caml(a), of_caml(b)));
}

intnat caml_avx_vec256_testz(caml__m256i a, caml__m256i b) {
  return _mm256_testz_si256(of_camli(a), of_camli(b));
}

intnat caml_avx_vec256_testc(caml__m256i a, caml__m256i b) {
  return _mm256_testc_si256(of_camli(a), of_camli(b));
}

intnat caml_avx_vec256_testnzc(caml__m256i a, caml__m256i b) {
  return _mm256_testnzc_si256(of_camli(a), of_camli(b));
}

caml__m256d caml_avx_vec128x2_interleave_high_64(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_unpackhi_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_vec128x2_interleave_high_32(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_unpackhi_ps(of_caml(a), of_caml(b)));
}

caml__m256d caml_avx_vec128x2_interleave_low_64(caml__m256d a, caml__m256d b) {
  return to_camld(_mm256_unpacklo_pd(of_camld(a), of_camld(b)));
}

caml__m256 caml_avx_vec128x2_interleave_low_32(caml__m256 a, caml__m256 b) {
  return to_caml(_mm256_unpacklo_ps(of_caml(a), of_caml(b)));
}

caml__m256i caml_avx_vec256_xor(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_xor_si256(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx_vec128x2_align_right_bytes(intnat imm, caml__m256i a,
                                                caml__m256i b) {
  __m256i a_ = of_camli(a);
  __m256i b_ = of_camli(b);
#define F(i) to_camli(_mm256_alignr_epi8(a_, b_, i))
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int8x32_abs(caml__m256i a) {
  return to_camli(_mm256_abs_epi8(of_camli(a)));
}

caml__m256i caml_avx2_int16x16_abs(caml__m256i a) {
  return to_camli(_mm256_abs_epi16(of_camli(a)));
}

caml__m256i caml_avx2_int32x8_abs(caml__m256i a) {
  return to_camli(_mm256_abs_epi32(of_camli(a)));
}

caml__m256i caml_avx2_int8x32_add(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_add_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_add(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_add_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_add(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_add_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int64x4_add(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_add_epi64(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_add_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_adds_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_add_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_adds_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_add_saturating_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_adds_epu8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_add_saturating_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_adds_epu16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_avg_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_avg_epu8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_avg_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_avg_epu16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_blend_16(intnat imm, caml__m256i a, caml__m256i b) {
  __m256i a_ = of_camli(a);
  __m256i b_ = of_camli(b);
#define F(i) to_camli(_mm256_blend_epi16(a_, b_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_vec256_blendv_8(caml__m256i a, caml__m256i b, caml__m256i mask) {
  return to_camli(_mm256_blendv_epi8(of_camli(a), of_camli(b), of_camli(mask)));
}

__m128i caml_avx2_vec128_broadcast_8(__m128i a) { return _mm_broadcastb_epi8(a); }

caml__m256i caml_avx2_vec256_broadcast_8(__m128i a) {
  return to_camli(_mm256_broadcastb_epi8(a));
}

__m128i caml_avx2_vec128_broadcast_16(__m128i a) { return _mm_broadcastw_epi16(a); }

caml__m256i caml_avx2_vec256_broadcast_16(__m128i a) {
  return to_camli(_mm256_broadcastw_epi16(a));
}

caml__m256i caml_avx2_vec128x2_shift_left_bytes(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_slli_si256(a_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_vec128x2_shift_right_bytes(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_srli_si256(a_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int8x32_cmpeq(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpeq_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_cmpeq(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpeq_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_cmpeq(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpeq_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int64x4_cmpeq(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpeq_epi64(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_cmpgt(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpgt_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_cmpgt(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpgt_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_cmpgt(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpgt_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int64x4_cmpgt(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_cmpgt_epi64(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_cvtsx_int16x8_int32x8(__m128i a) {
  return to_camli(_mm256_cvtepi16_epi32(a));
}

caml__m256i caml_avx2_cvtsx_int16x8_int64x4(__m128i a) {
  return to_camli(_mm256_cvtepi16_epi64(a));
}

caml__m256i caml_avx2_cvtsx_int32x4_int64x4(__m128i a) {
  return to_camli(_mm256_cvtepi32_epi64(a));
}

caml__m256i caml_avx2_cvtsx_int8x16_int16x16(__m128i a) {
  return to_camli(_mm256_cvtepi8_epi16(a));
}

caml__m256i caml_avx2_cvtsx_int8x16_int32x8(__m128i a) {
  return to_camli(_mm256_cvtepi8_epi32(a));
}

caml__m256i caml_avx2_cvtsx_int8x16_int64x4(__m128i a) {
  return to_camli(_mm256_cvtepi8_epi64(a));
}

caml__m256i caml_avx2_cvtzx_int16x8_int32x8(__m128i a) {
  return to_camli(_mm256_cvtepu16_epi32(a));
}

caml__m256i caml_avx2_cvtzx_int16x8_int64x4(__m128i a) {
  return to_camli(_mm256_cvtepu16_epi64(a));
}

caml__m256i caml_avx2_cvtzx_int32x4_int64x4(__m128i a) {
  return to_camli(_mm256_cvtepu32_epi64(a));
}

caml__m256i caml_avx2_cvtzx_int8x16_int16x16(__m128i a) {
  return to_camli(_mm256_cvtepu8_epi16(a));
}

caml__m256i caml_avx2_cvtzx_int8x16_int32x8(__m128i a) {
  return to_camli(_mm256_cvtepu8_epi32(a));
}

caml__m256i caml_avx2_cvtzx_int8x16_int64x4(__m128i a) {
  return to_camli(_mm256_cvtepu8_epi64(a));
}

caml__m256i caml_avx2_int16x8x2_hadd(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_hadd_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x4x2_hadd(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_hadd_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x8x2_hadd_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_hadds_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x8x2_hsub(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_hsub_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x4x2_hsub(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_hsub_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x8x2_hsub_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_hsubs_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_mul_hadd_int32x8(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_madd_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_mul_unsigned_hadd_saturating_int16x16(caml__m256i a,
                                                                    caml__m256i b) {
  return to_camli(_mm256_maddubs_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_max(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_max_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_max(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_max_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_max(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_max_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_max_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_max_epu8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_max_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_max_epu16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_max_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_max_epu32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_min(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_min_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_min(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_min_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_min(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_min_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_min_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_min_epu8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_min_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_min_epu16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_min_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_min_epu32(of_camli(a), of_camli(b)));
}

intnat caml_avx2_vec256_movemask_8(caml__m256i a) {
  return _mm256_movemask_epi8(of_camli(a));
}

caml__m256i caml_avx2_int8x16x2_multi_sad_unsigned(intnat imm, caml__m256i a,
                                                   caml__m256i b) {
  __m256i a_ = of_camli(a);
  __m256i b_ = of_camli(b);
#define F(i) to_camli(_mm256_mpsadbw_epu8(a_, b_, i))
  switch (imm & 0x3f) {
    CASE64(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int32x8_mul_even(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mul_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_mul_even_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mul_epu32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_mul_high(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mulhi_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_mul_high_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mulhi_epu16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_mul_round(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mulhrs_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_mul_low(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mullo_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_mul_low(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_mullo_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_cvt_int16x16_int8x32_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_packs_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_cvt_int32x8_int16x16_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_packs_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_cvt_int16x16_int8x32_saturating_unsigned(caml__m256i a,
                                                               caml__m256i b) {
  return to_camli(_mm256_packus_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_cvt_int32x8_int16x16_saturating_unsigned(caml__m256i a,
                                                               caml__m256i b) {
  return to_camli(_mm256_packus_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec256_permute_64(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_permute4x64_epi64(a_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_vec256_permutev_32(caml__m256i idx, caml__m256i a) {
  return to_camli(_mm256_permutevar8x32_epi32(of_camli(a), of_camli(idx)));
}

caml__m256i caml_avx2_int8x32_sad_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sad_epu8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_shuffle_8(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_shuffle_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_shuffle_high_16(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_shufflehi_epi16(a_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_vec128x2_shuffle_low_16(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_shufflelo_epi16(a_, i))
  switch (imm & 0xff) {
    CASE256(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int8x32_mulsign(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sign_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_mulsign(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sign_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_mulsign(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sign_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_sll(caml__m256i a, __m128i count) {
  return to_camli(_mm256_sll_epi16(of_camli(a), count));
}

caml__m256i caml_avx2_int32x8_sll(caml__m256i a, __m128i count) {
  return to_camli(_mm256_sll_epi32(of_camli(a), count));
}

caml__m256i caml_avx2_int64x4_sll(caml__m256i a, __m128i count) {
  return to_camli(_mm256_sll_epi64(of_camli(a), count));
}

caml__m256i caml_avx2_int16x16_slli(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_slli_epi16(a_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    return to_camli(_mm256_setzero_si256());
  }
#undef F
}

caml__m256i caml_avx2_int32x8_slli(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_slli_epi32(a_, i))
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int64x4_slli(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_slli_epi64(a_, i))
  switch (imm & 0x3f) {
    CASE64(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_avx2_int32x4_sllv(__m128i a, __m128i count) {
  return _mm_sllv_epi32(a, count);
}

caml__m256i caml_avx2_int32x8_sllv(caml__m256i a, caml__m256i count) {
  return to_camli(_mm256_sllv_epi32(of_camli(a), of_camli(count)));
}

__m128i caml_avx2_int64x2_sllv(__m128i a, __m128i count) {
  return _mm_sllv_epi64(a, count);
}

caml__m256i caml_avx2_int64x4_sllv(caml__m256i a, caml__m256i count) {
  return to_camli(_mm256_sllv_epi64(of_camli(a), of_camli(count)));
}

caml__m256i caml_avx2_int16x16_sra(caml__m256i a, __m128i count) {
  return to_camli(_mm256_sra_epi16(of_camli(a), count));
}

caml__m256i caml_avx2_int32x8_sra(caml__m256i a, __m128i count) {
  return to_camli(_mm256_sra_epi32(of_camli(a), count));
}

caml__m256i caml_avx2_int16x16_srai(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_srai_epi16(a_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int32x8_srai(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_srai_epi32(a_, i))
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_avx2_int32x4_srav(__m128i a, __m128i count) {
  return _mm_srav_epi32(a, count);
}

caml__m256i caml_avx2_int32x8_srav(caml__m256i a, caml__m256i count) {
  return to_camli(_mm256_srav_epi32(of_camli(a), of_camli(count)));
}

caml__m256i caml_avx2_int16x16_srl(caml__m256i a, __m128i count) {
  return to_camli(_mm256_srl_epi16(of_camli(a), count));
}

caml__m256i caml_avx2_int32x8_srl(caml__m256i a, __m128i count) {
  return to_camli(_mm256_srl_epi32(of_camli(a), count));
}

caml__m256i caml_avx2_int64x4_srl(caml__m256i a, __m128i count) {
  return to_camli(_mm256_srl_epi64(of_camli(a), count));
}

caml__m256i caml_avx2_int16x16_srli(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_srli_epi16(a_, i))
  switch (imm & 0xf) {
    CASE16(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int32x8_srli(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_srli_epi32(a_, i))
  switch (imm & 0x1f) {
    CASE32(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

caml__m256i caml_avx2_int64x4_srli(intnat imm, caml__m256i a) {
  __m256i a_ = of_camli(a);
#define F(i) to_camli(_mm256_srli_epi64(a_, i))
  switch (imm & 0x3f) {
    CASE64(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_avx2_int32x4_srlv(__m128i a, __m128i count) {
  return _mm_srlv_epi32(a, count);
}

caml__m256i caml_avx2_int32x8_srlv(caml__m256i a, caml__m256i count) {
  return to_camli(_mm256_srlv_epi32(of_camli(a), of_camli(count)));
}

__m128i caml_avx2_int64x2_srlv(__m128i a, __m128i count) {
  return _mm_srlv_epi64(a, count);
}

caml__m256i caml_avx2_int64x4_srlv(caml__m256i a, caml__m256i count) {
  return to_camli(_mm256_srlv_epi64(of_camli(a), of_camli(count)));
}

caml__m256i caml_avx2_int8x32_sub(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sub_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_sub(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sub_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int32x8_sub(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sub_epi32(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int64x4_sub(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_sub_epi64(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_sub_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_subs_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_sub_saturating(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_subs_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int8x32_sub_saturating_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_subs_epu8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_int16x16_sub_saturating_unsigned(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_subs_epu16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_interleave_high_8(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_unpackhi_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_interleave_high_16(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_unpackhi_epi16(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_interleave_low_8(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_unpacklo_epi8(of_camli(a), of_camli(b)));
}

caml__m256i caml_avx2_vec128x2_interleave_low_16(caml__m256i a, caml__m256i b) {
  return to_camli(_mm256_unpacklo_epi16(of_camli(a), of_camli(b)));
}

__m128 caml_f16c_cvt_float16x8_float32x4(__m128i a) { return _mm_cvtph_ps(a); }

caml__m256 caml_f16c_cvt_float16x8_float32x8(__m128i a) {
  return to_caml(_mm256_cvtph_ps(a));
}

__m128i caml_f16c_cvt_float32x4_float16x8(intnat imm, __m128 a) {
#define F(i) _mm_cvtps_ph(a, i)
  switch (imm & 0x7) {
    CASE8(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

__m128i caml_f16c_cvt_float32x8_float16x8(intnat imm, caml__m256 a) {
  __m256 a_ = of_caml(a);
#define F(i) _mm256_cvtps_ph(a_, i)
  switch (imm & 0x7) {
    CASE8(F, 0)
  default:
    assert(!"Invalid imm");
    abort();
  }
#undef F
}

float caml_fma_float32_mul_add(float a, float b, float c) {
  return _mm_cvtss_f32(_mm_fmadd_ss(_mm_set_ss(a), _mm_set_ss(b), _mm_set_ss(c)));
}

float caml_fma_float32_mul_sub(float a, float b, float c) {
  return _mm_cvtss_f32(_mm_fmsub_ss(_mm_set_ss(a), _mm_set_ss(b), _mm_set_ss(c)));
}

float caml_fma_float32_neg_mul_add(float a, float b, float c) {
  return _mm_cvtss_f32(_mm_fnmadd_ss(_mm_set_ss(a), _mm_set_ss(b), _mm_set_ss(c)));
}

float caml_fma_float32_neg_mul_sub(float a, float b, float c) {
  return _mm_cvtss_f32(_mm_fnmsub_ss(_mm_set_ss(a), _mm_set_ss(b), _mm_set_ss(c)));
}

double caml_fma_float64_mul_add(double a, double b, double c) {
  return _mm_cvtsd_f64(_mm_fmadd_sd(_mm_set_sd(a), _mm_set_sd(b), _mm_set_sd(c)));
}

double caml_fma_float64_mul_sub(double a, double b, double c) {
  return _mm_cvtsd_f64(_mm_fmsub_sd(_mm_set_sd(a), _mm_set_sd(b), _mm_set_sd(c)));
}

double caml_fma_float64_neg_mul_add(double a, double b, double c) {
  return _mm_cvtsd_f64(_mm_fnmadd_sd(_mm_set_sd(a), _mm_set_sd(b), _mm_set_sd(c)));
}

double caml_fma_float64_neg_mul_sub(double a, double b, double c) {
  return _mm_cvtsd_f64(_mm_fnmsub_sd(_mm_set_sd(a), _mm_set_sd(b), _mm_set_sd(c)));
}

__m128 caml_fma_float32x4_mul_add(__m128 a, __m128 b, __m128 c) {
  return _mm_fmadd_ps(a, b, c);
}

__m128 caml_fma_float32x4_mul_sub(__m128 a, __m128 b, __m128 c) {
  return _mm_fmsub_ps(a, b, c);
}

__m128 caml_fma_float32x4_mul_addsub(__m128 a, __m128 b, __m128 c) {
  return _mm_fmaddsub_ps(a, b, c);
}

__m128 caml_fma_float32x4_mul_subadd(__m128 a, __m128 b, __m128 c) {
  return _mm_fmsubadd_ps(a, b, c);
}

__m128 caml_fma_float32x4_neg_mul_add(__m128 a, __m128 b, __m128 c) {
  return _mm_fnmadd_ps(a, b, c);
}

__m128 caml_fma_float32x4_neg_mul_sub(__m128 a, __m128 b, __m128 c) {
  return _mm_fnmsub_ps(a, b, c);
}

__m128d caml_fma_float64x2_mul_add(__m128d a, __m128d b, __m128d c) {
  return _mm_fmadd_pd(a, b, c);
}

__m128d caml_fma_float64x2_mul_sub(__m128d a, __m128d b, __m128d c) {
  return _mm_fmsub_pd(a, b, c);
}

__m128d caml_fma_float64x2_mul_addsub(__m128d a, __m128d b, __m128d c) {
  return _mm_fmaddsub_pd(a, b, c);
}

__m128d caml_fma_float64x2_mul_subadd(__m128d a, __m128d b, __m128d c) {
  return _mm_fmsubadd_pd(a, b, c);
}

__m128d caml_fma_float64x2_neg_mul_add(__m128d a, __m128d b, __m128d c) {
  return _mm_fnmadd_pd(a, b, c);
}

__m128d caml_fma_float64x2_neg_mul_sub(__m128d a, __m128d b, __m128d c) {
  return _mm_fnmsub_pd(a, b, c);
}

caml__m256 caml_fma_float32x8_mul_add(caml__m256 a, caml__m256 b, caml__m256 c) {
  return to_caml(_mm256_fmadd_ps(of_caml(a), of_caml(b), of_caml(c)));
}

caml__m256 caml_fma_float32x8_mul_sub(caml__m256 a, caml__m256 b, caml__m256 c) {
  return to_caml(_mm256_fmsub_ps(of_caml(a), of_caml(b), of_caml(c)));
}

caml__m256 caml_fma_float32x8_mul_addsub(caml__m256 a, caml__m256 b, caml__m256 c) {
  return to_caml(_mm256_fmaddsub_ps(of_caml(a), of_caml(b), of_caml(c)));
}

caml__m256 caml_fma_float32x8_mul_subadd(caml__m256 a, caml__m256 b, caml__m256 c) {
  return to_caml(_mm256_fmsubadd_ps(of_caml(a), of_caml(b), of_caml(c)));
}

caml__m256 caml_fma_float32x8_neg_mul_add(caml__m256 a, caml__m256 b, caml__m256 c) {
  return to_caml(_mm256_fnmadd_ps(of_caml(a), of_caml(b), of_caml(c)));
}

caml__m256 caml_fma_float32x8_neg_mul_sub(caml__m256 a, caml__m256 b, caml__m256 c) {
  return to_caml(_mm256_fnmsub_ps(of_caml(a), of_caml(b), of_caml(c)));
}

caml__m256d caml_fma_float64x4_mul_add(caml__m256d a, caml__m256d b, caml__m256d c) {
  return to_camld(_mm256_fmadd_pd(of_camld(a), of_camld(b), of_camld(c)));
}

caml__m256d caml_fma_float64x4_mul_sub(caml__m256d a, caml__m256d b, caml__m256d c) {
  return to_camld(_mm256_fmsub_pd(of_camld(a), of_camld(b), of_camld(c)));
}

caml__m256d caml_fma_float64x4_mul_addsub(caml__m256d a, caml__m256d b, caml__m256d c) {
  return to_camld(_mm256_fmaddsub_pd(of_camld(a), of_camld(b), of_camld(c)));
}

caml__m256d caml_fma_float64x4_mul_subadd(caml__m256d a, caml__m256d b, caml__m256d c) {
  return to_camld(_mm256_fmsubadd_pd(of_camld(a), of_camld(b), of_camld(c)));
}

caml__m256d caml_fma_float64x4_neg_mul_add(caml__m256d a, caml__m256d b, caml__m256d c) {
  return to_camld(_mm256_fnmadd_pd(of_camld(a), of_camld(b), of_camld(c)));
}

caml__m256d caml_fma_float64x4_neg_mul_sub(caml__m256d a, caml__m256d b, caml__m256d c) {
  return to_camld(_mm256_fnmsub_pd(of_camld(a), of_camld(b), of_camld(c)));
}
