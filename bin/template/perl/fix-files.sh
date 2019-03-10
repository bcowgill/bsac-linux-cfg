#!/bin/bash
# example of search/replacements for making code IE8 backwards compatible

SRC=applications/mca/src
WHERE=applications/mca/dist
JS="$WHERE/*/scripts"
CSS="$WHERE/*/css"
if [ ! -d $WHERE/lloyds ]; then
	JS="$WHERE/*/content/*/scripts"
	CSS="$WHERE/*/content/*/css"
fi

# make webpack output nice for diffing
#for f in applications/mca/dist/*/content/*/scripts/*.js
#do
#	perl -pne 's{([,;])}{$1\n}xmsg' $f > $f.js.unwebpacked
#done
#egrep -r defineProperty $WHERE

# TODO:IE8 this post build hack is documented in the hacks/ie8-compatibility.js file itself.
echo Fix ie8-compatibility module console-polyfill version
for to in `find $WHERE -name ie8-compatibility.js`
do
	cp $SRC/hacks/ie8-compatibility.js $to
done

#FILES=`ls $JS/*.js`
#echo FIX $FILES
#perl -i -pne 's[({ \s* ) default: ][$1"default":]xmsg; s{\.(default|catch|for)\b}{["$1"]}xmsg' $FILES

# TODO:IE8 this hack fixup of URL's after build should really be corrected
# in the index.ejs file itself.
FILES=`ls $WHERE/*/index.html`
echo FIX base href in release build
echo $FILES
perl -i -pne '
	if (m{<!-- \s* CONTENTHASH: \s*(.*?) \s* -->\s*}xms) {
		$base = $1;
		#print qq{base: $base\n};
		s{<base[^>]+>}{}xmsg;
	}
	if ($base) {
		s{(src=")\./}{$1$base}xmsg; # && print $_;
		s{(href=")\./(css)}{$1$base$2}xmsg; # && print $_;
	}
	#$_ = "";
' $FILES

exit
# This fixup will allow you to disable certain CSS style properties to investigate which ones are messing up the IE8 render.
FILES=`ls $CSS/*.css`
echo FIX CSS
echo $FILES
perl -i -pne '
	sub allow_rule {
		my ($prop, $value, $semi) = @_;
		my $allow = $prop =~ m{\A\s(margin|padding|border|outline|overflow|background|font|-moz|-webkit)}xms  # begins with
		|| $prop =~ m{\A\s(width|height|color|clear|float|left|right|top|bottom|display|position|cursor|text-decoration|box-sizing|clip|content|text-rendering|text-transform|list-style-type|transition|src)\z}xms # exact match
		|| $prop =~ m{(width|height|align)\z}xms; # ends with
		$Disabled{$prop}++ unless $allow;
		return $allow;
	}

	# protect ; in data: urls
	#s/(url\(data[^;]+) ; ([^\)]+?) (\))/$1<SEMICOLON><DATA>$3/xmsg;
	s/(url\(data[^;]+) ; ([^\)]+?) (\))/$1<SEMICOLON>$2$3/xmsg;

	# standard spacing around { ; }
	s/(;)/$1\n   /xmsg;
	s/(\{)/ $1\n   /xmsg;
	s/(\})/\n$1\n/xmsg;

	# standard spacing around : rules
	s{
		(\s[\-a-z]+) : \s* ([^\{;\n]+) (;?) \n
	}{
		my ($prop, $value, $semi) = ($1, $2, $3);
		allow_rule($prop, $value, $semi)
		? qq{$prop: $value$semi\n}
		: qq{/* $prop: $value$semi */\n} }xmsgie;
	#s{(\s[\-a-z]+) : \s* ([^\{;\n]+) (;?) \n}{\n}xmsgi;

	# restore protected semicolons
	s{<SEMICOLON>}{;}xmsg;

	END {
		my $disabled = join(",", sort(keys(%Disabled)));
		print STDERR qq{CSS properties disabled: $disabled\n};
		use Data::Dumper;
		print STDERR Dumper(\%Disabled);
	}
' $FILES 2> css-disabled.lst

