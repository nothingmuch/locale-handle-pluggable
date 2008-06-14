#!/usr/bin/perl

package Locale::Handle::Pluggable::DateTime;
#use Moose::Role;
use Moose;

use Moose::Util::TypeConstraints;
use MooseX::Types::VariantTable::Declare;

#use MooseX::Types::DateTime;

use DateTime;
use DateTime::TimeZone;
use DateTime::Locale;

class_type "DateTime";

variant_method loc => DateTime => "loc_datetime";

has time_zone => (
    isa => "DateTime::TimeZone",
    is  => "rw",
    #coerce => 1,
    predicate => "has_time_zone",
);

sub loc_datetime {
    my ( $self, $date_proto, @args ) = @_;

    # the first argument is treated as a format or format name
    my $format = @args % 2 ? shift @args : undef;

    # make a copy of the date so we can set the time zone
    my $date = $self->loc_datetime_clone($date_proto, @args);
    
    $self->loc_datetime_set_time_zone($date, @args);

    if ( $format ) {
        $self->loc_datetime_format($date, $format, @args);
    } else {
        return $date;
    }
}

sub loc_datetime_format {
    my ( $self, $date, $format, @args ) = @_;

    # first check if this is a symbolic format name
    foreach my $method ( $format, "${format}_format" ) {
        if ( $date->locale->can($method) ) {
            return $date->strftime( $date->locale->$method );
        }
    }

    # if not treat it as an actual format
    return $date->strftime( $format );
}

sub loc_datetime_clone {
    my ( $self, $date_proto, @args ) = @_;

    # clone the object with the locale set
    ( ref $date_proto )->from_object(
        object    => $date_proto,
        locale    => $self->language_tag, # we can postfix this with our own subclasses, http://search.cpan.org/~drolsky/DateTime-Locale-0.34/lib/DateTime/Locale.pm#Subclass_an_existing_locale.
        @args
    );
}

sub loc_datetime_set_time_zone {
    my ( $self, $date, @args ) = @_;

    if ( $self->has_time_zone ) {
        $date->set_time_zone( $self->time_zone );
    }
}

__PACKAGE__

__END__

=pod

=head1 NAME

Locale::Handle::Pluggable::DateTime - Localize DateTime objects with your
maketext handles.

=head1 SYNOPSIS

	use Locale::Handle::Pluggable::DateTime;

=head1 DESCRIPTION

=cut


