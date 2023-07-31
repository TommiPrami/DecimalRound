unit DRUnit.Types;

interface

type
  TX87RoundingControl = (rcBankers, rcFloor, rcCeil, rcChop);
  TX87PrecisionControl = (pcSingle, pcReserved, pcDouble, pcExtended);
  TX87InterruptBit = (ibI, ibD, ibZ, ibO, ibU, ibP, ib6, ib7);
  TX87InterruptBits = set of tX87InterruptBit;

  tB10 = array [0..9] of Byte;
  tB8 = array [0..7] of Byte;
  tB4 = array [0..3] of Byte;

  TExtendedtRec = packed record
    Significand: int64;
    Exponent: Word;
  end;

  TDecimalRoundingControl =    {The defined rounding methods}
    (
      drcNone,    {No rounding.}
      drcHalfEven,{Round to nearest or to even whole number. (a.k.a Bankers) }
      drcHalfPos, {Round to nearest or toward positive.}
      drcHalfNeg, {Round to nearest or toward negative.}
      drcHalfDown,{Round to nearest or toward zero.}
      drcHalfUp,  {Round to nearest or away from zero.}
      drcRndNeg,  {Round toward negative.                    (a.k.a. Floor) }
      drcRndPos,  {Round toward positive.                    (a.k.a. Ceil ) }
      drcRndDown, {Round toward zero.                        (a.k.a. Trunc) }
      drcRndUp    {Round away from zero.}
    );


implementation

end.
