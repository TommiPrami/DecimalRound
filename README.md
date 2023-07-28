# DecimalRound

> NOTE:
>
> Modifying the code gives on latest Delphi 11 following error: [dcc32 Fatal Error] F2084 Internal Error: L902
> If/when this happens insted of compiling you need to build the code. COuld not find reason for this

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

> DesimalRound(2.245) ~ 2.25. 

If you wish to use this as a drop in replacement of the Delphi round method, make own wrapper using the DecicalRoundEx().

For a simple version, use DRUnit.Round. If you need more control, you can utilize the DRUnit.RoundEx unit.

I have been using these original routines, as well as my own versions, in various projects, both current and previous work. So far, I have not encountered any issues to complain about. However, it's important to note that there are limits when dealing with floating-point numbers, which can lead to unexpected results if pushed to extremes. Despite that, other rounding methods I've encountered and used have failed in various scenarios. In contrast, these routines have proven to be more reliable IMHO.

As far as I know, the original code was donated to the community without a license. To clarify the terms of use for anyone checking it out, I added a permissive MIT license. This license allows users to use the code quite freely and without restrictions.

## TODO:
- Add good set of Unit Tests
- Some examples in the demo, that usually fail, and maybe compare to rounding algorithms usually suggested in the web.
- (have not thought about this yet)
 
