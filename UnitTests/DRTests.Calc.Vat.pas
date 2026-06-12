unit DRTests.Calc.Vat;

{ Financial-style calculated inputs: net * (1 + VAT rate), gross / (1 + rate)
  and unit-price divisions. Prices with 2 decimals multiplied by rates with
  2 decimals give exact 4-decimal products, several of which sit exactly on
  the half-up tie boundary at 2 decimals (e.g. 2.50 * 1.07 = 2.675 -> 2.68,
  the classic case naive Round(x*100)/100 gets wrong).

  The computed Double lands within the library's error tolerance of the
  exact decimal product/quotient on both Win32 (x87) and Win64 (SSE), so
  every assertion must hold identically on both platforms.

  One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcVatMultiply = class
  public
    [Test] procedure Mul_19_99_x_1_24;     // 24.7876  @2 -> 24.79
    [Test] procedure Mul_9_95_x_1_24;      // 12.338   @2 -> 12.34
    [Test] procedure Mul_4_99_x_1_255;     // 6.26245  @2 -> 6.26
    [Test] procedure Mul_1_50_x_1_21;      // 1.815    @2 -> 1.82  (tie)
    [Test] procedure Mul_2_50_x_1_07;      // 2.675    @2 -> 2.68  (tie, classic)
    [Test] procedure Mul_1_25_x_1_10;      // 1.375    @2 -> 1.38  (tie)
    [Test] procedure Mul_3_75_x_1_10;      // 4.125    @2 -> 4.13  (tie)
    [Test] procedure Mul_6_25_x_1_22;      // 7.625    @2 -> 7.63  (tie)
    [Test] procedure Mul_1_05_x_1_50;      // 1.575    @2 -> 1.58  (tie)
    [Test] procedure Mul_2_45_x_1_50;      // 3.675    @2 -> 3.68  (tie)
    [Test] procedure Mul_4_45_x_0_70;      // 3.115    @2 -> 3.12  (tie)
    [Test] procedure Mul_2_05_x_1_10;      // 2.255    @2 -> 2.26  (tie)
    [Test] procedure Mul_3_65_x_0_30;      // 1.095    @2 -> 1.10  (tie)
    [Test] procedure Mul_0_99_x_1_24;      // 1.2276   @2 -> 1.23
    [Test] procedure Mul_123_45_x_1_24;    // 153.078  @2 -> 153.08
    [Test] procedure Mul_19_99_x_1_255;    // 25.08745 @2 -> 25.09
    [Test] procedure Mul_49_90_x_1_14;     // 56.886   @2 -> 56.89
    [Test] procedure Mul_0_10_x_1_24;      // 0.124    @2 -> 0.12
    [Test] procedure Mul_0_05_x_1_24;      // 0.062    @2 -> 0.06
    [Test] procedure Mul_7_77_x_1_24;      // 9.6348   @2 -> 9.63
    [Test] procedure Mul_Neg_19_99_x_1_24; // -24.7876 @2 -> -24.79
    [Test] procedure Mul_Neg_2_50_x_1_07;  // -2.675   @2 -> -2.68 (tie away from zero)
  end;

  [TestFixture]
  TCalcVatDivide = class
  public
    [Test] procedure Div_24_8_By_1_24;     // 20 exact     @2 -> 20
    [Test] procedure Div_12_4_By_1_24;     // 10 exact     @2 -> 10
    [Test] procedure Div_6_2_By_1_24;      // 5 exact      @2 -> 5
    [Test] procedure Div_2_48_By_1_24;     // 2 exact      @2 -> 2
    [Test] procedure Div_1_24_By_1_24;     // 1 exact      @2 -> 1
    [Test] procedure Div_124_By_1_24;      // 100 exact    @2 -> 100
    [Test] procedure Div_100_By_1_24;      // 80.645161..  @2 -> 80.65
    [Test] procedure Div_99_99_By_1_24;    // 80.637096..  @2 -> 80.64
    [Test] procedure Div_19_99_By_1_24;    // 16.120967..  @2 -> 16.12
    [Test] procedure Div_9_95_By_1_255;    // 7.9282868..  @2 -> 7.93
    [Test] procedure Div_10_By_3;          // 3.3333..     @2 -> 3.33
    [Test] procedure Div_20_By_3;          // 6.6666..     @2 -> 6.67
    [Test] procedure Div_100_By_7;         // 14.285714..  @2 -> 14.29
    [Test] procedure Div_25_By_6;          // 4.16666..    @2 -> 4.17
    [Test] procedure Div_1_By_24;          // 0.0416666..  @2 -> 0.04
    [Test] procedure Div_99_95_By_3;       // 33.31666..   @2 -> 33.32
    [Test] procedure Div_Neg_24_8_By_1_24; // -20 exact    @2 -> -20
    [Test] procedure Div_Neg_10_By_3;      // -3.3333..    @2 -> -3.33
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcVatMultiply }

procedure TCalcVatMultiply.Mul_19_99_x_1_24;
begin
  CheckMulRound(19.99, 1.24, 2, 24.79);
end;

procedure TCalcVatMultiply.Mul_9_95_x_1_24;
begin
  CheckMulRound(9.95, 1.24, 2, 12.34);
end;

procedure TCalcVatMultiply.Mul_4_99_x_1_255;
begin
  CheckMulRound(4.99, 1.255, 2, 6.26);
end;

procedure TCalcVatMultiply.Mul_1_50_x_1_21;
begin
  CheckMulRound(1.50, 1.21, 2, 1.82);
end;

procedure TCalcVatMultiply.Mul_2_50_x_1_07;
begin
  CheckMulRound(2.50, 1.07, 2, 2.68);
end;

procedure TCalcVatMultiply.Mul_1_25_x_1_10;
begin
  CheckMulRound(1.25, 1.10, 2, 1.38);
end;

procedure TCalcVatMultiply.Mul_3_75_x_1_10;
begin
  CheckMulRound(3.75, 1.10, 2, 4.13);
end;

procedure TCalcVatMultiply.Mul_6_25_x_1_22;
begin
  CheckMulRound(6.25, 1.22, 2, 7.63);
end;

procedure TCalcVatMultiply.Mul_1_05_x_1_50;
begin
  CheckMulRound(1.05, 1.50, 2, 1.58);
end;

procedure TCalcVatMultiply.Mul_2_45_x_1_50;
begin
  CheckMulRound(2.45, 1.50, 2, 3.68);
end;

procedure TCalcVatMultiply.Mul_4_45_x_0_70;
begin
  CheckMulRound(4.45, 0.70, 2, 3.12);
end;

procedure TCalcVatMultiply.Mul_2_05_x_1_10;
begin
  CheckMulRound(2.05, 1.10, 2, 2.26);
end;

procedure TCalcVatMultiply.Mul_3_65_x_0_30;
begin
  CheckMulRound(3.65, 0.30, 2, 1.1);
end;

procedure TCalcVatMultiply.Mul_0_99_x_1_24;
begin
  CheckMulRound(0.99, 1.24, 2, 1.23);
end;

procedure TCalcVatMultiply.Mul_123_45_x_1_24;
begin
  CheckMulRound(123.45, 1.24, 2, 153.08);
end;

procedure TCalcVatMultiply.Mul_19_99_x_1_255;
begin
  CheckMulRound(19.99, 1.255, 2, 25.09);
end;

procedure TCalcVatMultiply.Mul_49_90_x_1_14;
begin
  CheckMulRound(49.90, 1.14, 2, 56.89);
end;

procedure TCalcVatMultiply.Mul_0_10_x_1_24;
begin
  CheckMulRound(0.10, 1.24, 2, 0.12);
end;

procedure TCalcVatMultiply.Mul_0_05_x_1_24;
begin
  CheckMulRound(0.05, 1.24, 2, 0.06);
end;

procedure TCalcVatMultiply.Mul_7_77_x_1_24;
begin
  CheckMulRound(7.77, 1.24, 2, 9.63);
end;

procedure TCalcVatMultiply.Mul_Neg_19_99_x_1_24;
begin
  CheckMulRound(-19.99, 1.24, 2, -24.79);
end;

procedure TCalcVatMultiply.Mul_Neg_2_50_x_1_07;
begin
  CheckMulRound(-2.50, 1.07, 2, -2.68);
end;

{ TCalcVatDivide }

procedure TCalcVatDivide.Div_24_8_By_1_24;
begin
  CheckDivRound(24.8, 1.24, 2, 20);
end;

procedure TCalcVatDivide.Div_12_4_By_1_24;
begin
  CheckDivRound(12.4, 1.24, 2, 10);
end;

procedure TCalcVatDivide.Div_6_2_By_1_24;
begin
  CheckDivRound(6.2, 1.24, 2, 5);
end;

procedure TCalcVatDivide.Div_2_48_By_1_24;
begin
  CheckDivRound(2.48, 1.24, 2, 2);
end;

procedure TCalcVatDivide.Div_1_24_By_1_24;
begin
  CheckDivRound(1.24, 1.24, 2, 1);
end;

procedure TCalcVatDivide.Div_124_By_1_24;
begin
  CheckDivRound(124, 1.24, 2, 100);
end;

procedure TCalcVatDivide.Div_100_By_1_24;
begin
  CheckDivRound(100, 1.24, 2, 80.65);
end;

procedure TCalcVatDivide.Div_99_99_By_1_24;
begin
  CheckDivRound(99.99, 1.24, 2, 80.64);
end;

procedure TCalcVatDivide.Div_19_99_By_1_24;
begin
  CheckDivRound(19.99, 1.24, 2, 16.12);
end;

procedure TCalcVatDivide.Div_9_95_By_1_255;
begin
  CheckDivRound(9.95, 1.255, 2, 7.93);
end;

procedure TCalcVatDivide.Div_10_By_3;
begin
  CheckDivRound(10, 3, 2, 3.33);
end;

procedure TCalcVatDivide.Div_20_By_3;
begin
  CheckDivRound(20, 3, 2, 6.67);
end;

procedure TCalcVatDivide.Div_100_By_7;
begin
  CheckDivRound(100, 7, 2, 14.29);
end;

procedure TCalcVatDivide.Div_25_By_6;
begin
  CheckDivRound(25, 6, 2, 4.17);
end;

procedure TCalcVatDivide.Div_1_By_24;
begin
  CheckDivRound(1, 24, 2, 0.04);
end;

procedure TCalcVatDivide.Div_99_95_By_3;
begin
  CheckDivRound(99.95, 3, 2, 33.32);
end;

procedure TCalcVatDivide.Div_Neg_24_8_By_1_24;
begin
  CheckDivRound(-24.8, 1.24, 2, -20);
end;

procedure TCalcVatDivide.Div_Neg_10_By_3;
begin
  CheckDivRound(-10, 3, 2, -3.33);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcVatMultiply);
  TDUnitX.RegisterTestFixture(TCalcVatDivide);

end.
