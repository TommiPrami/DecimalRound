program ExactFloatToStringDemo;

uses
  Forms,
  EFTSDForm.Main in 'EFTSDForm.Main.pas' {EFTSDMainForm},
  EFTSDForm.FloatTester in 'EFTSDForm.FloatTester.pas',
  EFTSDForm.FloatTester.Extended in 'EFTSDForm.FloatTester.Extended.pas',
  EFTSDForm.FloatTester.Double in 'EFTSDForm.FloatTester.Double.pas',
  Delphi.ExactFloatToString in '..\Delphi.ExactFloatToString.pas';

{$R *.RES}

begin
  Application.Initialize;
  Application.CreateForm(TFTSDMainForm, EFTSDMainForm);
  Application.Run;
end.
