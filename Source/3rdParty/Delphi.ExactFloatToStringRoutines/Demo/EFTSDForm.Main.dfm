object FTSDMainForm: TFTSDMainForm
  Left = 61
  Top = 182
  Caption = 'Exact float to string [demo]'
  ClientHeight = 372
  ClientWidth = 909
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OnCreate = FormCreate
  DesignSize = (
    909
    372)
  TextHeight = 13
  object EditFloatValue: TEdit
    Left = 8
    Top = 8
    Width = 903
    Height = 21
    Anchors = [akLeft, akTop, akRight]
    TabOrder = 0
    Text = '0.0078125'
    OnKeyPress = EditFloatValueKeyPress
  end
  object ButtonConvert: TButton
    Left = 152
    Top = 40
    Width = 137
    Height = 25
    Hint = 'Converts value in above text box.'
    Caption = 'Convert EditBox to exact'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 1
    OnClick = ButtonConvertClick
  end
  object MemoLog: TMemo
    Left = 8
    Top = 72
    Width = 901
    Height = 297
    Anchors = [akLeft, akTop, akRight, akBottom]
    Font.Charset = ANSI_CHARSET
    Font.Color = clWindowText
    Font.Height = -11
    Font.Name = 'Courier New'
    Font.Style = []
    ParentFont = False
    ScrollBars = ssVertical
    TabOrder = 2
  end
  object CheckBoxShowDebug: TCheckBox
    Left = 763
    Top = 43
    Width = 113
    Height = 17
    Caption = 'Show debug output'
    TabOrder = 3
  end
  object CheckBoxCallExVer: TCheckBox
    Left = 664
    Top = 41
    Width = 89
    Height = 20
    Caption = 'Use Ex version'
    TabOrder = 4
  end
  object ButtonSmallest: TButton
    Left = 384
    Top = 40
    Width = 73
    Height = 25
    Hint = 'This function is slow!'
    Caption = 'CkSmallest'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 5
    OnClick = ButtonSmallestClick
  end
  object ButtonDenormal2: TButton
    Left = 296
    Top = 40
    Width = 81
    Height = 25
    Hint = 'This function is slow!'
    Caption = 'CkDenormal2'
    ParentShowHint = False
    ShowHint = True
    TabOrder = 6
    OnClick = ButtonDenormal2Click
  end
  object ButtonSpecials: TButton
    Left = 464
    Top = 40
    Width = 73
    Height = 25
    Caption = 'CkSpecials'
    TabOrder = 7
    OnClick = ButtonSpecialsClick
  end
  object ButtonSmallestDouble: TButton
    Left = 544
    Top = 40
    Width = 73
    Height = 25
    Caption = 'Smallest Dbl'
    TabOrder = 8
    OnClick = ButtonSmallestDoubleClick
  end
  object ButtonPi: TButton
    Left = 624
    Top = 40
    Width = 25
    Height = 25
    Caption = 'Pi'
    TabOrder = 9
    OnClick = ButtonPiClick
  end
  object ButtonAnalyzeFloat: TButton
    Left = 8
    Top = 40
    Width = 137
    Height = 25
    Caption = 'Ck AnalyzeFloat routines'
    TabOrder = 10
    OnClick = ButtonAnalyzeFloatClick
  end
end
