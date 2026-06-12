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
