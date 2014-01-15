package Tags::Output::PYX;

# Pragmas.
use base qw(Tags::Output);
use strict;
use warnings;

# Modules.
use Error::Pure qw(err);
use Readonly;
use Tags::Utils qw(encode_newline);

# Constants.
Readonly::Scalar my $EMPTY_STR => q{};
Readonly::Scalar my $SPACE => q{ };

# Version.
our $VERSION = 0.01;

# Attributes.
sub _put_attribute {
	my ($self, $attr, $value) = @_;
	push @{$self->{'flush_code'}}, "A$attr $value";
	return;
}

# Begin of tag.
sub _put_begin_of_tag {
	my ($self, $tag) = @_;
	push @{$self->{'flush_code'}}, "($tag";
	unshift @{$self->{'printed_tags'}}, $tag;
	return;
}

# CData.
sub _put_cdata {
	my ($self, @cdata) = @_;
	$self->_put_data(@cdata);
	return;
}

# Comment.
sub _put_comment {
	my ($self, @comments) = @_;
	$self->_put_data(
		map { '<!--'.$_.'-->' } @comments,
	);
	return;
}

# Data.
sub _put_data {
	my ($self, @data) = @_;
	my $data = join($EMPTY_STR, @data);
	push @{$self->{'flush_code'}}, '-'.encode_newline($data);
	return;
}

# End of tag.
sub _put_end_of_tag {
	my ($self, $tag) = @_;
	my $printed = shift @{$self->{'printed_tags'}};
	if ($printed ne $tag) {
		err "Ending bad tag: '$tag' in block of tag '$printed'.";
	}
	push @{$self->{'flush_code'}}, ")$tag";
	return;
}

# Instruction.
sub _put_instruction {
	my ($self, $target, $code) = @_;

	# Construct instruction line.
	my $instruction = '?'.$target;
	if ($code) {
		$instruction .= $SPACE.$code;
	}

	# To flush code.
	push @{$self->{'flush_code'}}, encode_newline($instruction);

	return;
}

# Raw data.
sub _put_raw {
	my ($self, @raw_data) = @_;
	$self->_put_data(@raw_data);
	return;
}

1;

__END__

=pod

=encoding utf8

=head1 NAME

 Tags::Output::PYX - PYX class for line oriented output for 'Tags'.

=head1 SYNOPSYS

 use Tags::Output::PYX;
 my $obj = Tags::Output::PYX->new(%parameters);
 $obj->finalize;
 my $ret = $obj->flush($reset_flag);
 my @tags = $obj->open_tags;
 $obj->put(@data);
 $obj->reset;

=head1 PYX LINE CHARS

 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item C<new(%parameters)>

 Constructor.

=over 8

=item * C<auto_flush>

 Auto flush flag.
 Default is 0.

=item * C<output_handler>

 TODO

=item * C<output_sep>

 TODO

=item * C<skip_bad_data>

 TODO

=back

=item C<finalize()>

 TODO

=item C<flush()>

 TODO

=item C<open_tags()>

 TODO

=item C<put()>

 TODO

=item C<reset()>

 TODO

=back

=head1 ERRORS

 Mine:
         Ending bad tag: '%s' in block of tag '%s'.

=head1 EXAMPLE

 # Pragmas.
 use strict;
 use warnings;

 # Modules.
 use Tags::Output::PYX;

 # Object.
 my $tags = Tags::Output::PYX->new;

 # Put all tag types.
 $tags->put(
         ['b', 'tag'],
         ['a', 'par', 'val'],
         ['c', 'data', \'data'],
         ['e', 'tag'],
         ['i', 'target', 'data'],
         ['b', 'tag'],
         ['d', 'data', 'data'],
         ['e', 'tag'],
 );

 # Print out.
 print $tags->flush."\n";

 # Output:
 # (tag
 # Apar val
 # -<!--data--><!--SCALAR(0x1570740)-->
 # )tag
 # ?target data
 # (tag
 # -datadata
 # )tag

=head1 DEPENDENCIES

L<Error::Pure>,
L<Readonly>,
L<Tags::Output>,
L<Tags::Utils>.

=head1 SEE ALSO

L<Tags>,
L<Tags::Output>,
L<Tags::Output::Raw>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
