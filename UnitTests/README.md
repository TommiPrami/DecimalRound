# DecimalRound — Unit Tests (DUnitX)

DUnitX-based test project for the DecimalRound library. Targets **Win32 and Win64**; the suite passes in both Debug and Release configurations.

## Files

| File | Contents |
| --- | --- |
| `DecimalRoundTests.dpr` / `.dproj` | Console DUnitX runner (also TestInsight-friendly via the `TESTINSIGHT` define) |
| `DRTests.IsNan.pas` | Regression coverage for the IsNan / Infinity classification bug |
| `DRTests.DecimalRound.pas` | Main `DecimalRound` (HalfUp) tests, special values (NaN / ±Infinity / huge magnitudes) + slot for private trip-up cases (`TDecimalRoundTrickyCases`) |
| `DRTests.DecimalRoundEx.pas` | Per-mode tests for `DecimalRoundEx` (HalfUp / HalfDown / HalfEven / HalfPos / HalfNeg / RndPos / RndNeg / RndDown / RndUp), plus drcNone / NaN / Infinity / overflow handling in every mode |
| `DRTests.DecimalRoundAutoCases.pas` | Data-driven regression sweep (one named test per input/expected pair) |
| `DRTests.Sanity.pas` | FPU configuration + `gPowerOfTenMultipliers` lookup sanity |
| `DRTests.UiUtils.pas` | Coverage for the `LoadDecimalRoundingCtrlAbbrs` combobox helper |
| `DRTests.CalcHelpers.pas` | One-line assertion helpers for the `DRTests.Calc.*` units; operands pass through runtime `Double` parameters so the arithmetic really executes on the platform FPU (x87 on Win32, SSE on Win64) instead of being constant-folded by the compiler |
| `DRTests.Calc.MultiplyTies.pas` | N × 0.045 / 0.015 / 0.005 for odd N — 150 half-up tie products, positive and negative |
| `DRTests.Calc.Times100.pas` | X.XX5 × 100 near-integer products (e.g. 1.005 × 100 = 100.49999999999999) and (K + 0.5) / 100 tie quotients |
| `DRTests.Calc.Divide.pas` | Exact binary ties (n/2, n/4, n/8, n/16), repeating decimals (n/3, n/7, n/9, n/11, …) and per-decimal-count ladders |
| `DRTests.Calc.Composite.pas` | Composite expressions a·b + c/g, a·b − c/g, (a + b)·c with exact-decimal tie results |
| `DRTests.Calc.AddSub.pas` | Sums/differences of decimal fractions (0.1 + 0.2, 1.0 − 0.9, …) that land just over/under the intended decimal |
| `DRTests.Calc.Vat.pas` | Financial patterns: net × (1 + rate), gross / (1 + rate), unit-price divisions |
| `DRTests.Calc.Modes.pas` | All `DecimalRoundEx` modes applied to calculated tie and non-tie values |
| `DRTests.Calc.MagnitudeSweep.pas` | Calculated ties swept from large negative to large positive: 10^k ± 0.5 (k = 0..15) and the X.045 cent tie at every decade (k = 0..12), via addition, division and multiplication |

The `DRTests.Calc.*` units exist because Win32 and Win64 compute the same expression differently (x87 keeps 80-bit Extended intermediates, SSE rounds every step to 64-bit Double), so a calculated value can land just under the intended decimal on one platform and just over it on the other. Every expected value is derived from exact decimal arithmetic, and each case is its own tiny test method — a failure pinpoints exactly one expression. The whole suite must pass identically on both platforms.

Tests that exercise the 80-bit `Extended` overloads are compiled only where `Extended` really is 80 bits (`SUPPORTS_TRUE_EXTENDED`, i.e. Win32/x86) — on Win64 the suite simply contains fewer tests; everything else is identical.

## Running in the IDE

The project defines `TESTINSIGHT` (in the Base config), so pressing Run reports into the [TestInsight](https://bitbucket.org/sglienke/testinsight/wiki/Home) viewer if it is installed. Remove the define from Project Options to use the console runner instead.

## Running from the command line / CI

Override the defines so the console runner (and no trailing `Readln`) is compiled in — MSBuild command-line properties take precedence over the ones in the `.dproj`:

```bat
call "%ProgramFiles(x86)%\Embarcadero\Studio\37.0\bin\rsvars.bat"
msbuild UnitTests\DecimalRoundTests.dproj /t:Rebuild /p:Config=Release /p:Platform=Win32 /p:DCC_Define=CI
UnitTests\Win32\Release\DecimalRoundTests.exe
msbuild UnitTests\DecimalRoundTests.dproj /t:Rebuild /p:Config=Release /p:Platform=Win64 /p:DCC_Define=CI
UnitTests\Win64\Release\DecimalRoundTests.exe
```

The runner uses `TDUnitXConsoleLogger` for console output and `TDUnitXXMLNUnitFileLogger` for an NUnit XML report (CI-friendly), and sets `System.ExitCode` on any failure.

## Adding private "tripped Delphi RTL" cases

Drop them into `TDecimalRoundTrickyCases` (in `DRTests.DecimalRound.pas`):

```pascal
[Test]
procedure My_Production_Case_42;
begin
  Assert.AreEqual<Extended>(123.45, DecimalRound(Double(...), 2));
end;
```

One `[Test]` method per scenario — when one fails, you instantly see which input is the culprit.
