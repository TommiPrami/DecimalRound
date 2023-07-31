unit DRForm.Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Vcl.Controls, Vcl.Dialogs,
  Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, DRUnit.Round, DRUnit.RoundEx;

type
  TDRMainForm = class(TForm)
    ButtonTest: TButton;
    MemoLog: TMemo;
    procedure ButtonTestClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoRound(const AFormulaOrNumber: string; const ARawValue: Extended);
  public
    { Public declarations }
  end;

var
  DRMainForm: TDRMainForm;

implementation

{$R *.dfm}

uses
  System.Math;

function Round1(const AValue: Extended): Extended;
begin
  Result := Trunc(AValue * 100 + 0.50) / 100;
end;

function Round2(const AValue: Extended): Extended;
begin
  Result := Round(AValue * 100) / 100;
end;

function Round3(const AValue: Extended): Extended;
begin
  Result := Round(AValue * 100.0) / 100.0;
end;

function Round4(const AValue: Extended): Extended;
begin
  Result := Ceil(AValue * 100.0) / 100.0;
end;

function Round5(const AValue: Extended): Extended;
begin
  Result := Floor(AValue * 100.0) / 100.0;
end;

procedure TDRMainForm.ButtonTestClick(Sender: TObject);
begin
  DoRound('2.245', 2.245);
  DoRound('1.2451232323', 1.2451232323);
  DoRound('1.015 * 100', 1.015 * 100);
  DoRound('3.015 * 100', 3.015 * 100);
end;

procedure TDRMainForm.DoRound(const AFormulaOrNumber: string; const ARawValue: Extended);
begin
  MemoLog.Lines.Add(AFormulaOrNumber + ' = ' + ARawValue.ToString + ' DecimalRound = ' + DecimalRound(ARawValue, 2).ToString);
end;

end.
