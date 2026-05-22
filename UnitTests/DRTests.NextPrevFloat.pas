unit DRTests.NextPrevFloat;

{ Regression coverage for NextLargerFloat / NextSmallerFloat.

  Key bug guarded against: NextSmallerFloat(Extended) for input 0 used to return
  +MinExtended instead of -MinExtended. The Double / Single overloads were
  always correct; this fixture pins all three to the same contract. }

interface

{$INCLUDE ..\Source\DecimalRound.inc}

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TNextPrevFloatTests = class
  public
    // NextSmallerFloat(0) sign contract
    [Test] procedure NextSmallerFloat_Single_Of_Zero_Is_Negative;
    [Test] procedure NextSmallerFloat_Double_Of_Zero_Is_Negative;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
    [Test] procedure NextSmallerFloat_Extended_Of_Zero_Is_Negative;
{$ENDIF}

    // NextLargerFloat(0) sign contract
    [Test] procedure NextLargerFloat_Single_Of_Zero_Is_Positive;
    [Test] procedure NextLargerFloat_Double_Of_Zero_Is_Positive;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
    [Test] procedure NextLargerFloat_Extended_Of_Zero_Is_Positive;
{$ENDIF}

    // Inverse: Next(Prev(x)) = x
    [Test] procedure NextOfPrev_Single_Returns_Original;
    [Test] procedure NextOfPrev_Double_Returns_Original;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
    [Test] procedure NextOfPrev_Extended_Returns_Original;
{$ENDIF}

    // Strict ordering
    [Test] procedure NextLargerFloat_Single_Returns_Strictly_Greater;
    [Test] procedure NextLargerFloat_Double_Returns_Strictly_Greater;
    [Test] procedure NextSmallerFloat_Single_Returns_Strictly_Less;
    [Test] procedure NextSmallerFloat_Double_Returns_Strictly_Less;
  end;

implementation

uses
  System.SysUtils, System.Math, DRUnit.ExactFloatUtils, DRUnit.Consts;

{ ----------------------------------------------------------- NextSmallerFloat(0) }

procedure TNextPrevFloatTests.NextSmallerFloat_Single_Of_Zero_Is_Negative;
var
  LResult: Single;
begin
  LResult := NextSmallerFloat(Single(0.0));
  Assert.IsTrue(LResult < 0, 'NextSmallerFloat(0: Single) must be < 0');
  Assert.AreEqual<Single>(-MinSingle, LResult);
end;

procedure TNextPrevFloatTests.NextSmallerFloat_Double_Of_Zero_Is_Negative;
var
  LResult: Double;
begin
  LResult := NextSmallerFloat(Double(0.0));
  Assert.IsTrue(LResult < 0, 'NextSmallerFloat(0: Double) must be < 0');
  Assert.AreEqual<Double>(-MinDouble, LResult);
end;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
procedure TNextPrevFloatTests.NextSmallerFloat_Extended_Of_Zero_Is_Negative;
var
  LResult: Extended;
begin
  LResult := NextSmallerFloat(Extended(0.0));

  Assert.IsTrue(LResult < 0, 'NextSmallerFloat(0: Extended) must be < 0 (regression: used to return +MinExtended)');
  Assert.AreEqual<Extended>(-MinExtended, LResult);
end;
{$ENDIF}

{ ----------------------------------------------------------- NextLargerFloat(0) }

procedure TNextPrevFloatTests.NextLargerFloat_Single_Of_Zero_Is_Positive;
var
  LResult: Single;
begin
  LResult := NextLargerFloat(Single(0.0));

  Assert.IsTrue(LResult > 0, 'NextLargerFloat(0: Single) must be > 0');
  Assert.AreEqual<Single>(MinSingle, LResult);
end;

procedure TNextPrevFloatTests.NextLargerFloat_Double_Of_Zero_Is_Positive;
var
  LResult: Double;
begin
  LResult := NextLargerFloat(Double(0.0));

  Assert.IsTrue(LResult > 0, 'NextLargerFloat(0: Double) must be > 0');
  Assert.AreEqual<Double>(MinDouble, LResult);
end;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
procedure TNextPrevFloatTests.NextLargerFloat_Extended_Of_Zero_Is_Positive;
var
  LResult: Extended;
begin
  LResult := NextLargerFloat(Extended(0.0));

  Assert.IsTrue(LResult > 0, 'NextLargerFloat(0: Extended) must be > 0');
  Assert.AreEqual<Extended>(MinExtended, LResult);
end;
{$ENDIF}

{ Inverse round-trip }

procedure TNextPrevFloatTests.NextOfPrev_Single_Returns_Original;
const
  CSamples: array [0..3] of Single = (1.0, -1.0, 12345.678, -0.0001);
var
  LIndex: Integer;
  LValue: Single;
begin
  for LIndex := Low(CSamples) to High(CSamples) do
  begin
    LValue := CSamples[LIndex];
    Assert.AreEqual(LValue, NextLargerFloat(NextSmallerFloat(LValue)), EPSILON_SINGLE, Format('Round-trip failed for %g', [LValue]));
  end;
end;

procedure TNextPrevFloatTests.NextOfPrev_Double_Returns_Original;
const
  CSamples: array [0..3] of Double = (1.0, -1.0, 12345.6789012345, -0.000001);
var
  LIndex: Integer;
  LValue: Double;
begin
  for LIndex := Low(CSamples) to High(CSamples) do
  begin
    LValue := CSamples[LIndex];
    Assert.AreEqual(LValue, NextLargerFloat(NextSmallerFloat(LValue)), EPSILON_DOUBLE, Format('Round-trip failed for %g', [LValue]));
  end;
end;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
procedure TNextPrevFloatTests.NextOfPrev_Extended_Returns_Original;
const
  CSamples: array [0..3] of Extended = (1.0, -1.0, 12345.6789012345, -0.000001);
var
  LIndex: Integer;
  LValue: Extended;
begin
  for LIndex := Low(CSamples) to High(CSamples) do
  begin
    LValue := CSamples[LIndex];
    Assert.AreEqual(LValue, NextLargerFloat(NextSmallerFloat(LValue)), EPSILON_EXTENDED, Format('Round-trip failed for %g', [LValue]));
  end;
end;
{$ENDIF}

{ Ordering }

procedure TNextPrevFloatTests.NextLargerFloat_Single_Returns_Strictly_Greater;
begin
  Assert.IsTrue(NextLargerFloat(Single(1.00)) > 1.00);
  Assert.IsTrue(NextLargerFloat(Single(-1.00)) > -1.00);
end;

procedure TNextPrevFloatTests.NextLargerFloat_Double_Returns_Strictly_Greater;
begin
  Assert.IsTrue(NextLargerFloat(Double(1.00)) > 1.00);
  Assert.IsTrue(NextLargerFloat(Double(-1.00)) > -1.00);
end;

procedure TNextPrevFloatTests.NextSmallerFloat_Single_Returns_Strictly_Less;
begin
  Assert.IsTrue(NextSmallerFloat(Single(1.00)) < 1.00);
  Assert.IsTrue(NextSmallerFloat(Single(-1.00)) < -1.00);
end;

procedure TNextPrevFloatTests.NextSmallerFloat_Double_Returns_Strictly_Less;
begin
  Assert.IsTrue(NextSmallerFloat(Double(1.00)) < 1.00);
  Assert.IsTrue(NextSmallerFloat(Double(-1.00)) < -1.00);
end;

initialization
  TDUnitX.RegisterTestFixture(TNextPrevFloatTests);

end.
