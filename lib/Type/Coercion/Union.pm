package Type::Coercion::Union;

use 5.008001;
use strict;
use warnings;

BEGIN {
	$Type::Coercion::Union::AUTHORITY = 'cpan:TOBYINK';
	$Type::Coercion::Union::VERSION   = '0.000_07';
}

use Scalar::Util qw< blessed >;
use Types::TypeTiny qw< TypeTiny >;

sub _croak ($;@)
{
	require Carp;
	@_ = sprintf($_[0], @_[1..$#_]) if @_ > 1;
	goto \&Carp::croak;
}

use base "Type::Coercion";

sub type_coercion_map
{
	my $self = shift;
	
	TypeTiny->assert_valid(my $type = $self->type_constraint);
	$type->isa('Type::Tiny::Union')
		or _croak "Type::Coercion::Union must be used in conjunction with Type::Tiny::Union";
	
	my @c;
	for my $tc (@$type)
	{
		next unless $tc->has_coercion;
		push @c, @{$tc->coercion->type_coercion_map};
	}
	return \@c;
}

sub add_type_coercions
{
	my $self = shift;
	_croak "adding coercions to Type::Coercion::Union not currently supported";
}

# sub _build_moose_coercion ???

1;

__END__

=pod

=encoding utf-8

=head1 NAME

Type::Coercion::Union - a set of coercions to a union type constraint

=head1 DESCRIPTION

This package inherits from L<Type::Coercion>; see that for most documentation.
The major differences are that C<add_type_coercions> always throws an
exception, and the C<type_coercion_map> is automatically populated from
the child contraints of the union type constraint.

=head1 BUGS

Please report any bugs to
L<http://rt.cpan.org/Dist/Display.html?Queue=Type-Tiny>.

=head1 SEE ALSO

L<Type::Coercion>.

L<Moose::Meta::TypeCoercion::Union>.

=head1 AUTHOR

Toby Inkster E<lt>tobyink@cpan.orgE<gt>.

=head1 COPYRIGHT AND LICENCE

This software is copyright (c) 2013 by Toby Inkster.

This is free software; you can redistribute it and/or modify it under
the same terms as the Perl 5 programming language system itself.

=head1 DISCLAIMER OF WARRANTIES

THIS PACKAGE IS PROVIDED "AS IS" AND WITHOUT ANY EXPRESS OR IMPLIED
WARRANTIES, INCLUDING, WITHOUT LIMITATION, THE IMPLIED WARRANTIES OF
MERCHANTIBILITY AND FITNESS FOR A PARTICULAR PURPOSE.
