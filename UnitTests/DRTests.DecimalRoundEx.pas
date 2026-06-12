unit DRTests.DecimalRoundEx;

{$INCLUDE ..\Source\DecimalRound.inc}

{ Coverage for DecimalRoundEx — one fixture per rounding mode plus a
  special-values fixture for drcNone / NaN / Infinity / huge magnitudes. }

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
  TDecimalRoundExSpecialValueTests = class
  { drcNone / NaN / Infinity / overflow-magnitude handling. These behaviors
    must hold in BOTH Debug and Release builds — an earlier version only
    honored drcNone and the NaN check when compiled with DEBUG, so in
    Release drcNone silently bankers-rounded the value instead. }
  public
    [Test] procedure NoneMode_ReturnsValueUnchanged;
    [Test] procedure NoneMode_NegativeDecimals_ReturnsValueUnchanged;
    [Test] procedure NaN_ReturnsNaN_InEveryMode;
    [Test] procedure Infinity_ReturnedUnchanged_InEveryMode;
    [Test] procedure HugeValue_ReturnedUnchanged_InEveryMode;
{$IFDEF SUPPORTS_TRUE_EXTENDED}
    [Test] procedure ExtendedOverload_ModesWork;
{$ENDIF}
  end;

implementation

uses
  System.Math, DRUnit.Consts, DRUnit.Types, DRUnit.RoundEx;

{  HalfUp }

procedure TDecimalRoundExModeTests.HalfUp_Positive_Tie_GoesAwayFromZero;
begin
  Assert.AreEqual<Extended>(2.25, DecimalRoundEx(Double(2.245), 2, drcHalfUp));
  Assert.AreEqual<Extended>(0.6, DecimalRoundEx(Double(0.55), 1, drcHalfUp));
end;

procedure TDecimalRoundExModeTests.HalfUp_Negative_Tie_GoesAwayFromZero;
begin
  Assert.AreEqual<Extended>(-2.25, DecimalRoundEx(Double(-2.245), 2, drcHalfUp));
end;

{ HalfDown }

procedure TDecimalRoundExModeTests.HalfDown_Positive_Tie_GoesTowardZero;
begin
  Assert.AreEqual<Extended>(0.5, DecimalRoundEx(Double(0.55), 1, drcHalfDown));
end;

procedure TDecimalRoundExModeTests.HalfDown_Negative_Tie_GoesTowardZero;
begin
  Assert.AreEqual<Extended>(-0.5, DecimalRoundEx(Double(-0.55), 1, drcHalfDown));
end;

{ HalfEven }

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

{ HalfPos / HalfNeg }

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

{ Directed modes }

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

{ Special values: drcNone / NaN / Infinity / huge magnitudes }

procedure TDecimalRoundExSpecialValueTests.NoneMode_ReturnsValueUnchanged;
var
  V: Double;
begin
  V := 1.234567;
  Assert.AreEqual<Extended>(V, DecimalRoundEx(V, 2, drcNone), 'drcNone must not round');

  V := -987.6543;
  Assert.AreEqual<Extended>(V, DecimalRoundEx(V, 0, drcNone), 'drcNone must not round negatives');
end;

procedure TDecimalRoundExSpecialValueTests.NoneMode_NegativeDecimals_ReturnsValueUnchanged;
var
  V: Double;
begin
  V := 1234.5;
  Assert.AreEqual<Extended>(V, DecimalRoundEx(V, -2, drcNone), 'drcNone must not round with negative decimal count');
end;

procedure TDecimalRoundExSpecialValueTests.NaN_ReturnsNaN_InEveryMode;
var
  V: Double;
  LMode: TDecimalRoundingControl;
begin
  V := NaN;

  for LMode := Low(TDecimalRoundingControl) to High(TDecimalRoundingControl) do
    Assert.IsTrue(System.Math.IsNan(DecimalRoundEx(V, 2, LMode)),
      'NaN in must give NaN out for mode ' + ROUNDING_CONTROL_STRINGS[LMode].Abbreviation);
end;

procedure TDecimalRoundExSpecialValueTests.Infinity_ReturnedUnchanged_InEveryMode;
var
  V: Double;
  LMode: TDecimalRoundingControl;
begin
  for LMode := Low(TDecimalRoundingControl) to High(TDecimalRoundingControl) do
  begin
    V := Infinity;
    Assert.AreEqual<Extended>(V, DecimalRoundEx(V, 2, LMode),
      '+Infinity, mode ' + ROUNDING_CONTROL_STRINGS[LMode].Abbreviation);

    V := NegInfinity;
    Assert.AreEqual<Extended>(V, DecimalRoundEx(V, 2, LMode),
      '-Infinity, mode ' + ROUNDING_CONTROL_STRINGS[LMode].Abbreviation);
  end;
end;

procedure TDecimalRoundExSpecialValueTests.HugeValue_ReturnedUnchanged_InEveryMode;
var
  V: Double;
  LMode: TDecimalRoundingControl;
begin
  { 1E19 * 10^2 = 1E21 overflows the internal Int64 conversion; every mode
    must fall back to returning the input unchanged, with the sign intact. }
  for LMode := Low(TDecimalRoundingControl) to High(TDecimalRoundingControl) do
  begin
    V := 1E19;
    Assert.AreEqual<Extended>(V, DecimalRoundEx(V, 2, LMode),
      '1E19, mode ' + ROUNDING_CONTROL_STRINGS[LMode].Abbreviation);

    V := -1E19;
    Assert.AreEqual<Extended>(V, DecimalRoundEx(V, 2, LMode),
      '-1E19, mode ' + ROUNDING_CONTROL_STRINGS[LMode].Abbreviation);
  end;
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
procedure TDecimalRoundExSpecialValueTests.ExtendedOverload_ModesWork;
var
  V: Extended;
begin
  V := 2.245;
  Assert.AreEqual<Extended>(2.25, DecimalRoundEx(V, 2, drcHalfUp), 'Extended 2.245 HalfUp');
  Assert.AreEqual<Extended>(2.24, DecimalRoundEx(V, 2, drcHalfDown), 'Extended 2.245 HalfDown');
  Assert.AreEqual<Extended>(2.24, DecimalRoundEx(V, 2, drcHalfEven), 'Extended 2.245 HalfEven (224 is even)');

  V := -2.245;
  Assert.AreEqual<Extended>(-2.25, DecimalRoundEx(V, 2, drcHalfUp), 'Extended -2.245 HalfUp');

  V := 1.21;
  Assert.AreEqual<Extended>(1.3, DecimalRoundEx(V, 1, drcRndPos), 'Extended 1.21 ceil');
  Assert.AreEqual<Extended>(1.2, DecimalRoundEx(V, 1, drcRndDown), 'Extended 1.21 trunc');
end;
{$ENDIF}

initialization
  TDUnitX.RegisterTestFixture(TDecimalRoundExModeTests);
  TDUnitX.RegisterTestFixture(TDecimalRoundExSpecialValueTests);

end.
