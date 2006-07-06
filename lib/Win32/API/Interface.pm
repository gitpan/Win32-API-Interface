package Win32::API::Interface;

use strict;

use vars qw/$VERSION/;
$VERSION = '0.0001';

use Win32::API ();

=head1 NAME

  Win32::API::Interface - Provide OO interface for Win32::API functions

=head1 SYNOPSIS

	
	package MyModule;
	use base qw/Win32::API::Interface/;

	__PACKAGE__->provide( "kernel32", "GetCurrentProcessId", "", "I" );
	__PACKAGE__->provide( "kernel32", "GetCurrentProcessId", "", "I", 'get_pid' );

	1;

	my $obj = MyModule->new );
	print "PID: " . $obj->GetCurrentProcessId . "\n";
	print "PID: " . $obj->get_pid . "\n";


=head1 DESCRIPTION                            

B<!!! This module is still experimental. Do not rely on the interface. !!!>

=head1 METHODS

=head2 new

=cut

sub new {
    my $proto = shift;
    my $class = ref $proto || $proto;

    return bless {}, $class;
}

=head2 provide

    Class->provide( ... )

=cut

{
    no strict 'refs';

    sub provide {
        my $self = shift;

        if ( 'ARRAY' eq ref $_[0] ) {
            foreach my $args ( @_ ) {
                $self->provide( @{$args} );
            }
        }
        else {

            my ( $library, $name, $params, $retr, $alias ) = @_;
            my $class = ref $self || $self;
            $alias ||= $name;

            *{"${class}::$alias"} =
              $self->_provide( $library, $name, $params, $retr )
              unless defined &{"${class}::$alias"};
        }

        return 1;
    }
}

sub _provide {
    my ( $class, $library, $name, $params, $retr ) = @_;

    my $key = uc "$library-$name";

    return sub {
        my $self = shift;

        my $api = defined $self->{$key} ? $self->{$key} : $self->{$key} =
          Win32::API->new( $library, $name, $params, $retr );
        die "Unable to import API $name from $library: $^E" unless defined $api;

        return $api->Call(@_);
    };
}

=head2 provide_ex

    Class->provide_ex( ... )

=cut                 

sub provide_ex {
    my $self = shift;
    my %args = @_ % 2 == 0 ? @_ : %{ $_[0] };

    while ( my ( $library, $params ) = each %args ) {
        foreach my $args ( @{$params} ) {
            $self->provide( $library, @{$args} );
        }
    }

    return 1;
}

=head1 AUTHOR

Sascha Kiefer, L<esskar@cpan.org>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2006 Sascha Kiefer

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself.

=cut

1;

