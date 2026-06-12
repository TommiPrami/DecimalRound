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
    [Test] procedure Fpu_IsOkForRounding;
    [Test] procedure PowerOfTenLookup_HasExpectedPositiveValues;
    [Test] procedure PowerOfTenLookup_NegativeIndicesMirrorPositive;
    [Test] procedure PowerOfTenLookup_ZeroIsOne;
    [Test] procedure PowerOfTenLookup_TopIndexIs1E19;
  end;

implementation

uses
  System.SysUtils, DRUnit.Consts, DRUnit.Utils;

procedure TSanityTests.Fpu_IsOkForRounding;
begin
  { On Win32 this reflects the x87 control word; on Win64 the SSE MXCSR
    register — both via IsFpuCwOkForRounding. }
  Assert.IsTrue(IsFpuCwOkForRounding,
    'Floating point unit is not configured for round-to-nearest-even at the precision DecimalRound assumes. '
    + 'Results will be off. Current state: ' + FpuSettingsToString);
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

procedure TSanityTests.PowerOfTenLookup_TopIndexIs1E19;
begin
  { 10^19 is exactly representable in both Double and Extended, so the
    iteratively built table must hit it exactly. }
  Assert.AreEqual(ROUND_FLOAT_MAX_DECIMAL_COUNT, High(gPowerOfTenMultipliers));
  Assert.AreEqual(-ROUND_FLOAT_MAX_DECIMAL_COUNT, Low(gPowerOfTenMultipliers));
  Assert.AreEqual<Extended>(1E19, gPowerOfTenMultipliers[ROUND_FLOAT_MAX_DECIMAL_COUNT]);
end;

initialization
  TDUnitX.RegisterTestFixture(TSanityTests);

end.
