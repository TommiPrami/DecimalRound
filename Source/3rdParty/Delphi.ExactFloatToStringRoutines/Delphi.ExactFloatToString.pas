unit Delphi.ExactFloatToString;

(* *****************************************************************************

  This module includes
    (a) functions for converting a floating binary point number to its
        *exact* decimal representation in an AnsiString;
    (b) functions for parsing the floating point types into sign, exponent,
        and mantissa; and
    (c) function for analyzing a extended float number into its type (zero,
        normal, infinity, etc.)

  Its intended use is for trouble shooting problems with floating point numbers.

  This code uses dynamic arrays, overloaded calls, and optional parameters.

  These routines are not very optimized for speed or space.
    I plan to replace the individual bit-shifts and multiplies-by-ten with multiple versions of same.
    Consider making an object so that the arrays don't have to reallocated so often.
    And consider making an output buffer character array so that the Result will be allocated only once.

  Rev. 6/21/2018  Updated to Unicode strings and code cleanup
  Rev. 1/1/2003   by JFH to add the three ParseFloat functions.
  Rev. 12/26/2002 by JFH to bracket the DEBUG code with conditionals.
  Rev. 12/25/2002 by JFH to fix 1E20 (BinExp) problem and check for zero and other special values.
  Pgm. 12/24/2002 by John Herbster for Delphi programmers everywhere.

***************************************************************************** *)

{ Turn DEBUG on to make available detail debugging at expense of speed.}
{.$DEFINE DEBUG}

{
  Define EXACT_FLOAT_TO_STRING_USE_OS_LOCALE to let the unit pull SPositiveSign,
  SNegativeSign, SPosInfinity, SNegInfinity, SGrouping, INegNumber and the native digits
  from the Windows user locale at unit init.

  Default (define commented out) keeps the hard-coded English-style strings ("+", "-",
  "Infinity", "-Infinity", "0..9", grouping "3;0", INegNumber=1). That makes the output
  deterministic across machines, which is normally what callers of an *exact* float
  converter want.
}
{.$DEFINE EXACT_FLOAT_TO_STRING_USE_OS_LOCALE}

interface

uses
  System.SysUtils;

type
  TSglWord = Word;     // Consider Byte or Word
  TDblWord = LongWord; // Consider Word or LongWord

{$IFDEF WIN32}
  // 80-bit Extended layout. Only meaningful on Win32 where Extended is a 10-byte type.
  // On Win64 (and other targets where Extended aliases Double) this record is invalid.
  TExtendedFloat = packed record
    Mantissa: Int64;
    Exponent: Word;  // Sign and Exponent
  end;
{$ENDIF}

  // 64-bit Double bit-reinterpretation overlay (IEEE-754 binary64).
  // Layout in AsInt64: sign (bit 63) | exponent (bits 62..52, bias 1023) | fraction (bits 51..0).
  // Available on all platforms (Double is 8 bytes everywhere).
  TDoubleRecord = packed record
    case Byte of
      0: (AsDouble: Double);
      1: (AsInt64: Int64);
  end;

  TFloatParts = packed record
    case Byte of
      0: (W: TDblWord);
      1: (L, H: TSglWord);
    end;

{$IFDEF WIN32}
  { This call uses the global DecimalSeparator and ThousandSeparator. It can be slow for very large or very small
    extended numbers. }
  function ExactFloatToStr(const AValue: Extended): string; overload; inline;
  function ExactFloatToStr(const AValue: Extended; const AFormatSettings: TFormatSettings): string; overload;
  function ExactFloatToStrEx(const AValue: Extended; const ADecimalPoint: string = '.'; const AThousandsSep: string = '';
    const ADigitGroups: Integer = 0): string;
{$ENDIF}

{$IFDEF CPUX64}
  { 64-bit-platform overloads. On Win64 Extended aliases Double, so we cannot have an Extended
    overload alongside Double — these stand in for the Win32 Extended functions. }
  function ExactFloatToStr(const AValue: Double): string; overload; inline;
  function ExactFloatToStr(const AValue: Double; const AFormatSettings: TFormatSettings): string; overload;
  function ExactFloatToStrEx(const AValue: Double; const ADecimalPoint: string = '.'; const AThousandsSep: string = '';
    const ADigitGroups: Integer = 0): string;
{$ENDIF}

  // These calls parse a float value to its sign, exponent, and mantissa.
{$IFDEF WIN32}
  function ParseFloat(const AValue: Extended): string; overload;
{$ENDIF}
  function ParseFloat(const AValue: Double): string; overload;
  function ParseFloat(const AValue: Single): string; overload;

  // This is the basic conversion engine.
  function FloatingBinPointToDecStr(const AValue; const AValNbrBits, AValBinExp: Integer; const ANegative: Boolean;
    const ADecimalPoint: string = '.'; const AThousandsSep: string = ''; const ADigitGroups: Integer = 0): string;

type
  TTypeFloat = (tfUnknown, tfNormal, tfZero, tfDenormal, tfIndefinite, tfInfinity, tfQuietNan, tfSignalingNan);

{$IFDEF WIN32}
  procedure AnalyzeFloat(const AValue: Extended; var ANumberType: TTypeFloat; var ANegative: Boolean; var AExponent: Word;
    var AMantissa: Int64); overload;
{$ENDIF}
  procedure AnalyzeFloat(const AValue: Double; var ANumberType: TTypeFloat; var ANegative: Boolean; var AExponent: Word;
    var AMantissa: Int64); overload;

(*
const
  TODO: Make this configurable

  // Different spaces you can use for digit grouping. SI recommends ThinSpace
  ThinSpace: WideChar          = #$2009; // U+2009 THIN SPACE
  NarrowNoBreakSpace: WideChar = #$202F; // U+202F NARROW NO-BREAK SPACE
  FigureSpace: WideChar        = #$2007; // U+2007 FIGURE SPACE
*)

var
  LogFmtX: procedure(const AFormat: string; const AData: array of const; const AIndent: Integer = 0) of object;

implementation

{$IFDEF EXACT_FLOAT_TO_STRING_USE_OS_LOCALE}
uses
  Winapi.Windows;
{$ENDIF}

const
  BitsInBufElem = SizeOf(TSglWord) * 8; // SizeOfAryElem*8;

var
  SPositiveSign: string =              '+';          // LOCALE_SPOSITIVESIGN, at most 4 characters
  SNegativeSign: string =              '-';          // LOCALE_SNEGATIVESIGN, at most 4 characters
  SPosInfinity:  string =              'Infinity';   // LOCALE_SPOSINFINITY
  SNegInfinity:  string =              '-Infinity';  // LOCALE_SNEGINFINITY
  SNativeDigits: array[0..9] of Char = '0123456789'; // LOCALE_SNATIVEDIGITS
  INegNumber:    Integer =             1;            // LOCALE_INEGNUMBER 0 = "(1.1), 1 = "-1.1", 2 = "- 1.1", 3 = "1.1-", 4 = "1.1 -"
  SGrouping:     string =              '3;0';        // LOCALE_SGROUPING
  SIGN_ARRAY: array[Boolean] of Char = '+-';

{$IFDEF DEBUG}
procedure LogFmt(const AFormat: string; const AData: array of const; const AIndent: Integer = 0);
begin
  if Assigned(LogFmtX) then
    LogFmtX(AFormat, AData, AIndent);
end;
{$ENDIF}

procedure MultiplyAndAdd(const AMultiplican, AMultiplier, ACarryIn: TSglWord; var ACarryOut, AProduct: TSglWord);
var
  LTmp: TFloatParts;
begin
  // Cast to TDblWord so the product cannot overflow Int32 when {$Q+} is active.
  LTmp.W := TDblWord(AMultiplican) * AMultiplier + ACarryIn;

  ACarryOut := LTmp.H;
  AProduct := LTmp.L;
end;

procedure DivideAndRemainder(const ANumeratorHi, ANumeratorLo: TSglWord; const ADivisor: TSglWord; var AQuotient, ARemainder: TSglWord);
var
  LNumerator: TFloatParts;
  LQuotient: TDblWord;
begin
  Assert(ADivisor <> 0, 'DivideAndRemainder: division by zero');

  LNumerator.H := ANumeratorHi;
  LNumerator.L := ANumeratorLo;

  LQuotient := LNumerator.W div ADivisor;
  Assert(LQuotient <= High(TSglWord), 'DivideAndRemainder: quotient does not fit in TSglWord');

  AQuotient := TSglWord(LQuotient);
  ARemainder := TSglWord(LNumerator.W mod ADivisor);
end;

function AddSign(const AStringValue: string; const AIsNegative: Boolean): string;
begin
  {
    LOCALE_INEGNUMBER
      0 = "(1.1)
      1 = "-1.1"
      2 = "- 1.1"
      3 = "1.1-"
      4 = "1.1 -"
  }
  if AIsNegative then
  begin
    case INegNumber of
      0: Result := '(' + AStringValue + ')';           // "(1.1)"
      1: Result := SNegativeSign + AStringValue;       // "-1.1"
      2: Result := SNegativeSign + ' ' + AStringValue; // "- 1.1"
      3: Result := AStringValue + SNegativeSign;       // "1.1-"
      4: Result := AStringValue + ' ' + SNegativeSign; // "1.1 -"
      else
        Result := SNegativeSign + AStringValue;
    end
  end
  else
  begin
    case INegNumber of
      0: Result := AStringValue;                       // "1.1"
      1: Result := SPositiveSign + AStringValue;       // "+1.1"
      2: Result := SPositiveSign + ' ' + AStringValue; // "+ 1.1"
      3: Result := AStringValue + SPositiveSign;       // "1.1+"
      4: Result := AStringValue + ' ' + SPositiveSign; // "1.1 +"
      else
        Result := SPositiveSign + AStringValue;
    end;
  end;
end;

function FloatingBinPointToDecStr(const AValue; const AValNbrBits, AValBinExp: Integer; const ANegative: Boolean;
    const ADecimalPoint: string = '.'; const AThousandsSep: string = ''; const ADigitGroups: Integer = 0): string;

{$IFDEF DEBUG}
  procedure LogManExp(const ARem: string; const AMan: array of TSglWord; const ABinExp, ADecExp, ANbrManElem: Integer);
  var
    LStringValue: string;
    LIndex: Integer;
  begin
    LogFmt('%s: BinExp=%d, DecExp=%d, NbrManElem=%d', [ARem, ABinExp, ADecExp, ANbrManElem]);
    LStringValue := '';

    for LIndex := 0 to ANbrManElem - 1 do
      LStringValue := Format(' %2.2x', [AMan[LIndex]]) + LStringValue;

    LogFmt('%s', [LStringValue], 1);
  end;
{$ENDIF}

var
  LMantissaArray: array of TSglWord;
  LCryE: TSglWord;
  LCry: TDblWord;
  LMantissaCount: Integer;
  LBinExp: Integer; // neg of # binary fraction bits
  LDecExp: Integer; // neg of # decimal fraction bits
  LDecimalCount: Integer;
  LIndex: Integer;
  LMantissaIndex: Integer;
  LTmpInt: TDblWord;
  LChar: Char;
  LTempFloatParts: TFloatParts;
begin
  {
    Value = Mantissa * 2^BinExp * 10^DecExp
  }

  { Load Mantissa and binary exponent: }
  LMantissaCount := (AValNbrBits + BitsInBufElem - 1) div BitsInBufElem;
  SetLength(LMantissaArray, LMantissaCount);
  Move(AValue, LMantissaArray[0], (AValNbrBits + 7) div 8); { Assuming little endian input }

  { Set exponents: (Value = Mantissa * 2^BinExp * 10^DecExp) }
  LBinExp := AValBinExp;
  LDecExp := 0;

  { Reduce mantissa to minimum number of bits (i.e. while mantissa is odd, div by 2 and inc binary exponent): }
{$IFDEF DEBUG}
  LogManExp('Before trimming', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}

  while (LMantissaCount > 0) and (LBinExp < 0) and not Odd(LMantissaArray[0]) do
  begin
    LCry := 0;

    for LIndex := LMantissaCount - 1 downto 0 do
    begin
      LTmpInt := (LCry shl BitsInBufElem) or LMantissaArray[LIndex];
      LMantissaArray[LIndex] := TSglWord(LTmpInt shr 1);
      LCry := LTmpInt and 1;
    end;

    Inc(LBinExp);

{$IFDEF DEBUG}
    LogManExp('Shifting down', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}

    if LMantissaArray[LMantissaCount - 1] = 0 then
      Dec(LMantissaCount);
  end;

  { Check for zero: }
  if LMantissaCount = 0 then
  begin
    Result := AddSign('0', ANegative);
    Exit;
  end;

   {
      Repeatably multiply by 10 until there is no more fraction. Decrement the DecExp at the same time.
      Note that a multiply by 10 is same as mul. by 5 and inc of BinExp exponent.
      Also note that a multiply by 5 adds two or three bits to number of mantissa bits.
   }
  LDecimalCount := -LBinExp; { Observe! 0.5, 0.25, 0.125, 0.0625, 0.03125, ... }
  LIndex := LMantissaCount + (3 * LDecimalCount + BitsInBufElem - 1) div BitsInBufElem;

  if Length(LMantissaArray) < LIndex then
    SetLength(LMantissaArray, LIndex);

{$IFDEF DEBUG}
  LogManExp('Prep mul out', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}

  LIndex := 1;
  while LIndex <= LDecimalCount do
  begin
    LCryE := 0;

    for LMantissaIndex := 0 to LMantissaCount - 1 do
      MultiplyAndAdd(LMantissaArray[LMantissaIndex], 5, LCryE, LCryE, LMantissaArray[LMantissaIndex]);

    if LCryE <> 0 then
    begin
      Inc(LMantissaCount);
      LMantissaArray[LMantissaCount - 1] := LCryE;
    end;

    Inc(LBinExp);
    Dec(LDecExp);

{$IFDEF DEBUG}
    LogManExp('Mul out', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}

    Inc(LIndex);
  end;

{$IFDEF DEBUG}
  LogManExp('Finished multiplies', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}

  { Finish reducing BinExp to 0 by shifting mantissa up: }
  while LBinExp > 0 do
  begin
    LCry := 0;

    for LIndex := 0 to LMantissaCount - 1 do
    begin
      LTempFloatParts.W := LMantissaArray[LIndex] shl 1;
      LMantissaArray[LIndex] := LTempFloatParts.L + LCry;
      LCry := LTempFloatParts.H;
    end;

    Dec(LBinExp);

    if LCry <> 0 then
    begin
      Inc(LMantissaCount);

      if Length(LMantissaArray) < LMantissaCount then
        SetLength(LMantissaArray, LMantissaCount);

      LMantissaArray[LMantissaCount - 1] := LCry;
    end;

{$IFDEF DEBUG}
    LogManExp('Shifting up', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}
  end;

   { Repeatably divide by 10 and use remainders to create decimal string }
  Result := '';

{$IFDEF DEBUG}
  LogManExp('Before division', LMantissaArray, LBinExp, LDecExp, LMantissaCount);
{$ENDIF}

  repeat
    { If not first then place separators: }
    if Result <> '' then
    begin
      if LDecExp = 0 then
        Result := ADecimalPoint + Result
      else if (ADigitGroups = 5) and ((LDecExp mod 5) = 0) then
        Result := AThousandsSep + Result
      else if (ADigitGroups = 3) and ((LDecExp mod 3) = 0) then
        Result := AThousandsSep + Result;
    end;

    { DivideAndRemainder mantissa array by 10: }
    LCryE := 0;

    for LIndex := LMantissaCount - 1 downto 0 do
      DivideAndRemainder(LCryE, LMantissaArray[LIndex], 10, LMantissaArray[LIndex], LCryE);

    Inc(LDecExp);
    LChar := SNativeDigits[LCryE];
    Result := LChar + Result;

    if (LMantissaCount > 0) and (LMantissaArray[LMantissaCount - 1] = 0) then
      Dec(LMantissaCount);
  until (LDecExp > 0) and (LMantissaCount = 0);

  Result := AddSign(Result, ANegative);
end;

{$IFDEF WIN32}
procedure AnalyzeFloat(const AValue: Extended; var ANumberType: TTypeFloat; var ANegative: Boolean; var AExponent: Word;
  var AMantissa: Int64);
var
  LValueRec: TExtendedFloat absolute AValue;
begin
  AMantissa := LValueRec.Mantissa;
  ANegative := (LValueRec.Exponent and $8000) <> 0;
  AExponent := (LValueRec.Exponent and $7FFF);

  if AExponent = $7FFF then
  begin
    // Infinity = exponent all 1s, all 63 fraction bits zero. The explicit integer bit
    // (bit 63) may be 0 (pseudo-infinity, invalid on modern x87 but accepted for legacy)
    // or 1 (canonical x87 Infinity — what FLD produces when promoting a Double Inf).
    if (AMantissa and $7FFFFFFFFFFFFFFF) = 0 then
      ANumberType := tfInfinity
    else
    begin
      AMantissa := (AMantissa and $3FFFFFFFFFFFFFFF);

      if ((LValueRec.Mantissa and $4000000000000000) = 0) then
        ANumberType := tfSignalingNan
      else if (AMantissa = 0) then
        ANumberType := tfIndefinite
      else
        ANumberType := tfQuietNan
    end
  end
  else if (AExponent = 0) then
  begin
    if (AMantissa = 0) then
      ANumberType := tfZero
    else
      ANumberType := tfDenormal
  end
  else
    ANumberType := tfNormal;
end;
{$ENDIF}

procedure AnalyzeFloat(const AValue: Double; var ANumberType: TTypeFloat; var ANegative: Boolean; var AExponent: Word;
  var AMantissa: Int64);
const
  DBL_SIGN_MASK         = Int64($8000000000000000); // bit 63
  DBL_EXPONENT_MASK     = Int64($7FF0000000000000); // bits 62..52
  DBL_FRACTION_MASK     = Int64($000FFFFFFFFFFFFF); // bits 51..0
  DBL_QUIET_BIT         = Int64($0008000000000000); // bit 51 (MSB of fraction): 1 = QNaN, 0 = SNaN
  DBL_NAN_PAYLOAD_MASK  = Int64($0007FFFFFFFFFFFF); // bits 50..0
var
  LValueRec: TDoubleRecord absolute AValue;
begin
  AMantissa := LValueRec.AsInt64 and DBL_FRACTION_MASK;
  ANegative := (LValueRec.AsInt64 and DBL_SIGN_MASK) <> 0;
  AExponent := (LValueRec.AsInt64 and DBL_EXPONENT_MASK) shr 52;

  if AExponent = $7FF then
  begin
    if AMantissa = 0 then
      ANumberType := tfInfinity
    else if (LValueRec.AsInt64 and DBL_QUIET_BIT) = 0 then
      ANumberType := tfSignalingNan
    else if (AMantissa and DBL_NAN_PAYLOAD_MASK) = 0 then
      ANumberType := tfIndefinite
    else
      ANumberType := tfQuietNan;
  end
  else if AExponent = 0 then
  begin
    if AMantissa = 0 then
      ANumberType := tfZero
    else
      ANumberType := tfDenormal;
  end
  else
    ANumberType := tfNormal;
end;

function IsUnicodeSpace(const AStringValue: string): Boolean;
begin
  Result := False;

  if Length(AStringValue) <> 1 then
    Exit;

  case Word(AStringValue[1]) of
    $00A0, $1680, $2000, $2001, $2002, $2003, $2004, $2005,
    $2006, $2007, $2008, $2009, $200A, $202F, $205F, $3000: Result := True;
  end;
end;

function ResolveDigitGroups(const AThousandsSep: string; const ADigitGroups: Integer): Integer;
begin
  // If a ThousandsSeparator is present, but the DigitGroups parameter is zero, then auto-guess grouping
  // (Because why else would you specify a separator if you didn't want one)
  if (ADigitGroups = 0) and (AThousandsSep <> '') then
  begin
    if IsUnicodeSpace(AThousandsSep) then
      Result := 5
    else
      Result := 3;
  end
  else
    Result := ADigitGroups;
end;

function ReadGroupingFromLocale: Integer;
begin
  {
    Handling groups is fairly difficult.

      Specification  Resulting string
      3;0            3,000,000,000,000
      3;2;0          30,00,00,00,00,000
      3              3000000000,000
      3;2            30000000,00,000

    We'll just read the first digit
  }
  Result := 0;

  if SGrouping <> '' then
  begin
    case SGrouping[1] of
      '0'..'9': Result := Ord(SGrouping[1]) - Ord('0');
    end;
  end;
end;

{$IFDEF WIN32}
function ExactFloatToStrEx(const AValue: Extended; const ADecimalPoint: string = '.'; const AThousandsSep: string = '';
  const ADigitGroups: Integer = 0): string;
var
  LNumberType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
  LThousandsSeparator: string;
  L0DigitGroups: Integer;
const
  BIAS = $3FFF;
begin
{
  ThousandsSep:
      ' ': group digits in groups of 5
      '', #0: no digit grouping
}
  AnalyzeFloat(AValue, LNumberType, LNegative, LExponent, LMantissa);

  // Convert legacy #0 char to an actual empty string.
  if AThousandsSep = #0 then
    LThousandsSeparator := ''
  else
    LThousandsSeparator := AThousandsSep;

  L0DigitGroups := ResolveDigitGroups(LThousandsSeparator, ADigitGroups);

  case LNumberType of
    tfNormal:       Result := FloatingBinPointToDecStr(LMantissa, 64, (LExponent - BIAS) - 63, LNegative, ADecimalPoint,
      LThousandsSeparator, L0DigitGroups);
    tfDenormal:     Result := FloatingBinPointToDecStr(LMantissa, 64, (-BIAS - 62), LNegative, ADecimalPoint,
      LThousandsSeparator, L0DigitGroups);
    tfQuietNan:     Result := Format('QNaN(%d)', [LMantissa]);
    tfSignalingNan: Result := Format('SNaN(%d)', [LMantissa]);
    tfZero:         Result := AddSign('0', LNegative);
    tfIndefinite:   Result := 'Indefinite';
    tfInfinity:
      begin
        if LNegative then
          Result := SNegInfinity
        else
          Result := SPosInfinity;
      end;
    else
      Result := 'UnknownNumberType';
  end;
end;

function ExactFloatToStr(const AValue: Extended): string;
begin
  Result := ExactFloatToStr(AValue, FormatSettings);
end;

function ExactFloatToStr(const AValue: Extended; const AFormatSettings: TFormatSettings): string;
begin
{
    NOTE: Only AFormatSettings.DecimalSeparator and AFormatSettings.ThousandSeparator are honored.
    TFormatSettings does not carry a digit-grouping pattern, so the group size is taken from the
    module-level SGrouping variable (populated from the OS locale in InitFormatSettings).
}
  Result := ExactFloatToStrEx(AValue, AFormatSettings.DecimalSeparator, AFormatSettings.ThousandSeparator,
    ReadGroupingFromLocale);
end;

function ParseFloat(const AValue: Extended): string;
var
  LValueRec: TExtendedFloat absolute AValue;
begin
  // This call parses an extended value to its sign, exponent, and mantissa.
  Result := Format('Ext(Sgn="%s",Exp=$%4.4x,Man=$%16.16x)', [SIGN_ARRAY[(LValueRec.Exponent and $8000) <> 0], (LValueRec.Exponent and $7FFF),
    LValueRec.Mantissa]);
end;
{$ENDIF}

{$IFDEF CPUX64}
function ExactFloatToStrEx(const AValue: Double; const ADecimalPoint: string = '.'; const AThousandsSep: string = '';
  const ADigitGroups: Integer = 0): string;
var
  LNumberType: TTypeFloat;
  LNegative: Boolean;
  LExponent: Word;
  LMantissa: Int64;
  LFullMantissa: Int64;
  LThousandsSeparator: string;
  L0DigitGroups: Integer;
const
  BIAS = $3FF;                              // Double's exponent bias
  DBL_IMPLICIT_INTEGER_BIT = Int64($0010000000000000); // bit 52 (the implicit "1" for normals)
begin
  AnalyzeFloat(AValue, LNumberType, LNegative, LExponent, LMantissa);

  if AThousandsSep = #0 then
    LThousandsSeparator := ''
  else
    LThousandsSeparator := AThousandsSep;

  L0DigitGroups := ResolveDigitGroups(LThousandsSeparator, ADigitGroups);

  case LNumberType of
    tfNormal:
      begin
        // Reconstruct the full 53-bit mantissa by OR-ing the implicit leading 1 back in.
        LFullMantissa := LMantissa or DBL_IMPLICIT_INTEGER_BIT;
        // Value = mantissa * 2^(exp - BIAS - 52)
        Result := FloatingBinPointToDecStr(LFullMantissa, 53, (LExponent - BIAS) - 52, LNegative, ADecimalPoint,
          LThousandsSeparator, L0DigitGroups);
      end;
    tfDenormal:
      // Denormal: no implicit bit, effective exponent = 1 - BIAS = -1022. Value = mantissa * 2^(-1022-52).
      Result := FloatingBinPointToDecStr(LMantissa, 52, (-BIAS - 51), LNegative, ADecimalPoint,
        LThousandsSeparator, L0DigitGroups);
    tfQuietNan:     Result := Format('QNaN(%d)', [LMantissa]);
    tfSignalingNan: Result := Format('SNaN(%d)', [LMantissa]);
    tfZero:         Result := AddSign('0', LNegative);
    tfIndefinite:   Result := 'Indefinite';
    tfInfinity:
      begin
        if LNegative then
          Result := SNegInfinity
        else
          Result := SPosInfinity;
      end;
    else
      Result := 'UnknownNumberType';
  end;
end;

function ExactFloatToStr(const AValue: Double): string;
begin
  Result := ExactFloatToStr(AValue, FormatSettings);
end;

function ExactFloatToStr(const AValue: Double; const AFormatSettings: TFormatSettings): string;
begin
  Result := ExactFloatToStrEx(AValue, AFormatSettings.DecimalSeparator, AFormatSettings.ThousandSeparator,
    ReadGroupingFromLocale);
end;
{$ENDIF}

function ParseFloat(const AValue: Double): string;
var
  LValueRec: TDoubleRecord absolute AValue;
begin
  // This call parses a double value to its sign, exponent, and mantissa.
  Result := Format('Dbl(Sgn="%s",Exp=$%3.3x,Man=$%13.13x)', [SIGN_ARRAY[(LValueRec.AsInt64 and $8000000000000000) <> 0],
    ((LValueRec.AsInt64 and $7FF0000000000000) shr 52), (LValueRec.AsInt64 and $000FFFFFFFFFFFFF)]);
end;

function ParseFloat(const AValue: Single): string;
var
  LValueRec: LongInt absolute AValue;
begin
  { This call parses a single value to its sign, exponent, and mantissa. }
  Result := Format('Sgl(Sgn="%s",Exp=$%2.2x,Man=$%6.6x)', [SIGN_ARRAY[(LValueRec and $80000000) <> 0],
    ((LValueRec and $7F800000) shr 23), (LValueRec and $007FFFFF)]);
end;

{$IFDEF EXACT_FLOAT_TO_STRING_USE_OS_LOCALE}
procedure InitFormatSettings;
const
  //Windows Vista
  LOCALE_SPOSINFINITY = $0000006a;   // + Infinity, eg "infinity"
  LOCALE_SNEGINFINITY = $0000006b;   // - Infinity, eg "-infinity"
var
  LLocaleID: LCID;
  LStringValue: string;
begin
  LLocaleID := LOCALE_USER_DEFAULT;

{$IFDEF MSWINDOWS}
  {$WARN SYMBOL_PLATFORM OFF}
  SPositiveSign := GetLocaleStr(LLocaleID, LOCALE_SPOSITIVESIGN, '+'); // at most 4 characters
  SNegativeSign := GetLocaleStr(LLocaleID, LOCALE_SNEGATIVESIGN, '-'); // at most 4 characters
  SPosInfinity  := GetLocaleStr(LLocaleID, LOCALE_SPOSINFINITY,  'Infinity');   //
  SNegInfinity  := GetLocaleStr(LLocaleID, LOCALE_SNEGINFINITY,  '-Infinity');  //
  SGrouping     := GetLocaleStr(LLocaleID, LOCALE_SGROUPING,     '3;0');        //

  INegNumber    := StrToIntDef(GetLocaleStr(LLocaleID, LOCALE_INEGNUMBER, '1'), 1);

  LStringValue := GetLocaleStr(LLocaleID, LOCALE_SNATIVEDIGITS, '0123456789');

  if Length(LStringValue) = 10 then
    Move(LStringValue[1], SNativeDigits[0], 10 * SizeOf(Char));
  {$WARN SYMBOL_PLATFORM ON}
{$ENDIF}
end;

initialization
  InitFormatSettings;
{$ENDIF}

end.
