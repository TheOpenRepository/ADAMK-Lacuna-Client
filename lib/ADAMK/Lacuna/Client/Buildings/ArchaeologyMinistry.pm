package ADAMK::Lacuna::Client::Buildings::ArchaeologyMinistry;

use 5.008;
use strict;
use warnings;
use Carp 'croak';
use ADAMK::Lacuna::Client;
use ADAMK::Lacuna::Client::Buildings;

our @ISA = qw(ADAMK::Lacuna::Client::Buildings);

sub api_methods {
  return {
    search_for_glyph    => { default_args => [qw(session_id building_id)] },
    subsidize_search    => { default_args => [qw(session_id building_id)] },
    get_glyphs          => { default_args => [qw(session_id building_id)] },
    assemble_glyphs     => { default_args => [qw(session_id building_id)] },
    get_ores_available_for_processing => { default_args => [qw(session_id building_id)] },
  };
}

sub work_start {
  my $self = shift;
  return 0 unless $self->{work};
  return $self->{work}->{start};
}

sub work_end {
  my $self = shift;
  return 0 unless $self->{work};
  return $self->{work}->{end};
}

sub work_seconds_remaining {
  my $self = shift;
  return 0 unless $self->{work};
  return $self->{work}->{seconds_remaining};
}

sub busy {
  !! $_[0]->work_seconds_remaining;
}





######################################################################
# API Integration

sub ores {
  my $self     = shift;
  my $response = $self->get_ores_available_for_processing;
  $self->set_status( $response->{status} );
  return $response->{ore};
}

sub glyphs {
  my $self     = shift;
  my $response = $self->get_glyphs;
  $self->set_status( $response->{status} );
  if ( $response->{glyphs} ) {
    return @{$response->{glyphs}};
  } else {
    return ();
  }
}

sub glyphs_count {
  my $self   = shift;
  my @glyphs = $self->glyphs;
  my %count  = ();
  foreach my $glyph ( @glyphs ) {
    $count{$glyph->{type}}++;
  }
  return \%count;
}

__PACKAGE__->init;

1;

__END__

=pod

=head1 NAME

ADAMK::Lacuna::Client::Buildings::ArchaeologyMinistry - The Archeology Ministry building

=head1 SYNOPSIS

  use ADAMK::Lacuna::Client;

=head1 DESCRIPTION

=head1 AUTHOR

Steffen Mueller, E<lt>smueller@cpan.orgE<gt>

=head1 COPYRIGHT AND LICENSE

Copyright (C) 2010 by Steffen Mueller

This library is free software; you can redistribute it and/or modify
it under the same terms as Perl itself, either Perl version 5.10.0 or,
at your option, any later version of Perl 5 you may have available.

=cut
