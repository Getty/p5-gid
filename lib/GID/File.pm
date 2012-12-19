package GID::File;
# ABSTRACT: A file representation in GID

use strictures 1;
use base 'Path::Class::File';

sub rm { shift->remove(@_) }

1;