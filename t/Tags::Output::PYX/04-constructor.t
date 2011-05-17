# Modules.
use English qw(-no_match_vars);
use Tags::Output::PYX;
use Test::More 'tests' => 5;

print "Testing: new('') bad constructor.\n";
my $obj;
eval {
	$obj = Tags::Output::PYX->new('');
};
is($EVAL_ERROR, "Unknown parameter ''.\n");

print "Testing: new('something' => 'value') bad constructor.\n";
eval {
	$obj = Tags::Output::PYX->new('something' => 'value');
};
is($EVAL_ERROR, "Unknown parameter 'something'.\n");

print "Testing: new('output_handler' = '') bad constructor.\n";
eval {
	$obj = Tags::Output::PYX->new('output_handler' => '');
};
is($EVAL_ERROR, 'Output handler is bad file handler.'."\n");

print "Testing: new() right constructor.\n";
$obj = Tags::Output::PYX->new;
ok(defined $obj);
ok($obj->isa('Tags::Output::PYX'));
