# Delphi.ExactFloatToStringRoutines
Exact Float to string routines (originally from John Herbster)


# Exact-Float-to-String-Routines
Converts extended number to *exact* decimal representation. Other routines analyze and parse the sign, exponent, and mantissa into number type and hex string values.

Description
------------

This module includes

- functions for converting a floating binary point number to its *exact* decimal representation in an AnsiString;
- functions for parsing the floating point types into sign, exponent, and mantissa; and
- function for analyzing a extended float number into its type (zero, normal, infinity, etc.)

Its intended use is for trouble shooting problems with floating point numbers.

This code uses dynamic arrays, overloaded calls, and optional parameters

Sample Usage
------------

    ExactFloatToStr(0.28); //convert using current locale

Returns *(for en-US)*:

    +0.280,000,000,000,000,000,001,084,202,172,485,504,434,007,452,800,869,941,711,425,781,25
    
You can customize the digit separator, and the grouping:

    ExactFloatToStrEx(0.28, FormatSettings.DecimalSeparator, 0);
    +0.28000000000000000000108420217248550443400745280086994171142578125
    
    ExactFloatToStrEx(0.28, ' ', 5);
    +0.28000 00000 00000 00000 10842 02172 48550 44340 07452 80086 99417 11425 78125


Created by [John Herbster](https://cc.embarcadero.com/Item.aspx?id=19421)
