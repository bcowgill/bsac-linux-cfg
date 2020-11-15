#!/bin/bash
# Generate stub test plan files for all javascript files using a template.
# Not a generic script, you have to customise a few things here to work with your layout.
# CUSTOM settings you may have to change for a new machine
FILE=js-objects.txt
#FILE=js-test.txt
find public/blis-assets/ -name '*.js' > $FILE
perl -ne  '
	BEGIN {
		use File::Slurp;
		our $OVERWRITE = 0;
		our $DRYRUN = 1;
		# for random assignment of test plans to team members
		our @PEOPLE = qw(Brent Evgkeni Abdel);
		# test plan template file with substitution markers
		#our $TEMPLATE = q{/home/me/workbin/template/javascript/jasmine.test.js};
		our $TEMPLATE = q{/home/brent/workspace/play/bsac-linux-cfg/bin/template/javascript/jasmine.test.js};
		warn qq{slurp $TEMPLATE\n};
		$TEMPLATE = read_file($TEMPLATE);
	}
	s{ \A ( public/ ( blis-assets/ .+? ) ) / ([^/]+) \. js \s* \z }{
		my $SOURCE = $1;
		my $PATH = $2;
		my $FILENAME=$3;
		my $WHERE=qq{test/$SOURCE};
		my $PLAN=qq{$FILENAME.test.js};
		my $FULL = qq{$WHERE/$PLAN};
		my $OUT = qq{$FULL\n};
		my $PLAN = $TEMPLATE;
		my $AUTHOR = $PEOPLE[int(rand() * scalar(@PEOPLE))];
		my $WRITE = 0;
		if (-f $FULL) {
			if ($OVERWRITE) {
				$WRITE = 1;
				$OUT = qq{overwrite $OUT};
			}
			else {
				$OUT = qq{skip existing $OUT};
			}
		}
		else {
			$WRITE = 1;
			$OUT = qq{creating $OUT};
		}
		if ($WRITE) {
			$PLAN =~ s{ // \s HELP .+ // \s /HELP \s* }{}xmsg;
			$PLAN =~ s{FILENAME}{$FILENAME}xmsg;
			$PLAN =~ s{test/PATH}{$WHERE}xmsg;
			$PLAN =~ s{public/PATH}{$SOURCE}xmsg;
			# if you can identify the js object being tested from the source code
			$PLAN =~ s{OBJECT}{OBJECT}xmsg;
			$PLAN =~ s{AUTHOR}{$AUTHOR}xmsg;
			unless ($DRYRUN) {
				system(qq{mkdir -p $WHERE});
				write_file($FULL, $PLAN);
			}
			$OUT = qq{$AUTHOR $OUT};
		}
		else {
			$OUT = qq{skip existing $OUT};
		}
		print $OUT;
	}xmse;
' $FILE

