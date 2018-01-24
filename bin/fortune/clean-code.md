# Code Review Purpose

* To transfer knowledge of best practices to the team.
* To ensure other team members know what is going to master.
* To let other team members check if unit tests are adequate.
* To reduce duplication as other team members see common patterns.
* A sober period of reflection on the code (by the author and others) to make sure it isn't shit.
* To ensure other team members are happy to support the code once it goes live.

# Code Review Principles

In general we adhere to the guidelines of [Robert C. Martin](https://www.amazon.co.uk/Robert-Martin-Clean-Code-Collection-ebook/dp/B00666M59G) in his book [Clean Code](https://www.investigatii.md/uploads/resurse/Clean_Code.pdf)

> Leave the code cleaner than you found it. If we all checked-in our code a little cleaner than when we checked it out, the code simply could not rot.

## Simple code:

* Passes all the tests.
* Expresses every idea that we need to express.
* Says everything OnceAndOnlyOnce.
* Has no superfluous parts.

[XP Simplicity](http://c2.com/cgi/wiki?XpSimplicityRules)

## Comments

There should be almost no comments in source code.  If you think you have to have a comment you should start with an apology because you have failed to write clean code.

```javascript
/* sorry, ... */
```

> Don't comment bad code -- rewrite it.
> Brian W. Kernighan and P.J. Plaugher

It's fine to have a comment banner at the top of the file giving a brief explanation of the purpose of the file/module/class, a URL reference to third party documentation or a URL to the ticket number in your issue tracking system.

### Good Comments:

* Legal Comments.
* Informative Comments.
* Explanation of Intent.
* Clarification.
* Warning of Consequences.
* TODO Comments. (w/date)
* Amplification.
* Javadocs in Public APIs.

*Clean Code, Robert C. Martin, p55*

### Smelly Comments:

* C1: Inappropriate Information
* C2: Obsolete Comment
* C3: Redundant Comment
* C4: Poorly Written Comment
* C5: Commented-Out Code

*Clean Code, Robert C. Martin, p286*

## Names

Names should make the need for comments unnecessary.  There should be no very short names (1-2 characters.)  Names should be given to every number except possibly -1, 0, and 1.  Make use of **const** instead or repeating identical strings everywhere.

### The 14 Commandments of Names:

1. Use Intention-Revealing Names
1. Avoid Disinformation
1. Make Meaningful Distinctions
1. Use Pronounceable Names
1. Use Searchable Names
1. Avoid Encodings
1. Avoid Mental Mapping
1. Don't Be Cute
1. Pick One Word Per Concept
1. Don't Pun
1. Use Solution Domain Names
1. Use Problem Domain Names
1. Add Meaningful Context
1. Don't Add Gratuitous Context

*Clean Code, Robert C. Martin, p18-29*

### Smelly Names:

* N1: Choose Descriptive Names
* N2: Choose Names at the Appropriate Level of Abstraction
* N3: Use Standard Nomenclature Where Possible
* N4: Unambiguous Names
* N5: Use Long Names for Long Scopes
* N6: Avoid Encodings
* N7: Names Should Describe Side Effects

*Clean Code, Robert C. Martin, p309*

## Functions:

Functions should do one thing. They should do it well. They should do it only.

> The first rule of functions (and classes) is that they should be small.
The second rule of functions is that they should be smaller than that.

Functions that do one thing cannot be reasonably divided into sections.

A function is doing more than "one thing" if you can extract another function from it with a name that is not merely a restatement of its implementation.

### Functions should be:

* Small!
* Have no room for nested structures.
* Do One Thing.
* Have No Sections.
* One Level of Abstraction Per Function.
* Read From Top to Bottom: The Stepdown Rule

*Clean Code, Robert C. Martin, p31-49*

> Functions should be so small they don't have room for nested structures. They should have one or two indention levels at most.

### Smelly Functions:

* F1: Too Many Arguments
* F2: Output Arguments
* F3: Flag Arguments
* F4: Dead Functions

*Clean Code, Robert C. Martin, p288*

> The code should read like a top-down narrative. We want every function to be followed by those at the next level of abstraction so that we can read the program, descending one level of abstraction at a time as we read down the list of functions. I call this The Stepdown Rule.

## Classes:

The name of a class should describe what responsibilities it fulfils. In fact, naming is probably the first way of helping determine class size. If we cannot derive a concise name for a class, then it's likely too large. The more ambiguous the class name, the more likely it has too many responsibilities.

### Classes should be:

* Small!
* Named for Responsibilities
* Can write a brief description in 25 words
* Cohesion should be high
* Class Design Principles (S.O.L.I.D.)
  * SRP: The Single Responsibility Principle
  * OCP: The Open/Closed Principle
  * LSP: The Liskov Substitution Principle
  * ISP: The Interface Segregation Principle
  * DIP: The Dependency Inversion Principle

> We should be able to write a brief description of the class in about 25 words without using the words "if," "and," "or," or "but."

#### Classes: Cohesion Should be High

Classes should have a small number of instance variables. Each of the methods of a class should manipulate one or more of those variables. In general the more variables a method manipulates the more cohesive that method is to its class. A class in which each variable is used by each method is maximally cohesive.

*Clean Code, Robert C. Martin, p140*

#### Classes: Single Responsibility Principle:

A class or module should have one, and only one, reason to change. Each small class encapsulates a single responsibility, has a single reason to change, and collaborates with a few others to achieve the desired system behaviors.

*Clean Code, Robert C. Martin, p138,140*

A class should have one, and only one, reason to change.
This does not mean a single function, does not mean what it does.
How many executive level officers have an interest in the class?

#### Classes: The Open / Closed Principle

Modules should be open for extension, but closed for modification.

*Bertrand Meyer, 1980*

#### Classes: The Liskov Substitution Principle

Derived classes must be usable through the base class interface, without the need for the user to know the difference.

Whenever you violate the substitution principle you will eventually add an if statement to check the type of the object to prevent you from crashing the system.

*Barbara Liskov, 1988*

## Error Handling:

### Prefer Exceptions to Returning Error Codes

Returning error codes from command functions is a subtle violation of command query separation.
It promotes commands being used as expressions in the predicates of if statements.

This does not suffer from verb/adjective confusion but does lead to deeply nested structures.
When you return an error code, you create the problem that the caller must deal with the error immediately.

On the other hand, if you use exceptions instead of returned error codes, then the error processing code can be separated from the happy path code and can be simplified.

*Clean Code, Robert C. Martin, p46*

## Switch Statements:

* Should appear only once.
* Should be used to create polymorpic objects.
* Should be hidden behind an inheritance relationship so that the rest of the system can't see them.

*Clean Code, Robert C. Martin, p38*

> Switch statements should be buried in the basement of an Abstract Factory and never seen.

## Miscellaneous

### Smelly Environments:

* E1: Build Requires More Than One Step
* E2: Tests Require More Than One Step

*Clean Code, Robert C. Martin, p287*

### Smelly Tests:

* T1: Insufficient Tests
* T2: Use a Coverage Tool!
* T3: Don't Skip Trivial Tests
* T4: An Ignored Test Is a Question about an Ambiguity
* T5: Test Boundary Conditions
* T6: Exhaustively Test Near Bugs
* T7: Patterns of Failure Are Revealing
* T8: Test Coverage Patterns Can Be Revealing
* T9: Tests Should Be Fast

*Clean Code, Robert C. Martin, p313*

### General Smelliness:

* G1: Multiple Languages in One Source File
* G2: Obvious Behavior Is Unimplemented
* G3: Incorrect Behavior at the Boundaries
* G4: Overridden Safeties
* G5: Duplication
* G6: Code at Wrong Level of Abstraction
* G7: Base Classes Depending on Their Derivatives
* G8: Too Much Information
* G9: Dead Code
* G10: Vertical Separation
* G11: Inconsistency
* G12: Clutter
* G13: Artifical Coupling
* G14: Feature Envy
* G15: Selector Arguments
* G16: Obscured Intent
* G17: Misplaced Responsibility
* G18: Inappropriate Static
* G19: Use Explanatory Variables
* G20: Function Names Should Say What They Do
* G21: Understand the Algorithm
* G22: Make Logical Dependencies Physical
* G23: Prefer Polymorphism to If/Else or Switch/Case
* G24: Follow Standard Convention
* G25: Replace Magic Numbers with Named Constants
* G26: Be Precise
* G27: Structure over Convention
* G28: Encapsulate Conditionals
* G29: Avoid Negative Conditionals
* G30: Functions Should Do One Thing
* G31: Hidden Temporal Couplings
* G32: Don't Be Arbitrary
* G33: Encapsulate Boundary Conditions
* G34: Functions Should Descend Only One Level of Abstraction
* G35: Keep Configurable Data at High Levels
* G36: Avoid Transitive Navigation

*Clean Code, Robert C. Martin, p288-307*

## Names in Detail

### Use Intention-Revealing Names

The name of a variable, function, or class, should answer all the big questions. It should tell you why it exists, what it does, and how it is used. If a name requires a comment, then the name does not reveal its intent.

### Make Meaningful Distinctions

Don't add meaningless words or numbers to names just to satisfy the compiler.

### Use Searchable Names

Single letter names can only be used as local variables inside short methods. The length of a name should correspond to the size of its scope.

### Avoid Encodings

Hungarian notation or member variable prefixes are no longer needed. Prefer to encode implementation class names instead of interface class names. i.e. **ShapeFactoryImp**

### Avoid Mental Mapping

Classes and objects should have noun or noun phrase names. Avoid words like Manager, Processor, Data or Info. A class name should not be a verb.
Methods should have verb or verb phrase names. Accessors, mutators, and predicates should be named for their value and prefixed with get, set, is, has, can.

### Don't Be Cute

Choose clarity over entertainment value. Say what you mean. Mean what you say.

### Pick One Word Per Concept

A consistent lexicon is a great boon to the programmers who must use your code.

### Don't Pun

Avoid using the same word for two purposes.

### Add Meaningful Context

Add prefixes or suffixes to names as a last resort when necessary to give proper context to a name.

### Don't Add Gratuitous Context

Shorter names are generally better than longer ones, so long as they are clear. Add no more context to a name than is necessary.

# Demanding Professionalism in Software Development:

* We will not ship shit!
* Always be ready to ship.
* Have Stable Productivity.
* Build Inexpensive Adaptability.
* Continuously Improve the code. (The Boy Scout rule)
* Have Fearless Competence. (TDD)
* Extreme Quality.
* QA  Will Find Nothing.
* (QA Should Wonder Why they Are There.)
* We cover for each other.
* Honest Estimates. "I Don't know" or a range of values constantly updated.
* We will say "No" when we have to.
* We will say "Yes" when we believe it.
* We never "Try."
* Automate Everything!
* Continuous Aggressive Learning. (on your own time)
* Mentoring.

*Robert C. Martin, youtube*
