#!/usr/bin/env perl
# construct some mysql to generate CSV or a perl hash

my $user = shift;
my $db = shift;
my $table = shift;
my @Columns = @ARGV;

print "mysql -u $user -p -D $db << EOSQL\nSELECT " . join(", ", map { qq{concat("\\"", $_, "\\", ") as $_} } @Columns) . " FROM $table ;\nEOSQL\n";


__END__
mysql-to-csv.pl root infinity_dashboard iab_category category_id category_name

select concat("\"", category_id, "\", ") as category_id, concat("\"", category_name, "\", ") as category_name from iab_category ;
mysql -u root -p -D infinity_dashboard << EOQ
select concat("\"", category_id, "\", ") as category_id, concat("\"", category_name, "\", ") as category_name from iab_category ;
EOQ

