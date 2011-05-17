# Modules.
use English qw(-no_match_vars);
use Tags::Output::PYX;
use Test::More 'tests' => 5;

# Test.
my $obj;
eval {
	$obj = Tags::Output::PYX->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

# Test.
eval {
	$obj = Tags::Output::PYX->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

# Test.
eval {
	$obj = Tags::Output::PYX->new('output_handler' => '');
};
is($EVAL_ERROR, 'Output handler is bad file handler.'."\n");

# Test.
$obj = Tags::Output::PYX->new;
ok(defined $obj);
ok($obj->isa('Tags::Output::PYX'));
