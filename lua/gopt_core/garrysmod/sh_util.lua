local Vector = Vector
local Angle = Angle
local Color = Color
local math_Rand = math.Rand
local math_random = math.random
local math_sin = math.sin
local math_cos = math.cos
local math_pi = math.pi
local CurTime = CurTime
--

--[[---------------------------------------------------------
	Returns a random vector
-----------------------------------------------------------]]
function VectorRand(min, max)
	min = min or -1
	max = max or 1

	return Vector(math_Rand(min, max), math_Rand(min, max), math_Rand(min, max))
end

--[[---------------------------------------------------------
	Returns a random angle
-----------------------------------------------------------]]
function AngleRand(min, max)
	return Angle(
		math_Rand(min or -90, max or 90),
		math_Rand(min or -180, max or 180),
		math_Rand(min or -180, max or 180)
	)
end

--[[---------------------------------------------------------
	Returns a random color
-----------------------------------------------------------]]
function ColorRand(alpha)
	if alpha then
		return Color(math_random(0, 255), math_random(0, 255), math_random(0, 255), math_random(0, 255))
	end

	return Color(math_random(0, 255), math_random(0, 255), math_random(0, 255))
end

--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]
function TimedSin(freq, min, max, offset)
	return math_sin(freq * math_pi * 2 * CurTime() + offset) * (max - min) * 0.5 + min
end

--[[---------------------------------------------------------
	From Simple Gamemode Base (Rambo_9)
-----------------------------------------------------------]]
function TimedCos(freq, min, max, offset)
	return math_cos(freq * math_pi * 2 * CurTime() + offset) * (max - min) * 0.5 + min
end