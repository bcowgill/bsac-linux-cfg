//import { B } from "./common"; // for npm run compile until typescript 5 arrives
import { B } from "./common.ts"; // for npm run fast / compile with typescript@beta == 5

console.log(B)

/* sample TS type error
const user = {
  firstName: "Angela",
  lastName: "Davis",
  role: "Professor",
}

console.log(user.name)
*/
