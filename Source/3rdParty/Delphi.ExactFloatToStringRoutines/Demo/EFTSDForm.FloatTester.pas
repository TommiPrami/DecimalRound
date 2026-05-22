unit EFTSDForm.FloatTester;

(* *****************************************************************************

  Platform-neutral base class for the demo's float-testing scenarios.

  The form owns a TFloatTester (concrete subclass picked by platform — Extended on
  Win32, Double on Win64) and dispatches button clicks to its virtual methods.
  This way the form has zero platform conditionals: all the bit-pattern construction
  and width-dependent format strings live in the descendants.

  See:
    EFTSDForm.FloatTester.Extended  ({$IFDEF WIN32} 80-bit logic)
    EFTSDForm.FloatTester.Double    ({$IFDEF CPUX64} 64-bit logic)

***************************************************************************** *)

interface

uses
  System.SysUtils;

type
  TLogProc = procedure(const AMsg: string; const AIndent: Integer = 0) of object;
  TLogFmtProc = procedure(const AFormat: string; const AData: array of const; const AIndent: Integer = 0) of object;

  TFloatTester = class abstract
  private
    FLog: TLogProc;
    FLogFmt: TLogFmtProc;
    FUseExVersion: Boolean;
    FShowDebug: Boolean;
  protected
    procedure Log(const AMsg: string; const AIndent: Integer = 0);
    procedure LogFmt(const AFormat: string; const AData: array of const; const AIndent: Integer = 0);
    function ClockCycleCount: Int64;

    { Calls ExactFloatToStr[Ex] on AValue, times it via RDTSC, logs the result.
      Descendants call this from TestNumber after dumping the type-specific bit pattern.
      AValue is Extended-typed, which on Win64 IS Double, so the same call works on both. }
    procedure RunConversionAndTime(const AValue: Extended);
  public
    constructor Create(const ALog: TLogProc; const ALogFmt: TLogFmtProc);

    { Mirrors the form's CheckBoxes. Form sets these before invoking a scenario. }
    property UseExVersion: Boolean read FUseExVersion write FUseExVersion;
    property ShowDebug: Boolean read FShowDebug write FShowDebug;

    { Type-specific: must log the bit pattern of AValue and then RunConversionAndTime. }
    procedure TestNumber(const AValue: Extended); virtual; abstract;

    { Type-specific scenarios — each descendant constructs values in the native float
      width and runs the same conceptual test (smallest denormal, denormal/normal
      boundary sweep, IEEE specials, Pi, cross-format analysis). }
    procedure RunSmallestDenormal; virtual; abstract;
    procedure RunDenormalBoundary; virtual; abstract;
    procedure RunSpecials; virtual; abstract;
    procedure RunPi; virtual; abstract;
    procedure RunAnalyzeFloat; virtual; abstract;

    { Always-Double scenario (works the same on both platforms). }
    procedure RunSmallestDouble; virtual;

    { Parses AStr (stripping garbage chars), converts, calls TestNumber. }
    procedure ConvertStringInput(const AStr: string); virtual;
  end;

implementation

uses
  Delphi.ExactFloatToString;

constructor TFloatTester.Create(const ALog: TLogProc; const ALogFmt: TLogFmtProc);
begin
  inherited Create;

  FLog := ALog;
  FLogFmt := ALogFmt;
end;

procedure TFloatTester.Log(const AMsg: string; const AIndent: Integer = 0);
begin
  FLog(AMsg, AIndent);
end;

procedure TFloatTester.LogFmt(const AFormat: string; const AData: array of const; const AIndent: Integer = 0);
begin
  FLogFmt(AFormat, AData, AIndent);
end;

function TFloatTester.ClockCycleCount: Int64;
{$IFDEF CPUX64}
asm
  // x64: RDTSC writes EDX:EAX (zero-extended into RDX:RAX). Combine into RAX (the
  // Win64 return register for Int64).
  rdtsc
  shl rdx, 32
  or  rax, rdx
end;
{$ELSE}
asm
  // x86 (Win32): RDTSC writes EDX:EAX which IS the Int64 return convention.
  dw $310F  // opcode bytes for RDTSC
end;
{$ENDIF}

procedure TFloatTester.RunConversionAndTime(const AValue: Extended);
var
  LCycles: Int64;
  LResult: string;
begin
  if FShowDebug then
    Delphi.ExactFloatToString.LogFmtX := LogFmt
  else
    Delphi.ExactFloatToString.LogFmtX := nil;

  try
    LCycles := ClockCycleCount;

    if FUseExVersion then
      LResult := ExactFloatToStrEx(AValue)
    else
      LResult := ExactFloatToStr(AValue);

    LCycles := ClockCycleCount - LCycles;

    LogFmt('Required %s clock cycles', [ExactFloatToStr(LCycles)], 1);
    Log(LResult);
  except
    on E: Exception do
      LogFmt('Exception: %s', [E.Message]);
  end;
end;

procedure TFloatTester.RunSmallestDouble;
var
  LValue1: Double;
  LValue2: Double;
begin
  Log('');

  // Repeatedly halve a Double until it underflows to zero. Report the last non-zero
  // value (the smallest representable positive Double = 2^-1074).
  LValue1 := 1.0;

  repeat
    LValue2 := LValue1;
    LValue1 := LValue1 / 2;
  until LValue1 = 0;

  TestNumber(LValue2);
end;

procedure TFloatTester.ConvertStringInput(const AStr: string);
var
  LCleaned: string;
  LSource: Integer;
  LDest: Integer;
  LValue: Extended;
begin
  // Strip everything that isn't a sign, digit, decimal point, or exponent marker.
  LCleaned := AStr;
  LDest := 0;

  for LSource := 1 to Length(LCleaned) do
    if CharInSet(LCleaned[LSource], ['-', '0'..'9', '.', 'e', 'E']) then
    begin
      Inc(LDest);
      LCleaned[LDest] := LCleaned[LSource];
    end;

  SetLength(LCleaned, LDest);

  LValue := StrToFloat(LCleaned);
  TestNumber(LValue);
end;

end.
