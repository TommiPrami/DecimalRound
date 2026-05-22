program DecimalRoundTests;

{$IFNDEF TESTINSIGHT}
  {$APPTYPE CONSOLE}
{$ENDIF}
{$STRONGLINKTYPES ON}

uses
  System.SysUtils,
  {$IFDEF TESTINSIGHT}
  TestInsight.DUnitX,
  {$ELSE}
  DUnitX.Loggers.Console,
  {$ENDIF }
  DUnitX.TestFramework,
  // Delphi.ExactFloatToString in '..\Source\3rdParty\Delphi.ExactFloatToStringRoutines\Delphi.ExactFloatToString.pas',
  DRUnit.Round in '..\Source\DRUnit.Round.pas',
  DRUnit.RoundEx in '..\Source\DRUnit.RoundEx.pas',
  DRUnit.Utils in '..\Source\DRUnit.Utils.pas',
  DRUnit.Consts in '..\Source\DRUnit.Consts.pas',
  DRUnit.Types in '..\Source\DRUnit.Types.pas',
  DRTests.IsNan in 'DRTests.IsNan.pas',
  DRTests.DecimalRound in 'DRTests.DecimalRound.pas',
  DRTests.DecimalRoundEx in 'DRTests.DecimalRoundEx.pas',
  DRTests.DecimalRoundAutoCases in 'DRTests.DecimalRoundAutoCases.pas',
  DRTests.Sanity in 'DRTests.Sanity.pas';

{$IFNDEF TESTINSIGHT}
var
  LRunner: ITestRunner;
  LResults: IRunResults;
  LConsoleLogger: ITestLogger;
  LNUnitLogger: ITestLogger;
{$ENDIF}
begin
{$IFDEF TESTINSIGHT}
  TestInsight.DUnitX.RunRegisteredTests;
{$ELSE}
  try
    TDUnitX.CheckCommandLine;
    LRunner := TDUnitX.CreateRunner;
    LRunner.FailsOnNoAsserts := False;

    LConsoleLogger := TDUnitXConsoleLogger.Create(True);
    LRunner.AddLogger(LConsoleLogger);

    LNUnitLogger := TDUnitXXMLNUnitFileLogger.Create(TDUnitX.Options.XMLOutputFile);
    LRunner.AddLogger(LNUnitLogger);

    LResults := LRunner.Execute;

    if not LResults.AllPassed then
      System.ExitCode := EXIT_ERRORS;

    {$IFNDEF CI}
    System.Write('Done.. press <Enter> key to quit.');
    System.Readln;
    {$ENDIF}
  except
    on E: Exception do
      System.Writeln(E.ClassName, ': ', E.Message);
  end;
{$ENDIF}
end.
