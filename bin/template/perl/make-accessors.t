#!/usr/bin/env perl
# Alternative to AUTOLOAD generated accessors, make them manually

use Test::More tests => 44;
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

# make property accessors named same as property
# but setting a value returns the old value instead of the new value
# $o->value()     # get the value
# $o->value(12);  # set the value can specify undef to clear it
sub make_old_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		no strict 'refs';
		*{"$class\::$attribute"} = sub
		{
			my $self = shift;
			my $old = $self->{$attribute};
			if (@ARG) {
				$self->{$attribute} = shift;
			}
			return $old;
		};
	}
}

# make property accessors named same as property
# but setting a value returns the object itself instead of the value
# so you can chain calls $o->width(12)->height(32);
# $o->value()     # get the value
# $o->value(12);  # set the value can specify undef to clear it
sub make_chain_accessors
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
				return $self;
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

# make property accessors named with set_ prefix on property
# but which returns the old value instead of the new value
# $o->set_value(12);  # set the value but return the previous value
sub make_set_old_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		no strict 'refs';
		*{"$class\::set_$attribute"} = sub
		{
			my $self = shift;
			my $old = $self->{$attribute};
			$self->{$attribute} = shift;
			return $old;
		};
	}
}

# make property accessors named with get_ and set_ prefix on property
# but which returns the old value instead of the new value
# $o->get_value()     # get the value
# $o->set_value(12);  # set the value can specify undef to clear it
sub make_get_set_old_accessors
{
	make_get_accessors(@ARG);
	make_set_old_accessors(@ARG);
}

# make property accessors named with set_ prefix on property
# but setting a value returns the object itself instead of the value
# so you can chain calls $o->set_width(12)->set_height(32);
# $o->set_value(12);  # set the value but return the previous value
sub make_set_chain_accessors
{
	my ($class, @attributes) = @ARG;
	foreach my $attribute (@attributes)
	{
		no strict 'refs';
		*{"$class\::set_$attribute"} = sub
		{
			my $self = shift;
			$self->{$attribute} = shift;
			return $self;
		};
	}
}

# make property accessors named with get_ and set_ prefix on property
# but setting a value returns the object itself instead of the value
# so you can chain calls $o->set_width(12)->set_height(32);
# $o->get_value()     # get the value
# $o->set_value(12);  # set the value can specify undef to clear it
sub make_get_set_chain_accessors
{
	make_get_accessors(@ARG);
	make_set_chain_accessors(@ARG);
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

# make property accessors named with setCamelCase for property
# but which returns the old value instead of the new value
# $o->setValue(12);  # set the value can specify undef to clear it
sub make_java_set_old_accessors
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
			my $old = $self->{$attribute};
			$self->{$attribute} = shift;
			return $old;
		};
	}
}

# make property accessors named with getCamelCase and setCamelCase for property
# but which returns the old value instead of the new value
# $o->getValue()     # get the value
# $o->setValue(12);  # set the value can specify undef to clear it
sub make_java_get_set_old_accessors
{
	make_java_get_accessors(@ARG);
	make_java_set_old_accessors(@ARG);
}

# make property accessors named with setCamelCase for property
# but setting a value returns the object itself instead of the value
# so you can chain calls $o->setWidth(12)->setHeight(32);
# $o->setValue(12);  # set the value can specify undef to clear it
sub make_java_set_chain_accessors
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
			return $self;
		};
	}
}

# make property accessors named with getCamelCase and setCamelCase for property
# but setting a value returns the object itself instead of the value
# so you can chain calls $o->setWidth(12)->setHeight(32);
# $o->getValue()     # get the value
# $o->setValue(12);  # set the value can specify undef to clear it
sub make_java_get_set_chain_accessors
{
	make_java_get_accessors(@ARG);
	make_java_set_chain_accessors(@ARG);
}

package Child;
use strict;
use warnings;
use English -no_match_vars;

our @ISA = 'Base';

my @aProperties = qw(this that);
my @aPropertiesSetOld = qw(the other);
__PACKAGE__->make_accessors(@aProperties);
__PACKAGE__->make_old_accessors(@aPropertiesSetOld);
__PACKAGE__->make_get_set_accessors(@aProperties);
__PACKAGE__->make_get_set_old_accessors(@aPropertiesSetOld);
__PACKAGE__->make_java_get_set_accessors(@aProperties);
__PACKAGE__->make_java_get_set_old_accessors(@aPropertiesSetOld);
__PACKAGE__->make_java_get_set_accessors('a_very_java_like_property');

__PACKAGE__->make_chain_accessors('chain');
__PACKAGE__->make_get_set_chain_accessors('chain');
__PACKAGE__->make_java_get_set_chain_accessors('chain');

sub new
{
	my ($that) = @ARG;
	my $class = ref($that) || $that;
	my $self = {
		this => 12,
		that => 4,
		the => 7,
		other => 6,
		chain => 64,
		a_very_java_like_property => 50,
	};
	return bless( $self, $class );
}

package main;

my $oChild = new_ok('Child' => []);
isa_ok($oChild, 'Base');
can_ok($oChild, qw(
	this that the other chain
	get_this get_that get_the get_other get_chain
	getThis  getThat  getThe  getOther getChain
	set_this set_that set_the set_other set_chain
	setThis  setThat  setThe  setOther setChain
	getAVeryJavaLikeProperty setAVeryJavaLikeProperty
));

note 'get value';
is($oChild->this(),  12, 'should be 12');
is($oChild->that(),   4, 'should be 4');
is($oChild->the(),    7, 'should be 7');
is($oChild->other(),  6, 'should be 6');
is($oChild->chain(), 64, 'should be 64');

note 'set value';
is($oChild->this(undef), undef, 'should be set to undef');
is($oChild->this(-1), -1, 'should be set to -1');
is($oChild->that(2),   2, 'should be set to 2');
is($oChild->the(6),    7, 'should return old value 7');
is($oChild->the(),     6, 'should be set to 6');
is($oChild->other(8),  6, 'should return old value 6');
is($oChild->other(),   8, 'should be set to 8');
is($oChild->chain(32)->chain(), 32, 'should allow chaining and be 32');

note 'get_ value';
is($oChild->get_this(),    -1, 'should be -1');
is($oChild->get_that(),     2, 'should be 2');
is($oChild->get_the(),      6, 'should be 6');
is($oChild->get_other(),    8, 'should be 8');
is($oChild->get_chain(32), 32, 'should be 32');
is($oChild->get_this(42),  -1, 'get should not set value');

note 'set_ value';
is($oChild->set_this(10),  10, 'should be set to 10');
is($oChild->set_that(20),  20, 'should be set to 20');
is($oChild->set_the(30),    6, 'should return old value 6');
is($oChild->get_the(),     30, 'should be set to 30');
is($oChild->set_other(40),  8, 'should return old value 8');
is($oChild->get_other(),   40, 'should be set to 40');
is($oChild->set_chain(50)->get_chain(), 50, 'should follow chain and be 50');

note 'getCamelCase value';
is($oChild->getThis(),  10, 'should be 10');
is($oChild->getThat(),  20, 'should be 20');
is($oChild->getThe(),   30, 'should be 30');
is($oChild->getOther(), 40, 'should be 40');
is($oChild->getChain(), 50, 'should be 50');
is($oChild->getAVeryJavaLikeProperty(), 50, 'should be 50');
is($oChild->getThis(42),  10, 'should not set value');

note 'setCamelCase value';
is($oChild->setThis(-1), -1, 'should be set to -1');
is($oChild->setThat(2),   2, 'should be set to 2');
is($oChild->setThe(6),   30, 'should return old value 30');
is($oChild->getThe(),     6, 'should be set to 6');
is($oChild->setOther(8), 40, 'should return old value 40');
is($oChild->getOther(),   8, 'should be set to 8');
is($oChild->setChain(9)->getChain(),  9, 'should follow chain and be 9');
is($oChild->setAVeryJavaLikeProperty(100), 100, 'should be 100');
