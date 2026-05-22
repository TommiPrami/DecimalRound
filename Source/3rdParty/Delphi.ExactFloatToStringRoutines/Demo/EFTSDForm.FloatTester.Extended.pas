unit EFTSDForm.FloatTester.Extended;

(* *****************************************************************************

  Win32-only descendant of TFloatTester. Uses 80-bit Extended throughout, with
  TExtendedFloat overlay for direct bit-pattern construction (denormals, NaNs,
  infinities). Extended-range literals (1e4900) appear here too.

  On Win64 the unit is effectively empty (the IFDEF wraps everything), so it's
  safe to list in the dpr unconditionally.

***************************************************************************** *)

interface

{$IFDEF WIN32}

uses
  EFTSDForm.FloatTester;

type
  TExtendedFloatTester = class(TFloatTester)
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

{$IFDEF WIN32}

uses
  System.SysUtils, Delphi.ExactFloatToString;

procedure TExtendedFloatTester.TestNumber(const AValue: Extended);
var
  LExtendedRec: TExtendedFloat absolute AValue;
  LScaled: Extended;
begin
  if Abs(AValue) < 1E-4000 then
  begin
    // For very small denormals %g prints "0" — multiply by 1e4000 to give the eye
    // something usable alongside the raw bit pattern.
    LScaled := AValue * 1E4000;
    LogFmt('Calling: Exp=$%4.4x, Man=$%16.16x, G=%g, Ge4K=%g',
      [LExtendedRec.Exponent, LExtendedRec.Mantissa, AValue, LScaled]);
  end
  else
    LogFmt('Calling: Exp=$%4.4x, Man=$%16.16x, G=%g',
      [LExtendedRec.Exponent, LExtendedRec.Mantissa, AValue]);

  RunConversionAndTime(AValue);
end;

procedure TExtendedFloatTester.RunSmallestDenormal;
var
  LValue: Extended;
  LExtendedRec: TExtendedFloat absolute LValue;
  LIndex: Integer;
begin
  Log('');

  // Smallest positive Extended denormal: exp=0, mantissa=1. Value = 2^-16445.
  LExtendedRec.Exponent := 0;
  LExtendedRec.Mantissa := $0000000000000001;

  for LIndex := 1 to 2 do
  begin
    TestNumber(LValue);
    LValue := LValue / 2;
  end;
end;

procedure TExtendedFloatTester.RunDenormalBoundary;
var
  LValue: Extended;
  LExtendedRec: TExtendedFloat absolute LValue;
  LScaled: Extended;
  LIndex: Integer;
begin
  Log('');

  // Start at 2 * smallest_normal (exp=2, integer-bit-only mantissa = $8000...000).
  // Halve four times to cross into denormal range, then double back up.
  LExtendedRec.Exponent := 2;
  LExtendedRec.Mantissa := $8000000000000000;

  for LIndex := 1 to 9 do
  begin
    LScaled := LValue * 1e4900;
    LogFmt('Test #%d: Exp=$%4.4x, Man=$%16.16x, G=%g, G2=%g',
      [LIndex, LExtendedRec.Exponent, LExtendedRec.Mantissa, LValue, LScaled]);

    if LIndex in [2, 3, 4] then
      TestNumber(LValue);

    if LIndex < 5 then
      LValue := LValue / 2
    else
      LValue := LValue * 2;
  end;
end;

procedure TExtendedFloatTester.RunSpecials;
const
  NanX = 0 / 0;
  DblManX: Int64 = $000FFFFFFFFFFFFF; // Double's 52-bit fraction mask
var
  LExtended: Extended;
  LDouble: Double;
  LExtendedRec: TExtendedFloat absolute LExtended;
  LDoubleAsInt64: Int64 absolute LDouble;
begin
  // +Inf / -Inf
  Log('');
  LExtendedRec.Exponent := $7FFF;
  LExtendedRec.Mantissa := $0000000000000000;
  Log('+Inf response = ' + ExactFloatToStr(LExtended));
  LExtendedRec.Exponent := $FFFF;
  LExtendedRec.Mantissa := $0000000000000000;
  Log('-Inf response = ' + ExactFloatToStr(LExtended));

  // Indefinite (round-trip through Double to verify Double conversion stays consistent)
  Log('');
  LExtended := NanX;
  LogFmt('Exp=$%4.4x, Man=$%16.16x', [LExtendedRec.Exponent, LExtendedRec.Mantissa]);
  Log('Indefinite response = ' + ExactFloatToStr(LExtended));

  LDouble := LExtended;
  LExtended := LDouble;
  LogFmt('Dbl: Exp=$%3.3x, Man=$%13.13x',
    [(LDoubleAsInt64 shr (13 * 4)), (LDoubleAsInt64 and DblManX)]);
  LogFmt('Ext: Exp=$%4.4x, Man=$%16.16x',
    [LExtendedRec.Exponent, LExtendedRec.Mantissa]);
  Log('Indefinite dbl rsp. = ' + ExactFloatToStr(LExtended));

  // QNaN / SNaN
  Log('');
  LExtendedRec.Exponent := $7FFF;
  LExtendedRec.Mantissa := Int64($C100000000000000);
  Log('QNAN(1) response = ' + ExactFloatToStr(LExtended));

  LExtendedRec.Exponent := $7FFF;
  LExtendedRec.Mantissa := Int64($8100000000000000);
  Log('SNAN(1) response = ' + ExactFloatToStr(LExtended));
end;

procedure TExtendedFloatTester.RunPi;
var
  LExtended: Extended;
  LDouble: Double;
begin
  Log('');
  LExtended := Pi;
  TestNumber(LExtended);

  LDouble := Pi;
  TestNumber(LDouble);
end;

procedure TExtendedFloatTester.RunAnalyzeFloat;
var
  LExtended1: Extended;
  LExtended2: Extended;
  LDouble: Double;
  LSingle: Single;
  LIndex: Integer;
  LExtendedRec: TExtendedFloat absolute LExtended1;
  LDoubleAsInt64: Int64 absolute LDouble;
  LSingleAsLongInt: LongInt absolute LSingle;
  LIgnored: string;
begin
  Assert(SizeOf(LExtendedRec) = SizeOf(LExtended1));
  Assert(SizeOf(LDoubleAsInt64) = SizeOf(LDouble));
  Assert(SizeOf(LSingleAsLongInt) = SizeOf(LSingle));

  for LIndex := 0 to 20 do
  begin
    case LIndex of
      0:
        begin
          Log(''); Log('Check simple numbers.');
          LExtended1 := 15.00;
        end;
      3:
        begin
          Log(''); Log('Check crossover into Single denormal.');
          LSingleAsLongInt := LongInt(2) shl 23;
          LExtended1 := LSingle;
        end;
      7:
        begin
          Log(''); Log('Check crossover into Double denormal.');
          LDoubleAsInt64 := Int64(2) shl 52;
          LIgnored := ParseFloat(LDouble);
          LExtended1 := LDouble;
        end;
      11:
        begin
          Log(''); Log('Check crossover into Extended denormal.');
          LExtendedRec.Exponent := 2;
          LExtendedRec.Mantissa := $8000000000000000;
        end;
      15:
        begin
          Log(''); Log('Check crossover into zero.');
          LExtendedRec.Exponent := 0;
          LExtendedRec.Mantissa := $0000000000000002;
        end;
    else
      LExtended1 := LExtended1 / 2;
      Log('Divide by 2 and check', 1);
    end;

    LDouble := LExtended1;
    LSingle := LExtended1;
    LExtended2 := LExtended1 * 1e4900;

    Log(Format('%2.2d: Nbr=%g ((Nbr x 1e4900)=%g)', [LIndex, LExtended1, LExtended2]), 1);
    Log(ParseFloat(LExtended1) + ' ' + ParseFloat(LDouble) + ' ' + ParseFloat(LSingle), 1);
  end;
end;

{$ENDIF}

end.
