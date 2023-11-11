#!/bin/bash
# Cuddle your braces and semicolons at the start of the line of code.
perl -ne '
	BEGIN
	{
		$max_length = 4;
		$prev_punct = "";
	}

	chomp;
	s{([\s;\{\}]+\z)}{}xms;
	$punct = $1 || "";
	$punct =~ s{\s+}{}xmsg;
	s{\s+\z}{}xmsg;
	if ($_ eq "")
	{
		next if $punct eq "";
		$prev_punct .= $punct;
		my $length = length($prev_punct);
		if ($length > $max_length)
		{
			$max_length = $length;
		}
		$punct = "";
		next;
	}
	my $length = length($punct);
	if ($length > $max_length)
	{
		$max_length = $length;
	}

	push(@Lines,[$prev_punct, "$_\n"]);
	$prev_punct = $punct;

	END
	{
		if ($prev_punct)
		{
			push(@Lines,[$prev_punct, "\n"]);
		}
		foreach my $raLine (@Lines)
		{
			my ($punct, $text) = @$raLine;
			if ($text =~ m{\#!}xms)
			{
				print $text;
			}
			else
			{
				print $punct . (" " x ($max_length - length($punct))) . $text;
			}
		}
	}
' $*
