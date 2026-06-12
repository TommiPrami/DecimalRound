unit DRTests.CalcHelpers;

{ Shared one-line assertion helpers for the "calculated input" test units
  (DRTests.Calc.*).

  THE POINT OF THESE HELPERS: the operands arrive as runtime Double
  parameters, so the arithmetic (A * B, A / B, A * B + C / G, ...) is
  performed by generated code of the platform under test — x87 with 80-bit
  Extended intermediates on Win32, SSE with pure 64-bit Double arithmetic on
  Win64. The same expression can therefore land just under or just over the
  intended decimal value depending on the platform; DecimalRound must absorb
  that difference and produce the same result on both.

  If a test wrote the whole expression with literals (e.g.
  DecimalRound(85 * 0.045)) the compiler would fold the arithmetic at
  compile time and the platform difference would never be exercised. Keeping
  the arithmetic here, on parameters the compiler cannot see through,
  guarantees real runtime FPU/SSE code paths. }

interface

uses
  DRUnit.Types;

procedure CheckMulRound(const ALeft, ARight: Double; const ADecimals: Integer; const AExpected: Extended);
procedure CheckDivRound(const ADividend, ADivisor: Double; const ADecimals: Integer; const AExpected: Extended);
procedure CheckAddRound(const ALeft, ARight: Double; const ADecimals: Integer; const AExpected: Extended);
procedure CheckSubRound(const ALeft, ARight: Double; const ADecimals: Integer; const AExpected: Extended);

{ Composite expression helpers — the user-facing pattern "a * b + c / g". }
procedure CheckMulAddDivRound(const AMulLeft, AMulRight, ADividend, ADivisor: Double; const ADecimals: Integer;
  const AExpected: Extended);
procedure CheckMulSubDivRound(const AMulLeft, AMulRight, ADividend, ADivisor: Double; const ADecimals: Integer;
  const AExpected: Extended);
procedure CheckAddMulRound(const AAddLeft, AAddRight, AMulRight: Double; const ADecimals: Integer;
  const AExpected: Extended);

{ DecimalRoundEx variants for verifying the rounding modes on calculated values. }
procedure CheckMulRoundEx(const ALeft, ARight: Double; const ADecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl; const AExpected: Extended);
procedure CheckDivRoundEx(const ADividend, ADivisor: Double; const ADecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl; const AExpected: Extended);

implementation

uses
  System.SysUtils, DUnitX.TestFramework, DRUnit.Consts, DRUnit.Round, DRUnit.RoundEx;

procedure CheckMulRound(const ALeft, ARight: Double; const ADecimals: Integer; const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := ALeft * ARight;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('%g * %g @ %d decimals (computed %.17g)', [ALeft, ARight, ADecimals, LValue]));
end;

procedure CheckDivRound(const ADividend, ADivisor: Double; const ADecimals: Integer; const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := ADividend / ADivisor;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('%g / %g @ %d decimals (computed %.17g)', [ADividend, ADivisor, ADecimals, LValue]));
end;

procedure CheckAddRound(const ALeft, ARight: Double; const ADecimals: Integer; const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := ALeft + ARight;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('%g + %g @ %d decimals (computed %.17g)', [ALeft, ARight, ADecimals, LValue]));
end;

procedure CheckSubRound(const ALeft, ARight: Double; const ADecimals: Integer; const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := ALeft - ARight;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('%g - %g @ %d decimals (computed %.17g)', [ALeft, ARight, ADecimals, LValue]));
end;

procedure CheckMulAddDivRound(const AMulLeft, AMulRight, ADividend, ADivisor: Double; const ADecimals: Integer;
  const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := AMulLeft * AMulRight + ADividend / ADivisor;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('%g * %g + %g / %g @ %d decimals (computed %.17g)',
      [AMulLeft, AMulRight, ADividend, ADivisor, ADecimals, LValue]));
end;

procedure CheckMulSubDivRound(const AMulLeft, AMulRight, ADividend, ADivisor: Double; const ADecimals: Integer;
  const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := AMulLeft * AMulRight - ADividend / ADivisor;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('%g * %g - %g / %g @ %d decimals (computed %.17g)',
      [AMulLeft, AMulRight, ADividend, ADivisor, ADecimals, LValue]));
end;

procedure CheckAddMulRound(const AAddLeft, AAddRight, AMulRight: Double; const ADecimals: Integer;
  const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := (AAddLeft + AAddRight) * AMulRight;

  Assert.AreEqual<Extended>(AExpected, DecimalRound(LValue, ADecimals),
    Format('(%g + %g) * %g @ %d decimals (computed %.17g)',
      [AAddLeft, AAddRight, AMulRight, ADecimals, LValue]));
end;

procedure CheckMulRoundEx(const ALeft, ARight: Double; const ADecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl; const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := ALeft * ARight;

  Assert.AreEqual<Extended>(AExpected, DecimalRoundEx(LValue, ADecimals, ARoundingControl),
    Format('%g * %g @ %d decimals, mode %s (computed %.17g)',
      [ALeft, ARight, ADecimals, ROUNDING_CONTROL_STRINGS[ARoundingControl].Abbreviation, LValue]));
end;

procedure CheckDivRoundEx(const ADividend, ADivisor: Double; const ADecimals: Integer;
  const ARoundingControl: TDecimalRoundingControl; const AExpected: Extended);
var
  LValue: Double;
begin
  LValue := ADividend / ADivisor;

  Assert.AreEqual<Extended>(AExpected, DecimalRoundEx(LValue, ADecimals, ARoundingControl),
    Format('%g / %g @ %d decimals, mode %s (computed %.17g)',
      [ADividend, ADivisor, ADecimals, ROUNDING_CONTROL_STRINGS[ARoundingControl].Abbreviation, LValue]));
end;

end.
