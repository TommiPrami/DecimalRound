﻿
{$IFDEF DEBUG}
  {$DEFINE DO_CHECKS}
{$ENDIF}

{$IF DEFINED(CPUX86)}
  {$DEFINE SUPPORTS_TRUE_EXTENDED}
{$ENDIF}
