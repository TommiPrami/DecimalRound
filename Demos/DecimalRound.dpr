﻿program DecimalRound;

uses
  Vcl.Forms,
  DRForm.Main in 'DRForm.Main.pas' {DRMainForm},
  DRUnit.Consts in '..\Source\DRUnit.Consts.pas',
  DRUnit.Round in '..\Source\DRUnit.Round.pas',
  DRUnit.RoundEx in '..\Source\DRUnit.RoundEx.pas',
  DRUnit.Types in '..\Source\DRUnit.Types.pas',
  DRUnit.Utils in '..\Source\DRUnit.Utils.pas',
  DRUnit.ExactFloatUtils in '..\Source\DRUnit.ExactFloatUtils.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TDRMainForm, DRMainForm);
  Application.Run;
end.
