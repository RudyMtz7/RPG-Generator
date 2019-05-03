%Rodolfo Martínez Guevara

:- dynamic at/2, currently/1.   /* Needed by SWI-Prolog. */
:- retractall(at(_, _)), retractall(currently(_)).

%Read files
write_on_file(File, Text):-
  open(File, write, Stream),
  write(Stream, Text), nl,
  close(Stream).

read_from_file(File):-
  open(File, read, Stream),
  get_char(Stream, Char1),
  process_the_stream(Char1, Stream),
  close(Stream).

process_the_stream(end_of_file, _):- !.

process_the_stream(Char, Stream):-
  write(Char),
  get_char(Stream, Char2),
  process_the_stream(Char2, Stream).

%Forces the start at the parking lot. I mean, you arrived in car.

currently(parking).


%Routing and mapping

path(atm, down, parking).

path(parking, left, library).
path(parking, right, cafe).
path(cafe, left, parking).
path(library, left, exam_room).
path(library, up, study_hall).
path(library, right, parking).
path(study_hall, down, library).
path(parking, up, atm).

path(parking, down, back_parking):- at(money, in_hand).

path(parking, down, back_parking):-
  read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room3Deny.txt'), nl,
  !, fail.

path(back_parking, up, parking).
path(back_parking, left, cage).


%Defines the items and their locations

at(money, atm).
at(exam_answers, back_parking).
at(book, study_hall).


%Functions to pick up items

take(X):-
  at(X, in_hand),
  write('You''re already holding it!'),
  nl, !.

take(X):-
  currently(Place),
  at(X, Place),
  retract(at(X, Place)),
  assert(at(X, in_hand)),
  write('You take the '), write(X), write('.'),
  nl, !.

take(_):-
  write('There is no such item in here.'),
  nl.


%Shortcuts to moving functions

up:-
  move(up).

down:-
  move(down).

right:-
  move(right).

left:-
  move(left).

%Functions to move in the given direction

move(Direction):-
  currently(Here),
  path(Here, Direction, There),
  retract(currently(Here)),
  assert(currently(There)),
  getDescription, !.

move(_):-
  write('You can''t go that way.').


%Gives description of the current area
getDescription:-
        currently(Place),
        describe(Place),
        nl,
        objectDescription(Place),
        nl.


%Describe object in current room.
objectDescription(Place):-
        at(X, Place),
        write('You can take item: '), write(X), nl,
        fail.

objectDescription(_).



%Greate movie, 10/10 should watch.
endGame:-
  write('The game is over.'),
  nl, !.



%Read game instructions.
instructions:-
  write('Instructions: '), nl,
  write('(Enter text as shown. Replace "Object"'),
  write('with the item you wish to interact with)'), nl,
  write('start.                   -- to start the game.'), nl,
  write('up. right. down. left.   -- to go in that direction.'), nl,
  write('take(Object).            -- to pick up an object.'), nl,
  write('getDescription.          -- to see the description again.'), nl,
  write('instructions.            -- to see this message again.'), nl.


%Reads required information to start a new game.
start:-
  welcomeInstructions,
  instructions,
  getDescription.

%Explains the game when started.
welcomeInstructions:-
  read_from_file('/Users/RudyMartinez/Desktop/Project/welcomeInstructions.txt'), nl.


%Describes each room and it possible actions
describe(parking):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room0.txt'), nl.

describe(atm):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room1.txt'), nl.

describe(cafe):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room2.txt'), nl.

describe(back_parking):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room3.txt'), nl.

describe(library):-
        at(book, in_hand),
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room4b.txt'), nl.

describe(library):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room4a.txt'), nl.

describe(study_hall):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room5.txt'), nl.

describe(exam_room):-
        at(exam_answers, in_hand),
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room6c.txt'), nl,
        endGame, !.

describe(exam_room):-
        at(book, in_hand),
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room6b.txt'), nl,
        endGame, !.

describe(exam_room):-
        read_from_file('/Users/RudyMartinez/Desktop/Project/Rooms/room6a.txt'), nl,
        endGame, !.
