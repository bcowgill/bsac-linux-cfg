#!/usr/bin/env perl
# take a pasted bunch of html and enquote it as a javascript string.

use strict;
use warnings;
use English qw(-no_match_vars); 

my $input;
local $INPUT_RECORD_SEPARATOR = undef;
$input = <STDIN>;
$input =~ s{\n\s*}{\\n}xmsg;
if ($input =~ m{"}xms)
{
   if ($input =~ m{'}xms)
   {
      $input =~ s{'}{\\'}xmsg;
      print qq{'$input'\n};
   }
   else
   {
      print qq{'$input'\n};
   }
}
else
{
   print qq{"$input"\n};
}

__END__
example with only single quotes in the html
<svg class='hidden definitions' width='100' height='100'>
	<defs>
		<g id='svg-icon-circle'><circle cx='0' cy='0' r='50' /></g>
		<g id='svg-icon-triangle-up'><polygon points='0,-50 43.3,25 -43.3,25' /></g>
		<g id='svg-icon-diamond'><polygon points='50,0 0,50 -50,0 0,-50' /></g>
		<g id='svg-icon-pentagon-up'><polygon points='0,-50 47.55,-15.45 29.39,40.45 -29.39,40.45 -47.55,-15.45' /></g>
		<g id='svg-icon-star-up'><polygon points='0,-50 29.39,40.45 -47.55,-15.45 47.55,-15.45 -29.39,40.45' /></g>
		<g id='svg-icon-hexagon-up'><polygon points='0,50 -43.3,25 -43.3,-25 0,-50 43.3,-25 43.3,25' /></g>
	</defs>
</svg>

example with only double quotes in the html
<svg class="hidden definitions" width="100" height="100">
	<defs>
		<g id="svg-icon-circle"><circle cx="0" cy="0" r="50" /></g>
		<g id="svg-icon-triangle-up"><polygon points="0,-50 43.3,25 -43.3,25" /></g>
		<g id="svg-icon-diamond"><polygon points="50,0 0,50 -50,0 0,-50" /></g>
		<g id="svg-icon-pentagon-up"><polygon points="0,-50 47.55,-15.45 29.39,40.45 -29.39,40.45 -47.55,-15.45" /></g>
		<g id="svg-icon-star-up"><polygon points="0,-50 29.39,40.45 -47.55,-15.45 47.55,-15.45 -29.39,40.45" /></g>
		<g id="svg-icon-hexagon-up"><polygon points="0,50 -43.3,25 -43.3,-25 0,-50 43.3,-25 43.3,25" /></g>
		<g id="svg-icon-cross-up"><polygon points="48.3,12.94 -48.3,12.94 -48.3,-12.93 48.3,-12.93" />
		<polygon points="-12.93,48.3 -12.93,-48.3 12.94,-48.3 12.94,48.3" /></g>
		<g id="svg-icon-triangle-down"><polygon points="0,50 -43.3,-25 43.3,-25" /></g>
		<g id="svg-icon-square"><rect x="-35.36" y="-35.36" width="70.72" height="70.72" /></g>
		<g id="svg-icon-pentagon-down"><polygon points="0,50 -47.55,15.45 -29.39,-40.45 29.39,-40.45 47.55,15.45" /></g>
		<g id="svg-icon-hexagon-side"><polygon points="50,0 25,43.3 -25,43.3 -50,0 -25,-43.3 25,-43.3" /></g>
		<g id="svg-icon-star-down"><polygon points="0,50 -29.39,-40.45 47.55,15.45 -47.55,15.45 29.39,-40.45" /></g>
		<g id="svg-icon-cross-side"><polygon points="25,43.3 -43.3,-25 -25,-43.3 43.3,25" />
		<polygon points="-43.3,25 25,-43.3 43.3,-25 -25,43.3" /></g>
		<g id="icon-checked" transform="translate(-50,-50)"><path
			fill="aquamarine" fill-opacity="1" fill-rule="nonzero" 
			stroke="black" stroke-opacity="1" stroke-width="2" stroke-dasharray="none" stroke-dashoffset="" stroke-linejoin="round" stroke-linecap="butt" 
			opacity="1" 
			marker-start="" marker-mid="" marker-end=""
			d="M 1.5 63 L 39 98.5 L 98.5 18.5 L 78 1.5 L 39 76.5 L 18 43 Z"></path></g>
		<g id="icon-crossed" transform="translate(-50,-50)"><path 
			fill="red" fill-opacity="1" fill-rule="nonzero"  
			stroke="black" stroke-opacity="1" stroke-width="2" stroke-dasharray="none" stroke-dashoffset="" stroke-linejoin="round" stroke-linecap="butt" 
			opacity="1" 
			marker-start="" marker-mid="" marker-end="" 
			d="M 1.5 27 L 29 1.5 L 44 40.5 L 72 1.5 L 98.5 16.5 L 54.5 50 L 98.5 74 L 71 98.5 L 47 58 L 23 98.5 L 1.5 78 L 35.5 54 Z"></path></g>
	</defs>
</svg>


example with both single and double quotes in the html
<svg class="hidden definitions" width="100" height="100">
	<defs>
		<g id="svg-icon-circle"><circle cx="0" cy="0" r="50" /></g>
		<g id="svg-icon-triangle-up"><polygon points="0,-50 43.3,25 -43.3,25" /></g>
		<g id="svg-icon-diamond"><polygon points="50,0 0,50 -50,0 0,-50" /></g>
		<g id='svg-icon-pentagon-up'><polygon points='0,-50 47.55,-15.45 29.39,40.45 -29.39,40.45 -47.55,-15.45' /></g>
		<g id='svg-icon-star-up'><polygon points='0,-50 29.39,40.45 -47.55,-15.45 47.55,-15.45 -29.39,40.45' /></g>
		<g id='svg-icon-hexagon-up'><polygon points='0,50 -43.3,25 -43.3,-25 0,-50 43.3,-25 43.3,25' /></g>
	</defs>
</svg>

