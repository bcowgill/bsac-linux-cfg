#!/bin/bash
# rename a test plan based on the actual file it is testing.

# tests?/ or specs?/ directory
# index.jsx? or tests?.jsx? or tests?.spec.jsx? or container.spec.jsx?

# path-name/test/test.js -> path-name/test/path-name.spec.js
# path-name/test/container.spec.js -> path-name/test/path-name.container.spec.js

# and replaces test/test.js text in the file with test/path-name.spec.js
# and replaces descSuiteFileName with descPathNameSuite

for test in $*; do
	perl -e '
		my $DEBUG = 0;
		my $DRY_RUN = 0;
		my $full_test = shift;
		print qq{$full_test\n};
		if ($full_test =~ m{\A((.+/)([^/]+))/(tests?|specs?)/((index|tests?|container)\.(spec\.)?(jsx?))}xms)
		{
			my $path = $1;
			my $above_path = $2;
			my $component = $3;
			my $tests_sub_dir = $4;
			my $tests_file_name = $5;

			my $tests_dir = "$path/$tests_sub_dir";
			my $relative_test = "$component/$tests_sub_dir/$tests_file_name";

			if ($DEBUG)
			{
				print qq{\t$above_path\n};
				print qq{\t$path\n};
				print qq{\t$component\n};
				print qq{\t$tests_sub_dir\n};
				print qq{\t$tests_dir\n};
				print qq{\t$tests_file_name\n};
				print qq{\t$relative_test\n};
			}

			sub command
			{
				my ($command) = @_;
				print $command if $DEBUG;
				system($command) unless $DRY_RUN;
			}

			sub suite_name
			{
				my ($file_name) = @_;
				$file_name =~ s{/.+\z}{}xms;
				$file_name =~ s{[-_]([a-z])}{uc($1)}xmsge;
				$file_name = "desc@{[ucfirst($file_name)]}Suite";
				print qq{suite: $file_name\n} if $DEBUG;
				return $file_name;
			}

			sub check_file
			{
				my ($check_file, $test_file, $relative_test_new) = @_;
				print qq{check: $check_file\n} if $DEBUG;
				if ( -f $check_file )
				{
					print qq{\tfound $check_file\n};
					if ($tests_file_name =~ m{\Acontainer\.spec\.}xms) {
						$test_file =~ s{\.spec}{.container.spec}xms;
						$relative_test_new =~ s{\.spec}{.container.spec}xms;
					}
					if ( ! -e $test_file )
					{
						print qq{\tmoving to $test_file\n};
						my $suite_name = suite_name($relative_test_new);
						command(qq{\tgit mv "$full_test" "$test_file"\n});
						command(qq{\treplace.sh "$relative_test" "$relative_test_new" "$test_file"\n});
						command(qq{\treplace.sh "descSuiteFileName" "$suite_name" "$test_file"\n});
						command(qq{\tgit add "$test_file"\n});
						return 1;
					}
					else
					{
						print qq{cannot fix, target already exists: $test_file\n};
					}
				}
				return 0;
			}

			eval
			{
				my $test_file_new = "$component.spec.js";
				my $relative_test_new = "$component/$tests_sub_dir/$test_file_new";
				my $test_file = "$tests_dir/$test_file_new";
				my $check_file = "$path/$component.js";
				check_file($check_file, $test_file, $relative_test_new) && die "STOP";
				$check_file .= 'x';
				check_file($check_file, $test_file, $relative_test_new) && die "STOP";
				$check_file = "$path/index.js";
				check_file($check_file, $test_file, $relative_test_new) && die "STOP";
				$check_file .= 'x';
				check_file($check_file, $test_file, $relative_test_new) && die "STOP";
				print qq{cannot fix $full_test\n};
			};
			die $@ if ($@ && $@ !~ m{\ASTOP}xms);
		}
		else
		{
			print qq{no need to fix $full_test\n};
		}
	' $test
done
