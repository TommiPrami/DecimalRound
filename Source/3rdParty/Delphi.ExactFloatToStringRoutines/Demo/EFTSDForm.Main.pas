unit EFTSDForm.Main;

(* *****************************************************************************

  For Testing ExactFloatToStr and ParseFloat functions.

  Pgm. 12/24/2002 by John Herbster.

  Refactored: all per-platform float-testing logic moved into TFloatTester and its
  descendants (see EFTSDForm.FloatTester.* ). The form just dispatches button clicks.

***************************************************************************** *)

interface

uses
  System.Classes, Vcl.Controls, Vcl.Dialogs, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls,
  EFTSDForm.FloatTester;

type
  TTesterMethod = procedure of object;

  TFTSDMainForm = class(TForm)
    ButtonAnalyzeFloat: TButton;
    ButtonConvert: TButton;
    ButtonDenormal2: TButton;
    ButtonPi: TButton;
    ButtonSmallest: TButton;
    ButtonSmallestDouble: TButton;
    ButtonSpecials: TButton;
    CheckBoxCallExVer: TCheckBox;
    CheckBoxShowDebug: TCheckBox;
    EditFloatValue: TEdit;
    MemoLog: TMemo;
    procedure ButtonAnalyzeFloatClick(ASender: TObject);
    procedure ButtonConvertClick(ASender: TObject);
    procedure ButtonDenormal2Click(ASender: TObject);
    procedure ButtonPiClick(ASender: TObject);
    procedure ButtonSmallestClick(ASender: TObject);
    procedure ButtonSmallestDoubleClick(ASender: TObject);
    procedure ButtonSpecialsClick(ASender: TObject);
    procedure EditFloatValueKeyPress(ASender: TObject; var AKey: Char);
    procedure FormCreate(ASender: TObject);
  private
    FFloatTester: TFloatTester;
    procedure RunScenario(const AScenario: TTesterMethod);
    procedure DoConvertEditValue;
  public
    destructor Destroy; override;

    // Public so TFloatTester can hold method pointers to these.
    procedure Log(const AMsg: string; const AIndent: Integer = 0);
    procedure LogFmt(const AFormat: string; const AData: array of const; const AIndent: Integer = 0);
  end;

var
  EFTSDMainForm: TFTSDMainForm;

implementation

{$R *.dfm}

uses
  Winapi.Messages, Winapi.Windows, System.SysUtils,
{$IFDEF WIN32}
  EFTSDForm.FloatTester.Extended,
{$ENDIF}
{$IFDEF CPUX64}
  EFTSDForm.FloatTester.Double,
{$ENDIF}
  Delphi.ExactFloatToString;

destructor TFTSDMainForm.Destroy;
begin
  FFloatTester.Free;
  inherited;
end;

procedure TFTSDMainForm.Log(const AMsg: string; const AIndent: Integer = 0);
begin
  MemoLog.Lines.Add(StringOfChar(' ', AIndent * 2) + AMsg);
end;

procedure TFTSDMainForm.LogFmt(const AFormat: string; const AData: array of const; const AIndent: Integer = 0);
begin
  Log(Format(AFormat, AData), AIndent);
end;

procedure TFTSDMainForm.FormCreate(ASender: TObject);
begin
  EditFloatValue.Text := FloatToStr(1.01);

{$IFDEF WIN32}
  FFloatTester := TExtendedFloatTester.Create(Log, LogFmt);
{$ENDIF}
{$IFDEF CPUX64}
  FFloatTester := TDoubleFloatTester.Create(Log, LogFmt);
{$ENDIF}
end;

procedure TFTSDMainForm.RunScenario(const AScenario: TTesterMethod);
begin
  // Mirror the checkboxes onto the tester, then run the scenario under an hourglass.
  FFloatTester.ShowDebug   := CheckBoxShowDebug.Checked;
  FFloatTester.UseExVersion := CheckBoxCallExVer.Checked;

  Screen.Cursor := crHourGlass;
  try
    AScenario();
  finally
    Screen.Cursor := crDefault;
  end;
end;

procedure TFTSDMainForm.DoConvertEditValue;
begin
  FFloatTester.ConvertStringInput(EditFloatValue.Text);
end;

procedure TFTSDMainForm.ButtonConvertClick(ASender: TObject);
begin
  Log('');
  RunScenario(DoConvertEditValue);
end;

procedure TFTSDMainForm.EditFloatValueKeyPress(ASender: TObject; var AKey: Char);
begin
  if AKey <> ^M then
    Exit;

  AKey := #0;
  ButtonConvertClick(ASender);
end;

procedure TFTSDMainForm.ButtonSmallestClick(ASender: TObject);
begin
  RunScenario(FFloatTester.RunSmallestDenormal);
end;

procedure TFTSDMainForm.ButtonDenormal2Click(ASender: TObject);
begin
  RunScenario(FFloatTester.RunDenormalBoundary);
end;

procedure TFTSDMainForm.ButtonSpecialsClick(ASender: TObject);
begin
  RunScenario(FFloatTester.RunSpecials);
end;

procedure TFTSDMainForm.ButtonPiClick(ASender: TObject);
begin
  RunScenario(FFloatTester.RunPi);
end;

procedure TFTSDMainForm.ButtonAnalyzeFloatClick(ASender: TObject);
begin
  RunScenario(FFloatTester.RunAnalyzeFloat);
end;

procedure TFTSDMainForm.ButtonSmallestDoubleClick(ASender: TObject);
begin
  RunScenario(FFloatTester.RunSmallestDouble);
end;

end.
