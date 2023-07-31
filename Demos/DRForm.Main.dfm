object DRMainForm: TDRMainForm
  Left = 0
  Top = 0
  Caption = 'DRMainForm'
  ClientHeight = 295
  ClientWidth = 1092
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  OnCreate = FormCreate
  TextHeight = 15
  object MemoLog: TMemo
    Left = 0
    Top = 0
    Width = 978
    Height = 295
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    TabOrder = 0
  end
  object PanelButtons: TPanel
    Left = 978
    Top = 0
    Width = 114
    Height = 295
    Align = alRight
    ShowCaption = False
    TabOrder = 1
    object ButtonRoundTest: TButton
      AlignWithMargins = True
      Left = 4
      Top = 4
      Width = 106
      Height = 25
      Align = alTop
      Caption = 'Round test'
      TabOrder = 0
      OnClick = ButtonRoundTestClick
    end
    object ButtonExactFloat: TButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 106
      Height = 25
      Align = alTop
      Caption = 'Exact Float'
      TabOrder = 1
      OnClick = ButtonExactFloatClick
    end
  end
end
