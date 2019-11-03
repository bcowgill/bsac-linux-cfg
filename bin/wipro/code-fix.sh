#!/bin/bash
# perform automated code review fixes based on guidelines at :
# https://confluence.devops.lloydsbanking.com/display/PAS/Concrete+Examples+of+Front+End+Review

FILE="$1"

perl -i.bak -pne '
	$q = chr(39);

	# fix Gherkin indentation
	s{\A\s+(Feature:)}{$1}xms;
	s{\A\s*(Scenario|Background:|\@skip|\@devCWA)}{  $1}xms;
	s{\A\s*(Given|When|Then)}{    $1}xms;
	s{\A\s*(And)}{      $1}xms;

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
