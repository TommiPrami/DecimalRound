# DecimalRound — Unit Tests (DUnitX)

DUnitX-based test project for the DecimalRound library.

## Files

| File | Contents |
| --- | --- |
| `DecimalRoundTests.dpr` | Console DUnitX runner (also TestInsight-friendly via `TESTINSIGHT` define) |
| `DRTests.IsNan.pas` | Regression coverage for the IsNan / Infinity classification bug |
| `DRTests.NextPrevFloat.pas` | Regression coverage for `PrevFloat(Extended) = 0` returning the wrong sign |
| `DRTests.DecimalRound.pas` | Main `DecimalRound` (HalfUp) tests + slot for private trip-up cases (`TDecimalRoundTrickyCases`) |
| `DRTests.DecimalRoundEx.pas` | Per-mode tests for `DecimalRoundEx` (HalfUp / HalfDown / HalfEven / HalfPos / HalfNeg / RndPos / RndNeg / RndDown / RndUp) |
| `DRTests.Sanity.pas` | FPU control word + `gPowerOfTenMultipliers` lookup sanity |

## First-time setup

A `.dproj` is intentionally **not** checked in — they are Delphi-version-specific XML and tend to churn. Generate one in the IDE:

1. In Delphi, **File → Open** the `DecimalRoundTests.dpr` here.
2. The IDE will create a matching `.dproj`. Save Project.
3. Add the library source folder to the project's **Search Path**:
   `..\Source`
4. Make sure DUnitX is installed (it ships with modern Delphi; otherwise add it via GetIt or a `dunitx.*` package).
5. Build and run.

The runner uses `TDUnitXConsoleLogger` for console output and `TDUnitXXMLNUnitFileLogger` for an NUnit XML report (CI-friendly).

## TestInsight

Define `TESTINSIGHT` in project options to run inside the TestInsight viewer instead of the console runner.

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

## CI note

Defining `CI` skips the trailing `Readln` so the runner exits unattended.
The runner sets `System.ExitCode := EXIT_ERRORS` on any failure.
