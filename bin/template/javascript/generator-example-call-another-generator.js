// Example of having one generator invoke another generator interstitially in its own sequence.

function* generate(start = 1) {
    console.log('invoked 1st time');
    yield start;
    console.log('invoked 2nd time');
    yield start + 1;
}
function* generate2() {
    console.log('g2 invoked 1st time');
    yield 1;

    // Unfortunately this cannot be turned into a function, but must be
    // inlined each time.
    let iter = generate(42);
    for (const next of iter) {
        yield next;
    }

    console.log('g2 invoked 2nd time');
    yield 2;

    iter = generate(92);
    for (let next = iter.next();
        !next.done;
        next = iter.next()
        ) {
        yield next.value;
    }

    // not supported by iterators
    // iter = generate(12);
    // iter.forEach(console.log)
}

const iter = generate2(2);
for (const next of iter) {
    console.log('YIELDED ', next);
}
