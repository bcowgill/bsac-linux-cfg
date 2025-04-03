#!/usr/bin/env perl
# BSACKIT Part of Brent S.A. Cowgill's Developer Toolkit
# WINDEV tool useful on windows development machine
use FindBin;

sub usage
{
	print <<"USAGE";
$FindBin::Script [--help|--man|-?]

Output the same thing forever in 1MB chunks.  Useful for testing file operations on a full device.

--help  shows help for this program.
--man   shows help for this program.
-?      shows help for this program.

USAGE
	exit 0;
}

if (scalar(@ARGV) && $ARGV[0] =~ m{--help|--man|-\?}xms)
{
	usage()
}

my @phrases = (
	qq(I swear by my life and my love of it never to live for the sake of another man nor ask another man to live for the sake of mine.),
	qq(Ash nazg durbatulûk, ash nazg gimbatul, ash nazg thrakatulûk, agh burzum-ishi krimpatul / One Ring to rule them all, One Ring to find them, One Ring to bring them all, and in the darkness bind them. //),
	qq(But now beneath the hunter's moon /
		their unleashing all but soon /
		Bright blue lighting fire up in room /
		their legions are ready to bring your doom /
		Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn /
		Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn /
		Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn /
		Ph'nglui mglw'nafh Cthulhu R'lyeh wgah'nagl fhtagn //
	),
	qq(Three Rings for the Elven-kings under the sky, /
		Seven for the Dwarf-lords in their halls of stone, /
		Nine for Mortal Men doomed to die, /
		One for the Dark Lord on his dark throne /
		In the Land of Mordor where the Shadows lie. /
		One Ring to rule them all, One Ring to find them, /
		One Ring to bring them all, and in the darkness bind them /
		In the Land of Mordor where the Shadows lie. //
	),
	qq(Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Proin tortor purus platea sit eu id nisi litora libero. Neque vulputate consequat ac amet augue blandit maximus aliquet congue. Pharetra vestibulum posuere ornare faucibus fusce dictumst orci aenean eu facilisis ut volutpat commodo senectus purus himenaeos fames primis convallis nisi.
	),
	qq(Oh freddled gruntbuggly, /
		Thy micturitions are to me, (with big yawning) /
		As plurdled gabbleblotchits, /
		On a lurgid bee, /
		That mordiously hath blurted out, /
		Its earted jurtles, grumbling /
		Into a rancid festering confectious organ squealer. [drowned out by moaning and screaming] /
		Now the jurpling slayjid agrocrustles, /
		Are slurping hagrilly up the axlegrurts, /
		And living glupules frart and stipulate, /
		Like jowling meated liverslime, /
		Groop, I implore thee, my foonting turlingdromes, /
		And hooptiously drangle me, /
		With crinkly bindlewurdles. /
		Or else I shall rend thee in the gobberwarts with my blurglecruncheon, /
		See if I don't! //
	),
	qq(
		This is the end /
		Beautiful friend /
		This is the end /
		My only friend, the end //

		Of our elaborate plans, the end /
		Of everything that stands, the end /
		No safety or surprise, the end /
		I'll never look into your eyes again //

		Can you picture what will be? /
		So limitless and free /
		Desperately in need /
		Of some stranger's hand /
		In a desperate land //

		Lost in a Roman wilderness of pain /
		And all the children are insane /
		All the children are insane /
		Waiting for the summer rain, yeah //

		There's danger on the edge of town /
		Ride the King's Highway, baby /
		Weird scenes inside the gold mine /
		Ride the highway west, baby /
		Ride the snake, ride the snake /
		To the lake, the ancient lake, baby /
		The snake, he's long, seven miles /
		Ride the snake /
		He's old and his skin is cold /
		The west is the best /
		The west is the best /
		Get here and we'll do the rest /
		The blue bus is calling us /
		The blue bus is calling us /
		Driver, where you taking us? //

		The killer awoke before dawn /
		He put his boots on /
		He took a face from the ancient gallery /
		And he walked on down the hall /
		He went into the room where his sister lived, and then he /
		Paid a visit to his brother, and then he /
		He walked on down the hall, and /
		And he came to a door /
		And he looked inside /
		"Father?" "Yes, son?" "I want to kill you" /
		"Mother? I want to..." /
		"Have my way" //

		Come on baby, take a chance with us /
		Come on baby, take a chance with us /
		Come on baby, take a chance with us /
		And meet me at the back of the blue bus /
		Doin' a blue rug, on a blue bus, doin' a /
		Come on yeah /
		Fuck, fuck-ah, yeah /
		Fuck, fuck /
		Fuck, fuck /
		Fuck, fuck, fuck yeah! /
		Come on baby, come on /
		Fuck me baby, fuck yeah /
		Woah /
		Fuck, fuck, fuck, yeah! /
		Fuck, yeah, come on baby /
		Fuck me baby, fuck fuck /
		Woah, woah, woah, yeah /
		Fuck yeah, do it, yeah /
		Come on! /
		Huh, huh, huh, huh, yeah /
		Alright /
		Kill, kill, kill, kill, kill, kill //

		This is the end /
		Beautiful friend /
		This is the end /
		My only friend, the end //

		It hurts to set you free /
		But you'll never follow me /
		The end of laughter and soft lies /
		The end of nights we tried to die /
		This is the end. ///
	),
	qq(I’ve seen horrors… horrors that you’ve seen. But you have no right to call me a murderer. You have a right to kill me. You have a right to do that… but you have no right to judge me. It’s impossible for words to describe what is necessary to those who do not know what horror means. Horror. Horror has a face… and you must make a friend of horror. Horror and moral terror are your friends. If they are not then they are enemies to be feared. They are truly enemies. I remember when I was with Special Forces. Seems a thousand centuries ago. We went into a camp to inoculate the children. We left the camp after we had inoculated the children for Polio, and this old man came running after us and he was crying. He couldn’t see. We went back there and they had come and hacked off every inoculated arm. There they were in a pile. A pile of little arms. And I remember… I… I… I cried. I wept like some grandmother. I wanted to tear my teeth out. I didn’t know what I wanted to do. And I want to remember it. I never want to forget it. I never want to forget. And then I realized… like I was shot… like I was shot with a diamond… a diamond bullet right through my forehead. And I thought: My God… the genius of that. The genius. The will to do that. Perfect, genuine, complete, crystalline, pure. And then I realized they were stronger than we. Because they could stand that these were not monsters. These were men… trained cadres. These men who fought with their hearts, who had families, who had children, who were filled with love… but they had the strength… the strength… to do that. If I had ten divisions of those men our troubles here would be over very quickly. You have to have men who are moral… and at the same time who are able to utilize their primordial instincts to kill without feeling… without passion… without judgment… without judgment. Because it’s judgment that defeats us.
	),
	qq(
		There's a grief that can't be spoken /
		There's a pain goes on and on /
		Empty chairs at empty tables /
		Now my friends are dead and gone. /

		Here they talked of revolution /
		Here it was they lit the flame /
		Here they sang about 'tomorrow' /
		And tomorrow never came /

		From the table in the corner /
		They could see a world reborn /
		And they rose with voices ringing /
		I can hear them now /
		The very words that they had sung /
		Became their last communion /
		On the lonely barricade at dawn! /

		Oh my friends, my friends, forgive me /
		That I live and you are gone. /
		There's a grief that can't be spoken /
		There's a pain goes on and on. /

		Phantom faces at the window /
		Phantom shadows on the floor /
		Empty chairs at empty tables /
		Where my friends will meet no more. /

		Oh my friends, my friends, don't ask me /
		What your sacrifice was for /
		Empty chairs at empty tables /
		Where my friends will sing no more. //
	),
);
my $default = $phrases[int(rand(scalar(@phrases)))];
$default =~ s{\s+}{ }xmsg;

my $mb = 1024 * 1024;
my $MAX = 4 * 1024 * $mb;
my $NL = "\n"; # " "

my $length = 0;
my $output = join(' ', @ARGV || ($default)) . $NL;
$output = $output x (int($mb / length($output)));
my $chunk = length($output);

do {
	print $output;
	$length += $chunk;
	die "Maximum size $MAX reached" if ($MAX && $length >= $MAX);
} while (1);

__END__
