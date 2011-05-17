# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Tags::Output::PYX;
use Test::More 'tests' => 4;

# Test.
eval {
	Tags::Output::PYX->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	Tags::Output::PYX->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
eval {
	Tags::Output::PYX->new('output_handler' => '');
};
is($EVAL_ERROR, 'Output handler is bad file handler.'."\n");

# Test.
my $obj = Tags::Output::PYX->new;
isa_ok($obj, 'Tags::Output::PYX');
