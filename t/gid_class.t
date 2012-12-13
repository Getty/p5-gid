#!/usr/bin/env perl
use strict;
use warnings;
use Test::More;

{
	package GIDTest::Class;
	use GID::Class;

	has last_index => ( is => 'rw' );

	sub test_last_index {
		return last_index { $_ eq 1 } ( 1,1,1,1 );
	}
}

{
	package GIDTest::Class2;
	use GID::Class;
	extends 'GIDTest::Class';
}

my $t = GIDTest::Class->new( last_index => 1 );

is($t->last_index,1,'last_index is set proper via constructor');
isa_ok($t,'GID::Object');
isa_ok($t,'Moo::Object');
$t->last_index(2);
is($t->last_index,2,'last_index is changed proper');
is($t->test_last_index,3,'gid last_index still works fine');

my $t2 = GIDTest::Class->new;

isa_ok($t2,'GIDTest::Class');
isa_ok($t2,'GID::Object');
isa_ok($t2,'Moo::Object');

done_testing;
