unit DRTests.Calc.Modes;

{ DecimalRoundEx rounding modes applied to CALCULATED values (runtime
  multiplication / division via the DRTests.CalcHelpers helpers, so the
  arithmetic differs between Win32/x87 and Win64/SSE in the last bits).

  Tie fixtures:
    85 * 0.045 = 3.825  @2 — scaled candidates 382/383, 382 is EVEN
    7  * 0.045 = 0.315  @2 — scaled candidates 31/32,  31 is ODD
    n  / 2      @0      — exact binary ties at integers
  Non-tie fixtures:
    1/3 and 2/3 @2      — repeating decimals for the directed modes.

  One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcModesTie3825 = class
  public
    [Test] procedure Mul_85_x_0_045_HalfUp;       // -> 3.83
    [Test] procedure Mul_85_x_0_045_HalfDown;     // -> 3.82
    [Test] procedure Mul_85_x_0_045_HalfEven;     // -> 3.82 (382 even)
    [Test] procedure Mul_85_x_0_045_HalfPos;      // -> 3.83
    [Test] procedure Mul_85_x_0_045_HalfNeg;      // -> 3.82
    [Test] procedure Mul_85_x_0_045_RndPos;       // -> 3.83 (ceil)
    [Test] procedure Mul_85_x_0_045_RndNeg;       // -> 3.82 (floor)
    [Test] procedure Mul_85_x_0_045_RndDown;      // -> 3.82 (trunc)
    [Test] procedure Mul_85_x_0_045_RndUp;        // -> 3.83 (away)
    [Test] procedure Mul_Neg_85_x_0_045_HalfUp;   // -> -3.83
    [Test] procedure Mul_Neg_85_x_0_045_HalfDown; // -> -3.82
    [Test] procedure Mul_Neg_85_x_0_045_HalfEven; // -> -3.82
    [Test] procedure Mul_Neg_85_x_0_045_HalfPos;  // -> -3.82 (toward positive)
    [Test] procedure Mul_Neg_85_x_0_045_HalfNeg;  // -> -3.83 (toward negative)
    [Test] procedure Mul_Neg_85_x_0_045_RndPos;   // -> -3.82 (ceil)
    [Test] procedure Mul_Neg_85_x_0_045_RndNeg;   // -> -3.83 (floor)
    [Test] procedure Mul_Neg_85_x_0_045_RndDown;  // -> -3.82 (trunc)
    [Test] procedure Mul_Neg_85_x_0_045_RndUp;    // -> -3.83 (away)
  end;

  [TestFixture]
  TCalcModesTie0315 = class
  public
    [Test] procedure Mul_7_x_0_045_HalfEven;      // -> 0.32 (31 odd, even neighbour is 32)
    [Test] procedure Mul_7_x_0_045_HalfUp;        // -> 0.32
    [Test] procedure Mul_7_x_0_045_HalfDown;      // -> 0.31
    [Test] procedure Mul_7_x_0_045_HalfPos;       // -> 0.32
    [Test] procedure Mul_7_x_0_045_HalfNeg;       // -> 0.31
    [Test] procedure Mul_Neg_7_x_0_045_HalfEven;  // -> -0.32
    [Test] procedure Mul_Neg_7_x_0_045_HalfUp;    // -> -0.32
    [Test] procedure Mul_Neg_7_x_0_045_HalfDown;  // -> -0.31
    [Test] procedure Mul_Neg_7_x_0_045_HalfPos;   // -> -0.31
    [Test] procedure Mul_Neg_7_x_0_045_HalfNeg;   // -> -0.32
  end;

  [TestFixture]
  TCalcModesThirds = class
  public
    [Test] procedure Div_1_By_3_HalfUp;           // 0.3333.. -> 0.33
    [Test] procedure Div_1_By_3_HalfDown;         // -> 0.33
    [Test] procedure Div_1_By_3_HalfEven;         // -> 0.33
    [Test] procedure Div_1_By_3_RndPos;           // ceil  -> 0.34
    [Test] procedure Div_1_By_3_RndNeg;           // floor -> 0.33
    [Test] procedure Div_1_By_3_RndDown;          // trunc -> 0.33
    [Test] procedure Div_1_By_3_RndUp;            // away  -> 0.34
    [Test] procedure Div_Neg_1_By_3_HalfUp;       // -> -0.33
    [Test] procedure Div_Neg_1_By_3_RndPos;       // ceil  -> -0.33
    [Test] procedure Div_Neg_1_By_3_RndNeg;       // floor -> -0.34
    [Test] procedure Div_Neg_1_By_3_RndDown;      // trunc -> -0.33
    [Test] procedure Div_Neg_1_By_3_RndUp;        // away  -> -0.34
    [Test] procedure Div_2_By_3_HalfEven;         // 0.6666.. -> 0.67
    [Test] procedure Div_2_By_3_RndPos;           // -> 0.67
    [Test] procedure Div_2_By_3_RndNeg;           // -> 0.66
    [Test] procedure Div_2_By_3_RndDown;          // -> 0.66
    [Test] procedure Div_2_By_3_RndUp;            // -> 0.67
    [Test] procedure Div_Neg_2_By_3_RndPos;       // -> -0.66
    [Test] procedure Div_Neg_2_By_3_RndNeg;       // -> -0.67
    [Test] procedure Div_Neg_2_By_3_RndDown;      // -> -0.66
    [Test] procedure Div_Neg_2_By_3_RndUp;        // -> -0.67
  end;

  [TestFixture]
  TCalcModesHalfInteger = class
  public
    [Test] procedure Div_5_By_2_HalfEven;         // 2.5 -> 2 (even)
    [Test] procedure Div_5_By_2_HalfUp;           // -> 3
    [Test] procedure Div_5_By_2_HalfDown;         // -> 2
    [Test] procedure Div_5_By_2_HalfPos;          // -> 3
    [Test] procedure Div_5_By_2_HalfNeg;          // -> 2
    [Test] procedure Div_Neg_5_By_2_HalfEven;     // -2.5 -> -2 (even)
    [Test] procedure Div_Neg_5_By_2_HalfUp;       // -> -3
    [Test] procedure Div_Neg_5_By_2_HalfDown;     // -> -2
    [Test] procedure Div_Neg_5_By_2_HalfPos;      // -> -2 (toward positive)
    [Test] procedure Div_Neg_5_By_2_HalfNeg;      // -> -3 (toward negative)
    [Test] procedure Div_3_By_2_HalfEven;         // 1.5 -> 2 (1 odd, even neighbour 2)
    [Test] procedure Div_3_By_2_HalfUp;           // -> 2
    [Test] procedure Div_3_By_2_HalfDown;         // -> 1
    [Test] procedure Div_7_By_2_HalfEven;         // 3.5 -> 4 (3 odd, even neighbour 4)
    [Test] procedure Div_7_By_2_HalfDown;         // -> 3
  end;

implementation

uses
  DRUnit.Types, DRTests.CalcHelpers;

{ TCalcModesTie3825 }

procedure TCalcModesTie3825.Mul_85_x_0_045_HalfUp;
begin
  CheckMulRoundEx(85, 0.045, 2, drcHalfUp, 3.83);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_HalfDown;
begin
  CheckMulRoundEx(85, 0.045, 2, drcHalfDown, 3.82);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_HalfEven;
begin
  CheckMulRoundEx(85, 0.045, 2, drcHalfEven, 3.82);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_HalfPos;
begin
  CheckMulRoundEx(85, 0.045, 2, drcHalfPos, 3.83);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_HalfNeg;
begin
  CheckMulRoundEx(85, 0.045, 2, drcHalfNeg, 3.82);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_RndPos;
begin
  CheckMulRoundEx(85, 0.045, 2, drcRndPos, 3.83);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_RndNeg;
begin
  CheckMulRoundEx(85, 0.045, 2, drcRndNeg, 3.82);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_RndDown;
begin
  CheckMulRoundEx(85, 0.045, 2, drcRndDown, 3.82);
end;

procedure TCalcModesTie3825.Mul_85_x_0_045_RndUp;
begin
  CheckMulRoundEx(85, 0.045, 2, drcRndUp, 3.83);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_HalfUp;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcHalfUp, -3.83);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_HalfDown;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcHalfDown, -3.82);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_HalfEven;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcHalfEven, -3.82);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_HalfPos;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcHalfPos, -3.82);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_HalfNeg;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcHalfNeg, -3.83);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_RndPos;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcRndPos, -3.82);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_RndNeg;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcRndNeg, -3.83);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_RndDown;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcRndDown, -3.82);
end;

procedure TCalcModesTie3825.Mul_Neg_85_x_0_045_RndUp;
begin
  CheckMulRoundEx(-85, 0.045, 2, drcRndUp, -3.83);
end;

{ TCalcModesTie0315 }

procedure TCalcModesTie0315.Mul_7_x_0_045_HalfEven;
begin
  CheckMulRoundEx(7, 0.045, 2, drcHalfEven, 0.32);
end;

procedure TCalcModesTie0315.Mul_7_x_0_045_HalfUp;
begin
  CheckMulRoundEx(7, 0.045, 2, drcHalfUp, 0.32);
end;

procedure TCalcModesTie0315.Mul_7_x_0_045_HalfDown;
begin
  CheckMulRoundEx(7, 0.045, 2, drcHalfDown, 0.31);
end;

procedure TCalcModesTie0315.Mul_7_x_0_045_HalfPos;
begin
  CheckMulRoundEx(7, 0.045, 2, drcHalfPos, 0.32);
end;

procedure TCalcModesTie0315.Mul_7_x_0_045_HalfNeg;
begin
  CheckMulRoundEx(7, 0.045, 2, drcHalfNeg, 0.31);
end;

procedure TCalcModesTie0315.Mul_Neg_7_x_0_045_HalfEven;
begin
  CheckMulRoundEx(-7, 0.045, 2, drcHalfEven, -0.32);
end;

procedure TCalcModesTie0315.Mul_Neg_7_x_0_045_HalfUp;
begin
  CheckMulRoundEx(-7, 0.045, 2, drcHalfUp, -0.32);
end;

procedure TCalcModesTie0315.Mul_Neg_7_x_0_045_HalfDown;
begin
  CheckMulRoundEx(-7, 0.045, 2, drcHalfDown, -0.31);
end;

procedure TCalcModesTie0315.Mul_Neg_7_x_0_045_HalfPos;
begin
  CheckMulRoundEx(-7, 0.045, 2, drcHalfPos, -0.31);
end;

procedure TCalcModesTie0315.Mul_Neg_7_x_0_045_HalfNeg;
begin
  CheckMulRoundEx(-7, 0.045, 2, drcHalfNeg, -0.32);
end;

{ TCalcModesThirds }

procedure TCalcModesThirds.Div_1_By_3_HalfUp;
begin
  CheckDivRoundEx(1, 3, 2, drcHalfUp, 0.33);
end;

procedure TCalcModesThirds.Div_1_By_3_HalfDown;
begin
  CheckDivRoundEx(1, 3, 2, drcHalfDown, 0.33);
end;

procedure TCalcModesThirds.Div_1_By_3_HalfEven;
begin
  CheckDivRoundEx(1, 3, 2, drcHalfEven, 0.33);
end;

procedure TCalcModesThirds.Div_1_By_3_RndPos;
begin
  CheckDivRoundEx(1, 3, 2, drcRndPos, 0.34);
end;

procedure TCalcModesThirds.Div_1_By_3_RndNeg;
begin
  CheckDivRoundEx(1, 3, 2, drcRndNeg, 0.33);
end;

procedure TCalcModesThirds.Div_1_By_3_RndDown;
begin
  CheckDivRoundEx(1, 3, 2, drcRndDown, 0.33);
end;

procedure TCalcModesThirds.Div_1_By_3_RndUp;
begin
  CheckDivRoundEx(1, 3, 2, drcRndUp, 0.34);
end;

procedure TCalcModesThirds.Div_Neg_1_By_3_HalfUp;
begin
  CheckDivRoundEx(-1, 3, 2, drcHalfUp, -0.33);
end;

procedure TCalcModesThirds.Div_Neg_1_By_3_RndPos;
begin
  CheckDivRoundEx(-1, 3, 2, drcRndPos, -0.33);
end;

procedure TCalcModesThirds.Div_Neg_1_By_3_RndNeg;
begin
  CheckDivRoundEx(-1, 3, 2, drcRndNeg, -0.34);
end;

procedure TCalcModesThirds.Div_Neg_1_By_3_RndDown;
begin
  CheckDivRoundEx(-1, 3, 2, drcRndDown, -0.33);
end;

procedure TCalcModesThirds.Div_Neg_1_By_3_RndUp;
begin
  CheckDivRoundEx(-1, 3, 2, drcRndUp, -0.34);
end;

procedure TCalcModesThirds.Div_2_By_3_HalfEven;
begin
  CheckDivRoundEx(2, 3, 2, drcHalfEven, 0.67);
end;

procedure TCalcModesThirds.Div_2_By_3_RndPos;
begin
  CheckDivRoundEx(2, 3, 2, drcRndPos, 0.67);
end;

procedure TCalcModesThirds.Div_2_By_3_RndNeg;
begin
  CheckDivRoundEx(2, 3, 2, drcRndNeg, 0.66);
end;

procedure TCalcModesThirds.Div_2_By_3_RndDown;
begin
  CheckDivRoundEx(2, 3, 2, drcRndDown, 0.66);
end;

procedure TCalcModesThirds.Div_2_By_3_RndUp;
begin
  CheckDivRoundEx(2, 3, 2, drcRndUp, 0.67);
end;

procedure TCalcModesThirds.Div_Neg_2_By_3_RndPos;
begin
  CheckDivRoundEx(-2, 3, 2, drcRndPos, -0.66);
end;

procedure TCalcModesThirds.Div_Neg_2_By_3_RndNeg;
begin
  CheckDivRoundEx(-2, 3, 2, drcRndNeg, -0.67);
end;

procedure TCalcModesThirds.Div_Neg_2_By_3_RndDown;
begin
  CheckDivRoundEx(-2, 3, 2, drcRndDown, -0.66);
end;

procedure TCalcModesThirds.Div_Neg_2_By_3_RndUp;
begin
  CheckDivRoundEx(-2, 3, 2, drcRndUp, -0.67);
end;

{ TCalcModesHalfInteger }

procedure TCalcModesHalfInteger.Div_5_By_2_HalfEven;
begin
  CheckDivRoundEx(5, 2, 0, drcHalfEven, 2);
end;

procedure TCalcModesHalfInteger.Div_5_By_2_HalfUp;
begin
  CheckDivRoundEx(5, 2, 0, drcHalfUp, 3);
end;

procedure TCalcModesHalfInteger.Div_5_By_2_HalfDown;
begin
  CheckDivRoundEx(5, 2, 0, drcHalfDown, 2);
end;

procedure TCalcModesHalfInteger.Div_5_By_2_HalfPos;
begin
  CheckDivRoundEx(5, 2, 0, drcHalfPos, 3);
end;

procedure TCalcModesHalfInteger.Div_5_By_2_HalfNeg;
begin
  CheckDivRoundEx(5, 2, 0, drcHalfNeg, 2);
end;

procedure TCalcModesHalfInteger.Div_Neg_5_By_2_HalfEven;
begin
  CheckDivRoundEx(-5, 2, 0, drcHalfEven, -2);
end;

procedure TCalcModesHalfInteger.Div_Neg_5_By_2_HalfUp;
begin
  CheckDivRoundEx(-5, 2, 0, drcHalfUp, -3);
end;

procedure TCalcModesHalfInteger.Div_Neg_5_By_2_HalfDown;
begin
  CheckDivRoundEx(-5, 2, 0, drcHalfDown, -2);
end;

procedure TCalcModesHalfInteger.Div_Neg_5_By_2_HalfPos;
begin
  CheckDivRoundEx(-5, 2, 0, drcHalfPos, -2);
end;

procedure TCalcModesHalfInteger.Div_Neg_5_By_2_HalfNeg;
begin
  CheckDivRoundEx(-5, 2, 0, drcHalfNeg, -3);
end;

procedure TCalcModesHalfInteger.Div_3_By_2_HalfEven;
begin
  CheckDivRoundEx(3, 2, 0, drcHalfEven, 2);
end;

procedure TCalcModesHalfInteger.Div_3_By_2_HalfUp;
begin
  CheckDivRoundEx(3, 2, 0, drcHalfUp, 2);
end;

procedure TCalcModesHalfInteger.Div_3_By_2_HalfDown;
begin
  CheckDivRoundEx(3, 2, 0, drcHalfDown, 1);
end;

procedure TCalcModesHalfInteger.Div_7_By_2_HalfEven;
begin
  CheckDivRoundEx(7, 2, 0, drcHalfEven, 4);
end;

procedure TCalcModesHalfInteger.Div_7_By_2_HalfDown;
begin
  CheckDivRoundEx(7, 2, 0, drcHalfDown, 3);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcModesTie3825);
  TDUnitX.RegisterTestFixture(TCalcModesTie0315);
  TDUnitX.RegisterTestFixture(TCalcModesThirds);
  TDUnitX.RegisterTestFixture(TCalcModesHalfInteger);

end.
