%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Programmer  : Jacob, Jenny
% Teacher     : Mr. Chow
% Course      : ICS3U1
%
% Program Name: Flappy Bird
% Description : 
% Flappy Bird is a previously existing mobile game that we have decided to recreate. 
% When the player opens our game, they will see a loading screen with the option to 
% interact with the instructions or play the game. The objective of this game is to 
% gain as many points as possible. To earn points in our version of Flappy Bird, the 
% player must keep the bird airborne for as long as possible. To keep the bird airborne, 
% it must go through the pipes by jumping. As the points accumulate, the speed of the 
% moving pipes will increase. When a player hits a pipe, the ground, or the highest 
% point of the loading screen, the game will halt. At this point, the player will have 
% the choice to revisit the menu or play again.

% DISCLAIMER: MR CHOW!! Because... Turing. The Bird has a white space around it. 

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%% HEADS UP DISPLAY (HUD) %%%%%%%%%%
setscreen ("graphics:400;400,nocursor")

%%%%%%%%%% VARIABLES & CONSTANTS %%%%%%%%%%

% Fonts
var font1 := Font.New ("calibri:15")
var font2 := Font.New ("sans serif:30:bold")
var font3 := Font.New ("tahoma:60:Bold")
var font4 := Font.New ("tahoma:90:bold")
var font5 := Font.New ("sans serif:15:bold")
var font6 := Font.New ("calibri:45:bold")
var font7 := Font.New ("calibri:100:bold")
var font8 := Font.New ("calibri:65:bold")
var font9 := Font.New ("sans serif:15:bold")
var font10 := Font.New ("Agency FB:50:bold")
var font11 := Font.New ("sans serif:20:bold")

% Pipe Coordinates 
var pipe_set1 : array 1 .. 4 of int
var pipe_set2 : array 1 .. 4 of int
var pipeCoordinates : array 1 .. 2 of array 1 .. 4 of int %Stored Coordinates of the pipes

% (1)(1) = First Pipe Set: Bottom Pipe, bottom left X-coordinate
% (1)(2) = First Pipe Set: Bottom Pipe, bottom Y-Coordinate
% (1)(3) = First Pipe Set: Top pipe, bottom left X-coordinate
% (1)(4) = First Pipe Set: Top Pipe, Top Y - Coordinate
% (2)(1) = Second Pipe Set: ^ Exactly the same as above

pipe_set1 (1) := 400
pipe_set1 (2) := 0
pipe_set1 (3) := 400
pipe_set1 (4) := 400

pipe_set2 (1) := 700
pipe_set2 (2) := 0
pipe_set2 (3) := 700
pipe_set2 (4) := 400

pipeCoordinates (1) := pipe_set1 %Initialize array into 2-D array
pipeCoordinates (2) := pipe_set2

% Pipe Variables
var pipe_speed, pipe_height1, pipe_height2 : int
pipe_speed := 7
pipe_height1 := Rand.Int (20, 220)
pipe_height2 := Rand.Int (20, 220)

% Flags - To stop fork statements later.
var draw_true : boolean := true
var jump_true : boolean := true

% Player variables
var velocity : real := 0
var ycoord : int := 200
var xcoord : int := 100

% Images
var background := Pic.FileNew ("background.jpg")
var bird := Pic.FileNew ("Bird.jpg")
var deadBird := Pic.FileNew ("deadBird.jpg") 

% Miscellaneous
var points : real := 0
var highscore : string
var highscore_message : string
var previousHighscore : int := 0
var input : string (1)
var x, y, button : int


%%%%%%%%%% FUNCTIONS & PROCEDURES %%%%%%%%%%

% Hitbox, Checks if user hits pipe
function hitbox (x, y, pipe_x, pipe_y, height : int) : boolean
    if x < pipe_x and x + 50 > pipe_x or x < pipe_x + 50 and x + 50 > pipe_x + 50 then
	if y > pipe_y and y < pipe_y + height or y + 34 < pipe_y and y + 34 > height + 130 then
	    result true
	end if
    end if
    result false
end hitbox

% Procedure for Menu
procedure menu
    Draw.FillBox (0, 0, maxx, maxy, 122)
    
    % Starting game animation 
    Font.Draw ("F", 50, 310, font3, 49)
    delay (200)
    Font.Draw ("L", 100, 310, font3, 49)
    delay (200)
    Font.Draw ("A", 150, 310, font3, 49)
    delay (200)
    Font.Draw ("P", 200, 310, font3, 49)
    delay (200)
    Font.Draw ("P", 250, 310, font3, 49)
    delay (200)
    Font.Draw ("Y", 300, 310, font3, 49)
    delay (200)
    Font.Draw ("B", 46, 215, font4, 49)
    delay (200)
    Font.Draw ("I", 126, 215, font4, 49)
    delay (200)
    Font.Draw ("R", 186, 215, font4, 49)
    delay (200)
    Font.Draw ("D", 266, 215, font4, 49)
    delay (300)
    
    % This whole loop structure is to basically continuously check the coordinates
    % of the user's mouse and apply a if statement accordingly.
    loop
	Mouse.Where (x, y, button)
	if button = 1 and x > 135 and y > 120 and x < 275 and y < 170 then 
	    cls
	    exit
	elsif button = 0 and x > 135 and y > 120 and x < 275 and y < 170 then
	    Draw.Box (135, 120, 275, 170, 70)
	    Font.Draw ("PLAY", 155, 130, font2, 70)
	else
	    Draw.Box (135, 120, 275, 170, 49)
	    Font.Draw ("PLAY", 155, 130, font2, 49)
	end if
	if button = 1 and x > 25 and y > 50 and x < 375 and y < 100 then
	    cls
	    Draw.FillBox (0, 0, 400, 400, 102)
	    loop
		Font.Draw ("INSTRUCTIONS", 20, 280, font6, green)
		Font.Draw ("The goal is to get the highest possible score.", 20, 250, font1, black)
		Font.Draw ("The score is determined by time.", 20, 230, font1, black)
		Font.Draw ("Make sure your box does not hit a pipe!", 20, 210, font1, black)
		Font.Draw ("Jump by hitting space or the up arrow key", 20, 190, font1, black)
		Font.Draw ("To start, hit 'back' and 'play'", 20, 170, font1, black)
		Font.Draw ("Good luck!", 20, 150, font1, black)
		Mouse.Where (x, y, button)
		Draw.Box (10, 395, 80, 370, green)
		Font.Draw ("BACK", 18, 375, font5, green)
		if button = 1 and x > 10 and y > 370 and x < 80 and y < 395 then
		    cls
		    
		    % Redraw the homescreen, after clicking back. 
		    Draw.FillBox (0, 0, maxx, maxy, 122)
		    Font.Draw ("F", 50, 310, font3, 49)
		    Font.Draw ("L", 100, 310, font3, 49)
		    Font.Draw ("A", 150, 310, font3, 49)
		    Font.Draw ("P", 200, 310, font3, 49)
		    Font.Draw ("P", 250, 310, font3, 49)
		    Font.Draw ("Y", 300, 310, font3, 49)
		    Font.Draw ("B", 46, 215, font4, 49)
		    Font.Draw ("I", 126, 215, font4, 49)
		    Font.Draw ("R", 186, 215, font4, 49)
		    Font.Draw ("D", 266, 215, font4, 49)
		    exit
		elsif button = 0 and x > 10 and y > 370 and x < 80 and y < 395 then
		    Draw.Box (10, 395, 80, 370, 49)
		    Font.Draw ("BACK", 18, 375, font5, 49)
		end if
	    end loop
	elsif button = 0 and x > 25 and y > 50 and x < 375 and y < 100 then
	    Draw.Box (25, 50, 375, 100, 70)
	    Font.Draw ("INSTRUCTIONS", 55, 60, font2, 70)
	else
	    Draw.Box (25, 50, 375, 100, 49) 
	    Font.Draw ("INSTRUCTIONS", 55, 60, font2, 49)
	end if
    end loop
end menu

% All drawing procedures. 
process draw
    if draw_true then
	loop
	    % Draw Background
	    Pic.Draw (background, 0, 0, picMerge)

	    % Draw Pipes
	    Pic.Draw (bird, xcoord, ycoord, picMerge)
	    Draw.FillBox (pipeCoordinates (1) (1), pipeCoordinates (1) (2), pipeCoordinates (1) (1) + 50, pipeCoordinates (1) (2) + pipe_height1, green)
	    Draw.FillBox (pipeCoordinates (1) (3), pipe_height1 + 130, pipeCoordinates (1) (3) + 50, pipeCoordinates (1) (4), green)
	    Draw.FillBox (pipeCoordinates (2) (1), pipeCoordinates (2) (2), pipeCoordinates (2) (1) + 50, pipeCoordinates (2) (2) + pipe_height2, green)
	    Draw.FillBox (pipeCoordinates (2) (3), pipe_height2 + 130, pipeCoordinates (2) (3) + 50, pipeCoordinates (2) (4), green)
	    
	    Font.Draw (intstr (round (points)), 380 - length (intstr (round (points))) * 30, 350, font6, 70) % Automatically shifts the points, if it
	    delay (100)                                                                                      % reaches another digit
	    cls
	    exit when draw_true = false % helps us stop the animation from running. 
	end loop
    end if
end draw

% Checks if User has clicked Space or Up arrow to jump, also plays "flap" sound. 
process jump
    loop
	if jump_true then
	    getch (input)

	    if input = " " or input = KEY_UP_ARROW and jump_true then
		Music.PlayFileReturn ("Flap.mp3")
		velocity := 8  % reset velocity to 8 to allow the bird to jump. 
	    end if
	else
	    exit
	end if
    end loop
end jump


%%%%%%%%%% MAIN CODE %%%%%%%%%%

%Loading screen
menu

loop
    % Starting animation, gives user time to start. 
    for decreasing i : 3 .. 1
	Pic.Draw (background, 0, 0, picMerge)
	if i > 2 then
	    Font.Draw ("On your Marks...", 17, 320, font10, black)
	else
	    Font.Draw ("Get set...", 100, 320, font10, black)
	end if
	Font.Draw (intstr (i), 170, 160, font7, black)
	delay (800)
	cls
	if i = 1 then
	    Pic.Draw (background, 0, 0, picMerge)
	    Font.Draw ("GO", 110, 160, font7, black)
	    delay (800)
	end if
    end for

    fork draw
    fork jump
    
    % This loop structure is the variable updater, and 
    % also the condition checker.  
    loop
	% Gravity
	ycoord += round (velocity) % basically doing this, helps me accelerate  
	velocity -= 30/33.33       % the fall, the longer the bird is in the air.
	delay (40)
	
	% Update Pipe Coordinates
	pipeCoordinates (1) (1) -= pipe_speed
	pipeCoordinates (1) (3) -= pipe_speed
	pipeCoordinates (2) (1) -= pipe_speed
	pipeCoordinates (2) (3) -= pipe_speed

	% Will reset the pipes to initial location so that they are reused
	if pipeCoordinates (1) (1) < -50 then
	    pipeCoordinates (1) (1) := 550
	    pipeCoordinates (1) (3) := 550
	    pipe_height1 := Rand.Int (20, 220)
	end if
	if pipeCoordinates (2) (1) < -50 then
	    pipeCoordinates (2) (1) := 550
	    pipeCoordinates (2) (3) := 550
	    pipe_height2 := Rand.Int (20, 220)
	end if

	% Points, increase in speed if user reaches certain amount of points
	points += 0.1
	if points >= 50 and points < 150 then
	    pipe_speed := 8
	elsif points >= 150 and points < 250 then
	    pipe_speed := 10
	elsif points >= 250 and points < 400 then
	    pipe_speed := 13
	elsif points >= 400 then 
	    pipe_speed := 15
	end if

	% Conditions to lose the game
	if ycoord < 0 or ycoord > 360
		or hitbox (xcoord, ycoord, pipeCoordinates (1) (1), pipeCoordinates (1) (2), pipe_height1)
		or hitbox (xcoord, ycoord, pipeCoordinates (1) (3), pipeCoordinates (1) (4), pipe_height1)
		or hitbox (xcoord, ycoord, pipeCoordinates (2) (1), pipeCoordinates (2) (2), pipe_height2)
		or hitbox (xcoord, ycoord, pipeCoordinates (2) (3), pipeCoordinates (2) (4), pipe_height2) 
		then
	    Music.PlayFileReturn ("deathSound.mp3")
	    exit
	end if
    end loop

    % Sets flags to false to stop the fork
    draw_true := false
    jump_true := false

    % Just a regular accumalator to track highscore. 
    % my highscore is 314 :) 
    if round (points) > previousHighscore then
	highscore := "Your Highscore: " + intstr (round (points))
	highscore_message := "New Highscore!!"
	previousHighscore := round (points)
    else
	highscore_message := "No new highscore"
    end if

    delay (200)


    % Ending Animation, shows bird falling down,
    % whilst redrawing everything so the bird doesn't
    % erase our stuff. 
    loop
	Pic.Draw (background, 0, 0, picMerge)
	Draw.FillBox (pipeCoordinates (1) (1), pipeCoordinates (1) (2), pipeCoordinates (1) (1) + 50, pipeCoordinates (1) (2) + pipe_height1, green)
	Draw.FillBox (pipeCoordinates (1) (3), pipe_height1 + 140, pipeCoordinates (1) (3) + 50, pipeCoordinates (1) (4), green)
	Draw.FillBox (pipeCoordinates (2) (1), pipeCoordinates (2) (2), pipeCoordinates (2) (1) + 50, pipeCoordinates (2) (2) + pipe_height2, green)
	Draw.FillBox (pipeCoordinates (2) (3), pipe_height2 + 140, pipeCoordinates (2) (3) + 50, pipeCoordinates (2) (4), green)
	Pic.Draw (deadBird, xcoord, ycoord, picMerge) % Switch the image to "dead bird" 
	delay (100)
	cls 
	ycoord += round (velocity)
	velocity -= 130 / 33.33
	if ycoord <= 0 then
	    Pic.Draw (background, 0, 0, picMerge)
	    Pic.Draw (deadBird, xcoord, 0, picMerge)
	    Draw.FillBox (pipeCoordinates (1) (1), pipeCoordinates (1) (2), pipeCoordinates (1) (1) + 50, pipeCoordinates (1) (2) + pipe_height1, green)
	    Draw.FillBox (pipeCoordinates (1) (3), pipe_height1 + 140, pipeCoordinates (1) (3) + 50, pipeCoordinates (1) (4), green)
	    Draw.FillBox (pipeCoordinates (2) (1), pipeCoordinates (2) (2), pipeCoordinates (2) (1) + 50, pipeCoordinates (2) (2) + pipe_height2, green)
	    Draw.FillBox (pipeCoordinates (2) (3), pipe_height2 + 140, pipeCoordinates (2) (3) + 50, pipeCoordinates (2) (4), green)
	    exit
	end if
    end loop
    delay (1000)   
 
    % "You Lose" Screen. 
    Draw.FillBox (0, 0, maxx, maxy, 99)
    delay (100) 
    Font.Draw (highscore, 10, 370, font11, 55)
    Font.Draw (highscore_message, 10, 340, font11, 55) % Tells the user if they got a new highscore or not. 
    Font.Draw (intstr (round (points)), 380 - length (intstr (round (points))) * 30, 350, font6, 55)
    Font.Draw ("YOU LOSE", 20, 180, font8, 55)

    % Reset the variables
    ycoord := 200
    draw_true := true
    jump_true := true
    pipeCoordinates (1) (1) := 400
    pipeCoordinates (1) (3) := 400
    pipeCoordinates (2) (1) := 700
    pipeCoordinates (2) (3) := 700
    pipe_height1 := Rand.Int (20, 220)
    pipe_height2 := Rand.Int (20, 220)
    pipe_speed := 7
    velocity := 0
    points := 0
    
    loop
	Mouse.Where (x, y, button) 

	if button = 1 and x > 40 and y > 120 and x < 180 and y < 170 then % Play Again Button
	    cls
	    exit
	elsif button = 0 and x > 40 and y > 120 and x < 180 and y < 170 then
	    Draw.Box (40, 120, 180, 170, 78)
	    Font.Draw ("PLAY AGAIN", 50, 137, font9, 78)
	else
	    Draw.Box (40, 120, 180, 170, 55)
	    Font.Draw ("PLAY AGAIN", 50, 137, font9, 55)
	end if
	if button = 1 and x > 210 and y > 120 and x < 360 and y < 170 then % Menu button, simply call the menu procedure  
	    cls
	    Draw.FillBox (0, 0, maxx, maxy, 18)
	    delay (700)
	    menu
	    exit
	elsif button = 0 and x > 210 and y > 120 and x < 360 and y < 170 then
	    Draw.Box (210, 120, 360, 170, 78)
	    Font.Draw ("MENU", 250, 137, font9, 78)
	else
	    Draw.Box (210, 120, 360, 170, 55)
	    Font.Draw ("MENU", 250, 137, font9, 55)
	end if
    end loop
end loop
