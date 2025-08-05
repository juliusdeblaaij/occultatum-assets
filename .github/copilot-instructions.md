When writing Netlogo code please use this as reference:


Introduction to NetLogo

    Overview and Objectives

    NetLogo: A First Look

    The World of NetLogo

    Basic Concept: Numerical Computation

    Core Concept: Reporter Procedures

    Core Concept: Lists

    Basic GUI Elements

    Core Concept: Plotting

    Basic Concept: Patches

    Basic Concept: Turtles

    Core Concept: Agentsets

    Core Concept: BehaviorSpace

    Summary and Conclusions

Overview and Objectives
Overview

This lecture provides a basic introduction to the NetLogo programming language, modeling environment, and toolkit. This material is crucial background for students who wish to implement the models of this course in NetLogo. This lecture constitutes a minimal introduction. The rest of this course conisders many additional features and applications of the NetLogo programming language and toolkit. Nevertheless, for the definitive details see [Wilensky-2017-CCL].
Goals and Outcomes

This lecture begins with a little historical background. It then explores the NetLogo GUI and introduces a few core language concepts. The primary goal is to introduce NetLogo at a level that suffices as background for the first lectures of this course.

Learning Outcomes

After mastering this lecture, students will be able to do the following.

    Explain the use of NetLogo’s. Interface, Info, and Code tabs.

    Describe key NetLogo features.

    Use the NetLogo Command Center to do calculations.

    Utilize some basic NetLogo programming constructs.

    Describe and create reporter procedures.

    Describe and create command procedures.

    Describe and create NetLogo lists.

    Explain the concept of an agentset.

    Manipulate patches and turtles from the Command Center.

    Use the NetLogo Dictionary to learn about NetLogo primitives.

    Add useful GUI widgets to the Interface tab of a NetLogo model.

    Explain how NetLogo’s BehaviorSpace tool supports simulation experiments.

Prerequisites

NetLogo is an open source application that may be freely downloaded. This lecture assumes that the student has downloaded and installed a recent version of the NetLogo software from the NetLogo website.
NetLogo: A First Look
What Is NetLogo?

NetLogo is a domain-specific programming language for individual-based and agent-based modeling. NetLogo is also the name of an associated agent-based modeling environment and an agent-simulation toolkit. This section provide an overview of NetLogo.

    cross platform.

    flexible data types.

    supports functional programming.

    useful language extensions.

    easily extensible.

NetLogo Overview

The NetLogo programming language is particularly simple to learn and to use, yet it is very powerful. The following features, along with NetLogo’s clear syntax and ease of use, have made NetLogo increasingly popular in introductory courses in agent-based modeling. NetLogo is cross platform: installers are available fore all major operating systems (including Windows 10 and OSX). The language provides flexible and useful data types, including lists and agentsets (as discussed below). It provides extensive support for procedural programming, and it provides some support for functional programming. Useful language extensions ship with the core language, greatly increasing the scope and power of the language. For advanced users, NetLogo is easily extensible.
Domain-Specific Language

File reading and writing:

    NetLogo does not ship with support for reading or writing binary files.
Object-oriented programming:

    NetLogo has no real inheritance or data encapsulation.
Interpretative interaction.

    The Command Center is very useful for interaction with the NetLogo interpreter, but it supports only limited features of the NetLogo language. (For example, it does not support declaration of new global variables, procedure definitions, or multiline commands.)

NetLogo is a domain-specific programming language. The domain is agent-based modeling and simulation (ABMS). The NetLogo programming language is quite powerful, even when compared to general purpose programming languages. Nevertheless, such an comparison also exposes some limitations. For example, it has limited support for multiple programming paradigms, it includes a very limited standard library, and it has limited support for file manipulation. Additionally, although the NetLogo Command Center is very useful for experimenting with NetLogo, but it directly supports only limited features of the NetLogo language. (For example, it is not possible to define procedures at NetLogo’s command line.)
NetLogo Strengths

As a domain-specific programming language, NetLogo does not try to compete with general purpose programming languages when it comes to general purpose uses. Instead, NetLogo provides a very useful agent-based modeling environment. Its domain-specific nature allows NetLogo to provide some unusual and powerful features for agent-based modeling and simulation (ABMS).

NetLogo includes many domain specific builtin commands (called primitives) that are useful specifically for ABMS. The primitives of the NetLogo language directly support the creation, command, and query of model agents. Support for spatially located agents is core to the language. (The space can be three-dimensional, but this course focuses on two-dimensional models.)
NetLogo Agents and Agentsets

NetLogo uses the term “agent” more broadly than is typical in the ABMS literature. Roughly, a NetLogo agent is any object that is able to process commands. Spatially located agents may be stationary agents (called patches) or mobile agents (called turtles, for historical reasons). NetLogo even provides a builtin agent type (called links) for relationships between turtles. There are four basic types of NetLogo agents.

observer

    The global command processor. There is only one observer for one running NetLogo model instance.
patch

    A stationary agent. Patches tile the extent of the NetLogo world, which contains a fixed number of patches.
turtle

    A mobile agent. A NetLogo world may contain any number of turtles, which may be created and destroyed.
link

    A relationship between turtles, which may be directed or undirected. A NetLogo world may contain any number of links between turtles, which may be created and destroyed.

Toolkit

In addition to the NetLogo programming language and useful agent types, NetLogo includes a domain-specific simulation toolkit. A simulation toolkit collects and integrates facilities that are useful for conducting simulation experiments. The NetLogo toolkit includes an integrated development environment (IDE) with the following features.

    A command-line interface (CLI), called the Command Center, for interacting with the agents in a model.

    A large collection of vetted examples and models in the NetLogo Models Library.

    Facilities for the easy definition and execution of simulation experiments.

    A Code tab that provides an editor with syntax highlighting, automatic indenting, many other features.

    An Info tab that simplifies model documentation.

    An Interface tab that support quick and simple GUI development, including real-time charts & visualizations.

NetLogo GUI Features

The Interface tab is a major feature of NetLogo’s simulation toolkit. It includes a graphics window (called the View) that automatically displays spatially located agents (patches and turtles). One may save the complete state of the model world at any time (in a format that can easily be re-opened or parsed with other software). Builtin language primitives make it simple to export the contents of this graphics View as an image and even, if desired, turn the images into a movie. As discussed below, the Interface tab even provides for easy point-and-click GUI building. The builtin widget types can control and monitor NetLogo simulations.

Launch NetLogo and click on the Interface tab. Add a button to the Interface tab as follows. Right click where you want a button, and pick Button from the resulting context menu. Try adding a print command (e.g., print "Hello World!") and a display name (e.g., SayHello). Click OK and then click your new button. you should see printed output in the Command Center. For more detail, see the NetLogo documentation for working with interface elements and the documentation of GUI buttons.
Easy Model Sharing

NetLogo models are easy to share. Saving a new NetLogo model creates a NetLogo model file, which has a .nlogo filename extension. Model files use simple a plain text format and are typically self contained. The NetLogo user community has shared more than a thousand models on the NetLogo Modeling Commons. Naturally, NetLogo must be installed to run these models on a personal computer. However, NetLogo Web provides a subset of NetLogo that runs in the browser. This allows easy sharing of simple NetLogo models on the worldwide web, without user requirements beyond a web browser.
The World of NetLogo

The section provides an introduction to the user interface of the NetLogo software. It introduces patches and turtles, two key NetLogo agent types. It also demonstrates how to enter commands in the Command Center in order to change patches and turtles.

After mastering this section, you will be able to do the following.

    Explain the role of the 3 tabs in the NetLogo GUI.

    Describe basic uses of the Command Center.

    Explain how NetLogo uses the term ‘agent’.

    Find and use the NetLogo Dictionary.

    Explain what patches are.

    Explain what patch coordinates are and describe how they relate to the NetLogo world size.

    Explain what turtles are.

    Explain what turtle coordinates are and describe how they relate to patch coordinates.

    Manipulate patches and turtles from the Command Center.

Tabbed User Interface

Interface:

    The GUI for the model; includes the Command Center, where we can enter NetLogo commands.
Info:

    The documentation editor; provides an area to create and store the model documentation.
Code:

    The code editor; provides an area to create and store the model code.

After installation, launch NetLogo like any other application on your computer. Upon start up, NetLogo presents the user with with a GUI that represents a new NetLogo model. Three tabs lie immediately below the main NetLogo menus. In NetLogo 6 these are labeled Interface, Info, and Code. The Interface tab displays the GUI for the new model. It also includes the Command Center, where a user can enter NetLogo commands. The Info tab holds model documentation and provides a convenient documentation editor. The Code tab is for model code, and it provides a NetLogo-aware code editor.
Observer

NetLogo uses the concept of a global observer—a kind of world-governing agent. The observer owns the global state, receives NetLogo commands, and passes commands to other agents (patches, turtles, and links). There is no visual display of the observer, but it is ever present. Figure f:Watcher comically illustrates this concept.
image of Uatu the Watcher

An Observer of the World

Source: https://www.marvel.com/characters/uatu-the-watcher
First Look: Command Center

The Command Center comprises an output area plus a command line. To the left of the command line, the observer> prompt should display. (If not, click whatever appears in the dropdown menu and choose that prompt instead.) This prompt indicates that the commands will be executed by a central model observer rather than by model-specific agents such as patches or turtles. In NetLogo terminology, entered commands run in observer context. For example,

print "Hello World!"
print 1 + 1

The first command asks NetLogo to print a string. (A string is a sequence of characters in double quotes.) The second command asks NetLogo to print the number that results from a simple computation. NetLogo knows how to print both strings and numbers. When a user enters a command, its result appears in the output area (usually, immediately above the command line).
print vs show

The behavior of the print command is unsurprising. It is possible to produce a fairly similar output with the show command.

show "Hello World!"
show 1 + 1

When you enter these commands at the command line, the output includes a specification of the context. That is, it includes the agent who is doing the showing. In this case, it is the observer agent, since the commands run in observer context.
Implicit Use of show at the Command Line

NetLogo also uses show when we simply enter an expression. This is a user convenience provided by the Command Center: if we enter an expression at the command line, NetLogo assumes we want to show its value in the Command Center. (In the output area, the show command is prefixed to the expressions entered.) For example, entering the following at the command line will cause an implicit use of show.

"Hello World!"
1 + 1

To recall a previous command to the command line, use the up arrow key; this scrolls through the command history.

Enter the following lines at NetLogo’s command line, one at a time, in observer context.

print "Hello World!"
print 1 + 1

Next enter the following lines. How does the output change?

show "Hello World!"
show 1 + 1

Next enter the following lines. Do you expect the output to change? Why or why not?

"Hello World!"
1 + 1

NetLogo Agents

    Patches are stationary NetLogo “agents” (i.e., they have a fixed location).

    Patches are present at NetLogo start up (i.e., they are usually not created by user code).

    Turtles are mobile NetLogo “agents” (i.e., they have a mutable position.)

    Turtles are not present at NetLogo start up (i.e., they must be created by user code).

NetLogo is a domain specific language, and its intended domain is agent-based modeling. Corresponding to this intent, NetLogo provides useful builtin agent types. One peculiarity of NetLogo’s basic agent types is that they are always spatially located. A NetLogo model automatically includes stationary agents and provides for the creation of mobile agents. NetLogo calls stationary agents patches, and NetLogo calls mobile agents turtles. In addition, NetLogo allows the creation links between turtles, and these links are also considered to be an agent type.
First Look: Patches

Patches are:

    Automatically created at start up, in a rectangular grid.

    Immobile, centered at integer locations.

    Displayed in the model’s View.

Patches are automatically created at start up. Each patch represents a spatial square in normal (Cartesian) coordinates. These square patches fill a NetLogo world, covering its entire extent. They are laid out in a rectangular grid, where each patch is centered at integer locations. Patches are immobile, so a patch is are uniquely identified by its fixed location. NetLogo code may use this location to refer to the patch (e.g., patch 0 0).

In the NetLogo Interface tab, patches receive a visual display. They are black (by default) and appear in an area known as the View (or alternatively, the Graphics Window). By default, patches fill a

grid, so the View initially looks like a black square.
Command-Line Interaction with Patches

In the Interface tab, users can interact with patches at NetLogo’s command line. For example, entering ask patch 0 0 [set pcolor red] at the command line causes a single patch (the one at the origin) to set its color to red. In this code, the brackets create a command block that holds code for the patch to execute. (In this course, the word brackets refers to square brackets. Later on, we will discuss this syntax in detail.) The model View immediately displays this new red color, without any additional action on the part of the user.

Consider asking all patches to change color in this way. By default there are

patches, so doing this one-by-one would be very tedious. However, NetLogo provides the patches keyword to refer to all of the patches at once. This allows for very simple code: ask patches [set pcolor white]. This code asks each patch to change its color to white. [1]
[1]

The patches change color sequentially, in random order. On modern computers, this happens too quickly to observe.

Using NetLogo’s command line, turn all patches black. Then, turn all patches blue.
First Look: Turtles

Turtles are:

    User created.

    Mobile (i.e., can change location).

    Located at any coordinates.

    Identified by the order of creation (e.g., turtle 0).

    Displayed on top of the patches in the model’s View.

Patches are stationary agents; each patch has a fixed location. NetLogo also provides mobile agents, called turtles. A NetLogo model automatically creates its patches. In contrast, turtles requires explicit creation. For example, create-turtles 1 creates a single turtle at the default location, which is

. NetLogo identifies turtles by their order of creation. The first turtle is turtle 0, the next is turtle 1, and so on.

A turtle is always on one patch at a time, and it displays on top of its patch in the model View. Like a patch, a turtle has a color, but the initial color is selected randomly for each turtle. Use ask to give commands to a turtle or a collection of turtles, just like with patches.

At NetLogo’s command line, explore the creation and manipulation of turtles by entering the following commands. (Everything following a semicolon is a comment, which means that NetLogo ignores it.)

create-turtles 1               ;create 1 turtle
ask (turtle 0) [set color red] ;set the turtle’s color

Turtle Location and Movement

A turtle cannot be uniquely identified by its patch or even its exact position. Multiple turtles may be at a single location. For example, create-turtles 10 will create

turtles at the origin. The ten turtles appear as arrowheads (the default shape) at the center of the model View. Additionally, a turtle is not constrained to integer positions; it can move to any real coordinates in the extent of the world.

For example, ask turtles [forward 0.5] causes each turtle to move forward by half a patch width. Here, turtles refers to the entire collection of all turtles. Therefore, each turtle will move forward. [2] The direction forward is given by a turtle’s heading; here this is the direction it is pointing.
[2]

Turtles move one after the other (in a random order). On modern computers, this happens too quickly to observe.

Using NetLogo’s command line, explore the creation and manipulation of turtles by entering the following commands. (The clear-all command resets the model to no turtles and black patches.)

clear-all                 ;start from scratch
create-turtles 10         ;create 10 turtles
ask turtles [forward 0.5] ;move turtle by half a patch

World, Patches, Turtles

Conceptualize a NetLogo world as a rectangular arena that includes immobile agents (called patches) and possibly some mobile agents (called turtles). Square patches tile the entire rectangular world. They are fixed in number and location, and a NetLogo model must have at least one patch. (By default, a new world tiles
patches in grid.) Patches constitute the terrain of the world. Turtles can move across this terrain. By default, a new world has no turtles; the user must explicitly create them. Figure netlogoViewSmall illustrates a small world with gray patches and

white turtle.
A small NetLogo world.

Illustrating a Small NetLogo World
Quick Characterization of a World

Figure umlclassboxNetLogoWorld provides a simplified class-box diagram of a NetLogo world. (See the UML Introduction lecture for an overview of class diagrams.) This simplified class box has three compartments. The first names the type of object; the second lists key attributes of this type of object; and the third lists key behaviors of this type of object. So the second compartment states that a World includes one or more ([1..*]) patches and zero or more ([0..*]) turtles. Finally, the third compartment states that a World is able to create turtles.
UML class box for NetLogo World.

NetLogo World
Quick Characterization of a Patch

Figure umlclassboxNetLogoPatch provides a simplified class-box diagram of a NetLogo patch. This time, the third compartment is empty. (For the moment, we do not consider any patch behaviors; but see below.) The second compartment lists two integer-valued attributes: pxcor and pycor. These are normal Cartesian coordinates that give the location of the center of the patch. Note that these are marked as frozen: the coordinates of a patch are immutable. These coordinates uniquely identify the patch; only a single patch can occupy a given location. A Patch also has a turtles-here attribute, which holds the set of turtles located on the patch. This attribute is not marked as frozen, because turtles are mobile and can change their position.
UML class box for NetLogo Patch.

NetLogo Patch
Quick Characterization of a Turtle

Figure umlclassboxNetLogoTurtle provides a simplified class-box illustration of a NetLogo turtle. The second compartment lists two real-valued attributes: xcor and ycor. These are normal Cartesian coordinates that give the position of the turtle. Note that these are not marked as frozen: the coordinates of a turtle are mutable. These coordinates do not uniquely identify the turtle; more than a single turtle can occupy a given position. A Turtle also has a patch-here attribute, which holds the patch located below the turtle. This attribute is also not marked as frozen, because turtles are mobile and can change their position. This time, the third compartment contains a single behavior. The setxy behavior moves the turtle to the provided coordinates (assuming these lie within the world). For the moment, we do not consider other any turtle behaviors, but see below.
UML class box for NetLogo Turtle.

NetLogo Turtle
World Size

By default, a NetLogo world is 33 patches wide and 33 patches high. So by default, a world has a total of

patches. NetLogo provides the world-width and world-height primitives to report the this width and height. There is also a count primitive that can count all the patches.

Using NetLogo’s command line, explore the size of the NetLogo world by entering the following commands.

print world-width
print world-height
print count patches

Patch Coordinates and World Size

Recall that the patches of a world tile a rectangular grid that is the extent of the word. The number of columns in this grid is world-width. The number of rows in this grid is world-height. The coordinates of the bottom-left patch can be produces with min-pxcor and min-pycor reporters. The coordinates of the top-right patch can be produces with max-pxcor and max-pycor reporters. By default, the patch at the origin is in the very center of a NetLogo world.

Using NetLogo’s command line, explore the coordinates of the NetLogo world by entering the following commands. (Each should print true.)

print (world-width = 1 + max-pxcor - min-pxcor)
print (world-height = 1 + max-pycor - min-pycor)

world-width

    the number of columns in the terrain grid: 1 + max-pxcor - min-pxcor + 1
world-height

    the number of rows in the terrain grid: max-pycor - min-pycor + 1
resize-world <minx> <maxx> <miny> <maxy>

    Reset the world size by setting new values for the min and max of pxcor and pycor.

All Together Now

You can think of max-pxcor, min-pxcor, max-pycor, min-pycor as core attributes of a world. (These imply world-width and world-height.) Figure umlclassNetLogoWorld adds the properties to our class-box diagram of a NetLogo world. It also provides a simplified diagram of the relationship between a World and its Patch and Turtle components.

This simplified class diagram says that the components of a NetLogo world include one or more ([1..*]) patches and zero or more ([0..*]) turtles. It also shows the attributes underlying the world’s terrain creation: max-pxcor, min-pxcor. max-pycor, and min-pycor. The integer-valued coordinates of each patch, pxcor and pycor, satisfy min-pxcor <= pxcor <= max-pxcor and min-pycor <= pycor <= max-pycor.
images/umlclassNetLogoWorld.svg

NetLogo World with Patch and Turtle Components
Basic Concept: Numerical Computation

After mastering this section, you will be able to:

    Use the NetLogo Command Center to do calculations.

    Explain the similarities and differences between command primitives and reporter primitives.

    Create a user defined function.

    use set to change the value of a variable.

    NetLogo is case-insensitive.

    Arithmetic operators must be surrounded by white space.

    Define local variables with the let command (not the equals sign).

    The local variables we define with let are local to their code block. (Each line we enter in the Command Center executes as a separate code block.)

    Although -2 is a literal number, we must use (- x) to produce the additive inverse of the variable x.

    After we have defined a local variable with let, we change its value with set.

This section shows how to use NetLogo’s Command Center as a numerical calculator. It shows how to create user-defined functions, and differentiates between local and global variables. It introduces the concept of execution context in the Command Center.
Observer as a NetLogo Agent

Patches and turtles are examples of agents. NetLogo agents can run commands and ask other agents to run commands. Since the observer that processes commands in NetLogo’s command center has these abilities, it too is considered a NetLogo agent. Simple numerical computations in NetLogo may be performed by the observer in the Command Center.
Arithmetic Operators

NetLogo uses the familiar arithmetic operators for addition (+), subtraction (-), multiplication (*), and division (/). These are also in common use in many other programming languages. However, in NetLogo these operators must be surrounded by spaces.

NetLogo uses the caret (^) operator for exponentiation. The caret operator has a different meaning in many other programming languages, so be alert when switching between languages. Also, NetLogo evaluates the mathematically indeterminant expression
as

. This is a common choice among programming languages, but it is by no means universal (not even in spreadsheets).
Infix Arithmetic Operators

A binary arithmetic operator is special kind of function: it has two input (the operands) and an output (the result). (See the Glossary for more details.) In most programming languages, binary arithmetic operators are infix. This means that the operator must appear in between the two operands. NetLogo’s standard arithmetic operators follow this common practice.
Arithmetic Computations

Recall that a NetLogo model always includes a special model manager, called the observer. The observer manages the behavior of a model by responding to commands. Users can interact directly with the observer in the Command Center. For example, users can print the results of simple computations such as 10 + 2, 10 - 2, 10 / 2, 10 * 2, or 10 ^ 2 or :code:` New NetLogo users are often surprised that these binary arithmetic operators must be surrounded by white space.

Recall that the Command Center includes a command line, for the entry of NetLogo commands, and an output-display area. In addition, to the left of the command line is the context chooser, which is a popup menu. (Unless explicitly directed otherwise, assume code entered at the command line should run in observer context.)

The print command can print the results of numerical calculations to the output-display area. Since NetLogo is case-insensitive, the consistent use of upper or lower case names is only for reader convenience. That is, print and PRINT are two equivalent ways of writing the same command.

At NetLogo’s command line, in observer context, enter each of the following expressions in the order presented. Some will not execute successfully; be sure you can explain why.

print 2+2    ;problem!
print 2 + 2
print 2-2    ;problem!
print 2 - 2
PRINT 2 - 2  ;equivalent

Parentheses

Parentheses may always surround a NetLogo expression, but this is seldom required. As in most programming languages, and as in ordinary classroom arithmetic, NetLogo code may require parentheses to eliminate ambiguity in the order or operations. And as in most languages, multiplication and division have priority over addition and subtraction.

print 2 + 2        ;print the value of an expression
print (2 + 2)      ;use an equivalent parenthesized expression
print 2 + 2 * 5    ;print the value of an expression
print 2 + (2 * 5)  ;use an equivalent parenthesized expression
print (2 + 2) * 5  ;change the order of evaluation

Occasionally NetLogo does require parentheses. Most commonly, this arises when a NetLogo primitive has multiple forms. Most surprisingly, this arises when producing the additive inverse of a numerical variable.

(range 1 10 2)      ;parentheses required
let x 2 print (- x) ;parentheses required

New NetLogo programmers often forget that negating a variable requires parentheses. Although -2 is a normal literal number, NetLogo requires (- x) to produce the additive inverse of the variable x.
Local Variables

The let introduces new local variables. For example, within a code block, let x 2 introduces a local variable named x with an initial value of 2. This is the only way to introduce new names at the command line or inside a procedure definition. Do not try to use the equals sign for this.

Variables defined with let are local to their code block. When used at the command line, this means they do not persist across multiple uses of the command line. (Each line entered in the Command Center runs as a separate code block.)

After defining a local variable with let, use set to change the value. Again, do not try to use the equals sign to assign values! New users often consider NetLogo’s syntax for setting the value of a variable to be particularly surprising. The equals sign never has this use.

At NetLogo’s command line, in observer context, enter each of the following expressions in the order presented. Not all will execute successfully; be sure you can explain why.

x = -2                          ;problem
let x -2
print x                         ;problem
let x -2 print X
let x -2 print -x               ;problem
let x -2 print (- x)
let x -2 let x (x + 1) print x  ;problem
let x -2 set x (x + 1) print x

Repeated Execution of Command Blocks

A command block is a bracketed sequence of commands. The repeat command allows provides repeated execution of a command block, as many times as wished. For example, repeat 10 [print "Hello!"] will execute the print command

times.

In the NetLogo Dictionary, read the documentation for the repeat command. At NetLogo’s command line, in observer context, enter the following commands (all on one line). Remember: use let to introduce a variable, but use set to change its value.

let x 0 repeat 50 [set x (x + 1)] print x

    Explain why the observer prints 50.

    What happens if we move the closing bracket to after print x? (Explain.)

    What happens if, after executing the above code, we enter print x at NetLogo’s command line? (Explain.)

Hint

Brackets surround a code block.
Arithmetic Comparisons

NetLogo provides a standard set of comparison operators, including not equal to (!=), greater than (>), greater than or equal to (>=), less than (<), and less than or equal to (<=). The equal-to operator is a single equals sign (=), as in most spreadsheets.

As with most programming languages, NetLogo’s comparison operators are infix operators. A comparison operator produces a boolean result. This just means that the value produced is either false or true. These special values are neither numbers nor strings. However, they print just like the strings "true" and "false".

At NetLogo’s command line, in observer context, print each of the following expressions in the order presented. The first three commands should print true; the last four should print false. (The parentheses are just for readability; NetLogo does not require them.)

print (1 + 2 = 3)
print (1 + 2 <= 3)
print (1 + 2 >= 3)
print (1 + 2 != 3)
print (1 + 2 < 3)
print (1 + 2 > 3)
print (true = "true")

NetLogo variables can have boolean values. Try the following at the command line. (The parentheses are unnecessary but may make this a bit easier to read.

(let bool01 true) print bool01 (set bool01 false) print bool01

Conditional Execution

Boolean values have many uses, but a particularly common use is to control whether or not a piece of code is executed. For example, a simple if statement conditionally executes a command block according to the value of a boolean expression. (Recall that a command block is a bracketed sequence of commands.) Try the following at the command line.

if true [print "this"]   ;prints "this"
if false [print "this"]  ;no action

The if command is followed by a boolean expression and a block of commands (in brackets). The boolean expression is called the condition. If the boolean expression evaluates to true, the commands execute. If the boolean expression evaluates to false, they are not.

An ifelse statement conditionally executes one of two command block, according to the value of a condition. Try the following at the command line.

ifelse true [print "this"] [print "that"]   ;prints "this"
ifelse false [print "this"] [print "that"]  ;prints "that"

The ifelse command is followed by a condition and two command blocks. If the condition evaluates to true, the first command block executes. If the condition evaluates to false, the second command block executes.
Boolean Operators

Two boolean values can be combined by the infix binary boolean operators and, or, and xor. There is additionally a unary operator not, which is a prefix operator. Let bool01 and bool02 represent boolean values. Then the following relationships are definition for these operators.

not bool01

    reports true if bool01 is false; reports false if bool01 is true;
bool01 and bool02

    reports true if bool01 and bool02 are true; otherwise reports false
bool01 or bool02

    reports true if bool01 or bool02 (or both) are true; otherwise reports false
bool01 xor bool02

    reports true if bool01 or bool02 (but not both) are true; otherwise report false

Try the following at the command line.

if (true or false) [print "this"]   ;prints
if (true and false) [print "this"]  ;no action

Core Concept: Reporter Procedures

After completing this section, you will be able to do the following.

    Explain the basic structure of a reporter procedure.

    Provide the defintion of a pure function.

    Create a reporter procedure that is a pure function.

    Learn how to declare global variables.

    Explain the difference between local and global variables.

Commands and Reporters

command

    Tells an agent to do something, but returns no value.
reporter

    Computes a value and returns it for further use. (Synonym for function.)

The NetLogo language includes a sizeable collection of primitives, which are documented in the NetLogo Dictionary. These are the commands and reporters built into the language. A command primitive tells some agent what to do, but produces no value. A reporter primitive computes a value and returns it for possible further use. [3]
[3]

The term reporter is rather NetLogo-specific. Similar terminology is used in other Logo-based languages, including StarLogo, Logo Blocks, Scratch, and Snap!. However, most languages use the term function instead.

By convention, command names are usually verbs that describe the type of action caused by the command. For example, print is a command; use it to print a value. By convention, reporter names are usually nouns that describe the meaning of the value produced by the reporter. For example, abs is a reporter; use it to produce the absolute value of a number.
Procedures

Programmers typically bundle together useful computations as named subroutines, for easy reuse. Instead of rewriting the entire code block each time the computation is needed, we use the subroutine name alone to run the enitre code block.

Like most programming languages, NetLogo allows users to create such named subroutines to implement user-defined commands and functions. In NetLogo, these are called command procedures and reporter procedures. A NetLogo procedure is a named subroutine—that is, a named block of code. The code block is the procedure body. To run the procedure body, simply use the procedure name. Typically, most NetLogo programming effort goes into creating appropriate procedures.
Programs

Most code for a NetLogo model is usually in the Code tab. This code typically includes numerous command and reporter procedures. These two procedure types have different purposes. A reporter procedure returns a value, and a command procedure does not. While both prove indispensable for NetLogo programming, a well-written program typically relies more heavily on reporter procedures.
Reporter Procedures are Functions

A reporter procedure returns a value, and the value it returns is said to be reported. This is precisely the nature of a computational function. Programmers commonly use the term function for any callable subroutine that produces a return value. NetLogo programmers often use the term reporter in preference to the synonymous term function, but this course will favor the latter.
Simplest Contrast

NetLogo procedures attach a name to a block of code that we want to reuse. The code for a command procedure does something useful, such as printing a value so that you can see it. The code for a reporter return a value. Here is a trivially simple command procedure. It just prints the value

.

to print-null
   print 0
end

Here is a trivially simple reporter procedure. It always returns the value

.

to-report null
   report 0
end

As soon as you define these procedures in the Code tab, you can use them at the command line (in the Interface tab). So try these two procedures at the command line.

The print-null command procedure and the null reporter procedure might initially seem to behave qute similarly, but in fact they are very different. How can you demonstrate this difference?
Creating Simple Functions

Mathematically, a function maps inputs (from the domain) to corresponding outputs (in the codomain). Computational functions often bear a close resemblance to mathematical functions. (See the Glossary for a discussion of mathematical and computational functions.) Here are some simple examples of univariate function definitions.

Hint

You must define procedures in the Code tab, not at the command line. However, after entering a defintion in the Code tab, you can test it at the command line.

A constant function:

to-report always0 [#x]
  report 0
end

The identity function:

to-report identity [#x]
  report #x
end

A growth function:

to-report growth01 [#x]
  report 1.01 * #x
end

A squaring function:

to-report xsq [#x]
  report (#x * #x)
end

These examples illustrate the general syntax for defining a simple reporter procedure. Use the NetLogo keyword to-report to introduce the name of the reporter procedure and (in square brackets) any parameters. Use the NetLogo keyword end to end the procedure definition. In between is the procedure body, which implements the function. The body of a reporter procedure must include the NetLogo keyword report, which reports a result. If we let angle brackets mark substitution locations, these examples all adhere to the following basic model.

to-report <function-name> [<parameter>]
  report <result>
end

Note

A useful convention in NetLogo is to begin the names of function parameters begin with an octothorpe (#). This course generally follows this convention, but it is not required by NetLogo.
Function Parameter

The univariate function examples each introduce a new name, #x. This name is the input parameter for the function. The parameter allows us to characterize the function’s manipulation of any input value, no matter which value it is. The parameter name is arbitrary. Crucially, the parameter name is a local variable in the definition. This means that we can use the same name in multiple procedure definitions, and they do not interact at all.
Parameter-Naming Convention

When describing NetLogo procedures, this course adheres to the following parameter-naming convention: the names always begin with an octothorpe (#). It may seem surprising that such names are possible. In contrast to many other programming languages, the octothorpe is a valid character in NetLogo identifiers (including parameters).

This course prefixes the names of procedure parameters in this way. NetLogo does not impose this practice; it is just a convention. It ensures that the names of procedure parameters never conflict with the names of global variables.
Function Arguments

When we apply a computational function to a value, we call that value the argument of the function. Pay careful attention to the difference between function parameters and function arguments. Function parameters are variables used during function defintion to represent any possible argument that might be provided to the function. Once we have defined a function, we can apply it to an argument in order to produce an output.

In NetLogo, function arguments are not put in brackets. (But, you must bracket the parameters in a procedure definition.) For example, after adding the identity function above to your Code tab, try the following at the command line.

print (identity 1)

This applies the identity function to an argument of 1 and then prints the result. The parenthesis are optional, but they may help a reader to understand the code.
Procedures in Code Tab

Procedures cannot be defined at NetLogo’s command line, although they can be used there. Putting the growth01 code in the Code tab declares a reporter procedure named growth01. This is a computational implementation of a univariate function. The function name is growth01. The function has one parameter, named #x. Once it is defined in the Code tab, we can apply the function to a value in order to produce a return value. The actual input value is an argument for the function.

Copy the growth01 procedure into the Code tab. At NetLogo’s command line, experiment with this new function by applying it to various arguments. (E.g., print (growth01 100).)

Hint

The Code tab adds syntax highlighting whenever code is displayed in the GUI’s Code tab. This highlighting is provided by the editor for reader convenience. It is not stored in the model file, nor is it part of the code.

In contrast to many other languages, simple function application in NetLogo does not use parentheses.
Pure Functions

Each of the univariate-function examples implements a pure function. A function is pure if its behavior is closed to outside influences and running the function causes no side effects. (See the Glossary for further discussion of pure functions.) Saying the function is closed means that its behavior is independent of the context in which it runs; a given input value always produces the same output, regardless of other things that may be happening in the program. Pure functions also have no side effects. Examples of side effects include changing the value of a global variable or printing a value to a computer screen. A pure function is a computational function that behaves much like a familiar mathematical function.
Different Return Type

A pure function need not be numerical. Even when a pure function has a number as an input, it may return some other type as an output. For example, consider an isEven function that returns true if the input number is an even integer and false otherwise. Recall that true and false are boolean values, so this function has a boolean return type. If this is all this function does, it is a pure function.

Look up mod in the NetLogo Dictionary. Explain why, for any integer n, the expression n mod 2 evaluates to 0 if and only if n is even. Using the mod operator, add an isEven function to the Code tab. Implement this as a pure function (e.g., it should not use the print command). Test your implementation at NetLogo’s command line in order to ensure that it behaves as expected.
Introduction to Function Iteration

When the return type of a univariate function matches its argument type, the function can be reapplied to the value it produces. This is called function iteration. (See the Glossary for a brief introduction to function iteration.) For example, suppose
is a univariate real function. Then given a number we can produce a new number by applying to . And then we can produce a new number by applying to

. And so on.

Copy the growth01 function (above) into NetLogo’s Code tab. Then enter the following at the command line.

growth01 100
growth01 growth01 100
growth01 growth01 growth01 100

Iterating a function by hand quickly becomes tedious. Once again, the repeat command proves handy. Review the documentation of the repeat command in the NetLogo Dictionary. Then enter the following at the command line.

let x 100 repeat 3 [set x (growth01 x)] print x

Carefully explain why this prints the same value as before. In this example, the new way does not seem to have saved any keystrokes. Why is it better? (Hint: What value is produced after

iterations?)
Core Concept: Global Variables

NetLogo allows the creation of global variables, which are visible everywhere in a NetLogo program. Global variables cannot be created in the Command Center. Instead, use the globals keyword to declare global variables at the top of the Code tab. For example, globals [x] declares a new global variable, named x. NetLogo models often use global variables as model parameters or to track the state of a simulation.

These variables are called global because they are visible to every part of the model. Any agent can access or even change the value of any global variable. Global variables are even visible inside of procedure definitions. For this reason, the names of a procedure parameter cannot be the same as the name of a global variable.
Changing a Global Value

When declared, a global variable has a default value of 0. Use the set command to change the value of any global variable. For example, at Command Center, we might enter set x 42 to set the value of a global variable x to

.

At the top of the Code tab, add the following declaration.

globals [x y z]  ;declare 3 global variables

Switch to the Interface tab. At NetLogo’s command line, in observer context, enter the following commands one at a time.

print x
set x 42
print x

These commands execute without error, because x is a global variable. The first print command prints 0, because all global variables declared in the Code tab automatically receive an initial value of 0. The set command changes the value of the variable, so the second print command prints 42.
Repeatedly Updating a Global Variable

NetLogo programs often use global variables to keep track of changing values. As seen previously, set can repeatedly reset the value of a variable.

In the Code tab, declare a global variable x Below that, copy the growth01 function. Next, at the command line, set x to 100 and then iteratively apply the growth01 function above to update the value of x as follows.

set x 100                       ;inital value
repeat 50 [set x (growth01 x)]  ;update x
print x

What value do you expect this code print? Does it? Are the brackets important in this code? Are the parentheses important in this code? Be sure you can explain why or why not.
Core Concept: Lists

This section provides a brief introduction to lists. A list is an ordered collection of objects. NetLogo lists are immutable: you cannot change an existing list. However, new list can be created from existing lists.

After mastering this section, students will be able to do the following.

    Create new lists.

    Create shorter and longer lists from existing lists.

    Iteratively append to a list in order to accumulate simulation data.

    Explain the concept of dynamic typing.

List Creation

NetLogo’s list constructor makes list construction very simple. The use of parentheses is required unless the number of terms is exactly two.

(list 0 1 2 3)         ;list of 4 numbers
(list "0" "1" "2" "3") ;list of 4 strings
(list )                ;empty list
(list (1 + 2) (3 + 4)) ;list of 2 numbers

When printed, these lists display in brackets. This is a completely distinct use of brackets in NetLogo. While not required, when creating literal lists, NetLogo programmers conventionally use this short-cut bracket notation for list creation. This is only possible if the list contains only number literals or string literals or nothing at all. In such cases, just place brackets around a space-separated sequence of constants.

[0 1 2 3]         ;a list of numbers
["0" "1" "2" "3"] ;a list of strings
[]                ;an empty list

However, the list constructor is more general. For example, it is needed whenever an of the list items are variables.

let a 0 print (list a 1)

List Creation via range

Orderly ranges of integers are a common need in programming, and NetLogo supports this with the range command. As an example of its simplest use, range 5 creates a list of the first five nonnegative integers.

print (range 5)     ; [0 1 2 3 4]

New Lists from Old: Selecting Shorter Lists

A commonly needed list manipulation is to extract some but not all of the list. The butfirst and butlast reporters are particularly useful: they remove the first item and the last item from a list. The remove-item reporter can remove an arbitrary item. Since NetLogo lists are immutable, the results of these operations are new lists. The original list remains unchanged.

In the NetLogo Dictionary, read the documentation for remove-item. the documentation for butfirst, and the documentation for butlast. Open the same NetLogo file as before, which declares the global variable x. Enter the following at NetLogo’s command line.

set x [0 1 4 8]
print butfirst x      ;; [1 4 8]
print remove-item 0 x ;; [1 4 8]
print butlast  x      ;; [0 1 4]
print remove-item 3 x ;; [0 1 4]

Hint

Even though NetLogo initially sets x to 0, you may change the value to be a list—or indeed, to any other value. To describe this feature of the language, we say that NetLogo is dynamically typed.
New Lists from Old: Longer Lists

Another commonly needed list manipulation is to add an item to a list. Particularly common needs are to add an item at the beginning with fput or at the end with lput. Lists may also be concatenated with sentence. Since NetLogo lists are immutable, the results of these operations are new lists.

Reuse your existing NetLogo file, whose Code tab declares the global variable x. Enter the following at NetLogo’s command line.

print fput 9 [0 0]         ;; [9 0 0]
print lput 9 [0 0]         ;; [0 0 9]
print sentence [0 0] [1 1] ;; [0 0 1 1]

set x [0 1 4]
print lput 8 x
print x

What do you expect to be the result of the final print statement? Is it? Be sure you can explain why.
Iterative List Building

Iterative list building repeatedly appends to a list as new values are produced. This is a common need in simulation modeling. For example, reconsider the earlier example of iterative updating after each application of growth01. Instead of discarding the old values as the iteration proceeds, we may prefer to accumulate them.

Reuse your existing NetLogo file, whose Code tab declares the global variable x. Enter the following code at the command line.

set x [100]
repeat 50 [set x lput (growth01 last x) x]
print x

Carefully explain what each line of code accomplishes. Predict what the final print statement produces.
Substitutive List Building

Substitutive list building replaces each item in a list with the result of applying a function to that item. This is called mapping over the list. Since NetLogo lists are immutable, the results of this mapping operation is a new list.

NetLogo provides the map primitive for substitutive list building. Apply map to a function and a list in order to produce a new list. This applies the function to each item in the old list.

In the NetLogo Dictionary, read the documentation for map. Add the xsq reporter procedure (illustrated above) to the Code. (Remember, it must come after any globals declaration.) After predicting the result, enter the following at NetLogo’s command line.

print map xsq [0 1 2 3]   ; [0 1 4 9]

Accessing List Items by Index

Access list items with the item reporter, which takes as arguments an index and a list. Indexing is zero-based, with just means that the first item is indexed by zero. The first item can alternatively be accessed with the first reporter, and the last item can alternatively be accessed with the last reporter.

.. container:: exercise

    In the NetLogo Dictionary, read the documentation for list and the documentation for item. Continue to use the previous NetLogo model, whose Code tab declares the global variable x. Enter the following at NetLogo’s command line.

    set x [0 1 4 8]
    print (item 0 x) ;; first item
    print first x    ;; first item
    print (item 1 x) ;; second item
    print last x     ;; last item

Accessing Random List Items

NetLogo’s one-of reporter primitive can pick a random item from a list. To illustrate this facility, construct a list of possible outcomes as (list -1 1) and repeatedly apply the one-of reporter to it. Equivalently construct a list of possible outcomes as [-1 1] and repeatedly apply the one-of reporter to it. (Recall that when all of the list members are literal numbers, we may write [-1 1] instead of (list -1 1).)

The argument is always the same list. Nevertheless, sometimes the result is -1, and sometimes the result is 1. Each time, this produces -1 or 1 with equal likelihood. Such behavior is a simple representation of random outcomes. Each new application of the builtin one-of reporter to this same list may produce a different value than the previous value.

Enter the following multiple times at NetLogo’s command line, after predicting the result.

one-of (list -1 1)

Is NetLogo’s one-of reporter a pure function? Explain.
Digression on Random Outcomes

It is natural to be puzzled by the idea that a computer simulation can incorporate randomness. It seems absolutely essential to the concept of a digital computer that it never behave in unpredictable ways. Yet simulation models often require some way to simulate randomness. Computational science reconciles the need for computational predictability and randomness by working with pseudo-random numbers. These are computer generated numbers that, as far as this course is concerned, behave just like truly random numbers. NetLogo provides reasonably extensive builtin random number facilities. [4]
[4]

The rnd extension provides additional facilities.
Randomness vs Purity

A function is pure if its only action is to return a value that is fully determined by its inputs. The effects of calling a pure function are completely predictable. When possible, functions should be pure. However, when one-of is called, the result depends on the state of the random number generator. This state is a hidden input to the procedure. Calling the function changes the state of the random number generator. This invisible change is a side-effect of calling this reporter primitive. So one-of is influenced by its environment and also has side-effects. It is not a pure function.
Basic GUI Elements

    sliders

    choosers

    switches

The Interface tab of a NetLogo model typically includes GUI widgets for simulation control and visualization. NetLogo allows using a “right click” in the Interface window to produce a context menu that can add GUI elements.
Sliders, Choosers, and Switches

Widgets such sliders, choosers, and switches provide users with GUI control over model parameters. For example, a slider might control the number of agents created during the model setup. Each of these widgets automatically declares a global variable, known as an interface global. This means that global variables can be declared in the Interface (instead of in the Code tab). Interface globals (set in sliders, switches, and choosers) are a convenience feature with downsides as well as upsides.
Sliders, Choosers, and Switches: Some Upsides

Sliders, choosers, and switches facilitate easy interactive experimentation with a model. Furthermore, as we will see later, they are designed to interact well with BehaviorSpace. This means that they additionally facilitate automated model experimentation.
Sliders, Choosers, and Switches: Some Downsides

Since Interface variables are not declared in the Code tab, they are less visible to a reader of the model code. This lack of visibility can be somewhat offset by a convention of listing the interface globals in a comment. Additionally, if model is opened with a text editor, its widgets are visible in the .nlogo file, as plain text.

A larger drawback of Interface globals is the absence of a default value. For example, if a user resets a slider and then saves the model, it saves the new slider value (not the original value). To address this, it is a good idea to use NetLogo’s special startup procedure to set default values when a model first loads.
Plot Widgets

NetLogo also includes display widgets for plots and monitors. These are just easy to add in the NetLogo Interface. NetLogo charts can dynamically plot a single value (plot), pairs of values (plotxy), or collections of values (histogram).
Core Concept: Plotting

This section provides a basic introduction to NetLogo’s plotting facilities. These support the easy creation of dynamic plots in the NetLogo interface.

After mastering this section, you will be able to do the following.

    Create plot widgets.

    Use the plotxy and plot commands.

    Produce dynamic plots for a simulation model.

Plot Widgets

NetLogo provides GUI widgets for plotting. Use the Add button in the Interface tab to add a new plot window. Or, add a plot by right-clicking where you want your plot located and then picking the Plot option. In the resulting dialogue, enter an appropriate name for the plot; this name displays in the plot widget and also provides a way to refer to the plot. Typically, you will also remove or replace the default pen-update commands and then set the x and y axis ranges to suitable values.

Hint

The NetLogo Programming Guide provides extensive plotting documentation.
Plotting with plotxy

A plot widget provides a view on a two-dimensional plane, which has a familiar rectangular coordinate system. The plotxy command correspondingly requires two input arguments: the
and

coordinates of the point to plot. This command plots a single point at the provided coordinates. By default, NetLogo draws a line segment to each newly plotted point. [5] However, it is possible to raise or lower the plot pen with the plot-pen-up and plot-pen-down commands. A raised plot pen does not draw when it is moved. By default, the plot pen is down. After entering plot-pen-up, plotxy still moves the plot pen to the next point but plots nothing.
[5]

The mode of the plot pen controls this behavior. You can set the mode by editing the plot pen in the plot-creation dialog or by using the set-plot-pen-mode command. Each plot may have multiple pens, but use only the default plot pen for now.

In the Interface tab, add a plot. In the plot-creation dialog, name the plot plot01 and delete the default pen-update commands. At NetLogo’s command line, enter the following:

plotxy 0 0
plotxy 1 1
plot-pen-up
plotxy 2 2
plot-pen-down
plotxy 3 3

Plotting with plot

The plot command requires only one input argument. This number is the ordinate of the plotted point. (This is the distance along the vertical axis, sometimes called the
-coordinate.) The plotted point also has an abscissa, of course. (This is the distance along the horizontal axis, sometimes called the

-coordinate.) When you use the plot command, NetLogo provides the abscissa as an automatically incremented number.

So just provide plot with a
coordinate (in the standard rectangular coordinates). By default, the coordinate is initially and increments by

with each call to plot. [6] Just as with plotxy, raising the plot pen stops plotting but not pen movement.
[6]

When needed, control this increment with the set-plot-pen-interval command.

Clear plot01 by entering clear-plot at NetLogo’s command line. Then enter the following:

plot 0 plot 1
plot-pen-up plot 2
plot-pen-down plot 3

Basic Plot of a Changing Global Variable

NetLogo models often apply the plot command to a global variable whose value is a number. This proves very useful. For example, if a global variable y has a numerical value, plot this value with plot y.

Check that you have already declared y to be a global variable, have added growth01 to the Code tab, and have added a plot widget to the Interface tab. (See above.) Enter the following at NetLogo’s command line.

clear-plot                            ;clear the plot to start afresh
set y 100                             ;set the value of global variable y
plot y                                ;plot the value of y
repeat 50 [set y (growth01 y) plot y] ;plot 50 points

Pen-Update Commands

NetLogo allows plotting code to reside within the plot widget, instead of in the Code tab. The plot-creation dialog includes an area for pen update commands. These are usually plotxy or plot commands. As shown above, the plot command is a bit simpler: it requires only a single argument—a user-provided number.

Clear plot01 by entering clear-plot at NetLogo’s command line. Right-click on the plot and choose Edit… from the context menu. Add the following pen update commands to the default pen: plot 0 plot 1 plot 2, and then click the OK button. Next, at the command line, enter update-plots. This executes the pen-update commands contained in the plot widget. Do this multiple times and describe what happens.
Code in Plots

The update-plots command runs all the code in a plot widget’s Pen update commands. Similarly, the setup-plots command runs all the code in a plot widget’s Pen setup commands. Use of the facilities is common in NetLogo models. In addition, The update-plots and setup-plots commands are typically called by other NetLogo commans.

Most NetLogo models run the reset-ticks command during the setup phase. As documented by the NetLogo Dictionary, this command has many effects that are useful during model setup. One of these is that it calls setup-plots. Additionally, it then calls update-plots.

Most NetLogo models call the tick command during the iteration phase. The tick command in turn calls update-plots. As documented by the NetLogo Dictionary, a model must run the reset-ticks command before it can run the tick command.

Warning

It might feel rather natural to include the reset-ticks command in a setupGlobals globals procedure, thereby treating the initialization of the tick counter like the initialization of any other global variable. In many other languages, this would be eminently sensible. However, globals (especially global constants) are typically initialized before performing any other model setup. Perhaps surprisingly, the reset-ticks command affects the NetLogo GUI. (In particular, it calls setup-plots and update-plots; see the NetLogo documentation for details.) So instead, models typically place reset-ticks near the end of the model setup. For any plot whose code is contained in a GUI plot interface, reset-ticks sets up and updates the plot. (Other plots require explicit setup and updating.) Typically, plots should be intialized after the rest of the setup is complete. For example, this allows for a visual display of the intitial state of the model.
Command Procedures: First Steps

In NetLogo, a command procedure is named subroutine that does not return a value. A command procedure produces side effects; that is its whole point. Letting angle brackets represent needed substitutions, the simplest syntax of a command procedure is the following.

to <procedure-name>
  <procedure-body>
end

That is, use the NetLogo keywords to and end, introduce a name for your command procedure, and place some commands code in the procedure body. In other languages, the equivalent of a NetLogo command procedure is often simply called a procedure. Because the purpose of a command procedure is to change things rather than to compute a value, we usually name a command procedure with a verb.

Hint

Indenting the procedure body is not required. NetLogo even allows putting the whole definition on a single line if you wish. However, it is good practice to use indentation to improve readability. Like reporter procedures, command procedures must be created in the Code tab, and they must come after any declarations such as patches-own.

Use a reporter procedure to compute a needed value. Create a command procedure when you need to do anything else. [7] For example, a print command exists for its side effect—it prints output to the Command Center. Correspondingly, a reporter procedure should never include a print statement. Use a command procedure instead.
[7]

Code entered at NetLogo’s command line may be thought of as being wrapped in a command procedure before being executed.

Make sure your NetLogo model declares a global variable named x and defines a growth01 reporter procedure, as before. In the Interface tab, right click on your plot widget, and pick Edit from the menu. Change the pen update command for the default pen to plot x. Then add the following command procedures to the Code tab.

to setup
  clear-all
  set x 100
  reset-ticks
end

to go
  set x (growth01 x)
  tick
end

Recall that the reset-ticks command calls setup-plots and update-plots. Recall that the tick command calls update-plots to plot a new point.

At the command line, run your setup procedure, and then run your go procedure

times. Explain what happens.

Note

Because reset-ticks calls update-plots, we do not need to add a pen setup command of plot x.
Basic Concept: Patches

After mastering this section, a student will be able to do the following.

    Explain what patches are and describe their built-in attributes.

    Explain what patch coordinates are and describe how they relate to the NetLogo world.

    Explain how to get attribute values for any patch.

    Explain set the value of mutable attributes for any patch.

    Explain how to add user-defined attributes to patches.

    Explain the basic structure of a command procedure.

    Explain the similarities and differences between command procedures and reporter procedures.

    Distinguish observer context, patch context, and turtle context.

Recall that NetLogo automatically creates a collection of patches at start up. Patches come with some builtin data attributes and behaviors. This section provides some additional information about these patches and describes some of their built-in attributes. Some of the data attributes are mutable (i.e., can be changed). It is possible to add user-defined mutable attributes to patches.
NetLogo Patches: Data Attributes

A patch has a color and a location. There is only one patch at each location. The location has unique integer coordinates, which both identify the patch and designate the center of the patch. In the View of a NetLogo model, patches display as colored squares laid out in a rectangle. By default, the View is
patches across and patches high (for a total of

patches).

Two separate attributes determine the location of a patch: the pxcor and pycor. The pxcor is the horizontal position (x-coordinate) of the patch. The pycor is the vertical position (y-coordinate) of the patch. These location attributes are immutable (i.e., it is not possible to change them).

Patches are stationary agents; they cannot move. The coordinates of a patch serve to uniquely identify the patch, since they are unique and never change. By default, the center patch is at the origin of the coordinate system, in which case it has coordinates

. Reference this patch as as patch 0 0.
Patch Monitor

The NetLogo Dictionary refers to default data attributes as builtin variables. Use the inspect command to see these. The inspect command opens a graphical patch monitor, which displays current attribute values. (These are dynamically updated whenever an attribute value changes.) The first two attributes listed by inspect are the patch coordinates, pxcor and pycor.

Explore these builtin patch attributes by entering inspect (patch 0 0) at NetLogo’s command line. Alternatively, right click in the view and inspect the selected patch. To close the monitor, enter stop-inspecting patch 0 0 at the command line. (Or click the monitor’s close button.)
NetLogo Patches: Attribute Access with of

Patches can report the value of their data attributes and change the values of their mutable attributes. NetLogo has a rather unique syntax for the getting and setting of attribute values. To get the value of a data attribute of an agent, use NetLogo’s of operator.

Most NetLogo primitives precede their arguments. However, a few are infix operators, and the of operator is one of these. It is an infix binary operator. It is binary because it takes two arguments, a reporter block and an agent. It is infix because it must be between its two arguments. For example, [pxcor] of (patch 0 0) reports zero. (In this expression, the brackets are required, but the parentheses are not.)

The first operand is a bracket-enclosed expression—a reporter block. The mandatory brackets contain an expression that can be evaluated by an agent. The second operand is the agent to execute the reporter block; this agent returns (reports) the value of that expression. In the context of a patch, the reporter block describes a value that a patch can calculate. The reporter block runs in patch context. In this case, of causes the patch to execute this reporter block in order to retrieve the desired value. Using angle brackets to indicate needed substitutions, represent this syntax more generally as follows.

[<reporter>] of <agent>

In the NetLogo Dictionary, read the documentation of the of operator. Then enter the following commands at NetLogo’s command line, predicting ahead of time the value printed in each case.

    print [pxcor] of (patch 0 0) print [pycor] of (patch 0 0) print [pxcor + pycor] of (patch 0 0)

Context in NetLogo

In NetLogo, the context of a command embodies the concept of who is acting (i.e., executing the commands). Most often, NetLogo programs use the ask command to set the execution context. For example, at the command line we may enter the following at the observer prompt.

ask (patch 0 0) [<do-something>]

Execution of this code begins in observer context, but the ask command changes to patch context. So this simple code actually involves multiple contexts. The observer asks the patch to execute do-something, and the patch then runs this command in patch context. In other words, the code tells the observer that we want the patch at the origin to run do-something. The ask command tells the observer the context in which we want the command block to run.

Generally, any agent can ask any other agents to run commands. For example, one patch may ask another patch to run some commands, and these commands will then run in the context of the second patch.

ask (patch 0 0) [ ask (patch 1 1) [<do-something>]]

Hint

The observer has a few special abilities. For example, only the observer can give commands to all patches as a group, as in ask patches [<do-something>].
Accessing Own Attributes

Any agent can access the attributes of a patch with the of operator. In addition, any agent can directly access its own attributes without using the of operator. NetLogo code can ask an agent to do things with its attributes, like print them or change them. The ask command must come before its two arguments. Using angle brackets to indicate where substitutions are needed, represent the syntax for ask as follows.

ask <agent> [<do-something>]

As illustrated, the two arguments are an agent and a command block for that agent to execute. Recall that a command block is a bracketed collection of commands. For example, the following code asks the patch at the origin to print its color.

ask (patch 0 0) [print pcolor]

The use of parentheses in this line of code is not required; it is just for ease of reading. In contrast, the use of brackets in this line of code is required. Brackets must delimit a command block to be executed by an agent.
NetLogo: Colors Are Numbers

NetLogo represents represents colors as numbers. Assuming the patch at the origin is black, the value of the expression [pcolor] of (patch 0 0) is 0. Some colors also have names, including red, orange, yellow, green, blue, and violet. Unsurprisingly, black and white are also named colors. In NetLogo black is just an alias for the number
. Similarly, in NetLogo red is just an alias for the number

. (The NetLogo Programming Guide provides detailed documentation.)
NetLogo Patches: Attribute Setting

An agent can change its own mutable attributes. Another agent can use the ask command to change the value of an agent’s mutable attribute. For example, at the command line, change the pcolor attribute of patch 0 0 as follows.

ask (patch 0 0) [set pcolor red]

Once again, notice that NetLogo does not use the equal sign (=) to do assignment. Instead, it uses the set command. Running this code should case the center patch to turn red in color in the model’s View,

In the NetLogo Programming Guide, read the documentation for the NetLogo color model. In the NetLogo Dictionary, read the documentation of the ask command. Then enter the following commands at NetLogo’s command line, after predicting the result of each line.

ask (patch 0 0) [print pcolor]
ask (patch 0 0) [set pcolor red]
ask (patch 0 0) [print pcolor]
print (red = 15)                 ;equality comparison

User-Defined Attributes

Suppose a patch should represent a gambler. Conceptually, a gambler has a wealth attribute. So if a patch represents a gambler, then the patch should have a wealth attribute. Although the NetLogo language provides its builtin agent types with many useful attributes, there is naturally no builtin wealth attribute. However, the :patches-own keyword can add user-defined attributes to patches. Use the following example adds a wealth attribute.

patches-own [wealth]

The patches-own keyword cannot be used at NetLogo’s command line. Instead, enter it in the Code tab, above any procedure definitions. This endows every patch with a wealth attribute. Access and change a user-defined attribute in the same way as builtin attributes.

Newly created attributes receive a default value of 0. So the patches-own [wealth] declaration not only declares that each patch has a wealth attribute but also initializes its value to 0 (for every patch). Usually the setup phase of a NetLogo simulation sets user-defined attributes to more useful values.

In the NetLogo Dictionary, read the documentation for the patches-own keyword. After declaring a wealth attribute for patches, enter the following code at NetLogo’s command line, after predicting the results.

print [wealth] of (patch 0 0)
ask (patch 0 0) [set wealth 100]
print [wealth] of (patch 0 0)

Random Changes in Wealth

Behavior has consequences, but often the consequences are not completely predictable. Instead, there is some randomness in the outcome. This uncertainty is an important aspect of the real world, and it is an aspect that agent-based modeling readily accommodates. For example, a gambler should experience random changes in wealth. These changes can happen each time the gambler gambles. A gambler gambles, which produces random changes in wealth. Therefore a simulation of a gambler must simulate random outcomes.

Make sure the Code tab declares a wealth attribute for patches. Represent one gamble by a gambler by randomly augmenting or decrementing the wealth of the patch.

Here is one approach. Enter the following code at NetLogo’s command line. (The two printed values will differ by

.)

print [wealth] of (patch 0 0)
ask (patch 0 0) [set wealth (wealth + one-of [-1 1])]
print [wealth] of (patch 0 0)

Next, simulate 50 gambles by this gambler, printing out the initial and final wealth. (If needed, review the earlier discussion of the repeat command.) Finally, change this simulation so that it plots the evolution of the gambler’s wealth over time.
Command Procedures for User-Defined Behavior

To embody such agent behavior, a NetLogo program typically introduces command procedures. Unlike reporter procedures, a command procedure does not return a value. The role of a command procedure is to produce side effects, not to return a value.

In contrast with object-oriented languages, a NetLogo program does not explicitly declare that agents of a certain type own a certain behavior. Instead, NetLogo programmers implement command procedures that only agents of a certain type can sensibly execute. NetLogo then infers that it is a behavior of agents of this type. The type of agent is the context for the procedure, and asking another type of agent to run the procedure produces an error.

This is a very natural approach to associating behavior with agents. For example, consider patches with a wealth attribute. In NetLogo, if patches have a wealth attribute, then no other agent type can have this attribute. Therefore, whenever a procedure directly refers to wealth, NetLogo infers that only patches can run that procedure. Such a procedure is called a patch procedure; it runs in patch context. We may ask any patch to run a patch procedure.
User-Defined Behaviors: Gambling

Conceptually, a gambling agent has a betting behavior. Continue to assume that a single bet increases or decreases wealth by

, with equal probability. A single bet produces one of two possible changes in wealth: an increment of 1, or a decrement of 1. We may implement this behavior as a nullary bet procedure.

A procedure without parameters is nullary. The parameter brackets for a nullary procedure are empty and may even be omitted. The input to a nullary procedure never changes, since there is no input argument. Nevertheless, by introducing randomness, each call to bet may produce a different outcome than before.

Check that you have declared that patches have a wealth attribute, as described above. In the Code tab, below all variable declarations, add a patch procedure named bet. This should implement the betting behavior described above. Test your code at NetLogo’s command line by entering the following code. (The two printed values should differ by

).

print [wealth] of patch 0 0
ask (patch 0 0) [bet]
print [wealth] of patch 0 0

bet

Here is one possible approach to this exercise.

Hint

Recall that a semicolon begins a NetLogo comment, which lasts until the end of the line. As an aid to readers of the code, NetLogo procedures conventionally include a comment providing the procedure context, as in the example code above.
A Patch-Based Gambling Simulation

Patches now have a wealth attribute and a bet behavior. This provides a simple representation of a gambler. Despite its simplicity, this is adequate for a bare-bones gambling simulation.

Combine what you have learned about patches with what you have learned about plots. Make sure that you have included a plot widget in the Interface tab. Perform and visualize the a simple gambling simulation by entering the following commands at NetLogo’s command line.

clear-all
ask (patch 0 0) [set wealth 100  plot wealth]
repeat 50 [ask (patch 0 0) [bet  plot wealth]]

For extra flair, explain how move the plotting code into the plot widget.
Basic Concept: Turtles

After reading this section you will be able to

    Explain what turtles are and describe some of their built-in attributes.

    Explain what turtles coordinates are and describe how they relate to patch coordinates.

    Create turtles at various locations.

    Get and set attributes for any turtle.

    Explain how to add user-defined attributes to turtles.

This section provides some additional information about NetLogo turtles and describes some of their built-in attributes. This section demonstrates ways to create and destroy turtles. It shows how to get and set attributes for any turtle, including the turtle’s coordinates. It explains how to add user-defined attributes to turtles.
Creating and Destroying Turtles

Launching a model automatically creates patches for the NetLogo world, but turtles must be explicitly created. For example, create-turtles 1 creates
turtle. Turtles are sequentially numbered in the order of creation, and the first turtle created is given the number

. After creating the first turtle, the command ask (turtle 0) [die] destroys it. The clear-turtles command destroys all existing turtles, and since clear-all runs clear-turtles, it will do so as well.
Turtle Coordinates

Like patches, turtles are spatially located agents. The create-turtles command creates turtles at the origin. A turtle’s location in the NetLogo world is given by its xcor and ycor attributes. Turtles can be anywhere in the world, not just at the center of a patch. [8] In contrast to patches, more than one turtle may be at the same location. This implies that a turtle is not uniquely identified by its coordinates.
[8]

Turtle coordinates are floating-point values, where:

min-pxcor - 0.5 <= xcor < max-pxcor + 0.5
min-pycor - 0.5 <= ycor < max-pycor + 0.5

A turtle-creation command may be immediately followed by a command block, which each created turtle will execute. The following example illustrates this by creating two turtles, each of which immediately sets its color to red.

clear-all
create-turtles 2 [set color red]

Hint

Turtles always display on top of patches. When displayed graphically, turtles are painted in the order created, so when turtles overlap the one created last will appear on top.
More Turtle Creation

Only the observer can run the create-turtles command. However, patches and turtles can create turtles by means of the sprout and hatch commands. For example, ask patches [sprout 1] asks each patch to create one turtle at that patch’s location. Similarly, ask turtles [hatch 1] asks each turtle to create one turtle at its location.

Hint

The attributes of a hatched turtle match those of its parent. This includes the color and heading of the parent.
Turtles Are Mobile

Turtles are mobile agents; they can move around in the NetLogo world. Correspondingly, xcor and ycor are mutable attributes. Turtles can change location (i.e., move across the terrain of patches). The most basic turtle motion command is setxy, which consumes two numbers that specify the new coordinates of the turtle.

ask turtle 0 [setxy 1 0]  ;; move turtle 0 to (1,0)

The move-to command instead takes another agent as its argument. This provides a convenient way to move a turtle to a specific patch or even another turtle.

ask turtle 0 [move-to (patch 0 0)]
ask turtle 1 [move-to (turtle 0)]

At the NetLogo command line, use create-turtles to create two turtles, each of which immediately moves to a random patch.
Relative Motion

NetLogo turtles are designed to support relative motion—motion in a particular direction for stated distance. The direction is given by the turtle’s heading attribute, which is measured in clockwise degrees from north. (So
points up,

points right, and so forth.) Distance is measure in patch lengths. The jump command causes the turtle to move by a specified distance in the direction of its heading.

ask turtle 0 [set heading 0]  ; face north
ask turtle 0 [jump 1]         ; move one patch length north
ask turtle 0 [jump -1]        ; move one patch length south

There are additional ways to change a turtle’s heading, including facexy (to face a point) and face (to face an agent). There are additional commands for turtle motion, including forward (for incremental forward motion) and back (for incremental backward motion). All are fully documented in the NetLogo Dictionary.

Ensure that the context for NetLogo’s command line is set to observer. Then enter the following commands.

clear-all
;create 20 turtles, which immediately move
create-turtles 20 [jump 5]
ask turtles [facexy 0 0] ;ask turtles to face the origin
ask turtles [jump 1]     ;ask turtles to approach the origin

Turtle Attributes

Turtles have a number of pre-defined attributes, which are documented in the NetLogo Dictionary. At NetLogo’s command line, use the inspect command to open a graphical turtle monitor. (If needed, discover the turtle’s identity with a right mouse click on the turtle.)

inspect turtle 0

A turtle monitor displays the current attribute values of a turtle. (These dynamically update as the turtle changes.) To close the turtle monitor, enter stop-inspecting turtle 0 at the command line. (Or click the monitor’s close button.)

Each turtle has a single immutable attribute: its who number, which is a unique integer identifier. The who numbers start at 0 increment as each turtle is created. It is possible to use the who number to determine which turtles receive a command. For example, ask turtle 0 [print color] causes the first turtle created to print its color.
Attribute Access

Like patches, turtles can report the value of their data attributes. And as with patches, we may use the of operator to access attributes.

print [who] of turtle 0
ask turtle 0 [print who]
print [color] of turtle 0
ask turtle 0 [print color]

Attribute Setting with ask

Any agent can set new values on its own mutable attributes. However, another agent cannot directly change an attribute of a turtle. Instead, as with patches, another agent can ask a turtle to change an attribute value. For example, change the color attribute of turtle 0 as follows.

ask turtle 0 [set color red]

The shape of the turtle is also a mutable attribute. Enter the shapes command at NetLogo’s command line to see a list of the builtin shapes. (More shapes are possible, including custom shapes.) Set the shape attribute like any other attribute. For example, ask turtles [set shape "airplane"] causes each existing turtle to switch to NetLogo’s airplane shape.
User-Defined Attributes

Add new turtle attributes (in Code tab) with turtles-own. The turtles-own keyword can only be used in the Code tab, above any procedure definitions. It cannot be used at NetLogo’s command line. As an example, give turtles an income attribute as follows.

turtles-own [income]

Attribute Access: A Turtle’s Patch

A turtle knows its patch. It can report its patch with the patch-here primitive. But the intimate relationship between turtles and patches goes much deeper.

In agent-based modeling, the agent that owns an attribute typically reports or changes its value. NetLogo makes a very interesting exception to this: a turtle can directly access the attributes of the patch that it is on. For example, in order to print first coordinate of the location of a turtle’s patch we might expect to write print [pxcor] of [patch-here] of turtle 0 or ask [patch-here] of turtle 0 [print pxcor] or perhaps ask turtle 0 [print [pxcor] of patch-here]. However, NetLogo offers a simpler syntax.

ask (turtle 0) [print patch-here]
ask turtle 0 [print pxcor]

Turtles Can Set Patch Attributes

More surprising yet, a turtle can directly change the mutable attributes of its patch. For example, recall that pcolor is a patch attribute and not a turtle attribute. Nevertheless, the following code will set the color of the patch below turtle 0.

ask turtle 0 [set pcolor green]  ;sets *patch* color

Turtle Context

Recall that to the left of NetLogo’s command line is a popup menu for selecting the context for executing the commands. The observer context is the default. In observer context, we give commands to all turtles as ask turtles [<commands>]. By switching to turtles context, it becomes possible to just enter the commands.

In the Command Center, set the context to observer. Then enter the following commands.

clear-all         ;; start from scratch
create-turtles 10 ;; create 10 turtles

Next, set the context to turtles. Then enter the following commands. Predict the outcome before entering each command.

jump 5           ;move forward 5 units
facexy 0 0       ;face origin
pen-down         ;pen-down
jump 2           ;move forward 2
pen-up           ;pen-up
set pcolor white ;change *patch* color to white

Core Concept: Agentsets

    unordered collections of agents

    traverse (in random order) with ask

An agentset is a collection of agents, all of the same type. NetLogo code often manipulates agentsets rather than individual agents. As discussed above, patches and turtles are two commonly used agentsets.

Like a mathematical set, an agentset has no notion of order or multiplicity. Corresponding, agentsets inherently support randomization, which is very common ingredient of agent-based modeling. For example, the ask command can pass a command block to each agent in an agentset, in random order. This order is randomized on each use of ask.

ask <agentset> [<commands>]

Enumerated Subsets

The patch-set, turtle-set, and link-set primitives can create enumerated subsets of agents. For example, (patch-set patch 0 0 patch 0 1) creates an agentset of two patches. As with mathematical sets, including a member twice in an enumeration does not change the agentset.

print (patch-set patch 0 0 patch 0 1)  ;; two members
print (patch-set patch 0 0 patch 0 0)  ;; one member

Occasionally, it is useful to have an empty agentset or to know whether an agentset is empty. An empty patch set can easily be created as (patch-set ); for this usage, the parentheses are required. However, as an aid to readability, NetLogo provides the no-patches and no-turtles. Before any turtles are created, turtles is equal to no-turtles. The any? primitive reports whether an agentset has any members. Before any turtles are created, any? turtles evaluates to false. Asking an empty agentset to execute a command block is not an error, but the command block never runs.

Write a pure function named isEmpty that returns true when applied to an empty agentset and false when applied to an agentset that is not empty. For this exercise, use the count primitive.

Rewrite your isEmpty function so that it uses the any? primitive.

Rewrite your isEmpty function so that it uses the one-of primitive.

Hint: in the NetLogo Dictionary, review the documentation for each primitive before attempting to use it.
Criterion-Based Subsets via with

It is very common to create a new agentset from an existing agentset by extracting a subset based on some criterion. The with command can filter any agentset based on a boolean criterion. The result is a subset of the original agentset, which contains only the agents satisfying the criterion. For example (patches with [pxcor < 0]) is an agentset that contains all the patches to the left of the origin. So, the following code turns green all the patches to the left of the origin. (As usual, the parentheses are not required, but the brackets are required.)

ask (patches with [pxcor < 0]) [set pcolor green]

This code applies the ask command to an agentset and a command block, which is by now a familiar syntax. The new concept is that the agentset is a subset of patches rather than all of them. The infix with operator creates this agentset based on its two operands: an agentset (patches), and a boolean reporter block that the agents can execute. (A boolean reporter block always evaluates to either true or false.) The resulting subset contains the patches that report true.
Random Subsets via n-of

The one-of and n-of reporter primitives make random choice very simple. The one-of primitive can produce a random member of an agentset. To instead produce a randomly chosen agentset, use the n-of primitive. This takes two arguments—a number and an agentset—and constructs a random subset of an agentset. Selection is without replacement, so an error results from requesting a subset bigger than the original set. The number of agents in the subset cannot be negative, but it may be

.

print (n-of 5 patches) ;agentset of 5 random patches
print (n-of 0 turtles) ;empty agentset

While parentheses can render NetLogo code more readable, they are seldom required. With experience, they are even seldom required for readability. However, consider the expression n-of 5 patches with [pcolor = black]. Will this be
of the black patches, which could be written n-of 5 (patches with [pcolor = black])? Or will it be the black patches out of a random

patches, which could be written (n-of 5 patches) with [pcolor = black]? The answer is the former, because the with operator has very high priority. In such cases, parentheses may help even experienced NetLogo users understand what you have written.
Neighborhoods

Since patches are stationary, each has a fixed set of adjacent patches. NetLogo provides the neighbors primitive to report the agentset of
surrounding patches and the neighbors4 primitive to report the agentset of

abutting patches. These behave like attributes of a patch, so they can be accessed with of. Recall that a turtle can directly access attributes of its patch, so it can directly produce the neighbors of its patch.

print [neighbors] of (patch 0 0)
print [neighbors4] of (patch 0 0)
print [neighbors] of (turtle 0)

Explore neighborhoods visually with the Neighborhoods Example in the NetLogo Models Library.
Agentsets Excluding a Patch or Turtle

other <agentset>

    the agentset, without the executing agent
<agentset> in-radius <number>

    agents in the agentset that are near enough
turtles-here

    turtles on the same patch

NetLogo provides a variety of other domain-specific primitives for producing agentsets. Fairly commonly used are other, turtles-here, and in-radius. An agent runs other <agentset> to produce all of the agentset except the executing agent. A patch runs turtles-here to produce an agentset, possibly empty, of the turtles on the patch. An agent runs <agentset> in-radius <number> to produce the members of the agentset that are close enough. This always includes the agent itself, if it is in the agentset.

Enter the following code at NetLogo’s command line. (Enter command blocks entirely on a single line.) Predict the results of each command before entering it.

clear-all ask patch 0 0 [

    ask patches in-radius 1.5 [set pcolor blue]

] ask patch 0 0 [

    ask other patches in-radius 1.5 [set pcolor red]

] create-turtles 24 [jump 5] print [other turtles-here] of turtle 0 print [turtles in-radius 5] of turtle 0
Optimal Agentsets

max-one-of <agentset> [<reporter>]

    report an agent that the reporter assigns a maximum value http://ccl.northwestern.edu/netlogo/docs/dictionary.html#max-one-of
min-one-of <agentset> [<reporter>]

    report an agent that the reporter assigns a minimum value http://ccl.northwestern.edu/netlogo/docs/dictionary.html#min-one-of

Agent-based models often need to choose a best agent from an agentset. Here, best means either biggest or smallest, according to some criterion. The max-one-of and min-one-of primitives often simplify with this task. Each takes an agentset and a reporter block and reports a single agent that is best.

print max-one-of patches [pxcor]
print min-one-of patches [pxcor]

Ties are randomly resolved. Applying these reporters to an empty agentset is not an error, but then nobody is reported instead of an agent. To ensure an error this situation, use max-n-of or min-n-of instead.
Lists From Agentsets

The second operand of the of operator can be an agentset, in which case the result is a list. For example, [pxcor] of patches is a list of numbers, which are the first coordinates of the patches (in random order). Similarly, [color] of patches is a list of numbers, which are the colors of the turtles. (Remember that NetLogo represents colors as numbers.)
Lists of Agentsets

Additionally, lists can contain agents. As an example, (list patch 0 0) creates a list with one item, which is the patch at the origin. As another example, applying the sort command to an agentset produces a list of agents, in ascending order. Turtles are ordered by who number. Patches are ordered from the top-left patch to the bottom-right patch.
self

An agent can refer to itself with the self reporter. However, it is usually redundant to do so. For example, ask patch 0 0 [print [pcolor] of self] is just a verbose way to ask patch 0 0 [print pcolor]. An except arises in the conversion of an agenset to a list. Even though NetLogo code typically works with agentsets rather than with lists of agents, this conversion is occasionally useful. For example, the follow code reports a list of all the patches, in random order.

[self] of patches

Core Concept: BehaviorSpace

BehaviorSpace is a NetLogo tool for easily implementing parameter sweeps. In this section, you will learn how to do the following.

    Distinguish between declared global variables and interface global variables.

    Run BehaviorSpace experiments.

This section very briefly introduces BehaviorSpace, which is NetLogo’s main facility for simulation experiments. BehaviorSpace is core part of the NetLogo toolkit. It simplifies experimentation with any NetLogo model, making it easy to systematically explore a model’s parameter space.

Hint

For more details see NetLogo’s BehaviorSpace Guide.
Interface Globals

Recall that a NetLogo model may use the globals keyword to declare global variables in its Code tab. An alternative way to introduce global variables is by means of a GUI widget, such as a slider. In the Interface tab, the Add button supports the creation of a new slider, switch, chooser, or input box. Associated with each of these widgets is a new global variable. This course refers to these as interface globals.

Interface globals are automatically declared when the widgets are created. They must not additionally be declared with a globals command in the Code tab. NetLogo models typically introduce interface globals for key model parameters, thereby facilitating experimentation with these parameters.

Hint

For more details see NetLogo’s Interface Tab Guide.

Warning

Filling in the Value field of a slider widget sets the value of the variable, but this value changes whenever the slider is moved. Most importantly, the current slider value is saved whenever the model is saved; it is not a fixed default value. To ensure that the variable always begins at a known value, launching the model must set the slider value. NetLogo provides for this by means of a specially named startup procedure.

You already should have declared the global variable x in the Code tab. Now, add a chooser to the Interface tab as follows. Right click where you want a chooser, and pick Chooser from the resulting dialog, let the name of the global variable be y, enter 0 and 1 as the values, and click OK. Set the chooser value to 0 and enter the following code at NetLogo’s command line.

clear-all
print x
ask patches [set x (x + y)]
print x

Explain the printed results. The change the chooser value to 1 and enter the same code. Explain the change in results.
Parameter Sweep

A parameter sweep explores the parameter space via systematic variation of the parameterization.

enumerated sweep:

    specify specific values (e.g., as a list) for a parameter.
range sweep:

    specify values for a parameter as a range (e.g., by providing start and stop values, along with an increment)

The outcomes of a simulation depends on the model parameters, whose values remain constant while a single simulation runs. Researchers correspondingly explore the behavior of a simulation model by running multiple simulations, each of which may have differing values of the model parameters. A choice of values for all of the model parameters is a parameterization of the model. A simulation experiment systematically explores how changes in the parameterization lead to changes in the simulation outcomes.

Often an experiment changes only a small number of parameters, known as the focal parameters. In the simplest case, there is a single focal parameter that takes on only two or three values.

The collection of all possible parameter configurations is the parameter space. Parameter sweeps are a common approach to exploring interesting parts of this parameter space. A sweep specification identifies a systematic variation of the model parameterization. An enumerated sweep of a parameter explicitly enumerates a set of values for that parameter. A range sweep of a parameter identifies a range of values for the parameter.
Creating an Experiment

A single experiment may combine enumerated and range sweeps of various parameters. BehaviorSpace supports such experiments. To create an experimental design in BehaviorSpace, first find BehaviorSpace under Tools tab of the NetLogo GUI. Then click the New button to open the Experiment dialog. Give the experiment a name, and fill in the dialog to specify the experimental design.

A core component of a simulation experiment is the specification of the parameter sweep. Specify an enumerated sweep by entering multiple values for any of the model parameters. Entering ["myparam" 0 1 2 3] serves as an illustrative example of the syntax for an enumerated sweep, as long as the NetLogo model includes myparam as a global variable. Alternatively, these same values may be specified as a start-increment-end range, which uses the slightly different syntax ["myparam" [0 1 3]]. Click the OK button when you are done.

Closing BehaviorSpace does not delete the experiment. After creating an experiment, saving the NetLogo model will save the experiment. NetLogo stores the experimental design inside the model file under its given name. Each time NetLogo loads the model, the experiment remains available.
Experiment Components

After specifying a parameter sweep in BehaviorSpace, enter the remaining components of the experiment. These include the model setup and step, and the number of replicates, the reporters for output data, and whether to generate output at every data-generation step or only when the simulation finishes. After filling in the BehaviorSpace dialog, clicking the OK button saves the experiment.

Repetitions

    The number of replicates for each scenario (i.e., for each parameterization in the sweep).
Reporters

    One reporter for each desired output from the simulations. (Put a single reporter on each line of the text box.)
Setup commands:

    In this textbox, specify the command or commands that set up the simulations.
Go commands:

    In this textbox, specify the command or commands that run one data-generation step of the model.
Stop condition:

    A reporter procedure that reports true when the run should stop.

A deterministic model only needs a single repetitions, since for any given parameterization, each run will produce exactly the same results. However, each run of a stochastic simulation may produce a different result. Repetitions are therefore important for stochastic models, where the distribution of outcomes is more informative than any single outcome. A value of 100 is a common first choice of the number of repetitions when a simulation model is stochatic. A setup procedure typically handles the setup. (See the discussion of seeding, below.) The stop condition ensures that the simulation does not run forever, but it can be empty if you set the desired number of steps as a Time Limit.

In NetLogo models, a go or step procedure typically handles the entire simulation step. Correspondingly, the Go commands textbox often contains only go. However, since the reporters for this experiment are called after each data-generation step, this may generate more data than desired. Fortunately, a data-generation step may involve multiple simulation steps. For example, the Go commands textbox may contain an entry like repeat 10 [go].
Running an Experiment

To run a saved experiment, open BehaviorSpace, select the experiment, and click the Run button. This produces a Run options dialog, presenting a small number of options. Usually Update view and Update plots and monitors should both be unchecked, since the experiment then runs much more quickly. The choice of output format is a bit more involved.
BehaviorSpace Output Formats

BehaviorSpace offers two different output formats for writing the experimental results to a file: Spreadsheet output or Table output. These both produce CSV files. The spreadsheet format is not written until the experiment runs to completion, so the data must fit in memory. However, this format strives to be more “human readable” by sorting the output by run before writing it to a file. The table format writes data to a file as the data is generated, which means that the data do not consume much memory. For this reason, use the table format for experiments generating large datasets. However, this leaves any sorting of the data to the user, including grouping together all output from a single run.

Hint

Include the .csv filename extension when you enter a filename; NetLogo does not add it for you.
BehaviorSpace Cautions

Proper use of BehaviorSpace requires attention to a few details. Most importantly, BehaviorSpace sets the values of global variables before executing its setup and go commands. So if your setup commands set the value of these variables, the BehaviorSpace values will not control your simulation. For example, the model setup phase typically calls clear-all, which resets to 0 all variables declared with globals. This will override any values set by BehaviorSpace.

However, clear-all does not affect interface globals. For example, it does not reset sliders or choosers. By design, this allows BehaviorSpace to work just fine with interface globals. Effectively, to work well with BehaviorSpace, a model must include all focal parameters in the Interface tab. This underlies the basic rule for BehaviorSpace experiments: use interface globals for all of the model’s focal parameters.
Replicates and Replicability

Most agent-based simulations include some randomness. A simulation replicate is an additional simulation run with an identical parameterization. This matters only when a model includes stochastic components. Outcomes across replicates differ solely due to the random components of the model.
Random Seed

Evidently, the need for randomness in a simulation model is in tension with the fundamental scientific goal of replicability. Simulation research deals with this by controlling the way that the randomness enters the model. To ensure exact replicability of a BehaviorSpace experiment, each simulation run must begin by specifying a random seed for the PRNG. Conditional on the value of this random seed, the behavior of the model is fully deterministic. This is possible because, hidden deep in the background, the apparently stochastic behaviors in a NetLogo model are actually controlled by a clever deterministic algorithm. (See the discussion of PRNGs in the Glossary for details.)
Generating Unique Seeds

Often a NetLogo model’s setup procedure sets a random seed. An alternative location is the Setup commands in the BehaviorSpace experiment. In either case, it is important to reset the value of random-seed before each run (not just once per experiment).

In order to allow variability across scenarios and replicates, each replicate should have its own unique seed. Fortunately, for each run in an experiment, NetLogo stores a unique identifier in behaviorspace-run-number. This makes it simple to produce a unique seed for the PRNG. During the model setup, before any randomness, set the value of the seed. Use any one-to-one function of behaviorspace-run-number. As a simple yet effective example, just use the command random-seed behaviorspace-run-number.

Again, seed setting may be part of the model setup or may be placed in the Setup commands of the BehaviorSpace dialogue. A disadvantage of the latter is that the seed must be set in every experiment, not just once in the model setup. However, there appears to be a disadvantage to setting the seed in the model setup as well. If the Code tab’s setup procedure includes random-seed behaviorspace-run-number, then then rerunning a scenario from the interface will not produce any variation in outcomes. This can be an undesirable constraint on interactive exploration of the model’s behavior. One possible solution is to include the following code in the setup procedure.

let _bsrn behaviorspace-run-number
random-seed ifelse-value (0 = _bsrn) [new-seed] [_bsrn]

This works because behaviorspace-run-number is zero when no BehaviorSpace experiment is running. NetLogo’s new-seed primitive effectively reports a randomly chosen seed. So this approach allows variation across interactive runs: NetLogo produces a new seed for each interactive run of the simulation from the Interface. In addition, this approach fully supports the replicability of BehaviorSpace experiments.
Summary and Conclusions

NetLogo is a powerful and flexible language and toolkit for agent-based modeling and simulation. It provides data types, arithmetic operators, and programming constructs associated with general purpose languages. However, it is a domain-specific language that is designed for agent-based modeling and simulation. Accordingly, it additionally provides useful agent types and specialized primitives for querying and manipulating agents.
Further Explorations

    After declaring the variable x at the top of the Code tab, enter the following at the Command Center.

    clear-all
    print x
    ask patches [set x (x + 1)]
    print x

    In this exercise, since x is a global variable, the print x command need not be on the same line as the set command.

    At NetLogo’s command line, in observer context, enter the following commands.

    clear-all
    print "test"

    Next, use the popup menu to change to patches context, and again enter print "test". (You may have to wait a moment.) Next, use the popup menu to change to turtles context, and again enter print "test". Explain why the output changes each time.

self and myself

Recall that self names current askee (e.g., an agent that is “ask”-ed).

In contrast, myself names current asker (e.g., if an agent asks another).

ask patch 0 0 [
  ask neighbors [set pcolor [pcolor] of myself]
]

Exercise: what is the result of the following command? Explain in detail.

ask patches [set pcolor black]
ask patches [
  ask neighbors4 with [pcolor = [pcolor] of myself] [
    set pcolor red
  ]
]

The NetLogo primitives self and myself. can be confusing to beginners. Whereas myself refers to the asker, self refers to the askee.

Two examples should help make this clear. Here is the example for myself from the manual:

ask turtles [
  ask patches in-radius 3 [
    set pcolor [color] of myself
  ]
]

In this case each turtle asks nearby patches to change to its color: myself refers to the asker (i.e., the turtle). Now suppose we tried to change myself to self in this example. This would not even run, because self refers to the askee (i.e., the patch), and a patch does not have a color attribute. (It has a pcolor attribute. Here is another example, which turns all turtles the color of turtle 1.

ask turtle 1 [
  ask other turtles [
    set color [color] of myself
  ]
]

Note that if we were to change myself to self, no turtle would change color, because each would just reset its own color to its original color. We use myself because we want the color of the asker, not the color of the askee.

One last question about this concerns scope: myself refers to the asker in the current code block---the proximate asker, if you like. So the following will set all the color of all turtles to the color of turtle 2.

ask turtle 1 [
  ask turtle 2 [
    ask other turtles [
      set color [color] of myself
    ]
  ]
]

Brief NetLogo History

NetLogo has its roots in Logo, a programming language that is a member of Lisp family. Logo was invented in the late 1960s by a group of scientists led by mathematician, computer scientist and educator Seymour Papert. In 1966, a team at Bolt, Beranek and Newman designed Logo as a language for learning. (Team members included Wally Feurzeig, Seymour Papert, and Cynthia Solomon.)

Logo was designed for learning. It was intended to be usable by school children. The Logo motto was “no threshold, no ceiling” [Harvey-1993-Self]. Due to its ease of use, NetLogo still finds wide application in teaching. Due to its “no ceiling” philosophy, NetLogo also finds wide application in agent-based research.

As part of its core design, Logo supported substantial graphical capabilities. It provided an on-screen drawing object: the turtle. Early Logo users moved turtles around on the screen with Logo commands. Mobile NetLogo agents are called turtles for this historical reason. In 1969, Seymour Papert developed a computer-controlled, physical “turtle”, which looked a bit like a modern GoPiGo Robot. Physical turtles were rather expensive at the time. Nowadays, it is possible to use NetLogo to control a physical turtle with an inexpensive GoGo Board.
http://cyberneticzoo.com/wp-content/uploads/22-turtle2-x640.jpg

Papert’s Turtle

Source: http://cyberneticzoo.com/wp-content/uploads/22-turtle2-x640.jpg

Mitchel Resnick’s StarLogo added multiple agents and patches to Logo. These features are present in NetLogo, which was designed by Uri Wilensky and Seth Tisue (of the Center for Connected Learning and Computer-Based Modeling at Northwestern University). NetLogo adds a broader understanding of agents (e.g,, patches and links) along with natural groupings of agents (called agentsets). It is a free download and (since version 5) is free and open source software.

There are a variety of other Logo implementations available, but development has stopped on most of them. One exception is StarLogo Nova, which allows web-based programming of three-dimensional games. For another currently active Logo derivative, see the LibreLogo drawing language in LibreOffice. Nevertheless, outside of strictly educational settings, by far the most widely used member of the Logo family is NetLogo.

For more background on NetLogo, see [Wilensky.Resnick-1999-JSET] and [Tisue.Wilensky-2004-WP]. The Center for Connected Learning provides a comparison of NetLogo to other Logos. You can also find more Logo history at the Logo Foundation, on Reuben Hoggett’s Cybernetic Zoo webpage, and on Cynthia Solomon’s Logo Things webpage.
Additional Resources

The core NetLogo resource is the NetLogo User Manual. This includes tutorials, reference guides, and the NetLogo Dictionary. The NetLogo Dictionary provides an alphabetical list of NetLogo primitives. A NetLogo installation provides a local copy of the Dictionary.

The type of agent that runs a command or reporter provides the “context” of that command or reporter. If NetLogo restricts the type of agent that can run the primitive, an icon showing the allowable context appears in the Dictionary. The Dictionary also groups primitives by agent type.

The NetLogo Interface Guide provides a full description of the Interface tab. It includes a discussio of the world settings: size and topology (wrapping vs. reflecting). It also documents menu items and the addition of control widgets. The Netlogo Programming Guide provides useful programming guidance.

NetLogo ships with the NetLogo Models Library, an extensive collection of pedagogical models. The Library’s Code Examples are generally useful. For the present course, the Model Library’s Social Science models are particularly useful.
References

Harvey, Brian. (1993) Symbolic Programming vs. Software Engineering -- Fun vs. Professionalism -- Are These the Same Question?. http://www.eecs.berkeley.edu/~bh/elogo.html

Tisue, Seth, and Uri Wilensky. (2004) "NetLogo: A Simple Environment for Modeling Complexity". Center for Connected Learning and Computer-Based Modeling . http://ccl.northwestern.edu/papers/netlogo-iccs2004.pdf

Wilensky, Uri. (2017) NetLogo 6.01 User Manual.

Wilensky, Uri, and Mitchel Resnick. (1999) Thinking in Levels: A Dynamic Systems Approach to Making Sense of the World. Journal of Science Education and Technology 8, 3--19. https://link.springer.com/article/10.1023/A:1009421303064

Copyright © 2016–2023 Alan G. Isaac. All rights reserved.

version:

    2023-07-14

