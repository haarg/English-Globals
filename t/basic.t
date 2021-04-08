use strict;
use warnings;
use Test::More;

use English::Globals;

eval { die };
like ${^EVAL_ERROR}, qr/Died/;

done_testing;
