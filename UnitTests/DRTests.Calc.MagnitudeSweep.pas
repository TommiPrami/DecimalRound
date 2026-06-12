unit DRTests.Calc.MagnitudeSweep;

{ GENERATED test data (one-shot script; safe to edit by hand).

  Calculated tie values swept from large negative through small to
  large positive magnitudes (1E0 .. 1E15 for integer ties, 1E0 .. 1E12
  for 2-decimal cent ties). Each decade is a genuinely different case:
  the binary representation error of the fractional part grows with
  the magnitude, and Win32 (x87 Extended intermediates) and Win64
  (SSE Double) can land on different sides of the boundary. The
  magnitudes beyond these ranges (no fractional information left in a
  Double) are covered by the identity tests in DRTests.DecimalRound
  (TDecimalRoundSpecialValues). One case per test method. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TCalcSweepAddHalf = class
  { 10^k + 0.5 computed at runtime: an exact tie at the integer boundary
    at every decade up to 1E15 (the last decade where X.5 is exactly
    representable in Double), positive and negative. Half-up must go
    away from zero at every magnitude on both Win32 and Win64. }
  public
    [Test] procedure AddHalf_1E00;    // 1 + 0.5 -> tie -> 2
    [Test] procedure AddHalf_Neg_1E00;    // -> -2
    [Test] procedure AddHalf_1E01;    // 10 + 0.5 -> tie -> 11
    [Test] procedure AddHalf_Neg_1E01;    // -> -11
    [Test] procedure AddHalf_1E02;    // 100 + 0.5 -> tie -> 101
    [Test] procedure AddHalf_Neg_1E02;    // -> -101
    [Test] procedure AddHalf_1E03;    // 1000 + 0.5 -> tie -> 1001
    [Test] procedure AddHalf_Neg_1E03;    // -> -1001
    [Test] procedure AddHalf_1E04;    // 10000 + 0.5 -> tie -> 10001
    [Test] procedure AddHalf_Neg_1E04;    // -> -10001
    [Test] procedure AddHalf_1E05;    // 100000 + 0.5 -> tie -> 100001
    [Test] procedure AddHalf_Neg_1E05;    // -> -100001
    [Test] procedure AddHalf_1E06;    // 1000000 + 0.5 -> tie -> 1000001
    [Test] procedure AddHalf_Neg_1E06;    // -> -1000001
    [Test] procedure AddHalf_1E07;    // 10000000 + 0.5 -> tie -> 10000001
    [Test] procedure AddHalf_Neg_1E07;    // -> -10000001
    [Test] procedure AddHalf_1E08;    // 100000000 + 0.5 -> tie -> 100000001
    [Test] procedure AddHalf_Neg_1E08;    // -> -100000001
    [Test] procedure AddHalf_1E09;    // 1000000000 + 0.5 -> tie -> 1000000001
    [Test] procedure AddHalf_Neg_1E09;    // -> -1000000001
    [Test] procedure AddHalf_1E10;    // 10000000000 + 0.5 -> tie -> 10000000001
    [Test] procedure AddHalf_Neg_1E10;    // -> -10000000001
    [Test] procedure AddHalf_1E11;    // 100000000000 + 0.5 -> tie -> 100000000001
    [Test] procedure AddHalf_Neg_1E11;    // -> -100000000001
    [Test] procedure AddHalf_1E12;    // 1000000000000 + 0.5 -> tie -> 1000000000001
    [Test] procedure AddHalf_Neg_1E12;    // -> -1000000000001
    [Test] procedure AddHalf_1E13;    // 10000000000000 + 0.5 -> tie -> 10000000000001
    [Test] procedure AddHalf_Neg_1E13;    // -> -10000000000001
    [Test] procedure AddHalf_1E14;    // 100000000000000 + 0.5 -> tie -> 100000000000001
    [Test] procedure AddHalf_Neg_1E14;    // -> -100000000000001
    [Test] procedure AddHalf_1E15;    // 1000000000000000 + 0.5 -> tie -> 1000000000000001
    [Test] procedure AddHalf_Neg_1E15;    // -> -1000000000000001
  end;

  [TestFixture]
  TCalcSweepDivHalf = class
  { (2 * 10^k + 1) / 2 reaches the same integer-boundary ties as the
    addition sweep, but through runtime division — a different FPU/SSE
    code path arriving at the identical exact tie. }
  public
    [Test] procedure DivHalf_1E00;    // 3 / 2 -> tie -> 2
    [Test] procedure DivHalf_Neg_1E00;    // -> -2
    [Test] procedure DivHalf_1E01;    // 21 / 2 -> tie -> 11
    [Test] procedure DivHalf_Neg_1E01;    // -> -11
    [Test] procedure DivHalf_1E02;    // 201 / 2 -> tie -> 101
    [Test] procedure DivHalf_Neg_1E02;    // -> -101
    [Test] procedure DivHalf_1E03;    // 2001 / 2 -> tie -> 1001
    [Test] procedure DivHalf_Neg_1E03;    // -> -1001
    [Test] procedure DivHalf_1E04;    // 20001 / 2 -> tie -> 10001
    [Test] procedure DivHalf_Neg_1E04;    // -> -10001
    [Test] procedure DivHalf_1E05;    // 200001 / 2 -> tie -> 100001
    [Test] procedure DivHalf_Neg_1E05;    // -> -100001
    [Test] procedure DivHalf_1E06;    // 2000001 / 2 -> tie -> 1000001
    [Test] procedure DivHalf_Neg_1E06;    // -> -1000001
    [Test] procedure DivHalf_1E07;    // 20000001 / 2 -> tie -> 10000001
    [Test] procedure DivHalf_Neg_1E07;    // -> -10000001
    [Test] procedure DivHalf_1E08;    // 200000001 / 2 -> tie -> 100000001
    [Test] procedure DivHalf_Neg_1E08;    // -> -100000001
    [Test] procedure DivHalf_1E09;    // 2000000001 / 2 -> tie -> 1000000001
    [Test] procedure DivHalf_Neg_1E09;    // -> -1000000001
    [Test] procedure DivHalf_1E10;    // 20000000001 / 2 -> tie -> 10000000001
    [Test] procedure DivHalf_Neg_1E10;    // -> -10000000001
    [Test] procedure DivHalf_1E11;    // 200000000001 / 2 -> tie -> 100000000001
    [Test] procedure DivHalf_Neg_1E11;    // -> -100000000001
    [Test] procedure DivHalf_1E12;    // 2000000000001 / 2 -> tie -> 1000000000001
    [Test] procedure DivHalf_Neg_1E12;    // -> -1000000000001
    [Test] procedure DivHalf_1E13;    // 20000000000001 / 2 -> tie -> 10000000000001
    [Test] procedure DivHalf_Neg_1E13;    // -> -10000000000001
    [Test] procedure DivHalf_1E14;    // 200000000000001 / 2 -> tie -> 100000000000001
    [Test] procedure DivHalf_Neg_1E14;    // -> -100000000000001
    [Test] procedure DivHalf_1E15;    // 2000000000000001 / 2 -> tie -> 1000000000000001
    [Test] procedure DivHalf_Neg_1E15;    // -> -1000000000000001
  end;

  [TestFixture]
  TCalcSweepAddCent = class
  { 10^k + 0.045 at 2 decimals: a half-up cent tie at every decade.
    The absolute representation error of the 0.045 part grows with the
    magnitude (about half an ulp of 10^k), but stays within the
    relative error tolerance through 1E12 — the documented safe range
    for 2-decimal ties. }
  public
    [Test] procedure AddCent_1E00;    // 1 + 0.045 -> tie -> 1.05
    [Test] procedure AddCent_Neg_1E00;    // -> -1.05
    [Test] procedure AddCent_1E01;    // 10 + 0.045 -> tie -> 10.05
    [Test] procedure AddCent_Neg_1E01;    // -> -10.05
    [Test] procedure AddCent_1E02;    // 100 + 0.045 -> tie -> 100.05
    [Test] procedure AddCent_Neg_1E02;    // -> -100.05
    [Test] procedure AddCent_1E03;    // 1000 + 0.045 -> tie -> 1000.05
    [Test] procedure AddCent_Neg_1E03;    // -> -1000.05
    [Test] procedure AddCent_1E04;    // 10000 + 0.045 -> tie -> 10000.05
    [Test] procedure AddCent_Neg_1E04;    // -> -10000.05
    [Test] procedure AddCent_1E05;    // 100000 + 0.045 -> tie -> 100000.05
    [Test] procedure AddCent_Neg_1E05;    // -> -100000.05
    [Test] procedure AddCent_1E06;    // 1000000 + 0.045 -> tie -> 1000000.05
    [Test] procedure AddCent_Neg_1E06;    // -> -1000000.05
    [Test] procedure AddCent_1E07;    // 10000000 + 0.045 -> tie -> 10000000.05
    [Test] procedure AddCent_Neg_1E07;    // -> -10000000.05
    [Test] procedure AddCent_1E08;    // 100000000 + 0.045 -> tie -> 100000000.05
    [Test] procedure AddCent_Neg_1E08;    // -> -100000000.05
    [Test] procedure AddCent_1E09;    // 1000000000 + 0.045 -> tie -> 1000000000.05
    [Test] procedure AddCent_Neg_1E09;    // -> -1000000000.05
    [Test] procedure AddCent_1E10;    // 10000000000 + 0.045 -> tie -> 10000000000.05
    [Test] procedure AddCent_Neg_1E10;    // -> -10000000000.05
    [Test] procedure AddCent_1E11;    // 100000000000 + 0.045 -> tie -> 100000000000.05
    [Test] procedure AddCent_Neg_1E11;    // -> -100000000000.05
    [Test] procedure AddCent_1E12;    // 1000000000000 + 0.045 -> tie -> 1000000000000.05
    [Test] procedure AddCent_Neg_1E12;    // -> -1000000000000.05
  end;

  [TestFixture]
  TCalcSweepMulCent = class
  { (2 * 10^k + 1) * 0.045 = 0.09 * 10^k + 0.045 exactly in decimal:
    the multiplication sweep variant of the cent ties, reaching the
    X.045 boundary through a runtime product at every decade. }
  public
    [Test] procedure MulCent_1E00;    // 3 * 0.045 = 0.135 -> tie -> 0.14
    [Test] procedure MulCent_Neg_1E00;    // -> -0.14
    [Test] procedure MulCent_1E01;    // 21 * 0.045 = 0.945 -> tie -> 0.95
    [Test] procedure MulCent_Neg_1E01;    // -> -0.95
    [Test] procedure MulCent_1E02;    // 201 * 0.045 = 9.045 -> tie -> 9.05
    [Test] procedure MulCent_Neg_1E02;    // -> -9.05
    [Test] procedure MulCent_1E03;    // 2001 * 0.045 = 90.045 -> tie -> 90.05
    [Test] procedure MulCent_Neg_1E03;    // -> -90.05
    [Test] procedure MulCent_1E04;    // 20001 * 0.045 = 900.045 -> tie -> 900.05
    [Test] procedure MulCent_Neg_1E04;    // -> -900.05
    [Test] procedure MulCent_1E05;    // 200001 * 0.045 = 9000.045 -> tie -> 9000.05
    [Test] procedure MulCent_Neg_1E05;    // -> -9000.05
    [Test] procedure MulCent_1E06;    // 2000001 * 0.045 = 90000.045 -> tie -> 90000.05
    [Test] procedure MulCent_Neg_1E06;    // -> -90000.05
    [Test] procedure MulCent_1E07;    // 20000001 * 0.045 = 900000.045 -> tie -> 900000.05
    [Test] procedure MulCent_Neg_1E07;    // -> -900000.05
    [Test] procedure MulCent_1E08;    // 200000001 * 0.045 = 9000000.045 -> tie -> 9000000.05
    [Test] procedure MulCent_Neg_1E08;    // -> -9000000.05
    [Test] procedure MulCent_1E09;    // 2000000001 * 0.045 = 90000000.045 -> tie -> 90000000.05
    [Test] procedure MulCent_Neg_1E09;    // -> -90000000.05
    [Test] procedure MulCent_1E10;    // 20000000001 * 0.045 = 900000000.045 -> tie -> 900000000.05
    [Test] procedure MulCent_Neg_1E10;    // -> -900000000.05
    [Test] procedure MulCent_1E11;    // 200000000001 * 0.045 = 9000000000.045 -> tie -> 9000000000.05
    [Test] procedure MulCent_Neg_1E11;    // -> -9000000000.05
    [Test] procedure MulCent_1E12;    // 2000000000001 * 0.045 = 90000000000.045 -> tie -> 90000000000.05
    [Test] procedure MulCent_Neg_1E12;    // -> -90000000000.05
  end;

implementation

uses
  DRTests.CalcHelpers;

{ TCalcSweepAddHalf }

procedure TCalcSweepAddHalf.AddHalf_1E00;
begin
  CheckAddRound(1, 0.5, 0, 2);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E00;
begin
  CheckAddRound(-1, -0.5, 0, -2);
end;

procedure TCalcSweepAddHalf.AddHalf_1E01;
begin
  CheckAddRound(10, 0.5, 0, 11);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E01;
begin
  CheckAddRound(-10, -0.5, 0, -11);
end;

procedure TCalcSweepAddHalf.AddHalf_1E02;
begin
  CheckAddRound(100, 0.5, 0, 101);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E02;
begin
  CheckAddRound(-100, -0.5, 0, -101);
end;

procedure TCalcSweepAddHalf.AddHalf_1E03;
begin
  CheckAddRound(1000, 0.5, 0, 1001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E03;
begin
  CheckAddRound(-1000, -0.5, 0, -1001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E04;
begin
  CheckAddRound(10000, 0.5, 0, 10001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E04;
begin
  CheckAddRound(-10000, -0.5, 0, -10001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E05;
begin
  CheckAddRound(100000, 0.5, 0, 100001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E05;
begin
  CheckAddRound(-100000, -0.5, 0, -100001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E06;
begin
  CheckAddRound(1000000, 0.5, 0, 1000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E06;
begin
  CheckAddRound(-1000000, -0.5, 0, -1000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E07;
begin
  CheckAddRound(10000000, 0.5, 0, 10000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E07;
begin
  CheckAddRound(-10000000, -0.5, 0, -10000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E08;
begin
  CheckAddRound(100000000, 0.5, 0, 100000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E08;
begin
  CheckAddRound(-100000000, -0.5, 0, -100000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E09;
begin
  CheckAddRound(1000000000, 0.5, 0, 1000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E09;
begin
  CheckAddRound(-1000000000, -0.5, 0, -1000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E10;
begin
  CheckAddRound(10000000000, 0.5, 0, 10000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E10;
begin
  CheckAddRound(-10000000000, -0.5, 0, -10000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E11;
begin
  CheckAddRound(100000000000, 0.5, 0, 100000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E11;
begin
  CheckAddRound(-100000000000, -0.5, 0, -100000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E12;
begin
  CheckAddRound(1000000000000, 0.5, 0, 1000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E12;
begin
  CheckAddRound(-1000000000000, -0.5, 0, -1000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E13;
begin
  CheckAddRound(10000000000000, 0.5, 0, 10000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E13;
begin
  CheckAddRound(-10000000000000, -0.5, 0, -10000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E14;
begin
  CheckAddRound(100000000000000, 0.5, 0, 100000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E14;
begin
  CheckAddRound(-100000000000000, -0.5, 0, -100000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_1E15;
begin
  CheckAddRound(1000000000000000, 0.5, 0, 1000000000000001);
end;

procedure TCalcSweepAddHalf.AddHalf_Neg_1E15;
begin
  CheckAddRound(-1000000000000000, -0.5, 0, -1000000000000001);
end;

{ TCalcSweepDivHalf }

procedure TCalcSweepDivHalf.DivHalf_1E00;
begin
  CheckDivRound(3, 2, 0, 2);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E00;
begin
  CheckDivRound(-3, 2, 0, -2);
end;

procedure TCalcSweepDivHalf.DivHalf_1E01;
begin
  CheckDivRound(21, 2, 0, 11);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E01;
begin
  CheckDivRound(-21, 2, 0, -11);
end;

procedure TCalcSweepDivHalf.DivHalf_1E02;
begin
  CheckDivRound(201, 2, 0, 101);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E02;
begin
  CheckDivRound(-201, 2, 0, -101);
end;

procedure TCalcSweepDivHalf.DivHalf_1E03;
begin
  CheckDivRound(2001, 2, 0, 1001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E03;
begin
  CheckDivRound(-2001, 2, 0, -1001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E04;
begin
  CheckDivRound(20001, 2, 0, 10001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E04;
begin
  CheckDivRound(-20001, 2, 0, -10001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E05;
begin
  CheckDivRound(200001, 2, 0, 100001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E05;
begin
  CheckDivRound(-200001, 2, 0, -100001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E06;
begin
  CheckDivRound(2000001, 2, 0, 1000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E06;
begin
  CheckDivRound(-2000001, 2, 0, -1000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E07;
begin
  CheckDivRound(20000001, 2, 0, 10000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E07;
begin
  CheckDivRound(-20000001, 2, 0, -10000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E08;
begin
  CheckDivRound(200000001, 2, 0, 100000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E08;
begin
  CheckDivRound(-200000001, 2, 0, -100000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E09;
begin
  CheckDivRound(2000000001, 2, 0, 1000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E09;
begin
  CheckDivRound(-2000000001, 2, 0, -1000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E10;
begin
  CheckDivRound(20000000001, 2, 0, 10000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E10;
begin
  CheckDivRound(-20000000001, 2, 0, -10000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E11;
begin
  CheckDivRound(200000000001, 2, 0, 100000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E11;
begin
  CheckDivRound(-200000000001, 2, 0, -100000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E12;
begin
  CheckDivRound(2000000000001, 2, 0, 1000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E12;
begin
  CheckDivRound(-2000000000001, 2, 0, -1000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E13;
begin
  CheckDivRound(20000000000001, 2, 0, 10000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E13;
begin
  CheckDivRound(-20000000000001, 2, 0, -10000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E14;
begin
  CheckDivRound(200000000000001, 2, 0, 100000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E14;
begin
  CheckDivRound(-200000000000001, 2, 0, -100000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_1E15;
begin
  CheckDivRound(2000000000000001, 2, 0, 1000000000000001);
end;

procedure TCalcSweepDivHalf.DivHalf_Neg_1E15;
begin
  CheckDivRound(-2000000000000001, 2, 0, -1000000000000001);
end;

{ TCalcSweepAddCent }

procedure TCalcSweepAddCent.AddCent_1E00;
begin
  CheckAddRound(1, 0.045, 2, 1.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E00;
begin
  CheckAddRound(-1, -0.045, 2, -1.05);
end;

procedure TCalcSweepAddCent.AddCent_1E01;
begin
  CheckAddRound(10, 0.045, 2, 10.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E01;
begin
  CheckAddRound(-10, -0.045, 2, -10.05);
end;

procedure TCalcSweepAddCent.AddCent_1E02;
begin
  CheckAddRound(100, 0.045, 2, 100.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E02;
begin
  CheckAddRound(-100, -0.045, 2, -100.05);
end;

procedure TCalcSweepAddCent.AddCent_1E03;
begin
  CheckAddRound(1000, 0.045, 2, 1000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E03;
begin
  CheckAddRound(-1000, -0.045, 2, -1000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E04;
begin
  CheckAddRound(10000, 0.045, 2, 10000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E04;
begin
  CheckAddRound(-10000, -0.045, 2, -10000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E05;
begin
  CheckAddRound(100000, 0.045, 2, 100000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E05;
begin
  CheckAddRound(-100000, -0.045, 2, -100000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E06;
begin
  CheckAddRound(1000000, 0.045, 2, 1000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E06;
begin
  CheckAddRound(-1000000, -0.045, 2, -1000000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E07;
begin
  CheckAddRound(10000000, 0.045, 2, 10000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E07;
begin
  CheckAddRound(-10000000, -0.045, 2, -10000000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E08;
begin
  CheckAddRound(100000000, 0.045, 2, 100000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E08;
begin
  CheckAddRound(-100000000, -0.045, 2, -100000000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E09;
begin
  CheckAddRound(1000000000, 0.045, 2, 1000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E09;
begin
  CheckAddRound(-1000000000, -0.045, 2, -1000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E10;
begin
  CheckAddRound(10000000000, 0.045, 2, 10000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E10;
begin
  CheckAddRound(-10000000000, -0.045, 2, -10000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E11;
begin
  CheckAddRound(100000000000, 0.045, 2, 100000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E11;
begin
  CheckAddRound(-100000000000, -0.045, 2, -100000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_1E12;
begin
  CheckAddRound(1000000000000, 0.045, 2, 1000000000000.05);
end;

procedure TCalcSweepAddCent.AddCent_Neg_1E12;
begin
  CheckAddRound(-1000000000000, -0.045, 2, -1000000000000.05);
end;

{ TCalcSweepMulCent }

procedure TCalcSweepMulCent.MulCent_1E00;
begin
  CheckMulRound(3, 0.045, 2, 0.14);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E00;
begin
  CheckMulRound(-3, 0.045, 2, -0.14);
end;

procedure TCalcSweepMulCent.MulCent_1E01;
begin
  CheckMulRound(21, 0.045, 2, 0.95);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E01;
begin
  CheckMulRound(-21, 0.045, 2, -0.95);
end;

procedure TCalcSweepMulCent.MulCent_1E02;
begin
  CheckMulRound(201, 0.045, 2, 9.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E02;
begin
  CheckMulRound(-201, 0.045, 2, -9.05);
end;

procedure TCalcSweepMulCent.MulCent_1E03;
begin
  CheckMulRound(2001, 0.045, 2, 90.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E03;
begin
  CheckMulRound(-2001, 0.045, 2, -90.05);
end;

procedure TCalcSweepMulCent.MulCent_1E04;
begin
  CheckMulRound(20001, 0.045, 2, 900.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E04;
begin
  CheckMulRound(-20001, 0.045, 2, -900.05);
end;

procedure TCalcSweepMulCent.MulCent_1E05;
begin
  CheckMulRound(200001, 0.045, 2, 9000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E05;
begin
  CheckMulRound(-200001, 0.045, 2, -9000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E06;
begin
  CheckMulRound(2000001, 0.045, 2, 90000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E06;
begin
  CheckMulRound(-2000001, 0.045, 2, -90000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E07;
begin
  CheckMulRound(20000001, 0.045, 2, 900000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E07;
begin
  CheckMulRound(-20000001, 0.045, 2, -900000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E08;
begin
  CheckMulRound(200000001, 0.045, 2, 9000000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E08;
begin
  CheckMulRound(-200000001, 0.045, 2, -9000000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E09;
begin
  CheckMulRound(2000000001, 0.045, 2, 90000000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E09;
begin
  CheckMulRound(-2000000001, 0.045, 2, -90000000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E10;
begin
  CheckMulRound(20000000001, 0.045, 2, 900000000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E10;
begin
  CheckMulRound(-20000000001, 0.045, 2, -900000000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E11;
begin
  CheckMulRound(200000000001, 0.045, 2, 9000000000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E11;
begin
  CheckMulRound(-200000000001, 0.045, 2, -9000000000.05);
end;

procedure TCalcSweepMulCent.MulCent_1E12;
begin
  CheckMulRound(2000000000001, 0.045, 2, 90000000000.05);
end;

procedure TCalcSweepMulCent.MulCent_Neg_1E12;
begin
  CheckMulRound(-2000000000001, 0.045, 2, -90000000000.05);
end;

initialization
  TDUnitX.RegisterTestFixture(TCalcSweepAddHalf);
  TDUnitX.RegisterTestFixture(TCalcSweepDivHalf);
  TDUnitX.RegisterTestFixture(TCalcSweepAddCent);
  TDUnitX.RegisterTestFixture(TCalcSweepMulCent);

end.
