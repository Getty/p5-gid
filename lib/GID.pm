package GID;

use Import::Into;
use Package::Stash;

use Path::Class ();
use Carp ();
use File::ShareDir ();
use File::Copy::Recursive ();
use File::Remove ();
use List::MoreUtils ();
use Scalar::Util ();
use Carp::Always ();

sub import { 
	my $target = scalar caller;

	Carp::Always->import::into($target);
	Path::Class->import::into($target,qw( file dir ));
	Carp->import::into($target,qw( confess croak carp ));
	File::ShareDir->import::into($target,qw( dist_dir module_dir class_dir ));
	File::Copy::Recursive->import::into($target,qw( dircopy ));
	File::Remove->import::into($target,qw( remove ));
	List::MoreUtils->import::into($target,qw(
		any all none notall firstidx first_index lastidx last_index
		insert_after insert_after_string apply indexes after_incl
		before_incl firstval first_value lastval last_value each_array
		each_arrayref pairwise natatime mesh zip uniq distinct minmax part
	));
	Scalar::Util->import::into($target,qw(
		blessed dualvar isweak readonly
		refaddr reftype tainted weaken isvstring looks_like_number
		set_prototype
	));
	my $stash = Package::Stash->new($target);

	$stash->add_symbol('&package_stash',sub { $stash });

	$stash->add_symbol('&env',sub {
		my $key = join('_',@_);
		return defined $ENV{$key} ? $ENV{$key} : "";
	});
}

1;
