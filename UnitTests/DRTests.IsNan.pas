unit DRTests.IsNan;

{ Regression coverage for DRUnit.Utils.IsNan.

  The earlier implementation classified +/-Infinity as NaN because it only
  checked "value <> 0 AND exponent-bits all-one". These tests guard against
  that bug returning. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TIsNanTests = class
  public
    // Single
    [Test] procedure Single_NaN_IsNan;
    [Test] procedure Single_PositiveInfinity_IsNotNan;
    [Test] procedure Single_NegativeInfinity_IsNotNan;
    [Test] procedure Single_Zero_IsNotNan;
    [Test] procedure Single_NegZero_IsNotNan;
    [Test] procedure Single_OrdinaryValue_IsNotNan;
    [Test] procedure Single_MaxValue_IsNotNan;
    [Test] procedure Single_MinValue_IsNotNan;

    // Double
    [Test] procedure Double_NaN_IsNan;
    [Test] procedure Double_PositiveInfinity_IsNotNan;
    [Test] procedure Double_NegativeInfinity_IsNotNan;
    [Test] procedure Double_Zero_IsNotNan;
    [Test] procedure Double_NegZero_IsNotNan;
    [Test] procedure Double_OrdinaryValue_IsNotNan;
    [Test] procedure Double_MaxValue_IsNotNan;
    [Test] procedure Double_MinValue_IsNotNan;

    // Extended (only built when SUPPORTS_TRUE_EXTENDED, i.e. CPUX86)
{$IF DEFINED(CPUX86)}
    [Test] procedure Extended_NaN_IsNan;
    [Test] procedure Extended_PositiveInfinity_IsNotNan;
    [Test] procedure Extended_NegativeInfinity_IsNotNan;
    [Test] procedure Extended_Zero_IsNotNan;
    [Test] procedure Extended_OrdinaryValue_IsNotNan;
{$ENDIF}
  end;

implementation

uses
  System.Math, System.SysUtils, DRUnit.Utils;

{ ------------------------------------------------------------------ Single }

procedure TIsNanTests.Single_NaN_IsNan;
var
  LValue: Single;
begin
  LValue := System.Math.NaN;
  Assert.IsTrue(DRUnit.Utils.IsNan(LValue), 'NaN Single should be NaN');
end;

procedure TIsNanTests.Single_PositiveInfinity_IsNotNan;
var
  LValue: Single;
begin
  LValue := System.Math.Infinity;
  Assert.IsFalse(DRUnit.Utils.IsNan(LValue), '+Infinity Single must not be classified as NaN');
end;

procedure TIsNanTests.Single_NegativeInfinity_IsNotNan;
var
  LValue: Single;
begin
  LValue := System.Math.NegInfinity;
  Assert.IsFalse(DRUnit.Utils.IsNan(LValue), '-Infinity Single must not be classified as NaN');
end;

procedure TIsNanTests.Single_Zero_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Single(0.0)));
end;

procedure TIsNanTests.Single_NegZero_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Single(-0.0)));
end;

procedure TIsNanTests.Single_OrdinaryValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Single(1.5)));
  Assert.IsFalse(DRUnit.Utils.IsNan(Single(-1.5)));
  Assert.IsFalse(DRUnit.Utils.IsNan(Single(2.245)));
end;

procedure TIsNanTests.Single_MaxValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(MaxSingle));
end;

procedure TIsNanTests.Single_MinValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(MinSingle));
end;

{ ------------------------------------------------------------------ Double }

procedure TIsNanTests.Double_NaN_IsNan;
var
  LValue: Double;
begin
  LValue := System.Math.NaN;
  Assert.IsTrue(DRUnit.Utils.IsNan(LValue), 'NaN Double should be NaN');
end;

procedure TIsNanTests.Double_PositiveInfinity_IsNotNan;
var
  LValue: Double;
begin
  LValue := System.Math.Infinity;
  Assert.IsFalse(DRUnit.Utils.IsNan(LValue), '+Infinity Double must not be classified as NaN');
end;

procedure TIsNanTests.Double_NegativeInfinity_IsNotNan;
var
  LValue: Double;
begin
  LValue := System.Math.NegInfinity;
  Assert.IsFalse(DRUnit.Utils.IsNan(LValue), '-Infinity Double must not be classified as NaN');
end;

procedure TIsNanTests.Double_Zero_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Double(0.0)));
end;

procedure TIsNanTests.Double_NegZero_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Double(-0.0)));
end;

procedure TIsNanTests.Double_OrdinaryValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Double(1.5)));
  Assert.IsFalse(DRUnit.Utils.IsNan(Double(-1.5)));
  Assert.IsFalse(DRUnit.Utils.IsNan(Double(2.245)));
end;

procedure TIsNanTests.Double_MaxValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(MaxDouble));
end;

procedure TIsNanTests.Double_MinValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(MinDouble));
end;

{ ---------------------------------------------------------------- Extended }
{$IF DEFINED(CPUX86)}

procedure TIsNanTests.Extended_NaN_IsNan;
var
  LValue: Extended;
begin
  LValue := System.Math.NaN;
  Assert.IsTrue(DRUnit.Utils.IsNan(LValue), 'NaN Extended should be NaN');
end;

procedure TIsNanTests.Extended_PositiveInfinity_IsNotNan;
var
  LValue: Extended;
begin
  LValue := System.Math.Infinity;
  Assert.IsFalse(DRUnit.Utils.IsNan(LValue), '+Infinity Extended must not be classified as NaN');
end;

procedure TIsNanTests.Extended_NegativeInfinity_IsNotNan;
var
  LValue: Extended;
begin
  LValue := System.Math.NegInfinity;
  Assert.IsFalse(DRUnit.Utils.IsNan(LValue), '-Infinity Extended must not be classified as NaN');
end;

procedure TIsNanTests.Extended_Zero_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Extended(0.0)));
end;

procedure TIsNanTests.Extended_OrdinaryValue_IsNotNan;
begin
  Assert.IsFalse(DRUnit.Utils.IsNan(Extended(1.5)));
  Assert.IsFalse(DRUnit.Utils.IsNan(Extended(-1.5)));
end;

{$ENDIF}

initialization
  TDUnitX.RegisterTestFixture(TIsNanTests);

end.
