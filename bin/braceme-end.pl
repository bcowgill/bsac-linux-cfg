#!/bin/bash
# Cuddle your braces and semicolons at the end of the line of code.
perl -ne '
	BEGIN
	{
		$max_length = 0;
		$indent = " " x 4;
	}

	chomp;
	s{([\s;\{\}]+\z)}{}xms;
	$punct = $1 || "";
	$punct =~ s{\s+}{}xmsg;
	s{\s+\z}{}xmsg;
	s{\t}{$indent}xmsg;
	if ($_ eq "")
	{
		next if $punct eq "";
		$prev_punct->[1] .= $punct;
		$punct = "";
		next;
	}
	my $length = length($_);
	if ($length > $max_length)
	{
		$max_length = $length;
	}

	push(@Lines,[$_, $punct]);
	$prev_punct = $Lines[-1];

	END
	{
		foreach my $raLine (@Lines)
		{
			my ($text, $punct) = @$raLine;
			if (!$punct || $text =~ m{\#!}xms)
			{
				print "$text\n";
			}
			else
			{
				print $text . (" " x ($max_length - length($text))) . $punct . "\n";
			}
		}
	}
' $*
