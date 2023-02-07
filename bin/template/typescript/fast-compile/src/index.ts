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

// Typescript samples from the Handbook
// https://www.typescriptlang.org/docs/handbook/2/narrowing.html

// type nothing = undefined | null | false | 0 | 0n | /^\s*$/ | /^\s*0*(.0*)?\s*$/| NaN;
// type empty = undefined | null | false | 0 | 0n | /^\s*$/ | /^\s*0*(.0*)?\s*$/| NaN | [] | {};
type fnAction = () => void;
type procedure = () => void;

type Fish = { swim: fnAction };
type Bird = { fly: procedure };

function move(animal: Fish | Bird) {
  if ("swim" in animal) {
    return animal.swim();
  }

  return animal.fly();
}
