#!/bin/bash
# update the i3-config and i3-launch file for current main and aux monitors

COMPANY=
if [ -f ~/.COMPANY ]; then
    . ~/.COMPANY
fi

CONFIG="$HOME/bin/cfg/$COMPANY/.i3-config"
LAUNCH="$HOME/bin/cfg/$COMPANY/i3-launch.sh"
DOCK="$HOME/bin/cfg/$COMPANY/i3-dock.sh"

if [ ${OUTPUT_MAIN:-error} == error ]; then
	source `which detect-monitors.sh`
fi

if [ ${OUTPUT_MAIN:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX:-error} == error ]; then
	exit 1
fi
if [ ${OUTPUT_AUX2:-error} == error ]; then
	exit 1
fi

# force for testing N monitors...
#OUTPUT_AUX=TESTAUX
#OUTPUT_AUX2=TESTAUX

if [ ${OUTPUT_AUX:-error} == ${OUTPUT_AUX2:-error} ]; then
	# 1 or 2 monitors only
	export I3WORKSPACES='
		# 1 or 2 monitors
		set $shell 1
		set $edit 2
		set $app 3
		set $email 4
		set $build 5
		set $chat 6
		set $vbox 7
		set $help 10
		set $files 8
	'
	export I3SCREENS='
		# assign workspaces to 1 or 2 monitors
		workspace 10  output $main
		workspace 8   output $main
		workspace 7   output $main
		workspace 6   output $main
		workspace 5   output $main

		workspace 9   output $aux
		workspace 4   output $aux
		workspace 3   output $aux
		workspace 2   output $aux
		workspace 1   output $aux
	'
else
	# 3 monitors
	export I3WORKSPACES='
		# 3 monitors
		set $shell 1
		set $edit 2
		set $app 3
		set $email 9
		set $build 5
		set $chat 6
		set $vbox 7
		set $help 10
		set $files 8
	'

	export I3SCREENS='
		# assign workspaces to 3 monitors
		workspace 10  output $aux
		workspace 8   output $main
		workspace 7   output $main
		workspace 6   output $aux
		workspace 5   output $main

		workspace 9   output $aux
		workspace 4   output $aux2
		workspace 3   output $aux2
		workspace 2   output $aux2
		workspace 1   output $aux2
	'
fi

# update monitor variables in config file
echo updating i3 config file $OUTPUT_MAIN $OUTPUT_AUX $OUTPUT_AUX2
#set $main eDP1
#set $aux HDMI1 # HOME

#echo $I3WORKSPACES

config=$CONFIG
perl -i.bak -pne '
	$definitions = $ENV{I3WORKSPACES};
	$definitions =~ s{\n \s* \z}{\n}xmsg;
	$screens = $ENV{I3SCREENS};
	$screens =~ s{\n \s* \z}{\n}xmsg;

	s{\A \s* (set \s+ \$main \s+) .+? \n \z}{$1$ENV{OUTPUT_MAIN}\n}xms;
	s{\A \s* (set \s+ \$aux  \s+) .+? \n \z}{$1$ENV{OUTPUT_AUX}\n}xms;
	s{\A \s* (set \s+ \$aux2 \s+) .+? \n \z}{$1$ENV{OUTPUT_AUX2}\n}xms;
	if (!$in_workspace_def) {
		if (m{\A ( \s* \# WORKSPACEDEF ) \s* \z}xms)
		{
			$in_workspace_def = 1;
			$_ = "$1\n#  do not edit settings here...$definitions$screens";
		}
	}
	else {
		if (s{\A \s* (\# / WORKSPACEDEF) \s* \z}{$1\n}xms)
		{
			$in_workspace_def = 0;
		}
		else
		{
			$_ = "";
		}
	}
' $config
echo $config updated
egrep 'set\s+\$(main|aux)' $config
middle.sh '#WORKSPACEDEF' '#/WORKSPACEDEF' $config

config=$LAUNCH
perl -i.bak -pne '
	BEGIN
	{
		$definitions = $ENV{I3WORKSPACES};
		$definitions =~ s{\bset \s+ \$(\w+) \s+ (.+? \n)}{$1=$2}xmsg;
		$definitions =~ s{\n \s* \z}{\n}xmsg;
		#print STDERR "definitions [$definitions]";
	}
	if (!$in_workspace_def) {
		if (m{\A ( \s* \# WORKSPACEDEF ) \s* \z}xms)
		{
			$in_workspace_def = 1;
			$_ = "$1\n#  do not edit settings here...$definitions";
		}
	}
	else {
		if (s{\A \s* (\# / WORKSPACEDEF) \s* \z}{$1\n}xms)
		{
			$in_workspace_def = 0;
		}
		else
		{
			$_ = "";
		}
	}
' $config
echo $config updated
middle.sh '#WORKSPACEDEF' '#/WORKSPACEDEF' $config

config=$DOCK
perl -i.bak -pne '
	$screens = $ENV{I3SCREENS};
	$screens =~ s{\bworkspace\b}{move_workspace}xmsg;
	$screens =~ s{\$(main|aux2?)}{qq{\$OUTPUT_} . uc($1)}xmsge;
	$screens =~ s{\n \s* \z}{\n}xmsg;

	if (!$in_workspace_def) {
		if (m{\A ( \s* \# WORKSPACEDEF ) \s* \z}xms)
		{
			$in_workspace_def = 1;
			$_ = "$1\n#  do not edit settings here...$screens";
		}
	}
	else {
		if (s{\A \s* (\# / WORKSPACEDEF) \s* \z}{$1\n}xms)
		{
			$in_workspace_def = 0;
		}
		else
		{
			$_ = "";
		}
	}
' $config
echo $config updated
middle.sh '#WORKSPACEDEF' '#/WORKSPACEDEF' $config
