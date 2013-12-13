--Touchdown Run

--Remove Staus bar
display.setStatusBar( display.HiddenStatusBar );

--Requires
local graphics = require("graphics");
--Game Variables
local speed = 5;
local right = true;

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

--Create a new group to hold our blocks
local blocks = display.newGroup();

--Ground
local groundMin = 420;
local groundMax = 340;
local groundLevel = groundMin;

for a = 1, 8, 1 do
	isDone = false;
	numGen = math.random(2);
	local newBlock;
	print(numGen);

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
--Hero
local hero = display.newSprite(spriteSheet, sequnceData);
hero.x = display.contentWidth / 2;
hero.y = display.contentHeight / 2;

hero:setSequence("running");
hero:play();

--Game Loop
local function update( event )
	updateBackgrounds();
	updateBlocks();
	speed = speed + .05;

	--Move Hero
	if (right) then
		hero.x = hero.x + 3;
	else
		hero.x = hero.x - 3;
	end

	if (hero.x > 380) then
		right = false;
		hero.xScale = -1;
	end
	
	if (hero.x < - 60) then
		right = true;
		hero.xScale = 1;
	end
end



--Functions
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

--Timer
timer.performWithDelay( 1, update, -1 );