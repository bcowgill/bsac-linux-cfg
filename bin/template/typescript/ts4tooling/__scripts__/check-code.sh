#!/bin/bash
# Scan the code for common problems, issues.
# check-code.sh > check.log; less check.log
# check-code.sh | grep -vE '⋅|^\s*$' | wc -l
# Fix up typo errors in markers
# perl -i -pne 's{//\s+(MU[S]TDO|TO[D]O)}{// $1}xmsg; s{(MU[S]TDO|TO[D]O)\s+(?!DIP)}{$1(2022-06-29) }xmsg' `ggr -lE '(MU[S]TDO|TO[D]O) '`

# set -x

CYPRESS=
FAILURE=0
PCT='\%٪'

function show_problem {
	perl -pne '$_ = qq{   $_}' found.lst
	FAILURE=1
}

function show_bad {
	local type why FOUND
	type="$1"
	why="$2"
		icon="⋅😢"
		if [ ! -f found.lst ]; then
		echo DEBUG: $type no found.lst file present...
		fi
		if echo $type | grep ERROR > /dev/null; then
		icon="⋅❌"
		elif echo $type | grep WARN > /dev/null; then
		icon="⋅😡"
		fi
	FOUND=`cat found.lst | wc -l | perl -pne 's{\A\s*}{}xms; s{\s*\z}{}xms'`
	if [ "$FOUND" != 0 ]; then
		echo " "
		echo "$icon $type ($FOUND): $why"
		show_problem
		if [ `cat found.lst | wc -l` -gt 20 ]; then
			echo "$icon $type ($FOUND) end"
		fi
	fi
}

if [ ! -z "$CYPRESS" ]; then
#-------------------------------------------
git grep -E 'findBy(\w+)\([^U]' cypress \
	| grep -vE '__vendor__|:\s*//|\(UI\.|\(id\w*\)|findByRole\("dialog"\)|findByTestId\(testId\)|findByText\((regex|msg|txt)\w*\)' \
	> found.lst

show_bad "CYPRESS MINOR LITERAL" "Should define locators cypress/support/constatnts.js and use as UI.SOMETHING."

#-------------------------------------------
git grep -E 'findBy.+\.click\(' cypress \
	| grep -vE '__vendor__|findByTestId\(' \
	> found.lst

show_bad "WARN CYPRESS CLICK BY TEXT" "Should locate items to click with findByTestId."
fi # CYPRESS

#-------------------------------------------
git grep 'getAttribute' \
	| grep -vE '__vendor__|__scripts__|//.+getAttribute|getAttribute\("value")\s*===\s*"true"' \
	> found.lst

show_bad "WARN TEST ATTR" "Should use (.not).toHaveAttribute instead of .getAttribute in unit tests because it reports failures better."

#-------------------------------------------
git grep -E '\b(window|document|navigator|history|(local|session)Storage)\.' \
	| grep -vE ':\s*//|\@param' \
	| grep -vE 'window\.(digitalData|AppMeasurement|__|console)' \
	| grep -vE '(__.+__|/integration|docs|cypress)/' \
	| grep -vE 'src/(setupTests|utils/platform).js:' \
	> found.lst
	# | perl -pne 's{\A(.+?):.*\z}{$1\n}xms' | sort | uniq \

show_bad "WARN PLATFORM GLOBAL" "Using platform globals outside of src/utils/platform.js"

#-------------------------------------------
git grep 'async function ' \
	| grep -v '__scripts__' \
	| grep -v 'loader.mjs' \
	| grep -vE '/(__tests__|__vendor__|integration)/' \
	| grep -vE 'function (will|fetch)' \
	> found.lst

show_bad "ASYNC NAMED" "Asynchronous functions should be named willXxx or fetchXxx to show future tense."

#-------------------------------------------
git grep -iE '#[0-9a-f]{3,6}\b|rgba?\(\d+' \
	| grep -vE '/(__vendor__|Icons|stories|partnerConfigs|emma2-redesign)/' \
	| grep -vE 'theme2json\.|public/manifest.json|Binary file' \
	> found.lst

show_bad "COLORS" "Should define colors in partnerConfigs/*/theme.js"

#-------------------------------------------
git grep chunks \
	| grep -vE '__|(withHtml|WithHtmlLink)\.js' \
	> found.lst

show_bad "WARN VALUES HTML" "Should not use chunks and common HTML elements like em strong, see hooks/withHtml"

#-------------------------------------------
git grep -E 'import.+FormattedMessage.+react-intl' \
	| grep -vE '__|docs/|OptionalMessage.js:' \
	> found.lst

show_bad "ERROR react-intl/FormattedMessage" "Do not use react-intl FormattedMessage directly, make a styled wrapper using our OptionalSection/OptionalMessage component and remove defaultValue like we do with OptionalText from src/components/OptionaleMessage or src/components/SimpleText."

#-------------------------------------------
git grep -E 'import.+FormattedMessage.+from.+OptionalMessage' \
	| grep -v '__' \
	> found.lst

show_bad "ERROR FormattedMessage" "Do not use FormattedMessage with a wrapper, instead make the wraper component take an id and values and use OptionalSection/OptionalMessage like we do with OptionalText from src/components/OptionaleMessage or src/components/SimpleText."

#-------------------------------------------
git grep Modal.Text \
	| grep -vE '__(vendor|scripts|stories)__|e2/Modal/Text\.js' \
	> found.lst

show_bad "WARN MODAL MESSAGE" "Should use Modal.Message instead of Modal.Text which is deprecated."

#-------------------------------------------
git grep -E '<SimpleButton\b' \
	| grep -vE 'SimpleButton\.js' \
	| grep -vE '__|hooks/withHtml|components/WithHtmlLink/WithHtmlLink.js' \
	> found.lst

show_bad "WARN SIMPLE BUTTON" "Should use MessageButton from SimpleButton in preference to SimpleButton and a FormattedMessage/OptionalMessage"

#-------------------------------------------
git grep -E 'import.+\bButton\b' \
	| grep -vE 'components/e2/Button|\bLoadingButton\b|\bMessageButton\b|(SimpleButton|Hitbox|CollapsibleSection|LanguagePicker/Language)\.js' \
	| grep -v '__' \
	> found.lst

show_bad "WARN MESSAGE BUTTON" "Should use components/e2/Button, or MessageButton from components/{Button or SimpleMessageButton} in preference to Button and medi24 and a FormattedMessage/OptionalMessage."

#-------------------------------------------
git grep -E 'import.+\bButton\b.+@medi24-da2c/web-ui' \
	| grep -vE '(Simple(Message)?Button|__)' \
	> found.lst

show_bad "WARN BUTTON BUG" "Should use SimpleMessageButton or MessageButton as there is a bug in the medi24 Button."

#-------------------------------------------
git grep '@media' \
	| grep -vE '_MEDIA|_BREAKPOINT|/(stories|Visibility)/' \
	| grep -vE '__vendor__|__scripts__|__stories__|/docs/' \
	> found.lst

show_bad "WARN @MEDIA" "Should not be defining custom @media breakponts, use components/Visibility values..."

#-------------------------------------------
F=`git grep -lE '(DESKTOP|TABLET)_MEDIA' | grep /e2/`
echo -n "" > found.lst
for file in $F; do
	FILE=$file perl -ne '
		if (m{styled.+`}xms) {
			$print = 1;
			$desktop = 0;
		}
		if ($print) {
			print;
			if (m{DESKTOP_MEDIA}) {
				$desktop = 1;
			}
			if (m{TABLET_MEDIA}xms && !m{DESKTOP_MEDIA.+TABLET_MEDIA}xms) {
				print STDERR qq{$ENV{FILE}: line $.: $_} if $desktop;
			}
		}
		$print = 0 if m{\A`;\s*\z}xms;
	' $file > /dev/null 2>> found.lst
done
show_bad "ERROR DESKTOP_MEDIA" "DESKTOP_MEDIA must come after TABLET_MEDIA in styled components"

#-------------------------------------------
git grep -E '(padding|margin).*:.*\b([1-9]|[0-9]+px)' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/|Visibility/ShowVisibility' \
	| perl -pne 's{\d+(\.\d*)?rem\b}{NUMREM}xmsg; s{\b0\b}{ZEROREM}g;' \
	| grep -E '(margin|padding).*: -?[^0-9]*0[^0-9]*$' \
	| perl -pne 's{NUMREM}{???rem}xmsg; s{ZEROREM}{0}g;' \
	> found.lst

show_bad "WARN PIXELS" "Should be using rems instead of px for layout..."

#-------------------------------------------
git grep -E '(padding|margin).*:.*\b[0-9]+' \
	| grep -E '/e2/' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/|cypress/' \
	| perl -pne 's{/e2/}{/eTWO/}xmsg; s{([a-zA-Z]{5,}?)\d+([abcdef]?)\b}{$1N$2}xmsg' \
	| grep -vE '(margin|padding).*: -?[^0-9]*0[^0-9]*$' \
	| grep -E '[^e][1-9]+' \
	| perl -pne 's{/eTWO/}{/e2/}xmsg;' \
	> found.lst

show_bad "WARN CSS HARD CODES" "Should be using design token names instead of rem or px for layout..."

#-------------------------------------------
git grep -E 'opacity:.+?[0-9]' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/|cypress/' \
	| grep -vE '\.cls.+\{opacity' \
	| grep -vE '/\* opacity\w+' \
	> found.lst

show_bad "WARN CSS OPACITY CODES" "Should be using design token names instead of numbers for opacity."

#-------------------------------------------
git grep -E '(letter(-s|S)pacing|line(-h|H)eight|font(-s|S)ize|font(-w|W)eight).*:.*\b[0-9]+' \
	| grep -E '/e2/' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/' \
	| perl -pne 's{0\.}{ZEROPT }g' \
	| grep -vE '\b0\b' \
	| perl -pne 's{ZEROPT }{0.}g' \
	> found.lst

show_bad "ERROR FONT SIZES" "Should be using design token names instead of rem or px for fonts..."

git grep -iE '\b(font-?(family|size|weight)|line-?height|letter-?spacing)\b' \
	| grep /e2/ \
	| grep -vE '__|docs/|Typography.js|js:\s*//|theme.fontFamily' \
	> found.lst

show_bad "ERROR TYPOGRAPHY" "Should be using components/e2/Typography components instead of specific font CSS."

#-------------------------------------------
git grep -E 'import.+useTheme.+/useLanguage' src \
		| grep -v 'App/App.js' \
	> found.lst

show_bad "WARN THEME" "Should import { useTheme } from '@emotion/react' NOT hooks/useLanguage"

#-------------------------------------------
git grep -E 'props\.theme\.' \
	| grep -v 'PROPER WAY' \
	| grep -v '__vendor__|__scripts__' \
	> found.lst

show_bad "WARN THEME1" "Should check styled component in Storybook and change to themedProps.theme to indicate proper operation like src/components/Carousel/Bullet.js"

#-------------------------------------------
git grep Broken \
	| grep '__vendor__|__stories__' \
	> found.lst

show_bad "WARN THEME2" "Should fix Broken styled components in Storybook with useTheme and themedProps as in src/components/Carousel/Bullet.js"

#-------------------------------------------
git grep theme= \
	| grep -v 'ThemeProvider theme' \
	| grep '__vendor__|__stories__' \
	> found.lst

show_bad "WARN THEME3" "Should not pass theme in Storybook stories, fix the component with useTheme and themedProps"

#-------------------------------------------
git grep -E '<(Text|(Subh|H)eadline)\b' \
	| grep -vE '\.(Themed|Message)|theme=|\bid=|Modal/Message\.js|Headline\.test\.js|/OptionalTextOr\.js|/SuccessStep/ActivationCode\.js|/BasicInfoPage/Headline\.js|/BasicInfoPage/Text\.js|/ChooseMessengerPage/Headline\.js|/LandingPage/Text\.js|/Card/(Headline|Subheadline|Text)\.js' \
	> found.lst

show_bad "WARN THEME4" "Need to use the Xxx.Themed or Xxx.Message version of some @emotion/styled components to work in Storybook"

#-------------------------------------------
git grep -E 'theme.+getInstance' \
	| grep -vE '__tests__|__scripts__|__stories__/tools\.js|(setupTests|useLanguage)\.js' \
	> found.lst

show_bad "WARN THEME5" "Need to useTheme instead of getting it from getInstance()"

#-------------------------------------------
git grep -E 'getInstance\(\)' \
	| grep -vE '__|/hooks/|/translations/|/setupTests\.js|partnerConfigs/singleton\.js' \
	> found.lst

show_bad "WARN INSTANCE" "Should create or use a hook instead of calling getInstance() directly"

#-------------------------------------------
# Find all React components with propTypes but missing displayName
git grep -E '(\.displayName|\.propTypes) *=' \
	| perl -ne '
	s{\A([^:]+):}{}xms;
	my $file = $1;
	if (m{displayName}xms)
	{
		$found{$file}++;
	}
	elsif (m{propTypes})
	{
		if ($found{$file})
		{
			$found{$file}--;
		}
		else
		{
			print qq{$file: Missing displayName for $_};
		}
	}
	else
	{
		print STDERR qq{unknown: $file: $_}
	}
' \
	> found.lst

show_bad "WARN DISPLAYNAME" "Should have const displayName for each component to help debugging"

#-------------------------------------------
git grep -E '\.prototype\s*=' \
	| grep -vE '__|BulletSection/BulletSection\.js' \
	> found.lst

show_bad "ERROR PROTOTYPE" "Should not be making .prototype assignments. Did you mean .propTypes?"

#-------------------------------------------
git grep -E '((\bx(it|describe))|\.skip)\(' \
	| grep -vE '__vendor__|__scripts__' \
	> found.lst

show_bad "WARN TESTS SKIP" "Should not have any tests marked as .skip()."

#-------------------------------------------
git grep -iE '(mu[s]+tdo|to[d]o:?)[^(]' \
	| grep -vE '__vendor__|docs/|\.json|check-code' \
	| grep -ivE 'DIP-[0-9+]' \
	> found.lst

MD="MUST""DO/TO""DO"
TD="TO""DO"
show_bad "WARN $MD" "Should give $TD(name), $TD(date) or $TD DIP-NNNN on $MD items"

#-------------------------------------------
git grep -E 'class=' \
	| grep -vE '\.svg:' \
	| grep -vE '__(scripts|vendor|tests)__' \
	| grep -vE 'setupTests|public/index.html' \
	> found.lst

show_bad "ERROR CLASSNAME" "Should be using className= instead of class="

#-------------------------------------------
git grep -E 'window\.console\.' \
	| grep -v docs/ \
	| grep -vE '//|__vendor__|__scripts__|setupTests|PARTNER_NAME|src/tracking/track\.js|README.md:|cypress/support/commands\.js' \
	| grep -vE '(\w+) = window\.console\.\1' \
	| grep -vE 'window\.console && window\.console\.\w+' \
	> found.lst

show_bad "ERROR window.console" "Should remove your window.console debugging"

#-------------------------------------------
git grep -E 'debug\(|debugger|pause\(' \
	| grep -vE '//|__vendor__|__scripts__|setupTests|templates/' \
	> found.lst

show_bad "ERROR DEBUGGER" "Should remove your debugger, debug() or .pause() instructions from tests"

#-------------------------------------------
git grep -E 'DEBUG\s*=' \
	| grep -vE '//|false|process\.env\.|package.json|docs/|__vendor__|__scripts__|displayName|DEV_DEBUG_' \
	> found.lst

show_bad "ERROR DEBUG=" "Should set DEBUG= to false"

#-------------------------------------------
git grep -E 'DEBUG\s*=.+true' \
	| grep -vE '//|__vendor__|__scripts__' \
	> found.lst

show_bad "ERROR DEBUG=" "Should not have DEBUG= set true"

#-------------------------------------------
git grep -E '((\bf(it|describe))|\.only)\(' \
	| grep -vE '__vendor__|__scripts__' \
	> found.lst

show_bad "ERROR TESTS ONLY" "Should not have any tests marked as .only()."

#-------------------------------------------
git grep -iE 'mus+''tdo' \
	| grep -vE '__vendor__|docs/|check-code|mockNavigateToDoctorChatPage|README' \
	> found.lst

show_bad "WARN MUS""TDO" "Should resolve MUS""TDO items"

rm found.lst
exit $FAILURE
