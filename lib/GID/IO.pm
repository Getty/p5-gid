package GID::IO;
# ABSTRACT: IO functions of GID, like dir() and file()

use strictures 1;
use Exporter 'import';
use vars qw( @EXPORT );

use GID::File;
use GID::Dir;
use File::Temp ();

@EXPORT = qw(
	dir
	file
	foreign_file
	foreign_dir
	tempdir
	tempfile
	rmtree
	mkdir
);

sub dir { GID::Dir->new(@_) }
sub file { GID::File->new(@_) }
sub foreign_dir { GID::Dir->new_foreign(@_) }
sub foreign_file { GID::File->new_foreign(@_) }
sub tempdir { GID::Dir->new(File::Temp::tempdir(@_)) }

sub tempfile {
	my ($fh, $filename) = File::Temp::tempfile(@_);
	GID::File->new($filename);
}

sub rmtree { dir(@_)->rmtree }

sub mkdir { GID::Dir->mkdir(@_) }

1;