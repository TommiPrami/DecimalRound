unit DRUnit.Round;

interface

{$INCLUDE DecimalRound.inc}

  { Convenience wrappers that round AValue to ANumberOfDecimals decimal
    fraction digits using half-up rounding (round to nearest, ties away from
    zero). Equivalent to DecimalRoundEx(AValue, ANumberOfDecimals, drcHalfUp).

    The functions have a two times "epsilon" error allowance built in for the
    Single, Double, and Extended argument respectively.

    Special values (all build configurations):
      - NaN in -> NaN out.
      - ±Infinity, and values whose scaled magnitude (AValue * 10^N) would
        overflow the internal Int64 conversion, are returned unchanged (see
        MAX_SAFE_SCALED_VALUE in DRUnit.Consts). }
  function DecimalRound(const AValue: Single; const ANumberOfDecimals: Integer = 2): Extended; overload;
  function DecimalRound(const AValue: Double; const ANumberOfDecimals: Integer = 2): Extended; overload;
{$IFDEF SUPPORTS_TRUE_EXTENDED}
  function DecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer = 2): Extended; overload;
{$ENDIF}

implementation

uses
  DRUnit.Types, DRUnit.RoundEx;

function DecimalRound(const AValue: Single; const ANumberOfDecimals: Integer = 2): Extended;
begin
  Result := DecimalRoundEx(AValue, ANumberOfDecimals, drcHalfUp);
end;

function DecimalRound(const AValue: Double; const ANumberOfDecimals: Integer = 2): Extended;
begin
  Result := DecimalRoundEx(AValue, ANumberOfDecimals, drcHalfUp);
end;

{$IFDEF SUPPORTS_TRUE_EXTENDED}
function DecimalRound(const AValue: Extended; const ANumberOfDecimals: Integer = 2): Extended;
begin
  Result := DecimalRoundEx(AValue, ANumberOfDecimals, drcHalfUp);
end;
{$ENDIF}

end.
