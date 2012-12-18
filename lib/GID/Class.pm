package GID::Class;
# ABSTRACT: Making your classes with GID

=head1 SYNOPSIS

  package MyApp::Class;
  use GID::Class;

  has last_index => ( is => 'rw' );

  sub test_last_index {
    return last_index { $_ eq 1 } ( 1,1,1,1 );
  }

=cut

use strictures 1;
use Import::Into;
use Scalar::Util qw( blessed );
use namespace::clean ();

use GID ();
use MooX ();

use MooX::Override ();
use MooX::Augment ();

sub import {
	my $class = shift;
	my $target = scalar caller;
	my @args = @_;

	GID->import::into($target,@args);

	MooX->import::into($target,qw(
		ClassStash
		HasEnv
		Options
		Types::MooseLike
		late
	));

	MooX::Override->import::into($target,'-class');
	MooX::Augment->import::into($target,'-class');

	namespace::clean->import::into($target);

	$target->can('extends')->('GID::Object');
}

1;
