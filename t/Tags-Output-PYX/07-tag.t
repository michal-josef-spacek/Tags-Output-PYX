# Pragmas.
use strict;
use warnings;

# Modules.
use English qw(-no_match_vars);
use Tags::Output::PYX;
use Test::More 'tests' => 7;
use Test::NoWarnings;

# Test.
my $obj = Tags::Output::PYX->new;
$obj->put(
	['b', 'MAIN'],
	['d', 'data'],
	['e', 'MAIN'],
);
my $ret = $obj->flush;
my $right_ret = <<'END';
(MAIN
-data
)MAIN
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj = Tags::Output::PYX->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(MAIN
Aid id_value
-data
)MAIN
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj = Tags::Output::PYX->new;
$obj->put(
	['b', 'MAIN'],
	['a', 'id', 'id_value'],
	['d', 'data'],
	['e', 'MAIN'],
	['b', 'MAIN'],
	['a', 'id', 'id_value2'],
	['d', 'data'],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<'END';
(MAIN
Aid id_value
-data
)MAIN
(MAIN
Aid id_value2
-data
)MAIN
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
my $long_data = 'a' x 1000;
$obj = Tags::Output::PYX->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
(MAIN
-$long_data
)MAIN
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$long_data = 'aaaa ' x 1000;
$obj = Tags::Output::PYX->new;
$obj->put(
	['b', 'MAIN'],
	['d', $long_data],
	['e', 'MAIN'],
);
$ret = $obj->flush;
$right_ret = <<"END";
(MAIN
-$long_data
)MAIN
END
chomp $right_ret;
is($ret, $right_ret);

# Test.
$obj = Tags::Output::PYX->new;
eval {
	$obj->put(
		['b', 'MAIN'],
		['e', 'MAIN2'],
	);
};
is($EVAL_ERROR, "Ending bad tag: 'MAIN2' in block of tag 'MAIN'.\n");
