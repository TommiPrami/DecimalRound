unit DRTests.Calc.MultiplyTies;

{ GENERATED test data (one-shot script; safe to edit by hand).

  Products N * 0.045 / 0.015 / 0.005 for odd N: every exact decimal
  product ends in 5 at the third decimal, i.e. a half-up tie at 2
  decimals. The Double computation lands a hair under or over the
  exact tie depending on platform (x87 Extended intermediates on
  Win32, SSE Double on Win64); DecimalRound must round every one of
  them UP (away from zero) on both. One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcMulTies0045 = class
  { N * 0.045 for odd N 1..49: the exact decimal product always ends in 5
    at the third decimal, so every case is a half-up tie at 2 decimals.
    Expected values derived with exact integer arithmetic. }
  public
    [Test] procedure Mul_01_x_0_045;    // 1 * 0.045 -> tie -> 0.05
    [Test] procedure Mul_Neg_01_x_0_045;    // -> -0.05
    [Test] procedure Mul_03_x_0_045;    // 3 * 0.045 -> tie -> 0.14
    [Test] procedure Mul_Neg_03_x_0_045;    // -> -0.14
    [Test] procedure Mul_05_x_0_045;    // 5 * 0.045 -> tie -> 0.23
    [Test] procedure Mul_Neg_05_x_0_045;    // -> -0.23
    [Test] procedure Mul_07_x_0_045;    // 7 * 0.045 -> tie -> 0.32
    [Test] procedure Mul_Neg_07_x_0_045;    // -> -0.32
    [Test] procedure Mul_09_x_0_045;    // 9 * 0.045 -> tie -> 0.41
    [Test] procedure Mul_Neg_09_x_0_045;    // -> -0.41
    [Test] procedure Mul_11_x_0_045;    // 11 * 0.045 -> tie -> 0.5
    [Test] procedure Mul_Neg_11_x_0_045;    // -> -0.5
    [Test] procedure Mul_13_x_0_045;    // 13 * 0.045 -> tie -> 0.59
    [Test] procedure Mul_Neg_13_x_0_045;    // -> -0.59
    [Test] procedure Mul_15_x_0_045;    // 15 * 0.045 -> tie -> 0.68
    [Test] procedure Mul_Neg_15_x_0_045;    // -> -0.68
    [Test] procedure Mul_17_x_0_045;    // 17 * 0.045 -> tie -> 0.77
    [Test] procedure Mul_Neg_17_x_0_045;    // -> -0.77
    [Test] procedure Mul_19_x_0_045;    // 19 * 0.045 -> tie -> 0.86
    [Test] procedure Mul_Neg_19_x_0_045;    // -> -0.86
    [Test] procedure Mul_21_x_0_045;    // 21 * 0.045 -> tie -> 0.95
    [Test] procedure Mul_Neg_21_x_0_045;    // -> -0.95
    [Test] procedure Mul_23_x_0_045;    // 23 * 0.045 -> tie -> 1.04
    [Test] procedure Mul_Neg_23_x_0_045;    // -> -1.04
    [Test] procedure Mul_25_x_0_045;    // 25 * 0.045 -> tie -> 1.13
    [Test] procedure Mul_Neg_25_x_0_045;    // -> -1.13
    [Test] procedure Mul_27_x_0_045;    // 27 * 0.045 -> tie -> 1.22
    [Test] procedure Mul_Neg_27_x_0_045;    // -> -1.22
    [Test] procedure Mul_29_x_0_045;    // 29 * 0.045 -> tie -> 1.31
    [Test] procedure Mul_Neg_29_x_0_045;    // -> -1.31
    [Test] procedure Mul_31_x_0_045;    // 31 * 0.045 -> tie -> 1.4
    [Test] procedure Mul_Neg_31_x_0_045;    // -> -1.4
    [Test] procedure Mul_33_x_0_045;    // 33 * 0.045 -> tie -> 1.49
    [Test] procedure Mul_Neg_33_x_0_045;    // -> -1.49
    [Test] procedure Mul_35_x_0_045;    // 35 * 0.045 -> tie -> 1.58
    [Test] procedure Mul_Neg_35_x_0_045;    // -> -1.58
    [Test] procedure Mul_37_x_0_045;    // 37 * 0.045 -> tie -> 1.67
    [Test] procedure Mul_Neg_37_x_0_045;    // -> -1.67
    [Test] procedure Mul_39_x_0_045;    // 39 * 0.045 -> tie -> 1.76
    [Test] procedure Mul_Neg_39_x_0_045;    // -> -1.76
    [Test] procedure Mul_41_x_0_045;    // 41 * 0.045 -> tie -> 1.85
    [Test] procedure Mul_Neg_41_x_0_045;    // -> -1.85
    [Test] procedure Mul_43_x_0_045;    // 43 * 0.045 -> tie -> 1.94
    [Test] procedure Mul_Neg_43_x_0_045;    // -> -1.94
    [Test] procedure Mul_45_x_0_045;    // 45 * 0.045 -> tie -> 2.03
    [Test] procedure Mul_Neg_45_x_0_045;    // -> -2.03
    [Test] procedure Mul_47_x_0_045;    // 47 * 0.045 -> tie -> 2.12
    [Test] procedure Mul_Neg_47_x_0_045;    // -> -2.12
    [Test] procedure Mul_49_x_0_045;    // 49 * 0.045 -> tie -> 2.21
    [Test] procedure Mul_Neg_49_x_0_045;    // -> -2.21
  end;

  [TestFixture]
  TCalcMulTies0015 = class
  { N * 0.015 for odd N 1..49: the exact decimal product always ends in 5
    at the third decimal, so every case is a half-up tie at 2 decimals.
    Expected values derived with exact integer arithmetic. }
  public
    [Test] procedure Mul_01_x_0_015;    // 1 * 0.015 -> tie -> 0.02
    [Test] procedure Mul_Neg_01_x_0_015;    // -> -0.02
    [Test] procedure Mul_03_x_0_015;    // 3 * 0.015 -> tie -> 0.05
    [Test] procedure Mul_Neg_03_x_0_015;    // -> -0.05
    [Test] procedure Mul_05_x_0_015;    // 5 * 0.015 -> tie -> 0.08
    [Test] procedure Mul_Neg_05_x_0_015;    // -> -0.08
    [Test] procedure Mul_07_x_0_015;    // 7 * 0.015 -> tie -> 0.11
    [Test] procedure Mul_Neg_07_x_0_015;    // -> -0.11
    [Test] procedure Mul_09_x_0_015;    // 9 * 0.015 -> tie -> 0.14
    [Test] procedure Mul_Neg_09_x_0_015;    // -> -0.14
    [Test] procedure Mul_11_x_0_015;    // 11 * 0.015 -> tie -> 0.17
    [Test] procedure Mul_Neg_11_x_0_015;    // -> -0.17
    [Test] procedure Mul_13_x_0_015;    // 13 * 0.015 -> tie -> 0.2
    [Test] procedure Mul_Neg_13_x_0_015;    // -> -0.2
    [Test] procedure Mul_15_x_0_015;    // 15 * 0.015 -> tie -> 0.23
    [Test] procedure Mul_Neg_15_x_0_015;    // -> -0.23
    [Test] procedure Mul_17_x_0_015;    // 17 * 0.015 -> tie -> 0.26
    [Test] procedure Mul_Neg_17_x_0_015;    // -> -0.26
    [Test] procedure Mul_19_x_0_015;    // 19 * 0.015 -> tie -> 0.29
    [Test] procedure Mul_Neg_19_x_0_015;    // -> -0.29
    [Test] procedure Mul_21_x_0_015;    // 21 * 0.015 -> tie -> 0.32
    [Test] procedure Mul_Neg_21_x_0_015;    // -> -0.32
    [Test] procedure Mul_23_x_0_015;    // 23 * 0.015 -> tie -> 0.35
    [Test] procedure Mul_Neg_23_x_0_015;    // -> -0.35
    [Test] procedure Mul_25_x_0_015;    // 25 * 0.015 -> tie -> 0.38
    [Test] procedure Mul_Neg_25_x_0_015;    // -> -0.38
    [Test] procedure Mul_27_x_0_015;    // 27 * 0.015 -> tie -> 0.41
    [Test] procedure Mul_Neg_27_x_0_015;    // -> -0.41
    [Test] procedure Mul_29_x_0_015;    // 29 * 0.015 -> tie -> 0.44
    [Test] procedure Mul_Neg_29_x_0_015;    // -> -0.44
    [Test] procedure Mul_31_x_0_015;    // 31 * 0.015 -> tie -> 0.47
    [Test] procedure Mul_Neg_31_x_0_015;    // -> -0.47
    [Test] procedure Mul_33_x_0_015;    // 33 * 0.015 -> tie -> 0.5
    [Test] procedure Mul_Neg_33_x_0_015;    // -> -0.5
    [Test] procedure Mul_35_x_0_015;    // 35 * 0.015 -> tie -> 0.53
    [Test] procedure Mul_Neg_35_x_0_015;    // -> -0.53
    [Test] procedure Mul_37_x_0_015;    // 37 * 0.015 -> tie -> 0.56
    [Test] procedure Mul_Neg_37_x_0_015;    // -> -0.56
    [Test] procedure Mul_39_x_0_015;    // 39 * 0.015 -> tie -> 0.59
    [Test] procedure Mul_Neg_39_x_0_015;    // -> -0.59
    [Test] procedure Mul_41_x_0_015;    // 41 * 0.015 -> tie -> 0.62
    [Test] procedure Mul_Neg_41_x_0_015;    // -> -0.62
    [Test] procedure Mul_43_x_0_015;    // 43 * 0.015 -> tie -> 0.65
    [Test] procedure Mul_Neg_43_x_0_015;    // -> -0.65
    [Test] procedure Mul_45_x_0_015;    // 45 * 0.015 -> tie -> 0.68
    [Test] procedure Mul_Neg_45_x_0_015;    // -> -0.68
    [Test] procedure Mul_47_x_0_015;    // 47 * 0.015 -> tie -> 0.71
    [Test] procedure Mul_Neg_47_x_0_015;    // -> -0.71
    [Test] procedure Mul_49_x_0_015;    // 49 * 0.015 -> tie -> 0.74
    [Test] procedure Mul_Neg_49_x_0_015;    // -> -0.74
  end;

  [TestFixture]
  TCalcMulTies0005 = class
  { N * 0.005 for odd N 1..49: the exact decimal product always ends in 5
    at the third decimal, so every case is a half-up tie at 2 decimals.
    Expected values derived with exact integer arithmetic. }
  public
    [Test] procedure Mul_01_x_0_005;    // 1 * 0.005 -> tie -> 0.01
    [Test] procedure Mul_Neg_01_x_0_005;    // -> -0.01
    [Test] procedure Mul_03_x_0_005;    // 3 * 0.005 -> tie -> 0.02
    [Test] procedure Mul_Neg_03_x_0_005;    // -> -0.02
    [Test] procedure Mul_05_x_0_005;    // 5 * 0.005 -> tie -> 0.03
    [Test] procedure Mul_Neg_05_x_0_005;    // -> -0.03
    [Test] procedure Mul_07_x_0_005;    // 7 * 0.005 -> tie -> 0.04
    [Test] procedure Mul_Neg_07_x_0_005;    // -> -0.04
    [Test] procedure Mul_09_x_0_005;    // 9 * 0.005 -> tie -> 0.05
    [Test] procedure Mul_Neg_09_x_0_005;    // -> -0.05
    [Test] procedure Mul_11_x_0_005;    // 11 * 0.005 -> tie -> 0.06
    [Test] procedure Mul_Neg_11_x_0_005;    // -> -0.06
    [Test] procedure Mul_13_x_0_005;    // 13 * 0.005 -> tie -> 0.07
    [Test] procedure Mul_Neg_13_x_0_005;    // -> -0.07
    [Test] procedure Mul_15_x_0_005;    // 15 * 0.005 -> tie -> 0.08
    [Test] procedure Mul_Neg_15_x_0_005;    // -> -0.08
    [Test] procedure Mul_17_x_0_005;    // 17 * 0.005 -> tie -> 0.09
    [Test] procedure Mul_Neg_17_x_0_005;    // -> -0.09
    [Test] procedure Mul_19_x_0_005;    // 19 * 0.005 -> tie -> 0.1
    [Test] procedure Mul_Neg_19_x_0_005;    // -> -0.1
    [Test] procedure Mul_21_x_0_005;    // 21 * 0.005 -> tie -> 0.11
    [Test] procedure Mul_Neg_21_x_0_005;    // -> -0.11
    [Test] procedure Mul_23_x_0_005;    // 23 * 0.005 -> tie -> 0.12
    [Test] procedure Mul_Neg_23_x_0_005;    // -> -0.12
    [Test] procedure Mul_25_x_0_005;    // 25 * 0.005 -> tie -> 0.13
    [Test] procedure Mul_Neg_25_x_0_005;    // -> -0.13
    [Test] procedure Mul_27_x_0_005;    // 27 * 0.005 -> tie -> 0.14
    [Test] procedure Mul_Neg_27_x_0_005;    // -> -0.14
    [Test] procedure Mul_29_x_0_005;    // 29 * 0.005 -> tie -> 0.15
    [Test] procedure Mul_Neg_29_x_0_005;    // -> -0.15
    [Test] procedure Mul_31_x_0_005;    // 31 * 0.005 -> tie -> 0.16
    [Test] procedure Mul_Neg_31_x_0_005;    // -> -0.16
    [Test] procedure Mul_33_x_0_005;    // 33 * 0.005 -> tie -> 0.17
    [Test] procedure Mul_Neg_33_x_0_005;    // -> -0.17
    [Test] procedure Mul_35_x_0_005;    // 35 * 0.005 -> tie -> 0.18
    [Test] procedure Mul_Neg_35_x_0_005;    // -> -0.18
    [Test] procedure Mul_37_x_0_005;    // 37 * 0.005 -> tie -> 0.19
    [Test] procedure Mul_Neg_37_x_0_005;    // -> -0.19
    [Test] procedure Mul_39_x_0_005;    // 39 * 0.005 -> tie -> 0.2
    [Test] procedure Mul_Neg_39_x_0_005;    // -> -0.2
    [Test] procedure Mul_41_x_0_005;    // 41 * 0.005 -> tie -> 0.21
    [Test] procedure Mul_Neg_41_x_0_005;    // -> -0.21
    [Test] procedure Mul_43_x_0_005;    // 43 * 0.005 -> tie -> 0.22
    [Test] procedure Mul_Neg_43_x_0_005;    // -> -0.22
    [Test] procedure Mul_45_x_0_005;    // 45 * 0.005 -> tie -> 0.23
    [Test] procedure Mul_Neg_45_x_0_005;    // -> -0.23
    [Test] procedure Mul_47_x_0_005;    // 47 * 0.005 -> tie -> 0.24
    [Test] procedure Mul_Neg_47_x_0_005;    // -> -0.24
    [Test] procedure Mul_49_x_0_005;    // 49 * 0.005 -> tie -> 0.25
    [Test] procedure Mul_Neg_49_x_0_005;    // -> -0.25
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcMulTies0045 }

procedure TCalcMulTies0045.Mul_01_x_0_045;
begin
  CheckMulRound(1, 0.045, 2, 0.05);
end;

procedure TCalcMulTies0045.Mul_Neg_01_x_0_045;
begin
  CheckMulRound(-1, 0.045, 2, -0.05);
end;

procedure TCalcMulTies0045.Mul_03_x_0_045;
begin
  CheckMulRound(3, 0.045, 2, 0.14);
end;

procedure TCalcMulTies0045.Mul_Neg_03_x_0_045;
begin
  CheckMulRound(-3, 0.045, 2, -0.14);
end;

procedure TCalcMulTies0045.Mul_05_x_0_045;
begin
  CheckMulRound(5, 0.045, 2, 0.23);
end;

procedure TCalcMulTies0045.Mul_Neg_05_x_0_045;
begin
  CheckMulRound(-5, 0.045, 2, -0.23);
end;

procedure TCalcMulTies0045.Mul_07_x_0_045;
begin
  CheckMulRound(7, 0.045, 2, 0.32);
end;

procedure TCalcMulTies0045.Mul_Neg_07_x_0_045;
begin
  CheckMulRound(-7, 0.045, 2, -0.32);
end;

procedure TCalcMulTies0045.Mul_09_x_0_045;
begin
  CheckMulRound(9, 0.045, 2, 0.41);
end;

procedure TCalcMulTies0045.Mul_Neg_09_x_0_045;
begin
  CheckMulRound(-9, 0.045, 2, -0.41);
end;

procedure TCalcMulTies0045.Mul_11_x_0_045;
begin
  CheckMulRound(11, 0.045, 2, 0.5);
end;

procedure TCalcMulTies0045.Mul_Neg_11_x_0_045;
begin
  CheckMulRound(-11, 0.045, 2, -0.5);
end;

procedure TCalcMulTies0045.Mul_13_x_0_045;
begin
  CheckMulRound(13, 0.045, 2, 0.59);
end;

procedure TCalcMulTies0045.Mul_Neg_13_x_0_045;
begin
  CheckMulRound(-13, 0.045, 2, -0.59);
end;

procedure TCalcMulTies0045.Mul_15_x_0_045;
begin
  CheckMulRound(15, 0.045, 2, 0.68);
end;

procedure TCalcMulTies0045.Mul_Neg_15_x_0_045;
begin
  CheckMulRound(-15, 0.045, 2, -0.68);
end;

procedure TCalcMulTies0045.Mul_17_x_0_045;
begin
  CheckMulRound(17, 0.045, 2, 0.77);
end;

procedure TCalcMulTies0045.Mul_Neg_17_x_0_045;
begin
  CheckMulRound(-17, 0.045, 2, -0.77);
end;

procedure TCalcMulTies0045.Mul_19_x_0_045;
begin
  CheckMulRound(19, 0.045, 2, 0.86);
end;

procedure TCalcMulTies0045.Mul_Neg_19_x_0_045;
begin
  CheckMulRound(-19, 0.045, 2, -0.86);
end;

procedure TCalcMulTies0045.Mul_21_x_0_045;
begin
  CheckMulRound(21, 0.045, 2, 0.95);
end;

procedure TCalcMulTies0045.Mul_Neg_21_x_0_045;
begin
  CheckMulRound(-21, 0.045, 2, -0.95);
end;

procedure TCalcMulTies0045.Mul_23_x_0_045;
begin
  CheckMulRound(23, 0.045, 2, 1.04);
end;

procedure TCalcMulTies0045.Mul_Neg_23_x_0_045;
begin
  CheckMulRound(-23, 0.045, 2, -1.04);
end;

procedure TCalcMulTies0045.Mul_25_x_0_045;
begin
  CheckMulRound(25, 0.045, 2, 1.13);
end;

procedure TCalcMulTies0045.Mul_Neg_25_x_0_045;
begin
  CheckMulRound(-25, 0.045, 2, -1.13);
end;

procedure TCalcMulTies0045.Mul_27_x_0_045;
begin
  CheckMulRound(27, 0.045, 2, 1.22);
end;

procedure TCalcMulTies0045.Mul_Neg_27_x_0_045;
begin
  CheckMulRound(-27, 0.045, 2, -1.22);
end;

procedure TCalcMulTies0045.Mul_29_x_0_045;
begin
  CheckMulRound(29, 0.045, 2, 1.31);
end;

procedure TCalcMulTies0045.Mul_Neg_29_x_0_045;
begin
  CheckMulRound(-29, 0.045, 2, -1.31);
end;

procedure TCalcMulTies0045.Mul_31_x_0_045;
begin
  CheckMulRound(31, 0.045, 2, 1.4);
end;

procedure TCalcMulTies0045.Mul_Neg_31_x_0_045;
begin
  CheckMulRound(-31, 0.045, 2, -1.4);
end;

procedure TCalcMulTies0045.Mul_33_x_0_045;
begin
  CheckMulRound(33, 0.045, 2, 1.49);
end;

procedure TCalcMulTies0045.Mul_Neg_33_x_0_045;
begin
  CheckMulRound(-33, 0.045, 2, -1.49);
end;

procedure TCalcMulTies0045.Mul_35_x_0_045;
begin
  CheckMulRound(35, 0.045, 2, 1.58);
end;

procedure TCalcMulTies0045.Mul_Neg_35_x_0_045;
begin
  CheckMulRound(-35, 0.045, 2, -1.58);
end;

procedure TCalcMulTies0045.Mul_37_x_0_045;
begin
  CheckMulRound(37, 0.045, 2, 1.67);
end;

procedure TCalcMulTies0045.Mul_Neg_37_x_0_045;
begin
  CheckMulRound(-37, 0.045, 2, -1.67);
end;

procedure TCalcMulTies0045.Mul_39_x_0_045;
begin
  CheckMulRound(39, 0.045, 2, 1.76);
end;

procedure TCalcMulTies0045.Mul_Neg_39_x_0_045;
begin
  CheckMulRound(-39, 0.045, 2, -1.76);
end;

procedure TCalcMulTies0045.Mul_41_x_0_045;
begin
  CheckMulRound(41, 0.045, 2, 1.85);
end;

procedure TCalcMulTies0045.Mul_Neg_41_x_0_045;
begin
  CheckMulRound(-41, 0.045, 2, -1.85);
end;

procedure TCalcMulTies0045.Mul_43_x_0_045;
begin
  CheckMulRound(43, 0.045, 2, 1.94);
end;

procedure TCalcMulTies0045.Mul_Neg_43_x_0_045;
begin
  CheckMulRound(-43, 0.045, 2, -1.94);
end;

procedure TCalcMulTies0045.Mul_45_x_0_045;
begin
  CheckMulRound(45, 0.045, 2, 2.03);
end;

procedure TCalcMulTies0045.Mul_Neg_45_x_0_045;
begin
  CheckMulRound(-45, 0.045, 2, -2.03);
end;

procedure TCalcMulTies0045.Mul_47_x_0_045;
begin
  CheckMulRound(47, 0.045, 2, 2.12);
end;

procedure TCalcMulTies0045.Mul_Neg_47_x_0_045;
begin
  CheckMulRound(-47, 0.045, 2, -2.12);
end;

procedure TCalcMulTies0045.Mul_49_x_0_045;
begin
  CheckMulRound(49, 0.045, 2, 2.21);
end;

procedure TCalcMulTies0045.Mul_Neg_49_x_0_045;
begin
  CheckMulRound(-49, 0.045, 2, -2.21);
end;

{ TCalcMulTies0015 }

procedure TCalcMulTies0015.Mul_01_x_0_015;
begin
  CheckMulRound(1, 0.015, 2, 0.02);
end;

procedure TCalcMulTies0015.Mul_Neg_01_x_0_015;
begin
  CheckMulRound(-1, 0.015, 2, -0.02);
end;

procedure TCalcMulTies0015.Mul_03_x_0_015;
begin
  CheckMulRound(3, 0.015, 2, 0.05);
end;

procedure TCalcMulTies0015.Mul_Neg_03_x_0_015;
begin
  CheckMulRound(-3, 0.015, 2, -0.05);
end;

procedure TCalcMulTies0015.Mul_05_x_0_015;
begin
  CheckMulRound(5, 0.015, 2, 0.08);
end;

procedure TCalcMulTies0015.Mul_Neg_05_x_0_015;
begin
  CheckMulRound(-5, 0.015, 2, -0.08);
end;

procedure TCalcMulTies0015.Mul_07_x_0_015;
begin
  CheckMulRound(7, 0.015, 2, 0.11);
end;

procedure TCalcMulTies0015.Mul_Neg_07_x_0_015;
begin
  CheckMulRound(-7, 0.015, 2, -0.11);
end;

procedure TCalcMulTies0015.Mul_09_x_0_015;
begin
  CheckMulRound(9, 0.015, 2, 0.14);
end;

procedure TCalcMulTies0015.Mul_Neg_09_x_0_015;
begin
  CheckMulRound(-9, 0.015, 2, -0.14);
end;

procedure TCalcMulTies0015.Mul_11_x_0_015;
begin
  CheckMulRound(11, 0.015, 2, 0.17);
end;

procedure TCalcMulTies0015.Mul_Neg_11_x_0_015;
begin
  CheckMulRound(-11, 0.015, 2, -0.17);
end;

procedure TCalcMulTies0015.Mul_13_x_0_015;
begin
  CheckMulRound(13, 0.015, 2, 0.2);
end;

procedure TCalcMulTies0015.Mul_Neg_13_x_0_015;
begin
  CheckMulRound(-13, 0.015, 2, -0.2);
end;

procedure TCalcMulTies0015.Mul_15_x_0_015;
begin
  CheckMulRound(15, 0.015, 2, 0.23);
end;

procedure TCalcMulTies0015.Mul_Neg_15_x_0_015;
begin
  CheckMulRound(-15, 0.015, 2, -0.23);
end;

procedure TCalcMulTies0015.Mul_17_x_0_015;
begin
  CheckMulRound(17, 0.015, 2, 0.26);
end;

procedure TCalcMulTies0015.Mul_Neg_17_x_0_015;
begin
  CheckMulRound(-17, 0.015, 2, -0.26);
end;

procedure TCalcMulTies0015.Mul_19_x_0_015;
begin
  CheckMulRound(19, 0.015, 2, 0.29);
end;

procedure TCalcMulTies0015.Mul_Neg_19_x_0_015;
begin
  CheckMulRound(-19, 0.015, 2, -0.29);
end;

procedure TCalcMulTies0015.Mul_21_x_0_015;
begin
  CheckMulRound(21, 0.015, 2, 0.32);
end;

procedure TCalcMulTies0015.Mul_Neg_21_x_0_015;
begin
  CheckMulRound(-21, 0.015, 2, -0.32);
end;

procedure TCalcMulTies0015.Mul_23_x_0_015;
begin
  CheckMulRound(23, 0.015, 2, 0.35);
end;

procedure TCalcMulTies0015.Mul_Neg_23_x_0_015;
begin
  CheckMulRound(-23, 0.015, 2, -0.35);
end;

procedure TCalcMulTies0015.Mul_25_x_0_015;
begin
  CheckMulRound(25, 0.015, 2, 0.38);
end;

procedure TCalcMulTies0015.Mul_Neg_25_x_0_015;
begin
  CheckMulRound(-25, 0.015, 2, -0.38);
end;

procedure TCalcMulTies0015.Mul_27_x_0_015;
begin
  CheckMulRound(27, 0.015, 2, 0.41);
end;

procedure TCalcMulTies0015.Mul_Neg_27_x_0_015;
begin
  CheckMulRound(-27, 0.015, 2, -0.41);
end;

procedure TCalcMulTies0015.Mul_29_x_0_015;
begin
  CheckMulRound(29, 0.015, 2, 0.44);
end;

procedure TCalcMulTies0015.Mul_Neg_29_x_0_015;
begin
  CheckMulRound(-29, 0.015, 2, -0.44);
end;

procedure TCalcMulTies0015.Mul_31_x_0_015;
begin
  CheckMulRound(31, 0.015, 2, 0.47);
end;

procedure TCalcMulTies0015.Mul_Neg_31_x_0_015;
begin
  CheckMulRound(-31, 0.015, 2, -0.47);
end;

procedure TCalcMulTies0015.Mul_33_x_0_015;
begin
  CheckMulRound(33, 0.015, 2, 0.5);
end;

procedure TCalcMulTies0015.Mul_Neg_33_x_0_015;
begin
  CheckMulRound(-33, 0.015, 2, -0.5);
end;

procedure TCalcMulTies0015.Mul_35_x_0_015;
begin
  CheckMulRound(35, 0.015, 2, 0.53);
end;

procedure TCalcMulTies0015.Mul_Neg_35_x_0_015;
begin
  CheckMulRound(-35, 0.015, 2, -0.53);
end;

procedure TCalcMulTies0015.Mul_37_x_0_015;
begin
  CheckMulRound(37, 0.015, 2, 0.56);
end;

procedure TCalcMulTies0015.Mul_Neg_37_x_0_015;
begin
  CheckMulRound(-37, 0.015, 2, -0.56);
end;

procedure TCalcMulTies0015.Mul_39_x_0_015;
begin
  CheckMulRound(39, 0.015, 2, 0.59);
end;

procedure TCalcMulTies0015.Mul_Neg_39_x_0_015;
begin
  CheckMulRound(-39, 0.015, 2, -0.59);
end;

procedure TCalcMulTies0015.Mul_41_x_0_015;
begin
  CheckMulRound(41, 0.015, 2, 0.62);
end;

procedure TCalcMulTies0015.Mul_Neg_41_x_0_015;
begin
  CheckMulRound(-41, 0.015, 2, -0.62);
end;

procedure TCalcMulTies0015.Mul_43_x_0_015;
begin
  CheckMulRound(43, 0.015, 2, 0.65);
end;

procedure TCalcMulTies0015.Mul_Neg_43_x_0_015;
begin
  CheckMulRound(-43, 0.015, 2, -0.65);
end;

procedure TCalcMulTies0015.Mul_45_x_0_015;
begin
  CheckMulRound(45, 0.015, 2, 0.68);
end;

procedure TCalcMulTies0015.Mul_Neg_45_x_0_015;
begin
  CheckMulRound(-45, 0.015, 2, -0.68);
end;

procedure TCalcMulTies0015.Mul_47_x_0_015;
begin
  CheckMulRound(47, 0.015, 2, 0.71);
end;

procedure TCalcMulTies0015.Mul_Neg_47_x_0_015;
begin
  CheckMulRound(-47, 0.015, 2, -0.71);
end;

procedure TCalcMulTies0015.Mul_49_x_0_015;
begin
  CheckMulRound(49, 0.015, 2, 0.74);
end;

procedure TCalcMulTies0015.Mul_Neg_49_x_0_015;
begin
  CheckMulRound(-49, 0.015, 2, -0.74);
end;

{ TCalcMulTies0005 }

procedure TCalcMulTies0005.Mul_01_x_0_005;
begin
  CheckMulRound(1, 0.005, 2, 0.01);
end;

procedure TCalcMulTies0005.Mul_Neg_01_x_0_005;
begin
  CheckMulRound(-1, 0.005, 2, -0.01);
end;

procedure TCalcMulTies0005.Mul_03_x_0_005;
begin
  CheckMulRound(3, 0.005, 2, 0.02);
end;

procedure TCalcMulTies0005.Mul_Neg_03_x_0_005;
begin
  CheckMulRound(-3, 0.005, 2, -0.02);
end;

procedure TCalcMulTies0005.Mul_05_x_0_005;
begin
  CheckMulRound(5, 0.005, 2, 0.03);
end;

procedure TCalcMulTies0005.Mul_Neg_05_x_0_005;
begin
  CheckMulRound(-5, 0.005, 2, -0.03);
end;

procedure TCalcMulTies0005.Mul_07_x_0_005;
begin
  CheckMulRound(7, 0.005, 2, 0.04);
end;

procedure TCalcMulTies0005.Mul_Neg_07_x_0_005;
begin
  CheckMulRound(-7, 0.005, 2, -0.04);
end;

procedure TCalcMulTies0005.Mul_09_x_0_005;
begin
  CheckMulRound(9, 0.005, 2, 0.05);
end;

procedure TCalcMulTies0005.Mul_Neg_09_x_0_005;
begin
  CheckMulRound(-9, 0.005, 2, -0.05);
end;

procedure TCalcMulTies0005.Mul_11_x_0_005;
begin
  CheckMulRound(11, 0.005, 2, 0.06);
end;

procedure TCalcMulTies0005.Mul_Neg_11_x_0_005;
begin
  CheckMulRound(-11, 0.005, 2, -0.06);
end;

procedure TCalcMulTies0005.Mul_13_x_0_005;
begin
  CheckMulRound(13, 0.005, 2, 0.07);
end;

procedure TCalcMulTies0005.Mul_Neg_13_x_0_005;
begin
  CheckMulRound(-13, 0.005, 2, -0.07);
end;

procedure TCalcMulTies0005.Mul_15_x_0_005;
begin
  CheckMulRound(15, 0.005, 2, 0.08);
end;

procedure TCalcMulTies0005.Mul_Neg_15_x_0_005;
begin
  CheckMulRound(-15, 0.005, 2, -0.08);
end;

procedure TCalcMulTies0005.Mul_17_x_0_005;
begin
  CheckMulRound(17, 0.005, 2, 0.09);
end;

procedure TCalcMulTies0005.Mul_Neg_17_x_0_005;
begin
  CheckMulRound(-17, 0.005, 2, -0.09);
end;

procedure TCalcMulTies0005.Mul_19_x_0_005;
begin
  CheckMulRound(19, 0.005, 2, 0.1);
end;

procedure TCalcMulTies0005.Mul_Neg_19_x_0_005;
begin
  CheckMulRound(-19, 0.005, 2, -0.1);
end;

procedure TCalcMulTies0005.Mul_21_x_0_005;
begin
  CheckMulRound(21, 0.005, 2, 0.11);
end;

procedure TCalcMulTies0005.Mul_Neg_21_x_0_005;
begin
  CheckMulRound(-21, 0.005, 2, -0.11);
end;

procedure TCalcMulTies0005.Mul_23_x_0_005;
begin
  CheckMulRound(23, 0.005, 2, 0.12);
end;

procedure TCalcMulTies0005.Mul_Neg_23_x_0_005;
begin
  CheckMulRound(-23, 0.005, 2, -0.12);
end;

procedure TCalcMulTies0005.Mul_25_x_0_005;
begin
  CheckMulRound(25, 0.005, 2, 0.13);
end;

procedure TCalcMulTies0005.Mul_Neg_25_x_0_005;
begin
  CheckMulRound(-25, 0.005, 2, -0.13);
end;

procedure TCalcMulTies0005.Mul_27_x_0_005;
begin
  CheckMulRound(27, 0.005, 2, 0.14);
end;

procedure TCalcMulTies0005.Mul_Neg_27_x_0_005;
begin
  CheckMulRound(-27, 0.005, 2, -0.14);
end;

procedure TCalcMulTies0005.Mul_29_x_0_005;
begin
  CheckMulRound(29, 0.005, 2, 0.15);
end;

procedure TCalcMulTies0005.Mul_Neg_29_x_0_005;
begin
  CheckMulRound(-29, 0.005, 2, -0.15);
end;

procedure TCalcMulTies0005.Mul_31_x_0_005;
begin
  CheckMulRound(31, 0.005, 2, 0.16);
end;

procedure TCalcMulTies0005.Mul_Neg_31_x_0_005;
begin
  CheckMulRound(-31, 0.005, 2, -0.16);
end;

procedure TCalcMulTies0005.Mul_33_x_0_005;
begin
  CheckMulRound(33, 0.005, 2, 0.17);
end;

procedure TCalcMulTies0005.Mul_Neg_33_x_0_005;
begin
  CheckMulRound(-33, 0.005, 2, -0.17);
end;

procedure TCalcMulTies0005.Mul_35_x_0_005;
begin
  CheckMulRound(35, 0.005, 2, 0.18);
end;

procedure TCalcMulTies0005.Mul_Neg_35_x_0_005;
begin
  CheckMulRound(-35, 0.005, 2, -0.18);
end;

procedure TCalcMulTies0005.Mul_37_x_0_005;
begin
  CheckMulRound(37, 0.005, 2, 0.19);
end;

procedure TCalcMulTies0005.Mul_Neg_37_x_0_005;
begin
  CheckMulRound(-37, 0.005, 2, -0.19);
end;

procedure TCalcMulTies0005.Mul_39_x_0_005;
begin
  CheckMulRound(39, 0.005, 2, 0.2);
end;

procedure TCalcMulTies0005.Mul_Neg_39_x_0_005;
begin
  CheckMulRound(-39, 0.005, 2, -0.2);
end;

procedure TCalcMulTies0005.Mul_41_x_0_005;
begin
  CheckMulRound(41, 0.005, 2, 0.21);
end;

procedure TCalcMulTies0005.Mul_Neg_41_x_0_005;
begin
  CheckMulRound(-41, 0.005, 2, -0.21);
end;

procedure TCalcMulTies0005.Mul_43_x_0_005;
begin
  CheckMulRound(43, 0.005, 2, 0.22);
end;

procedure TCalcMulTies0005.Mul_Neg_43_x_0_005;
begin
  CheckMulRound(-43, 0.005, 2, -0.22);
end;

procedure TCalcMulTies0005.Mul_45_x_0_005;
begin
  CheckMulRound(45, 0.005, 2, 0.23);
end;

procedure TCalcMulTies0005.Mul_Neg_45_x_0_005;
begin
  CheckMulRound(-45, 0.005, 2, -0.23);
end;

procedure TCalcMulTies0005.Mul_47_x_0_005;
begin
  CheckMulRound(47, 0.005, 2, 0.24);
end;

procedure TCalcMulTies0005.Mul_Neg_47_x_0_005;
begin
  CheckMulRound(-47, 0.005, 2, -0.24);
end;

procedure TCalcMulTies0005.Mul_49_x_0_005;
begin
  CheckMulRound(49, 0.005, 2, 0.25);
end;

procedure TCalcMulTies0005.Mul_Neg_49_x_0_005;
begin
  CheckMulRound(-49, 0.005, 2, -0.25);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcMulTies0045);
  TDUnitX.RegisterTestFixture(TCalcMulTies0015);
  TDUnitX.RegisterTestFixture(TCalcMulTies0005);

end.
