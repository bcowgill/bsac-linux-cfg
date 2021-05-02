#!/usr/bin/env perl
# Script to generate a new component or util module with associated unit tests or story and factory

use strict;
use warnings;
use English qw(-no_match_vars);
use File::Path;
use File::Spec;
use File::Basename;
use Data::Dumper;

my $DEBUG = 0;
my @Asked = ();

my $template_path = 'templates';

my $type = menu(
	'What do you want to create?',
	{
		component => 'a React <C>omponent',
		component_utility => 'a utilit<y> for React components',
		reducer => 'a Redux <R>educer',
		action => 'a Redux set of <A>ctions',
		utility => 'a general <u>tility',
		facade => 'a <F>acade index',
	});

my $rhSubPaths = {
	component => 'src/components',
	component_utility => 'src/components/utils',
	reducer => 'src/reducers',
	action => 'src/actions',
	utility => 'src/utils',
};

my $rhNameExample = {
	component => 'RadioBox',
	component_utility => 'thingFormatter',
	reducer => 'thingReducer',
	action => 'doSomething',
	utility => 'thingFormatter',
	facade => 'ThingName',
};

my $rhObjectCase = {
	component => 'ToCase',
	component_utility => 'toCase',
	reducer => 'toCase',
	action => 'toCase',
	utility => 'toCase',
	facade => 'ToCase',
};

our $reObjName = qr{^\w{3,}$}xms;
our $reFileName = qr{^[\w\.\-]{3,}$}xms;
our $reShoutCase = qr{^[A-Z][A-Z_]+[A-Z]\z}xms;

our $has_test = 0;
our $has_story = 0;
our $has_factory = 0;
our $is_react_facade = 0;

my $src_path = $rhSubPaths->{$type} || 'src';

if ($type eq 'facade') {
	$is_react_facade = ask("\nIs it a facade for a React component", 'y');
	$src_path = $rhSubPaths->{component} if $is_react_facade;
}

my $sub_path = ask_for_path_from("\nWhat directory does your $type go in", $src_path);

my $final_dir = get_final_dir($sub_path);
my $name_example = $rhNameExample->{$type};
if (!$final_dir && $type eq 'utility') {
	$final_dir = $sub_path;
}
$name_example = to_case($rhObjectCase->{$type} || 'ToCase', $final_dir) if ($final_dir);

my $object_name = ask_for("\nWhat is the name of your $type", $name_example, $reObjName);

my $default_filename = kebab_case($object_name);

if ($type eq 'component')
{
	my $file_name = ask_for_file("\nWhat is the file name of your $type", $default_filename, $src_path, $sub_path);
	my $is_pure = ask('Do you want a Pure component (no state, no event handlers)', 'y');
	my $has_state;
	if (!$is_pure) {
		$has_state = ask('Does your component need state', 'n');
	}
	ask_test_story_factory();

	summarise_options("\tfile name: $file_name", "\tis pure: $is_pure", "\thas state: $has_state");
	do_component($object_name, $sub_path, $file_name, $is_pure, $has_state);
}
elsif ($type eq 'reducer')
{
	my $file_name = ask_for_file("\nWhat is the file name of your $type", $default_filename, $src_path, $sub_path);
	my $action_prefix = ask_for("\nWhat kind of action names will your $type process", "VALIDATE_USER", $reShoutCase);
	ask_test();

	summarise_options("\tfile name: $file_name", "\taction prefix: $action_prefix");
	do_reducer($object_name, $sub_path, $file_name, $action_prefix);
}
elsif ($type eq 'action')
{
	my $file_name = ask_for_file("\nWhat is the file name of your $type", $default_filename, $src_path, $sub_path);
	my $example = to_case('TO_CASE', $file_name);
	my $action_prefix = ask_for("\nWhat kind of action names will your $type process", $example, $reShoutCase);
	ask_test();

	summarise_options("\tfile name: $file_name", "\taction prefix: $action_prefix");
	do_action($object_name, $sub_path, $file_name, $action_prefix);
}
elsif ($type =~ m{utility}xms)
{
	my $file_name = ask_for_file("\nWhat is the file name of your $type", $default_filename, $src_path, $sub_path);
	ask_test();

	summarise_options("\tfile name: $file_name");
	do_utility($object_name, $sub_path, $file_name);
}
elsif ($type eq 'facade')
{
	my $file_name = ask_for_file("\nWhat is the file name of your $type implmentation", $default_filename, $src_path, $sub_path);
	ask_test();

	summarise_options("\tfile name: $file_name");
	do_facade($object_name, $sub_path, $file_name);
}
else
{
	die "$type is not a supported type";
}

sub summarise_options
{
	print "\nYou selected:\n";
	print "\ttype: $type\n";
	print "\tsub path: $sub_path\n";
	print "\tobject name: $object_name\n";
	print "\tis component facade: $is_react_facade\n";
	print "\thas test: $has_test\n";
	print "\thas story: $has_story\n";
	print "\thas factory: $has_factory\n";
	print join("\n", @ARG, '');
}

# Was thinking of changing the replacement code to support different types of case replacements:
# If the user originally gives an object in Camel Case then alternate case versions are accessed via a suffix:

# %OBJ%       ObjectName
# %OBJ_CAMEL% objectName
# %OBJ_SNAKE% object_name
# %OBJ_KEBAB% object-name
# %OBJ_CONST% OBJECT_NAME
# %OBJ_DOTS%  object.name

sub do_component
{
	my ($object_name, $sub_path, $file_name, $is_pure, $has_state) = @ARG;

	my $rhReplace = setup_replacer($sub_path, $file_name, $object_name);
	$rhReplace->{TEMPLATEPATH} = strip_final_dir($sub_path);
	$rhReplace->{TEMPLATESTORYPATH} = get_first_dir($sub_path);

	my $rhFiles = {
		'facade-index.js' => 'index.js',
		'component.less' => 'styles.less',
	};
	$rhFiles->{'component.pure.jsx'} = "$file_name.jsx" if $is_pure;
	$rhFiles->{'component.state.jsx'} = "$file_name.jsx" if $has_state;
	$rhFiles->{'component.jsx'} = "$file_name.jsx" unless $is_pure || $has_state;
	$rhFiles->{'component.factory.jsx'} = "$file_name.factory.jsx" if $has_factory;
  $rhFiles->{'component.stories.js'} = "$file_name.stories.js" if $has_story;
	if ($has_test)
	{
		if ($has_factory)
		{
			$rhFiles->{'component.pure.factory.spec.jsx'} = "$file_name.spec.jsx" if $is_pure;
			$rhFiles->{'component.state.factory.spec.jsx'} = "$file_name.spec.jsx" if !$is_pure && $has_state;
			$rhFiles->{'component.factory.spec.jsx'} = "$file_name.spec.jsx" unless $is_pure || $has_state;
		}
		else
		{
			$rhFiles->{'component.pure.spec.jsx'} = "$file_name.spec.jsx" if $is_pure;
			$rhFiles->{'component.state.spec.jsx'} = "$file_name.spec.jsx" if !$is_pure && $has_state;
			$rhFiles->{'component.spec.jsx'} = "$file_name.spec.jsx" unless $is_pure || $has_state;
		}
	}

  # Handle where an existing component is already in an index.jsx file
	# we want to rename it my-component.jsx and create an index.js which loads it
	my $index_jsx = catpath($rhReplace->{TEMPLATEOUTPATH}, 'index.jsx');
	my $component_jsx = catpath($rhReplace->{TEMPLATEOUTPATH}, "$file_name.jsx");
	if (-f $index_jsx)
	{
		my $no_argv = 1;
		print("\nThere is already a component in $index_jsx\n");
		grok_file($index_jsx);
		print "\nI can use git to MOVE and COMMIT this file if you like.\n";
		my $move = ask("\nDo you want to rename it $file_name.jsx", 'n', $no_argv);
		if ($move)
		{
			print "GIT MV $index_jsx $component_jsx\n";
			system(qq{git mv "$index_jsx" "$component_jsx"}) == 0 || die "ERROR in git move: $?";
			system(qq{git commit --no-verify -m "Created component $file_name.jsx from facade $index_jsx"}) == 0 || die "ERROR in git commit: $?";
			delete($rhFiles->{'component.pure.jsx'}) if $is_pure;
			delete($rhFiles->{'component.jsx'}) unless $is_pure;
		}
	}

	process_files($rhFiles, $rhReplace);
}

sub do_utility
{
	my ($object_name, $sub_path, $file_name) = @ARG;

	my $rhReplace = setup_replacer($sub_path, $file_name, $object_name);

	my $rhFiles = {
		'simple.js' => "$file_name.js",
		'simple.spec.js' => "$file_name.spec.js",
	};
	delete($rhFiles->{'simple.spec.js'}) unless $has_test;

	process_files($rhFiles, $rhReplace);
}

sub do_reducer
{
	my ($object_name, $sub_path, $file_name, $action_prefix) = @ARG;

	my $rhReplace = setup_replacer($sub_path, $file_name, $object_name);
	$rhReplace->{TEMPLATEACTION} = $action_prefix;
	$rhReplace->{TEMPLATEACTIONFUNC} = to_case('toCase', $action_prefix);
	$rhReplace->{TEMPLATEACTIONTEST} = to_case('ToCase', $action_prefix);
	$rhReplace->{TEMPLATEACTIONFILE} = to_case('to-case', $action_prefix);

	my $rhFiles = {
		'reducer.js' => "$file_name.js",
		'reducer.spec.js' => "$file_name.spec.js",
	};
	delete($rhFiles->{'reducer.spec.js'}) unless $has_test;

	process_files($rhFiles, $rhReplace);
}

sub do_action
{
	my ($object_name, $sub_path, $file_name, $action_prefix) = @ARG;

	my $rhReplace = setup_replacer($sub_path, $file_name, $object_name);
	$rhReplace->{TEMPLATEACTION} = $action_prefix;

	my $rhFiles = {
		'action.js' => "$file_name.js",
		'action.spec.js' => "$file_name.spec.js",
	};
	delete($rhFiles->{'action.spec.js'}) unless $has_test;

	process_files($rhFiles, $rhReplace);
}

sub do_facade
{
	my ($object_name, $sub_path, $file_name) = @ARG;
	my $rhReplace = setup_replacer($sub_path, $file_name, $object_name);

	my $rhFiles = {
		'facade-index.js' => 'index.js',
	};
	if ($has_test) {
		$rhFiles->{'facade.component.spec.js'} = 'index.spec.js' if $is_react_facade;
		$rhFiles->{'facade.spec.js'} = 'index.spec.js' unless $is_react_facade;
	}

	process_files($rhFiles, $rhReplace);
}

# Process the files which need to be created
# at this time we also show the actual command line command which could
# be used to bypass the individual questions being asked.
sub process_files
{
	my ($rhFiles, $rhReplace) = @ARG;
	if ($DEBUG)
	{
		print Dumper(\$rhReplace);
		print Dumper(\$rhFiles);
	}
	print "\ncombined command:\n$0 " . join(' ', @Asked) . "\n\n";
	if ($DEBUG > 1)
	{
		exit(1);
	}
	process_templates($template_path, $rhReplace->{TEMPLATEOUTPATH}, $rhFiles, $rhReplace);
}

# Set up the replacement markers for processing templates.
sub setup_replacer
{
	my ($sub_path, $file_name, $object_name) = @ARG;

	my $out_path = catpath($src_path, $sub_path);
	my $rhReplace = {
		TEMPLATESRCPATH => $src_path, # global
		TEMPLATEOUTPATH => $out_path,
		TEMPLATEOUTFILE => catpath($out_path, $file_name),
		TEMPLATEFILENAME => $file_name,
		TEMPLATEOBJNAME => $object_name,
		TEMPLATETESTNAME => to_case('ToCase', $object_name),
		TEMPLATEPATH => $sub_path,
	};
	return $rhReplace;
}

# Convert some text to different case based on need.
sub to_case {
	my ($case, $name) = @ARG;
	return kebab_case($name) if $case eq 'to-case';
	return bactrian_case($name) if $case eq 'ToCase';
	return dromedary_case($name) if $case eq 'toCase';
	return shout_case($name) if $case eq 'TO_CASE';
}

# Convert some text to shish-kebab-case for filenames
sub kebab_case
{
	my ($name) = @ARG;
	$name =~ tr[_][-];
	# ALL-CAPS -> all-caps
	$name = lc($name) unless $name =~ m{[a-z]}xms;
	# HTMLThing -> html-thing
	$name =~ s{([A-Z]+)([A-Z])}{'-' . lc($1) . '-' . lc($2)}xmsge;
	# SomeThing -> Some-thing
	$name =~ s{([a-z])([A-Z])}{$1 . '-' . lc($2)}xmsge;
	$name =~ s{--+}{-}xmsg;
	$name =~ s{\A-}{}xms;
	$name =~ s{-\z}{}xms;
	# Some -> some
	$name =~ s{\A([A-Z])}{lc($1)}xmsge;
	return $name;
}

# Convert some text to SHOUT_CASE for names of constants
sub shout_case
{
	my ($name) = @ARG;
	my $kebab = kebab_case($name);
	$kebab =~ tr[-][_];
	return uc($kebab);
}

# Convert some text to BactrianCamelCase for Class or Object names
sub bactrian_case
{
	my ($name) = @ARG;

	# ALL_CAPS =-> all_caps
	$name = lc($name) unless $name =~ m{[a-z]}xms;
	$name =~ tr[_][-];
	$name =~ s{--+}{-}xmsg;
	$name =~ s{-([a-z])}{uc($1)}xmsge;
	return ucfirst($name);
}

# Convert some text to dromedaryCamelCase for function or variable names
sub dromedary_case
{
	my ($name) = @ARG;

	return lcfirst(bactrian_case($name));
}

sub ask_test_story_factory
{
	$has_test = ask_test();
	$has_story = ask('Do you want a storybook story', 'y');
	$has_factory = $has_story || ($has_test && ask('Do you want a factory', 'y'));
}

sub ask_test
{
	$has_test = ask('Do you want a unit test plan', 'y');
	return $has_test;
}

# Ask the user for a yes no answer or get from command line.
# Answers here will be remembered as asked for in @Asked
sub ask
{
	my ($prompt, $default, $no_argv) = @ARG;
	my $rhOptions = {
		n => 0,
		y => 1,
	};
	my $showYN = '';
	if (defined($default)) {
		$default = uc($default);
		$showYN = ($default eq 'Y') ? ' [Y/n]' : ' [y/N]';
		$default = lc($default);
	}
	print "$prompt$showYN? ";

	my $selected = get_input('lc', $no_argv) || $default || '';

	die "Selection <$selected> is not allowed" unless exists($rhOptions->{$selected});
	return $rhOptions->{$selected};
}

# Ask user for a path name (or get from command line)
# Will show files in the source path.
# if user replies with block? it would append to the source path
# and ask again after showing files, so you can navigate.
sub ask_for_path_from
{
	my ($prompt, $path_from, $default) = @ARG;

	my $ask_again = 1;
	my $sub_path = '';
	my $selected;
	while ($ask_again)
	{
		my $full_path_from = directory_prompt($prompt, $path_from, $default, $sub_path);
		$selected = get_input() || $default || '';
		# handle user putting full path in from command line, strip off the root dir
		$selected = '' if $selected eq $path_from;
		if ($selected =~ m{\A$path_from/(.*)\z}xms)
		{
			$selected = $1;
		}
		if ($selected =~ m{\?\z}xms) {
			chop($selected);
			print "navigate to $selected from $full_path_from\n";
			my $path = catpath($full_path_from, $selected);
			if (! -e $path)
			{
				warn("WARNING: Directory $path does not exist.\n");
			}
			$sub_path = catpath($sub_path, $selected);
			$sub_path =~ s{[^/\.]+/\.\.(/|\z)}{}xmsg;
			$sub_path =~ s{/\z}{}xmsg;
		}
		else
		{
			$ask_again = 0;
			my $path = catpath($full_path_from, $selected);
			if ( -e $path)
			{
				warn("WARNING: Directory $path already exists.\n");
			}
		}
	}
	# TODO clean up the path for something/../
	if ($sub_path)
	{
		$selected = catpath($sub_path, $selected);
	}
	$selected =~ s{/\.\/}{/}xmsg; # /./ is removed
	$selected =~ s{\A\.\z}{}xmsg; # . becomes empty
	return $selected;
}

# Ask user for a file name (or get from command line)
# Will show files in the source path.
# TODO if user replies with block? it would append to the source path
# and ask again after showing files, so you can navigate.
sub ask_for_file
{
	my ($prompt, $example, $path_from, $sub_path) = @ARG;

	my $full_path = catpath($path_from, $sub_path);
	directory_prompt($prompt, $full_path, 'NO?');
	my $file_name = ask_for('', $example, $reFileName);
	# TODO clean up the path for /../  or /./
	return $file_name;
}

# Show a prompt to get a directory path, with an example/default
# The contents of the top directory is shown to make selection easier.
sub directory_prompt
{
	my ($prompt, $path_from, $example, $sub_path) = @ARG;

	my $full_path_from = catpath($path_from, $sub_path || '');
	my $show_example = $example ? "[$example] ? ": '? ';
	$show_example = '' if ($example && $example eq 'NO?');
	print $prompt;
	print " under $full_path_from\n";
	system("ls $full_path_from") if (-e $full_path_from);
	if (defined $sub_path)
	{
		print "\n you may use ? to navigate i.e. ..? or subdir?";
	}
	print "\n$show_example";
	return $full_path_from;
}

# Ask the user for some text with optional example/default and regex validation
# It will also get input from the command line if there are any arguments leftover
# any default values used here will be remembered as being asked for in @Asked
sub ask_for
{
	my ($prompt, $example, $regex) = @ARG;

	print $prompt;
	print " [$example]" if $example;

	my $invalid = 1;
	my $selected;
	while ($invalid)
	{
		print ' ? ';
		$selected = get_input();
		if ($example && $selected eq '') {
			$selected = $example;
			$Asked[-1] = $example;
		}
		$invalid = 0;
		if ($regex && $selected !~ $regex) {
			$invalid = 1;
			print "That's not valid, must match $regex\nTry again";
		}
	}
	return $selected;
}

# Performs a menu, by printing it and waiting for a selection to be made.
# Selections can come from command line arguments also.
sub menu
{
	my ($prompt, $rhMenu) = @ARG;
	my $rhOptions = print_menu($prompt, $rhMenu);

	my $selected = get_input('lc');
	return $selected if $rhMenu->{$selected};
	return $rhOptions->{lc($selected)} if exists($rhOptions->{lc($selected)});
	die "Selection <$selected> is not allowed";
}

sub print_menu
{
	my ($prompt, $rhMenu) = @ARG;
	my $rhOptions = {};
	print "$prompt\n";
	foreach my $key (sort(keys(%$rhMenu)))
	{
		my $item = $rhMenu->{$key};
		my $char = get_char($item);
		$item = get_ui_item($item);
		print "$char) $item\n";
		die "Menu item $char) $item is duplicate $rhOptions->{$char}" if $rhOptions->{$char};
		$rhOptions->{$char} = $key;
	}
	print '? ';
	return $rhOptions;
}

# Get some input from the user or command line arguments.
# can force to be lower case and force to get from user.
# Values received here are remembered in @Asked that they
# were asked for.
sub get_input
{
	my ($is_lc, $no_argv) = @ARG;
	my $selected = get_arg() unless $no_argv;
	if ($selected)
	{
		print "$selected\n";
	}
	else
	{
		$selected = <STDIN>;
		chomp($selected);
		push(@Asked, $selected =~ m{\A\s*\z}xms ? "'$selected'" : $selected);
	}
	if ($is_lc)
	{
		$selected = lc($selected);
	}
	return $selected;
}

# Gets a command line argument and remembers that it was asked for.
sub get_arg
{
	my $selected = shift(@ARGV);
	if (defined($selected)) {
		if ($selected =~ m{\A\s*\z}xms)
		{
			push(@Asked, "'$selected'");
		}
		else
		{
			push(@Asked, $selected);
		}
	}
	return $selected;
}

# Gets the hot key character for a menu item as marked by <h>.
sub get_char
{
	my ($item) = @ARG;
	$item =~ m{<(.)>}xms;
	my $char = lc($1);
	die "Menu item has no <x> hot key marker: $item\n" unless $char;
	return $char;
}

# Get menu item text omitting <h>ot key markers
sub get_ui_item
{
	my ($item) = @ARG;
	$item =~ s{<(.)>}{$1}xms;
	return $item;
}

# Process all the templates into new output files
sub process_templates
{
	my ($template_dir, $out_dir, $rhTemplates, $rhReplaceWith) = @ARG;

	foreach my $template (sort(keys(%$rhTemplates)))
	{
		my $template_name = catpath($template_dir, $template);
		my $new_file = catpath($out_dir, $rhTemplates->{$template});
		process_template_file($template_name, $new_file, $rhReplaceWith);
	}
}

# Process a template file and write to output file asking to overwrite
# if output file already exists.
sub process_template_file
{
	my ($template_name, $new_file, $rhReplaceWith) = @ARG;

	if (-e $new_file)
	{
		my $no_argv = 1;
		print("\nFile already exists $new_file\n");
		grok_file($new_file);
		my $overwrite = ask("\nDo you want to replace it", 'n', $no_argv);
		$new_file = undef unless $overwrite;
	}
	if ($new_file)
	{
		my $content = read_file($template_name);
		print "CREATE $new_file from $template_name\n";
		$content = process_template($content, $rhReplaceWith);
		make_file_dir($new_file);
		write_file($new_file, $content);
	}
}

# process a template file by replacing longest keys first with their values
sub process_template
{
	my ($content, $rhReplaceWith) = @ARG;
	my @keys = sort { length($b) <=> length($a) } keys(%$rhReplaceWith);
	foreach my $search (@keys)
	{
		$content =~ s{$search}{$rhReplaceWith->{$search}}xmsg;
	}
	# finally correct directory paths affected by subdir/../
	$content =~ s{\w+/\.\./}{}xmsg;
	return $content;
}

# show file info and first few lines from file
sub grok_file
{
	my ($file) = @ARG;
	system("ls -al $file");
	system("head $file");
}

sub get_first_dir
{
	my ($path) = @ARG;
	my $first_dir = '';
	my @dirs = File::Spec->splitdir($path);
	$first_dir = shift(@dirs) if (scalar(@dirs) > 0);

	return $first_dir;
}

sub get_final_dir
{
	my ($path) = @ARG;
	my $final_dir;
	my @dirs = File::Spec->splitdir($path);
	$final_dir = pop(@dirs) if (scalar(@dirs) > 1);

	return $final_dir;
}

sub strip_final_dir
{
	my ($path) = @ARG;
	my @dirs = File::Spec->splitdir($path);
	pop(@dirs) if (scalar(@dirs) > 1);
	my $stripped_dir = File::Spec->catdir(@dirs);

	return $stripped_dir;
}

# Concatenate one path/file onto another.
sub catpath
{
	my ($path, $sub_path) = @ARG;
	my $no_file = 1;
	my ($volume, $directories, $file) = File::Spec->splitpath( $path, $no_file );
	my $out_path = File::Spec->catpath($volume, $directories, $sub_path);
	return $out_path;
}

# Make the directory and all paths up to for a given new file.
sub make_file_dir
{
	my ($new_file) = @ARG;

	my $verbose = 1;
	my $path = dirname($new_file);
	mkpath($path, $verbose) unless (-e $path);
}

sub read_file
{
	my ($file_name) = @ARG;
	local $/ = undef;
	my $fh;
	open($fh, '<', $file_name) || die "Error open for read $file_name: $!";
	my $contents = <$fh>;
	close($fh);
	return $contents;
}

sub write_file
{
	my ($file_name, $contents) = @ARG;
	my $fh;
	open($fh, '>', $file_name) || die "Error open for write $file_name: $!";
	print $fh $contents;
	close($fh);
	return $contents;
}
