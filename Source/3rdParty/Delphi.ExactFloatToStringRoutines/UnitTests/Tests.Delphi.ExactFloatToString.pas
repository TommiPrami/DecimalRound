unit Tests.Delphi.ExactFloatToString;

interface

uses
  DUnitX.TestFramework,
  Delphi.ExactFloatToString;

type
{$IFDEF WIN32}
  [TestFixture]
  TTestAnalyzeExtended = class
  public
    [Test] procedure ClassifiesPositiveZero;
    [Test] procedure ClassifiesNegativeZero;
    [Test] procedure ClassifiesNormalOne;
    [Test] procedure ClassifiesNegativeNormal;
    [Test] procedure ClassifiesPositiveInfinity;
    [Test] procedure ClassifiesNegativeInfinity;
    [Test] procedure ClassifiesCanonicalInfinity;
    [Test] procedure ClassifiesIndefinite;
    [Test] procedure ClassifiesQuietNan;
    [Test] procedure ClassifiesSignalingNan;
    [Test] procedure ClassifiesDenormal;
    [Test] procedure ExtractsCorrectFieldsForTwo;
  end;
{$ENDIF}

  [TestFixture]
  TTestAnalyzeDouble = class
  public
    [Test] procedure ClassifiesPositiveZero;
    [Test] procedure ClassifiesNegativeZero;
    [Test] procedure ClassifiesNormalOne;
    [Test] procedure ClassifiesNegativeNormal;
    [Test] procedure ClassifiesPositiveInfinity;
    [Test] procedure ClassifiesNegativeInfinity;
    [Test] procedure ClassifiesIndefinite;
    [Test] procedure ClassifiesQuietNan;
{$IFDEF CPUX64}
    // On Win32 the x87 FPU silently converts SNaN to QNaN whenever a Double round-trips
    // through it (function return, parameter passing, Double->Extended promotion). The
    // input bits don't survive transport, so this test would always fail there even
    // though AnalyzeFloat itself is correct.
    [Test] procedure ClassifiesSignalingNan;
{$ENDIF}
    [Test] procedure ClassifiesDenormal;
    [Test] procedure ClassifiesNegativeDenormal;
    [Test] procedure ClassifiesSmallestNormal;
    [Test] procedure ClassifiesLargestNormal;
    [Test] procedure ExtractsCorrectFieldsForTwo;
    [Test] procedure ExtractsCorrectFieldsForThree;
    [Test] procedure ExtractsCorrectFieldsForOneAndAHalf;
    [Test] procedure ExtractsCorrectFieldsForHalf;
  end;

  [TestFixture]
  TTestParseFloat = class
  public
{$IFDEF WIN32}
    [Test] procedure ExtendedOneFormatsExpectedBits;
    [Test] procedure ExtendedNegativeOneShowsNegativeSign;
    [Test] procedure ExtendedZeroFormatsAsAllZeroFields;
{$ENDIF}
    [Test] procedure DoubleOneFormatsExpectedBits;
    [Test] procedure DoubleNegativeOneShowsNegativeSign;
    [Test] procedure DoubleZeroFormatsAsAllZeroFields;
    [Test] procedure DoubleTwoFormatsExpectedBits;
    [Test] procedure SingleOneFormatsExpectedBits;
    [Test] procedure SingleNegativeOneShowsNegativeSign;
    [Test] procedure SingleZeroFormatsAsAllZeroFields;
  end;

{$IFDEF WIN32}
  [TestFixture]
  TTestExactExtendedToStrEx = class
  public
    [Test] procedure ZeroEmitsZeroDigit;
    [Test] procedure NegativeZeroEmitsZeroDigitWithNegativeSign;
    [Test] procedure OneEmitsOne;
    [Test] procedure NegativeOneEmitsOneWithNegativeSign;
    [Test] procedure HalfEmitsZeroPointFive;
    [Test] procedure QuarterEmitsZeroPointTwoFive;
    [Test] procedure OneAndAHalfEmitsOnePointFive;
    [Test] procedure FifteenEmitsFifteen;
    [Test] procedure HundredEmitsHundred;
    [Test] procedure OneSixteenthEmitsExactDecimal;
    [Test] procedure TwoEmitsTwo;
    [Test] procedure ThreeEmitsThree;
    [Test] procedure ThreeQuartersEmitsZeroPoint75;
    [Test] procedure OneEighthEmitsZeroPoint125;
    [Test] procedure PositiveInfinityIsNotNegative;
    [Test] procedure NegativeInfinityStartsWithMinus;
    [Test] procedure CanonicalInfinityIsRecognized;
    [Test] procedure IndefiniteEmitsIndefiniteKeyword;
    [Test] procedure QuietNanEmitsQNaNWithPayload;
    [Test] procedure SignalingNanEmitsSNaNWithPayload;
    [Test] procedure SmallestExtendedDenormalProducesLongDigits;
  end;
{$ENDIF}

  [TestFixture]
  TTestExactDoubleToStrEx = class
  public
    [Test] procedure ZeroEmitsZeroDigit;
    [Test] procedure NegativeZeroEmitsZeroDigitWithNegativeSign;
    [Test] procedure OneEmitsOne;
    [Test] procedure NegativeOneEmitsOneWithNegativeSign;
    [Test] procedure HalfEmitsZeroPointFive;
    [Test] procedure QuarterEmitsZeroPointTwoFive;
    [Test] procedure OneAndAHalfEmitsOnePointFive;
    [Test] procedure NegativeOneAndAHalfEmitsValueWithSign;
    [Test] procedure FifteenEmitsFifteen;
    [Test] procedure NegativeFifteenEmitsValueWithSign;
    [Test] procedure HundredEmitsHundred;
    [Test] procedure OneSixteenthEmitsExactDecimal;
    [Test] procedure TwoEmitsTwo;
    [Test] procedure ThreeEmitsThree;
    [Test] procedure ThreeQuartersEmitsZeroPoint75;
    [Test] procedure OneEighthEmitsZeroPoint125;
    [Test] procedure ThreePointSevenFiveEmitsValue;
    [Test] procedure TenBillionEmitsExactInteger;
    [Test] procedure ZeroPointOneHasKnownExactDecimal;
    [Test] procedure ZeroPointTwoHasKnownExactDecimal;
    [Test] procedure ZeroPointThreeHasKnownExactDecimal;
    [Test] procedure OneThirdHasKnownExactDecimal;
    [Test] procedure SmallestNormalProducesNonEmpty;
    [Test] procedure LargestFiniteProducesLongInteger;
    [Test] procedure PositiveInfinityIsNotNegative;
    [Test] procedure NegativeInfinityStartsWithMinus;
    [Test] procedure IndefiniteEmitsIndefiniteKeyword;
    [Test] procedure QuietNanEmitsQNaNWithPayload;
{$IFDEF CPUX64}
    // See note on TTestAnalyzeDouble.ClassifiesSignalingNan: on Win32 the x87 FPU mangles
    // SNaN into QNaN during Double->Extended promotion, so the input bit pattern is gone
    // by the time the engine sees it.
    [Test] procedure SignalingNanEmitsSNaNWithPayload;
{$ENDIF}
    [Test] procedure SmallestDoubleDenormalProducesLongDigits;
  end;

  [TestFixture]
  TTestExactFloatToStrFormats = class
  public
    [Test] procedure CustomDecimalSeparatorReplacesDot;
    [Test] procedure EmptyThousandsSeparatorProducesNoGrouping;
    [Test] procedure ThousandsSeparatorAppearsInLongInteger;
    [Test] procedure DigitGroupsThreeSeparatesFractionEveryThree;
    [Test] procedure SpaceThousandsSeparatorImpliesDigitGroupsFive;
    [Test] procedure ExactFloatToStrHonorsFormatSettings;
  end;

  [TestFixture]
  TTestFloatingBinPointEngine = class
  public
    [Test] procedure OneTimesTwoToZeroProducesOne;
    [Test] procedure FiveTimesTwoToMinusFourProducesZeroPoint3125;
    [Test] procedure ThreeTimesTwoToMinusOneProducesOnePointFive;
    [Test] procedure NegativeIsRespected;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils;

{ Test helpers }

{$IFDEF WIN32}
function MakeExtended(const AExponent: Word; const AMantissa: Int64): Extended;
var
  LRecord: TExtendedFloat absolute Result;
begin
  LRecord.Exponent := AExponent;
  LRecord.Mantissa := AMantissa;
end;
{$ENDIF}

function MakeDouble(const ABits: Int64): Double;
var
  LRecord: TDoubleRecord absolute Result;
begin
  LRecord.AsInt64 := ABits;
end;

function ExtractDigits(const AStringValue: string): string;
var
  LIndex: Integer;
begin
  Result := '';

  for LIndex := 1 to Length(AStringValue) do
    if CharInSet(AStringValue[LIndex], ['0'..'9', '.']) then
      Result := Result + AStringValue[LIndex];
end;

function HasNegativeSign(const AStringValue: string): Boolean;
begin
  Result := (Pos('-', AStringValue) > 0) or (Pos('(', AStringValue) > 0);
end;

function CountOccurrences(const AHaystack, ANeedle: string): Integer;
var
  LStart: Integer;
  LFound: Integer;
begin
  Result := 0;

  if ANeedle = '' then
    Exit;

  LStart := 1;
  while True do
  begin
    LFound := PosEx(ANeedle, AHaystack, LStart);

    if LFound = 0 then
      Exit;

    Inc(Result);
    LStart := LFound + Length(ANeedle);
  end;
end;

{$IFDEF WIN32}
{ TTestAnalyzeExtended }

procedure TTestAnalyzeExtended.ClassifiesPositiveZero;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($0000, $0000000000000000);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfZero), Ord(LType));
  Assert.IsFalse(LNegative);
end;

procedure TTestAnalyzeExtended.ClassifiesNegativeZero;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($8000, $0000000000000000);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfZero), Ord(LType));
  Assert.IsTrue(LNegative);
end;

procedure TTestAnalyzeExtended.ClassifiesNormalOne;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := 1.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.IsFalse(LNegative);
  Assert.AreEqual($3FFF, Integer(LExponent));
  Assert.AreEqual(Int64($8000000000000000), LMantissa);
end;

procedure TTestAnalyzeExtended.ClassifiesPositiveInfinity;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($7FFF, $0000000000000000);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfInfinity), Ord(LType));
  Assert.IsFalse(LNegative);
end;

procedure TTestAnalyzeExtended.ClassifiesNegativeInfinity;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($FFFF, $0000000000000000);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfInfinity), Ord(LType));
  Assert.IsTrue(LNegative);
end;

procedure TTestAnalyzeExtended.ClassifiesIndefinite;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($FFFF, Int64($C000000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfIndefinite), Ord(LType));
end;

procedure TTestAnalyzeExtended.ClassifiesQuietNan;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($7FFF, Int64($C100000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfQuietNan), Ord(LType));
end;

procedure TTestAnalyzeExtended.ClassifiesSignalingNan;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($7FFF, Int64($8100000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfSignalingNan), Ord(LType));
end;

procedure TTestAnalyzeExtended.ClassifiesDenormal;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeExtended($0000, $0000000000000001);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfDenormal), Ord(LType));
  Assert.IsFalse(LNegative);
end;
{$ENDIF}

{ TTestAnalyzeDouble }

procedure TTestAnalyzeDouble.ClassifiesPositiveZero;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeDouble($0000000000000000);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfZero), Ord(LType));
  Assert.IsFalse(LNegative);
end;

procedure TTestAnalyzeDouble.ClassifiesNegativeZero;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeDouble(Int64($8000000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfZero), Ord(LType));
  Assert.IsTrue(LNegative);
end;

procedure TTestAnalyzeDouble.ClassifiesNormalOne;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := 1.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.IsFalse(LNegative);
  Assert.AreEqual($3FF, Integer(LExponent));
  Assert.AreEqual(Int64(0), LMantissa); // fraction part only, implicit "1" not included
end;

procedure TTestAnalyzeDouble.ClassifiesPositiveInfinity;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeDouble(Int64($7FF0000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfInfinity), Ord(LType));
  Assert.IsFalse(LNegative);
end;

procedure TTestAnalyzeDouble.ClassifiesNegativeInfinity;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeDouble(Int64($FFF0000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfInfinity), Ord(LType));
  Assert.IsTrue(LNegative);
end;

procedure TTestAnalyzeDouble.ClassifiesIndefinite;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // x87 Double Indefinite: sign=1, exponent=$7FF, fraction = bit 51 set + no payload.
  LValue := MakeDouble(Int64($FFF8000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfIndefinite), Ord(LType));
end;

procedure TTestAnalyzeDouble.ClassifiesQuietNan;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // QNaN: exponent=$7FF, bit 51 set, payload non-zero.
  LValue := MakeDouble(Int64($7FF8000000000001));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfQuietNan), Ord(LType));
end;

{$IFDEF CPUX64}
procedure TTestAnalyzeDouble.ClassifiesSignalingNan;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // SNaN: exponent=$7FF, bit 51 clear, payload non-zero.
  LValue := MakeDouble(Int64($7FF0000000000001));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfSignalingNan), Ord(LType));
end;
{$ENDIF}

procedure TTestAnalyzeDouble.ClassifiesDenormal;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // Smallest positive Double denormal: exponent=0, fraction=1.
  LValue := MakeDouble($0000000000000001);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfDenormal), Ord(LType));
  Assert.IsFalse(LNegative);
end;

{ TTestParseFloat }

{$IFDEF WIN32}
procedure TTestParseFloat.ExtendedOneFormatsExpectedBits;
var
  LValue: Extended;
begin
  LValue := 1.0;

  Assert.AreEqual('Ext(Sgn="+",Exp=$3fff,Man=$8000000000000000)', ParseFloat(LValue));
end;

procedure TTestParseFloat.ExtendedNegativeOneShowsNegativeSign;
var
  LValue: Extended;
begin
  LValue := -1.0;

  Assert.AreEqual('Ext(Sgn="-",Exp=$3fff,Man=$8000000000000000)', ParseFloat(LValue));
end;
{$ENDIF}

procedure TTestParseFloat.DoubleOneFormatsExpectedBits;
var
  LValue: Double;
begin
  LValue := 1.0;

  Assert.AreEqual('Dbl(Sgn="+",Exp=$3ff,Man=$0000000000000)', ParseFloat(LValue));
end;

procedure TTestParseFloat.DoubleNegativeOneShowsNegativeSign;
var
  LValue: Double;
begin
  LValue := -1.0;

  Assert.AreEqual('Dbl(Sgn="-",Exp=$3ff,Man=$0000000000000)', ParseFloat(LValue));
end;

procedure TTestParseFloat.SingleOneFormatsExpectedBits;
var
  LValue: Single;
begin
  LValue := 1.0;

  Assert.AreEqual('Sgl(Sgn="+",Exp=$7f,Man=$000000)', ParseFloat(LValue));
end;

{$IFDEF WIN32}
{ TTestExactExtendedToStrEx }

procedure TTestExactExtendedToStrEx.ZeroEmitsZeroDigit;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Extended(0.0), '.', '');

  Assert.AreEqual('0', ExtractDigits(LResult));
  Assert.IsFalse(HasNegativeSign(LResult), 'positive zero should not carry a negative sign');
end;

procedure TTestExactExtendedToStrEx.NegativeZeroEmitsZeroDigitWithNegativeSign;
var
  LValue: Extended;
  LResult: string;
begin
  LValue := MakeExtended($8000, $0000000000000000);
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.AreEqual('0', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult), 'negative zero should be marked negative');
end;

procedure TTestExactExtendedToStrEx.OneEmitsOne;
begin
  Assert.AreEqual('1', ExtractDigits(ExactFloatToStrEx(Extended(1.0), '.', '')));
end;

procedure TTestExactExtendedToStrEx.NegativeOneEmitsOneWithNegativeSign;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Extended(-1.0), '.', '');

  Assert.AreEqual('1', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult));
end;

procedure TTestExactExtendedToStrEx.HalfEmitsZeroPointFive;
begin
  Assert.AreEqual('0.5', ExtractDigits(ExactFloatToStrEx(Extended(0.5), '.', '')));
end;

procedure TTestExactExtendedToStrEx.QuarterEmitsZeroPointTwoFive;
begin
  Assert.AreEqual('0.25', ExtractDigits(ExactFloatToStrEx(Extended(0.25), '.', '')));
end;

procedure TTestExactExtendedToStrEx.OneAndAHalfEmitsOnePointFive;
begin
  Assert.AreEqual('1.5', ExtractDigits(ExactFloatToStrEx(Extended(1.5), '.', '')));
end;

procedure TTestExactExtendedToStrEx.FifteenEmitsFifteen;
begin
  Assert.AreEqual('15', ExtractDigits(ExactFloatToStrEx(Extended(15.0), '.', '')));
end;

procedure TTestExactExtendedToStrEx.HundredEmitsHundred;
begin
  Assert.AreEqual('100', ExtractDigits(ExactFloatToStrEx(Extended(100.0), '.', '')));
end;

procedure TTestExactExtendedToStrEx.OneSixteenthEmitsExactDecimal;
begin
  Assert.AreEqual('0.0625', ExtractDigits(ExactFloatToStrEx(Extended(1) / Extended(16), '.', '')));
end;

procedure TTestExactExtendedToStrEx.PositiveInfinityIsNotNegative;
var
  LValue: Extended;
  LResult: string;
begin
  LValue := MakeExtended($7FFF, $0000000000000000);
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.IsFalse(LResult.IsEmpty, 'infinity output must not be empty');
  Assert.IsFalse(LResult.StartsWith('-'), 'positive infinity must not start with "-"');
end;

procedure TTestExactExtendedToStrEx.NegativeInfinityStartsWithMinus;
var
  LValue: Extended;
  LResult: string;
begin
  LValue := MakeExtended($FFFF, $0000000000000000);
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.IsFalse(LResult.IsEmpty, 'infinity output must not be empty');
  Assert.IsTrue(LResult.StartsWith('-'), 'negative infinity must start with "-"');
end;

procedure TTestExactExtendedToStrEx.IndefiniteEmitsIndefiniteKeyword;
var
  LValue: Extended;
begin
  LValue := MakeExtended($FFFF, Int64($C000000000000000));

  Assert.AreEqual('Indefinite', ExactFloatToStrEx(LValue, '.', ''));
end;

procedure TTestExactExtendedToStrEx.QuietNanEmitsQNaNWithPayload;
var
  LValue: Extended;
  LResult: string;
begin
  LValue := MakeExtended($7FFF, Int64($C100000000000000));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.StartsWith('QNaN(', LResult);
  Assert.EndsWith(')', LResult);
end;

procedure TTestExactExtendedToStrEx.SignalingNanEmitsSNaNWithPayload;
var
  LValue: Extended;
  LResult: string;
begin
  LValue := MakeExtended($7FFF, Int64($8100000000000000));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.StartsWith('SNaN(', LResult);
  Assert.EndsWith(')', LResult);
end;

procedure TTestExactExtendedToStrEx.SmallestExtendedDenormalProducesLongDigits;
var
  LValue: Extended;
  LResult: string;
  LDigits: string;
begin
  // Mantissa=1, Exponent=0: smallest positive Extended denormal. Value ~ 3.6e-4951.
  // Exact decimal expansion is ~11500 digits long.
  LValue := MakeExtended($0000, $0000000000000001);
  LResult := ExactFloatToStrEx(LValue, '.', '');
  LDigits := ExtractDigits(LResult);

  Assert.IsTrue(LDigits.StartsWith('0.'), 'denormal must start with "0."');
  Assert.IsTrue(LDigits.EndsWith('5'), 'final digit must be 5 (powers of 1/2 end in 5)');
  Assert.IsTrue(Length(LDigits) > 4000, 'expansion should be thousands of digits long');
end;
{$ENDIF}

{ TTestExactDoubleToStrEx }

procedure TTestExactDoubleToStrEx.ZeroEmitsZeroDigit;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Double(0.0), '.', '');

  Assert.AreEqual('0', ExtractDigits(LResult));
  Assert.IsFalse(HasNegativeSign(LResult), 'positive zero should not carry a negative sign');
end;

procedure TTestExactDoubleToStrEx.NegativeZeroEmitsZeroDigitWithNegativeSign;
var
  LValue: Double;
  LResult: string;
begin
  LValue := MakeDouble(Int64($8000000000000000));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.AreEqual('0', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult), 'negative zero should be marked negative');
end;

procedure TTestExactDoubleToStrEx.OneEmitsOne;
begin
  Assert.AreEqual('1', ExtractDigits(ExactFloatToStrEx(Double(1.0), '.', '')));
end;

procedure TTestExactDoubleToStrEx.NegativeOneEmitsOneWithNegativeSign;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Double(-1.0), '.', '');

  Assert.AreEqual('1', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult));
end;

procedure TTestExactDoubleToStrEx.HalfEmitsZeroPointFive;
begin
  Assert.AreEqual('0.5', ExtractDigits(ExactFloatToStrEx(Double(0.5), '.', '')));
end;

procedure TTestExactDoubleToStrEx.QuarterEmitsZeroPointTwoFive;
begin
  Assert.AreEqual('0.25', ExtractDigits(ExactFloatToStrEx(Double(0.25), '.', '')));
end;

procedure TTestExactDoubleToStrEx.OneAndAHalfEmitsOnePointFive;
begin
  Assert.AreEqual('1.5', ExtractDigits(ExactFloatToStrEx(Double(1.5), '.', '')));
end;

procedure TTestExactDoubleToStrEx.FifteenEmitsFifteen;
begin
  Assert.AreEqual('15', ExtractDigits(ExactFloatToStrEx(Double(15.0), '.', '')));
end;

procedure TTestExactDoubleToStrEx.HundredEmitsHundred;
begin
  Assert.AreEqual('100', ExtractDigits(ExactFloatToStrEx(Double(100.0), '.', '')));
end;

procedure TTestExactDoubleToStrEx.OneSixteenthEmitsExactDecimal;
begin
  // 1/16 is exactly 0.0625, finite and short in both Double and Extended.
  Assert.AreEqual('0.0625', ExtractDigits(ExactFloatToStrEx(Double(1) / Double(16), '.', '')));
end;

procedure TTestExactDoubleToStrEx.ZeroPointOneHasKnownExactDecimal;
const
  EXPECTED = '0.1000000000000000055511151231257827021181583404541015625';
var
  LValue: Double;
begin
  // The Double rounding of 0.1 has a well-known exact decimal expansion.
  LValue := 0.1;

  Assert.AreEqual(EXPECTED, ExtractDigits(ExactFloatToStrEx(LValue, '.', '')));
end;

procedure TTestExactDoubleToStrEx.PositiveInfinityIsNotNegative;
var
  LValue: Double;
  LResult: string;
begin
  LValue := MakeDouble(Int64($7FF0000000000000));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.IsFalse(LResult.IsEmpty, 'infinity output must not be empty');
  Assert.IsFalse(LResult.StartsWith('-'), 'positive infinity must not start with "-"');
end;

procedure TTestExactDoubleToStrEx.NegativeInfinityStartsWithMinus;
var
  LValue: Double;
  LResult: string;
begin
  LValue := MakeDouble(Int64($FFF0000000000000));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.IsFalse(LResult.IsEmpty, 'infinity output must not be empty');
  Assert.IsTrue(LResult.StartsWith('-'), 'negative infinity must start with "-"');
end;

procedure TTestExactDoubleToStrEx.IndefiniteEmitsIndefiniteKeyword;
var
  LValue: Double;
begin
  LValue := MakeDouble(Int64($FFF8000000000000));

  Assert.AreEqual('Indefinite', ExactFloatToStrEx(LValue, '.', ''));
end;

procedure TTestExactDoubleToStrEx.QuietNanEmitsQNaNWithPayload;
var
  LValue: Double;
  LResult: string;
begin
  LValue := MakeDouble(Int64($7FF8000000000001));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.StartsWith('QNaN(', LResult);
  Assert.EndsWith(')', LResult);
end;

{$IFDEF CPUX64}
procedure TTestExactDoubleToStrEx.SignalingNanEmitsSNaNWithPayload;
var
  LValue: Double;
  LResult: string;
begin
  LValue := MakeDouble(Int64($7FF0000000000001));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.StartsWith('SNaN(', LResult);
  Assert.EndsWith(')', LResult);
end;
{$ENDIF}

procedure TTestExactDoubleToStrEx.SmallestDoubleDenormalProducesLongDigits;
var
  LValue: Double;
  LResult: string;
  LDigits: string;
begin
  // Smallest positive Double denormal = 2^-1074 ~ 5e-324.
  // Exact decimal expansion has 1074 digits after the point.
  LValue := MakeDouble($0000000000000001);
  LResult := ExactFloatToStrEx(LValue, '.', '');
  LDigits := ExtractDigits(LResult);

  Assert.IsTrue(LDigits.StartsWith('0.'), 'denormal must start with "0."');
  Assert.IsTrue(LDigits.EndsWith('5'), 'final digit must be 5 (powers of 1/2 end in 5)');
  Assert.IsTrue(Length(LDigits) > 1000, 'expansion should be over 1000 digits long');
end;

{ ==================================================================================== }
{   Additional coverage                                                                 }
{ ==================================================================================== }

{$IFDEF WIN32}
{ TTestAnalyzeExtended — extra }

procedure TTestAnalyzeExtended.ClassifiesNegativeNormal;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := -1.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.IsTrue(LNegative, '-1.0 must be marked negative');
end;

procedure TTestAnalyzeExtended.ClassifiesCanonicalInfinity;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // Canonical x87 Infinity: exponent=$7FFF, integer bit set, fraction=0.
  // This is the form FLD produces from a Double Inf — regression test for the
  // AnalyzeFloat(Extended) Infinity check that previously only accepted mantissa=0.
  LValue := MakeExtended($7FFF, Int64($8000000000000000));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfInfinity), Ord(LType));
  Assert.IsFalse(LNegative);
end;

procedure TTestAnalyzeExtended.ExtractsCorrectFieldsForTwo;
var
  LValue: Extended;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := 2.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.AreEqual($4000, Integer(LExponent), 'exponent for 2.0 should be $4000 (bias + 1)');
  Assert.AreEqual(Int64($8000000000000000), LMantissa, 'mantissa for 2.0 is integer-bit-only');
end;
{$ENDIF}

{ TTestAnalyzeDouble — extra }

procedure TTestAnalyzeDouble.ClassifiesNegativeNormal;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := -1.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.IsTrue(LNegative);
end;

procedure TTestAnalyzeDouble.ClassifiesNegativeDenormal;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  LValue := MakeDouble(Int64($8000000000000001));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfDenormal), Ord(LType));
  Assert.IsTrue(LNegative);
end;

procedure TTestAnalyzeDouble.ClassifiesSmallestNormal;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // Smallest positive normal Double: exponent=1, fraction=0. Value = 2^-1022.
  LValue := MakeDouble($0010000000000000);
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.AreEqual(1, Integer(LExponent), 'smallest normal has biased exponent 1');
  Assert.AreEqual(Int64(0), LMantissa, 'smallest normal has fraction 0');
end;

procedure TTestAnalyzeDouble.ClassifiesLargestNormal;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // Largest finite Double: exponent=$7FE (one less than Inf), all fraction bits set.
  LValue := MakeDouble(Int64($7FEFFFFFFFFFFFFF));
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.AreEqual($7FE, Integer(LExponent));
  Assert.AreEqual(Int64($000FFFFFFFFFFFFF), LMantissa);
end;

procedure TTestAnalyzeDouble.ExtractsCorrectFieldsForTwo;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // 2.0 = 1.0 * 2^1, so stored exponent = bias + 1 = $400, fraction = 0.
  LValue := 2.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual(Ord(tfNormal), Ord(LType));
  Assert.AreEqual($400, Integer(LExponent));
  Assert.AreEqual(Int64(0), LMantissa);
end;

procedure TTestAnalyzeDouble.ExtractsCorrectFieldsForThree;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // 3.0 = 1.1_2 * 2^1, so fraction bit 51 set, exponent = $400.
  LValue := 3.0;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual($400, Integer(LExponent));
  Assert.AreEqual(Int64($0008000000000000), LMantissa);
end;

procedure TTestAnalyzeDouble.ExtractsCorrectFieldsForOneAndAHalf;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // 1.5 = 1.1_2 * 2^0, so fraction bit 51 set, exponent = $3FF.
  LValue := 1.5;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual($3FF, Integer(LExponent));
  Assert.AreEqual(Int64($0008000000000000), LMantissa);
end;

procedure TTestAnalyzeDouble.ExtractsCorrectFieldsForHalf;
var
  LValue: Double;
  LType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
begin
  // 0.5 = 1.0_2 * 2^-1, fraction = 0, exponent = $3FE (bias - 1).
  LValue := 0.5;
  AnalyzeFloat(LValue, LType, LNegative, LExponent, LMantissa);

  Assert.AreEqual($3FE, Integer(LExponent));
  Assert.AreEqual(Int64(0), LMantissa);
end;

{ TTestParseFloat — extra }

{$IFDEF WIN32}
procedure TTestParseFloat.ExtendedZeroFormatsAsAllZeroFields;
var
  LValue: Extended;
begin
  LValue := MakeExtended($0000, $0000000000000000);

  Assert.AreEqual('Ext(Sgn="+",Exp=$0000,Man=$0000000000000000)', ParseFloat(LValue));
end;
{$ENDIF}

procedure TTestParseFloat.DoubleZeroFormatsAsAllZeroFields;
var
  LValue: Double;
begin
  LValue := MakeDouble($0000000000000000);

  Assert.AreEqual('Dbl(Sgn="+",Exp=$000,Man=$0000000000000)', ParseFloat(LValue));
end;

procedure TTestParseFloat.DoubleTwoFormatsExpectedBits;
var
  LValue: Double;
begin
  LValue := 2.0;

  Assert.AreEqual('Dbl(Sgn="+",Exp=$400,Man=$0000000000000)', ParseFloat(LValue));
end;

procedure TTestParseFloat.SingleNegativeOneShowsNegativeSign;
var
  LValue: Single;
begin
  LValue := -1.0;

  Assert.AreEqual('Sgl(Sgn="-",Exp=$7f,Man=$000000)', ParseFloat(LValue));
end;

procedure TTestParseFloat.SingleZeroFormatsAsAllZeroFields;
var
  LValue: Single;
begin
  LValue := 0.0;

  Assert.AreEqual('Sgl(Sgn="+",Exp=$00,Man=$000000)', ParseFloat(LValue));
end;

{$IFDEF WIN32}
{ TTestExactExtendedToStrEx — extra }

procedure TTestExactExtendedToStrEx.TwoEmitsTwo;
begin
  Assert.AreEqual('2', ExtractDigits(ExactFloatToStrEx(Extended(2.0), '.', '')));
end;

procedure TTestExactExtendedToStrEx.ThreeEmitsThree;
begin
  Assert.AreEqual('3', ExtractDigits(ExactFloatToStrEx(Extended(3.0), '.', '')));
end;

procedure TTestExactExtendedToStrEx.ThreeQuartersEmitsZeroPoint75;
begin
  Assert.AreEqual('0.75', ExtractDigits(ExactFloatToStrEx(Extended(3) / Extended(4), '.', '')));
end;

procedure TTestExactExtendedToStrEx.OneEighthEmitsZeroPoint125;
begin
  Assert.AreEqual('0.125', ExtractDigits(ExactFloatToStrEx(Extended(1) / Extended(8), '.', '')));
end;

procedure TTestExactExtendedToStrEx.CanonicalInfinityIsRecognized;
var
  LValue: Extended;
  LResult: string;
begin
  // Regression: AnalyzeFloat(Extended) used to misclassify canonical Infinity (integer
  // bit set, fraction = 0) as SNaN. Verify the engine emits a real infinity string.
  LValue := MakeExtended($7FFF, Int64($8000000000000000));
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.IsFalse(LResult.IsEmpty);
  Assert.IsFalse(LResult.StartsWith('-'), 'canonical positive infinity must not start with "-"');
  Assert.IsFalse(LResult.StartsWith('SNaN'), 'canonical infinity must not be reported as SNaN');
end;
{$ENDIF}

{ TTestExactDoubleToStrEx — extra }

procedure TTestExactDoubleToStrEx.TwoEmitsTwo;
begin
  Assert.AreEqual('2', ExtractDigits(ExactFloatToStrEx(Double(2.0), '.', '')));
end;

procedure TTestExactDoubleToStrEx.ThreeEmitsThree;
begin
  Assert.AreEqual('3', ExtractDigits(ExactFloatToStrEx(Double(3.0), '.', '')));
end;

procedure TTestExactDoubleToStrEx.ThreeQuartersEmitsZeroPoint75;
begin
  Assert.AreEqual('0.75', ExtractDigits(ExactFloatToStrEx(Double(3) / Double(4), '.', '')));
end;

procedure TTestExactDoubleToStrEx.OneEighthEmitsZeroPoint125;
begin
  Assert.AreEqual('0.125', ExtractDigits(ExactFloatToStrEx(Double(1) / Double(8), '.', '')));
end;

procedure TTestExactDoubleToStrEx.ThreePointSevenFiveEmitsValue;
begin
  // 3.75 is exactly representable in binary (15/4).
  Assert.AreEqual('3.75', ExtractDigits(ExactFloatToStrEx(Double(3.75), '.', '')));
end;

procedure TTestExactDoubleToStrEx.NegativeOneAndAHalfEmitsValueWithSign;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Double(-1.5), '.', '');

  Assert.AreEqual('1.5', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult), '-1.5 must carry a negative sign');
end;

procedure TTestExactDoubleToStrEx.NegativeFifteenEmitsValueWithSign;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Double(-15.0), '.', '');

  Assert.AreEqual('15', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult));
end;

procedure TTestExactDoubleToStrEx.TenBillionEmitsExactInteger;
begin
  // 10^10 = 2^10 * 5^10, fits exactly in Double (< 2^53).
  Assert.AreEqual('10000000000', ExtractDigits(ExactFloatToStrEx(Double(1e10), '.', '')));
end;

procedure TTestExactDoubleToStrEx.ZeroPointTwoHasKnownExactDecimal;
const
  EXPECTED = '0.200000000000000011102230246251565404236316680908203125';
begin
  // Double 0.2 rounds slightly upward; this is its exact decimal expansion (54 digits after dot).
  Assert.AreEqual(EXPECTED, ExtractDigits(ExactFloatToStrEx(Double(0.2), '.', '')));
end;

procedure TTestExactDoubleToStrEx.ZeroPointThreeHasKnownExactDecimal;
const
  EXPECTED = '0.299999999999999988897769753748434595763683319091796875';
begin
  // Double 0.3 rounds slightly downward; exact decimal expansion (54 digits after dot).
  Assert.AreEqual(EXPECTED, ExtractDigits(ExactFloatToStrEx(Double(0.3), '.', '')));
end;

procedure TTestExactDoubleToStrEx.OneThirdHasKnownExactDecimal;
const
  EXPECTED = '0.333333333333333314829616256247390992939472198486328125';
var
  LValue: Double;
begin
  // Double 1/3 (computed at runtime, not from a literal that the compiler might fold).
  LValue := Double(1) / Double(3);

  Assert.AreEqual(EXPECTED, ExtractDigits(ExactFloatToStrEx(LValue, '.', '')));
end;

procedure TTestExactDoubleToStrEx.SmallestNormalProducesNonEmpty;
var
  LValue: Double;
  LResult: string;
begin
  // Smallest positive normal Double: 2^-1022 ~ 2.225e-308.
  LValue := MakeDouble($0010000000000000);
  LResult := ExactFloatToStrEx(LValue, '.', '');

  Assert.IsTrue(ExtractDigits(LResult).StartsWith('0.'), 'must start with "0."');
  Assert.IsTrue(Length(ExtractDigits(LResult)) > 300, 'expansion should be hundreds of digits');
end;

procedure TTestExactDoubleToStrEx.LargestFiniteProducesLongInteger;
var
  LValue: Double;
  LDigits: string;
begin
  // Largest finite Double: ~1.798e308 — a 309-digit integer.
  LValue := MakeDouble(Int64($7FEFFFFFFFFFFFFF));
  LDigits := ExtractDigits(ExactFloatToStrEx(LValue, '.', ''));

  Assert.IsFalse(LDigits.Contains('.'), 'largest finite Double is an integer, no decimal point expected');
  Assert.AreEqual(309, Length(LDigits), 'largest finite Double has 309 decimal digits');
end;

{ TTestExactFloatToStrFormats }

procedure TTestExactFloatToStrFormats.CustomDecimalSeparatorReplacesDot;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Double(0.5), ',', '');

  Assert.IsTrue(Pos(',', LResult) > 0, 'output should contain the custom decimal separator');
  Assert.IsTrue(Pos('.', LResult) = 0, 'output should not contain the default dot separator');
end;

procedure TTestExactFloatToStrFormats.EmptyThousandsSeparatorProducesNoGrouping;
var
  LResult: string;
begin
  LResult := ExactFloatToStrEx(Double(1e10), '.', '');

  Assert.AreEqual('10000000000', ExtractDigits(LResult), 'no separator -> no grouping');
  Assert.IsFalse(Pos(',', LResult) > 0);
end;

procedure TTestExactFloatToStrFormats.ThousandsSeparatorAppearsInLongInteger;
var
  LResult: string;
begin
  // 10 billion with thousands grouping at 3: "10,000,000,000" -> 3 commas
  LResult := ExactFloatToStrEx(Double(1e10), '.', ',', 3);

  Assert.AreEqual(3, CountOccurrences(LResult, ','), '10^10 grouped in threes has 3 commas');
end;

procedure TTestExactFloatToStrFormats.DigitGroupsThreeSeparatesFractionEveryThree;
var
  LResult: string;
  LCommas: Integer;
begin
  // Double 0.1 has a 55-digit fractional expansion. Grouping every 3 digits in the
  // fractional part inserts a separator every 3 places after the decimal point.
  // 55 / 3 = 18 full groups, so at least 18 commas.
  LResult := ExactFloatToStrEx(Double(0.1), '.', ',', 3);
  LCommas := CountOccurrences(LResult, ',');

  Assert.IsTrue(LCommas >= 18, Format('expected at least 18 commas, got %d', [LCommas]));
end;

procedure TTestExactFloatToStrFormats.SpaceThousandsSeparatorImpliesDigitGroupsFive;
var
  LResult: string;
begin
  // Per ExactFloatToStrEx contract: an ASCII space ($20 is NOT in the Unicode-space set
  // so we pass U+2009 thin space) used as the thousands separator auto-selects groups of 5.
  LResult := ExactFloatToStrEx(Double(1e10), '.', #$2009, 0);

  // 10000000000 grouped at 5 → "100000,00000" or "1,00000,00000" — should have at least one separator.
  Assert.IsTrue(Pos(#$2009, LResult) > 0, 'thin-space separator should appear at group boundary');
end;

procedure TTestExactFloatToStrFormats.ExactFloatToStrHonorsFormatSettings;
var
  LSettings: TFormatSettings;
  LResult: string;
begin
  LSettings := TFormatSettings.Create;
  LSettings.DecimalSeparator := ',';
  LSettings.ThousandSeparator := '.';

  LResult := ExactFloatToStr(Double(0.5), LSettings);

  Assert.IsTrue(Pos(',', LResult) > 0, 'custom decimal separator should be used');
end;

{ TTestFloatingBinPointEngine }

procedure TTestFloatingBinPointEngine.OneTimesTwoToZeroProducesOne;
var
  LMantissa: Int64;
begin
  // Value = 1 * 2^0 = 1.
  LMantissa := 1;
  Assert.AreEqual('1', ExtractDigits(FloatingBinPointToDecStr(LMantissa, 1, 0, False, '.', '', 0)));
end;

procedure TTestFloatingBinPointEngine.FiveTimesTwoToMinusFourProducesZeroPoint3125;
var
  LMantissa: Int64;
begin
  // Value = 5 * 2^-4 = 5/16 = 0.3125.
  LMantissa := 5;
  Assert.AreEqual('0.3125', ExtractDigits(FloatingBinPointToDecStr(LMantissa, 3, -4, False, '.', '', 0)));
end;

procedure TTestFloatingBinPointEngine.ThreeTimesTwoToMinusOneProducesOnePointFive;
var
  LMantissa: Int64;
begin
  // Value = 3 * 2^-1 = 1.5.
  LMantissa := 3;
  Assert.AreEqual('1.5', ExtractDigits(FloatingBinPointToDecStr(LMantissa, 2, -1, False, '.', '', 0)));
end;

procedure TTestFloatingBinPointEngine.NegativeIsRespected;
var
  LMantissa: Int64;
  LResult: string;
begin
  LMantissa := 5;
  LResult := FloatingBinPointToDecStr(LMantissa, 3, -4, True, '.', '', 0);

  Assert.AreEqual('0.3125', ExtractDigits(LResult));
  Assert.IsTrue(HasNegativeSign(LResult), 'negative flag should produce a negative-marked result');
end;

end.
