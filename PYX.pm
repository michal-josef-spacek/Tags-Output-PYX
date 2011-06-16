package Tags::Output::PYX;

# Pragmas.
use base qw(Tags::Output::Core);
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

 TODO

=head1 PYX LINE CHARS

 ?  - Instruction.
 (  - Open tag.
 )  - Close tag.
 A  - Attribute.
 -  - Normal data.

=head1 METHODS

=over 8

=item C<new()>

 TODO

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

 TODO

=head1 DEPENDENCIES

L<Error::Pure(3pm)>,
L<Readonly(3pm)>,
L<Tags::Utils(3pm)>.

=head1 SEE ALSO

L<Tags(3pm)>,
L<Tags::Output::Core(3pm)>,
L<Tags::Output::ESIS(3pm)>,
L<Tags::Output::Indent(3pm)>,
L<Tags::Output::Indent2(3pm)>,
L<Tags::Output::LibXML(3pm)>,
L<Tags::Output::Raw(3pm)>,
L<Tags::Output::SESIS(3pm)>,
L<Tags::Utils(3pm)>.

=head1 AUTHOR

Michal Špaček L<skim@cpan.org>

=head1 LICENSE AND COPYRIGHT

BSD license.

=head1 VERSION

0.01

=cut
