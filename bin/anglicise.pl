#!/usr/bin/env perl
# anglicise letters with accents and such
# WINDEV tool useful on windows development machine

# 'seamless' unicode support
use 5.012;
use FindBin;
#use feature "unicode_strings";

sub usage
{
	print <<"USAGE";
$FindBin::Script

Filter standard input anglicising any foreign alphabet characters and numbers.

USAGE
	exit 0;
}

my $ECHO = ""; # or inline, line

# replace accented characters with plain a-z
my %R = (
	# 'utf8ls-letter.sh L' used to generate:
	a => [qw( à á â ã ä å ā ă ą ǎ ǟ ǡ ǻ ȁ ȃ ȧ ͣ а ӑ ӓ ᶏ ḁ ẚ ạ ả ấ ầ ẩ ẫ ậ ắ ằ ẳ ẵ ặ ₐ ⒜ ⓐ ⱥ ａ 󠁡 )],

	A => [qw( À Á Â Ã Ä Å Ā Ă Ą Ǎ Ǟ Ǡ Ǻ Ȁ Ȃ Ȧ Ⱥ А Ӑ Ӓ Ḁ Ạ Ả Ấ Ầ Ẩ Ẫ Ậ Ắ Ằ Ẳ Ẵ Ặ Ⓐ Ａ 🄐 🄰 🅐 🅰 󠁁 )],

	b => [qw( ƀ ƃ ɓ ᵬ ᶀ ḃ ḅ ḇ ⒝ ⓑ ｂ 󠁢 )],

	B => [qw( Ɓ Ƃ Ƀ Ḃ Ḅ Ḇ Ⓑ Ｂ 🄑 🄱 🅑 🅱 󠁂 )],

	c => [qw( ç ć ĉ ċ č ƈ ȼ ɕ ͨ ᷗ ḉ ⒞ ⓒ ꞓ ｃ 󠁣 )],

	C => [qw( Ç Ć Ĉ Ċ Č Ƈ Ȼ Ḉ Ⓒ Ꞓ Ｃ 🄒 🄫 🄲 🅒 🅲 󠁃 )],

	d => [qw( ď đ ƌ ȡ ɖ ɗ ͩ ᵭ ᶁ ᶑ ḋ ḍ ḏ ḑ ḓ ⒟ ⓓ ｄ 󠁤 )],

	D => [qw( Ď Đ Ɗ Ƌ ǅ ǲ Ḋ Ḍ Ḏ Ḑ Ḓ Ⓓ Ｄ 🄓 🄳 🅓 🅳 󠁄 )],

	e => [qw( è é ê ë ē ĕ ė ę ě ȅ ȇ ȩ ɇ ͤ э ӭ ᶒ ḕ ḗ ḙ ḛ ḝ ẹ ẻ ẽ ế ề ể ễ ệ ₑ ⒠ ⓔ ⱸ ｅ 󠁥 )],

	E => [qw( È É Ê Ë Ē Ĕ Ė Ę Ě Ȅ Ȇ Ȩ Ɇ Э Ӭ Ḕ Ḗ Ḙ Ḛ Ḝ Ẹ Ẻ Ẽ Ế Ề Ể Ễ Ệ Ⓔ Ｅ 🄔 🄴 🅔 🅴 󠁅 )],

	f => [qw( ƒ ᵮ ᶂ ḟ ⒡ ⓕ ｆ 󠁦 )],

	F => [qw( Ƒ Ḟ Ⓕ Ｆ 🄕 🄵 🅕 🅵 󠁆 )],

	g => [qw( ĝ ğ ġ ģ ǥ ǧ ǵ ɠ ᶃ ᷚ ḡ ⒢ ⓖ ꞡ ｇ 󠁧 )],

	G => [qw( Ĝ Ğ Ġ Ģ Ɠ Ǥ Ǧ Ǵ Ḡ Ⓖ Ꞡ Ｇ 🄖 🄶 🅖 🅶 󠁇 )],

	h => [qw( ĥ ħ ȟ ɦ ͪ ḣ ḥ ḧ ḩ ḫ ẖ ₕ ⒣ ⓗ ⱨ ｈ 𐐸 󠁨 )],

	H => [qw( Ĥ Ħ Ȟ Ḣ Ḥ Ḧ Ḩ Ḫ Ⓗ Ⱨ Ɦ Ｈ 𐐐 🄗 🄷 🅗 🅷 󠁈 )],

	i => [qw( ì í î ï ĩ ī ĭ į ǐ ȉ ȋ ɨ ͥ и ѝ ӣ ӥ ᵢ ᶖ ḭ ḯ ỉ ị ⁱ ⒤ ⓘ ⰻ ｉ 󠁩 )],

	I => [qw( Ì Í Î Ï Ĩ Ī Ĭ Į İ Ɨ Ǐ Ȉ Ȋ Ѝ И Ӣ Ӥ ᵻ Ḭ Ḯ Ỉ Ị Ⓘ Ⰻ Ｉ 🄘 🄸 🅘 🅸 󠁉 )],

	j => [qw( ĵ ǈ ǋ ǰ ɉ ʝ ⒥ ⓙ ⱼ ｊ 󠁪 )],

	J => [qw( Ĵ Ɉ Ⓙ Ｊ 🄙 🄹 🅙 🅹 󠁊 )],

	k => [qw( ķ ƙ ǩ ᶄ ᷜ ḱ ḳ ḵ ₖ ⒦ ⓚ ⱪ ꝁ ꝃ ꝅ ꞣ ｋ 󠁫 )],

	K => [qw( Ķ Ƙ Ǩ Ḱ Ḳ Ḵ Ⓚ Ⱪ Ꝁ Ꝃ Ꝅ Ꞣ Ｋ 🄚 🄺 🅚 🅺 󠁋 )],

	l => [qw( ĺ ļ ľ ŀ ł ƚ ȴ ɫ ɬ ɭ ᶅ ᷝ ḷ ḹ ḻ ḽ ₗ ⒧ ⓛ ⱡ ⳑ ꝉ ꞎ ｌ 󠁬 )],

	L => [qw( Ĺ Ļ Ľ Ŀ Ł ǈ Ƚ Ḷ Ḹ Ḻ Ḽ Ⓛ Ⱡ Ɫ Ⳑ Ꝉ Ｌ 🄛 🄻 🅛 🅻 󠁌 )],

	m => [qw( ɱ ͫ ᵯ ᶆ ḿ ṁ ṃ ₘ ⒨ ⓜ ｍ 󠁭 )],

	M => [qw( Ḿ Ṁ Ṃ Ⓜ Ɱ Ｍ 🄜 🄼 🅜 🅼 󠁍 )],

	n => [qw( ñ ń ņ ň ŉ ƞ ǹ ȵ ɲ ɳ ᵰ ᶇ ᷠ ṅ ṇ ṉ ṋ ⁿ ₙ ⒩ ⓝ ꞑ ꞥ ｎ 󠁮 )],

	N => [qw( Ñ Ń Ņ Ň Ɲ ǋ Ǹ Ƞ Ṅ Ṇ Ṉ Ṋ Ⓝ Ꞑ Ꞥ Ｎ 🄝 🄽 🅝 🅽 󠁎 )],

	o => [qw( ò ó ô õ ö ø ō ŏ ő ơ ǒ ǫ ǭ ǿ ȍ ȏ ȫ ȭ ȯ ȱ ͦ о ӧ ṍ ṏ ṑ ṓ ọ ỏ ố ồ ổ ỗ ộ ớ ờ ở ỡ ợ ₒ ⒪ ⓞ ⱺ ⲟ ꝋ ꝍ ｏ 󠁯 )],

	O => [qw( Ò Ó Ô Õ Ö Ø Ō Ŏ Ő Ɵ Ơ Ǒ Ǫ Ǭ Ǿ Ȍ Ȏ Ȫ Ȭ Ȯ Ȱ О Ӧ Ṍ Ṏ Ṑ Ṓ Ọ Ỏ Ố Ồ Ổ Ỗ Ộ Ớ Ờ Ở Ỡ Ợ Ⓞ Ⲟ Ꝋ Ꝍ Ｏ 🄞 🄾 🅞 🅾 󠁏 )],

	p => [qw( ƥ ᵱ ᵽ ᶈ ṕ ṗ ₚ ⒫ ⓟ ꝑ ꝓ ꝕ ｐ 󠁰 )],

	P => [qw( Ƥ Ṕ Ṗ Ⓟ Ᵽ Ꝑ Ꝓ Ꝕ Ｐ 🄟 🄿 🅟 🅿 🆊 󠁐 )],

	q => [qw( ɋ ʠ ⒬ ⓠ ꝗ ꝙ ｑ 󠁱 )],

	Q => [qw( Ⓠ Ꝗ Ꝙ Ｑ 🄠 🅀 🅠 🆀 󠁑 )],

	r => [qw( ŕ ŗ ř ȑ ȓ ɍ ɼ ɽ ɾ ͬ ᵣ ᵲ ᵳ ᶉ ᷊ ᷣ ṙ ṛ ṝ ṟ ⒭ ⓡ ꝛ ꞧ ｒ 󠁲 )],

	R => [qw( Ŕ Ŗ Ř Ȑ Ȓ Ɍ Ṙ Ṛ Ṝ Ṟ Ⓡ Ɽ Ꝛ Ꞧ Ｒ 🄡 🄬 🅁 🅡 🆁 󠁒 )],

	s => [qw( ś ŝ ş š ș ȿ ʂ ᵴ ᶊ ᷤ ṡ ṣ ṥ ṧ ṩ ₛ ⒮ ⓢ ꞩ ｓ 󠁳 )],

	S => [qw( Ś Ŝ Ş Š Ș Ṡ Ṣ Ṥ Ṧ Ṩ Ⓢ Ȿ Ꞩ Ｓ 🄢 🄪 🅂 🅢 🆂 󠁓 )],

	t => [qw( ţ ť ŧ ƫ ƭ ț ȶ ʈ ͭ ᵵ ṫ ṭ ṯ ṱ ẗ ₜ ⒯ ⓣ ⱦ ｔ 󠁴 )],

	T => [qw( Ţ Ť Ŧ Ƭ Ʈ Ț Ⱦ Ṫ Ṭ Ṯ Ṱ Ⓣ Ｔ 🄣 🅃 🅣 🆃 󠁔 )],

	u => [qw( ù ú û ü ũ ū ŭ ů ű ų ư ǔ ǖ ǘ ǚ ǜ ȕ ȗ ʉ ͧ у ӯ ӱ ӳ ᵤ ᶙ ṳ ṵ ṷ ṹ ṻ ụ ủ ứ ừ ử ữ ự ⒰ ⓤ ｕ 󠁵 )],

	U => [qw( Ù Ú Û Ü Ũ Ū Ŭ Ů Ű Ų Ư Ǔ Ǖ Ǘ Ǚ Ǜ Ȕ Ȗ Ʉ У Ӯ Ӱ Ӳ ᵾ Ṳ Ṵ Ṷ Ṹ Ṻ Ụ Ủ Ứ Ừ Ử Ữ Ự Ⓤ Ｕ 🄤 🅄 🅤 🆄 󠁕 )],

	v => [qw( ʋ ͮ ᵥ ᶌ ṽ ṿ ⒱ ⓥ ⱱ ⱴ ꝟ ｖ 󠁶 )],

	V => [qw( Ʋ Ṽ Ṿ Ⓥ Ꝟ Ｖ 🄥 🅅 🅥 🆅 󠁖 )],

	w => [qw( ŵ ẁ ẃ ẅ ẇ ẉ ẘ ⒲ ⓦ ⱳ ｗ 󠁷 )],

	W => [qw( Ŵ Ẁ Ẃ Ẅ Ẇ Ẉ Ⓦ Ⱳ Ｗ 🄦 🅆 🅦 🆆 󠁗 )],

	x => [qw( ᶍ ẋ ẍ ₓ ⒳ ⓧ ｘ 󠁸 )],

	X => [qw( Ẋ Ẍ Ⓧ Ｘ 🄧 🅇 🅧 🆇 󠁘 )],

	y => [qw( ý ÿ ŷ ƴ ȳ ɏ ẏ ẙ ỳ ỵ ỷ ỹ ỿ ⒴ ⓨ ｙ 󠁹 )],

	Y => [qw( Ý Ŷ Ÿ Ƴ Ȳ Ɏ Ẏ Ỳ Ỵ Ỷ Ỹ Ỿ Ⓨ Ｙ 🄨 🅈 🅨 🆈 󠁙 )],

	z => [qw( ź ż ž ƶ ǅ ǲ ȥ ɀ ʐ ʑ ᵶ ᶎ ᷦ ẑ ẓ ẕ ⒵ ⓩ ⱬ ｚ 󠁺 )],

	Z => [qw( Ź Ż Ž Ƶ Ȥ Ẑ Ẓ Ẕ Ⓩ Ⱬ Ɀ Ｚ 🄩 🅉 🅩 🆉 󠁚 )],

	0 => [qw( ٠ ۰ ߀ ० ০ ੦ ૦ ୦ ௦ ౦ ೦ ൦ ๐ ໐ ༠ ၀ ႐ ០ ᠐ ᥆ ᧐ ᪀ ᪐ ᭐ ᮰ ᱀ ᱐ ⓪ ⓿ 〇 ꘠ ꣐ ꣠ ꤀ ꧐ ꩐ ꯰ ０ 𐒠 𑁦 𑃰 𑄶 𑇐 𑛀 𝟎 𝟘 𝟢 𝟬 𝟶 󠀰 )],

	1 => [qw( ١ ۱ ߁ १ ১ ੧ ૧ ୧ ௧ ౧ ೧ ൧ ๑ ໑ ༡ ၁ ႑ ፩ ១ ᠑ ᥇ ᧑ ᧚ ᪁ ᪑ ᭑ ᮱ ᱁ ᱑ ① ⑴ ⓵ ❶ ➀ ➊ ꘡ ꣑ ꣡ ꤁ ꧑ ꩑ ꯱ １ 𐄇 𐏑 𐒡 𐡘 𐤖 𐩀 𐩽 𐭘 𐭸 𐹠 𑁒 𑁧 𑃱 𑄷 𑇑 𑛁 𝍠 𝍩 𝟏 𝟙 𝟣 𝟭 𝟷 󠀱 )],

	2 => [qw( ٢ ۲ ݳ ݵ ݸ ݺ ߂ २ ২ ੨ ૨ ୨ ௨ ౨ ೨ ൨ ๒ ໒ ༢ ၂ ႒ ፪ ២ ᠒ ᥈ ᧒ ᪂ ᪒ ᭒ ᮲ ᱂ ᱒ ② ⑵ ⓶ ❷ ➁ ➋ ꘢ ꣒ ꣢ ꤂ ꧒ ꩒ ꯲ ２ 𐄈 𐏒 𐒢 𐡙 𐤚 𐩁 𐭙 𐭹 𐹡 𑁓 𑁨 𑃲 𑄸 𑇒 𑛂 𝍡 𝍪 𝟐 𝟚 𝟤 𝟮 𝟸 󠀲 )],

	3 => [qw( ٣ ۳ ݴ ݶ ݹ ݻ ߃ ३ ৩ ੩ ૩ ୩ ௩ ౩ ೩ ൩ ๓ ໓ ༣ ၃ ႓ ፫ ៣ ᠓ ᥉ ᧓ ᪃ ᪓ ᭓ ᮳ ᱃ ᱓ ③ ⑶ ⓷ ❸ ➂ ➌ ꘣ ꣓ ꣣ ꤃ ꧓ ꩓ ꯳ ３ 𐄉 𐒣 𐡚 𐤛 𐩂 𐭚 𐭺 𐹢 𑁔 𑁩 𑃳 𑄹 𑇓 𑛃 𝍢 𝍫 𝟑 𝟛 𝟥 𝟯 𝟹 󠀳 )],

	4 => [qw( ٤ ۴ ݷ ݼ ݽ ߄ ४ ৪ ੪ ૪ ୪ ௪ ౪ ೪ ൪ ๔ ໔ ༤ ၄ ႔ ፬ ៤ ᠔ ᥊ ᧔ ᪄ ᪔ ᭔ ᮴ ᱄ ᱔ ④ ⑷ ⓸ ❹ ➃ ➍ ꘤ ꣔ ꣤ ꤄ ꧔ ꩔ ꯴ ４ 𐄊 𐒤 𐩃 𐭛 𐭻 𐹣 𑁕 𑁪 𑃴 𑄺 𑇔 𑛄 𝍣 𝍬 𝟒 𝟜 𝟦 𝟰 𝟺 󠀴 )],

	5 => [qw( ٥ ۵ ߅ ५ ৫ ੫ ૫ ୫ ௫ ౫ ೫ ൫ ๕ ໕ ༥ ၅ ႕ ፭ ៥ ᠕ ᥋ ᧕ ᪅ ᪕ ᭕ ᮵ ᱅ ᱕ ⑤ ⑸ ⓹ ❺ ➄ ➎ ꘥ ꣕ ꣥ ꤅ ꧕ ꩕ ꯵ ５ 𐄋 𐒥 𐹤 𑁖 𑁫 𑃵 𑄻 𑇕 𑛅 𝍤 𝍭 𝟓 𝟝 𝟧 𝟱 𝟻 󠀵 )],

	6 => [qw( ٦ ۶ ߆ ६ ৬ ੬ ૬ ୬ ௬ ౬ ೬ ൬ ๖ ໖ ༦ ၆ ႖ ፮ ៦ ᠖ ᥌ ᧖ ᪆ ᪖ ᭖ ᮶ ᱆ ᱖ ⑥ ⑹ ⓺ ❻ ➅ ➏ ꘦ ꣖ ꣦ ꤆ ꧖ ꩖ ꯶ ６ 𐄌 𐒦 𐹥 𑁗 𑁬 𑃶 𑄼 𑇖 𑛆 𝍥 𝍮 𝟔 𝟞 𝟨 𝟲 𝟼 󠀶 )],

	7 => [qw( ٧ ۷ ߇ ७ ৭ ੭ ૭ ୭ ௭ ౭ ೭ ൭ ๗ ໗ ༧ ၇ ႗ ፯ ៧ ᠗ ᥍ ᧗ ᪇ ᪗ ᭗ ᮷ ᱇ ᱗ ⑦ ⑺ ⓻ ❼ ➆ ➐ ꘧ ꣗ ꣧ ꤇ ꧗ ꩗ ꯷ ７ 𐄍 𐒧 𐹦 𑁘 𑁭 𑃷 𑄽 𑇗 𑛇 𝍦 𝍯 𝟕 𝟟 𝟩 𝟳 𝟽 󠀷 )],

	8 => [qw( ٨ ۸ ߈ ८ ৮ ੮ ૮ ୮ ௮ ౮ ೮ ൮ ๘ ໘ ༨ ၈ ႘ ፰ ៨ ᠘ ᥎ ᧘ ᪈ ᪘ ᭘ ᮸ ᱈ ᱘ ⑧ ⑻ ⓼ ❽ ➇ ➑ ꘨ ꣘ ꣨ ꤈ ꧘ ꩘ ꯸ ８ 𐄎 𐒨 𐹧 𑁙 𑁮 𑃸 𑄾 𑇘 𑛈 𝍧 𝍰 𝟖 𝟠 𝟪 𝟴 𝟾 󠀸 )],

	9 => [qw( ٩ ۹ ߉ ९ ৯ ੯ ૯ ୯ ௯ ౯ ೯ ൯ ๙ ໙ ༩ ၉ ႙ ፱ ៩ ᠙ ᥏ ᧙ ᪉ ᪙ ᭙ ᮹ ᱉ ᱙ ⑨ ⑼ ⓽ ❾ ➈ ➒ ꘩ ꣙ ꣩ ꤉ ꧙ ꩙ ꯹ ９ 𐄏 𐒩 𐹨 𑁚 𑁯 𑃹 𑄿 𑇙 𑛉 𝍨 𝍱 𝟗 𝟡 𝟫 𝟵 𝟿 󠀹 )],
);

if (grep { m{\A(--help|-\?)\z}xms } @ARGV) {
	usage();
}

while (my $line = <>)
{
	chomp($line);
	my $original = $line;

	foreach my $letter (keys(%R))
	{
		foreach my $find (@{$R{$letter}})
		{
			$line =~ s{$find}{$letter}xmsg;
		}
	}
	#tr{A-Z}{a-z};
	if ($ECHO eq "inline")
	{
		$line = "$original\t$line";
	}
	elsif ($ECHO eq "line")
	{
		$line = "$original\n$line";
	}
	print "$line\n";
}

__END__
# simple list from manual examination of 'english' word lists
	a => [qw( á â ä å â )],
	A => [qw( Á Â Å Â )],
	e => [qw( è é ê )],
	E => [qw( Ë )],
	i => [qw( í )],
	I => [qw( Ì Í )],
	o => [qw( ó ô ö )],
	O => [qw( Ò Ó Ô )],
	u => [qw( û ü )],
	U => [qw( Ù Û )],
	c => [qw( ç )],
	n => [qw( ñ )],

# 'utf8ls-letter.sh L with' used to generate:
	a => [qw( à á â ã ä å ā ă ą ǎ ǟ ǡ ǻ ȁ ȃ ȧ ӑ ӓ ᶏ ḁ ẚ ạ ả ấ ầ ẩ ẫ ậ ắ ằ ẳ ẵ ặ ⱥ )],
	A => [qw( À Á Â Ã Ä Å Ā Ă Ą Ǎ Ǟ Ǡ Ǻ Ȁ Ȃ Ȧ Ⱥ Ӑ Ӓ Ḁ Ạ Ả Ấ Ầ Ẩ Ẫ Ậ Ắ Ằ Ẳ Ẵ Ặ )],
	b => [qw( ƀ ƃ ɓ ᵬ ᶀ ḃ ḅ ḇ )],
	B => [qw( Ɓ Ƃ Ƀ Ḃ Ḅ Ḇ )],
	c => [qw( ç ć ĉ ċ č ƈ ȼ ɕ ḉ ꞓ )],
	C => [qw( Ç Ć Ĉ Ċ Č Ƈ Ȼ Ḉ Ꞓ )],
	d => [qw( ď đ ƌ ȡ ɖ ɗ ᵭ ᶁ ᶑ ḋ ḍ ḏ ḑ ḓ )],
	D => [qw( Ď Đ Ɗ Ƌ ǅ ǲ Ḋ Ḍ Ḏ Ḑ Ḓ )],
	e => [qw( è é ê ë ē ĕ ė ę ě ȅ ȇ ȩ ɇ ӭ ᶒ ḕ ḗ ḙ ḛ ḝ ẹ ẻ ẽ ế ề ể ễ ệ ⱸ )],
	E => [qw( È É Ê Ë Ē Ĕ Ė Ę Ě Ȅ Ȇ Ȩ Ɇ Ӭ Ḕ Ḗ Ḙ Ḛ Ḝ Ẹ Ẻ Ẽ Ế Ề Ể Ễ Ệ )],
	f => [qw( ƒ ᵮ ᶂ ḟ )],
	F => [qw( Ƒ Ḟ )],
	g => [qw( ĝ ğ ġ ģ ǥ ǧ ǵ ɠ ᶃ ḡ ꞡ )],
	G => [qw( Ĝ Ğ Ġ Ģ Ɠ Ǥ Ǧ Ǵ Ḡ Ꞡ )],
	h => [qw( ĥ ħ ȟ ɦ ḣ ḥ ḧ ḩ ḫ ẖ ⱨ )],
	H => [qw( Ĥ Ħ Ȟ Ḣ Ḥ Ḧ Ḩ Ḫ Ⱨ Ɦ )],
	i => [qw( ì í î ï ĩ ī ĭ į ǐ ȉ ȋ ɨ ѝ ӣ ӥ ᶖ ḭ ḯ ỉ ị )],
	I => [qw( Ì Í Î Ï Ĩ Ī Ĭ Į İ Ɨ Ǐ Ȉ Ȋ Ѝ Ӣ Ӥ ᵻ Ḭ Ḯ Ỉ Ị )],
	j => [qw( ĵ ǰ ɉ ʝ )],
	J => [qw( Ĵ Ɉ )],
	k => [qw( ķ ƙ ǩ ᶄ ḱ ḳ ḵ ⱪ ꝁ ꝃ ꝅ ꞣ )],
	K => [qw( Ķ Ƙ Ǩ Ḱ Ḳ Ḵ Ⱪ Ꝁ Ꝃ Ꝅ Ꞣ )],
	l => [qw( ĺ ļ ľ ŀ ł ƚ ȴ ɫ ɬ ɭ ᶅ ḷ ḹ ḻ ḽ ⱡ ꝉ ꞎ )],
	L => [qw( Ĺ Ļ Ľ Ŀ Ł ǈ Ƚ Ḷ Ḹ Ḻ Ḽ Ⱡ Ɫ Ꝉ )],
	m => [qw( ɱ ᵯ ᶆ ḿ ṁ ṃ )],
	M => [qw( Ḿ Ṁ Ṃ Ɱ )],
	n => [qw( ñ ń ņ ň ƞ ǹ ȵ ɲ ɳ ᵰ ᶇ ṅ ṇ ṉ ṋ ꞑ ꞥ )],
	N => [qw( Ñ Ń Ņ Ň Ɲ ǋ Ǹ Ƞ Ṅ Ṇ Ṉ Ṋ Ꞑ Ꞥ )],
	o => [qw( ò ó ô õ ö ø ō ŏ ő ơ ǒ ǫ ǭ ǿ ȍ ȏ ȫ ȭ ȯ ȱ ӧ ṍ ṏ ṑ ṓ ọ ỏ ố ồ ổ ỗ ộ ớ ờ ở ỡ ợ ⱺ ꝋ ꝍ )],
	O => [qw( Ò Ó Ô Õ Ö Ø Ō Ŏ Ő Ɵ Ơ Ǒ Ǫ Ǭ Ǿ Ȍ Ȏ Ȫ Ȭ Ȯ Ȱ Ӧ Ṍ Ṏ Ṑ Ṓ Ọ Ỏ Ố Ồ Ổ Ỗ Ộ Ớ Ờ Ở Ỡ Ợ Ꝋ Ꝍ )],
	p => [qw( ƥ ᵱ ᵽ ᶈ ṕ ṗ ꝑ ꝓ ꝕ )],
	P => [qw( Ƥ Ṕ Ṗ Ᵽ Ꝑ Ꝓ Ꝕ )],
	q => [qw( ɋ ʠ ꝗ ꝙ )],
	Q => [qw( Ꝗ Ꝙ )],
	r => [qw( ŕ ŗ ř ȑ ȓ ɍ ɼ ɽ ɾ ᵲ ᵳ ᶉ ṙ ṛ ṝ ṟ ꞧ )],
	R => [qw( Ŕ Ŗ Ř Ȑ Ȓ Ɍ Ṙ Ṛ Ṝ Ṟ Ɽ Ꞧ )],
	s => [qw( ś ŝ ş š ș ȿ ʂ ᵴ ᶊ ṡ ṣ ṥ ṧ ṩ ꞩ )],
	S => [qw( Ś Ŝ Ş Š Ș Ṡ Ṣ Ṥ Ṧ Ṩ Ȿ Ꞩ )],
	t => [qw( ţ ť ŧ ƫ ƭ ț ȶ ʈ ᵵ ṫ ṭ ṯ ṱ ẗ ⱦ )],
	T => [qw( Ţ Ť Ŧ Ƭ Ʈ Ț Ⱦ Ṫ Ṭ Ṯ Ṱ )],
	u => [qw( ù ú û ü ũ ū ŭ ů ű ų ư ǔ ǖ ǘ ǚ ǜ ȕ ȗ ӯ ӱ ӳ ᶙ ṳ ṵ ṷ ṹ ṻ ụ ủ ứ ừ ử ữ ự )],
	U => [qw( Ù Ú Û Ü Ũ Ū Ŭ Ů Ű Ų Ư Ǔ Ǖ Ǘ Ǚ Ǜ Ȕ Ȗ Ӯ Ӱ Ӳ ᵾ Ṳ Ṵ Ṷ Ṹ Ṻ Ụ Ủ Ứ Ừ Ử Ữ Ự )],
	v => [qw( ʋ ᶌ ṽ ṿ ⱱ ⱴ ꝟ )],
	V => [qw( Ʋ Ṽ Ṿ Ꝟ )],
	w => [qw( ŵ ẁ ẃ ẅ ẇ ẉ ẘ ⱳ )],
	W => [qw( Ŵ Ẁ Ẃ Ẅ Ẇ Ẉ Ⱳ )],
	x => [qw( ᶍ ẋ ẍ )],
	X => [qw( Ẋ Ẍ )],
	y => [qw( ý ÿ ŷ ƴ ȳ ɏ ẏ ẙ ỳ ỵ ỷ ỹ ỿ )],
	Y => [qw( Ý Ŷ Ÿ Ƴ Ȳ Ɏ Ẏ Ỳ Ỵ Ỷ Ỹ Ỿ )],
	z => [qw( ź ż ž ƶ ǅ ȥ ɀ ʐ ʑ ᵶ ᶎ ẑ ẓ ẕ ⱬ )],
	Z => [qw( Ź Ż Ž Ƶ Ȥ Ẑ Ẓ Ẕ Ⱬ Ɀ )],

TABLE=1 utf8ls-number.sh 0 zero >> anglicise.pl
TABLE=1 utf8ls-number.sh 1 one >> anglicise.pl
TABLE=1 utf8ls-number.sh 2 two >> anglicise.pl
TABLE=1 utf8ls-number.sh 3 three >> anglicise.pl
TABLE=1 utf8ls-number.sh 4 four >> anglicise.pl
TABLE=1 utf8ls-number.sh 5 five >> anglicise.pl
TABLE=1 utf8ls-number.sh 6 six >> anglicise.pl
TABLE=1 utf8ls-number.sh 7 seven >> anglicise.pl
TABLE=1 utf8ls-number.sh 8 eight >> anglicise.pl
TABLE=1 utf8ls-number.sh 9 nine >> anglicise.pl
	0 => [qw( ٠ ۰ ߀ ० ০ ੦ ૦ ୦ ௦ ౦ ೦ ൦ ๐ ໐ ༠ ၀ ႐ ០ ᠐ ᥆ ᧐ ᪀ ᪐ ᭐ ᮰ ᱀ ᱐ ⓪ ⓿ 〇 ꘠ ꣐ ꣠ ꤀ ꧐ ꩐ ꯰ ０ 𐒠 𑁦 𑃰 𑄶 𑇐 𑛀 𝟎 𝟘 𝟢 𝟬 𝟶 󠀰 )],
	1 => [qw( ١ ۱ ߁ १ ১ ੧ ૧ ୧ ௧ ౧ ೧ ൧ ๑ ໑ ༡ ၁ ႑ ፩ ១ ᠑ ᥇ ᧑ ᧚ ᪁ ᪑ ᭑ ᮱ ᱁ ᱑ ① ⑴ ⓵ ❶ ➀ ➊ ꘡ ꣑ ꣡ ꤁ ꧑ ꩑ ꯱ １ 𐄇 𐏑 𐒡 𐡘 𐤖 𐩀 𐩽 𐭘 𐭸 𐹠 𑁒 𑁧 𑃱 𑄷 𑇑 𑛁 𝍠 𝍩 𝟏 𝟙 𝟣 𝟭 𝟷 󠀱 )],
	2 => [qw( ٢ ۲ ݳ ݵ ݸ ݺ ߂ २ ২ ੨ ૨ ୨ ௨ ౨ ೨ ൨ ๒ ໒ ༢ ၂ ႒ ፪ ២ ᠒ ᥈ ᧒ ᪂ ᪒ ᭒ ᮲ ᱂ ᱒ ② ⑵ ⓶ ❷ ➁ ➋ ꘢ ꣒ ꣢ ꤂ ꧒ ꩒ ꯲ ２ 𐄈 𐏒 𐒢 𐡙 𐤚 𐩁 𐭙 𐭹 𐹡 𑁓 𑁨 𑃲 𑄸 𑇒 𑛂 𝍡 𝍪 𝟐 𝟚 𝟤 𝟮 𝟸 󠀲 )],
	3 => [qw( ٣ ۳ ݴ ݶ ݹ ݻ ߃ ३ ৩ ੩ ૩ ୩ ௩ ౩ ೩ ൩ ๓ ໓ ༣ ၃ ႓ ፫ ៣ ᠓ ᥉ ᧓ ᪃ ᪓ ᭓ ᮳ ᱃ ᱓ ③ ⑶ ⓷ ❸ ➂ ➌ ꘣ ꣓ ꣣ ꤃ ꧓ ꩓ ꯳ ３ 𐄉 𐒣 𐡚 𐤛 𐩂 𐭚 𐭺 𐹢 𑁔 𑁩 𑃳 𑄹 𑇓 𑛃 𝍢 𝍫 𝟑 𝟛 𝟥 𝟯 𝟹 󠀳 )],
	4 => [qw( ٤ ۴ ݷ ݼ ݽ ߄ ४ ৪ ੪ ૪ ୪ ௪ ౪ ೪ ൪ ๔ ໔ ༤ ၄ ႔ ፬ ៤ ᠔ ᥊ ᧔ ᪄ ᪔ ᭔ ᮴ ᱄ ᱔ ④ ⑷ ⓸ ❹ ➃ ➍ ꘤ ꣔ ꣤ ꤄ ꧔ ꩔ ꯴ ４ 𐄊 𐒤 𐩃 𐭛 𐭻 𐹣 𑁕 𑁪 𑃴 𑄺 𑇔 𑛄 𝍣 𝍬 𝟒 𝟜 𝟦 𝟰 𝟺 󠀴 )],
	5 => [qw( ٥ ۵ ߅ ५ ৫ ੫ ૫ ୫ ௫ ౫ ೫ ൫ ๕ ໕ ༥ ၅ ႕ ፭ ៥ ᠕ ᥋ ᧕ ᪅ ᪕ ᭕ ᮵ ᱅ ᱕ ⑤ ⑸ ⓹ ❺ ➄ ➎ ꘥ ꣕ ꣥ ꤅ ꧕ ꩕ ꯵ ５ 𐄋 𐒥 𐹤 𑁖 𑁫 𑃵 𑄻 𑇕 𑛅 𝍤 𝍭 𝟓 𝟝 𝟧 𝟱 𝟻 󠀵 )],
	6 => [qw( ٦ ۶ ߆ ६ ৬ ੬ ૬ ୬ ௬ ౬ ೬ ൬ ๖ ໖ ༦ ၆ ႖ ፮ ៦ ᠖ ᥌ ᧖ ᪆ ᪖ ᭖ ᮶ ᱆ ᱖ ⑥ ⑹ ⓺ ❻ ➅ ➏ ꘦ ꣖ ꣦ ꤆ ꧖ ꩖ ꯶ ６ 𐄌 𐒦 𐹥 𑁗 𑁬 𑃶 𑄼 𑇖 𑛆 𝍥 𝍮 𝟔 𝟞 𝟨 𝟲 𝟼 󠀶 )],
	7 => [qw( ٧ ۷ ߇ ७ ৭ ੭ ૭ ୭ ௭ ౭ ೭ ൭ ๗ ໗ ༧ ၇ ႗ ፯ ៧ ᠗ ᥍ ᧗ ᪇ ᪗ ᭗ ᮷ ᱇ ᱗ ⑦ ⑺ ⓻ ❼ ➆ ➐ ꘧ ꣗ ꣧ ꤇ ꧗ ꩗ ꯷ ７ 𐄍 𐒧 𐹦 𑁘 𑁭 𑃷 𑄽 𑇗 𑛇 𝍦 𝍯 𝟕 𝟟 𝟩 𝟳 𝟽 󠀷 )],
	8 => [qw( ٨ ۸ ߈ ८ ৮ ੮ ૮ ୮ ௮ ౮ ೮ ൮ ๘ ໘ ༨ ၈ ႘ ፰ ៨ ᠘ ᥎ ᧘ ᪈ ᪘ ᭘ ᮸ ᱈ ᱘ ⑧ ⑻ ⓼ ❽ ➇ ➑ ꘨ ꣘ ꣨ ꤈ ꧘ ꩘ ꯸ ８ 𐄎 𐒨 𐹧 𑁙 𑁮 𑃸 𑄾 𑇘 𑛈 𝍧 𝍰 𝟖 𝟠 𝟪 𝟴 𝟾 󠀸 )],
	9 => [qw( ٩ ۹ ߉ ९ ৯ ੯ ૯ ୯ ௯ ౯ ೯ ൯ ๙ ໙ ༩ ၉ ႙ ፱ ៩ ᠙ ᥏ ᧙ ᪉ ᪙ ᭙ ᮹ ᱉ ᱙ ⑨ ⑼ ⓽ ❾ ➈ ➒ ꘩ ꣙ ꣩ ꤉ ꧙ ꩙ ꯹ ９ 𐄏 𐒩 𐹨 𑁚 𑁯 𑃹 𑄿 𑇙 𑛉 𝍨 𝍱 𝟗 𝟡 𝟫 𝟵 𝟿 󠀹 )],

(for letter in  a b c d e f g h i j k l m n o p q r s t u v w x y z ; do utf8ls-letter.sh $letter ; done) >> anglicise.pl
a	U+61	[LowercaseLetter]	LATIN SMALL LETTER A
à	U+E0	[LowercaseLetter]	LATIN SMALL LETTER A WITH GRAVE
á	U+E1	[LowercaseLetter]	LATIN SMALL LETTER A WITH ACUTE
â	U+E2	[LowercaseLetter]	LATIN SMALL LETTER A WITH CIRCUMFLEX
ã	U+E3	[LowercaseLetter]	LATIN SMALL LETTER A WITH TILDE
ä	U+E4	[LowercaseLetter]	LATIN SMALL LETTER A WITH DIAERESIS
å	U+E5	[LowercaseLetter]	LATIN SMALL LETTER A WITH RING ABOVE
ā	U+101	[LowercaseLetter]	LATIN SMALL LETTER A WITH MACRON
ă	U+103	[LowercaseLetter]	LATIN SMALL LETTER A WITH BREVE
ą	U+105	[LowercaseLetter]	LATIN SMALL LETTER A WITH OGONEK
ǎ	U+1CE	[LowercaseLetter]	LATIN SMALL LETTER A WITH CARON
ǟ	U+1DF	[LowercaseLetter]	LATIN SMALL LETTER A WITH DIAERESIS AND MACRON
ǡ	U+1E1	[LowercaseLetter]	LATIN SMALL LETTER A WITH DOT ABOVE AND MACRON
ǻ	U+1FB	[LowercaseLetter]	LATIN SMALL LETTER A WITH RING ABOVE AND ACUTE
ȁ	U+201	[LowercaseLetter]	LATIN SMALL LETTER A WITH DOUBLE GRAVE
ȃ	U+203	[LowercaseLetter]	LATIN SMALL LETTER A WITH INVERTED BREVE
ȧ	U+227	[LowercaseLetter]	LATIN SMALL LETTER A WITH DOT ABOVE
ͣ	U+363	[NonspacingMark]	COMBINING LATIN SMALL LETTER A
а	U+430	[LowercaseLetter]	CYRILLIC SMALL LETTER A
ӑ	U+4D1	[LowercaseLetter]	CYRILLIC SMALL LETTER A WITH BREVE
ӓ	U+4D3	[LowercaseLetter]	CYRILLIC SMALL LETTER A WITH DIAERESIS
ᶏ	U+1D8F	[LowercaseLetter]	LATIN SMALL LETTER A WITH RETROFLEX HOOK
ḁ	U+1E01	[LowercaseLetter]	LATIN SMALL LETTER A WITH RING BELOW
ẚ	U+1E9A	[LowercaseLetter]	LATIN SMALL LETTER A WITH RIGHT HALF RING
ạ	U+1EA1	[LowercaseLetter]	LATIN SMALL LETTER A WITH DOT BELOW
ả	U+1EA3	[LowercaseLetter]	LATIN SMALL LETTER A WITH HOOK ABOVE
ấ	U+1EA5	[LowercaseLetter]	LATIN SMALL LETTER A WITH CIRCUMFLEX AND ACUTE
ầ	U+1EA7	[LowercaseLetter]	LATIN SMALL LETTER A WITH CIRCUMFLEX AND GRAVE
ẩ	U+1EA9	[LowercaseLetter]	LATIN SMALL LETTER A WITH CIRCUMFLEX AND HOOK ABOVE
ẫ	U+1EAB	[LowercaseLetter]	LATIN SMALL LETTER A WITH CIRCUMFLEX AND TILDE
ậ	U+1EAD	[LowercaseLetter]	LATIN SMALL LETTER A WITH CIRCUMFLEX AND DOT BELOW
ắ	U+1EAF	[LowercaseLetter]	LATIN SMALL LETTER A WITH BREVE AND ACUTE
ằ	U+1EB1	[LowercaseLetter]	LATIN SMALL LETTER A WITH BREVE AND GRAVE
ẳ	U+1EB3	[LowercaseLetter]	LATIN SMALL LETTER A WITH BREVE AND HOOK ABOVE
ẵ	U+1EB5	[LowercaseLetter]	LATIN SMALL LETTER A WITH BREVE AND TILDE
ặ	U+1EB7	[LowercaseLetter]	LATIN SMALL LETTER A WITH BREVE AND DOT BELOW
ₐ	U+2090	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER A
⒜	U+249C	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER A
ⓐ	U+24D0	[OtherSymbol]	CIRCLED LATIN SMALL LETTER A
ⱥ	U+2C65	[LowercaseLetter]	LATIN SMALL LETTER A WITH STROKE
ａ	U+FF41	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER A
󠁡	U+E0061	[Format]	TAG LATIN SMALL LETTER A
A	U+41	[UppercaseLetter]	LATIN CAPITAL LETTER A
À	U+C0	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH GRAVE
Á	U+C1	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH ACUTE
Â	U+C2	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CIRCUMFLEX
Ã	U+C3	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH TILDE
Ä	U+C4	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH DIAERESIS
Å	U+C5	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH RING ABOVE
Ā	U+100	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH MACRON
Ă	U+102	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH BREVE
Ą	U+104	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH OGONEK
Ǎ	U+1CD	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CARON
Ǟ	U+1DE	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH DIAERESIS AND MACRON
Ǡ	U+1E0	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH DOT ABOVE AND MACRON
Ǻ	U+1FA	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH RING ABOVE AND ACUTE
Ȁ	U+200	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH DOUBLE GRAVE
Ȃ	U+202	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH INVERTED BREVE
Ȧ	U+226	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH DOT ABOVE
Ⱥ	U+23A	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH STROKE
А	U+410	[UppercaseLetter]	CYRILLIC CAPITAL LETTER A
Ӑ	U+4D0	[UppercaseLetter]	CYRILLIC CAPITAL LETTER A WITH BREVE
Ӓ	U+4D2	[UppercaseLetter]	CYRILLIC CAPITAL LETTER A WITH DIAERESIS
Ḁ	U+1E00	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH RING BELOW
Ạ	U+1EA0	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH DOT BELOW
Ả	U+1EA2	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH HOOK ABOVE
Ấ	U+1EA4	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND ACUTE
Ầ	U+1EA6	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND GRAVE
Ẩ	U+1EA8	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND HOOK ABOVE
Ẫ	U+1EAA	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND TILDE
Ậ	U+1EAC	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH CIRCUMFLEX AND DOT BELOW
Ắ	U+1EAE	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH BREVE AND ACUTE
Ằ	U+1EB0	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH BREVE AND GRAVE
Ẳ	U+1EB2	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH BREVE AND HOOK ABOVE
Ẵ	U+1EB4	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH BREVE AND TILDE
Ặ	U+1EB6	[UppercaseLetter]	LATIN CAPITAL LETTER A WITH BREVE AND DOT BELOW
Ⓐ	U+24B6	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER A
Ａ	U+FF21	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER A
🄐	U+1F110	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER A
🄰	U+1F130	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER A
🅐	U+1F150	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER A
🅰	U+1F170	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER A
󠁁	U+E0041	[Format]	TAG LATIN CAPITAL LETTER A
b	U+62	[LowercaseLetter]	LATIN SMALL LETTER B
ƀ	U+180	[LowercaseLetter]	LATIN SMALL LETTER B WITH STROKE
ƃ	U+183	[LowercaseLetter]	LATIN SMALL LETTER B WITH TOPBAR
ɓ	U+253	[LowercaseLetter]	LATIN SMALL LETTER B WITH HOOK
ᵬ	U+1D6C	[LowercaseLetter]	LATIN SMALL LETTER B WITH MIDDLE TILDE
ᶀ	U+1D80	[LowercaseLetter]	LATIN SMALL LETTER B WITH PALATAL HOOK
ḃ	U+1E03	[LowercaseLetter]	LATIN SMALL LETTER B WITH DOT ABOVE
ḅ	U+1E05	[LowercaseLetter]	LATIN SMALL LETTER B WITH DOT BELOW
ḇ	U+1E07	[LowercaseLetter]	LATIN SMALL LETTER B WITH LINE BELOW
⒝	U+249D	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER B
ⓑ	U+24D1	[OtherSymbol]	CIRCLED LATIN SMALL LETTER B
ｂ	U+FF42	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER B
󠁢	U+E0062	[Format]	TAG LATIN SMALL LETTER B
B	U+42	[UppercaseLetter]	LATIN CAPITAL LETTER B
Ɓ	U+181	[UppercaseLetter]	LATIN CAPITAL LETTER B WITH HOOK
Ƃ	U+182	[UppercaseLetter]	LATIN CAPITAL LETTER B WITH TOPBAR
Ƀ	U+243	[UppercaseLetter]	LATIN CAPITAL LETTER B WITH STROKE
Ḃ	U+1E02	[UppercaseLetter]	LATIN CAPITAL LETTER B WITH DOT ABOVE
Ḅ	U+1E04	[UppercaseLetter]	LATIN CAPITAL LETTER B WITH DOT BELOW
Ḇ	U+1E06	[UppercaseLetter]	LATIN CAPITAL LETTER B WITH LINE BELOW
Ⓑ	U+24B7	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER B
Ｂ	U+FF22	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER B
🄑	U+1F111	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER B
🄱	U+1F131	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER B
🅑	U+1F151	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER B
🅱	U+1F171	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER B
󠁂	U+E0042	[Format]	TAG LATIN CAPITAL LETTER B
c	U+63	[LowercaseLetter]	LATIN SMALL LETTER C
ç	U+E7	[LowercaseLetter]	LATIN SMALL LETTER C WITH CEDILLA
ć	U+107	[LowercaseLetter]	LATIN SMALL LETTER C WITH ACUTE
ĉ	U+109	[LowercaseLetter]	LATIN SMALL LETTER C WITH CIRCUMFLEX
ċ	U+10B	[LowercaseLetter]	LATIN SMALL LETTER C WITH DOT ABOVE
č	U+10D	[LowercaseLetter]	LATIN SMALL LETTER C WITH CARON
ƈ	U+188	[LowercaseLetter]	LATIN SMALL LETTER C WITH HOOK
ȼ	U+23C	[LowercaseLetter]	LATIN SMALL LETTER C WITH STROKE
ɕ	U+255	[LowercaseLetter]	LATIN SMALL LETTER C WITH CURL
ͨ	U+368	[NonspacingMark]	COMBINING LATIN SMALL LETTER C
ᷗ	U+1DD7	[NonspacingMark]	COMBINING LATIN SMALL LETTER C CEDILLA
ḉ	U+1E09	[LowercaseLetter]	LATIN SMALL LETTER C WITH CEDILLA AND ACUTE
⒞	U+249E	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER C
ⓒ	U+24D2	[OtherSymbol]	CIRCLED LATIN SMALL LETTER C
ꞓ	U+A793	[LowercaseLetter]	LATIN SMALL LETTER C WITH BAR
ｃ	U+FF43	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER C
󠁣	U+E0063	[Format]	TAG LATIN SMALL LETTER C
C	U+43	[UppercaseLetter]	LATIN CAPITAL LETTER C
Ç	U+C7	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH CEDILLA
Ć	U+106	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH ACUTE
Ĉ	U+108	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH CIRCUMFLEX
Ċ	U+10A	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH DOT ABOVE
Č	U+10C	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH CARON
Ƈ	U+187	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH HOOK
Ȼ	U+23B	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH STROKE
Ḉ	U+1E08	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH CEDILLA AND ACUTE
Ⓒ	U+24B8	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER C
Ꞓ	U+A792	[UppercaseLetter]	LATIN CAPITAL LETTER C WITH BAR
Ｃ	U+FF23	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER C
🄒	U+1F112	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER C
🄫	U+1F12B	[OtherSymbol]	CIRCLED ITALIC LATIN CAPITAL LETTER C
🄲	U+1F132	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER C
🅒	U+1F152	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER C
🅲	U+1F172	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER C
󠁃	U+E0043	[Format]	TAG LATIN CAPITAL LETTER C
d	U+64	[LowercaseLetter]	LATIN SMALL LETTER D
ď	U+10F	[LowercaseLetter]	LATIN SMALL LETTER D WITH CARON
đ	U+111	[LowercaseLetter]	LATIN SMALL LETTER D WITH STROKE
ƌ	U+18C	[LowercaseLetter]	LATIN SMALL LETTER D WITH TOPBAR
ȡ	U+221	[LowercaseLetter]	LATIN SMALL LETTER D WITH CURL
ɖ	U+256	[LowercaseLetter]	LATIN SMALL LETTER D WITH TAIL
ɗ	U+257	[LowercaseLetter]	LATIN SMALL LETTER D WITH HOOK
ͩ	U+369	[NonspacingMark]	COMBINING LATIN SMALL LETTER D
ᵭ	U+1D6D	[LowercaseLetter]	LATIN SMALL LETTER D WITH MIDDLE TILDE
ᶁ	U+1D81	[LowercaseLetter]	LATIN SMALL LETTER D WITH PALATAL HOOK
ᶑ	U+1D91	[LowercaseLetter]	LATIN SMALL LETTER D WITH HOOK AND TAIL
ḋ	U+1E0B	[LowercaseLetter]	LATIN SMALL LETTER D WITH DOT ABOVE
ḍ	U+1E0D	[LowercaseLetter]	LATIN SMALL LETTER D WITH DOT BELOW
ḏ	U+1E0F	[LowercaseLetter]	LATIN SMALL LETTER D WITH LINE BELOW
ḑ	U+1E11	[LowercaseLetter]	LATIN SMALL LETTER D WITH CEDILLA
ḓ	U+1E13	[LowercaseLetter]	LATIN SMALL LETTER D WITH CIRCUMFLEX BELOW
⒟	U+249F	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER D
ⓓ	U+24D3	[OtherSymbol]	CIRCLED LATIN SMALL LETTER D
ｄ	U+FF44	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER D
󠁤	U+E0064	[Format]	TAG LATIN SMALL LETTER D
D	U+44	[UppercaseLetter]	LATIN CAPITAL LETTER D
Ď	U+10E	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH CARON
Đ	U+110	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH STROKE
Ɗ	U+18A	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH HOOK
Ƌ	U+18B	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH TOPBAR
ǅ	U+1C5	[TitlecaseLetter]	LATIN CAPITAL LETTER D WITH SMALL LETTER Z WITH CARON
ǲ	U+1F2	[TitlecaseLetter]	LATIN CAPITAL LETTER D WITH SMALL LETTER Z
Ḋ	U+1E0A	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH DOT ABOVE
Ḍ	U+1E0C	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH DOT BELOW
Ḏ	U+1E0E	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH LINE BELOW
Ḑ	U+1E10	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH CEDILLA
Ḓ	U+1E12	[UppercaseLetter]	LATIN CAPITAL LETTER D WITH CIRCUMFLEX BELOW
Ⓓ	U+24B9	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER D
Ｄ	U+FF24	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER D
🄓	U+1F113	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER D
🄳	U+1F133	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER D
🅓	U+1F153	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER D
🅳	U+1F173	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER D
󠁄	U+E0044	[Format]	TAG LATIN CAPITAL LETTER D
e	U+65	[LowercaseLetter]	LATIN SMALL LETTER E
è	U+E8	[LowercaseLetter]	LATIN SMALL LETTER E WITH GRAVE
é	U+E9	[LowercaseLetter]	LATIN SMALL LETTER E WITH ACUTE
ê	U+EA	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX
ë	U+EB	[LowercaseLetter]	LATIN SMALL LETTER E WITH DIAERESIS
ē	U+113	[LowercaseLetter]	LATIN SMALL LETTER E WITH MACRON
ĕ	U+115	[LowercaseLetter]	LATIN SMALL LETTER E WITH BREVE
ė	U+117	[LowercaseLetter]	LATIN SMALL LETTER E WITH DOT ABOVE
ę	U+119	[LowercaseLetter]	LATIN SMALL LETTER E WITH OGONEK
ě	U+11B	[LowercaseLetter]	LATIN SMALL LETTER E WITH CARON
ȅ	U+205	[LowercaseLetter]	LATIN SMALL LETTER E WITH DOUBLE GRAVE
ȇ	U+207	[LowercaseLetter]	LATIN SMALL LETTER E WITH INVERTED BREVE
ȩ	U+229	[LowercaseLetter]	LATIN SMALL LETTER E WITH CEDILLA
ɇ	U+247	[LowercaseLetter]	LATIN SMALL LETTER E WITH STROKE
ͤ	U+364	[NonspacingMark]	COMBINING LATIN SMALL LETTER E
э	U+44D	[LowercaseLetter]	CYRILLIC SMALL LETTER E
ӭ	U+4ED	[LowercaseLetter]	CYRILLIC SMALL LETTER E WITH DIAERESIS
ᶒ	U+1D92	[LowercaseLetter]	LATIN SMALL LETTER E WITH RETROFLEX HOOK
ḕ	U+1E15	[LowercaseLetter]	LATIN SMALL LETTER E WITH MACRON AND GRAVE
ḗ	U+1E17	[LowercaseLetter]	LATIN SMALL LETTER E WITH MACRON AND ACUTE
ḙ	U+1E19	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX BELOW
ḛ	U+1E1B	[LowercaseLetter]	LATIN SMALL LETTER E WITH TILDE BELOW
ḝ	U+1E1D	[LowercaseLetter]	LATIN SMALL LETTER E WITH CEDILLA AND BREVE
ẹ	U+1EB9	[LowercaseLetter]	LATIN SMALL LETTER E WITH DOT BELOW
ẻ	U+1EBB	[LowercaseLetter]	LATIN SMALL LETTER E WITH HOOK ABOVE
ẽ	U+1EBD	[LowercaseLetter]	LATIN SMALL LETTER E WITH TILDE
ế	U+1EBF	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX AND ACUTE
ề	U+1EC1	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX AND GRAVE
ể	U+1EC3	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX AND HOOK ABOVE
ễ	U+1EC5	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX AND TILDE
ệ	U+1EC7	[LowercaseLetter]	LATIN SMALL LETTER E WITH CIRCUMFLEX AND DOT BELOW
ₑ	U+2091	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER E
⒠	U+24A0	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER E
ⓔ	U+24D4	[OtherSymbol]	CIRCLED LATIN SMALL LETTER E
ⱸ	U+2C78	[LowercaseLetter]	LATIN SMALL LETTER E WITH NOTCH
ｅ	U+FF45	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER E
󠁥	U+E0065	[Format]	TAG LATIN SMALL LETTER E
E	U+45	[UppercaseLetter]	LATIN CAPITAL LETTER E
È	U+C8	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH GRAVE
É	U+C9	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH ACUTE
Ê	U+CA	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX
Ë	U+CB	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH DIAERESIS
Ē	U+112	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH MACRON
Ĕ	U+114	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH BREVE
Ė	U+116	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH DOT ABOVE
Ę	U+118	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH OGONEK
Ě	U+11A	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CARON
Ȅ	U+204	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH DOUBLE GRAVE
Ȇ	U+206	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH INVERTED BREVE
Ȩ	U+228	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CEDILLA
Ɇ	U+246	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH STROKE
Э	U+42D	[UppercaseLetter]	CYRILLIC CAPITAL LETTER E
Ӭ	U+4EC	[UppercaseLetter]	CYRILLIC CAPITAL LETTER E WITH DIAERESIS
Ḕ	U+1E14	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH MACRON AND GRAVE
Ḗ	U+1E16	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH MACRON AND ACUTE
Ḙ	U+1E18	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX BELOW
Ḛ	U+1E1A	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH TILDE BELOW
Ḝ	U+1E1C	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CEDILLA AND BREVE
Ẹ	U+1EB8	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH DOT BELOW
Ẻ	U+1EBA	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH HOOK ABOVE
Ẽ	U+1EBC	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH TILDE
Ế	U+1EBE	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND ACUTE
Ề	U+1EC0	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND GRAVE
Ể	U+1EC2	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND HOOK ABOVE
Ễ	U+1EC4	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND TILDE
Ệ	U+1EC6	[UppercaseLetter]	LATIN CAPITAL LETTER E WITH CIRCUMFLEX AND DOT BELOW
Ⓔ	U+24BA	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER E
Ｅ	U+FF25	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER E
🄔	U+1F114	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER E
🄴	U+1F134	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER E
🅔	U+1F154	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER E
🅴	U+1F174	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER E
󠁅	U+E0045	[Format]	TAG LATIN CAPITAL LETTER E
f	U+66	[LowercaseLetter]	LATIN SMALL LETTER F
ƒ	U+192	[LowercaseLetter]	LATIN SMALL LETTER F WITH HOOK
ᵮ	U+1D6E	[LowercaseLetter]	LATIN SMALL LETTER F WITH MIDDLE TILDE
ᶂ	U+1D82	[LowercaseLetter]	LATIN SMALL LETTER F WITH PALATAL HOOK
ḟ	U+1E1F	[LowercaseLetter]	LATIN SMALL LETTER F WITH DOT ABOVE
⒡	U+24A1	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER F
ⓕ	U+24D5	[OtherSymbol]	CIRCLED LATIN SMALL LETTER F
ｆ	U+FF46	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER F
󠁦	U+E0066	[Format]	TAG LATIN SMALL LETTER F
F	U+46	[UppercaseLetter]	LATIN CAPITAL LETTER F
Ƒ	U+191	[UppercaseLetter]	LATIN CAPITAL LETTER F WITH HOOK
Ḟ	U+1E1E	[UppercaseLetter]	LATIN CAPITAL LETTER F WITH DOT ABOVE
Ⓕ	U+24BB	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER F
Ｆ	U+FF26	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER F
🄕	U+1F115	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER F
🄵	U+1F135	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER F
🅕	U+1F155	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER F
🅵	U+1F175	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER F
󠁆	U+E0046	[Format]	TAG LATIN CAPITAL LETTER F
g	U+67	[LowercaseLetter]	LATIN SMALL LETTER G
ĝ	U+11D	[LowercaseLetter]	LATIN SMALL LETTER G WITH CIRCUMFLEX
ğ	U+11F	[LowercaseLetter]	LATIN SMALL LETTER G WITH BREVE
ġ	U+121	[LowercaseLetter]	LATIN SMALL LETTER G WITH DOT ABOVE
ģ	U+123	[LowercaseLetter]	LATIN SMALL LETTER G WITH CEDILLA
ǥ	U+1E5	[LowercaseLetter]	LATIN SMALL LETTER G WITH STROKE
ǧ	U+1E7	[LowercaseLetter]	LATIN SMALL LETTER G WITH CARON
ǵ	U+1F5	[LowercaseLetter]	LATIN SMALL LETTER G WITH ACUTE
ɠ	U+260	[LowercaseLetter]	LATIN SMALL LETTER G WITH HOOK
ᶃ	U+1D83	[LowercaseLetter]	LATIN SMALL LETTER G WITH PALATAL HOOK
ᷚ	U+1DDA	[NonspacingMark]	COMBINING LATIN SMALL LETTER G
ḡ	U+1E21	[LowercaseLetter]	LATIN SMALL LETTER G WITH MACRON
⒢	U+24A2	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER G
ⓖ	U+24D6	[OtherSymbol]	CIRCLED LATIN SMALL LETTER G
ꞡ	U+A7A1	[LowercaseLetter]	LATIN SMALL LETTER G WITH OBLIQUE STROKE
ｇ	U+FF47	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER G
󠁧	U+E0067	[Format]	TAG LATIN SMALL LETTER G
G	U+47	[UppercaseLetter]	LATIN CAPITAL LETTER G
Ĝ	U+11C	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH CIRCUMFLEX
Ğ	U+11E	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH BREVE
Ġ	U+120	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH DOT ABOVE
Ģ	U+122	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH CEDILLA
Ɠ	U+193	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH HOOK
Ǥ	U+1E4	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH STROKE
Ǧ	U+1E6	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH CARON
Ǵ	U+1F4	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH ACUTE
Ḡ	U+1E20	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH MACRON
Ⓖ	U+24BC	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER G
Ꞡ	U+A7A0	[UppercaseLetter]	LATIN CAPITAL LETTER G WITH OBLIQUE STROKE
Ｇ	U+FF27	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER G
🄖	U+1F116	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER G
🄶	U+1F136	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER G
🅖	U+1F156	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER G
🅶	U+1F176	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER G
󠁇	U+E0047	[Format]	TAG LATIN CAPITAL LETTER G
h	U+68	[LowercaseLetter]	LATIN SMALL LETTER H
ĥ	U+125	[LowercaseLetter]	LATIN SMALL LETTER H WITH CIRCUMFLEX
ħ	U+127	[LowercaseLetter]	LATIN SMALL LETTER H WITH STROKE
ȟ	U+21F	[LowercaseLetter]	LATIN SMALL LETTER H WITH CARON
ɦ	U+266	[LowercaseLetter]	LATIN SMALL LETTER H WITH HOOK
ͪ	U+36A	[NonspacingMark]	COMBINING LATIN SMALL LETTER H
ḣ	U+1E23	[LowercaseLetter]	LATIN SMALL LETTER H WITH DOT ABOVE
ḥ	U+1E25	[LowercaseLetter]	LATIN SMALL LETTER H WITH DOT BELOW
ḧ	U+1E27	[LowercaseLetter]	LATIN SMALL LETTER H WITH DIAERESIS
ḩ	U+1E29	[LowercaseLetter]	LATIN SMALL LETTER H WITH CEDILLA
ḫ	U+1E2B	[LowercaseLetter]	LATIN SMALL LETTER H WITH BREVE BELOW
ẖ	U+1E96	[LowercaseLetter]	LATIN SMALL LETTER H WITH LINE BELOW
ₕ	U+2095	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER H
⒣	U+24A3	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER H
ⓗ	U+24D7	[OtherSymbol]	CIRCLED LATIN SMALL LETTER H
ⱨ	U+2C68	[LowercaseLetter]	LATIN SMALL LETTER H WITH DESCENDER
ｈ	U+FF48	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER H
𐐸	U+10438	[LowercaseLetter]	DESERET SMALL LETTER H
󠁨	U+E0068	[Format]	TAG LATIN SMALL LETTER H
H	U+48	[UppercaseLetter]	LATIN CAPITAL LETTER H
Ĥ	U+124	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH CIRCUMFLEX
Ħ	U+126	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH STROKE
Ȟ	U+21E	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH CARON
Ḣ	U+1E22	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH DOT ABOVE
Ḥ	U+1E24	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH DOT BELOW
Ḧ	U+1E26	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH DIAERESIS
Ḩ	U+1E28	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH CEDILLA
Ḫ	U+1E2A	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH BREVE BELOW
Ⓗ	U+24BD	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER H
Ⱨ	U+2C67	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH DESCENDER
Ɦ	U+A7AA	[UppercaseLetter]	LATIN CAPITAL LETTER H WITH HOOK
Ｈ	U+FF28	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER H
𐐐	U+10410	[UppercaseLetter]	DESERET CAPITAL LETTER H
🄗	U+1F117	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER H
🄷	U+1F137	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER H
🅗	U+1F157	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER H
🅷	U+1F177	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER H
󠁈	U+E0048	[Format]	TAG LATIN CAPITAL LETTER H
i	U+69	[LowercaseLetter]	LATIN SMALL LETTER I
ì	U+EC	[LowercaseLetter]	LATIN SMALL LETTER I WITH GRAVE
í	U+ED	[LowercaseLetter]	LATIN SMALL LETTER I WITH ACUTE
î	U+EE	[LowercaseLetter]	LATIN SMALL LETTER I WITH CIRCUMFLEX
ï	U+EF	[LowercaseLetter]	LATIN SMALL LETTER I WITH DIAERESIS
ĩ	U+129	[LowercaseLetter]	LATIN SMALL LETTER I WITH TILDE
ī	U+12B	[LowercaseLetter]	LATIN SMALL LETTER I WITH MACRON
ĭ	U+12D	[LowercaseLetter]	LATIN SMALL LETTER I WITH BREVE
į	U+12F	[LowercaseLetter]	LATIN SMALL LETTER I WITH OGONEK
ǐ	U+1D0	[LowercaseLetter]	LATIN SMALL LETTER I WITH CARON
ȉ	U+209	[LowercaseLetter]	LATIN SMALL LETTER I WITH DOUBLE GRAVE
ȋ	U+20B	[LowercaseLetter]	LATIN SMALL LETTER I WITH INVERTED BREVE
ɨ	U+268	[LowercaseLetter]	LATIN SMALL LETTER I WITH STROKE
ͥ	U+365	[NonspacingMark]	COMBINING LATIN SMALL LETTER I
и	U+438	[LowercaseLetter]	CYRILLIC SMALL LETTER I
ѝ	U+45D	[LowercaseLetter]	CYRILLIC SMALL LETTER I WITH GRAVE
ӣ	U+4E3	[LowercaseLetter]	CYRILLIC SMALL LETTER I WITH MACRON
ӥ	U+4E5	[LowercaseLetter]	CYRILLIC SMALL LETTER I WITH DIAERESIS
ᵢ	U+1D62	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER I
ᶖ	U+1D96	[LowercaseLetter]	LATIN SMALL LETTER I WITH RETROFLEX HOOK
ḭ	U+1E2D	[LowercaseLetter]	LATIN SMALL LETTER I WITH TILDE BELOW
ḯ	U+1E2F	[LowercaseLetter]	LATIN SMALL LETTER I WITH DIAERESIS AND ACUTE
ỉ	U+1EC9	[LowercaseLetter]	LATIN SMALL LETTER I WITH HOOK ABOVE
ị	U+1ECB	[LowercaseLetter]	LATIN SMALL LETTER I WITH DOT BELOW
ⁱ	U+2071	[ModifierLetter]	SUPERSCRIPT LATIN SMALL LETTER I
⒤	U+24A4	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER I
ⓘ	U+24D8	[OtherSymbol]	CIRCLED LATIN SMALL LETTER I
ⰻ	U+2C3B	[LowercaseLetter]	GLAGOLITIC SMALL LETTER I
ｉ	U+FF49	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER I
󠁩	U+E0069	[Format]	TAG LATIN SMALL LETTER I
I	U+49	[UppercaseLetter]	LATIN CAPITAL LETTER I
Ì	U+CC	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH GRAVE
Í	U+CD	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH ACUTE
Î	U+CE	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH CIRCUMFLEX
Ï	U+CF	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH DIAERESIS
Ĩ	U+128	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH TILDE
Ī	U+12A	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH MACRON
Ĭ	U+12C	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH BREVE
Į	U+12E	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH OGONEK
İ	U+130	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH DOT ABOVE
Ɨ	U+197	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH STROKE
Ǐ	U+1CF	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH CARON
Ȉ	U+208	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH DOUBLE GRAVE
Ȋ	U+20A	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH INVERTED BREVE
Ѝ	U+40D	[UppercaseLetter]	CYRILLIC CAPITAL LETTER I WITH GRAVE
И	U+418	[UppercaseLetter]	CYRILLIC CAPITAL LETTER I
Ӣ	U+4E2	[UppercaseLetter]	CYRILLIC CAPITAL LETTER I WITH MACRON
Ӥ	U+4E4	[UppercaseLetter]	CYRILLIC CAPITAL LETTER I WITH DIAERESIS
ᵻ	U+1D7B	[LowercaseLetter]	LATIN SMALL CAPITAL LETTER I WITH STROKE
Ḭ	U+1E2C	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH TILDE BELOW
Ḯ	U+1E2E	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH DIAERESIS AND ACUTE
Ỉ	U+1EC8	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH HOOK ABOVE
Ị	U+1ECA	[UppercaseLetter]	LATIN CAPITAL LETTER I WITH DOT BELOW
Ⓘ	U+24BE	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER I
Ⰻ	U+2C0B	[UppercaseLetter]	GLAGOLITIC CAPITAL LETTER I
Ｉ	U+FF29	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER I
🄘	U+1F118	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER I
🄸	U+1F138	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER I
🅘	U+1F158	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER I
🅸	U+1F178	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER I
󠁉	U+E0049	[Format]	TAG LATIN CAPITAL LETTER I
j	U+6A	[LowercaseLetter]	LATIN SMALL LETTER J
ĵ	U+135	[LowercaseLetter]	LATIN SMALL LETTER J WITH CIRCUMFLEX
ǈ	U+1C8	[TitlecaseLetter]	LATIN CAPITAL LETTER L WITH SMALL LETTER J
ǋ	U+1CB	[TitlecaseLetter]	LATIN CAPITAL LETTER N WITH SMALL LETTER J
ǰ	U+1F0	[LowercaseLetter]	LATIN SMALL LETTER J WITH CARON
ɉ	U+249	[LowercaseLetter]	LATIN SMALL LETTER J WITH STROKE
ʝ	U+29D	[LowercaseLetter]	LATIN SMALL LETTER J WITH CROSSED-TAIL
⒥	U+24A5	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER J
ⓙ	U+24D9	[OtherSymbol]	CIRCLED LATIN SMALL LETTER J
ⱼ	U+2C7C	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER J
ｊ	U+FF4A	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER J
󠁪	U+E006A	[Format]	TAG LATIN SMALL LETTER J
J	U+4A	[UppercaseLetter]	LATIN CAPITAL LETTER J
Ĵ	U+134	[UppercaseLetter]	LATIN CAPITAL LETTER J WITH CIRCUMFLEX
Ɉ	U+248	[UppercaseLetter]	LATIN CAPITAL LETTER J WITH STROKE
Ⓙ	U+24BF	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER J
Ｊ	U+FF2A	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER J
🄙	U+1F119	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER J
🄹	U+1F139	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER J
🅙	U+1F159	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER J
🅹	U+1F179	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER J
󠁊	U+E004A	[Format]	TAG LATIN CAPITAL LETTER J
k	U+6B	[LowercaseLetter]	LATIN SMALL LETTER K
ķ	U+137	[LowercaseLetter]	LATIN SMALL LETTER K WITH CEDILLA
ƙ	U+199	[LowercaseLetter]	LATIN SMALL LETTER K WITH HOOK
ǩ	U+1E9	[LowercaseLetter]	LATIN SMALL LETTER K WITH CARON
ᶄ	U+1D84	[LowercaseLetter]	LATIN SMALL LETTER K WITH PALATAL HOOK
ᷜ	U+1DDC	[NonspacingMark]	COMBINING LATIN SMALL LETTER K
ḱ	U+1E31	[LowercaseLetter]	LATIN SMALL LETTER K WITH ACUTE
ḳ	U+1E33	[LowercaseLetter]	LATIN SMALL LETTER K WITH DOT BELOW
ḵ	U+1E35	[LowercaseLetter]	LATIN SMALL LETTER K WITH LINE BELOW
ₖ	U+2096	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER K
⒦	U+24A6	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER K
ⓚ	U+24DA	[OtherSymbol]	CIRCLED LATIN SMALL LETTER K
ⱪ	U+2C6A	[LowercaseLetter]	LATIN SMALL LETTER K WITH DESCENDER
ꝁ	U+A741	[LowercaseLetter]	LATIN SMALL LETTER K WITH STROKE
ꝃ	U+A743	[LowercaseLetter]	LATIN SMALL LETTER K WITH DIAGONAL STROKE
ꝅ	U+A745	[LowercaseLetter]	LATIN SMALL LETTER K WITH STROKE AND DIAGONAL STROKE
ꞣ	U+A7A3	[LowercaseLetter]	LATIN SMALL LETTER K WITH OBLIQUE STROKE
ｋ	U+FF4B	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER K
󠁫	U+E006B	[Format]	TAG LATIN SMALL LETTER K
K	U+4B	[UppercaseLetter]	LATIN CAPITAL LETTER K
Ķ	U+136	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH CEDILLA
Ƙ	U+198	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH HOOK
Ǩ	U+1E8	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH CARON
Ḱ	U+1E30	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH ACUTE
Ḳ	U+1E32	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH DOT BELOW
Ḵ	U+1E34	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH LINE BELOW
Ⓚ	U+24C0	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER K
Ⱪ	U+2C69	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH DESCENDER
Ꝁ	U+A740	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH STROKE
Ꝃ	U+A742	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH DIAGONAL STROKE
Ꝅ	U+A744	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH STROKE AND DIAGONAL STROKE
Ꞣ	U+A7A2	[UppercaseLetter]	LATIN CAPITAL LETTER K WITH OBLIQUE STROKE
Ｋ	U+FF2B	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER K
🄚	U+1F11A	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER K
🄺	U+1F13A	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER K
🅚	U+1F15A	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER K
🅺	U+1F17A	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER K
󠁋	U+E004B	[Format]	TAG LATIN CAPITAL LETTER K
l	U+6C	[LowercaseLetter]	LATIN SMALL LETTER L
ĺ	U+13A	[LowercaseLetter]	LATIN SMALL LETTER L WITH ACUTE
ļ	U+13C	[LowercaseLetter]	LATIN SMALL LETTER L WITH CEDILLA
ľ	U+13E	[LowercaseLetter]	LATIN SMALL LETTER L WITH CARON
ŀ	U+140	[LowercaseLetter]	LATIN SMALL LETTER L WITH MIDDLE DOT
ł	U+142	[LowercaseLetter]	LATIN SMALL LETTER L WITH STROKE
ƚ	U+19A	[LowercaseLetter]	LATIN SMALL LETTER L WITH BAR
ȴ	U+234	[LowercaseLetter]	LATIN SMALL LETTER L WITH CURL
ɫ	U+26B	[LowercaseLetter]	LATIN SMALL LETTER L WITH MIDDLE TILDE
ɬ	U+26C	[LowercaseLetter]	LATIN SMALL LETTER L WITH BELT
ɭ	U+26D	[LowercaseLetter]	LATIN SMALL LETTER L WITH RETROFLEX HOOK
ᶅ	U+1D85	[LowercaseLetter]	LATIN SMALL LETTER L WITH PALATAL HOOK
ᷝ	U+1DDD	[NonspacingMark]	COMBINING LATIN SMALL LETTER L
ḷ	U+1E37	[LowercaseLetter]	LATIN SMALL LETTER L WITH DOT BELOW
ḹ	U+1E39	[LowercaseLetter]	LATIN SMALL LETTER L WITH DOT BELOW AND MACRON
ḻ	U+1E3B	[LowercaseLetter]	LATIN SMALL LETTER L WITH LINE BELOW
ḽ	U+1E3D	[LowercaseLetter]	LATIN SMALL LETTER L WITH CIRCUMFLEX BELOW
ₗ	U+2097	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER L
⒧	U+24A7	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER L
ⓛ	U+24DB	[OtherSymbol]	CIRCLED LATIN SMALL LETTER L
ⱡ	U+2C61	[LowercaseLetter]	LATIN SMALL LETTER L WITH DOUBLE BAR
ⳑ	U+2CD1	[LowercaseLetter]	COPTIC SMALL LETTER L-SHAPED HA
ꝉ	U+A749	[LowercaseLetter]	LATIN SMALL LETTER L WITH HIGH STROKE
ꞎ	U+A78E	[LowercaseLetter]	LATIN SMALL LETTER L WITH RETROFLEX HOOK AND BELT
ｌ	U+FF4C	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER L
󠁬	U+E006C	[Format]	TAG LATIN SMALL LETTER L
L	U+4C	[UppercaseLetter]	LATIN CAPITAL LETTER L
Ĺ	U+139	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH ACUTE
Ļ	U+13B	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH CEDILLA
Ľ	U+13D	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH CARON
Ŀ	U+13F	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH MIDDLE DOT
Ł	U+141	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH STROKE
ǈ	U+1C8	[TitlecaseLetter]	LATIN CAPITAL LETTER L WITH SMALL LETTER J
Ƚ	U+23D	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH BAR
Ḷ	U+1E36	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH DOT BELOW
Ḹ	U+1E38	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH DOT BELOW AND MACRON
Ḻ	U+1E3A	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH LINE BELOW
Ḽ	U+1E3C	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH CIRCUMFLEX BELOW
Ⓛ	U+24C1	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER L
Ⱡ	U+2C60	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH DOUBLE BAR
Ɫ	U+2C62	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH MIDDLE TILDE
Ⳑ	U+2CD0	[UppercaseLetter]	COPTIC CAPITAL LETTER L-SHAPED HA
Ꝉ	U+A748	[UppercaseLetter]	LATIN CAPITAL LETTER L WITH HIGH STROKE
Ｌ	U+FF2C	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER L
🄛	U+1F11B	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER L
🄻	U+1F13B	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER L
🅛	U+1F15B	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER L
🅻	U+1F17B	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER L
󠁌	U+E004C	[Format]	TAG LATIN CAPITAL LETTER L
m	U+6D	[LowercaseLetter]	LATIN SMALL LETTER M
ɱ	U+271	[LowercaseLetter]	LATIN SMALL LETTER M WITH HOOK
ͫ	U+36B	[NonspacingMark]	COMBINING LATIN SMALL LETTER M
ᵯ	U+1D6F	[LowercaseLetter]	LATIN SMALL LETTER M WITH MIDDLE TILDE
ᶆ	U+1D86	[LowercaseLetter]	LATIN SMALL LETTER M WITH PALATAL HOOK
ḿ	U+1E3F	[LowercaseLetter]	LATIN SMALL LETTER M WITH ACUTE
ṁ	U+1E41	[LowercaseLetter]	LATIN SMALL LETTER M WITH DOT ABOVE
ṃ	U+1E43	[LowercaseLetter]	LATIN SMALL LETTER M WITH DOT BELOW
ₘ	U+2098	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER M
⒨	U+24A8	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER M
ⓜ	U+24DC	[OtherSymbol]	CIRCLED LATIN SMALL LETTER M
ｍ	U+FF4D	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER M
󠁭	U+E006D	[Format]	TAG LATIN SMALL LETTER M
M	U+4D	[UppercaseLetter]	LATIN CAPITAL LETTER M
Ḿ	U+1E3E	[UppercaseLetter]	LATIN CAPITAL LETTER M WITH ACUTE
Ṁ	U+1E40	[UppercaseLetter]	LATIN CAPITAL LETTER M WITH DOT ABOVE
Ṃ	U+1E42	[UppercaseLetter]	LATIN CAPITAL LETTER M WITH DOT BELOW
Ⓜ	U+24C2	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER M
Ɱ	U+2C6E	[UppercaseLetter]	LATIN CAPITAL LETTER M WITH HOOK
Ｍ	U+FF2D	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER M
🄜	U+1F11C	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER M
🄼	U+1F13C	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER M
🅜	U+1F15C	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER M
🅼	U+1F17C	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER M
󠁍	U+E004D	[Format]	TAG LATIN CAPITAL LETTER M
n	U+6E	[LowercaseLetter]	LATIN SMALL LETTER N
ñ	U+F1	[LowercaseLetter]	LATIN SMALL LETTER N WITH TILDE
ń	U+144	[LowercaseLetter]	LATIN SMALL LETTER N WITH ACUTE
ņ	U+146	[LowercaseLetter]	LATIN SMALL LETTER N WITH CEDILLA
ň	U+148	[LowercaseLetter]	LATIN SMALL LETTER N WITH CARON
ŉ	U+149	[LowercaseLetter]	LATIN SMALL LETTER N PRECEDED BY APOSTROPHE
ƞ	U+19E	[LowercaseLetter]	LATIN SMALL LETTER N WITH LONG RIGHT LEG
ǹ	U+1F9	[LowercaseLetter]	LATIN SMALL LETTER N WITH GRAVE
ȵ	U+235	[LowercaseLetter]	LATIN SMALL LETTER N WITH CURL
ɲ	U+272	[LowercaseLetter]	LATIN SMALL LETTER N WITH LEFT HOOK
ɳ	U+273	[LowercaseLetter]	LATIN SMALL LETTER N WITH RETROFLEX HOOK
ᵰ	U+1D70	[LowercaseLetter]	LATIN SMALL LETTER N WITH MIDDLE TILDE
ᶇ	U+1D87	[LowercaseLetter]	LATIN SMALL LETTER N WITH PALATAL HOOK
ᷠ	U+1DE0	[NonspacingMark]	COMBINING LATIN SMALL LETTER N
ṅ	U+1E45	[LowercaseLetter]	LATIN SMALL LETTER N WITH DOT ABOVE
ṇ	U+1E47	[LowercaseLetter]	LATIN SMALL LETTER N WITH DOT BELOW
ṉ	U+1E49	[LowercaseLetter]	LATIN SMALL LETTER N WITH LINE BELOW
ṋ	U+1E4B	[LowercaseLetter]	LATIN SMALL LETTER N WITH CIRCUMFLEX BELOW
ⁿ	U+207F	[ModifierLetter]	SUPERSCRIPT LATIN SMALL LETTER N
ₙ	U+2099	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER N
⒩	U+24A9	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER N
ⓝ	U+24DD	[OtherSymbol]	CIRCLED LATIN SMALL LETTER N
ꞑ	U+A791	[LowercaseLetter]	LATIN SMALL LETTER N WITH DESCENDER
ꞥ	U+A7A5	[LowercaseLetter]	LATIN SMALL LETTER N WITH OBLIQUE STROKE
ｎ	U+FF4E	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER N
󠁮	U+E006E	[Format]	TAG LATIN SMALL LETTER N
N	U+4E	[UppercaseLetter]	LATIN CAPITAL LETTER N
Ñ	U+D1	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH TILDE
Ń	U+143	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH ACUTE
Ņ	U+145	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH CEDILLA
Ň	U+147	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH CARON
Ɲ	U+19D	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH LEFT HOOK
ǋ	U+1CB	[TitlecaseLetter]	LATIN CAPITAL LETTER N WITH SMALL LETTER J
Ǹ	U+1F8	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH GRAVE
Ƞ	U+220	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH LONG RIGHT LEG
Ṅ	U+1E44	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH DOT ABOVE
Ṇ	U+1E46	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH DOT BELOW
Ṉ	U+1E48	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH LINE BELOW
Ṋ	U+1E4A	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH CIRCUMFLEX BELOW
Ⓝ	U+24C3	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER N
Ꞑ	U+A790	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH DESCENDER
Ꞥ	U+A7A4	[UppercaseLetter]	LATIN CAPITAL LETTER N WITH OBLIQUE STROKE
Ｎ	U+FF2E	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER N
🄝	U+1F11D	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER N
🄽	U+1F13D	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER N
🅝	U+1F15D	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER N
🅽	U+1F17D	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER N
󠁎	U+E004E	[Format]	TAG LATIN CAPITAL LETTER N
o	U+6F	[LowercaseLetter]	LATIN SMALL LETTER O
ò	U+F2	[LowercaseLetter]	LATIN SMALL LETTER O WITH GRAVE
ó	U+F3	[LowercaseLetter]	LATIN SMALL LETTER O WITH ACUTE
ô	U+F4	[LowercaseLetter]	LATIN SMALL LETTER O WITH CIRCUMFLEX
õ	U+F5	[LowercaseLetter]	LATIN SMALL LETTER O WITH TILDE
ö	U+F6	[LowercaseLetter]	LATIN SMALL LETTER O WITH DIAERESIS
ø	U+F8	[LowercaseLetter]	LATIN SMALL LETTER O WITH STROKE
ō	U+14D	[LowercaseLetter]	LATIN SMALL LETTER O WITH MACRON
ŏ	U+14F	[LowercaseLetter]	LATIN SMALL LETTER O WITH BREVE
ő	U+151	[LowercaseLetter]	LATIN SMALL LETTER O WITH DOUBLE ACUTE
ơ	U+1A1	[LowercaseLetter]	LATIN SMALL LETTER O WITH HORN
ǒ	U+1D2	[LowercaseLetter]	LATIN SMALL LETTER O WITH CARON
ǫ	U+1EB	[LowercaseLetter]	LATIN SMALL LETTER O WITH OGONEK
ǭ	U+1ED	[LowercaseLetter]	LATIN SMALL LETTER O WITH OGONEK AND MACRON
ǿ	U+1FF	[LowercaseLetter]	LATIN SMALL LETTER O WITH STROKE AND ACUTE
ȍ	U+20D	[LowercaseLetter]	LATIN SMALL LETTER O WITH DOUBLE GRAVE
ȏ	U+20F	[LowercaseLetter]	LATIN SMALL LETTER O WITH INVERTED BREVE
ȫ	U+22B	[LowercaseLetter]	LATIN SMALL LETTER O WITH DIAERESIS AND MACRON
ȭ	U+22D	[LowercaseLetter]	LATIN SMALL LETTER O WITH TILDE AND MACRON
ȯ	U+22F	[LowercaseLetter]	LATIN SMALL LETTER O WITH DOT ABOVE
ȱ	U+231	[LowercaseLetter]	LATIN SMALL LETTER O WITH DOT ABOVE AND MACRON
ͦ	U+366	[NonspacingMark]	COMBINING LATIN SMALL LETTER O
о	U+43E	[LowercaseLetter]	CYRILLIC SMALL LETTER O
ӧ	U+4E7	[LowercaseLetter]	CYRILLIC SMALL LETTER O WITH DIAERESIS
ṍ	U+1E4D	[LowercaseLetter]	LATIN SMALL LETTER O WITH TILDE AND ACUTE
ṏ	U+1E4F	[LowercaseLetter]	LATIN SMALL LETTER O WITH TILDE AND DIAERESIS
ṑ	U+1E51	[LowercaseLetter]	LATIN SMALL LETTER O WITH MACRON AND GRAVE
ṓ	U+1E53	[LowercaseLetter]	LATIN SMALL LETTER O WITH MACRON AND ACUTE
ọ	U+1ECD	[LowercaseLetter]	LATIN SMALL LETTER O WITH DOT BELOW
ỏ	U+1ECF	[LowercaseLetter]	LATIN SMALL LETTER O WITH HOOK ABOVE
ố	U+1ED1	[LowercaseLetter]	LATIN SMALL LETTER O WITH CIRCUMFLEX AND ACUTE
ồ	U+1ED3	[LowercaseLetter]	LATIN SMALL LETTER O WITH CIRCUMFLEX AND GRAVE
ổ	U+1ED5	[LowercaseLetter]	LATIN SMALL LETTER O WITH CIRCUMFLEX AND HOOK ABOVE
ỗ	U+1ED7	[LowercaseLetter]	LATIN SMALL LETTER O WITH CIRCUMFLEX AND TILDE
ộ	U+1ED9	[LowercaseLetter]	LATIN SMALL LETTER O WITH CIRCUMFLEX AND DOT BELOW
ớ	U+1EDB	[LowercaseLetter]	LATIN SMALL LETTER O WITH HORN AND ACUTE
ờ	U+1EDD	[LowercaseLetter]	LATIN SMALL LETTER O WITH HORN AND GRAVE
ở	U+1EDF	[LowercaseLetter]	LATIN SMALL LETTER O WITH HORN AND HOOK ABOVE
ỡ	U+1EE1	[LowercaseLetter]	LATIN SMALL LETTER O WITH HORN AND TILDE
ợ	U+1EE3	[LowercaseLetter]	LATIN SMALL LETTER O WITH HORN AND DOT BELOW
ₒ	U+2092	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER O
⒪	U+24AA	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER O
ⓞ	U+24DE	[OtherSymbol]	CIRCLED LATIN SMALL LETTER O
ⱺ	U+2C7A	[LowercaseLetter]	LATIN SMALL LETTER O WITH LOW RING INSIDE
ⲟ	U+2C9F	[LowercaseLetter]	COPTIC SMALL LETTER O
ꝋ	U+A74B	[LowercaseLetter]	LATIN SMALL LETTER O WITH LONG STROKE OVERLAY
ꝍ	U+A74D	[LowercaseLetter]	LATIN SMALL LETTER O WITH LOOP
ｏ	U+FF4F	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER O
󠁯	U+E006F	[Format]	TAG LATIN SMALL LETTER O
O	U+4F	[UppercaseLetter]	LATIN CAPITAL LETTER O
Ò	U+D2	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH GRAVE
Ó	U+D3	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH ACUTE
Ô	U+D4	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CIRCUMFLEX
Õ	U+D5	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH TILDE
Ö	U+D6	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DIAERESIS
Ø	U+D8	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH STROKE
Ō	U+14C	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH MACRON
Ŏ	U+14E	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH BREVE
Ő	U+150	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DOUBLE ACUTE
Ɵ	U+19F	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH MIDDLE TILDE
Ơ	U+1A0	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HORN
Ǒ	U+1D1	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CARON
Ǫ	U+1EA	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH OGONEK
Ǭ	U+1EC	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH OGONEK AND MACRON
Ǿ	U+1FE	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH STROKE AND ACUTE
Ȍ	U+20C	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DOUBLE GRAVE
Ȏ	U+20E	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH INVERTED BREVE
Ȫ	U+22A	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DIAERESIS AND MACRON
Ȭ	U+22C	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH TILDE AND MACRON
Ȯ	U+22E	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DOT ABOVE
Ȱ	U+230	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DOT ABOVE AND MACRON
О	U+41E	[UppercaseLetter]	CYRILLIC CAPITAL LETTER O
Ӧ	U+4E6	[UppercaseLetter]	CYRILLIC CAPITAL LETTER O WITH DIAERESIS
Ṍ	U+1E4C	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH TILDE AND ACUTE
Ṏ	U+1E4E	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH TILDE AND DIAERESIS
Ṑ	U+1E50	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH MACRON AND GRAVE
Ṓ	U+1E52	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH MACRON AND ACUTE
Ọ	U+1ECC	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH DOT BELOW
Ỏ	U+1ECE	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HOOK ABOVE
Ố	U+1ED0	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND ACUTE
Ồ	U+1ED2	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND GRAVE
Ổ	U+1ED4	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND HOOK ABOVE
Ỗ	U+1ED6	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND TILDE
Ộ	U+1ED8	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH CIRCUMFLEX AND DOT BELOW
Ớ	U+1EDA	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HORN AND ACUTE
Ờ	U+1EDC	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HORN AND GRAVE
Ở	U+1EDE	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HORN AND HOOK ABOVE
Ỡ	U+1EE0	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HORN AND TILDE
Ợ	U+1EE2	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH HORN AND DOT BELOW
Ⓞ	U+24C4	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER O
Ⲟ	U+2C9E	[UppercaseLetter]	COPTIC CAPITAL LETTER O
Ꝋ	U+A74A	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH LONG STROKE OVERLAY
Ꝍ	U+A74C	[UppercaseLetter]	LATIN CAPITAL LETTER O WITH LOOP
Ｏ	U+FF2F	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER O
🄞	U+1F11E	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER O
🄾	U+1F13E	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER O
🅞	U+1F15E	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER O
🅾	U+1F17E	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER O
󠁏	U+E004F	[Format]	TAG LATIN CAPITAL LETTER O
p	U+70	[LowercaseLetter]	LATIN SMALL LETTER P
ƥ	U+1A5	[LowercaseLetter]	LATIN SMALL LETTER P WITH HOOK
ᵱ	U+1D71	[LowercaseLetter]	LATIN SMALL LETTER P WITH MIDDLE TILDE
ᵽ	U+1D7D	[LowercaseLetter]	LATIN SMALL LETTER P WITH STROKE
ᶈ	U+1D88	[LowercaseLetter]	LATIN SMALL LETTER P WITH PALATAL HOOK
ṕ	U+1E55	[LowercaseLetter]	LATIN SMALL LETTER P WITH ACUTE
ṗ	U+1E57	[LowercaseLetter]	LATIN SMALL LETTER P WITH DOT ABOVE
ₚ	U+209A	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER P
⒫	U+24AB	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER P
ⓟ	U+24DF	[OtherSymbol]	CIRCLED LATIN SMALL LETTER P
ꝑ	U+A751	[LowercaseLetter]	LATIN SMALL LETTER P WITH STROKE THROUGH DESCENDER
ꝓ	U+A753	[LowercaseLetter]	LATIN SMALL LETTER P WITH FLOURISH
ꝕ	U+A755	[LowercaseLetter]	LATIN SMALL LETTER P WITH SQUIRREL TAIL
ｐ	U+FF50	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER P
󠁰	U+E0070	[Format]	TAG LATIN SMALL LETTER P
P	U+50	[UppercaseLetter]	LATIN CAPITAL LETTER P
Ƥ	U+1A4	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH HOOK
Ṕ	U+1E54	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH ACUTE
Ṗ	U+1E56	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH DOT ABOVE
Ⓟ	U+24C5	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER P
Ᵽ	U+2C63	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH STROKE
Ꝑ	U+A750	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH STROKE THROUGH DESCENDER
Ꝓ	U+A752	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH FLOURISH
Ꝕ	U+A754	[UppercaseLetter]	LATIN CAPITAL LETTER P WITH SQUIRREL TAIL
Ｐ	U+FF30	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER P
🄟	U+1F11F	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER P
🄿	U+1F13F	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER P
🅟	U+1F15F	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER P
🅿	U+1F17F	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER P
🆊	U+1F18A	[OtherSymbol]	CROSSED NEGATIVE SQUARED LATIN CAPITAL LETTER P
󠁐	U+E0050	[Format]	TAG LATIN CAPITAL LETTER P
q	U+71	[LowercaseLetter]	LATIN SMALL LETTER Q
ɋ	U+24B	[LowercaseLetter]	LATIN SMALL LETTER Q WITH HOOK TAIL
ʠ	U+2A0	[LowercaseLetter]	LATIN SMALL LETTER Q WITH HOOK
⒬	U+24AC	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER Q
ⓠ	U+24E0	[OtherSymbol]	CIRCLED LATIN SMALL LETTER Q
ꝗ	U+A757	[LowercaseLetter]	LATIN SMALL LETTER Q WITH STROKE THROUGH DESCENDER
ꝙ	U+A759	[LowercaseLetter]	LATIN SMALL LETTER Q WITH DIAGONAL STROKE
ｑ	U+FF51	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER Q
󠁱	U+E0071	[Format]	TAG LATIN SMALL LETTER Q
Q	U+51	[UppercaseLetter]	LATIN CAPITAL LETTER Q
Ⓠ	U+24C6	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER Q
Ꝗ	U+A756	[UppercaseLetter]	LATIN CAPITAL LETTER Q WITH STROKE THROUGH DESCENDER
Ꝙ	U+A758	[UppercaseLetter]	LATIN CAPITAL LETTER Q WITH DIAGONAL STROKE
Ｑ	U+FF31	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER Q
🄠	U+1F120	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER Q
🅀	U+1F140	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER Q
🅠	U+1F160	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER Q
🆀	U+1F180	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER Q
󠁑	U+E0051	[Format]	TAG LATIN CAPITAL LETTER Q
r	U+72	[LowercaseLetter]	LATIN SMALL LETTER R
ŕ	U+155	[LowercaseLetter]	LATIN SMALL LETTER R WITH ACUTE
ŗ	U+157	[LowercaseLetter]	LATIN SMALL LETTER R WITH CEDILLA
ř	U+159	[LowercaseLetter]	LATIN SMALL LETTER R WITH CARON
ȑ	U+211	[LowercaseLetter]	LATIN SMALL LETTER R WITH DOUBLE GRAVE
ȓ	U+213	[LowercaseLetter]	LATIN SMALL LETTER R WITH INVERTED BREVE
ɍ	U+24D	[LowercaseLetter]	LATIN SMALL LETTER R WITH STROKE
ɼ	U+27C	[LowercaseLetter]	LATIN SMALL LETTER R WITH LONG LEG
ɽ	U+27D	[LowercaseLetter]	LATIN SMALL LETTER R WITH TAIL
ɾ	U+27E	[LowercaseLetter]	LATIN SMALL LETTER R WITH FISHHOOK
ͬ	U+36C	[NonspacingMark]	COMBINING LATIN SMALL LETTER R
ᵣ	U+1D63	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER R
ᵲ	U+1D72	[LowercaseLetter]	LATIN SMALL LETTER R WITH MIDDLE TILDE
ᵳ	U+1D73	[LowercaseLetter]	LATIN SMALL LETTER R WITH FISHHOOK AND MIDDLE TILDE
ᶉ	U+1D89	[LowercaseLetter]	LATIN SMALL LETTER R WITH PALATAL HOOK
᷊	U+1DCA	[NonspacingMark]	COMBINING LATIN SMALL LETTER R BELOW
ᷣ	U+1DE3	[NonspacingMark]	COMBINING LATIN SMALL LETTER R ROTUNDA
ṙ	U+1E59	[LowercaseLetter]	LATIN SMALL LETTER R WITH DOT ABOVE
ṛ	U+1E5B	[LowercaseLetter]	LATIN SMALL LETTER R WITH DOT BELOW
ṝ	U+1E5D	[LowercaseLetter]	LATIN SMALL LETTER R WITH DOT BELOW AND MACRON
ṟ	U+1E5F	[LowercaseLetter]	LATIN SMALL LETTER R WITH LINE BELOW
⒭	U+24AD	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER R
ⓡ	U+24E1	[OtherSymbol]	CIRCLED LATIN SMALL LETTER R
ꝛ	U+A75B	[LowercaseLetter]	LATIN SMALL LETTER R ROTUNDA
ꞧ	U+A7A7	[LowercaseLetter]	LATIN SMALL LETTER R WITH OBLIQUE STROKE
ｒ	U+FF52	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER R
󠁲	U+E0072	[Format]	TAG LATIN SMALL LETTER R
R	U+52	[UppercaseLetter]	LATIN CAPITAL LETTER R
Ŕ	U+154	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH ACUTE
Ŗ	U+156	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH CEDILLA
Ř	U+158	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH CARON
Ȑ	U+210	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH DOUBLE GRAVE
Ȓ	U+212	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH INVERTED BREVE
Ɍ	U+24C	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH STROKE
Ṙ	U+1E58	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH DOT ABOVE
Ṛ	U+1E5A	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH DOT BELOW
Ṝ	U+1E5C	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH DOT BELOW AND MACRON
Ṟ	U+1E5E	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH LINE BELOW
Ⓡ	U+24C7	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER R
Ɽ	U+2C64	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH TAIL
Ꝛ	U+A75A	[UppercaseLetter]	LATIN CAPITAL LETTER R ROTUNDA
Ꞧ	U+A7A6	[UppercaseLetter]	LATIN CAPITAL LETTER R WITH OBLIQUE STROKE
Ｒ	U+FF32	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER R
🄡	U+1F121	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER R
🄬	U+1F12C	[OtherSymbol]	CIRCLED ITALIC LATIN CAPITAL LETTER R
🅁	U+1F141	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER R
🅡	U+1F161	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER R
🆁	U+1F181	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER R
󠁒	U+E0052	[Format]	TAG LATIN CAPITAL LETTER R
s	U+73	[LowercaseLetter]	LATIN SMALL LETTER S
ś	U+15B	[LowercaseLetter]	LATIN SMALL LETTER S WITH ACUTE
ŝ	U+15D	[LowercaseLetter]	LATIN SMALL LETTER S WITH CIRCUMFLEX
ş	U+15F	[LowercaseLetter]	LATIN SMALL LETTER S WITH CEDILLA
š	U+161	[LowercaseLetter]	LATIN SMALL LETTER S WITH CARON
ș	U+219	[LowercaseLetter]	LATIN SMALL LETTER S WITH COMMA BELOW
ȿ	U+23F	[LowercaseLetter]	LATIN SMALL LETTER S WITH SWASH TAIL
ʂ	U+282	[LowercaseLetter]	LATIN SMALL LETTER S WITH HOOK
ᵴ	U+1D74	[LowercaseLetter]	LATIN SMALL LETTER S WITH MIDDLE TILDE
ᶊ	U+1D8A	[LowercaseLetter]	LATIN SMALL LETTER S WITH PALATAL HOOK
ᷤ	U+1DE4	[NonspacingMark]	COMBINING LATIN SMALL LETTER S
ṡ	U+1E61	[LowercaseLetter]	LATIN SMALL LETTER S WITH DOT ABOVE
ṣ	U+1E63	[LowercaseLetter]	LATIN SMALL LETTER S WITH DOT BELOW
ṥ	U+1E65	[LowercaseLetter]	LATIN SMALL LETTER S WITH ACUTE AND DOT ABOVE
ṧ	U+1E67	[LowercaseLetter]	LATIN SMALL LETTER S WITH CARON AND DOT ABOVE
ṩ	U+1E69	[LowercaseLetter]	LATIN SMALL LETTER S WITH DOT BELOW AND DOT ABOVE
ₛ	U+209B	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER S
⒮	U+24AE	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER S
ⓢ	U+24E2	[OtherSymbol]	CIRCLED LATIN SMALL LETTER S
ꞩ	U+A7A9	[LowercaseLetter]	LATIN SMALL LETTER S WITH OBLIQUE STROKE
ｓ	U+FF53	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER S
󠁳	U+E0073	[Format]	TAG LATIN SMALL LETTER S
S	U+53	[UppercaseLetter]	LATIN CAPITAL LETTER S
Ś	U+15A	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH ACUTE
Ŝ	U+15C	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH CIRCUMFLEX
Ş	U+15E	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH CEDILLA
Š	U+160	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH CARON
Ș	U+218	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH COMMA BELOW
Ṡ	U+1E60	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH DOT ABOVE
Ṣ	U+1E62	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH DOT BELOW
Ṥ	U+1E64	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH ACUTE AND DOT ABOVE
Ṧ	U+1E66	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH CARON AND DOT ABOVE
Ṩ	U+1E68	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH DOT BELOW AND DOT ABOVE
Ⓢ	U+24C8	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER S
Ȿ	U+2C7E	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH SWASH TAIL
Ꞩ	U+A7A8	[UppercaseLetter]	LATIN CAPITAL LETTER S WITH OBLIQUE STROKE
Ｓ	U+FF33	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER S
🄢	U+1F122	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER S
🄪	U+1F12A	[OtherSymbol]	TORTOISE SHELL BRACKETED LATIN CAPITAL LETTER S
🅂	U+1F142	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER S
🅢	U+1F162	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER S
🆂	U+1F182	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER S
󠁓	U+E0053	[Format]	TAG LATIN CAPITAL LETTER S
t	U+74	[LowercaseLetter]	LATIN SMALL LETTER T
ţ	U+163	[LowercaseLetter]	LATIN SMALL LETTER T WITH CEDILLA
ť	U+165	[LowercaseLetter]	LATIN SMALL LETTER T WITH CARON
ŧ	U+167	[LowercaseLetter]	LATIN SMALL LETTER T WITH STROKE
ƫ	U+1AB	[LowercaseLetter]	LATIN SMALL LETTER T WITH PALATAL HOOK
ƭ	U+1AD	[LowercaseLetter]	LATIN SMALL LETTER T WITH HOOK
ț	U+21B	[LowercaseLetter]	LATIN SMALL LETTER T WITH COMMA BELOW
ȶ	U+236	[LowercaseLetter]	LATIN SMALL LETTER T WITH CURL
ʈ	U+288	[LowercaseLetter]	LATIN SMALL LETTER T WITH RETROFLEX HOOK
ͭ	U+36D	[NonspacingMark]	COMBINING LATIN SMALL LETTER T
ᵵ	U+1D75	[LowercaseLetter]	LATIN SMALL LETTER T WITH MIDDLE TILDE
ṫ	U+1E6B	[LowercaseLetter]	LATIN SMALL LETTER T WITH DOT ABOVE
ṭ	U+1E6D	[LowercaseLetter]	LATIN SMALL LETTER T WITH DOT BELOW
ṯ	U+1E6F	[LowercaseLetter]	LATIN SMALL LETTER T WITH LINE BELOW
ṱ	U+1E71	[LowercaseLetter]	LATIN SMALL LETTER T WITH CIRCUMFLEX BELOW
ẗ	U+1E97	[LowercaseLetter]	LATIN SMALL LETTER T WITH DIAERESIS
ₜ	U+209C	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER T
⒯	U+24AF	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER T
ⓣ	U+24E3	[OtherSymbol]	CIRCLED LATIN SMALL LETTER T
ⱦ	U+2C66	[LowercaseLetter]	LATIN SMALL LETTER T WITH DIAGONAL STROKE
ｔ	U+FF54	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER T
󠁴	U+E0074	[Format]	TAG LATIN SMALL LETTER T
T	U+54	[UppercaseLetter]	LATIN CAPITAL LETTER T
Ţ	U+162	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH CEDILLA
Ť	U+164	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH CARON
Ŧ	U+166	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH STROKE
Ƭ	U+1AC	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH HOOK
Ʈ	U+1AE	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH RETROFLEX HOOK
Ț	U+21A	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH COMMA BELOW
Ⱦ	U+23E	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH DIAGONAL STROKE
Ṫ	U+1E6A	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH DOT ABOVE
Ṭ	U+1E6C	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH DOT BELOW
Ṯ	U+1E6E	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH LINE BELOW
Ṱ	U+1E70	[UppercaseLetter]	LATIN CAPITAL LETTER T WITH CIRCUMFLEX BELOW
Ⓣ	U+24C9	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER T
Ｔ	U+FF34	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER T
🄣	U+1F123	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER T
🅃	U+1F143	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER T
🅣	U+1F163	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER T
🆃	U+1F183	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER T
󠁔	U+E0054	[Format]	TAG LATIN CAPITAL LETTER T
u	U+75	[LowercaseLetter]	LATIN SMALL LETTER U
ù	U+F9	[LowercaseLetter]	LATIN SMALL LETTER U WITH GRAVE
ú	U+FA	[LowercaseLetter]	LATIN SMALL LETTER U WITH ACUTE
û	U+FB	[LowercaseLetter]	LATIN SMALL LETTER U WITH CIRCUMFLEX
ü	U+FC	[LowercaseLetter]	LATIN SMALL LETTER U WITH DIAERESIS
ũ	U+169	[LowercaseLetter]	LATIN SMALL LETTER U WITH TILDE
ū	U+16B	[LowercaseLetter]	LATIN SMALL LETTER U WITH MACRON
ŭ	U+16D	[LowercaseLetter]	LATIN SMALL LETTER U WITH BREVE
ů	U+16F	[LowercaseLetter]	LATIN SMALL LETTER U WITH RING ABOVE
ű	U+171	[LowercaseLetter]	LATIN SMALL LETTER U WITH DOUBLE ACUTE
ų	U+173	[LowercaseLetter]	LATIN SMALL LETTER U WITH OGONEK
ư	U+1B0	[LowercaseLetter]	LATIN SMALL LETTER U WITH HORN
ǔ	U+1D4	[LowercaseLetter]	LATIN SMALL LETTER U WITH CARON
ǖ	U+1D6	[LowercaseLetter]	LATIN SMALL LETTER U WITH DIAERESIS AND MACRON
ǘ	U+1D8	[LowercaseLetter]	LATIN SMALL LETTER U WITH DIAERESIS AND ACUTE
ǚ	U+1DA	[LowercaseLetter]	LATIN SMALL LETTER U WITH DIAERESIS AND CARON
ǜ	U+1DC	[LowercaseLetter]	LATIN SMALL LETTER U WITH DIAERESIS AND GRAVE
ȕ	U+215	[LowercaseLetter]	LATIN SMALL LETTER U WITH DOUBLE GRAVE
ȗ	U+217	[LowercaseLetter]	LATIN SMALL LETTER U WITH INVERTED BREVE
ʉ	U+289	[LowercaseLetter]	LATIN SMALL LETTER U BAR
ͧ	U+367	[NonspacingMark]	COMBINING LATIN SMALL LETTER U
у	U+443	[LowercaseLetter]	CYRILLIC SMALL LETTER U
ӯ	U+4EF	[LowercaseLetter]	CYRILLIC SMALL LETTER U WITH MACRON
ӱ	U+4F1	[LowercaseLetter]	CYRILLIC SMALL LETTER U WITH DIAERESIS
ӳ	U+4F3	[LowercaseLetter]	CYRILLIC SMALL LETTER U WITH DOUBLE ACUTE
ᵤ	U+1D64	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER U
ᶙ	U+1D99	[LowercaseLetter]	LATIN SMALL LETTER U WITH RETROFLEX HOOK
ṳ	U+1E73	[LowercaseLetter]	LATIN SMALL LETTER U WITH DIAERESIS BELOW
ṵ	U+1E75	[LowercaseLetter]	LATIN SMALL LETTER U WITH TILDE BELOW
ṷ	U+1E77	[LowercaseLetter]	LATIN SMALL LETTER U WITH CIRCUMFLEX BELOW
ṹ	U+1E79	[LowercaseLetter]	LATIN SMALL LETTER U WITH TILDE AND ACUTE
ṻ	U+1E7B	[LowercaseLetter]	LATIN SMALL LETTER U WITH MACRON AND DIAERESIS
ụ	U+1EE5	[LowercaseLetter]	LATIN SMALL LETTER U WITH DOT BELOW
ủ	U+1EE7	[LowercaseLetter]	LATIN SMALL LETTER U WITH HOOK ABOVE
ứ	U+1EE9	[LowercaseLetter]	LATIN SMALL LETTER U WITH HORN AND ACUTE
ừ	U+1EEB	[LowercaseLetter]	LATIN SMALL LETTER U WITH HORN AND GRAVE
ử	U+1EED	[LowercaseLetter]	LATIN SMALL LETTER U WITH HORN AND HOOK ABOVE
ữ	U+1EEF	[LowercaseLetter]	LATIN SMALL LETTER U WITH HORN AND TILDE
ự	U+1EF1	[LowercaseLetter]	LATIN SMALL LETTER U WITH HORN AND DOT BELOW
⒰	U+24B0	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER U
ⓤ	U+24E4	[OtherSymbol]	CIRCLED LATIN SMALL LETTER U
ｕ	U+FF55	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER U
󠁵	U+E0075	[Format]	TAG LATIN SMALL LETTER U
U	U+55	[UppercaseLetter]	LATIN CAPITAL LETTER U
Ù	U+D9	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH GRAVE
Ú	U+DA	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH ACUTE
Û	U+DB	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH CIRCUMFLEX
Ü	U+DC	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DIAERESIS
Ũ	U+168	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH TILDE
Ū	U+16A	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH MACRON
Ŭ	U+16C	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH BREVE
Ů	U+16E	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH RING ABOVE
Ű	U+170	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DOUBLE ACUTE
Ų	U+172	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH OGONEK
Ư	U+1AF	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HORN
Ǔ	U+1D3	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH CARON
Ǖ	U+1D5	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DIAERESIS AND MACRON
Ǘ	U+1D7	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DIAERESIS AND ACUTE
Ǚ	U+1D9	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DIAERESIS AND CARON
Ǜ	U+1DB	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DIAERESIS AND GRAVE
Ȕ	U+214	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DOUBLE GRAVE
Ȗ	U+216	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH INVERTED BREVE
Ʉ	U+244	[UppercaseLetter]	LATIN CAPITAL LETTER U BAR
У	U+423	[UppercaseLetter]	CYRILLIC CAPITAL LETTER U
Ӯ	U+4EE	[UppercaseLetter]	CYRILLIC CAPITAL LETTER U WITH MACRON
Ӱ	U+4F0	[UppercaseLetter]	CYRILLIC CAPITAL LETTER U WITH DIAERESIS
Ӳ	U+4F2	[UppercaseLetter]	CYRILLIC CAPITAL LETTER U WITH DOUBLE ACUTE
ᵾ	U+1D7E	[LowercaseLetter]	LATIN SMALL CAPITAL LETTER U WITH STROKE
Ṳ	U+1E72	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DIAERESIS BELOW
Ṵ	U+1E74	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH TILDE BELOW
Ṷ	U+1E76	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH CIRCUMFLEX BELOW
Ṹ	U+1E78	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH TILDE AND ACUTE
Ṻ	U+1E7A	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH MACRON AND DIAERESIS
Ụ	U+1EE4	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH DOT BELOW
Ủ	U+1EE6	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HOOK ABOVE
Ứ	U+1EE8	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HORN AND ACUTE
Ừ	U+1EEA	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HORN AND GRAVE
Ử	U+1EEC	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HORN AND HOOK ABOVE
Ữ	U+1EEE	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HORN AND TILDE
Ự	U+1EF0	[UppercaseLetter]	LATIN CAPITAL LETTER U WITH HORN AND DOT BELOW
Ⓤ	U+24CA	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER U
Ｕ	U+FF35	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER U
🄤	U+1F124	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER U
🅄	U+1F144	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER U
🅤	U+1F164	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER U
🆄	U+1F184	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER U
󠁕	U+E0055	[Format]	TAG LATIN CAPITAL LETTER U
v	U+76	[LowercaseLetter]	LATIN SMALL LETTER V
ʋ	U+28B	[LowercaseLetter]	LATIN SMALL LETTER V WITH HOOK
ͮ	U+36E	[NonspacingMark]	COMBINING LATIN SMALL LETTER V
ᵥ	U+1D65	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER V
ᶌ	U+1D8C	[LowercaseLetter]	LATIN SMALL LETTER V WITH PALATAL HOOK
ṽ	U+1E7D	[LowercaseLetter]	LATIN SMALL LETTER V WITH TILDE
ṿ	U+1E7F	[LowercaseLetter]	LATIN SMALL LETTER V WITH DOT BELOW
⒱	U+24B1	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER V
ⓥ	U+24E5	[OtherSymbol]	CIRCLED LATIN SMALL LETTER V
ⱱ	U+2C71	[LowercaseLetter]	LATIN SMALL LETTER V WITH RIGHT HOOK
ⱴ	U+2C74	[LowercaseLetter]	LATIN SMALL LETTER V WITH CURL
ꝟ	U+A75F	[LowercaseLetter]	LATIN SMALL LETTER V WITH DIAGONAL STROKE
ｖ	U+FF56	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER V
󠁶	U+E0076	[Format]	TAG LATIN SMALL LETTER V
V	U+56	[UppercaseLetter]	LATIN CAPITAL LETTER V
Ʋ	U+1B2	[UppercaseLetter]	LATIN CAPITAL LETTER V WITH HOOK
Ṽ	U+1E7C	[UppercaseLetter]	LATIN CAPITAL LETTER V WITH TILDE
Ṿ	U+1E7E	[UppercaseLetter]	LATIN CAPITAL LETTER V WITH DOT BELOW
Ⓥ	U+24CB	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER V
Ꝟ	U+A75E	[UppercaseLetter]	LATIN CAPITAL LETTER V WITH DIAGONAL STROKE
Ｖ	U+FF36	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER V
🄥	U+1F125	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER V
🅅	U+1F145	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER V
🅥	U+1F165	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER V
🆅	U+1F185	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER V
󠁖	U+E0056	[Format]	TAG LATIN CAPITAL LETTER V
w	U+77	[LowercaseLetter]	LATIN SMALL LETTER W
ŵ	U+175	[LowercaseLetter]	LATIN SMALL LETTER W WITH CIRCUMFLEX
ẁ	U+1E81	[LowercaseLetter]	LATIN SMALL LETTER W WITH GRAVE
ẃ	U+1E83	[LowercaseLetter]	LATIN SMALL LETTER W WITH ACUTE
ẅ	U+1E85	[LowercaseLetter]	LATIN SMALL LETTER W WITH DIAERESIS
ẇ	U+1E87	[LowercaseLetter]	LATIN SMALL LETTER W WITH DOT ABOVE
ẉ	U+1E89	[LowercaseLetter]	LATIN SMALL LETTER W WITH DOT BELOW
ẘ	U+1E98	[LowercaseLetter]	LATIN SMALL LETTER W WITH RING ABOVE
⒲	U+24B2	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER W
ⓦ	U+24E6	[OtherSymbol]	CIRCLED LATIN SMALL LETTER W
ⱳ	U+2C73	[LowercaseLetter]	LATIN SMALL LETTER W WITH HOOK
ｗ	U+FF57	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER W
󠁷	U+E0077	[Format]	TAG LATIN SMALL LETTER W
W	U+57	[UppercaseLetter]	LATIN CAPITAL LETTER W
Ŵ	U+174	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH CIRCUMFLEX
Ẁ	U+1E80	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH GRAVE
Ẃ	U+1E82	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH ACUTE
Ẅ	U+1E84	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH DIAERESIS
Ẇ	U+1E86	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH DOT ABOVE
Ẉ	U+1E88	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH DOT BELOW
Ⓦ	U+24CC	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER W
Ⱳ	U+2C72	[UppercaseLetter]	LATIN CAPITAL LETTER W WITH HOOK
Ｗ	U+FF37	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER W
🄦	U+1F126	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER W
🅆	U+1F146	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER W
🅦	U+1F166	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER W
🆆	U+1F186	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER W
󠁗	U+E0057	[Format]	TAG LATIN CAPITAL LETTER W
x	U+78	[LowercaseLetter]	LATIN SMALL LETTER X
ͯ	U+36F	[NonspacingMark]	COMBINING LATIN SMALL LETTER X
ᶍ	U+1D8D	[LowercaseLetter]	LATIN SMALL LETTER X WITH PALATAL HOOK
ẋ	U+1E8B	[LowercaseLetter]	LATIN SMALL LETTER X WITH DOT ABOVE
ẍ	U+1E8D	[LowercaseLetter]	LATIN SMALL LETTER X WITH DIAERESIS
ₓ	U+2093	[ModifierLetter]	LATIN SUBSCRIPT SMALL LETTER X
⒳	U+24B3	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER X
ⓧ	U+24E7	[OtherSymbol]	CIRCLED LATIN SMALL LETTER X
ｘ	U+FF58	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER X
󠁸	U+E0078	[Format]	TAG LATIN SMALL LETTER X
X	U+58	[UppercaseLetter]	LATIN CAPITAL LETTER X
Ẋ	U+1E8A	[UppercaseLetter]	LATIN CAPITAL LETTER X WITH DOT ABOVE
Ẍ	U+1E8C	[UppercaseLetter]	LATIN CAPITAL LETTER X WITH DIAERESIS
Ⓧ	U+24CD	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER X
Ｘ	U+FF38	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER X
🄧	U+1F127	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER X
🅇	U+1F147	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER X
🅧	U+1F167	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER X
🆇	U+1F187	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER X
󠁘	U+E0058	[Format]	TAG LATIN CAPITAL LETTER X
y	U+79	[LowercaseLetter]	LATIN SMALL LETTER Y
ý	U+FD	[LowercaseLetter]	LATIN SMALL LETTER Y WITH ACUTE
ÿ	U+FF	[LowercaseLetter]	LATIN SMALL LETTER Y WITH DIAERESIS
ŷ	U+177	[LowercaseLetter]	LATIN SMALL LETTER Y WITH CIRCUMFLEX
ƴ	U+1B4	[LowercaseLetter]	LATIN SMALL LETTER Y WITH HOOK
ȳ	U+233	[LowercaseLetter]	LATIN SMALL LETTER Y WITH MACRON
ɏ	U+24F	[LowercaseLetter]	LATIN SMALL LETTER Y WITH STROKE
ẏ	U+1E8F	[LowercaseLetter]	LATIN SMALL LETTER Y WITH DOT ABOVE
ẙ	U+1E99	[LowercaseLetter]	LATIN SMALL LETTER Y WITH RING ABOVE
ỳ	U+1EF3	[LowercaseLetter]	LATIN SMALL LETTER Y WITH GRAVE
ỵ	U+1EF5	[LowercaseLetter]	LATIN SMALL LETTER Y WITH DOT BELOW
ỷ	U+1EF7	[LowercaseLetter]	LATIN SMALL LETTER Y WITH HOOK ABOVE
ỹ	U+1EF9	[LowercaseLetter]	LATIN SMALL LETTER Y WITH TILDE
ỿ	U+1EFF	[LowercaseLetter]	LATIN SMALL LETTER Y WITH LOOP
⒴	U+24B4	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER Y
ⓨ	U+24E8	[OtherSymbol]	CIRCLED LATIN SMALL LETTER Y
ｙ	U+FF59	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER Y
󠁹	U+E0079	[Format]	TAG LATIN SMALL LETTER Y
Y	U+59	[UppercaseLetter]	LATIN CAPITAL LETTER Y
Ý	U+DD	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH ACUTE
Ŷ	U+176	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH CIRCUMFLEX
Ÿ	U+178	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH DIAERESIS
Ƴ	U+1B3	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH HOOK
Ȳ	U+232	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH MACRON
Ɏ	U+24E	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH STROKE
Ẏ	U+1E8E	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH DOT ABOVE
Ỳ	U+1EF2	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH GRAVE
Ỵ	U+1EF4	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH DOT BELOW
Ỷ	U+1EF6	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH HOOK ABOVE
Ỹ	U+1EF8	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH TILDE
Ỿ	U+1EFE	[UppercaseLetter]	LATIN CAPITAL LETTER Y WITH LOOP
Ⓨ	U+24CE	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER Y
Ｙ	U+FF39	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER Y
🄨	U+1F128	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER Y
🅈	U+1F148	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER Y
🅨	U+1F168	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER Y
🆈	U+1F188	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER Y
󠁙	U+E0059	[Format]	TAG LATIN CAPITAL LETTER Y
z	U+7A	[LowercaseLetter]	LATIN SMALL LETTER Z
ź	U+17A	[LowercaseLetter]	LATIN SMALL LETTER Z WITH ACUTE
ż	U+17C	[LowercaseLetter]	LATIN SMALL LETTER Z WITH DOT ABOVE
ž	U+17E	[LowercaseLetter]	LATIN SMALL LETTER Z WITH CARON
ƶ	U+1B6	[LowercaseLetter]	LATIN SMALL LETTER Z WITH STROKE
ǅ	U+1C5	[TitlecaseLetter]	LATIN CAPITAL LETTER D WITH SMALL LETTER Z WITH CARON
ǲ	U+1F2	[TitlecaseLetter]	LATIN CAPITAL LETTER D WITH SMALL LETTER Z
ȥ	U+225	[LowercaseLetter]	LATIN SMALL LETTER Z WITH HOOK
ɀ	U+240	[LowercaseLetter]	LATIN SMALL LETTER Z WITH SWASH TAIL
ʐ	U+290	[LowercaseLetter]	LATIN SMALL LETTER Z WITH RETROFLEX HOOK
ʑ	U+291	[LowercaseLetter]	LATIN SMALL LETTER Z WITH CURL
ᵶ	U+1D76	[LowercaseLetter]	LATIN SMALL LETTER Z WITH MIDDLE TILDE
ᶎ	U+1D8E	[LowercaseLetter]	LATIN SMALL LETTER Z WITH PALATAL HOOK
ᷦ	U+1DE6	[NonspacingMark]	COMBINING LATIN SMALL LETTER Z
ẑ	U+1E91	[LowercaseLetter]	LATIN SMALL LETTER Z WITH CIRCUMFLEX
ẓ	U+1E93	[LowercaseLetter]	LATIN SMALL LETTER Z WITH DOT BELOW
ẕ	U+1E95	[LowercaseLetter]	LATIN SMALL LETTER Z WITH LINE BELOW
⒵	U+24B5	[OtherSymbol]	PARENTHESIZED LATIN SMALL LETTER Z
ⓩ	U+24E9	[OtherSymbol]	CIRCLED LATIN SMALL LETTER Z
ⱬ	U+2C6C	[LowercaseLetter]	LATIN SMALL LETTER Z WITH DESCENDER
ｚ	U+FF5A	[LowercaseLetter]	FULLWIDTH LATIN SMALL LETTER Z
󠁺	U+E007A	[Format]	TAG LATIN SMALL LETTER Z
Z	U+5A	[UppercaseLetter]	LATIN CAPITAL LETTER Z
Ź	U+179	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH ACUTE
Ż	U+17B	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH DOT ABOVE
Ž	U+17D	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH CARON
Ƶ	U+1B5	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH STROKE
Ȥ	U+224	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH HOOK
Ẑ	U+1E90	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH CIRCUMFLEX
Ẓ	U+1E92	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH DOT BELOW
Ẕ	U+1E94	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH LINE BELOW
Ⓩ	U+24CF	[OtherSymbol]	CIRCLED LATIN CAPITAL LETTER Z
Ⱬ	U+2C6B	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH DESCENDER
Ɀ	U+2C7F	[UppercaseLetter]	LATIN CAPITAL LETTER Z WITH SWASH TAIL
Ｚ	U+FF3A	[UppercaseLetter]	FULLWIDTH LATIN CAPITAL LETTER Z
🄩	U+1F129	[OtherSymbol]	PARENTHESIZED LATIN CAPITAL LETTER Z
🅉	U+1F149	[OtherSymbol]	SQUARED LATIN CAPITAL LETTER Z
🅩	U+1F169	[OtherSymbol]	NEGATIVE CIRCLED LATIN CAPITAL LETTER Z
🆉	U+1F189	[OtherSymbol]	NEGATIVE SQUARED LATIN CAPITAL LETTER Z
󠁚	U+E005A	[Format]	TAG LATIN CAPITAL LETTER Z
0	U+30	[DecimalNumber]	DIGIT ZERO
٠	U+660	[DecimalNumber]	ARABIC-INDIC DIGIT ZERO
۰	U+6F0	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT ZERO
߀	U+7C0	[DecimalNumber]	NKO DIGIT ZERO
०	U+966	[DecimalNumber]	DEVANAGARI DIGIT ZERO
০	U+9E6	[DecimalNumber]	BENGALI DIGIT ZERO
੦	U+A66	[DecimalNumber]	GURMUKHI DIGIT ZERO
૦	U+AE6	[DecimalNumber]	GUJARATI DIGIT ZERO
୦	U+B66	[DecimalNumber]	ORIYA DIGIT ZERO
௦	U+BE6	[DecimalNumber]	TAMIL DIGIT ZERO
౦	U+C66	[DecimalNumber]	TELUGU DIGIT ZERO
೦	U+CE6	[DecimalNumber]	KANNADA DIGIT ZERO
൦	U+D66	[DecimalNumber]	MALAYALAM DIGIT ZERO
๐	U+E50	[DecimalNumber]	THAI DIGIT ZERO
໐	U+ED0	[DecimalNumber]	LAO DIGIT ZERO
༠	U+F20	[DecimalNumber]	TIBETAN DIGIT ZERO
၀	U+1040	[DecimalNumber]	MYANMAR DIGIT ZERO
႐	U+1090	[DecimalNumber]	MYANMAR SHAN DIGIT ZERO
០	U+17E0	[DecimalNumber]	KHMER DIGIT ZERO
᠐	U+1810	[DecimalNumber]	MONGOLIAN DIGIT ZERO
᥆	U+1946	[DecimalNumber]	LIMBU DIGIT ZERO
᧐	U+19D0	[DecimalNumber]	NEW TAI LUE DIGIT ZERO
᪀	U+1A80	[DecimalNumber]	TAI THAM HORA DIGIT ZERO
᪐	U+1A90	[DecimalNumber]	TAI THAM THAM DIGIT ZERO
᭐	U+1B50	[DecimalNumber]	BALINESE DIGIT ZERO
᮰	U+1BB0	[DecimalNumber]	SUNDANESE DIGIT ZERO
᱀	U+1C40	[DecimalNumber]	LEPCHA DIGIT ZERO
᱐	U+1C50	[DecimalNumber]	OL CHIKI DIGIT ZERO
⓪	U+24EA	[OtherNumber]	CIRCLED DIGIT ZERO
⓿	U+24FF	[OtherNumber]	NEGATIVE CIRCLED DIGIT ZERO
〇	U+3007	[LetterNumber]	IDEOGRAPHIC NUMBER ZERO
꘠	U+A620	[DecimalNumber]	VAI DIGIT ZERO
꣐	U+A8D0	[DecimalNumber]	SAURASHTRA DIGIT ZERO
꣠	U+A8E0	[NonspacingMark]	COMBINING DEVANAGARI DIGIT ZERO
꤀	U+A900	[DecimalNumber]	KAYAH LI DIGIT ZERO
꧐	U+A9D0	[DecimalNumber]	JAVANESE DIGIT ZERO
꩐	U+AA50	[DecimalNumber]	CHAM DIGIT ZERO
꯰	U+ABF0	[DecimalNumber]	MEETEI MAYEK DIGIT ZERO
０	U+FF10	[DecimalNumber]	FULLWIDTH DIGIT ZERO
𐒠	U+104A0	[DecimalNumber]	OSMANYA DIGIT ZERO
𑁦	U+11066	[DecimalNumber]	BRAHMI DIGIT ZERO
𑃰	U+110F0	[DecimalNumber]	SORA SOMPENG DIGIT ZERO
𑄶	U+11136	[DecimalNumber]	CHAKMA DIGIT ZERO
𑇐	U+111D0	[DecimalNumber]	SHARADA DIGIT ZERO
𑛀	U+116C0	[DecimalNumber]	TAKRI DIGIT ZERO
𝟎	U+1D7CE	[DecimalNumber]	MATHEMATICAL BOLD DIGIT ZERO
𝟘	U+1D7D8	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT ZERO
𝟢	U+1D7E2	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT ZERO
𝟬	U+1D7EC	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT ZERO
𝟶	U+1D7F6	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT ZERO
󠀰	U+E0030	[Format]	TAG DIGIT ZERO
1	U+31	[DecimalNumber]	DIGIT ONE
١	U+661	[DecimalNumber]	ARABIC-INDIC DIGIT ONE
۱	U+6F1	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT ONE
߁	U+7C1	[DecimalNumber]	NKO DIGIT ONE
१	U+967	[DecimalNumber]	DEVANAGARI DIGIT ONE
১	U+9E7	[DecimalNumber]	BENGALI DIGIT ONE
੧	U+A67	[DecimalNumber]	GURMUKHI DIGIT ONE
૧	U+AE7	[DecimalNumber]	GUJARATI DIGIT ONE
୧	U+B67	[DecimalNumber]	ORIYA DIGIT ONE
௧	U+BE7	[DecimalNumber]	TAMIL DIGIT ONE
౧	U+C67	[DecimalNumber]	TELUGU DIGIT ONE
೧	U+CE7	[DecimalNumber]	KANNADA DIGIT ONE
൧	U+D67	[DecimalNumber]	MALAYALAM DIGIT ONE
๑	U+E51	[DecimalNumber]	THAI DIGIT ONE
໑	U+ED1	[DecimalNumber]	LAO DIGIT ONE
༡	U+F21	[DecimalNumber]	TIBETAN DIGIT ONE
၁	U+1041	[DecimalNumber]	MYANMAR DIGIT ONE
႑	U+1091	[DecimalNumber]	MYANMAR SHAN DIGIT ONE
፩	U+1369	[OtherNumber]	ETHIOPIC DIGIT ONE
១	U+17E1	[DecimalNumber]	KHMER DIGIT ONE
᠑	U+1811	[DecimalNumber]	MONGOLIAN DIGIT ONE
᥇	U+1947	[DecimalNumber]	LIMBU DIGIT ONE
᧑	U+19D1	[DecimalNumber]	NEW TAI LUE DIGIT ONE
᧚	U+19DA	[OtherNumber]	NEW TAI LUE THAM DIGIT ONE
᪁	U+1A81	[DecimalNumber]	TAI THAM HORA DIGIT ONE
᪑	U+1A91	[DecimalNumber]	TAI THAM THAM DIGIT ONE
᭑	U+1B51	[DecimalNumber]	BALINESE DIGIT ONE
᮱	U+1BB1	[DecimalNumber]	SUNDANESE DIGIT ONE
᱁	U+1C41	[DecimalNumber]	LEPCHA DIGIT ONE
᱑	U+1C51	[DecimalNumber]	OL CHIKI DIGIT ONE
①	U+2460	[OtherNumber]	CIRCLED DIGIT ONE
⑴	U+2474	[OtherNumber]	PARENTHESIZED DIGIT ONE
⓵	U+24F5	[OtherNumber]	DOUBLE CIRCLED DIGIT ONE
❶	U+2776	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT ONE
➀	U+2780	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT ONE
➊	U+278A	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT ONE
꘡	U+A621	[DecimalNumber]	VAI DIGIT ONE
꣑	U+A8D1	[DecimalNumber]	SAURASHTRA DIGIT ONE
꣡	U+A8E1	[NonspacingMark]	COMBINING DEVANAGARI DIGIT ONE
꤁	U+A901	[DecimalNumber]	KAYAH LI DIGIT ONE
꧑	U+A9D1	[DecimalNumber]	JAVANESE DIGIT ONE
꩑	U+AA51	[DecimalNumber]	CHAM DIGIT ONE
꯱	U+ABF1	[DecimalNumber]	MEETEI MAYEK DIGIT ONE
１	U+FF11	[DecimalNumber]	FULLWIDTH DIGIT ONE
𐄇	U+10107	[OtherNumber]	AEGEAN NUMBER ONE
𐏑	U+103D1	[LetterNumber]	OLD PERSIAN NUMBER ONE
𐒡	U+104A1	[DecimalNumber]	OSMANYA DIGIT ONE
𐡘	U+10858	[OtherNumber]	IMPERIAL ARAMAIC NUMBER ONE
𐤖	U+10916	[OtherNumber]	PHOENICIAN NUMBER ONE
𐩀	U+10A40	[OtherNumber]	KHAROSHTHI DIGIT ONE
𐩽	U+10A7D	[OtherNumber]	OLD SOUTH ARABIAN NUMBER ONE
𐭘	U+10B58	[OtherNumber]	INSCRIPTIONAL PARTHIAN NUMBER ONE
𐭸	U+10B78	[OtherNumber]	INSCRIPTIONAL PAHLAVI NUMBER ONE
𐹠	U+10E60	[OtherNumber]	RUMI DIGIT ONE
𑁒	U+11052	[OtherNumber]	BRAHMI NUMBER ONE
𑁧	U+11067	[DecimalNumber]	BRAHMI DIGIT ONE
𑃱	U+110F1	[DecimalNumber]	SORA SOMPENG DIGIT ONE
𑄷	U+11137	[DecimalNumber]	CHAKMA DIGIT ONE
𑇑	U+111D1	[DecimalNumber]	SHARADA DIGIT ONE
𑛁	U+116C1	[DecimalNumber]	TAKRI DIGIT ONE
𝍠	U+1D360	[OtherNumber]	COUNTING ROD UNIT DIGIT ONE
𝍩	U+1D369	[OtherNumber]	COUNTING ROD TENS DIGIT ONE
𝟏	U+1D7CF	[DecimalNumber]	MATHEMATICAL BOLD DIGIT ONE
𝟙	U+1D7D9	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT ONE
𝟣	U+1D7E3	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT ONE
𝟭	U+1D7ED	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT ONE
𝟷	U+1D7F7	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT ONE
󠀱	U+E0031	[Format]	TAG DIGIT ONE
2	U+32	[DecimalNumber]	DIGIT TWO
٢	U+662	[DecimalNumber]	ARABIC-INDIC DIGIT TWO
۲	U+6F2	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT TWO
ݳ	U+773	[OtherLetter]	ARABIC LETTER ALEF WITH EXTENDED ARABIC-INDIC DIGIT TWO ABOVE
ݵ	U+775	[OtherLetter]	ARABIC LETTER FARSI YEH WITH EXTENDED ARABIC-INDIC DIGIT TWO ABOVE
ݸ	U+778	[OtherLetter]	ARABIC LETTER WAW WITH EXTENDED ARABIC-INDIC DIGIT TWO ABOVE
ݺ	U+77A	[OtherLetter]	ARABIC LETTER YEH BARREE WITH EXTENDED ARABIC-INDIC DIGIT TWO ABOVE
߂	U+7C2	[DecimalNumber]	NKO DIGIT TWO
२	U+968	[DecimalNumber]	DEVANAGARI DIGIT TWO
২	U+9E8	[DecimalNumber]	BENGALI DIGIT TWO
੨	U+A68	[DecimalNumber]	GURMUKHI DIGIT TWO
૨	U+AE8	[DecimalNumber]	GUJARATI DIGIT TWO
୨	U+B68	[DecimalNumber]	ORIYA DIGIT TWO
௨	U+BE8	[DecimalNumber]	TAMIL DIGIT TWO
౨	U+C68	[DecimalNumber]	TELUGU DIGIT TWO
೨	U+CE8	[DecimalNumber]	KANNADA DIGIT TWO
൨	U+D68	[DecimalNumber]	MALAYALAM DIGIT TWO
๒	U+E52	[DecimalNumber]	THAI DIGIT TWO
໒	U+ED2	[DecimalNumber]	LAO DIGIT TWO
༢	U+F22	[DecimalNumber]	TIBETAN DIGIT TWO
၂	U+1042	[DecimalNumber]	MYANMAR DIGIT TWO
႒	U+1092	[DecimalNumber]	MYANMAR SHAN DIGIT TWO
፪	U+136A	[OtherNumber]	ETHIOPIC DIGIT TWO
២	U+17E2	[DecimalNumber]	KHMER DIGIT TWO
᠒	U+1812	[DecimalNumber]	MONGOLIAN DIGIT TWO
᥈	U+1948	[DecimalNumber]	LIMBU DIGIT TWO
᧒	U+19D2	[DecimalNumber]	NEW TAI LUE DIGIT TWO
᪂	U+1A82	[DecimalNumber]	TAI THAM HORA DIGIT TWO
᪒	U+1A92	[DecimalNumber]	TAI THAM THAM DIGIT TWO
᭒	U+1B52	[DecimalNumber]	BALINESE DIGIT TWO
᮲	U+1BB2	[DecimalNumber]	SUNDANESE DIGIT TWO
᱂	U+1C42	[DecimalNumber]	LEPCHA DIGIT TWO
᱒	U+1C52	[DecimalNumber]	OL CHIKI DIGIT TWO
②	U+2461	[OtherNumber]	CIRCLED DIGIT TWO
⑵	U+2475	[OtherNumber]	PARENTHESIZED DIGIT TWO
⓶	U+24F6	[OtherNumber]	DOUBLE CIRCLED DIGIT TWO
❷	U+2777	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT TWO
➁	U+2781	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT TWO
➋	U+278B	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT TWO
꘢	U+A622	[DecimalNumber]	VAI DIGIT TWO
꣒	U+A8D2	[DecimalNumber]	SAURASHTRA DIGIT TWO
꣢	U+A8E2	[NonspacingMark]	COMBINING DEVANAGARI DIGIT TWO
꤂	U+A902	[DecimalNumber]	KAYAH LI DIGIT TWO
꧒	U+A9D2	[DecimalNumber]	JAVANESE DIGIT TWO
꩒	U+AA52	[DecimalNumber]	CHAM DIGIT TWO
꯲	U+ABF2	[DecimalNumber]	MEETEI MAYEK DIGIT TWO
２	U+FF12	[DecimalNumber]	FULLWIDTH DIGIT TWO
𐄈	U+10108	[OtherNumber]	AEGEAN NUMBER TWO
𐏒	U+103D2	[LetterNumber]	OLD PERSIAN NUMBER TWO
𐒢	U+104A2	[DecimalNumber]	OSMANYA DIGIT TWO
𐡙	U+10859	[OtherNumber]	IMPERIAL ARAMAIC NUMBER TWO
𐤚	U+1091A	[OtherNumber]	PHOENICIAN NUMBER TWO
𐩁	U+10A41	[OtherNumber]	KHAROSHTHI DIGIT TWO
𐭙	U+10B59	[OtherNumber]	INSCRIPTIONAL PARTHIAN NUMBER TWO
𐭹	U+10B79	[OtherNumber]	INSCRIPTIONAL PAHLAVI NUMBER TWO
𐹡	U+10E61	[OtherNumber]	RUMI DIGIT TWO
𑁓	U+11053	[OtherNumber]	BRAHMI NUMBER TWO
𑁨	U+11068	[DecimalNumber]	BRAHMI DIGIT TWO
𑃲	U+110F2	[DecimalNumber]	SORA SOMPENG DIGIT TWO
𑄸	U+11138	[DecimalNumber]	CHAKMA DIGIT TWO
𑇒	U+111D2	[DecimalNumber]	SHARADA DIGIT TWO
𑛂	U+116C2	[DecimalNumber]	TAKRI DIGIT TWO
𝍡	U+1D361	[OtherNumber]	COUNTING ROD UNIT DIGIT TWO
𝍪	U+1D36A	[OtherNumber]	COUNTING ROD TENS DIGIT TWO
𝟐	U+1D7D0	[DecimalNumber]	MATHEMATICAL BOLD DIGIT TWO
𝟚	U+1D7DA	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT TWO
𝟤	U+1D7E4	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT TWO
𝟮	U+1D7EE	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT TWO
𝟸	U+1D7F8	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT TWO
󠀲	U+E0032	[Format]	TAG DIGIT TWO
3	U+33	[DecimalNumber]	DIGIT THREE
٣	U+663	[DecimalNumber]	ARABIC-INDIC DIGIT THREE
۳	U+6F3	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT THREE
ݴ	U+774	[OtherLetter]	ARABIC LETTER ALEF WITH EXTENDED ARABIC-INDIC DIGIT THREE ABOVE
ݶ	U+776	[OtherLetter]	ARABIC LETTER FARSI YEH WITH EXTENDED ARABIC-INDIC DIGIT THREE ABOVE
ݹ	U+779	[OtherLetter]	ARABIC LETTER WAW WITH EXTENDED ARABIC-INDIC DIGIT THREE ABOVE
ݻ	U+77B	[OtherLetter]	ARABIC LETTER YEH BARREE WITH EXTENDED ARABIC-INDIC DIGIT THREE ABOVE
߃	U+7C3	[DecimalNumber]	NKO DIGIT THREE
३	U+969	[DecimalNumber]	DEVANAGARI DIGIT THREE
৩	U+9E9	[DecimalNumber]	BENGALI DIGIT THREE
੩	U+A69	[DecimalNumber]	GURMUKHI DIGIT THREE
૩	U+AE9	[DecimalNumber]	GUJARATI DIGIT THREE
୩	U+B69	[DecimalNumber]	ORIYA DIGIT THREE
௩	U+BE9	[DecimalNumber]	TAMIL DIGIT THREE
౩	U+C69	[DecimalNumber]	TELUGU DIGIT THREE
೩	U+CE9	[DecimalNumber]	KANNADA DIGIT THREE
൩	U+D69	[DecimalNumber]	MALAYALAM DIGIT THREE
๓	U+E53	[DecimalNumber]	THAI DIGIT THREE
໓	U+ED3	[DecimalNumber]	LAO DIGIT THREE
༣	U+F23	[DecimalNumber]	TIBETAN DIGIT THREE
၃	U+1043	[DecimalNumber]	MYANMAR DIGIT THREE
႓	U+1093	[DecimalNumber]	MYANMAR SHAN DIGIT THREE
፫	U+136B	[OtherNumber]	ETHIOPIC DIGIT THREE
៣	U+17E3	[DecimalNumber]	KHMER DIGIT THREE
᠓	U+1813	[DecimalNumber]	MONGOLIAN DIGIT THREE
᥉	U+1949	[DecimalNumber]	LIMBU DIGIT THREE
᧓	U+19D3	[DecimalNumber]	NEW TAI LUE DIGIT THREE
᪃	U+1A83	[DecimalNumber]	TAI THAM HORA DIGIT THREE
᪓	U+1A93	[DecimalNumber]	TAI THAM THAM DIGIT THREE
᭓	U+1B53	[DecimalNumber]	BALINESE DIGIT THREE
᮳	U+1BB3	[DecimalNumber]	SUNDANESE DIGIT THREE
᱃	U+1C43	[DecimalNumber]	LEPCHA DIGIT THREE
᱓	U+1C53	[DecimalNumber]	OL CHIKI DIGIT THREE
③	U+2462	[OtherNumber]	CIRCLED DIGIT THREE
⑶	U+2476	[OtherNumber]	PARENTHESIZED DIGIT THREE
⓷	U+24F7	[OtherNumber]	DOUBLE CIRCLED DIGIT THREE
❸	U+2778	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT THREE
➂	U+2782	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT THREE
➌	U+278C	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT THREE
꘣	U+A623	[DecimalNumber]	VAI DIGIT THREE
꣓	U+A8D3	[DecimalNumber]	SAURASHTRA DIGIT THREE
꣣	U+A8E3	[NonspacingMark]	COMBINING DEVANAGARI DIGIT THREE
꤃	U+A903	[DecimalNumber]	KAYAH LI DIGIT THREE
꧓	U+A9D3	[DecimalNumber]	JAVANESE DIGIT THREE
꩓	U+AA53	[DecimalNumber]	CHAM DIGIT THREE
꯳	U+ABF3	[DecimalNumber]	MEETEI MAYEK DIGIT THREE
３	U+FF13	[DecimalNumber]	FULLWIDTH DIGIT THREE
𐄉	U+10109	[OtherNumber]	AEGEAN NUMBER THREE
𐒣	U+104A3	[DecimalNumber]	OSMANYA DIGIT THREE
𐡚	U+1085A	[OtherNumber]	IMPERIAL ARAMAIC NUMBER THREE
𐤛	U+1091B	[OtherNumber]	PHOENICIAN NUMBER THREE
𐩂	U+10A42	[OtherNumber]	KHAROSHTHI DIGIT THREE
𐭚	U+10B5A	[OtherNumber]	INSCRIPTIONAL PARTHIAN NUMBER THREE
𐭺	U+10B7A	[OtherNumber]	INSCRIPTIONAL PAHLAVI NUMBER THREE
𐹢	U+10E62	[OtherNumber]	RUMI DIGIT THREE
𑁔	U+11054	[OtherNumber]	BRAHMI NUMBER THREE
𑁩	U+11069	[DecimalNumber]	BRAHMI DIGIT THREE
𑃳	U+110F3	[DecimalNumber]	SORA SOMPENG DIGIT THREE
𑄹	U+11139	[DecimalNumber]	CHAKMA DIGIT THREE
𑇓	U+111D3	[DecimalNumber]	SHARADA DIGIT THREE
𑛃	U+116C3	[DecimalNumber]	TAKRI DIGIT THREE
𝍢	U+1D362	[OtherNumber]	COUNTING ROD UNIT DIGIT THREE
𝍫	U+1D36B	[OtherNumber]	COUNTING ROD TENS DIGIT THREE
𝟑	U+1D7D1	[DecimalNumber]	MATHEMATICAL BOLD DIGIT THREE
𝟛	U+1D7DB	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT THREE
𝟥	U+1D7E5	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT THREE
𝟯	U+1D7EF	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT THREE
𝟹	U+1D7F9	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT THREE
󠀳	U+E0033	[Format]	TAG DIGIT THREE
4	U+34	[DecimalNumber]	DIGIT FOUR
٤	U+664	[DecimalNumber]	ARABIC-INDIC DIGIT FOUR
۴	U+6F4	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT FOUR
ݷ	U+777	[OtherLetter]	ARABIC LETTER FARSI YEH WITH EXTENDED ARABIC-INDIC DIGIT FOUR BELOW
ݼ	U+77C	[OtherLetter]	ARABIC LETTER HAH WITH EXTENDED ARABIC-INDIC DIGIT FOUR BELOW
ݽ	U+77D	[OtherLetter]	ARABIC LETTER SEEN WITH EXTENDED ARABIC-INDIC DIGIT FOUR ABOVE
߄	U+7C4	[DecimalNumber]	NKO DIGIT FOUR
४	U+96A	[DecimalNumber]	DEVANAGARI DIGIT FOUR
৪	U+9EA	[DecimalNumber]	BENGALI DIGIT FOUR
੪	U+A6A	[DecimalNumber]	GURMUKHI DIGIT FOUR
૪	U+AEA	[DecimalNumber]	GUJARATI DIGIT FOUR
୪	U+B6A	[DecimalNumber]	ORIYA DIGIT FOUR
௪	U+BEA	[DecimalNumber]	TAMIL DIGIT FOUR
౪	U+C6A	[DecimalNumber]	TELUGU DIGIT FOUR
೪	U+CEA	[DecimalNumber]	KANNADA DIGIT FOUR
൪	U+D6A	[DecimalNumber]	MALAYALAM DIGIT FOUR
๔	U+E54	[DecimalNumber]	THAI DIGIT FOUR
໔	U+ED4	[DecimalNumber]	LAO DIGIT FOUR
༤	U+F24	[DecimalNumber]	TIBETAN DIGIT FOUR
၄	U+1044	[DecimalNumber]	MYANMAR DIGIT FOUR
႔	U+1094	[DecimalNumber]	MYANMAR SHAN DIGIT FOUR
፬	U+136C	[OtherNumber]	ETHIOPIC DIGIT FOUR
៤	U+17E4	[DecimalNumber]	KHMER DIGIT FOUR
᠔	U+1814	[DecimalNumber]	MONGOLIAN DIGIT FOUR
᥊	U+194A	[DecimalNumber]	LIMBU DIGIT FOUR
᧔	U+19D4	[DecimalNumber]	NEW TAI LUE DIGIT FOUR
᪄	U+1A84	[DecimalNumber]	TAI THAM HORA DIGIT FOUR
᪔	U+1A94	[DecimalNumber]	TAI THAM THAM DIGIT FOUR
᭔	U+1B54	[DecimalNumber]	BALINESE DIGIT FOUR
᮴	U+1BB4	[DecimalNumber]	SUNDANESE DIGIT FOUR
᱄	U+1C44	[DecimalNumber]	LEPCHA DIGIT FOUR
᱔	U+1C54	[DecimalNumber]	OL CHIKI DIGIT FOUR
④	U+2463	[OtherNumber]	CIRCLED DIGIT FOUR
⑷	U+2477	[OtherNumber]	PARENTHESIZED DIGIT FOUR
⓸	U+24F8	[OtherNumber]	DOUBLE CIRCLED DIGIT FOUR
❹	U+2779	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT FOUR
➃	U+2783	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT FOUR
➍	U+278D	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT FOUR
꘤	U+A624	[DecimalNumber]	VAI DIGIT FOUR
꣔	U+A8D4	[DecimalNumber]	SAURASHTRA DIGIT FOUR
꣤	U+A8E4	[NonspacingMark]	COMBINING DEVANAGARI DIGIT FOUR
꤄	U+A904	[DecimalNumber]	KAYAH LI DIGIT FOUR
꧔	U+A9D4	[DecimalNumber]	JAVANESE DIGIT FOUR
꩔	U+AA54	[DecimalNumber]	CHAM DIGIT FOUR
꯴	U+ABF4	[DecimalNumber]	MEETEI MAYEK DIGIT FOUR
４	U+FF14	[DecimalNumber]	FULLWIDTH DIGIT FOUR
𐄊	U+1010A	[OtherNumber]	AEGEAN NUMBER FOUR
𐒤	U+104A4	[DecimalNumber]	OSMANYA DIGIT FOUR
𐩃	U+10A43	[OtherNumber]	KHAROSHTHI DIGIT FOUR
𐭛	U+10B5B	[OtherNumber]	INSCRIPTIONAL PARTHIAN NUMBER FOUR
𐭻	U+10B7B	[OtherNumber]	INSCRIPTIONAL PAHLAVI NUMBER FOUR
𐹣	U+10E63	[OtherNumber]	RUMI DIGIT FOUR
𑁕	U+11055	[OtherNumber]	BRAHMI NUMBER FOUR
𑁪	U+1106A	[DecimalNumber]	BRAHMI DIGIT FOUR
𑃴	U+110F4	[DecimalNumber]	SORA SOMPENG DIGIT FOUR
𑄺	U+1113A	[DecimalNumber]	CHAKMA DIGIT FOUR
𑇔	U+111D4	[DecimalNumber]	SHARADA DIGIT FOUR
𑛄	U+116C4	[DecimalNumber]	TAKRI DIGIT FOUR
𝍣	U+1D363	[OtherNumber]	COUNTING ROD UNIT DIGIT FOUR
𝍬	U+1D36C	[OtherNumber]	COUNTING ROD TENS DIGIT FOUR
𝟒	U+1D7D2	[DecimalNumber]	MATHEMATICAL BOLD DIGIT FOUR
𝟜	U+1D7DC	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT FOUR
𝟦	U+1D7E6	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT FOUR
𝟰	U+1D7F0	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT FOUR
𝟺	U+1D7FA	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT FOUR
󠀴	U+E0034	[Format]	TAG DIGIT FOUR
5	U+35	[DecimalNumber]	DIGIT FIVE
٥	U+665	[DecimalNumber]	ARABIC-INDIC DIGIT FIVE
۵	U+6F5	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT FIVE
߅	U+7C5	[DecimalNumber]	NKO DIGIT FIVE
५	U+96B	[DecimalNumber]	DEVANAGARI DIGIT FIVE
৫	U+9EB	[DecimalNumber]	BENGALI DIGIT FIVE
੫	U+A6B	[DecimalNumber]	GURMUKHI DIGIT FIVE
૫	U+AEB	[DecimalNumber]	GUJARATI DIGIT FIVE
୫	U+B6B	[DecimalNumber]	ORIYA DIGIT FIVE
௫	U+BEB	[DecimalNumber]	TAMIL DIGIT FIVE
౫	U+C6B	[DecimalNumber]	TELUGU DIGIT FIVE
೫	U+CEB	[DecimalNumber]	KANNADA DIGIT FIVE
൫	U+D6B	[DecimalNumber]	MALAYALAM DIGIT FIVE
๕	U+E55	[DecimalNumber]	THAI DIGIT FIVE
໕	U+ED5	[DecimalNumber]	LAO DIGIT FIVE
༥	U+F25	[DecimalNumber]	TIBETAN DIGIT FIVE
၅	U+1045	[DecimalNumber]	MYANMAR DIGIT FIVE
႕	U+1095	[DecimalNumber]	MYANMAR SHAN DIGIT FIVE
፭	U+136D	[OtherNumber]	ETHIOPIC DIGIT FIVE
៥	U+17E5	[DecimalNumber]	KHMER DIGIT FIVE
᠕	U+1815	[DecimalNumber]	MONGOLIAN DIGIT FIVE
᥋	U+194B	[DecimalNumber]	LIMBU DIGIT FIVE
᧕	U+19D5	[DecimalNumber]	NEW TAI LUE DIGIT FIVE
᪅	U+1A85	[DecimalNumber]	TAI THAM HORA DIGIT FIVE
᪕	U+1A95	[DecimalNumber]	TAI THAM THAM DIGIT FIVE
᭕	U+1B55	[DecimalNumber]	BALINESE DIGIT FIVE
᮵	U+1BB5	[DecimalNumber]	SUNDANESE DIGIT FIVE
᱅	U+1C45	[DecimalNumber]	LEPCHA DIGIT FIVE
᱕	U+1C55	[DecimalNumber]	OL CHIKI DIGIT FIVE
⑤	U+2464	[OtherNumber]	CIRCLED DIGIT FIVE
⑸	U+2478	[OtherNumber]	PARENTHESIZED DIGIT FIVE
⓹	U+24F9	[OtherNumber]	DOUBLE CIRCLED DIGIT FIVE
❺	U+277A	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT FIVE
➄	U+2784	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT FIVE
➎	U+278E	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT FIVE
꘥	U+A625	[DecimalNumber]	VAI DIGIT FIVE
꣕	U+A8D5	[DecimalNumber]	SAURASHTRA DIGIT FIVE
꣥	U+A8E5	[NonspacingMark]	COMBINING DEVANAGARI DIGIT FIVE
꤅	U+A905	[DecimalNumber]	KAYAH LI DIGIT FIVE
꧕	U+A9D5	[DecimalNumber]	JAVANESE DIGIT FIVE
꩕	U+AA55	[DecimalNumber]	CHAM DIGIT FIVE
꯵	U+ABF5	[DecimalNumber]	MEETEI MAYEK DIGIT FIVE
５	U+FF15	[DecimalNumber]	FULLWIDTH DIGIT FIVE
𐄋	U+1010B	[OtherNumber]	AEGEAN NUMBER FIVE
𐒥	U+104A5	[DecimalNumber]	OSMANYA DIGIT FIVE
𐹤	U+10E64	[OtherNumber]	RUMI DIGIT FIVE
𑁖	U+11056	[OtherNumber]	BRAHMI NUMBER FIVE
𑁫	U+1106B	[DecimalNumber]	BRAHMI DIGIT FIVE
𑃵	U+110F5	[DecimalNumber]	SORA SOMPENG DIGIT FIVE
𑄻	U+1113B	[DecimalNumber]	CHAKMA DIGIT FIVE
𑇕	U+111D5	[DecimalNumber]	SHARADA DIGIT FIVE
𑛅	U+116C5	[DecimalNumber]	TAKRI DIGIT FIVE
𝍤	U+1D364	[OtherNumber]	COUNTING ROD UNIT DIGIT FIVE
𝍭	U+1D36D	[OtherNumber]	COUNTING ROD TENS DIGIT FIVE
𝟓	U+1D7D3	[DecimalNumber]	MATHEMATICAL BOLD DIGIT FIVE
𝟝	U+1D7DD	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT FIVE
𝟧	U+1D7E7	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT FIVE
𝟱	U+1D7F1	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT FIVE
𝟻	U+1D7FB	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT FIVE
󠀵	U+E0035	[Format]	TAG DIGIT FIVE
6	U+36	[DecimalNumber]	DIGIT SIX
٦	U+666	[DecimalNumber]	ARABIC-INDIC DIGIT SIX
۶	U+6F6	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT SIX
߆	U+7C6	[DecimalNumber]	NKO DIGIT SIX
६	U+96C	[DecimalNumber]	DEVANAGARI DIGIT SIX
৬	U+9EC	[DecimalNumber]	BENGALI DIGIT SIX
੬	U+A6C	[DecimalNumber]	GURMUKHI DIGIT SIX
૬	U+AEC	[DecimalNumber]	GUJARATI DIGIT SIX
୬	U+B6C	[DecimalNumber]	ORIYA DIGIT SIX
௬	U+BEC	[DecimalNumber]	TAMIL DIGIT SIX
౬	U+C6C	[DecimalNumber]	TELUGU DIGIT SIX
೬	U+CEC	[DecimalNumber]	KANNADA DIGIT SIX
൬	U+D6C	[DecimalNumber]	MALAYALAM DIGIT SIX
๖	U+E56	[DecimalNumber]	THAI DIGIT SIX
໖	U+ED6	[DecimalNumber]	LAO DIGIT SIX
༦	U+F26	[DecimalNumber]	TIBETAN DIGIT SIX
၆	U+1046	[DecimalNumber]	MYANMAR DIGIT SIX
႖	U+1096	[DecimalNumber]	MYANMAR SHAN DIGIT SIX
፮	U+136E	[OtherNumber]	ETHIOPIC DIGIT SIX
៦	U+17E6	[DecimalNumber]	KHMER DIGIT SIX
᠖	U+1816	[DecimalNumber]	MONGOLIAN DIGIT SIX
᥌	U+194C	[DecimalNumber]	LIMBU DIGIT SIX
᧖	U+19D6	[DecimalNumber]	NEW TAI LUE DIGIT SIX
᪆	U+1A86	[DecimalNumber]	TAI THAM HORA DIGIT SIX
᪖	U+1A96	[DecimalNumber]	TAI THAM THAM DIGIT SIX
᭖	U+1B56	[DecimalNumber]	BALINESE DIGIT SIX
᮶	U+1BB6	[DecimalNumber]	SUNDANESE DIGIT SIX
᱆	U+1C46	[DecimalNumber]	LEPCHA DIGIT SIX
᱖	U+1C56	[DecimalNumber]	OL CHIKI DIGIT SIX
⑥	U+2465	[OtherNumber]	CIRCLED DIGIT SIX
⑹	U+2479	[OtherNumber]	PARENTHESIZED DIGIT SIX
⓺	U+24FA	[OtherNumber]	DOUBLE CIRCLED DIGIT SIX
❻	U+277B	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT SIX
➅	U+2785	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT SIX
➏	U+278F	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT SIX
꘦	U+A626	[DecimalNumber]	VAI DIGIT SIX
꣖	U+A8D6	[DecimalNumber]	SAURASHTRA DIGIT SIX
꣦	U+A8E6	[NonspacingMark]	COMBINING DEVANAGARI DIGIT SIX
꤆	U+A906	[DecimalNumber]	KAYAH LI DIGIT SIX
꧖	U+A9D6	[DecimalNumber]	JAVANESE DIGIT SIX
꩖	U+AA56	[DecimalNumber]	CHAM DIGIT SIX
꯶	U+ABF6	[DecimalNumber]	MEETEI MAYEK DIGIT SIX
６	U+FF16	[DecimalNumber]	FULLWIDTH DIGIT SIX
𐄌	U+1010C	[OtherNumber]	AEGEAN NUMBER SIX
𐒦	U+104A6	[DecimalNumber]	OSMANYA DIGIT SIX
𐹥	U+10E65	[OtherNumber]	RUMI DIGIT SIX
𑁗	U+11057	[OtherNumber]	BRAHMI NUMBER SIX
𑁬	U+1106C	[DecimalNumber]	BRAHMI DIGIT SIX
𑃶	U+110F6	[DecimalNumber]	SORA SOMPENG DIGIT SIX
𑄼	U+1113C	[DecimalNumber]	CHAKMA DIGIT SIX
𑇖	U+111D6	[DecimalNumber]	SHARADA DIGIT SIX
𑛆	U+116C6	[DecimalNumber]	TAKRI DIGIT SIX
𝍥	U+1D365	[OtherNumber]	COUNTING ROD UNIT DIGIT SIX
𝍮	U+1D36E	[OtherNumber]	COUNTING ROD TENS DIGIT SIX
𝟔	U+1D7D4	[DecimalNumber]	MATHEMATICAL BOLD DIGIT SIX
𝟞	U+1D7DE	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT SIX
𝟨	U+1D7E8	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT SIX
𝟲	U+1D7F2	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT SIX
𝟼	U+1D7FC	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT SIX
󠀶	U+E0036	[Format]	TAG DIGIT SIX
7	U+37	[DecimalNumber]	DIGIT SEVEN
٧	U+667	[DecimalNumber]	ARABIC-INDIC DIGIT SEVEN
۷	U+6F7	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT SEVEN
߇	U+7C7	[DecimalNumber]	NKO DIGIT SEVEN
७	U+96D	[DecimalNumber]	DEVANAGARI DIGIT SEVEN
৭	U+9ED	[DecimalNumber]	BENGALI DIGIT SEVEN
੭	U+A6D	[DecimalNumber]	GURMUKHI DIGIT SEVEN
૭	U+AED	[DecimalNumber]	GUJARATI DIGIT SEVEN
୭	U+B6D	[DecimalNumber]	ORIYA DIGIT SEVEN
௭	U+BED	[DecimalNumber]	TAMIL DIGIT SEVEN
౭	U+C6D	[DecimalNumber]	TELUGU DIGIT SEVEN
೭	U+CED	[DecimalNumber]	KANNADA DIGIT SEVEN
൭	U+D6D	[DecimalNumber]	MALAYALAM DIGIT SEVEN
๗	U+E57	[DecimalNumber]	THAI DIGIT SEVEN
໗	U+ED7	[DecimalNumber]	LAO DIGIT SEVEN
༧	U+F27	[DecimalNumber]	TIBETAN DIGIT SEVEN
၇	U+1047	[DecimalNumber]	MYANMAR DIGIT SEVEN
႗	U+1097	[DecimalNumber]	MYANMAR SHAN DIGIT SEVEN
፯	U+136F	[OtherNumber]	ETHIOPIC DIGIT SEVEN
៧	U+17E7	[DecimalNumber]	KHMER DIGIT SEVEN
᠗	U+1817	[DecimalNumber]	MONGOLIAN DIGIT SEVEN
᥍	U+194D	[DecimalNumber]	LIMBU DIGIT SEVEN
᧗	U+19D7	[DecimalNumber]	NEW TAI LUE DIGIT SEVEN
᪇	U+1A87	[DecimalNumber]	TAI THAM HORA DIGIT SEVEN
᪗	U+1A97	[DecimalNumber]	TAI THAM THAM DIGIT SEVEN
᭗	U+1B57	[DecimalNumber]	BALINESE DIGIT SEVEN
᮷	U+1BB7	[DecimalNumber]	SUNDANESE DIGIT SEVEN
᱇	U+1C47	[DecimalNumber]	LEPCHA DIGIT SEVEN
᱗	U+1C57	[DecimalNumber]	OL CHIKI DIGIT SEVEN
⑦	U+2466	[OtherNumber]	CIRCLED DIGIT SEVEN
⑺	U+247A	[OtherNumber]	PARENTHESIZED DIGIT SEVEN
⓻	U+24FB	[OtherNumber]	DOUBLE CIRCLED DIGIT SEVEN
❼	U+277C	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT SEVEN
➆	U+2786	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT SEVEN
➐	U+2790	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT SEVEN
꘧	U+A627	[DecimalNumber]	VAI DIGIT SEVEN
꣗	U+A8D7	[DecimalNumber]	SAURASHTRA DIGIT SEVEN
꣧	U+A8E7	[NonspacingMark]	COMBINING DEVANAGARI DIGIT SEVEN
꤇	U+A907	[DecimalNumber]	KAYAH LI DIGIT SEVEN
꧗	U+A9D7	[DecimalNumber]	JAVANESE DIGIT SEVEN
꩗	U+AA57	[DecimalNumber]	CHAM DIGIT SEVEN
꯷	U+ABF7	[DecimalNumber]	MEETEI MAYEK DIGIT SEVEN
７	U+FF17	[DecimalNumber]	FULLWIDTH DIGIT SEVEN
𐄍	U+1010D	[OtherNumber]	AEGEAN NUMBER SEVEN
𐒧	U+104A7	[DecimalNumber]	OSMANYA DIGIT SEVEN
𐹦	U+10E66	[OtherNumber]	RUMI DIGIT SEVEN
𑁘	U+11058	[OtherNumber]	BRAHMI NUMBER SEVEN
𑁭	U+1106D	[DecimalNumber]	BRAHMI DIGIT SEVEN
𑃷	U+110F7	[DecimalNumber]	SORA SOMPENG DIGIT SEVEN
𑄽	U+1113D	[DecimalNumber]	CHAKMA DIGIT SEVEN
𑇗	U+111D7	[DecimalNumber]	SHARADA DIGIT SEVEN
𑛇	U+116C7	[DecimalNumber]	TAKRI DIGIT SEVEN
𝍦	U+1D366	[OtherNumber]	COUNTING ROD UNIT DIGIT SEVEN
𝍯	U+1D36F	[OtherNumber]	COUNTING ROD TENS DIGIT SEVEN
𝟕	U+1D7D5	[DecimalNumber]	MATHEMATICAL BOLD DIGIT SEVEN
𝟟	U+1D7DF	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT SEVEN
𝟩	U+1D7E9	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT SEVEN
𝟳	U+1D7F3	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT SEVEN
𝟽	U+1D7FD	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT SEVEN
󠀷	U+E0037	[Format]	TAG DIGIT SEVEN
8	U+38	[DecimalNumber]	DIGIT EIGHT
٨	U+668	[DecimalNumber]	ARABIC-INDIC DIGIT EIGHT
۸	U+6F8	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT EIGHT
߈	U+7C8	[DecimalNumber]	NKO DIGIT EIGHT
८	U+96E	[DecimalNumber]	DEVANAGARI DIGIT EIGHT
৮	U+9EE	[DecimalNumber]	BENGALI DIGIT EIGHT
੮	U+A6E	[DecimalNumber]	GURMUKHI DIGIT EIGHT
૮	U+AEE	[DecimalNumber]	GUJARATI DIGIT EIGHT
୮	U+B6E	[DecimalNumber]	ORIYA DIGIT EIGHT
௮	U+BEE	[DecimalNumber]	TAMIL DIGIT EIGHT
౮	U+C6E	[DecimalNumber]	TELUGU DIGIT EIGHT
೮	U+CEE	[DecimalNumber]	KANNADA DIGIT EIGHT
൮	U+D6E	[DecimalNumber]	MALAYALAM DIGIT EIGHT
๘	U+E58	[DecimalNumber]	THAI DIGIT EIGHT
໘	U+ED8	[DecimalNumber]	LAO DIGIT EIGHT
༨	U+F28	[DecimalNumber]	TIBETAN DIGIT EIGHT
၈	U+1048	[DecimalNumber]	MYANMAR DIGIT EIGHT
႘	U+1098	[DecimalNumber]	MYANMAR SHAN DIGIT EIGHT
፰	U+1370	[OtherNumber]	ETHIOPIC DIGIT EIGHT
៨	U+17E8	[DecimalNumber]	KHMER DIGIT EIGHT
᠘	U+1818	[DecimalNumber]	MONGOLIAN DIGIT EIGHT
᥎	U+194E	[DecimalNumber]	LIMBU DIGIT EIGHT
᧘	U+19D8	[DecimalNumber]	NEW TAI LUE DIGIT EIGHT
᪈	U+1A88	[DecimalNumber]	TAI THAM HORA DIGIT EIGHT
᪘	U+1A98	[DecimalNumber]	TAI THAM THAM DIGIT EIGHT
᭘	U+1B58	[DecimalNumber]	BALINESE DIGIT EIGHT
᮸	U+1BB8	[DecimalNumber]	SUNDANESE DIGIT EIGHT
᱈	U+1C48	[DecimalNumber]	LEPCHA DIGIT EIGHT
᱘	U+1C58	[DecimalNumber]	OL CHIKI DIGIT EIGHT
⑧	U+2467	[OtherNumber]	CIRCLED DIGIT EIGHT
⑻	U+247B	[OtherNumber]	PARENTHESIZED DIGIT EIGHT
⓼	U+24FC	[OtherNumber]	DOUBLE CIRCLED DIGIT EIGHT
❽	U+277D	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT EIGHT
➇	U+2787	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT EIGHT
➑	U+2791	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT EIGHT
꘨	U+A628	[DecimalNumber]	VAI DIGIT EIGHT
꣘	U+A8D8	[DecimalNumber]	SAURASHTRA DIGIT EIGHT
꣨	U+A8E8	[NonspacingMark]	COMBINING DEVANAGARI DIGIT EIGHT
꤈	U+A908	[DecimalNumber]	KAYAH LI DIGIT EIGHT
꧘	U+A9D8	[DecimalNumber]	JAVANESE DIGIT EIGHT
꩘	U+AA58	[DecimalNumber]	CHAM DIGIT EIGHT
꯸	U+ABF8	[DecimalNumber]	MEETEI MAYEK DIGIT EIGHT
８	U+FF18	[DecimalNumber]	FULLWIDTH DIGIT EIGHT
𐄎	U+1010E	[OtherNumber]	AEGEAN NUMBER EIGHT
𐒨	U+104A8	[DecimalNumber]	OSMANYA DIGIT EIGHT
𐹧	U+10E67	[OtherNumber]	RUMI DIGIT EIGHT
𑁙	U+11059	[OtherNumber]	BRAHMI NUMBER EIGHT
𑁮	U+1106E	[DecimalNumber]	BRAHMI DIGIT EIGHT
𑃸	U+110F8	[DecimalNumber]	SORA SOMPENG DIGIT EIGHT
𑄾	U+1113E	[DecimalNumber]	CHAKMA DIGIT EIGHT
𑇘	U+111D8	[DecimalNumber]	SHARADA DIGIT EIGHT
𑛈	U+116C8	[DecimalNumber]	TAKRI DIGIT EIGHT
𝍧	U+1D367	[OtherNumber]	COUNTING ROD UNIT DIGIT EIGHT
𝍰	U+1D370	[OtherNumber]	COUNTING ROD TENS DIGIT EIGHT
𝟖	U+1D7D6	[DecimalNumber]	MATHEMATICAL BOLD DIGIT EIGHT
𝟠	U+1D7E0	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT EIGHT
𝟪	U+1D7EA	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT EIGHT
𝟴	U+1D7F4	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT EIGHT
𝟾	U+1D7FE	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT EIGHT
󠀸	U+E0038	[Format]	TAG DIGIT EIGHT
9	U+39	[DecimalNumber]	DIGIT NINE
٩	U+669	[DecimalNumber]	ARABIC-INDIC DIGIT NINE
۹	U+6F9	[DecimalNumber]	EXTENDED ARABIC-INDIC DIGIT NINE
߉	U+7C9	[DecimalNumber]	NKO DIGIT NINE
९	U+96F	[DecimalNumber]	DEVANAGARI DIGIT NINE
৯	U+9EF	[DecimalNumber]	BENGALI DIGIT NINE
੯	U+A6F	[DecimalNumber]	GURMUKHI DIGIT NINE
૯	U+AEF	[DecimalNumber]	GUJARATI DIGIT NINE
୯	U+B6F	[DecimalNumber]	ORIYA DIGIT NINE
௯	U+BEF	[DecimalNumber]	TAMIL DIGIT NINE
౯	U+C6F	[DecimalNumber]	TELUGU DIGIT NINE
೯	U+CEF	[DecimalNumber]	KANNADA DIGIT NINE
൯	U+D6F	[DecimalNumber]	MALAYALAM DIGIT NINE
๙	U+E59	[DecimalNumber]	THAI DIGIT NINE
໙	U+ED9	[DecimalNumber]	LAO DIGIT NINE
༩	U+F29	[DecimalNumber]	TIBETAN DIGIT NINE
၉	U+1049	[DecimalNumber]	MYANMAR DIGIT NINE
႙	U+1099	[DecimalNumber]	MYANMAR SHAN DIGIT NINE
፱	U+1371	[OtherNumber]	ETHIOPIC DIGIT NINE
៩	U+17E9	[DecimalNumber]	KHMER DIGIT NINE
᠙	U+1819	[DecimalNumber]	MONGOLIAN DIGIT NINE
᥏	U+194F	[DecimalNumber]	LIMBU DIGIT NINE
᧙	U+19D9	[DecimalNumber]	NEW TAI LUE DIGIT NINE
᪉	U+1A89	[DecimalNumber]	TAI THAM HORA DIGIT NINE
᪙	U+1A99	[DecimalNumber]	TAI THAM THAM DIGIT NINE
᭙	U+1B59	[DecimalNumber]	BALINESE DIGIT NINE
᮹	U+1BB9	[DecimalNumber]	SUNDANESE DIGIT NINE
᱉	U+1C49	[DecimalNumber]	LEPCHA DIGIT NINE
᱙	U+1C59	[DecimalNumber]	OL CHIKI DIGIT NINE
⑨	U+2468	[OtherNumber]	CIRCLED DIGIT NINE
⑼	U+247C	[OtherNumber]	PARENTHESIZED DIGIT NINE
⓽	U+24FD	[OtherNumber]	DOUBLE CIRCLED DIGIT NINE
❾	U+277E	[OtherNumber]	DINGBAT NEGATIVE CIRCLED DIGIT NINE
➈	U+2788	[OtherNumber]	DINGBAT CIRCLED SANS-SERIF DIGIT NINE
➒	U+2792	[OtherNumber]	DINGBAT NEGATIVE CIRCLED SANS-SERIF DIGIT NINE
꘩	U+A629	[DecimalNumber]	VAI DIGIT NINE
꣙	U+A8D9	[DecimalNumber]	SAURASHTRA DIGIT NINE
꣩	U+A8E9	[NonspacingMark]	COMBINING DEVANAGARI DIGIT NINE
꤉	U+A909	[DecimalNumber]	KAYAH LI DIGIT NINE
꧙	U+A9D9	[DecimalNumber]	JAVANESE DIGIT NINE
꩙	U+AA59	[DecimalNumber]	CHAM DIGIT NINE
꯹	U+ABF9	[DecimalNumber]	MEETEI MAYEK DIGIT NINE
９	U+FF19	[DecimalNumber]	FULLWIDTH DIGIT NINE
𐄏	U+1010F	[OtherNumber]	AEGEAN NUMBER NINE
𐒩	U+104A9	[DecimalNumber]	OSMANYA DIGIT NINE
𐹨	U+10E68	[OtherNumber]	RUMI DIGIT NINE
𑁚	U+1105A	[OtherNumber]	BRAHMI NUMBER NINE
𑁯	U+1106F	[DecimalNumber]	BRAHMI DIGIT NINE
𑃹	U+110F9	[DecimalNumber]	SORA SOMPENG DIGIT NINE
𑄿	U+1113F	[DecimalNumber]	CHAKMA DIGIT NINE
𑇙	U+111D9	[DecimalNumber]	SHARADA DIGIT NINE
𑛉	U+116C9	[DecimalNumber]	TAKRI DIGIT NINE
𝍨	U+1D368	[OtherNumber]	COUNTING ROD UNIT DIGIT NINE
𝍱	U+1D371	[OtherNumber]	COUNTING ROD TENS DIGIT NINE
𝟗	U+1D7D7	[DecimalNumber]	MATHEMATICAL BOLD DIGIT NINE
𝟡	U+1D7E1	[DecimalNumber]	MATHEMATICAL DOUBLE-STRUCK DIGIT NINE
𝟫	U+1D7EB	[DecimalNumber]	MATHEMATICAL SANS-SERIF DIGIT NINE
𝟵	U+1D7F5	[DecimalNumber]	MATHEMATICAL SANS-SERIF BOLD DIGIT NINE
𝟿	U+1D7FF	[DecimalNumber]	MATHEMATICAL MONOSPACE DIGIT NINE
󠀹	U+E0039	[Format]	TAG DIGIT NINE
