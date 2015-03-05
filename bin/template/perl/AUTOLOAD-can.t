#!/usr/bin/env perl

use Test::More tests => 5;
use strict;
use warnings;
use English-no_match_vars;

use Test::Deep;

BEGIN
{
    use_ok 'Blis::Infinity::Dashboard::Auth';
}

package Mock::Org;
use strict;
use warnings;
use Carp qw(croak);
use English-no_match_vars;
our ( $DEBUG, $AUTOLOAD ) = (0); # DEBUG goes up to 4

our $DEFAULT = {
    id                     => 1,
    type                   => 'superuser',
    name                   => 'testmedia.org',
    parent_organisation_id => 0
};

sub new
{
    my %self = %{ $DEFAULT };
    return bless \%self, shift;
}

# automatic method generation via AUTOLOAD
# source: http://www.perlmonks.org/?node_id=8227

sub DESTROY { }    # prevent AUTOLOAD getting this
sub AUTOLOAD
{
    my $self = shift or return undef;

    print __PACKAGE__ . "::AUTOLOAD($AUTOLOAD)\n" if $DEBUG;
    # Get the called method name and trim off the fully-qualified part
    ( my $method = $AUTOLOAD ) =~ s{.*::}{};
    print __PACKAGE__ . "::AUTOLOAD($AUTOLOAD) method = $method\n" if $DEBUG > 1;

    # If the data member being accessed exists, build an accessor for it
    if ( exists $self->{$method} )
    {
        ### Create a closure that will become the new accessor method
        print __PACKAGE__ . "::AUTOLOAD($AUTOLOAD) create ->$method() accessor\n" if $DEBUG > 2;
        my $accessor = sub
        {
            my $closureSelf = shift;
            my $value = $closureSelf->{$method};
            if (@ARG)
            {
			    my $new_value = shift;
                print __PACKAGE__ . "::AUTOLOAD($AUTOLOAD) set ->$method($new_value) was $value\n" if $DEBUG > 3;
                return $closureSelf->{$method} = $value;
            }
			else
			{
                print __PACKAGE__ . "::AUTOLOAD($AUTOLOAD) get ->$method() == $value\n" if $DEBUG > 3;
			}

            return $value;
        };

        # Assign the closure to the symbol table at the place where the real
        # method should be. We need to turn off strict refs, as we'll be mucking
        # with the symbol table.
    SYMBOL_TABLE_HACQUERY:
        {
            no strict qw{refs};
            *$AUTOLOAD = $accessor;
        }

        # Turn the call back into a method call by sticking the self-reference
        # back onto the arglist
        unshift @ARG, $self;

        # Jump to the newly-created method with magic goto
        goto &$AUTOLOAD;
    }

    ### Handle other autoloaded methods or errors
    croak(qq{Can't locate object method "$method" via package "@{[__PACKAGE__]}"});
} # sub AUTOLOAD()

# can - Help UNIVERSAL::can() cope with our AUTOLOADed methods
sub can
{
    my ($self, $method) = @_;

    print __PACKAGE__ . "::can($method)\n" if $DEBUG;
    my $subref = $self->SUPER::can($method);
    print __PACKAGE__ . "::can($method) real? @{[$subref // 'no']}\n" if $DEBUG > 1;
    return $subref if $subref; # can found it; it's a real method

    # Method doesn't currently exist; should it, though?
    print __PACKAGE__ . "::can($method) could? @{[exists($self->{$method}) || 'no']}\n" if $DEBUG > 1;
    return unless exists $self->{$method};

    # Return an anon sub that will work when it's eventually called
    print __PACKAGE__ . "::can($method) create ->$method() placeholder\n" if $DEBUG > 2;
    return sub {
        my $innerSelf = $ARG[0];

        print __PACKAGE__ . "::can($method){placeholder} access ->$method() placeholder\n" if $DEBUG > 3;
        # The method is being called.  The real method may have been
        # created in the meantime; if so, don't call AUTOLOAD again
        my $subref = $innerSelf->SUPER::can($method);
        print __PACKAGE__ . "::can($method){placeholder} already loaded ? @{[$subref // 'no']}\n" if $DEBUG > 3;
        goto &$subref if $subref;

        print __PACKAGE__ . "::can($method){placeholder} over to AUTOLOAD\n" if $DEBUG > 3;
        $AUTOLOAD=$method; 
        goto &AUTOLOAD 
    };
} # sub can()

package main;

#$Mock::Org::DEBUG = 4;

my $oTestOrg;
$oTestOrg = new_ok('Mock::Org');
note explain $oTestOrg;
can_ok($oTestOrg, 'flibble');
can_ok($oTestOrg, 'id');
my $meth = $oTestOrg->can('id');
diag "invoke can method";
$oTestOrg->$meth;

$meth = $oTestOrg->can('type');
$oTestOrg->type(); # AUTOLOAD makes it
$oTestOrg->$meth; # invoke placeholder

$oTestOrg->can('new');

my $oTestOrgObj = Blis::Infinity::Dashboard::Auth::get_organisation_obj($oTestOrg);
note explain $oTestOrgObj;
cmp_deeply($oTestOrgObj, $Mock::Org::DEFAULT, 'should be regular hash with organisation properties');
