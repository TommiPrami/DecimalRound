unit DRUnit.Types;

interface

type
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
