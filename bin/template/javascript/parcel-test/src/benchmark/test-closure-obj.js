// expriments in functional programming with different ways of making objects

function StudentRecordClosure(name, major, gpa) {
	return function printStudent(){
		return name + ', Major: ' + major + ', GPA: ' + gpa.toFixed(1);
	};
}

//-------------------------------------
function StudentRecord(){
	return this.name + ', Major: ' + this.major + ', GPA: ' + this.gpa.toFixed(1);
}

function StudentRecordObject(name, major, gpa) {
	const student = StudentRecord.bind({
		name: name,
		major: major,
		gpa: gpa
	});
	return student;
}

//-------------------------------------
function StudentRecordNew(name, major, gpa) {
	this.name = name;
	this.major = major;
	this.gpa = gpa;
}
StudentRecordNew.prototype.studentInfo = StudentRecord;

//-------------------------------------
function StudentRecordPrivate(name, major, gpa) {
	return {
		studentInfo: function () {
			return name + ', Major: ' + major + ', GPA: ' + gpa.toFixed(1);
		}
	};
}

//-------------------------------------
class StudentRecordClass {
	constructor (name, major, gpa) {
		this.name = name;
		this.major = major;
		this.gpa = gpa;
	}
	studentInfo () {
		return this.name + ', Major: ' + this.major + ', GPA: ' + this.gpa.toFixed(1);
	}
}

// Your module code goes here...
const Tests = [
	{
		'Closure#objcreate': function ObjectCreateClosureTest () {
			StudentRecordClosure('John Smith', 'PH', 3.2)();
		},
		'Object#objcreate': function ObjectCreateObjectTest () {
			StudentRecordObject('John Smith', 'PH', 3.2)();
		},
		'Constructor#objcreate': function ObjectCreateConstructorTest () {
			const student = new StudentRecordNew('John Smith', 'PH', 3.2);
			student.studentInfo();
		},
		'Private#objcreate': function ObjectCreatePrivateTest () {
			const student = StudentRecordPrivate('John Smith', 'PH', 3.2);
			student.studentInfo();
		},
		'Class#objcreate': function ObjectCreateClassTest () {
			const student = new StudentRecordClass('John Smith', 'PH', 3.2);
			student.studentInfo();
		}
	},
	{
		'Closure10#objcreate': function ObjectCreateClosureCall10Test () {
			const studentInfo = StudentRecordClosure('John Smith', 'PH', 3.2);
			let result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
		},
		'ObjectCall10#objcreate': function ObjectCreateCbjectCall10Test () {
			const studentInfo = StudentRecordObject('John Smith', 'PH', 3.2);
			let result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
			result = studentInfo();
		},
		'ConstructorCall10#objcreate': function ObjectCreateConstructorCall10Test () {
			const student = new StudentRecordNew('John Smith', 'PH', 3.2);
			let result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
		},
		'PrivateCall10#objcreate': function ObjectCreatePrivateCall10Test () {
			const student = StudentRecordPrivate('John Smith', 'PH', 3.2);
			let result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
		},
		'ClassCall10#objcreate': function ObjectCreateClassCall10Test () {
			const student = new StudentRecordClass('John Smith', 'PH', 3.2);
			let result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
			result = student.studentInfo();
		}
	}
];

export default Tests;
