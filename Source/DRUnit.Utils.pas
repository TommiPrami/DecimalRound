unit DRUnit.Utils;

interface

{$INCLUDE DR.inc}

uses
  System.Classes, DRUnit.Consts;

  { This procedure was used to compute the Epsilon values }
  procedure CalcEpsValues(var ASingleEpsilon, ADoubleEpsilon, AExtendedEpsilon: Double);

  { Each returns true if the value passed is not-a-number. }
  function IsNan(const ASingleValue: Single): Boolean; overload; inline;
  function IsNan(const ADoubleValue: Double): Boolean; overload; inline;
{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function IsNan(const AExtendedValue: Extended): Boolean; overload; inline;
{$ENDIF}

  { Returns the FPU control word (which indicates interrupt masks and precision and rounding modes). }
  function GetX87CW: Word;

  { Interpretes X87 control word and returns as a string. }
  function X87CWToString(const AControlWord: Word): string;

  { Returns true if floating point processor (FPU) is correctly set
    (1) to allow conversion from Extended to Double and Double to Single
        without creating the the loss-of-precision interrupt or exception,
    (2) to do arithmetic internal to FPU in Extended precision, and
    (3) to internally use halves-to-even (a.k.a. bankers) rounding. }
  function IsFpuCwOkForRounding: Boolean;

  { This procedure loads the tDecimalRoundingCtrl descriptions and ordinals
    into the string list for such use as using a TCombobox to make rounding
    type selection. }
  procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings; const AAddAbbreviotion: Boolean = True);

var
  gRoundFoatMultiplierArray: array [-ROUND_FLOAT_MAX_DECIMAL_COUNT..ROUND_FLOAT_MAX_DECIMAL_COUNT] of Extended;

implementation

uses
  System.SysUtils, DRUnit.Types;

{ Compute smallest 1/(2^n) epsilon values for which "1 + epsilon <> 1".
  For "1 - epsilon <> 1", divide these computed values by 2. }
procedure CalcEpsValues(var ASingleEpsilon, ADoubleEpsilon, AExtendedEpsilon: Double);
var
  s: Single;
  d: Double;
  e: Extended;
  f: Extended;
begin
  { Compute for Single, s: }
  f := 1.00;
  repeat
    f := f / 2.00;
    s := 1.00 + f / 2.00;
  until s = 1.00;
  ASingleEpsilon := f;

  { Compute for Double, d: }
  f := 1.00;
  repeat
    f := f / 2.00;
    d := 1.00 + f / 2.00;
  until d = 1.00;
  ADoubleEpsilon := f;

  { Compute with Extended, e: }
  f := 1.00;
  repeat
    f := f / 2.00;
    e := 1.00 + f / 2.00;
  until e = 1.00;

  AExtendedEpsilon := f;
end;

function IsNan(const ASingleValue: Single): Boolean;
var
  LInputX: LongInt absolute ASingleValue;
begin
  Result := (LInputX <> 0) and ((LInputX and SINGLE_EXPONENT_BITS) = SINGLE_EXPONENT_BITS);
end;

function IsNan(const ADoubleValue: Double): Boolean;
var
  LInputX: Int64 absolute ADoubleValue;
begin
  Result := (LInputX <> 0) and ((LInputX and DOUBLE_EXPONENT_BITS) = DOUBLE_EXPONENT_BITS);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function IsNan(const AExtendedValue: Extended): Boolean;
var
  LInputX: TExtendedtRec absolute AExtendedValue;
begin
  Result := (LInputX.Significand <> 0) and ((LInputX.Exponent and EXTENDED_EXPONENT_BITS) = EXTENDED_EXPONENT_BITS);
end;
{$ENDIF}

procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings; const AAddAbbreviotion: Boolean = True);
var
  LRoundingControl: TDecimalRoundingControl;
begin
  Assert(AStrings <> nil);

  AStrings.Clear;
  for LRoundingControl := Low(LRoundingControl) to High(LRoundingControl) do
    if AAddAbbreviotion then
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

{ Interpretes X87 control word and returns as a string. }
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
    + '; Precision=' + PRECICION_CONTROL_STRINGS[LPrecisionControl]
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

  Result := ((LControlWord and (PC or RC or PM)) = (RC_BANKERS or PC_EXTENDED or PM));
end;

procedure InitializeRoundFloatMultiplierLookUp;
var
  I: Integer;
  LMultiplier: Extended;
begin
  LMultiplier := 1.00;

  gRoundFoatMultiplierArray[0] := LMultiplier;
  for I := 1 to High(gRoundFoatMultiplierArray) do
  begin
    LMultiplier := LMultiplier * 10;
    gRoundFoatMultiplierArray[I] := LMultiplier;
  end;

  for I := Low(gRoundFoatMultiplierArray) to -1 do
    gRoundFoatMultiplierArray[I] := gRoundFoatMultiplierArray[Abs(I)];
end;

initialization
  InitializeRoundFloatMultiplierLookUp;

end.
