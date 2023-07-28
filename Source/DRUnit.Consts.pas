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
  pcSingle = $0000;
  pcDouble = $0200;
  pcExtended = $0300;
  rcBankers = $0000;
  rcFloor = $0400;
  rcCeil = $0800;
  rcChop = $0C00;

  ROUND_FLOAT_MAX_DECIMAL_COUNT = 19;

  SglExpBits: LongInt = $7F800000;          { 8 bits}
  DblExpBits: Int64   = $7FF0000000000000;  {11 bits}
  ExtExpBits: word    = $7FFF;              {15 bits}

  DecimalRoundingCtrlStrs: array [TDecimalRoundingControl] of
      record
        Abbr: string[9];
        Dscr: string[59];
      end =
    (
      (Abbr: 'None'    ; Dscr: 'No rounding.'),
      (Abbr: 'HalfEven'; Dscr: 'Round to nearest or to even whole number (a.k.a Bankers)'),
      (Abbr: 'HalfPos' ; Dscr: 'Round to nearest or toward positive'),
      (Abbr: 'HalfNeg' ; Dscr: 'Round to nearest or toward negative'),
      (Abbr: 'HalfDown'; Dscr: 'Round to nearest or toward zero'),
      (Abbr: 'HalfUp'  ; Dscr: 'Round to nearest or away from zero'),
      (Abbr: 'RndNeg'  ; Dscr: 'Round toward negative. (a.k.a. Floor) '),
      (Abbr: 'RndPos'  ; Dscr: 'Round toward positive. (a.k.a. Ceil ) '),
      (Abbr: 'RndDown' ; Dscr: 'Round toward zero. (a.k.a. Trunc) '),
      (Abbr: 'RndUp'   ; Dscr: 'Round away from zero.')
    );


implementation

end.
