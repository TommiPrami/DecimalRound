unit DRUnit.Help;

interface

(* *****************************************************************************

 ROUTINES FOR ROUNDING IEEE-754 FLOATS TO SPECIFIED NUMBER OF DECIMAL FRACTIONS

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

  Some terminology:
    "NDFD" is used for Number of Decimal Fraction Digits.  If NDFD is
        negative, then the inputs will be rounded so that there are zeros
        on the left of the decimal point.  I.E. if NDFD = -3, then the
        output will be rounded to an integral multiple of a thousand.
    "MaxRelError" designates the maximum relative error to be allowed in the
        input values when deciding they are supposed to represent exact
        decimal fractions (as mentioned above).  If Ctrl <> drNone, then
        MaxRelError must be greater than 0.
    "Ctrl" determines the type of rounding to be done.  Nine kinds of
        rounding (plus no rounding) are defined.  They include almost
        every kind of rounding known.  See the definition of
        tDecimalRoundingCtrl below for the specific types.

 Note that in Quality Central Report #8143, there is an attached file,
     RoundToXReplacement_3c.pas that contains a few ideas for improvement
     in the code used herein.  One of the new features of the #8143 code
     is that the MaxRelError may be zero, for whatever that is worth.
     However, but the #8143 code has not be as rigorously validated as
     this code.

 Fix. 2004.06.29 by JH in the DecimalRound() function to change j from
     Integer to Int64 and add an Assert for MaxRelErr being > 0.
 Rev. 2002.01.14 by John Herbster to add overloaded IsNaN() functions to
     solve problem with invalid operation when loading values for test.
 Rev. 2001.11.24 by John Herbster to add KnownErrorLimit, SafetyFactor,
     and MaxRelErrXxx constants. Also corrected DecimalRoundingCtrlStrs
     and comments per feedback from Marjan Venema.
 Pgm. 2001.09.19 by John Herbster.  Please send feedback and suggestions
     to author at herb-sci@swbell.net.

 Dedicated to the participants in the borland.public.delphi.objectpascal
     forum.  With special thanks to Brad White for his proofing and
     suggestions.

***************************************************************************** *)


implementation

end.
