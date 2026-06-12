unit DRTests.Calc.Times100;

{ GENERATED test data (one-shot script; safe to edit by hand).

  The "scale by 100" patterns: X.XX5 * 100 near-integer products and
  (K + 0.5) / 100 tie quotients. One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcTimes100NearInteger = class
  { X.XX5 * 100 lands just under or just over the integer-and-a-half
    boundary (e.g. 1.005 * 100 = 100.49999999999999 in Double);
    rounding to 0 decimals must still treat it as the exact tie and
    go away from zero on both Win32 and Win64. }
  public
    [Test] procedure Mul_1_005_x_100;    // 1.005 * 100 -> tie -> 101
    [Test] procedure Mul_Neg_1_005_x_100;    // -> -101
    [Test] procedure Mul_2_675_x_100;    // 2.675 * 100 -> tie -> 268
    [Test] procedure Mul_Neg_2_675_x_100;    // -> -268
    [Test] procedure Mul_4_355_x_100;    // 4.355 * 100 -> tie -> 436
    [Test] procedure Mul_Neg_4_355_x_100;    // -> -436
    [Test] procedure Mul_8_165_x_100;    // 8.165 * 100 -> tie -> 817
    [Test] procedure Mul_Neg_8_165_x_100;    // -> -817
    [Test] procedure Mul_1_015_x_100;    // 1.015 * 100 -> tie -> 102
    [Test] procedure Mul_Neg_1_015_x_100;    // -> -102
    [Test] procedure Mul_3_015_x_100;    // 3.015 * 100 -> tie -> 302
    [Test] procedure Mul_Neg_3_015_x_100;    // -> -302
    [Test] procedure Mul_2_245_x_100;    // 2.245 * 100 -> tie -> 225
    [Test] procedure Mul_Neg_2_245_x_100;    // -> -225
    [Test] procedure Mul_1_115_x_100;    // 1.115 * 100 -> tie -> 112
    [Test] procedure Mul_Neg_1_115_x_100;    // -> -112
    [Test] procedure Mul_0_045_x_100;    // 0.045 * 100 -> tie -> 5
    [Test] procedure Mul_Neg_0_045_x_100;    // -> -5
    [Test] procedure Mul_0_055_x_100;    // 0.055 * 100 -> tie -> 6
    [Test] procedure Mul_Neg_0_055_x_100;    // -> -6
    [Test] procedure Mul_9_995_x_100;    // 9.995 * 100 -> tie -> 1000
    [Test] procedure Mul_Neg_9_995_x_100;    // -> -1000
    [Test] procedure Mul_5_555_x_100;    // 5.555 * 100 -> tie -> 556
    [Test] procedure Mul_Neg_5_555_x_100;    // -> -556
    [Test] procedure Mul_7_125_x_100;    // 7.125 * 100 -> tie -> 713
    [Test] procedure Mul_Neg_7_125_x_100;    // -> -713
    [Test] procedure Mul_3_875_x_100;    // 3.875 * 100 -> tie -> 388
    [Test] procedure Mul_Neg_3_875_x_100;    // -> -388
    [Test] procedure Mul_6_665_x_100;    // 6.665 * 100 -> tie -> 667
    [Test] procedure Mul_Neg_6_665_x_100;    // -> -667
  end;

  [TestFixture]
  TCalcDiv100Ties = class
  { (K + 0.5) / 100 for integer K: the dividend is exactly representable
    in binary, the quotient sits on the half-up tie at 2 decimals. }
  public
    [Test] procedure Div_0_5_By_100;    // 0.5 / 100 -> tie -> 0.01
    [Test] procedure Div_Neg_0_5_By_100;    // -> -0.01
    [Test] procedure Div_1_5_By_100;    // 1.5 / 100 -> tie -> 0.02
    [Test] procedure Div_Neg_1_5_By_100;    // -> -0.02
    [Test] procedure Div_2_5_By_100;    // 2.5 / 100 -> tie -> 0.03
    [Test] procedure Div_Neg_2_5_By_100;    // -> -0.03
    [Test] procedure Div_3_5_By_100;    // 3.5 / 100 -> tie -> 0.04
    [Test] procedure Div_Neg_3_5_By_100;    // -> -0.04
    [Test] procedure Div_4_5_By_100;    // 4.5 / 100 -> tie -> 0.05
    [Test] procedure Div_Neg_4_5_By_100;    // -> -0.05
    [Test] procedure Div_5_5_By_100;    // 5.5 / 100 -> tie -> 0.06
    [Test] procedure Div_Neg_5_5_By_100;    // -> -0.06
    [Test] procedure Div_6_5_By_100;    // 6.5 / 100 -> tie -> 0.07
    [Test] procedure Div_Neg_6_5_By_100;    // -> -0.07
    [Test] procedure Div_7_5_By_100;    // 7.5 / 100 -> tie -> 0.08
    [Test] procedure Div_Neg_7_5_By_100;    // -> -0.08
    [Test] procedure Div_8_5_By_100;    // 8.5 / 100 -> tie -> 0.09
    [Test] procedure Div_Neg_8_5_By_100;    // -> -0.09
    [Test] procedure Div_9_5_By_100;    // 9.5 / 100 -> tie -> 0.1
    [Test] procedure Div_Neg_9_5_By_100;    // -> -0.1
    [Test] procedure Div_10_5_By_100;    // 10.5 / 100 -> tie -> 0.11
    [Test] procedure Div_11_5_By_100;    // 11.5 / 100 -> tie -> 0.12
    [Test] procedure Div_12_5_By_100;    // 12.5 / 100 -> tie -> 0.13
    [Test] procedure Div_13_5_By_100;    // 13.5 / 100 -> tie -> 0.14
    [Test] procedure Div_14_5_By_100;    // 14.5 / 100 -> tie -> 0.15
    [Test] procedure Div_15_5_By_100;    // 15.5 / 100 -> tie -> 0.16
    [Test] procedure Div_16_5_By_100;    // 16.5 / 100 -> tie -> 0.17
    [Test] procedure Div_17_5_By_100;    // 17.5 / 100 -> tie -> 0.18
    [Test] procedure Div_18_5_By_100;    // 18.5 / 100 -> tie -> 0.19
    [Test] procedure Div_19_5_By_100;    // 19.5 / 100 -> tie -> 0.2
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcTimes100NearInteger }

procedure TCalcTimes100NearInteger.Mul_1_005_x_100;
begin
  CheckMulRound(1.005, 100, 0, 101);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_1_005_x_100;
begin
  CheckMulRound(-1.005, 100, 0, -101);
end;

procedure TCalcTimes100NearInteger.Mul_2_675_x_100;
begin
  CheckMulRound(2.675, 100, 0, 268);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_2_675_x_100;
begin
  CheckMulRound(-2.675, 100, 0, -268);
end;

procedure TCalcTimes100NearInteger.Mul_4_355_x_100;
begin
  CheckMulRound(4.355, 100, 0, 436);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_4_355_x_100;
begin
  CheckMulRound(-4.355, 100, 0, -436);
end;

procedure TCalcTimes100NearInteger.Mul_8_165_x_100;
begin
  CheckMulRound(8.165, 100, 0, 817);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_8_165_x_100;
begin
  CheckMulRound(-8.165, 100, 0, -817);
end;

procedure TCalcTimes100NearInteger.Mul_1_015_x_100;
begin
  CheckMulRound(1.015, 100, 0, 102);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_1_015_x_100;
begin
  CheckMulRound(-1.015, 100, 0, -102);
end;

procedure TCalcTimes100NearInteger.Mul_3_015_x_100;
begin
  CheckMulRound(3.015, 100, 0, 302);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_3_015_x_100;
begin
  CheckMulRound(-3.015, 100, 0, -302);
end;

procedure TCalcTimes100NearInteger.Mul_2_245_x_100;
begin
  CheckMulRound(2.245, 100, 0, 225);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_2_245_x_100;
begin
  CheckMulRound(-2.245, 100, 0, -225);
end;

procedure TCalcTimes100NearInteger.Mul_1_115_x_100;
begin
  CheckMulRound(1.115, 100, 0, 112);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_1_115_x_100;
begin
  CheckMulRound(-1.115, 100, 0, -112);
end;

procedure TCalcTimes100NearInteger.Mul_0_045_x_100;
begin
  CheckMulRound(0.045, 100, 0, 5);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_0_045_x_100;
begin
  CheckMulRound(-0.045, 100, 0, -5);
end;

procedure TCalcTimes100NearInteger.Mul_0_055_x_100;
begin
  CheckMulRound(0.055, 100, 0, 6);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_0_055_x_100;
begin
  CheckMulRound(-0.055, 100, 0, -6);
end;

procedure TCalcTimes100NearInteger.Mul_9_995_x_100;
begin
  CheckMulRound(9.995, 100, 0, 1000);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_9_995_x_100;
begin
  CheckMulRound(-9.995, 100, 0, -1000);
end;

procedure TCalcTimes100NearInteger.Mul_5_555_x_100;
begin
  CheckMulRound(5.555, 100, 0, 556);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_5_555_x_100;
begin
  CheckMulRound(-5.555, 100, 0, -556);
end;

procedure TCalcTimes100NearInteger.Mul_7_125_x_100;
begin
  CheckMulRound(7.125, 100, 0, 713);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_7_125_x_100;
begin
  CheckMulRound(-7.125, 100, 0, -713);
end;

procedure TCalcTimes100NearInteger.Mul_3_875_x_100;
begin
  CheckMulRound(3.875, 100, 0, 388);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_3_875_x_100;
begin
  CheckMulRound(-3.875, 100, 0, -388);
end;

procedure TCalcTimes100NearInteger.Mul_6_665_x_100;
begin
  CheckMulRound(6.665, 100, 0, 667);
end;

procedure TCalcTimes100NearInteger.Mul_Neg_6_665_x_100;
begin
  CheckMulRound(-6.665, 100, 0, -667);
end;

{ TCalcDiv100Ties }

procedure TCalcDiv100Ties.Div_0_5_By_100;
begin
  CheckDivRound(0.5, 100, 2, 0.01);
end;

procedure TCalcDiv100Ties.Div_Neg_0_5_By_100;
begin
  CheckDivRound(-0.5, 100, 2, -0.01);
end;

procedure TCalcDiv100Ties.Div_1_5_By_100;
begin
  CheckDivRound(1.5, 100, 2, 0.02);
end;

procedure TCalcDiv100Ties.Div_Neg_1_5_By_100;
begin
  CheckDivRound(-1.5, 100, 2, -0.02);
end;

procedure TCalcDiv100Ties.Div_2_5_By_100;
begin
  CheckDivRound(2.5, 100, 2, 0.03);
end;

procedure TCalcDiv100Ties.Div_Neg_2_5_By_100;
begin
  CheckDivRound(-2.5, 100, 2, -0.03);
end;

procedure TCalcDiv100Ties.Div_3_5_By_100;
begin
  CheckDivRound(3.5, 100, 2, 0.04);
end;

procedure TCalcDiv100Ties.Div_Neg_3_5_By_100;
begin
  CheckDivRound(-3.5, 100, 2, -0.04);
end;

procedure TCalcDiv100Ties.Div_4_5_By_100;
begin
  CheckDivRound(4.5, 100, 2, 0.05);
end;

procedure TCalcDiv100Ties.Div_Neg_4_5_By_100;
begin
  CheckDivRound(-4.5, 100, 2, -0.05);
end;

procedure TCalcDiv100Ties.Div_5_5_By_100;
begin
  CheckDivRound(5.5, 100, 2, 0.06);
end;

procedure TCalcDiv100Ties.Div_Neg_5_5_By_100;
begin
  CheckDivRound(-5.5, 100, 2, -0.06);
end;

procedure TCalcDiv100Ties.Div_6_5_By_100;
begin
  CheckDivRound(6.5, 100, 2, 0.07);
end;

procedure TCalcDiv100Ties.Div_Neg_6_5_By_100;
begin
  CheckDivRound(-6.5, 100, 2, -0.07);
end;

procedure TCalcDiv100Ties.Div_7_5_By_100;
begin
  CheckDivRound(7.5, 100, 2, 0.08);
end;

procedure TCalcDiv100Ties.Div_Neg_7_5_By_100;
begin
  CheckDivRound(-7.5, 100, 2, -0.08);
end;

procedure TCalcDiv100Ties.Div_8_5_By_100;
begin
  CheckDivRound(8.5, 100, 2, 0.09);
end;

procedure TCalcDiv100Ties.Div_Neg_8_5_By_100;
begin
  CheckDivRound(-8.5, 100, 2, -0.09);
end;

procedure TCalcDiv100Ties.Div_9_5_By_100;
begin
  CheckDivRound(9.5, 100, 2, 0.1);
end;

procedure TCalcDiv100Ties.Div_Neg_9_5_By_100;
begin
  CheckDivRound(-9.5, 100, 2, -0.1);
end;

procedure TCalcDiv100Ties.Div_10_5_By_100;
begin
  CheckDivRound(10.5, 100, 2, 0.11);
end;

procedure TCalcDiv100Ties.Div_11_5_By_100;
begin
  CheckDivRound(11.5, 100, 2, 0.12);
end;

procedure TCalcDiv100Ties.Div_12_5_By_100;
begin
  CheckDivRound(12.5, 100, 2, 0.13);
end;

procedure TCalcDiv100Ties.Div_13_5_By_100;
begin
  CheckDivRound(13.5, 100, 2, 0.14);
end;

procedure TCalcDiv100Ties.Div_14_5_By_100;
begin
  CheckDivRound(14.5, 100, 2, 0.15);
end;

procedure TCalcDiv100Ties.Div_15_5_By_100;
begin
  CheckDivRound(15.5, 100, 2, 0.16);
end;

procedure TCalcDiv100Ties.Div_16_5_By_100;
begin
  CheckDivRound(16.5, 100, 2, 0.17);
end;

procedure TCalcDiv100Ties.Div_17_5_By_100;
begin
  CheckDivRound(17.5, 100, 2, 0.18);
end;

procedure TCalcDiv100Ties.Div_18_5_By_100;
begin
  CheckDivRound(18.5, 100, 2, 0.19);
end;

procedure TCalcDiv100Ties.Div_19_5_By_100;
begin
  CheckDivRound(19.5, 100, 2, 0.2);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcTimes100NearInteger);
  TDUnitX.RegisterTestFixture(TCalcDiv100Ties);

end.
