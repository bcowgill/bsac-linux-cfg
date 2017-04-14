//===============================================================
// indexable interfaces

interface StringArray {
    [index: number]: string;
}

let myArray: StringArray;
myArray = ["Bob", "Fred"];

let myStr: string = myArray[0];

// You can index by number or string but number indexing is done by
// converting the number to a string so the type returned from a numeric indexer
// must be a subtype of the type returned from the string indexer.

class Animal {
    name: string;
}
class Dog extends Animal {
    breed: string;
}

// Error: indexing with a 'string' will sometimes get you a Dog!
interface NotOkay {
//ERR    [x: number]: Animal;  //Animal is not a sub type of Dog, but must be if number indexed
    [x: string]: Dog;
}


//

interface NumberDictionary {
    [index: string]: number;
    length: number;    // ok, length is a number
//ERR    name: string;      // error, the type of 'name' is not a subtype of the indexer
}

// Finally, you can make index signatures readonly in order to prevent assignment to their indices:

interface ReadonlyStringArray {
    readonly [index: number]: string;
}
let myArray2: ReadonlyStringArray = ["Alice", "Bob"];
//ERR myArray2[2] = "Mallory"; // error!

