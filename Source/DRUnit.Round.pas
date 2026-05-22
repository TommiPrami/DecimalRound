unit DRUnit.Round;

interface

{$INCLUDE DecimalRound.inc}

uses
  DRUnit.Types;

  { The following functions have a two times "epsilon" error built in for the Single, Double, and Extended argument
    respectively }
  function DecimalRound(const AValue: Single; const ANumberOfDecimals: Integer = 2): Extended; overload;
  function DecimalRound(const AValue: Double; const ANumberOfDecimals: Integer = 2): Extended; overload;
{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function DecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer = 2): Extended; overload;
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
function InternalDecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer; const AMaxRelativeError: Double): Extended;
var
  LInt64Value: Int64;
  LMultiplier: Extended;
  LScaledValue: Extended;
  LScaledError: Extended;
begin
  Assert(AMaxRelativeError > 0, 'AMaxRelativeError param in call to DecimalRound() must be greater than zero.');
  Assert((ANumberOfDecimals >= Low(gPowerOfTenMultipliers)) and (ANumberOfDecimals <= High(gPowerOfTenMultipliers)),
    'ANumberOfDecimals out of range for gPowerOfTenMultipliers lookup.');
  Assert(IsFpuCwOkForRounding,
    'FPU control word is not configured for bankers rounding / Extended precision — DecimalRound results will be off.');

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

  // drcHalfUp - Round to nearest or away from zero.
  LInt64Value := Round((Abs(LScaledValue) + LScaledError));

  { Finally convert back to the right order }
  if ANumberOfDecimals >= 0 then
    Result := LInt64Value / LMultiplier
  else
    Result := LInt64Value * LMultiplier;

  if AValue < 0 then
    Result := -Result;
end;

function DecimalRound(const AValue: Single; const ANumberOfDecimals: Integer = 2): Extended;
begin
{$IFDEF DO_CHECKS}
  if DRUnit.Utils.IsNan(AValue) then
    Exit(NaN);
{$ENDIF}

  Result := InternalDecimalRound(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_SINGLE);
end;

function DecimalRound(const AValue: Double; const ANumberOfDecimals: Integer = 2): Extended;
begin
{$IFDEF DO_CHECKS}
  if DRUnit.Utils.IsNan(AValue) then
    Exit(NaN);
{$ENDIF}

  Result := InternalDecimalRound(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_DOUBLE);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function DecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer = 2): Extended;
begin
{$IFDEF DO_CHECKS}
  if DRUnit.Utils.IsNan(AValue) then
    Exit(NaN);
{$ENDIF}

  Result := InternalDecimalRound(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_EXTENDED);
end;
{$ENDIF}

End.
