#!/bin/bash
# update the i3-config and i3-launch file for current main and aux monitors

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

if [ ${OUTPUT_AUX:-error} == ${OUTPUT_AUX2:-error} ]; then
	# 1 or 2 monitors only
	export I3WORKSPACES='
		set $shell 1
		set $edit 2
		set $app 3
		set $email 4
		set $build 5
		set $chat 6
		set $vbox 7
		set $help 7
		set $files 8
	'

	export I3MAIN='$build $chat $vbox $files $help'
	export I3AUX='$shell $edit $app $email $help'
	export I3AUX2=''
else
	# 3 monitors
	export I3WORKSPACES='
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

	export I3MAIN='$build $vbox $files'
	export I3AUX='$email $chat $help'
	export I3AUX2='$shell $edit $app'
fi

# update monitor variables in config file
echo updating i3 config file $OUTPUT_MAIN $OUTPUT_AUX $OUTPUT_AUX2
#set $main eDP1
#set $aux HDMI1 # HOME

#echo $I3WORKSPACES

config=~/bin/cfg/.i3-config
perl -i.bak -pne '
	$definitions = $ENV{I3WORKSPACES};
	$definitions =~ s{\n \s* \z}{\n}xmsg;

	s{\A \s* (set \s+ \$main \s+) .+? \n \z}{$1$ENV{OUTPUT_MAIN}\n}xms;
	s{\A \s* (set \s+ \$aux  \s+) .+? \n \z}{$1$ENV{OUTPUT_AUX}\n}xms;
	s{\A \s* (set \s+ \$aux2 \s+) .+? \n \z}{$1$ENV{OUTPUT_AUX2}\n}xms;
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
egrep 'set\s+\$(main|aux)' $config
grep WORKSPACEDEF -B 7 -A 7 $config

config=~/bin/i3-launch.sh
perl -i.bak -pne '
	BEGIN
	{
		$definitions = $ENV{I3WORKSPACES};
		$definitions =~ s{\bset \s+ \$(\w+) \s+ (.+? \n)}{$1=$2}xmsg;
		$definitions =~ s{\n \s* \z}{\n}xmsg;
		print STDERR "definitions [$definitions]";
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
grep WORKSPACEDEF -B 7 -A 7 $config
