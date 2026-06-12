unit DRTests.Calc.Composite;

{ Composite calculated inputs: a * b + c / g, a * b - c / g and (a + b) * c.

  Every expected value is derived from EXACT decimal arithmetic (e.g.
  1.23 * 3 + 1/8 = 3.69 + 0.125 = 3.815, a half-up tie at 2 decimals
  -> 3.82). The floating point computation lands within the library's
  error tolerance of that exact decimal value on both Win32 (x87/Extended
  intermediates) and Win64 (SSE/Double), so the rounded result must be
  identical on both platforms.

  One case per test method — a failure pinpoints exactly one expression. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcMulAddDiv = class
  public
    [Test] procedure MulAdd_1_23_x_3_Plus_1_Div_8;       // 3.69  + 0.125  = 3.815  @2 -> 3.82
    [Test] procedure MulAdd_2_07_x_5_Plus_3_Div_8;       // 10.35 + 0.375  = 10.725 @2 -> 10.73
    [Test] procedure MulAdd_0_7_x_7_Plus_1_Div_4;        // 4.9   + 0.25   = 5.15   @1 -> 5.2
    [Test] procedure MulAdd_1_1_x_9_Plus_1_Div_2;        // 9.9   + 0.5    = 10.4   @0 -> 10
    [Test] procedure MulAdd_3_3_x_3_Plus_1_Div_8;        // 9.9   + 0.125  = 10.025 @2 -> 10.03
    [Test] procedure MulAdd_0_05_x_9_Plus_1_Div_8;       // 0.45  + 0.125  = 0.575  @2 -> 0.58
    [Test] procedure MulAdd_2_2_x_2_Plus_1_Div_16;       // 4.4   + 0.0625 = 4.4625 @3 -> 4.463
    [Test] procedure MulAdd_1_01_x_5_Plus_1_Div_2;       // 5.05  + 0.5    = 5.55   @1 -> 5.6
    [Test] procedure MulAdd_0_3_x_3_Plus_1_Div_3;        // 0.9   + 0.333..= 1.2333 @2 -> 1.23
    [Test] procedure MulAdd_2_5_x_2_Plus_2_Div_3;        // 5.0   + 0.666..= 5.6667 @2 -> 5.67
    [Test] procedure MulAdd_0_1_x_5_Plus_1_Div_2;        // 0.5   + 0.5    = 1.0    @2 -> 1
    [Test] procedure MulAdd_1_05_x_2_Plus_1_Div_4;       // 2.1   + 0.25   = 2.35   @1 -> 2.4
    [Test] procedure MulAdd_0_45_x_3_Plus_1_Div_8;       // 1.35  + 0.125  = 1.475  @2 -> 1.48
    [Test] procedure MulAdd_6_6_x_5_Plus_1_Div_4;        // 33.0  + 0.25   = 33.25  @1 -> 33.3
    [Test] procedure MulAdd_0_005_x_5_Plus_1_Div_8;      // 0.025 + 0.125  = 0.15   @1 -> 0.2
    [Test] procedure MulAdd_12_34_x_5_Plus_3_Div_4;      // 61.7  + 0.75   = 62.45  @1 -> 62.5
    [Test] procedure MulAdd_9_99_x_9_Plus_1_Div_10;      // 89.91 + 0.1    = 90.01  @1 -> 90
    [Test] procedure MulAdd_0_95_x_2_Plus_1_Div_8;       // 1.9   + 0.125  = 2.025  @2 -> 2.03

    // Negative mirrors: -(a*b) + (-c)/g — half-up ties go away from zero.
    [Test] procedure MulAdd_Neg_1_23_x_3_Minus_1_Div_8;  // -3.815  @2 -> -3.82
    [Test] procedure MulAdd_Neg_2_07_x_5_Minus_3_Div_8;  // -10.725 @2 -> -10.73
    [Test] procedure MulAdd_Neg_0_7_x_7_Minus_1_Div_4;   // -5.15   @1 -> -5.2
    [Test] procedure MulAdd_Neg_3_3_x_3_Minus_1_Div_8;   // -10.025 @2 -> -10.03
    [Test] procedure MulAdd_Neg_0_05_x_9_Minus_1_Div_8;  // -0.575  @2 -> -0.58
    [Test] procedure MulAdd_Neg_2_2_x_2_Minus_1_Div_16;  // -4.4625 @3 -> -4.463
  end;

  [TestFixture]
  TCalcMulSubDiv = class
  public
    [Test] procedure MulSub_5_x_2_Minus_1_Div_8;         // 10.0  - 0.125 = 9.875  @2 -> 9.88
    [Test] procedure MulSub_1_5_x_3_Minus_1_Div_4;       // 4.5   - 0.25  = 4.25   @1 -> 4.3
    [Test] procedure MulSub_0_7_x_10_Minus_1_Div_2;      // 7.0   - 0.5   = 6.5    @0 -> 7
    [Test] procedure MulSub_2_22_x_5_Minus_1_Div_8;      // 11.1  - 0.125 = 10.975 @2 -> 10.98
    [Test] procedure MulSub_10_01_x_3_Minus_1_Div_2;     // 30.03 - 0.5   = 29.53  @1 -> 29.5
    [Test] procedure MulSub_1_005_x_100_Minus_1_Div_2;   // 100.5 - 0.5   = 100.0  @0 -> 100
    [Test] procedure MulSub_Neg_5_x_2_Plus_1_Div_8;      // -10 + 0.125   = -9.875 @2 -> -9.88
    [Test] procedure MulSub_Neg_2_22_x_5_Plus_1_Div_8;   // -11.1 + 0.125 = -10.975 @2 -> -10.98
  end;

  [TestFixture]
  TCalcAddMul = class
  public
    [Test] procedure AddMul_0_1_Plus_0_2_x_10;           // 0.30000000000000004 * 10 @2 -> 3
    [Test] procedure AddMul_0_7_Plus_0_1_x_10;           // 0.7999999999999999  * 10 @0 -> 8
    [Test] procedure AddMul_1_1_Plus_2_2_x_3;            // 3.3000000000000003  * 3  @1 -> 9.9
    [Test] procedure AddMul_0_05_Plus_0_05_x_7;          // 0.1 * 7 = 0.7000000000000001 @1 -> 0.7
    [Test] procedure AddMul_1_05_Plus_1_2_x_2;           // 2.25 * 2 = 4.5 @0 -> 5
    [Test] procedure AddMul_0_15_Plus_0_3_x_5;           // 0.45 * 5 = 2.25 @1 -> 2.3
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcMulAddDiv }

procedure TCalcMulAddDiv.MulAdd_1_23_x_3_Plus_1_Div_8;
begin
  CheckMulAddDivRound(1.23, 3, 1, 8, 2, 3.82);
end;

procedure TCalcMulAddDiv.MulAdd_2_07_x_5_Plus_3_Div_8;
begin
  CheckMulAddDivRound(2.07, 5, 3, 8, 2, 10.73);
end;

procedure TCalcMulAddDiv.MulAdd_0_7_x_7_Plus_1_Div_4;
begin
  CheckMulAddDivRound(0.7, 7, 1, 4, 1, 5.2);
end;

procedure TCalcMulAddDiv.MulAdd_1_1_x_9_Plus_1_Div_2;
begin
  CheckMulAddDivRound(1.1, 9, 1, 2, 0, 10);
end;

procedure TCalcMulAddDiv.MulAdd_3_3_x_3_Plus_1_Div_8;
begin
  CheckMulAddDivRound(3.3, 3, 1, 8, 2, 10.03);
end;

procedure TCalcMulAddDiv.MulAdd_0_05_x_9_Plus_1_Div_8;
begin
  CheckMulAddDivRound(0.05, 9, 1, 8, 2, 0.58);
end;

procedure TCalcMulAddDiv.MulAdd_2_2_x_2_Plus_1_Div_16;
begin
  CheckMulAddDivRound(2.2, 2, 1, 16, 3, 4.463);
end;

procedure TCalcMulAddDiv.MulAdd_1_01_x_5_Plus_1_Div_2;
begin
  CheckMulAddDivRound(1.01, 5, 1, 2, 1, 5.6);
end;

procedure TCalcMulAddDiv.MulAdd_0_3_x_3_Plus_1_Div_3;
begin
  CheckMulAddDivRound(0.3, 3, 1, 3, 2, 1.23);
end;

procedure TCalcMulAddDiv.MulAdd_2_5_x_2_Plus_2_Div_3;
begin
  CheckMulAddDivRound(2.5, 2, 2, 3, 2, 5.67);
end;

procedure TCalcMulAddDiv.MulAdd_0_1_x_5_Plus_1_Div_2;
begin
  CheckMulAddDivRound(0.1, 5, 1, 2, 2, 1);
end;

procedure TCalcMulAddDiv.MulAdd_1_05_x_2_Plus_1_Div_4;
begin
  CheckMulAddDivRound(1.05, 2, 1, 4, 1, 2.4);
end;

procedure TCalcMulAddDiv.MulAdd_0_45_x_3_Plus_1_Div_8;
begin
  CheckMulAddDivRound(0.45, 3, 1, 8, 2, 1.48);
end;

procedure TCalcMulAddDiv.MulAdd_6_6_x_5_Plus_1_Div_4;
begin
  CheckMulAddDivRound(6.6, 5, 1, 4, 1, 33.3);
end;

procedure TCalcMulAddDiv.MulAdd_0_005_x_5_Plus_1_Div_8;
begin
  CheckMulAddDivRound(0.005, 5, 1, 8, 1, 0.2);
end;

procedure TCalcMulAddDiv.MulAdd_12_34_x_5_Plus_3_Div_4;
begin
  CheckMulAddDivRound(12.34, 5, 3, 4, 1, 62.5);
end;

procedure TCalcMulAddDiv.MulAdd_9_99_x_9_Plus_1_Div_10;
begin
  CheckMulAddDivRound(9.99, 9, 1, 10, 1, 90);
end;

procedure TCalcMulAddDiv.MulAdd_0_95_x_2_Plus_1_Div_8;
begin
  CheckMulAddDivRound(0.95, 2, 1, 8, 2, 2.03);
end;

procedure TCalcMulAddDiv.MulAdd_Neg_1_23_x_3_Minus_1_Div_8;
begin
  CheckMulAddDivRound(-1.23, 3, -1, 8, 2, -3.82);
end;

procedure TCalcMulAddDiv.MulAdd_Neg_2_07_x_5_Minus_3_Div_8;
begin
  CheckMulAddDivRound(-2.07, 5, -3, 8, 2, -10.73);
end;

procedure TCalcMulAddDiv.MulAdd_Neg_0_7_x_7_Minus_1_Div_4;
begin
  CheckMulAddDivRound(-0.7, 7, -1, 4, 1, -5.2);
end;

procedure TCalcMulAddDiv.MulAdd_Neg_3_3_x_3_Minus_1_Div_8;
begin
  CheckMulAddDivRound(-3.3, 3, -1, 8, 2, -10.03);
end;

procedure TCalcMulAddDiv.MulAdd_Neg_0_05_x_9_Minus_1_Div_8;
begin
  CheckMulAddDivRound(-0.05, 9, -1, 8, 2, -0.58);
end;

procedure TCalcMulAddDiv.MulAdd_Neg_2_2_x_2_Minus_1_Div_16;
begin
  CheckMulAddDivRound(-2.2, 2, -1, 16, 3, -4.463);
end;

{ TCalcMulSubDiv }

procedure TCalcMulSubDiv.MulSub_5_x_2_Minus_1_Div_8;
begin
  CheckMulSubDivRound(5, 2, 1, 8, 2, 9.88);
end;

procedure TCalcMulSubDiv.MulSub_1_5_x_3_Minus_1_Div_4;
begin
  CheckMulSubDivRound(1.5, 3, 1, 4, 1, 4.3);
end;

procedure TCalcMulSubDiv.MulSub_0_7_x_10_Minus_1_Div_2;
begin
  CheckMulSubDivRound(0.7, 10, 1, 2, 0, 7);
end;

procedure TCalcMulSubDiv.MulSub_2_22_x_5_Minus_1_Div_8;
begin
  CheckMulSubDivRound(2.22, 5, 1, 8, 2, 10.98);
end;

procedure TCalcMulSubDiv.MulSub_10_01_x_3_Minus_1_Div_2;
begin
  CheckMulSubDivRound(10.01, 3, 1, 2, 1, 29.5);
end;

procedure TCalcMulSubDiv.MulSub_1_005_x_100_Minus_1_Div_2;
begin
  CheckMulSubDivRound(1.005, 100, 1, 2, 0, 100);
end;

procedure TCalcMulSubDiv.MulSub_Neg_5_x_2_Plus_1_Div_8;
begin
  CheckMulSubDivRound(-5, 2, -1, 8, 2, -9.88);
end;

procedure TCalcMulSubDiv.MulSub_Neg_2_22_x_5_Plus_1_Div_8;
begin
  CheckMulSubDivRound(-2.22, 5, -1, 8, 2, -10.98);
end;

{ TCalcAddMul }

procedure TCalcAddMul.AddMul_0_1_Plus_0_2_x_10;
begin
  CheckAddMulRound(0.1, 0.2, 10, 2, 3);
end;

procedure TCalcAddMul.AddMul_0_7_Plus_0_1_x_10;
begin
  CheckAddMulRound(0.7, 0.1, 10, 0, 8);
end;

procedure TCalcAddMul.AddMul_1_1_Plus_2_2_x_3;
begin
  CheckAddMulRound(1.1, 2.2, 3, 1, 9.9);
end;

procedure TCalcAddMul.AddMul_0_05_Plus_0_05_x_7;
begin
  CheckAddMulRound(0.05, 0.05, 7, 1, 0.7);
end;

procedure TCalcAddMul.AddMul_1_05_Plus_1_2_x_2;
begin
  CheckAddMulRound(1.05, 1.2, 2, 0, 5);
end;

procedure TCalcAddMul.AddMul_0_15_Plus_0_3_x_5;
begin
  CheckAddMulRound(0.15, 0.3, 5, 1, 2.3);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcMulAddDiv);
  TDUnitX.RegisterTestFixture(TCalcMulSubDiv);
  TDUnitX.RegisterTestFixture(TCalcAddMul);

end.
