object DRMainForm: TDRMainForm
  Left = 0
  Top = 0
  Caption = 'DRMainForm'
  ClientHeight = 688
  ClientWidth = 1554
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
    Width = 1440
    Height = 688
    Align = alClient
    Font.Charset = DEFAULT_CHARSET
    Font.Color = clWindowText
    Font.Height = -16
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssBoth
    TabOrder = 0
    WordWrap = False
  end
  object PanelButtons: TPanel
    Left = 1440
    Top = 0
    Width = 114
    Height = 688
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
      Caption = 'Round tests'
      TabOrder = 0
      OnClick = ButtonRoundTestClick
    end
    object ButtonExactFloat: TButton
      AlignWithMargins = True
      Left = 4
      Top = 66
      Width = 106
      Height = 25
      Align = alTop
      Caption = 'Exact Float'
      TabOrder = 1
      OnClick = ButtonExactFloatClick
    end
    object ButtonMoreRoundTests: TButton
      AlignWithMargins = True
      Left = 4
      Top = 35
      Width = 106
      Height = 25
      Align = alTop
      Caption = 'More Round tests'
      TabOrder = 2
      OnClick = ButtonMoreRoundTestsClick
    end
  end
end
