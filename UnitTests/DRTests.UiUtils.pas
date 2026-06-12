unit DRTests.UiUtils;

{ Coverage for DRUnit.UiUtils.LoadDecimalRoundingCtrlAbbrs — the helper that
  pairs each TDecimalRoundingControl with its abbreviation or description,
  e.g. for populating a TComboBox. }

interface

uses
  DUnitX.TestFramework;

type
  [TestFixture]
  TLoadDecimalRoundingCtrlAbbrsTests = class
  public
    [Test] procedure Abbreviations_OneItemPerRoundingControl;
    [Test] procedure Descriptions_OneItemPerRoundingControl;
    [Test] procedure ExistingContent_IsCleared;
  end;

implementation

uses
  System.Classes, DRUnit.Consts, DRUnit.Types, DRUnit.UiUtils;

const
  EXPECTED_COUNT = Ord(High(TDecimalRoundingControl)) + 1;

procedure TLoadDecimalRoundingCtrlAbbrsTests.Abbreviations_OneItemPerRoundingControl;
var
  LStrings: TStringList;
  LRoundingControl: TDecimalRoundingControl;
  LIndex: Integer;
begin
  LStrings := TStringList.Create;
  try
    LoadDecimalRoundingCtrlAbbrs(LStrings);

    Assert.AreEqual(EXPECTED_COUNT, LStrings.Count);

    for LRoundingControl := Low(TDecimalRoundingControl) to High(TDecimalRoundingControl) do
    begin
      LIndex := Ord(LRoundingControl);

      Assert.AreEqual(ROUNDING_CONTROL_STRINGS[LRoundingControl].Abbreviation, LStrings[LIndex]);
      Assert.AreEqual(LIndex, Integer(NativeUInt(LStrings.Objects[LIndex])),
        'Objects[' + LStrings[LIndex] + '] must hold the enum ordinal');
    end;
  finally
    LStrings.Free;
  end;
end;

procedure TLoadDecimalRoundingCtrlAbbrsTests.Descriptions_OneItemPerRoundingControl;
var
  LStrings: TStringList;
  LRoundingControl: TDecimalRoundingControl;
  LIndex: Integer;
begin
  LStrings := TStringList.Create;
  try
    LoadDecimalRoundingCtrlAbbrs(LStrings, False);

    Assert.AreEqual(EXPECTED_COUNT, LStrings.Count);

    for LRoundingControl := Low(TDecimalRoundingControl) to High(TDecimalRoundingControl) do
    begin
      LIndex := Ord(LRoundingControl);

      Assert.AreEqual(ROUNDING_CONTROL_STRINGS[LRoundingControl].Description, LStrings[LIndex]);
      Assert.AreEqual(LIndex, Integer(NativeUInt(LStrings.Objects[LIndex])),
        'Objects[' + LStrings[LIndex] + '] must hold the enum ordinal');
    end;
  finally
    LStrings.Free;
  end;
end;

procedure TLoadDecimalRoundingCtrlAbbrsTests.ExistingContent_IsCleared;
var
  LStrings: TStringList;
begin
  LStrings := TStringList.Create;
  try
    LStrings.Add('leftover 1');
    LStrings.Add('leftover 2');

    LoadDecimalRoundingCtrlAbbrs(LStrings);

    Assert.AreEqual(EXPECTED_COUNT, LStrings.Count, 'Previous content must be cleared, not appended to');
    Assert.AreEqual(ROUNDING_CONTROL_STRINGS[Low(TDecimalRoundingControl)].Abbreviation, LStrings[0]);
  finally
    LStrings.Free;
  end;
end;

initialization
  TDUnitX.RegisterTestFixture(TLoadDecimalRoundingCtrlAbbrsTests);

end.
