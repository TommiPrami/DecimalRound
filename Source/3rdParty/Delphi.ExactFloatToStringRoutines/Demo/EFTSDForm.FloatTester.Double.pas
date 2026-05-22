unit EFTSDForm.FloatTester.Double;

(* *****************************************************************************

  Win64-only descendant of TFloatTester. Uses 64-bit Double throughout, with
  TDoubleRecord overlay for direct bit-pattern construction.

  On Win32 the unit is effectively empty so the dpr can list it unconditionally.

***************************************************************************** *)

interface

{$IFDEF CPUX64}

uses
  EFTSDForm.FloatTester;

type
  TDoubleFloatTester = class(TFloatTester)
  public
    procedure TestNumber(const AValue: Extended); override;
    procedure RunSmallestDenormal; override;
    procedure RunDenormalBoundary; override;
    procedure RunSpecials; override;
    procedure RunPi; override;
    procedure RunAnalyzeFloat; override;
  end;

{$ENDIF}

implementation

{$IFDEF CPUX64}

uses
  System.SysUtils, Delphi.ExactFloatToString;

const
  // Double's smallest positive normal is ~2.225e-308. Below this threshold we scale
  // by 1e300 so %g has something readable to print alongside the raw bit pattern.
  DENORMAL_THRESHOLD = 1e-300;
  DENORMAL_SCALE     = 1e300;

// On Win64 Extended IS Double, so overlaying TDoubleRecord on AValue gives us the
// 64-bit IEEE-754 bit pattern directly.
procedure TDoubleFloatTester.TestNumber(const AValue: Extended);
var
  LDoubleRec: TDoubleRecord absolute AValue;
  LExponent: Cardinal;
  LMantissa: Int64;
  LScaled: Double;
begin
  // sign (bit 63) | exponent (11 bits, 62..52) | fraction (52 bits)
  LExponent := (LDoubleRec.AsInt64 shr 52) and $7FF;
  LMantissa := LDoubleRec.AsInt64 and $000FFFFFFFFFFFFF;

  if Abs(AValue) < DENORMAL_THRESHOLD then
  begin
    LScaled := AValue * DENORMAL_SCALE;
    LogFmt('Calling: Exp=$%3.3x, Man=$%13.13x, G=%g, G*1e300=%g',
      [LExponent, LMantissa, AValue, LScaled]);
  end
  else
    LogFmt('Calling: Exp=$%3.3x, Man=$%13.13x, G=%g',
      [LExponent, LMantissa, AValue]);

  RunConversionAndTime(AValue);
end;

procedure TDoubleFloatTester.RunSmallestDenormal;
var
  LValue: Double;
  LDoubleRec: TDoubleRecord absolute LValue;
  LIndex: Integer;
begin
  Log('');

  // Smallest positive Double denormal: bits = $0000000000000001. Value = 2^-1074.
  // Dividing by 2 once underflows to +0.
  LDoubleRec.AsInt64 := $0000000000000001;

  for LIndex := 1 to 2 do
  begin
    TestNumber(LValue);
    LValue := LValue / 2;
  end;
end;

procedure TDoubleFloatTester.RunDenormalBoundary;
var
  LValue: Double;
  LDoubleRec: TDoubleRecord absolute LValue;
  LScaled: Double;
  LIndex: Integer;
begin
  Log('');

  // Start at 2 * smallest_normal (exp=2, fraction=0). Value = 2^-1021.
  // Halve four times to cross into denormal range, then double back up.
  LDoubleRec.AsInt64 := $0020000000000000;

  for LIndex := 1 to 9 do
  begin
    LScaled := LValue * DENORMAL_SCALE;
    LogFmt('Test #%d: Bits=$%16.16x, G=%g, G*1e300=%g',
      [LIndex, LDoubleRec.AsInt64, LValue, LScaled]);

    if LIndex in [2, 3, 4] then
      TestNumber(LValue);

    if LIndex < 5 then
      LValue := LValue / 2
    else
      LValue := LValue * 2;
  end;
end;

procedure TDoubleFloatTester.RunSpecials;
var
  LValue: Double;
  LDoubleRec: TDoubleRecord absolute LValue;
begin
  // +Inf / -Inf
  Log('');
  LDoubleRec.AsInt64 := Int64($7FF0000000000000);
  Log('+Inf response = ' + ExactFloatToStr(LValue));
  LDoubleRec.AsInt64 := Int64($FFF0000000000000);
  Log('-Inf response = ' + ExactFloatToStr(LValue));

  // Indefinite (Intel canonical: sign=1, exponent=$7FF, fraction = bit 51 set + zero payload)
  Log('');
  LDoubleRec.AsInt64 := Int64($FFF8000000000000);
  LogFmt('Bits=$%16.16x', [LDoubleRec.AsInt64]);
  Log('Indefinite response = ' + ExactFloatToStr(LValue));

  // QNaN (bit 51 set + payload)
  Log('');
  LDoubleRec.AsInt64 := Int64($7FF8000000000001);
  Log('QNAN(1) response = ' + ExactFloatToStr(LValue));

  // SNaN (bit 51 clear + payload). Note: the x87 FPU on Win32 would clobber this to
  // QNaN during Double->Extended promotion, but on Win64 SSE preserves the bits.
  LDoubleRec.AsInt64 := Int64($7FF0000000000001);
  Log('SNAN(1) response = ' + ExactFloatToStr(LValue));
end;

procedure TDoubleFloatTester.RunPi;
var
  LDouble: Double;
begin
  Log('');
  LDouble := Pi;
  TestNumber(LDouble);
end;

procedure TDoubleFloatTester.RunAnalyzeFloat;
var
  LDouble: Double;
  LSingle: Single;
  LScaled: Double;
  LIndex: Integer;
  LDoubleRec: TDoubleRecord absolute LDouble;
  LSingleAsLongInt: LongInt absolute LSingle;
begin
  Assert(SizeOf(LDoubleRec) = SizeOf(LDouble));
  Assert(SizeOf(LSingleAsLongInt) = SizeOf(LSingle));

  for LIndex := 0 to 20 do
  begin
    case LIndex of
      0:
        begin
          Log(''); Log('Check simple numbers.');
          LDouble := 15.0;
        end;
      3:
        begin
          Log(''); Log('Check crossover into Single denormal.');
          LSingleAsLongInt := LongInt(2) shl 23;
          LDouble := LSingle;
        end;
      7:
        begin
          Log(''); Log('Check crossover into Double denormal.');
          LDoubleRec.AsInt64 := Int64(2) shl 52;
        end;
      11:
        begin
          Log(''); Log('Check small Double denormal.');
          LDoubleRec.AsInt64 := $0000000000000002;
        end;
    else
      LDouble := LDouble / 2;
      Log('Divide by 2 and check', 1);
    end;

    LSingle := LDouble;
    LScaled := LDouble * DENORMAL_SCALE;

    Log(Format('%2.2d: Nbr=%g (Nbr*1e300=%g)', [LIndex, LDouble, LScaled]), 1);
    Log(ParseFloat(LDouble) + ' ' + ParseFloat(LSingle), 1);
  end;
end;

{$ENDIF}

end.
