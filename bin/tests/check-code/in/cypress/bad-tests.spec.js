// testcase zymurgy
findByText(UI_BTN_BACK); // OKEY
findByText(UI.something); // OKEY
findByText(idBtn); // OKEY
findByText(not_UI_id);
// findByText(not_UI_id); OKEY
findByRole("dialog"); // OKEY
findByTestId(testId); // OKEY
findByText(regexXyz); // OKEY
findByText(msgXyz); // OKEY
findByText(txtXyz); // OKEY
__vendor__/x.js: findByText(not_UI_id); // OKEY

// testcase zymotic
findByText(UI.BACK).click()
findByTestId(UI.BACK).click(); // OKEY
__vendor__/x.js: findByText(UI.BACK).click(); // OKEY

// testcase zygotic
window.location.replace(URL) // OKEY

// testcase zoysia
describe.skip("a skipped suite");
it.skip("a skipped test");
anything.skip("a skipped test");
xit("a skipped test");
xdescribe("a skipped test");
exit("a skipped test"); // OKEY
__vendor__/x.js: xit("a skipped test");
__scripts__/x.js: xit("a skipped test");
