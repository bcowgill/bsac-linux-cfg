//===============================================================
// function interfaces

interface SearchFunc {
    (source: string, subString: string): boolean;
}

let mySearch: SearchFunc;
mySearch = function(source: string, subString: string) {
    let result = source.search(subString);
    return result > -1;
}

// Names of parameters don't have to match on function interfaces, just types

mySearch = function(src: string, sub: string): boolean {
    let result = src.search(sub);
    return result > -1;
}

// Typescript can infer the types if you omit them
mySearch = function(src, sub) {
    let result = src.search(sub);
    return result > -1;
}
