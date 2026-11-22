-- Rename by Prince Bot | .gg/freesource
-- Clean by Prince Bot | .gg/freesource
local function luraph_runtime1(...)
	error("Luraph runtime function, not devirtualized")
end

local function payload_fn_13()
	assert(0.95980323245314281)
	getfenv(0)
	select("#", 0.21066317205669061, 0.91874696113331178, 0.20907157293564349)
	tonumber(0.42114355220593924)
	tostring(0.22867960849910196)
	rawequal(scratch, scratch)
	local tbl = {}
	next(tbl)
	pairs(tbl)(tbl)
	ipairs(tbl)(tbl, 1)
	rawlen(tbl)
	rawget(tbl, 0.055581467069107049)
	rawset(tbl, 0.46868048561599784, 0.16151711456028683)
	getmetatable(tbl)
	setmetatable(tbl, tbl)
	setmetatable(tbl, nil)
	upv1(683, "slnaf")
	bit32.bor(53, 83)
	bit32.bxor(214, 187)
	bit32.band(103, 4)
	bit32.bnot(137)
	bit32.lshift(196, 17)
	bit32.rshift(8, 23)
	bit32.lrotate(146, 5)
	bit32.rrotate(172, 20)
	bit32.countlz(72)
	bit32.countrz(32)
	local v = buffer.create(239)
	buffer.len(v)
	buffer.fromstring("")
	buffer.tostring(v)
	buffer.readi8(v, 5)
	buffer.readu8(v, 16)
	buffer.readi16(v, 1)
	buffer.readu16(v, 5)
	buffer.readi32(v, 27)
	buffer.readu32(v, 15)
	buffer.readf32(v, 13)
	buffer.readf64(v, 9)
	buffer.writei8(v, 15, -43)
	buffer.writeu8(v, 30, 101)
	buffer.writei16(v, 13, -16125)
	buffer.writeu16(v, 21, 16510)
	buffer.writei32(v, 6, -792132135)
	buffer.writeu32(v, 1, 166809002)
	buffer.writef32(v, 30, 14000)
	buffer.writef64(v, 7, 1515)
	buffer.readstring(v, 27, 15)
	buffer.writestring(v, 22, "Luraph", 2)
	buffer.readbits(v, 247, 11)
	buffer.writebits(v, 64, 20, 200752224)
	buffer.copy(v, 32, v, 0, 16)
	buffer.fill(v, 29, 230, 24)
	local v2 = upv2.new()
	v2:NextInteger(45, 826)
	v2:NextNumber(8, 985)
	v2:NextUnitVector()
	v2:NextNumber()
	v2:Shuffle({})
	v2:Clone()
	local n = Vector3.new(0.4523847, 0.5905261, 0.77301115) + Vector3.new(0.78420955, 0.6469517, 0.7131226)
	local vector = Vector3.new(0.4523847, 0.5905261, 0.77301115)
	local vector2 = Vector3.new(0.78420955, 0.6469517, 0.7131226)
	local vector3 = Vector3.new(1, 0, 0)
	local vector4 = Vector3.new(0, 1, 0)
	local v3 = upv3.new()
	local v4 = upv3.new(vector)
	upv3.Angles(0.063106167433893412, 0.073686665442849408, 0.44349182109393193)
	local xyz = Enum.RotationOrder.XYZ
	upv3.new(vector, n)
	upv3.new(vector.X, vector.Y, vector.Z)
	upv3.new(vector.X, vector.Y, vector.Z, 0, 0, 0, 1)
	upv3.new(vector.X, vector.Y, vector.Z, 1, 0, 0, 0, 1, 0, 0, 0, 1)
	upv3.lookAt(vector, n, vector4)
	upv3.lookAlong(vector, vector2, vector4)
	upv3.fromEulerAnglesXYZ(0.063106167433893412, 0.073686665442849408, 0.44349182109393193)
	upv3.fromEulerAnglesYXZ(0.063106167433893412, 0.073686665442849408, 0.44349182109393193)
	upv3.fromOrientation(0.063106167433893412, 0.073686665442849408, 0.44349182109393193)
	upv3.fromAxisAngle(vector2.Unit, 0.063106167433893412)
	upv3.fromRotationBetweenVectors(vector3, vector4)
	upv3.fromMatrix(vector, vector3, vector4, Vector3.new(0, 0, 1))
	upv3.fromEulerAngles(0.063106167433893412, 0.073686665442849408, 0.44349182109393193, xyz)
	v3:Inverse()
	v3:Orthonormalize()
	v3:Lerp(v4, 0.6092726572379219)
	v3:ToWorldSpace(v4)
	v3:ToObjectSpace(v4)
	v3:ToEulerAnglesXYZ()
	v3:ToEulerAnglesYXZ()
	v3:PointToWorldSpace(vector)
	v3:PointToObjectSpace(vector)
	v3:VectorToWorldSpace(vector2)
	v3:VectorToObjectSpace(vector2)
	v3:ToEulerAngles(xyz)
	v3:GetComponents()
	v3:ToOrientation()
	v3:ToAxisAngle()
	v3:FuzzyEq(v4)
	v3:AngleBetween(v4)
	local vector5 = Vector3.new(0.15860099, 0.076187186, 0.27643508)
	local vector6 = Vector3.new(0.04987291, 0.3266288, 0.5403538)
	upv4.FromAxis(Enum.Axis.X)
	upv4.FromNormalId(Enum.NormalId.Top)
	vector5:Abs()
	vector5:Ceil()
	vector5:Floor()
	vector5:Sign()
	vector5:Dot(vector6)
	vector5:Cross(vector6)
	vector5:Angle(vector6)
	vector5:FuzzyEq(vector6)
	vector5:Lerp(vector6, 0.046263188307136716)
	vector5:Max(vector6)
	vector5:Min(vector6)
	local vector22 = Vector2.new(0.9025918841362, 0.90862613916397095)
	vector22:Abs()
	vector22:Ceil()
	vector22:Floor()
	vector22:Sign()
	vector22:Dot(Vector2.new(0.89519357681274414, 0.34628966450691223))
	vector22:Cross(Vector2.new(0.89519357681274414, 0.34628966450691223))
	vector22:Angle(Vector2.new(0.89519357681274414, 0.34628966450691223))
	vector22:FuzzyEq(Vector2.new(0.89519357681274414, 0.34628966450691223))
	vector22:Lerp(Vector2.new(0.89519357681274414, 0.34628966450691223), 0.18734772703646485)
	vector22:Max(Vector2.new(0.89519357681274414, 0.34628966450691223))
	vector22:Min(Vector2.new(0.89519357681274414, 0.34628966450691223))
	local v5 = upv5(-0.2859237519530653, 65)
	local v6 = upv5(0.26366564728694231, 101)
	upv6(0.44697076235189215, -90, 0.033422182715441728, -96):Lerp(
		upv6(-0.019706954531249377, 30, 0.41172301780977683, -55),
		0.31967508999838401
	)
	local subject = Enum.HumanoidDisplayDistanceType.Subject
	local enumType = subject.EnumType
	enumType:GetEnumItems()
	enumType:FromName(subject.Name)
	enumType:FromValue(subject.Value)
	local v7 = upv6(0.237790023511397, 19, 0.23690746167192941, 6)
	local v8 = upv6(0.10864377729793792, 27, 0.072616704817220046, 12)
	local v9 = upv6(0.96485562774424638, 172, 0.70991499092963817, 185)
	local v10 = upv7(v7, v8, v8)
	upv7(v7:Lerp(v9, 0.56046914203460663))
	local tbl2 = {}
	local v11 = upv7(v9)
	tbl2[1] = v10
	tbl2[2] = v11
	local v12 = utf8.char(45, 1550, 156073)
	utf8.codepoint(v12, 1, #v12)
	utf8.len(v12)
	utf8.offset(v12, 3)
	utf8.offset(v12, -3)
	local v13, v14, v15 = utf8.codes(v12)
	v13(v14, v15)
	v13(v14, utf8.offset(v12, 1))
	local v16 = utf8.char(108, 864)
	utf8.nfcnormalize(v16)
	utf8.nfdnormalize(v12)
	utf8.graphemes(v16, 1, #v16)()
	upv8 = (201 * upv8 + 174031381) % 268435456
	upv9 = (1 * upv9 + 47212102) % 268435456
end

local function payload_fn_14()
	local v = nil
	upv1 += 1

	if nil then
		setmetatable({}, { __index = upv2 })
		local v2 = luraph_runtime1(nil, 4196277223)
		upv3(v2)
		upv8(3566952600, "wait")
		upv9 = "Shuffle"
		upv10()
		return
	end

	if nil then
		upv6()
	end

	upv4 = (1 * upv4 + 148029244) % 268435456
	upv5 = (350557 * upv5 + 195686467) % 268435456
end

local function payload_fn_15()
	upv1 = (1 * upv1 + 196593968) % 268435456
	upv2 = (585239 * upv2 + 7182967) % 268435456
end

local function payload_fn_16()
	upv1 = upv1 - upv1 % 2 + 1
	upv2 = (712337 * upv2 + 159565479) % 268435456
	upv2 = (985637 * upv2 + 32218059) % 268435456
end

local function payload_fn_17()
	upv1 += 1

	if upv1 ~= 2499 then
		if upv1 == 2498 then
			upv5()
		end

		upv3 = (1 * upv3 + 27729454) % 268435456
		upv4 = (228055 * upv4 + 32871487) % 268435456
		upv6()
		return
	end

	upv2()
	upv3 = (1 * upv3 + 151448578) % 268435456
	upv4 = (824735 * upv4 + 255486207) % 268435456
end

local function payload_fn_18(arg)
	if arg ~= 19998 then
		if arg ~= 19997 then
			if arg == 16967 then
				upv4(arg)
			end
		else
			upv4(arg)
		end

		upv5(arg + 1)

		if arg == 19997 then
			if not upv6(upv1, upv7) then
				upv3 = upv3 - upv3 % 2 + 1
				upv2 = (243607 * upv2 + 221766565) % 268435456
				upv2 = (1007583 * upv2 + 163881711) % 268435456
				return
			end

			upv8()

			if not upv9(upv1) then
				upv3 = upv3 - upv3 % 2 + 1
				upv2 = (540693 * upv2 + 203568947) % 268435456
				upv2 = (366941 * upv2 + 50075669) % 268435456
				return
			end

			if upv6(upv10, upv11) then
				upv3 = upv3 - upv3 % 2 + 1
				upv2 = (401 * upv2 + 117854649) % 268435456
				upv2 = (391401 * upv2 + 183508873) % 268435456
				return
			end

			upv12()

			if upv13 then
				upv3 = upv3 - upv3 % 2 + 1
				upv2 = (65473 * upv2 + 53871237) % 268435456
				upv2 = (94645 * upv2 + 111427373) % 268435456
				return
			end

			upv3 = (1 * upv3 + 129134222) % 268435456
			upv2 = (923897 * upv2 + 180989555) % 268435456
		end

		upv2 = (656297 * upv2 + 41011467) % 268435456
		upv3 = (1 * upv3 + 150166904) % 268435456
		return
	end

	upv1()
	upv2 = (604161 * upv2 + 108177013) % 268435456
	upv3 = (1 * upv3 + 2689812) % 268435456
end

local function payload_fn_19()
	coroutine.yield(upv1)
	coroutine.yield(upv2)
	upv3(38967837, 4)
	upv4 = 137063193
	upv5()
end

local function payload_fn_20()
	upv1 = coroutine.running()
	upv2(0)
	upv3 = true
	upv4(38967837, 4)
	upv5 = 137063193

	if nil then
		upv7 = bit32.bxor(upv7, 3815021599)
	end

	upv6()
end

local function payload_fn_21()
	coroutine.yield()
	upv1(38967837, 4)
	upv2 = 137063193
	upv3()
end

local function payload_fn_22() end

local function payload_fn_26()
	upv1.Parent = upv2
end

local v, v2, n = ...
local v3 = nil
local kind = type(v)
upv3("userdata", kind)

if not nil then
	upv4(38967837, 4)
	upv5 = 137063193
	upv6()
end

local kind2 = typeof(v)
upv3("Instance", kind2)

if not nil then
	upv4("defer", 2946078646)
	local n2 = n + upv8
	upv5 = 3553874899
	upv6()
	n = n2 - 227610726
end

local parent = v.Parent
local v4 = bit32.band(nil, upv8)
local parent2 = v.Parent

if nil + 520643843 ~= 159168312 then
	local name, name2, kind3, descendantAdded, v5, connect, v6, v7, fn, v8, v9, v10, disconnect, v11, v12, childRemoved, v13, create, fn2, v14, v15, v16, v17, n2, flag, v18, ok, result, v19, v20, v21, flag2, v22, v23, v24, childRemoved2, connect2, connect3

	if upv7[not parent] then
		name = parent2
		upv3(parent, name)

		if not nil then
			upv4("The metatable is locked", "Parent")
			upv5 = 1431655765
			upv6()
		end

		if bit32.bxor(nil, 188710262) ~= 437619904 then
			name2 = v.Name
			name = v.Name
			kind3 = type(name2)
			upv3("string", kind3)

			if not nil then
				upv4(38967837, 4)
				upv5 = 137063193
				upv6()
			end
		else
			while true do
				upv4(-2, 0)
				upv5 = "PostAsync"
				upv6()
				local exitTo = nil

				while true do
					descendantAdded = v.DescendantAdded
					v5 = descendantAdded
					connect = descendantAdded.Connect
					v7 = bit32.bxor(v6, 1375590348)

					fn = function()
						upv1 = true
						bit32.bxor(upv2, 33167250)

						if nil then
							upv2 = bit32.bxor(upv2, 2590075543)
						end
					end

					v8 = bit32.bxor(n, 250982902)
					bit32.bxor(v7, v8)
					v9 = connect(v5, fn)
					local v25 = table.pack(bit32.band(v4, 4294967295))
					local v26 = table.pack(bit32.band(v10, 4294967295))
					local v27 = table.pack(bit32.band(v25[1], 65535))
					local v28 = table.pack(bit32.rshift(v25[1], 16))
					local v29 = table.pack(bit32.band(v26[1], 65535))
					v4 = bit32.band(
						v27[1] * v29[1]
							+ bit32.lshift(bit32.band(v27[1] * bit32.rshift(v26[1], 16) + v28[1] * v29[1], 65535), 16),
						4294967295
					)

					if nil then
						exitTo = 1
						break
					else
						if not nil then
							upv4(38967837, 4)
							upv5 = 137063193
							upv6()
						end

						disconnect = v9.Disconnect
						v11 = upv1(disconnect, "Disconnect")
						bit32.bxor(v11, 313819569)

						if nil then
							bit32.bxor(v11, 2079815762)
						end

						v12 = upv2

						if v9 <= 59 then
							v12(disconnect, nil)
							disconnect(v9)

							if nil then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								n = n + upv8 - 227610726
							end

							v13 = upv1(childRemoved.Wait, "Wait")
							bit32.bxor(v13, 465099924)

							if nil then
								bit32.bxor(v13, 1619147085)
							end

							create = coroutine.create

							fn2 = function()
								local v30 = upv1
								local v31 = upv2

								if nil then
									upv3 = bit32.bxor(upv3, 388969805)
								end

								return (v30(v31))
							end

							bit32.bxor(bit32.bxor(v10, 178173754), v4 + 3027910902)
							v2 = create(fn2)
							v14, v15 = coroutine.resume(v2)
							v16 = v15
							v17 = upv7[not v14]
							n2 = v6 - n

							if v17 then
								flag = upv7[not v16]

								if not flag then
									v18 = coroutine.status(v2)
									flag = not upv3("suspended", v18)
								end

								if flag then
									upv4(38967837, 4)
									upv5 = 137063193
									upv6()
								end

								ok, result = pcall(coroutine.close, v2)
								name2 = result
								v19 = upv7
								v6 = bit32.band(n2, v20)
								v21 = v19[not ok]
								flag2 = not v21
								local exitTo2

								if v21 then
									v22 = upv7

									if v6 == 137363747 then
										name2 = not v22[not name2]

										if not name2 then
											v23 = coroutine.status(v2)
											name2 = not upv3("dead", v23)
										end

										exitTo2 = nil

										while true do
											if name2 then
												upv4(38967837, 4)
												upv5 = 137063193
												upv6()
											end

											v24 = getmetatable(v)
											upv3("The metatable is locked", v24)

											if not nil then
												upv4(3553874899, 1513060619)
												upv5 = "FromAxis"
												upv6()
											end

											if upv8 ~= 474807989 then
												exitTo2 = 1
												break
											else
												upv4(38967837, 4)
												upv5 = 137063193
												if v6 + 73262460 == 128884171 then
													continue
												end
											end

											break
										end

										if exitTo2 == 1 then
											exitTo = 5
											break
										else
											upv6()
											childRemoved = v.ChildRemoved
											childRemoved2 = v.ChildRemoved
											upv3(childRemoved, childRemoved2)

											if nil then
												upv4(38967837, 4)
												upv5 = 137063193
												upv6()
											end

											if not nil then
												upv4(3957289073, "RequestAsync")
												upv5 = "Enum"
												upv6()
											end

											connect2 = childRemoved.Connect
											connect3 = childRemoved.Connect
											v10 = upv1(connect2, "Connect")
											v20 = upv1(connect3, "Connect")
											upv3(connect2, connect3)
											if not nil then
												continue
											end
										end
									else
										exitTo = 4
										break
									end
								else
									name2 = flag2

									if not name2 then
										v23 = coroutine.status(v2)
										name2 = not upv3("dead", v23)
									end

									exitTo2 = nil

									while true do
										if name2 then
											upv4(38967837, 4)
											upv5 = 137063193
											upv6()
										end

										v24 = getmetatable(v)
										upv3("The metatable is locked", v24)

										if not nil then
											upv4(3553874899, 1513060619)
											upv5 = "FromAxis"
											upv6()
										end

										if upv8 ~= 474807989 then
											exitTo2 = 1
											break
										else
											upv4(38967837, 4)
											upv5 = 137063193
											if v6 + 73262460 == 128884171 then
												continue
											end
										end

										break
									end

									if exitTo2 == 1 then
										exitTo = 5
										break
									else
										upv6()
										childRemoved = v.ChildRemoved
										childRemoved2 = v.ChildRemoved
										upv3(childRemoved, childRemoved2)

										if nil then
											upv4(38967837, 4)
											upv5 = 137063193
											upv6()
										end

										if not nil then
											upv4(3957289073, "RequestAsync")
											upv5 = "Enum"
											upv6()
										end

										connect2 = childRemoved.Connect
										connect3 = childRemoved.Connect
										v10 = upv1(connect2, "Connect")
										v20 = upv1(connect3, "Connect")
										upv3(connect2, connect3)
										if not nil then
											continue
										end
									end
								end
							else
								exitTo = 3
								break
							end
						else
							exitTo = 2
							break
						end

						break
					end
				end

				if exitTo == 1 then
					upv4(38967837, 4)
					upv5 = 137063193
					bit32.band(2, nil)
					error("devirt: corrupt/encrypted register store 1439 (at 59:600)")
				end

				if exitTo == 2 then
					error("devirt: index b'FromName' (at 59:60)")
				end

				if exitTo == 3 then
					error("devirt: symbolic value store into proto array (at 59:770)")
				end

				if exitTo == 4 then
					break
				end

				if exitTo == 5 then
					return
				end
			end

			upv4(38967837, 4)
			upv5 = 137063193
			upv6()
		end
	else
		name2 = v.Name
		name = v.Name
		kind3 = type(name2)
		upv3("string", kind3)

		if not nil then
			upv4(38967837, 4)
			upv5 = 137063193
			upv6()
		end
	end

	local exitTo5 = nil
	local exitTo11 = nil
	local exitTo9, exitTo3, exitTo7

	while true do
		upv3(name2, name)

		if not nil then
			upv4(2166136261, "wait")
			upv5 = "nfdnormalize"
			upv6()
		end

		exitTo9 = nil
		local exitTo4

		while true do
			upv3(#name2, #name)

			if nil then
				upv3(tostring(v), name2)

				if not nil then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
				end

				upv3(v2, v.ClassName)

				if nil then
					exitTo9 = 1
					break
				else
					local exitTo6 = nil

					while true do
						upv4(38967837, 4)
						upv5 = 137063193

						if v6 + 73262460 ~= 128884171 then
							exitTo6 = 1
							break
						else
							if name2 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
							end

							v24 = getmetatable(v)
							upv3("The metatable is locked", v24)

							if not nil then
								upv4(3553874899, 1513060619)
								upv5 = "FromAxis"
								upv6()
							end

							if upv8 == 474807989 then
								continue
							end
							break
						end
					end

					if exitTo6 == 1 then
						upv6()
						exitTo3 = nil
						local exitTo8 = nil

						while true do
							childRemoved = v.ChildRemoved
							childRemoved2 = v.ChildRemoved
							upv3(childRemoved, childRemoved2)

							if nil then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
							end

							if not nil then
								upv4(3957289073, "RequestAsync")
								upv5 = "Enum"
								upv6()
							end

							connect2 = childRemoved.Connect
							connect3 = childRemoved.Connect
							v10 = upv1(connect2, "Connect")
							v20 = upv1(connect3, "Connect")
							upv3(connect2, connect3)

							if nil then
								upv4(-2, 0)
								upv5 = "PostAsync"
								upv6()
							end

							descendantAdded = v.DescendantAdded
							v5 = descendantAdded
							connect = descendantAdded.Connect
							v7 = bit32.bxor(v6, 1375590348)

							fn = function()
								upv1 = true
								bit32.bxor(upv2, 33167250)

								if nil then
									upv2 = bit32.bxor(upv2, 2590075543)
								end
							end

							v8 = bit32.bxor(n, 250982902)
							bit32.bxor(v7, v8)
							v9 = connect(v5, fn)
							local v25 = table.pack(bit32.band(v4, 4294967295))
							local v26 = table.pack(bit32.band(v10, 4294967295))
							local v27 = table.pack(bit32.band(v25[1], 65535))
							local v28 = table.pack(bit32.rshift(v25[1], 16))
							local v29 = table.pack(bit32.band(v26[1], 65535))
							v4 = bit32.band(
								v27[1] * v29[1]
									+ bit32.lshift(
										bit32.band(v27[1] * bit32.rshift(v26[1], 16) + v28[1] * v29[1], 65535),
										16
									),
								4294967295
							)

							if nil then
								exitTo8 = 1
								break
							else
								if not nil then
									upv4(38967837, 4)
									upv5 = 137063193
									upv6()
								end

								disconnect = v9.Disconnect
								v11 = upv1(disconnect, "Disconnect")
								bit32.bxor(v11, 313819569)

								if nil then
									bit32.bxor(v11, 2079815762)
								end

								v12 = upv2

								if v9 <= 59 then
									v12(disconnect, nil)
									disconnect(v9)

									if nil then
										upv4(38967837, 4)
										upv5 = 137063193
										upv6()
										n = n + upv8 - 227610726
									end

									v13 = upv1(childRemoved.Wait, "Wait")
									bit32.bxor(v13, 465099924)

									if nil then
										bit32.bxor(v13, 1619147085)
									end

									create = coroutine.create

									fn2 = function()
										local v30 = upv1
										local v31 = upv2

										if nil then
											upv3 = bit32.bxor(upv3, 388969805)
										end

										return (v30(v31))
									end

									bit32.bxor(bit32.bxor(v10, 178173754), v4 + 3027910902)
									v2 = create(fn2)
									v14, v15 = coroutine.resume(v2)
									v16 = v15
									v17 = upv7[not v14]
									n2 = v6 - n

									if v17 then
										flag = upv7[not v16]

										if not flag then
											v18 = coroutine.status(v2)
											flag = not upv3("suspended", v18)
										end

										if flag then
											upv4(38967837, 4)
											upv5 = 137063193
											upv6()
										end

										ok, result = pcall(coroutine.close, v2)
										name2 = result
										v19 = upv7
										v6 = bit32.band(n2, v20)
										v21 = v19[not ok]
										flag2 = not v21

										if v21 then
											exitTo8 = 3
											break
										else
											name2 = flag2

											if not name2 then
												v23 = coroutine.status(v2)
												name2 = not upv3("dead", v23)
											end

											exitTo4 = nil

											while true do
												if name2 then
													upv4(38967837, 4)
													upv5 = 137063193
													upv6()
												end

												v24 = getmetatable(v)
												upv3("The metatable is locked", v24)

												if not nil then
													upv4(3553874899, 1513060619)
													upv5 = "FromAxis"
													upv6()
												end

												if upv8 ~= 474807989 then
													exitTo4 = 1
													break
												else
													upv4(38967837, 4)
													upv5 = 137063193
													if v6 + 73262460 == 128884171 then
														continue
													end
												end

												break
											end

											if exitTo4 == 1 then
												exitTo8 = 4
												break
											else
												upv6()
												continue
											end
										end
									else
										exitTo8 = 2
										break
									end
								end
							end

							break
						end

						if exitTo8 == 1 then
							exitTo3 = 1

							if exitTo3 == 1 then
								exitTo9 = 14
								break
							elseif exitTo3 == 2 then
								exitTo9 = 15
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								upv3(name2, name)

								if not nil then
									upv4(2166136261, "wait")
									upv5 = "nfdnormalize"
									upv6()
								end
							else
								exitTo9 = 16
								break
							end
						elseif exitTo8 == 2 then
							exitTo3 = 2

							if exitTo3 == 1 then
								exitTo9 = 11
								break
							elseif exitTo3 == 2 then
								exitTo9 = 12
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								upv3(name2, name)

								if not nil then
									upv4(2166136261, "wait")
									upv5 = "nfdnormalize"
									upv6()
								end
							else
								exitTo9 = 13
								break
							end
						elseif exitTo8 == 3 then
							v22 = upv7

							if v6 == 137363747 then
								exitTo9 = 7
								break
							else
								exitTo3 = 3

								if exitTo3 == 1 then
									exitTo9 = 8
									break
								elseif exitTo3 == 2 then
									exitTo9 = 9
									break
								elseif exitTo3 == 3 then
									upv4(38967837, 4)
									upv5 = 137063193
									upv6()
									upv3(name2, name)

									if not nil then
										upv4(2166136261, "wait")
										upv5 = "nfdnormalize"
										upv6()
									end
								else
									exitTo9 = 10
									break
								end
							end
						elseif exitTo8 == 4 then
							exitTo3 = 4

							if exitTo3 == 1 then
								exitTo9 = 4
								break
							elseif exitTo3 == 2 then
								exitTo9 = 5
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								upv3(name2, name)

								if not nil then
									upv4(2166136261, "wait")
									upv5 = "nfdnormalize"
									upv6()
								end
							else
								exitTo9 = 6
								break
							end
						else
							exitTo9 = 3
							break
						end
					else
						exitTo9 = 2
						break
					end
				end
			else
				break
			end
		end

		local exitTo10

		if exitTo9 == 1 then
			exitTo3 = nil
			exitTo7 = nil

			while true do
				childRemoved = v.ChildRemoved
				childRemoved2 = v.ChildRemoved
				upv3(childRemoved, childRemoved2)

				if nil then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
				end

				if not nil then
					upv4(3957289073, "RequestAsync")
					upv5 = "Enum"
					upv6()
				end

				connect2 = childRemoved.Connect
				connect3 = childRemoved.Connect
				v10 = upv1(connect2, "Connect")
				v20 = upv1(connect3, "Connect")
				upv3(connect2, connect3)

				if nil then
					upv4(-2, 0)
					upv5 = "PostAsync"
					upv6()
				end

				descendantAdded = v.DescendantAdded
				v5 = descendantAdded
				connect = descendantAdded.Connect
				v7 = bit32.bxor(v6, 1375590348)

				fn = function()
					upv1 = true
					bit32.bxor(upv2, 33167250)

					if nil then
						upv2 = bit32.bxor(upv2, 2590075543)
					end
				end

				v8 = bit32.bxor(n, 250982902)
				bit32.bxor(v7, v8)
				v9 = connect(v5, fn)
				local v25 = table.pack(bit32.band(v4, 4294967295))
				local v26 = table.pack(bit32.band(v10, 4294967295))
				local v27 = table.pack(bit32.band(v25[1], 65535))
				local v28 = table.pack(bit32.rshift(v25[1], 16))
				local v29 = table.pack(bit32.band(v26[1], 65535))
				v4 = bit32.band(
					v27[1] * v29[1]
						+ bit32.lshift(bit32.band(v27[1] * bit32.rshift(v26[1], 16) + v28[1] * v29[1], 65535), 16),
					4294967295
				)

				if nil then
					exitTo7 = 1
					break
				else
					if not nil then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
					end

					disconnect = v9.Disconnect
					v11 = upv1(disconnect, "Disconnect")
					bit32.bxor(v11, 313819569)

					if nil then
						bit32.bxor(v11, 2079815762)
					end

					v12 = upv2

					if v9 <= 59 then
						v12(disconnect, nil)
						disconnect(v9)

						if nil then
							upv4(38967837, 4)
							upv5 = 137063193
							upv6()
							n = n + upv8 - 227610726
						end

						v13 = upv1(childRemoved.Wait, "Wait")
						bit32.bxor(v13, 465099924)

						if nil then
							bit32.bxor(v13, 1619147085)
						end

						create = coroutine.create

						fn2 = function()
							local v30 = upv1
							local v31 = upv2

							if nil then
								upv3 = bit32.bxor(upv3, 388969805)
							end

							return (v30(v31))
						end

						bit32.bxor(bit32.bxor(v10, 178173754), v4 + 3027910902)
						v2 = create(fn2)
						v14, v15 = coroutine.resume(v2)
						v16 = v15
						v17 = upv7[not v14]
						n2 = v6 - n

						if v17 then
							flag = upv7[not v16]

							if not flag then
								v18 = coroutine.status(v2)
								flag = not upv3("suspended", v18)
							end

							if flag then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
							end

							ok, result = pcall(coroutine.close, v2)
							name2 = result
							v19 = upv7
							v6 = bit32.band(n2, v20)
							v21 = v19[not ok]
							flag2 = not v21

							if v21 then
								exitTo7 = 3
								break
							else
								name2 = flag2

								if not name2 then
									v23 = coroutine.status(v2)
									name2 = not upv3("dead", v23)
								end

								exitTo4 = nil

								while true do
									if name2 then
										upv4(38967837, 4)
										upv5 = 137063193
										upv6()
									end

									v24 = getmetatable(v)
									upv3("The metatable is locked", v24)

									if not nil then
										upv4(3553874899, 1513060619)
										upv5 = "FromAxis"
										upv6()
									end

									if upv8 ~= 474807989 then
										exitTo4 = 1
										break
									else
										upv4(38967837, 4)
										upv5 = 137063193
										if v6 + 73262460 == 128884171 then
											continue
										end
									end

									break
								end

								if exitTo4 == 1 then
									exitTo7 = 4
									break
								else
									upv6()
									continue
								end
							end
						else
							exitTo7 = 2
							break
						end
					end
				end

				break
			end

			if exitTo7 == 1 then
				exitTo3 = 1

				if exitTo3 == 1 then
					exitTo11 = 8
					break
				elseif exitTo3 == 2 then
					exitTo11 = 9
					break
				elseif exitTo3 == 3 then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
					continue
				else
					exitTo11 = 10
					break
				end
			elseif exitTo7 == 2 then
				exitTo3 = 2

				if exitTo3 == 1 then
					exitTo11 = 8
					break
				elseif exitTo3 == 2 then
					exitTo11 = 9
					break
				elseif exitTo3 == 3 then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
					continue
				else
					exitTo11 = 10
					break
				end
			elseif exitTo7 == 3 then
				v22 = upv7

				if v6 == 137363747 then
					name2 = not v22[not name2]

					if not name2 then
						v23 = coroutine.status(v2)
						name2 = not upv3("dead", v23)
					end

					exitTo4 = nil

					while true do
						if name2 then
							upv4(38967837, 4)
							upv5 = 137063193
							upv6()
						end

						v24 = getmetatable(v)
						upv3("The metatable is locked", v24)

						if not nil then
							upv4(3553874899, 1513060619)
							upv5 = "FromAxis"
							upv6()
						end

						if upv8 ~= 474807989 then
							exitTo4 = 1
							break
						else
							upv4(38967837, 4)
							upv5 = 137063193
							if v6 + 73262460 == 128884171 then
								continue
							end
						end

						break
					end

					if exitTo4 == 1 then
						exitTo3 = 4

						if exitTo3 == 1 then
							exitTo11 = 8
							break
						elseif exitTo3 == 2 then
							exitTo11 = 9
							break
						elseif exitTo3 == 3 then
							upv4(38967837, 4)
							upv5 = 137063193
							upv6()
							continue
						else
							exitTo11 = 10
							break
						end
					else
						upv6()
						exitTo10 = nil

						while true do
							exitTo7 = nil

							while true do
								childRemoved = v.ChildRemoved
								childRemoved2 = v.ChildRemoved
								upv3(childRemoved, childRemoved2)

								if nil then
									upv4(38967837, 4)
									upv5 = 137063193
									upv6()
								end

								if not nil then
									upv4(3957289073, "RequestAsync")
									upv5 = "Enum"
									upv6()
								end

								connect2 = childRemoved.Connect
								connect3 = childRemoved.Connect
								v10 = upv1(connect2, "Connect")
								v20 = upv1(connect3, "Connect")
								upv3(connect2, connect3)

								if nil then
									upv4(-2, 0)
									upv5 = "PostAsync"
									upv6()
								end

								descendantAdded = v.DescendantAdded
								v5 = descendantAdded
								connect = descendantAdded.Connect
								v7 = bit32.bxor(v6, 1375590348)

								fn = function()
									upv1 = true
									bit32.bxor(upv2, 33167250)

									if nil then
										upv2 = bit32.bxor(upv2, 2590075543)
									end
								end

								v8 = bit32.bxor(n, 250982902)
								bit32.bxor(v7, v8)
								v9 = connect(v5, fn)
								local v25 = table.pack(bit32.band(v4, 4294967295))
								local v26 = table.pack(bit32.band(v10, 4294967295))
								local v27 = table.pack(bit32.band(v25[1], 65535))
								local v28 = table.pack(bit32.rshift(v25[1], 16))
								local v29 = table.pack(bit32.band(v26[1], 65535))
								v4 = bit32.band(
									v27[1] * v29[1]
										+ bit32.lshift(
											bit32.band(v27[1] * bit32.rshift(v26[1], 16) + v28[1] * v29[1], 65535),
											16
										),
									4294967295
								)

								if nil then
									exitTo7 = 1
									break
								else
									if not nil then
										upv4(38967837, 4)
										upv5 = 137063193
										upv6()
									end

									disconnect = v9.Disconnect
									v11 = upv1(disconnect, "Disconnect")
									bit32.bxor(v11, 313819569)

									if nil then
										bit32.bxor(v11, 2079815762)
									end

									v12 = upv2

									if v9 <= 59 then
										v12(disconnect, nil)
										disconnect(v9)

										if nil then
											upv4(38967837, 4)
											upv5 = 137063193
											upv6()
											n = n + upv8 - 227610726
										end

										v13 = upv1(childRemoved.Wait, "Wait")
										bit32.bxor(v13, 465099924)

										if nil then
											bit32.bxor(v13, 1619147085)
										end

										create = coroutine.create

										fn2 = function()
											local v30 = upv1
											local v31 = upv2

											if nil then
												upv3 = bit32.bxor(upv3, 388969805)
											end

											return (v30(v31))
										end

										bit32.bxor(bit32.bxor(v10, 178173754), v4 + 3027910902)
										v2 = create(fn2)
										v14, v15 = coroutine.resume(v2)
										v16 = v15
										v17 = upv7[not v14]
										n2 = v6 - n

										if v17 then
											flag = upv7[not v16]

											if not flag then
												v18 = coroutine.status(v2)
												flag = not upv3("suspended", v18)
											end

											if flag then
												upv4(38967837, 4)
												upv5 = 137063193
												upv6()
											end

											ok, result = pcall(coroutine.close, v2)
											name2 = result
											v19 = upv7
											v6 = bit32.band(n2, v20)
											v21 = v19[not ok]
											flag2 = not v21

											if v21 then
												exitTo7 = 3
												break
											else
												name2 = flag2

												if not name2 then
													v23 = coroutine.status(v2)
													name2 = not upv3("dead", v23)
												end

												exitTo4 = nil

												while true do
													if name2 then
														upv4(38967837, 4)
														upv5 = 137063193
														upv6()
													end

													v24 = getmetatable(v)
													upv3("The metatable is locked", v24)

													if not nil then
														upv4(3553874899, 1513060619)
														upv5 = "FromAxis"
														upv6()
													end

													if upv8 ~= 474807989 then
														exitTo4 = 1
														break
													else
														upv4(38967837, 4)
														upv5 = 137063193
														if v6 + 73262460 == 128884171 then
															continue
														end
													end

													break
												end

												if exitTo4 == 1 then
													exitTo7 = 4
													break
												else
													upv6()
													continue
												end
											end
										else
											exitTo7 = 2
											break
										end
									end
								end

								break
							end

							if exitTo7 == 1 then
								exitTo10 = 1
								break
							elseif exitTo7 == 2 then
								exitTo10 = 2
								break
							elseif exitTo7 == 3 then
								v22 = upv7

								if v6 == 137363747 then
									name2 = not v22[not name2]

									if not name2 then
										v23 = coroutine.status(v2)
										name2 = not upv3("dead", v23)
									end

									exitTo4 = nil

									while true do
										if name2 then
											upv4(38967837, 4)
											upv5 = 137063193
											upv6()
										end

										v24 = getmetatable(v)
										upv3("The metatable is locked", v24)

										if not nil then
											upv4(3553874899, 1513060619)
											upv5 = "FromAxis"
											upv6()
										end

										if upv8 ~= 474807989 then
											exitTo4 = 1
											break
										else
											upv4(38967837, 4)
											upv5 = 137063193
											if v6 + 73262460 == 128884171 then
												continue
											end
										end

										break
									end

									if exitTo4 == 1 then
										exitTo10 = 4
										break
									else
										upv6()
										continue
									end
								else
									exitTo10 = 3
									break
								end
							end

							break
						end

						if exitTo10 == 1 then
							exitTo3 = 1

							if exitTo3 == 1 then
								exitTo11 = 8
								break
							elseif exitTo3 == 2 then
								exitTo11 = 9
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								continue
							else
								exitTo11 = 10
								break
							end
						elseif exitTo10 == 2 then
							exitTo3 = 2

							if exitTo3 == 1 then
								exitTo11 = 8
								break
							elseif exitTo3 == 2 then
								exitTo11 = 9
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								continue
							else
								exitTo11 = 10
								break
							end
						elseif exitTo10 == 3 then
							exitTo3 = 3

							if exitTo3 == 1 then
								exitTo11 = 8
								break
							elseif exitTo3 == 2 then
								exitTo11 = 9
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								continue
							else
								exitTo11 = 10
								break
							end
						elseif exitTo10 == 4 then
							exitTo3 = 4

							if exitTo3 == 1 then
								exitTo11 = 8
								break
							elseif exitTo3 == 2 then
								exitTo11 = 9
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								continue
							else
								exitTo11 = 10
								break
							end
						elseif exitTo7 == 4 then
							exitTo3 = 4

							if exitTo3 == 1 then
								exitTo11 = 8
								break
							elseif exitTo3 == 2 then
								exitTo11 = 9
								break
							elseif exitTo3 == 3 then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
								continue
							else
								exitTo11 = 10
								break
							end
						elseif exitTo3 == 1 then
							exitTo11 = 8
							break
						elseif exitTo3 == 2 then
							exitTo11 = 9
							break
						elseif exitTo3 == 3 then
							upv4(38967837, 4)
							upv5 = 137063193
							upv6()
							continue
						else
							exitTo11 = 10
							break
						end
					end
				else
					exitTo3 = 3

					if exitTo3 == 1 then
						exitTo11 = 8
						break
					elseif exitTo3 == 2 then
						exitTo11 = 9
						break
					elseif exitTo3 == 3 then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
						continue
					else
						exitTo11 = 10
						break
					end
				end
			elseif exitTo7 == 4 then
				exitTo3 = 4

				if exitTo3 == 1 then
					exitTo11 = 8
					break
				elseif exitTo3 == 2 then
					exitTo11 = 9
					break
				elseif exitTo3 == 3 then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
					continue
				else
					exitTo11 = 10
					break
				end
			elseif exitTo3 == 1 then
				exitTo11 = 8
				break
			elseif exitTo3 == 2 then
				exitTo11 = 9
				break
			elseif exitTo3 == 3 then
				upv4(38967837, 4)
				upv5 = 137063193
				upv6()
				continue
			else
				exitTo11 = 10
				break
			end
		elseif exitTo9 == 2 then
			exitTo11 = 1
			break
		elseif exitTo9 == 3 then
			if exitTo3 == 1 then
				exitTo11 = 5
				break
			elseif exitTo3 == 2 then
				exitTo11 = 6
				break
			elseif exitTo3 == 3 then
				upv4(38967837, 4)
				upv5 = 137063193
				upv6()
				continue
			else
				exitTo11 = 7
				break
			end
		elseif exitTo9 == 4 then
			exitTo11 = 2
			break
		elseif exitTo9 == 5 then
			exitTo11 = 3
			break
		elseif exitTo9 == 6 then
			exitTo11 = 4
			break
		elseif exitTo9 == 7 then
			name2 = not v22[not name2]

			if not name2 then
				v23 = coroutine.status(v2)
				name2 = not upv3("dead", v23)
			end

			exitTo4 = nil

			while true do
				if name2 then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
				end

				v24 = getmetatable(v)
				upv3("The metatable is locked", v24)

				if not nil then
					upv4(3553874899, 1513060619)
					upv5 = "FromAxis"
					upv6()
				end

				if upv8 ~= 474807989 then
					exitTo4 = 1
					break
				else
					upv4(38967837, 4)
					upv5 = 137063193
					if v6 + 73262460 == 128884171 then
						continue
					end
				end

				break
			end

			if exitTo4 == 1 then
				exitTo3 = 4

				if exitTo3 == 1 then
					exitTo11 = 8
					break
				elseif exitTo3 == 2 then
					exitTo11 = 9
					break
				elseif exitTo3 == 3 then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
					continue
				else
					exitTo11 = 10
					break
				end
			else
				upv6()
				exitTo10 = nil

				while true do
					exitTo7 = nil

					while true do
						childRemoved = v.ChildRemoved
						childRemoved2 = v.ChildRemoved
						upv3(childRemoved, childRemoved2)

						if nil then
							upv4(38967837, 4)
							upv5 = 137063193
							upv6()
						end

						if not nil then
							upv4(3957289073, "RequestAsync")
							upv5 = "Enum"
							upv6()
						end

						connect2 = childRemoved.Connect
						connect3 = childRemoved.Connect
						v10 = upv1(connect2, "Connect")
						v20 = upv1(connect3, "Connect")
						upv3(connect2, connect3)

						if nil then
							upv4(-2, 0)
							upv5 = "PostAsync"
							upv6()
						end

						descendantAdded = v.DescendantAdded
						v5 = descendantAdded
						connect = descendantAdded.Connect
						v7 = bit32.bxor(v6, 1375590348)

						fn = function()
							upv1 = true
							bit32.bxor(upv2, 33167250)

							if nil then
								upv2 = bit32.bxor(upv2, 2590075543)
							end
						end

						v8 = bit32.bxor(n, 250982902)
						bit32.bxor(v7, v8)
						v9 = connect(v5, fn)
						local v25 = table.pack(bit32.band(v4, 4294967295))
						local v26 = table.pack(bit32.band(v10, 4294967295))
						local v27 = table.pack(bit32.band(v25[1], 65535))
						local v28 = table.pack(bit32.rshift(v25[1], 16))
						local v29 = table.pack(bit32.band(v26[1], 65535))
						v4 = bit32.band(
							v27[1] * v29[1]
								+ bit32.lshift(
									bit32.band(v27[1] * bit32.rshift(v26[1], 16) + v28[1] * v29[1], 65535),
									16
								),
							4294967295
						)

						if nil then
							exitTo7 = 1
							break
						else
							if not nil then
								upv4(38967837, 4)
								upv5 = 137063193
								upv6()
							end

							disconnect = v9.Disconnect
							v11 = upv1(disconnect, "Disconnect")
							bit32.bxor(v11, 313819569)

							if nil then
								bit32.bxor(v11, 2079815762)
							end

							v12 = upv2

							if v9 <= 59 then
								v12(disconnect, nil)
								disconnect(v9)

								if nil then
									upv4(38967837, 4)
									upv5 = 137063193
									upv6()
									n = n + upv8 - 227610726
								end

								v13 = upv1(childRemoved.Wait, "Wait")
								bit32.bxor(v13, 465099924)

								if nil then
									bit32.bxor(v13, 1619147085)
								end

								create = coroutine.create

								fn2 = function()
									local v30 = upv1
									local v31 = upv2

									if nil then
										upv3 = bit32.bxor(upv3, 388969805)
									end

									return (v30(v31))
								end

								bit32.bxor(bit32.bxor(v10, 178173754), v4 + 3027910902)
								v2 = create(fn2)
								v14, v15 = coroutine.resume(v2)
								v16 = v15
								v17 = upv7[not v14]
								n2 = v6 - n

								if v17 then
									flag = upv7[not v16]

									if not flag then
										v18 = coroutine.status(v2)
										flag = not upv3("suspended", v18)
									end

									if flag then
										upv4(38967837, 4)
										upv5 = 137063193
										upv6()
									end

									ok, result = pcall(coroutine.close, v2)
									name2 = result
									v19 = upv7
									v6 = bit32.band(n2, v20)
									v21 = v19[not ok]
									flag2 = not v21

									if v21 then
										exitTo7 = 3
										break
									else
										name2 = flag2

										if not name2 then
											v23 = coroutine.status(v2)
											name2 = not upv3("dead", v23)
										end

										exitTo4 = nil

										while true do
											if name2 then
												upv4(38967837, 4)
												upv5 = 137063193
												upv6()
											end

											v24 = getmetatable(v)
											upv3("The metatable is locked", v24)

											if not nil then
												upv4(3553874899, 1513060619)
												upv5 = "FromAxis"
												upv6()
											end

											if upv8 ~= 474807989 then
												exitTo4 = 1
												break
											else
												upv4(38967837, 4)
												upv5 = 137063193
												if v6 + 73262460 == 128884171 then
													continue
												end
											end

											break
										end

										if exitTo4 == 1 then
											exitTo7 = 4
											break
										else
											upv6()
											continue
										end
									end
								else
									exitTo7 = 2
									break
								end
							end
						end

						break
					end

					if exitTo7 == 1 then
						exitTo10 = 1
						break
					elseif exitTo7 == 2 then
						exitTo10 = 2
						break
					elseif exitTo7 == 3 then
						v22 = upv7

						if v6 == 137363747 then
							name2 = not v22[not name2]

							if not name2 then
								v23 = coroutine.status(v2)
								name2 = not upv3("dead", v23)
							end

							exitTo4 = nil

							while true do
								if name2 then
									upv4(38967837, 4)
									upv5 = 137063193
									upv6()
								end

								v24 = getmetatable(v)
								upv3("The metatable is locked", v24)

								if not nil then
									upv4(3553874899, 1513060619)
									upv5 = "FromAxis"
									upv6()
								end

								if upv8 ~= 474807989 then
									exitTo4 = 1
									break
								else
									upv4(38967837, 4)
									upv5 = 137063193
									if v6 + 73262460 == 128884171 then
										continue
									end
								end

								break
							end

							if exitTo4 == 1 then
								exitTo10 = 4
								break
							else
								upv6()
								continue
							end
						else
							exitTo10 = 3
							break
						end
					end

					break
				end

				if exitTo10 == 1 then
					exitTo3 = 1

					if exitTo3 == 1 then
						exitTo11 = 8
						break
					elseif exitTo3 == 2 then
						exitTo11 = 9
						break
					elseif exitTo3 == 3 then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
						continue
					else
						exitTo11 = 10
						break
					end
				elseif exitTo10 == 2 then
					exitTo3 = 2

					if exitTo3 == 1 then
						exitTo11 = 8
						break
					elseif exitTo3 == 2 then
						exitTo11 = 9
						break
					elseif exitTo3 == 3 then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
						continue
					else
						exitTo11 = 10
						break
					end
				elseif exitTo10 == 3 then
					exitTo3 = 3

					if exitTo3 == 1 then
						exitTo11 = 8
						break
					elseif exitTo3 == 2 then
						exitTo11 = 9
						break
					elseif exitTo3 == 3 then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
						continue
					else
						exitTo11 = 10
						break
					end
				elseif exitTo10 == 4 then
					exitTo3 = 4

					if exitTo3 == 1 then
						exitTo11 = 8
						break
					elseif exitTo3 == 2 then
						exitTo11 = 9
						break
					elseif exitTo3 == 3 then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
						continue
					else
						exitTo11 = 10
						break
					end
				elseif exitTo7 == 4 then
					exitTo3 = 4

					if exitTo3 == 1 then
						exitTo11 = 8
						break
					elseif exitTo3 == 2 then
						exitTo11 = 9
						break
					elseif exitTo3 == 3 then
						upv4(38967837, 4)
						upv5 = 137063193
						upv6()
						continue
					else
						exitTo11 = 10
						break
					end
				elseif exitTo3 == 1 then
					exitTo11 = 8
					break
				elseif exitTo3 == 2 then
					exitTo11 = 9
					break
				elseif exitTo3 == 3 then
					upv4(38967837, 4)
					upv5 = 137063193
					upv6()
					continue
				else
					exitTo11 = 10
					break
				end
			end
		end

		break
	end

	if exitTo11 == 1 then
		exitTo5 = 1
	elseif exitTo11 == 2 then
		exitTo5 = 2
	elseif exitTo11 == 3 then
		exitTo5 = 3
	elseif exitTo11 == 4 then
		exitTo5 = 4
	elseif exitTo11 == 5 then
		exitTo5 = 2
	elseif exitTo11 == 6 then
		exitTo5 = 3
	elseif exitTo11 == 7 then
		exitTo5 = 4
	elseif exitTo11 == 8 then
		exitTo5 = 2
	elseif exitTo11 == 9 then
		exitTo5 = 3
	elseif exitTo11 == 10 then
		exitTo5 = 4
	elseif exitTo9 == 8 then
		exitTo5 = 2
	elseif exitTo9 == 9 then
		exitTo5 = 3
	elseif exitTo9 == 10 then
		exitTo5 = 4
	elseif exitTo9 == 11 then
		exitTo5 = 2
	elseif exitTo9 == 12 then
		exitTo5 = 3
	elseif exitTo9 == 13 then
		exitTo5 = 4
	elseif exitTo9 == 14 then
		exitTo5 = 2
	elseif exitTo9 == 15 then
		exitTo5 = 3
	elseif exitTo9 == 16 then
		exitTo5 = 4
	end

	if exitTo5 ~= 1 then
		if exitTo5 == 2 then
			upv4(38967837, 4)
			upv5 = 137063193
			bit32.band(2, nil)
			error("devirt: corrupt/encrypted register store 1439 (at 59:600)")
		end

		if exitTo5 == 3 then
			error("devirt: symbolic value store into proto array (at 59:770)")
		end

		if exitTo5 ~= 4 then
			upv4("IsServer", false)
			upv5 = "GetTangentOnCurve"
			error("devirt: symbolic value store into proto array (at 59:81)")
		end

		if exitTo3 ~= 4 then
			error("devirt: index b'FromName' (at 59:60)")
		end
	end

	return
end

error("devirt: symbolic value store into proto array (at 59:920)")