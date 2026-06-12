# DecimalRound

### Routines for rounding IEEE-754 floats to specified number of decimal fractions

These routines round input values to fit as closely as possible to an
output number with desired number of decimal fraction digits.

Because, in general, numbers with decimal fractions cannot be exactly
represented in IEEE-754 floating binary point variables, error limits
are used to determine if the input numbers are intended to represent an
exact decimal fraction rather than a nearby value.   Thus an error limit
will be taken into account when deciding that a number input such as
1.295, which internally is represented 1.29499 99999 …, really should
be considered exactly 1.295 and that 0.29999 99999 ... really should
be interpreted as 0.3 when applying the rounding rules.

- **Some terminology**:
  - **NumberOfDecimals**
      - is used for Number of Decimal Fraction Digits.  If NumberOfDecimals is  negative, then the inputs will be rounded so that there are zeros on the left of the decimal point.  I.E. if NumberOfDecimals = -3, then the output will be rounded to an integral multiple of a thousand. "MaxRelativeError" designates the maximum relative error to be allowed in the input values when deciding they are supposed to represent exact ecimal fractions (as mentioned above). If Ctrl <> drNone, then MaxRelError must be greater than 0.00.
  - **RoundingControl**
      -  determines the type of rounding to be done.  Nine kinds of rounding (plus no rounding) are defined.  They include almost every kind of rounding known.  See the definition of TDecimalRoundingControl below for the specific types.

 **Note** _(could not track this unit down -tee-)_
 > In Quality Central Report #8143, there is an attached file, RoundToXReplacement_3c.pas that contains 
 > a few ideas for improvement in the code used herein.  One of the new features of the #8143 code is 
 > that the MaxRelError may be  zero, for whatever that is worth. However, but the #8143 code has not be 
 > as rigorously validated as this code.

Original code credit: John Herbster (DecimalRounding_JH1.pas).

The original code has been refactored and formatted to adhere to more standard coding conventions, with some minor modifications. The most significant change is the adjustment of the default rounding mode to **drcHalfUp**. 

> DecimalRound(2.245) ~ 2.25. 

If you wish to use this as a drop in replacement of the Delphi round method, make own wrapper using the DecimalRoundEx().

For a simple version, use DRUnit.Round. If you need more control, you can utilize the DRUnit.RoundEx unit. The `LoadDecimalRoundingCtrlAbbrs` helper (for filling a TComboBox with the rounding modes) lives in DRUnit.UiUtils, so the core rounding units do not depend on System.Classes.

## Special values and limits

These hold in **all** build configurations (Debug and Release) and on both Win32 and Win64:

- **NaN in → NaN out.** The input NaN is returned as is.
- **±Infinity is returned unchanged.**
- **drcNone returns the value unchanged** (no rounding, as the name says).
- **Values too large to round are returned unchanged.** When `|AValue * 10^NumberOfDecimals|` reaches `MAX_SAFE_SCALED_VALUE` (9E18, just below 2^63), the internal Int64 conversion would overflow — and an overflowing `Round()` does not reliably raise; with floating point exceptions masked (the Delphi 12+ default) it silently yields sign-flipped garbage. At such magnitudes the value carries no decimal fraction information at the requested precision anyway, so returning it unchanged *is* the correct rounding.
- **Significant digits are bounded by the input type.** Asking for more significant digits than a Double (~16) or Extended (~19) actually carries gives results that are only correct to within the documented relative error — that is inherent to binary floating point, not to these routines.

On Win64 the compiler uses SSE instructions, so the rounding behavior is governed by the MXCSR register rather than the x87 control word; `IsFpuCwOkForRounding` (and the diagnostic `FpuSettingsToString`) check the register that is actually in effect on each platform.

I have been using these original routines, as well as my own versions, in various projects, both current and previous work. So far, I have not encountered any issues to complain about. However, it's important to note that there are limits when dealing with floating-point numbers, which can lead to unexpected results if pushed to extremes. Despite that, other rounding methods I've encountered and used have failed in various scenarios. In contrast, these routines have proven to be more reliable IMHO.

As far as I know, the original code was donated to the community without a license. To clarify the terms of use for anyone checking it out, I added a permissive MIT license. This license allows users to use the code quite freely and without restrictions.

## TODO:
- ~~Add good set of Unit Tests~~ (Done — DUnitX suite under `UnitTests`, runs on Win32 and Win64, Debug and Release)
- Some examples in the demo, that usually fail, and maybe compare to rounding algorithms usually suggested in the web. (Started and partially done)
- (have not thought about this yet)
 
