--Touchdown Run

--Remove Staus bar
display.setStatusBar( display.HiddenStatusBar );

--Game Variables
local speed = 5;

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

local function update( event )
	updateBackgrounds();
	updateBlocks();
	speed = speed + .05;
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