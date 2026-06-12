unit DRUnit.Consts;

interface

uses
  DRUnit.Types;

const
  {
    The following "epsilon" values are representative of the resolution of the
    floating point numbers divided by the number being represented.
    These constants are supplied to the rounding routines to determine how much
    correction should be allowed for the natural errors in representing
    decimal fractions.
    Using 2 times or higher multiples of these values may be advisable if the data
    have been massaged through arithmetic calculations.
    If MAXIMUM_RELATIVE_ERROR_XXX < EPSILON_ * KNOWN_ERROR_LIMIT then errors can occur.
  }
  EPSILON_SINGLE = 1.1920928955e-07;
  EPSILON_DOUBLE = 2.2204460493e-16;
  EPSILON_EXTENDED = 1.0842021725e-19;
  KNOWN_ERROR_LIMIT = 1.234375;
  SAFETY_FACTOR = 2;
  MAXIMUM_RELATIVE_ERROR_SINGLE = EPSILON_SINGLE * KNOWN_ERROR_LIMIT * SAFETY_FACTOR;
  MAXIMUM_RELATIVE_ERROR_DOUBLE = EPSILON_DOUBLE * KNOWN_ERROR_LIMIT * SAFETY_FACTOR;
  MAXIMUM_RELATIVE_ERROR_EXTENDED = EPSILON_EXTENDED * KNOWN_ERROR_LIMIT * SAFETY_FACTOR;

  { x87 FPU Control Word bit fields, used when interpreting the CW for
    diagnostics on Win32/x86. The low byte holds the exception mask bits in
    TX87InterruptBit order (IM, DM, ZM, OM, UM, PM). On Win64 floating point
    runs on SSE and is governed by the MXCSR register instead — see
    DRUnit.Utils.IsFpuCwOkForRounding / FpuSettingsToString. }
  PC = $0300; {Precision Control mask}
  RC = $0C00; {Rounding Control mask}

  ROUND_FLOAT_MAX_DECIMAL_COUNT = 19;

  { Upper bound for the magnitude of the scaled value (AValue * 10^N) that the
    rounding routines will pass to Round(). Kept safely below 2^63
    (= 9.2233720368547758E18) so that adding the error allowance or the
    half-unit offsets can never overflow the Int64 conversion. An overflowing
    Round() does NOT reliably raise: with floating point exceptions masked
    (the Delphi 12+ default) it silently yields the "indefinite integer"
    Low(Int64) — i.e. sign-flipped garbage. A value at or beyond this limit
    carries no decimal fraction information at the requested precision, so
    the rounding routines return such inputs (including ±Infinity) unchanged. }
  MAX_SAFE_SCALED_VALUE = 9.0E18;

  SINGLE_EXPONENT_BITS: LongInt = $7F800000; { 8 bits}
  DOUBLE_EXPONENT_BITS: Int64 = $7FF0000000000000; {11 bits}
  EXTENDED_EXPONENT_BITS: Word = $7FFF; {15 bits}

  { Mantissa / significand-without-leading-bit masks. NaN is identified by
    "exponent all ones AND mantissa non-zero"; Infinity has exponent all ones
    AND mantissa zero. The Extended significand has an explicit leading bit
    (bit 63), so for NaN detection we mask it off and require the remaining
    63 bits to be non-zero. }
  SINGLE_MANTISSA_BITS: LongInt = $007FFFFF;
  DOUBLE_MANTISSA_BITS: Int64 = $000FFFFFFFFFFFFF;
  EXTENDED_SIGNIFICAND_NON_LEADING_BITS: Int64 = $7FFFFFFFFFFFFFFF;

  ROUNDING_CONTROL_STRINGS: array [TDecimalRoundingControl] of
      record
        Abbreviation: string;
        Description: string;
      end =
    (
      (Abbreviation: 'None'    ; Description: 'No rounding.'),
      (Abbreviation: 'HalfEven'; Description: 'Round to nearest or to even whole number (a.k.a Bankers)'),
      (Abbreviation: 'HalfPos' ; Description: 'Round to nearest or toward positive'),
      (Abbreviation: 'HalfNeg' ; Description: 'Round to nearest or toward negative'),
      (Abbreviation: 'HalfDown'; Description: 'Round to nearest or toward zero'),
      (Abbreviation: 'HalfUp'  ; Description: 'Round to nearest or away from zero'),
      (Abbreviation: 'RndNeg'  ; Description: 'Round toward negative. (a.k.a. Floor) '),
      (Abbreviation: 'RndPos'  ; Description: 'Round toward positive. (a.k.a. Ceil ) '),
      (Abbreviation: 'RndDown' ; Description: 'Round toward zero. (a.k.a. Trunc) '),
      (Abbreviation: 'RndUp'   ; Description: 'Round away from zero.')
    );

  { Strings for interpreting the x87 control word in diagnostics output. }
  X87_ROUNDING_CONTROL_STRINGS: array [TX87RoundingControl] of string = ('bankers', 'floor', 'ceil', 'chop');
  PRECISION_CONTROL_STRINGS: array [TX87PrecisionControl] of string = ('single', 'reserved', 'double', 'extended');
  INTERRUPT_MASK_STRINGS: array [TX87InterruptBit] of string = ('IM', 'DM', 'ZM', 'OM', 'UM', 'PM', 'm6', 'm7');

implementation

end.
