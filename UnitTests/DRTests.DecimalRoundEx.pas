unit DRTests.DecimalRoundEx;

{ Coverage for DecimalRoundEx — one fixture per rounding mode plus an
  early-exit fixture for drcNone / NaN handling. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDecimalRoundExModeTests = class
  public
    // HalfUp (default): round to nearest, ties away from zero
    [Test] procedure HalfUp_Positive_Tie_GoesAwayFromZero;
    [Test] procedure HalfUp_Negative_Tie_GoesAwayFromZero;

    // HalfDown: round to nearest, ties toward zero
    [Test] procedure HalfDown_Positive_Tie_GoesTowardZero;
    [Test] procedure HalfDown_Negative_Tie_GoesTowardZero;

    // HalfEven (bankers)
    [Test] procedure HalfEven_TieAtEven_StaysEven;
    [Test] procedure HalfEven_TieAtOdd_GoesToEven;

    // HalfPos / HalfNeg
    [Test] procedure HalfPos_Positive_Tie_GoesUp;
    [Test] procedure HalfPos_Negative_Tie_GoesUp;
    [Test] procedure HalfNeg_Positive_Tie_GoesDown;
    [Test] procedure HalfNeg_Negative_Tie_GoesDown;

    // Directed roundings
    [Test] procedure RndPos_Ceil;
    [Test] procedure RndNeg_Floor;
    [Test] procedure RndDown_Trunc;
    [Test] procedure RndUp_AwayFromZero;
  end;

  [TestFixture]
  TDecimalRoundExEarlyExitTests = class
  public
{$IFDEF DEBUG}
    [Test] procedure NoneMode_ReturnsValueUnchanged;
{$ENDIF}
  end;

implementation

uses
  System.Math, DRUnit.Types, DRUnit.RoundEx;

{ ------------------------------------------------------------------- HalfUp }

procedure TDecimalRoundExModeTests.HalfUp_Positive_Tie_GoesAwayFromZero;
begin
  Assert.AreEqual<Extended>(2.25, DecimalRoundEx(Double(2.245), 2, drcHalfUp));
  Assert.AreEqual<Extended>(0.6, DecimalRoundEx(Double(0.55), 1, drcHalfUp));
end;

procedure TDecimalRoundExModeTests.HalfUp_Negative_Tie_GoesAwayFromZero;
begin
  Assert.AreEqual<Extended>(-2.25, DecimalRoundEx(Double(-2.245), 2, drcHalfUp));
end;

{ ----------------------------------------------------------------- HalfDown }

procedure TDecimalRoundExModeTests.HalfDown_Positive_Tie_GoesTowardZero;
begin
  Assert.AreEqual<Extended>(0.5, DecimalRoundEx(Double(0.55), 1, drcHalfDown));
end;

procedure TDecimalRoundExModeTests.HalfDown_Negative_Tie_GoesTowardZero;
begin
  Assert.AreEqual<Extended>(-0.5, DecimalRoundEx(Double(-0.55), 1, drcHalfDown));
end;

{ ----------------------------------------------------------------- HalfEven }

procedure TDecimalRoundExModeTests.HalfEven_TieAtEven_StaysEven;
begin
  { 2.5 -> 2 (nearest even); 0.5 -> 0 (nearest even) }
  Assert.AreEqual<Extended>(2.0, DecimalRoundEx(Double(2.5), 0, drcHalfEven));
  Assert.AreEqual<Extended>(0.0, DecimalRoundEx(Double(0.5), 0, drcHalfEven));
end;

procedure TDecimalRoundExModeTests.HalfEven_TieAtOdd_GoesToEven;
begin
  { 1.5 -> 2; 3.5 -> 4 }
  Assert.AreEqual<Extended>(2.0, DecimalRoundEx(Double(1.5), 0, drcHalfEven));
  Assert.AreEqual<Extended>(4.0, DecimalRoundEx(Double(3.5), 0, drcHalfEven));
end;

{ -------------------------------------------------------- HalfPos / HalfNeg }

procedure TDecimalRoundExModeTests.HalfPos_Positive_Tie_GoesUp;
begin
  Assert.AreEqual<Extended>(0.6, DecimalRoundEx(Double(0.55), 1, drcHalfPos));
end;

procedure TDecimalRoundExModeTests.HalfPos_Negative_Tie_GoesUp;
begin
  Assert.AreEqual<Extended>(-0.5, DecimalRoundEx(Double(-0.55), 1, drcHalfPos));
end;

procedure TDecimalRoundExModeTests.HalfNeg_Positive_Tie_GoesDown;
begin
  Assert.AreEqual<Extended>(0.5, DecimalRoundEx(Double(0.55), 1, drcHalfNeg));
end;

procedure TDecimalRoundExModeTests.HalfNeg_Negative_Tie_GoesDown;
begin
  Assert.AreEqual<Extended>(-0.6, DecimalRoundEx(Double(-0.55), 1, drcHalfNeg));
end;

{ ----------------------------------------------------------- Directed modes }

procedure TDecimalRoundExModeTests.RndPos_Ceil;
begin
  Assert.AreEqual<Extended>(1.3, DecimalRoundEx(Double(1.21), 1, drcRndPos));
  Assert.AreEqual<Extended>(-1.2, DecimalRoundEx(Double(-1.21), 1, drcRndPos));
end;

procedure TDecimalRoundExModeTests.RndNeg_Floor;
begin
  Assert.AreEqual<Extended>(1.2, DecimalRoundEx(Double(1.29), 1, drcRndNeg));
  Assert.AreEqual<Extended>(-1.3, DecimalRoundEx(Double(-1.29), 1, drcRndNeg));
end;

procedure TDecimalRoundExModeTests.RndDown_Trunc;
begin
  Assert.AreEqual<Extended>(1.2, DecimalRoundEx(Double(1.29), 1, drcRndDown));
  Assert.AreEqual<Extended>(-1.2, DecimalRoundEx(Double(-1.29), 1, drcRndDown));
end;

procedure TDecimalRoundExModeTests.RndUp_AwayFromZero;
begin
  Assert.AreEqual<Extended>(1.3, DecimalRoundEx(Double(1.21), 1, drcRndUp));
  Assert.AreEqual<Extended>(-1.3, DecimalRoundEx(Double(-1.21), 1, drcRndUp));
end;

{ ----------------------------------------------- Early-exit / drcNone path }

{$IFDEF DEBUG}
procedure TDecimalRoundExEarlyExitTests.NoneMode_ReturnsValueUnchanged;
{ The drcNone branch is only present when DO_CHECKS is enabled (Debug). }
begin
  Assert.AreEqual<Extended>(1.234567, DecimalRoundEx(Double(1.234567), 2, drcNone));
end;
{$ENDIF}

initialization
  TDUnitX.RegisterTestFixture(TDecimalRoundExModeTests);
  TDUnitX.RegisterTestFixture(TDecimalRoundExEarlyExitTests);

end.
