expect(element.getAttribute('width')).toBe(false)
// expect(element.getAttribute('width')).toBe(false) OKEY
expect(element.getAttribute('width')).toMatch() // OKEY
(element.getAttribute("value") === "true")

await waitFor(() => expect(asFragment()).toMatchSnapshot())