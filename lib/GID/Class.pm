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

use GID ();
use MooX ();

sub import {
	my $class = shift;
	my $target = scalar caller;
	my @args = @_;

	GID->import::into($target,@args);

	my $stash = Package::Stash->new($target);
	my @gid_methods = $stash->list_all_symbols('CODE');

	MooX->import::into($target,qw(
		ClassStash
		HasEnv
		Options
		Types::MooseLike
	));

	$target->can('extends')->('GID::Object');

	$target->class_stash->around_method('has',sub {
		my $has = shift;
		my $attribute_arg = shift;
		my @attribute_args = @_;
		my @attributes = ref $attribute_arg eq 'ARRAY' ? @{$attribute_arg} : ($attribute_arg);
		for my $attribute (@attributes) {
			if (grep { $attribute eq $_ } @gid_methods) {
				my $gid_method = $target->class_stash->get_method($attribute);
				$target->class_stash->remove_method($attribute);
				$has->($attribute,@attribute_args);
				$target->class_stash->around_method($attribute,sub {
					my $attribute_method = shift;
					return $attribute_method->(@_) if blessed $_[0];
					return $gid_method->(@_);
				});
			} else {
				$has->($attribute,@attribute_args);
			}
		}
	});

}

1;
