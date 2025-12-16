#!/bin/bash
# convert: a murder of crows
# to:      crows,murder

# Sources for collective nouns lists:
# https://englishstudyhere.com/collective-nouns/english-collective-nouns-list/
# https://www.englishgrammar.org/collective-nouns/
# https://www.collinsdictionary.com/word-lists/animal-collective-nouns
# TODO https://www.adducation.info/mankind-nature-general-knowledge/collective-nouns-for-animals/
# names for offspring by animal type
# https://lessonsforenglish.com/vocabulary/100-animals-and-their-babies-names-animals-and-their-young-ones/
perl -i -ne '
	next if m{\A\s*\z}xms;
	$_ = lc($_);
	print;
' english-collective-nouns.txt
perl -pne '
	chomp;
	s{\Aan?\s+}{}xms;
	my ($group, $noun) = split(/\s+of\s+/);
	$_ = "$noun,$group\n";
' english-collective-nouns.txt  | sort | uniq > english-collective-nouns.csv



__END__
// convert animals from html page
var type = document.querySelectorAll("a.ref")
var animals = {};
var Animals = [];
var CSV = [];
var stop = false;
type.forEach((el) => {
  if (stop) { return; }
  var parts = el.parentElement.parentElement.innerText.split(/\s+/);
  var group = parts.shift();
  if (group === "woodcocks") {
    stop = true;
    return;
  }
  parts.forEach((name) => {
    name = name.replace(',', '');
    if (name !== "or") {
      var phrase = `a ${name} of ${group}`;
      if (!animals[phrase]) {
        Animals.push(phrase);
        CSV.push(`${group},${name}`);
        animals[phrase] = true;
      }
    }
  });
});
console.warn("\n\n" + Animals.join("\n"));
console.warn("\n\n" + CSV.join("\n"));

# Fix a outfit .. to an outfit
perl -i -pne 's{\Aa\s([aeiou])}{an $1}xmsg' english-collective-nouns.txt
# Resort
F=english-collective-nouns.txt
F=english-collective-nouns.csv
cp $F $F.saved; sort < $F.saved | uniq > $F; rm $F.saved


// Animals and their offspring
r=document.querySelectorAll('tr');
what=[];r.forEach((el) => { let td=el.querySelectorAll('td'); let mom=td[0].innerText.toLowerCase(); let young = td[1].innerText.toLowerCase().split(/,\s*/); young.forEach(pup => { let a = /^[aeiou]/.test(mom) ? "an" : "a"; what.push(`${a} ${mom} produces a ${pup}`) });   })
