unit DRUnit.Utils;

interface

{$INCLUDE DR.inc}

uses
  System.Classes, DRUnit.Consts;

  { This procedure was used to compute the values SglEps, DblEps, and ExtEps: }
  procedure CalcEpsValues(var SglEps, DblEps, ExtEps: Double);

  { Each returns true if the value passed is not-a-number. }
  function IsNAN(const ASingleValue: Single): Boolean; overload; inline;
  function IsNAN(const ADoubleValue: Double): Boolean; overload; inline;
{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function IsNAN(const AExtendedValue: Extended): Boolean; overload; inline;
{$ENDIF}

  { Returns the FPU control word (which indicates interrupt masks and precision and rounding modes). }
  function GetX87CW: Word;

  { Returns true if floating point processor (FPU) is correctly set
    (1) to allow conversion from extended to double and double to single
        without creating the the loss-of-precision interrupt or exception,
    (2) to do arithmetic internal to FPU in extended precision, and
    (3) to internally use halves-to-even (a.k.a. bankers) rounding. }
  function IsFpuCwOkForRounding: Boolean;

  { This procedure loads the tDecimalRoundingCtrl descriptions and ordinals
    into the string list for such use as using a TCombobox to make rounding
    type selection. }
  procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings);

var
  gRoundFoatMultiplierArray: array [-ROUND_FLOAT_MAX_DECIMAL_COUNT..ROUND_FLOAT_MAX_DECIMAL_COUNT] of Extended;

implementation

uses
  DRUnit.Types;

{ Compute smallest 1/(2^n) epsilon values for which "1 + epsilon <> 1".
  For "1 - epsilon <> 1", divide these computed values by 2. }
procedure CalcEpsValues(var SglEps, DblEps, ExtEps: Double);
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
  Until s = 1.00;
  SglEps := f;

  { Compute for Double, d: }
  f := 1.00;
  repeat
    f := f / 2.00;
    d := 1.00 + f / 2.00;
  until d = 1.00;
  DblEps := f;

  { Compute with Extended, e: }
  f := 1.00;
  repeat
    f := f / 2.00;
    e := 1.00 + f / 2.00;
  Until e = 1.00;
  ExtEps := f;
end;

type
  TExtPackedRec = packed record
    Man: Int64;
    Exp: Word
  end;

function IsNAN(const ASingleValue: Single): Boolean;
var
  InputX: LongInt absolute ASingleValue;
begin
  Result := (InputX <> 0) and ((InputX and SglExpBits) = SglExpBits);
end;

function IsNAN(const ADoubleValue: Double): Boolean;
var
  InputX: Int64 absolute ADoubleValue;
begin
  Result := (InputX <> 0) and ((InputX and DblExpBits) = DblExpBits);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function IsNAN(const AExtendedValue: extended): boolean;
var
  InputX: TExtPackedRec absolute AExtendedValue;
begin
  Result := (InputX.Man <> 0) and ((InputX.Exp and ExtExpBits)=ExtExpBits);
end;
{$ENDIF}

procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings);
var
  LRoundingControl: TDecimalRoundingControl;
begin
  Assert(AStrings <> nil);

  AStrings.Clear;
  for LRoundingControl := Low(LRoundingControl) to High(LRoundingControl) do
    AStrings.AddObject(string(DecimalRoundingCtrlStrs[LRoundingControl].Abbr), Pointer(LRoundingControl));
end;

{ Returns the FPU control word (which indicates interrupt masks and precision and rounding modes). }
function GetX87CW: Word;
asm
  FStCW [Result]
end;

{ Checks to see that floating point processor (FPU) is correctly set to

    (1) allow conversion from extended to double and double to single
        without creating the the loss of precision interrupt or exception,
    (2) do arithmetic internal to FPU in extended precision, and
    (3) use round halves-to-even (a.k.a. bankers rounding) internally. }
function IsFpuCwOkForRounding: boolean;
var
  CW: word;
begin
  CW := GetX87CW;
  Result := ((CW and (PC or RC or PM)) = (rcBankers or pcExtended or PM));
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
