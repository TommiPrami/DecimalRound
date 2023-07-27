unit DRForm.Main;

interface

uses
  Winapi.Messages, Winapi.Windows, System.Classes, System.SysUtils, System.Variants, Vcl.Controls, Vcl.Dialogs,
  Vcl.Forms, Vcl.Graphics, Vcl.StdCtrls, DRUnit.Round, DRUnit.RoundEx;

type
  TForm11 = class(TForm)
    Button1: TButton;
    MemoLog: TMemo;
    procedure Button1Click(Sender: TObject);
  private
    { Private declarations }
    procedure DoRound(const AFormulaOrNumber: string; const ARawValue: Extended);
  public
    { Public declarations }
  end;

var
  Form11: TForm11;

implementation

{$R *.dfm}

procedure TForm11.Button1Click(Sender: TObject);
begin
  // 1.015 * 100 and rounded is different than 3.015 * 100
  DoRound('1.015 * 100', 1.015 * 100);
  DoRound('3.015 * 100', 3.015 * 100);
end;

procedure TForm11.DoRound(const AFormulaOrNumber: string; const ARawValue: Extended);
begin
  MemoLog.Lines.Add(AFormulaOrNumber + ' = ' + ARawValue.ToString + ' DecimalRound = ' + DecimalRound(ARawValue, 2).ToString);
end;

end.
