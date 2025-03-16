// test node typescript type spacing vs tsx/bun/deno which strip them totally
const EX_TSSTRIP = `${function (x:string):string{return x[0]}}`;
console.warn(`?? [${EX_TSSTRIP}]`, typeof EX_TSSTRIP, EX_TSSTRIP.length);

/*
tsx test.ts
?? [function(x){return x[0]}] string 24
deno test.ts
?? [function(x) {
  return x[0];
}] string 30
bun test.ts
?? [function(x) {
  return x[0];
}] string 30
node /tmp/test.ts  with ts type stripping
?? [function (x       )       {return x[0]}] string 39

*/
