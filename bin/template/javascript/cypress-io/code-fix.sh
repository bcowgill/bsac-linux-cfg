#!/bin/bash
# perform automated code review fixes based on guidelines at :
# https://confluence.devops.lloydsbanking.com/display/PAS/Concrete+Examples+of+Front+End+Review

if [ -z "$1" ]; then
	echo "
usage: $(basename $0) filename...

Perform automated code review fixes based on guidelines at:

https://confluence.devops.lloydsbanking.com/display/PAS/Concrete+Examples+of+Front+End+Review

To fix all the files on your branch:

$(basename $0) \`git diff --name-only develop\`
"
	exit 1
fi

FILE="$1"

perl -i.bak -pne '
	$q = chr(39);
	if (m{function\s+desc(\w+)Suite}xms)
	{
		$object_name = $object_name || $1;
	}

	# fix Gherkin indentation
	s{\A\s+(Feature:)}{$1}xms;
	s{\A\s*(Scenario|Background:|\@skip|\@devCWA)}{  $1}xms;
	s{\A\s*(Given|When|Then)}{    $1}xms;
	s{\A\s*(And)}{      $1}xms;

	# fix describe/it anon functions
	if (m{(it|describe|beforeEach|afterEach|skip\w+)\(.*?\(\s*\w*\s*\)\s*=>}xms) {
		$object_name = $object_name || "ObjectName";
		s{(describe\(.+?,\s*)(\(\s*\w*\s*\))\s*=>\s*}{$1function desc${object_name}FunctionMMM$2 }xms;
		s{((it|skip\w+)\(.+?,\s*)(\(\s*\w*\s*\))\s*=>\s*}{$1function test${object_name}FunctionCaseMMM$3 }xms;
		s{(beforeEach\()\s*\(\s*\)\s*=>\s*}{$1function setupTestsMMM() }xms;
		s{(afterEach\()\s*\(\s*\)\s*=>\s*}{$1function tearDownMMM() }xms;
	}

	# fix .calledOnce first...
	s{expect\(\s*(\w+)(.*?)\.called(?:Once)?\s*\)\s*\.toBe(?:Truthy|True)\s*\(\s*\)}{qq{expect($1$2.callCount).toBe(1)}}xmsge;
	s{expect\(\s*(\w+)(.*?)\.called(?:Once)?\s*\)\s*\.to(?:Be|Equal)\s*\(\s*true\s*\)}{qq{expect($1$2.callCount).toBe(1)}}xmsge;
	s{expect\(\s*(\w+)(.*?)\.called(?:Once)?\s*\)\s*\.toBe(?:Falsy|False)\s*\(\s*\)}{qq{expect($1$2.callCount).toBe(0)}}xmsge;
	s{expect\(\s*(\w+)(.*?)\.called(?:Once)?\s*\)\s*\.to(?:Be|Equal)\s*\(\s*false\s*\)}{qq{expect($1$2.callCount).toBe(0)}}xmsge;
	s{\.called(Once)?\b}{.callCount}xmsg;

	# fix component state/prop checks true/false ish
	s{expect\(\s*((\w+\.(?:state|prop))\s*\(\s*$q(\w+)$q\s*\))\)\s*\.to(?:Be|Equal)\s*\(\s*(true|false|undefined|null)\s*\)}{qq{expect@{[ucfirst($4)]}(${q}$2.$3NNN$q, $1)}}xmsge;
	s{expect\(\s*((\w+\.(?:state|prop))\s*\(\s*$q(\w+)$q\s*\))\)\s*\.toBe(True|False|Undefined|Null|Truthy|Falsy|Defined)\s*\(\s*\)}{qq{expect$4(${q}$2.$3NNN$q, $1)}}xmsge;

	# fix value checks true/false ish
	s{expect\(\s*(\w+)(.*?)\s*\)\s*\.to(?:Be|Equal)\s*\(\s*(true|false|undefined|null)\s*\)}{qq{expect@{[ucfirst($3)]}($q$1NNN$q, $1$2)}}xmsge;
	s{expect\(\s*(\w+)(.*?)\s*\)\s*\.toBe(True|False|Undefined|Null|Truthy|Falsy|Defined)\s*\(\s*\)}{qq{expect@{[ucfirst($3)]}($q$1NNN$q, $1$2)}}xmsge;
	s{expect\(\s*(\w+)(.*?)\s*\)\s*\.not\s*\.to(?:Be|Equal)\s*\(\s*(true|false|undefined|null)\s*\)}{qq{expectNot@{[ucfirst($3)]}($q$1NNN$q, $1$2)}}xmsge;

	# any remaining .toBeTruthy etc
	s{(\.to(?:Be|Equal)\s*\(\s*(true|false|undefined|null)\s*\))}{qq{$1 /* MUSTDO maybe expect@{[ucfirst($2)]}}}xmsge;
	s{(\.toBe(True|False|Undefined|Null|Truthy|Falsy|Defined)\s*\(\s*\))}{qq{$1 /* MUSTDO maybe  expect$2 */}}xmsge;

	# toEqual
	s{\.toEqual\s*\(\s*(\d+|$q[^$q]*$q)\s*\)}{.toBe($1)}xmsg;

' "$FILE"

# TODO .hasClass fix
