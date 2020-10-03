#!/usr/bin/env perl
# Shakespearean insult generator.

use strict;
use warnings;
use English;

my @Insult1 = qw(
artless
bawdy
beslubbering
bootless
churlish
cockeyed
clouted
craven
currish
dankish
dissembling
droning
errant
fawning
fobbing
froward
frothy
gleeking
goatish
gorbellied
impertinent
infectious
jarring
joggerheaded
lumpish
mammering
mangled
mewling
paunchy
pribbling
puking
puny
qualling
rank
reeky
roguish
ruttish
saucy
spleeny
spongy
surly
tottering
unmuzzled
vain
venomed
villainous
warped
wayward
weedy
yeasty
);

my @Insult2 = qw(
base-court
bat-fouling
beef-witted
beetle-headed
boil-brained
clapper-clawed
clay-brained
common-kissing
crook-pated
dismal-dreaming
dizzy-eyed
dog-hearted
dread-bolted
earth-vexing
elf-skinned
fat-kidneyed
fen-sucked
flap-mouthed
fly-bitten
folly-fallen
fool-born
full-gorged
guts-griping
half-faced
hasty-witted
hedge-born
hell-hated
idle-headed
ill-breeding
ill-nurtured
knotty-pated
motley-minded
milk-livered
onion-eyed
plume-plucked
pottle-deep
pox-marked
reeling-ripe
rough-hewn
rude-growing
rump-fed
shard-borne
sheep-biting
spur-galled
swag-bellied
tardy-gaited
tickle-brained
toad-spotted
urchin-snoted
weather-bitten
);

my @Insult3 = qw(
apple-john
baggage
barnacle
bladder
boar-pig
bugbear
bum-bailey
canket-blossom
clack-dish
clotpole
coxcomb
codpiece
death-token
dewberry
flap-dragon
flax-wench
flirt-gill
foot-licker
futilarrian
giglet
gudgeon
haggard
harpy
hedge-pig
horn-beast
hugger-mugger
joithead
lewduster
lout
maggot-pie
malt-worm
mammet
measle
minnow
miscreant
moldwarp
mumble-news
nut-hook
pigeon-egg
pignut
puttock
pumpion
ratsbane
scut
skainsmate
strumpot
varlot
vassal
wheyface
wagtail
);


sub choose
{
	my ($Choices) = @ARG;
	my $index = int(rand(scalar(@$Choices)));
	my $choice = $Choices->[$index];
	return $choice;
}

sub insult
{
	my $insult1 = choose(\@Insult1);
	my $insult2 = choose(\@Insult2);
	my $insult3 = choose(\@Insult3);

	return qq{Thou $insult1 $insult2 $insult3!\n};
}

sub main
{
	print insult();
}

main();
