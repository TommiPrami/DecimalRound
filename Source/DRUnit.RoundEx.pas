unit DRUnit.RoundEx;

interface

{$INCLUDE DR.inc}

uses
  DRUnit.Types;

  { The following functions have a two times "epsilon" error built in for the single, double, and extended argument
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
  DRUnit.Consts, DRUnit.Help, DRUnit.Utils;

{ The following DecimalRound function is for doing the best possible job of
  rounding floating binary point numbers to the specified NDFD.  MaxRelError
  is the maximum relative error that will be allowed when determining the
  cut points for applying the rounding rules.

  Parameters
    AValue: Extended              Input value to be rounded.
    ANumberOfDecimals: Integer    Number decimal fraction digits to figure in result.
    AMaxRelativeError: Double     Maximum relative error to assume in input value.
    ARoundingControl              Optional rounding rule
}
function InternalDecimalRoundEx(const AValue: Extended; const ANumberOfDecimals: Integer; const AMaxRelativeError: Double;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
var
  LInt64Value: Int64;
  LInt64ValueEven: Int64;
  LMultiplier: Extended;
  LScaledValue: Extended;
  LScaledError: Extended;
begin
  Assert(AMaxRelativeError > 0, 'AMaxRelativeError param in call to DecimalRound() must be greater than zero.');

  LMultiplier := gRoundFoatMultiplierArray[ANumberOfDecimals];

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

  { Do the diferent basic types separately: }
  case ARoundingControl of
    drcHalfEven:
      begin
        LInt64Value := Round(LScaledValue - LScaledError);
        LInt64ValueEven := Round(LScaledValue + LScaledError);

        if Odd(LInt64Value) then
          LInt64Value := LInt64ValueEven;
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

function DecimalRoundEx(const AValue: single; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
{$IFDEF DO_CHECKS}
  if IsNaN(AValue) or (ARoundingControl = drcNone) then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_SINGLE, ARoundingControl)
end;

function DecimalRoundEx(const AValue: Double; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
{$IFDEF DO_CHECKS}
  if IsNaN(AValue) or (ARoundingControl = drcNone) then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_DOUBLE, ARoundingControl)
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function DecimalRoundEx(const AValue: Extended; const ANumberOfDecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl = drcHalfUp): Extended;
begin
{$IFDEF DO_CHECKS}
  if IsNaN(AValue) or (ARoundingControl = drcNone) then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRoundEx(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_EXTENDED, ARoundingControl)
end;
{$ENDIF}

end.
