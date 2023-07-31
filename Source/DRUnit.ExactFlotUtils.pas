unit DRUnit.ExactFlotUtils;

(* *****************************************************************************

  There is no claim that these functions are perfect or efficient.
      However, they do support the binary floating point analysis
      programs T_BinaryFloatingPoint_1, _2, and IeeeNbrAnalyzer_Main.

  Pgm. 01/02/00 by John Herbster, herb-sci@swbell.net.

***************************************************************************** *)

interface

  function ExactFloatToStr(const AExtendedValue: Extended; const ASpaceInterval: Integer = 3): string;

  function FloatToHex(var AExtendedValue: Extended; const ALittleEndian: Boolean): string; overload;
  function FloatToHex(var ADoubleValue: Double; const ALittleEndian: Boolean): string; overload;
  function FloatToHex(var ASingleValue: Single; const ALittleEndian: Boolean): string; overload;

  function UnpackFloatToStr(var AExtendedValue: Extended): string; overload;
  function UnpackFloatToStr(var ADoubleValue: Double): string; overload;
  function UnpackFloatToStr(var ASingleValue: Single): string; overload;

  function Succ(const AExtendedValue: Extended): Extended; overload;
  function Succ(const ADoubleValue: Double): Double; overload;
  function Succ(const ASingleValue: Single): Single; overload;

  function Pred(const AExtendedValue: Extended): Extended; overload;
  function Pred(const ADoubleValue: Double): Double; overload;
  function Pred(const ASingleValue: Single): Single; overload;

implementation

uses
  System.SysUtils, System.Math, DRUnit.Consts, DRUnit.Utils, DRUnit.Types;

function ExactFloatToStr(const AExtendedValue: Extended; const ASpaceInterval: Integer = 3): string;

  procedure RaiseNumberTooSmallException;
  begin
    raise Exception.Create('ExactFloatToStr cannot handle numbers this small yet.');
  end;

var
  LSignificand,
  wn: Int64;
  dd: Int64;
  m: Int64;
  LExponent: Integer;
  d: Integer;
  LIndex: Integer;
  LSeparatorIndex: Integer;
  LNegative: Boolean;
  LExtendedtRec: TExtendedtRec;
begin
  if AExtendedValue = 0.00 then
    Exit('0');

  { Cast to exp and significant parts in "ER": }
  LExtendedtRec := TExtendedtRec(AExtendedValue);
  LSignificand := LExtendedtRec.Significand;
  LExponent := (LExtendedtRec.Exponent and $7FFF) - $4000;
  LNegative := (LExtendedtRec.Exponent and $8000) <> 0;

  if LNegative then
    Result := '-' else Result := '+';

  { Shift out whole number part into "wn": }
  wn := 0;
  while LExponent > -2 do
  begin
    Dec(LExponent);
    wn := (wn shl 1);

    if (LSignificand and $8000000000000000) <> 0 then
      wn := wn or 1;

    LSignificand := LSignificand shl 1;
  end;

  Result := Result + IntToStr(wn);

  if ASpaceInterval > 0 then
  begin
    LIndex := length(Result);

    while (LIndex > 5) and CharInSet(Result[LIndex], ['0'..'9']) do
    begin
      Dec(LIndex, 5);
      System.Insert(' ', Result, LIndex + 1);
    end;
  end;

  { Multiply out the fraction part }
  Result := Result + '.';

  { Make "dd" holder for the top byte of Exponent: }
  LIndex := NUMBER_OF_BITS_TO_CLEAR - 2 - LExponent;

  if LIndex > 64 - 4 then
    RaiseNumberTooSmallException;

  m := 1;
  m := m shl LIndex;
  dd := LSignificand shr (64 - NUMBER_OF_BITS_TO_CLEAR);
  LSignificand := LSignificand and MASK;

  LSeparatorIndex := 0;
  while (LSignificand <> 0) or (dd <> 0) do
  begin
    { Mul sig and dd by 10 }
    dd  := dd * 10;
    LSignificand := LSignificand * 10;

    { Remove new stuff in top byte of sig to dd }
    dd := dd + LSignificand shr (64 - 8);
    LSignificand := LSignificand and MASK;

    { Remove whole number part from "dd" to "d" }
    d  := dd div m;
    dd := dd mod m;

    if (ASpaceInterval > 0) and (LSeparatorIndex > 0) and ((LSeparatorIndex mod ASpaceInterval) = 0) then
      Result := Result + ' ';

    Inc(LSeparatorIndex);

    Result := Result + Char(Ord('0') + d);
  end;
end;

function FloatToHex(var AExtendedValue: Extended; const ALittleEndian: Boolean): string; overload;
var
  LIndex: Integer;
begin
  Result := '';

  for  LIndex:= 0 to SizeOf(AExtendedValue) - 1 do
  begin
    if ALittleEndian then
      Result := Result + IntToHex(tB10(AExtendedValue)[LIndex], 2)
    else
      Result := IntToHex(tB10(AExtendedValue)[LIndex], 2) + Result;
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
      Result := Result + IntToHex(tB8(ADoubleValue)[LIndex], 2)
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
      Result := Result + IntToHex(tB4(ASingleValue)[LIndex], 2)
    else
      Result := IntToHex(tB4(ASingleValue)[LIndex], 2) + Result;
    end;
end;

function UnpackFloatToStr(var AExtendedValue: Extended): string; overload;
var
  LNegative: boolean;
  LIndex: Integer;
  LExtendedtRec: TExtendedtRec;
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

  LExtendedtRec := TExtendedtRec(LExtendedValue);

  Result := Result + ' 2^' + IntToStr(LExtendedtRec.Exponent - $3ffe) + ' * $0.';

  for LIndex := 7 downto 0 do
    Result := Result + IntToHex(TB10(LExtendedValue)[LIndex], 2);
end;

function UnpackFloatToStr(var ADoubleValue: Double): string; overload;
var
  LNegative: Boolean;
  LIndex: Integer;
  LExtendedtRec: TExtendedtRec;
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

  LExtendedtRec := TExtendedtRec(LExtendedValue);

  Result := Result + ' 2^' + IntToStr(LExtendedtRec.Exponent - $3ffe) + ' * ';
  Result := Result + ' $0.';

  for LIndex:= 7 downto 1 do
    Result := Result + IntToHex(tB10(LExtendedValue)[LIndex], 2);

  SetLength(Result, Length(Result) - 1);
end;

function UnpackFloatToStr(var ASingleValue: single): string; overload;
var
  LNegative: Boolean;
  LIndex: Integer;
  LExtendedtRec: TExtendedtRec;
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

  LExtendedtRec := TExtendedtRec(LExtendedValue);

  Result := Result + ' 2^' + IntToStr(LExtendedtRec.Exponent - $3ffe) + ' * ';
  Result := Result + ' $0.';

  for LIndex:= 7 downto 5 do
    Result := Result + IntToHex(tB10(LExtendedValue)[LIndex], 2);
end;

function Succ(const AExtendedValue: Extended): Extended;
var
  LExtendedtRec: TExtendedtRec;
begin
  if AExtendedValue < 0.00 then
    Exit(-Pred(-AExtendedValue))
  else if AExtendedValue = 0.00 then
    Exit(+MinExtended)
  else if AExtendedValue = -MinExtended then
    Exit(0.00);

  LExtendedtRec := TExtendedtRec(AExtendedValue);
  Inc(LExtendedtRec.Significand);

  Assert(LExtendedtRec.Significand <> 0);

  if LExtendedtRec.Significand = 0 then
  begin
    LExtendedtRec.Significand := $8000000000000000;
    LExtendedtRec.Exponent := LExtendedtRec.Exponent + 1;
  end;

  Result := Extended(LExtendedtRec);
end;

function Pred(const AExtendedValue: Extended): Extended;
var
  LExtendedtRec: TExtendedtRec;
begin
  if AExtendedValue < 0.00 then
    Exit(-Succ(-AExtendedValue))
  else if AExtendedValue = 0.00 then
    Exit(+MinExtended)
  else if AExtendedValue = +MinExtended then
    Exit(0.00);

  LExtendedtRec := TExtendedtRec(AExtendedValue);
  Dec(LExtendedtRec.Significand);

  Assert(LExtendedtRec.Significand <> 0.00);

  While (LExtendedtRec.Significand <> 0) and ((LExtendedtRec.Significand and $8000000000000000) = 0) do
  begin
    LExtendedtRec.Significand := LExtendedtRec.Significand shl 1;
    LExtendedtRec.Exponent := LExtendedtRec.Exponent - 1;
  end;

  Result := Extended(LExtendedtRec);
end;

function Succ(const ADoubleValue: Double): Double;
var
  LExtendedtRec: TExtendedtRec;
  LExtendedValue: Extended;
begin
  if ADoubleValue < 0.00 then
    Exit(-Pred(-ADoubleValue))
  else if ADoubleValue = 0.00 then
    Exit(+MinDouble)
  else if ADoubleValue = -MinDouble then
    Exit(0.00);

  LExtendedValue := ADoubleValue;
  LExtendedtRec := TExtendedtRec(LExtendedValue);
  LExtendedtRec.Significand := LExtendedtRec.Significand + INC_DOUBLE;

  Assert(LExtendedtRec.Significand <> 0);

  if (LExtendedtRec.Significand and $8000000000000000) = 0 then
  begin
    LExtendedtRec.Significand := LExtendedtRec.Significand shr 1 or $8000000000000000;
    LExtendedtRec.Exponent := LExtendedtRec.Exponent + 1;
  end;

  Result := Extended(LExtendedtRec);
end;

function Pred(const ADoubleValue: Double): Double;
var
  LExtendedtRec: TExtendedtRec;
  LExtendedValue: extended;
begin
  if ADoubleValue < 0 then
    Exit(-Succ(-ADoubleValue))
  else if ADoubleValue = 0 then
    Exit(-MinDouble)
  else if ADoubleValue = +MinDouble then
    Exit(0.00);

  LExtendedValue := ADoubleValue;
  LExtendedtRec := TExtendedtRec(LExtendedValue);

  LExtendedtRec.Significand := LExtendedtRec.Significand - INC_DOUBLE;

  Assert(LExtendedtRec.Significand <> 0);

  while (LExtendedtRec.Significand <> 0) and ((LExtendedtRec.Significand and $8000000000000000) = 0) do
  begin
    LExtendedtRec.Significand := LExtendedtRec.Significand shl 1;
    LExtendedtRec.Exponent := LExtendedtRec.Exponent - 1;
  end;

  Result := Extended(LExtendedtRec);
end;

function Succ(const ASingleValue: Single): Single;
var
  LExtendedtRec: TExtendedtRec;
  LExtendedValue: Extended;
begin
  if ASingleValue < 0.00 then
    Exit(-Pred(-ASingleValue))
  else if ASingleValue = 0.00 then
    Exit(+MinSingle)
  else if ASingleValue = -MinSingle then
    Exit(0.00);

  LExtendedValue  := ASingleValue;
  LExtendedtRec := TExtendedtRec(LExtendedValue);

  LExtendedtRec.Significand := LExtendedtRec.Significand + INC_SINGLE;

  Assert(LExtendedtRec.Significand <> 0);

  if (LExtendedtRec.Significand and $8000000000000000) = 0 then
  begin
    LExtendedtRec.Significand := LExtendedtRec.Significand shr 1 or $8000000000000000;
    LExtendedtRec.Exponent := LExtendedtRec.Exponent + 1;
  end;

  Result := Extended(LExtendedtRec);
end;

function Pred(const ASingleValue: Single): Single;
var
  LExtendedtRec: TExtendedtRec;
  LExtendedValue: Extended;
begin
  if ASingleValue < 0.00 then
    Exit(-Succ(-ASingleValue))
  else if ASingleValue = 0.00 then
    Exit(-MinSingle)
  else if ASingleValue = +MinSingle then
    Exit(0.00);

  LExtendedValue := ASingleValue;
  LExtendedtRec := TExtendedtRec(LExtendedValue);

  LExtendedtRec.Significand := LExtendedtRec.Significand - INC_SINGLE;

  Assert(LExtendedtRec.Significand <> 0);

  while (LExtendedtRec.Significand <> 0) and ((LExtendedtRec.Significand and $8000000000000000) = 0) do
  begin
    LExtendedtRec.Significand := LExtendedtRec.Significand shl 1;
    LExtendedtRec.Exponent := LExtendedtRec.Exponent - 1;
  end;

  Result := Extended(LExtendedtRec);
end;

end.
