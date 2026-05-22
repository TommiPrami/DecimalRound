unit DRTests.DecimalRound;

{ Coverage for DecimalRound (the simple HalfUp public API in DRUnit.Round).

  Includes the classic cases that trip Delphi's RTL Round() — e.g. 2.245
  rounded to 2 decimals must be 2.25, and 1.015 * 100 must be 101.5.
  These are exactly the cases that motivated this library.

  Add new tricky inputs to TDecimalRoundTrickyCases below; the user has
  more numbers/calculations from production to drop in later. }

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
  end;

  [TestFixture]
  TDecimalRoundTrickyCases = class
  { Placeholder for the private set of awkward production numbers the user
    plans to drop in. Add one Test per case. }
  public
    [Test] procedure Placeholder_AddRealCasesHere;
  end;

implementation

uses
  System.Math, System.SysUtils, DRUnit.Round;

{ ----------------------------------------------------- Basic correctness }

procedure TDecimalRoundTests.Zero_RoundsToZero;
begin
  Assert.AreEqual<Extended>(0.0, DecimalRound(Double(0.0), 2));
  Assert.AreEqual<Extended>(0.0, DecimalRound(Single(0.0), 2));
end;

procedure TDecimalRoundTests.PositiveValue_RoundedToTwoDecimals;
begin
  Assert.AreEqual<Extended>(1.23, DecimalRound(Double(1.234), 2));
  Assert.AreEqual<Extended>(1.24, DecimalRound(Double(1.235), 2));
end;

procedure TDecimalRoundTests.NegativeValue_RoundedToTwoDecimals;
begin
  Assert.AreEqual<Extended>(-1.23, DecimalRound(Double(-1.234), 2));
  Assert.AreEqual<Extended>(-1.24, DecimalRound(Double(-1.235), 2));
end;

procedure TDecimalRoundTests.DefaultDecimalCount_IsTwo;
begin
  Assert.AreEqual<Extended>(2.25, DecimalRound(Double(2.245)));
end;

procedure TDecimalRoundTests.ZeroDecimals_RoundsToInteger;
begin
  Assert.AreEqual<Extended>(2.0, DecimalRound(Double(1.5), 0));
  Assert.AreEqual<Extended>(2.0, DecimalRound(Double(2.4), 0));
  Assert.AreEqual<Extended>(3.0, DecimalRound(Double(2.6), 0));
end;

procedure TDecimalRoundTests.NegativeDecimals_RoundsToTens;
begin
  { ANumberOfDecimals = -1 means round to nearest 10. }
  Assert.AreEqual<Extended>(120.0, DecimalRound(Double(123.4), -1));
  Assert.AreEqual<Extended>(130.0, DecimalRound(Double(125.0), -1));
  Assert.AreEqual<Extended>(100.0, DecimalRound(Double(123.4), -2));
end;

{ ----------------------------------------------- Hard-to-round classics }

procedure TDecimalRoundTests.Tricky_2_245_Rounds_To_2_25;
begin
  { Plain RTL Round(2.245 * 100) / 100 famously yields 2.24. }
  Assert.AreEqual<Extended>(2.25, DecimalRound(Double(2.245), 2),
    'DecimalRound(2.245) must produce 2.25');
end;

procedure TDecimalRoundTests.Tricky_1_015_Times_100_Rounds_To_101_5;
begin
  Assert.AreEqual<Extended>(101.5, DecimalRound(Double(1.015 * 100.0), 1));
end;

procedure TDecimalRoundTests.Tricky_3_015_Times_100_Rounds_To_301_5;
begin
  Assert.AreEqual<Extended>(301.5, DecimalRound(Double(3.015 * 100.0), 1));
end;

procedure TDecimalRoundTests.Tricky_Negative_2_245_Rounds_To_Minus_2_25;
begin
  Assert.AreEqual<Extended>(-2.25, DecimalRound(Double(-2.245), 2));
end;

{ -------------------------------------------- Awaiting real production data }

procedure TDecimalRoundTrickyCases.Placeholder_AddRealCasesHere;
begin
  { Drop the private trip-up cases here, one [Test] method per scenario.
    Prefer one assertion per test so failures point at the exact value. }
  Assert.Pass('Add your private real-world rounding cases here.');
end;

initialization
  TDUnitX.RegisterTestFixture(TDecimalRoundTests);
  TDUnitX.RegisterTestFixture(TDecimalRoundTrickyCases);

end.
