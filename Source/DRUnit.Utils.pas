unit DRUnit.Utils;

interface

{$INCLUDE DecimalRound.inc}

uses
  DRUnit.Consts;

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

{$IF DEFINED(CPUX86)}
  { Returns the x87 FPU control word (which indicates interrupt masks and
    precision and rounding modes). x86/Win32 only: on Win64 floating point
    runs on SSE and is governed by the MXCSR register, which the x87 control
    word does not reflect — use FpuSettingsToString there instead. }
  function GetX87CW: Word;

  { Interprets x87 control word and returns as a string. }
  function X87CWToString(const AControlWord: Word): string;
{$ENDIF}

  { Cross-platform, human-readable summary of the floating point control
    state that matters for these rounding routines: rounding mode, precision
    mode (x86 only) and the masked-exception set. }
  function FpuSettingsToString: string;

  { Returns true if the floating point unit is configured the way the
    rounding routines assume:
      (1) round-to-nearest-even (a.k.a. bankers) rounding mode,
      (2) the loss-of-precision exception masked (so conversions from
          Extended to Double and Double to Single cannot trap), and
      (3) on x86 only: internal arithmetic done in Extended precision.
    On Win32 this reflects the x87 control word; on Win64 the SSE MXCSR
    register (both read via System.Math.GetRoundMode / GetExceptionMask). }
  function IsFpuCwOkForRounding: Boolean;

var
  { Lookup of 10^N. Indexed by decimal-count; negative indices mirror the
    positive ones (callers divide by the lookup for negative N). }
  gPowerOfTenMultipliers: array [-ROUND_FLOAT_MAX_DECIMAL_COUNT..ROUND_FLOAT_MAX_DECIMAL_COUNT] of Extended;

implementation

uses
  System.Math, System.SysUtils, DRUnit.Types;

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

{$IF DEFINED(CPUX86)}

{ Returns the x87 FPU control word (which indicates interrupt masks and precision and rounding modes). }
function GetX87CW: Word;
asm
  FStCW [Result]
end;

{ PickX87PrecisionCtrl picks FPU precision control out of CW.}
function PickX87PrecisionCtrl(const AControlWord: Word): TX87PrecisionControl;
begin
  Result := TX87PrecisionControl((AControlWord and PC) shr 8);
end;

{ PickX87RoundingCtrl picks FPU rounding control out of CW.}
function PickX87RoundingCtrl(const AControlWord: Word): TX87RoundingControl;
begin
  Result := TX87RoundingControl((AControlWord and RC) shr 10);
end;

{ PickX87InterruptMask picks FPU interrupt mask bits out of CW (the low byte). }
function PickX87InterruptMask(const AControlWord: Word): TX87InterruptBits;
begin
  Result := TX87InterruptBits(Byte(AControlWord));
end;

{ Interprets x87 control word and returns as a string. }
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

{$ENDIF}

{ GetPrecisionMode / TFPUPrecisionMode are x87-specific by nature; their use
  here is intentionally limited to CPUX86 blocks. }
{$WARN SYMBOL_PLATFORM OFF}

function FpuSettingsToString: string;
const
  ROUNDING_MODE_STRINGS: array [TRoundingMode] of string =
    ('nearest (bankers)', 'down (floor)', 'up (ceil)', 'truncate (chop)');
{$IF DEFINED(CPUX86)}
  PRECISION_MODE_STRINGS: array [TFPUPrecisionMode] of string =
    ('single', 'reserved', 'double', 'extended');
{$ENDIF}
  MASKED_EXCEPTION_STRINGS: array [TArithmeticException] of string =
    ('IM', 'DM', 'ZM', 'OM', 'UM', 'PM');
var
  LExceptionMask: TArithmeticExceptionMask;
  LException: TArithmeticException;
  LMaskedExceptions: string;
begin
  LExceptionMask := GetExceptionMask;
  LMaskedExceptions := '';

  for LException := Low(TArithmeticException) to High(TArithmeticException) do
    if LException in LExceptionMask then
    begin
      if LMaskedExceptions <> '' then
        LMaskedExceptions := LMaskedExceptions + ',';

      LMaskedExceptions := LMaskedExceptions + MASKED_EXCEPTION_STRINGS[LException];
    end;

  Result := 'FPU Rounding=' + ROUNDING_MODE_STRINGS[GetRoundMode]
{$IF DEFINED(CPUX86)}
    + '; Precision=' + PRECISION_MODE_STRINGS[GetPrecisionMode]
{$ENDIF}
    + '; MaskedExceptions=[' + LMaskedExceptions + ']';

{$IF DEFINED(CPUX86)}
  Result := Result + ' ($' + IntToHex(GetX87CW, 4) + ')';
{$ENDIF}
end;

{ Checks that the floating point unit is set up the way the rounding
  routines assume — see the interface comment. Reads the x87 control word
  on Win32 and the SSE MXCSR register on Win64, via System.Math. }
function IsFpuCwOkForRounding: Boolean;
begin
  Result := (GetRoundMode = rmNearest) and (exPrecision in GetExceptionMask);

{$IF DEFINED(CPUX86)}
  Result := Result and (GetPrecisionMode = pmExtended);
{$ENDIF}
end;

{$WARN SYMBOL_PLATFORM ON}

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
