# Modules.
use File::Object;
use Tags::Output::PYX;
use Test::More 'tests' => 2;

# Include helpers.
do File::Object->new->up->file('get_stdout.inc')->serialize;

my $obj = Tags::Output::PYX->new(
	'output_handler' => \*STDOUT,
);
my $ret = get_stdout($obj, 1,
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $right_ret = <<'END';
(MAIN
-data
)MAIN
END
chomp $right_ret;
is($ret, $right_ret);

$obj = Tags::Output::PYX->new(
	'auto_flush' => 1,
	'output_handler' => \*STDOUT,
);
$ret = get_stdout($obj, 1,
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
is($ret, $right_ret);
