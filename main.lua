--Touchdown Run

--Remove Staus bar
display.setStatusBar( display.HiddenStatusBar );

--Requires
local graphics = require("graphics");

--Game Variables
local speed = 5;
local onGround = true;
local wasOnGround = true;
local inEvent = 0;
local eventRun = 0;

--Sprites
local sheetOptions = {
	width = 100,
	height = 100,
	numFrames = 7,

	sheetContentWidth = 700,
	sheetContentHeight = 100
};
local spriteSheet = graphics.newImageSheet("images/monsterSpriteSheet.png", sheetOptions);

local sequnceData = {
	{ name = "running", start = 1, count = 6, time = 600, loopCount = 0 },
	{ name = "jumping", start = 7, count = 1, time = 1, loopCount = 1 }
};

--Create groups
local blocks = display.newGroup();
local player = display.newGroup();
local screen = display.newGroup();
local ghosts = display.newGroup();
local spikes = display.newGroup();
local blasts = display.newGroup();

--Background
local backbackround = display.newImage( "images/background.png" );
backbackround.x = 240;
backbackround.y = 160;

local backgroundfar = display.newImage( "images/bgfar1.png" );
backgroundfar.x = 480;
backgroundfar.y = 160;

local backgroundnear1 = display.newImage( "images/bgnear2.png" );
backgroundnear1.x = 240;
backgroundnear1.y = 160;

local backgroundnear2 = display.newImage( "images/bgnear2.png" );
backgroundnear2.x = 760;
backgroundnear2.y = 160;

--Ground
local groundMin = 420;
local groundMax = 340;
local groundLevel = groundMin;

for a = 1, 8, 1 do
	isDone = false;
	numGen = math.random(2);
	local newBlock;

	if (numGen == 1 and isDone == false) then
		newBlock = display.newImage( "images/ground1.png" );
		isDone = true;
	end

	if (numGen == 2 and isDone == false) then
		newBlock = display.newImage( "images/ground2.png" );
		isDone = true;
	end

	newBlock.name = ("block" .. a);
	newBlock.id = a;

	newBlock.x = (a * 79) - 79;
	newBlock.y = groundLevel;
	blocks:insert(newBlock);
end

--Ghosts
for i = 1, 3, 1 do
	local ghost = display.newImage( "images/ghost.png" );
	ghost.name = ("ghost" .. i);
	ghost.id = i;
	ghost.x = 800;
	ghost.y = 600;
	ghost.speed = 0;
	ghost.isAlive = false;
	ghost.alpha = .5;
	ghosts:insert( ghost );
end

--Spikes
for i = 1, 3, 1 do
	local spike = display.newImage( "images/spikeBlock.png" );
	spike.name = ("spike" .. i);
	spike.id = i;
	spike.x = 900;
	spike.y = 500;
	spike.isAlive = false;
	spikes:insert(spike);
end

--Blasts
for i = 1, 5, 1 do
	local blast = display.newImage( "images/blast.png" );
	blast.name = ("blast" .. i);
	blast.id = i;
	blast.x = 800;
	blast.y = 500;
	blast.isAlive = false;
	blasts:insert(blast);
end

--monster
local monster = display.newSprite(spriteSheet, sequnceData);
monster.x = 110;
monster.y = 200;
monster.gravity = -6;
monster.accel = 0;

monster:setSequence("running");
monster:play();

--Collision Test
local collisionRect = display.newRect( monster.x + 36, monster.y, 1, 70 );
collisionRect.strokeWidth = 1;
collisionRect:setFillColor( 140, 140, 140 );
collisionRect:setStrokeColor( 180, 180, 180 );
collisionRect.alpha = 0;

--Load Groups
screen:insert(backbackround);
screen:insert(backgroundfar);
screen:insert(backgroundnear1);
screen:insert(backgroundnear2);
screen:insert(blocks);
screen:insert(spikes);
screen:insert(blasts);
screen:insert(ghosts);
screen:insert(monster);
screen:insert(collisionRect);

--Game Loop
local function update( event )
	updateBackgrounds();
	updateSpeed();
	updateMonster();
	updateBlocks();
	checkCollisions();
	updateBlasts();
	updateSpikes();
	updateGhosts();
end

--Functions
function updateBackgrounds()
	backgroundfar.x = backgroundfar.x - (speed / 55);
	
	backgroundnear1.x = backgroundnear1.x - (speed / 5);
	if (backgroundnear1.x < -239) then
		backgroundnear1.x = 760;
	end

	backgroundnear2.x = backgroundnear2.x - (speed / 5);
	if (backgroundnear2.x < -239) then
		backgroundnear2.x = 760;
	end
end

function updateSpeed()
	speed = speed + .0005;
end

function updateMonster()
	if (onGround) then
		if (wasOnGround) then
		else
			monster:setSequence( "running" );
			monster:play();
		end
	else
		monster:setSequence( "jumping" );
		monster:play();
	end

	if (monster.accel > 0) then
		monster.accel = monster.accel - 1;
	end

	monster.y = monster.y - monster.accel;
	monster.y = monster.y - monster.gravity;

	collisionRect.y = monster.y;	
end

function updateBlocks()
	for i = 1, blocks.numChildren, 1 do
		if (i > 1) then
			newX = (blocks[i - 1]).x + 79;
		else
			newX = (blocks[8]).x + 79 - speed;
		end
		if ((blocks[i]).x < -40) then
			if (inEvent == 11) then
				(blocks[i]).x, (blocks[i]).y = newX, 600;
			else
				(blocks[i]).x, (blocks[i]).y = newX, groundLevel;
			end

			if (inEvent == 12) then
				for i = 1, spikes.numChildren, 1 do
					if (spikes[i].isAlive == true) then
						--do nothing
					else
						spikes[i].isAlive = true;
						spikes[i].y = groundLevel - 200;
						spikes[i].x = newX;
						break;
					end
				end
			end

			checkEvent();
		else
			(blocks[i]):translate( speed * -1, 0 );
		end
	end
end

function checkCollisions()
	wasOnGround = onGround;

	for i = 1, blocks.numChildren, 1 do
		if (collisionRect.y - 10 > blocks[i].y - 170 and blocks[i].x - 40 < collisionRect.x and blocks[i].x + 40 > collisionRect.x) then
			speed = 0;
		end
	end

	for i = 1, blocks.numChildren, 1 do
		if (monster.y >= blocks[i].y - 170 and blocks[i].x < monster.x + 60 and blocks[i].x > monster.x - 60) then
			monster.y = blocks[i].y - 171;
			onGround = true;
			break;
		else
			onGround = false;
		end
	end

	--if monster runs into spikes
	for i = 1, spikes.numChildren, 1 do
		if (spikes[i].isAlive == true) then
			if (collisionRect.y - 10 > spikes[i].y - 170 and spikes[i].x - 40 < collisionRect.x and spikes[i].x + 40 > collisionRect.x) then
				--stop the monster
				speed = 0;
			end
		end
	end

	--if monsters hits a ghost
	for i = 1, ghosts.numChildren, 1 do
		if (ghosts[i].isAlive == true) then
			if (((((monster.y - ghosts[i].y)) < 70) and ((monster.y - ghosts[i].y) > -70)) and (ghosts[i].x - 40 < collisionRect.x and ghosts[i].x + 40 > collisionRect.x)) then
				speed = 0;
			end
		end
	end
end

function updateBlasts()
	for i = 1, blasts.numChildren, 1 do
		if (blasts[i].isAlive == true) then
			(blasts[i]):translate( 5, 0 );
			if (blasts[i].x > 550) then
				blasts[i].x = 800;
				blasts[i].y = 500;
				blasts[i].isAlive = false;
			end
		end

		--check spike collision
		for j = 1, spikes.numChildren, 1 do
			if (spikes[j].isAlive == true) then
				if (blasts[i].y - 25 > spikes[j].y - 120 and blasts[i].y + 25 < spikes[j].y + 120 and spikes[j].x - 40 < blasts[i].x + 25 and spikes[j].x + 40 > blasts[i].x - 25) then
					blasts[i].x = 800;
					blasts[i].y = 500;
					blasts[i].isAlive = false;
					spikes[j].x = 900;
					spikes[j].y = 500;
					spikes[j].isAlive = false;
				end
			end
		end

		--check ghost collision
		for j = 1, ghosts.numChildren, 1 do
      if(ghosts[j].isAlive == true) then
        if(blasts[i].y - 25 > ghosts[j].y - 120 and blasts[i].y + 25 < ghosts[j].y + 120 and ghosts[j].x - 40 < blasts[i].x + 25 and ghosts[j].x + 40 > blasts[i].x - 25) then
          blasts[i].x = 800
          blasts[i].y = 500
          blasts[i].isAlive = false
          ghosts[j].x = 800
          ghosts[j].y = 600
          ghosts[j].isAlive = false
          ghosts[j].speed = 0
        end
      end
    end
  end
end

function updateSpikes()
	for i = 1, spikes.numChildren, 1 do
		if (spikes[i].isAlive == true) then
			(spikes[i]):translate( speed * -1, 0 );
			if (spikes[i].x < -80) then
				spikes[i].x = 900;
				spikes[i].y = 500;
				spikes[i].isAlive = false;
			end
		end
	end
end

function updateGhosts()
	for i = 1, ghosts.numChildren, 1 do
		if (ghosts[i].isAlive == true) then
			(ghosts[i]):translate( speed * -1, 0 );
			if (ghosts[i].y > monster.y) then
				ghosts[i].y = ghosts[i].y - 1;
			end
			if (ghosts[i].y < monster.y) then
				ghosts[i].y = ghosts[i].y + 1;
			end
			if (ghosts[i].x < -80) then
				ghosts[i].x = 800;
				ghosts[i].y = 600;
				ghosts[i].speed = 0;
				ghosts[i].isAlive = false;
			end
		end
	end
end

function checkEvent()
	if (eventRun > 0) then
		eventRun = eventRun - 1;
		if (eventRun == 0) then
			inEvent = 0;
		end
	end

	if (inEvent > 0 and eventRun > 0) then
		--do nothing
	else
		local check = math.random(100);

		--Raise/Lower ground event
		if (check > 80 and check < 99) then
			inEvent = math.random(10);
			eventRun = 1;
		end

		--Pit event
		if (check > 98) then
			inEvent = 11;
			eventRun = 2;
		end

		--spike event
		if (check > 72 and check < 81) then
			inEvent = 12;
			eventRun = 1;
		end

		--ghost event
		if (check > 60 and check < 73) then
			inEvent = 13;
			eventRun = 1;
		end
	end
	if (inEvent > 0) then
		runEvent();
	end
end

function runEvent()
	if (inEvent < 6) then
		groundLevel = groundLevel + 40;
	end
	if (inEvent > 5 and inEvent < 11) then
		groundLevel = groundLevel - 40;
	end
	if (groundLevel < groundMax) then
		groundLevel = groundMax;
	end
	if (groundLevel > groundMin) then
		groundLevel = groundMin;
	end

	--ghosts
	if (inEvent == 13) then
		for i = 1, ghosts.numChildren, 1 do
			if (ghosts[i].isAlive == false) then
				ghosts[i].isAlive = true;
				ghosts[i].x = 500;
				ghosts[i].y = math.random(-50, 400);
				ghosts[i].speed = math.random(2, 4);
				break;
			end
		end
	end
end

--Listener functions
function touched( event )
	if (event.phase == "began") then
		if (event.x < 241) then
			if (onGround) then
				monster.accel = monster.accel + 20;
			end
		else
			for i = 1, blasts.numChildren, 1 do
				if (blasts[i].isAlive == false) then
					blasts[i].isAlive = true;
					blasts[i].x = monster.x + 50;
					blasts[i].y = monster.y;
					break;
				end
			end
		end
	end
end

--Timer
timer.performWithDelay( 1, update, -1 );

--Listeners
Runtime:addEventListener( "touch", touched, -1 );