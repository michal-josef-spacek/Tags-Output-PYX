# Pragmas.
use strict;
use warnings;

# Modules.
use Tags::Output::PYX;
use Test::More 'tests' => 1;

# Test.
my $obj = Tags::Output::PYX->new;
$obj->put(
	['b', 'tag'],
);
$obj->finalize;
my $ret = $obj->flush;
my $right_ret = <<'END';
(tag
)tag
END
chomp $right_ret;
is($ret, $right_ret, 'Simple test of flush().');
