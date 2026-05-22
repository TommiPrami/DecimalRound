unit DRUnit.ExactFloatUtils;

(* *****************************************************************************

  There is no claim that these functions are perfect or efficient.
      However, they do support the binary floating point analysis
      programs T_BinaryFloatingPoint_1, _2, and IeeeNbrAnalyzer_Main.

  Pgm. 01/02/00 by John Herbster, herb-sci@swbell.net.

***************************************************************************** *)

{$INCLUDE DecimalRound.inc}
{$OVERFLOWCHECKS OFF}
{$RANGECHECKS OFF}
// Deliberate bit-level manipulation of the IEEE significand of
// Single / Double / Extended values. The significand is held in an Int64
// field, but its high bit is set for any normalised value — meaning
// ordinary signed arithmetic on it (Inc/Dec, +/- INC_DOUBLE etc.) would
// trap EIntOverflow when the host project enables overflow checks.
// Likewise, intermediate shift / multiply expressions in ExactFloatToStr
// step through the full 64-bit range. The two switch directives above
// force checks OFF for this unit regardless of the caller's settings.
// Do NOT write compiler-directive literals inside { } comments here:
// Delphi parses them as real directives even within a brace comment.

interface

  function ExactFloatToStr(const AExtendedValue: Extended; const ASpaceInterval: Integer = 3): string;

  function FloatToHex(var AExtendedValue: Extended; const ALittleEndian: Boolean): string; overload;
  function FloatToHex(var ADoubleValue: Double; const ALittleEndian: Boolean): string; overload;
  function FloatToHex(var ASingleValue: Single; const ALittleEndian: Boolean): string; overload;

  function UnpackFloatToStr(var AExtendedValue: Extended): string; overload;
  function UnpackFloatToStr(var ADoubleValue: Double): string; overload;
  function UnpackFloatToStr(var ASingleValue: Single): string; overload;

  { Successor / predecessor in the floating-point sense: returns the next
    (or previous) representable value. Renamed from Succ/Pred to avoid
    shadowing the system intrinsics.

    The Single and Double overloads operate on the native IEEE bit pattern
    and are platform-independent. The Extended overload still uses the
    80-bit-significand approach, so it is only declared when Extended is a
    real 80-bit type (SUPPORTS_TRUE_EXTENDED — currently CPUX86 only;
    on x64 Extended is just an alias for Double and that overload would
    collide with the Double one). }
{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function NextFloat(const AExtendedValue: Extended): Extended; overload;
{$ENDIF}
  function NextFloat(const ADoubleValue: Double): Double; overload;
  function NextFloat(const ASingleValue: Single): Single; overload;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function PrevFloat(const AExtendedValue: Extended): Extended; overload;
{$ENDIF}
  function PrevFloat(const ADoubleValue: Double): Double; overload;
  function PrevFloat(const ASingleValue: Single): Single; overload;

implementation

uses
  System.SysUtils, System.Math, DRUnit.Consts, DRUnit.Utils, DRUnit.Types;

function ExactFloatToStr(const AExtendedValue: Extended; const ASpaceInterval: Integer = 3): string;

  procedure RaiseNumberTooSmallException;
  begin
    raise Exception.Create('ExactFloatToStr cannot handle numbers this small yet.');
  end;

var
  LSignificand: Int64;
  LWholePart: Int64;
  LFractionAcc: Int64;
  LDivisor: Int64;
  LExponent: Integer;
  LDigit: Integer;
  LIndex: Integer;
  LSeparatorIndex: Integer;
  LNegative: Boolean;
  LExtendedRec: TExtendedRec;
begin
  if AExtendedValue = 0.00 then
    Exit('0');

  { Cast to exponent and significand parts: }
  LExtendedRec := TExtendedRec(AExtendedValue);
  LSignificand := LExtendedRec.Significand;
  LExponent := (LExtendedRec.Exponent and $7FFF) - $4000;
  LNegative := (LExtendedRec.Exponent and $8000) <> 0;

  if LNegative then
    Result := '-' else Result := '+';

  { Shift out whole number part into LWholePart: }
  LWholePart := 0;
  while LExponent > -2 do
  begin
    Dec(LExponent);
    LWholePart := (LWholePart shl 1);

    if (LSignificand and $8000000000000000) <> 0 then
      LWholePart := LWholePart or 1;

    LSignificand := LSignificand shl 1;
  end;

  Result := Result + IntToStr(LWholePart);

  if ASpaceInterval > 0 then
  begin
    LIndex := Length(Result);

    while (LIndex > 5) and CharInSet(Result[LIndex], ['0'..'9']) do
    begin
      Dec(LIndex, 5);
      System.Insert(' ', Result, LIndex + 1);
    end;
  end;

  { Multiply out the fraction part }
  Result := Result + '.';

  { LFractionAcc holds the top byte of the running significand; LDivisor is
    the place value used to extract one decimal digit per iteration. }
  LIndex := NUMBER_OF_BITS_TO_CLEAR - 2 - LExponent;

  if LIndex > (64 - 4) then
    RaiseNumberTooSmallException;

  LDivisor := 1;
  LDivisor := LDivisor shl LIndex;
  LFractionAcc := LSignificand shr (64 - NUMBER_OF_BITS_TO_CLEAR);
  LSignificand := LSignificand and MASK;

  LSeparatorIndex := 0;
  while (LSignificand <> 0) or (LFractionAcc <> 0) do
  begin
    { Multiply significand and accumulator by 10. }
    LFractionAcc := LFractionAcc * 10;
    LSignificand := LSignificand * 10;

    { Shift the new top byte of the significand into the accumulator. }
    LFractionAcc := LFractionAcc + LSignificand shr (64 - 8);
    LSignificand := LSignificand and MASK;

    { Extract the next decimal digit from the accumulator. }
    LDigit := LFractionAcc div LDivisor;
    LFractionAcc := LFractionAcc mod LDivisor;

    if (ASpaceInterval > 0) and (LSeparatorIndex > 0) and ((LSeparatorIndex mod ASpaceInterval) = 0) then
      Result := Result + ' ';

    Inc(LSeparatorIndex);

    Result := Result + Char(Ord('0') + LDigit);
  end;
end;

function FloatToHex(var AExtendedValue: Extended; const ALittleEndian: Boolean): string; overload;
var
  LIndex: Integer;
begin
  Result := '';

  for  LIndex := 0 to SizeOf(AExtendedValue) - 1 do
  begin
    if ALittleEndian then
      Result := Result + IntToHex(TB10(AExtendedValue)[LIndex], 2)
    else
      Result := IntToHex(TB10(AExtendedValue)[LIndex], 2) + Result;
  end;
end;

function FloatToHex(var ADoubleValue: Double; const ALittleEndian: Boolean): string; overload;
var
  LIndex: Integer;
begin
  Result := '';

  for LIndex := 0 to SizeOf(ADoubleValue) - 1 do
  begin
    if ALittleEndian then
      Result := Result + IntToHex(TB8(ADoubleValue)[LIndex], 2)
    else
      Result := IntToHex(TB8(ADoubleValue)[LIndex], 2) + Result;
  end;
end;

function FloatToHex(var ASingleValue: Single; const ALittleEndian: Boolean): string; overload;
var
  LIndex: Integer;
begin
  Result := '';

  for LIndex := 0 to SizeOf(ASingleValue) - 1 do
  begin
    if ALittleEndian then
      Result := Result + IntToHex(TB4(ASingleValue)[LIndex], 2)
    else
      Result := IntToHex(TB4(ASingleValue)[LIndex], 2) + Result;
    end;
end;

function UnpackFloatToStr(var AExtendedValue: Extended): string; overload;
var
  LNegative: Boolean;
  LIndex: Integer;
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  LExtendedValue := AExtendedValue;
  LNegative := LExtendedValue<0;

  if LNegative then
  begin
    Result := '-';
    LExtendedValue := -LExtendedValue;
  end
  else
    Result := '+';

  LExtendedRec := TExtendedRec(LExtendedValue);

  Result := Result + ' 2^' + IntToStr(LExtendedRec.Exponent - $3ffe) + ' * $0.';

  for LIndex := 7 downto 0 do
    Result := Result + IntToHex(TB10(LExtendedValue)[LIndex], 2);
end;

function UnpackFloatToStr(var ADoubleValue: Double): string; overload;
var
  LNegative: Boolean;
  LIndex: Integer;
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  LExtendedValue := ADoubleValue;
  LNegative := LExtendedValue < 0;

  if LNegative then
  begin
    Result := '-';
    LExtendedValue := -LExtendedValue;
  end
  else
    Result := '+';

  LExtendedRec := TExtendedRec(LExtendedValue);

  Result := Result + ' 2^' + IntToStr(LExtendedRec.Exponent - $3ffe) + ' * ';
  Result := Result + ' $0.';

  for LIndex := 7 downto 1 do
    Result := Result + IntToHex(TB10(LExtendedValue)[LIndex], 2);

  SetLength(Result, Length(Result) - 1);
end;

function UnpackFloatToStr(var ASingleValue: Single): string; overload;
var
  LNegative: Boolean;
  LIndex: Integer;
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  LExtendedValue := ASingleValue;
  LNegative := LExtendedValue < 0;

  if LNegative then
  begin
    Result := '-';
    LExtendedValue := -LExtendedValue;
  end
  else
    Result := '+';

  LExtendedRec := TExtendedRec(LExtendedValue);

  Result := Result + ' 2^' + IntToStr(LExtendedRec.Exponent - $3ffe) + ' * ';
  Result := Result + ' $0.';

  for LIndex := 7 downto 5 do
    Result := Result + IntToHex(TB10(LExtendedValue)[LIndex], 2);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function NextFloat(const AExtendedValue: Extended): Extended;
var
  LExtendedRec: TExtendedRec;
begin
{$WARN SYMBOL_PLATFORM OFF}
  if AExtendedValue < 0.00 then
    Exit(-PrevFloat(-AExtendedValue))
  else if AExtendedValue = 0.00 then
    Exit(MinExtended)
  else if AExtendedValue = -MinExtended then
    Exit(0.00);
{$WARN SYMBOL_PLATFORM ON}

  LExtendedRec := TExtendedRec(AExtendedValue);
  Inc(LExtendedRec.Significand);

  Assert(LExtendedRec.Significand <> 0);

  if LExtendedRec.Significand = 0 then
  begin
    LExtendedRec.Significand := $8000000000000000;
    LExtendedRec.Exponent := LExtendedRec.Exponent + 1;
  end;

  Result := Extended(LExtendedRec);
end;

function PrevFloat(const AExtendedValue: Extended): Extended;
var
  LExtendedRec: TExtendedRec;
begin
{$WARN SYMBOL_PLATFORM OFF}
  if AExtendedValue < 0.00 then
    Exit(-NextFloat(-AExtendedValue))
  else if AExtendedValue = 0.00 then
    Exit(-MinExtended)
  else if AExtendedValue = MinExtended then
    Exit(0.00);
{$WARN SYMBOL_PLATFORM ON}

  LExtendedRec := TExtendedRec(AExtendedValue);
  Dec(LExtendedRec.Significand);

  Assert(LExtendedRec.Significand <> 0.00);

  While (LExtendedRec.Significand <> 0) and ((LExtendedRec.Significand and $8000000000000000) = 0) do
  begin
    LExtendedRec.Significand := LExtendedRec.Significand shl 1;
    LExtendedRec.Exponent := LExtendedRec.Exponent - 1;
  end;

  Result := Extended(LExtendedRec);
end;
{$ENDIF}

{ ----- Double / Single overloads: operate directly on the native IEEE-754
        bit pattern. Platform-independent (no TExtendedRec dependency) and
        gives correct 1-ULP semantics.

        Convention preserved from the original Herbster code:
          NextFloat(0)         = MinDouble / MinSingle  (smallest normal)
          PrevFloat(0)         = -MinDouble / -MinSingle
          NextFloat(-MinX)     = 0
          PrevFloat(+MinX)     = 0
        i.e. subnormals are skipped at the zero boundary. }

function NextFloat(const ADoubleValue: Double): Double;
var
  LBits: Int64;
begin
  if ADoubleValue = 0.0 then
    Exit(MinDouble)
  else if ADoubleValue = -MinDouble then
    Exit(0.0);

  LBits := PInt64(@ADoubleValue)^;
  if (LBits and Int64($8000000000000000)) = 0 then
    Inc(LBits)   // positive: next-larger magnitude
  else
    Dec(LBits);  // negative: next-smaller magnitude (closer to zero)
  Result := PDouble(@LBits)^;
end;

function PrevFloat(const ADoubleValue: Double): Double;
var
  LBits: Int64;
begin
  if ADoubleValue = 0.0 then
    Exit(-MinDouble)
  else if ADoubleValue = +MinDouble then
    Exit(0.0);

  LBits := PInt64(@ADoubleValue)^;
  if (LBits and Int64($8000000000000000)) = 0 then
    Dec(LBits)   // positive: next-smaller magnitude (closer to zero)
  else
    Inc(LBits);  // negative: next-larger magnitude
  Result := PDouble(@LBits)^;
end;

function NextFloat(const ASingleValue: Single): Single;
var
  LBits: Cardinal;
begin
  if ASingleValue = 0.0 then
    Exit(MinSingle)
  else if ASingleValue = -MinSingle then
    Exit(0.0);

  LBits := PCardinal(@ASingleValue)^;
  if (LBits and $80000000) = 0 then
    Inc(LBits)
  else
    Dec(LBits);
  Result := PSingle(@LBits)^;
end;

function PrevFloat(const ASingleValue: Single): Single;
var
  LBits: Cardinal;
begin
  if ASingleValue = 0.0 then
    Exit(-MinSingle)
  else if ASingleValue = +MinSingle then
    Exit(0.0);

  LBits := PCardinal(@ASingleValue)^;
  if (LBits and $80000000) = 0 then
    Dec(LBits)
  else
    Inc(LBits);
  Result := PSingle(@LBits)^;
end;

end.
