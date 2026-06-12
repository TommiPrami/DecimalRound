unit DRUnit.UiUtils;

{ UI support helpers, kept out of DRUnit.Utils so that the core rounding
  units do not pull System.Classes into every executable that uses them. }

interface

uses
  System.Classes;

  { Loads the TDecimalRoundingControl abbreviations (or descriptions, when
    AAddAbbreviation is False) into the string list, for such use as a
    TComboBox to make a rounding type selection. The matching enum ordinal is
    stored in Objects[] alongside each item. }
  procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings; const AAddAbbreviation: Boolean = True);

implementation

uses
  DRUnit.Consts, DRUnit.Types;

procedure LoadDecimalRoundingCtrlAbbrs(const AStrings: TStrings; const AAddAbbreviation: Boolean = True);
var
  LRoundingControl: TDecimalRoundingControl;
begin
  Assert(Assigned(AStrings));

  AStrings.BeginUpdate;
  try
    AStrings.Clear;

    for LRoundingControl := Low(LRoundingControl) to High(LRoundingControl) do
      if AAddAbbreviation then
        AStrings.AddObject(ROUNDING_CONTROL_STRINGS[LRoundingControl].Abbreviation,
          TObject(NativeUInt(Ord(LRoundingControl))))
      else
        AStrings.AddObject(ROUNDING_CONTROL_STRINGS[LRoundingControl].Description,
          TObject(NativeUInt(Ord(LRoundingControl))));
  finally
    AStrings.EndUpdate;
  end;
end;

end.
