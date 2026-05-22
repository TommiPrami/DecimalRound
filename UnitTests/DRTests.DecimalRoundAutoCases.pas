unit DRTests.DecimalRoundAutoCases;

{ Data-driven (AutoNameTestCase) regression sweep for DecimalRound.
  One row per (input, expected) pair — DUnitX generates a distinctly named
  test for each row, so when one fails you see the exact offending input
  in the report without needing to step through.

  The cases cover:
    - Trivial rounding (1.001, 3.33333)
    - Extremely small values down through subnormals — must round to 0.00
      regardless of magnitude or sign
    - Boundary points near integers (1.999999, 2.00001)
    - The notorious "X.095" boundary at increasing magnitudes (positive
      and negative). Half-up rounding must always go away from zero
      (-> X.10) — this is where many naive RTL/RoundTo implementations
      flip between correct and incorrect results as the magnitude grows. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TDecimalRoundAutoCases = class
  public
    [Test]
    [AutoNameTestCase('1.001,1.00')]
    [AutoNameTestCase('3.33333,3.33')]
    [AutoNameTestCase('0.00000000000000000000001,0.00')]
    [AutoNameTestCase('-0.00000000000000000000001,0.00')]
    [AutoNameTestCase('0.0000000000000000000000000000000001,0.00')]
    [AutoNameTestCase('0.0000000000000000000000000000000000000000000001,0.00')]
    [AutoNameTestCase('0.0000000000000000000000000000000000000000000000000000000000001,0.00')]
    [AutoNameTestCase('0.0000000000000000000000000000000000000000000000000000000000000000000000001,0.00')]
    [AutoNameTestCase('-0.000000000000000000000000000000000000000000000000000000000000000000000001,0.00')]
    [AutoNameTestCase('1.999999,2.00')]
    [AutoNameTestCase('2.00001,2.00')]
    [AutoNameTestCase('2.095,2.10')]
    [AutoNameTestCase('92.095,92.10')]
    [AutoNameTestCase('992.095,992.10')]
    [AutoNameTestCase('9992.095,9992.10')]
    [AutoNameTestCase('99992.095,99992.10')]
    [AutoNameTestCase('999992.095,999992.10')]
    [AutoNameTestCase('9999992.095,9999992.10')]
    [AutoNameTestCase('99999992.095,99999992.10')]
    [AutoNameTestCase('999999992.095,999999992.10')]
    [AutoNameTestCase('9999999992.095,9999999992.10')]
    [AutoNameTestCase('99999999992.095,99999999992.10')]
    [AutoNameTestCase('999999999992.095,999999999992.10')]
    [AutoNameTestCase('-992.095,-992.10')]
    [AutoNameTestCase('-9992.095,-9992.10')]
    [AutoNameTestCase('-99992.095,-99992.10')]
    [AutoNameTestCase('-999992.095,-999992.10')]
    [AutoNameTestCase('-9999992.095,-9999992.10')]
    [AutoNameTestCase('-99999992.095,-99999992.10')]
    [AutoNameTestCase('-999999992.095,-999999992.10')]
    [AutoNameTestCase('-9999999992.095,-9999999992.10')]
    [AutoNameTestCase('-99999999992.095,-99999999992.10')]
    [AutoNameTestCase('-999999999992.095,-999999999992.10')]
    [Category('auto')]
    procedure DecimalRound_Case(const AInputValue, AExpectedValue: Double);
  end;

implementation

uses
  System.SysUtils, DRUnit.Round;

procedure TDecimalRoundAutoCases.DecimalRound_Case(const AInputValue, AExpectedValue: Double);
var
  LRoundedValue: Double;
begin
  LRoundedValue := DecimalRound(AInputValue);

  Assert.AreEqual(AExpectedValue, LRoundedValue, 0.00,
    Format('DecimalRound(%g) returned %g, expected %g',
      [AInputValue, LRoundedValue, AExpectedValue]));
end;

initialization
  TDUnitX.RegisterTestFixture(TDecimalRoundAutoCases);

end.
