// testcase zygotic
window.location.replace(URL)
// window.location.replace(URL) OKEY
@param {URLLocation} location defaults to window.location OKEY
window.digitalData.key // OKEY
window.AppMeasurement.key // OKEY
window.__private // OKEY
window.console // OKEY
__scripts__/x.js: window.location.replace(URL) // OKEY
__tests__/x.js: window.location.replace(URL) // OKEY
__snapshots__/x.js: window.location.replace(URL) // OKEY
__mock__/x.js: window.location.replace(URL) // OKEY
__vendor__/x.js: window.location.replace(URL) // OKEY
/integration/x.js: window.location.replace(URL) // OKEY
docs/x.js: window.location.replace(URL) // OKEY
cypress/x.js: window.location.replace(URL) // OKEY
src/setupTests.js: window.location.replace(URL) // OKEY
src/utils/platform.js: window.location.replace(URL) // OKEY

// testcase zygotene
JSON.parse(JSON.stringify(obj))
__scripts__/x.js: JSON.parse(JSON.stringify(obj)) // OKEY
/__tests__/x.js: JSON.parse(JSON.stringify(obj)) // OKEY
/__vendor__/x.js: JSON.parse(JSON.stringify(obj)) // OKEY
/integration/x.js: JSON.parse(JSON.stringify(obj)) // OKEY

// testcase zygote
async function doNow() {}
async function willComputeValues() {} // OKEY
async function fetchValues() {} // OKEY
__scripts__/x.js: async function doNow() {} // OKEY
/__tests__/x.js: async function doNow() {} // OKEY
/__vendor__/x.js: async function doNow() {} // OKEY
/integration/x.js: async function doNow() {} // OKEY

// testcase zygoptera
"#1"
"#0D"
"#B9C"
"#f7A8"
"#4d5e6"
"#1a2b3c"
"rgb(1,4,3)"
"rgba(3,5,3,4)"
/__vendor__/x.js: #fff // OKEY
/Icons/i.js: #fff // OKEY
/stories/i.js: #fff // OKEY
/partnerConfigs/i.js: #fff // OKEY
/emma2-redesign/i.js: #fff // OKEY
theme2json.sh: #fff // OKEY
public/manifest.json: #fff // OKEY
Binary file x.ico: #fff // OKEY

// testcase zygomycota
chunks
__scripts__/x.js: chunks // OKEY
__tests__/x.js: chunks // OKEY
__vendor__/x.js: chunks // OKEY
withHtml.js: chunks // OKEY
WithHtmlLink.js: chunks // OKEY

// testcase zygomycetes
import { FormattedMessage } from "react-intl";
__scripts__/x.js: import { FormattedMessage } from "react-intl"; // OKEY
__tests__/x.js: import { FormattedMessage } from "react-intl"; // OKEY
__vendor__/x.js: import { FormattedMessage } from "react-intl"; // OKEY
docs/x.js: import { FormattedMessage } from "react-intl"; // OKEY
OptionalMessage.js: import { FormattedMessage } from "react-intl"; // OKEY

// testcase zygnemataceae
border: 1rem solid ${props.theme.edging};
// PROPER WAY to use them is not ${props.theme.edging} but ... // OKEY
__vendor__/x.js: border: 1rem solid ${props.theme.edging}; // OKEY
__scripts__/x.js: border: 1rem solid ${props.theme.edging}; // OKEY

// testcase zygnema
__stories__/x.js: Broken
__vendor__/x.js: Broken
Broken // OKEY

// testcase zwischen
__vendor__/x.js: theme={theme}
__stories__/x.js: theme={theme}
__stories__/x.js: <ThemeProvider theme={theme} /> // OKEY
theme={theme} // OKEY

// testcase zwieback
<Headline />
<Subheadline />
<Text />
<Text.Themed /> // OKEY
<Text.Message /> // OKEY
<Text theme={theme} /> // OKEY
<Text id={id} /> // OKEY
Modal/Message.js: <Text /> // OKEY
Headline.test.js: <Headline /> // OKEY
/OptionalTextOr.js: <Text /> // OKEY
/SuccessStep/ActivationCode.js: <Text /> // OKEY
/BasicInfoPage/Headline.js: <Text /> // OKEY
/BasicInfoPage/Text.js: <Text /> // OKEY
/ChooseMessengerPage/Headline.js: <Text /> // OKEY
/LandingPage/Text.js: <Text /> // OKEY
/Card/Headline.js: <Headline /> // OKEY
/Card/Subheadline.js: <Subheadline /> // OKE
/Card/Text.js: <Text /> // OKEY

// testcase zweierleiger (some overlap with zurich, below)
theme={getInstance()}
__tests__/x.test.js: theme={getInstance()} // OKEY
__scripts__/x.sh: theme={getInstance()} // OKEY
__stories__/tools.js: const theme = getInstance() // OKEY
/setupTests.js: theme={getInstance()} // OKEY
/hooks/useLanguage.js: theme={getInstance()} // OKEY

// testcase zurich (some overlap with zweierleiger, above)
getInstance()
__vendor__/x.sh: getInstance() // OKEY
/translations/x.js: getInstance() // OKEY
partnerConfigs/singleton.js: getInstance() // OKEY
/hooks/useLanguage.js: getInstance() // OKEY
