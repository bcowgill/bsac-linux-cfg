#!/bin/bash
# Convert an expression in English words to the corresponding numerical value.
# i.e. echo three billion and twenty-two million and five hundred thousand and eighteen gross | words-to-number.sh
ARG="$1" perl -MData::Dumper -pne '
	%val = qw{
		one 1 two 2 three 3 four 4 five 5 six 6 seven 7 eight 8 nine 9 ten 10 eleven 11 twelve 12 thirteen 13 fourteen 14 fifteen 15 sixteen 16 seventeen 17 eighteen 18 nineteen 19 twenty 20 thirty 30 forty 40 fifty 50 sixty 60 seventy 70 eighty 80 ninety 90 trillion *1e12 billion *1e9 million *1e6 thousand *1000 hundred *100 tens *10 score *20 dozen *12 gross *144 century *100 decade *10 pair *2
		couple *2 trio *3 quartet *4 myriad *10000 grand *1000 duo *2 and + plus + minus - less - subtract - times * zero 0 over / half /2 halves /2 third /3 thirds /3 quarter /4 quarters /4 fourth /4 fourths /4 fifth /5 fifths /5 sixth /6 sixths /6 seventh /7 sevenths /7 eighth /8 eighths /8 ninth /9 ninths /9 tenth /10 tenths /10 eleventh /11 elevenths /11 twelfth /12 twelfths /12 thirteenth /13 thirteenths /13 fourteenth /14 fourteenths /14 fifteenth /15 fifteenths /15
		sixteenth /16 sixteenths /16 seventeenth /17 seventeenths /17 eighteenth /18 eighteenths /18 nineteenth /19 nineteenths /19 twentieth /20 twentieths /20 thirtieth /30 thirtieths /30 fortieth /40 fortieths /40 fiftieth /50 fiftieths /50 sixtieth /60 sixtieths /60 seventieth /70 seventieths /70 eightieth /80 eightieths /80 ninetieth /90 ninetieths /90 hundredth /100 hundredths /100
	};

	if ($ENV{ARG} eq "--dump") {
		print Dumper(\%val);
		exit 0;
	};

	s{([a-z]+)-([a-z]+)}{($1+$2)}xmsgi;
	s{\b([a-z]+)\b}{$val{lc($1)} || $1}xmsgie;
	$_ = eval($_);
	$_ = join("",reverse(split(//)));
	s{(\d\d\d)}{$1,}xmsg;
	s{,\z}{}xms;
	$_ = join("",reverse(split(//)));
	$_="$_\n";
'
