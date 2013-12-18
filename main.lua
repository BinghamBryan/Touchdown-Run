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
local score = 0;

local scoreText = display.newText("score: " .. score, 0, 0, "BorisBlackBloxx", 50);
scoreText.anchorX = 0;
scoreText.anchorY = 0;
scoreText.x = 0;
scoreText.y = 0;

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
local bossSpits = display.newGroup();

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
monster.x = 60;
monster.y = 200;
monster.gravity = -6;
monster.accel = 0;
monster.isAlive = true;

monster:setSequence("running");
monster:play();

--Collision Test
local collisionRect = display.newRect( monster.x + 36, monster.y, 1, 70 );
collisionRect.strokeWidth = 1;
collisionRect:setFillColor( 140, 140, 140 );
collisionRect:setStrokeColor( 180, 180, 180 );
collisionRect.alpha = 0;

--Boss
local boss = display.newImage( "boss.png", 150, 150 );
boss.x = 300;
boss.y = 550;
boss.isAlive = false;
boss.health = 10;
boss.goingDown = true;
boss.canShoot = false;
boss.spitCycle = 0;

for i = 1, 3, 1 do
	local bossSpit = display.newImage( "bossSpit.png" );
	bossSpit.x = 400;
	bossSpit.y = 550;
	bossSpit.isAlive = false;
	bossSpit.speed = 3;
	bossSpit.speed = 3;
	bossSpits:insert(bossSpits);
end

--Game Over
local gameOver = display.newImage( "images/gameOver.png" );
gameOver.name = "gameOver";
gameOver.x = 0;
gameOver.y = 500;

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
screen:insert(boss);
screen:insert(bossSpits);
screen:insert(scoreText);
screen:insert(gameOver);

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
	updateBossSpit();
	if (boss.isAlive == true) then
		updateBoss();
	end
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
	if (monster.isAlive == true) then
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
	else
		monster:rotate(5);
	end
	collisionRect.y = monster.y;	
end

function updateBoss()
	if (boss.health < 0) then
		if (boss.y > 210) then
			boss.goingDown = false;
		end
		if (boss.y < 100) then
			boss.goingDown = true;
		end
		if (boss.goingDown) then
			boss.y = boss.y + 2;
		else
			boss.y = boss.y - 2;
		end
	else
		boss.alpha = boss.alpha - .01;
	end

	if (boss.alpha <= 0) then
		boss.isAlive = false;
		boss.x = 300;
		boss.y = 550;
		boss.alpha = 1;
		boss.health = 10;
		inEvent = 0;
		boss.spitCycle = 0;
	end
end

function updateBossSpit()
	for i = 1, bossSpits.numChildren, 1 do
		if (bossSpits[i].isAlive) then
			(bossSpits[i]):translate( speed * -1, 0 );
			if (bossSpits[i].y > monster.y) then
				bossSpits[i].y = bossSpits[i].y - 1;
			end
			if (bossSpits[i].y < monster.y) then
				bossSpits[i].y = bossSpits[i].y + 1;
			end
			if (bossSpits[i].x < -80) then
				bossSpits[i].x = 400;
				bossSpits[i].y = 550;
				bossSpits[i].speed = 0;
				bossSpits[i].isAlive = false;
			end
		end
	end
end

function updateBlocks()
	for i = 1, blocks.numChildren, 1 do
		if (i > 1) then
			newX = (blocks[i - 1]).x + 79;
		else
			newX = (blocks[8]).x + 79 - speed;
		end
		if ((blocks[i]).x < -40) then
			if (boss.isAlive == false) then
				score = score + 1;
				scoreText.text = "score: " .. score;
			else
				boss.spitCycle = boss.spitCycle + 1;
				if (boss.y > 100 and boss.y < 300 and boss.spitCycle % 3 == 0) then
					for i = 1, bossSpits.numChildren, 1 do
						if (bossSpits[i].isAlive == false) then
							bossSpits[i].isAlive = true;
							bossSpits[i].x = boss.x - 35;
							bossSpits[i].y = boss.y + 55;
							bossSpits[i].speed = math.random(5, 10);
							break;
						end
					end
				end
			end
			if (inEvent == 15) then
				groundLevel = groundMin;
			end
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
			monster.isAlive = false;
			monster:pause( );
			gameOver.x = display.contentWidth * .65;
			gameOver.y = display.contentHeight / 2;
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
				monster.isAlive = false;
				monster:pause( );
				gameOver.x = display.contentWidth * .65;
				gameOver.y = display.contentHeight / 2;
			end
		end
	end

	--if monsters hits a ghost
	for i = 1, ghosts.numChildren, 1 do
		if (ghosts[i].isAlive == true) then
			if (((((monster.y - ghosts[i].y)) < 70) and ((monster.y - ghosts[i].y) > -70)) and (ghosts[i].x - 40 < collisionRect.x and ghosts[i].x + 40 > collisionRect.x)) then
				speed = 0;
				monster.isAlive = false;
				monster:pause( );
				gameOver.x = display.contentWidth * .65;
				gameOver.y = display.contentHeight / 2;
			end
		end
	end

	--if monster hits boss spit
	for i = 1, bossSpits.numChildren, 1 do
		if (bossSpits[i].isAlive == true) then
			if(((  ((monster.y-bossSpits[a].y))<45)) and ((  ((monster.y-bossSpits[a].y))>-45)) and ((  ((monster.x-bossSpits[a].x))>-45)) ) then
				speed = 0;
				monster.isAlive = false;
				monster:pause( );
				gameOver.x = display.contentWidth * .65;
				gameOver.y = display.contentHeight / 2;
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

    --check boss collision
    if (boss.isAlive == true) then
    	if (blasts[i].y - 25 > boss.y - 120 and blasts[i].y + 25 < boss.y + 120 and boss.x - 40 < blasts[i].x + 25 and boss.x + 40 > blasts[i].x - 25) then
    		blasts[i].x = 800;
    		blasts[i].y = 500;
    		blasts[i].isAlive = false;
    		boss.health = boss.health - 1;
    	end
    end

    --check boss spit collision
    for j = 1, bossSpits.numChildren, 1 do
    	if (bossSpits[j].isAlive == true) then
    		if (blasts[i].y - 20 > bossSpits[j].y - 120 and blasts[i].y + 20 < bossSpits[j].y + 120 and bossSpits[j].x - 25 < blasts[i].x + 20 and bossSpits[j].x + 25 > blasts[i.x - 20) then
    			blasts[i].x = 800;
    			blasts[j].x = 500;
    			blasts[i].isAlive = false;

    			bossSpits[j].x = 400;
    			bossSpits[j].y = 550;
    			bossSpits[j].isAlive = false;
    			bossSpits[j].speed = 0;
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
		if (boss.isAlive == false and score % 10 == 0) then
			boss.isAlive = true;
			boss.x = 400;
			boss.y = -200;
			boss.health = 10;
		end
		if (boss.isAlive == true) then
			inEvent = 15;
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

--Restart Game
function restartGame()
	gameOver.x = 0;
	gameOver.y = 500;

	score = 0;

	speed = 5;

	monster.isAlive = true;
	monster.x = 60;
	monster.y = 200;
	monster:setSequence("running");
	monster:play();
	monster.rotation = 0;

	--reset boss
	boss.isAlive = false;
	boss.x = 300;
	boss.y = 550;

	for i = 1, bossSpits.numChildren, 1 do
		bossSpits[i].x = 400;
		bossSpits[i].y = 550;
		bossSpits[i].isAlive = false;
	end

	groundLevel = groundMin;
	for i = 1, blocks.numChildren, 1 do
		blocks[i].x = (i * 79) - 79;
		blocks[i].y = groundLevel;
	end

	for i = 1, ghosts.numChildren, 1 do
		ghosts[i].x = 800;
		ghosts[i].y = 600;
	end

	for i = 1, spikes.numChildren, 1 do
		spikes[i].x = 900;
		spikes[i].y = 500;
	end

	for i = 1, blasts.numChildren, 1 do
		blasts[i].x = 800;
		blasts[i].y = 500;
	end

	backgroundfar.x = 480;
	backgroundfar.y = 160;
	backgroundnear1.x = 240;
	backgroundnear1.y = 160;
	backgroundnear2.x = 760;
	backgroundnear2.y = 160;
end

--Listener functions
function touched( event )
	if (event.x < gameOver.x + 150 and event.x > gameOver.x - 150 and event.y < gameOver.y + 95 and event.y > gameOver.y - 95) then
		restartGame();
	else
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
end

--Timer
timer.performWithDelay( 1, update, -1 );

--Listeners
Runtime:addEventListener( "touch", touched, -1 );