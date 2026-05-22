unit DRTests.DecimalRound;

{$INCLUDE ..\Source\DecimalRound.inc}

{ Coverage for DecimalRound (the simple HalfUp public API in DRUnit.Round).

  Includes the classic cases that trip Delphi's RTL Round() — e.g. 2.245
  rounded to 2 decimals must be 2.25, and 1.015 * 100 must be 101.5.
  These are exactly the cases that motivated this library.

  Tricky real-world cases are tested through BOTH the Double and the
  Extended overload. The Extended variants are only compiled on platforms
  where Extended is a true 80-bit type (i.e. SUPPORTS_TRUE_EXTENDED,
  currently CPUX86 only — on x64 Extended is an alias for Double, so
  running them again would just duplicate the Double tests). }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDecimalRoundTests = class
  public
    [Test] procedure Zero_RoundsToZero;
    [Test] procedure PositiveValue_RoundedToTwoDecimals;
    [Test] procedure NegativeValue_RoundedToTwoDecimals;
    [Test] procedure DefaultDecimalCount_IsTwo;
    [Test] procedure ZeroDecimals_RoundsToInteger;
    [Test] procedure NegativeDecimals_RoundsToTens;

    // Hard-to-round inputs that RTL Round gets wrong.
    [Test] procedure Tricky_2_245_Rounds_To_2_25;
    [Test] procedure Tricky_1_015_Times_100_Rounds_To_101_5;
    [Test] procedure Tricky_3_015_Times_100_Rounds_To_301_5;
    [Test] procedure Tricky_Negative_2_245_Rounds_To_Minus_2_25;
    //
    [Test] procedure LargeValues_ManualTests;
  end;

  [TestFixture]
  TDecimalRoundTrickyCases = class
  { Real-world inputs that have tripped our previous rounding routine
    and/or Delphi's RTL rounding (Round / SimpleRoundTo). All assertions
    use a zero tolerance — these must be exact. }
  public
    // ----- Double overload -----
    [Test] procedure Multiplications_By_0_045_Double;
    [Test] procedure Multiplications_By_Large_X_045_Double;
    [Test] procedure HalfUp_Boundary_Values_Double;
    [Test] procedure Decimal_Count_Zero_And_Negative_Double;
    [Test] procedure Many_Decimal_Counts_Double;
    [Test] procedure Specific_1470724508_0318_Double;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
    // ----- Extended overload (32-bit only) -----
    [Test] procedure Multiplications_By_0_045_Extended;
    [Test] procedure Multiplications_By_Large_X_045_Extended;
    [Test] procedure HalfUp_Boundary_Values_Extended;
    [Test] procedure Decimal_Count_Zero_And_Negative_Extended;
    [Test] procedure Many_Decimal_Counts_Extended;
    [Test] procedure Specific_1470724508_0318_Extended;
{$ENDIF}
  end;

implementation

uses
  System.Math, System.SysUtils, DRUnit.Consts, DRUnit.Round;

{ ----------------------------------------------------- Basic correctness }

procedure TDecimalRoundTests.Zero_RoundsToZero;
begin
  Assert.AreEqual(0.0, DecimalRound(Double(0.0), 2), EPSILON_DOUBLE);
  Assert.AreEqual(0.0, DecimalRound(Single(0.0), 2), EPSILON_SINGLE);
end;

procedure TDecimalRoundTests.PositiveValue_RoundedToTwoDecimals;
begin
  Assert.AreEqual(1.23, DecimalRound(Double(1.234), 2), EPSILON_DOUBLE);
  Assert.AreEqual(1.24, DecimalRound(Double(1.235), 2), EPSILON_DOUBLE);
end;

procedure TDecimalRoundTests.NegativeValue_RoundedToTwoDecimals;
begin
  Assert.AreEqual(-1.23, DecimalRound(Double(-1.234), 2), EPSILON_DOUBLE);
  Assert.AreEqual(-1.24, DecimalRound(Double(-1.235), 2), EPSILON_DOUBLE);
end;

procedure TDecimalRoundTests.DefaultDecimalCount_IsTwo;
begin
  Assert.AreEqual(2.25, DecimalRound(Double(2.245)), EPSILON_DOUBLE);
end;

procedure TDecimalRoundTests.ZeroDecimals_RoundsToInteger;
begin
  Assert.AreEqual(2.0, DecimalRound(Double(1.5), 0), EPSILON_DOUBLE);
  Assert.AreEqual(2.0, DecimalRound(Double(2.4), 0), EPSILON_DOUBLE);
  Assert.AreEqual(3.0, DecimalRound(Double(2.6), 0), EPSILON_DOUBLE);
end;

procedure TDecimalRoundTests.LargeValues_ManualTests;
begin
  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(High(Int64) * 1.1);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(Low(Int64) * 1.1);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(High(Int64) * 2.2);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(Low(Int64) * 2.2);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(High(Int64) * Pi);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(Low(Int64) * Pi);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(NaN);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(Infinity);
    end,
    EInvalidOp);

  Assert.WillNotRaise(
    procedure
    begin
      DecimalRound(NegInfinity);
    end,
    EInvalidOp);
end;

procedure TDecimalRoundTests.NegativeDecimals_RoundsToTens;
begin
  { ANumberOfDecimals = -1 means round to nearest 10. }
  Assert.AreEqual(120.0, DecimalRound(Double(123.4), -1), EPSILON_DOUBLE);
  Assert.AreEqual(130.0, DecimalRound(Double(125.0), -1), EPSILON_DOUBLE);
  Assert.AreEqual(100.0, DecimalRound(Double(123.4), -2), EPSILON_DOUBLE);
end;

{ ----------------------------------------------- Hard-to-round classics }

procedure TDecimalRoundTests.Tricky_2_245_Rounds_To_2_25;
begin
  { Plain RTL Round(2.245 * 100) / 100 famously yields 2.24. }
  Assert.AreEqual(2.25, DecimalRound(Double(2.245), 2), EPSILON_DOUBLE, 'DecimalRound(2.245) must produce 2.25');
end;

procedure TDecimalRoundTests.Tricky_1_015_Times_100_Rounds_To_101_5;
begin
  Assert.AreEqual(101.5, DecimalRound(Double(1.015 * 100.0), 1), EPSILON_DOUBLE);
end;

procedure TDecimalRoundTests.Tricky_3_015_Times_100_Rounds_To_301_5;
begin
  Assert.AreEqual(301.5, DecimalRound(Double(3.015 * 100.0), 1), EPSILON_DOUBLE);
end;

procedure TDecimalRoundTests.Tricky_Negative_2_245_Rounds_To_Minus_2_25;
begin
  Assert.AreEqual(-2.25, DecimalRound(Double(-2.245), 2), EPSILON_DOUBLE);
end;

{ --------------------------------------------- Tricky real-world cases }

{ Private helpers — keep each test body short and force the input to be
  computed in the correct precision via a typed local.

  AssertRound_D : evaluates the source expression in Double precision and
                  calls the Double overload of DecimalRound.

  AssertRound_E : evaluates the source expression in Extended precision and
                  calls the Extended overload. Only compiled on x86. }

procedure AssertRound_D(const AExpected, AActual: Double; const AMsg: string = '');
begin
  Assert.AreEqual(AExpected, AActual, EPSILON_DOUBLE, AMsg);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure AssertRound_E(const AExpected, AActual: Extended; const AMsg: string = '');
begin
  Assert.AreEqual(AExpected, AActual, EPSILON_EXTENDED, AMsg);
end;
{$ENDIF}

{ ------- Multiplications_By_0_045 ------- }

procedure TDecimalRoundTrickyCases.Multiplications_By_0_045_Double;
var
  V: Double;
begin
  { These (integer * 0.045) multiplications used to break our previous basic rounding routine. }

  V := 85 * 0.045;
  AssertRound_D(3.83,  DecimalRound(V), '85 * 0.045');

  V := 85 * -0.045;
  AssertRound_D(-3.83, DecimalRound(V), '85 * -0.045');

  V := 1047 * 0.045000;
  AssertRound_D(47.12, DecimalRound(V), '1047 * 0.045000');
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundTrickyCases.Multiplications_By_0_045_Extended;
var
  V: Extended;
begin
  V := 85 * 0.045;
  AssertRound_E(3.83,  DecimalRound(V), '85 * 0.045');

  V := 85 * -0.045;
  AssertRound_E(-3.83, DecimalRound(V), '85 * -0.045');

  V := 1047 * 0.045000;
  AssertRound_E(47.12, DecimalRound(V), '1047 * 0.045000');
end;
{$ENDIF}

{ ------- Multiplications_By_Large_X_045 ------- }

procedure TDecimalRoundTrickyCases.Multiplications_By_Large_X_045_Double;
{ Ascending magnitudes of (integer * Y.045). Delphi's SimpleRoundTo started
  returning the wrong value (.82 instead of .83) at 85 * 1_000_000_000.045
  and 85 * -1_000_000_000.045, but oddly worked again at one order of
  magnitude higher — so this is not strictly a "size" issue. }
var
  V: Double;
begin
  V := 85 * 1000.045;
  AssertRound_D(85003.83,         DecimalRound(V), '85 * 1000.045');

  V := 85 * -1000.045;
  AssertRound_D(-85003.83,        DecimalRound(V), '85 * -1000.045');

  V := 85 * 10000.045;
  AssertRound_D(850003.83,        DecimalRound(V), '85 * 10000.045');

  V := 85 * -10000.045;
  AssertRound_D(-850003.83,       DecimalRound(V), '85 * -10000.045');

  V := 85 * 100000.045;
  AssertRound_D(8500003.83,       DecimalRound(V), '85 * 100000.045');

  V := 85 * -100000.045;
  AssertRound_D(-8500003.83,      DecimalRound(V), '85 * -100000.045');

  V := 85 * 1000000.045;
  AssertRound_D(85000003.83,      DecimalRound(V), '85 * 1000000.045');

  V := 85 * -1000000.045;
  AssertRound_D(-85000003.83,     DecimalRound(V), '85 * -1000000.045');

  V := 85 * 10000000.045;
  AssertRound_D(850000003.83,     DecimalRound(V), '85 * 10000000.045');

  V := 85 * -10000000.045;
  AssertRound_D(-850000003.83,    DecimalRound(V), '85 * -10000000.045');

  V := 85 * 100000000.045;
  AssertRound_D(8500000003.83,    DecimalRound(V), '85 * 100000000.045');

  V := 85 * -100000000.045;
  AssertRound_D(-8500000003.83,   DecimalRound(V), '85 * -100000000.045');

  // Delphi's SimpleRoundTo returns .82 on these two:
  V := 85 * 1000000000.045;
  AssertRound_D(85000000003.83,   DecimalRound(V), '85 * 1_000_000_000.045 (RTL SimpleRoundTo fails here)');

  V := 85 * -1000000000.045;
  AssertRound_D(-85000000003.83,  DecimalRound(V), '85 * -1_000_000_000.045 (RTL SimpleRoundTo fails here)');

  // ...but SimpleRoundTo works again here, so it is not strictly a size issue:
  V := 85 * 10000000000.045;
  AssertRound_D(850000000003.83,  DecimalRound(V), '85 * 10_000_000_000.045');

  V := 85 * -10000000000.045;
  AssertRound_D(-850000000003.83, DecimalRound(V), '85 * -10_000_000_000.045');
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundTrickyCases.Multiplications_By_Large_X_045_Extended;
var
  V: Extended;
begin
  V := 85 * 1000.045;
  AssertRound_E(85003.83,         DecimalRound(V), '85 * 1000.045');

  V := 85 * -1000.045;
  AssertRound_E(-85003.83,        DecimalRound(V), '85 * -1000.045');

  V := 85 * 10000.045;
  AssertRound_E(850003.83,        DecimalRound(V), '85 * 10000.045');

  V := 85 * -10000.045;
  AssertRound_E(-850003.83,       DecimalRound(V), '85 * -10000.045');

  V := 85 * 100000.045;
  AssertRound_E(8500003.83,       DecimalRound(V), '85 * 100000.045');

  V := 85 * -100000.045;
  AssertRound_E(-8500003.83,      DecimalRound(V), '85 * -100000.045');

  V := 85 * 1000000.045;
  AssertRound_E(85000003.83,      DecimalRound(V), '85 * 1000000.045');

  V := 85 * -1000000.045;
  AssertRound_E(-85000003.83,     DecimalRound(V), '85 * -1000000.045');

  V := 85 * 10000000.045;
  AssertRound_E(850000003.83,     DecimalRound(V), '85 * 10000000.045');

  V := 85 * -10000000.045;
  AssertRound_E(-850000003.83,    DecimalRound(V), '85 * -10000000.045');

  V := 85 * 100000000.045;
  AssertRound_E(8500000003.83,    DecimalRound(V), '85 * 100000000.045');

  V := 85 * -100000000.045;
  AssertRound_E(-8500000003.83,   DecimalRound(V), '85 * -100000000.045');

  V := 85 * 1000000000.045;
  AssertRound_E(85000000003.83,   DecimalRound(V), '85 * 1_000_000_000.045 (RTL SimpleRoundTo fails here)');

  V := 85 * -1000000000.045;
  AssertRound_E(-85000000003.83,  DecimalRound(V), '85 * -1_000_000_000.045 (RTL SimpleRoundTo fails here)');

  V := 85 * 10000000000.045;
  AssertRound_E(850000000003.83,  DecimalRound(V), '85 * 10_000_000_000.045');

  V := 85 * -10000000000.045;
  AssertRound_E(-850000000003.83, DecimalRound(V), '85 * -10_000_000_000.045');
end;
{$ENDIF}

{ ------- HalfUp_Boundary_Values ------- }

procedure TDecimalRoundTrickyCases.HalfUp_Boundary_Values_Double;
{ DecimalRound is half-up. If it ever silently switches to bankers rounding,
  the 0.045 -> 0.05 and 1.66665 -> 1.6667 assertions will fail. }
var
  V: Double;
begin
  V := 0.045;
  AssertRound_D(0.05,   DecimalRound(V),    '0.045 (bankers would give 0.04)');

  V := 0.055;
  AssertRound_D(0.06,   DecimalRound(V),    '0.055');

  V := 1.66665;
  AssertRound_D(1.6667, DecimalRound(V, 4), '1.66665 to 4 dp (bankers would give 1.6666)');

  V := 1.55555;
  AssertRound_D(1.5556, DecimalRound(V, 4), '1.55555 to 4 dp');
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundTrickyCases.HalfUp_Boundary_Values_Extended;
var
  V: Extended;
begin
  V := 0.045;
  AssertRound_E(0.05,   DecimalRound(V),    '0.045 (bankers would give 0.04)');

  V := 0.055;
  AssertRound_E(0.06,   DecimalRound(V),    '0.055');

  V := 1.66665;
  AssertRound_E(1.6667, DecimalRound(V, 4), '1.66665 to 4 dp (bankers would give 1.6666)');

  V := 1.55555;
  AssertRound_E(1.5556, DecimalRound(V, 4), '1.55555 to 4 dp');
end;
{$ENDIF}

{ ------- Decimal_Count_Zero_And_Negative ------- }

procedure TDecimalRoundTrickyCases.Decimal_Count_Zero_And_Negative_Double;
var
  V: Double;
begin
  V := 1234.56;

  AssertRound_D(1235, DecimalRound(V,  0), '1234.56 to 0 dp');
  AssertRound_D(1230, DecimalRound(V, -1), '1234.56 to -1 dp (nearest 10)');
  AssertRound_D(1200, DecimalRound(V, -2), '1234.56 to -2 dp (nearest 100)');
  AssertRound_D(1000, DecimalRound(V, -3), '1234.56 to -3 dp (nearest 1000)');
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundTrickyCases.Decimal_Count_Zero_And_Negative_Extended;
var
  V: Extended;
begin
  V := 1234.56;

  AssertRound_E(1235, DecimalRound(V,  0), '1234.56 to 0 dp');
  AssertRound_E(1230, DecimalRound(V, -1), '1234.56 to -1 dp (nearest 10)');
  AssertRound_E(1200, DecimalRound(V, -2), '1234.56 to -2 dp (nearest 100)');
  AssertRound_E(1000, DecimalRound(V, -3), '1234.56 to -3 dp (nearest 1000)');
end;
{$ENDIF}

{ ------- Many_Decimal_Counts ------- }

procedure TDecimalRoundTrickyCases.Many_Decimal_Counts_Double;
var
  V: Double;
begin
  V := 1.12345678901234567890;

  AssertRound_D(1.123,       DecimalRound(V, 3), '3 dp');
  AssertRound_D(1.1235,      DecimalRound(V, 4), '4 dp');
  AssertRound_D(1.12346,     DecimalRound(V, 5), '5 dp');
  AssertRound_D(1.123457,    DecimalRound(V, 6), '6 dp');
  AssertRound_D(1.1234568,   DecimalRound(V, 7), '7 dp');
  AssertRound_D(1.12345679,  DecimalRound(V, 8), '8 dp');
  AssertRound_D(1.123456789, DecimalRound(V, 9), '9 dp');

  V := 1.11111;
  AssertRound_D(1.00,  DecimalRound(V, 0), '1.11111 to 0 dp');

  V := 1.99;
  AssertRound_D(2.00,  DecimalRound(V, 0), '1.99 to 0 dp');

  V := -1.99;
  AssertRound_D(-2.00, DecimalRound(V, 0), '-1.99 to 0 dp');
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundTrickyCases.Many_Decimal_Counts_Extended;
var
  V: Extended;
begin
  V := 1.12345678901234567890;

  AssertRound_E(1.123,       DecimalRound(V, 3), '3 dp');
  AssertRound_E(1.1235,      DecimalRound(V, 4), '4 dp');
  AssertRound_E(1.12346,     DecimalRound(V, 5), '5 dp');
  AssertRound_E(1.123457,    DecimalRound(V, 6), '6 dp');
  AssertRound_E(1.1234568,   DecimalRound(V, 7), '7 dp');
  AssertRound_E(1.12345679,  DecimalRound(V, 8), '8 dp');
  AssertRound_E(1.123456789, DecimalRound(V, 9), '9 dp');

  V := 1.11111;
  AssertRound_E(1.00,  DecimalRound(V, 0), '1.11111 to 0 dp');

  V := 1.99;
  AssertRound_E(2.00,  DecimalRound(V, 0), '1.99 to 0 dp');

  V := -1.99;
  AssertRound_E(-2.00, DecimalRound(V, 0), '-1.99 to 0 dp');
end;
{$ENDIF}

{ ------- Specific_1470724508_0318 ------- }

procedure TDecimalRoundTrickyCases.Specific_1470724508_0318_Double;
var
  V: Double;
begin
  V := 1470724508.0318;

  AssertRound_D(1470724508.03, DecimalRound(V), '1470724508.0318 to 2 dp');
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundTrickyCases.Specific_1470724508_0318_Extended;
var
  V: Extended;
begin
  V := 1470724508.0318;

  AssertRound_E(1470724508.03, DecimalRound(V), '1470724508.0318 to 2 dp');
end;
{$ENDIF}

initialization
  TDUnitX.RegisterTestFixture(TDecimalRoundTests);
  TDUnitX.RegisterTestFixture(TDecimalRoundTrickyCases);

end.
