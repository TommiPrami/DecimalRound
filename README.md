# DecimalRound

Original code credit: John Herbster (DecimalRounding_JH1.pas).

The code has been refactored and formatted to adhere to more standard conventions, with some minor modifications. The most significant change is the adjustment of the default rounding mode to one commonly taught in schools. If you wish to replace the Delphi round method, you can specify the rounding mode in DecicalRoundEx().

For a simple version, use DRUnit.Round. If you need more control, you can utilize the DRUnit.RoundEx unit.

I have been using these original routines, as well as my own versions, in various projects, both current and previous work. So far, I have not encountered any issues to complain about. However, it's important to note that there are limits when dealing with floating-point numbers, which can lead to unexpected results if pushed to extremes. Despite that, other rounding methods I've encountered and used have failed in various scenarios. In contrast, these routines have proven to be more reliable IMHO.

## TODO:

 
