--Touchdown Run

--Remove Staus bar
display.setStatusBar( display.HiddenStatusBar );

--Requires
local graphics = require("graphics");

--Game Variables
local speed = 5;
local onGround = true;
local wasOnGround = true;

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

--Create groups
local blocks = display.newGroup();
local player = display.newGroup();
local screen = display.newGroup();

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
screen:insert(monster);
screen:insert(collisionRect);

--Game Loop
local function update( event )
	updateBackgrounds();
	updateSpeed();
	updateMonster();
	updateBlocks();
	checkCollisions();
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
	speed = speed + .05;
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
			(blocks[i]).x, (blocks[i]).y = newX, groundLevel;
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
end

--Listener functions
function touched( event )
	if (event.phase == "began") then
		if (event.x < 241) then
			if (onGround) then
				monster.accel = monster.accel + 20;
			end
		end
	end
end

--Timer
timer.performWithDelay( 1, update, -1 );

--Listeners
Runtime:addEventListener( "touch", touched, -1 );