-- code source: https://github.com/EgoMoose/Articles/blob/master/2d%20triangles/2d%20triangles.md

local HALF = Vector2.new(0.5, 0.5);

local IMG = Instance.new("ImageLabel");
IMG.BackgroundTransparency = 1;
IMG.AnchorPoint = HALF;
IMG.BorderSizePixel = 0;

local RIGHT = "rbxassetid://319692151";
local LEFT = "rbxassetid://319692171";

local function draw2dTriangle(a, b, c, parent, w1, w2)
	local ab, ac, bc = b - a, c - a, c - b;
	local abd, acd, bcd = ab:Dot(ab), ac:Dot(ac), bc:Dot(bc);
	
	if (abd > acd and abd > bcd) then
		c, a = a, c;
	elseif (acd > bcd and acd > abd) then
		a, b = b, a;
	end
	
	ab, ac, bc = b - a, c - a, c - b;
	
	local unit = bc.unit;
	local height = unit:Cross(ab);
	local flip = (height >= 0);
	local theta = math.deg(math.atan2(unit.y, unit.x)) + (flip and 0 or 180);
	
	local m1 = (a + b)/2;
	local m2 = (a + c)/2;
	
	w1 = w1 or IMG:Clone();
	w1.Image = flip and RIGHT or LEFT;
	w1.AnchorPoint = HALF;
	w1.Size = UDim2.new(0, math.abs(unit:Dot(ab)), 0, height);
	w1.Position = UDim2.new(0, m1.x, 0, m1.y);
	w1.Rotation = theta;
	w1.Parent = parent;
	
	w2 = w2 or IMG:Clone();
	w2.Image = flip and LEFT or RIGHT;
	w2.AnchorPoint = HALF;
	w2.Size = UDim2.new(0, math.abs(unit:Dot(ac)), 0, height);
	w2.Position = UDim2.new(0, m2.x, 0, m2.y);
	w2.Rotation = theta;
	w2.Parent = parent;
	
	return w1, w2;
end
