#!/usr/bin/env perl
# Convert english translation file to a foreign language using Lorem Ipsum like text.
# preview a few lines...
# head -30 src/translations/en.json | __scripts__/lorem-ipsum-translations.pl
# __scripts__/lorem-ipsum-translations.pl src/translations/en.json > src/translations/ja.json

use utf8;         # so literals and identifiers can be in UTF-8
#use v5.12;      # or later to get "unicode_strings" feature
use v5.16;       # later version so we can use case folding fc() function directly
use strict;     # quote strings, declare variables
use warnings;  # on by default
#use warnings  qw(FATAL utf8);   # fatalize encoding glitches
use open          qw(:std :utf8);       # undeclared streams in UTF-8
#use charnames qw(:full :short);  # unneeded in v5.16
use Unicode::UCD qw( charinfo general_categories );  # to get category of character
use Unicode::Normalize qw(check); # to check normalisation
use Encode qw(decode_utf8); # to convert args/env vars
use Data::Dumper;

#my $chFullStop = ". ";
#my $chComma = ", ";
#my $chLQ = "“";
#my $chRQ = "”";

my $chFullStop = "。 ";
my $chComma = "、 ";
my $chLQ = "「";
my $chRQ = "」";

# Japanese
# Japanese punctuation: https://www.tofugu.com/japanese/japanese-punctuation/
# lorem generator: https://generator.lorem-ipsum.info/_japanese2
my $loremJA = qq(
根 樹 夜 根 屋 譜 留 氏 名 素 つ 無 目 せ 以 目 な は な 以 み ゃ ふ、ら あ 魔 そ ち 二 遊 サ オ ー タ エ ソ フ と っ た 瀬 派 樹 保 ぬ り す や あ な 以 野 く 露 そ へ む 手 雲 野 遊、以 野 雲 る へ 課 鵜 阿 保 野 離 「擢 日 雲 」ろ た ま 区 御 鵜 擢 も ゅ、に え き さ 露 素 課 手 っ 譜 瀬 遊 都 魔 課 ゃ ほ く 留、や 以 舳 知 へ と 野 屋 日 ウ ヒ ア ケ。
樹 阿 絵 雲 阿 え け 夜 日 派 く ん の 瀬 以 と 保 津 や ゃ い た り た ょ ぬ め。た 遊 差 ふ い し っ い 手 目 等 課 絵 御 氏 う ね た に オ ケ チ シ サ ゃ 手 素 名 絵 素 そ や こ 以 阿 ひ え く た 留 ク ヨ 二 都 野 ア ヨ シ ル 雲。知 つ て 尾 譜 野 な よ 譜 他 夜 素 ん は そ 保 氏 都。
や 離 る 模 都 譜 っ さ る つ め み く あ け ゅ ぬ て、ヨ ケ ナ ー ユ ス 素。こ 日 目 ょ 等 瀬 擢 鵜 ホ ヨ マ ー、野 名 よ ぬ っ そ ロ ス マ セ ム ハ 譜 擢 と ち や 巣 離 尾 保 列 二 野 き ほ お に ほ ち す え 以 知 巣 鵜 列 保 列 個 へ 列 根 根 無 課 日 派 み つ ゅ サ ン マ ハ ー に、た つ る し ふ も な 二 名 露 瀬 う 雲 巣 っ お も や っ れ さ 絵 個 目 差 露 ょ あ て ぬ、し こ り ほ あ え 露 課、オ エ ネ ロ ソ た れ メ メ ョ、手 離 御 知 区 露 氏 ム フ イ ウ せ に す ろ み の や 保 都 く っ つ ほ つ し な せ。
な く っ た や え さ 阿 区 絵 個 氏 絵 ら よ さ ね ひ の む け 舳 他 け り へ 津 擢 御 個 氏 こ れ 擢 舳 名 ち っ ほ も た ゅ あ さ 以 夜 ゅ お る や あ 尾 阿 め 雲 列 ち ま そ 野 差 魔。知 ょ ゅ 模 保。せ メ ラ ケ。や ぬ よ な へ れ っ ョ キ ユ エ ヌ い 知 個 る ち お ら う て、み む チ コ ト 御 差 氏 れ や、。す さ 雲 遊 巣 ふ。や や 擢 保。
ら そ さ め そ の ひ と 無 留 手 テ ス シ イ ヨ ハ イ フ、鵜 阿 み な や め っ 他 譜 巣 二 た ん 個 等 瀬 素 絵 津 っ お へ い ね へ 毛 手 他 日 魔 る み 列 雲 え や ゅ 派 模 御 課 尾 他 雲 屋 ミ チ へ 個 名 列 ゃ ゆ ふ へ。以 な 他 野 む イ ネ ウ ケ テ ー 派 以 て も も ほ え 離 二 ま へ し た ま け 阿 尾 知 譜 露 え れ く た て ょ な め ま う ぬ み よ し ゆ 保 遊 氏 氏 模 樹、根。 せ ま ぬ け へ は。や う 都 目 区 以 素 ね そ お る っ し み ひ え 譜 瀬 毛 っ。
ゆ 樹 都 き、根 目 樹 個 ら し し 課 保 目 手 舳 ネ セ ゅ つ。と 都 鵜 個 差 な か ひ あ や す ひ 遊 日 保 離 そ す み お 魔 や と み ひ く 尾 ゆ ゆ し 根 等 無 ほ い ほ ひ ね き 御 区 等 舳 い ち の れ 氏 素 氏。二 離 目、ク テ フ 露 留 手 手 れ ス ネ メ ニ ソ ヘ も あ ぬ。ら ひ そ や テ ネ ン ン 無 模、魔 遊 以 尾 雲 ヤ ウ ャ コ オ ュ 毛 ま ふ ゆ 素 離。
て ツ ト ウ ム モ ユ 尾 二 目 差 等。屋 樹 ゃ ー フ ニ ア コ ヘ セ ホ コ チ 野 る や に 遊 区 毛 二 課 等 氏 留 あ ゆ む オ ー ッ 尾 個 も 派 巣 無 個 離 毛 さ や 都 御 以 離 等 譜 毛 擢 巣 二 以、他 屋 ま っ 屋 派、む 列 御 野 阿 舳 の へ け ゅ ノ ヤ ウ レ オ ウ 「保 津 れ」ほ し り 野 樹 夜 樹 き こ ょ ほ ち の ね や み 夜 鵜 絵 と の 津 派 ち う な ょ し ふ の 魔 阿 ろ へ せ ら え ひ へ 屋 無 か に お な ゃ そ。模 雲 尾 鵜 鵜 個 都 樹 擢 な し た す え あ ゆ ハ ス テ レ は は す ち こ す な ぬ あ く 都 阿 タ セ イ ヘ ユ イ フ テ ン ヒ。
素 尾 保 ゆ す へ ナ ヌ テ ュ ケ ユ、ひ ち は せ み す ょ ら け 阿 知 露 都。名 模 か ゆ れ す う の 氏 た ま ゆ え ゆ 課。へ よ な ぬ へ ょ 樹 個 樹 樹 し 毛 譜 ケ メ シ ニ ソ い 鵜 ふ つ や 等 雲、ゆ あ、は ゅ 無 屋 目 留 手 舳 模 擢 差 屋 え っ み う ん 素 津 課 の せ は 等 根 譜 モ ヌ ノ チ ヘ 離 夜 こ つ ぬ あ つ、ニ キ ム キ 根 瀬 露 野 屋 毛 日 素 ん ゃ そ ょ 夜 露 保 は 都 手 雲 以、あ る 阿 遊 ロ ネ ス ル 派 毛 し く 遊 屋 け 二 無 名 お れ ょ き。
さ 手 無 他。り 都 阿 無 御 区 お り。日 み き 二 津 ろ 遊、二 樹 舳 テ ホ リ ヨ た 雲 手 素 離 素 御 へ え に い 露 露 ホ キ ニ セ ル タ ね ゆ る っ さ ょ く ま り る へ ひ 雲 御 つ 鵜 譜 舳 樹 知 個 差 等 区 ゆ 舳 課 屋 根 雲 リ サ ヘ と む み に と す 遊 二 模 無 御 遊 以 津 御 二 こ。保 擢 課 素 他 ね こ 阿 鵜 ノ キ テ て け む 模 野 留。ぬ め ら う ふ え と め ゆ お け か す ん の き た よ ユ フ ハ ナ カ フ ヒ の 氏 雲 夜 よ 巣 他 え メ ネ ョ コ ラ 鵜 擢 へ き た れ ま ぬ め に 阿 阿 ョ モ サ イ ル ヒ 氏 さ な て ふ。根 等 以 絵 ゅ ぬ ゅ み か む つ。
に ち り ち み ほ お む か ゅ む ラ フ ク ラ セ ゆ ょ 保 コ ユ ノ シ に け 差 目 う。以 巣 ら も め 根 都 す 阿 課 あ つ ね ぬ の あ ヤ ノ ハ さ そ、ん ち き ほ 差 手。ほ り に し た 都 派 留 ろ 名 津 と に み さ 舳。舳 阿 は 氏 と ん 樹 毛 知 む つ ノ ス チ セ エ 素 あ っ も い と ル ル ヨ う い 津 保 阿 た ゆ ら ろ す ね 絵 留 他、お ふ け け ヘ ヤ エ ネ モ ほ こ や 露 樹 区 津 ろ え れ か す す つ 手 魔 夜 他 鵜 二 課 留 っ こ ひ け ゅ む ま 差 せ き き。手 根 え。
);

# russian ?? https://www.loremipzum.com/ru/
# Ваш шедевр готов!
#Значимость этих проблем настолько очевидна что постоянный количественный рост и сфера нашей активности играет важную роль в формировании направлений прогрессивного развития. С другой стороны рамки и место обучения кадров позволяет оценить значение существенных финансовых и административных условий.
#Товарищи! дальнейшее развитие различных форм деятельности играет важную роль в формировании позиций занимаемых участниками в отношении поставленных задач. С другой стороны начало повседневной работы по формированию позиции позволяет оценить значение новых предложений. Разнообразный и богатый опыт сложившаяся структура организации обеспечивает широкому кругу специалистов участие в формировании систем массового участия. Товарищи! новая модель организационной деятельности в значительной степени обуславливает создание дальнейших направлений развития. Задача организации в особенности же укрепление и развитие структуры позволяет выполнять важные задания по разработке существенных финансовых и административных условий. Разнообразный и богатый опыт начало повседневной работы по формированию позиции способствует подготовки и реализации новых предложений.
#Товарищи!
my $loremRU = join(" ", qw(
Ваш шедевр готов
Значимость этих проблем настолько очевидна что постоянный количественный рост и сфера нашей активности играет важную роль в формировании направлений прогрессивного развития С другой стороны рамки и место обучения кадров позволяет оценить значение существенных финансовых и административных условий

Товарищи! дальнейшее развитие различных форм деятельности играет важную роль в формировании позиций занимаемых участниками в отношении поставленных задач С другой стороны начало повседневной работы по формированию позиции позволяет оценить значение новых предложений Разнообразный и богатый опыт сложившаяся структура организации обеспечивает широкому кругу специалистов участие в формировании систем массового участия Товарищи! новая модель организационной деятельности в значительной степени обуславливает создание дальнейших направлений развития Задача организации в особенности же укрепление и развитие структуры позволяет выполнять важные задания по разработке существенных финансовых и административных условий Разнообразный и богатый опыт начало повседневной работы по формированию позиции способствует подготовки и реализации новых предложений
));
my $loremAR = join(" ", qw(
لكن لا بد أن أوضح لك أن كل هذه الأفكار المغلوطة حول استنكار  النشوة وتمجيد الألم نشأت بالفعل، وسأعرض لك التفاصيل لتكتشف حقيقة وأساس تلك السعادة البشرية، فلا أحد يرفض أو يكره أو يتجنب الشعور بالسعادة، ولكن بفضل هؤلاء الأشخاص الذين لا يدركون بأن السعادة لا بد أن نستشعرها بصورة أكثر عقلانية ومنطقية فيعرضهم هذا لمواجهة الظروف الأليمة، وأكرر بأنه لا يوجد من يرغب في الحب ونيل المنال ويتلذذ بالآلام، الألم هو الألم ولكن نتيجة لظروف ما قد تكمن السعاده فيما نتحمله من كد وأسي.

و سأعرض مثال حي لهذا، من منا لم يتحمل جهد بدني شاق إلا من أجل الحصول على ميزة أو فائدة؟ ولكن من لديه الحق أن ينتقد شخص ما أراد أن يشعر بالسعادة التي لا تشوبها عواقب أليمة أو آخر أراد أن يتجنب الألم الذي ربما تنجم عنه بعض المتعة ؟
علي الجانب الآخر نشجب ونستنكر هؤلاء الرجال المفتونون بنشوة اللحظة الهائمون في رغباتهم فلا يدركون ما يعقبها من الألم والأسي المحتم، واللوم كذلك يشمل هؤلاء الذين أخفقوا في واجباتهم نتيجة لضعف إرادتهم فيتساوي مع هؤلاء الذين يتجنبون وينأون عن تحمل الكدح والألم .
));
# https://lipsum.com/
my $loremEN = join(" ", qw(Lorem ipsum dolor sit amet consectetur adipiscing elit Aenean efficitur leo ac ipsum feugiat non luctus nisl porta Duis quis erat nec risus hendrerit tincidunt at vel mi Mauris gravida ligula euismod sollicitudin rhoncus diam velit cursus tortor quis cursus urna magna eget est Aenean semper orci feugiat sem tincidunt convallis Mauris turpis ante consequat eget orci id facilisis ultricies risus Ut vel viverra neque eget pharetra felis Interdum et malesuada fames ac ante ipsum primis in faucibus Nam elementum tempus neque accumsan fringilla

Suspendisse ut ullamcorper libero sed sodales ligula Fusce dui nibh efficitur eu lacinia vel dapibus vel leo Interdum et malesuada fames ac ante ipsum primis in faucibus Proin a turpis dolor Aliquam tempor a nunc sit amet laoreet Lorem ipsum dolor sit amet consectetur adipiscing elit Praesent mattis felis ac est facilisis sed dignissim lorem maximus In hac habitasse platea dictumst Fusce laoreet ac tellus vel consequat Suspendisse et convallis lacus Morbi rutrum massa et neque faucibus porta

Quisque tempor tristique felis at blandit Quisque vehicula sapien sed ultricies auctor est mauris tempus tortor eu aliquet velit purus eu ipsum Vivamus ac scelerisque mauris Proin pretium viverra nisl sollicitudin elementum Sed faucibus pharetra purus ut commodo mi pretium sed Sed lacus quam efficitur ut nisl non venenatis porta diam Vivamus congue ex elit et suscipit nisl pretium nec Interdum et malesuada fames ac ante ipsum primis in faucibus Morbi arcu diam molestie ac velit a luctus egestas arcu Aenean tristique efficitur neque a varius odio auctor ut Fusce sodales mauris eros ac elementum ipsum congue ac Pellentesque venenatis eget orci at elementum Nullam bibendum mollis odio at sollicitudin Aliquam gravida quam in ligula convallis rhoncus auctor neque volutpat Ut vel lorem ac elit venenatis sagittis non et sem

Mauris dolor mauris convallis sollicitudin urna luctus semper dignissim diam Nullam placerat dolor ac velit ultricies ac mattis lacus cursus Donec sagittis finibus diam et elementum Integer quis sollicitudin mi Proin ac risus quis elit lobortis sollicitudin Ut vel bibendum enim Morbi rhoncus mattis lacus eget porttitor eros volutpat vitae Vivamus aliquet congue semper Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia curae; Nulla neque justo euismod at velit id dapibus hendrerit ante Nulla facilisi

Sed ornare sem odio ac euismod ipsum pretium at Sed vehicula nisi eget ornare commodo Proin aliquet quis velit in varius Nulla nec euismod lectus Etiam eu vestibulum nibh et pretium nulla Duis eget laoreet felis In consequat lectus vel aliquam dapibus lacus quam fringilla risus sit amet sodales mi magna et dolor
));
# ukrainian https://generator.lorem-ipsum.info/_russian
my $loremUK = join(" ", qw(Лорем ипсум долор сит амет ад граецо еффициантур дефинитионем иус Еам алияуид патриояуе ет Яуо ин хинц тота долоре ан оффендит нолуиссе интеллегам вис Ид иус путант фиерент оффициис

Вис лорем цетерос легендос ин Еу дицит веритус фацилиси вел ет оратио малуиссет нец Те омнес тритани нолуиссе сед меа не толлит цонсулату Нец алтера сусципит ат цонсул феугиат вис ад Еам ессе дицта ат те дицам поссит цум Иус цивибус ехпетендис интеллегебат еи ат цум инермис елояуентиам не сед доцтус антиопам Те персиус витуперата вих путант омиттам деленити вел еа
));

my $lorem = $loremJA;

my @ArabicWords = split(/\s+/, $lorem);
my $count = scalar(@ArabicWords);

my $word_index = 0;

my $reSpecials = qr{(\\u.{4}|&[a-z]+;|%[a-z0-9.]+%|</?[a-z0-9]+>|\{[a-z0-9]+\})}xmsi;

sub substitute
{
	my ($match) = @_;
	#return $match;
	my $word = $ArabicWords[$word_index];
	$word =~ s{[。、「」]+}{}xmsg; # Japanese, remove punctuation

	$word_index = (1 + $word_index) % $count;
	#return $word;
	return "$word/EOW/"; # Japanese delete space between words each char is a word
}

sub encode_specials
{
	my ($match) = @_;
	my @chars = split(/\s*/, $match);
	my $result = join("", map { '#' . ord($_) } @chars);
	#print STDERR "ERR [$match]\n";
	#print STDERR Dumper(\@chars);
	#die "STOP $result " . decode_specials($result) ;
	return $result;
}

sub decode_specials
{
	my ($match) = @_;
	$match =~ s{\#(\d+)}{chr($1)}xmsge;
	return $match;
}

sub replace
{
	my ($text) = @_;
	#$word_index = 0;
	return $text if $text =~ m{\Ahttp}xms;
	$text =~ s{'}{}xmsg;
	$text =~ s{\\"(.+?)\\"}{$chLQ$1$chRQ}xmsg;
	$text =~ s{([a-z])\.\s}{$1$chFullStop}xmsg; # Japanese convert full stop
	$text =~ s{([a-z]),\s}{$1$chComma}xmsg; # Japanese convert comma
	$text =~ s{$reSpecials}{encode_specials($1)}xmsgie;
	$text =~ s{([a-z]+)}{substitute($1)}xmsgei;
	$text =~ s{/EOW/\s*}{}xmsg; # Japanse delete spaces trailing words
#	return $lorem;
	return decode_specials($text);
}

while (my $line = <>)
{
	$line =~ s{(:\s*")(.+)(")(,|\n)}{$1 . replace($2) . $3 . $4}xmsge;
	print $line;
}
