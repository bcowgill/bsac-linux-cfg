//===============================================================
// class interfaces

interface ClockInterface {
    currentTime: Date;
}

class Clock implements ClockInterface {
    currentTime: Date;
    constructor(h: number, m: number) { void h, void m }
}

interface ClockInterface2 {
    currentTime: Date;
    setTime(d: Date) : void;
}

class Clock2 implements ClockInterface2 {
    currentTime: Date;
    setTime(d: Date) {
        this.currentTime = d;
    }
    constructor(h: number, m: number) { void h, void m }
}

// Static and Instance side of class, incorrect
/*
interface ClockConstructorWrong {
    new (hour: number, minute: number);
}
*/

//ERR
/*
class Clock3 implements ClockConstructorWrong {
    currentTime: Date;
    constructor(h: number, m: number) { }
}
*/

// Instead you have to use static factories if you want to specify the
// static interface
interface ClockConstructor3 {
    new (hour: number, minute: number): ClockInterface3;
}
interface ClockInterface3 {
    tick() : void;
}

function createClock(ctor: ClockConstructor3, hour: number, minute: number): ClockInterface3 {
    return new ctor(hour, minute);
}

class DigitalClock implements ClockInterface3 {
    constructor(h: number, m: number) { void h, void m }
    tick() {
        console.log("beep beep");
    }
}
class AnalogClock implements ClockInterface3 {
    constructor(h: number, m: number) { void h, void m }
    tick() {
        console.log("tick tock");
    }
}

let digital = createClock(DigitalClock, 12, 17);
let analog = createClock(AnalogClock, 7, 32);

