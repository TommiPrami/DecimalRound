unit DRForm.Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Vcl.Controls, Vcl.Dialogs,
  Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, Vcl.ExtCtrls;

type
  TDRMainForm = class(TForm)
    MemoLog: TMemo;
    PanelButtons: TPanel;
    ButtonRoundTest: TButton;
    ButtonExactFloat: TButton;
    procedure ButtonRoundTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure ButtonExactFloatClick(Sender: TObject);
  private
    { Private declarations }
    procedure DoRound(const AFormulaOrNumber: string; const ARawValue, AExpectedValue: Extended);
    function FToStr(const AValue: Extended): string;
  public
    { Public declarations }
  end;

var
  DRMainForm: TDRMainForm;

implementation

{$R *.dfm}

uses
  System.Math, DRUnit.ExactFlotUtils, DRUnit.Round, DRUnit.RoundEx;
var
  GFormatSettigns: TFormatSettings;

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

procedure TDRMainForm.ButtonExactFloatClick(Sender: TObject);
begin
  MemoLog.Lines.Add(ExactFloatToStr(1.1234, 3));
end;

procedure TDRMainForm.ButtonRoundTestClick(Sender: TObject);
begin
  // Headerr
  DoRound('', 0.00, 0.00);

  // Tests
  DoRound('2.245', 2.245, 2.25);
  DoRound('1.2451232323', 1.2451232323, 1.25);
  DoRound('1.015 * 100', 1.015 * 100, 101.50);
  DoRound('3.015 * 100', 3.015 * 100, 301.50);
end;

procedure TDRMainForm.DoRound(const AFormulaOrNumber: string; const ARawValue, AExpectedValue: Extended);
begin
  if AFormulaOrNumber = '' then
    MemoLog.Lines.Add('formula/value;RawValue;ExpectedResult;DecimalRound;Round1,Round2;Round3;Round4;Round5')
  else
    MemoLog.Lines.Add(AFormulaOrNumber
      + ';' + FToStr(ARawValue)
      + ';' + FToStr(AExpectedValue)
      + ';' + FToStr(Round1(ARawValue))
      + ';' + FToStr(Round2(ARawValue))
      + ';' + FToStr(Round3(ARawValue))
      + ';' + FToStr(Round4(ARawValue))
      + ';' + FToStr(Round5(ARawValue))

      );;
end;

procedure TDRMainForm.FormCreate(Sender: TObject);
begin
  GFormatSettigns := TFormatSettings.Create;
  GFormatSettigns.DecimalSeparator := '.';
  GFormatSettigns.ThousandSeparator := ' ';
end;

function TDRMainForm.FToStr(const AValue: Extended): string;
begin
  Result := FloatToStr(AValue, GFormatSettigns);
end;

end.
