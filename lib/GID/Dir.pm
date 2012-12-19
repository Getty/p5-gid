package GID::Dir;
# ABSTRACT: A dir representation in GID

use strictures 1;
use base 'Path::Class::Dir';
use Scalar::Util qw( blessed );
use File::Temp ();
use GID::File;

sub mkdir {
	my $self = shift;
	my $newdir = blessed $self
		? $self->subdir(@_)
		: $self->new(@_);
	$newdir->mkpath;
	return $newdir;
}

sub tempfile {
	my $self = shift;
	# TODO: should actually parse $filename and use $self->file($parsed_filename_base);
	my ($fh, $filename) = File::Temp::tempfile(@_, DIR => $self);
	return GID::File->new($filename);
}

sub _parse_selectors {
	my $self = shift;
	my @selectors;
	my $code;
	for (@_) {
		if (ref $_ eq 'CODE') {
			$code = $_;
			last; # so far no handling of parameters after CODEREF
		} else {
			push @selectors, $_;
		}
	}
	return $code, @selectors;
}

sub files {
	my $self = shift;
	my ( $code, @selectors ) = $self->_parse_selectors(@_);
	$self->entities(@selectors,sub {
		$code->() unless $_->is_dir;
	});
}

sub dirs {
	my $self = shift;
	my ( $code, @selectors ) = $self->_parse_selectors(@_);
	$self->entities(@selectors,sub {
		$code->() if $_->is_dir;
	});
}

sub entities {
	my $self = shift;
	my ( $code, @selectors ) = $self->_parse_selectors(@_);
	for my $child ($self->children) {
		my $match;
		for (@selectors) {
			if ($child->basename =~ $_) {
				$match = 1;
				last;
			}
		}
		$code->() for ($child);
	}
}

1;