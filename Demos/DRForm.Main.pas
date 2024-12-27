unit DRForm.Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Vcl.Controls, Vcl.Dialogs,
  Vcl.ExtCtrls, Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls;

type
  TDRMainForm = class(TForm)
    MemoLog: TMemo;
    PanelButtons: TPanel;
    ButtonRoundTest: TButton;
    ButtonExactFloat: TButton;
    procedure ButtonExactFloatClick(Sender: TObject);
    procedure ButtonRoundTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    procedure DoRound(const AFormulaOrNumber: string; const ARawValue: Extended; const AExpectedValue: string);
    procedure Log(const AMessage: string; const AIndent: Integer = 0);
    function FToStr(const AValue: Extended; const ADecimalCount: Integer = 6): string;
  public
  end;

var
  DRMainForm: TDRMainForm;

implementation

{$R *.dfm}

uses
  System.Math, DRUnit.ExactFloatUtils, DRUnit.Round, DRUnit.RoundEx, DRUnit.Utils;

var
  GFormatSettings: TFormatSettings;

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
  Log(ExactFloatToStr(1.1234, 3));

  Log('');
end;

procedure TDRMainForm.ButtonRoundTestClick(Sender: TObject);
begin
  // Header
  DoRound('', 0.00, '0.00');

  // Tests
  DoRound('2.245', 2.245, '2.25');
  DoRound('1.2451232323', 1.2451232323, '+1.25');
  DoRound('1.015 * 100', 1.015 * 100.00, '+101.5');
  DoRound('3.015 * 100', 3.015 * 100.00, '+301.5');

  Log('');
end;

procedure TDRMainForm.DoRound(const AFormulaOrNumber: string; const ARawValue: Extended; const AExpectedValue: string);
begin
  if AFormulaOrNumber = '' then
    Log('formula/value;RawValue;ExpectedResult;DecimalRound;Round1,Round2;Round3;Round4;Round5')
  else
    Log(AFormulaOrNumber
      + ';' + FToStr(ARawValue)
      + ';' + AExpectedValue
      + ';' + FToStr(DecimalRound(ARawValue))
      + ';' + FToStr(Round1(ARawValue))
      + ';' + FToStr(Round2(ARawValue))
      + ';' + FToStr(Round3(ARawValue))
      + ';' + FToStr(Round4(ARawValue))
      + ';' + FToStr(Round5(ARawValue))
    );
end;

procedure TDRMainForm.FormCreate(Sender: TObject);
begin
  GFormatSettings := TFormatSettings.Create;
  GFormatSettings.DecimalSeparator := '.';
  GFormatSettings.ThousandSeparator := ' ';

  if not IsFpuCwOkForRounding then
    raise Exception.Create('FPU Control word is not OK for DecimalRound routines');

  Log(X87CWToString(GetX87CW));
  Log('');
end;

function TDRMainForm.FToStr(const AValue: Extended; const ADecimalCount: Integer = 6): string;
var
  LSeparatorPos: Integer;
  LStrLength: Integer;
  LRawResultDecimalCount: Integer;
begin
  Result := ExactFloatToStr(AValue, 0);

  LSeparatorPos := Pos('.', Result);
  LStrLength := Length(Result);
  LRawResultDecimalCount := LStrLength - LSeparatorPos;

  if (LSeparatorPos > 0) and (LRawResultDecimalCount > ADecimalCount) then
    Result := Copy(Result, 1, LSeparatorPos + ADecimalCount)
  else
    Result := Result + StringOfChar('0', ADecimalCount - LRawResultDecimalCount);
end;

procedure TDRMainForm.Log(const AMessage: string; const AIndent: Integer);
begin
  MemoLog.Lines.Add(StringOfChar(' ', AIndent * 2) + AMessage);
end;

end.

