unit DRUnit.RoundEx;

interface

{$INCLUDE DecimalRound.inc}

uses
  DRUnit.Types;

  { The following functions have a two times "epsilon" error built in for the Single, Double and Extended argument
    respectively }
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
  System.Math, DRUnit.Consts, DRUnit.Utils;

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
    'FPU control word is not configured for bankers rounding / Extended precision — DecimalRoundEx results will be off.');

  LMultiplier := gPowerOfTenMultipliers[ANumberOfDecimals];

  if ANumberOfDecimals >= 0 then
  begin
    LScaledValue := AValue * LMultiplier;
    LScaledError := Abs(AMaxRelativeError * AValue) * LMultiplier;
  end
  else
  begin
    LScaledValue := AValue / LMultiplier;
    LScaledError := Abs(AMaxRelativeError * AValue) / LMultiplier;
  end;

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
{$IFDEF DO_CHECKS}
  if DRUnit.Utils.IsNan(AValue) then
    Exit(NaN)
  else if ARoundingControl = drcNone then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_SINGLE, ARoundingControl);
end;

function DecimalRoundEx(const AValue: Double; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
{$IFDEF DO_CHECKS}
  if DRUnit.Utils.IsNan(AValue) then
    Exit(NaN)
  else if ARoundingControl = drcNone then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_DOUBLE, ARoundingControl);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function DecimalRoundEx(const AValue: Extended; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
{$IFDEF DO_CHECKS}
  if DRUnit.Utils.IsNan(AValue) then
    Exit(NaN)
  else  if ARoundingControl = drcNone then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_EXTENDED, ARoundingControl);
end;
{$ENDIF}

end.
