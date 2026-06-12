unit DRTests.Calc.AddSub;

{ Sums and differences of decimal fractions. Classics like 0.1 + 0.2
  (= 0.30000000000000004 in Double) land just OVER the intended decimal,
  1.0 - 0.9 (= 0.09999999999999998) lands just UNDER it; the result also
  differs in the last bits between Win32 (x87) and Win64 (SSE). DecimalRound
  must snap both to the intended decimal on both platforms.

  Subtraction cases are chosen so the intended result is either a value
  exactly representable at the rounding precision (cell centre — immune to
  the cancellation-amplified relative error) or a tie whose inherited
  absolute error stays within the library's tolerance.

  One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcAdd = class
  public
    [Test] procedure Add_0_1_Plus_0_2;          // 0.30000000000000004 @2 -> 0.30
    [Test] procedure Add_0_1_Plus_0_7;          // 0.7999999999999999  @2 -> 0.80
    [Test] procedure Add_0_3_Plus_0_6;          // 0.8999999999999999  @2 -> 0.90
    [Test] procedure Add_1_1_Plus_2_2;          // 3.3000000000000003  @2 -> 3.30
    [Test] procedure Add_0_07_Plus_0_01;        // 0.08 @2 -> 0.08
    [Test] procedure Add_0_29_Plus_0_01;        // 0.30 @2 -> 0.30
    [Test] procedure Add_1_005_Plus_2_005;      // 3.01 @2 -> 3.01
    [Test] procedure Add_0_025_Plus_0_02;       // 0.045 tie @2 -> 0.05
    [Test] procedure Add_0_005_Plus_0_01;       // 0.015 tie @2 -> 0.02
    [Test] procedure Add_1_0025_Plus_1_0025;    // 2.005 tie @2 -> 2.01
    [Test] procedure Add_0_555_Plus_0_555;      // 1.11 @2 -> 1.11
    [Test] procedure Add_9_99_Plus_0_01;        // 10.00 @2 -> 10
    [Test] procedure Add_0_045_Plus_0_045;      // 0.09 @2 -> 0.09
    [Test] procedure Add_1_115_Plus_1_115;      // 2.23 @2 -> 2.23
    [Test] procedure Add_Neg_0_1_Minus_0_2;     // -0.30000000000000004 @2 -> -0.30
    [Test] procedure Add_Neg_0_025_Minus_0_02;  // -0.045 tie @2 -> -0.05
    [Test] procedure Add_Neg_0_005_Minus_0_01;  // -0.015 tie @2 -> -0.02
    [Test] procedure Add_Neg_1_Plus_0_9;        // -0.09999999999999998 @2 -> -0.10
  end;

  [TestFixture]
  TCalcSub = class
  public
    [Test] procedure Sub_1_Minus_0_9;           // 0.09999999999999998 @2 -> 0.10
    [Test] procedure Sub_0_3_Minus_0_1;         // 0.19999999999999998 @2 -> 0.20
    [Test] procedure Sub_2_Minus_1_1;           // 0.8999999999999999  @2 -> 0.90
    [Test] procedure Sub_10_Minus_9_99;         // 0.01 @2 -> 0.01
    [Test] procedure Sub_1_Minus_0_999;         // 0.001 @3 -> 0.001
    [Test] procedure Sub_5_05_Minus_0_05;       // 5.00 @2 -> 5
    [Test] procedure Sub_0_45_Minus_0_4;        // 0.05 @2 -> 0.05
    [Test] procedure Sub_100_Minus_0_005;       // 99.995 tie @2 -> 100
    [Test] procedure Sub_3_Minus_2_7;           // 0.29999999999999982 @1 -> 0.3
    [Test] procedure Sub_1_5_Minus_0_45;        // 1.05 @2 -> 1.05
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcAdd }

procedure TCalcAdd.Add_0_1_Plus_0_2;
begin
  CheckAddRound(0.1, 0.2, 2, 0.3);
end;

procedure TCalcAdd.Add_0_1_Plus_0_7;
begin
  CheckAddRound(0.1, 0.7, 2, 0.8);
end;

procedure TCalcAdd.Add_0_3_Plus_0_6;
begin
  CheckAddRound(0.3, 0.6, 2, 0.9);
end;

procedure TCalcAdd.Add_1_1_Plus_2_2;
begin
  CheckAddRound(1.1, 2.2, 2, 3.3);
end;

procedure TCalcAdd.Add_0_07_Plus_0_01;
begin
  CheckAddRound(0.07, 0.01, 2, 0.08);
end;

procedure TCalcAdd.Add_0_29_Plus_0_01;
begin
  CheckAddRound(0.29, 0.01, 2, 0.3);
end;

procedure TCalcAdd.Add_1_005_Plus_2_005;
begin
  CheckAddRound(1.005, 2.005, 2, 3.01);
end;

procedure TCalcAdd.Add_0_025_Plus_0_02;
begin
  CheckAddRound(0.025, 0.02, 2, 0.05);
end;

procedure TCalcAdd.Add_0_005_Plus_0_01;
begin
  CheckAddRound(0.005, 0.01, 2, 0.02);
end;

procedure TCalcAdd.Add_1_0025_Plus_1_0025;
begin
  CheckAddRound(1.0025, 1.0025, 2, 2.01);
end;

procedure TCalcAdd.Add_0_555_Plus_0_555;
begin
  CheckAddRound(0.555, 0.555, 2, 1.11);
end;

procedure TCalcAdd.Add_9_99_Plus_0_01;
begin
  CheckAddRound(9.99, 0.01, 2, 10);
end;

procedure TCalcAdd.Add_0_045_Plus_0_045;
begin
  CheckAddRound(0.045, 0.045, 2, 0.09);
end;

procedure TCalcAdd.Add_1_115_Plus_1_115;
begin
  CheckAddRound(1.115, 1.115, 2, 2.23);
end;

procedure TCalcAdd.Add_Neg_0_1_Minus_0_2;
begin
  CheckAddRound(-0.1, -0.2, 2, -0.3);
end;

procedure TCalcAdd.Add_Neg_0_025_Minus_0_02;
begin
  CheckAddRound(-0.025, -0.02, 2, -0.05);
end;

procedure TCalcAdd.Add_Neg_0_005_Minus_0_01;
begin
  CheckAddRound(-0.005, -0.01, 2, -0.02);
end;

procedure TCalcAdd.Add_Neg_1_Plus_0_9;
begin
  CheckAddRound(-1.0, 0.9, 2, -0.1);
end;

{ TCalcSub }

procedure TCalcSub.Sub_1_Minus_0_9;
begin
  CheckSubRound(1.0, 0.9, 2, 0.1);
end;

procedure TCalcSub.Sub_0_3_Minus_0_1;
begin
  CheckSubRound(0.3, 0.1, 2, 0.2);
end;

procedure TCalcSub.Sub_2_Minus_1_1;
begin
  CheckSubRound(2.0, 1.1, 2, 0.9);
end;

procedure TCalcSub.Sub_10_Minus_9_99;
begin
  CheckSubRound(10.0, 9.99, 2, 0.01);
end;

procedure TCalcSub.Sub_1_Minus_0_999;
begin
  CheckSubRound(1.0, 0.999, 3, 0.001);
end;

procedure TCalcSub.Sub_5_05_Minus_0_05;
begin
  CheckSubRound(5.05, 0.05, 2, 5);
end;

procedure TCalcSub.Sub_0_45_Minus_0_4;
begin
  CheckSubRound(0.45, 0.4, 2, 0.05);
end;

procedure TCalcSub.Sub_100_Minus_0_005;
begin
  CheckSubRound(100.0, 0.005, 2, 100);
end;

procedure TCalcSub.Sub_3_Minus_2_7;
begin
  CheckSubRound(3.0, 2.7, 1, 0.3);
end;

procedure TCalcSub.Sub_1_5_Minus_0_45;
begin
  CheckSubRound(1.5, 0.45, 2, 1.05);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcAdd);
  TDUnitX.RegisterTestFixture(TCalcSub);

end.
