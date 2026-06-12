unit DRTests.Calc.Divide;

{ GENERATED test data (one-shot script; safe to edit by hand).

  Quotients: exact binary ties (n/2, n/4, n/8, n/16), repeating
  decimals (n/3, n/7, n/9, n/11, ...) and per-decimal-count ladders.
  Expected values derived with exact decimal arithmetic, half-up.
  One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcDivExactBinary = class
  { Dividing by 2/4/8/16 gives EXACT binary values sitting exactly on
    half-up tie boundaries — no representation error at all, identical
    bits on Win32 and Win64. Verifies pure tie handling. }
  public
    [Test] procedure Div_01_By_2;    // 1/2 tie -> 1
    [Test] procedure Div_Neg_01_By_2;    // -> -1
    [Test] procedure Div_03_By_2;    // 3/2 tie -> 2
    [Test] procedure Div_Neg_03_By_2;    // -> -2
    [Test] procedure Div_05_By_2;    // 5/2 tie -> 3
    [Test] procedure Div_Neg_05_By_2;    // -> -3
    [Test] procedure Div_07_By_2;    // 7/2 tie -> 4
    [Test] procedure Div_Neg_07_By_2;    // -> -4
    [Test] procedure Div_09_By_2;    // 9/2 tie -> 5
    [Test] procedure Div_Neg_09_By_2;    // -> -5
    [Test] procedure Div_11_By_2;    // 11/2 tie -> 6
    [Test] procedure Div_Neg_11_By_2;    // -> -6
    [Test] procedure Div_13_By_2;    // 13/2 tie -> 7
    [Test] procedure Div_Neg_13_By_2;    // -> -7
    [Test] procedure Div_15_By_2;    // 15/2 tie -> 8
    [Test] procedure Div_Neg_15_By_2;    // -> -8
    [Test] procedure Div_17_By_2;    // 17/2 tie -> 9
    [Test] procedure Div_Neg_17_By_2;    // -> -9
    [Test] procedure Div_19_By_2;    // 19/2 tie -> 10
    [Test] procedure Div_Neg_19_By_2;    // -> -10
    [Test] procedure Div_1_By_4;    // 1/4 tie -> 0.3
    [Test] procedure Div_Neg_1_By_4;    // -> -0.3
    [Test] procedure Div_3_By_4;    // 3/4 tie -> 0.8
    [Test] procedure Div_Neg_3_By_4;    // -> -0.8
    [Test] procedure Div_5_By_4;    // 5/4 tie -> 1.3
    [Test] procedure Div_Neg_5_By_4;    // -> -1.3
    [Test] procedure Div_7_By_4;    // 7/4 tie -> 1.8
    [Test] procedure Div_Neg_7_By_4;    // -> -1.8
    [Test] procedure Div_01_By_8;    // 1/8 tie -> 0.13
    [Test] procedure Div_Neg_01_By_8;    // -> -0.13
    [Test] procedure Div_03_By_8;    // 3/8 tie -> 0.38
    [Test] procedure Div_Neg_03_By_8;    // -> -0.38
    [Test] procedure Div_05_By_8;    // 5/8 tie -> 0.63
    [Test] procedure Div_Neg_05_By_8;    // -> -0.63
    [Test] procedure Div_07_By_8;    // 7/8 tie -> 0.88
    [Test] procedure Div_Neg_07_By_8;    // -> -0.88
    [Test] procedure Div_09_By_8;    // 9/8 tie -> 1.13
    [Test] procedure Div_Neg_09_By_8;    // -> -1.13
    [Test] procedure Div_11_By_8;    // 11/8 tie -> 1.38
    [Test] procedure Div_Neg_11_By_8;    // -> -1.38
    [Test] procedure Div_13_By_8;    // 13/8 tie -> 1.63
    [Test] procedure Div_Neg_13_By_8;    // -> -1.63
    [Test] procedure Div_15_By_8;    // 15/8 tie -> 1.88
    [Test] procedure Div_Neg_15_By_8;    // -> -1.88
    [Test] procedure Div_01_By_16;    // 1/16 tie -> 0.063
    [Test] procedure Div_03_By_16;    // 3/16 tie -> 0.188
    [Test] procedure Div_05_By_16;    // 5/16 tie -> 0.313
    [Test] procedure Div_07_By_16;    // 7/16 tie -> 0.438
    [Test] procedure Div_09_By_16;    // 9/16 tie -> 0.563
    [Test] procedure Div_11_By_16;    // 11/16 tie -> 0.688
    [Test] procedure Div_13_By_16;    // 13/16 tie -> 0.813
    [Test] procedure Div_15_By_16;    // 15/16 tie -> 0.938
  end;

  [TestFixture]
  TCalcDivRepeating = class
  { Repeating-decimal quotients (thirds, sixths, sevenths, ninths,
    elevenths, ...) rounded half-up at 2 decimals. }
  public
    [Test] procedure Div_1_By_7;    // 1/7 -> 0.14
    [Test] procedure Div_2_By_7;    // 2/7 -> 0.29
    [Test] procedure Div_3_By_7;    // 3/7 -> 0.43
    [Test] procedure Div_4_By_7;    // 4/7 -> 0.57
    [Test] procedure Div_5_By_7;    // 5/7 -> 0.71
    [Test] procedure Div_6_By_7;    // 6/7 -> 0.86
    [Test] procedure Div_8_By_7;    // 8/7 -> 1.14
    [Test] procedure Div_9_By_7;    // 9/7 -> 1.29
    [Test] procedure Div_10_By_7;    // 10/7 -> 1.43
    [Test] procedure Div_11_By_7;    // 11/7 -> 1.57
    [Test] procedure Div_12_By_7;    // 12/7 -> 1.71
    [Test] procedure Div_13_By_7;    // 13/7 -> 1.86
    [Test] procedure Div_1_By_9;    // 1/9 -> 0.11
    [Test] procedure Div_2_By_9;    // 2/9 -> 0.22
    [Test] procedure Div_3_By_9;    // 3/9 -> 0.33
    [Test] procedure Div_4_By_9;    // 4/9 -> 0.44
    [Test] procedure Div_5_By_9;    // 5/9 -> 0.56
    [Test] procedure Div_6_By_9;    // 6/9 -> 0.67
    [Test] procedure Div_7_By_9;    // 7/9 -> 0.78
    [Test] procedure Div_8_By_9;    // 8/9 -> 0.89
    [Test] procedure Div_1_By_11;    // 1/11 -> 0.09
    [Test] procedure Div_2_By_11;    // 2/11 -> 0.18
    [Test] procedure Div_3_By_11;    // 3/11 -> 0.27
    [Test] procedure Div_4_By_11;    // 4/11 -> 0.36
    [Test] procedure Div_5_By_11;    // 5/11 -> 0.45
    [Test] procedure Div_6_By_11;    // 6/11 -> 0.55
    [Test] procedure Div_7_By_11;    // 7/11 -> 0.64
    [Test] procedure Div_8_By_11;    // 8/11 -> 0.73
    [Test] procedure Div_9_By_11;    // 9/11 -> 0.82
    [Test] procedure Div_10_By_11;    // 10/11 -> 0.91
    [Test] procedure Div_1_By_3;    // 1/3 -> 0.33
    [Test] procedure Div_2_By_3;    // 2/3 -> 0.67
    [Test] procedure Div_4_By_3;    // 4/3 -> 1.33
    [Test] procedure Div_5_By_3;    // 5/3 -> 1.67
    [Test] procedure Div_7_By_3;    // 7/3 -> 2.33
    [Test] procedure Div_8_By_3;    // 8/3 -> 2.67
    [Test] procedure Div_10_By_3;    // 10/3 -> 3.33
    [Test] procedure Div_100_By_3;    // 100/3 -> 33.33
    [Test] procedure Div_1000_By_3;    // 1000/3 -> 333.33
    [Test] procedure Div_10000_By_3;    // 10000/3 -> 3333.33
    [Test] procedure Div_1_By_6;    // 1/6 -> 0.17
    [Test] procedure Div_5_By_6;    // 5/6 -> 0.83
    [Test] procedure Div_7_By_6;    // 7/6 -> 1.17
    [Test] procedure Div_11_By_6;    // 11/6 -> 1.83
    [Test] procedure Div_100_By_6;    // 100/6 -> 16.67
    [Test] procedure Div_1000_By_6;    // 1000/6 -> 166.67
    [Test] procedure Div_100_By_7;    // 100/7 -> 14.29
    [Test] procedure Div_1000_By_7;    // 1000/7 -> 142.86
    [Test] procedure Div_100_By_11;    // 100/11 -> 9.09
    [Test] procedure Div_100_By_13;    // 100/13 -> 7.69
    [Test] procedure Div_1000_By_13;    // 1000/13 -> 76.92
    [Test] procedure Div_100_By_17;    // 100/17 -> 5.88
    [Test] procedure Div_100_By_19;    // 100/19 -> 5.26
    [Test] procedure Div_100_By_23;    // 100/23 -> 4.35
    [Test] procedure Div_Neg_1_By_3;    // -1/3 -> -0.33
    [Test] procedure Div_Neg_2_By_3;    // -2/3 -> -0.67
    [Test] procedure Div_Neg_1_By_7;    // -1/7 -> -0.14
    [Test] procedure Div_Neg_5_By_9;    // -5/9 -> -0.56
    [Test] procedure Div_Neg_6_By_11;    // -6/11 -> -0.55
    [Test] procedure Div_Neg_100_By_3;    // -100/3 -> -33.33
  end;

  [TestFixture]
  TCalcDivLadders = class
  { The same quotient rounded at every decimal count 0..N — each digit
    boundary of the repeating expansion checked separately. }
  public
    [Test] procedure Div_1_By_7_At0dp;    // 1/7 @0 dp -> 0
    [Test] procedure Div_1_By_7_At1dp;    // 1/7 @1 dp -> 0.1
    [Test] procedure Div_1_By_7_At2dp;    // 1/7 @2 dp -> 0.14
    [Test] procedure Div_1_By_7_At3dp;    // 1/7 @3 dp -> 0.143
    [Test] procedure Div_1_By_7_At4dp;    // 1/7 @4 dp -> 0.1429
    [Test] procedure Div_1_By_7_At5dp;    // 1/7 @5 dp -> 0.14286
    [Test] procedure Div_1_By_7_At6dp;    // 1/7 @6 dp -> 0.142857
    [Test] procedure Div_22_By_7_At0dp;    // 22/7 @0 dp -> 3
    [Test] procedure Div_22_By_7_At1dp;    // 22/7 @1 dp -> 3.1
    [Test] procedure Div_22_By_7_At2dp;    // 22/7 @2 dp -> 3.14
    [Test] procedure Div_22_By_7_At3dp;    // 22/7 @3 dp -> 3.143
    [Test] procedure Div_22_By_7_At4dp;    // 22/7 @4 dp -> 3.1429
    [Test] procedure Div_22_By_7_At5dp;    // 22/7 @5 dp -> 3.14286
    [Test] procedure Div_22_By_7_At6dp;    // 22/7 @6 dp -> 3.142857
    [Test] procedure Div_2_By_3_At0dp;    // 2/3 @0 dp -> 1
    [Test] procedure Div_2_By_3_At1dp;    // 2/3 @1 dp -> 0.7
    [Test] procedure Div_2_By_3_At2dp;    // 2/3 @2 dp -> 0.67
    [Test] procedure Div_2_By_3_At3dp;    // 2/3 @3 dp -> 0.667
    [Test] procedure Div_2_By_3_At4dp;    // 2/3 @4 dp -> 0.6667
    [Test] procedure Div_2_By_3_At5dp;    // 2/3 @5 dp -> 0.66667
    [Test] procedure Div_5_By_6_At0dp;    // 5/6 @0 dp -> 1
    [Test] procedure Div_5_By_6_At1dp;    // 5/6 @1 dp -> 0.8
    [Test] procedure Div_5_By_6_At2dp;    // 5/6 @2 dp -> 0.83
    [Test] procedure Div_5_By_6_At3dp;    // 5/6 @3 dp -> 0.833
    [Test] procedure Div_5_By_6_At4dp;    // 5/6 @4 dp -> 0.8333
    [Test] procedure Div_5_By_6_At5dp;    // 5/6 @5 dp -> 0.83333
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcDivExactBinary }

procedure TCalcDivExactBinary.Div_01_By_2;
begin
  CheckDivRound(1, 2, 0, 1);
end;

procedure TCalcDivExactBinary.Div_Neg_01_By_2;
begin
  CheckDivRound(-1, 2, 0, -1);
end;

procedure TCalcDivExactBinary.Div_03_By_2;
begin
  CheckDivRound(3, 2, 0, 2);
end;

procedure TCalcDivExactBinary.Div_Neg_03_By_2;
begin
  CheckDivRound(-3, 2, 0, -2);
end;

procedure TCalcDivExactBinary.Div_05_By_2;
begin
  CheckDivRound(5, 2, 0, 3);
end;

procedure TCalcDivExactBinary.Div_Neg_05_By_2;
begin
  CheckDivRound(-5, 2, 0, -3);
end;

procedure TCalcDivExactBinary.Div_07_By_2;
begin
  CheckDivRound(7, 2, 0, 4);
end;

procedure TCalcDivExactBinary.Div_Neg_07_By_2;
begin
  CheckDivRound(-7, 2, 0, -4);
end;

procedure TCalcDivExactBinary.Div_09_By_2;
begin
  CheckDivRound(9, 2, 0, 5);
end;

procedure TCalcDivExactBinary.Div_Neg_09_By_2;
begin
  CheckDivRound(-9, 2, 0, -5);
end;

procedure TCalcDivExactBinary.Div_11_By_2;
begin
  CheckDivRound(11, 2, 0, 6);
end;

procedure TCalcDivExactBinary.Div_Neg_11_By_2;
begin
  CheckDivRound(-11, 2, 0, -6);
end;

procedure TCalcDivExactBinary.Div_13_By_2;
begin
  CheckDivRound(13, 2, 0, 7);
end;

procedure TCalcDivExactBinary.Div_Neg_13_By_2;
begin
  CheckDivRound(-13, 2, 0, -7);
end;

procedure TCalcDivExactBinary.Div_15_By_2;
begin
  CheckDivRound(15, 2, 0, 8);
end;

procedure TCalcDivExactBinary.Div_Neg_15_By_2;
begin
  CheckDivRound(-15, 2, 0, -8);
end;

procedure TCalcDivExactBinary.Div_17_By_2;
begin
  CheckDivRound(17, 2, 0, 9);
end;

procedure TCalcDivExactBinary.Div_Neg_17_By_2;
begin
  CheckDivRound(-17, 2, 0, -9);
end;

procedure TCalcDivExactBinary.Div_19_By_2;
begin
  CheckDivRound(19, 2, 0, 10);
end;

procedure TCalcDivExactBinary.Div_Neg_19_By_2;
begin
  CheckDivRound(-19, 2, 0, -10);
end;

procedure TCalcDivExactBinary.Div_1_By_4;
begin
  CheckDivRound(1, 4, 1, 0.3);
end;

procedure TCalcDivExactBinary.Div_Neg_1_By_4;
begin
  CheckDivRound(-1, 4, 1, -0.3);
end;

procedure TCalcDivExactBinary.Div_3_By_4;
begin
  CheckDivRound(3, 4, 1, 0.8);
end;

procedure TCalcDivExactBinary.Div_Neg_3_By_4;
begin
  CheckDivRound(-3, 4, 1, -0.8);
end;

procedure TCalcDivExactBinary.Div_5_By_4;
begin
  CheckDivRound(5, 4, 1, 1.3);
end;

procedure TCalcDivExactBinary.Div_Neg_5_By_4;
begin
  CheckDivRound(-5, 4, 1, -1.3);
end;

procedure TCalcDivExactBinary.Div_7_By_4;
begin
  CheckDivRound(7, 4, 1, 1.8);
end;

procedure TCalcDivExactBinary.Div_Neg_7_By_4;
begin
  CheckDivRound(-7, 4, 1, -1.8);
end;

procedure TCalcDivExactBinary.Div_01_By_8;
begin
  CheckDivRound(1, 8, 2, 0.13);
end;

procedure TCalcDivExactBinary.Div_Neg_01_By_8;
begin
  CheckDivRound(-1, 8, 2, -0.13);
end;

procedure TCalcDivExactBinary.Div_03_By_8;
begin
  CheckDivRound(3, 8, 2, 0.38);
end;

procedure TCalcDivExactBinary.Div_Neg_03_By_8;
begin
  CheckDivRound(-3, 8, 2, -0.38);
end;

procedure TCalcDivExactBinary.Div_05_By_8;
begin
  CheckDivRound(5, 8, 2, 0.63);
end;

procedure TCalcDivExactBinary.Div_Neg_05_By_8;
begin
  CheckDivRound(-5, 8, 2, -0.63);
end;

procedure TCalcDivExactBinary.Div_07_By_8;
begin
  CheckDivRound(7, 8, 2, 0.88);
end;

procedure TCalcDivExactBinary.Div_Neg_07_By_8;
begin
  CheckDivRound(-7, 8, 2, -0.88);
end;

procedure TCalcDivExactBinary.Div_09_By_8;
begin
  CheckDivRound(9, 8, 2, 1.13);
end;

procedure TCalcDivExactBinary.Div_Neg_09_By_8;
begin
  CheckDivRound(-9, 8, 2, -1.13);
end;

procedure TCalcDivExactBinary.Div_11_By_8;
begin
  CheckDivRound(11, 8, 2, 1.38);
end;

procedure TCalcDivExactBinary.Div_Neg_11_By_8;
begin
  CheckDivRound(-11, 8, 2, -1.38);
end;

procedure TCalcDivExactBinary.Div_13_By_8;
begin
  CheckDivRound(13, 8, 2, 1.63);
end;

procedure TCalcDivExactBinary.Div_Neg_13_By_8;
begin
  CheckDivRound(-13, 8, 2, -1.63);
end;

procedure TCalcDivExactBinary.Div_15_By_8;
begin
  CheckDivRound(15, 8, 2, 1.88);
end;

procedure TCalcDivExactBinary.Div_Neg_15_By_8;
begin
  CheckDivRound(-15, 8, 2, -1.88);
end;

procedure TCalcDivExactBinary.Div_01_By_16;
begin
  CheckDivRound(1, 16, 3, 0.063);
end;

procedure TCalcDivExactBinary.Div_03_By_16;
begin
  CheckDivRound(3, 16, 3, 0.188);
end;

procedure TCalcDivExactBinary.Div_05_By_16;
begin
  CheckDivRound(5, 16, 3, 0.313);
end;

procedure TCalcDivExactBinary.Div_07_By_16;
begin
  CheckDivRound(7, 16, 3, 0.438);
end;

procedure TCalcDivExactBinary.Div_09_By_16;
begin
  CheckDivRound(9, 16, 3, 0.563);
end;

procedure TCalcDivExactBinary.Div_11_By_16;
begin
  CheckDivRound(11, 16, 3, 0.688);
end;

procedure TCalcDivExactBinary.Div_13_By_16;
begin
  CheckDivRound(13, 16, 3, 0.813);
end;

procedure TCalcDivExactBinary.Div_15_By_16;
begin
  CheckDivRound(15, 16, 3, 0.938);
end;

{ TCalcDivRepeating }

procedure TCalcDivRepeating.Div_1_By_7;
begin
  CheckDivRound(1, 7, 2, 0.14);
end;

procedure TCalcDivRepeating.Div_2_By_7;
begin
  CheckDivRound(2, 7, 2, 0.29);
end;

procedure TCalcDivRepeating.Div_3_By_7;
begin
  CheckDivRound(3, 7, 2, 0.43);
end;

procedure TCalcDivRepeating.Div_4_By_7;
begin
  CheckDivRound(4, 7, 2, 0.57);
end;

procedure TCalcDivRepeating.Div_5_By_7;
begin
  CheckDivRound(5, 7, 2, 0.71);
end;

procedure TCalcDivRepeating.Div_6_By_7;
begin
  CheckDivRound(6, 7, 2, 0.86);
end;

procedure TCalcDivRepeating.Div_8_By_7;
begin
  CheckDivRound(8, 7, 2, 1.14);
end;

procedure TCalcDivRepeating.Div_9_By_7;
begin
  CheckDivRound(9, 7, 2, 1.29);
end;

procedure TCalcDivRepeating.Div_10_By_7;
begin
  CheckDivRound(10, 7, 2, 1.43);
end;

procedure TCalcDivRepeating.Div_11_By_7;
begin
  CheckDivRound(11, 7, 2, 1.57);
end;

procedure TCalcDivRepeating.Div_12_By_7;
begin
  CheckDivRound(12, 7, 2, 1.71);
end;

procedure TCalcDivRepeating.Div_13_By_7;
begin
  CheckDivRound(13, 7, 2, 1.86);
end;

procedure TCalcDivRepeating.Div_1_By_9;
begin
  CheckDivRound(1, 9, 2, 0.11);
end;

procedure TCalcDivRepeating.Div_2_By_9;
begin
  CheckDivRound(2, 9, 2, 0.22);
end;

procedure TCalcDivRepeating.Div_3_By_9;
begin
  CheckDivRound(3, 9, 2, 0.33);
end;

procedure TCalcDivRepeating.Div_4_By_9;
begin
  CheckDivRound(4, 9, 2, 0.44);
end;

procedure TCalcDivRepeating.Div_5_By_9;
begin
  CheckDivRound(5, 9, 2, 0.56);
end;

procedure TCalcDivRepeating.Div_6_By_9;
begin
  CheckDivRound(6, 9, 2, 0.67);
end;

procedure TCalcDivRepeating.Div_7_By_9;
begin
  CheckDivRound(7, 9, 2, 0.78);
end;

procedure TCalcDivRepeating.Div_8_By_9;
begin
  CheckDivRound(8, 9, 2, 0.89);
end;

procedure TCalcDivRepeating.Div_1_By_11;
begin
  CheckDivRound(1, 11, 2, 0.09);
end;

procedure TCalcDivRepeating.Div_2_By_11;
begin
  CheckDivRound(2, 11, 2, 0.18);
end;

procedure TCalcDivRepeating.Div_3_By_11;
begin
  CheckDivRound(3, 11, 2, 0.27);
end;

procedure TCalcDivRepeating.Div_4_By_11;
begin
  CheckDivRound(4, 11, 2, 0.36);
end;

procedure TCalcDivRepeating.Div_5_By_11;
begin
  CheckDivRound(5, 11, 2, 0.45);
end;

procedure TCalcDivRepeating.Div_6_By_11;
begin
  CheckDivRound(6, 11, 2, 0.55);
end;

procedure TCalcDivRepeating.Div_7_By_11;
begin
  CheckDivRound(7, 11, 2, 0.64);
end;

procedure TCalcDivRepeating.Div_8_By_11;
begin
  CheckDivRound(8, 11, 2, 0.73);
end;

procedure TCalcDivRepeating.Div_9_By_11;
begin
  CheckDivRound(9, 11, 2, 0.82);
end;

procedure TCalcDivRepeating.Div_10_By_11;
begin
  CheckDivRound(10, 11, 2, 0.91);
end;

procedure TCalcDivRepeating.Div_1_By_3;
begin
  CheckDivRound(1, 3, 2, 0.33);
end;

procedure TCalcDivRepeating.Div_2_By_3;
begin
  CheckDivRound(2, 3, 2, 0.67);
end;

procedure TCalcDivRepeating.Div_4_By_3;
begin
  CheckDivRound(4, 3, 2, 1.33);
end;

procedure TCalcDivRepeating.Div_5_By_3;
begin
  CheckDivRound(5, 3, 2, 1.67);
end;

procedure TCalcDivRepeating.Div_7_By_3;
begin
  CheckDivRound(7, 3, 2, 2.33);
end;

procedure TCalcDivRepeating.Div_8_By_3;
begin
  CheckDivRound(8, 3, 2, 2.67);
end;

procedure TCalcDivRepeating.Div_10_By_3;
begin
  CheckDivRound(10, 3, 2, 3.33);
end;

procedure TCalcDivRepeating.Div_100_By_3;
begin
  CheckDivRound(100, 3, 2, 33.33);
end;

procedure TCalcDivRepeating.Div_1000_By_3;
begin
  CheckDivRound(1000, 3, 2, 333.33);
end;

procedure TCalcDivRepeating.Div_10000_By_3;
begin
  CheckDivRound(10000, 3, 2, 3333.33);
end;

procedure TCalcDivRepeating.Div_1_By_6;
begin
  CheckDivRound(1, 6, 2, 0.17);
end;

procedure TCalcDivRepeating.Div_5_By_6;
begin
  CheckDivRound(5, 6, 2, 0.83);
end;

procedure TCalcDivRepeating.Div_7_By_6;
begin
  CheckDivRound(7, 6, 2, 1.17);
end;

procedure TCalcDivRepeating.Div_11_By_6;
begin
  CheckDivRound(11, 6, 2, 1.83);
end;

procedure TCalcDivRepeating.Div_100_By_6;
begin
  CheckDivRound(100, 6, 2, 16.67);
end;

procedure TCalcDivRepeating.Div_1000_By_6;
begin
  CheckDivRound(1000, 6, 2, 166.67);
end;

procedure TCalcDivRepeating.Div_100_By_7;
begin
  CheckDivRound(100, 7, 2, 14.29);
end;

procedure TCalcDivRepeating.Div_1000_By_7;
begin
  CheckDivRound(1000, 7, 2, 142.86);
end;

procedure TCalcDivRepeating.Div_100_By_11;
begin
  CheckDivRound(100, 11, 2, 9.09);
end;

procedure TCalcDivRepeating.Div_100_By_13;
begin
  CheckDivRound(100, 13, 2, 7.69);
end;

procedure TCalcDivRepeating.Div_1000_By_13;
begin
  CheckDivRound(1000, 13, 2, 76.92);
end;

procedure TCalcDivRepeating.Div_100_By_17;
begin
  CheckDivRound(100, 17, 2, 5.88);
end;

procedure TCalcDivRepeating.Div_100_By_19;
begin
  CheckDivRound(100, 19, 2, 5.26);
end;

procedure TCalcDivRepeating.Div_100_By_23;
begin
  CheckDivRound(100, 23, 2, 4.35);
end;

procedure TCalcDivRepeating.Div_Neg_1_By_3;
begin
  CheckDivRound(-1, 3, 2, -0.33);
end;

procedure TCalcDivRepeating.Div_Neg_2_By_3;
begin
  CheckDivRound(-2, 3, 2, -0.67);
end;

procedure TCalcDivRepeating.Div_Neg_1_By_7;
begin
  CheckDivRound(-1, 7, 2, -0.14);
end;

procedure TCalcDivRepeating.Div_Neg_5_By_9;
begin
  CheckDivRound(-5, 9, 2, -0.56);
end;

procedure TCalcDivRepeating.Div_Neg_6_By_11;
begin
  CheckDivRound(-6, 11, 2, -0.55);
end;

procedure TCalcDivRepeating.Div_Neg_100_By_3;
begin
  CheckDivRound(-100, 3, 2, -33.33);
end;

{ TCalcDivLadders }

procedure TCalcDivLadders.Div_1_By_7_At0dp;
begin
  CheckDivRound(1, 7, 0, 0);
end;

procedure TCalcDivLadders.Div_1_By_7_At1dp;
begin
  CheckDivRound(1, 7, 1, 0.1);
end;

procedure TCalcDivLadders.Div_1_By_7_At2dp;
begin
  CheckDivRound(1, 7, 2, 0.14);
end;

procedure TCalcDivLadders.Div_1_By_7_At3dp;
begin
  CheckDivRound(1, 7, 3, 0.143);
end;

procedure TCalcDivLadders.Div_1_By_7_At4dp;
begin
  CheckDivRound(1, 7, 4, 0.1429);
end;

procedure TCalcDivLadders.Div_1_By_7_At5dp;
begin
  CheckDivRound(1, 7, 5, 0.14286);
end;

procedure TCalcDivLadders.Div_1_By_7_At6dp;
begin
  CheckDivRound(1, 7, 6, 0.142857);
end;

procedure TCalcDivLadders.Div_22_By_7_At0dp;
begin
  CheckDivRound(22, 7, 0, 3);
end;

procedure TCalcDivLadders.Div_22_By_7_At1dp;
begin
  CheckDivRound(22, 7, 1, 3.1);
end;

procedure TCalcDivLadders.Div_22_By_7_At2dp;
begin
  CheckDivRound(22, 7, 2, 3.14);
end;

procedure TCalcDivLadders.Div_22_By_7_At3dp;
begin
  CheckDivRound(22, 7, 3, 3.143);
end;

procedure TCalcDivLadders.Div_22_By_7_At4dp;
begin
  CheckDivRound(22, 7, 4, 3.1429);
end;

procedure TCalcDivLadders.Div_22_By_7_At5dp;
begin
  CheckDivRound(22, 7, 5, 3.14286);
end;

procedure TCalcDivLadders.Div_22_By_7_At6dp;
begin
  CheckDivRound(22, 7, 6, 3.142857);
end;

procedure TCalcDivLadders.Div_2_By_3_At0dp;
begin
  CheckDivRound(2, 3, 0, 1);
end;

procedure TCalcDivLadders.Div_2_By_3_At1dp;
begin
  CheckDivRound(2, 3, 1, 0.7);
end;

procedure TCalcDivLadders.Div_2_By_3_At2dp;
begin
  CheckDivRound(2, 3, 2, 0.67);
end;

procedure TCalcDivLadders.Div_2_By_3_At3dp;
begin
  CheckDivRound(2, 3, 3, 0.667);
end;

procedure TCalcDivLadders.Div_2_By_3_At4dp;
begin
  CheckDivRound(2, 3, 4, 0.6667);
end;

procedure TCalcDivLadders.Div_2_By_3_At5dp;
begin
  CheckDivRound(2, 3, 5, 0.66667);
end;

procedure TCalcDivLadders.Div_5_By_6_At0dp;
begin
  CheckDivRound(5, 6, 0, 1);
end;

procedure TCalcDivLadders.Div_5_By_6_At1dp;
begin
  CheckDivRound(5, 6, 1, 0.8);
end;

procedure TCalcDivLadders.Div_5_By_6_At2dp;
begin
  CheckDivRound(5, 6, 2, 0.83);
end;

procedure TCalcDivLadders.Div_5_By_6_At3dp;
begin
  CheckDivRound(5, 6, 3, 0.833);
end;

procedure TCalcDivLadders.Div_5_By_6_At4dp;
begin
  CheckDivRound(5, 6, 4, 0.8333);
end;

procedure TCalcDivLadders.Div_5_By_6_At5dp;
begin
  CheckDivRound(5, 6, 5, 0.83333);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcDivExactBinary);
  TDUnitX.RegisterTestFixture(TCalcDivRepeating);
  TDUnitX.RegisterTestFixture(TCalcDivLadders);

end.
