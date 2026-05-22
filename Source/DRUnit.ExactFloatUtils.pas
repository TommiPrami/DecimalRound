unit DRUnit.ExactFloatUtils;

(* *****************************************************************************

  There is no claim that these functions are perfect or efficient.
      However, they do support the binary floating point analysis
      programs T_BinaryFloatingPoint_1, _2, and IeeeNbrAnalyzer_Main.

  Pgm. 01/02/00 by John Herbster, herb-sci@swbell.net.

***************************************************************************** *)

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
    shadowing the system intrinsics. }
  function NextFloat(const AExtendedValue: Extended): Extended; overload;
  function NextFloat(const ADoubleValue: Double): Double; overload;
  function NextFloat(const ASingleValue: Single): Single; overload;

  function PrevFloat(const AExtendedValue: Extended): Extended; overload;
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

function NextFloat(const ADoubleValue: Double): Double;
var
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  if ADoubleValue < 0.00 then
    Exit(-PrevFloat(-ADoubleValue))
  else if ADoubleValue = 0.00 then
    Exit(MinDouble)
  else if ADoubleValue = -MinDouble then
    Exit(0.00);

  LExtendedValue := ADoubleValue;
  LExtendedRec := TExtendedRec(LExtendedValue);
  LExtendedRec.Significand := LExtendedRec.Significand + INC_DOUBLE;

  Assert(LExtendedRec.Significand <> 0);

  if (LExtendedRec.Significand and $8000000000000000) = 0 then
  begin
    LExtendedRec.Significand := LExtendedRec.Significand shr 1 or $8000000000000000;
    LExtendedRec.Exponent := LExtendedRec.Exponent + 1;
  end;

  Result := Extended(LExtendedRec);
end;

function PrevFloat(const ADoubleValue: Double): Double;
var
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  if ADoubleValue < 0 then
    Exit(-NextFloat(-ADoubleValue))
  else if ADoubleValue = 0 then
    Exit(-MinDouble)
  else if ADoubleValue = +MinDouble then
    Exit(0.00);

  LExtendedValue := ADoubleValue;
  LExtendedRec := TExtendedRec(LExtendedValue);

  LExtendedRec.Significand := LExtendedRec.Significand - INC_DOUBLE;

  Assert(LExtendedRec.Significand <> 0);

  while (LExtendedRec.Significand <> 0) and ((LExtendedRec.Significand and $8000000000000000) = 0) do
  begin
    LExtendedRec.Significand := LExtendedRec.Significand shl 1;
    LExtendedRec.Exponent := LExtendedRec.Exponent - 1;
  end;

  Result := Extended(LExtendedRec);
end;

function NextFloat(const ASingleValue: Single): Single;
var
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  if ASingleValue < 0.00 then
    Exit(-PrevFloat(-ASingleValue))
  else if ASingleValue = 0.00 then
    Exit(MinSingle)
  else if ASingleValue = -MinSingle then
    Exit(0.00);

  LExtendedValue := ASingleValue;
  LExtendedRec := TExtendedRec(LExtendedValue);

  LExtendedRec.Significand := LExtendedRec.Significand + INC_SINGLE;

  Assert(LExtendedRec.Significand <> 0);

  if (LExtendedRec.Significand and $8000000000000000) = 0 then
  begin
    LExtendedRec.Significand := LExtendedRec.Significand shr 1 or $8000000000000000;
    LExtendedRec.Exponent := LExtendedRec.Exponent + 1;
  end;

  Result := Extended(LExtendedRec);
end;

function PrevFloat(const ASingleValue: Single): Single;
var
  LExtendedRec: TExtendedRec;
  LExtendedValue: Extended;
begin
  if ASingleValue < 0.00 then
    Exit(-NextFloat(-ASingleValue))
  else if ASingleValue = 0.00 then
    Exit(-MinSingle)
  else if ASingleValue = +MinSingle then
    Exit(0.00);

  LExtendedValue := ASingleValue;
  LExtendedRec := TExtendedRec(LExtendedValue);

  LExtendedRec.Significand := LExtendedRec.Significand - INC_SINGLE;

  Assert(LExtendedRec.Significand <> 0);

  while (LExtendedRec.Significand <> 0) and ((LExtendedRec.Significand and $8000000000000000) = 0) do
  begin
    LExtendedRec.Significand := LExtendedRec.Significand shl 1;
    LExtendedRec.Exponent := LExtendedRec.Exponent - 1;
  end;

  Result := Extended(LExtendedRec);
end;

end.
