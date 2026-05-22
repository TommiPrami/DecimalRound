unit DRTests.Sanity;

{ Sanity / environment checks. These fail loudly if the FPU isn't set up
  the way DecimalRound assumes, or if the power-of-ten lookup got
  corrupted at initialization. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TSanityTests = class
  public
    [Test] procedure FpuControlWord_IsOkForRounding;
    [Test] procedure PowerOfTenLookup_HasExpectedPositiveValues;
    [Test] procedure PowerOfTenLookup_NegativeIndicesMirrorPositive;
    [Test] procedure PowerOfTenLookup_ZeroIsOne;
  end;

implementation

uses
  System.SysUtils, DRUnit.Consts, DRUnit.Utils;

procedure TSanityTests.FpuControlWord_IsOkForRounding;
begin
  Assert.IsTrue(IsFpuCwOkForRounding,
    'FPU control word is not configured for bankers rounding / Extended precision. '
    + 'DecimalRound results will be off. Current CW: '
    + Format('$%4.4x', [GetX87CW]));
end;

procedure TSanityTests.PowerOfTenLookup_HasExpectedPositiveValues;
begin
  Assert.AreEqual<Extended>(1.0, gPowerOfTenMultipliers[0]);
  Assert.AreEqual<Extended>(10.0, gPowerOfTenMultipliers[1]);
  Assert.AreEqual<Extended>(100.0, gPowerOfTenMultipliers[2]);
  Assert.AreEqual<Extended>(1000.0, gPowerOfTenMultipliers[3]);
  Assert.AreEqual<Extended>(1000000.0, gPowerOfTenMultipliers[6]);
end;

procedure TSanityTests.PowerOfTenLookup_NegativeIndicesMirrorPositive;
var
  I: Integer;
begin
  for I := -ROUND_FLOAT_MAX_DECIMAL_COUNT to -1 do
    Assert.AreEqual<Extended>(gPowerOfTenMultipliers[Abs(I)], gPowerOfTenMultipliers[I],
      Format('Mirror mismatch at index %d', [I]));
end;

procedure TSanityTests.PowerOfTenLookup_ZeroIsOne;
begin
  Assert.AreEqual<Extended>(1.0, gPowerOfTenMultipliers[0]);
end;

initialization
  TDUnitX.RegisterTestFixture(TSanityTests);

end.
