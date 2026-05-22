unit DRTests.NextPrevFloat;

{ Regression coverage for NextFloat / PrevFloat.

  Key bug guarded against: PrevFloat(Extended) for input 0 used to return
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
    // PrevFloat(0) sign contract
    [Test] procedure PrevFloat_Single_Of_Zero_Is_Negative;
    [Test] procedure PrevFloat_Double_Of_Zero_Is_Negative;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
    [Test] procedure PrevFloat_Extended_Of_Zero_Is_Negative;
{$ENDIF}

    // NextFloat(0) sign contract
    [Test] procedure NextFloat_Single_Of_Zero_Is_Positive;
    [Test] procedure NextFloat_Double_Of_Zero_Is_Positive;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
    [Test] procedure NextFloat_Extended_Of_Zero_Is_Positive;
{$ENDIF}

    // Inverse: Next(Prev(x)) = x
    [Test] procedure NextOfPrev_Single_Returns_Original;
    [Test] procedure NextOfPrev_Double_Returns_Original;
{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
    [Test] procedure NextOfPrev_Extended_Returns_Original;
{$ENDIF}

    // Strict ordering
    [Test] procedure NextFloat_Single_Returns_Strictly_Greater;
    [Test] procedure NextFloat_Double_Returns_Strictly_Greater;
    [Test] procedure PrevFloat_Single_Returns_Strictly_Less;
    [Test] procedure PrevFloat_Double_Returns_Strictly_Less;
  end;

implementation

uses
  System.SysUtils, System.Math, DRUnit.ExactFloatUtils, DRUnit.Consts;

{ ----------------------------------------------------------- PrevFloat(0) }

procedure TNextPrevFloatTests.PrevFloat_Single_Of_Zero_Is_Negative;
var
  LResult: Single;
begin
  LResult := PrevFloat(Single(0.0));
  Assert.IsTrue(LResult < 0, 'PrevFloat(0: Single) must be < 0');
  Assert.AreEqual<Single>(-MinSingle, LResult);
end;

procedure TNextPrevFloatTests.PrevFloat_Double_Of_Zero_Is_Negative;
var
  LResult: Double;
begin
  LResult := PrevFloat(Double(0.0));
  Assert.IsTrue(LResult < 0, 'PrevFloat(0: Double) must be < 0');
  Assert.AreEqual<Double>(-MinDouble, LResult);
end;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
procedure TNextPrevFloatTests.PrevFloat_Extended_Of_Zero_Is_Negative;
var
  LResult: Extended;
begin
  LResult := PrevFloat(Extended(0.0));

  Assert.IsTrue(LResult < 0, 'PrevFloat(0: Extended) must be < 0 (regression: used to return +MinExtended)');
  Assert.AreEqual<Extended>(-MinExtended, LResult);
end;
{$ENDIF}

{ ----------------------------------------------------------- NextFloat(0) }

procedure TNextPrevFloatTests.NextFloat_Single_Of_Zero_Is_Positive;
var
  LResult: Single;
begin
  LResult := NextFloat(Single(0.0));

  Assert.IsTrue(LResult > 0, 'NextFloat(0: Single) must be > 0');
  Assert.AreEqual<Single>(MinSingle, LResult);
end;

procedure TNextPrevFloatTests.NextFloat_Double_Of_Zero_Is_Positive;
var
  LResult: Double;
begin
  LResult := NextFloat(Double(0.0));

  Assert.IsTrue(LResult > 0, 'NextFloat(0: Double) must be > 0');
  Assert.AreEqual<Double>(MinDouble, LResult);
end;

{$IF DEFINED(SUPPORTS_TRUE_EXTENDED)}
procedure TNextPrevFloatTests.NextFloat_Extended_Of_Zero_Is_Positive;
var
  LResult: Extended;
begin
  LResult := NextFloat(Extended(0.0));

  Assert.IsTrue(LResult > 0, 'NextFloat(0: Extended) must be > 0');
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
    Assert.AreEqual(LValue, NextFloat(PrevFloat(LValue)), EPSILON_SINGLE, Format('Round-trip failed for %g', [LValue]));
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
    Assert.AreEqual(LValue, NextFloat(PrevFloat(LValue)), EPSILON_DOUBLE, Format('Round-trip failed for %g', [LValue]));
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
    Assert.AreEqual(LValue, NextFloat(PrevFloat(LValue)), EPSILON_EXTENDED, Format('Round-trip failed for %g', [LValue]));
  end;
end;
{$ENDIF}

{ Ordering }

procedure TNextPrevFloatTests.NextFloat_Single_Returns_Strictly_Greater;
begin
  Assert.IsTrue(NextFloat(Single(1.0)) > 1.0);
  Assert.IsTrue(NextFloat(Single(-1.0)) > -1.0);
end;

procedure TNextPrevFloatTests.NextFloat_Double_Returns_Strictly_Greater;
begin
  Assert.IsTrue(NextFloat(Double(1.0)) > 1.0);
  Assert.IsTrue(NextFloat(Double(-1.0)) > -1.0);
end;

procedure TNextPrevFloatTests.PrevFloat_Single_Returns_Strictly_Less;
begin
  Assert.IsTrue(PrevFloat(Single(1.0)) < 1.0);
  Assert.IsTrue(PrevFloat(Single(-1.0)) < -1.0);
end;

procedure TNextPrevFloatTests.PrevFloat_Double_Returns_Strictly_Less;
begin
  Assert.IsTrue(PrevFloat(Double(1.0)) < 1.0);
  Assert.IsTrue(PrevFloat(Double(-1.0)) < -1.0);
end;

initialization
  TDUnitX.RegisterTestFixture(TNextPrevFloatTests);

end.
