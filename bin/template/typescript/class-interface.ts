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

// Extending multiple interfaces
interface Shape {
    color: string;
}

interface Square extends Shape {
    sideLength: number;
}

let square = <Square>{};
square.color = "blue";
square.sideLength = 10;

interface PenStroke {
    penWidth: number;
}

interface Square2 extends Shape, PenStroke {
    sideLength: number;
}

let square2 = <Square2>{};
square2.color = "blue";
square2.sideLength = 10;
square2.penWidth = 5.0;

// Functions with properties
interface Counter {
    (start: number): string;
    interval: number;
    reset(): void;
}

function getCounter(): Counter {
    let counter = <Counter>function (start: number) { void start };
    counter.interval = 123;
    counter.reset = function () { };
    return counter;
}

let c3 = getCounter();
c3(10);
c3.reset();
c3.interval = 5.0;

// Class inheritance of private properties
class Control {
    private state: any;
    public getState() { return this.state }
}

interface SelectableControl extends Control {
    select(): void;
}

class Button extends Control {
    select() { }
}

class TextBox extends Control {
    select() { }
}

// Not inheriting fron control, so will not have the private state
class ImageNotControl {
    select() { }
}

class LocationNotControl {
    select() { }
}
