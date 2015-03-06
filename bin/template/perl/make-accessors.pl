alternative to autoload, jsut make the accessors

  package Parent;
  use strict;

  sub make_accessors {
    my ($class, @attributes) = @_;
    foreach my $attribute (@attributes) {
      no strict 'refs';
      *{"$class\::$attribute"} = sub {
        my $self = shift;
        if (@_) {
          $self->{$attribute} = shift;
        }
        return $self->{$attribute};
      };
    }
  }
  
  
  package Child;
  our @ISA = 'Parent';
  __PACKAGE__->make_accessors(qw(this that the other));
