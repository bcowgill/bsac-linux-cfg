#!/usr/bin/env perl
# Alternative to AUTOLOAD generated accessors, make them manually

use Test::More tests => 32;
use strict;
use warnings;
use English -no_match_vars;

package Base;
use strict;
use warnings;
use English -no_match_vars;

# make property accessors named same as property
# $o->value()     # get the value
# $o->value(12);  # set the value can specify undef to clear it
sub make_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		no strict 'refs';
		*{"$class\::$attribute"} = sub
		{
			my $self = shift;
			if (@ARG) {
				$self->{$attribute} = shift;
			}
			return $self->{$attribute};
		};
	}
}

# make property accessors named with get_ prefix on property
# $o->get_value()     # get the value
sub make_get_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		no strict 'refs';
		*{"$class\::get_$attribute"} = sub
		{
			my $self = shift;
			return $self->{$attribute};
		};
	}
}

# make property accessors named with set_ prefix on property
# $o->set_value(12);  # set the value can specify undef to clear it
sub make_set_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		no strict 'refs';
		*{"$class\::set_$attribute"} = sub
		{
			my $self = shift;
			$self->{$attribute} = shift;
			return $self->{$attribute};
		};
	}
}

# make property accessors named with get_ and set_ prefix on property
# $o->get_value()     # get the value
# $o->set_value(12);  # set the value can specify undef to clear it
sub make_get_set_accessors
{
	make_get_accessors(@ARG);
	make_set_accessors(@ARG);
}

# make property accessors named with getCamelCase for property
# $o->getValue()     # get the value
sub make_java_get_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		my $getter = ucfirst($attribute);
		$getter =~ s{_(.)}{uc($1)}xmsge;
		no strict 'refs';
		*{"$class\::get$getter"} = sub
		{
			my $self = shift;
			return $self->{$attribute};
		};
	}
}

# make property accessors named with setCamelCase for property
# $o->setValue(12);  # set the value can specify undef to clear it
sub make_java_set_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		my $setter = ucfirst($attribute);
		$setter =~ s{_(.)}{uc($1)}xmsge;
		no strict 'refs';
		*{"$class\::set$setter"} = sub
		{
			my $self = shift;
			$self->{$attribute} = shift;
			return $self->{$attribute};
		};
	}
}

# make property accessors named with getCamelCase and setCamelCase for property
# $o->getValue()     # get the value
# $o->setValue(12);  # set the value can specify undef to clear it
sub make_java_get_set_accessors
{
	make_java_get_accessors(@ARG);
	make_java_set_accessors(@ARG);
}

package Child;
use strict;
use warnings;
use English -no_match_vars;

our @ISA = 'Base';

my @aProperties = qw(this that the other);
__PACKAGE__->make_accessors(@aProperties);
__PACKAGE__->make_get_set_accessors(@aProperties);
__PACKAGE__->make_java_get_set_accessors(@aProperties);
__PACKAGE__->make_java_get_set_accessors('a_very_java_like_property');

sub new
{
	my ($that) = @ARG;
	my $class = ref($that) || $that;
	my $self = {
		this => 12,
		that => 4,
		the => 7,
		other => 6,
		a_very_java_like_property => 50,
	};
	return bless( $self, $class );
}

package main;

my $oChild = new_ok('Child' => []);
isa_ok($oChild, 'Base');
can_ok($oChild, qw(
	this that the other
	get_this get_that get_the get_other
	getThis  getThat  getThe  getOther
	set_this set_that set_the set_other
	setThis  setThat  setThe  setOther
	getAVeryJavaLikeProperty setAVeryJavaLikeProperty
));

# get value
is($oChild->this(), 12, 'should be 12');
is($oChild->that(),  4, 'should be 4');
is($oChild->the(),   7, 'should be 7');
is($oChild->other(), 6, 'should be 6');

# set value
is($oChild->this(undef), undef, 'should be set to undef');
is($oChild->this(-1), -1, 'should be set to -1');
is($oChild->that(2),   2, 'should be set to 2');
is($oChild->the(6),    6, 'should be set to 6');
is($oChild->other(8),  8, 'should be set to 8');

# get_ value
is($oChild->get_this(), -1, 'should be -1');
is($oChild->get_that(),  2, 'should be 2');
is($oChild->get_the(),   6, 'should be 6');
is($oChild->get_other(), 8, 'should be 8');
is($oChild->get_this(42), -1, 'should not set value');

# set_ value
is($oChild->set_this(10),  10, 'should be set to 10');
is($oChild->set_that(20),  20, 'should be set to 20');
is($oChild->set_the(30),   30, 'should be set to 30');
is($oChild->set_other(40), 40, 'should be set to 40');

# getCamelCase value
is($oChild->getThis(),  10, 'should be 10');
is($oChild->getThat(),  20, 'should be 20');
is($oChild->getThe(),   30, 'should be 30');
is($oChild->getOther(), 40, 'should be 40');
is($oChild->getAVeryJavaLikeProperty(), 50, 'should be 50');
is($oChild->getThis(42),  10, 'should not set value');

# setCamelCase value
is($oChild->setThis(-1), -1, 'should be set to -1');
is($oChild->setThat(2),   2, 'should be set to 2');
is($oChild->setThe(6),    6, 'should be set to 6');
is($oChild->setOther(8),  8, 'should be set to 8');
is($oChild->setAVeryJavaLikeProperty(100), 100, 'should be 100');
