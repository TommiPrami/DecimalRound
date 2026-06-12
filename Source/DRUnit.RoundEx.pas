unit DRUnit.RoundEx;

interface

{$INCLUDE DecimalRound.inc}

uses
  DRUnit.Types;

  { The following functions have a two times "epsilon" error built in for the Single, Double and Extended argument
    respectively.

    Special values (all build configurations):
      - NaN in -> NaN out (the input NaN is returned as is).
      - ARoundingControl = drcNone returns the value unchanged.
      - ±Infinity, and values whose scaled magnitude (AValue * 10^N) would
        overflow the internal Int64 conversion, are returned unchanged. At
        such magnitudes the value carries no decimal fraction information at
        the requested precision, so the input is already its own best
        rounding (see MAX_SAFE_SCALED_VALUE in DRUnit.Consts). }
  function DecimalRoundEx(const AValue: Single; const ANumberOfDecimals: Integer;
    const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended; overload;
  function DecimalRoundEx(const AValue: Double; const ANumberOfDecimals: Integer;
    const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended; overload;
{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function DecimalRoundEx(const AValue: Extended; const ANumberOfDecimals: Integer;
    const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended; overload;
{$ENDIF}

implementation

uses
  DRUnit.Consts, DRUnit.Utils;

{ The following DecimalRound function is for doing the best possible job of
  rounding floating binary point numbers to the specified NDFD.  MaxRelError
  is the maximum relative error that will be allowed when determining the
  cut points for applying the rounding rules.

  Parameters
    AValue: Extended              Input value to be rounded.
    ANumberOfDecimals: Integer    Number decimal fraction digits to figure in result.
    AMaxRelativeError: Double     Maximum relative error to assume in input value.
    ARoundingControl              Optional rounding rule

  NOTE: For performance, no range check is done on ANumberOfDecimals at the
  array lookup. An Assert guards Debug builds; in Release the caller is
  expected to pass a value within [-ROUND_FLOAT_MAX_DECIMAL_COUNT..
  +ROUND_FLOAT_MAX_DECIMAL_COUNT].

  NOTE: NaN must be filtered out by the caller (the public wrappers do this);
  everything else, including ±Infinity, is safe to pass in.
}
function InternalDecimalRoundEx(const AValue: Extended; const ANumberOfDecimals: Integer; const AMaxRelativeError: Double;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
var
  LInt64Value: Int64;
  LCandidateLow: Int64;
  LCandidateHigh: Int64;
  LMultiplier: Extended;
  LScaledValue: Extended;
  LScaledError: Extended;
begin
  Assert(AMaxRelativeError > 0, 'AMaxRelativeError param in call to DecimalRound() must be greater than zero.');
  Assert((ANumberOfDecimals >= Low(gPowerOfTenMultipliers)) and (ANumberOfDecimals <= High(gPowerOfTenMultipliers)),
    'ANumberOfDecimals out of range for gPowerOfTenMultipliers lookup.');
  Assert(IsFpuCwOkForRounding,
    'FPU is not configured for round-to-nearest-even — DecimalRoundEx results will be off.');

  if ARoundingControl = drcNone then
    Exit(AValue);

  LMultiplier := gPowerOfTenMultipliers[ANumberOfDecimals];

  if ANumberOfDecimals >= 0 then
    LScaledValue := AValue * LMultiplier
  else
    LScaledValue := AValue / LMultiplier;

  { Too large for the Int64 conversion below (covers ±Infinity as well). At
    this magnitude the rounding granule is below one ulp of the input, so the
    value is already its own best rounding — return it unchanged instead of
    letting Round() overflow into garbage. }
  if Abs(LScaledValue) >= MAX_SAFE_SCALED_VALUE then
    Exit(AValue);

  if ANumberOfDecimals >= 0 then
    LScaledError := Abs(AMaxRelativeError * AValue) * LMultiplier
  else
    LScaledError := Abs(AMaxRelativeError * AValue) / LMultiplier;

  { Do the different basic types separately: }
  case ARoundingControl of
    drcHalfEven:
      begin
        { Bankers rounding: try the low and high edges of the epsilon band.
          If the lower candidate is odd, the value is effectively on a halfway
          point — the upper candidate (under the FPU's bankers rounding mode,
          which IsFpuCwOkForRounding asserts) will land on the even integer.
          Otherwise the lower candidate already is the nearest. }
        LCandidateLow := Round(LScaledValue - LScaledError);
        LCandidateHigh := Round(LScaledValue + LScaledError);

        if Odd(LCandidateLow) then
          LInt64Value := LCandidateHigh
        else
          LInt64Value := LCandidateLow;
      end;
    drcHalfDown:  {Round to nearest or toward zero.}
      LInt64Value := Round((Abs(LScaledValue) - LScaledError));
    drcHalfUp:    {Round to nearest or away from zero.}
      LInt64Value := Round((Abs(LScaledValue) + LScaledError));
    drcHalfPos:   {Round to nearest or toward positive.}
      LInt64Value := Round((LScaledValue + LScaledError));
    drcHalfNeg:   {Round to nearest or toward negative.}
      LInt64Value := Round((LScaledValue - LScaledError));
    drcRndNeg:    {Truncate toward negative. (a.k.a. Floor)}
      LInt64Value := Round((LScaledValue + (LScaledError - 1 / 2)));
    drcRndPos:    {Truncate toward positive. (a.k.a. Ceil)}
      LInt64Value := Round((LScaledValue - (LScaledError - 1 / 2)));
    drcRndDown:   {Truncate toward zero (a.k.a. Trunc).}
      LInt64Value := Round((Abs(LScaledValue) + (LScaledError - 1 / 2)));
    drcRndUp:     {Truncate away from zero.}
      LInt64Value := Round((Abs(LScaledValue) - (LScaledError - 1 / 2)));
    else
      LInt64Value := Round(LScaledValue);
  end;

  { Finally convert back to the right order }
  if ANumberOfDecimals >= 0 then
    Result := LInt64Value / LMultiplier
  else
    Result := LInt64Value * LMultiplier;

  if (ARoundingControl in [drcHalfDown, drcHalfUp, drcRndDown, drcRndUp]) and (AValue < 0) then
    Result := -Result;
end;

function DecimalRoundEx(const AValue: Single; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
  if DRUnit.Utils.IsNan(AValue) then
    Exit(AValue);

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_SINGLE, ARoundingControl);
end;

function DecimalRoundEx(const AValue: Double; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
  if DRUnit.Utils.IsNan(AValue) then
    Exit(AValue);

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_DOUBLE, ARoundingControl);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function DecimalRoundEx(const AValue: Extended; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
  if DRUnit.Utils.IsNan(AValue) then
    Exit(AValue);

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_EXTENDED, ARoundingControl);
end;
{$ENDIF}

end.
