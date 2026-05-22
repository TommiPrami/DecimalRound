unit DRForm.Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Vcl.Controls, Vcl.Dialogs, Vcl.ExtCtrls, Vcl.Forms,
  Vcl.Graphics, Vcl.StdCtrls;

type
  TDRMainForm = class(TForm)
    ButtonExactFloat: TButton;
    ButtonMoreRoundTests: TButton;
    ButtonRoundTest: TButton;
    MemoLog: TMemo;
    PanelButtons: TPanel;
    procedure ButtonExactFloatClick(Sender: TObject);
    procedure ButtonMoreRoundTestsClick(Sender: TObject);
    procedure ButtonRoundTestClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  strict private
    FFormatSettings: TFormatSettings;
    function FToStr(const AValue: Extended; const ADecimalCount: Integer = 6): string;
    procedure DoRound(const AFormulaOrNumber: string; const ARawValue: Extended; const AExpectedValue: string);
    procedure EmptyLog;
    procedure Log(const AMessage: string; const AIndent: Integer = 0);
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
  Result := Trunc(AValue * 100 + 0.50) / 100.00;
end;

function Round2(const AValue: Extended): Extended;
begin
  Result := Round(AValue * 100.00) / 100.00;
end;

function Round3(const AValue: Extended): Extended;
begin
  Result := Round(AValue * 100.0) / 100.00;
end;

function Round4(const AValue: Extended): Extended;
begin
  Result := Ceil(AValue * 100.0) / 100.00;
end;

function Round5(const AValue: Extended): Extended;
begin
  Result := Floor(AValue * 100.0) / 100.00;
end;

procedure TDRMainForm.ButtonExactFloatClick(Sender: TObject);
begin
  EmptyLog;
  Log('ExactFloatToStr');
  Log('');

  DoRound('', 0.00, ''); // This outputs header
  Log(ExactFloatToStr(1.1234, 3));

  Log('');
end;

procedure TDRMainForm.ButtonMoreRoundTestsClick(Sender: TObject);
begin
  EmptyLog;
  Log('More tests');
  Log('');

  DoRound('', 0.00, ''); // This outputs header
  DoRound('1.001', 1.001, '1.00');
  DoRound('3.33333', 3.33333, '3.33');
  DoRound('0.00000000000001', 0.00000000000001, '0.00');
  DoRound('-0.00000000000001', -0.00000000000001, '0.00');
  // DoRound('0.00000000000000000000001', 0.00000000000000000000001, '0.00');
  // DoRound('-0.00000000000000000000001', -0.00000000000000000000001, '0.00');
  // DoRound('0.0000000000000000000000000000000000000000000000000000000000000000000000001', 0.0000000000000000000000000000000000000000000000000000000000000000000000001, '0.00');
  // DoRound('-0.0000000000000000000000000000000000000000000000000000000000000000000000001', -0.0000000000000000000000000000000000000000000000000000000000000000000000001, '0.00');
  DoRound('1.999999', 1.999999, '2.00');
  DoRound('2.00001', 2.00001, '2.00');
  DoRound('2.095', 2.095, '2.10');
  DoRound('-2.095', -2.095, '-2.10');
  DoRound('92.095', 92.095, '92.10');
  DoRound('85 * 0.045', 85 * 0.045, '3.83'); // This multiplication was problematic for some rounding algorithms
  DoRound('85 * -0.045', 85 * -0.045, '-3.83'); // This multiplication was problematic for some rounding algorithms
  DoRound('1047 * 0.045000', 1047 * 0.045000, '47.12'); // This multiplication was problematic for some rounding algorithms
  DoRound('0.045', 0.045, '0.05'); // Bankers rounding
  DoRound('0.055', 0.055, '0.06');
  DoRound('85 * 1000000000.045', 85 * 1000000000.045, '85000000003.83'); // Delphis own SimpleRoundTo returns wrong value for this (85000000003.82)
  // DoRound('', , '');

  Log('');
end;

procedure TDRMainForm.ButtonRoundTestClick(Sender: TObject);
begin
  EmptyLog;
  Log('Round tests');
  Log('');

  // Tests
  DoRound('', 0.00, ''); // This outputs header
  DoRound('2.245', 2.245, '2.25');
  DoRound('1.2451232323', 1.2451232323, '+1.25');
  DoRound('1.015 * 100', 1.015 * 100.00, '+101.5');
  DoRound('3.015 * 100', 3.015 * 100.00, '+301.5');

  Log('');
end;

procedure TDRMainForm.DoRound(const AFormulaOrNumber: string; const ARawValue: Extended; const AExpectedValue: string);
var
  LRawStringValue: string;
  LDecimalRoundStringValue: string;
  LRound1StringValue: string;
  LRound2StringValue: string;
  LRound3StringValue: string;
  LRound4StringValue: string;
  LRound5StringValue: string;
begin
  if AFormulaOrNumber = '' then
    Log('formula/value;RawValue;ExpectedResult;DecimalRound;Round1,Round2;Round3;Round4;Round5')
  else
  begin
    LRawStringValue := FToStr(ARawValue);
    LDecimalRoundStringValue := FloatToStr(DecimalRound(ARawValue), FFormatSettings);
    LRound1StringValue := FloatToStr(Round1(ARawValue), FFormatSettings);
    LRound2StringValue := FloatToStr(Round2(ARawValue), FFormatSettings);
    LRound3StringValue := FloatToStr(Round3(ARawValue), FFormatSettings);
    LRound4StringValue := FloatToStr(Round4(ARawValue), FFormatSettings);
    LRound5StringValue := FloatToStr(Round5(ARawValue), FFormatSettings);

    Log(AFormulaOrNumber
      + ';' + LRawStringValue
      + ';' + AExpectedValue
      + ';' + LDecimalRoundStringValue
      + ';' + LRound1StringValue
      + ';' + LRound2StringValue
      + ';' + LRound3StringValue
      + ';' + LRound4StringValue
      + ';' + LRound5StringValue
    );
  end;
end;

procedure TDRMainForm.EmptyLog;
begin
  MemoLog.Clear;
end;

procedure TDRMainForm.FormCreate(Sender: TObject);
begin
  GFormatSettings := TFormatSettings.Create;
  GFormatSettings.DecimalSeparator := '.';
  GFormatSettings.ThousandSeparator := ' ';

  if not IsFpuCwOkForRounding then
    raise Exception.Create('FPU Control word is not OK for DecimalRound routines');

  FFormatSettings := TFormatSettings.Create;
  FFormatSettings.ThousandSeparator := ' ';
  FFormatSettings.DecimalSeparator := '.';

  EmptyLog;
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

