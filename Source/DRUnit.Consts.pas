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

  { These FPU Control Word bit masks prevent interrupt when present: }
  IM = $0001; {Invalid op interrupt Mask}
  DM = $0002; {Denormalized op interrupt Mask}
  ZM = $0004; {Zero divide interrupt Mask}
  OM = $0008; {Overflow interrupt Mask}
  UM = $0010; {Underflow interrupt Mask}
  PM = $0020; {Loss of precision interrupt Mask}
  { The "pending interrupt" flags in status word have matching positions. }
  IntrM = IM or DM or ZM or OM or UM or PM;
  { These FPU Control Word bit fields change operation: }
  PC = $0300; {Precision Control mask}
  RC = $0C00; {Rounding Control mask}

  PC_SINGLE = $0000;
  PC_DOUBLE = $0200;
  PC_EXTENDED = $0300;

  RC_BANKERS = $0000;
  RC_FLOOR = $0400;
  RC_CEIL = $0800;
  RC_CHOP = $0C00;

  ROUND_FLOAT_MAX_DECIMAL_COUNT = 19;

  SINGLE_EXPONENT_BITS: LongInt = $7F800000; { 8 bits}
  DOUBLE_EXPONENT_BITS: Int64 = $7FF0000000000000; {11 bits}
  EXTENDED_EXPONENT_BITS: Word = $7FFF; {15 bits}

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

(* CW Mask bits prevent interrupt when true:
   (Pending interrupt flags in status word have matching positions.) )
    $0001 -- IM (Invalid op interrupt Mask)
    $0002 -- DM (Denormalized op interrupt Mask)
    $0004 -- ZM (Zero divide interrupt Mask)
    $0008 -- OM (Overflow interrupt Mask)
    $0010 -- UM (Underflow interrupt Mask)
    $0020 -- PM (Loss of precision interrupt Mask) }
{ CW Control bits change operation:
    $0300 -- PC (Precision Control mask)
    $0C00 -- RC (Rounding Control mask)
    $1000 -- IC (Infinity Control mask) *)

const {define long names}
  ibInValidOperation = ibI;
  ibDenormalizedOperand = ibD;
  ibZeroDivide = ibZ;
  ibOverflow = ibO;
  ibUnderflow = ibU;
  ibPrecision = ibP;

  X87_ROUNDING_CONTROL_STRINGS: array [TX87RoundingControl] of string = ('bankers', 'floor', 'ceil', 'chop');
  PRECICION_CONTROL_STRINGS: array [TX87PrecisionControl] of string = ('single', 'reserved', 'double', 'extended');
  INTERRUPT_MASK_STRINGS: array [TX87InterruptBit] of string = ('IM', 'DM', 'ZM', 'OM', 'UM', 'PM', 'm6', 'm7');
  INTERRUPT_STATUS_STRINGS: array [TX87InterruptBit] of string = ('IE', 'DE', 'ZE', 'OE', 'UE', 'PE', 'e6', 'e7');

  DIGITS: array [0..9] of Char = '0123456789';

  NUMBER_OF_BITS_TO_CLEAR = 8;
  MASK: int64 = $FFFFFFFFFFFFFFFF shr NUMBER_OF_BITS_TO_CLEAR;

  INC_DOUBLE = $1000;
  INC_SINGLE = $10000000000;

implementation

end.
