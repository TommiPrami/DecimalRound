unit DRUnit.Utils;

interface

{$INCLUDE DecimalRound.inc}

uses
  System.Classes, DRUnit.Consts;

  { This procedure was used to compute the Epsilon values }
  procedure CalcEpsValues(var ASingleEpsilon, ADoubleEpsilon, AExtendedEpsilon: Double);

  { Each returns true if the value passed is not-a-number.
    NOTE: Returns False for +Inf / -Inf (an earlier version of this routine
    misclassified infinities as NaN). }
  function IsNan(const ASingleValue: Single): Boolean; overload; inline;
  function IsNan(const ADoubleValue: Double): Boolean; overload; inline;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
  function IsNan(const AExtendedValue: Extended): Boolean; overload; inline;
{$ENDIF}

  { Returns the FPU control word (which indicates interrupt masks and precision and rounding modes). }
  function GetX87CW: Word;

  { Interprets X87 control word and returns as a string. }
  function X87CWToString(const AControlWord: Word): string;

  { Returns true if floating point processor (FPU) is correctly set
    (1) to allow conversion from Extended to Double and Double to Single
        without creating the the loss-of-precision interrupt or exception,
    (2) to do arithmetic internal to FPU in Extended precision, and
    (3) to internally use halves-to-even (a.k.a. bankers) rounding. }
  function IsFpuCwOkForRounding: Boolean;

  { This procedure loads the TDecimalRoundingControl descriptions and ordinals
    into the string list for such use as using a TCombobox to make rounding
    type selection. }
  procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings; const AAddAbbreviation: Boolean = True);

var
  { Lookup of 10^N. Indexed by decimal-count; negative indices mirror the
    positive ones (callers divide by the lookup for negative N). }
  gPowerOfTenMultipliers: array [-ROUND_FLOAT_MAX_DECIMAL_COUNT..ROUND_FLOAT_MAX_DECIMAL_COUNT] of Extended;

implementation

uses
  System.SysUtils, DRUnit.Types;

{ Compute smallest 1/(2^n) epsilon values for which "1 + epsilon <> 1".
  For "1 - epsilon <> 1", divide these computed values by 2. }
procedure CalcEpsValues(var ASingleEpsilon, ADoubleEpsilon, AExtendedEpsilon: Double);
var
  LSingleTest: Single;
  LDoubleTest: Double;
  LExtendedTest: Extended;
  LFactor: Extended;
begin
  { Compute for Single: }
  LFactor := 1.00;

  repeat
    LFactor := LFactor / 2.00;
    LSingleTest := 1.00 + LFactor / 2.00;
  until LSingleTest = 1.00;

  ASingleEpsilon := LFactor;

  { Compute for Double: }
  LFactor := 1.00;

  repeat
    LFactor := LFactor / 2.00;
    LDoubleTest := 1.00 + LFactor / 2.00;
  until LDoubleTest = 1.00;

  ADoubleEpsilon := LFactor;

  { Compute for Extended: }
  LFactor := 1.00;

  repeat
    LFactor := LFactor / 2.00;
    LExtendedTest := 1.00 + LFactor / 2.00;
  until LExtendedTest = 1.00;

  AExtendedEpsilon := LFactor;
end;

function IsNan(const ASingleValue: Single): Boolean;
var
  LBits: LongInt absolute ASingleValue;
begin
  { NaN: exponent bits all-ones AND mantissa non-zero.
    Infinity also has exponent all-ones but its mantissa is zero. }
  Result := ((LBits and SINGLE_EXPONENT_BITS) = SINGLE_EXPONENT_BITS) and ((LBits and SINGLE_MANTISSA_BITS) <> 0);
end;

function IsNan(const ADoubleValue: Double): Boolean;
var
  LBits: Int64 absolute ADoubleValue;
begin
  Result := ((LBits and DOUBLE_EXPONENT_BITS) = DOUBLE_EXPONENT_BITS) and ((LBits and DOUBLE_MANTISSA_BITS) <> 0);
end;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
function IsNan(const AExtendedValue: Extended): Boolean;
var
  LBits: TExtendedRec absolute AExtendedValue;
begin
  { For 80-bit Extended the significand has an explicit leading bit (bit 63).
    Infinity = exponent all-ones AND significand = $8000000000000000.
    NaN     = exponent all-ones AND the lower 63 bits of the significand non-zero. }
  Result := ((LBits.Exponent and EXTENDED_EXPONENT_BITS) = EXTENDED_EXPONENT_BITS)
    and ((LBits.Significand and EXTENDED_SIGNIFICAND_NON_LEADING_BITS) <> 0);
end;
{$ENDIF}

procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings; const AAddAbbreviation: Boolean = True);
var
  LRoundingControl: TDecimalRoundingControl;
begin
  Assert(Assigned(AStrings));

  AStrings.Clear;

  for LRoundingControl := Low(LRoundingControl) to High(LRoundingControl) do
    if AAddAbbreviation then
      AStrings.AddObject(ROUNDING_CONTROL_STRINGS[LRoundingControl].Abbreviation, Pointer(LRoundingControl))
    else
      AStrings.AddObject(ROUNDING_CONTROL_STRINGS[LRoundingControl].Description, Pointer(LRoundingControl));
end;

{ Returns the FPU control word (which indicates interrupt masks and precision and rounding modes). }
function GetX87CW: Word;
asm
  FStCW [Result]
end;

{ PickX87PrecisionCtrl picks FPU precision control out of CW.}
function PickX87PrecisionCtrl(const AControlWord: Word): TX87PrecisionControl;
begin
  Result := TX87PrecisionControl((AControlWord and $0300) shr 8);
end;

{ PickX87RoundingCtrl picks FPU rounding control out of CW.}
function PickX87RoundingCtrl(const AControlWord: Word): TX87RoundingControl;
begin
  Result := TX87RoundingControl((AControlWord and $0C00) shr 10);
end;

{ PickX87InterruptMask picks FPU interrupt mask bits out of CW.}
function PickX87InterruptMask(const AControlWord: Word): TX87InterruptBits;
begin
  Result := TX87InterruptBits(Byte(AControlWord and $00FF));
end;

{ Interprets X87 control word and returns as a string. }
function X87CWToString(const AControlWord: Word): string;
var
  LRoundingControl: TX87RoundingControl;
  LPrecisionControl: TX87PrecisionControl;
  LMask: TX87InterruptBits;
  LInterruptBit: TX87InterruptBit;
begin
  LRoundingControl := PickX87RoundingCtrl(AControlWord);
  LPrecisionControl := PickX87PrecisionCtrl(AControlWord);
  LMask := PickX87InterruptMask(AControlWord);

  Result := '';

  for LInterruptBit := Low(LInterruptBit) to High(LInterruptBit) do
    if LInterruptBit in LMask then
      Result := Result + INTERRUPT_MASK_STRINGS[LInterruptBit] + ',';

  if Length(Result) > 0 then
    SetLength(Result, Length(Result) - 1);

  Result := 'FPU Rounding=' + X87_ROUNDING_CONTROL_STRINGS[LRoundingControl]
    + '; Precision=' + PRECISION_CONTROL_STRINGS[LPrecisionControl]
    + '; ExceptionMasks=[' + Result + '] $' + IntToHex(AControlWord, 4);
end;

{ Checks to see that floating point processor (FPU) is correctly set to

    (1) allow conversion from Extended to Double and Double to Single
        without creating the the loss of precision interrupt or exception,
    (2) do arithmetic internal to FPU in Extended precision, and
    (3) use round halves-to-even (a.k.a. bankers rounding) internally. }
function IsFpuCwOkForRounding: Boolean;
var
  LControlWord: Word;
begin
  LControlWord := GetX87CW;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
  Result := ((LControlWord and (PC or RC or PM)) = (RC_BANKERS or PC_EXTENDED or PM));
{$ELSE}
  Result := ((LControlWord and (PC or RC or PM)) = (RC_BANKERS or PC_DOUBLE or PM));
{$ENDIF}
end;

procedure InitializePowerOfTenMultipliers;
var
  I: Integer;
  LMultiplier: Extended;
begin
  LMultiplier := 1.00;

  gPowerOfTenMultipliers[0] := LMultiplier;

  for I := 1 to High(gPowerOfTenMultipliers) do
  begin
    LMultiplier := LMultiplier * 10;
    gPowerOfTenMultipliers[I] := LMultiplier;
  end;

  { Negative indices mirror positive ones — callers divide by the lookup instead of multiplying when ANumberOfDecimals < 0. }
  for I := Low(gPowerOfTenMultipliers) to -1 do
    gPowerOfTenMultipliers[I] := gPowerOfTenMultipliers[Abs(I)];
end;

initialization
  InitializePowerOfTenMultipliers;

end.
