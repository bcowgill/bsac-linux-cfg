#!/bin/bash
# Scan the code for common problems, issues.
# check-code.sh > check.log; less check.log
# check-code.sh | grep -vE '⋅|^\s*$' | wc -l
# perl -i -pne 's{//\s+(MU[S]TDO|TO[D]O)}{// $1}xmsg; s{(MU[S]TDO|TO[D]O)\s+(?!DIP)}{$1(2022-06-29) }xmsg' `ggr -lE '(MU[S]TDO|TO[D]O) '`

#CYP=1
#ALLZ=1

DEBUG=
FAILURE=0
COUNT=0

PCT='\%٪'
#LANGUAGES="src/translations src/partnerConfigs"
#TRANSLATIONS="`ls -1 src/translations/*.json | grep -vE '\bempty.+json'` `find src/partnerConfigs -type f -name '*.json' | grep -vE '__dev__/|infra\.|package\.|theme\.|_(BASE|REMOTE|LOCAL)'`"
#echo TRANSLATIONS=$TRANSLATIONS

if [ "$1" == "--tests" ]; then
	CYP=1
	TRANSLATIONS=translations/*.json
	LANGUAGES=translations/*.json
	ALLZ=1
	cd in
fi

function show_problem {
	perl -pne '$_ = qq{   $_}' found.lst
	FAILURE=1
}

function show_bad {
	local type why FOUND
	type="$1"
	why="$2"
	icon="⋅😢"
	COUNT=$(($COUNT + 1))
	if [ ! -f found.lst ]; then
		echo DEBUG: $type no found.lst file present...
	fi
	if echo $type | grep ERROR > /dev/null; then
		icon="⋅❌"
	elif echo $type | grep WARN > /dev/null; then
		icon="⋅😡"
	fi
	if [ ! -z "$DEBUG" ]; then
		icon="$icon $COUNT"
		echo "show_bad #$COUNT [$type $why]" 1>&2
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

# set -x
if [ ! -z "$CYP" ]; then
# Test Cases are named from english-words.txt letter z backwards
# so you can grep for testcase to see where the test data relates
#------------------------------------------- testcase zymurgy,1
git grep -E 'findBy(\w+)\([^U]' cypress \
	| grep -vE '__vendor__|:\s*//|\(UI\.|\(id\w*\)|findByRole\("dialog"\)|findByTestId\(testId\)|findByText\((regex|msg|txt)\w*\)' \
	> found.lst

show_bad "CYPRESS MINOR LITERAL" "Should define locators cypress/support/constatnts.js and use as UI.SOMETHING."

#------------------------------------------- testcase zymotic,2
git grep -E 'findBy.+\.click\(' cypress \
	| grep -vE '__vendor__|findByTestId\(' \
	> found.lst

show_bad "WARN CYPRESS CLICK BY TEXT" "Should locate items to click with findByTestId."

fi # CYP

#------------------------------------------- testcase zymosis,3
git grep 'getAttribute' \
	| grep -vE '__vendor__|__scripts__|\.toMatch\(|//.+getAttribute|getAttribute\("value"\)\s*===\s*"true"' \
	> found.lst

show_bad "WARN TEST ATTR" "Should use (.not).toHaveAttribute instead of .getAttribute in unit tests because it reports failures better."

#------------------------------------------- testcase zymase,4
git grep -E 'waitFor.+toMatchSnapshot' \
	> found.lst

show_bad "ERROR TEST SNAPSHOT" "Do not put toMatchSnapshot inside a waitFor function.  It will ruin your snapshots when you run tests in isolation with skip/only.  Put it AFTER the waitFor completes."

#------------------------------------------- testcase zygotic,5
git grep -E '\b(window|document|navigator|history|(local|session)Storage)\.' \
	| grep -vE ':\s*//|\@param' \
	| grep -vE 'window\.(digitalData|AppMeasurement|__|console)' \
	| grep -vE '(__.+__|/integration|docs|cypress)/' \
	| grep -vE 'src/(setupTests|utils/platform).js:' \
	> found.lst
	# | perl -pne 's{\A(.+?):.*\z}{$1\n}xms' | sort | uniq \

show_bad "WARN PLATFORM GLOBAL" "Using platform globals outside of src/utils/platform.js"

#------------------------------------------- testcase zygotene,6
git grep -E 'JSON\.parse\(JSON\.stringify' \
	| grep -v '__scripts__/' \
	| grep -vE '/(__tests__|__vendor__|integration)/' \
	> found.lst

show_bad "ERROR CLONE" "Don't use JSON.parse(JSON.stringify to clone an object except in tests.  Use structuredClone() or _.cloneDeep() as a fallback."

#------------------------------------------- testcase zygote,7
git grep 'async function ' \
	| grep -v '__scripts__/' \
	| grep -vE '/(__tests__|__vendor__|integration)/' \
	| grep -vE 'function (will|fetch)' \
	> found.lst

show_bad "ASYNC NAMED" "Asynchronous functions should be named willXxx or fetchXxx to show future tense."

#------------------------------------------- testcase zygoptera,8
git grep -iE '#[0-9a-f]{3,6}\b|rgba?\(\d+' \
	| grep -vE '/(__vendor__|Icons|stories|partnerConfigs|emma2-redesign)/' \
	| grep -vE 'theme2json\.|public/manifest.json|Binary file' \
	> found.lst

show_bad "COLORS" "Should define colors in partnerConfigs/*/theme.js"

if [ ! -z "$TRANSLATIONS" ]; then
#------------------------------------------- testcase zygophyllum,9
git grep -E 'e2\.\w+\.content(|[04-9]|[0-9][0-9]+)"' $TRANSLATIONS \
	> found.lst

show_bad "FEATURE KEY1" "Feature message key should be renamed e2.*.content[1-3] (up to content3 allowed)"

# UNTESTED ALL BELOW TO NEXT IF
#-------------------------------------------
git grep -E 'e2\.\w+\.service.logo(|[04-9]|[0-9][0-9]+)"' $TRANSLATIONS \
	> found.lst

show_bad "FEATURE KEY2" "Feature message key should be renamed e2.*.service.logo[1-3] (up to logo3 allowed)"

#-------------------------------------------
git grep -E 'e2\.\w+\.service.benefit(|[06-9]|[0-9][0-9]+)\.' $TRANSLATIONS \
	> found.lst

show_bad "FEATURE KEY3" "Feature message key should be renamed e2.*.service.benefit[1-5].* (up to benefit5 allowed)"

#-------------------------------------------
git grep -E 'e2\.\w+\.service.benefit[1-5]\.p(|[06-9]|[0-9][0-9]+)"' $TRANSLATIONS \
	> found.lst

show_bad "FEATURE KEY4" "Feature message key should be renamed e2.*.service.benefit[1-5].p[1-5] (up to p5 allowed)"

#-------------------------------------------
git grep -E 'e2\.\w+\.service.howMany\.' $TRANSLATIONS \
	> found.lst

show_bad "FEATURE KEY5" "Feature message key should be renamed e2.*.service.question.*"

#-------------------------------------------
git grep -E 'pco\.' src/translations/empty*.json \
	> found.lst

show_bad "ERROR EMPTY JSON" "empty.json should not contain any pco. overrides."

#-------------------------------------------
git grep -E 'Allianz partners' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS" "Allianz Partners has been messed up again, capitalise it please."

#-------------------------------------------
git grep '<link>' $TRANSLATIONS \
	> found.lst

show_bad "LINK" "Translation should NOT have \`<link>\` in it but \`<linkTo...>\` more specific"

#-------------------------------------------
git grep -E '(landingPage\.legal\.myDoc\.faq|landingPage\.quickLink\.benefits)"' $TRANSLATIONS \
	| grep -vE 'linkToFaq' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK FAQ1" "Translation should have \`<linkToFaq>\` in it"

fi

if [ ! -z "$LANGUAGES" ]; then
#------------------------------------------- testcase zygophyllaceae,10
git grep -E '(chooseMessengerPage\.generateActivationCodeModal\.initialStep\.help|chooseMessengerPage\.activationCodeModal\.content\.helpLink|chooseMessengerPage\.activationCodeModal\.validationError)"' $LANGUAGES \
	| grep -vE 'linkToFaqItemSACH' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK FAQ ITEM1" "Translation should have \`<linkToFaqItemSACH>\` in it"

# UNTESTED ALL BELOW TO NEXT IF
#-------------------------------------------
git grep -E 'chooseMessengerPage\.activationCodeModal\.(generic|invalid)Error"' $LANGUAGES \
	| grep -vE 'linkToFaqItemSACNWH' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK FAQ ITEM2" "Translation should have \`<linkToFaqItemSACNWH>\` in it"

#-------------------------------------------
git grep -E 'landingPage\.quickLink\.benefits"' $LANGUAGES \
	| grep -vE 'linkToFaqItemSWEH' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK FAQ ITEM3" "Translation should have \`<linkToFaqItemSWEH>\` in it"

#-------------------------------------------
git grep consentForm.termsOfUse $LANGUAGES \
	| grep -v linkToTerms \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK TERMS OF USE" "Translation should have \`<linkToTerms>\` in it"

#-------------------------------------------
git grep -E '(consentForm\.privacyPolicy|cookiesPrivacy\.readPrivacy|faq\.securityAndDataPrivacy\.protectingPrivacy\.content\.p2|faq\.securityAndDataPrivacy\.deleteAccount\.content\.p3)"' $LANGUAGES \
	| grep -v linkToPrivacy \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK PRIVACY" "Translation should have \`<linkToPrivacy>\` in it"

#-------------------------------------------
git grep -E 'termsOfUse\.dataProtection\.p2' $LANGUAGES \
	| grep -vE 'linkToPrivacy(Search|SearchInline|NoticeRightClick)' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK PRIVACY SEARCH" "Translation should have \`<linkToPrivacySearch>\` or \`<linkToPrivacySearchInline>\` in it"

#-------------------------------------------
git grep -E '(generateActivationCodeForm\.policyNumber\.legalInfo|generateActivationCodeForm\.email\.legalInfo|generateActivationCodeForm\.policyNumber\.legalInfo)"' $LANGUAGES \
	| grep -vE 'linkToPrivacyItemWPDHAH' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK PRIVACY PAGE ITEM1" "Translation should have \`<linkToPrivacyItemWPDHAH>\` in it"

#-------------------------------------------
git grep -E 'faq\.usingSymptomCheck\.contentSource\.content\.p3' $LANGUAGES \
	| grep -v linkToMayo \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK MAYO" "Translation should have \`<linkToMayo>\` in it"

#-------------------------------------------
git grep -E 'faq\.usingTeleconsultation\.moreInfo\.link' $LANGUAGES \
	| grep -vE 'linkTo(Halo|My)Doc' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK MYDOC" "Translation should have \`<linkToMyDoc|HaloDoc>\` in it"

#-------------------------------------------
git grep -E '(privacyNotice\.collectedData\.cookies\.list\.item3)"' $LANGUAGES \
	| grep -v linkToCookieConsent \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "LINK COOKIE CONSENT" "Translation should have \`<linkToCookieConsent>\` in it"

#-------------------------------------------
git grep -E '</(link|mail)[^>]+?>[\.][^"]' $LANGUAGES \
	> found.lst

show_bad "LINK FULL STOP" "Should move full stop inside the link/mail element <linkToXxx>Xxxx.</linkToXxx>"

#-------------------------------------------
git grep -E '(faq\.complimentsAndComplaints\.givingFeedback\.content\.p1\.withActivationCode|faq\.subscription\.activationCodeNotWorking\.content)"' $LANGUAGES \
	| grep -vE 'mailToHelp>' \
	| grep -vE 'src/translations/(de|es|fr|it)\.json' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "MAILTO HELP" "Translation should have \`<mailToHelp>\` or in it"

#-------------------------------------------
git grep -E 'faqPage\.contactInfo"' $LANGUAGES \
	| grep -vE 'mailToHelp(Lg|Emma2)>' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "MAILTO HELP" "Translation should have \`<mailToHelpEmma2>\` or \`<mailToHelpLg>\` in it"

#-------------------------------------------
git grep -E 'privacyNotice\.nameAndAddress\.p2"' $LANGUAGES \
	| grep -vE 'mailToPrivacy' \
	| grep -vE 'src/translations/zh-(Hant|Yue)\.json' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "MAILTO PRIVACY" "Translation should have \`<mailToPrivacy>\` in it"

#-------------------------------------------
git grep -E 'privacyNotice\.nameAndAddress\.p3"' $LANGUAGES \
	| grep -vE 'mailToDataRep' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "MAILTO DATAREP" "Translation should have \`<mailToDataRep>\` in it"

#-------------------------------------------
git grep -E 'chooseMessengerPage\.generateActivationCodeModal\.errorStep\.invalidCredentialsError|chooseMessengerPage\.generateActivationCodeModal\.errorStep\.maxNumberOfCodesError' $LANGUAGES \
	| grep -vE 'mailToService' \
	| grep -vE 'src/(translations/(ar|de|en|fr|id|it|ja|th|uk|vi|zh-(Hant|Yue))\.json)' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	| grep -vE 'Please try again or check back with your card issuer' \
	> found.lst

show_bad "MAILTO SERVICE" "Translation should have \`<mailToService>\` in it"

#-------------------------------------------
git grep -E '<em>.+Email' $LANGUAGES \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "MAILTO" "Translation should change \`<em>\` to \`<mailToXxx>\`"

#-------------------------------------------
git grep -E '<mailTo[^>]+>[^%]|[^%]</mailTo[^>]+>' $LANGUAGES \
	> found.lst

show_bad "MAILTO CONTENT" "Translators may have messed up a \`<mailToXxx>\` it must contain a %system.somethingEmail%"

#-------------------------------------------
git grep -E '[^>]\s*Secure Web Chat\s*[^<]' $LANGUAGES \
	| grep -v '<strong>Захищений веб-чат (Secure Web Chat)</strong>' \
	> found.lst

#   | grep -vE '<strong>[^<]*Secure Web Chat[^<]*</strong>' \

show_bad "STRONG NEEDED" "Translation should have <strong> around Secure Web Chat."

fi # LANGUAGES

if [ ! -z "$TRANSLATIONS" ]; then
# UNTESTED ALL BELOW TO NEXT IF
#-------------------------------------------
git grep -E 'e2\.home\.footerPanel\.company\.city"' $TRANSLATIONS \
	| grep -vE 'country\.ch' \
	> found.lst

show_bad "COUNTRY NEEDED" "Translation should have %country.ch% marker within it."

#-------------------------------------------
git grep -E 'e2\.home\.footerPanel\.company\.register"' $TRANSLATIONS \
	| grep -vE 'footer\.commercialRegister' \
	> found.lst

show_bad "COMMERCIAL NEEDED" "Translation should have %footer.commercialRegister% marker within it."

fi # TRANSLATIONS

if [ ! -z "$LANGUAGES" ]; then
# UNTESTED ALL BELOW TO NEXT IF
#-------------------------------------------
# regex does not work for ukraine...
#| grep -vE '([%٪])global\.commChannels3rdPartyOnly\1' \
git grep -E '(chooseMessengerPage\.whichPlatformModal\.content\.messengersParagraph|faq\.subscription\.specificApp\.content)"' $LANGUAGES \
	| grep -vE '[%٪]global\.commChannels3rdPartyOnly[%٪]' \
	| grep -vE 'src/translations/(vi|zh-Hans)\.json' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "COMM CHANNELS" "Translation should have \`%global.commChannels3rdPartyOnly%\` in it"

#-------------------------------------------
git grep -E '(faq\.whoIsEmma\.whoOrWhat\.content|termsOfUse\.individualServices\.generalInfo\.p1|termsOfUse\.disclaimers\.emmaInGeneral\.p5)"' $LANGUAGES \
	| grep -vE '[%٪]global\.commChannels3rdParty[%٪]' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "COMM CHANNELS" "Translation should have \`%global.commChannels3rdParty%\` in it"

#-------------------------------------------
git grep -E 'faq\.usingDoctorChat\.questionToEmma\.content"' $LANGUAGES \
	| grep -vE '[%٪]global.emmaNameInChat[%٪]' \
	| grep -vE 'src/translations/zh-(Hant|Yue)\.json' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "EMMA NAME CHAT" "Translation should have \`%global.emmaNameInChat%\` in it."

#-------------------------------------------
git grep -E 'faq\.usingDoctorChat\.questionToEmma\.content"' $LANGUAGES \
	| grep -E '([%٪])global.emmaNameInChat\1.+emmaNameInChat' \
	> found.lst

show_bad "EMMA NAME CHAT ONCE" "Translation should have \`%global.emmaNameInChat%\` in it once only."

#-------------------------------------------
git grep -E 'faq\.usingDoctorChat\.howAddImage\.content\.p2"' $LANGUAGES \
	| grep -E '([%٪])global.emmaNameInChat\1' \
	| grep -vE ': "(([%٪])SUPPRESS\2)?"' \
	> found.lst

show_bad "EMMA NAME" "Translation should NOT have \`%global.emmaNameInChat%\` change it to \`%global.emmaName%\` "

#-------------------------------------------
git grep -E 'faq\.usingDoctorChat\.questionToEmma\.content' $LANGUAGES \
	| grep '<name>' \
	> found.lst

show_bad "WARN <NAME>" "Translation should NOT have \`<name>\` in it"

fi # LANGUAGES

if [ ! -z "$ALLZ" ]; then
#------------------------------------------- testcase zygomycota,11
git grep chunks \
	| grep -vE '__/|(withHtml|WithHtmlLink)\.js' \
	> found.lst

show_bad "WARN VALUES HTML" "Should not use chunks and common HTML elements like em strong, see hooks/withHtml"

#------------------------------------------- testcase zygomycetes,12
git grep -E 'import.+FormattedMessage.+react-intl' \
	| grep -vE '__/|docs/|OptionalMessage.js:' \
	> found.lst

show_bad "ERROR react-intl/FormattedMessage" "Do not use react-intl FormattedMessage directly, make a styled wrapper using our OptionalSection/OptionalMessage component and remove defaultValue like we do with OptionalText from src/components/OptionaleMessage or src/components/SimpleText."

# UNTESTED ALL BELOW TO NEXT IF
#-------------------------------------------
git grep -E 'import.+FormattedMessage.+from.+OptionalMessage' \
	| grep -v '__/' \
	> found.lst

show_bad "ERROR FormattedMessage" "Do not use FormattedMessage with a wrapper, instead make the wraper component take an id and values and use OptionalSection/OptionalMessage like we do with OptionalText from src/components/OptionaleMessage or src/components/SimpleText."

#-------------------------------------------
FILES=`git grep -lE 'import.+\bText\b.+@medi24-da2c/web-ui' | grep -vE '(SimpleText|OptionalMessage|OptionalTextOr|MyDocLegal|Section/ListItem|GetStartedPanel/Text|FooterPanel/Text|BasicInfoPage/Text|pages/LandingPage/Text|Card/Text|FaqPage/ContactInfo|AccordionSection/e2/ContactInfo)\.js'`
if [ ! -z "$FILES" ]; then
grep -E '(Formatted|Optional)Message' $FILES \
	> found.lst

show_bad "ERROR TEXT MESSAGE" "Should use SimpleText or OptionalText instead of Text/OptionalMessage combination."
fi

#-------------------------------------------
git grep Modal.Text \
	| grep -vE '__(vendor|scripts|stories)__|e2/Modal/Text\.js' \
	> found.lst

show_bad "WARN MODAL MESSAGE" "Should use Modal.Message instead of Modal.Text which is deprecated."

#-------------------------------------------
git grep -E '<SimpleButton\b' \
	| grep -vE 'SimpleButton\.js' \
	| grep -vE '__/|hooks/withHtml|components/WithHtmlLink/WithHtmlLink.js' \
	> found.lst

show_bad "WARN SIMPLE BUTTON" "Should use MessageButton from SimpleButton in preference to SimpleButton and a FormattedMessage/OptionalMessage"

#-------------------------------------------
git grep -E 'import.+\bButton\b' \
	| grep -vE 'components/e2/Button|\bLoadingButton\b|\bMessageButton\b|(SimpleButton|Hitbox|CollapsibleSection|LanguagePicker/Language)\.js' \
	| grep -v '__/' \
	> found.lst

show_bad "WARN MESSAGE BUTTON" "Should use components/e2/Button, or MessageButton from components/{Button or SimpleMessageButton} in preference to Button and medi24 and a FormattedMessage/OptionalMessage."

#-------------------------------------------
git grep -E 'import.+\bButton\b.+@medi24-da2c/web-ui' \
	| grep -vE '(Simple(Message)?Button|__/)' \
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
echo -n ""	> found.lst
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

fi # ALLZ

#------------------------------------------- testcase zygomorphic,13
git grep -E '(padding|margin).*:.*\b([1-9]|[0-9]+px)' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/|Visibility/ShowVisibility' \
	| perl -pne 's{\d+(\.\d*)?rem\b}{NUMREM}xmsg; s{\b0\b}{ZEROREM}g;' \
	| grep -E '[0-9]+[^0-9\s]' \
	| perl -pne 's{NUMREM}{???rem}xmsg; s{ZEROREM}{0}g;' \
	> found.lst

show_bad "WARN PIXELS" "Should be using rems instead of px for layout..."

# UNTESTED
#/e2/x.css: margin: 4rem;
#/e2/x.css: margin: Space1 Extras23b Blacked54 Bla6;???
#/e2/x.css: margin-right: 0; // OKEY
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

#------------------------------------------- testcase zygoma,14
git grep -E 'opacity:.+?[0-9]' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/|cypress/' \
	| grep -vE '\.cls.+\{opacity' \
	| grep -vE '/\* opacity\w+' \
	> found.lst

show_bad "WARN CSS OPACITY CODES" "Should be using design token names instead of numbers for opacity."

#------------------------------------------- testcase zygodactyl,15
git grep -E '(letter(-s|S)pacing|line(-h|H)eight|font(-s|S)ize|font(-w|W)eight).*:.*\b[0-9]+' \
	| grep -E '/e2/' \
	| grep -vE '__vendor__|__scripts__|__stories__|__dev__|/stories/|docs/' \
	| perl -pne 's{0\.}{ZEROPT }g' \
	| grep -vE '\b0\b' \
	| perl -pne 's{ZEROPT }{0.}g' \
	> found.lst

show_bad "ERROR FONT SIZES" "Should be using design token names instead of rem or px for fonts..."

#------------------------------------------- testcase zygocactus,16
git grep -iE '\b(font-?(family|size|weight)|line-?height|letter-?spacing)\b' \
	| grep /e2/ \
	| grep -vE '__/|docs/|Typography.js|js:\s*//|theme.fontFamily' \
	> found.lst

show_bad "ERROR TYPOGRAPHY" "Should be using components/e2/Typography components instead of specific font CSS."

if [ ! -z "$ALLZ" ]; then
#------------------------------------------- testcase zygnematales,17
git grep -E 'import.+useTheme.+/useLanguage' src \
	| grep -v 'App/App.js' \
	> found.lst

show_bad "WARN THEME" "Should import { useTheme } from '@emotion/react' NOT hooks/useLanguage"

#------------------------------------------- testcase zygnemataceae,18
git grep -E 'props\.theme\.' \
	| grep -v 'PROPER WAY' \
	| grep -vE '__vendor__|__scripts__' \
	> found.lst

show_bad "WARN THEME1" "Should check styled component in Storybook and change to themedProps.theme to indicate proper operation like src/components/Carousel/Bullet.js"

#------------------------------------------- testcase zygnema,19
git grep Broken \
	| grep -E '__vendor__|__stories__' \
	> found.lst

show_bad "WARN THEME2" "Should fix Broken styled components in Storybook with useTheme and themedProps as in src/components/Carousel/Bullet.js"

#------------------------------------------- testcase zwischen,20
git grep theme= \
	| grep -v 'ThemeProvider theme' \
	| grep -E '__vendor__|__stories__' \
	> found.lst

show_bad "WARN THEME3" "Should not pass theme in Storybook stories, fix the component with useTheme and themedProps"

#------------------------------------------- testcase zwieback,21
git grep -E '<(Text|(Subh|H)eadline)\b' \
	| grep -vE '\.(Themed|Message)|theme=|\bid=|Modal/Message\.js|Headline\.test\.js|/OptionalTextOr\.js|/SuccessStep/ActivationCode\.js|/BasicInfoPage/Headline\.js|/BasicInfoPage/Text\.js|/ChooseMessengerPage/Headline\.js|/LandingPage/Text\.js|/Card/(Headline|Subheadline|Text)\.js' \
	> found.lst

show_bad "WARN THEME4" "Need to use the Xxx.Themed or Xxx.Message version of some @emotion/styled components to work in Storybook"

#------------------------------------------- testcase zweierleiger,22
git grep -E 'theme.+getInstance' \
	| grep -vE '__tests__|__scripts__|__stories__/tools\.js|/(setupTests|useLanguage)\.js' \
	> found.lst

show_bad "WARN THEME5" "Need to useTheme instead of getting it from getInstance()"

#------------------------------------------- testcase zurich,23
git grep -E 'getInstance\(\)' \
	| grep -vE '__/|/hooks/|/translations/|/setupTests\.js|partnerConfigs/singleton\.js' \
	> found.lst

show_bad "WARN INSTANCE" "Should create or use a hook instead of calling getInstance() directly"

fi # ALLZ

#------------------------------------------- testcase zulu,24
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

#------------------------------------------- testcase zucchini,25
git grep -E '\.prototype\s*=' \
	| grep -vE '__/|BulletSection/BulletSection\.js' \
	> found.lst

show_bad "ERROR PROTOTYPE" "Should not be making .prototype assignments. Did you mean .propTypes?"

#------------------------------------------- testcase zu,26
git grep -E 'react-hooks/exhaustive-deps' \
	| grep -vE '__/' \
	> found.lst

show_bad "ERROR EFFECT HOOKS" "Should not be useing react-hooks/exhaustive-deps. Create proper useEffect dependency array or omit it for beforeWeMount/afterWeUnmount effects."

#------------------------------------------- testcase zoysia,27
git grep -E '((\bx(it|describe))|\.skip)\(' \
	| grep -vE '__vendor__|__scripts__' \
	> found.lst

show_bad "WARN TESTS SKIP" "Should not have any tests marked as .skip()."

#------------------------------------------- testcase zounds,28
git grep -iE '(mu[s]+tdo|to[d]o)[^(]' \
	| grep -vE '__vendor__|docs/|\.json|check-code' \
	| grep -ivE 'DIP-[0-9+]' \
	> found.lst

MD="MUST""DO/TO""DO"
TD="TO""DO"
show_bad "WARN $MD" "Should give $TD(name), $TD(date) or $TD DIP-NNNN on $MD items"

#------------------------------------------- testcase zouave,29
git grep -E 'class=' \
	| grep -vE '\.svg:' \
	| grep -vE '__(scripts|vendor|tests)__' \
	| grep -vE 'setupTests|public/index.html' \
	> found.lst

show_bad "ERROR CLASSNAME" "Should be using className= instead of class="

#------------------------------------------- testcase zosteraceae,30
git grep -E 'window\.console\.' \
	| grep -v docs/ \
	| grep -vE '//|__vendor__|__scripts__|setupTests|PARTNER_NAME|src/tracking/track\.js|README.md:|cypress/support/commands\.js' \
	| grep -vE '(\w+) = window\.console\.\1' \
	| grep -vE 'window\.console && window\.console\.\w+' \
	> found.lst

show_bad "ERROR window.console" "Should remove your window.console debugging"

# HEREIAM TESTING
#-------------------------------------------
git grep -E 'debug\(|debugger|pause\(' \
	| grep -vE '//|__vendor__|__scripts__|setupTests|templates/' \
	> found.lst

show_bad "ERROR DEBUGGER" "Should remove your debugger, debug() or .pause() instructions from tests"

#-------------------------------------------
git grep -E 'DEBUG\s*=' \
	| grep -vE 'DEBUG\s*=\s*$|//|false|process\.env\.|package.json|docs/|__vendor__|__scripts__|displayName|DEV_DEBUG_' \
	> found.lst

show_bad "ERROR DEBUG=" "Should set DEBUG= to false"

#-------------------------------------------
git grep -E 'DEBUG\s*=.+true' \
	| grep -vE '//|__vendor__|__scripts__' \
	> found.lst

show_bad "ERROR DEBUG=" "Should not have DEBUG= set true"

#-------------------------------------------
git grep -E '\.to(Be|Equal|Have)\w*\s*(/|;|$)' \
	| grep -vE '__vendor__|__scripts__' \
	> found.lst

show_bad "ERROR TESTS NOTHING" "Should have () at end of a test assertion like .toBeNull, this tests nothing."

#-------------------------------------------
git grep -E '((\bf(it|describe))|\.only)\(' \
	| grep -vE '__vendor__|__scripts__' \
	> found.lst

show_bad "ERROR TESTS ONLY" "Should not have any tests marked as .only()."

if [ ! -z "$TRANSLATIONS" ]; then
#-------------------------------------------
grep -E '([%٪])(general|dataRep|privacy|service)Email\1' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS SYSTEM" "Marker needs system. prefix. i.e. %system.privacyEmail%"

#-------------------------------------------
grep -E '[%٪]languagePicker\.label' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS SYSTEM" "Marker needs system. prefix. i.e. %system.languagePicker.label"

#-------------------------------------------
grep -E '\b(MyDoc|Halo[dD]oc)\b' $TRANSLATIONS \
	| grep -vE 'global.teleName"|\.MyDoc\.|\+Halodoc\+' \
	> found.lst

show_bad "ERROR TRANS MyDoc" "Should not MyDoc/Halodoc in the translations use %global.teleName%"

#-------------------------------------------
grep -E '</(\w+)>[^<]+</\1>|<(\w+)>[^<]+<\1>' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS HTML" "Translators have messed up the </open>...</open> tagging."

#-------------------------------------------
grep -E '<([^>]+)>[^<]+</([^>]+)>' $TRANSLATIONS \
	| grep -vE '<([^>]+)>[^<]+</\1>' \
	> found.lst

show_bad "ERROR TRANS HTML2" "Translators have messed up the <tag>...</mismatch> tagging."

#-------------------------------------------
grep -E '\s\?' $TRANSLATIONS \
	| grep -v fr.json \
	> found.lst

show_bad "WARN TRANS PUNCT" "Non-French question marks should NOT be preceded by a space."

#-------------------------------------------
grep -E '\S\?' $TRANSLATIONS \
	| grep fr.json \
	| grep -v '?subject' \
	> found.lst

show_bad "WARN TRANS PUNCT" "French question marks should be preceded by a space."

#-------------------------------------------
grep -E ' 2\.1' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS MyDoc" "Should not have 2.1 in translations, use %privacyNotice.whatPersonalData.healthAssistant.headline.bulletNumber%"

#-------------------------------------------
grep -E ' 5\.2' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS DrChat" "Should not have 5.2 in translations, use %termsOfUse.disclaimers.doctorChat.headline.bulletNumber%"

#-------------------------------------------
grep -E '\(b\)' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS DrChat" "Should not have 5.2(b) in translations, use %termsOfUse.disclaimers.doctorChat.headline.bulletNumber%(%termsOfUse.disclaimers.doctorChat.p2.bulletNumber%)"

#perl -i -pne 's{5\.2\(b\)}{%termsOfUse.disclaimers.doctorChat.headline.bulletNumber%(%termsOfUse.disclaimers.doctorChat.p2.bulletNumber%)}xmsg' src/translations/*.json
#perl -i -pne 's{5\.2(\ข)}{%termsOfUse.disclaimers.doctorChat.headline.bulletNumber%(%termsOfUse.disclaimers.doctorChat.p2.bulletNumber%)}xmsg' src/translations/*.json

#-------------------------------------------
grep -E '\\n' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS NEWLINE" "Use a line break marker {br} instead of newline characters: \\n"

#-------------------------------------------
grep -E '\S\{br\}|\{br\}\S' $TRANSLATIONS \
	| grep -v '"{br}' \
	| grep -v '{br}"' \
	> found.lst

show_bad "ERROR TRANS BR" "Line break marker {br} should be surrounded by a space to work propery i.e. Arabic, Japanese"

#-------------------------------------------
grep -E '\.\.\.' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS ELLIPSIS" "Looks like ... was used for ellipsis, replace with …"

#-------------------------------------------
grep -E '٪\s*\w+\s*٪' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANS PERCENT" "Looks like %marker% was replaced by Arabic percent ٪marker٪."

#-------------------------------------------
grep -E '((\{|</?)\s+|\s+[\}>]|(\{|</?)[A-Z]|\%\s*[A-Z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])\%)' $TRANSLATIONS \
	> found.lst
grep -E '((\{|</?)\s+|\s+[\}>]|(\{|</?)[A-Z]|٪\s*[A-Z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])٪)' $TRANSLATIONS \
	>> found.lst

show_bad "ERROR TRANSLATOR" "Translators may have messed up {vars} or <elements> spacing or auto-capitalisation."

#-------------------------------------------
grep -E '\%\s*[A-Z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])\s*\%' $TRANSLATIONS \
	> found.lst
grep -E '٪\s*[A-Z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])\s*٪' $TRANSLATIONS \
	>> found.lst

show_bad "ERROR TRANSLATOR" "Translators may have messed up %vars% auto-capitalisation."

#-------------------------------------------
grep -E '\%\s+[a-z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])\%' $TRANSLATIONS \
	> found.lst
grep -E '٪\s+[a-z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])٪' $TRANSLATIONS \
	>> found.lst

show_bad "ERROR TRANSLATOR" "Translators may have messed up %vars% with leading spaces."

#-------------------------------------------
grep -E '\%[a-z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])\s+\%' $TRANSLATIONS \
	> found.lst
grep -E '٪[a-z]([nN][dD][aA][sS][hH]|[pP][oO][sS]|[bB][sS][pP]|[sS][pP]|[sSdD][qQ]|[hH])\s+٪' $TRANSLATIONS \
	>> found.lst

show_bad "ERROR TRANSLATOR" "Translators may have messed up %vars% with trailing spaces."

#-------------------------------------------
grep -E '[%٪]\s*[A-Z]([lL][oO][bB][aA][lL]|[yY][sS][tT][eE][mM])' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANSLATOR" "Translators may have messed up %global...% spacing or capitalisation."

#-------------------------------------------
grep -E '\s[%٪](nbsp|sp|wsp|sh)[%٪]|[%٪](nbsp|sp|wsp|sh)[%٪]\s' $TRANSLATIONS \
	> found.lst

show_bad "ERROR TRANSLATOR" "Translators may have messed up %nbsp% and other spacing markers."

#-------------------------------------------
grep -E ':\s*""' $TRANSLATIONS \
	> found.lst

show_bad "WARN TRANS EMPTY" "Should use %SUPPRESS% to mark suppressed messages, not empty string"

#-------------------------------------------
# don't use git grep, it has unicode problems
grep -E '[ʼ‘’“”‚‘„“«»]|\\"' $TRANSLATIONS \
	| grep -vE '"(pco\.emma2\.)?(global\.)?(apos|endash|[lr][sd][qg])"' \
	| perl -pne 's{([ʼ‘’“”‚‘„“«»]|\\")}{  >>> $1 <<<  }xmsg;' \
	> found.lst

show_bad "QUOTES TRANS" "Should not have dodgy quotes/characters in translation files use %ldq% etc"

fi # TRANSLATIONS

#-------------------------------------------
git grep -iE 'mus+''tdo' \
	| grep -vE '__vendor__|docs/|check-code|mockNavigateToDoctorChatPage|README' \
	> found.lst

show_bad "WARN MUS""TDO" "Should resolve MUS""TDO items"

if [ ! -z "$ALLZ" ]; then
#-------------------------------------------
git grep DEV_ src/constants/switches.js \
	| grep true \
	| grep -v DEV_CHECK_FAQ \
	> found.lst

show_bad "ERROR DEV_ switches should be turned off for releases"

fi # ALLZ

rm found.lst
exit $FAILURE
