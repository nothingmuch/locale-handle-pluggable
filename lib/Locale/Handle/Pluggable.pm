#!/usr/bin/perl

package Locale::Handle::Pluggable;
#use Moose::Role;
use Moose;

use Carp qw(croak);

#with qw(Locale::Handle::Pluggable::Maketext);

use Moose::Util::TypeConstraints::VariantTable::Sugar;

our $VERSION = "0.01";

variant_method loc => Item => sub {
    my ( $self, @args ) = @_;

    my $dump = eval { require Devel::PartialDump; 1 }
        ? \&Devel::PartialDump::dump
        : sub { return join $", map { overload::StrVal($_) } @_ };

    croak "Don't know how to localize ", $dump->(@args);
};

# all strings are considered message IDs and go to 'maketext' for handling
variant_method loc => Str => "loc_string";

sub loc_string {
    my ( $self, $str, @args ) = @_;
    $self->maketext($str, @args);
}

__PACKAGE__

__END__

=pod

=encoding utf8

=head1 NAME

Locale::Handle::Pluggable - L<Moose> role based plugins for
L<Locale::Maketext>.

=head1 SYNOPSIS

    # create the localization factory class
    # see Locale::Maketext for details

	package MyProgram::L10N;
    use Moose;

    # define the factory class normally
    extends qw(Locale::Maketext);
    # or
    use Locale::Maketext::Lexicon { ... };


    # load some additional roles with variants for the loc() method
    with qw(
        Locale::Maketext::Pluggable
        Locale::Maketext::Pluggable::DateTime
        Locale::Maketext::Pluggable::Foo
    );




    # in your language definitions, use Locale::Maketext's syntax for entries
    # For instance, to create a localized greeting with a date, the entries
    # might look like the following example. the second argument to %loc() is
    # the DateTime::Locale format symbolic format name

    # English:
    'Hello, it is now [loc, _1, "full_time"]'
    # in gettext style:
    'Hello, it is now %loc(%1, "full_time")'

    # Hebrew:
    'שלום, השעה [loc, _1, "medium_time"]'


    # And then use it like this:
    $handle->loc( $message_id, $datetime_object ); # the datetime object is in %1


    # this also works, since %loc is a method call on the language handle:
    $handle->loc( $datetime_object, "short_date" );
    
=head1 DESCRIPTION

This class 

=cut


