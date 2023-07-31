object DRMainForm: TDRMainForm
  Left = 0
  Top = 0
  Caption = 'DRMainForm'
  ClientHeight = 269
  ClientWidth = 541
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  TextHeight = 15
  object ButtonTest: TButton
    Left = 458
    Top = 8
    Width = 75
    Height = 25
    Caption = 'Test'
    TabOrder = 0
    OnClick = ButtonTEstClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 8
    Width = 444
    Height = 253
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 1
  end
end
