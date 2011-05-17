# Modules.
use Tags::Output::PYX;
use Test::More 'tests' => 1;

print "Testing: Version.\n";
is($Tags::Output::PYX::VERSION, '0.01');
