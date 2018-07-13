%Derek Zhang
%Mr Rosen
%May 15, 2017
%Clone of the TV show, "Who Wants to be a Millionaire", remastered for Turing 4.1!

/*
 QUICK SUMMARY
 **TURN VOLUME LOWER BEFORE YOU RUN**
 -Game takes a bit of time to load (3-5 seconds depending on computer) since there are some high def
 pictures and the music file is relatively large.
 -3D array storing 3 questions for each of the 15 levels. Each question has 5 values (q,a1,a2,a3,a4)

 -Questions and which button holds the right answer is completely randomized! You may sometimes have a
 string of questions where A is always the right answer but it is only a coincidence!

 -Friends and Crowd have a chance of providing correct answer, that decreases as questions get harder
 */

import GUI
var win : int := Window.Open ("position:0;400,graphics:740;500,offscreenonly,noecho,nocursor")

%loading screen (done before declaration of images so turing can load them)
locatexy (350, 250)
drawfillbox (0, 0, maxx, maxy, black)
Text.ColourBack (black)
Text.Colour (white)
put "Loading..." %Put text on the screen while turing loads in all the music and sounds

%Picture Initializing
var music : string := "intro.mp3"
var menuPic := Pic.FileNew ("menuPic.jpg")
var menuPicEmpty := Pic.FileNew ("menuPicEmpty.jpg")
var logo := Pic.FileNew ("logo.jpg")
var gameWinPic := Pic.FileNew ("gameWin.jpg")
var gameLosePic := Pic.FileNew ("gameLose.jpg")
var background := Pic.FileNew ("background.jpg")
var moneyBar := Pic.FileNew ("moneyBar.jpg")
var instructionsPic := Pic.FileNew ("instructions.jpg")
var backDrop := Pic.FileNew ("backDrop.jpg")
var friendIcon := Pic.FileNew ("friendIcon.jpg")
var friendIconUsed := Pic.FileNew ("friendIconUsed.jpg")
var fiftyIcon := Pic.FileNew ("fiftyIcon.jpg")
var fiftyIconUsed := Pic.FileNew ("fiftyIconUsed.jpg")
var crowdIcon := Pic.FileNew ("crowdIcon.jpg")
var crowdIconUsed := Pic.FileNew ("crowdIconUsed.jpg")
var walkAwayIcon := Pic.FileNew ("walkAwayIcon.jpg")

%Font Initializing
var arial16 := Font.New ("arial:16")
var impact60 := Font.New ("impact:45")

%Global Varibles
var mx, my, mb : int := 0 %mouse variables
var rA, rB, rC, rD : string := "" %text for responses A,B,C,D in display
var rCorrect : string % the correct answer which is used in display
var level : int := 0
var prizeMoney : array 1 .. 15 of int := init (100, 200, 300, 500, 1000, 2000, 4000, 8000, 16000, 32000, 64000, 125000, 250000, 500000, 1000000)

%3D array that store all the questions. Index 2 is always the right answer. Will be randomized later with another procedure
%Three Questions for each level, 15 levels, 5 values per questions (q,a1,a2,a3,a4)
var questions : array 1 .. 15, 1 .. 3, 1 .. 5 of string :=
    init (
    "Which expression evaluates to 15?", "(2+3)x3", "2+3x2", "3+(3x2)", "(2x3)+2",
    "Which statement is true for the order of operations?", "x before +", "+ before x", "- before ()", "x before \^2",
    "What is the result of (1+1)x(2+3)-5+2-10+3", "0", "4", "23", "15",

    "Which one of these gems are most commonly blue?", "Sapphire", "Amethyst", "Ruby", "Emerald",
    "Which is mineral is the hardest?", "Diamond", "Graphite", "Granite", "Titanium",
    "What is the mineral used in pencils?", "Graphite", "Lead", "Charcoal", "Slate",

    "Which continent does Mexico belong to?", "North America", "Central America", "South America", "U.S.A.",
    "Which continent is the farthest from the equator?", "Antarctica", "Asia", "North America", "South America",
    "Which continent has the least countries?", "North America", "South America", "Asia", "Europe",

    "Which one of these is not a brass instrument?", "Saxophone", "Tuba", "French Horn", "Euphonium",
    "Which stringed instrument does not use a bow to play?", "Guitar", "Fiddle", "Double Bass", "Viola",
    "Which is not a percussion intrument?", "Euphonium", "Piano", "Bongos", "Snare Drum",

    "Which is the fictional home of Batman?", "Gotham City", "Star City", "Smallville", "Central City",
    "Which is the fictional childhood home of Superman?", "Smallville", "Star City", "Gotham City", "Central City",
    "Who is the secret identity of Spiderman?", "Peter Parker", "Bruce Wayne", "Clark Kent", "Parker Peter",

    "What are human finger nails made of?", "Keratin", "Biotin", "Osseus Tissue", "Fat",
    "How many bones are there in the human body?", "206", "183", "68", "234",
    "Which word is not related to the brain?", "Anthro", "Cognitive", "Neuro", "Cerebral",

    "What is does the T in NATO stand for?", "Treaty", "Trade", "Territory", "Tariff",
    "What does the first A in NASA stand for?", "Aeronautics", "Astronomy", "Argonomics", "Association",
    "Clothing frachise , H&M, stands for:", "Hiennes and Mauritz", "Henry & Mako", "Harrison & Maurice", "Hats & Mittens",

    "Who was the the first prime minister of Canada?", "John A. Macdonald", "Pierre Elliot Trudeau", "Sir Wilfred Laurier", "W.L. Mackenzie King",
    "Who was the only female prime minister of Canada?", "Kim Campbell", "Karen Luther", "Kathleen Wynne", "Angela Merkel",
    "Who is not a former Canadian prime minister?", "Henry Campbell", "Sir Charles Tupper", "Paul Martin", "Joe Clark",

    "\"An eye for an eye makes the whole world blind.\" -", "Mahatma Gandhi", "Alexander the Great", "Nelson Mandela", "Abraham Lincoln",
    "\"Let them eat cake!\" -", "Marie Antoinette", "Fat Albert", "Antonia Fraser", "Louis XIV",
    "\"Creativity is contagious, pass it on\" - ", "Albert Einstein", "Issac Newton", "Thomas Edison", "Steven Hawkings",

    "The root word \"auto\", means:", "self", "automatic", "car", "star",
    "What is the root word of \"legislature\"", "legis", "legi", "slature", "legislate",
    "The prefix \"ig\" as in \"ignorant\" means:", "not", "always", "undo", "stupid",

    "Spell:", "Penicillin", "Pennisilin", "Penecilin", "Pennecilin",
    "Which is spelled incorrectly?", "ecstacy", "weird", "embarrass", "cemetery",
    "Which is spelled correctly?", "broccoli", "wierd", "eigth", "assasination",

    "Which hormone is secreted by the adrenal glands?", "Dopamine", "Endorphins", "Protesterone", "Bacteria",
    "Which hormone is responsible for hunger?", "Ghrelin", "Bacteria", "Peptide", "Estrogen",
    "Which hormone is responsible for sleepiness?", "Melatonin", "Endorphins", "Hepcidin", "Insulin",

    "What is the highest grossing anime movie of all time?", "Your Name", "Howl's Moving Castle", "Minions", "Spirited Away",
    "What is the japanese name for the anime movie \"Your Name\"?", "Kimi No Na Wa", "Kimi no Uso", "Koe no Katachi", "Konichiwa",
    "Which is the translation for \"Good Morning\" in Japanese?", "Oyato", "Ohayo", "Konichiwa", "Suminasen",

    "Who does not have a chemical element named after them?", "Isaac Newton", "Albert Einstein", "Niels Bohr", "Enrico Fermi",
    "Which element has the highest average atomic mass?", "Calcium", "Nitrogen", "Potassium", "Carbon",
    "Which is not an abbreviation for a chemical element?", "Cn", "Cs", "Cr", "Ce",

    "What is the 4th letter of alphabet?", "h", "a", "b", "d",
    "What was Elvis Presley's middle name?", "Aaron", "Arthur", "Leroy", "Lewis",
    "The motto of Canada, \"A Mari usque ad Mare\", means:", "From sea to sea", "From coast to coast", "In God we trust", "Bless the Queen"
    )

var dice : int %dice for randomization of things
var questionSet : int % Used to determine which question out of the 3 to pick

%Lifeline used or not
var callFriendUsed : boolean := false
var fiftyFiftyUsed : boolean := false
var askCrowdUsed : boolean := false

%Declaring dimensions for each button in display
var A : array 1 .. 4 of int := init (100, 120, 250, 40)
var B : array 1 .. 4 of int := init (400, 120, 250, 40)
var C : array 1 .. 4 of int := init (100, 50, 250, 40)
var D : array 1 .. 4 of int := init (400, 50, 250, 40)

var fiftyCover1, fiftyCover2 : array 1 .. 4 of int := init (-100, -100, 0, 0) %covers for fifty ability (x,y,w,h)

%Bug/Glitch Traps
var winClose : boolean := false %debugging for intruction window
var currentWindow : int %Solve window problems
var finished : boolean := false %used to stop menu from appearing once quit is pressed
var exitLoop : boolean := false %used to debug window closing problems in general

forward proc menu %Forwards the menu procedure to be called anywhere

process playMusic
    %Plays the music
    Music.PlayFile (music)
end playMusic

fork playMusic %plays music in background

%MOUSEWARE BUTTONS
function collision (btn : array 1 .. 4 of int) : boolean
    /*
     Passes an array with x,y,w,h of a box
     Computes whether the mouse has clicked within the box
     */
    if mx >= btn (1) and mx <= btn (1) + btn (3) and my >= btn (2) and my <= btn (2) + btn (4) then
	result true
    else
	result false
    end if
end collision

%MOUSEWARE BUTTONS
proc drawButton (btn : array 1 .. 4 of int, text, align : string, clr, clr2 : int)
    /*
     Passes an array with x,y,w,h of a box
     Draws the box and centers the given text
     - Font.Width to find width of text
     - startx + (boxwidth/2 - Font.Width/2)
     If mouse hovers over, button colour will change to clr2
     */

    var btnColour := clr

    if collision (btn) then
	%if mouse is hovering, turn colour to secondary colour (cl2)
	btnColour := clr2
    else
	%Else, revert to primary colour (clr)
	btnColour := clr
    end if

    %Display buttons
    drawfillbox (btn (1), btn (2), btn (1) + btn (3), btn (2) + btn (4), btnColour)
    drawbox (btn (1), btn (2), btn (1) + btn (3), btn (2) + btn (4), black)

    % alignment using Font.Width
    if align = "middle" then
	Font.Draw (text, btn (1) + (btn (3) div 2 - Font.Width (text, arial16) div 2), btn (2) + 15, arial16, black)
    elsif align = "left" then
	Font.Draw (text, btn (1) + 15, btn (2) + 15, arial16, black)
    end if
end drawButton

proc title
    locate (1, 1)
    colorback (black)
    color (white)
    put "Who Wants to be a Millionaire V1.0"
end title

proc intro
    %Mouseware declaration
    var menuButton : array 1 .. 4 of int := init (318, 50, 100, 45)

    for x : -250 .. 120 % Animation for the logo
	Pic.Draw (menuPicEmpty, 0, 0, picMerge)
	Pic.Draw (logo, 170, x, picMerge)
	title
	View.Update
    end for

    Pic.Draw (menuPic, 0, 0, picCopy)
    title
    View.Update % Update the background before the button

    delay (300) %Slight delay before button shows up

    loop
	%Checks for mouse clicks on the button
	title
	mousewhere (mx, my, mb)
	if mb = 1 then
	    if collision (menuButton) then
		menu
		exit
	    end if
	end if

	%Render the button
	drawButton (menuButton, "MENU", "middle", 54, 53)
	delay (17)
	View.Update
    end loop

end intro

procedure closeWin % Used to close instructions when button is clicked
    Window.Close (currentWindow)
    winClose := true
end closeWin

proc instructions
    setscreen ("position:760;400,graphics:500;500,offscreenonly")
    Pic.Draw (instructionsPic, 0, 0, picCopy)
    var backButton := GUI.CreatePictureButton (15, 450, Pic.FileNew ("backButton.jpg"), menu)

    loop
	exit when GUI.ProcessEvent or winClose = true % closes window properly
	View.Update
    end loop
end instructions

proc gameLose
    setscreen ("graphics:740;400")
    Pic.Draw (gameLosePic, 0, 0, picCopy)
    Font.Draw ("$" + intstr (prizeMoney (level)), maxx div 2 - Font.Width ("$" + intstr (prizeMoney (level)), impact60) div 2, 180, impact60, white)
    View.Update
    loop
	exit when hasch %wait for a key to be pressed
    end loop
end gameLose

proc walkAway
    setscreen ("graphics:740;400")
    Pic.Draw (backDrop, 0, 0, picCopy)
    %borders
    drawfillbox (0, 165, maxx, 265, black)
    drawbox (5, 170, maxx - 5, 260, white)
    drawfillbox (0, 20, maxx, 45, black)
    %Centres the text using maxx and Font.Width
    Font.Draw (("You walked away with"), maxx div 2 - Font.Width ("You walked away with ", arial16) div 2, 240, arial16, white)
    Font.Draw ("$" + intstr (prizeMoney (level - 1)), maxx div 2 - Font.Width ("$" + intstr (prizeMoney (level)), impact60) div 2, 180, impact60, white)
    Font.Draw ("Press any key to continue", maxx div 2 - Font.Width ("Press any key to continue", arial16) div 2, 25, arial16, white)
    View.Update
    loop
	exit when hasch %wait for a key to be pressed
    end loop
end walkAway

proc gameWin
    setscreen ("graphics:740;400")
    Pic.Draw (gameWinPic, 0, 0, picCopy)

    loop
	exit when hasch %wait for a key to be pressed
    end loop
end gameWin

proc goodbye
    setscreen ("graphics:740;400")
    Pic.Draw (backDrop, 0, 0, picCopy)

    %borders
    drawfillbox (0, 165, maxx, 240, black)
    drawbox (5, 170, maxx - 5, 235, white)
    drawfillbox (0, 20, maxx, 45, black)

    %Centres text using maxx and Font.Width
    Font.Draw ("THANK YOU FOR PLAYING", maxx div 2 - Font.Width ("THANK YOU FOR PLAYING", impact60) div 2, 180, impact60, white)
    Font.Draw ("Created by Overlord Derek Zhang", maxx div 2 - Font.Width ("Created by Overlord Derek Zhang", arial16) div 2, 25, arial16, white)

    View.Update

    delay (3000) %Wait three seconds
    Music.PlayFileStop
    exitLoop := true %exit the main loop and close the program
    GUI.Quit %Exits GUI
end goodbye

proc callFriend
    var dice100 : int % randomized number
    randint (dice100, 1, 100)
    var chance : int
    %Scaling chance of giving right answer
    if level <= 10 then %Q1-Q10, Chance = 100 - level^2. (i.e. 99,96,91...19)
	chance := 100 - level ** 2
    else %Q10-Q15, Chance = 19 - level. (i.e. 9,8,7,6,5)
	chance := 20 - level ** 2
    end if

    if dice100 <= chance then % if chance is rolled
	/*
	 If A or C (left side), place small icon on the left of them
	 If B or D (right side), place small icon on the right of them
	 */
	if rA = rCorrect then
	    Pic.Draw (friendIcon, A (1) - 55, A (2) - 5, picCopy)
	elsif rB = rCorrect then
	    Pic.Draw (friendIcon, B (1) + B (3) + 5, B (2) - 5, picCopy)
	elsif rC = rCorrect then
	    Pic.Draw (friendIcon, C (1) - 55, C (2) - 5, picCopy)
	elsif rD = rCorrect then
	    Pic.Draw (friendIcon, D (1) + D (3) + 5, D (2) - 5, picCopy)
	end if
    else
	% Otherwise, place it on a wrong one
	if rA = rCorrect then
	    Pic.Draw (friendIcon, B (1) + B (3) + 5, B (2) - 5, picCopy)
	elsif rB = rCorrect then
	    Pic.Draw (friendIcon, D (1) + D (3) + 5, D (2) - 5, picCopy)
	elsif rC = rCorrect then
	    Pic.Draw (friendIcon, A (1) - 55, A (2) - 5, picCopy)
	elsif rD = rCorrect then
	    Pic.Draw (friendIcon, C (1) - 55, C (2) - 5, picCopy)
	end if
    end if

    callFriendUsed := true

end callFriend

proc askCrowd
    var dice100_2 : int
    randint (dice100_2, 1, 100)
    var chance : int
    %Scaling chance of giving right answer
    if level <= 8 then %Q1-Q10, Chance = 100 - level^2. (i.e. 99,96,91...19)
	chance := 90 - level ** 2
    else %Q9-Q15, Chance = 19 - level. (i.e. 9,8,7,6,5)
	chance := 25
    end if

    if dice100_2 <= chance then % if chance is rolled
	/*
	 If A or C (left side), place small icon on the left of them
	 If B or D (right side), place small icon on the right of them
	 */
	if rA = rCorrect then
	    Pic.Draw (crowdIcon, A (1) - 55, A (2) - 5, picCopy)
	elsif rB = rCorrect then
	    Pic.Draw (crowdIcon, B (1) + B (3) + 5, B (2) - 5, picCopy)
	elsif rC = rCorrect then
	    Pic.Draw (crowdIcon, C (1) - 55, C (2) - 5, picCopy)
	elsif rD = rCorrect then
	    Pic.Draw (crowdIcon, D (1) + D (3) + 5, D (2) - 5, picCopy)
	end if
    else
	% Otherwise, place it on a wrong one
	if rA = rCorrect then
	    Pic.Draw (crowdIcon, C (1) - 55, C (2) - 5, picCopy)
	elsif rB = rCorrect then
	    Pic.Draw (crowdIcon, A (1) - 55, A (2) - 5, picCopy)
	elsif rC = rCorrect then
	    Pic.Draw (crowdIcon, D (1) + D (3) + 5, D (2) - 5, picCopy)
	elsif rD = rCorrect then
	    Pic.Draw (crowdIcon, B (1) + B (3) + 5, B (2) - 5, picCopy)
	end if
    end if

    askCrowdUsed := true

end askCrowd

proc fiftyFifty
    var dice3 : int
    randint (dice3, 1, 3)
    var fiftyCover1temp : array 1 .. 4 of int
    var fiftyCover2temp : array 1 .. 4 of int
    if rCorrect = rA then %If A is the correct button
	%randomize which other button not to darken
	if dice3 = 1 then
	    fiftyCover1temp := B
	    fiftyCover2temp := C
	elsif dice3 = 2 then
	    fiftyCover1temp := D
	    fiftyCover2temp := C
	elsif dice3 = 3 then
	    fiftyCover1temp := B
	    fiftyCover2temp := D
	end if
    elsif rCorrect = rB then %If B is the correct button
	%randomize which other button not to darken
	if dice3 = 1 then
	    fiftyCover1temp := A
	    fiftyCover2temp := C
	elsif dice3 = 2 then
	    fiftyCover1temp := D
	    fiftyCover2temp := C
	elsif dice3 = 3 then
	    fiftyCover1temp := A
	    fiftyCover2temp := D
	end if
    elsif rCorrect = rC then %If C is the correct button
	%randomize which other button not to darken
	if dice3 = 1 then
	    fiftyCover1temp := A
	    fiftyCover2temp := B
	elsif dice3 = 2 then
	    fiftyCover1temp := D
	    fiftyCover2temp := B
	elsif dice3 = 3 then
	    fiftyCover1temp := A
	    fiftyCover2temp := D
	end if
    elsif rCorrect = rD then %If C is the correct button
	%randomize which other button not to darken
	if dice3 = 1 then
	    fiftyCover1temp := A
	    fiftyCover2temp := B
	elsif dice3 = 2 then
	    fiftyCover1temp := C
	    fiftyCover2temp := B
	elsif dice3 = 3 then
	    fiftyCover1temp := A
	    fiftyCover2temp := C
	end if
    end if

    for x : 1 .. 4
	fiftyCover1 (x) := fiftyCover1temp (x)
	fiftyCover2 (x) := fiftyCover2temp (x)
    end for

    fiftyFiftyUsed := true
end fiftyFifty

proc drawButtons
    %Draws all the buttons for display
    drawButton (A, ("A  " + rA), "left", 54, 53)
    drawButton (B, ("B  " + rB), "left", 54, 53)
    drawButton (C, ("C  " + rC), "left", 54, 53)
    drawButton (D, ("D  " + rD), "left", 54, 53)
end drawButtons

proc display
    setscreen ("graphics:940,500")
    Pic.Draw (background, 0, 0, picCopy)
    Pic.Draw (moneyBar, 740, -1, picCopy)

    var mCooldown := 10 %mouse buffer to prevent mouse holds

    var friendButton : array 1 .. 4 of int := init (680, 440, 50, 50)
    var fiftyButton : array 1 .. 4 of int := init (620, 440, 50, 50)
    var crowdButton : array 1 .. 4 of int := init (560, 440, 50, 50)
    var walkAwayButton : array 1 .. 4 of int := init (10, 440, 50, 50)

    var x : int := 0

    randint (dice, 1, 4)
    randint (questionSet, 1, 3)
    loop

	rCorrect := questions (level, questionSet, 2)

	% Randomization
	if dice = 1 then
	    rA := questions (level, questionSet, 2)
	    rB := questions (level, questionSet, 3)
	    rC := questions (level, questionSet, 4)
	    rD := questions (level, questionSet, 5)
	elsif dice = 2 then
	    rA := questions (level, questionSet, 3)
	    rB := questions (level, questionSet, 2)
	    rC := questions (level, questionSet, 5)
	    rD := questions (level, questionSet, 4)
	elsif dice = 3 then
	    rA := questions (level, questionSet, 5)
	    rB := questions (level, questionSet, 2)
	    rC := questions (level, questionSet, 4)
	    rD := questions (level, questionSet, 3)
	elsif dice = 4 then
	    rA := questions (level, questionSet, 4)
	    rB := questions (level, questionSet, 5)
	    rC := questions (level, questionSet, 2)
	    rD := questions (level, questionSet, 3)
	end if

	drawButtons

	%Checks for cooldown on mouse, so that clicks don't register as multiple clicks
	if mCooldown = 10 then
	    mousewhere (mx, my, mb)
	elsif mCooldown > 10 then
	    mCooldown := 10
	else
	    mCooldown += 1
	end if

	%Draw questions and answers
	drawfillbox (100, 180, 650, 240, white)
	Font.Draw (questions (level, questionSet, 1), 100 + (550 div 2 - Font.Width (questions (level, questionSet, 1), arial16) div 2), 202, arial16, black)

	%Draws call friend button
	drawbox (679, 439, 731, 490, white)
	if not callFriendUsed then
	    Pic.Draw (friendIcon, 680, 440, picCopy)
	else
	    Pic.Draw (friendIconUsed, 680, 440, picCopy)
	end if

	%Draws fifty fifty button
	drawbox (619, 439, 670, 490, white)
	if not fiftyFiftyUsed then
	    Pic.Draw (fiftyIcon, 620, 440, picCopy)
	else
	    Pic.Draw (fiftyIconUsed, 620, 440, picCopy)
	end if

	%Fifty Fifty Covers
	drawfillbox (fiftyCover1 (1), fiftyCover1 (2), fiftyCover1 (1) + fiftyCover1 (3), fiftyCover1 (2) + fiftyCover1 (4), black)
	drawfillbox (fiftyCover2 (1), fiftyCover2 (2), fiftyCover2 (1) + fiftyCover2 (3), fiftyCover2 (2) + fiftyCover2 (4), black)

	%Draws Ask Crowd button
	drawbox (559, 439, 610, 490, white)
	if not askCrowdUsed then
	    Pic.Draw (crowdIcon, 560, 440, picCopy)
	else
	    Pic.Draw (crowdIconUsed, 560, 440, picCopy)
	end if

	%Draws Walk Away button
	drawbox (9, 439, 61, 491, white)
	Pic.Draw (walkAwayIcon, 10, 440, picCopy)

	%Checks for mouse clicks
	if mb = 1 then
	    if collision (A) then
		if rA = rCorrect then
		    level += 1
		    x := 0 % resets timer
		    randint (dice, 1, 4) %randomize questions
		    randint (questionSet, 1, 3)
		else
		    gameLose
		    exit
		end if
		Pic.Draw (background, 0, 0, picCopy)
		%Reset fifty covers
		for i : 1 .. 4
		    fiftyCover1 (i) := -100
		    fiftyCover2 (i) := -100
		end for
		drawButtons
	    elsif collision (B) then
		if rB = rCorrect then
		    level += 1
		    x := 0 % resets timer
		    randint (dice, 1, 4) %randomize questions
		    randint (questionSet, 1, 3)
		else
		    gameLose
		    exit
		end if
		Pic.Draw (background, 0, 0, picCopy)
		%Reset fifty covers
		for i : 1 .. 4
		    fiftyCover1 (i) := -100
		    fiftyCover2 (i) := -100
		end for
		drawButtons
	    elsif collision (C) then
		if rC = rCorrect then
		    level += 1
		    x := 0 % resets timer
		    randint (dice, 1, 4) %randomize questions
		    randint (questionSet, 1, 3)
		else
		    gameLose
		    exit
		end if
		Pic.Draw (background, 0, 0, picCopy)
		%Reset fifty covers
		for i : 1 .. 4
		    fiftyCover1 (i) := -100
		    fiftyCover2 (i) := -100
		end for
		drawButtons
	    elsif collision (D) then
		if rD = rCorrect then
		    level += 1
		    x := 0 % resets timer
		    randint (dice, 1, 4) %randomize questions
		    randint (questionSet, 1, 3)
		else
		    gameLose
		    exit
		end if
		Pic.Draw (background, 0, 0, picCopy)
		%Reset fifty covers
		for i : 1 .. 4
		    fiftyCover1 (i) := -100
		    fiftyCover2 (i) := -100
		end for
		drawButtons


		%Checking if mouse clicks the life line buttons
	    elsif collision (friendButton) then
		if not callFriendUsed then
		    callFriend
		end if
	    elsif collision (fiftyButton) then
		if not fiftyFiftyUsed then
		    fiftyFifty
		end if
	    elsif collision (crowdButton) then
		if not askCrowdUsed then
		    askCrowd
		end if
	    elsif collision (walkAwayButton) then
		if level = 1 then
		    exit
		else
		    walkAway
		    exit
		end if
	    end if

	    %Prevents mouse holds
	    mb := 0
	    mCooldown := 0

	end if

	%Timer
	x += 1
	drawfilloval (370, 350, 81, 81, white)
	drawoval (370, 350, 80, 80, black)
	drawfillarc (370, 350, 80, 80, 90, 89 - x div 10, blue)
	drawoval (370, 350, 71, 71, black)
	drawfilloval (370, 350, 70, 70, white)

	%Timer Font
	if 60 - x div 60 >= 10 then %If it is a two digit #, draw normally
	    Font.Draw (intstr (60 - x div 60), 340, 325, impact60, black)
	else % single digit numbers must be adjusted to stay centered
	    Font.Draw (intstr (60 - x div 60), 355, 325, impact60, black)
	end if

	%Money Level Indicator
	Pic.Draw (moneyBar, 740, -1, picCopy)
	drawbox (750, (level - 1) * 31 + 15, 930, (level - 1) * 31 + 50, white)

	%Check if the player has run out of time
	if 60 - x div 60 = 0 then
	    gameLose
	    exit
	end if

	%Win Condition
	if level > 15 then
	    gameWin
	    exit
	end if

	delay (17)

	View.Update
    end loop
end display

body proc menu

    loop
	exit when GUI.ProcessEvent or exitLoop

	setscreen ("graphics:740;500")

	Pic.Draw (menuPic, 0, 0, picCopy) %Draws background for the menu

	title

	%reset
	level := 1
	callFriendUsed := false
	askCrowdUsed := false
	fiftyFiftyUsed := false
	for i : 1 .. 4
	    fiftyCover1 (i) := -100
	    fiftyCover2 (i) := -100
	end for


	%Button Declaration
	var playButton := GUI.CreateButtonFull (250, 120, 240, "PLAY", display, 40, '^w', false)
	var howButton := GUI.CreateButtonFull (250, 70, 240, "HOW TO PLAY", instructions, 40, '^q', false)
	var quitButton := GUI.CreateButtonFull (250, 20, 240, "QUIT", goodbye, 40, KEY_ESC, false)
	View.Update
    end loop
end menu

%Main Program
intro
loop
    exit when GUI.ProcessEvent
end loop
Window.Close (win)
%End of Program
