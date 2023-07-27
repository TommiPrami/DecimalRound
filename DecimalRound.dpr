program DecimalRound;

uses
  Vcl.Forms,
  DRForm.Main in 'DRForm.Main.pas' {Form11},
  DRUnit.Consts in 'DRUnit.Consts.pas',
  DRUnit.Utils in 'DRUnit.Utils.pas',
  DRUnit.Types in 'DRUnit.Types.pas',
  DRUnit.Help in 'DRUnit.Help.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TForm11, Form11);
  Application.Run;
end.
