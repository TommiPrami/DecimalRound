unit DRUnit.Round;

interface

{$INCLUDE DR.inc}

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
}
function InternalDecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer; const AMaxRelativeError: Double): Extended;
var
  LInt64Value: Int64;
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
  if IsNan(AValue) then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRound(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_SINGLE);
end;

function DecimalRound(const AValue: Double; const ANumberOfDecimals: Integer = 2): Extended;
begin
{$IFDEF DO_CHECKS}
  if IsNan(AValue) then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRound(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_DOUBLE);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function DecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer = 2): Extended;
begin
{$IFDEF DO_CHECKS}
  if IsNan(AValue) then
    Exit(AValue);
{$ENDIF}

  Result := InternalDecimalRound(AValue, ANumberOfDecimals, MAXIMUM_RELATIVE_ERROR_EXTENDED);
end;
{$ENDIF}

End.
