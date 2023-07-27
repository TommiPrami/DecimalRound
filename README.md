# DecimalRound

Based on original code of John Herbsted (DecimalRounding_JH1.pas). Refactored it formatted code to be more standard and did some minor modifications. Biggest change is to change default rounding mode to the one, at least I, wwas thought at school. If need to replace delhi round -method, you need to specify the rounding mode in  DecicalRoundEx().

DRUnit.Round for simple version, and if yoiu need more control use DRUnit.RoundEx unit.

I've been using these original routines, and own versions of these in my own projects and also in used in my current and previous work.

So far have not found anything to complain about. Sure there are limits if pushed hard enough, due the nature of floating point numbers. Other rounding methods I've seen and used, have failed tough. Usually pretty fast there has been number those have failed to round expectedly.

## TODO:
 
