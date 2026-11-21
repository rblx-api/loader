do
	local env=type(getgenv)=="function"and getgenv()or _G
	local prior=env.ElysiumEarlyOptimizer
	if not prior or prior.game~=game or prior.world~=workspace then
		local api={game=game,world=workspace,mode="aa",saved=setmetatable({},{__mode="k"})}
		env.ElysiumEarlyOptimizer,_G.ElysiumEarlyOptimizer=api,api
		local function set(object,property,value)
			local values=api.saved[object]
			if not values then values={};api.saved[object]=values end
			if values[property]==nil then values[property]={object[property]}end
			object[property]=value
		end
		local function characterPart(object)
			local node=object
			while node and node~=workspace do
				if node:IsA("Tool")or node:FindFirstChildOfClass("Humanoid")then return true end
				node=node.Parent
			end
			return false
		end
		local function materialsOn()
			return env.ElysiumOptimizerMaterials==true or _G.ElysiumOptimizerMaterials==true
		end
		local function applyObject(object)
			if api.mode~="default"or not materialsOn()then return end
			if object:IsA("BillboardGui")and(object.Name=="ElysiumDeliveryPrediction"or object.Name=="ElysiumActiveThiefBase")then
				set(object,"Enabled",false)
			elseif object:IsA("BasePart")and not characterPart(object)then
				set(object,"CastShadow",false)
				set(object,"Reflectance",0)
				set(object,"Material",Enum.Material.SmoothPlastic)
			elseif object:IsA("Decal")or object:IsA("Texture")then
				if not characterPart(object)then set(object,"Transparency",1)end
			elseif object:IsA("ParticleEmitter")or object:IsA("Trail")or object:IsA("Beam")then
				if not characterPart(object)then set(object,"Enabled",false)end
			end
		end
		function api.Apply(mode)
			api.mode=mode=="default"and"default"or"aa"
			_G.ElysiumOptimizerMode=api.mode
			local pass=(api.pass or 0)+1
			api.pass=pass
			local canYield=coroutine.isyieldable()and(api.started==true or api.deferFirst==true)
			local budget=0
			local function tick()
				if not canYield then return true end
				budget=budget+1
				if budget>=2500 then
					budget=0
					task.wait()
					if api.pass~=pass then return false end
				end
				return true
			end
			if api.mode=="default"then
				set(game:GetService("Lighting"),"GlobalShadows",false)
				if materialsOn()then
					for _,object in ipairs(workspace:GetDescendants())do
						pcall(applyObject,object)
						if not tick()then return end
					end
				end
			else
				for object,values in pairs(api.saved)do
					for property,value in pairs(values)do pcall(function()object[property]=value[1]end)end
					if not tick()then return end
				end
			end
			api.started=true
		end
		workspace.DescendantAdded:Connect(function(object)pcall(applyObject,object)end)
		local mode=_G.ElysiumOptimizerMode or"aa"
		if type(readfile)=="function"then
			local ok,settings=pcall(function()return game:GetService("HttpService"):JSONDecode(readfile("SideTP.json"))end)
			if ok and type(settings)=="table"and settings.optimizerMode then mode=settings.optimizerMode end
		end
		api.mode=mode=="default"and"default"or"aa"
		_G.ElysiumOptimizerMode=api.mode
		if env.ElysiumOptimizerSyncFirst==true or _G.ElysiumOptimizerSyncFirst==true then
			api.Apply(mode)
		else
			api.deferFirst=true
			task.spawn(function()
				api.Apply(mode)
				api.started=true
			end)
		end
	end
end
local function ElysiumChannels()
	local env=type(getgenv)=="function"and getgenv()or _G
	local bridge=env.ElysiumDataBridge or _G.ElysiumDataBridge
	if not bridge or bridge.game~=game or bridge.workspace~=workspace then return nil end
	local view=bridge.channels
	if not view then view={};bridge.channels=view end
	for name,data in pairs(bridge.plots)do
		local key=tostring(name)
		if type(data)=="table"then
			local channel=view[key]
			if not channel then
				channel={Index=key}
				function channel:Get(field)return self.CacheTable[field]end
				view[key]=channel
			end
			channel.CacheTable=data
		end
	end
	for name in pairs(view)do
		if type(bridge.plots[name])~="table"then view[name]=nil end
	end
	_G.ElysiumSyncDiag="loader live channels"
	return view
end
local function ElysiumService(name)
	local env=type(getgenv)=="function"and getgenv()or _G
	local runtime=env.ElysiumRuntime or _G.ElysiumRuntime
	if runtime and runtime.game==game and runtime.workspace==workspace then
		return runtime.Service(name)
	end
	return game:FindFirstChildOfClass(name)or game:GetService(name)
end
local print,warn=function()end,function()end
if not game:IsLoaded()then
	game.Loaded:Wait()
end
local __elysiumMainSameGame=(_G.ElysiumMainLoadedGame==game)and(_G.ElysiumMainLoadedWorkspace==workspace)
if _G.ElysiumMainInstanceLoaded and __elysiumMainSameGame then
	return
end
_G.ElysiumMainInstanceLoaded=true
_G.ElysiumMainLoadedGame=game
_G.ElysiumMainLoadedWorkspace=workspace
if _G.ElysiumSourceStealPanelAPI and _G.ElysiumSourceStealPanelAPI.Destroy then
	pcall(_G.ElysiumSourceStealPanelAPI.Destroy)
end
_G.ElysiumSourceStealActive=false
local _gameLoadAt=os.clock()
_G.ElysiumInvisAuto=_G.ElysiumInvisAuto==true
_G.ElysiumAutoKickOnSteal,_G.ElysiumAutoBuy=false,false
_G.ElysiumStealMode=_G.ElysiumStealMode or"priority"
_G.ElysiumOptimizerMode=_G.ElysiumOptimizerMode or"aa"
do
	local lighting=ElysiumService("Lighting")
	local shadows=lighting.GlobalShadows
	_G.ElysiumApplyOptimizerBase=function(mode)
		if _G.ElysiumEarlyOptimizer then _G.ElysiumEarlyOptimizer.Apply(mode);return end
		if mode=="default"then lighting.GlobalShadows=false
		else lighting.GlobalShadows=shadows end
	end
end
_G.ElysiumAutoTP=(_G.ElysiumAutoTP==nil)and true or _G.ElysiumAutoTP
local _profOut=
	{"ElysiumPanelScanGap","ElysiumRepickGap","ElysiumInRangeGap","ElysiumWatchdogTick","ElysiumSyncScanGap","ElysiumAutoTPPoll"}
local _profSfx={"PanelGap","RepickGap","InRangeGap","WatchdogTick","SyncGap","TPPoll"}
_G.ElysiumScanProfile=function(mode)
	local boost=(mode=="fast")
	local tag=boost and"ElysiumFast"or"ElysiumNorm"
	local fb=boost and{.15,.1,.1,.15,.1,.03}or{.25,.25,.2,.2,.15,.03}
	_G.ElysiumScanMode=boost and"fast"or"normal"
	for i=1,6 do
		_G[_profOut[i]]=tonumber(_G[tag.._profSfx[i]])or fb[i]
	end
end
_G.ElysiumScanProfile("fast")
task.spawn(function()
	if not game:IsLoaded()then
		game.Loaded:Wait()
	end
	task.wait(tonumber(_G.ElysiumFastWindow)or 60)
	if _G.ElysiumScanMode=="fast"then
		_G.ElysiumScanProfile("normal")
	end
end)
task.spawn(function()
	if not game:IsLoaded()then
		game.Loaded:Wait()
	end
	task.wait(tonumber(_G.ElysiumFpsCapDelay)or 1.5)
	pcall(function()
		if setfpscap then
			setfpscap(9999)
		end
	end)
end)
task.spawn(function()
	local ws=ElysiumService("Workspace")
	if not ws.StreamingEnabled then
		return
	end
	local hb=ElysiumService("RunService")
	local me=ElysiumService("Players").LocalPlayer
	local area,limit=nil,os.clock()+15
	repeat
		area=ws:FindFirstChild("Plots")
		if not area then
			hb.Heartbeat:Wait()
		end
	until area or os.clock()>limit
	if not area then
		return
	end
	local function pivotOf(plot)
		local ok,pv=pcall(function()
			return plot:GetPivot().Position
		end)
		if ok and pv and pv.Magnitude>1 then
			return pv
		end
		if plot.PrimaryPart then
			return plot.PrimaryPart.Position
		end
		local bp=plot:FindFirstChildWhichIsA("BasePart",true)
		return bp and bp.Position or nil
	end
	local left=0
	for _,plot in ipairs(area:GetChildren())do
		local where=pivotOf(plot)
		if where then
			left=left+1
			task.spawn(function()
				pcall(function()
					me:RequestStreamAroundAsync(where)
				end)
				left=left-1
			end)
		end
	end
	local stopAt=os.clock()+3
	while left>0 and os.clock()<stopAt do
		task.wait(.03)
	end
end)
_G.ElysiumBootDelay=tonumber(_G.ElysiumBootDelay)or .3
if _G.ElysiumWaitForTools==nil then
	_G.ElysiumWaitForTools=true
end
_G.ElysiumToolWait=tonumber(_G.ElysiumToolWait)or 6
do
	local _since=os.clock()
	local _gear={"Flying Carpet","Waverider","Santa's Sleigh","Witch's Broom","Cupid's Wings","Grapple Hook",}
	local _has={}
	for _,n in ipairs(_gear)do
		_has[n]=true
	end
	local function _inBox(box,want)
		if not box then
			return false
		end
		for _,t in ipairs(box:GetChildren())do
			if t:IsA("Tool")and(t.Name==want or _has[t.Name])then
				return true
			end
		end
		return false
	end
	local function _gearReady()
		local plr=ElysiumService("Players").LocalPlayer
		if not plr then
			return false
		end
		local want=(type(_G.ElysiumCarpetTool)=="string"and _G.ElysiumCarpetTool~="")and _G.ElysiumCarpetTool or nil
		return _inBox(plr.Character,want)or _inBox(plr:FindFirstChild("Backpack"),want)
	end
	_G.ElysiumToolsReady=_gearReady
	_G.ElysiumBootWait=function()
		local d=tonumber(_G.ElysiumBootDelay)or .3
		local cap=tonumber(_G.ElysiumToolWait)or 6
		local want=(_G.ElysiumWaitForTools~=false)
		local t0=os.clock()
		while true do
			local ready=true
			if want then
				local ok,r=pcall(_gearReady)
				ready=(ok and r)and true or false
			end
			if ready and(os.clock()-_since)>=d then
				return
			end
			if os.clock()-t0>=cap then
				return
			end
			task.wait(tonumber(_G.ElysiumBootPoll)or .03)
		end
	end
end
_G.ElysiumPriVersion=_G.ElysiumPriVersion or 0
if type(_G.ElysiumPriorityDefault)~="table"then
	_G.ElysiumPriorityDefault={}
end
if type(_G.SHARED_PRIORITY_ITEMS)~="table"then
	_G.SHARED_PRIORITY_ITEMS={}
end
if type(_G.SHARED_MUTATION_PRIORITY)~="table"then
	_G.SHARED_MUTATION_PRIORITY={}
end
if type(_G.SHARED_TRAIT_PRIORITY)~="table"then
	_G.SHARED_TRAIT_PRIORITY={}
end
if type(_G.SHARED_MUTATION_DISABLED)~="table"then
	_G.SHARED_MUTATION_DISABLED={}
end
if LPH_OBFUSCATED==nil then
	local env=getfenv()
	env["LPH_NO_".."VIRTUALIZE"]=function(...)
		return...
	end
	env["LPH_JIT_".."MAX"]=function(...)
		return...
	end
end
do
	local _HS=ElysiumService("HttpService")
	local _TS=ElysiumService("TeleportService")
	_G.TEK_DEFAULT_CONFIG_JSON=
		[==[{"mutationList":["Bloodrot","Candy","Crystal","Cursed","Cyber","Diamond","Divine","Galaxy","Gold","Lava","Phantom","Radioactive","Rainbow","YinYang"],"traitList":["1 Year","10B","26",":3","Algeria","Argentina","Aura Shades","Australia","Austria","Ball","Bee","Belgium","Blue Balloon","Blue Egg","Bosnia and Herzegovina","Brazil","Bubblegum","Bull","Bunny Ears","Burger","Canada","Cape Verde","Chocolate","Claws","Colombia","Cometstruck","Croatia","Curacao","Czechia","DR Congo","Disco","Ecuador","Egypt","England","Explosive","Fire","Fire Bee","Fireworks","France","Galactic","Germany","Ghana","Glitched","Granny","Green Balloon","Green Egg","Haiti","Halo","Ice Bee","Indonesia","Iran","Iraq","Ivory Coast","Jackolantern Pet","Japan","Job Application","John Pork","Jordan","Lightning","Lucky","Matteo Hat","Meowl","Mexico","Morocco","Netherlands","New Zealand","Norway","Nyan","Orange Balloon","Orange Egg","Paint","Panama","Paraguay","Pink Balloon","Pink Egg","Portugal","Qatar","Queen Bee","RIP Gravestone","Rainbow Balloon","Red Balloon","Reindeer Pet","Rose","Santa Hat","Saudi Arabia","Scotland","Senegal","Shark Fin","Skeleton","Skibidi","Sleepy","Snowy","Sombrero","South Africa","South Korea","Spain","Spider","Strawberry","Sun","Sweden","Switzerland","Taco","Tie","Tunisia","Turkey","UFO","United States","Uruguay","Uzbekistan","Wet","Witch Hat","Zombie"],"alertSound":"111786441593851","stealLead":0.07,"exX":1977,"landingDelay":0.15000000000000002,"infJump":true,"invisAngle":216,"xray":true,"goSpeed":220,"faceAway":false,"antiBee":true,"cframeSpeed":450,"stealFireKey":"LeftAlt","autoKickOnSteal":false,"invisDepth":10,"cloneKey":"V","autoBuyRange":17,"antiFlash":true,"autoBuyHover":9,"resetKey":"X","closeSpeed":300,"stealMode":"priority","dropKey":"G","priAlert":false,"nearestKey":"F","faceAwayNearest":false,"exY":355,"autoSteal":true,"priorityList":["Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl","Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio","Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros","Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal","Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino","Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros","Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero","Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers","Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro","Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch","Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon","Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah","Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos","Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso","Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas","Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros","Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion","Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande","Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta","Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti","Los Bros","Gobblino Uniciciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis","Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande","Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67","Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito","Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy","Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni","Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda","Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion","Esok Sekolah"],"grabBeforeKick":true,"carpetStrict":true,"autoBuy":false,"psLink":"","antiDie":false,"carpetSpeedValue":120,"alertMinGen":80000000,"tpVelocity":550,"panelY":457,"invisAuto":true,"autoTp":true,"kickToPS":false,"faceAwayDelay":2,"climbSpeed":100,"carpetTool":"Waverider","carpetSpeedKey":"Q","stealQuickKey":"C","panelX":1068}]==]
	local DEFAULT_CONFIG
	pcall(function()
		DEFAULT_CONFIG=_HS:JSONDecode(_G.TEK_DEFAULT_CONFIG_JSON)
	end)
	local fileData,tpData
	if readfile then
		pcall(function()
			local raw=readfile("SideTP.json")
			if type(raw)=="string"and#raw>0 then
				fileData=_HS:JSONDecode(raw)
			end
		end)
	end
	pcall(function()
		local td=_TS:GetLocalPlayerTeleportData()
		if td and td.SideTP then
			tpData=td.SideTP
		end
	end)
	local merged={}
	if type(DEFAULT_CONFIG)=="table"then
		for k,v in pairs(DEFAULT_CONFIG)do
			merged[k]=v
		end
	end
	if type(tpData)=="table"then
		for k,v in pairs(tpData)do
			merged[k]=v
		end
	end
	if type(fileData)=="table"then
		for k,v in pairs(fileData)do
			merged[k]=v
		end
	end
	if type(merged.tpDelay)=="number"then
		_G._stp_tpDelay=merged.tpDelay
	end
	if merged.tpMotionDriver=="carpet-speed-v1"then
		_G.TPVelocity=math.clamp(tonumber(merged.tpVelocity)or 200,50,750)
	else
		_G.TPVelocity=200
	end
	if type(merged.climbSpeed)=="number"then
		_G.ElysiumClimb=math.clamp(merged.climbSpeed,100,250)
	end
	if type(merged.cframeSpeed)=="number"then
		_G.ElysiumCFrameSpeed=math.clamp(merged.cframeSpeed,100,900)
	end
	if type(merged.cframeTP)=="boolean"then
		_G.ElysiumCFrameTP=merged.cframeTP
	end
	if type(merged.tweenTP)=="boolean"then
		_G.ElysiumTweenTP=merged.tweenTP
	end
	if type(merged.flingTp)=="boolean"then
		_G.ElysiumFlingTP=merged.flingTp
	end
	if type(merged.tweenNear)=="number"then
		_G.ElysiumTweenNear=math.clamp(merged.tweenNear,20,60)
	end
	if type(merged.tweenStage)=="number"then
		_G.ElysiumTweenStage=math.clamp(merged.tweenStage,3,40)
	end
	if type(merged.flashTP)=="boolean"then
		_G.ElysiumFlashTP=merged.flashTP
	end
	_G.ElysiumGoStyle=merged.goStyle=="smooth"and"smooth"or"source"
	_G.ElysiumGoApproachF2=merged.goApproachF2==true
	_G.trxPlatLife=math.clamp(tonumber(merged.goPlatformLife)or 2,.5,10)
	if type(merged.flashOrigin)=="table"then
		local p=merged.flashOrigin
		if type(p[1])=="number"and type(p[2])=="number"and type(p[3])=="number"then
			_G.ElysiumFlashOrigin=Vector3.new(p[1],p[2],p[3])
		end
	end
	if type(merged.flashFire)=="number"then
		_G.ElysiumFlashGroundWait=math.clamp(merged.flashFire,0,.25)
	end
	if type(merged.flashEquip)=="number"then
		_G.ElysiumFlashPreEquip=math.clamp(merged.flashEquip,0,60)
	end
	if type(merged.cframeStart)=="number"then
		_G.ElysiumCFrameStart=merged.cframeStart
	end
	if type(merged.cframeEnd)=="number"then
		_G.ElysiumCFrameEnd=merged.cframeEnd
	end
	if type(merged.carpetTool)=="string"then
		_G.ElysiumCarpetTool=merged.carpetTool
	end
	if type(merged.landingDelay)=="number"then
		_G.LandingDelay=math.clamp(merged.landingDelay,.01,1)
	end
	if type(merged.closeSpeed)=="number"then
		_G.ElysiumCloseSpeed=math.clamp(merged.closeSpeed,20,400)
	end
	if type(merged.preCloneSpeed)=="number"then
		_G.ElysiumPreCloneSpeed=math.clamp(merged.preCloneSpeed,40,250)
	end
	if type(merged.problemBaseSpeed)=="number"then
		_G.ElysiumProblemBaseSpeed=math.clamp(merged.problemBaseSpeed,20,400)
	end
	if type(merged.slowCrossRow)=="boolean"then
		_G.ElysiumSlowCrossRow=merged.slowCrossRow
	end
	if type(merged.stealLead)=="number"then
		_G.ElysiumStealLead=math.clamp(merged.stealLead,0,2)
	end
	if type(merged.autoGrabRadius)=="number"then
		_G.ElysiumAutoGrabRadius=math.clamp(merged.autoGrabRadius,10,150)
	end
	_G.ElysiumStealQuick=false
	if type(merged.stealQuickKey)=="string"then
		_G.ElysiumStealQuickKey=merged.stealQuickKey
	end
	if type(merged.stealFireKey)=="string"then
		_G.ElysiumStealFireKey=merged.stealFireKey
	end
	if type(merged.tpKey)=="string"then
		_G._stp_tpKeyName=merged.tpKey
	end
	if type(merged.nearestKey)=="string"then
		_G.ElysiumNearestKey=merged.nearestKey
	end
	if type(merged.prioritySoundID)=="string"then
		_G.ElysiumPrioritySoundID=merged.prioritySoundID
	end
	_G.ElysiumStealMode="priority"
	_G._stealUserOff=false
	if type(merged.priorityList)=="table"then
		local clean={}
		for _,v in ipairs(merged.priorityList)do
			if type(v)=="string"and v~=""then
				clean[#clean+1]=v
			end
		end
		if#clean>0 then
			local L=_G.SHARED_PRIORITY_ITEMS
			table.clear(L)
			for i=1,#clean do
				L[i]=clean[i]
			end
			_G.ElysiumPriVersion=_G.ElysiumPriVersion+1
		end
	end
	do
		local wanted="Gorillo Subwoofero"
		local wantedKey=wanted:lower():gsub("[%s%-_'%.]","")
		local L=_G.SHARED_PRIORITY_ITEMS
		local found=false
		for i=1,#L do
			if tostring(L[i]):lower():gsub("[%s%-_'%.]","")==wantedKey then
				found=true
				break
			end
		end
		if not found then
			table.insert(L,wanted)
			_G.ElysiumPriVersion=_G.ElysiumPriVersion+1
		end
	end
	if type(merged.priorityDefault)=="table"then
		local d={}
		for _,v in ipairs(merged.priorityDefault)do
			if type(v)=="string"and v~=""then
				d[#d+1]=v
			end
		end
		if#d>0 then
			_G.ElysiumPriorityDefault=d
		end
	end
	if type(merged.mutationList)=="table"then
		local clean={}
		for _,v in ipairs(merged.mutationList)do
			if type(v)=="string"and v~=""then
				local canonical=v:lower():gsub("[%s%-_]","")=="yinyang"and"Yin Yang"or v
				clean[#clean+1]=canonical
			end
		end
		if#clean>0 then
			local L=_G.SHARED_MUTATION_PRIORITY
			table.clear(L)
			for i=1,#clean do
				L[i]=clean[i]
			end
		end
	end
	if type(merged.mutationDisabled)=="table"then
		local D=_G.SHARED_MUTATION_DISABLED
		table.clear(D)
		for _,v in ipairs(merged.mutationDisabled)do
			if type(v)=="string"and v~=""then
				local canonical=v:lower():gsub("[%s%-_]","")=="yinyang"and"Yin Yang"or v
				D[canonical]=true
			end
		end
	end
	if type(merged.traitList)=="table"then
		local clean={}
		for _,v in ipairs(merged.traitList)do
			if type(v)=="string"and v~=""then
				clean[#clean+1]=v
			end
		end
		if#clean>0 then
			local L=_G.SHARED_TRAIT_PRIORITY
			table.clear(L)
			for i=1,#clean do
				L[i]=clean[i]
			end
		end
	end
	if type(merged.invisAuto)=="boolean"then
		_G.ElysiumInvisAuto=merged.invisAuto
	end
	if type(merged.invisDepth)=="number"then
		_G.ElysiumInvisDepth=math.clamp(merged.invisDepth,.5,10)
	end
	if type(merged.invisAngle)=="number"then
		_G.ElysiumInvisAngle=math.clamp(merged.invisAngle,0,360)
	end
	if _G.SinkSliderValue==nil then
		_G.SinkSliderValue=_G.ElysiumInvisDepth
	end
	if _G.InvisStealAngle==nil then
		_G.InvisStealAngle=_G.ElysiumInvisAngle
	end
	_G.ElysiumUnwalk=merged.unwalk~=false
	_G.ElysiumGoMethod=merged.goMethod=="Velocity"and"Velocity"or"CFrame"
	_G.ElysiumFlashEntry=(merged.flashEntry=="Front"or merged.flashEntry=="Side")and merged.flashEntry or"Multi"
	_G.ElysiumGoSpeed=math.clamp(tonumber(merged.brainrotSpeed)or 400,50,1000)
	_G.ElysiumBrainrotDelay=0
	_G.ElysiumGoEquipTimeout=.2
	_G.ElysiumGoApproachF2=merged.goApproachF2~=false
	if merged.optimizerMode=="default"then
		_G.ElysiumOptimizerMode="default"
		_G.ElysiumApplyOptimizerBase("default")
	end
	if type(merged.autoTp)=="boolean"then
		_G.ElysiumAutoTP=merged.autoTp
	end
	if type(merged.autoBuy)=="boolean"then
		_G.ElysiumAutoBuy=merged.autoBuy
	end
	if type(merged.autoBuyRange)=="number"then
		_G.ElysiumAutoBuyRange=math.clamp(merged.autoBuyRange,5,40)
	end
	if type(merged.autoBuyHover)=="number"then
		_G.ElysiumAutoBuyHover=math.clamp(merged.autoBuyHover,0,20)
	end
	if type(merged.panelX)=="number"then
		_G._stp_panelX=merged.panelX
	end
	if type(merged.panelY)=="number"then
		_G._stp_panelY=merged.panelY
	end
	if type(merged.panelPos)=="table"then
		_G._stp_pos=merged.panelPos
	end
	if type(merged.autoKickOnSteal)=="boolean"then
		_G.ElysiumAutoKickOnSteal=merged.autoKickOnSteal
	end
	if type(merged.resetKey)=="string"then
		_G.ElysiumResetKeyName=merged.resetKey
	end
	if type(merged.cloneKey)=="string"then
		_G.ElysiumCloneKeyName=merged.cloneKey
	end
	if type(merged.carpetSpeedKey)=="string"then
		_G.ElysiumCarpetSpeedKeyName=merged.carpetSpeedKey
	end
	if type(merged.kickKey)=="string"then
		_G.ElysiumKickKeyName=merged.kickKey
	end
	if type(merged.stopTpKey)=="string"then
		_G.ElysiumStopTPKeyName=merged.stopTpKey
	end
	if type(merged.dropKey)=="string"then
		_G.ElysiumDropKeyName=merged.dropKey
	end
	if type(merged.kickToPS)=="boolean"then
		_G.ElysiumKickToPS=merged.kickToPS
	end
	if type(merged.psLink)=="string"then
		_G.ElysiumPrivateServerLink=merged.psLink
	end
	if type(merged.priAlert)=="boolean"then
		_G.ElysiumPriAlert=merged.priAlert
	end
	if type(merged.alertSound)=="string"then
		_G.ElysiumAlertSound=merged.alertSound
	end
	if type(merged.alertMinGen)=="number"then
		_G.ElysiumAlertMinGen=merged.alertMinGen
	end
	if type(merged.xray)=="boolean"then
		_G.ElysiumXray=merged.xray
	end
	if type(merged.antiFlash)=="boolean"then
		_G.ElysiumAntiFlash=merged.antiFlash
	end
	if type(merged.faceAway)=="boolean"then
		_G.ElysiumFaceAway=merged.faceAway
	end
	if type(merged.faceAwayNearest)=="boolean"then
		_G.ElysiumFaceAwayNearest=merged.faceAwayNearest
	end
	if type(merged.faceAwayDelay)=="number"then
		_G.ElysiumFaceAwayDelay=merged.faceAwayDelay
	end
	if type(merged.antiBee)=="boolean"then
		_G.ElysiumAntiBee=merged.antiBee
	end
	if type(merged.infJump)=="boolean"then
		_G.ElysiumInfJump=merged.infJump
	end
	if type(merged.antiDie)=="boolean"then
		_G.AntiDieDisabled=not merged.antiDie
	end
	_G.ElysiumCarpetSpeedValue=120
	if type(merged.exX)=="number"then
		_G._elysium_exX=merged.exX
	end
	if type(merged.exY)=="number"then
		_G._elysium_exY=merged.exY
	end
	if type(merged.fX)=="number"then
		_G._elysium_fX=merged.fX
	end
	if type(merged.fY)=="number"then
		_G._elysium_fY=merged.fY
	end
	if type(merged.kX)=="number"then
		_G._elysium_kX=merged.kX
	end
	if type(merged.kY)=="number"then
		_G._elysium_kY=merged.kY
	end
	if type(merged.tgtX)=="number"then
		_G._elysium_tgtX=merged.tgtX
	end
	if type(merged.tgtY)=="number"then
		_G._elysium_tgtY=merged.tgtY
	end
	if type(merged.modeX)=="number"then
		_G._elysium_modeX=merged.modeX
	end
	if type(merged.modeY)=="number"then
		_G._elysium_modeY=merged.modeY
	end
	if type(merged.tgtW)=="number"then
		_G._elysium_tgtW=merged.tgtW
	end
	if type(merged.tgtH)=="number"then
		_G._elysium_tgtH=merged.tgtH
	end
	if type(merged.modeW)=="number"then
		_G._elysium_modeW=merged.modeW
	end
	if type(merged.modeH)=="number"then
		_G._elysium_modeH=merged.modeH
	end
	_G.ElysiumAutoTP=true
	if writefile then
		pcall(function()
			local t=type(fileData)=="table"and fileData or{}
			t.autoTp=true
			writefile("SideTP.json",_HS:JSONEncode(t))
		end)
	end
end
local Players=ElysiumService("Players")
local RunService=ElysiumService("RunService")
local UIS=ElysiumService("UserInputService")
local RS=ElysiumService("ReplicatedStorage")
local VIM=ElysiumService("VirtualInputManager")
local GuiService=ElysiumService("GuiService")
local LP=Players.LocalPlayer
do
	local laserParts,lastRefresh={},-math.huge
	local lastSafe,lastCharacter=nil,nil
	local function refreshLasers()
		if os.clock()-lastRefresh<.65 then return end
		lastRefresh=os.clock()
		table.clear(laserParts)
		local plots=workspace:FindFirstChild("Plots")
		if not plots then return end
		for _,part in ipairs(plots:GetDescendants())do
			if part:IsA("BasePart")and part.CanCollide and
				(part.Name=="LaserHitbox"or part.Name=="Laser"or
				 (part.Parent and part.Parent.Name=="Laser"))then
				laserParts[#laserParts+1]=part
			end
		end
	end
	local function intersectsBarrier(from,to,barrier)
		local localFrom=barrier.CFrame:PointToObjectSpace(from)
		local localTo=barrier.CFrame:PointToObjectSpace(to)
		local delta=localTo-localFrom
		local radius=1.6
		local half=barrier.Size*.5+Vector3.new(radius,radius,radius)
		local enter,leave=0,1
		for _,axis in ipairs({"X","Y","Z"})do
			local origin,direction,bound=localFrom[axis],delta[axis],half[axis]
			if math.abs(direction)<1e-6 then
				if origin<-bound or origin>bound then return false end
			else
				local a,b=(-bound-origin)/direction,(bound-origin)/direction
				if a>b then a,b=b,a end
				enter=math.max(enter,a)
				leave=math.min(leave,b)
				if enter>leave then return false end
			end
		end
		return not(math.abs(localFrom.X)<=half.X and math.abs(localFrom.Y)<=half.Y and math.abs(localFrom.Z)<=half.Z)
	end
	RunService.Heartbeat:Connect(function()
		local char=LP.Character
		local root=char and char:FindFirstChild("HumanoidRootPart")
		if not root then lastSafe=nil;lastCharacter=char;return end
		if lastCharacter~=char then lastCharacter=char;lastSafe=nil end
		local current=root.CFrame
		local invis=(_G.ElysiumInvisActive==true)or
			(type(_G._invIsEnabled)=="function"and _G._invIsEnabled()==true)
		if not invis or _G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting()
			or _G.ElysiumTPBusy or _G.ElysiumMovementLeaseActive then
			lastSafe=current
			return
		end
		refreshLasers()
		if not lastSafe then lastSafe=current;return end
		local from,to=lastSafe.Position,current.Position
		if(to-from).Magnitude>65 then
			lastSafe=current
			return
		end
		for _,barrier in ipairs(laserParts)do
			if barrier.Parent and barrier.CanCollide
				and(barrier.Position-to).Magnitude<=75
				and intersectsBarrier(from,to,barrier)then
				root.CFrame=lastSafe
				root.AssemblyLinearVelocity=Vector3.zero
				root.AssemblyAngularVelocity=Vector3.zero
				_G.ElysiumInvisLaserBlockedAt=os.clock()
				return
			end
		end
		lastSafe=current
	end)
end
if _G.ElysiumNoZeroVel==nil then
	_G.ElysiumNoZeroVel=false
end
function _vzOK()
	if _G.ElysiumNoZeroVel==true then
		return false
	end
	if _G.ElysiumZeroWhileStealing~=true and LP:GetAttribute("Stealing")==true then
		return false
	end
	return true
end
function _vzL(p)
	if p and _vzOK()then
		p.AssemblyLinearVelocity=Vector3.new(0,0,0)
	end
end
function _vzA(p)
	if p and _vzOK()then
		p.AssemblyAngularVelocity=Vector3.new(0,0,0)
	end
end
_BLOCKING_MACHINE_TYPES={
	Fuse=true,
	Duel=true,
	Trade=true,
	Crafting=true,
}
function _ElysiumIsFusing(animalData)
	if type(animalData)~="table"then
		return false
	end
	local m=animalData.Machine
	if type(m)~="table"then
		return false
	end
	return _BLOCKING_MACHINE_TYPES[m.Type]==true
end
do
	local RS=ElysiumService("ReplicatedStorage")
	local RUN=ElysiumService("RunService")
	local _netFolder
	local function _netDir()
		if _netFolder then
			return _netFolder
		end
		local pk=RS:FindFirstChild("Packages")or RS:WaitForChild("Packages",10)
		if not pk then
			return nil
		end
		_netFolder=pk:FindFirstChild("Net")or pk:WaitForChild("Net",10)
		return _netFolder
	end
	local _net
	local function _getNet()
		if _net then
			return _net
		end
		local dir=_netDir()
		if not dir then
			return nil
		end
		local ok,m=pcall(require,dir)
		if ok and type(m)=="table"then
			_net=m
		end
		return _net
	end
	local _queue,_hooked,_original={},false,nil
	local function _host()
		for _,sig in ipairs({RUN.Heartbeat,RUN.RenderStepped,RUN.PostSimulation})do
			local ok,conns=pcall(getconnections,sig)
			if ok then
				for _,c in ipairs(conns)do
					local f=c.Function
					if f and f~=_G.__mkSyncHost and islclosure(f)and not isexecutorclosure(f)then
						local s=select(2,pcall(debug.info,f,"s"))
						if type(s)=="string"and s:find("^ReplicatedStorage%.")and not s:find("ReplicatedFirst")then
							return f
						end
					end
				end
			end
		end
	end
	local function _install()
		if _hooked then
			return true
		end
		if not _getNet()then
			return false
		end
		local h=_host()
		if not h then
			return false
		end
		_G.__mkNetHost=h
		local w=function(...)
			local job=table.remove(_queue,1)
			if job then
				local ok,r=pcall(_net[job.kind],_net,job.name)
				job.result=(ok and typeof(r)=="Instance")and r or nil
				job.done=true
			end
			return _original(...)
		end
		local ok,env=pcall(getfenv,h)
		if ok and type(env)=="table"then
			pcall(setfenv,w,env)
		end
		_original=hookfunction(h,w)
		_hooked=true
		return true
	end
	local _cache={}
	local function _get(name,kind)
		kind=(kind=="RemoteFunction"and"RemoteFunction")
			or(kind=="UnreliableRemoteEvent"and"UnreliableRemoteEvent")
			or"RemoteEvent"
		if type(name)~="string"or name==""then
			return nil
		end
		local logical=name:match("^R[EF]/(.+)$")or name:match("^URE/(.+)$")or name
		local ck=kind.."|"..logical
		local hit=_cache[ck]
		if hit and hit.Parent then
			return hit
		end
		_cache[ck]=nil
		local env=type(getgenv)=="function"and getgenv()or _G
		local actions=env.ElysiumActions or _G.ElysiumActions
		local prefix=kind=="RemoteFunction"and"RF/"or kind=="UnreliableRemoteEvent"and"URE/"or"RE/"
		if actions and actions.game==game and actions.workspace==workspace then
			local ok,remote=pcall(actions.Remote,prefix,logical)
			if ok and typeof(remote)=="Instance"and remote.Parent and remote:IsA(kind)then
				_cache[ck]=remote
				return remote
			end
		end
		if not _getNet()then
			return nil
		end
		if not _install()then
			return nil
		end
		local job={kind=kind,name=logical}
		table.insert(_queue,job)
		local t=os.clock()+(tonumber(_G.ElysiumNetTimeout)or 5)
		while not job.done and os.clock()<t do
			RUN.Heartbeat:Wait()
		end
		if job.result and job.result.Parent then
			_cache[ck]=job.result
			return job.result
		end
		return nil
	end
	_G.ElysiumNet={
		RemoteEvent=function(_,name)
			return _get(name,"RemoteEvent")
		end,
		RemoteFunction=function(_,name)
			return _get(name,"RemoteFunction")
		end,
		UnreliableRemoteEvent=function(_,name)
			return _get(name,"UnreliableRemoteEvent")
		end,
	}
	_G.ElysiumGetRemote=_get
	_G.Resolve=_get
	_G.__secureGetRemote=function(method,name)
		return _get(name,method)
	end
	_G.ElysiumNetHooked=function()
		return _hooked
	end
	do
		local _dummy=Instance.new("RemoteEvent")
		local _rawFire=(clonefunction and clonefunction(_dummy.FireServer))or _dummy.FireServer
		_G.RawFire=function(name,...)
			local r=_get(name)
			if not r then
				return false
			end
			_rawFire(r,...)
			return true
		end
	end
end
do
	local _xchan
	local _lastTry,_attempts=0,0
	local _deepScans,_lastDeep=0,0
	local _mod
	local MAX_ATTEMPTS,RETRY_GAP=40,.5
	local BOOT_T0,BOOT_BURST,BOOT_GAP=os.clock(),3,.1
	local MAX_DEEP,DEEP_GAP=3,1.5
	local RS_SYNC=ElysiumService("ReplicatedStorage")
	local _mask_sc
	local function _getMask()
		if _mask_sc and _mask_sc.Parent then
			return _mask_sc
		end
		local c=RS_SYNC:FindFirstChild("Controllers")
		_mask_sc=c and c:FindFirstChild("PlotController")
		return _mask_sc
	end
	local secure_call=_G.secure_call
	if type(secure_call)~="function"then
		local RUN=ElysiumService("RunService")
		local state={ready=false,inside=false}
		local conn,original
		local function host()
			for _,sig in ipairs({RUN.Heartbeat,RUN.RenderStepped,RUN.PostSimulation})do
				local ok,conns=pcall(getconnections,sig)
				if ok then
					for _,c in ipairs(conns)do
						local f=c.Function
						if f and f~=_G.__mkNetHost and islclosure(f)and not isexecutorclosure(f)then
							local s=select(2,pcall(debug.info,f,"s"))
							if
								type(s)=="string"
								and s:find("^ReplicatedStorage%.")
								and not s:find("ReplicatedFirst")
							then
								return f,c,s
							end
						end
					end
				end
			end
		end
		local function install()
			if state.ready then
				return true
			end
			local h,c,src=host()
			if not h then
				return false
			end
			local chunk=loadstring(
				[[
            local state, pack, unpack = ...
            return function(...)
                local job = state.job
                if job and not job.done then
                    job.done = true
                    state.inside = true
                    job.result = pack(pcall(job.fn, unpack(job.args, 1, job.args.n)))
                    state.inside = false
                end
                return state.original(...)
            end
        ]],
				"="..src
			)
			if not chunk then
				return false
			end
			local ok,env=pcall(getfenv,h)
			if ok and type(env)=="table"then
				pcall(setfenv,chunk,env)
			end
			local wrapper=chunk(state,table.pack,table.unpack)
			_G.__mkSyncHost=h
			original=hookfunction(h,wrapper)
			state.original=original
			conn=c
			state.ready=true
			return true
		end
		secure_call=function(fn,...)
			if type(fn)~="function"then
				return nil
			end
			if state.inside then
				return fn(...)
			end
			if not install()then
				return nil
			end
			state.job={fn=fn,args=table.pack(...),done=false}
			pcall(function()
				conn:Fire(0)
			end)
			local job=state.job
			state.job=nil
			if not job or not job.done or not job.result then
				return nil
			end
			if not job.result[1]then
				error(job.result[2],2)
			end
			return table.unpack(job.result,2,job.result.n)
		end
		_G.secure_call=secure_call
		_G.ElysiumSyncHooked=function()
			return state.ready
		end
	end
	task.spawn(function()
		pcall(function()
			local sync=_getSyncMod()
			if sync and type(sync.GetAllChannels)=="function"then
				local mask=_getMask()
				if mask then
					pcall(secure_call,sync.GetAllChannels,mask)
				end
			end
		end)
	end)
	local _syncMod_sc,_nextTry_sc=nil,0
	local function _getSyncMod()
		if _syncMod_sc then
			return _syncMod_sc
		end
		local p=RS_SYNC:FindFirstChild("Packages")
		local m=p and p:FindFirstChild("Synchronizer")
		if not m then
			return nil
		end
		local ok,mod=pcall(require,m)
		if ok and type(mod)=="table"then
			_syncMod_sc=mod
		end
		return _syncMod_sc
	end
	_G.__secureChans=function()
		if os.clock()<_nextTry_sc then
			return _xchan
		end
		local sync=_getSyncMod()
		if not sync then
			_nextTry_sc=os.clock()+.1
			return _xchan
		end
		if type(sync.GetAllChannels)~="function"then
			_nextTry_sc=os.clock()+.1
			return _xchan
		end
		local mask=_getMask()
		if not mask then
			_nextTry_sc=os.clock()+.1
			return _xchan
		end
		local ok,reg=pcall(secure_call,sync.GetAllChannels,mask)
		if ok and type(reg)=="table"then
			_xchan=reg
			_nextTry_sc=os.clock()+1.5
			_G.ElysiumSyncDiag="GetAllChannels (secure_call) - undetect/instant"
		else
			_nextTry_sc=os.clock()+.1
		end
		return _xchan
	end
	local function _channelCount(t)
		if type(t)~="table"then
			return 0
		end
		local ok,hits=pcall(function()
			local h,n=0,0
			for _,v in next,t do
				n=n+1
				if type(v)=="table"and type(rawget(v,"CacheTable"))=="table"then
					h=h+1
				end
				if n>=50 then
					break
				end
			end
			return h
		end)
		return(ok and hits)or 0
	end
	local function _probe(mod)
		local gu=(debug and debug.getupvalue)or getupvalue
		if type(gu)~="function"then
			return nil,0,nil
		end
		local best,bestN,where=nil,0,nil
		local function consider(t,tag)
			local n=_channelCount(t)
			if n>bestN then
				best,bestN,where=t,n,tag
			end
		end
		local cands={
			{mod.Get,10,4,"Get/10/4"},
			{mod.GetAllChannels,10,1,"GetAll/10/1"},
			{mod.Wait,10,1,"Wait/10/1"},
		}
		for _,c in ipairs(cands)do
			if type(c[1])=="function"then
				local o,u=pcall(gu,c[1],c[2])
				if o and type(u)=="table"then
					consider(rawget(u,c[3]),c[4])
					if bestN>0 then
						return best,bestN,where
					end
				end
			end
		end
		for _,fn in ipairs({mod.Get,mod.GetAllChannels,mod.Wait,mod.WaitAndCall,mod.GetTableFromChannel})do
			if type(fn)=="function"then
				for i=8,12 do
					local o,u=pcall(gu,fn,i)
					if o and type(u)=="table"then
						consider(u,"up"..i)
						for j=1,4 do
							consider(rawget(u,j),"up"..i.."/"..j)
						end
						if bestN>0 then
							return best,bestN,where
						end
					end
				end
			end
		end
		local ok,up=pcall(gu,mod.Get,9)
		if ok and type(up)=="table"then
			consider(rawget(up,3),"Get/9/3")
			if bestN>0 then
				return best,bestN,where
			end
			consider(up,"Get/9")
			if bestN>0 then
				return best,bestN,where
			end
		end
		return best,bestN,where
	end
	local function _deepScan(mod)
		local gu=(debug and debug.getupvalue)or getupvalue
		if type(gu)~="function"then
			return nil,0,nil
		end
		local best,bestN,where=nil,0,nil
		local function consider(t,tag)
			local n=_channelCount(t)
			if n>bestN then
				best,bestN,where=t,n,tag
			end
		end
		local _fnCount=0
		for fname,fn in next,mod do
			if type(fn)=="function"then
				_fnCount=_fnCount+1
				if _fnCount>30 then
					break
				end
				for i=1,16 do
					local o,u=pcall(gu,fn,i)
					if not o then
						break
					end
					if type(u)=="table"then
						consider(u,tostring(fname).."/"..i)
						for j=1,4 do
							consider(rawget(u,j),tostring(fname).."/"..i.."/"..j)
						end
					end
				end
			end
		end
		return best,bestN,where
	end
	local _gcFound,_gcFoundN,_gcState=nil,0,"idle"
	local function _gcScanOnce()
		local plots=workspace:FindFirstChild("Plots")
		if not plots then
			return
		end
		local live,names,nLive={},{},0
		for _,p in ipairs(plots:GetChildren())do
			live[p.Name]=true
			nLive=nLive+1
			names[nLive]=p.Name
		end
		if nLive==0 then
			return
		end
		local function score(t)
			local hits,seen=0,0
			for k,v in next,t do
				seen=seen+1
				if
					type(k)=="string"
					and live[k]
					and type(v)=="table"
					and type(rawget(v,"CacheTable"))=="table"
				then
					hits=hits+1
				end
				if seen>=64 then
					break
				end
			end
			return hits
		end
		local best,bestN=nil,0
		local hasFilter=type(filtergc)=="function"
		if hasFilter then
			local tries={}
			if nLive>=2 then
				tries[1]={names[1],names[2],"CacheTable"}
			end
			tries[#tries+1]={names[1],"CacheTable"}
			if nLive>=3 then
				tries[#tries+1]={names[2],names[3],"CacheTable"}
			end
			for _,keys in ipairs(tries)do
				local ok,res=pcall(filtergc,"table",{Keys=keys},false)
				if ok and type(res)=="table"then
					for _,t in ipairs(res)do
						if type(t)=="table"then
							local n=score(t)
							if n>bestN and n>=2 then
								best,bestN=t,n
							end
						end
					end
				end
				if bestN>=nLive then
					break
				end
			end
		end
		if
			bestN==0
			and type(getgc)=="function"
			and(not hasFilter or _G.ElysiumAllowFullGc==true)
			and not(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())
			and(os.clock()-(_G.__gcFullAt or 0))>=(tonumber(_G.ElysiumFullGcGap)or 3)
			and(workspace.StreamingEnabled==false or os.clock()-_gameLoadAt>=4)
		then
			_G.__gcFullAt=os.clock()
			pcall(function()
				local gc=getgc(true)
				local _gcLimit=math.min(#gc,4000)
				for i=1,_gcLimit do
					local t=gc[i]
					if type(t)=="table"then
						local pk=0
						for k in next,t do
							if type(k)=="string"and live[k]then
								pk=pk+1
								if pk>=2 then
									break
								end
							end
						end
						if pk>=2 then
							local n=score(t)
							if n>bestN and n>=2 then
								best,bestN=t,n
							end
						end
						if bestN>=nLive then
							break
						end
					end
				end
			end)
		end
		if best and bestN>_gcFoundN then
			_gcFound,_gcFoundN=best,bestN
		end
	end
	local _gcLastScan=0
	local _gcRescans=0
	local _gcMiss,_gcLastPlots=0,-1
	local function _gcChans()
		if _gcFound then
			local _pl=workspace:FindFirstChild("Plots")
			local _nLive=_pl and#_pl:GetChildren()or 0
			if
				_G.ElysiumSyncRescan==true
				and _gcFoundN<_nLive
				and _gcRescans<(tonumber(_G.ElysiumSyncMaxRescan)or 20)
				and(os.clock()-_gcLastScan)>=(tonumber(_G.ElysiumSyncRescanGap)or 3)
			then
				_gcLastScan=os.clock()
				_gcRescans=_gcRescans+1
				_gcScanOnce()
			end
			return _gcFound,_gcFoundN,"gc/plot-key+CacheTable"
		end
		local _pl=workspace:FindFirstChild("Plots")
		local _n=_pl and#_pl:GetChildren()or 0
		if _n~=_gcLastPlots then
			_gcLastPlots=_n
			_gcMiss=(_gcMiss>2)and 2 or _gcMiss
			_gcLastScan=_gcLastScan-.05
		end
		local gap=tonumber(_G.ElysiumSyncScanGap)or .2
		local back=math.min(_gcMiss*(tonumber(_G.ElysiumSyncMissStep)or .15),tonumber(_G.ElysiumSyncMissMax)or 1)
		if os.clock()-_gcLastScan<(gap+back)then
			return nil,0,nil
		end
		_gcLastScan=os.clock()
		_gcScanOnce()
		if _gcFound then
			_gcMiss=0
			return _gcFound,_gcFoundN,"gc/plot-key+CacheTable"
		end
		if _n>0 then
			_gcMiss=_gcMiss+1
		end
		return nil,0,nil
	end
	local function _apiChans(mod)
		if type(mod)~="table"then
			return nil,0,nil
		end
		local fn=rawget(mod,"GetAllChannels")
		if type(fn)~="function"then
			return nil,0,nil
		end
		local function _accept(reg,tag)
			if type(reg)~="table"then
				return nil,0,nil
			end
			local n=_channelCount(reg)
			if n>0 then
				return reg,n,tag
			end
			return nil,0,nil
		end
		if _G.ElysiumAllowSecureSyncCall~=false and type(secure_call)=="function"then
			for _,form in ipairs({"self","plain"})do
				local ok,reg=pcall(function()
					if form=="self"then
						return secure_call(fn,mod)
					end
					return secure_call(fn)
				end)
				if ok then
					local r,n,t=_accept(reg,"GetAllChannels/secure_call("..form..")")
					if r then
						return r,n,t
					end
				end
			end
		end
		if _G.ElysiumAllowRawSyncCall then
			for _,form in ipairs({"self","plain"})do
				local ok,reg=pcall(function()
					if form=="self"then
						return fn(mod)
					end
					return fn()
				end)
				if ok then
					local r,n,t=_accept(reg,"GetAllChannels/RAW("..form..")")
					if r then
						return r,n,t
					end
				end
			end
		end
		return nil,0,nil
	end
	local _xchan2,_nextTry2,_attempts2=nil,0,0
	local _xchan2Until=0
	local _nextApi=0
	local _chansLastScan=0
	local function _chans()
		local live=ElysiumChannels()
		if live then return live end
		if _xchan2 then
			local now=os.clock()
			if now<_xchan2Until then
				return _xchan2
			end
			if _channelCount(_xchan2)>0 then
				_xchan2Until=now+2
				return _xchan2
			end
		end
		local now=os.clock()
		if now-_chansLastScan<.02 then
			return _xchan2
		end
		if now<_nextTry2 then
			return _xchan2
		end
		_chansLastScan=now
		_attempts2=_attempts2+1
		local best,n,where
		if _G.ElysiumAllowSecureSyncCall~=false and os.clock()>=_nextApi then
			local mod=_getSyncMod()
			if mod then
				best,n,where=_apiChans(mod)
			end
			if not best or n==0 then
				_nextApi=os.clock()+(tonumber(_G.ElysiumSyncApiGap)or .5)
			end
		end
		if not best or n==0 then
			best,n,where=_gcChans()
		end
		if(not best or n==0)and _attempts2<=400 and _G.ElysiumAllowUpvalueProbe then
			local mod=_getSyncMod()
			if mod then
				best,n,where=_probe(mod)
				local inBoot=_gameLoadAt and(os.clock()-_gameLoadAt)<4
				if(not best or n==0)and not inBoot and os.clock()-_lastDeep>2 then
					_lastDeep=os.clock()
					_deepScans=_deepScans+1
					best,n,where=_deepScan(mod)
				end
			end
		end
		if best and n>0 then
			_xchan2=best
			_G.ElysiumSyncDiag=string.format("%s - %d channels",tostring(where),n)
			return _xchan2
		end
		local inBoot2=_gameLoadAt and(os.clock()-_gameLoadAt)<4
		_nextTry2=os.clock()+(inBoot2 and .1 or((_G.ElysiumScanMode=="fast")and .03 or .1))
		return _xchan2
	end
	_G.__secureChans=_chans
	_G.ElysiumSyncAll=function()
		return _chans()
	end
	_G.ElysiumSyncGet=function(idx)
		local t=_chans()
		if not t or idx==nil then
			return nil
		end
		local ok,cd=pcall(rawget,t,idx)
		if ok and type(cd)=="table"then
			return cd
		end
		local ok2,cd2=pcall(function()
			return t[idx]
		end)
		if ok2 and type(cd2)=="table"then
			return cd2
		end
		return nil
	end
	_G.sProp=function(ch,key)
		if type(ch)~="table"or key==nil then
			return nil
		end
		local ct=rawget(ch,"CacheTable")
		if type(ct)~="table"then
			local okC,c2=pcall(function()
				return ch.CacheTable
			end)
			if okC and type(c2)=="table"then
				ct=c2
			end
		end
		if type(ct)~="table"then
			return nil
		end
		local v=rawget(ct,key)
		if v~=nil then
			return v
		end
		local okV,v2=pcall(function()
			return ct[key]
		end)
		if okV then
			return v2
		end
		return nil
	end
	_G._elysiumRawCT=function(plotName)
		local c=_G.ElysiumSyncGet(plotName)
		if not c then
			return nil
		end
		return rawget(c,"CacheTable")
	end
	local _AD,_MD,_TD
	local function _data()
		if _AD then
			return true
		end
		local ok=pcall(function()
			local R=ElysiumService("ReplicatedStorage")
			local d=R:FindFirstChild("Datas")or R:WaitForChild("Datas",2)
			if not d then
				return
			end
			local a=d:FindFirstChild("Animals")or d:WaitForChild("Animals",2)
			if a then
				_AD=require(a)
			end
			local m=d:FindFirstChild("Mutations")or d:WaitForChild("Mutations",2)
			if m then
				_MD=require(m)
			end
			local t=d:FindFirstChild("Traits")or d:WaitForChild("Traits",2)
			if t then
				_TD=require(t)
			end
		end)
		return ok and _AD~=nil
	end
	_G._elysiumGen=function(index,mutation,traits)
		if not _data()then
			return 0
		end
		local info=_AD[index]
		if not info or not info.Generation then
			return 0
		end
		local mult=1
		if mutation and mutation~="None"and mutation~=""then
			local m=_MD[mutation]
			if m and m.Modifier then
				mult=mult+m.Modifier
			end
		end
		if type(traits)=="table"then
			for _,tr in ipairs(traits)do
				local t=_TD[tr]
				if t and t.MultiplierModifier then
					mult=mult+t.MultiplierModifier
				end
			end
		end
		return info.Generation*mult
	end
	local _sharedAnimals
	_G._elysiumAnimShim=setmetatable({
		GetGeneration=function(_,index,mutation,traits)
			return _G._elysiumGen(index,mutation,traits)
		end,
	},{
		__index=function(_,k)
			if not _sharedAnimals then
				local ok,real=pcall(function()
					local R=ElysiumService("ReplicatedStorage")
					local sh=R:FindFirstChild("Shared")or R:WaitForChild("Shared",3)
					local an=sh and(sh:FindFirstChild("Animals")or sh:WaitForChild("Animals",3))
					return an and require(an)or nil
				end)
				if ok and type(real)=="table"then
					_sharedAnimals=real
				end
			end
			if not _sharedAnimals then
				return nil
			end
			return rawget(_sharedAnimals,k)
		end,
	})
	_G.Elysium_GetPlotChannel=function(plotName)
		return _G.ElysiumSyncGet(plotName)
	end
	_G.Elysium_GetAllPlots=function()
		return _G.ElysiumSyncAll()or{}
	end
	_G.Elysium_GetPlotAnimalList=function(plotName)
		local ct=_G._elysiumRawCT(plotName)
		local al=ct and ct.AnimalList
		return type(al)=="table"and al or nil
	end
end
_G.ElysiumSyncAll=_G.ElysiumSyncAll
_G.ElysiumSyncGet=_G.ElysiumSyncGet
_G.ElysiumRawCT=_G._elysiumRawCT
_G.ElysiumGen=_G._elysiumGen
_G.ElysiumAnimShim=_G._elysiumAnimShim
_G.stealthGet=function(n)
	return _G.ElysiumSyncGet(n)
end
_G.SyncInt={_cache={},_data=nil}
task.spawn(function()
	for i=1,260 do
		local t=_G.ElysiumSyncAll()
		local pl=workspace:FindFirstChild("Plots")
		local kids=pl and pl:GetChildren()
		local want=kids and#kids or 0
		if want>0 and type(t)=="table"then
			local have=0
			for k=1,want do
				if rawget(t,kids[k].Name)~=nil then
					have=have+1
				end
			end
			if have>=want then
				_G.ElysiumChannelsReady=true
				return
			end
		end
		task.wait(i<=100 and .04 or .1)
	end
end)
_G.ElysiumGetSyncData=_G.ElysiumGetSyncData
	or function(plot)
		local plotName=type(plot)=="string"and plot or(plot and plot.Name)
		if not plotName then
			return nil
		end
		local Pkgs=ElysiumService("ReplicatedStorage"):FindFirstChild("Packages")
		local Sync=Pkgs and Pkgs:FindFirstChild("Synchronizer")
		if not Sync then
			return nil
		end
		local okMod,mod=pcall(require,Sync)
		if not okMod or type(mod)~="table"then
			return nil
		end
		local okT,data=pcall(function()
			return _G.ElysiumRawCT(plotName)
		end)
		if okT and type(data)=="table"then
			return data
		end
		local okC,ch=pcall(function()
			return _G.ElysiumSyncGet(plotName)
		end)
		if okC and ch then
			local synth={__channel=ch}
			pcall(function()
				local ct=rawget(ch,"CacheTable")
				if type(ct)=="table"then
					synth.AnimalList=ct.AnimalList
					synth.Owner=ct.Owner
				end
			end)
			return synth
		end
		return nil
	end
_mkNextModTry=0
function _ElysiumBuildDefaultBrainrotPriority()
	if not AnimalsData then
		return
	end
	table.clear(_brainrotDefaultPri)
	table.clear(_brainrotDefaultRarity)
	local rarities={
		OG=1,
		Secret=2,
		["Brainrot God"]=3,
		["Brainrot Titan"]=4,
		["Brainrot Legendary"]=5,
		Legendary=6,
		Mythic=7,
		Epic=8,
		Rare=9,
		Uncommon=10,
		Common=11,
	}
	local list={}
	for name,info in pairs(AnimalsData)do
		if type(info)=="table"then
			local r=tostring(info.Rarity or"Common")
			local rIdx=rarities[r]or 12
			table.insert(list,{name=info.DisplayName or name,index=name,r=r,rIdx=rIdx})
		end
	end
	table.sort(list,function(a,b)
		if a.rIdx~=b.rIdx then
			return a.rIdx<b.rIdx
		end
		return(a.name or a.index)<(b.name or b.index)
	end)
	for i,v in ipairs(list)do
		local nn=_normName(v.name)
		local ni=_normName(v.index)
		_brainrotDefaultPri[nn]=i
		_brainrotDefaultRarity[nn]=v.r
		if _brainrotDefaultPri[ni]==nil then
			_brainrotDefaultPri[ni]=i
			_brainrotDefaultRarity[ni]=v.r
		end
	end
	if#_G.SHARED_PRIORITY_ITEMS==0 then
		local cap=tonumber(_G.ElysiumDefaultPrioCap)or 60
		for i,v in ipairs(list)do
			if i>cap then
				break
			end
			_G.SHARED_PRIORITY_ITEMS[i]=v.name
		end
	end
	_G.ElysiumPriVersion=(_G.ElysiumPriVersion or 0)+1
end
function loadModules()
	if AnimalsData then
		if not AnimalsShared and _G.ElysiumAnimShim then
			AnimalsShared=_G.ElysiumAnimShim
		end
		return true
	end
	if os.clock()<_mkNextModTry then
		return false
	end
	_mkNextModTry=os.clock()+(tonumber(_G.ElysiumModRetry)or .5)
	pcall(function()
		local Datas=RS:FindFirstChild("Datas")or RS:WaitForChild("Datas",1.5)
		if Datas then
			local a=Datas:FindFirstChild("Animals")or Datas:WaitForChild("Animals",1.5)
			if a then
				AnimalsData=require(a)
			end
		end
	end)
	pcall(_ElysiumBuildDefaultBrainrotPriority)
	AnimalsShared=_G.ElysiumAnimShim
	if not NumberUtils then
		pcall(function()
			local Utils=RS:FindFirstChild("Utils")
			local n=Utils and Utils:FindFirstChild("NumberUtils")
			if n then
				NumberUtils=require(n)
			end
		end)
	end
	return AnimalsData~=nil
end
function loadNet()
	return false
end
function getRemote(method,name)
	return _G.__secureGetRemote(method,name)
end
_G.ElysiumGetRemote=getRemote
do
local elysiumFlashPreferred=false
local function elysiumFlashResolve(kind,name)return getRemote(kind,name)end
do
	local previous=_G.ElysiumFlashBridge
	if previous and previous.game==game then
		if elysiumFlashPreferred then previous.resolve=elysiumFlashResolve end
	else
		local api={game=game,resolve=elysiumFlashResolve,wired=setmetatable({},{__mode="k"})}
		_G.ElysiumFlashBridge=api
		local n=game:GetService("Players")
		local p=workspace
		local q=game:GetService("CollectionService")
		local u=n.LocalPlayer
		local f,g,h=40,2,Vector3.new(1,0,1)
							local function Cast(w,x,y,z)
						local A
						local function Keep(B)
							if B and(not A or B.Distance<A.Distance)then
								A=B
							end
						end
						Keep(p:Blockcast(w,x,y,z))
						Keep(p:Raycast(w.Position,y,z))
						if(y*h).Magnitude>.001 then
							local B=math.max(x.X,x.Y,x.Z)
							local C=y.Unit*B
							local D=p:Blockcast(w-C,x,y+C,z)
							if D then
								Keep({
									Instance=D.Instance,
									Position=D.Position,
									Normal=D.Normal,
									Distance=math.max(0,D.Distance-B),
								})
							end
						end
						return A
					end
					local function FlashParams()
						local w=RaycastParams.new()
						w.IgnoreWater=true
						w.RespectCanCollide=true
						w.CollisionGroup="Player"
						local x=table.clone(q:GetTagged("FlashTeleportIgnore"))
						for y,z in n:GetPlayers()do
							if z.Character then
								table.insert(x,z.Character)
							end
						end
						w.FilterType=Enum.RaycastFilterType.Exclude
						w.FilterDescendantsInstances=x
						return w
					end
					local function FlashPlan()
						local w=u.Character
						local x=w and(w:FindFirstChild("HumanoidRootPart")or w.PrimaryPart)
						local y=w and w:FindFirstChildWhichIsA("Humanoid")
						if not(x and y)then
							return nil,nil
						end
						local z={
							RootCFrame=x.CFrame,
							RootSize=x.Size,
							HipHeight=y.HipHeight,
							CameraCFrame=p.CurrentCamera.CFrame,
							Distance=f,
						}
						local A=FlashParams()
						local B,C=z.RootSize,z.HipHeight
						local D=z.RootCFrame*CFrame.new(0,-(C+B.Y*.5),0)
						local E=z.CameraCFrame*CFrame.fromOrientation(math.rad(15),0,0)
						local F=CFrame.lookAlong(D.Position,E.LookVector)
						local G=F*CFrame.new(0,0,-f)
						local H=-math.huge
						local I=math.sqrt(B.X^2+B.Z^2)
						local J=Vector3.new(I,C+B.Y,I)
						local K=CFrame.new(0,J.Y*.5,0)
						local function Consider(L)
							local M=((F.Position-L.Position)*h).Magnitude
							if M>H then
								H,G=M,L
							end
						end
						local L=F*CFrame.new(0,0,-f)
						local M=L.Position-F.Position
						local N=Cast(F*K,J,M,A)
						if N then
							Consider(CFrame.new(F.Position+M.Unit*N.Distance)*L.Rotation)
							for O,P in
								{
									J.Y*.25,
									J.Y*.5,
									J.Y,
									J.Y*1.25,
									J.Y*1.5,
									J.Y*2,
									.5,
									1,
									2.5,
									5,
								}
							do
								local Q=F
								for R,S in{CFrame.new(0,P,0),CFrame.new(0,0,-f),CFrame.new(0,-P,0)}do
									local T=Q*S
									local U=T.Position-Q.Position
									local V=Cast(Q*K,J,U,A)
									Q=if V then CFrame.new(Q.Position+U.Unit*V.Distance)*T.Rotation else T
								end
								Consider(Q)
							end
						else
							Consider(L)
						end
						local O,P=G:ToOrientation()
						return z,
							{CFrame=CFrame.new(G.Position)*CFrame.fromOrientation(0,P,0),Valid=math.max(g,I)
								<=H}
					end
		local function status(value,detail)
			api.status=value;_G.ElysiumFlashStatus=value
			if detail then _G.ElysiumFlashError=tostring(detail)end
			if api.lastLogged~=value then
				api.lastLogged=value
				local runtime=_G.ElysiumRuntime
				if runtime and runtime.Log then runtime.Log("flash_"..value,detail)end
			end
		end
		function api.Activate(tool)
			if api.pending then status("busy");return false end
			local character=u.Character
			local root=character and character:FindFirstChild("HumanoidRootPart")
			local humanoid=character and character:FindFirstChildOfClass("Humanoid")
			if not root or not humanoid or humanoid.Health<=0 or tool.Parent~=character then status("not_equipped");return false end
			if root.Anchored or u:GetAttribute("Stealing")==true then status("character_blocked");return false end
			local now=p:GetServerTimeNow()
			if(tonumber(tool:GetAttribute("CooldownUntil"))or 0)>now then status("cooldown");return false end
			if(tonumber(u:GetAttribute("RagdollEndTime"))or 0)>now then status("ragdolled");return false end
			local pending={character=character,root=root,started=os.clock()}
			api.pending=pending
			local connection
			local ok,result=pcall(function()
				local remote=api.resolve("RemoteFunction","Tools/Flash/Activate")
				local effects=api.resolve("RemoteEvent","Tools/Flash/Effects")
				if not remote or not effects then status("remote_missing");return false end
				local params,plan=FlashPlan()
				if not params or not plan or not plan.Valid then status("no_valid_destination");return false end
				connection=effects.OnClientEvent:Connect(function(player,origin,destination)
					if player~=u or typeof(destination)~="CFrame"or api.pending~=pending then return end
					if u.Character~=character or not root.Parent or humanoid.Health<=0 then return end
					if os.clock()-pending.started>8 then return end
					root.AssemblyLinearVelocity=Vector3.zero
					root.AssemblyAngularVelocity=Vector3.zero
					root.CFrame=destination
					pending.landed=true;status("landed")
				end)
				status("requesting")
				task.spawn(function()
					local success,accepted,reason=pcall(remote.InvokeServer,remote,params,plan)
					pending.done=true;pending.accepted=success and accepted
					if api.pending==pending and not pending.landed then
						if not success then status("request_error",accepted)
						elseif not accepted then status("refused",reason or"no reason returned")
						else status("awaiting_effect")end
					end
				end)
				local deadline=os.clock()+math.clamp(u:GetNetworkPing()*4+2,2,6)
				repeat
					game:GetService("RunService").Heartbeat:Wait()
					if u.Character~=character then return false end
				until pending.landed or(pending.done and not pending.accepted)or os.clock()>=deadline
				if pending.landed then return true end
				if not pending.done or pending.accepted then status("effect_timeout")end
				return false
			end)
			if connection then connection:Disconnect()end
			if api.pending==pending then api.pending=nil end
			if not ok then status("client_error",result)end
			return ok and result==true
		end
		local activate=api.Activate
		function api.Activate(tool)
			if api.pending or api.preparing then return false end
			api.preparing=true
			local release
			local ok,result=pcall(function()
				if type(_G.ElysiumExtrasAcquireFlash)=="function"then release=_G.ElysiumExtrasAcquireFlash()end
				return activate(tool)
			end)
			api.preparing=false
			if release then pcall(release)end
			if not ok then status("extras_or_activation_error",result)end
			return ok and result==true
		end
		local function wire(tool)
			if not tool:IsA("Tool")or tool.Name~="Flash Teleport"or api.wired[tool]then return end
			api.wired[tool]=true
			tool.ManualActivationOnly=false
			tool.Enabled=true
			if type(getconnections)=="function"and type(isexecutorclosure)=="function"then
				local ok,connections=pcall(getconnections,tool.Activated)
				if ok then for _,connection in ipairs(connections)do
					if type(connection.Function)=="function"and not isexecutorclosure(connection.Function)then pcall(function()connection:Disable()end)end
				end end
			end
			tool.Activated:Connect(function()task.spawn(api.Activate,tool)end)
		end
		local function watch(container)
			if not container then return end
			for _,child in ipairs(container:GetChildren())do wire(child)end
			container.ChildAdded:Connect(wire)
		end
		watch(u:FindFirstChildOfClass("Backpack"));watch(u.Character)
		u.ChildAdded:Connect(function(child)if child:IsA("Backpack")then watch(child)end end)
		u.CharacterAdded:Connect(watch)
	end
end
end
GRAPPLE_ARG=.8
do
	local _WSg=ElysiumService("Workspace")
	local getGrappleRemote
	do
		local netFolder,netModule,queue,hooked,original=nil,nil,{},false,nil
		local function netDirectory()
			if netFolder then
				return netFolder
			end
			local packages=RS:FindFirstChild("Packages")or RS:WaitForChild("Packages",10)
			if not packages then
				return nil
			end
			netFolder=packages:FindFirstChild("Net")or packages:WaitForChild("Net",10)
			return netFolder
		end
		local function getNet()
			if netModule then
				return netModule
			end
			local directory=netDirectory()
			if not directory then
				return nil
			end
			local ok,module=pcall(require,directory)
			if ok and type(module)=="table"then
				netModule=module
			end
			return netModule
		end
		local function host()
			for _,signal in ipairs({RunService.Heartbeat,RunService.RenderStepped,RunService.PostSimulation})do
				local ok,connections=pcall(getconnections,signal)
				if ok then
					for _,connection in ipairs(connections)do
						local fn=connection.Function
						if fn and islclosure(fn)and not isexecutorclosure(fn)then
							local source=select(2,pcall(debug.info,fn,"s"))
							if
								type(source)=="string"
								and source:find("^ReplicatedStorage%.")
								and not source:find("ReplicatedFirst")
							then
								return fn
							end
						end
					end
				end
			end
		end
		local function install()
			if hooked then
				return true
			end
			if not getNet()then
				return false
			end
			local fn=host()
			if not fn then
				return false
			end
			local wrapper=function(...)
				local job=table.remove(queue,1)
				if job then
					local ok,remote=pcall(netModule[job.kind],netModule,job.name)
					job.result=(ok and typeof(remote)=="Instance")and remote or nil
					job.done=true
				end
				return original(...)
			end
			local ok,env=pcall(getfenv,fn)
			if ok and type(env)=="table"then
				pcall(setfenv,wrapper,env)
			end
			original=hookfunction(fn,wrapper)
			hooked=true
			return true
		end
		local cache={}
		getGrappleRemote=function(method,name)
			local kind=method=="RemoteFunction"and"RemoteFunction"
				or method=="UnreliableRemoteEvent"and"UnreliableRemoteEvent"
				or"RemoteEvent"
			if type(name)~="string"or name==""then
				return nil
			end
			local cacheKey=kind.."|"..name
			local cached=cache[cacheKey]
			if cached and cached.Parent then
				return cached
			end
			cache[cacheKey]=nil
			if not getNet()or not install()then
				return nil
			end
			local job={kind=kind,name=name}
			table.insert(queue,job)
			local expires=os.clock()+5
			while not job.done and os.clock()<expires do
				RunService.Heartbeat:Wait()
			end
			if job.result and job.result.Parent then
				cache[cacheKey]=job.result
				return job.result
			end
			return nil
		end
	end
	function _grappleInvalidate()
		_G.__ElysiumUseItem,_G.__ElysiumUseItemJob=nil,nil
	end
	_G.ElysiumGrappleInvalidate=_grappleInvalidate
	task.spawn(function()
		_grappleUseItem=getGrappleRemote("RemoteEvent","UseItem")
	end)
	task.spawn(function()
		_grappleItemUse=getGrappleRemote("RemoteEvent","75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
	end)
	function _grappleRemoteGet()
		if not(_grappleUseItem and _grappleUseItem.Parent)then
			_grappleUseItem=getGrappleRemote("RemoteEvent","UseItem")
		end
		if not(_grappleItemUse and _grappleItemUse.Parent)then
			_grappleItemUse=getGrappleRemote("RemoteEvent","75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
		end
		return(_grappleUseItem and _grappleUseItem.Parent and _grappleUseItem)
			or(_grappleItemUse and _grappleItemUse.Parent and _grappleItemUse)
	end
	_G.ElysiumGrappleRemote=_grappleRemoteGet
	local _gMuteCache=setmetatable({},{__mode="k"})
	local function _gCollectMutes(tool)
		local e=_gMuteCache[tool]
		if e and(os.clock()-e.t)<8 and tool.Parent then
			return e
		end
		local snd,bm={},{}
		pcall(function()
			local scanned=0
			for _,s in ipairs(tool:GetDescendants())do
				scanned=scanned+1
				if scanned>500 then
					break
				end
				if s:IsA("Sound")then
					snd[#snd+1]=s
				elseif s:IsA("Beam")then
					bm[#bm+1]=s
				end
			end
		end)
		e={t=os.clock(),snd=snd,bm=bm}
		_gMuteCache[tool]=e
		return e
	end
	local function _gMuteAndStopPull(tool,hrp)
		if tool and tool.Parent then
			local e=_gCollectMutes(tool)
			for _,s in ipairs(e.snd)do
				if s.Parent then
					pcall(function()
						s.Volume=0
						s:Stop()
					end)
				end
			end
			for _,b in ipairs(e.bm)do
				if b.Parent then
					pcall(function()
						b.Enabled=false
						b.Attachment0=nil
					end)
				end
			end
		end
		local character=LP.Character
		if not tool or not character or tool.Parent~=character
			or not hrp or hrp.Parent~=character
			or character:FindFirstChild("HumanoidRootPart")~=hrp then return end
		if isTeleporting or _G.ElysiumTPBusy or _G.ElysiumActiveMoveCancel
			or _G.ElysiumMovementLeaseActive then return end
		if hrp and hrp.Parent then
			local fp=hrp:FindFirstChild("FlightPower")
			if fp then
				pcall(function()
					fp:Destroy()
				end)
			end
			if not isTeleporting and not _G.ElysiumTPBusy then
				_vzL(hrp)
				_vzA(hrp)
			end
		end
	end
	local _gHoldUntil,_gHoldConn=0,nil
	local function _gHoldNoPull(tool,hrp,seconds)
		_gHoldUntil=os.clock()+seconds
		if _gHoldConn then
			return
		end
		local last=0
		_gHoldConn=RunService.Heartbeat:Connect(function()
			local character=LP.Character
			if not character or not tool or tool.Parent~=character
				or not hrp or hrp.Parent~=character
				or character:FindFirstChild("HumanoidRootPart")~=hrp then
				_gHoldUntil=0
				if _gHoldConn then _gHoldConn:Disconnect();_gHoldConn=nil end
				return
			end
			local now=os.clock()
			if now-last>=.03 then
				last=now
				_gMuteAndStopPull(tool,hrp)
			end
			if now>_gHoldUntil then
				if _gHoldConn then
					_gHoldConn:Disconnect()
					_gHoldConn=nil
				end
				_gMuteAndStopPull(tool,hrp)
			end
		end)
	end
	function _grappleToolReady(tool,waitS)
		if not tool or not tool.Parent then
			return false
		end
		local t0=os.clock()
		while true do
			local ok,en=pcall(function()
				return tool.Enabled
			end)
			if not ok or en~=false then
				return true
			end
			if os.clock()-t0>(tonumber(waitS)or 0)then
				return false
			end
			RunService.Heartbeat:Wait()
			if not tool.Parent then
				return false
			end
		end
	end
	_G.ElysiumToolReady=_grappleToolReady
	local _gLastFireAt=0
	local function _grappleFireGap()
		local gap=tonumber(_G.ElysiumGrappleMinGap)
		if gap==nil then
			gap=1.1
		end
		return math.max(gap,0)
	end
	function _grappleAllowFire()
		return(os.clock()-_gLastFireAt)>=_grappleFireGap()
	end
	function _grappleMarkFired()
		_gLastFireAt=os.clock()
		_G.ElysiumGrappleLastFireAt=_gLastFireAt
	end
	_G.ElysiumGrappleCanFire=_grappleAllowFire
	function _grapplePickRemote()
		local byName=_grappleUseItem and _grappleUseItem.Parent and _grappleUseItem or nil
		local byGuid=_grappleItemUse and _grappleItemUse.Parent and _grappleItemUse or nil
		local pick=tostring(_G.ElysiumGrappleRemotePick or""):lower()
		if pick=="guid"then
			return byGuid or byName
		elseif pick=="useitem"then
			return byName or byGuid
		end
		return byName or byGuid
	end
	function _grappleDo(tool,pos,target,char)
		if not tool or not pos then
			return false
		end
		if typeof(pos)=="Instance"then
			pos=pos.Position
		end
		if typeof(pos)=="CFrame"then
			pos=pos.Position
		end
		if typeof(pos)~="Vector3"then
			_G.ElysiumGrappleWhy="bad target position"
			return false
		end
		char=char or LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			_G.ElysiumGrappleWhy="no hrp"
			return false
		end
		if not _grappleToolReady(tool,tonumber(_G.ElysiumGrappleCooldownWait)or .35)then
			_G.ElysiumGrappleWhy="hook on cooldown (Enabled=false)"
			return false
		end
		if not(_grappleUseItem and _grappleUseItem.Parent)then
			_grappleUseItem=getGrappleRemote("RemoteEvent","UseItem")
		end
		if not(_grappleItemUse and _grappleItemUse.Parent)then
			_grappleItemUse=getGrappleRemote("RemoteEvent","75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
		end
		if not(_grappleUseItem and _grappleUseItem.Parent)and not(_grappleItemUse and _grappleItemUse.Parent)then
			_G.ElysiumGrappleWhy="unresolved"
			return false
		end
		if not _grappleAllowFire()then
			_G.ElysiumGrappleWhy="rate limited (hook cooldown)"
			return false
		end
		local mag=(pos-hrp.Position).Magnitude
		local amt=math.clamp(mag/120,0,1)
		local quiet=(_G.ElysiumGrappleQuiet~=false)
		if quiet then
			_gMuteAndStopPull(tool,hrp)
		end
		local remote=_grapplePickRemote()
		local fired=false
		if remote then
			pcall(function()
				remote:FireServer(amt,pos)
			end)
			fired=true
			_grappleMarkFired()
		end
		if quiet then
			_gMuteAndStopPull(tool,hrp)
			_gHoldNoPull(tool,hrp,tonumber(_G.ElysiumGrappleQuietFor)or .6)
		end
		_G.ElysiumGrappleWhy=fired and"ok"or"no remote fired"
		return fired
	end
	_G.ElysiumGrappleDo=_grappleDo
	local function _grappleLegacyFire()
		local fired=false
		if not _grappleAllowFire()then
			_G.ElysiumGrappleWhy="rate limited (hook cooldown)"
			return false
		end
		if not(_grappleUseItem and _grappleUseItem.Parent)then
			_grappleUseItem=getGrappleRemote("RemoteEvent","UseItem")
		end
		if not(_grappleItemUse and _grappleItemUse.Parent)then
			_grappleItemUse=getGrappleRemote("RemoteEvent","75c9466d-e4c0-4b02-b26a-c3615fcc1e42")
		end
		local remote=_grapplePickRemote()
		if remote then
			pcall(function()
				remote:FireServer(GRAPPLE_ARG)
			end)
			fired=true
			_grappleMarkFired()
		end
		_G.ElysiumGrappleWhy=fired and"ok (legacy)"or"legacy: no remote"
		return fired
	end
	local _GFAN={9,10,11,12,13,14,16,18,21,24,28,32,36,40,45}
	local _GFAN2={11,14,18,24,32,42,48}
	local _GCOMPASS={
		Vector3.new(1,0,0),
		Vector3.new(-1,0,0),
		Vector3.new(0,0,1),
		Vector3.new(0,0,-1),
		Vector3.new(.7,0,.7),
		Vector3.new(.7,0,-.7),
		Vector3.new(-.7,0,.7),
		Vector3.new(-.7,0,-.7),
	}
	function _fireGrapple(value,exact)
		if _G.ElysiumGrappleLegacy==true then
			return _grappleLegacyFire()
		end
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return false
		end
		if LP:GetAttribute("Stealing")and _G.ElysiumNoGrappleWhileCarrying==true then
			_G.ElysiumGrappleWhy="refused: carrying a brainrot"
			return false
		end
		local tool=char:FindFirstChild("Grapple Hook")or(findGrapple())
		if tool and tool.Parent~=char then
			local hum=char:FindFirstChildOfClass("Humanoid")
			if not hum then
				return false
			end
			pcall(function()
				hum:EquipTool(tool)
			end)
			local t0=os.clock()
			repeat
				RunService.Heartbeat:Wait()
				char=LP.Character
				tool=char and(char:FindFirstChild("Grapple Hook")or(findGrapple()))
			until(tool and tool.Parent==char)or os.clock()-t0>.5
			hrp=char and char:FindFirstChild("HumanoidRootPart")
		end
		if not tool or not hrp then
			return false
		end
		local par=RaycastParams.new()
		par.FilterType=Enum.RaycastFilterType.Exclude
		par.FilterDescendantsInstances={char}
		if exact and typeof(value)=="Vector3"then
			local m=(value-hrp.Position).Magnitude
			if m<10 or m>50 then
				return false
			end
			local target
			local hit=_WSg:Raycast(hrp.Position,value-hrp.Position,par)
			if hit then
				target=hit.Instance
			end
			if not target then
				local okb,parts=pcall(function()
					return _WSg:GetPartBoundsInRadius(value,6)
				end)
				if okb and parts then
					for _,p in ipairs(parts)do
						if p:IsA("BasePart")and not p:IsDescendantOf(char)then
							target=p
							break
						end
					end
				end
			end
			if not target then
				return false
			end
			return _grappleDo(tool,value,target,char)
		end
		local dest
		if typeof(value)=="Vector3"then
			dest=value
		elseif typeof(value)=="Instance"and value:IsA("BasePart")then
			dest=value.Position
		end
		local dir
		if dest then
			local d=dest-hrp.Position
			dir=Vector3.new(d.X,0,d.Z)
		end
		if not dir or dir.Magnitude<1 then
			local lv=hrp.CFrame.LookVector
			dir=Vector3.new(lv.X,0,lv.Z)
		end
		if dir.Magnitude<.01 then
			return false
		end
		dir=dir.Unit
		local pos,target,bestM
		for _,d in ipairs(_GFAN)do
			local origin=hrp.Position+dir*d+Vector3.new(0,3,0)
			local hit=_WSg:Raycast(origin,Vector3.new(0,-60,0),par)
			if hit then
				local m=(hit.Position-hrp.Position).Magnitude
				if m>=10 and m<=50 and(not bestM or m<bestM)then
					pos,target,bestM=hit.Position,hit.Instance,m
				end
			end
		end
		if not pos then
			for _,d in ipairs(_GFAN2)do
				local hit=_WSg:Raycast(hrp.Position,dir*d,par)
				if hit then
					local m=(hit.Position-hrp.Position).Magnitude
					if m>=10 and m<=50 and(not bestM or m<bestM)then
						pos,target,bestM=hit.Position,hit.Instance,m
					end
				end
			end
		end
		if not pos then
			for _,cd in ipairs(_GCOMPASS)do
				for _,d in ipairs(_GFAN)do
					local origin=hrp.Position+cd*d+Vector3.new(0,3,0)
					local hit=_WSg:Raycast(origin,Vector3.new(0,-70,0),par)
					if hit then
						local m=(hit.Position-hrp.Position).Magnitude
						if m>=10 and m<=50 and(not bestM or m<bestM)then
							pos,target,bestM=hit.Position,hit.Instance,m
						end
					end
				end
			end
		end
		if not pos or not target then
			_G.ElysiumGrappleWhy="no anchor within 10-50 studs"
			return false
		end
		return _grappleDo(tool,pos,target,char)
	end
	_G.ElysiumFireGrappleBoth=_fireGrapple
	function fireGrapple(value,exact)
		local char=LP.Character
		if not char then
			return false
		end
		return _fireGrapple(value,exact)
	end
	_G.ElysiumFireGrapple=fireGrapple
	_G.ElysiumGrappleReady=function()
		return findGrapple()~=nil and _grappleRemoteGet()~=nil
	end
end
CARPET_SPEED=280
INBASE_SPEED=450
SKY_CLONE_WAIT=.35
CARPET_NAMES={"Flying Carpet","Waverider","Santa's Sleigh","Witch's Broom","Cupid's Wings"}
FLY_TOOLS={"Flying Carpet","Waverider","Santa's Sleigh","Witch's Broom","Cupid's Wings"}
function findTool(name)
	local char=LP.Character
	local bp=LP:FindFirstChild("Backpack")
	return(char and char:FindFirstChild(name))or(bp and bp:FindFirstChild(name))
end
GRAPPLE_NAMES={"Grapple Hook"}
function findGrapple()
	for _,n in ipairs(GRAPPLE_NAMES)do
		local t=findTool(n)
		if t and t:IsA("Tool")then
			return t,n
		end
	end
	return nil
end
function listTools()
	local out,char,bp={},LP.Character,LP:FindFirstChild("Backpack")
	if char then
		for _,t in ipairs(char:GetChildren())do
			if t:IsA("Tool")then
				out[#out+1]=t.Name
			end
		end
	end
	if bp then
		for _,t in ipairs(bp:GetChildren())do
			if t:IsA("Tool")then
				out[#out+1]=t.Name
			end
		end
	end
	return table.concat(out,", ")
end
_lastCarpetName=nil
function equipCarpet()
	if _G.ElysiumFlashTeleportActive or _G.ElysiumFlashTeleportRun then
		return nil
	end
	local char=LP.Character
	if not char then
		return nil
	end
	if _lastCarpetName then
		local t=char:FindFirstChild(_lastCarpetName)
		if t and t.Parent==char then
			return _lastCarpetName
		end
	end
	local hum=char:FindFirstChildOfClass("Humanoid")
	if not hum then
		return nil
	end
	for _,n in ipairs(CARPET_NAMES)do
		local t=findTool(n)
		if t and t:IsA("Tool")then
			if t.Parent~=char then
				pcall(function()
					hum:EquipTool(t)
				end)
			end
			_lastCarpetName=n
			return n
		end
	end
	return nil
end
function setCarpetTool(name)
	if type(name)~="string"or name==""then
		return
	end
	_G.ElysiumCarpetTool=name
	_lastCarpetName=nil
	for i=#CARPET_NAMES,1,-1 do
		if CARPET_NAMES[i]==name then
			table.remove(CARPET_NAMES,i)
		end
	end
	table.insert(CARPET_NAMES,1,name)
end
_G.ElysiumSetCarpetTool=setCarpetTool
if type(_G.ElysiumCarpetTool)=="string"and _G.ElysiumCarpetTool~=""then
	setCarpetTool(_G.ElysiumCarpetTool)
end
do
	local GEAR_WORDS={"carpet","waverider","wave rider","broom","sleigh","cupid"}
	local function isGear(inst)
		local n=inst.Name:lower()
		for _,w in ipairs(GEAR_WORDS)do
			if n:find(w,1,true)then
				return true
			end
		end
		return false
	end
	local function setHidden(container,hide)
		local v=hide and 1 or 0
		for _,d in ipairs(container:GetDescendants())do
			if d:IsA("BasePart")or d:IsA("Decal")or d:IsA("Texture")then
				d.LocalTransparencyModifier=v
			end
		end
		if container:IsA("BasePart")then
			container.LocalTransparencyModifier=v
		end
	end
	pcall(RunService.UnbindFromRenderStep,RunService,"ElysiumHideCarpet")
	RunService:BindToRenderStep("ElysiumHideCarpet",Enum.RenderPriority.Camera.Value+1,function()
		pcall(function()
			local char=LP.Character
			if not char then
				return
			end
			local hide=_G.ElysiumHideCarpet~=false
			for _,child in ipairs(char:GetChildren())do
				if not child:IsA("Accessory")and(table.find(CARPET_NAMES,child.Name)or isGear(child))then
					setHidden(child,hide)
				end
			end
		end)
	end)
end
_carpetEngaging=false
do
	local activeTool,removedConnection
	local flightNames={FlightHold=true,FlightPower=true,FlightSpin=true}
	function ElysiumCarpetRouteSweep(root,humanoid)
		for _,object in ipairs(root:GetChildren())do
			if flightNames[object.Name]then object:Destroy()end
		end
		for _,track in ipairs(humanoid:GetPlayingAnimationTracks())do
			if string.lower(track.Name):find("sit",1,true)then pcall(track.Stop,track)end
		end
	end
	function ElysiumFindRouteFlightTool(character)
		if not character then return nil end
		local function valid(tool)return tool and tool:IsA("Tool")end
		local preferred=_G.ElysiumCarpetTool
		if type(preferred)=="string"and preferred~=""then
			local selected=findTool(preferred)
			if valid(selected)then return selected end
		end
		for _,name in ipairs(CARPET_NAMES)do
			local tool=character:FindFirstChild(name)
			if valid(tool)then return tool end
		end
		local last=_G.ElysiumRouteFlightTool
		if type(last)=="string"and last~=""and last~=preferred then
			local tool=findTool(last)
			if valid(tool)then return tool end
		end
		if type(_G.Elysium_CurrentCarpetTool)=="function"then
			local extrasChoice=findTool(_G.Elysium_CurrentCarpetTool())
			if valid(extrasChoice)then return extrasChoice end
		end
		for _,name in ipairs(CARPET_NAMES)do
			local tool=findTool(name)
			if valid(tool)then return tool end
		end
		return nil
	end
	local activeSince,activeWhileDisabled,activeEnabledBefore=0,false,false
	local activeForced=false
	local enabledWatched=setmetatable({},{__mode="k"})
	function ElysiumWatchCarpetEnabled(tool)
		if not tool or enabledWatched[tool]then return end
		enabledWatched[tool]=true
		local lastAt=os.clock()
		local seatedSince=nil
		tool:GetPropertyChangedSignal("Enabled"):Connect(function()
			local log=_G.ElysiumCarpetEnabledLog
			if type(log)~="table"then log={};_G.ElysiumCarpetEnabledLog=log end
			local now=os.clock()
			local held=tool.Parent==LP.Character
			if#log>=8 then table.remove(log,1)end
			log[#log+1]={tool=tool.Name,enabled=tool.Enabled,at=now,since=now-lastAt,
				held=held}
			lastAt=now
			if held and not tool.Enabled then
				seatedSince=now
				_G.ElysiumCarpetMountedAt=now
			elseif held and seatedSince then
				seatedSince=nil
				_G.ElysiumCarpetMountEndedAt=now
			end
			if not tool.Enabled and not held then
				seatedSince=nil
				_G.ElysiumCarpetMountEndedAt=nil
				_G.ElysiumCarpetCooldownEnds=now+(tonumber(_G.ElysiumCarpetCooldown)or 2.05)
			end
		end)
	end
	function ElysiumCarpetForceAllowed()
		return _G.ElysiumCarpetForceEnable==true and _G.ElysiumCarpetForceEnableBad~=true
	end
	function ElysiumPrepareCarpetRoute(noWait,forRoute)
		local character=LP.Character
		local humanoid=character and character:FindFirstChildOfClass("Humanoid")
		local root=character and character:FindFirstChild("HumanoidRootPart")
		if not humanoid or humanoid.Health<=0 or not root then return nil end
		local tool=ElysiumFindRouteFlightTool(character)
		if not tool then
			_G.ElysiumTPMovementStatus="flight_gear_missing"
			_G.ElysiumCarpetRouteError="No selected flight gear available; choose a flight tool in settings"
			return nil
		end
		ElysiumWatchCarpetEnabled(tool)
		local equippedAt=tonumber(_G.ElysiumCarpetEquippedAt)or 0
		if tool.Parent~=character then
			humanoid:EquipTool(tool)
			local deadline=os.clock()+1.5
			while tool.Parent~=character and os.clock()<deadline do
				if _G.ElysiumTPStop or LP.Character~=character then return nil end
				RunService.Heartbeat:Wait()
			end
			equippedAt=os.clock()
			_G.ElysiumCarpetEquippedAt=equippedAt
		end
		if tool.Parent~=character or LP.Character~=character then
			_G.ElysiumTPMovementStatus="flight_gear_equip_failed"
			return nil
		end
		_G.ElysiumCarpetRouteError=nil
		local listed=false
		for _,name in ipairs(CARPET_NAMES)do if name==tool.Name then listed=true;break end end
		if not listed then table.insert(CARPET_NAMES,tool.Name)end
		ElysiumCarpetRouteSweep(root,humanoid)
		local function interrupted()
			return _G.ElysiumTPStop or LP.Character~=character or tool.Parent~=character
				or humanoid.Health<=0
		end
		local function holdStill()
			root.AssemblyLinearVelocity=Vector3.new(0,math.min(root.AssemblyLinearVelocity.Y,0),0)
			RunService.Heartbeat:Wait()
		end
		local function mounted()
			if humanoid.PlatformStand or humanoid:GetState()==Enum.HumanoidStateType.PlatformStanding then
				return true
			end
			for name in pairs(flightNames)do
				if root:FindFirstChild(name)then return true end
			end
			return false
		end
		local prepDiag={tool=tool.Name,at=os.clock(),enabledAtStart=tool.Enabled,
			mountedAtStart=mounted(),cooldownWait=0,engageWait=0,anchoredWait=0,
			noWait=noWait==true}
		_G.ElysiumCarpetPrepDiag=prepDiag
		do
			local history=_G.ElysiumCarpetPrepHistory
			if type(history)~="table"then history={};_G.ElysiumCarpetPrepHistory=history end
			if#history>=6 then table.remove(history,1)end
			history[#history+1]=prepDiag
		end
		local function waitRealCooldown()
			local ends=tonumber(_G.ElysiumCarpetCooldownEnds)
			local untilAt=ends and math.min(os.clock()+2.5,math.max(ends,os.clock()))
				or os.clock()+1
			prepDiag.realCooldownWait=untilAt-os.clock()
			while os.clock()<untilAt do
				if interrupted()then return false end
				holdStill()
			end
			return true
		end
		local mountEndedAt=tonumber(_G.ElysiumCarpetMountEndedAt)or 0
		if forRoute and mountEndedAt>0 and tool.Enabled and not mounted()
			and os.clock()-mountEndedAt<(tonumber(_G.ElysiumCarpetRemountGrace)or 8)then
			prepDiag.unseated=true
			prepDiag.mountEndedAgo=os.clock()-mountEndedAt
			prepDiag.total=os.clock()-prepDiag.at
			_G.TPEngage="flight-speed="..tool.Name
			_G.ElysiumRouteFlightTool=tool.Name
			return tool
		end
		local cooldownEnds=tonumber(_G.ElysiumCarpetCooldownEnds)or 0
		if not noWait and(activeTool~=tool or activeWhileDisabled)and(not tool.Enabled or cooldownEnds>os.clock())
			and not(activeTool==tool and mounted())and not ElysiumCarpetForceAllowed()then
			_G.TPEngage="cooldown="..tool.Name
			local cooldownFrom=os.clock()
			local enableUntil=cooldownFrom+(tonumber(_G.ElysiumCarpetEnableWait)or 2.5)
			local gateUntil=math.min(enableUntil,cooldownEnds)
			while(not tool.Enabled or os.clock()<gateUntil)and os.clock()<enableUntil do
				if interrupted()then
					_G.ElysiumTPMovementStatus="flight_gear_engage_interrupted"
					return nil
				end
				holdStill()
			end
			prepDiag.cooldownWait=os.clock()-cooldownFrom
			prepDiag.cooldownCleared=tool.Enabled
		end
		if activeTool==tool and activeWhileDisabled and tool.Enabled then activeTool=nil end
		local pingOK,ping=pcall(function()return LP:GetNetworkPing()end)
		ping=(pingOK and tonumber(ping))or .1
		local function activate()
			local readyAt=equippedAt+math.clamp(ping+.05,.05,.4)
			while os.clock()<readyAt do
				if interrupted()then return false,"interrupted"end
				holdStill()
			end
			activeForced=false
			if not tool.Enabled and not mounted()and ElysiumCarpetForceAllowed()then
				pcall(function()tool.Enabled=true end)
				if tool.Enabled then
					activeForced=true
					prepDiag.forced=true
					_G.ElysiumCarpetForcedAt=os.clock()
				end
			end
			activeEnabledBefore=tool.Enabled
			local ok,err=pcall(tool.Activate,tool)
			if not ok then return false,err end
			activeSince=os.clock()
			prepDiag.activations=(prepDiag.activations or 0)+1
			return true
		end
		local function activationFailed(err)
			activeTool=nil
			if err=="interrupted"then
				_G.ElysiumTPMovementStatus="flight_gear_engage_interrupted"
			else
				_G.ElysiumTPMovementStatus="carpet_activation_failed"
				_G.ElysiumCarpetRouteError=tostring(err)
			end
			return nil
		end
		if activeTool~=tool then
			if removedConnection then removedConnection:Disconnect()end
			activeTool=tool
			removedConnection=tool.AncestryChanged:Connect(function()
				if tool.Parent~=character then
					if activeTool==tool then activeTool=nil end
					if removedConnection then removedConnection:Disconnect();removedConnection=nil end
				end
			end)
			local ok,err=activate()
			if not ok then return activationFailed(err)end
			activeWhileDisabled=not activeEnabledBefore
		end
		if noWait then
			_G.TPEngage="engaging="..tool.Name
			return tool
		end
		local function ackReceived()
			if activeEnabledBefore and not tool.Enabled then return true end
			if(tonumber(_G.ElysiumCarpetMountedAt)or 0)>=activeSince
				or(tonumber(_G.ElysiumCarpetMountEndedAt)or 0)>=activeSince then
				return true
			end
			return mounted()and os.clock()>=activeSince+math.clamp(ping+.05,.08,.4)
		end
		local function acknowledged()
			if not ackReceived()then return false end
			if not prepDiag.ackAt then prepDiag.ackAt=os.clock()-prepDiag.at end
			if root.Anchored then
				prepDiag.anchoredAtAck=true
				return os.clock()>=activeSince+(tonumber(_G.ElysiumCarpetUnanchorWait)or 1.5)
			end
			return true
		end
		local ackWait=tonumber(_G.ElysiumCarpetEngageDelay)or math.clamp(2*ping+.15,.25,.9)
		local maxTries=math.clamp(tonumber(_G.ElysiumCarpetActivateTries)or 3,1,5)
		if _G.ElysiumCarpetRetryActivate==false then maxTries=1 end
		local engageFrom=os.clock()
		if _G.ElysiumCarpetEngageWait~=false then
			_G.TPEngage="engaging="..tool.Name
			local tries=1
			if activeForced then prepDiag.forced=true end
			while true do
				if interrupted()then
					_G.ElysiumTPMovementStatus="flight_gear_engage_interrupted"
					return nil
				end
				if acknowledged()then break end
				if activeForced and not prepDiag.forceFailed and not ackReceived()
					and os.clock()>=activeSince+ackWait then
					prepDiag.forceFailed=true
					_G.ElysiumCarpetForceEnableBad=true
					_G.TPEngage="cooldown="..tool.Name
					if not waitRealCooldown()then
						_G.ElysiumTPMovementStatus="flight_gear_engage_interrupted"
						return nil
					end
					local ok,err=activate()
					if not ok then return activationFailed(err)end
				elseif not ackReceived()and os.clock()>=activeSince+ackWait then
					if tries>=maxTries then
						prepDiag.ackTimedOut=true
						break
					end
					tries=tries+1
					prepDiag.retried=true
					local ok,err=activate()
					if not ok then return activationFailed(err)end
				end
				holdStill()
			end
			prepDiag.tries=tries
		end
		prepDiag.engageWait=os.clock()-engageFrom
		prepDiag.acknowledged=acknowledged()
		if root.Anchored then
			local anchoredFrom=os.clock()
			local anchoredUntil=anchoredFrom+(tonumber(_G.ElysiumCarpetUnanchorWait)or 1.5)
			_G.TPEngage="anchored="..tool.Name
			while root.Anchored and os.clock()<anchoredUntil do
				if interrupted()then
					_G.ElysiumTPMovementStatus="flight_gear_engage_interrupted"
					return nil
				end
				RunService.Heartbeat:Wait()
			end
			prepDiag.anchoredWait=os.clock()-anchoredFrom
			prepDiag.anchoredCleared=not root.Anchored
		end
		prepDiag.mountedAtEnd=mounted()
		prepDiag.total=os.clock()-prepDiag.at
		_G.TPEngage="flight-speed="..tool.Name
		_G.ElysiumRouteFlightTool=tool.Name
		return tool
	end
	function ElysiumCarpetRouteHorizontal(delta,speed,dt)
		local flat=Vector3.new(delta.X,0,delta.Z)
		local distance=flat.Magnitude
		if distance<.001 then return Vector3.zero end
		return flat.Unit*math.min(speed,distance*.65/math.max(dt,1/240))
	end
	do
		local engaging,readyTool,failedUntil=false,nil,0
		local movingSince,lastAt=0,0
		function ElysiumCarpetSpeedReset()
			readyTool,movingSince,lastAt=nil,0,0
		end
		function ElysiumCarpetSpeedStep(humanoid,root)
			local character=LP.Character
			if not character or not humanoid or not root or root.Parent~=character
				or humanoid.Health<=0 then
				return false
			end
			local velocity=root.AssemblyLinearVelocity
			if engaging then
				root.AssemblyLinearVelocity=Vector3.new(0,math.min(velocity.Y,0),0)
				return true
			end
			if not readyTool or readyTool.Parent~=character then
				readyTool=nil
				if os.clock()<failedUntil then return false end
				engaging=true
				task.spawn(function()
					local ok,tool=pcall(ElysiumPrepareCarpetRoute,nil,true)
					if ok and tool and tool.Parent==LP.Character then
						readyTool=tool
					else
						failedUntil=os.clock()+1
					end
					movingSince,lastAt=os.clock(),os.clock()
					engaging=false
				end)
				root.AssemblyLinearVelocity=Vector3.new(0,math.min(velocity.Y,0),0)
				return true
			end
			local now=os.clock()
			lastAt=now
			if root.Anchored then
				movingSince=now
				return true
			end
			ElysiumCarpetRouteSweep(root,humanoid)
			local direction=humanoid.MoveDirection
			local flat=Vector3.new(direction.X,0,direction.Z)
			if flat.Magnitude<.05 then
				movingSince=now
				root.AssemblyLinearVelocity=Vector3.new(0,velocity.Y,0)
				root.AssemblyAngularVelocity=Vector3.zero
				return true
			end
			local speed=math.clamp(tonumber(_G.ElysiumCarpetSpeedValue)or 120,16,400)
			local rampFloor=tonumber(_G.ElysiumRampStartSpeed)or 24
			local cap=math.min(speed,rampFloor+(speed/.3)*math.max(0,now-movingSince))
			local command=flat.Unit*cap
			root.AssemblyLinearVelocity=Vector3.new(command.X,velocity.Y,command.Z)
			root.AssemblyAngularVelocity=Vector3.zero
			return true
		end
		_G.ElysiumCarpetSpeedStep=ElysiumCarpetSpeedStep
		_G.ElysiumCarpetSpeedReset=ElysiumCarpetSpeedReset
		_G.ElysiumPrepareCarpetRoute=ElysiumPrepareCarpetRoute
		_G.ElysiumFindRouteFlightTool=ElysiumFindRouteFlightTool
	end
end
function carpetEngage(force)
	do
		local tool=ElysiumPrepareCarpetRoute()
		return tool and tool.Name or nil
	end
	if _G.ElysiumFlashTeleportActive or _G.ElysiumFlashTeleportRun then
		return nil
	end
	if not force then
		local c=LP.Character
		if c then
			for _,n in ipairs(CARPET_NAMES)do
				local t=c:FindFirstChild(n)
				if t and t:IsA("Tool")then
					_G.TPEngage="carpet="..tostring(n)
					return n
				end
			end
		end
	end
	if _carpetEngaging then
		local _tw=os.clock()
		repeat
			RunService.Heartbeat:Wait()
		until(not _carpetEngaging)or os.clock()-_tw>6
		local c=LP.Character
		if c then
			for _,n in ipairs(CARPET_NAMES)do
				local t=c:FindFirstChild(n)
				if t and t:IsA("Tool")then
					return n
				end
			end
		end
	end
	_carpetEngaging=true
	local _t0=os.clock()
	while not findTool("Grapple Hook")and os.clock()-_t0<5 do
		RunService.Heartbeat:Wait()
	end
	local char=LP.Character
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if not char or not hum then
		_carpetEngaging=false
		return nil
	end
	if not char:FindFirstChild("Grapple Hook")then
		local g=findTool("Grapple Hook")
		if g then
			pcall(function()
				hum:EquipTool(g)
			end)
		end
	end
	local _te=os.clock()
	while not(LP.Character and LP.Character:FindFirstChild("Grapple Hook"))and os.clock()-_te<1.5 do
		local c=LP.Character
		local h2=c and c:FindFirstChildOfClass("Humanoid")
		local g=findTool("Grapple Hook")
		if g and h2 then
			pcall(function()
				h2:EquipTool(g)
			end)
		end
		RunService.Heartbeat:Wait()
	end
	if LP.Character and LP.Character:FindFirstChild("Grapple Hook")then
		_fireGrapple()
	end
	task.wait(.05)
	local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if h then
		pcall(function()
			h:UnequipTools()
		end)
	end
	task.wait(.05)
	local cn
	local _tc=os.clock()
	repeat
		cn=equipCarpet()
		local c=LP.Character
		if cn and c and c:FindFirstChild(cn)then
			break
		end
		RunService.Heartbeat:Wait()
	until os.clock()-_tc>.5
	local current=LP.Character
	local equipped=current==char and cn and current:FindFirstChild(cn)
	if not equipped or not equipped:IsA("Tool")or equipped.Parent~=char then
		_G.TPEngage="flight_tool_not_equipped"
		_G.ElysiumTPMovementStatus="flight_tool_not_equipped"
		_carpetEngaging=false
		return nil
	end
	_G.TPEngage="carpet="..tostring(cn)
	_carpetEngaging=false
	return cn
end
_G.ElysiumEquipCarpet=equipCarpet
_G.ElysiumCarpetEngaging=function()
	return _carpetEngaging
end
if _G.ElysiumKeepCarpet==nil then
	_G.ElysiumKeepCarpet=true
end
LP.CharacterAdded:Connect(function(c)
	if _G.ElysiumKeepCarpet==false then
		return
	end
	task.spawn(function()
		c:WaitForChild("Humanoid",10)
		task.wait(tonumber(_G.ElysiumCarpetRespawnDelay)or .6)
		if _G.ElysiumKeepCarpet==false then
			return
		end
		if _carpetEngaging or LP.Character~=c then
			return
		end
		if LP:GetAttribute("Stealing")==true then
			return
		end
		for _,n in ipairs(CARPET_NAMES)do
			if c:FindFirstChild(n)then
				return
			end
		end
		pcall(equipCarpet)
	end)
end)
PET_PRIORITY_TIERS={
	[1]={pets={"Headless Horseman"},threshold=0},
	[2]={pets={"Signore Carapace"},threshold=0},
	[3]={pets={"John Pork"},threshold=0},
	[4]={pets={"Strawberry Elephant"},threshold=0},
	[5]={pets={"Arcadragon"},threshold=5e9},
	[6]={pets={"Elefanto Frigo"},threshold=10e9},
	[7]={pets={"Meowl"},threshold=5e9},
	[8]={pets={"Skibidi Toilet"},threshold=5e9},
	[9]={pets={"Love Love Bear"},threshold=0},
	[10]={pets={"Antonio"},threshold=0},
	[11]={pets={"Pancake and Syrup"},threshold=0},
	[12]={pets={"Griffin"},threshold=0},
	[13]={
		pets={"Globa Steppa","La Supreme Combinasion","Fishino Clownino","Dragon Gingerini","Tirilikalika Tirilikalako",},
		threshold=5e9,
	},
	[14]={pets={"Ginger Gerat","Pet"},threshold=10e9},
	[15]={pets={"Hydra Bunny","Digi Narwhal","Kalika Bros"},threshold=3e9},
	[16]={pets={"Hydra Dragon Cannelloni","Dragon Cannelloni","Bunny and Eggy"},threshold=3e9},
	[17]={pets={"Ketupat Bros","Rosey and Teddy","La Casa Boo","Fragola la la"},threshold=3e9},
	[18]={pets={"Fragola La La La","Cerberus","Guest 666","Los Hackers"},threshold=1e9},
	[19]={
		pets={"Garama and Madunung","Spooky and Pumpky","Reinito Sleighito","Burguro And Fryuro","Cooki and Milki","Fragrama and Chocrama","La Food Combinasion","Los Amigos","Foxini Lanternini","Capitano Moby","Fortunu and Cashuru","Los Sekolahs","Celestial Pegasus",},
		threshold=750e6,
	},
	[20]={
		pets={"La Secret Combinasion","Sammyni Fattini","Cloverat Clapat","Popcuru and Fizzuru"},
		threshold=1e9,
	},
}
TIER_LOOKUP={}
for tier,data in pairs(PET_PRIORITY_TIERS)do
	for _,name in ipairs(data.pets)do
		TIER_LOOKUP[name]=tier
	end
end
LOCKED_TIERS={[1]=true,[2]=true,[3]=true,[4]=true}
DIRECT_THRESHOLDS={
	[3]={[4]=10e9},
	[4]={},
	[5]={[6]=math.huge},
	[6]={[9]=math.huge,[10]=math.huge,[12]=15e9},
	[10]={[12]=20e9},
	[11]={[12]=10e9},
}
MUTATION_PRIORITY={["Galaxy"]=1,["Candy"]=1,["Yin Yang"]=1,["YinYang"]=1,["Divine"]=1,["Cursed"]=1,["Lava"]=1,["Radioactive"]=1,["Cyber"]=1,["Rainbow"]=1,["Bloodrot"]=2,}
TRAIT_PRIORITY={}
MUTATION_ICONS,TRAIT_ICONS={},{}
local function _mutationDisplayName(name)
	local text=tostring(name or"")
	return text:lower():gsub("[%s%-_]","")=="yinyang"and"Yin Yang"or text
end
local function _iconForName(icons,name)
	if type(icons)~="table"then
		return nil
	end
	local exact=icons[name]
	if exact then
		return exact
	end
	local wanted=tostring(name or""):lower():gsub("[%s%-_]","")
	for key,icon in pairs(icons)do
		if tostring(key):lower():gsub("[%s%-_]","")==wanted then
			return icon
		end
	end
	return nil
end
function _ElysiumLoadGameData()
	local ok1,mData=pcall(function()
		return require(game.ReplicatedStorage.Datas.Mutations)
	end)
	if ok1 and type(mData)=="table"then
		local mList={}
		for name,data in pairs(mData)do
			if type(data)=="table"then
				MUTATION_ICONS[name]=data.Icon
				mList[#mList+1]=name
			end
		end
		table.sort(mList)
		if#_G.SHARED_MUTATION_PRIORITY==0 then
			for i=1,#mList do
				_G.SHARED_MUTATION_PRIORITY[i]=mList[i]
			end
		end
	end
	local ok2,tData=pcall(function()
		return require(game.ReplicatedStorage.Datas.Traits)
	end)
	if ok2 and type(tData)=="table"then
		local tList={}
		for name,data in pairs(tData)do
			if type(data)=="table"then
				TRAIT_ICONS[name]=data.Icon
				tList[#tList+1]=name
			end
		end
		table.sort(tList)
		if#_G.SHARED_TRAIT_PRIORITY==0 then
			for i=1,#tList do
				_G.SHARED_TRAIT_PRIORITY[i]=tList[i]
			end
		end
	end
end
task.spawn(function()
	pcall(function()
		local Datas=ElysiumService("ReplicatedStorage"):FindFirstChild("Datas")
		local a=Datas and Datas:FindFirstChild("Animals")
		if a and not AnimalsData then
			AnimalsData=require(a)
		end
		if AnimalsData then
			_ElysiumBuildDefaultBrainrotPriority()
		end
	end)
	pcall(_ElysiumLoadGameData)
end)
function getMutPrio(m)
	if not m or m==""or m=="None"then
		return 0
	end
	local n=tostring(m)
	local dis=_G.SHARED_MUTATION_DISABLED
	if type(dis)=="table"and(dis[n]or dis[_normName(n)])then
		return 0
	end
	local idx=_priIndexOfMut(n)
	if not idx then
		n=n:lower():gsub("[%s%-_]","")
		idx=_priIndexOfMut(n)
	end
	if idx then
		return 999-idx
	end
	if MUTATION_PRIORITY[m]then
		return MUTATION_PRIORITY[m]
	end
	if MUTATION_PRIORITY[n]then
		return MUTATION_PRIORITY[n]
	end
	return 0
end
function getTraitPrio(t)
	if not t or t==""then
		return 0
	end
	local name=type(t)=="table"and t.name or tostring(t)
	local n=name
	local idx=_priIndexOfTrait(n)
	if not idx then
		n=n:lower():gsub("[%s%-_]","")
		idx=_priIndexOfTrait(n)
	end
	if idx then
		return 999-idx
	end
	if TRAIT_PRIORITY[name]then
		return TRAIT_PRIORITY[name]
	end
	if TRAIT_PRIORITY[n]then
		return TRAIT_PRIORITY[n]
	end
	return 0
end
function getCumThreshold(hi,lo)
	if DIRECT_THRESHOLDS[hi]and DIRECT_THRESHOLDS[hi][lo]then
		return DIRECT_THRESHOLDS[hi][lo]
	end
	if LOCKED_TIERS[hi]then
		return math.huge
	end
	local total=0
	for t=hi+1,lo do
		local td=PET_PRIORITY_TIERS[t]
		if td and td.threshold>0 then
			total=total+td.threshold
		end
	end
	return total
end
function _normName(s)
	return tostring(s):lower():gsub("[%s%-_'%.]","")
end
_priCacheVer,_priCache=-1,{}
_brainrotDefaultPri={}
_brainrotDefaultRarity={}
_mutPriCacheVer,_mutPriCache=-1,{}
_traitPriCacheVer,_traitPriCache=-1,{}
function _priLookup(listName)
	local ver=_G.ElysiumPriVersion or 0
	if listName=="mutation"then
		if _mutPriCacheVer~=ver then
			table.clear(_mutPriCache)
			local plist=_G.SHARED_MUTATION_PRIORITY
			if type(plist)=="table"then
				for i=#plist,1,-1 do
					_mutPriCache[_normName(plist[i])]=i
				end
			end
			_mutPriCacheVer=ver
		end
		return _mutPriCache
	elseif listName=="trait"then
		if _traitPriCacheVer~=ver then
			table.clear(_traitPriCache)
			local plist=_G.SHARED_TRAIT_PRIORITY
			if type(plist)=="table"then
				for i=#plist,1,-1 do
					_traitPriCache[_normName(plist[i])]=i
				end
			end
			_traitPriCacheVer=ver
		end
		return _traitPriCache
	else
		if _priCacheVer~=ver then
			table.clear(_priCache)
			local plist=_G.SHARED_PRIORITY_ITEMS
			if type(plist)=="table"then
				for i=#plist,1,-1 do
					_priCache[_normName(plist[i])]=i
				end
			end
			_priCacheVer=ver
		end
		return _priCache
	end
end
_G.ElysiumPriLookup=function()
	return _priLookup()
end
function _priIndexOf(name)
	if not name then
		return nil
	end
	local n=_normName(name)
	local idx=_priLookup()[n]
	if idx then
		return idx
	end
	local def=_brainrotDefaultPri[n]
	if def and _brainrotDefaultRarity[n]=="OG"then
		return def*.001
	end
	return nil
end
function _priIndexOfMut(name)
	if not name then
		return nil
	end
	return _priLookup("mutation")[_normName(name)]
end
function _priIndexOfTrait(name)
	if not name then
		return nil
	end
	return _priLookup("trait")[_normName(name)]
end
function petOutranks(aName,bName,aMut,bMut,aMPS,bMPS,aTraits,bTraits)
	local iA=_priIndexOf(aName)
	local iB=_priIndexOf(bName)
	if iA~=nil and iB~=nil then
		if iA~=iB then
			return iA<iB
		end
	end
	if(iA~=nil)~=(iB~=nil)then
		return iA~=nil
	end
	if iA==nil and iB==nil then
		if(aMPS or 0)~=(bMPS or 0)then
			return(aMPS or 0)>(bMPS or 0)
		end
	end
	local ma,mb=getMutPrio(aMut),getMutPrio(bMut)
	if ma~=mb then
		return ma>mb
	end
	if type(aTraits)=="table"and type(bTraits)=="table"then
		local pa,pb=0,0
		for _,t in ipairs(aTraits)do
			pa=math.max(pa,getTraitPrio(t))
		end
		for _,t in ipairs(bTraits)do
			pb=math.max(pb,getTraitPrio(t))
		end
		if pa~=pb then
			return pa>pb
		end
	end
	return(aMPS or 0)>(bMPS or 0)
end
function getPlotChannel(plotName)
	local env=type(getgenv)=="function"and getgenv()or _G
	local bridge=env.ElysiumDataBridge or _G.ElysiumDataBridge
	if type(bridge)=="table"and bridge.game==game and bridge.workspace==workspace then
		local data=bridge.plots and bridge.plots[tostring(plotName)]
		_G.ElysiumScanDataSource="loader-v2.4"
		return type(data)=="table"and data or nil
	end
	local runtime=env.ElysiumRuntime or _G.ElysiumRuntime
	if runtime and runtime.game==game and runtime.workspace==workspace and runtime.stage~="net_failed"and runtime.stage~="dependency_failed"then return nil end
	local channel
	pcall(function()
		channel=_G.ElysiumSyncGet(plotName)
	end)
	return channel
end
function channelGet(channel,key)
	if not channel then
		return nil
	end
	local ok,v=pcall(function()
		local ct=rawget(channel,"CacheTable")
		if type(ct)=="table"then
			local r=rawget(ct,key)
			if r~=nil then
				return r
			end
		end
		local d=rawget(channel,"Data")
		if type(d)=="table"then
			local r=rawget(d,key)
			if r~=nil then
				return r
			end
		end
		return rawget(channel,key)
	end)
	if ok then
		return v
	end
	return nil
end
function _ownerIsMe(owner)
	if not owner then
		return false
	end
	local result=false
	pcall(function()
		if typeof(owner)=="Instance"and owner:IsA("Player")then
			result=owner.UserId==LP.UserId
		elseif type(owner)=="table"and owner.UserId then
			result=owner.UserId==LP.UserId
		elseif typeof(owner)=="Instance"then
			result=owner==LP
		elseif type(owner)=="string"then
			result=owner:lower()==LP.Name:lower()or owner:lower()==(LP.DisplayName or LP.Name):lower()
		end
	end)
	return result
end
function isMyPlot(channel)
	if not channel then
		return false
	end
	return _ownerIsMe(channelGet(channel,"Owner"))
end
_ownerInGameCache,_ownerInGameAt={},{}
function _ownerInGame(owner)
	if not owner then
		return false
	end
	local cacheKey
	if typeof(owner)=="Instance"then
		cacheKey="i:"..tostring(owner)
	elseif type(owner)=="number"then
		cacheKey="n:"..owner
	elseif type(owner)=="string"then
		cacheKey="s:"..owner:lower()
	else
		cacheKey="o:"..tostring(owner)
	end
	local now=os.clock()
	local cached=_ownerInGameAt[cacheKey]
	if cached and(now-cached.t)<2 then
		return cached.v
	end
	local inGame=false
	pcall(function()
		if typeof(owner)=="Instance"and owner:IsA("Player")then
			inGame=owner.Parent==Players
		elseif type(owner)=="number"then
			inGame=Players:GetPlayerByUserId(owner)~=nil
		elseif type(owner)=="table"and owner.Name then
			inGame=Players:FindFirstChild(tostring(owner.Name))~=nil
		elseif typeof(owner)=="Instance"and owner.Name then
			inGame=Players:FindFirstChild(owner.Name)~=nil
		elseif type(owner)=="string"then
			if Players:FindFirstChild(owner)then
				inGame=true
			else
				local lo=owner:lower()
				for _,pl in ipairs(Players:GetPlayers())do
					if pl.Name:lower()==lo or(pl.DisplayName or""):lower()==lo then
						inGame=true
						break
					end
				end
			end
		end
	end)
	_ownerInGameCache[cacheKey]={v=inGame,t=now}
	_ownerInGameAt[cacheKey]={v=inGame,t=now}
	return inGame
end
function ownerInGame(channel)
	if not channel then
		return false
	end
	return _ownerInGame(channelGet(channel,"Owner"))
end
_petModelCache=setmetatable({},{__mode="v"})
_genCache={}
local _MPS_SUFFIX={K=1e3,M=1e6,B=1e9,T=1e12,Q=1e15}
_wmpsCache,_wmpsAt={},{}
function _worldMPS(plot,slot)
	local podiums=plot and plot:FindFirstChild("AnimalPodiums")
	local podium=podiums and podiums:FindFirstChild(tostring(slot))
	if not podium then
		return nil
	end
	local _ck=plot.Name.."\0"..tostring(slot)
	local _now=os.clock()
	if _wmpsAt[_ck]and(_now-_wmpsAt[_ck])<(tonumber(_G.ElysiumWorldMPSTTL)or 1)then
		return _wmpsCache[_ck]
	end
	local best=nil
	local function _scanLabels(parent)
		for _,child in ipairs(parent:GetChildren())do
			if child:IsA("TextLabel")or child:IsA("TextButton")then
				local txt=child.Text
				if type(txt)=="string"and txt~=""then
					local num,suf=txt:match("%$%s*([%d%.]+)%s*([KMBTQ]?)%s*/s")
					if num then
						local v=tonumber(num)
						if v then
							v=v*(_MPS_SUFFIX[suf]or 1)
							if not best or v>best then
								best=v
							end
						end
					end
				end
			end
			_scanLabels(child)
		end
	end
	_scanLabels(podium)
	_wmpsCache[_ck],_wmpsAt[_ck]=best,_now
	return best
end
_petPosCache={}
function _petPosLookup(key,podium,strict)
	local hit=_petPosCache[key]
	if not hit or hit.podium~=podium then
		return false
	end
	local ttl=hit.model and(tonumber(_G.ElysiumPetPosTTL)or 1)or(tonumber(_G.ElysiumPetPosMissTTL)or .75)
	if os.clock()-hit.t>ttl then
		return false
	end
	if hit.model or not strict then
		return true,hit.pos
	end
	return true,nil
end
function _petPosStore(key,podium,pos,model)
	_petPosCache[key]={t=os.clock(),podium=podium,pos=pos,model=model}
	return pos
end
function getPetPosition(plot,slot,strict)
	local podiums=plot:FindFirstChild("AnimalPodiums")
	if not podiums then
		return nil
	end
	local podium=podiums:FindFirstChild(tostring(slot))
	if not podium then
		return nil
	end
	local key=plot.Name.."\0"..tostring(slot)
	do
		local found,pos=_petPosLookup(key,podium,strict)
		if found then
			return pos
		end
	end
	local cached=_petModelCache[key]
	if cached and cached.Parent and cached:IsDescendantOf(podium)then
		local ok,cf=pcall(function()
			return cached:GetBoundingBox()
		end)
		if ok then
			return _petPosStore(key,podium,cf.Position,true)
		end
	end
	_petModelCache[key]=nil
	local _skipNames={Claim=true,Base=true,Decorations=true}
	local function _findModel(parent)
		for _,child in ipairs(parent:GetChildren())do
			if _skipNames[child.Name]then continue end
			if child:IsA("Model")and not _skipNames[child.Name]then
				if child:FindFirstChildWhichIsA("MeshPart",true)then
					return child
				end
			end
			local found=_findModel(child)
			if found then
				return found
			end
		end
		return nil
	end
	local model=_findModel(podium)
	if model then
		local ok,cf=pcall(function()
			return model:GetBoundingBox()
		end)
		if ok then
			_petModelCache[key]=model
			return _petPosStore(key,podium,cf.Position,true)
		end
	end
	local fallback
	pcall(function()
		local base=podium:FindFirstChild("Base")
		local spawn=base and base:FindFirstChild("Spawn")
		if spawn and spawn:IsA("BasePart")then
			fallback=spawn.Position+Vector3.new(0,spawn.Size.Y*.5+2.5,0)
		end
	end)
	local ok,cf=true,nil
	if fallback==nil then
		ok,cf=pcall(function()
			return podium:GetPivot()
		end)
		fallback=ok and cf and cf.Position or nil
	end
	if fallback==nil then
		pcall(function()
			fallback=podium.Position
		end)
	end
	_petPosStore(key,podium,fallback,false)
	if strict then
		return nil
	end
	return fallback
end
_G.ElysiumMinMPS=0
function scanAllPets()
	local pets={}
	local optimizerPets={}
	local optimizerPending=0
	_G.ElysiumOptimizerScanPending=1
	if not loadModules()then
		_G.ElysiumScanTotal,_G.ElysiumScanUsed,_G.ElysiumScanNoChan=0,0,8
		return pets
	end
	local Plots=workspace:FindFirstChild("Plots")
	if not Plots then
		_G.ElysiumScanTotal,_G.ElysiumScanUsed,_G.ElysiumScanNoChan=0,0,8
		return pets
	end
	local _mkSeen,_mkUse,_mkTotal=0,0,0
	local _mkNoChan=0
	local _mkTags={}
	local plotInventory=_G.ElysiumOptimizerPlotInventory and _G.ElysiumOptimizerPlotInventory(Plots)or Plots:GetChildren()
	for _,plot in ipairs(plotInventory)do
		_mkTotal=_mkTotal+1
		local channel=getPlotChannel(plot.Name)
		if not channel then
			_mkTags[#_mkTags+1]="nochan"
			_mkNoChan=_mkNoChan+1
			continue
		end
		_mkSeen=_mkSeen+1
		local owner=channelGet(channel,"Owner")
		if _ownerIsMe(owner)then
			_G.ElysiumMyPlot=plot.Name
			_mkTags[#_mkTags+1]="MINE"
			continue
		end
		if _G.ElysiumMyPlot==plot.Name then
			_mkTags[#_mkTags+1]="MINE"
			continue
		end
		if not _G.ElysiumMyPlot and owner==nil then
			_mkTags[#_mkTags+1]="noowner?"
			continue
		end
		if _G.ElysiumRequireOwner~=false and not _ownerInGame(owner)then
			_mkTags[#_mkTags+1]="left"
			continue
		end
		_mkUse=_mkUse+1
		local animalList=channelGet(channel,"AnimalList")
		if type(animalList)~="table"then
			optimizerPending+=1
			_mkTags[#_mkTags+1]="nolist"
			continue
		end
		local _mkPlotN=0
		for slot,animalData in pairs(animalList)do
			if type(animalData)~="table"then
				continue
			end
			local animalName=animalData.Index
			if not animalName then
				continue
			end
			local animalInfo=AnimalsData and AnimalsData[animalName]
			if not animalInfo and _G.ElysiumRequireKnown==true then
				continue
			end
			if _ElysiumIsFusing(animalData)then
				continue
			end
			local mutation=animalData.Mutation or"None"
			local traits=animalData.Traits
			if type(traits)~="table"then
				traits={}
			end
			local genValue
			local _gk=plot.Name.."\0"..tostring(slot)
			local _gc=_genCache[_gk]
			local _tk=""
			local _sameTraits=_gc and _gc.t==animalData.Traits
			if not _sameTraits then
				local parts={}
				for i,tr in ipairs(traits)do
					parts[i]=tostring(type(tr)=="table"and tr.name or tr)
				end
				_tk=table.concat(parts,",")
			end
			if _gc and _gc.n==animalName and _gc.m==animalData.Mutation and(_sameTraits or _gc.tk==_tk)then
				genValue=_gc.g
			else
				genValue=0
				pcall(function()
					local shim=AnimalsShared or _G.ElysiumAnimShim
					if shim then
						genValue=shim:GetGeneration(animalName,animalData.Mutation,animalData.Traits,nil)
					end
				end)
				if genValue and genValue>0 then
					_genCache[_gk]={n=animalName,m=animalData.Mutation,t=animalData.Traits,tk=_tk,g=genValue}
				end
			end
			if(not genValue or genValue<=0)and _G.ElysiumWorldMPS~=false then
				local wm=_worldMPS(plot,slot)
				if wm and wm>0 then
					genValue=wm
				end
			end
			local displayName=(animalInfo and animalInfo.DisplayName)or animalName
			local pos=getPetPosition(plot,slot,(_G.ElysiumRequireOwner==false)or(_G.ElysiumRequireModel==true))
			do
				local minScanMps=0
				local resolvedMps=tonumber(genValue)or 0
				if resolvedMps>=minScanMps then
					local candidate={
						name=displayName,
						index=animalName,
						mps=resolvedMps,
						mutation=mutation,
						traits=traits,
						position=pos,
						plot=plot.Name,
						slot=tostring(slot),
					}
					table.insert(optimizerPets,candidate)
					if pos then
						table.insert(pets,candidate)
					end
					_mkPlotN=_mkPlotN+1
				end
			end
		end
		_mkTags[#_mkTags+1]=tostring(_mkPlotN)
	end
	_G.ElysiumScanTotal,_G.ElysiumScanUsed,_G.ElysiumScanNoChan=_mkTotal,_mkUse,_mkNoChan
	_G.ElysiumScanInfo=string.format(
		"plots %d scanned of %d  pets %d  [%s]  %s",
		_mkUse,
		_mkTotal,
		#pets,
		table.concat(_mkTags," "),
		tostring(_G.ElysiumScanMode)
	)
	local function _bestTraitPrio(traits)
		if type(traits)~="table"then
			return 0
		end
		local best=0
		for _,t in ipairs(traits)do
			local p=getTraitPrio(t)
			if p>best then
				best=p
			end
		end
		return best
	end
	_G.ElysiumOptimizerScanPending=optimizerPending
	for _,p in ipairs(optimizerPets)do
		p._pri=_priIndexOf(p.name)or(p.index and _priIndexOf(p.index))or nil
		p._mp=tonumber(p.mps)or 0
		p._mut=getMutPrio(p.mutation)
		p._trait=_bestTraitPrio(p.traits)
	end
	local function _petOrder(a,b)
		local ia,ib=a._pri,b._pri
		if(ia~=nil)~=(ib~=nil)then
			return ia~=nil
		end
		if ia and ib and ia~=ib then
			return ia<ib
		end
		if ia==nil then
			if a._mp~=b._mp then
				return a._mp>b._mp
			end
		end
		if a._mut~=b._mut then
			return a._mut>b._mut
		end
		if a._trait~=b._trait then
			return a._trait>b._trait
		end
		if a._mp~=b._mp then
			return a._mp>b._mp
		end
		local pa,pb=tostring(a.plot),tostring(b.plot)
		if pa~=pb then
			return pa<pb
		end
		return(tonumber(a.slot)or 0)<(tonumber(b.slot)or 0)
	end
	local mode=_G.ElysiumStealMode
	if mode=="highest"then
		table.sort(pets,function(a,b)
			local ma,mb=tonumber(a.mps)or 0,tonumber(b.mps)or 0
			if ma~=mb then
				return ma>mb
			end
			local pa,pb=tostring(a.plot),tostring(b.plot)
			if pa~=pb then
				return pa<pb
			end
			return(tonumber(a.slot)or 0)<(tonumber(b.slot)or 0)
		end)
		table.sort(optimizerPets,function(a,b)
			local ma,mb=tonumber(a.mps)or 0,tonumber(b.mps)or 0
			if ma~=mb then
				return ma>mb
			end
			local pa,pb=tostring(a.plot),tostring(b.plot)
			if pa~=pb then
				return pa<pb
			end
			return(tonumber(a.slot)or 0)<(tonumber(b.slot)or 0)
		end)
		if _G.ElysiumOptimizerOnScan then
			_G.ElysiumOptimizerOnScan(optimizerPets)
		end
		return pets
	end
	table.sort(pets,_petOrder)
	table.sort(optimizerPets,_petOrder)
	if _G.ElysiumOptimizerOnScan then
		_G.ElysiumOptimizerOnScan(optimizerPets)
	end
	return pets
end
_G.ElysiumScanAllPets=scanAllPets
_scanShared,_scanSharedAt=nil,0
function scanAllPetsCached(maxAge)
	local now=os.clock()
	local age=math.max(tonumber(maxAge)or .15,tonumber(_G.ElysiumScanMinAge)or .1)
	if _scanShared and(now-_scanSharedAt)<=age then
		return _scanShared
	end
	local ok,p=pcall(scanAllPets)
	if ok and type(p)=="table"then
		_scanShared,_scanSharedAt=p,now
		return p
	end
	return nil
end
_G.ElysiumScanCached=scanAllPetsCached
function scanForTP()
	local inBoot=_gameLoadAt and(os.clock()-_gameLoadAt)<4
	local full=scanAllPetsCached(tonumber(_G.ElysiumScanCacheAge)or(inBoot and .1 or .2))
	if type(full)~="table"then
		full={}
	end
	if _G.ElysiumScanTiered and _G.ElysiumUseTiered~=false then
		local ok,tiered=pcall(_G.ElysiumScanTiered)
		if ok and type(tiered)=="table"and#tiered>0 then
			local seen={}
			for _,p in ipairs(full)do
				if p and p.plot and p.slot~=nil then
					seen[tostring(p.plot).."_"..tostring(p.slot)]=true
				end
			end
			for _,p in ipairs(tiered)do
				if p and p.plot and p.slot~=nil then
					local uid=tostring(p.plot).."_"..tostring(p.slot)
					if not seen[uid]and(tonumber(p.mps)or 0)>=0 then
						seen[uid]=true
						full[#full+1]=p
					end
				end
			end
		end
	end
	return full
end
function _petUid(p)
	if not p then
		return nil
	end
	return tostring(p.plot).."_"..tostring(p.slot)
end
do
	local markerSize=Vector3.new(4.5,4.5,4.5)
	local function cubeSize(extent)
		local minEdge=tonumber(_G.ElysiumBlackCubeMin)or 4.5
		local maxEdge=tonumber(_G.ElysiumBlackCubeMax)or 10
		local edge=math.clamp(extent,minEdge,maxEdge)
		return Vector3.new(edge,edge,edge)
	end
	local function markerFrame(pet)
		local plots=workspace:FindFirstChild("Plots")
		local plot=plots and plots:FindFirstChild(tostring(pet.plot))
		local podiums=plot and plot:FindFirstChild("AnimalPodiums")
		local podium=podiums and podiums:FindFirstChild(tostring(pet.slot))
		local model=_petModelCache[tostring(pet.plot).."\0"..tostring(pet.slot)]
		if model and model.Parent and podium and model:IsDescendantOf(podium)then
			local ok,frame,size=pcall(model.GetBoundingBox,model)
			if ok then
				local edge=math.max(size.X,size.Z,size.Y*.8)
				local cube=cubeSize(edge)
				local bottom=frame.Position.Y-size.Y*.5
				return CFrame.new(frame.Position.X,bottom+cube.Y*.5,frame.Position.Z),cube
			end
		end
		local cube=cubeSize(tonumber(_G.ElysiumBlackCubeDefault)or 6)
		local base=podium and podium:FindFirstChild("Base")
		local spawn=base and base:FindFirstChild("Spawn")
		if spawn and spawn:IsA("BasePart")then
			return CFrame.new(spawn.Position+Vector3.new(0,spawn.Size.Y*.5+cube.Y*.5,0)),cube
		end
		if podium then
			local ok,frame=pcall(podium.GetPivot,podium)
			if ok then return CFrame.new(frame.Position+Vector3.new(0,cube.Y*.5,0)),cube end
		end
		if typeof(pet.position)=="Vector3"then
			return CFrame.new(pet.position),cube
		end
		return nil
	end
	local old=workspace:FindFirstChild("ElysiumBrainrotLabels")
	if old then old:Destroy()end
	local folder=Instance.new("Folder")
	folder.Name="ElysiumBrainrotLabels"
	folder.Parent=workspace
	local anchor=Instance.new("Part")
	anchor.Name="ElysiumTargetBounds"
	anchor.Anchored,anchor.CanCollide,anchor.CanTouch,anchor.CanQuery=true,false,false,false
	anchor.CastShadow=false
	anchor.Material=Enum.Material.SmoothPlastic
	anchor.Color=Color3.fromRGB(0,0,0)
	anchor.Transparency=1
	anchor.Size=markerSize
	anchor:SetAttribute("ElysiumLocalInvisVisual",true)
	anchor.Parent=folder
	local box=Instance.new("SelectionBox")
	box.Name="ElysiumBlackTargetBox"
	box.Color3=Color3.fromRGB(0,0,0)
	box.SurfaceColor3=box.Color3
	box.SurfaceTransparency=0
	box.LineThickness=.045
	box.Visible=false
	box.Adornee,box.Parent=anchor,folder
	local violet=Color3.fromRGB(166,75,255)
	local stage=Instance.new("Part")
	stage.Name="ElysiumBestBrainrotPurplePodium"
	stage.Anchored=true
	stage.CanCollide=false
	stage.CanTouch=false
	stage.CanQuery=false
	stage.CastShadow=false
	stage.Material=Enum.Material.Neon
	stage.Color=violet
	stage.Transparency=.35
	stage.Size=Vector3.new(4.5,4.5,4.5)
	stage:SetAttribute("ElysiumLocalInvisVisual",true)
	stage.Parent=folder
	local stageEdge=Instance.new("SelectionBox")
	stageEdge.Name="ElysiumBestPodiumOutline"
	stageEdge.Color3=violet
	stageEdge.SurfaceColor3=violet
	stageEdge.SurfaceTransparency=.75
	stageEdge.LineThickness=.075
	stageEdge.Visible=false
	stageEdge.Adornee=stage
	stageEdge.Parent=folder
	local stageGlow=Instance.new("Highlight")
	stageGlow.Name="ElysiumBestPodiumGlow"
	stageGlow.Adornee=stage
	stageGlow.FillColor=violet
	stageGlow.OutlineColor=violet
	stageGlow.FillTransparency=.5
	stageGlow.OutlineTransparency=0
	stageGlow.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
	stageGlow.Enabled=false
	stageGlow.Parent=folder
	local function podiumFrame(pet)
		if not pet then return nil end
		local size=Vector3.new(4.5,4.5,4.5)
		local plots=workspace:FindFirstChild("Plots")
		local plot=plots and pet.plot and plots:FindFirstChild(tostring(pet.plot))
		local collection=plot and plot:FindFirstChild("AnimalPodiums")
		local podium=collection and pet.slot and collection:FindFirstChild(tostring(pet.slot))
		if podium then
			local model=_petModelCache[tostring(pet.plot).."\0"..tostring(pet.slot)]
			if model and model.Parent and model:IsDescendantOf(podium)then
				local ok,frame,bounds=pcall(function()return model:GetBoundingBox()end)
				if ok and frame and bounds and bounds.Magnitude>.1 then
					local extent=math.max(bounds.X,bounds.Y,bounds.Z)
					return CFrame.new(frame.Position),Vector3.one*math.clamp(extent*1.1,4.5,12)
				end
			end
		end
		if typeof(pet.position)=="Vector3"then
			return CFrame.new(pet.position+Vector3.new(0,2.25,0)),size
		end
		if podium then
			local spawn=podium:FindFirstChild("Spawn",true)
			if spawn and spawn:IsA("BasePart")then
				return CFrame.new(spawn.Position+Vector3.new(0,spawn.Size.Y*.5+size.Y*.5,0)),size
			end
			local ok,cf=pcall(function()return podium:GetPivot()end)
			if ok and cf then return CFrame.new(cf.Position+Vector3.new(0,size.Y*.5+2.25,0)),size end
		end
		return nil
	end
	task.spawn(function()
		while _G.ElysiumMainLoadedGame==game do
			local shown=false
			pcall(function()
				if _G.ElysiumOptimizerMode=="default"or _G.ElysiumBlackCubeAlways==true then
					local pets=scanAllPetsCached(.15)or{}
					local pet=pets[1]
					if pet then
						local frame,size=markerFrame(pet)
						if frame then
							anchor.CFrame=frame
							if size and anchor.Size~=size then anchor.Size=size end
							shown=true
						end
					end
				end
			end)
			local purpleShown=false
			pcall(function()
				if _G.ElysiumPurpleBestPodium~=false then
					local pets=scanAllPetsCached(.15)or{}
					if#pets==0 then pets=scanForTP()or{}end
					if#pets==0 and type(_G.ElysiumScanTiered)=="function"then
						local ok,tiered=pcall(_G.ElysiumScanTiered)
						if ok and type(tiered)=="table"then pets=tiered end
					end
					_G.ElysiumPurplePodiumCandidates=#pets
					for _,candidate in ipairs(pets)do
						if not candidate.conveyor then
							local cf,size=podiumFrame(candidate)
							if cf then
								stage.CFrame=cf
								if size then stage.Size=size end
								purpleShown=true
								_G.ElysiumPurplePodiumTarget=tostring(candidate.name or candidate.index or"unknown")
								break
							end
						end
					end
					if not purpleShown then
						_G.ElysiumPurplePodiumTarget=nil
					end
				end
			end)
			_G.ElysiumPurplePodiumStatus=purpleShown and"visible"or
				("no target position (candidates="..tostring(_G.ElysiumPurplePodiumCandidates or 0)..")")
			stage.Transparency=purpleShown and .1 or 1
			stage.LocalTransparencyModifier=0
			stageEdge.Visible=purpleShown
			stageGlow.Enabled=purpleShown
			stageGlow.Adornee=stage
			stageEdge.Color3=violet
			stage.Color=violet
			if stage.Parent~=folder then stage.Parent=folder end
			if stageEdge.Parent~=folder then stageEdge.Parent=folder end
			if stageGlow.Parent~=folder then stageGlow.Parent=folder end
			box.Visible=shown and not purpleShown
			anchor.Transparency=(shown and not purpleShown)and 0 or 1
			anchor.LocalTransparencyModifier=0
			if anchor.Color~=Color3.new(0,0,0)then anchor.Color=Color3.new(0,0,0)end
			if anchor.Parent~=folder then anchor.Parent=folder end
			if folder.Parent~=workspace then folder.Parent=workspace end
			task.wait(.1)
		end
	end)
end
function _pickPetOnFoot(pets,myPos)
	if not pets or#pets==0 then
		return nil
	end
	local best
	if _G.ElysiumStealMode=="nearest"and myPos then
		local bestD=math.huge
		for _,p in ipairs(pets)do
			if not p.conveyor and p.position then
				local d=(p.position-myPos).Magnitude
				if d<bestD then
					bestD=d
					best=p
				end
			end
		end
	else
		for _,p in ipairs(pets)do
			if not p.conveyor then
				best=p
				break
			end
		end
	end
	return best or pets[1]
end
function _findTPSyncedPet(pets)
	local uid=_G.ElysiumStealTargetUID
	if type(uid)~="string"or uid==""then
		return nil
	end
	for _,p in ipairs(pets)do
		if _petUid(p)==uid then
			return p
		end
	end
	return nil
end
function _clearTPSync()
	_G.ElysiumTPSyncActive=false
	_G.ElysiumStealTargetUID=nil
	_G.ElysiumStealTarget=nil
end
function _armTPSync(pet)
	if not pet then
		return
	end
	_G.ElysiumStealTargetUID=_petUid(pet)
	_G.ElysiumStealTarget=pet
	_G.ElysiumTPSyncActive=true
	local gen=(_G._ElysiumTPSyncGen or 0)+1
	_G._ElysiumTPSyncGen=gen
	task.delay(12,function()
		if _G._ElysiumTPSyncGen==gen then
			_clearTPSync()
		end
	end)
end
_G.ElysiumClearTPSync=_clearTPSync
function _findStealTarget(pets)
	return _findTPSyncedPet(pets)
end
function _publishStealTarget(pet)
	if not pet then
		return
	end
	_G.ElysiumStealTargetUID=_petUid(pet)
	_G.ElysiumStealTarget=pet
end
MK_UPPER={
	B={
		{coord=Vector3.new(-487.921448,16.850713,-75.768013),facing="NORTH"},
		{coord=Vector3.new(-332.37973,16.850722,-75.7621),facing="NORTH"},
		{coord=Vector3.new(-487.134918,16.850713,-18.094154),facing="SOUTH"},
		{coord=Vector3.new(-316.300171,16.850713,-17.845898),facing="SOUTH"},
	},
	C={
		{coord=Vector3.new(-330.765381,16.850713,31.424425),facing="NORTH"},
		{coord=Vector3.new(-502.989349,16.850713,31.17243),facing="NORTH"},
		{coord=Vector3.new(-489.077087,16.850713,89.010147),facing="SOUTH"},
		{coord=Vector3.new(-330.908936,16.850713,88.930145),facing="SOUTH"},
	},
	D={
		{coord=Vector3.new(-331.264893,16.850713,138.209167),facing="NORTH"},
		{coord=Vector3.new(-487.935181,16.850713,138.026321),facing="NORTH"},
		{coord=Vector3.new(-487.774933,16.850713,195.882538),facing="SOUTH"},
		{coord=Vector3.new(-330.799133,16.850575,196.022354),facing="SOUTH"},
	},
}
MK_LOWER={
	B={
		{coord=Vector3.new(-335.725586,-3.048217,-74.984589),facing="NORTH"},
		{coord=Vector3.new(-503.214233,-3.048217,-75.043137),facing="NORTH"},
		{coord=Vector3.new(-483.619385,-3.71843,-18.844337),facing="SOUTH"},
		{coord=Vector3.new(-316.147095,-3.048218,-18.818844),facing="SOUTH"},
	},
	C={
		{coord=Vector3.new(-335.985413,-3.048218,32.051426),facing="NORTH"},
		{coord=Vector3.new(-503.277008,-3.048217,31.956175),facing="NORTH"},
		{coord=Vector3.new(-483.74939,-3.048218,88.147003),facing="SOUTH"},
		{coord=Vector3.new(-315.793823,-3.048217,88.163979),facing="SOUTH"},
	},
	D={
		{coord=Vector3.new(-335.476654,-3.048218,139.001083),facing="NORTH"},
		{coord=Vector3.new(-503.710083,-3.048218,138.989883),facing="NORTH"},
		{coord=Vector3.new(-315.654938,-3.048218,195.302444),facing="SOUTH"},
		{coord=Vector3.new(-483.859253,-3.048218,195.269043),facing="SOUTH"},
	},
}
UPPER_Y_THRESHOLD=7
TALL_PETS={["La Secret Combinasion"]=true,["La Jolly Grande"]=true}
TALL_OFFSET=3
BASES_LOW={
	[1]=Vector3.new(-476.52,-2,220.940902709961),
	[2]=Vector3.new(-476.52,-2,113.773155212402),
	[3]=Vector3.new(-476.52,-2,6.17848777770996),
	[4]=Vector3.new(-476.52,-2,-101.07275390625),
	[5]=Vector3.new(-342.66,-2,221.447372436523),
	[6]=Vector3.new(-342.66,-2,113.414093017578),
	[7]=Vector3.new(-342.66,-2,6.24946165084839),
	[8]=Vector3.new(-342.66,-2,-99.7345886230469),
}
BASES_HIGH={
	[1]=Vector3.new(-479.51,18,220.940902709961),
	[2]=Vector3.new(-479.51,18,113.773155212402),
	[3]=Vector3.new(-479.51,18,6.17848777770996),
	[4]=Vector3.new(-479.51,18,-101.07275390625),
	[5]=Vector3.new(-339.48,18,221.447372436523),
	[6]=Vector3.new(-339.48,18,113.414093017578),
	[7]=Vector3.new(-339.48,18,6.24946165084839),
	[8]=Vector3.new(-339.48,18,-99.7345886230469),
}
FRONT_Y_LOW=-3.048217
FRONT_Y_HIGH=16.850713
COLUMN_SPLIT_X=-410
FRONT_Z_CLAMP=18
SIDE_NEAR_Z=45
function getClosestBaseIdx(pos)
	local closest,dist=1,math.huge
	for i=1,8 do
		local b=BASES_LOW[i]
		local d=(pos.X-b.X)^2+(pos.Z-b.Z)^2
		if d<dist then
			dist=d
			closest=i
		end
	end
	return closest
end
function buildFrontCandidate(idx,isUpper,playerZ)
	local base=isUpper and BASES_HIGH[idx]or BASES_LOW[idx]
	local frontY=isUpper and FRONT_Y_HIGH or FRONT_Y_LOW
	local frontZ=math.clamp(playerZ-base.Z,-FRONT_Z_CLAMP,FRONT_Z_CLAMP)+base.Z
	local coord=Vector3.new(base.X,frontY,frontZ)
	local faceDir=(idx<=4)and Vector3.new(-1,0,0)or Vector3.new(1,0,0)
	return coord,faceDir
end
function plotSides(coordTable,idx)
	local base=BASES_LOW[idx]
	local isWest=idx<=4
	local out={}
	for _,coords in pairs(coordTable)do
		for _,data in ipairs(coords)do
			if((data.coord.X<COLUMN_SPLIT_X)==isWest)and math.abs(data.coord.Z-base.Z)<SIDE_NEAR_Z then
				out[#out+1]=data
			end
		end
	end
	return out
end
function _floor1LaserSolid(plotName)
	local solid=false
	pcall(function()
		local Plots=workspace:FindFirstChild("Plots")
		local plot=Plots and Plots:FindFirstChild(plotName)
		if not plot then
			return
		end
		for _,d in ipairs(plot:GetDescendants())do
			if
				d:IsA("BasePart")
				and(d.Name=="LaserHitbox"or d.Name=="Laser")
				and d.CanCollide
				and d.Position.Y<=9
			then
				solid=true
				break
			end
		end
	end)
	return solid
end
function isPlotUnlocked(plotName)
	local ok,res=pcall(function()
		local channel=getPlotChannel(plotName)
		if not channel then
			return false
		end
		if channelGet(channel,"BlockEndTimeFirstFloor")~=nil then
			return false
		end
		return not _floor1LaserSolid(plotName)
	end)
	return ok and(res==true)
end
function findClosest(petPos,coordTable)
	local best,bestKey,bestDist=nil,nil,math.huge
	for skyKey,coords in pairs(coordTable)do
		for _,data in ipairs(coords)do
			local c=data.coord
			local d=math.sqrt((petPos.X-c.X)^2+(petPos.Z-c.Z)^2)
			if d<bestDist then
				bestDist=d
				best=data
				bestKey=skyKey
			end
		end
	end
	return best,bestKey
end
do
	_vizParts={}
	_vizGen=0
	function _vizEnsure()
		if _vizFolder and _vizFolder.Parent then
			return
		end
		_vizFolder=Instance.new("Folder")
		_vizFolder.Name="ElysiumPathViz"
		_vizFolder.Parent=workspace
		_vizAnchor=Instance.new("Part")
		_vizAnchor.Name="Anchor"
		_vizAnchor.Anchored=true
		_vizAnchor.CanCollide=false
		_vizAnchor.CanQuery=false
		_vizAnchor.CanTouch=false
		_vizAnchor.Transparency=1
		_vizAnchor.Size=Vector3.one
		_vizAnchor.CFrame=CFrame.new()
		_vizAnchor.Parent=_vizFolder
	end
	clearViz=function()
		if _vizFolder then
			pcall(function()
				_vizFolder:Destroy()
			end)
		end
		_vizFolder,_vizAnchor=nil,nil
		table.clear(_vizParts)
	end
	local function _neon(cf,size,color,ball,transp)
		_vizEnsure()
		local p=Instance.new("Part")
		p.Anchored=true
		p.CanCollide=false
		p.CanQuery=false
		p.CanTouch=false
		p.CastShadow=false
		p.Material=Enum.Material.Neon
		p.Color=color
		p.Transparency=transp or 0
		if ball then
			p.Shape=Enum.PartType.Ball
		end
		p.Size=size
		p.CFrame=cf
		p.Parent=_vizFolder
	end
	function vizLine(a,b,color)
		local d=b-a
		if d.Magnitude<.05 then
			return
		end
		_neon(CFrame.lookAt((a+b)*.5,b),Vector3.new(.25,.25,d.Magnitude),color,false,0)
	end
	function vizDot(pos,color,sz)
		_neon(CFrame.new(pos),Vector3.new(sz,sz,sz),color,true,0)
	end
	vizPath=function(fromPos,waypoints)
		if _G.ElysiumShowPath~=true then
			return
		end
		if#waypoints==0 then
			return
		end
		local COL=Color3.fromRGB(153,153,153)
		local prev=fromPos
		for _,wp in ipairs(waypoints)do
			vizLine(prev,wp,COL)
			prev=wp
		end
		vizDot(waypoints[#waypoints],COL,1.6)
	end
end
function elysiumTargetDistanceSpeed(position,target,normalSpeed)
	if target and(target-position).Magnitude>=200 then
		return 200
	end
	return normalSpeed
end
function elysiumTPVelocity()
	return math.clamp(tonumber(_G.TPVelocity)or 200,50,750)
end
function elysiumTPProfileSpeed(value,fallback,minimum,maximum)
	local profile=math.clamp(tonumber(value)or fallback,minimum,maximum)
	return profile
end
function elysiumTPRouteSpeed(length,straight)
	local speed=elysiumTPVelocity()
	if straight and tonumber(_G.ElysiumStraightSpeed)then
		speed=elysiumTPProfileSpeed(_G.ElysiumStraightSpeed,400,100,500)
	end
	if length<100 then
		speed=elysiumTPProfileSpeed(_G.ElysiumCloseSpeed,80,20,400)
	end
	return speed
end
function _climbCap()
	local v=math.clamp(tonumber(_G.ElysiumClimb)or 200,100,250)
	return v
end
function vZero(hrp)
	if hrp then
		_vzL(hrp)
		_vzA(hrp)
	end
end
function _setFlightVel(hrp,vel)
	if hrp and hrp.Parent then
		hrp.AssemblyLinearVelocity=vel
	end
end
function elysiumStartHopThenFly(hrp,route,spd,allowJump,quickStart)
	velMoveThrough(hrp,route,math.max(tonumber(spd)or 400,120),allowJump,quickStart)
	return false
end
_G.ElysiumStartHopThenFly=elysiumStartHopThenFly
function elysiumEnsureArrive(hrp,dest,spd)
	if not(hrp and typeof(dest)=="Vector3")then
		return false
	end
	local flySpd=math.max(tonumber(spd)or 400,120)
	for _=1,2 do
		for _=1,3 do
			RunService.Heartbeat:Wait()
		end
		if not hrp.Parent or _G.ElysiumTPStop then
			return false
		end
		if(hrp.Position-dest).Magnitude<=(tonumber(_G.ElysiumArriveTolerance)or 6)then
			return true
		end
		local gap=(hrp.Position-dest).Magnitude
		local r={dest}
		if gap>25 then
			local ok,rr=pcall(computeRoute,hrp.Position,dest,nil)
			if ok and type(rr)=="table"and#rr>0 then
				r=rr
			end
		end
		velMoveThrough(hrp,r,flySpd,true,true)
	end
	return hrp.Parent~=nil and(hrp.Position-dest).Magnitude<=6
end
_G.ElysiumEnsureArrive=elysiumEnsureArrive
function velMoveThrough(hrp,waypoints,speedOverride,allowJump,quickStart,arrivalTolerance,targetPosition,motionOptions)
	local character=LP.Character
	local humanoid=character and character:FindFirstChildOfClass("Humanoid")
	if not hrp or not character or hrp.Parent~=character or not humanoid
		or type(waypoints)~="table"or#waypoints==0 then
		return false
	end
	local route={}
	for i,point in ipairs(waypoints)do
		if typeof(point)~="Vector3"or point.X~=point.X or point.Y~=point.Y
			or point.Z~=point.Z or point.Magnitude==math.huge then
			_G.ElysiumTPMovementStatus="invalid_route"
			return false
		end
		route[i]=point
	end
	if type(_G.ElysiumActiveMoveCancel)=="function"then
		_G.ElysiumActiveMoveCancel()
	end
	local cancelled=false
	local cancel
	cancel=function()
		cancelled=true
		if _G.ElysiumActiveMoveCancel==cancel and hrp.Parent then
			hrp.AssemblyLinearVelocity=Vector3.zero
			hrp.AssemblyAngularVelocity=Vector3.zero
		end
	end
	_G.ElysiumActiveMoveCancel=cancel
	local function number(value,fallback,low,high)
		value=tonumber(value)
		if not value or value~=value then value=fallback end
		return math.clamp(value,low,high)
	end
	local speed=number(type(motionOptions)=="table"and motionOptions.speed or _G.TPVelocity,200,50,750)
	local riseSpeed=number(type(motionOptions)=="table"and motionOptions.speed or _G.ElysiumClimb,160,1,250)
	local ignoreObstacles=type(motionOptions)=="table"and motionOptions.ignoreObstacles==true
	local quickArrive=type(motionOptions)=="table"and motionOptions.quickArrive==true
	local sideWallHandoff=type(motionOptions)=="table"and motionOptions.sideWallHandoff==true
	local diagonalRise=type(motionOptions)=="table"and motionOptions.diagonal==true
	local passThrough=_G.ElysiumPassThrough~=false
		and not(type(motionOptions)=="table"and motionOptions.passThrough==false)
	local clamp3D=_G.ElysiumClamp3D~=false
	local configuredSpeed=speed
	local lagCap=tonumber(_G.ElysiumSpeedLagbackCap)
	if lagCap and _G.ElysiumAdaptiveSpeed==true then
		if(os.clock()-(tonumber(_G.ElysiumSpeedLagbackAt)or 0))>180 then
			_G.ElysiumSpeedLagbackCap=nil
		elseif lagCap<speed then
			speed=math.max(50,lagCap)
			riseSpeed=math.min(riseSpeed,math.max(50,speed))
		end
	end
	local acceleration=math.max(speed,riseSpeed)/.3
	local tolerance=number(arrivalTolerance,1,.2,6)
	local pingOK,ping=pcall(function()return LP:GetNetworkPing()end)
	ping=number(pingOK and ping or nil,.1,0,1)
	local settleTime=math.clamp(2*ping+.15,.25,.8)
	if type(motionOptions)=="table"and tonumber(motionOptions.settleTime)then
		settleTime=math.clamp(tonumber(motionOptions.settleTime),.05,.8)
	end
	local faceAlong=type(motionOptions)=="table"and typeof(motionOptions.face)=="Vector3"
		and Vector3.new(motionOptions.face.X,0,motionOptions.face.Z)or nil
	if faceAlong and faceAlong.Magnitude<.01 then faceAlong=nil end
	if faceAlong then faceAlong=faceAlong.Unit end
	local faceRange=tonumber(_G.ElysiumTPFaceRange)or 30
	local faceLocked=false
	local started=os.clock()
	local length,previous=0,hrp.Position
	for _,point in ipairs(route)do
		length=length+(point-previous).Magnitude
		previous=point
	end
	local deadline=started+math.max(8,length/math.min(speed,riseSpeed)*3+#route+4)
	local diag={
		version=2,started=started,phase="route",corrections=0,
		requestedSpeed=speedOverride,speed=speed,events={},frames={},
		configuredSpeed=tonumber(_G.TPVelocity),riseSpeed=riseSpeed,
		acceleration=acceleration,ping=ping,
	}
	local function coordinates(value)
		return{x=value.X,y=value.Y,z=value.Z}
	end
	local function flightSnapshot()
		local state={
			movementLease=_G.ElysiumMovementLeaseActive==true,
			invisPaused=_G.ElysiumExtrasFlashPaused==true,
			preparing=_carpetEngaging==true,
			engage=tostring(_G.TPEngage or""),
		}
		for _,name in ipairs(CARPET_NAMES or{})do
			local tool=character:FindFirstChild(name)
			if tool and tool:IsA("Tool")then
				state.tool,state.enabled=name,tool.Enabled
				break
			end
		end
		local power=hrp.FindFirstChild and hrp:FindFirstChild("FlightPower")
		state.flightPower=power and power.ClassName or nil
		state.humanoidState=humanoid.GetState and tostring(humanoid:GetState())or nil
		local physical=_G.ElysiumGetInvisRealRoot and _G.ElysiumGetInvisRealRoot()
		state.separatePhysicalRoot=physical~=nil and physical~=hrp
		return state
	end
	diag.initialFlight=flightSnapshot()
	local function saveTrace(status)
		if type(writefile)~="function"then return end
		local ok,err=pcall(function()
			local events={}
			for i,event in ipairs(diag.events)do
				events[i]={status=event.status,at=event.at,
					position=event.position and coordinates(event.position)or nil}
			end
			local payload={
				schema=1,status=status,elapsed=os.clock()-started,
				configuredSpeed=diag.configuredSpeed,requestedSpeed=diag.requestedSpeed,
				currentSpeed=diag.speed,riseSpeed=diag.riseSpeed,
				acceleration=diag.acceleration,ping=diag.ping,
				corrections=diag.corrections,error=diag.error,
				carpetStowedAt=diag.carpetStowedAt,
				passThrough=passThrough,clamp3D=clamp3D,routePoints=#route,
				routeInfo=tostring(_G.ElysiumTPLiftInfo),profileFail=_G.ElysiumTPProfileFail,
				steer=diag.steer,snapReplans=diag.snapReplans,snapReplanInfo=diag.snapReplanInfo,
				events=events,frames=diag.frames,
				initialFlight=diag.initialFlight,latestFlight=flightSnapshot(),
			}
			local file=status=="arrived"and"Elysium-motion-last-run.json"
				or"Elysium-motion-last-issue.json"
			local encoded=ElysiumService("HttpService"):JSONEncode(payload)
			writefile(file,encoded)
			if status=="resync_observed_position"or status=="repeated_position_correction"then
				writefile("Elysium-motion-last-correction.json",encoded)
			end
			diag.traceFile=file
		end)
		if not ok then diag.traceError=tostring(err)end
	end
	_G.ElysiumTPMotionDiag=diag
	local function report(status)
		diag.status,diag.at=status,os.clock()
		if#diag.events==24 then table.remove(diag.events,1)end
		diag.events[#diag.events+1]={status=status,at=diag.at-started,
			position=hrp.Parent and hrp.Position or nil}
		if _G.ElysiumActiveMoveCancel==cancel then
			_G.ElysiumTPMovementStatus=status
		end
	end
	local routeTool
	local function valid()
		if cancelled or _G.ElysiumActiveMoveCancel~=cancel then return"cancelled"end
		if _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then return"stopped"end
		if LP.Character~=character or hrp.Parent~=character
			or character:FindFirstChild("HumanoidRootPart")~=hrp then return"root_changed"end
		if humanoid.Health<=0 then return"character_dead"end
		if routeTool and routeTool.Parent~=character then return"flight_gear_unequipped"end
		if hrp.Anchored then return"root_anchored"end
		if LP:GetAttribute("Stealing")==true then return"pickup_started"end
		if(tonumber(LP:GetAttribute("RagdollEndTime"))or 0)>workspace:GetServerTimeNow()then
			return"ragdolled"
		end
		local physical=_G.ElysiumGetInvisRealRoot and _G.ElysiumGetInvisRealRoot()
		if physical and physical~=hrp then return"physical_root_conflict"end
	end
	local cast=RaycastParams.new()
	cast.FilterType=Enum.RaycastFilterType.Exclude
	cast.FilterDescendantsInstances={character}
	cast.RespectCanCollide=true
	cast.IgnoreWater=true
	cast.CollisionGroup=hrp.CollisionGroup
	local avoidEnabled=not ignoreObstacles and _G.ElysiumSmartAvoid~=false
		and not(type(motionOptions)=="table"and motionOptions.avoid==false)
	local avoidSide,avoidUntil,avoidLastAt=0,0,0
	local bodyTop,bodyBottom=2.4,-(humanoid.HipHeight+hrp.Size.Y*.5)
	pcall(function()
		local top,bottom
		for _,part in ipairs(character:GetChildren())do
			if part:IsA("BasePart")then
				local cf,size=part.CFrame,part.Size
				local half=(math.abs(cf.RightVector.Y)*size.X+math.abs(cf.UpVector.Y)*size.Y
					+math.abs(cf.LookVector.Y)*size.Z)*.5
				local y=cf.Position.Y-hrp.Position.Y
				top=math.max(top or-math.huge,y+half)
				bottom=math.min(bottom or math.huge,y-half)
			end
		end
		if top and top>.5 and top<8 then bodyTop=top end
		if bottom and bottom<-.5 and bottom>-8 then bodyBottom=bottom end
	end)
	local avoidTop,avoidBottom=bodyTop-.2,bodyBottom+.9
	local avoidSize=Vector3.new(2.6,math.max(1,avoidTop-avoidBottom),2.6)
	local avoidLift=(avoidTop+avoidBottom)*.5
	local function lookCast(direction,distance)
		return workspace:Blockcast(CFrame.new(hrp.Position+Vector3.new(0,avoidLift,0)),
			avoidSize,direction*distance,cast)
	end
	local function rotateFlat(flatDir,degrees,y)
		local r=math.rad(degrees)
		local c,s=math.cos(r),math.sin(r)
		local d=Vector3.new(flatDir.X*c-flatDir.Z*s,y,flatDir.X*s+flatDir.Z*c)
		return d.Magnitude>.001 and d.Unit or flatDir
	end
	local laserGuardOn=_G.ElysiumLaserGuard~=false
	local laserList,laserListAt,laserWaitFrom={},-math.huge,nil
	local function isLaserPart(inst)
		if typeof(inst)~="Instance"then return false end
		local n,p=inst.Name,inst.Parent
		return n=="LaserHitbox"or n=="Laser"
			or(p~=nil and(p.Name=="LaserHitbox"or p.Name=="Laser"))
	end
	local function plotOfPart(part)
		local x=part
		for _=1,10 do
			local p=x and x.Parent
			if not p then return nil end
			if p.Name=="Plots"then return x end
			x=p
		end
		return nil
	end
	local function refreshLaserList(now)
		if now-laserListAt<.25 then return end
		laserListAt=now
		table.clear(laserList)
		local plots=workspace:FindFirstChild("Plots")
		if not plots then return end
		local here=hrp.Position
		for _,plot in ipairs(plots:GetChildren())do
			local folder=plot:FindFirstChild("LaserHitbox")
			if folder then
				for _,part in ipairs(folder:GetChildren())do
					if part:IsA("BasePart")and part.CanCollide
						and(part.Position-here).Magnitude<160+part.Size.Magnitude*.5 then
						laserList[#laserList+1]=part
					end
				end
			end
		end
	end
	local function segmentHitsBox(a,b,part,pad)
		local cf=part.CFrame
		local la,lb=cf:PointToObjectSpace(a),cf:PointToObjectSpace(b)
		local d=lb-la
		local half=part.Size*.5+Vector3.new(pad,pad,pad)
		local enter,leave=0,1
		for _,axis in ipairs({"X","Y","Z"})do
			local o,v,h=la[axis],d[axis],half[axis]
			if math.abs(v)<1e-6 then
				if o<-h or o>h then return false end
			else
				local t1,t2=(-h-o)/v,(h-o)/v
				if t1>t2 then t1,t2=t2,t1 end
				if t1>enter then enter=t1 end
				if t2<leave then leave=t2 end
				if enter>leave then return false end
			end
		end
		return true
	end
	local function laserAhead(position,command,toWaypoint,now)
		if not laserGuardOn or command.Magnitude<.5 then return nil end
		refreshLaserList(now)
		if#laserList==0 then return nil end
		local look=math.min(toWaypoint.Magnitude+1,math.max(4,command.Magnitude*.25))
		local tip=position+command.Unit*look
		local pad=tonumber(_G.ElysiumLaserPad)or 2
		local goal=position+toWaypoint
		for _,part in ipairs(laserList)do
			if part.Parent and part.CanCollide and segmentHitsBox(position,tip,part,pad)
				and segmentHitsBox(position,goal,part,.5)then
				if segmentHitsBox(position,position,part,pad)then
					local s=part.Size
					local axis=(s.X<=s.Y and s.X<=s.Z)and"X"or(s.Y<=s.Z and"Y"or"Z")
					local lp=part.CFrame:PointToObjectSpace(position)
					local lv=part.CFrame:VectorToObjectSpace(command)
					if lp[axis]*lv[axis]<0 then return part end
				else
					return part
				end
			end
		end
		return nil
	end
	local function laserUntilFor(part)
		local env=type(getgenv)=="function"and getgenv()or _G
		local map=env.ElysiumLaserUntil or _G.ElysiumLaserUntil
		local plot=plotOfPart(part)
		local t=type(map)=="table"and plot and tonumber(map[plot.Name])or nil
		return t,plot
	end
	local lastSteerDir,lastSteerAt=nil,-math.huge
	local function steer(desired,toWaypoint,now)
		local magnitude=desired.Magnitude
		local waypointDistance=toWaypoint.Magnitude
		if not avoidEnabled or magnitude<1 or waypointDistance<1.5 then return desired end
		local dir=desired/magnitude
		local look=math.min(math.clamp(magnitude*(tonumber(_G.ElysiumSteerLook)or .3),5,30),waypointDistance)
		local hit=lookCast(dir,look)
		if not hit or hit.Distance>=waypointDistance-.5 then
			if now>avoidUntil then avoidSide=0 end
			return desired
		end
		diag.obstacle=tostring(hit.Instance)
		if laserGuardOn and isLaserPart(hit.Instance)and hit.Instance:IsA("BasePart")
			and segmentHitsBox(hrp.Position,hrp.Position+toWaypoint,hit.Instance,.5)then
			diag.laserSeen=hit.Instance:GetFullName()
			return desired
		end
		local goal=toWaypoint.Unit
		local flatDir=Vector3.new(dir.X,0,dir.Z)
		local candidates={}
		local normal=hit.Normal
		local climbMax=riseSpeed
		local function capClimb(v)
			if climbMax>0 and v.Y>climbMax then v=v*(climbMax/v.Y)end
			return v
		end
		if normal.Y>=(tonumber(_G.ElysiumSteerFloorNormal)or .5)and _G.ElysiumSteerFloorFollow~=false then
			local along=dir-normal*dir:Dot(normal)
			if along.Magnitude>.05 then
				local out=(along.Unit+Vector3.new(0,.08,0)).Unit
				if not lookCast(out,math.min(look,hit.Distance+2))then
					lastSteerDir,lastSteerAt=out,now
					diag.steer={kind="floor",at=now-started}
					return capClimb(out*magnitude)
				end
			end
		end
		local slide=dir-normal*dir:Dot(normal)
		if slide.Magnitude>.3 then
			candidates[#candidates+1]={dir=slide.Unit,side=0}
		end
		if flatDir.Magnitude>.1 then
			flatDir=flatDir.Unit
			local sides=(avoidSide==1 or avoidSide==-1)and{avoidSide,-avoidSide}or{1,-1}
			for _,angle in ipairs({30,55,80,110})do
				for _,side in ipairs(sides)do
					candidates[#candidates+1]={dir=rotateFlat(flatDir,angle*side,dir.Y),side=side}
				end
			end
			if _G.ElysiumSteerOver~=false then
				local overMax=tonumber(_G.ElysiumSteerOverMax)or 16
				local at=hit.Position+flatDir*1.2
				local fromY=hrp.Position.Y+overMax+avoidTop+1
				local down=workspace:Raycast(Vector3.new(at.X,fromY,at.Z),
					Vector3.new(0,-(overMax+avoidTop+1-avoidBottom+4),0),cast)
				if down and down.Position.Y<fromY-.2 then
					local rise=down.Position.Y+(tonumber(_G.ElysiumSteerOverClear)or 1.5)-(hrp.Position.Y+avoidBottom)
					if rise>.2 and rise<=overMax then
						local ahead=math.max(hit.Distance,2)
						candidates[#candidates+1]={dir=(flatDir*ahead+Vector3.new(0,rise,0)).Unit,
							side=0,over=true,rise=rise}
					end
				end
			end
			candidates[#candidates+1]={dir=(flatDir+Vector3.new(0,1.2,0)).Unit,side=0,up=true}
		end
		candidates[#candidates+1]={dir=Vector3.new(0,1,0),side=0,up=true}
		local best,bestScore,freest,freestDistance=nil,-math.huge,nil,hit.Distance+1
		for _,candidate in ipairs(candidates)do
			local probe=lookCast(candidate.dir,look)
			local k=1
			if candidate.dir.Y>0 and climbMax>0 then
				k=math.min(1,climbMax/math.max(.001,magnitude*candidate.dir.Y))
			end
			local score=candidate.dir:Dot(goal)*k
			if candidate.side~=0 and candidate.side==avoidSide then score=score+.2 end
			if candidate.over and avoidSide==2 then score=score+.2 end
			if not probe then
				if score>bestScore then best,bestScore=candidate,score end
			elseif probe.Distance>freestDistance then
				freest,freestDistance=candidate,probe.Distance
			end
		end
		local chosen=best or freest
		if not chosen then return desired end
		diag.steer={kind=chosen.over and"over"or(chosen.up and"up"or(chosen.side~=0 and"side"or"slide")),
			rise=chosen.rise,at=now-started,obstacle=tostring(hit.Instance)}
		if chosen.over then avoidSide=2 elseif chosen.side~=0 then avoidSide=chosen.side end
		avoidUntil,avoidLastAt=now+.6,now
		local out=chosen.dir
		local smooth=math.clamp(tonumber(_G.ElysiumSteerSmooth)or .5,0,.9)
		if smooth>0 and lastSteerDir and now-lastSteerAt<.2 and lastSteerDir:Dot(out)>.2 then
			local blend=out*(1-smooth)+lastSteerDir*smooth
			if blend.Magnitude>.05 and not lookCast(blend.Unit,look)then out=blend.Unit end
		end
		lastSteerDir,lastSteerAt=out,now
		local factor=out:Dot(goal)<.3 and .75 or 1
		return capClimb(out*magnitude*factor)
	end
	local replans=0
	local maxReplans=math.clamp(tonumber(_G.ElysiumRouteReplans)or 2,0,5)
	if type(motionOptions)=="table"and motionOptions.replan==false then maxReplans=0 end
	local function run()
		if hrp.Anchored then
			report("waiting_unanchor")
			local began=os.clock()
			while hrp.Anchored and os.clock()-began<2 do
				if cancelled or _G.ElysiumActiveMoveCancel~=cancel then return false,"cancelled"end
				if _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then return false,"stopped"end
				if LP.Character~=character or hrp.Parent~=character then return false,"root_changed"end
				if humanoid.Health<=0 then return false,"character_dead"end
				RunService.Heartbeat:Wait()
			end
			deadline=deadline+os.clock()-began
		end
		local initialReason=valid()
		if initialReason then return false,initialReason end
		if type(motionOptions)=="table"and motionOptions.noCarpet==true then
			routeTool=nil
			diag.noCarpet=true
		else
			routeTool=ElysiumPrepareCarpetRoute(nil,true)
			if not routeTool then return false,_G.ElysiumTPMovementStatus or"carpet_unavailable"end
		end
		_G.ElysiumCarpetRouteRunning=true
		local index,bestDistance,progressAt=1,math.huge,os.clock()
		local command,observed=Vector3.zero,hrp.Position
		local pauseUntil,stableAt,stablePosition=0,nil,nil
		local settling=false
		local lastAt=os.clock()
		local movingSince=os.clock()
		local rampFloor=tonumber(_G.ElysiumRampStartSpeed)or 24
		local stowEarly=type(motionOptions)=="table"and motionOptions.stowCarpet==true
			and _G.ElysiumTPStowCarpetEarly~=false
		local mountSeen=false
		report("moving")
		local function waitForUnanchor()
			if not hrp.Anchored then return nil end
			local began=os.clock()
			report("waiting_unanchor")
			while hrp.Anchored do
				if cancelled or _G.ElysiumActiveMoveCancel~=cancel then return"cancelled"end
				if _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then return"stopped"end
				if LP.Character~=character or hrp.Parent~=character then return"root_changed"end
				if humanoid.Health<=0 then return"character_dead"end
				if os.clock()-began>=2 then return"root_anchored"end
				RunService.Heartbeat:Wait()
			end
			local now=os.clock()
			deadline=deadline+now-began
			command,observed=Vector3.zero,hrp.Position
			lastAt,progressAt,bestDistance=now,now,math.huge
			stableAt,stablePosition,settling=nil,nil,false
			movingSince=now
			report("moving")
		end
		while os.clock()<deadline do
			local anchorReason=waitForUnanchor()
			if anchorReason then return false,anchorReason end
			local reason=valid()
			if reason then return false,reason end
			local dt=RunService.Heartbeat:Wait()
			anchorReason=waitForUnanchor()
			if anchorReason then return false,anchorReason end
			reason=valid()
			if reason then return false,reason end
			if routeTool and routeTool.Parent~=character then return false,"flight_gear_unequipped"end
			ElysiumCarpetRouteSweep(hrp,humanoid)
			if routeTool then
				local nowStow=os.clock()
				if not routeTool.Enabled or humanoid.PlatformStand then
					mountSeen=true
				elseif stowEarly and(mountSeen or(tonumber(_G.ElysiumCarpetMountEndedAt)or 0)>=started-1)
					and nowStow-started>(tonumber(_G.ElysiumTPStowAfter)or 1)
					and nowStow-(diag.lastCorrectionAt or-math.huge)>1.5
					and not hrp.Anchored
					and(route[#route]-hrp.Position).Magnitude>math.max(speed,1)*1.2 then
					local bp=LP:FindFirstChild("Backpack")
					if bp then pcall(function()routeTool.Parent=bp end)end
					if routeTool.Parent~=character then
						diag.carpetStowedAt=nowStow-started
						_G.ElysiumCarpetStowedAt=nowStow
						routeTool=nil
						_G.TPEngage="stowed"
					end
				end
			end
			local now=os.clock()
			dt=number(dt,math.max(now-lastAt,1/240),1/240,1)
			lastAt=now
			local position=hrp.Position
			local displacement=position-observed
			local expected=command*dt
			local residual=(displacement-expected).Magnitude
			diag.residual,diag.position,diag.waypoint=residual,position,index
			if#diag.frames>=180 then table.remove(diag.frames,1)end
			diag.frames[#diag.frames+1]={
				at=now-started,dt=dt,waypoint=index,
				position=coordinates(position),command=coordinates(command),
				target=coordinates(route[index]),flight=flightSnapshot(),
				measuredVelocity=coordinates(hrp.AssemblyLinearVelocity),
				residual=residual,phase=diag.phase,
				platformStand=humanoid.PlatformStand,anchored=hrp.Anchored,
			}
			local backwards=command.Magnitude>1
				and displacement:Dot(command.Unit)<-math.max(2,expected.Magnitude*.5)
			local discontinuity=dt<=.2 and now>=pauseUntil
				and(backwards or residual>math.max(6,expected.Magnitude+3))
			observed=position
			if discontinuity then
				diag.corrections=diag.corrections+1
				diag.lastCorrectionAt=now
				command=Vector3.zero
				hrp.AssemblyLinearVelocity=command
				hrp.AssemblyAngularVelocity=Vector3.zero
				stableAt,stablePosition=nil,nil
				settling=false
				if diag.corrections>(tonumber(_G.ElysiumMaxCorrections)or 4)then
					return false,"repeated_position_correction"
				end
				local stepDown=diag.corrections==1 and(tonumber(_G.ElysiumSnapSlowFirst)or .8)
					or(tonumber(_G.ElysiumSnapSlow)or .7)
				local floorSpeed=math.max(50,configuredSpeed*(tonumber(_G.ElysiumSnapFloor)or .5))
				speed=math.max(math.min(speed,floorSpeed),speed*stepDown)
				riseSpeed=math.min(riseSpeed,speed)
				acceleration=math.max(speed,riseSpeed)/.3
				diag.speed=speed
				if _G.ElysiumAdaptiveSpeed==true then
					local current=tonumber(_G.ElysiumSpeedLagbackCap)or math.huge
					_G.ElysiumSpeedLagbackCap=math.max(50,math.min(current,speed))
					_G.ElysiumSpeedLagbackAt=now
				end
				pauseUntil=now+math.max(settleTime,math.min(.5,2*ping+.12))
				movingSince=pauseUntil
				bestDistance,progressAt=math.huge,pauseUntil
				local replanRoute=type(motionOptions)=="table"and motionOptions.replanRoute
				if type(replanRoute)=="function"and _G.ElysiumSnapReplan~=false
					and displacement.Magnitude>=(tonumber(_G.ElysiumSnapReplanDist)or 12)
					and(diag.snapReplans or 0)<2 then
					local okFresh,fresh=pcall(replanRoute,position)
					local clean={}
					if okFresh and type(fresh)=="table"then
						for _,p in ipairs(fresh)do
							if typeof(p)=="Vector3"and p.X==p.X and p.Y==p.Y and p.Z==p.Z then
								clean[#clean+1]=p
							end
						end
					end
					diag.snapReplans=(diag.snapReplans or 0)+1
					if#clean>0 then
						route,index=clean,1
						avoidSide,lastSteerDir=0,nil
						diag.snapReplanInfo=tostring(_G.ElysiumTPLiftInfo)
					else
						diag.snapReplanInfo="failed: "..tostring(not okFresh and fresh or _G.ElysiumTPProfileFail)
					end
				end
				report("resync_observed_position")
				saveTrace("resync_observed_position")
			end
			if now<pauseUntil then
				command=Vector3.zero
				hrp.AssemblyLinearVelocity=command
			else
				local target=route[index]
				local delta=target-position
				local distance=delta.Magnitude
				local passRadius=passThrough and math.max(1,math.min(6,command.Magnitude*dt*1.25))or 1
				while index<#route and distance<=passRadius do
					index=index+1
					target=route[index]
					delta,distance=target-position,(target-position).Magnitude
					bestDistance,progressAt=math.huge,now
				end
				if faceAlong and(route[#route]-position).Magnitude<=faceRange then
					if not faceLocked then
						faceLocked=true
						pcall(function()humanoid.AutoRotate=false end)
					end
					hrp.CFrame=CFrame.lookAlong(position,faceAlong)
				end
				if sideWallHandoff and index==#route and distance<=9 and math.abs(delta.Y)<=3.5 then
					local flatGoal=Vector3.new(delta.X,0,delta.Z)
					if flatGoal.Magnitude>.25 then
						local direction=flatGoal.Unit
						local result=workspace:Raycast(position,direction*math.min(4,flatGoal.Magnitude),cast)
						if result and result.Instance and result.Instance.CanCollide
							and result.Distance<=3.4 and result.Normal:Dot(direction)<-.65 then
							command=Vector3.zero
							hrp.AssemblyLinearVelocity=Vector3.zero
							hrp.AssemblyAngularVelocity=Vector3.zero
							_G.ElysiumSideWallReachedAt=os.clock()
							diag.sideWallHit=tostring(result.Instance)
							diag.phase="side_wall_arrived"
							return true,"arrived_wall"
						end
					end
				end
				if quickArrive and index==#route and distance<=tolerance then
					command=Vector3.zero
					hrp.AssemblyLinearVelocity=command
					hrp.AssemblyAngularVelocity=Vector3.zero
					_G.ElysiumTPProgressAt=now
					diag.phase="arrived"
					return true,"arrived"
				end
				if index==#route and distance<=(settling and tolerance+.35 or tolerance)then
					settling=true
					local hold=delta*math.min(8,.5/dt)
					local flatHold=Vector3.new(hold.X,0,hold.Z)
					if flatHold.Magnitude>speed then flatHold=flatHold.Unit*speed end
					local gravity=number(workspace.Gravity,196.2,0,1000)
					command=flatHold+Vector3.new(0,
						math.clamp(hold.Y+gravity*dt*.5,-riseSpeed,riseSpeed),0)
					local travel=command*dt
					if travel.Magnitude>.001 and not ignoreObstacles then
						local hit=workspace:Blockcast(hrp.CFrame,hrp.Size*.8,travel,cast)
						if hit then
							command=travel.Unit*math.max(0,hit.Distance-.2)/dt
							diag.obstacle=tostring(hit.Instance)
						end
					end
					hrp.AssemblyLinearVelocity=command
					hrp.AssemblyAngularVelocity=Vector3.zero
					bestDistance,progressAt=distance,now
					_G.ElysiumTPProgressAt=now
					if distance>tolerance then
						stableAt,stablePosition=nil,nil
					elseif not stableAt or(position-stablePosition).Magnitude>tolerance*.5 then
						stableAt,stablePosition=now,position
					end
					diag.phase="settling"
					if stableAt and now-stableAt>=settleTime then return true,"arrived"end
				else
					settling=false
					stableAt,stablePosition=nil,nil
					diag.phase="route"
					if distance<bestDistance-.15 then
						bestDistance,progressAt=distance,now
						_G.ElysiumTPProgressAt=now
					elseif now-progressAt>math.max(now-avoidLastAt<.8 and 3 or 1.5,4*ping+.5)then
						local replanned=false
						if replans<maxReplans and type(computeRoute)=="function"then
							replans=replans+1
							command=Vector3.zero
							hrp.AssemblyLinearVelocity=command
							local okRoute,fresh=pcall(computeRoute,position,target,nil)
							local merged={}
							if okRoute and type(fresh)=="table"then
								for _,p in ipairs(fresh)do
									if typeof(p)=="Vector3"and p.X==p.X and p.Y==p.Y and p.Z==p.Z then
										merged[#merged+1]=p
									end
								end
							end
							if#merged>0 and hrp.Parent==character then
								for i=index+1,#route do merged[#merged+1]=route[i]end
								route,index=merged,1
								local resumedAt=os.clock()
								bestDistance,progressAt=math.huge,resumedAt
								observed,lastAt=hrp.Position,resumedAt
								movingSince=resumedAt
								deadline=math.max(deadline,resumedAt+6)
								avoidSide=(avoidSide==1 or avoidSide==-1)and-avoidSide or 0
								lastSteerDir=nil
								report("replanned")
								replanned=true
							end
						end
						if not replanned then return false,"route_stalled"end
					end
					local flat=Vector3.new(delta.X,0,delta.Z)
					local flatDistance=flat.Magnitude
					local flatVelocity=ElysiumCarpetRouteHorizontal(delta,speed,dt)
					if _G.ElysiumUnseatedCap==true and not humanoid.PlatformStand
						and(routeTool==nil or routeTool.Enabled)then
						local unseatedCap=math.max(16,tonumber(_G.ElysiumUnseatedSpeed)or 85)
						if flatVelocity.Magnitude>unseatedCap then
							flatVelocity=flatVelocity.Unit*unseatedCap
							if not diag.unseatedAt then diag.unseatedAt=now-started end
						end
					end
					local rampCap=math.min(speed,rampFloor+acceleration*math.max(0,now-movingSince))
					if flatVelocity.Magnitude>rampCap then
						flatVelocity=flatVelocity.Unit*rampCap
					end
					local nextLeg=passThrough and index<#route and(route[index+1]-target)or nil
					if nextLeg and nextLeg.Magnitude>.05 and distance>.05 then
						local dir=delta/distance
						local v=dir*speed
						local flatPart=Vector3.new(v.X,0,v.Z).Magnitude
						if flatPart>rampCap then v=v*(rampCap/flatPart)end
						if math.abs(v.Y)>riseSpeed then
							v=v*(riseSpeed/math.abs(v.Y))
						end
						local turn=dir:Dot(nextLeg.Unit)
						local corner=speed*math.clamp((turn-.3)/.65,.2,1)
						local allowed=math.sqrt(corner*corner+2*acceleration*distance)
						if v.Magnitude>allowed then v=v.Unit*allowed end
						local change=v-command
						local maxStep=acceleration*1.5*math.min(dt,.1)
						if change.Magnitude>maxStep then v=command+change.Unit*maxStep end
						command=v
					else
					local ySpeed=math.min(riseSpeed,math.sqrt(2*acceleration*math.abs(delta.Y)),math.abs(delta.Y)*.65/dt)
					if diagonalRise and flatDistance>.5 and math.abs(delta.Y)>.5 then
						local flatSpeed=flatVelocity.Magnitude
						local wantY=math.abs(delta.Y)*flatSpeed/flatDistance
						if wantY>ySpeed and ySpeed>0 and flatSpeed>0 then
							flatVelocity=flatVelocity*(ySpeed/wantY)
						else
							ySpeed=wantY
						end
					end
					local desired=flatVelocity+Vector3.new(0,delta.Y>=0 and ySpeed or-ySpeed,0)
					local difference=desired-command
					local maxChange=acceleration*math.min(dt,.1)
					if difference.Magnitude>maxChange then difference=difference.Unit*maxChange end
					command=command+difference
					command=Vector3.new(flatVelocity.X,command.Y,flatVelocity.Z)
					local horizontal=Vector3.new(command.X,0,command.Z)
					local maxFlat=flatDistance*.65/dt
					if horizontal.Magnitude>maxFlat then horizontal=horizontal.Unit*maxFlat end
					local maxY=math.abs(delta.Y)*.65/dt
					command=horizontal+Vector3.new(0,math.clamp(command.Y,-maxY,maxY),0)
					end
					command=steer(command,delta,now)
					if clamp3D and command.Magnitude>speed then
						command=command.Unit*speed
					end
					local laser=laserAhead(position,command,delta,now)
					if laser then
						local untilT,laserPlot=laserUntilFor(laser)
						local left=untilT and(untilT-workspace:GetServerTimeNow())or nil
						local waitMax=math.max(0,tonumber(_G.ElysiumLaserWaitMax)or 2.5)
						local firstWait=laserWaitFrom==nil
						laserWaitFrom=laserWaitFrom or now
						diag.laserWait={at=now-started,part=laser:GetFullName(),
							plot=laserPlot and laserPlot.Name or nil,left=left,
							waited=now-laserWaitFrom}
						if firstWait then report("laser_wait")end
						if(left and left>waitMax-(now-laserWaitFrom))
							or now-laserWaitFrom>(left and waitMax or math.min(waitMax,1.2))then
							command=Vector3.zero
							hrp.AssemblyLinearVelocity=command
							return false,"laser_blocked"
						end
						local gravity=number(workspace.Gravity,196.2,0,1000)
						command=Vector3.new(0,gravity*dt*.5,0)
						progressAt,bestDistance=now,math.huge
						deadline=math.max(deadline,now+2)
					elseif laserWaitFrom then
						laserWaitFrom=nil
						movingSince=now
						report("moving")
					end
					local travel=command*dt
					if travel.Magnitude>.001 and not ignoreObstacles then
						local hit=workspace:Blockcast(hrp.CFrame,hrp.Size*.8,travel,cast)
						if hit then
							command=travel.Unit*math.max(0,hit.Distance-.2)/dt
							diag.obstacle=tostring(hit.Instance)
						end
					end
					hrp.AssemblyLinearVelocity=command
					hrp.AssemblyAngularVelocity=Vector3.zero
				end
			end
		end
		return false,"route_timeout"
	end
	local ok,arrived,reason=pcall(run)
	if not ok then diag.error=tostring(arrived);arrived,reason=false,"movement_error"end
	report(reason or"interrupted")
	local forcedAt=tonumber(_G.ElysiumCarpetForcedAt)
	if forcedAt and forcedAt>=started-3 and(diag.corrections or 0)>0 then
		_G.ElysiumCarpetForceEnableBad=true
		diag.forcedCarpetRejected=true
	end
	if forcedAt and forcedAt>=started-3 then diag.forcedCarpet=true end
	if ok and arrived==true and diag.corrections==0 and tonumber(_G.ElysiumSpeedLagbackCap)then
		local cap=tonumber(_G.ElysiumSpeedLagbackCap)*1.15
		if cap>=configuredSpeed then _G.ElysiumSpeedLagbackCap=nil
		else _G.ElysiumSpeedLagbackCap=cap end
	end
	if _G.ElysiumActiveMoveCancel==cancel then
		if hrp.Parent then
			hrp.AssemblyLinearVelocity=Vector3.zero
			hrp.AssemblyAngularVelocity=Vector3.zero
		end
		_G.ElysiumActiveMoveCancel=nil
		_G.ElysiumCarpetRouteRunning=false
		if not arrived then _G.ElysiumTPRetryAfter=os.clock()+1.5 end
	end
	diag.finished=os.clock()
	saveTrace(reason or"interrupted")
	return ok and arrived==true
end
_OTHER_CLONES={}
do
	local _MY_CLONE=tostring(LP.UserId).."_Clone"
	local _seen={}
	local function _isOtherClone(inst)
		if not inst then
			return false
		end
		local n=inst.Name
		if n==_MY_CLONE then
			return false
		end
		if n:match("^%d+_Clone$")then
			return true
		end
		if not n:find("lone",1,true)then
			return false
		end
		if not inst:IsA("Model")then
			return false
		end
		if inst==LP.Character then
			return false
		end
		if not inst:FindFirstChild("HumanoidRootPart")then
			return false
		end
		if not inst:FindFirstChildOfClass("Humanoid")then
			return false
		end
		for _,pl in ipairs(Players:GetPlayers())do
			if pl.Character==inst then
				return false
			end
		end
		return true
	end
	local function _neutralize(inst)
		if not inst or _seen[inst]then
			return
		end
		_seen[inst]=true
		_OTHER_CLONES[#_OTHER_CLONES+1]=inst
		local function declaw(d)
			if d:IsA("BasePart")and d.CanCollide then
				pcall(function()
					d.CanCollide=false
				end)
			end
		end
		for _,d in ipairs(inst:GetDescendants())do
			declaw(d)
		end
		inst.DescendantAdded:Connect(declaw)
		inst.Destroying:Connect(function()
			_seen[inst]=nil
			for i=#_OTHER_CLONES,1,-1 do
				if _OTHER_CLONES[i]==inst then
					table.remove(_OTHER_CLONES,i)
					break
				end
			end
		end)
	end
	local function _scan(inst)
		if _isOtherClone(inst)then
			_neutralize(inst)
		end
	end
	for _,c in ipairs(workspace:GetChildren())do
		_scan(c)
	end
	workspace.ChildAdded:Connect(function(c)
		_scan(c)
		task.defer(function()
			if c and c.Parent==workspace then
				_scan(c)
			end
		end)
	end)
end
do
	local _pSeen=setmetatable({},{__mode="k"})
	local _ncBag=setmetatable({},{__mode="k"})
	local function _declaw(d)
		if d:IsA("BasePart")and d.CanCollide then
			pcall(function()
				d.CanCollide=false
			end)
		end
	end
	local function _declawChar(char)
		if not char then
			return
		end
		for _,d in ipairs(char:GetDescendants())do
			_declaw(d)
		end
		if not _pSeen[char]then
			_pSeen[char]=true
			char.DescendantAdded:Connect(_declaw)
		end
	end
	local _THEIRS={"HumanoidRootPart","UpperTorso","LowerTorso","Torso","Head"}
	local function _noCollide(char)
		if _G.ElysiumNoCollideConstraints==false or not char then
			return
		end
		local c=LP.Character
		local mine=c and c:FindFirstChild("HumanoidRootPart")
		if not mine then
			return
		end
		local bag=_ncBag[char]
		if not bag or bag.root~=mine then
			bag={root=mine}
			_ncBag[char]=bag
		end
		for _,n in ipairs(_THEIRS)do
			local part=char:FindFirstChild(n)
			if part and part:IsA("BasePart")then
				local nc=bag[n]
				if not(nc and nc.Parent)then
					pcall(function()
						local k=Instance.new("NoCollisionConstraint")
						k.Part0,k.Part1=mine,part
						k.Parent=mine
						bag[n]=k
					end)
				end
			end
		end
	end
	local _watched=setmetatable({},{__mode="k"})
	local _pinHooked=setmetatable({},{__mode="k"})
	local function _pin(p)
		if not p:IsA("BasePart")then
			return
		end
		if p.CanCollide then
			p.CanCollide=false
		end
		if _watched[p]then
			return
		end
		_watched[p]=true
		pcall(function()
			p:GetPropertyChangedSignal("CanCollide"):Connect(function()
				if p.CanCollide then
					p.CanCollide=false
				end
			end)
		end)
	end
	local function _pinChar(ch)
		if not ch then
			return
		end
		for _,d in ipairs(ch:GetDescendants())do
			_pin(d)
		end
		if not _pinHooked[ch]then
			_pinHooked[ch]=true
			ch.DescendantAdded:Connect(function(d)
				task.defer(_pin,d)
			end)
		end
	end
	local function _hookPlayer(pl)
		if pl==LP then
			return
		end
		if pl.Character then
			_declawChar(pl.Character)
			_noCollide(pl.Character)
			_pinChar(pl.Character)
		end
		pl.CharacterAdded:Connect(function(c)
			task.wait(.05)
			_declawChar(c)
			_noCollide(c)
			_pinChar(c)
		end)
	end
	for _,pl in ipairs(Players:GetPlayers())do
		_hookPlayer(pl)
	end
	Players.PlayerAdded:Connect(_hookPlayer)
	LP.CharacterAdded:Connect(function()
		task.wait(.3)
		for _,pl in ipairs(Players:GetPlayers())do
			if pl~=LP and pl.Character then
				_noCollide(pl.Character)
			end
		end
	end)
	local function _pinPlayer(pl)
		if pl==LP then
			return
		end
		if pl.Character then
			_pinChar(pl.Character)
		end
		pl.CharacterAdded:Connect(function(c)
			task.wait(.15)
			_pinChar(c)
		end)
	end
	for _,pl in ipairs(Players:GetPlayers())do
		_pinPlayer(pl)
	end
	Players.PlayerAdded:Connect(_pinPlayer)
	local _MY_CLONE_N=tostring(LP.UserId).."_Clone"
	local function _clones()
		local t=_OTHER_CLONES
		return(type(t)=="table")and t or{}
	end
	local _ncAcc=0
	RunService.Stepped:Connect(function(_,dt)
		if _G.ElysiumNoCollide==false or _G.isCloning==true then
			return
		end
		_ncAcc=_ncAcc+(dt or .016)
		if _ncAcc<.25 then
			return
		end
		_ncAcc=0
		local c=LP.Character
		local myHrp=c and c:FindFirstChild("HumanoidRootPart")
		if not myHrp then
			return
		end
		local mp=myHrp.Position
		local rng=tonumber(_G.ElysiumNoCollideRange)or 28
		for _,pl in ipairs(Players:GetPlayers())do
			local ch=(pl~=LP)and pl.Character
			local h=ch and ch:FindFirstChild("HumanoidRootPart")
			if h and(h.Position-mp).Magnitude<=rng then
				for _,d in ipairs(ch:GetDescendants())do
					if d:IsA("BasePart")and d.CanCollide then
						d.CanCollide=false
					end
				end
			end
		end
		for _,cl in ipairs(_clones())do
			if cl and cl.Parent and cl.Name~=_MY_CLONE_N then
				local h=cl:FindFirstChild("HumanoidRootPart")
				if h and(h.Position-mp).Magnitude<=rng then
					for _,d in ipairs(cl:GetDescendants())do
						if d:IsA("BasePart")and d.CanCollide then
							d.CanCollide=false
						end
					end
				end
			end
		end
	end)
	task.spawn(function()
		while true do
			task.wait(1)
			if _G.ElysiumNoCollide~=false and _G.isCloning~=true then
				for _,pl in ipairs(Players:GetPlayers())do
					local ch=(pl~=LP)and pl.Character
					if ch then
						_pinChar(ch)
					end
				end
				for _,cl in ipairs(_clones())do
					if cl and cl.Parent and cl.Name~=_MY_CLONE_N then
						_pinChar(cl)
					end
				end
			end
		end
	end)
end
local _event={boxes={},scanned=-math.huge}
do
	local function kind(text)
		local s=tostring(text or""):lower():gsub("[_%-]"," ")
		local compact=s:gsub("%s","")
		if
			compact=="wheel"
			or s:find("spinwheel",1,true)
			or s:find("luckywheel",1,true)
			or(s:find("wheel",1,true)and(s:find("spin",1,true)or s:find("eclipse",1,true)))
			or s:find("rueda de eclipse",1,true)
			or s:find("eclipse wheel",1,true)
		then
			return"wheel"
		end
		if
			s:find("eventboard",1,true)
			or s:find("event board",1,true)
			or s:find("next event",1,true)
			or s:find("ximo evento",1,true)
			or(
				(s:find("skeleton",1,true)or s:find("skull",1,true))
				and(s:find("board",1,true)or s:find("sign",1,true)or s:find("event",1,true))
			)
		then
			return"board"
		end
	end
	_event.kind=kind
	local function excluded(model)
		local p=model
		while p and p~=workspace do
			local n=p.Name:lower():gsub("[%s_%-]","")
			if
				n=="animals"
				or n=="animalpodiums"
				or n=="pets"
				or n=="characters"
				or p:FindFirstChildOfClass("Humanoid")
			then
				return true
			end
			p=p.Parent
		end
		return false
	end
	local function container(model)
		local n=model.Name:lower():gsub("[%s_%-]","")
		return n=="map"
			or n=="world"
			or n=="plots"
			or n=="plot"
			or n=="base"
			or n=="bases"
			or n=="decorations"
			or n=="events"
	end
	local function bounds(model)
		if excluded(model)or container(model)then
			return nil
		end
		local ok,cf,size=pcall(function()
			return model:GetBoundingBox()
		end)
		if
			not ok
			or not cf
			or not size
			or math.max(size.X,size.Y,size.Z)>130
			or math.max(size.X,size.Y,size.Z)<4
		then
			return nil
		end
		local r,u,l=cf.RightVector,cf.UpVector,cf.LookVector
		local half=Vector3.new(
			math.abs(r.X)*size.X+math.abs(u.X)*size.Y+math.abs(l.X)*size.Z,
			math.abs(r.Y)*size.X+math.abs(u.Y)*size.Y+math.abs(l.Y)*size.Z,
			math.abs(r.Z)*size.X+math.abs(u.Z)*size.Y+math.abs(l.Z)*size.Z
		)*.5
		return cf.Position-half,cf.Position+half
	end
	local function modelFor(object)
		local p=object:IsA("Model")and object or object.Parent
		local nearest
		while p and p~=workspace do
			if p:IsA("Model")then
				if container(p)or excluded(p)then
					break
				end
				local lo=bounds(p)
				if lo then
					nearest=nearest or p
					if kind(p.Name)then
						return p
					end
				end
			end
			p=p.Parent
		end
		return nearest
	end
	local function scanEvents(yielding)
		local models={}
		local list=workspace:GetDescendants()
		local chunk=tonumber(_G.ElysiumEventScanChunk)or 1500
		for i=1,#list do
			local object=list[i]
			local found=object.Parent~=nil and object:IsA("Model")and kind(object.Name)
			if not found and object.Parent~=nil and(object:IsA("TextLabel")or object:IsA("TextButton"))then
				found=kind(object.Text)
			end
			if found then
				local model=modelFor(object)
				if model then
					models[model]=found
				end
			end
			if yielding and i%chunk==0 then
				task.wait()
			end
		end
		return models
	end
	function _event.refresh()
		if _event.boxes and os.clock()-_event.scanned<(tonumber(_G.ElysiumEventCacheAge)or 12)then
			return
		end
		if _event.boxes and _event.bgRunning then
			return
		end
		_event.scanned=os.clock()
		_event.store(scanEvents(false))
	end
	if not _event.bgStarted then
		_event.bgStarted=true
		task.spawn(function()
			task.wait(tonumber(_G.ElysiumEventScanDelay)or 8)
			while true do
				_event.bgRunning=true
				local ok,models=pcall(scanEvents,true)
				if ok and models then
					_event.scanned=os.clock()
					pcall(_event.store,models)
				end
				task.wait(tonumber(_G.ElysiumEventScanEvery)or 6)
			end
		end)
	end
	function _event.store(models)
		local boxes={}
		local counts={wheel=0,board=0}
		for model,tag in pairs(models)do
			local lo,hi=bounds(model)
			local part=model:FindFirstChildWhichIsA("BasePart",true)
			if lo and part then
				boxes[#boxes+1]={lo=lo,hi=hi,part=part,model=model,kind=tag}
				counts[tag]+=1
			end
		end
		_event.boxes=boxes
		_G.ElysiumEventObstacleStatus={wheel=counts.wheel,board=counts.board,total=#boxes}
	end
	function _event.intersection(a,b,lo,hi,padding)
		local enter,leave=0,1
		padding=padding or 0
		for _,axis in ipairs({"X","Y","Z"})do
			local origin,delta=a[axis],b[axis]-a[axis]
			local low,high=lo[axis]-padding,hi[axis]+padding
			if math.abs(delta)<1e-7 then
				if origin<low or origin>high then
					return nil
				end
			else
				local t1,t2=(low-origin)/delta,(high-origin)/delta
				if t1>t2 then
					t1,t2=t2,t1
				end
				enter=math.max(enter,t1)
				leave=math.min(leave,t2)
				if enter>leave then
					return nil
				end
			end
		end
		return enter,leave
	end
	function _event.hit(a,b,padding)
		local best,bestT
		for _,box in ipairs(_event.boxes)do
			if box.model.Parent then
				local t=_event.intersection(a,b,box.lo,box.hi,padding)
				local p=padding or 0
				local function contains(v)
					return v.X>=box.lo.X-p
						and v.X<=box.hi.X+p
						and v.Y>=box.lo.Y-p
						and v.Y<=box.hi.Y+p
						and v.Z>=box.lo.Z-p
						and v.Z<=box.hi.Z+p
				end
				local startsInside=contains(a)
				local leaving=startsInside and not contains(b)
				if leaving then
					local actualEntry=_event.intersection(a,b,box.lo,box.hi,0)
					local insideActual=a.X>=box.lo.X
						and a.X<=box.hi.X
						and a.Y>=box.lo.Y
						and a.Y<=box.hi.Y
						and a.Z>=box.lo.Z
						and a.Z<=box.hi.Z
					if actualEntry and not insideActual then
						leaving=false
					end
					if insideActual then
						local distances={
							a.X-box.lo.X,
							box.hi.X-a.X,
							a.Y-box.lo.Y,
							box.hi.Y-a.Y,
							a.Z-box.lo.Z,
							box.hi.Z-a.Z,
						}
						local face=1
						for i=2,6 do
							if distances[i]<distances[face]then
								face=i
							end
						end
						local delta=b-a
						local directions={-delta.X,delta.X,-delta.Y,delta.Y,-delta.Z,delta.Z}
						leaving=directions[face]>0
					end
				end
				if t and not leaving and(not bestT or t<bestT)then
					best,bestT=box,t
				end
			end
		end
		if best then
			return{
				Instance=best.part,
				Position=a+(b-a)*bestT,
				Distance=(b-a).Magnitude*bestT,
				EventTop=best.hi.Y,
				EventBox=best,
			}
		end
	end
	function _event.overlap(center,size)
		local half=size*.5
		for _,box in ipairs(_event.boxes)do
			if
				box.model.Parent
				and center.X+half.X>=box.lo.X
				and center.X-half.X<=box.hi.X
				and center.Y+half.Y>=box.lo.Y
				and center.Y-half.Y<=box.hi.Y
				and center.Z+half.Z>=box.lo.Z
				and center.Z-half.Z<=box.hi.Z
			then
				return true
			end
		end
		return false
	end
end
local _len
do
	local _DIRS={Vector3.new(1,0,0),Vector3.new(-1,0,0),Vector3.new(0,0,1),Vector3.new(0,0,-1)}
	local _STRUCT={["structure base home"]=true,["Wall"]=true,["Floor"]=true,["Roof"]=true}
	local _SKIP_NAME={["DeliveryHitbox"]=true,["StealHitbox"]=true,["LaserHitbox"]=true,["AnimalTarget"]=true,["Multiplier"]=true,["Laser"]=true,["Hitbox"]=true,["Spawn"]=true,["MainRoot"]=true,["SecondFloor"]=true,["ThirdFloor"]=true,["Slope"]=true,}
	local function _blocks(inst)
		if not inst then
			return false
		end
		if _SKIP_NAME[inst.Name]then
			return false
		end
		if inst.CanCollide then
			return true
		end
		local _par=inst.Parent
		if _par and(_par.Name=="ObstacleVolumes"or _par.Name=="ObstacleVolume")then
			return false
		end
		if _STRUCT[inst.Name]then
			return true
		end
		local s=inst.Size
		if s and math.max(s.X*s.Y,s.X*s.Z,s.Y*s.Z)>150 then
			return true
		end
		return false
	end
	local function _blocksWide(inst)
		if not inst then
			return false
		end
		if _SKIP_NAME[inst.Name]then
			return false
		end
		if inst.CanCollide then
			return true
		end
		local _par=inst.Parent
		if _par and(_par.Name=="ObstacleVolumes"or _par.Name=="ObstacleVolume")then
			return false
		end
		if _STRUCT[inst.Name]then
			return true
		end
		local s=inst.Size
		if s and math.max(s.X*s.Y,s.X*s.Z,s.Y*s.Z)>30 then
			return true
		end
		return false
	end
	local function _block(origin,target,blockFn)
		local eventHit=_event.hit(origin,target,3)
		if eventHit then
			return eventHit
		end
		blockFn=blockFn or _blocks
		local rp=RaycastParams.new()
		rp.FilterType=Enum.RaycastFilterType.Exclude
		rp.IgnoreWater=true
		local skip={}
		for _,pl in ipairs(Players:GetPlayers())do
			if pl.Character then
				skip[#skip+1]=pl.Character
			end
		end
		for _,cl in ipairs(_OTHER_CLONES)do
			skip[#skip+1]=cl
		end
		local o=origin
		for _=1,16 do
			rp.FilterDescendantsInstances=skip
			local d=target-o
			if d.Magnitude<.05 then
				return nil
			end
			local res=workspace:Raycast(o,d,rp)
			if not res then
				return nil
			end
			if blockFn(res.Instance)then
				return res
			end
			skip[#skip+1]=res.Instance
			o=res.Position+d.Unit*.3
		end
		return nil
	end
	local function _clear(a,b)
		return _block(a,b)==nil
	end
	function _len(pts)
		local s,prev=0,pts[1]
		for k=2,#pts do
			s=s+(pts[k]-prev).Magnitude
			prev=pts[k]
		end
		return s
	end
	local function _peakY(pts)
		local m=-math.huge
		for _,p in ipairs(pts)do
			if p.Y>m then
				m=p.Y
			end
		end
		return m
	end
	local PathfindingService=ElysiumService("PathfindingService")
	local _CLEARANCE=16
	local function _clearWideRay(a,b)
		return _block(a,b,_blocksWide)==nil
	end
	local _SWEEP_R=4
	local _ENDPOINT_SLACK=6
	local _canSphere=nil
	local function _sweepBlockFn(inst)
		if _G.ElysiumStrictSweep==false then
			return _blocks(inst)
		end
		return _blocksWide(inst)
	end
	local function _sweepDir(a,b)
		local rp=RaycastParams.new()
		rp.FilterType=Enum.RaycastFilterType.Exclude
		rp.IgnoreWater=true
		local skip={}
		for _,pl in ipairs(Players:GetPlayers())do
			if pl.Character then
				skip[#skip+1]=pl.Character
			end
		end
		for _,cl in ipairs(_OTHER_CLONES)do
			skip[#skip+1]=cl
		end
		local o=a
		for _=1,24 do
			rp.FilterDescendantsInstances=skip
			local d=b-o
			if d.Magnitude<.05 then
				return false
			end
			local res
			local ok=pcall(function()
				res=workspace:Spherecast(o,_SWEEP_R,d,rp)
			end)
			if not ok then
				_canSphere=false
				return nil
			end
			if not res then
				return false
			end
			if _sweepBlockFn(res.Instance)then
				return true
			end
			skip[#skip+1]=res.Instance
			local adv=(res.Distance or 0)-.05
			if adv>0 then
				o=o+d.Unit*math.min(adv,d.Magnitude)
			end
		end
		return true
	end
	local function _sweepBlocked(a,b,slackA,slackB)
		if _event.hit(a,b,_SWEEP_R+2)then
			return true
		end
		if _canSphere==nil then
			_canSphere=pcall(function()
				workspace:Spherecast(Vector3.new(0,10000,0),1,Vector3.new(0,-1,0),RaycastParams.new())
			end)
		end
		if not _canSphere then
			return nil
		end
		local d=b-a
		local len=d.Magnitude
		if len<.1 then
			return false
		end
		local u=d/len
		local a2=a+u*math.min(slackA or _ENDPOINT_SLACK,len*.4)
		local b2=b-u*math.min(slackB or _ENDPOINT_SLACK,len*.4)
		local fwd=_sweepDir(a2,b2)
		if fwd==nil then
			return nil
		end
		if fwd then
			return true
		end
		local rev=_sweepDir(b2,a2)
		if rev==nil then
			return nil
		end
		return rev
	end
	local function _clearWide(a,b,slackA,slackB)
		if not _clear(a,b)then
			return false
		end
		local sw=_sweepBlocked(a,b,slackA,slackB)
		if sw~=nil then
			return not sw
		end
		local d=Vector3.new(b.X-a.X,0,b.Z-a.Z)
		if d.Magnitude<.1 then
			local ox=Vector3.new(_CLEARANCE,0,0)
			local oz=Vector3.new(0,0,_CLEARANCE)
			return _clearWideRay(a+ox,b+ox)
				and _clearWideRay(a-ox,b-ox)
				and _clearWideRay(a+oz,b+oz)
				and _clearWideRay(a-oz,b-oz)
		end
		local perp=Vector3.new(-d.Z,0,d.X).Unit*_CLEARANCE
		local up=Vector3.new(0,_CLEARANCE,0)
		return _clearWideRay(a+perp,b+perp)
			and _clearWideRay(a-perp,b-perp)
			and _clearWideRay(a+up,b+up)
			and _clearWideRay(a-up,b-up)
	end
	local function _crestClear(a,b)
		if not _clear(a,b)then
			return false
		end
		local cl=tonumber(_G.ElysiumCrestClearance)or 6
		local d=Vector3.new(b.X-a.X,0,b.Z-a.Z)
		if d.Magnitude<.1 then
			return true
		end
		local perp=Vector3.new(-d.Z,0,d.X).Unit*cl
		return _clearWideRay(a+perp,b+perp)
			and _clearWideRay(a-perp,b-perp)
			and _clearWideRay(a+Vector3.new(0,cl,0),b+Vector3.new(0,cl,0))
	end
	local function _pullWide(pts)
		if#pts<=2 then
			return pts
		end
		local out={pts[1]}
		local i=1
		local n=#pts
		while i<n do
			local j=n
			while j>i+1 do
				local a,b=out[#out],pts[j]
				local sA=(i==1)and _ENDPOINT_SLACK or 0
				local sB=(j==n)and _ENDPOINT_SLACK or 0
				if _clearWide(a,b,sA,sB)then
					break
				end
				j=j-1
			end
			out[#out+1]=pts[j]
			i=j
		end
		return out
	end
	local function _pushOffWalls(pts)
		if#pts<=2 then
			return pts
		end
		local MARGIN=8
		local MAX_PUSH=12
		local out={pts[1]}
		for i=2,#pts-1 do
			local p=pts[i]
			local shift=Vector3.zero
			for _,dr in ipairs(_DIRS)do
				local res=_block(p,p+dr*MARGIN,_blocks)
				if res then
					local dist=(res.Position-p).Magnitude
					if dist<MARGIN then
						shift=shift-dr*(MARGIN-dist)
					end
				end
			end
			do
				local resUp=_block(p,p+Vector3.new(0,MARGIN,0),_blocks)
				if resUp then
					local dist=(resUp.Position-p).Magnitude
					if dist<4 then
						shift=shift+Vector3.new(0,-(4-dist),0)
					end
				end
			end
			if shift.Magnitude>.1 then
				if shift.Magnitude>MAX_PUSH then
					shift=shift.Unit*MAX_PUSH
				end
				local moved=p+shift
				if _clear(out[#out],moved)then
					out[#out+1]=moved
				else
					out[#out+1]=p
				end
			else
				out[#out+1]=p
			end
		end
		out[#out+1]=pts[#pts]
		return out
	end
	do
		local _vxFloor,_vxSqrt=math.floor,math.sqrt
		local _vxMin,_vxMax=math.min,math.max
		local function _vxAbs(n)
			return n<0 and-n or n
		end
		local _vxOverlap=OverlapParams.new()
		_vxOverlap.FilterType=Enum.RaycastFilterType.Exclude
		_vxOverlap.RespectCanCollide=true
		local _vxCast=RaycastParams.new()
		_vxCast.FilterType=Enum.RaycastFilterType.Exclude
		_vxCast.RespectCanCollide=true
		_vxCast.IgnoreWater=true
		local _vxOrigin
		local _vxDimX,_vxDimY,_vxDimZ=0,0,0
		local _vxSz,_vxInflate=4,2.5
		local _vxSolid={}
		local _vxHeight=5
		local function _vxWorld(sz,x,y,z)
			local h=sz*.5
			return Vector3.new(_vxOrigin.X+x*sz+h,_vxOrigin.Y+y*sz+h,_vxOrigin.Z+z*sz+h)
		end
		local function _vxKey(x,y,z)
			return x+y*1024+z*1048576
		end
		local function _vxIsSolid(x,y,z)
			if x<0 or y<0 or z<0 or x>=_vxDimX or y>=_vxDimY or z>=_vxDimZ then
				return true
			end
			local k=_vxKey(x,y,z)
			local c=_vxSolid[k]
			if c~=nil then
				return c
			end
			local h=_vxSz*.5
			local cx=_vxOrigin.X+x*_vxSz+h
			local cy=_vxOrigin.Y+y*_vxSz+h
			local cz=_vxOrigin.Z+z*_vxSz+h
			local sxz=_vxSz+_vxInflate
			local vy=_vxHeight>_vxSz and _vxHeight or _vxSz
			local vcy=cy-h+vy*.5
			local parts=workspace:GetPartBoundsInBox(CFrame.new(cx,vcy,cz),Vector3.new(sxz,vy,sxz),_vxOverlap)
			local solid=#parts>0 or _event.overlap(Vector3.new(cx,vcy,cz),Vector3.new(sxz,vy,sxz))
			_vxSolid[k]=solid
			return solid
		end
		local function _vxSegClear(from,to,radius,height,sample)
			if _event.hit(from,to,math.max(radius or 1,(height or 3)*.5)+2)then
				return false
			end
			local dir=to-from
			local mag=dir.Magnitude
			if mag<.05 then
				return true
			end
			if workspace:Raycast(from,dir,_vxCast)then
				return false
			end
			local r=radius>1 and radius or 1
			if workspace:Blockcast(CFrame.new(from),Vector3.new(r*2,height,r*2),dir,_vxCast)~=nil then
				return false
			end
			local n=_vxFloor(mag)
			if sample~=false and n>=2 then
				local step=dir/n
				local torso=Vector3.new(r*2,3,r*2)
				for i=1,n-1 do
					local pt=from+step*i
					if#workspace:GetPartBoundsInBox(CFrame.new(pt),torso,_vxOverlap)>0 then
						return false
					end
				end
			end
			return true
		end
		local _vxNeigh={}
		do
			for dx=-1,1 do
				for dy=-1,1 do
					for dz=-1,1 do
						if dx~=0 or dy~=0 or dz~=0 then
							local nz=(dx~=0 and 1 or 0)+(dy~=0 and 1 or 0)+(dz~=0 and 1 or 0)
							local kd=dx+dy*1024+dz*1048576
							_vxNeigh[#_vxNeigh+1]={dx,dy,dz,_vxSqrt(dx*dx+dy*dy+dz*dz),nz,kd}
						end
					end
				end
			end
		end
		local function _vxNoCorner(cx,cy,cz,off)
			if off[5]<2 then
				return true
			end
			if off[1]~=0 and _vxIsSolid(cx+off[1],cy,cz)then
				return false
			end
			if off[2]~=0 and _vxIsSolid(cx,cy+off[2],cz)then
				return false
			end
			if off[3]~=0 and _vxIsSolid(cx,cy,cz+off[3])then
				return false
			end
			return true
		end
		local function _vxSnapGoal(goalPos,x,y,z)
			if not _vxIsSolid(x,y,z)then
				return x,y,z
			end
			for r=1,16 do
				for dx=-r,r do
					for dy=-r,r do
						for dz=-r,r do
							if _vxMax(_vxAbs(dx),_vxAbs(dy),_vxAbs(dz))==r then
								local nx,ny,nz=x+dx,y+dy,z+dz
								if
									not _vxIsSolid(nx,ny,nz)
									and(_vxWorld(_vxSz,nx,ny,nz)-goalPos).Magnitude<=8
								then
									return nx,ny,nz
								end
							end
						end
					end
				end
			end
			return x,y,z
		end
		local function _vxSnapStart(pos,x,y,z)
			if not _vxIsSolid(x,y,z)then
				return x,y,z
			end
			for r=1,16 do
				for dx=-r,r do
					for dy=-r,r do
						for dz=-r,r do
							if _vxMax(_vxAbs(dx),_vxAbs(dy),_vxAbs(dz))==r then
								local nx,ny,nz=x+dx,y+dy,z+dz
								if
									not _vxIsSolid(nx,ny,nz)
									and not workspace:Raycast(pos,_vxWorld(_vxSz,nx,ny,nz)-pos,_vxCast)
								then
									return nx,ny,nz
								end
							end
						end
					end
				end
			end
			return x,y,z
		end
		local function _vxPush(h,f,key)
			local i=#h+1
			h[i]={f,key}
			while i>1 do
				local p=_vxFloor(i*.5)
				if h[p][1]<=h[i][1]then
					break
				end
				h[p],h[i]=h[i],h[p]
				i=p
			end
		end
		local function _vxPop(h)
			local n=#h
			if n==0 then
				return nil
			end
			local top=h[1]
			h[1]=h[n]
			h[n]=nil
			n-=1
			local i=1
			while true do
				local l,r,s=i+i,i+i+1,i
				if l<=n and h[l][1]<h[s][1]then
					s=l
				end
				if r<=n and h[r][1]<h[s][1]then
					s=r
				end
				if s==i then
					break
				end
				h[i],h[s]=h[s],h[i]
				i=s
			end
			return top[2]
		end
		local _vxHeurW=2
		local function _vxAStar(sz,startCell,goalCell,startPos,goalPos)
			local sx,sy,sz2=_vxSnapStart(startPos,startCell.x,startCell.y,startCell.z)
			local gx,gy,gz=_vxSnapGoal(goalPos,goalCell.x,goalCell.y,goalCell.z)
			local goalKey=_vxKey(gx,gy,gz)
			local startKey=_vxKey(sx,sy,sz2)
			local nodes={[startKey]={x=sx,y=sy,z=sz2,g=0,parent=nil}}
			local closed={}
			local heap={}
			_vxPush(heap,0,startKey)
			local function Heur(x,y,z)
				local ax,ay,az=x-gx,y-gy,z-gz
				return _vxSqrt(ax*ax+ay*ay+az*az)
			end
			local pops=0
			while#heap>0 do
				local curKey=_vxPop(heap)
				if closed[curKey]then
					continue
				end
				closed[curKey]=true
				pops+=1
				if pops>300000 then
					break
				end
				local cur=nodes[curKey]
				if curKey==goalKey then
					local path={}
					local n=cur
					while n do
						path[#path+1]=_vxWorld(sz,n.x,n.y,n.z)
						n=n.parent and nodes[n.parent]
					end
					local rev={}
					for i=#path,1,-1 do
						rev[#rev+1]=path[i]
					end
					return rev
				end
				local cx,cy,cz=cur.x,cur.y,cur.z
				local cg=cur.g
				for _,off in _vxNeigh do
					local nk=curKey+off[6]
					if closed[nk]then
						continue
					end
					local nx,ny,nz=cx+off[1],cy+off[2],cz+off[3]
					if _vxIsSolid(nx,ny,nz)then
						continue
					end
					if not _vxNoCorner(cx,cy,cz,off)then
						continue
					end
					local tg=cg+off[4]
					local ex=nodes[nk]
					if not ex or tg<ex.g then
						if ex then
							ex.g,ex.parent,ex.x,ex.y,ex.z=tg,curKey,nx,ny,nz
						else
							nodes[nk]={x=nx,y=ny,z=nz,g=tg,parent=curKey}
						end
						_vxPush(heap,tg+_vxHeurW*Heur(nx,ny,nz),nk)
					end
				end
			end
			return nil
		end
		local function _vxSimplify(path,radius,height)
			if not path or#path<3 then
				return path
			end
			local out={path[1]}
			local anchor=1
			local i=2
			while i<=#path do
				if not _vxSegClear(path[anchor],path[i+1]or path[i],radius,height,false)then
					out[#out+1]=path[i]
					anchor=i
				end
				i+=1
			end
			out[#out+1]=path[#path]
			return out
		end
		voxelRoute=function(fromPos,toPos)
			local char=LP.Character
			local _flt=char and{char}or{}
			for _,cl in ipairs(_OTHER_CLONES)do
				_flt[#_flt+1]=cl
			end
			_vxOverlap.FilterDescendantsInstances=_flt
			_vxCast.FilterDescendantsInstances=_flt
			local sz=tonumber(_G.ElysiumPathCell)or 4
			local inflate=tonumber(_G.ElysiumPathRadius)or 2.5
			local height=tonumber(_G.ElysiumPathHeight)or 5
			local pad=tonumber(_G.ElysiumPathPad)or 40
			_vxSz,_vxInflate,_vxHeight=sz,inflate,height
			table.clear(_vxSolid)
			local mn=Vector3.new(_vxMin(fromPos.X,toPos.X),_vxMin(fromPos.Y,toPos.Y),_vxMin(fromPos.Z,toPos.Z))
				-Vector3.new(pad,pad,pad)
			local mx=Vector3.new(_vxMax(fromPos.X,toPos.X),_vxMax(fromPos.Y,toPos.Y),_vxMax(fromPos.Z,toPos.Z))
				+Vector3.new(pad,pad,pad)
			_vxOrigin=mn
			local size=mx-mn
			_vxDimX=_vxFloor(size.X/sz)+1
			_vxDimY=_vxFloor(size.Y/sz)+1
			_vxDimZ=_vxFloor(size.Z/sz)+1
			if _vxDimX*_vxDimY*_vxDimZ>200000 then
				return nil
			end
			local startCell={
				x=_vxFloor((fromPos.X-_vxOrigin.X)/sz),
				y=_vxFloor((fromPos.Y-_vxOrigin.Y)/sz),
				z=_vxFloor((fromPos.Z-_vxOrigin.Z)/sz),
			}
			local goalCell={
				x=_vxFloor((toPos.X-_vxOrigin.X)/sz),
				y=_vxFloor((toPos.Y-_vxOrigin.Y)/sz),
				z=_vxFloor((toPos.Z-_vxOrigin.Z)/sz),
			}
			local path=_vxAStar(sz,startCell,goalCell,fromPos,toPos)
			if not path then
				return nil
			end
			path=_vxSimplify(path,inflate,height)
			if not path or#path==0 then
				return nil
			end
			local route={}
			for idx=2,#path do
				route[#route+1]=path[idx]
			end
			if#route==0 or(route[#route]-toPos).Magnitude>.5 then
				route[#route+1]=toPos
			end
			return route
		end
	end
	_G.ElysiumVoxelRoute=voxelRoute
	local _MAP_CENTER={minX=-458,maxX=-362,minZ=-40,maxZ=185}
	local _BYPASS_Z_NORTH,_BYPASS_Z_SOUTH=205,-95
	local _BYPASS_X_WEST,_BYPASS_X_EAST=-525,-295
	local function _inCenterZone(x,z)
		return x>=_MAP_CENTER.minX and x<=_MAP_CENTER.maxX and z>=_MAP_CENTER.minZ and z<=_MAP_CENTER.maxZ
	end
	local function _segmentCrossesCenter(a,b)
		if _inCenterZone(a.X,a.Z)or _inCenterZone(b.X,b.Z)then
			return true
		end
		for i=1,10 do
			local t=i/11
			if _inCenterZone(a.X+(b.X-a.X)*t,a.Z+(b.Z-a.Z)*t)then
				return true
			end
		end
		return false
	end
	local function _findBestCenterDetour(fromPos,toPos,y)
		local candidates={
			{Vector3.new(fromPos.X,y,_BYPASS_Z_NORTH),Vector3.new(toPos.X,y,_BYPASS_Z_NORTH)},
			{Vector3.new(fromPos.X,y,_BYPASS_Z_SOUTH),Vector3.new(toPos.X,y,_BYPASS_Z_SOUTH)},
			{Vector3.new(_BYPASS_X_WEST,y,fromPos.Z),Vector3.new(_BYPASS_X_WEST,y,toPos.Z)},
			{Vector3.new(_BYPASS_X_EAST,y,fromPos.Z),Vector3.new(_BYPASS_X_EAST,y,toPos.Z)},
		}
		local best,bestLen=nil,math.huge
		for _,pair in ipairs(candidates)do
			local w1,w2=pair[1],pair[2]
			if _clearWide(fromPos,w1)and _clearWide(w1,w2)and _clearWide(w2,toPos)then
				local len=(fromPos-w1).Magnitude+(w1-w2).Magnitude+(w2-toPos).Magnitude
				if len<bestLen then
					bestLen=len
					best={w1,w2}
				end
			end
		end
		return best
	end
	_G.ElysiumSegmentCrossesCenter=_segmentCrossesCenter
	_G.ElysiumFindCenterDetour=_findBestCenterDetour
	local function _rowBoxX()
		return tonumber(_G.ElysiumRowBoxX)or 26
	end
	local function _rowBoxZ()
		return tonumber(_G.ElysiumRowBoxZ)or 30
	end
	local function _rowLane()
		return tonumber(_G.ElysiumRowLane)or 30
	end
	local function _nearestBase(p)
		local bi,bd=nil,math.huge
		for i=1,8 do
			local b=BASES_LOW[i]
			local d=(p.X-b.X)^2+(p.Z-b.Z)^2
			if d<bd then
				bd=d
				bi=i
			end
		end
		if bd>70*70 then
			return nil
		end
		return bi
	end
	local function _segmentHitsOtherBase(a,b,ignA,ignB)
		local hx,hz=_rowBoxX(),_rowBoxZ()
		for i=0,24 do
			local t=i/24
			local px=a.X+(b.X-a.X)*t
			local pz=a.Z+(b.Z-a.Z)*t
			for k=1,8 do
				if k~=ignA and k~=ignB then
					local bs=BASES_LOW[k]
					if math.abs(px-bs.X)<=hx and math.abs(pz-bs.Z)<=hz then
						return true
					end
				end
			end
		end
		return false
	end
	local function _findRowDetour(fromPos,toPos,y)
		local iFrom,iTo=_nearestBase(fromPos),_nearestBase(toPos)
		if not _segmentHitsOtherBase(fromPos,toPos,iFrom,iTo)then
			return nil
		end
		local colX=BASES_LOW[iTo or 1].X
		local off=_rowLane()
		local lanes={}
		local outer=(colX<COLUMN_SPLIT_X)and(colX-off)or(colX+off)
		lanes[#lanes+1]=outer
		local inner=(colX<COLUMN_SPLIT_X)and(colX+off)or(colX-off)
		if not _inCenterZone(inner,(fromPos.Z+toPos.Z)*.5)then
			lanes[#lanes+1]=inner
		end
		local best,bestLen=nil,math.huge
		for _,laneX in ipairs(lanes)do
			local w1=Vector3.new(laneX,y,fromPos.Z)
			local w2=Vector3.new(laneX,y,toPos.Z)
			if
				_clearWide(fromPos,w1)
				and _clearWide(w1,w2)
				and _clearWide(w2,toPos)
				and not _segmentHitsOtherBase(w1,w2,iFrom,iTo)
			then
				local len=(fromPos-w1).Magnitude+(w1-w2).Magnitude+(w2-toPos).Magnitude
				if len<bestLen then
					bestLen=len
					best={w1,w2}
				end
			end
		end
		return best
	end
	_G.ElysiumFindRowDetour=_findRowDetour
	local _hopRP=RaycastParams.new()
	_hopRP.FilterType=Enum.RaycastFilterType.Exclude
	local function _partTopY(inst)
		local ok,t=pcall(function()
			local cf,sz=inst.CFrame,inst.Size
			local half=(
				math.abs(cf.RightVector.Y)*sz.X
				+math.abs(cf.UpVector.Y)*sz.Y
				+math.abs(cf.LookVector.Y)*sz.Z
			)/2
			return cf.Position.Y+half
		end)
		if ok and t then
			return t
		end
		return inst.Position.Y+(inst.Size.Y/2)
	end
	local function _hopBlockerTop(a,b)
		local eventHit=_event.hit(a,b,3)
		local ignore={LP.Character}
		for _,cl in ipairs(_OTHER_CLONES)do
			ignore[#ignore+1]=cl
		end
		local top=eventHit and eventHit.EventTop or nil
		for _=1,10 do
			_hopRP.FilterDescendantsInstances=ignore
			local r=workspace:Raycast(a,b-a,_hopRP)
			if not r then
				break
			end
			if _blocks(r.Instance)then
				local t=_partTopY(r.Instance)
				if not top or t>top then
					top=t
				end
			end
			ignore[#ignore+1]=r.Instance
		end
		return top
	end
	local function _hopRoute(fromPos,toPos)
		local flat=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
		local dist=flat.Magnitude
		if dist<8 then
			return nil
		end
		local dir=flat.Unit
		local step=tonumber(_G.ElysiumHopStep)or 8
		local clear=tonumber(_G.ElysiumHopClear)or 4
		local maxUp=tonumber(_G.ElysiumHopMaxUp)or 22
		local groundY=fromPos.Y
		local route={}
		local inHop,hopY,hopStart=false,nil,nil
		local i=step
		while i<=dist do
			local a=fromPos+dir*(i-step)
			local b=fromPos+dir*math.min(i,dist)
			local ga=Vector3.new(a.X,groundY,a.Z)
			local gb=Vector3.new(b.X,groundY,b.Z)
			if not _clear(ga,gb)then
				local top=_hopBlockerTop(ga,gb)or(groundY+6)
				local want=top+clear
				if want-groundY>maxUp then
					return nil
				end
				if not inHop then
					inHop,hopY,hopStart=true,want,ga
					route[#route+1]=Vector3.new(a.X,want,a.Z)
				elseif want>hopY then
					hopY=want
					route[#route+1]=Vector3.new(a.X,want,a.Z)
				end
			elseif inHop then
				inHop=false
				route[#route+1]=Vector3.new(b.X,hopY,b.Z)
				route[#route+1]=gb
			end
			i=i+step
		end
		if inHop then
			route[#route+1]=Vector3.new(toPos.X,hopY,toPos.Z)
		end
		route[#route+1]=toPos
		return route
	end
	_G.ElysiumHopRoute=_hopRoute
	function _event.detour(fromPos,toPos)
		local hit=_event.hit(fromPos,toPos,6)
		if not hit then
			return nil
		end
		local box=hit.EventBox
		local margin=hit.EventBox.kind=="board"and 18 or 14
		local candidates={}
		for _,x in ipairs({box.lo.X-margin,box.hi.X+margin})do
			candidates[#candidates+1]=
				{fromPos,Vector3.new(x,fromPos.Y,fromPos.Z),Vector3.new(x,toPos.Y,toPos.Z),toPos}
		end
		for _,z in ipairs({box.lo.Z-margin,box.hi.Z+margin})do
			candidates[#candidates+1]=
				{fromPos,Vector3.new(fromPos.X,fromPos.Y,z),Vector3.new(toPos.X,toPos.Y,z),toPos}
		end
		local corners={}
		for _,x in ipairs({box.lo.X-margin,box.hi.X+margin})do
			for _,z in ipairs({box.lo.Z-margin,box.hi.Z+margin})do
				corners[#corners+1]=Vector3.new(x,math.max(fromPos.Y,toPos.Y),z)
			end
		end
		for i,c in ipairs(corners)do
			candidates[#candidates+1]={fromPos,c,toPos}
			for j,d in ipairs(corners)do
				if i~=j and(c.X==d.X or c.Z==d.Z)then
					candidates[#candidates+1]={fromPos,c,d,toPos}
				end
			end
		end
		local y=math.max(fromPos.Y,toPos.Y,box.hi.Y+16)
		candidates[#candidates+1]=
			{fromPos,Vector3.new(fromPos.X,y,fromPos.Z),Vector3.new(toPos.X,y,toPos.Z),toPos}
		local best,bestLength
		for _,route in ipairs(candidates)do
			local clear=true
			for i=2,#route do
				if(route[i]-route[i-1]).Magnitude>.05 and not _clearWide(route[i-1],route[i],0,0)then
					clear=false
					break
				end
			end
			if clear then
				local length=_len(route)
				if not bestLength or length<bestLength then
					best,bestLength=route,length
				end
			end
		end
		if best then
			table.remove(best,1)
			return best
		end
	end
	local function elysiumLowLiftRoute(fromPos,toPos,dense,obstacleTop,clear)
		if not dense then
			return nil
		end
		local baseY=math.max(fromPos.Y,toPos.Y)
		local maxY=math.max(fromPos.Y+18,toPos.Y+3)
		local y=math.max(baseY,fromPos.Y+4)
		while y<=maxY do
			local up=Vector3.new(fromPos.X,y,fromPos.Z)
			local over=Vector3.new(toPos.X,y,toPos.Z)
			if clear(fromPos,up)and clear(up,over)and clear(over,toPos)then
				return{up,over,toPos}
			end
			y+=2
		end
		return nil
	end
	function computeRoute(fromPos,toPos,facingDir,maxLift,preferCrest)
		_event.refresh()
		local maxRouteY=math.max(fromPos.Y+18,toPos.Y+3)
		local directClear=_clearWide(fromPos,toPos)
		if not directClear then
			local flat=Vector3.new(toPos.X-fromPos.X,0,toPos.Z-fromPos.Z)
			local blocked,top=0,nil
			local steps=math.max(1,math.ceil(flat.Magnitude/8))
			for i=1,steps do
				local a=fromPos+flat*((i-1)/steps)
				local b=fromPos+flat*(i/steps)
				local t=_hopBlockerTop(a,b)
				if t then
					blocked+=1
					top=math.max(top or t,t)
				end
			end
			local low=elysiumLowLiftRoute(fromPos,toPos,blocked>=2,top,_crestClear)
			if low then
				return low
			end
		end
		local eventRoute=_event.detour(fromPos,toPos)
		if eventRoute and _peakY(eventRoute)<=maxRouteY then
			return eventRoute
		end
		local _=maxLift
		if _G.ElysiumHopFirst==true and not _clearWide(fromPos,toPos)then
			local hop=_hopRoute(fromPos,toPos)
			if hop and#hop>0 then
				return hop
			end
		end
		local centerPatch=nil
		if _segmentCrossesCenter(fromPos,toPos)and not _clearWide(fromPos,toPos)then
			centerPatch=_findBestCenterDetour(fromPos,toPos,fromPos.Y)
			if centerPatch and#centerPatch>0 then
				fromPos=centerPatch[#centerPatch]
			end
		end
		local rowPatch=_findRowDetour(fromPos,toPos,fromPos.Y)
		if rowPatch and#rowPatch>0 then
			fromPos=rowPatch[#rowPatch]
		end
		local function _withPatch(route)
			if(not centerPatch or#centerPatch==0)and(not rowPatch or#rowPatch==0)then
				return route
			end
			local merged={}
			if centerPatch then
				for _,p in ipairs(centerPatch)do
					merged[#merged+1]=p
				end
			end
			if rowPatch then
				for _,p in ipairs(rowPatch)do
					merged[#merged+1]=p
				end
			end
			for _,p in ipairs(route)do
				merged[#merged+1]=p
			end
			return merged
		end
		if _clearWide(fromPos,toPos)then
			return _withPatch({toPos})
		end
		do
			local vr=voxelRoute(fromPos,toPos)
			if vr and#vr>0 and _peakY(vr)<=maxRouteY then
				return _withPatch(vr)
			end
		end
		local entry=facingDir and(toPos-facingDir*14)or toPos
		local best,bestLen=nil,math.huge
		local function consider(pts)
			if not pts or#pts<2 or _peakY(pts)>maxRouteY then
				return
			end
			local n=#pts
			for i=1,n-1 do
				local a,b=pts[i],pts[i+1]
				if(a-b).Magnitude>.5 then
					local sA=(i==1)and _ENDPOINT_SLACK or 0
					local sB=(i==n-1)and _ENDPOINT_SLACK or 0
					if not _clearWide(a,b,sA,sB)then
						return
					end
				end
			end
			local pulled=_pullWide(pts)
			local L=_len(pulled)
			if L<bestLen then
				best,bestLen=pulled,L
			end
		end
		do
			local dirF=Vector3.new(entry.X-fromPos.X,0,entry.Z-fromPos.Z)
			if dirF.Magnitude>.1 then
				dirF=dirF.Unit
				local perp=Vector3.new(-dirF.Z,0,dirF.X)
				local midBase=(fromPos+entry)*.5
				for _,off in ipairs({14,-14,24,-24,38,-38,56,-56,76,-76})do
					consider({fromPos,midBase+perp*off,entry})
					consider({fromPos,fromPos+perp*off,entry+perp*off,entry})
				end
			end
		end
		local navRaw
		if not best then
			local groundTo=Vector3.new(entry.X,fromPos.Y,entry.Z)
			local path=PathfindingService:CreatePath({
				AgentRadius=16,
				AgentHeight=5,
				AgentCanJump=true,
				AgentJumpHeight=10,
				AgentMaxSlope=89,
			})
			local FLOAT=5
			local nav={fromPos}
			local ok=pcall(function()
				path:ComputeAsync(Vector3.new(fromPos.X,fromPos.Y,fromPos.Z),groundTo)
			end)
			if ok and path.Status==Enum.PathStatus.Success then
				local last=fromPos
				for _,wp in ipairs(path:GetWaypoints())do
					if(wp.Position-last).Magnitude>=8 then
						nav[#nav+1]=wp.Position+Vector3.new(0,FLOAT,0)
						last=wp.Position
					end
				end
			end
			nav[#nav+1]=entry+Vector3.new(0,FLOAT,0)
			nav=_pushOffWalls(nav)
			navRaw=nav
			consider(nav)
		end
		local route=best
		if not route and _clear(fromPos,toPos)then
			route={toPos}
		end
		if not route and navRaw and _peakY(navRaw)<=maxRouteY then
			route=_pullWide(navRaw)
		end
		if not route then
			route={toPos}
		end
		if(route[#route]-toPos).Magnitude>.5 then
			route[#route+1]=toPos
		end
		return _withPatch(route)
	end
end
function ElysiumTPLiftRoute(character,root,destPos,facingDir,preferCrest)
	local function plan(a,b)
		local r=computeRoute(a,b,facingDir,nil,preferCrest)
		if not r or#r==0 then r={b}end
		return r
	end
	if not root then return{destPos}end
	local height=tonumber(_G.ElysiumTPLiftHeight)or 7
	if not character or height<=0 then return plan(root.Position,destPos)end
	local humanoid=character:FindFirstChildOfClass("Humanoid")
	local feet=(humanoid and humanoid.HipHeight+root.Size.Y*.5)or 3
	local okHead,headroom=pcall(ElysiumCharacterHeadroom,character,root)
	headroom=(okHead and tonumber(headroom))or 2.5
	if type(ElysiumGoToCastParams)~="function"then return plan(root.Position,destPos)end
	local cast=ElysiumGoToCastParams(character)
	local box=Vector3.new(2.2,2,2.2)
	local function clear(a,b)
		local move=b-a
		if move.Magnitude<.05 then return true end
		return workspace:Blockcast(CFrame.new(a),box,move,cast)==nil
	end
	local function liftAt(p)
		local hit=workspace:Raycast(p,Vector3.new(0,-60,0),cast)
		local y=(hit and hit.Position.Y or(p.Y-feet))+feet+height
		local up=workspace:Raycast(p,Vector3.new(0,math.max(0,y-p.Y)+headroom+1,0),cast)
		if up then y=math.min(y,up.Position.Y-headroom-.8)end
		return math.max(y,p.Y)
	end
	local from=root.Position
	local route,start={},from
	local liftY=liftAt(from)
	if liftY-from.Y>.5 then
		local up=Vector3.new(from.X,liftY,from.Z)
		if clear(from,up)then
			route[1]=up
			start=up
		end
	end
	local above=Vector3.new(destPos.X,liftAt(destPos),destPos.Z)
	local descend=above.Y-destPos.Y>.5 and clear(above,destPos)
	for _,p in ipairs(plan(start,descend and above or destPos))do route[#route+1]=p end
	if descend then
		if(route[#route]-above).Magnitude>.5 then route[#route+1]=above end
		route[#route+1]=destPos
	elseif(route[#route]-destPos).Magnitude>.5 then
		route[#route+1]=destPos
	end
	_G.ElysiumTPLiftInfo=string.format("lift=%.1f cruise=%.1f descend=%s",liftY-from.Y,start.Y,tostring(descend))
	return route
end
function ElysiumTPOverRoute(character,root,destPos)
	if _G.ElysiumTPProfileRoute~=false then
		local ok,route=pcall(ElysiumTPProfileRoute,character,root,destPos)
		if ok and route then return route end
		_G.ElysiumTPProfileError=not ok and tostring(route)or nil
	end
	return ElysiumTPOverRouteFlat(character,root,destPos)
end
function ElysiumTPProfileRoute(character,root,destPos)
	_G.ElysiumTPProfileFail=nil
	if not character or not root or type(ElysiumGoToCastParams)~="function"then return nil end
	local cast=ElysiumGoToCastParams(character)
	local from=root.Position
	local flat=Vector3.new(destPos.X-from.X,0,destPos.Z-from.Z)
	local length=flat.Magnitude
	if length<12 then _G.ElysiumTPProfileFail="too_short";return nil end
	local humanoid=character:FindFirstChildOfClass("Humanoid")
	local feet=(humanoid and humanoid.HipHeight+root.Size.Y*.5)or 3
	local maxRise=tonumber(_G.ElysiumTPOverMaxRise)or 90
	local clearance=tonumber(_G.ElysiumTPOverClearance)or 8
	local floorClear=math.max(.5,tonumber(_G.ElysiumTPOverFloor)or 3)
	local cruise=math.clamp(tonumber(_G.TPVelocity)or 200,50,750)
	local riseSpeed=math.clamp(tonumber(_G.ElysiumClimb)or 160,10,250)
	local slope=math.max(.15,tonumber(_G.ElysiumTPOverSlope)or math.clamp(riseSpeed/cruise,.35,1))
	local climbRatio=cruise/riseSpeed
	local healCost=tonumber(_G.ElysiumTPHealCost)or 12
	local endSlack=math.max(0,tonumber(_G.ElysiumTPOverEndSlack)or 5)
	local okHead,headroom=pcall(ElysiumCharacterHeadroom,character,root)
	headroom=(okHead and tonumber(headroom))or 2.5
	local low,high=math.min(from.Y,destPos.Y),math.max(from.Y,destPos.Y)
	local probeY=high+maxRise+clearance
	local underRoof=_G.ElysiumTPProfileUnderRoof~=false
	local box=Vector3.new(2.2,2,2.2)
	local function blockHit(a,b)
		local move=b-a
		if move.Magnitude<.05 then return nil end
		return workspace:Blockcast(CFrame.new(a),box,move,cast)
	end
	local function topAt(x,z,fromY)
		local hit=workspace:Raycast(Vector3.new(x,fromY,z),Vector3.new(0,low-fromY-20,0),cast)
		return hit and(hit.Position.Y+feet)or nil
	end
	local straightSpans
	local function plan(vias)
		local corners={from}
		for _,v in ipairs(vias)do corners[#corners+1]=v end
		corners[#corners+1]=destPos
		local legs,total={},0
		for k=1,#corners-1 do
			local a,b=corners[k],corners[k+1]
			legs[k]=Vector3.new(b.X-a.X,0,b.Z-a.Z).Magnitude
			total=total+legs[k]
		end
		if total<1 then return nil,"zero"end
		local stepLen=total>150 and 4 or 3
		local S,along={},0
		for k=1,#corners-1 do
			local a,b,d=corners[k],corners[k+1],legs[k]
			local n=math.max(1,math.ceil(d/stepLen))
			local dir=d>.01 and Vector3.new(b.X-a.X,0,b.Z-a.Z)/d or Vector3.new(1,0,0)
			for i=(k==1 and 0 or 1),n do
				local t=i/n
				S[#S+1]={x=a.X+(b.X-a.X)*t,z=a.Z+(b.Z-a.Z)*t,s=along+d*t,
					dir=dir,corner=i==n and k<#corners-1}
			end
			along=along+d
		end
		local count=#S
		local ground,cap={},{}
		for i,smp in ipairs(S)do
			local lineY=from.Y+(destPos.Y-from.Y)*(smp.s/total)
			local side=Vector3.new(-smp.dir.Z,0,smp.dir.X)*1.6
			local roof
			if underRoof then
				local up=workspace:Raycast(Vector3.new(smp.x,lineY,smp.z),Vector3.new(0,maxRise+clearance,0),cast)
				if up then roof=up.Position.Y end
			end
			local top,under=low,low
			for k=-1,1 do
				local x,z=smp.x+side.X*k,smp.z+side.Z*k
				local t=topAt(x,z,probeY)
				if t then top=math.max(top,t)end
				if roof then
					local u=topAt(x,z,roof-.3)
					if u then under=math.max(under,u)end
				end
			end
			local roomTop=roof and(roof-headroom-.8)
			if roomTop and roomTop-under>=1.5 then
				ground[i],cap[i]=under,roomTop
			else
				ground[i]=top
			end
			if total-smp.s<=endSlack then
				ground[i]=math.min(ground[i],destPos.Y)
				if cap[i]then cap[i]=math.max(cap[i],destPos.Y)end
			end
			if smp.s<=1.5 then ground[i]=math.min(ground[i],from.Y)end
		end
		local function noteSpans()
			if#vias>0 then return end
			local spans,open={},nil
			for i=1,count do
				local lineY=from.Y+(destPos.Y-from.Y)*(S[i].s/total)
				local raised=ground[i]>lineY+3 or(cap[i]~=nil and cap[i]<lineY)
				if raised and not open then
					open={a=S[i].s,b=S[i].s,top=ground[i]}
				elseif raised then
					open.b,open.top=S[i].s,math.max(open.top,ground[i])
				end
				if open and(not raised or i==count)then
					spans[#spans+1]=open
					open=nil
				end
			end
			straightSpans=spans
		end
		noteSpans()
		local pts,h,peak,route,heals={},{},-math.huge,nil,0
		local attempts=math.max(1,tonumber(_G.ElysiumTPProfileHeals)or 10)
		for attempt=1,attempts do
			for i=1,count do
				local lineY=from.Y+(destPos.Y-from.Y)*(S[i].s/total)
				if ground[i]>lineY+3 then
					local nearEnd=math.min(S[i].s,total-S[i].s)
					h[i]=ground[i]+math.clamp(floorClear+nearEnd*slope,floorClear,clearance)
				else
					h[i]=ground[i]+floorClear
				end
			end
			for i=2,count do h[i]=math.max(h[i],h[i-1]-slope*(S[i].s-S[i-1].s))end
			for i=count-1,1,-1 do h[i]=math.max(h[i],h[i+1]-slope*(S[i+1].s-S[i].s))end
			peak=-math.huge
			for i=1,count do
				if cap[i]then h[i]=math.max(ground[i]+.5,math.min(h[i],cap[i]))end
				peak=math.max(peak,h[i])
				pts[i]=Vector3.new(S[i].x,h[i],S[i].z)
			end
			if peak-high>maxRise then noteSpans();return nil,string.format("too_high %.0f",peak-high)end
			route={}
			if h[1]>from.Y+.5 then route[1]=pts[1]end
			local function edge(i)
				local j=i+1
				if j>count then return end
				if cap[i]and not cap[j]and h[j]>h[i]+.5 then
					route[#route+1]=Vector3.new(pts[j].X,h[i],pts[j].Z)
				elseif not cap[i]and cap[j]and h[i]>h[j]+.5 then
					route[#route+1]=Vector3.new(pts[i].X,h[j],pts[i].Z)
				end
			end
			edge(1)
			for i=2,count-1 do
				local a=(h[i]-h[i-1])/math.max(.01,S[i].s-S[i-1].s)
				local b=(h[i+1]-h[i])/math.max(.01,S[i+1].s-S[i].s)
				local boundary=(cap[i]~=nil)~=(cap[i+1]~=nil)or(cap[i]~=nil)~=(cap[i-1]~=nil)
				if S[i].corner or math.abs(a-b)>.1 or boundary then route[#route+1]=pts[i]end
				edge(i)
			end
			if pts[count].Y>destPos.Y+.5 then route[#route+1]=pts[count]end
			route[#route+1]=destPos
			local blocked,prev=nil,from
			for idx,p in ipairs(route)do
				local hit=blockHit(prev,p)
				if hit and(hit.Position-destPos).Magnitude>endSlack+1.5
					and not(idx==1 and(hit.Position-from).Magnitude<=2.5)then
					blocked=hit
					break
				end
				prev=p
			end
			if not blocked then break end
			if attempt==attempts then noteSpans();return nil,"blocked "..tostring(blocked.Instance)end
			heals=heals+1
			local hp=blocked.Position-Vector3.new(blocked.Normal.X,0,blocked.Normal.Z)*.3
			local k,bestD=1,math.huge
			for i=1,count do
				local d=(S[i].x-hp.X)^2+(S[i].z-hp.Z)^2
				if d<bestD then k,bestD=i,d end
			end
			if blocked.Normal.Y<-.5 and cap[k]then
				for i=math.max(1,k-1),math.min(count,k+1)do
					if cap[i]then cap[i]=math.min(cap[i],hp.Y-headroom-1)end
				end
			else
				local t=math.max(topAt(hp.X,hp.Z,probeY)or-math.huge,blocked.Position.Y+feet)
				for i=math.max(1,k-1),math.min(count,k+1)do
					ground[i]=math.max(ground[i],t+.5)
					if cap[i]and cap[i]<ground[i]+.5 then cap[i]=nil end
				end
			end
			noteSpans()
		end
		local len,timeCost,prev=0,0,from
		for _,p in ipairs(route)do
			local d=(p-prev).Magnitude
			len=len+d
			timeCost=timeCost+math.max(d,math.max(0,p.Y-prev.Y)*climbRatio)
			prev=p
		end
		timeCost=timeCost+heals*healCost
		local roofed=0
		for i=1,count do if cap[i]then roofed=roofed+1 end end
		return route,timeCost,string.format("peak=%.1f rise=%.1f len=%.0f pts=%d underRoof=%d/%d heal=%d",
			peak,peak-from.Y,len,#route,roofed,count,heals),peak-high
	end
	local best,bestCost,bestInfo,bestRise,tried,fails=nil,math.huge,nil,nil,0,{}
	local function try(vias,label)
		tried=tried+1
		local ok,route,cost,info,rise=pcall(plan,vias)
		if not ok then
			fails[#fails+1]=label..": "..tostring(route)
		elseif not route then
			fails[#fails+1]=label..": "..tostring(cost)
		else
			if cost<bestCost then
				best,bestCost,bestInfo,bestRise=route,cost,label.." "..info,rise
			end
			return route,cost,rise
		end
	end
	try({},"straight")
	local detourAbove=tonumber(_G.ElysiumTPDetourAbove)or 12
	if _G.ElysiumTPProfileDetours~=false and(not best or bestRise>detourAbove)then
		local dir=flat.Unit
		local perp=Vector3.new(-dir.Z,0,dir.X)
		local maxOff=tonumber(_G.ElysiumTPDetourMax)or 100
		local spans=straightSpans or{}
		if#spans>0 then
			local a,b=math.huge,-math.huge
			for _,sp in ipairs(spans)do
				a,b=math.min(a,sp.a),math.max(b,sp.b)
			end
			local margin=tonumber(_G.ElysiumTPDetourMargin)or 5
			local s0=math.clamp(a-margin,1,length-1)
			local s1=math.clamp(b+margin,1,length-1)
			for _,s in ipairs({1,-1})do
				for _,off in ipairs({5,9,14,20,28,38,50,65,80})do
					if off>maxOff then break end
					local label=string.format("hug%+.0f",off*s)
					local got,_,rise
					if s1-s0<10 then
						got,_,rise=try({from+dir*((s0+s1)*.5)+perp*(off*s)},label)
					else
						got,_,rise=try({from+dir*s0+perp*(off*s),from+dir*s1+perp*(off*s)},label)
					end
					if got and(rise or 0)<=detourAbove then
						break
					end
				end
			end
		end
		local mid=from+flat*.5
		local last=-1
		for _,f in ipairs({.18,.32,.5})do
			local off=math.min(length*f,maxOff)
			if off>=8 and off-last>5 then
				last=off
				for _,s in ipairs({1,-1})do
					try({mid+perp*(off*s)},string.format("side%+.0f",off*s))
				end
			end
		end
	end
	_G.ElysiumTPProfileFail=#fails>0 and table.concat(fails,"; ")or nil
	if not best then return nil end
	_G.ElysiumTPLiftInfo=string.format("profile %s cost=%.0f tried=%d",bestInfo,bestCost,tried)
	return best
end
function ElysiumTPOverRouteFlat(character,root,destPos)
	if not character or not root or type(ElysiumGoToCastParams)~="function"then return nil end
	local cast=ElysiumGoToCastParams(character)
	local from=root.Position
	local flat=Vector3.new(destPos.X-from.X,0,destPos.Z-from.Z)
	local length=flat.Magnitude
	if length<12 then return nil end
	local dir=flat.Unit
	local humanoid=character:FindFirstChildOfClass("Humanoid")
	local feet=(humanoid and humanoid.HipHeight+root.Size.Y*.5)or 3
	local maxRise=tonumber(_G.ElysiumTPOverMaxRise)or 90
	local low,high=math.min(from.Y,destPos.Y),math.max(from.Y,destPos.Y)
	local probeY=high+maxRise
	local top=high
	local side=Vector3.new(-dir.Z,0,dir.X)*1.5
	local count=math.max(2,math.ceil(length/4))
	for i=0,count do
		local p=from+flat*(i/count)
		for k=-1,1 do
			local origin=Vector3.new(p.X+side.X*k,probeY,p.Z+side.Z*k)
			local hit=workspace:Raycast(origin,Vector3.new(0,low-probeY-20,0),cast)
			if hit then top=math.max(top,hit.Position.Y+feet)end
		end
	end
	local cruiseY=top+(tonumber(_G.ElysiumTPOverFlatClearance)or 4)
	if cruiseY-high>maxRise then return nil end
	local box=Vector3.new(2.2,2,2.2)
	local function clear(a,b)
		local move=b-a
		if move.Magnitude<.05 then return true end
		return workspace:Blockcast(CFrame.new(a),box,move,cast)==nil
	end
	local up=Vector3.new(from.X,cruiseY,from.Z)
	if not clear(from,up)then return nil end
	for back=0,24,4 do
		local q=destPos-dir*back
		local over=Vector3.new(q.X,cruiseY,q.Z)
		if clear(up,over)and clear(over,q)and(back==0 or clear(q,destPos))then
			_G.ElysiumTPLiftInfo=string.format("over cruise=%.1f rise=%.1f back=%d",cruiseY,cruiseY-from.Y,back)
			if back==0 then return{up,over,destPos}end
			return{up,over,q,destPos}
		end
	end
	return nil
end
function ElysiumTPBestRoute(character,root,destPos,facingDir,preferCrest)
	if _G.ElysiumTPUseProfile~=false then
		local ok,route=pcall(ElysiumTPOverRoute,character,root,destPos)
		if ok and type(route)=="table"and#route>0 then
			_G.ElysiumTPRouteKind="profile"
			return route,"profile"
		end
		if not ok then _G.ElysiumTPProfileError=tostring(route)end
	end
	_G.ElysiumTPRouteKind="lift"
	return ElysiumTPLiftRoute(character,root,destPos,facingDir,preferCrest),"lift"
end
function equipTool(name)
	local char=LP.Character
	if not char or char:FindFirstChild(name)then
		return char~=nil
	end
	local bp=LP:FindFirstChild("Backpack")
	if not bp then
		return false
	end
	local tool=bp:FindFirstChild(name)
	if tool and tool:IsA("Tool")then
		tool.Parent=char
		return true
	end
	return false
end
function unequipAll()
	local char,bp=LP.Character,LP.Backpack
	if not char or not bp then
		return
	end
	for _,t in pairs(char:GetChildren())do
		if t:IsA("Tool")then
			t.Parent=bp
		end
	end
end
local _elysiumInstantResetBusy=false
function _G.ElysiumInstantReset()
	if _elysiumInstantResetBusy then
		return false
	end
	local oldCharacter=LP.Character
	local hum=oldCharacter and oldCharacter:FindFirstChildOfClass("Humanoid")
	if not oldCharacter or not hum then
		return false
	end
	if type(_G.ElysiumInvisStop)=="function"then
		pcall(_G.ElysiumInvisStop)
	end
	_elysiumInstantResetBusy=true
	local antiDieWasDisabled=_G.AntiDieDisabled==true
	_G.Elysium_IsResetting=true
	if _G.ElysiumPrepareMovementReset then
		pcall(_G.ElysiumPrepareMovementReset)
	end
	_G.AntiDieDisabled=true
	_G.ElysiumTPStop=true
	isTeleporting=false
	task.spawn(function()
		RunService.Heartbeat:Wait()
		pcall(function()
			hum:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
		end)
		pcall(function()
			hum.Health=0
		end)
		pcall(function()
			hum:ChangeState(Enum.HumanoidStateType.Dead)
		end)
		pcall(function()
			oldCharacter:BreakJoints()
		end)
		local deadline=os.clock()+10
		repeat
			task.wait(.05)
		until LP.Character~=oldCharacter or os.clock()>=deadline
		if LP.Character~=oldCharacter then
			local newHum=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
			if not newHum and LP.Character then
				pcall(function()
					newHum=LP.Character:WaitForChild("Humanoid",5)
				end)
			end
			task.wait(.1)
		end
		_G.AntiDieDisabled=antiDieWasDisabled
		_G.Elysium_IsResetting=false
		_G.ElysiumTPStop=false
		_elysiumInstantResetBusy=false
	end)
	return true
end
function ElysiumCloneCarpetInHand(char)
	if not char or type(ElysiumFindRouteFlightTool)~="function"then return nil end
	local carpet=ElysiumFindRouteFlightTool(char)
	if carpet and carpet.Parent==char then return carpet end
	for _,name in ipairs(CARPET_NAMES or{})do
		local tool=char:FindFirstChild(name)
		if tool and tool:IsA("Tool")then return tool end
	end
	return nil
end
function ElysiumHoldCloner(char,hum,cloner)
	if not char or not hum or not cloner then return nil end
	local diag=_G.ElysiumCloneHoldDiag
	if type(diag)~="table"or(os.clock()-(diag.at or 0))>5 then
		diag={at=os.clock()}
		_G.ElysiumCloneHoldDiag=diag
	end
	if cloner.Parent==char then
		local mode=ElysiumCloneCarpetInHand(char)and"dual"or"swap"
		_G.ElysiumCloneHoldMode=mode
		diag.mode=diag.mode or mode
		return mode
	end
	local carpet=_G.ElysiumCloneKeepCarpet==true and _G.ElysiumCloneKeepCarpetBad~=true
		and ElysiumCloneCarpetInHand(char)
	if carpet then
		pcall(function()cloner.Parent=char end)
		if cloner.Parent==char then
			_G.ElysiumCloneHoldMode="dual"
			diag.mode,diag.carpet="dual",carpet.Name
			return"dual"
		end
	end
	_G.ElysiumCloneHoldMode="swap"
	diag.mode="swap"
	diag.badReason=_G.ElysiumCloneKeepCarpetBadReason
	pcall(hum.EquipTool,hum,cloner)
	return"swap"
end
do
	local VIM=ElysiumService("VirtualInputManager")
	local function clickCloneButton(obj)
		if not obj or not obj:IsA("GuiButton")or not obj.Visible or not obj.Active then return false end
		local ancestor=obj.Parent
		while ancestor and ancestor~=game do
			if ancestor:IsA("GuiObject")and not ancestor.Visible then return false end
			if ancestor:IsA("ScreenGui")and not ancestor.Enabled then return false end
			ancestor=ancestor.Parent
		end
		_G.ElysiumCloneClickDiag={button=obj:GetFullName(),events={}}
		if type(getconnections)=="function"then
			for _,eventName in ipairs({"MouseButton1Up","MouseButton1Click","Activated"})do
				local signal=obj[eventName]
				local ok,connections=pcall(getconnections,signal)
				local listeners={}
				if ok and type(connections)=="table"then
					for _,connection in ipairs(connections)do
						if connection.Enabled~=false then listeners[#listeners+1]=connection end
					end
				end
				_G.ElysiumCloneClickDiag.events[eventName]=#listeners
				if#listeners>0 then
					_G.ElysiumCloneClickDiag.method=eventName
					local dispatched,err=pcall(function()
						if type(firesignal)=="function"then
							firesignal(signal)
						else
							for _,connection in ipairs(listeners)do
								if type(connection.Fire)=="function"then connection:Fire()
								elseif type(connection.Function)=="function"then connection.Function()
								else error("Button listener cannot be dispatched")end
							end
						end
					end)
					_G.ElysiumCloneClickError=not dispatched and tostring(err)or nil
					return dispatched
				end
			end
		end
		_G.ElysiumCloneClickDiag.method="mouse"
		RunService.Heartbeat:Wait()
		if _G.ElysiumTPStop or not obj.Parent or not obj.Visible or not obj.Active then return false end
		local size=obj.AbsoluteSize
		if size.X<=0 or size.Y<=0 then return false end
		local p=obj.AbsolutePosition+size/2
		local pressed,pressError=pcall(function()
			VIM:SendMouseMoveEvent(p.X,p.Y,game)
			VIM:SendMouseButtonEvent(p.X,p.Y,0,true,game,1)
		end)
		RunService.Heartbeat:Wait()
		local released,releaseError=pcall(function()
			VIM:SendMouseButtonEvent(p.X,p.Y,0,false,game,1)
		end)
		_G.ElysiumCloneClickError=not pressed and tostring(pressError)
			or not released and tostring(releaseError)or nil
		return pressed and released
	end
	_G.ElysiumDonorInstantClone=function()
		_G.ElysiumCloneRequest=nil
		_G.ElysiumCloneConfirmReason=nil
		local player=LP
		local char=player and player.Character
		local hum=char and char:FindFirstChildOfClass("Humanoid")
		if not hum then
			return false
		end
		local backpack=player:FindFirstChild("Backpack")
		local cloner=(backpack and backpack:FindFirstChild("Quantum Cloner"))or char:FindFirstChild("Quantum Cloner")
		if not cloner then
			return false
		end
		local dual=ElysiumHoldCloner(char,hum,cloner)=="dual"
		do
			local equipDeadline=os.clock()+1
			while cloner.Parent~=char and os.clock()<equipDeadline do
				RunService.Heartbeat:Wait()
			end
		end
		local holdDiag=_G.ElysiumCloneHoldDiag
		local function fallBackToSwap(reason)
			if not dual then return false end
			dual=false
			_G.ElysiumCloneKeepCarpetBad=true
			_G.ElysiumCloneKeepCarpetBadReason=reason
			_G.ElysiumCloneHoldMode="swap"
			if type(holdDiag)=="table"then holdDiag.fallback=reason end
			pcall(hum.UnequipTools,hum)
			RunService.Heartbeat:Wait()
			pcall(hum.EquipTool,hum,cloner)
			local equipDeadline=os.clock()+1
			while cloner.Parent~=char and os.clock()<equipDeadline do
				RunService.Heartbeat:Wait()
			end
			return cloner.Parent==char and player.Character==char
		end
		if cloner.Parent~=char and not fallBackToSwap("cloner_not_held")then
			_G.ElysiumTPMovementStatus="clone_equip_failed"
			return false
		end
		if(tonumber(cloner:GetAttribute("CooldownTime"))or 0)>0 then
			_G.ElysiumTPMovementStatus="clone_cooldown"
			return false
		end
		local cloneName=tostring(player.UserId).."_Clone"
		local oldClone=workspace:FindFirstChild(cloneName)
		local oldPosition=oldClone and oldClone:IsA("PVInstance")and oldClone:GetPivot().Position
		local function placeClone()
			cloner:Activate()
			local placed=false
			local placeDeadline=os.clock()+math.clamp(player:GetNetworkPing()*3+.2,.5,2)
			repeat
				RunService.Heartbeat:Wait()
				local clone=workspace:FindFirstChild(cloneName)
				local position=clone and clone:IsA("PVInstance")and clone:GetPivot().Position
				placed=position~=nil and(clone~=oldClone or not oldPosition or(position-oldPosition).Magnitude>.5)
				if _G.ElysiumTPStop or player.Character~=char then return nil end
			until placed or os.clock()>=placeDeadline
			return placed
		end
		local placed=placeClone()
		if placed==nil then return false end
		if not placed and fallBackToSwap("clone_not_placed")
			and(tonumber(cloner:GetAttribute("CooldownTime"))or 0)<=0 then
			placed=placeClone()
			if placed==nil then return false end
		end
		if not placed then
			_G.ElysiumTPMovementStatus="clone_not_placed"
			return false
		end
		if type(holdDiag)=="table"then
			local carpet=ElysiumCloneCarpetInHand(char)
			holdDiag.carpetHeldAtPlace=carpet~=nil and carpet.Parent==char
		end
		local cloneSerial=(_G.ElysiumCloneRunSerial or 0)+1
		_G.ElysiumCloneRunSerial=cloneSerial
		_G.isCloning=true
		local function resolveBrainPos()
			local brainPos=nil
			local pet=_G.ElysiumStealTarget
			if type(pet)=="table"then
				if typeof(pet.position)=="Vector3"then
					brainPos=pet.position
				elseif typeof(pet.pos)=="Vector3"then
					brainPos=pet.pos
				end
				if pet.model and pet.model.Parent then
					local pp=pet.model.PrimaryPart
						or pet.model:FindFirstChild("HumanoidRootPart")
						or pet.model:FindFirstChildWhichIsA("BasePart")
					if pp then
						brainPos=pp.Position
					end
				end
			end
			if not brainPos and typeof(_G.TrxStealTargetPos)=="Vector3"then
				brainPos=_G.TrxStealTargetPos
			end
			return brainPos
		end
		local playerGui=player:FindFirstChild("PlayerGui")
		local toolsFrames=playerGui and playerGui:FindFirstChild("ToolsFrames")
		local clonerFrame=toolsFrames and toolsFrames:FindFirstChild("QuantumCloner")
		local teleport
		local function buttonShown(obj)
			local at=obj.Parent
			while at and at~=game do
				if at:IsA("GuiObject")and not at.Visible then return false end
				if at:IsA("LayerCollector")and not at.Enabled then return false end
				at=at.Parent
			end
			return true
		end
		local function waitTeleportButton(seconds)
			local readyUntil=os.clock()+seconds
			repeat
				if
					_G.ElysiumTPStop
					or _G.ElysiumAutoBuyTPBlocked
					or _G.Elysium_IsResetting
					or player.Character~=char
					or hum.Health<=0
				then
					return nil
				end
				playerGui=player:FindFirstChild("PlayerGui")
				toolsFrames=playerGui and playerGui:FindFirstChild("ToolsFrames")
				clonerFrame=toolsFrames and toolsFrames:FindFirstChild("QuantumCloner")
				teleport=clonerFrame and clonerFrame:FindFirstChild("TeleportToClone",true)
				if workspace:FindFirstChild(cloneName)and teleport and teleport:IsA("GuiButton")
					and teleport.Visible and teleport.Active and buttonShown(teleport)then return true end
				teleport=nil
				RunService.Heartbeat:Wait()
			until os.clock()>=readyUntil
			return false
		end
		local ready=waitTeleportButton(dual and 1 or 2)
		if ready==false and dual and workspace:FindFirstChild(cloneName)then
			if fallBackToSwap("button_not_ready")then
				ready=waitTeleportButton(1.5)
			end
		end
		if ready==nil then
			_G.isCloning=false
			return false
		end
		if not workspace:FindFirstChild(cloneName)or not teleport then
			_G.ElysiumTPMovementStatus="clone_button_not_ready"
			_G.isCloning=false
			return false
		end
		local requestRoot=char:FindFirstChild("HumanoidRootPart")
		if not requestRoot then
			_G.isCloning=false
			return false
		end
		_G.ElysiumCloneRequest={
			character=char,
			humanoid=hum,
			root=requestRoot,
			position=requestRoot.Position,
			at=os.clock(),
			button=teleport,
		}
		local clicked=clickCloneButton(teleport)
		if not clicked then
			if waitTeleportButton(.5)and teleport then
				_G.ElysiumCloneRequest.button=teleport
				clicked=clickCloneButton(teleport)
			end
		end
		if not clicked then
			_G.isCloning=false
			_G.ElysiumTPMovementStatus="clone_button_click_failed"
			return false
		end
		_G.ElysiumTPMovementStatus="clone_swap_requested"
		task.spawn(function()
			local landPos=nil
			local t0=os.clock()
			while os.clock()-t0<1 do
				RunService.Heartbeat:Wait()
				local c=LP.Character
				local h=c and c:FindFirstChild("HumanoidRootPart")
				if h then
					landPos=h.Position
					RunService.Heartbeat:Wait()
					if LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")then
						landPos=LP.Character.HumanoidRootPart.Position
					end
					break
				end
			end
			task.wait(.15)
			local c=LP.Character
			local h=c and c:FindFirstChild("HumanoidRootPart")
			if h then
				landPos=h.Position
			end
			local brainPos=resolveBrainPos()
			if landPos and brainPos and type(_G.TrxVizClonePath)=="function"then
				pcall(_G.TrxVizClonePath,landPos,brainPos)
			end
		end)
		task.delay(3,function()
			if _G.ElysiumCloneRunSerial==cloneSerial then
				_G.isCloning=false
			end
		end)
		return true
	end
end
function doClone()
	if _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then
		return false
	end
	local ok,result=pcall(_G.ElysiumDonorInstantClone)
	if not ok or result~=true then
		_G.isCloning=false
		return false
	end
	return true
end
function _makeOneWay(plat)
	if not plat then
		return
	end
	local rsConn
	local lastY=nil
	rsConn=RunService.Stepped:Connect(function()
		if not plat or not plat.Parent then
			if rsConn then
				rsConn:Disconnect()
			end
			return
		end
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if hrp then
			local currentY=hrp.Position.Y
			if not lastY then
				lastY=currentY
			end
			local deltaY=currentY-lastY
			local isMovingUp=(hrp.AssemblyLinearVelocity.Y>1)or(deltaY>.01 and deltaY<5)
			if isMovingUp then
				plat.CanCollide=false
			else
				plat.CanCollide=(currentY>plat.Position.Y+.1)
			end
			lastY=currentY
		end
	end)
end
function carpetEngageFast()
	local char=LP.Character
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if not char or not hum then
		return nil
	end
	if not char:FindFirstChild("Grapple Hook")then
		local g=findTool("Grapple Hook")
		if g then
			pcall(function()
				hum:EquipTool(g)
			end)
		end
	end
	local _t=os.clock()
	while
		not(LP.Character and LP.Character:FindFirstChild("Grapple Hook"))
		and os.clock()-_t<(tonumber(_G.ElysiumGoGrappleWait)or .35)
	do
		local c=LP.Character
		local h=c and c:FindFirstChildOfClass("Humanoid")
		local g=findTool("Grapple Hook")
		if g and h then
			pcall(function()
				h:EquipTool(g)
			end)
		end
		RunService.Heartbeat:Wait()
	end
	if LP.Character and LP.Character:FindFirstChild("Grapple Hook")then
		_fireGrapple()
	end
	local h2=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
	if h2 then
		pcall(function()
			h2:UnequipTools()
		end)
	end
	RunService.Heartbeat:Wait()
	local cn
	local _t2=os.clock()
	repeat
		cn=equipCarpet()
		local c=LP.Character
		if cn and c and c:FindFirstChild(cn)then
			break
		end
		RunService.Heartbeat:Wait()
	until os.clock()-_t2>(tonumber(_G.ElysiumGoCarpetWait)or 2)
	return cn
end
_G.ElysiumCarpetEngageFast=carpetEngageFast
local function elysiumGoTargetHeight(h,slot,under)
	if _G.ElysiumGoStyle~="smooth"then
		if h>23.15 then return 21,true end
		if h>=11 then
			return _G.ElysiumGoApproachF2==true and h-8 or 14.5,true
		end
		if h>=-6.9 and h<=8.9 then return-4,true end
		return h,false
	end
	slot=tonumber(slot)
	if(slot and slot>=21)or(not slot and h>23.15)then
		return h-under-.5,true
	end
	if(slot and slot>=11)or(not slot and h>=11 and h<=23.15)then
		return h-under+3.5,true
	end
	if(slot and slot>=1)or(not slot and h>=-6.9 and h<=8.9)then
		return tonumber(_G.trxFloor1Y)or-4,_G.trxFloor1Platform~=false
	end
	return h-under,true
end
local _goBusy,_goBrGen=false,0
function _elysiumGoToBrainrotImpl(petPos,slotOrOpts)
	if not petPos or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then
		return false
	end
	local slot=slotOrOpts
	local _noJump=false
	local _speedOverride=nil
	local _targetPlot=nil
	if type(slotOrOpts)=="table"then
		slot=slotOrOpts.slot
		_noJump=slotOrOpts.noJump==true
		_speedOverride=tonumber(slotOrOpts.speed)
		_targetPlot=slotOrOpts.plot and tostring(slotOrOpts.plot)or nil
	end
	if _goBusy then
		return
	end
	_goBusy=true
	_goBrGen=_goBrGen+1
	local myGen=_goBrGen
	local function dead()
		return myGen~=_goBrGen or _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting
	end
	if _G.ElysiumSourceStealRuntime then
		_G.ElysiumSourceStealRuntime.TriggerSafePollBoost()
	end
	local char,hrp,hum
	local _t0=os.clock()
	repeat
		char=LP.Character
		hrp=char and char:FindFirstChild("HumanoidRootPart")
		hum=char and char:FindFirstChildOfClass("Humanoid")
		if hrp and hum then
			break
		end
		if dead()then
			_goBusy=false
			return
		end
		RunService.Heartbeat:Wait()
	until os.clock()-_t0>3
	if not hrp or not hum then
		_goBusy=false
		return
	end
	pcall(function()
		hrp.Anchored=false
	end)
	local _equipped=false
	do
		local _e0=os.clock()
		local _carpetWait=_noJump and .04 or(tonumber(_G.trxGoCarpetWait)or 1.5)
		repeat
			if dead()then
				_goBusy=false
				return
			end
			char=LP.Character
			for _,_cn in ipairs(CARPET_NAMES)do
				if char and char:FindFirstChild(_cn)then
					_equipped=true
					break
				end
			end
			if _equipped then
				break
			end
			equipCarpet()
			RunService.Heartbeat:Wait()
		until _equipped or os.clock()-_e0>_carpetWait
		if _equipped and not _noJump then
			task.wait(tonumber(_G.trxGoCarpetSettle)or .03)
		end
	end
	char=LP.Character
	hrp=char and char:FindFirstChild("HumanoidRootPart")
	hum=char and char:FindFirstChildOfClass("Humanoid")
	if not hrp then
		_goBusy=false
		return
	end
	hrp.Anchored=false
	local _plotRad=(petPos.Y<=8.9)and 26 or 25
	if not _noJump then
		local _t0b=os.clock()
		repeat
			if dead()then
				break
			end
			local p=hrp.Position
			local inRad=false
			local plotsFolder=workspace:FindFirstChild("Plots")
			if plotsFolder then
				for _,plot in ipairs(plotsFolder:GetChildren())do
					local okp,pp=true,(function()
						return plot:GetPivot().Position
					end)()
					if okp and pp and math.abs(p.X-pp.X)<_plotRad and math.abs(p.Z-pp.Z)<_plotRad then
						inRad=true
					end
					if inRad then
						break
					end
				end
			end
			if inRad then
				break
			end
			RunService.Heartbeat:Wait()
		until os.clock()-_t0b>(_noJump and .05 or(tonumber(_G.trxGoPlotWait)or .4))
	end
	local h=petPos.Y
	hrp.AssemblyLinearVelocity=Vector3.zero
	hrp.AssemblyAngularVelocity=Vector3.zero
	local _wentUnder=false
	local _slot=tonumber(slot)
	local _under=tonumber(_G.trxUnderOffset)or 6
	local targetY
	targetY,_wentUnder=elysiumGoTargetHeight(h,_slot,_under)
	local _to=Vector3.new(petPos.X,targetY,petPos.Z)
	if false then
		local _swapChar=LP.Character
		local _swapRoot=_swapChar and _swapChar:FindFirstChild("HumanoidRootPart")
		local _swapPos=_swapRoot and _swapRoot.Position
		local _swapDeadline=os.clock()+(_noJump and .12 or .75)
		local _swapSeen=false
		while not dead()and os.clock()<_swapDeadline do
			local _nowChar=LP.Character
			local _nowRoot=_nowChar and _nowChar:FindFirstChild("HumanoidRootPart")
			if _nowChar~=_swapChar or(_nowRoot and _nowRoot~=_swapRoot)then
				_swapSeen=true
				break
			end
			if _swapPos and _nowRoot and _nowRoot.Parent and(_nowRoot.Position-_swapPos).Magnitude>=.75 then
				_swapSeen=true
				break
			end
			RunService.Heartbeat:Wait()
		end
		if dead()then
			_goBusy=false
			return
		end
	end
	local _pending=_G.__TrxPendingInstaGoPet
	if _pending and _targetPlot and tostring(_pending.plot or"")==_targetPlot then
		local _pendingPos=_pending.position
		if typeof(_pendingPos)=="Vector3"then
			local _ph=_pendingPos.Y
			local _ps=tonumber(_pending.slot)
			local _py=elysiumGoTargetHeight(_ph,_ps,_under)
			_to=Vector3.new(_pendingPos.X,_py,_pendingPos.Z)
		end
		_G.__TrxPendingInstaGoPet=nil
	end
	_G.ElysiumGoToDestination=_to
	if hrp and hrp.Parent and not dead()then
		local _snapCF=CFrame.new(_to)*(hrp.CFrame-hrp.CFrame.Position)
		local _instant=_G.ElysiumGoStyle~="smooth"
		if _instant then
			hrp.AssemblyLinearVelocity=Vector3.zero
			hrp.AssemblyAngularVelocity=Vector3.zero
			hrp.CFrame=_snapCF
			for _=1,(tonumber(_G.TrxBrainrotSnapFrames)or 2)do
				RunService.Heartbeat:Wait()
				if not(hrp and hrp.Parent)or dead()then
					break
				end
				if(hrp.Position-_to).Magnitude>(tonumber(_G.TrxBrainrotSnapTolerance)or 3)then
					hrp.CFrame=_snapCF
					hrp.AssemblyLinearVelocity=Vector3.zero
					hrp.AssemblyAngularVelocity=Vector3.zero
				end
			end
			if not dead()and not LP:GetAttribute("Stealing")then
				local _lagTolerance=tonumber(_G.TrxBrainrotLagbackTolerance)
					or tonumber(_G.TrxBrainrotSnapTolerance)
					or 3
				local _lagRetries=math.clamp(tonumber(_G.TrxBrainrotLagbackRetries)or 2,1,4)
				for _retry=1,_lagRetries do
					task.wait(.12)
					if dead()or LP:GetAttribute("Stealing")then
						break
					end
					local _liveChar=LP.Character
					local _liveRoot=_liveChar and _liveChar:FindFirstChild("HumanoidRootPart")
					if _liveRoot and _liveRoot.Parent then
						hrp=_liveRoot
						local _error=(hrp.Position-_to).Magnitude
						if _error<=_lagTolerance then
							break
						end
						hrp.AssemblyLinearVelocity=Vector3.zero
						hrp.AssemblyAngularVelocity=Vector3.zero
						hrp.CFrame=_snapCF
						for _confirm=1,2 do
							RunService.Heartbeat:Wait()
							if dead()or not(hrp and hrp.Parent)then
								break
							end
							if(hrp.Position-_to).Magnitude>_lagTolerance then
								hrp.AssemblyLinearVelocity=Vector3.zero
								hrp.AssemblyAngularVelocity=Vector3.zero
								hrp.CFrame=_snapCF
							end
						end
					else
						break
					end
				end
			end
		else
			local _s1=_speedOverride or tonumber(_G.ElysiumGoSpeed)or 150
			local _t1=tonumber(_G.trxGoGlideTime1)or .03
			local _s2=_speedOverride or tonumber(_G.ElysiumGoSpeed)or 400
			local _cap=
				math.max(tonumber(_G.trxGoGlideMax)or 2.5,(_to-hrp.Position).Magnitude/math.max(_s2,1)+2)
			local _g0=os.clock()
			local _goTick=_g0
			while os.clock()-_g0<_cap do
				if not(hrp and hrp.Parent)then
					break
				end
				if LP:GetAttribute("Stealing")or dead()then
					break
				end
				local liveHum=hrp.Parent:FindFirstChildOfClass("Humanoid")
				if LP.Character~=char or not liveHum or liveHum.Health<=0 then
					_G.ElysiumGoToDetail="character_changed_or_dead"
					_goBusy=false
					return false
				end
				local d=_to-hrp.Position
				_G.ElysiumGoToDistance=d.Magnitude
				_G.ElysiumGoToStatus="moving"
				_G.ElysiumTPProgressAt=os.clock()
				if d.Magnitude<=3 then
					break
				end
				equipCarpet()
				if not _noJump and _G.trxGoJump==true then
					local _gh=hrp.Parent and hrp.Parent:FindFirstChildOfClass("Humanoid")
					if _gh then
						_gh:ChangeState(Enum.HumanoidStateType.Jumping)
						_gh.Jump=true
					end
				end
				if _G.trxGoZeroEachFrame==true then
					hrp.AssemblyLinearVelocity=Vector3.zero
					hrp.AssemblyAngularVelocity=Vector3.zero
				end
				local _now=os.clock()
				local _dt=math.max(_now-_goTick,1/240)
				_goTick=_now
				local _speed=(((os.clock()-_g0)<_t1)and _s1 or _s2)
				local _v=d.Unit*math.min(_speed,d.Magnitude*.8/_dt)
				if _G.trxGoNoRise~=false and hrp.Position.Y>=_to.Y-.5 and _v.Y>0 then
					_v=Vector3.new(_v.X,0,_v.Z)
				end
				_setFlightVel(hrp,_v)
				RunService.Heartbeat:Wait()
			end
			hrp.AssemblyLinearVelocity=Vector3.zero
			hrp.AssemblyAngularVelocity=Vector3.zero
			if LP:GetAttribute("Stealing")==true then
				_G.ElysiumPickupMotionUntil=os.clock()+.4
				_goBusy=false
				return true
			end
			if not dead()and hrp and hrp.Parent and(hrp.Position-_to).Magnitude<=3 then
				hrp.CFrame=_snapCF
			elseif not dead()then
				_goBusy=false
				_G.ElysiumGoToDetail="stalled_before_target"
				if _G.ElysiumRecoverMovement then
					task.defer(_G.ElysiumRecoverMovement,"goto_stalled")
				end
				return false
			end
		end
	end
	if _wentUnder and _G.trxPlatform~=false and not dead()then
		local _platPos=(hrp and hrp.Parent and hrp.Position)or _to
		local _feetY=_platPos.Y-3
		local _sz=tonumber(_G.trxPlatSize)or 10
		local _old=workspace:FindFirstChild("TrxTempPlatform")
		if _old then
			_old:Destroy()
		end
		local _plat=Instance.new("Part")
		_plat.Name="TrxTempPlatform"
		_plat.Size=Vector3.new(_sz,1,_sz)
		_plat.Position=Vector3.new(_platPos.X,_feetY-(tonumber(_G.trxPlatDrop)or 1.5),_platPos.Z)
		_plat.Anchored=true
		_plat.CanCollide=false
		_makeOneWay(_plat)
		_plat.Transparency=1
		_plat.Material=Enum.Material.SmoothPlastic
		_plat.Parent=workspace
		task.spawn(function()
			local _s=tick()
			while tick()-_s<(tonumber(_G.trxPlatLife)or 2)do
				if LP:GetAttribute("Stealing")or _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then
					break
				end
				task.wait(.1)
			end
			if _plat and _plat.Parent then
				_plat:Destroy()
			end
		end)
	end
	_goBusy=false
	return not dead()
end
local function elysiumGoCollisionScope()
	local character=LP.Character
	local original,connections={},{}
	local closed=false
	local function suppress(part)
		if closed or not character or LP.Character~=character or not part:IsA("BasePart")then
			return
		end
		if original[part]==nil then
			original[part]={canCollide=part.CanCollide}
		end
		if part.CanCollide then
			part.CanCollide=false
		end
	end
	local function sweep()
		if closed or not character or LP.Character~=character then
			return
		end
		for _,part in ipairs(character:GetDescendants())do
			suppress(part)
		end
	end
	if character then
		sweep()
		connections[#connections+1]=character.DescendantAdded:Connect(suppress)
		connections[#connections+1]=RunService.Stepped:Connect(sweep)
	end
	return function()
		if closed then
			return
		end
		closed=true
		for _,connection in ipairs(connections)do
			connection:Disconnect()
		end
		for part,state in pairs(original)do
			pcall(function()
				part.CanCollide=state.canCollide
			end)
		end
		table.clear(original)
	end
end
do
	local ag,ah,ai,aj=math.clamp,math.max,math.min,math.abs
	local ak,al=task.spawn,task.wait
	local am,an,ap,ar=RunService,ElysiumService("HttpService"),workspace,LP
	local a2=Vector3.new(1,0,1)
	local runCharacter
	local ab={Feet=function()
		local c=LP.Character;local r=c and c:FindFirstChild("HumanoidRootPart");local h=c and c:FindFirstChildOfClass("Humanoid")
		return r and h and h.HipHeight+r.Size.Y*.5 or 2.7
	end}
	local ac={Held=function(c)
		for _,name in ipairs(CARPET_NAMES)do if c and c:FindFirstChild(name)then return true end end
		return false
	end,Equip=function()return equipCarpet()end}
	local function Trace(message)_G.ElysiumGoToDetail=message end
			local aD=10
			local aE=-4
			local aF=Vector3.new(4,.4,4)
			local aG=Color3.fromRGB(40,40,46)
			local aH=10
			local aI=20
			local aJ=.5
			local aK=.3
			local aL=8
			local aM,aN,aO=150,400,.03
			local aP,aQ=2.5,3
			local aS,aT=40,.1
			local aU=6
			local aV,aW=6,7.5
			local aY={Delay=.3}
			local function Root()
				local aZ=ar.Character
				if _G.ElysiumTPStop or(runCharacter and aZ~=runCharacter)then return nil end
				return aZ and(aZ:FindFirstChild("HumanoidRootPart"))
			end
			local function Ping()
				return ar:GetNetworkPing()
			end
			local function Still(aZ)
				aZ.AssemblyLinearVelocity=Vector3.zero
				aZ.AssemblyAngularVelocity=Vector3.zero
			end
			local function Name()
				return(string.gsub(string.lower(an:GenerateGUID(false)),"%-",""))
			end
			local function JumpIfClimbing(aZ,a_)
				if aj(a_-aZ.Position.Y)<=aD then
					return
				end
				local a0=aZ.Parent and aZ.Parent:FindFirstChildOfClass("Humanoid")
				if a0 then
					a0:ChangeState(Enum.HumanoidStateType.Jumping)
					a0.Jump=true
				end
			end
			function aY.InWalls(aZ,a_)
				local a0=aZ:FindFirstChild("StealHitbox")
				if not a0 or not a0:IsA("BasePart")then
					return false
				end
				local a2=a0.CFrame:PointToObjectSpace(a_)
				local a3=a0.Size*.5
				return aj(a2.X)<=a3.X and aj(a2.Y)<=a3.Y and aj(a2.Z)<=a3.Z
			end
			local function InRing(a5,a6)
				local a7=a5:GetPivot().Position
				return aj(a6.X-a7.X)<26 and aj(a6.Z-a7.Z)<26
			end
			local function AwaitSwap(a5,a6)
				local a7=os.clock()+a6
				repeat
					local a8=Root()
					if a8 and(aY.InWalls(a5,a8.Position)or InRing(a5,a8.Position))then
						return true
					end
					am.Heartbeat:Wait()
				until os.clock()>a7
				local a8=Root()
				return a8~=nil and InRing(a5,a8.Position)
			end
			local a5
			local padMonitor,padStep
			local function ClearPad()
				if padMonitor then padMonitor:Disconnect();padMonitor=nil end
				if padStep then padStep:Disconnect();padStep=nil end
				local old=a5;a5=nil
				if old then old.CanCollide=false;old:Destroy()end
			end
			_G.ElysiumClearGoToPlatform=ClearPad
			ar:GetAttributeChangedSignal("Stealing"):Connect(function()
				if ar:GetAttribute("Stealing")==true then ClearPad()end
			end)
			ar.CharacterRemoving:Connect(ClearPad)
			local function Pad(a6,a7,a8)
				ClearPad()
				local a9=Instance.new("Part")
				a9.Name=Name()
				a9.Size=aF
				a9.Position=Vector3.new(a6.X,a7-aF.Y*.5,a6.Z)
				a9.Anchored=true
				a9.CanCollide=not a8
				a9.CanTouch=false
				a9.CanQuery=false
				a9.Transparency=.55
				a9.Color=aG
				a9.CastShadow=false
				a9.Material=Enum.Material.SmoothPlastic
				a9.Parent=ap
				a5=a9
				local padCharacter=ar.Character
				padMonitor=am.Heartbeat:Connect(function()
					if a5~=a9 then return end
					local c=ar.Character
					local hum=c and c:FindFirstChildOfClass("Humanoid")
					if c~=padCharacter or not hum or hum.Health<=0 or _G.ElysiumTPStop
						or ar:GetAttribute("Stealing")==true or hum.MoveDirection.Magnitude>.05 then ClearPad()end
				end)
				local b=ab.Feet()
				local ba=if a8
					then am.Stepped:Connect(function()
						local ba=Root()
						if ba and a5==a9 and a9.Parent then
							a9.CanCollide=ba.Position.Y-b>=a7-aJ
						end
					end)
					else nil
				padStep=ba
				ak(function()
					local bb=os.clock()
					while a9.Parent and os.clock()-bb<aI do
						local bc=Root()
						if not bc or((bc.Position-a9.Position)*Vector3.new(1,0,1)).Magnitude>aH then
							break
						end
						al(.15)
					end
					if ba then
						ba:Disconnect()
					end
					if a5==a9 then
						ClearPad()
					end
				end)
			end
			local function Carpet(a6)
				local a7=os.clock()
				repeat
					if ac.Held(ar.Character)then
						if a6>0 then al(a6)end
						return
					end
					ac.Equip()
					am.Heartbeat:Wait()
				until os.clock()-a7>.2
			end
			local function LevelOf(a6)
				return if a6>23.15 then 3 elseif a6>=11 then 2 else 1
			end
			local function GoCFrame(a6,a7,a8,a9)
				if not a9 then
					Carpet(0)
				end
				local b=Root()
				if not b then
					return false,nil
				end
				b.Anchored=false
				if a8 and a7 and not AwaitSwap(a7,1.5)then
					Trace("not inside the base after the swap")
					return false,nil
				end
				local ba=a6.Y
				local bb=b.Position.Y
				local bc=LevelOf(bb)==LevelOf(ba)
				if bc then
					Trace("already on the podium's floor")
				elseif ba>23.15 then
					bb=21
				elseif ba>=11 then
					bb=14.5
				elseif ba>=-6.9 and ba<=8.9 then
					bb=aE
				end
				local c=Vector3.new(a6.X,bb,a6.Z)
				Trace(string.format("hop to (%.0f,%.0f,%.0f)",c.X,c.Y,c.Z))
				JumpIfClimbing(b,c.Y)
				local e=b.Position
				local f=math.max(1,math.ceil((c-e).Magnitude/aS))
				for g=1,f do
					if not b.Parent or Root()~=b then
						return false,nil
					end
					b.CFrame=CFrame.new(e:Lerp(c,g/f))
					Still(b)
					if g<f then
						al(aT)
					end
				end
				if not bc then
					Pad(c,c.Y-ab.Feet(),false)
				end
				task.delay(.5,Trace,"half a second after the hop")
				return true,c
			end
			local function UnderHeight(a6,a7)
				if(a7 and 19<=a7)or(not a7 and a6>23.15)then
					return a6-aW
				end
				if(a7 and a7>=11)or(not a7 and a6>=11)then
					return a6-aV
				end
				if(a7 and a7>=1)or(not a7 and a6>=-6.9 and a6<=8.9)then
					return aE
				end
				return a6-aV
			end
			local function GoVelocity(a6,a7,a8,a9,b,ba)
				if not ba then
					Carpet(0)
				end
				local bb=Root()
				if not bb then
					return false
				end
				bb.Anchored=false
				if a9 and a8 and not AwaitSwap(a8,ag(Ping()*4,.4,1.5))then
					Trace("not inside the base after the swap")
					return false
				end
				Trace("glide start")
				Still(bb)
				local bc=LevelOf(bb.Position.Y)==LevelOf(a6.Y)
				local c=Vector3.new(a6.X,if bc then bb.Position.Y else UnderHeight(a6.Y,a7),a6.Z)
				local e=bb.Parent and bb.Parent:FindFirstChildOfClass("Humanoid")
				local function States(f)
					if e then
						e:SetStateEnabled(Enum.HumanoidStateType.Running,f)
						e:SetStateEnabled(Enum.HumanoidStateType.Climbing,f)
					end
				end
				States(false)
				local started=os.clock()
				local speed=math.max(1,b or aN)
				local deadline=started+math.max(aP,(c-bb.Position).Magnitude/speed+1)
				local dt=1/60
				local settleAt,settlePosition
				local settleTime=ag(Ping()*2+.1,.15,.6)
				local function finish(ok,reason)
					if bb and bb.Parent then Still(bb)end
					States(true)
					Trace(reason)
					if not ok then ClearPad()end
					return ok
				end
				while os.clock()<deadline do
					if Root()~=bb or not bb.Parent or not e or e.Health<=0 then
						return finish(false,"movement_character_changed")
					end
					if ar:GetAttribute("Stealing")then
						return finish(true,"pickup_started")
					end
					local delta=c-bb.Position
					if delta.Magnitude<=aQ then
						Still(bb)
						if not settleAt then
							settleAt,settlePosition=os.clock(),bb.Position
							if not bc then Pad(a6,c.Y-ab.Feet(),true)end
						elseif(bb.Position-settlePosition).Magnitude>.75 then
							settleAt,settlePosition=os.clock(),bb.Position
						end
						if os.clock()-settleAt>=settleTime then
							return finish(true,"glide_settled")
						end
					else
						if settleAt then
							return finish(false,"movement_corrected_after_arrival")
						end
						local desired=if os.clock()-started<aO then ai(aM,speed)else speed
						local stepSpeed=ai(desired,delta.Magnitude*.8/math.max(dt,1/240))
						bb.AssemblyLinearVelocity=delta.Unit*stepSpeed
					end
					dt=am.Heartbeat:Wait()or 1/60
				end
				return finish(false,"movement_timeout")
			end
			function aY.GoTo(a6,a7,a8,a9,b,ba,bb)
				if a6=="Velocity"then
					return GoVelocity(a7,a8,a9,b,ba,bb)
				end
				local bc,c=GoCFrame(a7,a9,b,bb)
				if not bc or not c then
					return bc
				end
				local e=Root()
				if not e then return false end
				if((e.Position-c)*a2).Magnitude<=aU then
					return bc
				end
				Trace(
					string.format(
						"lagged back %.0f studs after the hop, gliding instead",
						((e.Position-c)*a2).Magnitude
					)
				)
				return GoVelocity(a7,a8,a9,false,ba,bb)
			end
	function aY.RiseToCeiling(target,plot)
		local root=Root()
		local humanoid=root and root.Parent:FindFirstChildOfClass("Humanoid")
		if not root or not humanoid or not plot then return false end
		local height=target.Y-root.Position.Y
		if height<=3 then return true end
		local params=RaycastParams.new()
		params.FilterType=Enum.RaycastFilterType.Exclude
		params.FilterDescendantsInstances={root.Parent}
		params.RespectCanCollide=true
		params.CollisionGroup=root.CollisionGroup
		local hit=workspace:Blockcast(CFrame.new(root.Position+Vector3.new(0,.4,0)),Vector3.new(2.4,4.6,2.4),Vector3.new(0,height,0),params)
		if not hit or not hit.Instance:IsDescendantOf(plot)then Trace("ceiling_not_found");return false end
		local ceiling=root.Position.Y+math.max(0,hit.Distance-.15)
		local start=root.Position
		local best,progressAt=root.Position.Y,os.clock()
		local deadline=os.clock()+3
		humanoid:ChangeState(Enum.HumanoidStateType.Jumping)
		humanoid.Jump=true
		local dt=1/60
		while ceiling-root.Position.Y>.05 do
			if Root()~=root or humanoid.Health<=0 or os.clock()>deadline then Still(root);return false end
			local horizontal=(root.Position-start)*Vector3.new(1,0,1)
			if horizontal.Magnitude>3 then Still(root);return false end
			if root.Position.Y>best+.02 then best,progressAt=root.Position.Y,os.clock()
			elseif os.clock()-progressAt>.3 then break end
			root.AssemblyLinearVelocity=Vector3.new(0,math.min(tonumber(_G.ElysiumClimb)or 160,(ceiling-root.Position.Y)/math.max(dt,1/240)),0)
			dt=am.Heartbeat:Wait()or 1/60
		end
		Still(root)
		if ceiling-root.Position.Y>1 then Trace("ceiling_unreachable");return false end
		Pad(root.Position,root.Position.Y-ab.Feet(),false)
		Trace("at_ceiling")
		return true
	end
	_G.ElysiumDonorGoTo=function(position,options)
		options=type(options)=="table"and options or{slot=options}
		runCharacter=LP.Character
		local humanoid=runCharacter and runCharacter:FindFirstChildOfClass("Humanoid")
		if not humanoid or _G.ElysiumTPStop then return false end
		local running=humanoid:GetStateEnabled(Enum.HumanoidStateType.Running)
		local climbing=humanoid:GetStateEnabled(Enum.HumanoidStateType.Climbing)
		local plots=workspace:FindFirstChild("Plots")
		local plot=options.plot and plots and plots:FindFirstChild(tostring(options.plot))
		ClearPad()
		local ok,result=pcall(function()
			local arrived=aY.GoTo(options.cloneRelocated and"Velocity"or(_G.ElysiumGoMethod or"CFrame"),position,tonumber(options.slot),plot,false,tonumber(options.speed)or tonumber(_G.ElysiumGoSpeed)or 400,false)
			local slot=tonumber(options.slot)
			local root=Root()
			if arrived and slot and slot>=11 and slot<=18 and _G.ElysiumGoApproachF2~=false and root and position.Y-root.Position.Y>3 then
				return aY.RiseToCeiling(position,plot)
			end
			return arrived
		end)
		pcall(function()
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Running,running)
			humanoid:SetStateEnabled(Enum.HumanoidStateType.Climbing,climbing)
		end)
		if not ok or _G.ElysiumTPStop then ClearPad()end
		if not ok then error(result,0)end
		return result==true
	end
end
local function elysiumGoToCastParams(character,extra)
	local cast=RaycastParams.new()
	cast.FilterType=Enum.RaycastFilterType.Exclude
	local exclude={character}
	local labels=workspace:FindFirstChild("ElysiumBrainrotLabels")
	if labels then exclude[#exclude+1]=labels end
	local plat=workspace:FindFirstChild("ElysiumPickupPlatform")
	if plat then exclude[#exclude+1]=plat end
	if type(extra)=="table"then
		for _,inst in ipairs(extra)do exclude[#exclude+1]=inst end
	elseif extra then
		exclude[#exclude+1]=extra
	end
	cast.FilterDescendantsInstances=exclude
	cast.RespectCanCollide=true
	cast.IgnoreWater=true
	return cast
end
ElysiumGoToCastParams=elysiumGoToCastParams
function ElysiumGoToStandPoint(petPos,fromPos,options)
	local character=LP.Character
	local plots=workspace:FindFirstChild("Plots")
	local plot=options and options.plot and plots and plots:FindFirstChild(tostring(options.plot))
	local podiums=plot and plot:FindFirstChild("AnimalPodiums")
	local podium=podiums and options.slot and podiums:FindFirstChild(tostring(options.slot))
	local model=plot and options.slot and _petModelCache[tostring(plot.Name).."\0"..tostring(options.slot)]
	if model and(not model.Parent or(podium and not model:IsDescendantOf(podium)))then model=nil end
	local cast=elysiumGoToCastParams(character,model)
	local floorY
	local hit=workspace:Raycast(petPos+Vector3.new(0,1,0),Vector3.new(0,-24,0),cast)
	if hit then floorY=hit.Position.Y end
	local podiumFloor
	if podium then
		local base=podium:FindFirstChild("Base")
		pcall(function()
			if base and base:IsA("BasePart")then
				podiumFloor=base.Position.Y-base.Size.Y*.5
			elseif base then
				local cf,size=base:GetBoundingBox()
				podiumFloor=cf.Position.Y-size.Y*.5
			else
				local cf,size=podium:GetBoundingBox()
				podiumFloor=cf.Position.Y-size.Y*.5
			end
		end)
	end
	if podiumFloor and(not floorY or math.abs(floorY-podiumFloor)>4)then
		floorY=podiumFloor
	end
	if not floorY then floorY=petPos.Y-2.5 end
	local center=petPos
	local anchor=ElysiumGoToPromptAnchor(options)
	if typeof(anchor)=="Vector3"and math.abs(anchor.Y-petPos.Y)<12 then center=anchor end
	local offset=math.clamp(tonumber(_G.ElysiumGoStandOffset)or 1.5,0,8)
	local toward=Vector3.new(fromPos.X-center.X,0,fromPos.Z-center.Z)
	if toward.Magnitude<.5 then toward=Vector3.new(0,0,1)end
	toward=toward.Unit
	local dirs={toward,Vector3.new(-toward.Z,0,toward.X),Vector3.new(toward.Z,0,-toward.X),-toward}
	local overlap=OverlapParams.new()
	overlap.FilterType=Enum.RaycastFilterType.Exclude
	overlap.FilterDescendantsInstances=cast.FilterDescendantsInstances
	overlap.RespectCanCollide=true
	for _,dist in ipairs({offset,offset+1,offset+2,offset+3.5})do
		for _,dir in ipairs(dirs)do
			local probe=Vector3.new(center.X,floorY+4,center.Z)+dir*dist
			local ground=workspace:Raycast(probe,Vector3.new(0,-8,0),cast)
			if ground and math.abs(ground.Position.Y-floorY)<=2 then
				local feet=Vector3.new(probe.X,ground.Position.Y,probe.Z)
				local body=CFrame.new(feet+Vector3.new(0,3,0))
				if#workspace:GetPartBoundsInBox(body,Vector3.new(1.8,4.6,1.8),overlap)==0 then
					return feet,floorY
				end
			end
		end
	end
	return Vector3.new(center.X,floorY,center.Z),floorY
end
function ElysiumCharacterHeadroom(character,root)
	local top
	pcall(function()
		for _,part in ipairs(character:GetChildren())do
			if part:IsA("BasePart")then
				local cf,size=part.CFrame,part.Size
				local half=(math.abs(cf.RightVector.Y)*size.X+math.abs(cf.UpVector.Y)*size.Y
					+math.abs(cf.LookVector.Y)*size.Z)*.5
				top=math.max(top or-math.huge,cf.Position.Y-root.Position.Y+half)
			end
		end
	end)
	if not top or top<.5 or top>8 then top=2.4 end
	return top
end
function ElysiumGoToCeiling(character,at,floorY)
	if type(floorY)~="number"or typeof(at)~="Vector3"then return nil end
	local cast=elysiumGoToCastParams(character)
	local depth=math.clamp(tonumber(_G.ElysiumGoCeilingProbe)or 9,4,16)
	local origin=Vector3.new(at.X,floorY-depth,at.Z)
	local up=Vector3.new(0,depth+.5,0)
	local hit=workspace:Blockcast(CFrame.new(origin),Vector3.new(2.4,.2,2.4),up,cast)
		or workspace:Raycast(origin,up,cast)
	if not hit or hit.Position.Y>floorY-.3 then return nil end
	return hit.Position.Y
end
function ElysiumGoToPromptAnchor(options)
	if type(options)~="table"or not options.plot or not options.slot then return nil end
	local plots=workspace:FindFirstChild("Plots")
	local plot=plots and plots:FindFirstChild(tostring(options.plot))
	local podiums=plot and plot:FindFirstChild("AnimalPodiums")
	local podium=podiums and podiums:FindFirstChild(tostring(options.slot))
	if not podium then return nil end
	local base=podium:FindFirstChild("Base")
	local spawn=base and base:FindFirstChild("Spawn")
	local attach=spawn and spawn:FindFirstChild("PromptAttachment")
	local reach
	if attach then
		for _,prompt in ipairs(attach:GetChildren())do
			if prompt:IsA("ProximityPrompt")then
				reach=math.max(reach or 0,tonumber(prompt.MaxActivationDistance)or 0)
			end
		end
		if reach and reach<=0 then reach=nil end
		return attach.WorldPosition,reach
	end
	if spawn and spawn:IsA("BasePart")then return spawn.Position,nil end
	return nil
end
function ElysiumGoCarpetSpeed()
	return math.clamp(tonumber(_G.ElysiumGoCarpetSpeed)or tonumber(_G.ElysiumCarpetSpeedValue)or 120,30,400)
end
function ElysiumEquipCarpetOnly(character,humanoid)
	if not character or not humanoid then return nil end
	local tool=ElysiumFindRouteFlightTool(character)
	if not tool and type(equipCarpet)=="function"then
		pcall(equipCarpet)
		tool=ElysiumFindRouteFlightTool(character)
	end
	if not tool then
		_G.ElysiumGoToDetail="carpet_missing"
		return nil
	end
	if type(ElysiumWatchCarpetEnabled)=="function"then ElysiumWatchCarpetEnabled(tool)end
	if tool.Parent==character and not tool.Enabled and _G.ElysiumGoReequipCarpet==true then
		local bp=LP:FindFirstChild("Backpack")
		if bp then pcall(function()tool.Parent=bp end)end
		RunService.Heartbeat:Wait()
	end
	if tool.Parent==character then
		local cloner=character:FindFirstChild("Quantum Cloner")
		local bp=LP:FindFirstChild("Backpack")
		if cloner and cloner:IsA("Tool")and bp then pcall(function()cloner.Parent=bp end)end
		local holdDiag=_G.ElysiumCloneHoldDiag
		if type(holdDiag)=="table"and holdDiag.carpetHeldAfterSwap==nil then
			holdDiag.carpetHeldAfterSwap=true
			holdDiag.carpetEnabledAfterSwap=tool.Enabled
		end
	end
	local deadline,nextTry=os.clock()+1.2,0
	local equippedHere=tool.Parent~=character
	while tool.Parent~=character and os.clock()<deadline do
		if _G.ElysiumTPStop or LP.Character~=character then return nil end
		if os.clock()>=nextTry then
			nextTry=os.clock()+.15
			pcall(humanoid.EquipTool,humanoid,tool)
		end
		RunService.Heartbeat:Wait()
	end
	if equippedHere and tool.Parent==character then _G.ElysiumCarpetEquippedAt=os.clock()end
	_G.ElysiumGoCarpetTool=tool.Parent==character and tool.Name or nil
	return tool.Parent==character and tool or nil
end
function ElysiumDismountCarpet(character,humanoid,root)
	if not character then return end
	if root then
		pcall(ElysiumCarpetRouteSweep,root,humanoid)
		root.AssemblyLinearVelocity=Vector3.new(0,math.min(root.AssemblyLinearVelocity.Y,0),0)
		root.AssemblyAngularVelocity=Vector3.zero
	end
	local bp=LP:FindFirstChild("Backpack")
	local names={_G.ElysiumGoCarpetTool,_G.ElysiumRouteFlightTool}
	for _,name in ipairs(CARPET_NAMES)do names[#names+1]=name end
	for _,name in pairs(names)do
		local tool=type(name)=="string"and character:FindFirstChild(name)
		if tool and tool:IsA("Tool")and bp then pcall(function()tool.Parent=bp end)end
	end
	_G.ElysiumGoCarpetTool=nil
	if not humanoid then return end
	pcall(function()
		humanoid.PlatformStand=false
		humanoid.Sit=false
		local seat=humanoid.SeatPart
		local weld=seat and seat:FindFirstChild("SeatWeld")
		if weld then weld:Destroy()end
		local state=humanoid:GetState()
		if humanoid.SeatPart or state==Enum.HumanoidStateType.Seated
			or state==Enum.HumanoidStateType.PlatformStanding
			or state==Enum.HumanoidStateType.Physics then
			humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
		end
	end)
end
function ElysiumCarpetSpeedMove(character,root,humanoid,route,speed,tolerance,stopWhen)
	if not root or not humanoid or type(route)~="table"or#route==0 then return false,"no_route"end
	local index,started=1,os.clock()
	local lastPos=root.Position
	local bestDist,progressAt=math.huge,os.clock()
	local lagbacks=0
	local accel=tonumber(_G.ElysiumGoCarpetAccel)or 400
	pcall(function()humanoid.PlatformStand=false;humanoid.Sit=false end)
	local carpet=ElysiumEquipCarpetOnly(character,humanoid)
	local nextEquip=0
	while index<=#route do
		if _G.ElysiumTPStop or LP.Character~=character or root.Parent~=character
			or humanoid.Health<=0 then return false,"interrupted"end
		if LP:GetAttribute("Stealing")==true then return true end
		if type(stopWhen)=="function"and stopWhen()then
			root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
			return false,"stopped"
		end
		local dt=RunService.Heartbeat:Wait()
		if root.Anchored then return false,"anchored"end
		local pos=root.Position
		local now=os.clock()
		local jump=(pos-lastPos).Magnitude
		if jump>math.max(8,speed*dt*3)then
			lagbacks=lagbacks+1
			speed=math.max(30,speed*.5)
			started=now
			bestDist,progressAt=math.huge,now
			_G.ElysiumGoToDetail="carpet_speed_lagback_"..lagbacks
			if lagbacks>3 then return false,"lagback"end
		end
		lastPos=pos
		local point=route[index]
		local flat=Vector3.new(point.X-pos.X,0,point.Z-pos.Z)
		local distance=flat.Magnitude
		local tol=index==#route and tolerance or math.max(tolerance,3)
		if distance<=tol then
			index=index+1
			bestDist,progressAt=math.huge,now
		else
			if distance<bestDist-.3 then
				bestDist,progressAt=distance,now
			elseif now-progressAt>(tonumber(_G.ElysiumGoCarpetStall)or 1)then
				root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
				return false,"stalled"
			end
			pcall(ElysiumCarpetRouteSweep,root,humanoid)
			if humanoid.Sit then humanoid.Sit=false end
			if carpet and carpet.Parent~=character and now>=nextEquip then
				nextEquip=now+.2
				if carpet.Parent then pcall(humanoid.EquipTool,humanoid,carpet)end
			end
			if point.Y-pos.Y>2 and humanoid.FloorMaterial~=Enum.Material.Air then humanoid.Jump=true end
			local cruise=math.min(speed,24+(now-started)*accel)
			local step=flat.Unit*math.min(cruise,distance*.65/math.max(dt,1/240))
			root.AssemblyLinearVelocity=Vector3.new(step.X,root.AssemblyLinearVelocity.Y,step.Z)
		end
	end
	root.AssemblyLinearVelocity=Vector3.new(0,root.AssemblyLinearVelocity.Y,0)
	return true
end
function ElysiumCarpetGoTo(petPos,options)
	if typeof(petPos)~="Vector3"then return false end
	if type(options)~="table"then options={slot=options}end
	local character=LP.Character
	local root=character and character:FindFirstChild("HumanoidRootPart")
	local humanoid=character and character:FindFirstChildOfClass("Humanoid")
	if not root or _G.ElysiumTPStop then return false end
	if options.plot and type(_G.ElysiumOptimizerFocusPlot)=="function"then
		pcall(_G.ElysiumOptimizerFocusPlot,options.plot)
		local plots=workspace:FindFirstChild("Plots")
		local live=plots and plots:FindFirstChild(tostring(options.plot))
		if live and options.slot then
			local ok,fresh=pcall(getPetPosition,live,options.slot,false)
			if ok and typeof(fresh)=="Vector3"and(fresh-petPos).Magnitude<60 then petPos=fresh end
		end
	end
	local readyUntil=os.clock()+2
	while root.Anchored and os.clock()<readyUntil do
		if _G.ElysiumTPStop or LP.Character~=character or root.Parent~=character then return false end
		RunService.Heartbeat:Wait()
	end
	if root.Anchored then _G.ElysiumGoToDetail="root_still_anchored";return false end
	local goDiag=_G.ElysiumGoStartDiag
	if type(goDiag)~="table"then goDiag={};_G.ElysiumGoStartDiag=goDiag end
	goDiag.goStart=os.clock()
	ElysiumEquipCarpetOnly(character,humanoid)
	goDiag.equipDone=os.clock()
	local feetOffset=(humanoid and(humanoid.HipHeight+root.Size.Y*.5))or 3
	local standPos,floorY=ElysiumGoToStandPoint(petPos,root.Position,options)
	local flyTarget=standPos+Vector3.new(0,feetOffset+.5,0)
	local crossFloor=math.abs(flyTarget.Y-root.Position.Y)>(tonumber(_G.ElysiumGoFloorGap)or 6)
	local noclip=_G.ElysiumGoNoclip==true or(crossFloor and _G.ElysiumGoNoclip~=false)
	local upNoCarpet=crossFloor and flyTarget.Y>root.Position.Y and _G.ElysiumGoUpCarpet~=true
	goDiag.upNoCarpet=upNoCarpet
	if not upNoCarpet and _G.ElysiumGoCarpetSpeedWalk~=true then pcall(ElysiumPrepareCarpetRoute,true)end
	local goCast=elysiumGoToCastParams(character)
	local function clearPath(fromP,toP)
		local move=toP-fromP
		if move.Magnitude<.05 then return true end
		return workspace:Blockcast(CFrame.new(fromP),Vector3.new(2.2,2,2.2),move,goCast)==nil
	end
	local underCeiling=false
	if crossFloor and flyTarget.Y>root.Position.Y and _G.ElysiumGoThroughCeiling~=true then
		local headroom=ElysiumCharacterHeadroom(character,root)
		local margin=math.clamp(tonumber(_G.ElysiumGoCeilingMargin)or .6,.2,3)
		local anchor,reach=ElysiumGoToPromptAnchor(options)
		anchor=anchor or petPos
		local toward=Vector3.new(root.Position.X-anchor.X,0,root.Position.Z-anchor.Z)
		toward=toward.Magnitude>.5 and toward.Unit or Vector3.zero
		local overlap=OverlapParams.new()
		overlap.FilterType=Enum.RaycastFilterType.Exclude
		overlap.FilterDescendantsInstances=goCast.FilterDescendantsInstances
		overlap.RespectCanCollide=true
		local bodySize=Vector3.new(2.2,math.max(2,headroom+feetOffset-.4),2.2)
		local preferred=math.clamp(tonumber(_G.ElysiumGoUnderOffset)or 0,0,6)
		local fallback
		for _,offset in ipairs({preferred,preferred+1.5,preferred+3,preferred+4.5})do
			local under=Vector3.new(anchor.X,0,anchor.Z)+toward*offset
			local ceilingY=ElysiumGoToCeiling(character,under,floorY)
			local y=ceilingY and(ceilingY-headroom-margin)
			if y and y>root.Position.Y-40 then
				local spot=Vector3.new(under.X,y,under.Z)
				local center=spot+Vector3.new(0,(headroom-feetOffset)*.5,0)
				local free=#workspace:GetPartBoundsInBox(CFrame.new(center),bodySize,overlap)==0
				local inReach=not reach or(spot-anchor).Magnitude<=reach-.3
				if free and inReach then
					fallback=spot
					break
				end
				if free and not fallback then fallback=spot end
			end
		end
		if fallback then
			flyTarget=fallback
			standPos=Vector3.new(fallback.X,fallback.Y-feetOffset,fallback.Z)
			underCeiling=true
		end
	end
	local route
	if underCeiling then
		local headroom=ElysiumCharacterHeadroom(character,root)
		local lift=Vector3.new(0,math.max(0,headroom-1.2),0)
		local up=Vector3.new(root.Position.X,flyTarget.Y,root.Position.Z)
		local diagonal
		if _G.ElysiumGoDiagonal~=false then
			if clearPath(root.Position,flyTarget+lift)then
				diagonal={flyTarget}
			else
				local flat=Vector3.new(flyTarget.X-root.Position.X,0,flyTarget.Z-root.Position.Z)
				for _,part in ipairs({.6,.4,.25})do
					local knee=root.Position+flat*part+Vector3.new(0,flyTarget.Y-root.Position.Y,0)
					if clearPath(root.Position,knee+lift)and clearPath(knee,flyTarget+lift)then
						diagonal={knee,flyTarget}
						break
					end
				end
			end
		end
		if diagonal then
			route=diagonal
			noclip=_G.ElysiumGoNoclip==true
		elseif clearPath(root.Position,up+lift)then
			route={up,flyTarget}
			noclip=_G.ElysiumGoNoclip==true
		else
			local over=Vector3.new(flyTarget.X,root.Position.Y,flyTarget.Z)
			route=computeRoute(root.Position,over,nil)
			if not route or#route==0 then route={over}end
			if(route[#route]-over).Magnitude>.5 then route[#route+1]=over end
			route[#route+1]=flyTarget
			noclip=_G.ElysiumGoNoclip==true
				or(_G.ElysiumGoNoclip~=false and not clearPath(over,flyTarget+lift))
		end
	elseif crossFloor and noclip then
		local over=Vector3.new(flyTarget.X,root.Position.Y,flyTarget.Z)
		route=computeRoute(root.Position,over,nil)
		if not route or#route==0 then route={over}end
		local last=route[#route]
		if(last-over).Magnitude>.5 then route[#route+1]=over end
		route[#route+1]=flyTarget
	elseif clearPath(root.Position,flyTarget)then
		route={flyTarget}
	else
		route=computeRoute(root.Position,flyTarget,nil)
		if not route or#route==0 then route={flyTarget}end
	end
	local tolerance=math.clamp(tonumber(_G.ElysiumGoArriveTolerance)or 1.2,.6,6)
	if underCeiling then tolerance=math.min(tolerance,1.5)end
	local level=not crossFloor and not underCeiling and not noclip and _G.ElysiumGoCarpetSpeedWalk==true
	if level then
		for _,point in ipairs(route)do
			if math.abs(point.Y-root.Position.Y)>4 then level=false;break end
		end
	end
	local ok,arrived=true,false
	if level then
		_G.ElysiumGoToDetail="carpet_speed_walk"
		local walked,why=ElysiumCarpetSpeedMove(character,root,humanoid,route,
			ElysiumGoCarpetSpeed(),tolerance)
		arrived=walked
		if not walked and why=="stalled"and not _G.ElysiumTPStop and LP.Character==character
			and LP:GetAttribute("Stealing")~=true then
			level=false
			route=computeRoute(root.Position,flyTarget,nil)
			if not route or#route==0 then route={flyTarget}end
		end
	end
	if not level and not noclip and _G.ElysiumGoFootWhileCooldown~=false
		and not(type(ElysiumCarpetForceAllowed)=="function"and ElysiumCarpetForceAllowed())then
		local tool=ElysiumFindRouteFlightTool(character)
		local onCooldown=tool and tool.Parent==character and not tool.Enabled
			and not humanoid.PlatformStand
			and humanoid:GetState()~=Enum.HumanoidStateType.PlatformStanding
		local flatRoute=onCooldown and math.abs(flyTarget.Y-root.Position.Y)<=4
		if flatRoute then
			for _,point in ipairs(route)do
				if math.abs(point.Y-root.Position.Y)>4 then flatRoute=false;break end
			end
		end
		if flatRoute then
			_G.ElysiumGoToDetail="foot_while_cooldown"
			goDiag.footStart=os.clock()
			local footSpeed=math.clamp(tonumber(_G.ElysiumGoFootSpeed)or ElysiumGoCarpetSpeed(),16,400)
			local walked,why=ElysiumCarpetSpeedMove(character,root,humanoid,route,footSpeed,tolerance,
				function()return tool.Enabled or tool.Parent~=character end)
			goDiag.footEnd,goDiag.footResult=os.clock(),walked and"arrived"or why
			if LP.Character~=character or root.Parent~=character then return false end
			if walked then
				if LP:GetAttribute("Stealing")==true then
					ElysiumDismountCarpet(character,humanoid,root)
					return true
				end
				return ElysiumHoldForPickup(character,root,standPos,floorY,{forcePlatform=underCeiling})
			end
			if why=="interrupted"or why=="lagback"or why=="anchored"then return false end
			route=computeRoute(root.Position,flyTarget,nil)
			if not route or#route==0 then route={flyTarget}end
		end
	end
	if not level then
		_G.ElysiumGoToDetail=upNoCarpet and"up_no_carpet"
			or(noclip and"carpet_route_noclip"or"carpet_route")
		goDiag.routeDone=os.clock()
		if not upNoCarpet then pcall(ElysiumPrepareCarpetRoute,false)end
		goDiag.prepDone=os.clock()
		local goSpeed=_G.ElysiumGoUseCarpetSpeed~=false and ElysiumGoCarpetSpeed()
			or math.clamp(tonumber(_G.ElysiumGoSpeed)or tonumber(_G.TPVelocity)or 150,50,750)
		local restoreCollision=noclip and elysiumGoCollisionScope()or nil
		goDiag.moveStart=os.clock()
		ok,arrived=pcall(velMoveThrough,root,route,goSpeed,true,true,tolerance,nil,
			{speed=goSpeed,ignoreObstacles=noclip,quickArrive=true,diagonal=_G.ElysiumGoDiagonal~=false,
			  noCarpet=upNoCarpet})
		if ok and not arrived and _G.ElysiumTPMovementStatus=="root_anchored"
			and _G.ElysiumGoAnchoredRetry~=false and not _G.ElysiumTPStop
			and LP.Character==character and LP:GetAttribute("Stealing")~=true then
			local clearUntil=os.clock()+2
			while root.Anchored and os.clock()<clearUntil and LP.Character==character do
				RunService.Heartbeat:Wait()
			end
			if not root.Anchored and LP.Character==character then
				goDiag.anchoredRetry=os.clock()
				_G.ElysiumGoToDetail="carpet_route_retry_after_anchor"
				route=computeRoute(root.Position,flyTarget,nil)
				if not route or#route==0 then route={flyTarget}end
				if not upNoCarpet then pcall(ElysiumPrepareCarpetRoute,false)end
				ok,arrived=pcall(velMoveThrough,root,route,goSpeed,true,true,tolerance,nil,
					{speed=goSpeed,ignoreObstacles=noclip,quickArrive=true,diagonal=_G.ElysiumGoDiagonal~=false,
					  noCarpet=upNoCarpet})
			end
		end
		if restoreCollision then restoreCollision()end
	end
	if not ok then error(arrived,0)end
	if LP:GetAttribute("Stealing")==true then
		ElysiumDismountCarpet(character,humanoid,root)
		return true
	end
	if LP.Character~=character or root.Parent~=character then return false end
	if not arrived then
		local delta=flyTarget-root.Position
		local near=Vector3.new(delta.X,0,delta.Z).Magnitude<=6 and math.abs(delta.Y)<=4
		if not near then return false end
		if delta.Magnitude>tolerance+.3 and _G.ElysiumGoFinalNudge~=false
			and not _G.ElysiumTPStop and LP:GetAttribute("Stealing")~=true then
			goDiag.nudge=delta.Magnitude
			_G.ElysiumGoToDetail="final_nudge"
			local nudgeSpeed=math.clamp(tonumber(_G.ElysiumGoNudgeSpeed)or 40,10,140)
			pcall(velMoveThrough,root,{flyTarget},nudgeSpeed,true,true,tolerance,nil,
				{speed=nudgeSpeed,ignoreObstacles=true,quickArrive=true,replan=false,
				  noCarpet=upNoCarpet})
			if LP.Character~=character or root.Parent~=character then return false end
			if LP:GetAttribute("Stealing")==true then
				ElysiumDismountCarpet(character,humanoid,root)
				return true
			end
		end
	end
	return ElysiumHoldForPickup(character,root,standPos,floorY,{forcePlatform=underCeiling})
end
function ElysiumHoldForPickup(character,root,standPos,floorY,holdOptions)
	local position=root.Position
	local humanoid=character:FindFirstChildOfClass("Humanoid")
	local cast=elysiumGoToCastParams(character)
	cast.CollisionGroup=root.CollisionGroup
	local feetOffset=(humanoid and(humanoid.HipHeight+root.Size.Y*.5))or 3
	local probe=tonumber(_G.ElysiumPickupGroundProbe)or 60
	local _=standPos,floorY
	do
		local brakeUntil=os.clock()+math.clamp(tonumber(_G.ElysiumPickupBrake)or .5,.1,2)
		local still,last=0,root.Position
		while os.clock()<brakeUntil do
			root.AssemblyLinearVelocity=Vector3.zero
			root.AssemblyAngularVelocity=Vector3.zero
			RunService.Heartbeat:Wait()
			if LP.Character~=character or root.Parent~=character then return false end
			if LP:GetAttribute("Stealing")==true then break end
			local now=root.Position
			still=(now-last).Magnitude<.05 and still+1 or 0
			last=now
			if still>=3 then break end
		end
		position=root.Position
	end
	local groundHit=workspace:Raycast(position,Vector3.new(0,-probe,0),cast)
	local dropDist=groundHit and(position.Y-groundHit.Position.Y)or math.huge
	local maxDrop=feetOffset+(tonumber(_G.ElysiumPickupMaxDrop)or 8)
	local standOnGround=groundHit~=nil and dropDist<=maxDrop and _G.ElysiumPickupStandOnGround~=false
	if type(holdOptions)=="table"and holdOptions.forcePlatform then standOnGround=false end
	root.AssemblyLinearVelocity=Vector3.zero
	root.AssemblyAngularVelocity=Vector3.zero
	local plat
	if standOnGround then
		plat=nil
	elseif _G.ElysiumPickupPlatform~=false then
		local sz=tonumber(_G.ElysiumPickupPlatSize)or 8
		local old=workspace:FindFirstChild("ElysiumPickupPlatform")
		if old then old:Destroy()end
		plat=Instance.new("Part")
		plat.Name="ElysiumPickupPlatform"
		plat.Anchored=true
		plat.CanCollide=true
		plat.CanTouch=false
		plat.CanQuery=false
		plat.CastShadow=false
		plat.Transparency=1
		plat.Material=Enum.Material.SmoothPlastic
		plat.Size=Vector3.new(sz,1,sz)
		plat.Position=Vector3.new(position.X,position.Y-feetOffset-.5,position.Z)
		plat.Parent=workspace
	end
	ElysiumDismountCarpet(character,humanoid,root)
	for _=1,4 do
		root.AssemblyLinearVelocity=Vector3.zero
		root.AssemblyAngularVelocity=Vector3.zero
		RunService.Heartbeat:Wait()
		if LP.Character~=character or root.Parent~=character then
			if plat then plat:Destroy()end
			return false
		end
	end
	root.AssemblyLinearVelocity=Vector3.zero
	root.AssemblyAngularVelocity=Vector3.zero
	local leaveDist=tonumber(_G.ElysiumPickupLeaveDist)or 25
	_G.ElysiumHoldingForPickup=true
	_G.ElysiumGoToStatus="waiting_pickup"
	_G.ElysiumGoToDetail=plat and"holding_on_platform"or"holding_on_ground"
	local ok,pickedUp=pcall(function()
		while LP.Character==character and root.Parent==character and humanoid and humanoid.Health>0 do
			if LP:GetAttribute("Stealing")==true then return true end
			if _G.ElysiumTPStop or _G.Elysium_IsResetting or _G.ElysiumAutoBuyTPBlocked then return false end
			if(tonumber(LP:GetAttribute("RagdollEndTime"))or 0)>workspace:GetServerTimeNow()then return false end
			RunService.Heartbeat:Wait()
			if LP.Character~=character or root.Parent~=character then return false end
			if LP:GetAttribute("Stealing")==true then return true end
			local offset=root.Position-position
			if Vector3.new(offset.X,0,offset.Z).Magnitude>leaveDist then
				_G.ElysiumGoToDetail="left_pickup_spot"
				return false
			end
		end
		return false
	end)
	_G.ElysiumHoldingForPickup=false
	if plat then plat:Destroy()end
	if root.Parent==character then
		root.AssemblyLinearVelocity=Vector3.zero
		root.AssemblyAngularVelocity=Vector3.zero
	end
	if not ok then error(pickedUp,0)end
	return pickedUp==true
end
function goToBrainrot(petPos,slotOrOpts)
	if _goBusy then
		_G.ElysiumGoToStatus="busy"
		return false
	end
	_G.ElysiumGoToStatus="starting"
	_G.ElysiumGoToError=nil
	_G.ElysiumGoToDetail=nil
	_goBusy=true
	local ok,result=pcall(ElysiumCarpetGoTo,petPos,slotOrOpts)
	_goBusy=false
	if not ok then
		_G.ElysiumGoToStatus="error"
		_G.ElysiumGoToError=tostring(result)
		local c=LP.Character
		local r=c and c:FindFirstChild("HumanoidRootPart")
		if r then
			r.AssemblyLinearVelocity=Vector3.zero
			r.AssemblyAngularVelocity=Vector3.zero
		end
		return false
	end
	_G.ElysiumGoToStatus=result==true and"arrived"or"interrupted"
	return result==true
end
function _pingMs()
	local ok,p=pcall(function()
		return LP:GetNetworkPing()*1000
	end)
	if ok and type(p)=="number"and p>0 then
		return p
	end
	local ok2,p2=pcall(function()
		return _Stats.Network.ServerStatsItem["Data Ping"]:GetValue()
	end)
	if ok2 and type(p2)=="number"and p2>0 then
		return p2
	end
	return 0
end
_G.ElysiumPingMs=_pingMs
function _pingAdjustSpeed(spd)
	local thresh=tonumber(_G.ElysiumPingThresh)or 170
	local capped=tonumber(_G.ElysiumHighPingSpeed)or 400
	if _pingMs()>=thresh and spd>capped then
		return capped
	end
	return spd
end
function _inVoid(hrp)
	if not hrp or not hrp.Parent then
		return true
	end
	local voidY=tonumber(_G.ElysiumVoidY)or-50
	return hrp.Position.Y<voidY
end
function _waitOutOfVoid(timeout)
	local t0=os.clock()
	local good=0
	while os.clock()-t0<(timeout or 12)do
		if _G.ElysiumTPStop then
			return false
		end
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if hrp and hrp.Parent and not _inVoid(hrp)and math.abs(hrp.AssemblyLinearVelocity.Y)<12 then
			good+=1
			if good>=4 then
				return true
			end
		else
			good=0
		end
		RunService.Heartbeat:Wait()
	end
	return false
end
do
	local lastSafe=nil
	local recovering=false
	local _voidAcc=0
	RunService.Heartbeat:Connect(LPH_NO_VIRTUALIZE(function(dt)
		_voidAcc=_voidAcc+(dt or .016)
		if _voidAcc<.1 then
			return
		end
		_voidAcc=0
		if _G.ElysiumVoidRecover==false then
			return
		end
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp or not hrp.Parent then
			return
		end
		local voidY=tonumber(_G.ElysiumVoidY)or-50
		if hrp.Position.Y>=voidY then
			if math.abs(hrp.AssemblyLinearVelocity.Y)<40 then
				lastSafe=hrp.Position
			end
			return
		end
		if recovering or not lastSafe then
			return
		end
		recovering=true
		pcall(function()
			_vzL(hrp)
			_vzA(hrp)
			hrp.CFrame=CFrame.new(lastSafe+Vector3.new(0,5,0))
		end)
		task.spawn(function()
			local delay=tonumber(_G.ElysiumVoidRecoverDelay)or 0
			if delay>0 then
				task.wait(delay)
			end
			local vy=tonumber(_G.ElysiumVoidY)or-50
			local tries=0
			while tries<80 do
				local c=LP.Character
				local h=c and c:FindFirstChild("HumanoidRootPart")
				if not h or not h.Parent then
					break
				end
				if h.Position.Y>=vy and math.abs(h.AssemblyLinearVelocity.Y)<18 then
					break
				end
				if lastSafe then
					pcall(function()
						_vzL(h)
						_vzA(h)
						h.CFrame=CFrame.new(lastSafe+Vector3.new(0,5,0))
					end)
				end
				tries=tries+1
				RunService.Heartbeat:Wait()
			end
			recovering=false
		end)
	end))
end
isTeleporting=false
task.spawn(function()
	local _since=nil
	while true do
		task.wait(1)
		if isTeleporting then
			_since=_since or os.clock()
			if
				os.clock()-math.max(_since,tonumber(_G.ElysiumTPProgressAt)or _since)
				>(tonumber(_G.ElysiumTPWatchdog)or 25)
			then
				_G.ElysiumTPStop=true
				if _G.ElysiumActiveMoveCancel then
					_G.ElysiumActiveMoveCancel()
				end
				_G.ElysiumTPRetryAfter=os.clock()+1.5
				isTeleporting=false
				_G.ElysiumStealHold=false
				_since=nil
				if _G.ElysiumTPDebug==true then
				end
			end
		else
			_since=nil
		end
	end
end)
_G.ElysiumDoClone=doClone
_G.ElysiumIsTeleporting=function()
	return isTeleporting
end
_G.ElysiumReleaseTPForPickup=function()
	local char=LP.Character
	if LP:GetAttribute("Stealing")~=true and not(char and char:GetAttribute("Stealing")==true)then
		return
	end
	if not isTeleporting then
		return
	end
	_G.ElysiumTPStop=true
	if _G.ElysiumActiveMoveCancel then
		_G.ElysiumActiveMoveCancel()
	end
	_G.ElysiumStealHold=false
	_G.ElysiumPickupMotionUntil=os.clock()+.2
	isTeleporting=false
end
LP:GetAttributeChangedSignal("Stealing"):Connect(function()
	if LP:GetAttribute("Stealing")==true and _G.ElysiumClearGoToPlatform then _G.ElysiumClearGoToPlatform()end
	if _G.ElysiumReleaseTPForPickup then
		_G.ElysiumReleaseTPForPickup()
	end
end)
function _isStraightRoute(fromPos,route)
	if not route or#route<=1 then
		return true
	end
	local turns,lastDir,prev=0,nil,fromPos
	for _,wp in ipairs(route)do
		local seg=wp-prev
		if seg.Magnitude>1 then
			local dir=seg.Unit
			if lastDir and dir:Dot(lastDir)<.94 then
				turns=turns+1
			end
			lastDir=dir
		end
		prev=wp
	end
	return turns<=(tonumber(_G.ElysiumStraightMaxTurns)or 1)
end
local _elysiumAnimRestoreAt=0
_G.ElysiumUnwalk=_G.ElysiumUnwalk~=false
local function restoreAnimations()
	_elysiumAnimRestoreAt=os.clock()+3
	task.spawn(function()
		local char=LP.Character
		if not char then
			return
		end
		local hum=char:FindFirstChildOfClass("Humanoid")
		local animate=char:FindFirstChild("Animate")
		if animate and _G.ElysiumUnwalk==false then
			pcall(function()
				animate.Disabled=false
			end)
		end
		if hum then
			pcall(function()
				hum.AutoRotate=true
			end)
			local animator=hum:FindFirstChildOfClass("Animator")
			if animator and _G.ElysiumUnwalk==false then
				pcall(function()
					local tracks=animator:GetPlayingAnimationTracks()
					if tracks then
						for _,t in ipairs(tracks)do
							if
								t.Priority==Enum.AnimationPriority.Core
								or t.Priority==Enum.AnimationPriority.Idle
							then
								pcall(function()
									t:Play(.1)
								end)
							end
						end
					end
				end)
			end
		end
	end)
end
_G.ElysiumTweenTP=false
_G.ElysiumFlingTP=false
_G.ElysiumFlashTP=_G.ElysiumFlashTP==true
_G.ElysiumCFrameTP=false
local function roadBetter(a,b)
	if not a then
		return false
	end
	if not b then
		return true
	end
	local ar,br=math.huge,math.huge
	if _G.ElysiumStealMode~="highest"then
		ar=_priIndexOf(a.index or a.name)or _priIndexOf(a.name)or math.huge
		br=_priIndexOf(b.index or b.name)or _priIndexOf(b.name)or math.huge
	end
	if ar~=br then
		return ar<br
	end
	return(tonumber(a.mps)or 0)>(tonumber(b.mps)or 0)
end
local function roadScanReady()
	if(tonumber(_G.ElysiumScanNoChan)or 0)==0 then
		return true
	end
	local plots=workspace:FindFirstChild("Plots")
	if not plots then
		return false
	end
	for _,plot in ipairs(plots:GetChildren())do
		if not getPlotChannel(plot.Name)then
			local sign=plot:FindFirstChild("PlotSign")
			local label=sign and sign:FindFirstChildWhichIsA("TextLabel",true)
			if not label or label.Text==""then
				return false
			end
			local text=label.Text:gsub("<[^>]+>",""):lower()
			for _,player in ipairs(ElysiumService("Players"):GetPlayers())do
				if
					text:find(player.Name:lower(),1,true)
					or text:find((player.DisplayName or player.Name):lower(),1,true)
				then
					return false
				end
			end
		end
	end
	return true
end
local function roadWinner(bases)
	if not _G.ElysiumGetRoadCandidates then
		_G.ElysiumRoadTPStatus="extras_not_loaded"
		return nil
	end
	if not roadScanReady()then
		_G.ElysiumRoadTPStatus="waiting_owned_bases"
		return nil
	end
	local bestBase,bestRoad
	for _,pet in ipairs(bases or{})do
		if not pet.conveyor and roadBetter(pet,bestBase)then
			bestBase=pet
		end
	end
	local ok,roads=pcall(_G.ElysiumGetRoadCandidates)
	if not ok or type(roads)~="table"then
		_G.ElysiumRoadTPStatus="scanner_error"
		_G.ElysiumRoadTPLastError=tostring(roads)
		if _G.ElysiumRoadLastReportedError~=tostring(roads)then
			_G.ElysiumRoadLastReportedError=tostring(roads)
			warn("[Elysium Road TP] "..tostring(roads))
		end
		return nil
	end
	_G.ElysiumRoadCandidateCount=#roads
	for _,pet in ipairs(roads)do
		if(tonumber(pet.mps)or 0)>=40000000 and roadBetter(pet,bestRoad)then
			bestRoad=pet
		end
	end
	_G.ElysiumRoadBestName=bestRoad and bestRoad.name
	_G.ElysiumRoadBaseBestName=bestBase and bestBase.name
	if roadBetter(bestRoad,bestBase)then
		_G.ElysiumRoadTPStatus="eligible"
		return bestRoad
	end
	_G.ElysiumRoadTPStatus=bestRoad and"base_priority_or_income_better"or"no_visible_road_target"
end
local function roadAllowed()
	return _G.ElysiumAutoTP~=false
		and not _G.ElysiumAutoBuyTPBlocked
		and not _G.Elysium_IsResetting
		and not _G.ElysiumSourceStealActive
		and not _G.ElysiumLaserGrabSession
		and not(type(_G.ElysiumStealTargetUID)=="string"and _G.ElysiumStealTargetUID~="")
end
local function flyToRoad(pet)
	local char=LP.Character
	local root=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if not root or not hum or hum.Health<=0 then
		return false
	end
	if _G.ElysiumGetPhysicalRoot and _G.ElysiumGetPhysicalRoot()~=root then
		return false
	end
	local started,lastPlan,bestAt=os.clock(),-math.huge,os.clock()
	local route,index,previousPosition=nil,1,root.Position
	_G.ElysiumRoadTPActive=true
	_G.ElysiumRoadTPName=pet.name
	_G.ElysiumRoadResumeBase=true
	local ok,result=pcall(function()
		while os.clock()-started<30 do
			if
				not roadAllowed()
				or _G.ElysiumTPStop
				or LP.Character~=char
				or not root.Parent
				or hum.Health<=0
				or LP:GetAttribute("Stealing")==true
			then
				return false
			end
			if
				(tonumber(LP:GetAttribute("RagdollEndTime"))or 0)>workspace:GetServerTimeNow()
				or hum.PlatformStand
			then
				return false
			end
			local position=pet.getPosition()
			if not position then
				return false
			end
			local destination=position+Vector3.new(0,5,0)
			if(root.Position-destination).Magnitude<=6 then
				return true
			end
			if(root.Position-previousPosition).Magnitude>1 then
				previousPosition=root.Position
				bestAt=os.clock()
			elseif os.clock()-bestAt>1.2 then
				_G.ElysiumTPRetryAfter=os.clock()+1.5
				return false
			end
			if os.clock()-lastPlan>=.4 or not route then
				local winner=roadWinner(scanForTP())
				if not winner or winner.uid~=pet.uid then
					return false
				end
				route=computeRoute(root.Position,destination,nil)
				if not route or#route==0 then
					return false
				end
				index=1
				lastPlan=os.clock()
				equipCarpet()
			end
			local goal=route[index]
			while index<#route and(goal-root.Position).Magnitude<=3 do
				index+=1
				goal=route[index]
			end
			local dt=RunService.Heartbeat:Wait()
			if
				not roadAllowed()
				or _G.ElysiumTPStop
				or LP.Character~=char
				or not root.Parent
				or hum.Health<=0
				or LP:GetAttribute("Stealing")==true
			then
				return false
			end
			local delta=goal-root.Position
			local speed=math.min(70,delta.Magnitude*.8/math.max(tonumber(dt)or 1/60,1/240))
			root.AssemblyLinearVelocity=delta.Magnitude>.01 and delta.Unit*speed or Vector3.zero
			root.AssemblyAngularVelocity=Vector3.zero
		end
		return false
	end)
	if root and root.Parent and LP.Character==char then
		root.AssemblyLinearVelocity=Vector3.zero
		root.AssemblyAngularVelocity=Vector3.zero
	end
	_G.ElysiumRoadTPActive=false
	_G.ElysiumRoadTPStatus=ok and(result and"arrived"or"stopped")or"error"
	_G.ElysiumRoadTPLastError=not ok and tostring(result)or nil
	return ok and result
end
local function waitCloneRelocation(request,timeout)
	if not request then
		return false
	end
	local deadline=os.clock()+timeout
	local hardDeadline=deadline+3
	local relocationObserved=false
	local observedAt=nil
	repeat
		if _G.ElysiumTPStop or _G.ElysiumAutoBuyTPBlocked or _G.Elysium_IsResetting then
			return false
		end
		if request.humanoid.Health<=0 then
			return false
		end
		local current=LP.Character
		local root=current and current:FindFirstChild("HumanoidRootPart")
		local hum=current and current:FindFirstChildOfClass("Humanoid")
		if hum and hum.Health<=0 then
			return false
		end
		local ragdollEnd=
			math.max(tonumber(LP:GetAttribute("RagdollEndTime"))or 0,tonumber(_G.ElysiumRagdollObservedUntil)or 0)
		if root and hum and ragdollEnd<=workspace:GetServerTimeNow()then
			local delta=root.Position-request.position
			local horizontal=Vector3.new(delta.X,0,delta.Z).Magnitude
			local consumed=false
			if request.button then
				local ok,value=pcall(function()
					local button=request.button
					if not button.Parent or not button.Visible or not button.Active then
						return true
					end
					local ancestor=button.Parent
					while ancestor and ancestor~=game do
						if ancestor:IsA("GuiObject")and not ancestor.Visible then
							return true
						end
						if ancestor:IsA("ScreenGui")and not ancestor.Enabled then
							return true
						end
						ancestor=ancestor.Parent
					end
					return false
				end)
				consumed=ok and value==true
			end
			local movedLarge=horizontal>=4
			local movedWithUI=consumed and(horizontal>=.75 or math.abs(delta.Y)>=6)
			local shortSwap=horizontal>=2.75 and horizontal<=3.5
				and os.clock()-(request.at or 0)>=.035
			local moved=movedLarge or movedWithUI or shortSwap
			if not relocationObserved and moved then
				relocationObserved=true
				observedAt=os.clock()
				if type(request.onRelocated)=="function"then
					task.spawn(pcall,request.onRelocated)
				end
			end
			_G.ElysiumCloneSettleDiag={
				horizontal=horizontal,vertical=delta.Y,
				settled=not root.Anchored,anchored=root.Anchored,
				remaining=deadline-os.clock(),detected=relocationObserved
			}
			if moved and not root.Anchored then
				_G.ElysiumCloneConfirmReason=movedWithUI and"ui_ack_and_movement"
					or(shortSwap and"short_relocation"or"large_relocation")
				_G.ElysiumCloneRelocationDetectedAt=observedAt or os.clock()
				return true
			end
		end
		RunService.Heartbeat:Wait()
	until os.clock()>=deadline
	return false
end
function elysiumFireFlash(direction)
	local character=LP.Character
	local root=character and character:FindFirstChild("HumanoidRootPart")
	local humanoid=character and character:FindFirstChildOfClass("Humanoid")
	local tool=findTool("Flash Teleport")
	local camera=workspace.CurrentCamera
	if not root or not humanoid or not tool or not camera then
		_G.ElysiumFlashStatus="missing_character_or_flash_tool"
		return false
	end
	if direction.Magnitude<.01 then return false end
	local untilTime=tonumber(tool:GetAttribute("CooldownUntil"))or 0
	if untilTime>workspace:GetServerTimeNow()or tool.Enabled==false then
		_G.ElysiumFlashStatus="cooldown"
		return false
	end
	local oldType,oldFrame,oldSubject=camera.CameraType,camera.CFrame,camera.CameraSubject
	local oldRotate=humanoid.AutoRotate
	local start=root.Position
	local connection
	_G.ElysiumFlashTeleportActive=true
	local ok,result=pcall(function()
		humanoid.AutoRotate=false
		humanoid:EquipTool(tool)
		local equipDeadline=os.clock()+.2
		repeat
			RunService.Heartbeat:Wait()
		until tool.Parent==character or os.clock()>=equipDeadline or _G.ElysiumTPStop
		if tool.Parent~=character or _G.ElysiumTPStop then return false end
		local aim=direction.Unit
		connection=RunService.PreRender:Connect(function()
			if LP.Character~=character or not root.Parent then return end
			local head=character:FindFirstChild("Head")
			local eye=head and head.Position or root.Position
			camera.CameraType=Enum.CameraType.Scriptable
			camera.CFrame=CFrame.lookAlong(eye-aim*12,aim)
		end)
		RunService.PreRender:Wait()
		RunService.PreRender:Wait()
		if _G.ElysiumTPStop or LP.Character~=character then return false end
		if _G.ElysiumFlashBridge then
			if not _G.ElysiumFlashBridge.Activate(tool)then return false end
		else tool:Activate()end
		_G.ElysiumFlashStatus="waiting_relocation"
		local deadline=os.clock()+math.clamp(LP:GetNetworkPing()*4+.6,1,3)
		repeat
			RunService.Heartbeat:Wait()
			if _G.ElysiumTPStop or LP.Character~=character or not root.Parent or humanoid.Health<=0 then
				return false
			end
			if(root.Position-start).Magnitude>=3 then return true end
		until os.clock()>=deadline
		return false
	end)
	if connection then connection:Disconnect()end
	pcall(function()
		camera.CameraType,camera.CFrame,camera.CameraSubject=oldType,oldFrame,oldSubject
		humanoid.AutoRotate=oldRotate
	end)
	_G.ElysiumFlashTeleportActive=false
	if ok and result then _G.ElysiumFlashStatus="relocation_observed"elseif not _G.ElysiumFlashBridge then _G.ElysiumFlashStatus="not_confirmed"end
	if not ok then _G.ElysiumFlashError=tostring(result)end
	return ok and result==true
end
do
		local function loadStandData()
			return table.freeze({[1]={[1]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73,},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[2]={{-2.39,-42.81,.3812,-.0871,.9204,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{27.95,-43.27,-.3759,-.1869,.9076,0},{49.07,-21.49,-.9204,-.0871,.3812,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{46.8,-26.11,-.862700000773,-.0871,.4981,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{52.07,-6.42,-.9962,-.0871,-0,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{2.49,-44.47,.2578,-.0871,.9623,0},{47.06,-26.260000000376,-.8578,-.1373,.4953,0},{51.74,-11.56,-.9877,-.0871,.13,0},},[3]={{52.37,1.22,-.9905,-.1373,-0,0},{46.8,-18.48,-.8627,-.0871,.4981,0},{44.33,-23.07,-.7794,-.1869,.598,0},{52.07,1.22,-.9962,-.0871,-0,0},{50.34,-8.87,-.9653,-.0362,.2587,0},{49.07,-13.86,-.920400000927,-.0871,.3812,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{47.23,-18.73,-.8508,-.1869,.4912,0},{40.89,-26.99,-.6946,-.1869,.6946,0},{40.75,-26.85,-.7004,-.1373,.7004,0},{36.84,-30.27,-.603,-.1373,.7858,0},{40.54,-26.64,-.7044,-.0871,.7044,0},{51.74,-3.93,-.9877,-.0871,.13,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{52.23,-3.99,-.974,-.1869,.1282,0},},[4]={{32.38,-25.73,-.4981,-.0871,.8627,0},{46.8,-11.31,-.8627,-.0871,.4981,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{40.89,-19.82,-.6946,-.1869,.6946,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{50.34,-1.7,-.965300000521,-.0362,.2587,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{40.75,-19.68,-.7004,-.1373,.7004,0},{44.33,-15.9,-.7794,-.1869,.598,0},{36.84,-23.1,-.603,-.1373,.7858,0},{32.53,-25.99,-.4953,-.1373,.8578,0},{32.63,-26.16,-.4912,-.1869,.8508,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{36.97,-23.26,-.598,-.1869,.7794,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{51.02,-1.890000000761,-.9568,-.1373,.2564,0},},[5]={{52.03,17.14,-.9675,-.1869,-.1706,1.750000000363},{49.54,-3.31,-.9308,-.1373,.338800000618,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.060000000399},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.210000000834,1.63,-.9609,-.1869,.2042,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43,},{52.23,6.75,-.980000000254,-.1869,.0685,2.44},{48.7,26.87,-.883,-.1869,-.4306,2.57},},[6]={{-51.77,17.1,.9811,-.0871,-.173,1.72},{-52.07,17.14,.9755,-.1373,-.172,1.73},{-52.27,17.16,.9675,-.1869,-.1706,1.74},{-51.37,17.04,.9811,-.0871,-.173,1.76},{-50.37,22.05,.9474,-.0871,-.3078,2.09},{-50.77,22.15,.942,-.1373,-.306100000455,2.09},{-51.77,6.81,.9938,-.0871,.0695,2.41},{-52.07,6.77,.9881,-.1373,.0691,2.42},{-51.37,6.87,.9938,-.0871,.0695,2.43},{-48.74,26.87,.883,-.1869,-.4306,2.57},{-52.11,11.96,.9938,-.0871,-.0695,2.750000000936},},[7]={{-47.26,27.44,.8508,-.1869,-.4912,0,},{-52.41,7.49,.9905,-.1373,0,0},{-49.570000000798,22.76,.9076,-.1869,-.3759,0},{-48.74,22.41,.9233,-.0362,-.3824,0},{-51.06,17.76,.9568,-.1373,-.2564,0},{-46.83,27.19,.8627,-.0871,-.4981,0},{-49.11,22.56,.9204,-.0871,-.3812,0},{-49.39,22.68,.9151,-.1373,-.3791,0},{-50.77,17.69,.9623,-.0871,-.2578,0},{-47.09,27.34,.8578,-.1373,-.4953,0},{-52.27,12.7,.974,-.1869,-.1282,0},{-51.77,12.63,.9877,-.0871,-.130000000351,0},{-51.37,12.58,.9908,-.0362,-.130400000782,0},{-52.11,7.49,.996200000815,-.0871,0,0},},[8]={{-47.26,-20.09,.8508,-.1869,.4912,0},{-46.83,19.55,.8627,-.0871,-.4981,0},{-47.09,19.7,.8578,-.1373,-.4953,0,},{-44.21,24.02,.7858,-.1373,-.603,0},{-43.97,23.84,.7903,-.0871,-.6064,0},{-44.36,24.14,.7794,-.1869,-.598,0},{-40.78,27.92,.7004,-.1373,-.7004,0},{-40.780000000374,-28.21,.7004,-.1373,.7004,0},{-43.97,-24.13,.7903,-.0871,.6064,0},{-40.92,-28.35,.6946,-.1869,.6946,0},},[9]={{-47.26,-27.26,.8508,-.1869,.4912,0},{7.23,-41.86,-.4912,-.1869,.8508,0},{-22.99,-45.66,.2564,-.1373,.9568,0},{-27.79,-43.71,.3812,-.0871,.9204,0},{-2.52,-45.37,-.2578,-.0871,.9623,0},{-22.91,-45.37,.2578,-.0871,.9623,0},{2.47,-43.99,-.3791,-.1373,.9151,0},{2.55,-44.17,-.3759,-.1869,.9076,0},{-49.39,-22.51,.9151,-.1373,.3791,0},{-49.11,-22.39,.9204,-.0871,.3812,0},{-50.77,-17.51,.9623,-.0871,.2578,0},{-51.06,-17.59,.9568,-.1373,.2564,0},{-48.74,-22.24,.9233,-.0362,.3824,0},{-49.57,-22.58,.9076,-.1869,.3759,0},{-51.37,-12.4,.9908,-.0362,.1304,0},{-27.91,-43.99,.3791,-.137300000178,.9151,0},},[10]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[11]={{51.74,-16.03,-.9811,-.0871,.173,1.72,},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73,},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.340000000287,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.730000000913,-21.08,-.942,-.1373,.3061,2.090000000361},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[12]={{-2.39,-42.81,.3812,-.0871,.9204,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{27.95,-43.270000000706,-.3759,-.1869,.9076,0},{49.07,-21.49,-.9204,-.0871,.3812,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{46.8,-26.11,-.8627,-.0871,.4981,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{-2.58,-43.27,.375900000456,-.1869,.9076,0},{52.07,-6.42,-.9962,-.0871,-0,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{2.49,-44.47,.2578,-.0871,.9623,0},{47.06,-26.26,-.8578,-.1373,.4953,0},{51.74,-11.56,-.9877,-.0871,.130000000642,0},},[13]={{52.37,1.22,-.9905,-.1373,-0,0},{46.8,-18.48,-.8627,-.0871,.4981,0},{44.33,-23.07,-.7794,-.1869,.598,0},{52.07,1.22,-.9962,-.0871,-0,0},{50.34,-8.87,-.9653,-.0362,.2587,0},{49.07,-13.86,-.920400000522,-.0871,.3812,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{47.23,-18.73,-.8508,-.1869,.4912,0},{40.89,-26.99,-.6946,-.1869,.6946,0},{40.75,-26.85,-.7004,-.1373,.7004,0},{36.84,-30.27,-.603,-.1373,.7858,0},{40.54,-26.640000000827,-.7044,-.0871,.7044,0},{51.74,-3.93,-.9877,-.0871,.13,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{52.030000000213,-3.96,-.9821,-.1373,.1293,0},{52.23,-3.99,-.974,-.1869,.1282,0},},[14]={{32.38,-25.73,-.4981,-.0871,.8627,0},{46.8,-11.31,-.8627,-.0871,.498100000593,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{40.89,-19.82,-.6946,-.1869,.6946,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{50.34,-1.7,-.9653,-.0362,.2587,0},{49.070000000649,-6.69,-.9204,-.0871,.3812,0},{40.75,-19.68,-.7004,-.1373,.7004,0},{44.33,-15.9,-.7794,-.1869,.598,0},{36.84,-23.1,-.603,-.1373,.7858,0},{32.53,-25.99,-.4953,-.1373,.8578,0},{32.63,-26.16,-.4912,-.1869,.8508,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{36.97,-23.26,-.598,-.1869,.7794,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{51.02,-1.89,-.9568,-.1373,.2564,0},},[15]={{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43,},{52.23,6.75,-.98,-.1869,.0685,2.44},{48.7,26.87,-.883,-.1869,-.4306,2.57},},[16]={{-51.77,-16.030000000167,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173000000723,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.580000000252,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[17]={{-47.26,-27.4,.8508,-.1869,.4912,0},{-2.52,-45.5,-.2578,-.0871,.9623,0},{-22.99,-45.79,.2564,-.1373,.9568,0},{-27.79,-43.85,.3812,-.0871,.9204,0},{7.23,-42,-.4912,-.1869,.8508,0},{-22.91,-45.5,.2578,-.0871,.9623,0},{2.47,-44.12,-.3791,-.1373,.9151,0},{2.55,-44.31,-.3759,-.1869,.9076,0,},{-49.39,-22.64,.9151,-.1373,.3791,0},{-49.11,-22.53,.9204,-.0871,.3812,0},{-50.77,-17.65,.9623,-.0871,.2578,0},{-51.06,-17.73,.9568,-.1373,.256400000308,0},{-48.74,-22.37,.9233,-.0362,.382400000792,0},{-49.57,-22.72,.9076,-.1869,.3759,0},{-51.37,-12.54,.9908,-.0362,.1304,0},{-27.91,-44.12,.3791,-.137300000414,.9151,0},},[18]={{-47.26,-19.4,.8508,-.1869,.4912,0},{-47.09,-19.3,.8578,-.1373,.4953,0},{-49.39,15.74,.9151,-.1373,-.3791,0},{-46.83,20.24,.8627,-.0871,-.4981,0},{-43.97,24.53,.7903,-.0871,-.6064,0},{-44.36,24.83,.7794,-.1869,-.598,0},{-44.21,24.71,.7858,-.1373,-.603,0},{-47.09,20.39,.8578,-.1373,-.4953,0},{-49.11,15.62,.9204,-.0871,-.3812,0},{-40.78,-27.52,.7004,-.1373,.7004,0},{-40.78,28.61,.7004,-.1373,-.7004,0},{-43.97,-23.43,.7903,-.0871,.6064,0},},[19]={{39.76,3.72,-.8114,.4595,-.3613,3.61},{42.95,.62,-.8809,.4002,-.2526,3.93},{44.16,1.12,-.9032,.3422,-.259,4.01},{41.57,.05,-.8618,.4595,-.2149,4.82},{39.72,8.83,-.7937,.4002,-.4582,5.11},},[20]={{39.76,-22.09,-.7937,.4002,.4582,0},{43.68,-2.37,-.908600000643,.4002,-.1196,0,},{42.88,1.64,-.8852,.4002,-.2372,0},{44.33,2.03,-.9076,.3422,-.2432,0,},{43.68,-10.53,-.9086,.4002,.1196,0},{43.95,-6.45,-.9164,.4002,-0,0,},{44.33,-14.93,-.9076,.3422,.2432,0},{42.88,-14.54,-.8852,.4002,.2372,0},{39.76,9.18,-.7937,.4002,-.4582,0},{41.57,5.51,-.8467,.4002,-.3507,0},{41.57,-18.42,-.8467,.4002,.3507,0},},[21]={{39.76,-13.85,-.7937,.4002,.4582,0},{39.76,17.42,-.7937,.4002,-.4582,0},},[22]={{41.23,1.95,-.8618,.4595,.2149,.520000000195,},{41.23,17.25,-.8538,.4595,-.2448,.52},{42.88,17.69,-.8809,.4002,-.2526,.55},{42.88,1.51,-.8892,.4002,.2217,.55},{44.33,1.12,-.9117,.3422,.2273,.57},{39.99,20.91,-.8114,.4595,-.3613,.77},{41.99,5.74,-.8833,.4595,.0928,.77},{43.68,5.52,-.9114,.4002,.0958,.82},{41.57,21.57,-.8372,.4002,-.3728,.82},{45.16,5.32,-.9345,.3422,.0982,.86},{42.24,9.6,-.8876,.4595,-.031,1.03},{43.95,9.6,-.9159,.4002,-.032,1.09},{39.76,-6.03,-.8092,.4002,.4302,1.09},{39.99,-1.71,-.8346,.4595,.3038,1.29},{41.990000000731,13.46,-.8747,.4595,-.1542,1.29},{41.57,-2.36,-.8612,.4002,.3134,1.36},},[23]={{39.76,-3.68,-.8114,.4595,.3613,3.61},{41.05,-4.43,-.8372,.4002,.3728,3.67},{42.950000000193,-.58,-.8809,.4002,.2526,3.93},{44.16,-1.09,-.9032,.3422,.259,4.01},{41.57,-.01,-.8618,.4595,.2149,4.82},{39.72,-8.79,-.7937,.4002,.4582,5.11},},[24]={{-42.83,.62,.8809,.4002,-.2526,3.93},{-44.04,1.120000000103,.9032,.3422,-.259,4.01},},[25]={{-41.87,-1.64,.8795,.4595,-.1236,.26},{-41.45,-17.47,.8497,.4002,.3433,.27},{-41.11,-13.15,.8618,.4595,.2149,.52},{-42.76,2.59,.8809,.4002,-.2526,.55},{-42.76,-13.59,.8892,.4002,.2217,.55},{-44.21,-13.98,.9117,.3422,.227300000932,.570000000864},{-41.87,-9.36,.8833,.4595,.0928,.77},{-43.56,-9.58,.9114,.4002,.0958,.82},{-45.04,-9.78,.9345,.3422,.0982,.86},{-42.12,-5.5,.8876,.4595,-.031,1.03},{-43.83,-5.5,.9159,.4002,-.032,1.09},{-43.56,-1.42,.9025,.4002,-.1591,1.36},},[26]={{-42.76,-5.59,.8892,.4002,.2217,.55},{-43.56,-1.58,.9114,.4002,.0958,.82},{-43.83,2.5,.9159,.4002,-.032,1.09},{-41.45,-9.47,.8612,.400200000299,.3134,1.36},{-41.11,-5.15,.8688,.4595,.1847,1.55},},[27]={{-40.93,-6.38,.8372,.4002,.3728,3.67}},[28]={{-42.07,-5.08,.8612,.4002,.3134,6.35}},},[2]={[1]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{49.35,4.31,-.9308,-.1373,-.3388,1.73},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09,},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.207100000852,2.090000000148},{50.73,-21.080000000138,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[2]={{27.95,-43.27,-.3759,-.1869,.9076,0},{2.49,-44.47,.2578,-.0871,.9623,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{49.54,-21.68,-.9076,-.1869,.3759,0},{49.07,-21.49,-.9204,-.0871,.3812,0},{32.53,27.96,-.4953,-.1373,-.8578,0},{27.870000000918,-43.09,-.3791,-.1373,.9151,0},{49.35,-21.61,-.9151,-.1373,.3791,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{-2.580000000441,-43.27,.3759,-.1869,.907600000554,0},{-2.39,-42.81,.3812,-.0871,.9204,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{22.95,-44.76,-.2564,-.137300000153,.9568,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{36.84,25.07,-.603,-.1373,-.7858,0},},[3]={{52.23,-3.99,-.974,-.1869,.128200000178,0},{49.07,-13.86,-.9204,-.0871,.3812,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{49.35,-13.97,-.9151,-.1373,.3791,0},{49.54,-14.05,-.9076,-.1869,.3759,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{47.23,-18.73,-.8508,-.1869,.4912,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{51.74,-3.93,-.9877,-.0871,.130000000322,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{51.02,-9.06,-.9568,-.1373,.2564,0,},{40.54,29.07,-.7044,-.0871,-.7044,0},{40.75,29.28,-.7004,-.137300000601,-.7004,0},{36.84,-30.27,-.603,-.1373,.7858,0},{36.66,-30.040000000458,-.6064,-.0871,.7903,0},{46.8,-18.48,-.8627,-.0871,.4981,0},},[4]={{52.23,3.18,-.974,-.1869,.1282,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{49.350000000136,-6.8,-.9151,-.1373,.3791,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{52.03,3.21,-.9821,-.1373,.1293,0},{49.54,-6.88,-.9076,-.1869,.3759,0},{32.53,-25.99,-.4953,-.1373,.8578,0},{51.74,3.25,-.9877,-.0871,.13,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{51.020000000624,-1.89,-.9568,-.1373,.2564,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{47.06,-11.46,-.8578,-.1373,.4953,0},{44.33,-15.9,-.7794,-.1869,.598000000216,0},{32.380000000498,-25.73,-.498100000354,-.0871,.8627,0},{46.8,-11.31,-.8627,-.0871,.4981,0},},[5]={{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43,},{52.23,6.75,-.98,-.1869,.0685,2.44},{48.7,26.87,-.883,-.1869,-.4306,2.57},},[6]={{-51.77,17.1,.9811,-.0871,-.173,1.72},{-52.07,17.14,.9755,-.1373,-.172,1.73},{-52.27,17.16,.9675,-.1869,-.1706,1.74},{-51.37,17.04,.9811,-.0871,-.173,1.76},{-50.37,22.05,.9474,-.0871,-.3078,2.09},{-50.77,22.15,.942,-.1373,-.3061,2.09},{-51.77,6.81,.9938,-.0871,.0695,2.41},{-52.07,6.77,.9881,-.1373,.0691,2.42},{-51.37,6.87,.9938,-.0871,.0695,2.43},{-48.74,26.87,.883,-.1869,-.4306,2.57},{-52.11,11.96,.9938,-.0871,-.0695,2.75},},[7]={{-49.57,22.76,.9076,-.1869,-.375900000795,0,},{-47.09,27.34,.8578,-.1373,-.4953,0},{-51.77,12.63,.9877,-.0871,-.13,0,},{-49.39,22.68,.9151,-.1373,-.3791,0},{-47.26,27.44,.8508,-.1869,-.4912,0},{-49.11,22.56,.9204,-.0871,-.3812,0},{-52.07,12.67,.9821,-.1373,-.1293,0},{-51.25,17.81,.9489,-.1869,-.2543,0},{-52.110000000533,7.49,.9962,-.0871,0,0},{-52.27,12.7,.974,-.1869,-.1282,0,},{-52.41,7.49,.9905,-.1373,0,0},{-50.77,17.69,.9623,-.0871,-.2578,0},},[8]={{-47.09,19.7,.8578,-.1373,-.4953,0},{-43.97,-24.13,.7903,-.0871,.6064,0},{-40.92,-28.35,.6946,-.1869,.6946,0},{-47.26,-20.09,.8508,-.1869,.4912,0},{-47.09,-19.99,.8578,-.1373,.4953,0},{-43.97,23.84,.7903,-.0871,-.6064,0},{-40.92,28.06,.6946,-.1869,-.6946,0,},{-44.36,24.14,.7794,-.1869,-.598,0},{-44.21,24.02,.7858,-.1373,-.603,0},{-46.83,19.55,.8627,-.0871,-.4981,0},{-40.78,-28.21,.7004,-.1373,.7004,0},},[9]={{-51.25,-17.64,.9489,-.1869,.2543,0},{-47.09,-27.16,.8578,-.1373,.4953,0},{-22.99,-45.66,.2564,-.1373,.9568,0},{-23.04,-45.85,.2543,-.1869,.9489,0},{-47.260000000479,-27.26,.8508,-.1869,.4912,0},{-52.07,-12.5,.9821,-.1373,.1293,0},{-49.57,-22.58,.9076,-.1869,.3759,0},{-49.39,-22.51,.9151,-.1373,.3791,0},{-2.52,-45.37,-.2578,-.0871,.9623,0},{-49.11,-22.39,.9204,-.0871,.381200000497,0},{-52.27,-12.52,.974,-.1869,.1282,0},},[10]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.740000000888,-25.800000000342,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.770000000603},{-12.72,-50.28,.0691,-.1373,.988100000327,2.78},},[11]={{51.74,-16.03,-.9811,-.0871,.173,1.72,},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{49.35,4.31,-.9308,-.137300000502,-.3388,1.73},{52.03,-16.06,-.9755,-.1373,.172,1.73,},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.760000000845},{50.73,-.690000000942,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[12]={{27.95,-43.27,-.3759,-.1869,.9076,0},{2.49,-44.47,.2578,-.0871,.9623,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{49.54,-21.68,-.9076,-.1869,.3759,0},{49.07,-21.49,-.9204,-.0871,.3812,0},{32.53,27.96,-.4953,-.1373,-.8578,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{49.35,-21.61,-.9151,-.1373,.3791,0},{47.23,-26.36,-.8508,-.1869,.491200000939,0},{-2.58,-43.27,.3759,-.1869,.907600000413,0},{-2.39,-42.81,.3812,-.0871,.9204,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{36.84,25.07,-.603,-.1373,-.7858,0},},[13]={{52.23,-3.99,-.974,-.1869,.1282,0},{49.07,-13.86,-.9204,-.0871,.3812,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{49.35,-13.97,-.9151,-.1373,.3791,0,},{49.54,-14.05,-.9076,-.1869,.3759,0},{43.93,-22.76,-.7903,-.0871,.6064,0,},{47.23,-18.73,-.8508,-.1869,.4912,0},{50.730000000434,-8.98,-.9623,-.0871,.2578,0},{51.74,-3.93,-.9877,-.0871,.13,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{51.02,-9.06,-.9568,-.1373,.2564,0},{40.54,29.07,-.7044,-.0871,-.7044,0},{40.75,29.28,-.7004,-.1373,-.7004,0},{36.84,-30.27,-.603,-.1373,.7858,0},{36.66,-30.04,-.6064,-.0871,.7903,0},{46.8,-18.48,-.8627,-.0871,.4981,0},},[14]={{52.23,3.18,-.974,-.1869,.1282,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{49.35,-6.8,-.9151,-.1373,.3791,0},{43.93,-15.59,-.7903,-.0871,.606400000547,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{52.03,3.21,-.9821,-.1373,.1293,0},{49.54,-6.88,-.9076,-.1869,.3759,0},{32.53,-25.99,-.4953,-.1373,.8578,0},{51.74,3.25,-.9877,-.0871,.13,0},{50.73,-1.81,-.9623,-.0871,.257800000653,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{47.06,-11.46,-.8578,-.1373,.4953,0},{44.330000000947,-15.9,-.7794,-.1869,.598,0},{32.38,-25.73,-.4981,-.0871,.8627,0},{46.8,-11.31,-.8627,-.0871,.4981,0},},[15]={{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.968900000636,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09,},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42,},{51.33,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.0685,2.44},{48.7,26.87,-.883,-.1869,-.4306,2.570000000784},},[16]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[17]={{-51.25,-17.78,.9489,-.1869,.254300000528,0},{-47.09,-27.3,.8578,-.1373,.4953,0},{-22.99,-45.79,.2564,-.1373,.9568,0},{-23.04,-45.98,.254300000258,-.1869,.9489,0},{-47.26,-27.4,.8508,-.1869,.4912,0},{-52.07,-12.63,.9821,-.1373,.1293,0},{-49.57,-22.72,.9076,-.1869,.3759,0},{-49.39,-22.64,.9151,-.1373,.3791,0},{-2.52,-45.5,-.2578,-.0871,.9623,0},{-49.11,-22.53,.9204,-.0871,.3812,0},{-52.27,-12.660000000951,.974,-.1869,.1282,0},},[18]={{-47.09,20.39,.8578,-.1373,-.4953,0},{-40.92,-27.66,.6946,-.1869,.6946,0},{-40.92,28.76,.6946,-.1869,-.6946,0},{-49.39,15.74,.9151,-.1373,-.3791,0},{-49.11,15.62,.9204,-.0871,-.3812,0},{-43.97,-23.43,.7903,-.0871,.6064,0},{-43.97,24.53,.7903,-.0871,-.6064,0},{-47.09,-19.3,.8578,-.1373,.4953,0},{-46.83,20.24,.8627,-.0871,-.4981,0},{-44.36,24.83,.7794,-.1869,-.598,0},{-44.21,24.71,.7858,-.1373,-.603,0},},[19]={{39.76,3.72,-.8114,.4595,-.3613,3.61},{42.95,.62,-.8809,.4002,-.2526,3.93,},{44.16,1.12,-.9032,.3422,-.259,4.01},{41.57,.05,-.8618,.4595,-.2149,4.82},{39.72,8.83,-.7937,.4002,-.4582,5.11},},[20]={{39.76,-22.09,-.7937,.4002,.4582,0},{43.68,-2.37,-.9086,.4002,-.1196,0},{43.68,-10.53,-.9086,.4002,.1196,0},{39.76,9.18,-.7937,.4002,-.4582,0},{42.88,-14.54,-.8852,.4002,.2372,0},{41.57,-18.42,-.846700000313,.4002,.3507,0},{43.95,-6.45,-.9164,.4002,-0,0},{41.57,5.51,-.8467,.4002,-.3507,0},{42.88,1.64,-.8852,.4002,-.2372,0},{44.33,-14.93,-.9076,.3422,.2432,0},{44.33,2.03,-.9076,.3422,-.2432,0,},},[21]={{39.76,-13.85,-.7937,.4002,.4582,0},{39.76,17.42,-.7937,.4002,-.4582,0},},[22]={{41.23,1.95,-.8618,.4595,.2149,.52},{41.23,17.25,-.8538,.4595,-.2448,.52},{42.88,17.69,-.8809,.4002,-.2526,.55},{42.88,1.51,-.8892,.4002,.2217,.55},{44.33,1.12,-.9117,.3422,.2273,.57},{39.99,20.91,-.8114,.4595,-.3613,.77},{41.99,5.74,-.8833,.4595,.0928,.77},{43.68,5.52,-.9114,.4002,.0958,.82},{41.570000000676,21.57,-.8372,.4002,-.3728,.82},{45.16,5.32,-.9345,.3422,.0982,.86},{42.24,9.6,-.8876,.4595,-.031,1.03},{43.95,9.6,-.9159,.4002,-.032,1.09},{39.76,-6.03,-.809200000934,.4002,.4302,1.09},{39.99,-1.71,-.8346,.4595,.3038,1.29},{41.99,13.460000000573,-.8747,.4595,-.1542,1.29},{41.57,-2.36,-.8612,.4002,.3134,1.360000000623},},[23]={{39.76,-3.68,-.8114,.4595,.3613,3.61},{41.05,-4.43,-.8372,.4002,.3728,3.67},{42.95,-.58,-.8809,.4002,.2526,3.93},{44.16,-1.09,-.9032,.3422,.259,4.01},{41.57,-.01,-.8618,.4595,.2149,4.82},{39.72,-8.79,-.7937,.4002,.4582,5.11},},[24]={{-42.83,.62,.8809,.4002,-.2526,3.93},{-44.04,1.120000000837,.9032,.3422,-.259,4.010000000502},},[25]={{-41.87,-1.64,.8795,.4595,-.1236,.26},{-41.45,-17.47,.849700000437,.4002,.3433,.27},{-41.11,-13.15,.8618,.4595,.2149,.52},{-42.76,2.59,.8809,.4002,-.2526,.55},{-42.76,-13.59,.8892,.4002,.2217,.55},{-44.21,-13.98,.9117,.3422,.2273,.57},{-41.87,-9.36,.8833,.4595,.0928,.77},{-43.56,-9.58,.9114,.4002,.0958,.82},{-45.04,-9.78,.9345,.3422,.0982,.86},{-42.12,-5.5,.8876,.4595,-.031,1.03},{-43.83,-5.5,.9159,.4002,-.032,1.09},{-43.56,-1.42,.9025,.4002,-.1591,1.36},},[26]={{-42.76,-5.59,.8892,.4002,.2217,.55},{-43.560000000305,-1.58,.9114,.4002,.0958,.82},{-43.83,2.5,.9159,.4002,-.032,1.09},{-41.45,-9.47,.8612,.4002,.3134,1.36},{-41.11,-5.15,.8688,.4595,.1847,1.55},},[27]={{-40.93,-6.38,.8372,.4002,.3728,3.67}},[28]={{-42.07,-5.08,.8612,.4002,.3134,6.35}},},[3]={[1]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.730000000451},{49.35,4.31,-.9308,-.1373,-.3388,1.73,},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.970000000571,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[2]={{2.49,-44.47,.2578,-.0871,.9623,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{50.34,-16.51,-.9653,-.0362,.258700000448,0},{48.700000000529,-21.34,-.9233,-.0362,.3824,0},{49.07,-21.49,-.9204,-.0871,.381200000782,0},{51.74,-11.56,-.9877,-.0871,.13,0},{51.02,-16.690000000118,-.9568,-.1373,.2564,0},{50.73,-16.61,-.9623,-.0871,.2578,0},{49.35,-21.61,-.9151,-.1373,.3791,0,},{49.54,-21.68,-.9076,-.1869,.3759,0},},[3]={{47.23,-18.73,-.8508,-.1869,.4912,0},{36.84,-30.27,-.603,-.1373,.7858,0},{49.35,-13.97,-.9151,-.1373,.3791,0},{36.97,-30.43,-.598,-.1869,.7794,0},{49.07,-13.86,-.9204,-.0871,.3812,0},{48.7,-13.7,-.9233,-.0362,.3824,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{51.02,-9.06,-.9568,-.1373,.2564,0},{49.54,-14.05,-.9076,-.1869,.3759,0},{51.74,-3.93,-.9877,-.0871,.13,0},{51.33,-3.87,-.9908,-.0362,.1304,0},{52.23,-3.99,-.974,-.1869,.1282,0},{46.8,-18.48,-.8627,-.0871,.4981,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{47.06,-18.63,-.8578,-.1373,.4953,0},{40.89,-26.99,-.6946,-.1869,.6946,0},},[4]={{32.63,-26.160000000439,-.4912,-.1869,.8508,0},{36.84,-23.1,-.603,-.1373,.7858,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{49.54,-6.88,-.9076,-.1869,.3759,0},{47.06,-11.46,-.8578,-.1373,.4953,0},{46.8,-11.31,-.8627,-.0871,.4981,0},{49.35,-6.8,-.9151,-.1373,.3791,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{48.7,-6.53,-.9233,-.0362,.3824,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{51.33,3.3,-.9908,-.0362,.1304,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{44.33,-15.9,-.7794,-.1869,.598,0},{44.17,-15.78,-.7858,-.1373,.603,0},{32.38,-25.73,-.4981,-.0871,.8627,0},},[5]={{46.44,31.45,-.8331,-.1869,-.5206,1.65},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.340000000221,1.86,-.9744,-.0871,.2071,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.73,22.15,-.942,-.137300000894,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41,},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.0685,2.44,},},[6]={{-46.48,31.45,.8331,-.1869,-.5206,1.65},{-51.770000000116,17.1,.9811,-.0871,-.173,1.720000000759},{-52.07,17.14,.9755,-.1373,-.172,1.73},{-51.37,17.04,.9811,-.0871,-.173,1.76},{-50.37,22.05,.9474,-.0871,-.3078,2.09},{-50.77,22.15,.942,-.1373,-.306100000594,2.09},{-51.77,6.81,.993800000344,-.0871,.0695,2.41},{-52.07,6.77,.9881,-.1373,.0691,2.42},{-51.37,6.87,.9938,-.0871,.0695,2.43},{-48.74,26.87,.883,-.1869,-.4306,2.57},{-52.11,11.96,.9938,-.0871,-.0695,2.75},},[7]={{-50.37,17.58,.9653,-.0362,-.2587,0},{-43.97,31.47,.7903,-.0871,-.6064,0},{-46.48,26.98,.8655,-.0362,-.4997,0},{-52.410000000503,7.49,.9905,-.1373,0,0},{-52.11,7.49,.9962,-.0871,0,0},{-51.25,17.81,.9489,-.1869,-.2543,0},{-50.770000000672,17.69,.9623,-.0871,-.2578,0},{-51.06,17.76,.9568,-.137300000839,-.2564,0},{-52.27,12.7,.974,-.1869,-.1282,0},{-51.77,12.63,.9877,-.0871,-.13,0},{-47.09,27.34,.857800000293,-.1373,-.4953,0},{-47.26,27.440000000258,.8508,-.1869,-.4912,0},},[8]={{-40.92,-28.35,.6946,-.1869,.6946,0},{-40.78,27.92,.7004,-.1373,-.7004,0},{-47.09,19.7,.8578,-.1373,-.4953,0},{-47.26,-20.09,.8508,-.1869,.4912,0},{-43.97,-24.13,.7903,-.0871,.6064,0},{-44.36,-24.43,.7794,-.1869,.598,0},{-40.78,-28.21,.7004,-.1373,.7004,0},{-40.92,28.06,.6946,-.186900000558,-.6946,0},{-47.09,-19.99,.8578,-.1373,.4953,0},{-44.21,-24.31,.7858,-.1373,.603,0},{-44.21,24.02,.7858,-.1373,-.603,0},{-44.36,24.14,.7794,-.1869,-.598,0},{-43.97,23.84,.7903,-.0871,-.6064,0},},[9]={{-2.52,-45.37,-.2578,-.0871,.9623,0},{-27.79,-43.71,.381200000769,-.0871,.9204,0},{-27.98,-44.17,.375900000894,-.1869,.9076,0},{6.98,-41.43,-.4981,-.0871,.8627,0},{-47.26,-27.26,.850800000756,-.1869,.4912,0},{-49.11,-22.39,.9204,-.0871,.3812,0},{-46.83,-27.01,.8627,-.0871,.4981,0},{7.13,-41.69,-.4953,-.1373,.8578,0},{-27.91,-43.99,.3791,-.1373,.9151,0},{-22.91,-45.37,.2578,-.0871,.9623,0},{2.47,-43.99,-.3791,-.1373,.9151,0},{7.23,-41.86,-.4912,-.1869,.8508,0},{2.55,-44.17,-.3759,-.1869,.9076,0},{2.36,-43.71,-.3812,-.0871,.9204,0},{-22.99,-45.66,.2564,-.1373,.9568,0},},[10]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.975500000372,-.137300000308,.172000000928,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.090000000593},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[11]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72,},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73},{49.54,4.38,-.9231,-.186900000771,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.170600000583,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09,},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[12]={{2.49,-44.47,.2578,-.0871,.9623,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{-7.26,-40.970000000592,.4912,-.1869,.8508,0},{27.76,-42.81,-.3812,-.0871,.9204,0,},{22.95,-44.76,-.256400000707,-.1373,.9568,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{50.34,-16.51,-.9653,-.0362,.2587,0},{48.7,-21.34,-.9233,-.0362,.3824,0},{49.07,-21.49,-.9204,-.0871,.3812,0},{51.74,-11.56,-.9877,-.0871,.13,0},{51.02,-16.69,-.9568,-.1373,.2564,0},{50.73,-16.61,-.9623,-.0871,.2578,0},{49.35,-21.61,-.9151,-.1373,.3791,0},{49.54,-21.68,-.9076,-.1869,.3759,0},},[13]={{47.23,-18.73,-.8508,-.1869,.4912,0},{36.84,-30.27,-.603000000577,-.1373,.7858,0,},{49.35,-13.97,-.9151,-.1373,.3791,0},{36.97,-30.43,-.598,-.1869,.7794,0,},{49.07,-13.86,-.9204,-.0871,.3812,0},{48.7,-13.7,-.9233,-.0362,.3824,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{51.02,-9.06,-.9568,-.1373,.2564,0},{49.54,-14.05,-.9076,-.1869,.3759,0},{51.74,-3.93,-.9877,-.0871,.13,0},{51.33,-3.87,-.9908,-.0362,.1304,0},{52.23,-3.99,-.974,-.1869,.1282,0},{46.8,-18.48,-.8627,-.0871,.4981,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{47.06,-18.63,-.8578,-.1373,.4953,0},{40.89,-26.99,-.6946,-.1869,.694600000619,0},},[14]={{32.63,-26.16,-.4912,-.1869,.8508,0},{36.84,-23.1,-.603,-.1373,.7858,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{49.54,-6.88,-.907600000295,-.1869,.3759,0},{47.06,-11.460000000665,-.8578,-.1373,.4953,0},{46.8,-11.31,-.8627,-.0871,.4981,0},{49.35,-6.8,-.9151,-.1373,.3791,0,},{49.07,-6.69,-.9204,-.0871,.3812,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{48.7,-6.53,-.923300000886,-.0362,.3824,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{51.33,3.3,-.9908,-.0362,.1304,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{44.33,-15.9,-.7794,-.1869,.598,0},{44.17,-15.78,-.7858,-.1373,.603,0},{32.38,-25.73,-.4981,-.0871,.8627,0,},},[15]={{46.44,31.45,-.8331,-.1869,-.5206,1.65},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{51.330000000531,17.040000000747,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,1.860000000138,-.9744,-.0871,.2071,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09,},{50.73,22.15,-.942000000764,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42,},{51.33,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.0685,2.44},},[16]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.270000000173,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[17]={{-2.52,-45.5,-.2578,-.0871,.9623,0},{-27.790000000901,-43.85,.3812,-.0871,.9204,0},{-27.98,-44.310000000437,.3759,-.1869,.9076,0},{6.98,-41.57,-.4981,-.0871,.8627,0},{-47.26,-27.4,.8508,-.1869,.4912,0},{-49.11,-22.53,.9204,-.0871,.3812,0},{-46.83,-27.15,.8627,-.0871,.4981,0,},{7.13,-41.83,-.4953,-.1373,.8578,0},{-27.91,-44.12,.3791,-.1373,.9151,0},{-22.91,-45.5,.2578,-.0871,.9623,0},{2.47,-44.12,-.3791,-.1373,.9151,0},{7.23,-42,-.4912,-.1869,.8508,0},{2.55,-44.31,-.3759,-.1869,.9076,0},{2.36,-43.85,-.3812,-.0871,.9204,0},{-22.99,-45.79,.256400000506,-.1373,.9568,0},},[18]={{-40.92,-27.66,.6946,-.1869,.6946,0},{-46.48,20.04,.8655,-.0362,-.4997,0},{-43.97,24.53,.7903,-.0871,-.6064,0},{-47.26,-19.4,.8508,-.1869,.4912,0},{-43.97,-23.43,.7903,-.0871,.6064,0},{-40.78,-27.52,.7004,-.1373,.7004,0,},{-44.360000000294,-23.74,.7794,-.1869,.598,0},{-47.09,20.39,.8578,-.1373,-.4953,0},{-47.09,-19.3,.857800000849,-.1373,.4953,0},{-44.21,-23.62,.7858,-.1373,.603,0},{-40.78,28.61,.7004,-.1373,-.7004,0},{-44.21,24.71,.7858,-.1373,-.603,0},},[19]={{39.76,3.72,-.8114,.459500000674,-.3613,3.61},{42.95,.62,-.8809,.4002,-.2526,3.93},{44.16,1.12,-.9032,.3422,-.259000000907,4.01},{41.57,.05,-.8618,.4595,-.2149,4.82},{39.72,8.83,-.7937,.4002,-.4582,5.11},},[20]={{43.95,-6.45,-.9164,.4002,0,0},{41.99,-2.59,-.8806,.459500000414,-.1159,0},{42.88,1.64,-.8852,.4002,-.2372,0},{44.33,-14.93,-.9076,.3422,.2432,0},{41.99,-10.31,-.8806,.4595,.1159,0},{44.33,2.03,-.9076,.3422,-.2432,0},{42.88,-14.54,-.8852,.4002,.2372,0},{42.24,-6.45,-.8882,.4595,0,0},{43.68,-2.37,-.9086,.4002,-.1196,0},{39.76,-22.09,-.7937,.400200000212,.4582,0},{43.68,-10.53,-.9086,.4002,.1196,0},{41.57,5.51,-.8467,.4002,-.3507,0},{41.57,-18.42,-.8467,.4002,.3507,0,},{39.76,9.18,-.7937,.4002,-.4582,0},},[21]={{39.76,-13.85,-.7937,.4002,.4582,0},{39.76,17.42,-.7937,.4002,-.4582,0},},[22]={{41.23,1.95,-.8618,.4595,.2149,.52},{41.23,17.25,-.8538,.4595,-.2448,.52},{42.88,17.69,-.8809,.4002,-.2526,.55},{42.88,1.51,-.8892,.4002,.221700000764,.55},{44.33,1.12,-.9117,.3422,.2273,.57},{41.99,5.74,-.8833,.4595,.0928,.77},{39.99,20.91,-.8114,.4595,-.3613,.77},{41.57,21.57,-.8372,.4002,-.3728,.82},{43.68,5.52,-.9114,.4002,.0958,.82},{45.16,5.32,-.9345,.3422,.0982,.86},{42.24,9.6,-.8876,.4595,-.031,1.03},{39.76,-6.03,-.8092,.4002,.4302,1.09},{43.95,9.600000000593,-.9159,.4002,-.032,1.09},{39.99,-1.71,-.8346,.4595,.3038,1.29},{41.99,13.46,-.8747,.4595,-.1542,1.29},{41.57,-2.36,-.8612,.4002,.3134,1.36,},},[23]={{39.76,-3.68,-.8114,.4595,.3613,3.61},{41.05,-4.43,-.8372,.4002,.3728,3.67},{42.95,-.58,-.8809,.4002,.2526,3.93},{44.16,-1.09,-.9032,.3422,.259,4.01},{41.57,-.01,-.8618,.4595,.2149,4.82},{39.72,-8.79,-.7937,.4002,.4582,5.11},},[24]={{-42.83,.62,.8809,.4002,-.2526,3.93},{-44.04,1.12,.9032,.3422,-.259,4.01},},[25]={{-41.870000000323,-1.64,.8795,.4595,-.1236,.26},{-41.45,-17.47,.8497,.4002,.3433,.27},{-41.11,-13.15,.8618,.4595,.2149,.52},{-42.76,2.59,.8809,.4002,-.2526,.55},{-42.760000000141,-13.59,.8892,.4002,.2217,.55},{-44.21,-13.98,.9117,.3422,.2273,.57},{-41.87,-9.36,.8833,.4595,.0928,.77},{-43.56,-9.58,.9114,.4002,.0958,.82},{-45.04,-9.78,.9345,.3422,.0982,.86},{-42.12,-5.5,.8876,.4595,-.031,1.03},{-43.83,-5.5,.9159,.4002,-.032,1.09},{-43.56,-1.42,.9025,.4002,-.1591,1.36},},[26]={{-42.76,-5.59,.8892,.4002,.2217,.55},{-41.87,-1.36,.8833,.4595,.0928,.77},{-43.560000000956,-1.58,.9114,.4002,.0958,.82},{-43.83,2.5,.9159,.4002,-.032,1.09},{-41.45,-9.47,.8612,.4002,.3134,1.36},{-41.11,-5.150000000651,.8688,.4595,.1847,1.55},},[27]={{-40.93,-6.38,.8372,.4002,.3728,3.67}},[28]={{-42.07,-5.08,.8612,.4002,.3134,6.35}},},[4]={[1]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.338800000432,1.73,},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.730000000769,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.73,-21.08,-.942000000125,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[2]={{47.23,-26.36,-.8508,-.1869,.4912,0},{-2.51,-43.09,.379100000232,-.1373,.9151,0},{51.210000000831,-16.74,-.9489,-.1869,.2543,0},{52.03,-11.6,-.9821,-.1373,.1293,0},{50.34,-16.51,-.9653,-.0362,.2587,0},{2.49,-44.47,.2578,-.0871,.9623,0},{51.74,-11.56,-.9877,-.0871,.13,0},{49.35,-21.61,-.915100000198,-.1373,.3791,0},{47.06,-26.26,-.8578,-.1373,.4953,0},{49.070000000727,-21.49,-.9204,-.0871,.3812,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{49.54,-21.68,-.9076,-.1869,.3759,0},{52.23,-11.63,-.974,-.1869,.1282,0},{51.02,-16.69,-.9568,-.1373,.2564,0},{48.7,-21.34,-.9233,-.0362,.3824,0},{50.73,-16.61,-.9623,-.0871,.2578,0},},[3]={{36.97,-30.43,-.598,-.1869,.7794,0},{49.07,-13.86,-.9204,-.0871,.3812,0,},{49.35,-13.97,-.9151,-.1373,.3791,0},{49.54,-14.05,-.9076,-.186900000566,.3759,0},{52.57,1.22,-.9824,-.1869,0,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{52.23,-3.99,-.974,-.1869,.1282,0},{51.74,-3.93,-.9877,-.0871,.13,0},{47.06,-18.63,-.8578,-.1373,.4953,0},{52.37,1.22,-.9905,-.1373,0,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{40.89,-26.99,-.6946,-.1869,.6946,0,},{36.66,-30.04,-.6064,-.0871,.7903,0},{40.54,-26.64,-.7044,-.0871,.7044,0},{36.84,-30.270000000975,-.603,-.1373,.7858,0},},[4]={{52.03,3.21,-.9821,-.1373,.1293,0},{47.06,-11.46,-.8578,-.1373,.4953,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{52.23,3.18,-.974,-.1869,.1282,0},{49.54,-6.88,-.9076,-.1869,.3759,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{49.35,-6.8,-.9151,-.1373,.3791,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{40.54,-19.47,-.7044,-.0871,.7044,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{36.84,-23.1,-.603,-.1373,.785800000316,0},{36.66,-22.86,-.6064,-.0871,.7903,0},{36.97,-23.26,-.598,-.1869,.7794,0},{40.89,-19.82,-.6946,-.1869,.6946,0},{32.53,-25.99,-.4953,-.137300000652,.8578,0},{44.17,-15.78,-.7858,-.1373,.603,0},},[5]={{46.44,31.45,-.8331,-.1869,-.5206,1.65},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09,},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42,},{51.33,6.87,-.9938,-.0871,.0695,2.430000000533},{52.23,6.750000000614,-.98,-.1869,.0685,2.44},},[6]={{-46.48,31.45,.8331,-.1869,-.5206,1.65,},{-51.77,17.1,.9811,-.0871,-.173,1.72},{-52.07,17.14,.9755,-.1373,-.172,1.73},{-51.37,17.04,.9811,-.0871,-.173,1.76},{-50.37,22.05,.9474,-.0871,-.3078,2.09},{-50.77,22.15,.942,-.1373,-.3061,2.09},{-51.77,6.81,.9938,-.0871,.0695,2.41},{-52.07,6.77,.9881,-.1373,.0691,2.42},{-51.37,6.87,.9938,-.0871,.0695,2.43},{-48.74,26.87,.883,-.1869,-.4306,2.57},{-52.11,11.96,.9938,-.0871,-.0695,2.75},},[7]={{-52.11,7.49,.9962,-.0871,0,0},{-52.41,7.49,.9905,-.1373,0,0},{-43.97,31.47,.7903,-.0871,-.6064,0},{-51.06,17.76,.956800000388,-.1373,-.2564,0},{-46.48,26.980000000825,.8655,-.0362,-.4997,0},{-51.25,17.81,.9489,-.1869,-.2543,0,},{-46.83,27.19,.8627,-.0871,-.4981,0},{-47.26,27.440000000896,.8508,-.1869,-.4912,0},{-49.110000000377,22.56,.920400000102,-.0871,-.3812,0},{-49.390000000908,22.68,.9151,-.1373,-.3791,0},{-52.07,12.67,.9821,-.1373,-.1293,0},{-52.27,12.7,.974,-.1869,-.1282,0},},[8]={{-47.26,-20.09,.8508,-.1869,.4912,0},{-43.97,-24.13,.7903,-.0871,.6064,0},{-40.78,27.92,.7004,-.1373,-.7004,0},{-47.09,19.7,.8578,-.1373,-.4953,0},{-40.78,-28.21,.7004,-.1373,.7004,0},{-44.36,-24.43,.7794,-.1869,.598,0},{-47.09,-19.99,.8578,-.1373,.4953,0},{-40.92,28.06,.6946,-.1869,-.6946,0},{-40.92,-28.35,.6946,-.1869,.6946,0},{-44.21,-24.31,.7858,-.137300000629,.603,0},{-43.97,23.84,.7903,-.0871,-.6064,0},},[9]={{-27.98,-44.17,.3759,-.1869,.9076,0},{-2.52,-45.37,-.2578,-.0871,.9623,0},{7.23,-41.86,-.4912,-.1869,.8508,0},{-47.26,-27.26,.8508,-.1869,.4912,0},{-49.39,-22.51,.9151,-.1373,.3791,0},{-49.11,-22.39,.9204,-.0871,.3812,0},{-49.57,-22.58,.9076,-.1869,.375900000845,0},{-22.91,-45.37,.2578,-.0871,.9623,0},{-27.91,-43.99,.3791,-.1373,.9151,0},{2.55,-44.17,-.3759,-.1869,.9076,0},{6.98,-41.43,-.4981,-.0871,.8627,0},{2.47,-43.99,-.379100000694,-.1373,.9151,0},{7.13,-41.69,-.4953,-.1373,.8578,0,},{2.36,-43.71,-.3812,-.0871,.9204,0},{-22.99,-45.66,.2564,-.1373,.9568,0},},[10]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.975500000512,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-12.720000000138,-50.58,.0691,-.1373,.9881,2.77},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[11]={{51.74,-16.03,-.9811,-.0871,.173,1.72,},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73,},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[12]={{49.07,-21.49,-.9204,-.0871,.3812,0},{51.21,-16.74,-.9489,-.1869,.2543,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{51.74,-11.56,-.9877,-.0871,.13,0},{50.34,-16.51,-.9653,-.0362,.2587,0},{52.23,-11.63,-.974,-.1869,.1282,0},{2.49,-44.47,.2578,-.0871,.9623,0},{52.03,-11.6,-.9821,-.1373,.1293,0},{49.54,-21.68,-.9076,-.1869,.3759,0},{49.35,-21.61,-.9151,-.1373,.3791,0},{47.06,-26.26,-.857800000175,-.1373,.4953,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{27.76,-42.81,-.3812,-.0871,.9204,0},},[13]={{36.97,-30.43,-.598,-.1869,.7794,0},{49.07,-13.860000000908,-.9204,-.0871,.3812,0,},{49.35,-13.97,-.9151,-.137300000142,.3791,0},{49.54,-14.05,-.9076,-.1869,.3759,0},{52.57,1.22,-.9824,-.1869,0,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{52.23,-3.99,-.974,-.1869,.1282,0},{51.74,-3.93,-.9877,-.0871,.13,0},{47.06,-18.63,-.8578,-.1373,.4953,0},{52.37,1.22,-.9905,-.1373,0,0},{43.93,-22.76,-.7903,-.0871,.6064,0},{40.890000000855,-26.99,-.6946,-.186900000869,.6946,0,},{36.66,-30.04,-.6064,-.0871,.7903,0},{40.54,-26.64,-.7044,-.0871,.7044,0},{36.84,-30.270000000192,-.603,-.1373,.7858,0},},[14]={{52.03,3.21,-.9821,-.1373,.1293,0},{47.06,-11.46,-.8578,-.1373,.4953,0},{47.23,-11.560000000731,-.8508,-.1869,.4912,0},{52.23,3.18,-.974,-.1869,.1282,0},{49.54,-6.88,-.9076,-.1869,.3759,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{49.35,-6.8,-.9151,-.1373,.3791,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{40.54,-19.47,-.7044,-.0871,.7044,0},{43.93,-15.59,-.7903,-.0871,.6064,0},{36.84,-23.1,-.603,-.1373,.7858,0},{36.66,-22.86,-.6064,-.0871,.7903,0},{36.97,-23.26,-.598,-.1869,.7794,0},{40.89,-19.82,-.6946,-.1869,.6946,0},{32.53,-25.99,-.4953,-.137300000287,.8578,0},{44.17,-15.78,-.7858,-.1373,.603,0},},[15]={{46.44,31.45,-.8331,-.1869,-.5206,1.65},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.34,22.050000000687,-.9474,-.0871,-.3078,2.09,},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42,},{51.33,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.0685,2.44},},[16]={{-51.77,-16.03,.981100000343,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[17]={{-27.98,-44.31,.3759,-.1869,.9076,0},{-2.52,-45.500000000814,-.2578,-.0871,.9623,0},{7.23,-42,-.4912,-.1869,.8508,0},{-47.26,-27.4,.8508,-.1869,.4912,0},{-49.39,-22.64,.9151,-.1373,.3791,0},{-49.11,-22.53,.9204,-.0871,.3812,0},{-49.57,-22.72,.9076,-.1869,.3759,0},{-22.91,-45.5,.2578,-.0871,.9623,0},{-27.91,-44.12,.3791,-.1373,.9151,0},{2.55,-44.31,-.3759,-.1869,.9076,0},{6.98,-41.57,-.4981,-.0871,.8627,0},{2.47,-44.12,-.3791,-.1373,.9151,0},{7.13,-41.83,-.4953,-.1373,.8578,0,},{2.36,-43.85,-.3812,-.0871,.9204,0},{-22.99,-45.79,.2564,-.1373,.9568,0},},[18]={{-43.97,-23.43,.7903,-.0871,.6064,0},{-43.97,24.53,.7903,-.0871,-.6064,0},{-40.78,28.61,.7004,-.1373,-.7004,0},{-46.48,20.04,.8655,-.0362,-.4997,0},{-47.09,20.39,.8578,-.1373,-.4953,0},{-47.26,-19.4,.8508,-.1869,.4912,0},{-40.78,-27.52,.7004,-.1373,.7004,0},{-44.36,-23.74,.7794,-.1869,.598,0},{-47.09,-19.3,.8578,-.1373,.4953,0},{-40.92,-27.66,.6946,-.1869,.6946,0},{-44.21,-23.62,.785800000318,-.1373,.603,0},{-46.83,20.24,.8627,-.0871,-.4981,0},{-49.39,15.74,.9151,-.137300000958,-.3791,0},{-49.11,15.620000000768,.9204,-.0871,-.3812,0},},[19]={{39.76,3.72,-.8114,.4595,-.3613,3.61},{42.95,.62,-.8809,.4002,-.2526,3.93},{44.16,1.12,-.9032,.3422,-.259,4.01},{41.57,.05,-.8618,.4595,-.2149,4.82},{39.72,8.83,-.7937,.4002,-.4582,5.11},},[20]={{39.76,-22.09,-.7937,.4002,.4582,0},{41.57,5.51,-.8467,.4002,-.3507,0},{42.24,-6.45,-.8882,.4595,0,0},{41.99,-2.59,-.8806,.4595,-.1159,0},{41.99,-10.31,-.8806,.4595,.1159,0},{43.95,-6.45,-.9164,.4002,0,0},{41.570000000184,-18.42,-.8467,.4002,.3507,0},{44.33,2.03,-.9076,.342200000857,-.2432,0},{42.88,1.64,-.8852,.4002,-.2372,0},{43.68,-10.53,-.9086,.4002,.1196,0},{42.88,-14.54,-.8852,.4002,.2372,0},{44.33,-14.93,-.9076,.3422,.2432,0},{43.68,-2.37,-.9086,.4002,-.1196,0},{39.76,9.18,-.7937,.4002,-.4582,0},},[21]={{39.76,-13.85,-.793700000182,.4002,.4582,0},{39.76,17.42,-.7937,.4002,-.4582,0,},},[22]={{41.23,1.95,-.8618,.4595,.2149,.52},{41.23,17.25,-.8538,.4595,-.2448,.52},{42.88,17.69,-.880900000672,.4002,-.2526,.55},{42.88,1.51,-.8892,.4002,.2217,.55},{44.33,1.12,-.9117,.3422,.2273,.57},{41.99,5.74,-.883300000847,.4595,.0928,.77},{39.99,20.91,-.8114,.4595,-.3613,.77},{41.57,21.57,-.8372,.4002,-.3728,.82,},{43.68,5.52,-.9114,.4002,.0958,.82},{45.16,5.32,-.9345,.3422,.0982,.86},{42.24,9.6,-.8876,.4595,-.031,1.03},{39.76,-6.03,-.8092,.4002,.4302,1.090000000689},{43.95,9.6,-.9159,.4002,-.032,1.09},{39.99,-1.71,-.8346,.4595,.3038,1.29},{41.99,13.46,-.8747,.4595,-.1542,1.29},{41.57,-2.36,-.8612,.4002,.3134,1.36},},[23]={{39.76,-3.68,-.8114,.4595,.3613,3.61},{41.05,-4.43,-.8372,.4002,.3728,3.67},{42.950000000775,-.580000000681,-.8809,.4002,.2526,3.93},{44.16,-1.09,-.9032,.3422,.259,4.01},{41.57,-.01,-.8618,.4595,.2149,4.82},{39.72,-8.79,-.7937,.400200000777,.4582,5.11},},[24]={{-42.83,.62,.8809,.4002,-.2526,3.93},{-44.04,1.12,.9032,.3422,-.259,4.01},},[25]={{-41.87,-1.64,.8795,.4595,-.1236,.26},{-41.45,-17.47,.8497,.4002,.343300000706,.27},{-41.11,-13.15,.8618,.4595,.2149,.52},{-42.76,2.59,.8809,.4002,-.2526,.55},{-42.76,-13.59,.8892,.4002,.2217,.55},{-44.21,-13.98,.9117,.3422,.2273,.57},{-41.87,-9.36,.8833,.4595,.0928,.77},{-43.56,-9.58,.9114,.4002,.0958,.82},{-45.04,-9.78,.9345,.3422,.0982,.860000000765},{-42.12,-5.5,.8876,.4595,-.031,1.03},{-43.83,-5.5,.9159,.4002,-.032,1.090000000139},{-43.560000000932,-1.42,.9025,.4002,-.1591,1.36},},[26]={{-42.760000000102,-5.59,.8892,.4002,.2217,.55},{-41.87,-1.36,.8833,.4595,.0928,.77},{-43.56,-1.58,.9114,.4002,.0958,.82},{-43.83,2.5,.9159,.4002,-.032,1.09},{-41.45,-9.47,.8612,.4002,.3134,1.36},{-41.11,-5.15,.8688,.4595,.1847,1.55},},[27]={{-40.93,-6.38,.8372,.4002,.3728,3.67}},[28]={{-42.07,-5.08,.8612,.4002,.3134,6.35}},},[5]={[1]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.740000000942},{51.33,-15.970000000765,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09,},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[2]={{51.21,-16.74,-.9489,-.1869,.2543,0},{52.37,-6.42,-.9905,-.1373,-0,0},{52.57,-6.42,-.9824,-.1869,-0,0},{46.8,-26.11,-.8627,-.0871,.4981,0},{47.06,-26.26,-.8578,-.1373,.4953,0},{52.07,-6.42,-.9962,-.0871,-0,0},{52.03,-1.24,-.9821,-.1373,-.1293,0},{52.23,-1.21,-.974,-.1869,-.1282,0},{51.74,-1.28,-.9877,-.0871,-.13,0},{51.74,-11.56,-.9877,-.0871,.13,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{51.21,3.91,-.9489,-.1869,-.2543,0},{50.73,-16.61,-.9623,-.0871,.2578,0},{52.03,-11.6,-.9821,-.1373,.1293,0},{49.35,-21.61,-.9151,-.1373,.3791,0},{51.02,-16.69,-.9568,-.1373,.2564,0},},[3]={{40.75,-26.85,-.7004,-.1373,.7004,0},{52.23,-3.99,-.974,-.1869,.1282,0},{40.89,-26.99,-.6946,-.1869,.6946,0},{50.34,-8.87,-.9653,-.0362,.2586,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{44.33,-23.07,-.7794,-.1869,.598,0},{51.74,-3.93,-.9877,-.0871,.13,0},{44.17,-22.95,-.7858,-.1373,.603000000186,0,},{52.37,1.22,-.9905,-.1373,-0,0},{46.8,-18.48,-.8627,-.0871,.4981,0},{52.07,1.22,-.9962,-.0871,-0,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{49.35,-13.97,-.9151,-.1373,.3791,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{49.07,-13.86,-.9204,-.0871,.3812,0,},{47.23,-18.73,-.8508,-.1869,.4912,0},},[4]={{52.37,8.39,-.9905,-.1373,-0,0},{52.23,3.18,-.974,-.1869,.1282,0},{50.34,-1.7,-.9653,-.0362,.2586,0},{44.17,-15.78,-.785800000996,-.1373,.603,0},{52.57,8.39,-.9824,-.1869,-0,0},{52.03,3.21,-.9821,-.1373,.1293,0},{40.89,-19.82,-.6946,-.1869,.6946,0},{51.74,3.25,-.9877,-.0871,.13,0},{40.54,-19.47,-.7044,-.0871,.7044,0},{40.75,-19.68,-.7004,-.1373,.7004,0},{44.33,-15.9,-.7794,-.1869,.598,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{46.8,-11.31,-.8627,-.0871,.4981,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{47.06,-11.46,-.8578,-.1373,.4953,0},},[5]={{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41,},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.068500000908,2.44,},{48.7,26.87,-.883,-.1869,-.4306,2.57},},[6]={{30.89,-7.75,-.9606,-.0362,.2755,10.85},{31.71,-3.64,-.9896,-.0362,.1391,11.72},{31.98,.54,-.9993,-.0362,-0,12.77},{33.79,-8.52,-.9606,-.0362,.2755,13.28},{32.32,-12.86,-.9266,-.0362,.3744,13.54},{34.68,-4.03,-.9896,-.0362,.1391,13.74},{31.71,4.71,-.9896,-.0362,-.1391,13.94},{34.98,.54,-.999300000603,-.0362,-0,14.36,},{34.68,5.1,-.9896,-.0362,-.1391,15.1},{30.89,8.82,-.9606,-.0362,-.2755,15.18},{32.32,13.93,-.9266,-.0362,-.3744,15.44},{36.69,-9.3,-.9606,-.0362,.2755,15.9},{33.79,9.59,-.9606,-.0362,-.275500000871,15.92},{37.66,-4.42,-.989600000428,-.0362,.1391,16.08},{32.89,-18.46,-.8655,-.0362,.4997,16.11},{35.09,-14.01,-.9266,-.0362,.3744,16.280000000689},},[7]={{30.89,-7.75,-.9606,-.0362,.2755,7.6},{31.71,-3.64,-.9896,-.0362,.1391,8.15},{31.98,.54,-.9993,-.0362,-0,9},{31.71,4.71,-.9896,-.0362,-.139100000365,10.06},{33.79,-8.52,-.9606,-.0362,.2755,10.45},{32.32,-12.86,-.9266,-.0362,.3744,10.58},{34.68,-4.03,-.9896,-.0362,.1391,10.7},{34.98,.54,-.9993,-.0362,-0,11.15},{30.89,8.82,-.9606,-.0362,-.2755,11.24},{34.68,5.1,-.9896,-.0362,-.1391,11.76},{32.32,13.93,-.9266,-.0362,-.3744,12.07},{33.79,9.59,-.9606,-.0362,-.2755,12.5,},{36.69,-9.3,-.9606,-.0362,.2755,13.37},{37.66,-4.42,-.9896,-.0362,.1391,13.44},{32.89,-18.46,-.8655,-.0362,.4997,13.49},{35.09,-14.01,-.9266,-.0362,.3744,13.54},},[8]={{31.98,.54,-.9993,-.0362,-0,5.75},{31.71,4.71,-.9896,-.0362,-.1391,5.85},{31.71,-3.64,-.9896,-.0362,.1391,6.13},{30.89,8.82,-.9606,-.0362,-.2755,6.39},{30.89,-7.75,-.9606,-.0362,.2755,6.89},{34.98,.54,-.9993,-.0362,-0,8.74},{34.68,5.1,-.9896,-.0362,-.1391,8.79},{32.32,13.93,-.9266,-.0362,-.3744,8.9},{34.68,-4.03,-.9896,-.0362,.1391,8.93},{33.79,9.59,-.9606,-.0362,-.2755,9.09},{32.32,-12.86,-.9266,-.0362,.3744,9.09},{33.79,-8.52,-.9606,-.0362,.2755,9.34},{35.09,15.08,-.926600000576,-.0362,-.3744,11.68},{35.09,-14.01,-.9266,-.0362,.3744,11.68},{37.98,.54,-.9993,-.0362,-0,11.73},{37.66,5.5,-.9896,-.0362,-.1391,11.77},},[9]={{-27.98,-44.17,.375900000625,-.1869,.9076,0},{2.47,-43.99,-.3791,-.1373,.9151,0,},{-23.04,-45.85,.2543,-.1869,.9489,0},{-22.99,-45.66,.2564,-.1373,.9568,0},{-27.79,-43.71,.3812,-.0871,.9204,0},{7.13,-41.69,-.4953,-.1373,.8578,0},{6.98,-41.43,-.4981,-.0871,.862700000241,0},{-22.91,-45.37,.2578,-.0871,.9623,0},{-2.52,-45.37,-.2578,-.0871,.9623,0},{2.36,-43.71,-.3812,-.0871,.9204,0},{-27.91,-43.99,.3791,-.1373,.915100000978,0},{2.55,-44.17,-.3759,-.186900000454,.9076,0},{7.23,-41.86,-.4912,-.1869,.8508,0},},[10]={{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},{-12.72,-50.77,.0685,-.1869,.98,2.78},{-17.9,-50.24,.2042,-.1869,.9609,3.13},},[11]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.186900000326,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.34,-.79,-.9744,-.0871,-.207100000465,2.09},{50.730000000884,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41,},{52.03,-5.7,-.9881,-.1373,-.0691,2.42},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[12]={{51.21,-16.74,-.9489,-.1869,.2543,0},{52.37,-6.42,-.9905,-.1373,-0,0},{52.57,-6.42,-.9824,-.1869,-0,0},{46.8,-26.11,-.8627,-.0871,.4981,0},{47.06,-26.26,-.8578,-.1373,.4953,0},{52.07,-6.42,-.9962,-.0871,-0,0},{52.03,-1.24,-.9821,-.1373,-.1293,0},{52.23,-1.21,-.974,-.186900000625,-.1282,0},{51.74,-1.28,-.9877,-.0871,-.13,0},{51.74,-11.56,-.9877,-.0871,.13,0},{47.23,-26.36,-.8508,-.1869,.4912,0},{51.21,3.91,-.9489,-.1869,-.2543,0},{50.73,-16.61,-.9623,-.0871,.2578,0},{52.03,-11.6,-.9821,-.1373,.1293,0},{49.35,-21.61,-.9151,-.1373,.3791,0},{51.02,-16.69,-.9568,-.1373,.2564,0},},[13]={{40.75,-26.85,-.7004,-.1373,.7004,0},{52.23,-3.99,-.974,-.1869,.1282,0},{40.89,-26.99,-.6946,-.1869,.6946,0},{50.34,-8.87,-.9653,-.0362,.2586,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{44.330000000728,-23.07,-.7794,-.1869,.598,0},{51.74,-3.93,-.9877,-.0871,.13,0},{44.17,-22.95,-.7858,-.1373,.603000000177,0,},{52.37,1.22,-.9905,-.1373,-0,0},{46.8,-18.48,-.8627,-.0871,.4981,0},{52.07,1.22,-.9962,-.0871,-0,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{49.35,-13.97,-.9151,-.1373,.3791,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{49.07,-13.86,-.9204,-.0871,.3812,0,},{47.230000000665,-18.73,-.8508,-.1869,.4912,0},},[14]={{52.37,8.39,-.9905,-.1373,-0,0},{52.23,3.18,-.974,-.1869,.128200000125,0},{50.34,-1.7,-.9653,-.0362,.2586,0},{44.17,-15.780000000396,-.7858,-.1373,.603,0},{52.57,8.39,-.9824,-.1869,-0,0},{52.03,3.21,-.9821,-.1373,.1293,0},{40.89,-19.82,-.6946,-.1869,.6946,0},{51.74,3.25,-.9877,-.0871,.13,0},{40.54,-19.47,-.7044,-.0871,.7044,0},{40.75,-19.68,-.7004,-.1373,.700400000223,0},{44.33,-15.9,-.7794,-.1869,.598,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{46.8,-11.31,-.8627,-.0871,.4981,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{47.06,-11.46,-.8578,-.1373,.4953,0},},[15]={{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75,},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09,},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.993800000606,-.0871,.0695,2.41},{52.03,6.770000000701,-.9881,-.1373,.0691,2.42,},{51.330000000918,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.0685,2.44},{48.7,26.87,-.883,-.1869,-.4306,2.57},},[16]={{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},{-12.72,-50.77,.0685,-.186900000972,.98,2.78},{-17.9,-50.24,.2042,-.1869,.9609,3.13},},[17]={{-27.98,-44.31,.3759,-.1869,.9076,0},{2.47,-44.12,-.3791,-.1373,.9151,0},{-23.04,-45.98,.2543,-.1869,.9489,0},{-22.99,-45.79,.2564,-.1373,.9568,0},{-27.79,-43.85,.3812,-.0871,.9204,0},{7.13,-41.83,-.4953,-.1373,.8578,0},{6.98,-41.57,-.4981,-.0871,.8627,0,},{-22.91,-45.5,.2578,-.0871,.9623,0},{-2.52,-45.5,-.2578,-.0871,.9623,0},{2.360000000974,-43.85,-.3812,-.0871,.9204,0},{-27.91,-44.12,.3791,-.1373,.9151,0},{2.55,-44.31,-.3759,-.1869,.9076,0},{7.23,-42,-.4912,-.1869,.8508,0},},[18]={{31.98,.54,-.9993,-.0362,-0,5.71},{31.710000000503,-3.64,-.9896,-.0362,.1391,5.95},{31.71,4.71,-.9896,-.0362,-.1391,5.95},{30.89,-7.75,-.9606,-.0362,.2755,6.6},{30.89,8.82,-.9606,-.0362,-.2755,6.61},{34.98,.54,-.9993,-.0362,-0,8.71,},{34.68,-4.03,-.9896,-.0362,.1391,8.83},{34.68,5.1,-.9896,-.0362,-.1391,8.84},{32.32,-12.86,-.9266,-.0362,.3744,8.97},{32.32,13.93,-.9266,-.0362,-.3744,8.97},{33.79,-8.52,-.9606,-.0362,.2755,9.18},{33.79,9.59,-.960600000414,-.0362,-.2755,9.19},{35.09,-14.01,-.9266,-.0362,.3744,11.66},{35.09,15.08,-.9266,-.0362,-.3744,11.66},{37.98,.54,-.9993,-.0362,-0,11.71},{37.66,-4.42,-.9896,-.0362,.1391,11.78},},[19]={{39.76,3.72,-.8114,.4595,-.3613,3.61,},{42.95,.62,-.8809,.4002,-.2526,3.93},{44.16,1.12,-.9032,.3422,-.259,4.010000000957},{41.57,.05,-.8618,.4595,-.2149,4.82},{39.72,8.83,-.7937,.400200000649,-.4582,5.11},{42.19,5.12,-.8747,.4595,-.1542,11.91},},[20]={{44.33,-14.93,-.9076,.3422,.2432,0},{39.99,4.86,-.8206,.4595,-.3399,0},{44.33,2.03,-.9076,.3422,-.2432,0},{41.57,5.51,-.8467,.4002,-.3507,0},{39.99,-17.76,-.8206,.459500000461,.3399,0},{43.95,-6.45,-.9164,.4002,-0,0},{39.76,9.18,-.7937,.4002,-.4582,0},{41.57,-18.420000000853,-.8467,.4002,.3507,0},{39.76,-22.09,-.7937,.4002,.4582,0},{42.88,-14.54,-.8852,.4002,.2372,0},{42.88,1.64,-.8852,.4002,-.2372,0,},{43.68,-2.370000000514,-.9086,.4002,-.1196,0},{43.68,-10.53,-.908600000922,.4002,.1196,0,},},[21]={{39.76,-13.85,-.7937,.4002,.4582,0},{39.99,13.1,-.8206,.4595,-.3399,0},{39.99,-9.53,-.8206,.4595,.3399,0},{39.76,17.42,-.7937,.4002,-.4582,0},},[22]={{41.23,1.95,-.8618,.4595,.2149,.52},{41.23,17.25,-.8538,.4595,-.2448,.52},{42.88,17.69,-.8809,.4002,-.2526,.55},{42.880000000688,1.51,-.8892,.4002,.2217,.55},{44.33,1.12,-.9117,.3422,.2273,.57},{41.99,5.74,-.8833,.4595,.0928,.77},{39.99,20.91,-.8114,.4595,-.3613,.77},{43.68,5.52,-.9114,.4002,.095800000723,.82},{41.57,21.57,-.8372,.4002,-.3728,.82},{45.16,5.32,-.9345,.3422,.0982,.86},{42.24,9.6,-.8876,.4595,-.031,1.03},{43.95,9.6,-.9159,.4002,-.032,1.09},{39.76,-6.03,-.8092,.4002,.4302,1.09},{41.99,13.46,-.8747,.4595,-.1542,1.29},{39.99,-1.71,-.8346,.4595,.3038,1.29},{43.68,13.68,-.9025,.400200000169,-.1591,1.36},},[23]={{39.76,-3.68,-.8114,.4595,.3613,3.61},{41.05,-4.43,-.837200000541,.4002,.3728,3.67},{42.95,-.58,-.8809,.4002,.2526,3.93},{44.16,-1.09,-.9032,.3422,.259,4.01},{41.57,-.01,-.8618,.4595,.2149,4.82},{39.72,-8.79,-.7937,.4002,.4582,5.11},{42.19,-5.08,-.8747,.4595,.1542,11.91},},[24]={{43.48,-17.97,-.883,.3422,.3214,25.78},{40.71,-16.82,-.8346,.4595,.3038,26.02},{43.68,-5.72,-.9025,.4002,.1591,27.98},{44.06,.02,-.9164,.4002,-0,28.02},{43.68,5.76,-.907500000307,.4002,-.1275,28.58},{40.71,16.86,-.8346,.4595,-.3038,31.6},},[25]={{43.48,-17.97,-.883,.3422,.3214,25.29},{40.71,-16.82,-.8346,.4595,.3038,25.52},{44.06,.02,-.9164,.4002,-0,25.95},{43.68,-5.72,-.9025,.4002,.1591,25.98},{43.68,5.76,-.9075,.4002,-.1275,26.21},{40.71,16.86,-.8346,.4595,-.3038,28.28},},[26]={{43.68,5.760000000221,-.9075,.4002,-.1275,25.31},{44.06,.02,-.9164,.4002,-0,25.480000000221},{43.68,-5.72,-.9025,.4002,.1591,25.61},{40.71,16.86,-.8346,.4595,-.3038,25.85},{43.48,-17.97,-.883,.3422,.3214,26.9},{40.71,-16.82,-.8346,.4595,.3038,27.11,},},[27]={{40.71,16.86,-.8346,.4595,-.3038,25.7},{43.68,5.76,-.9075,.4002,-.1275,26.7},{44.06,.02,-.916400000361,.4002,-0,27.25},{43.68,-5.72,-.9025,.4002,.1591,27.46},{43.48,-17.97,-.883,.3422,.3214,30.31},{40.71,-16.82,-.8346,.4595,.3038,30.48},},[28]={{40.71,16.86,-.8346,.4595,-.3038,26.02},{43.68,5.76,-.9075,.4002,-.1275,27.39},{44.060000000223,.020000000698,-.916400000383,.4002,-0,28.02},{43.68,-5.72,-.9025,.4002,.1591,28.25},{43.48,-17.97,-.883,.3422,.3214,31.44},{40.71,-16.82,-.8346,.4595,.3038,31.6},},},[6]={[1]={{12.68,-50.58,-.0691,-.1373,.9881,2.77},{12.68,-50.28,-.0691,-.1373,.9881,2.78},{12.68,-50.77,-.0685,-.1869,.98,2.78},{17.86,-50.24,-.2042,-.1869,.9609,3.13},{36.41,20.05,-.6573,-.1869,-.73,3.23},},[2]={{27.95,-43.27,-.3759,-.1869,.9076,0},{2.49,-44.470000000819,.2578,-.0871,.9623,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{-2.39,-42.81,.3812,-.0871,.9204,0},{32.53,27.96,-.4953,-.1373,-.8578,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{22.88,-44.47,-.2578,-.0871,.962300000359,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{32.38,27.7,-.4981,-.0871,-.8627,0},{36.84,25.07,-.603,-.1373,-.7858,0},{32.63,28.13,-.4912,-.1869,-.8508,0},{36.66,24.83,-.6064,-.0871,-.7903,0},},[3]={{-18.65,-30.65,.7416,-.2504,.6223,8.52},{10.08,-47.24,.1685,-.2419,.9556,8.54},{-5.75,-41.48,.4841,-.2504,.8384,8.52},{26.23,-43.3,-.3052,-.1564,.9393,7.53},},[4]={{32.63,-26.16,-.4912,-.1869,.8508,0},{32.38,-25.73,-.4981,-.0871,.8627,0},{32.53,-25.99,-.4953,-.1373,.857800000661,0},{36.66,-22.86,-.6064,-.0871,.7903,0},},[5]={{36.410000000835,-18.97,-.6573,-.1869,.73,3.23}},[6]={{-46.48,31.45,.8331,-.1869,-.5206,1.65},{-51.77,17.1,.9811,-.0871,-.173,1.72},{-52.07,17.14,.9755,-.1373,-.172,1.73},{-51.37,17.04,.9811,-.0871,-.173,1.76},{-50.37,22.05,.9474,-.0871,-.3078,2.09},{-50.77,22.15,.942,-.1373,-.3061,2.090000000561},{-51.77,6.81,.9938,-.0871,.0695,2.41},{-52.07,6.77,.9881,-.1373,.0691,2.42},{-51.37,6.87,.9938,-.0871,.0695,2.43},{-48.74,26.87,.883,-.1869,-.4306,2.57},{-52.11,11.96,.9938,-.0871,-.0695,2.75},},[7]={{-50.37,17.580000000611,.9653,-.0362,-.2587,0},{-50.77,17.69,.9623,-.0871,-.2578,0},{-51.06,17.76,.9568,-.1373,-.2564,0},{-48.74,22.41,.9233,-.0362,-.3824,0},{-47.09,27.34,.8578,-.1373,-.4953,0},{-49.57,22.76,.9076,-.1869,-.3759,0},{-51.370000000887,12.58,.9908,-.0362,-.1304,0},{-51.25,17.81,.9489,-.1869,-.2543,0},{-43.97,31.47,.7903,-.0871,-.6064,0},{-52.11,7.49,.9962,-.0871,0,0},{-52.41,7.49,.9905,-.1373,0,0},},[8]={{-40.92,28.06,.6946,-.1869,-.6946,0},{-40.78,27.92,.7004,-.1373,-.7004,0},{-47.09,19.7,.8578,-.1373,-.4953,0},{-47.09,-19.99,.8578,-.1373,.4953,0,},{-43.97,-24.13,.7903,-.0871,.6064,0},{-47.26,-20.09,.8508,-.1869,.4912,0},{-44.36,-24.43,.7794,-.1869,.598,0},{-40.78,-28.21,.7004,-.1373,.7004,0},{-44.21,-24.31,.7858,-.1373,.603,0},{-40.92,-28.35,.6946,-.1869,.6946,0},{-44.36,24.14,.7794,-.1869,-.598,0},},[9]={{-27.98,-44.17,.3759,-.1869,.9076,0},{-50.77,-17.51,.9623,-.0871,.2578,0},{-51.06,-17.59,.9568,-.1373,.2564,0},{-51.25,-17.64,.9489,-.1869,.2543,0},{-48.74,-22.24,.9233,-.0362,.3824,0},{-50.37,-17.41,.965300000255,-.0362,.2587,0},{-52.07,-12.5,.9821,-.1373,.1293,0},{-52.27,-12.52,.974,-.1869,.1282,0},{-51.37,-12.4,.9908,-.0362,.1304,0},{2.55,-44.17,-.3759,-.1869,.9076,0},{-49.11,-22.39,.9204,-.0871,.3812,0},{-23.04,-45.85,.2543,-.1869,.9489,0},{-27.91,-43.99,.3791,-.1373,.9151,0},{-49.39,-22.51,.9151,-.1373,.3791,0},{-27.79,-43.71,.3812,-.0871,.9204,0},},[10]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.967500000409,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[11]={{12.68,-50.58,-.0691,-.1373,.9881,2.77,},{12.680000000801,-50.280000000449,-.0691,-.1373,.9881,2.78},{12.68,-50.77,-.0685,-.1869,.98,2.78},{17.86,-50.24,-.2042,-.1869,.9609,3.13},{36.41,20.05,-.6573,-.1869,-.73,3.23},},[12]={{27.950000000715,-43.27,-.3759,-.1869,.9076,0},{2.49,-44.47,.2578,-.0871,.9623,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{-2.39,-42.81,.3812,-.0871,.9204,0},{32.53,27.96,-.4953,-.1373,-.8578,0},{27.76,-42.81,-.3812,-.0871,.920400000762,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{-7.26,-40.97,.4912,-.1869,.8508,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{32.38,27.7,-.4981,-.0871,-.8627,0},{36.84,25.07,-.603,-.1373,-.7858,0},{32.63,28.13,-.4912,-.1869,-.8508,0},{36.66,24.83,-.6064,-.0871,-.7903,0},},[13]={{-7.53,-45.5,.5506,.3502,.7578,8.33},{5.33,-50.65,.2606,.3256,.9089,5.89},{18.5,-51.98,-.0662,.3173,.946,4.82},},[14]={{32.63,-26.16,-.4912,-.1869,.8508,0},{32.38,-25.73,-.4981,-.0871,.8627,0},{32.53,-25.99,-.4953,-.1373,.8578,0},{36.660000000493,-22.86,-.6064,-.0871,.7903,0},},[15]={{36.41,-18.97,-.6573,-.1869,.73,3.23}},[16]={{-51.77,-16.030000000889,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.74},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.740000000931,-25.8,.883,-.186900000191,.4306,2.57},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[17]={{-27.98,-44.31,.3759,-.1869,.9076,0},{-50.77,-17.65,.9623,-.0871,.2578,0},{-51.06,-17.73,.9568,-.1373,.2564,0},{-51.25,-17.78,.9489,-.1869,.2543,0},{-48.74,-22.37,.9233,-.0362,.3824,0},{-50.37,-17.54,.9653,-.0362,.2587,0},{-52.07,-12.63,.9821,-.1373,.1293,0},{-52.27,-12.66,.974,-.1869,.1282,0},{-51.37,-12.54,.9908,-.0362,.1304,0},{2.55,-44.310000000691,-.3759,-.1869,.9076,0},{-49.11,-22.53,.9204,-.0871,.3812,0},{-23.04,-45.98,.2543,-.1869,.9489,0},{-27.91,-44.12,.3791,-.1373,.9151,0},{-49.39,-22.64,.9151,-.1373,.3791,0},{-27.79,-43.85,.3812,-.0871,.9204,0},},[18]={{-43.97,24.53,.7903,-.0871,-.6064,0},{-40.78,28.61,.7004,-.1373,-.7004,0},{-47.09,20.39,.8578,-.1373,-.4953,0},{-48.74,15.47,.9233,-.0362,-.3824,0},{-47.09,-19.3,.8578,-.1373,.4953,0},{-43.97,-23.43,.7903,-.0871,.6064,0},{-40.78,-27.52,.7004,-.1373,.7004,0},{-44.21,24.71,.7858,-.1373,-.603,0},{-44.36,-23.74,.7794,-.1869,.598,0},{-44.21,-23.62,.7858,-.1373,.603,0},{-46.480000000244,20.04,.8655,-.0362,-.4997,0},{-40.920000000263,-27.66,.6946,-.1869,.6946,0},{-47.26,-19.4,.8508,-.1869,.4912,0},},[19]={{-43.36,-17.97,.883,.3422,.3214,25.78},{-43.56,-5.720000000757,.9025,.4002,.1591,27.98},{-43.94,.02,.9164,.4002,0,28.02},},[20]={{-43.36,-17.97,.883,.3422,.3214,25.26},{-43.94,.02,.9164,.4002,0,26.17},{-43.56,-5.72,.9025,.4002,.1591,26.19},},[21]={{-43.94,.02,.9164,.4002,0,25.42},{-43.56,-5.72,.902500000901,.4002,.1591,25.54},{-43.36,-17.97,.883,.3422,.3214,26.66},},[22]={{-43.940000000739,.02,.9164,.4002,0,27.11},{-43.56,-5.720000000118,.9025,.4002,.1591,27.31},{-43.36,-17.97,.883,.3422,.3214,30.09},},[23]={{-43.94,.02,.9164,.4002,0,28.02},{-43.56,-5.72,.9025,.4002,.1591,28.25},{-43.36,-17.97,.883,.3422,.3214,31.44},},[24]={{-42.83,.62,.8809,.4002,-.2526,3.930000000458},{-44.04,1.12,.9032,.3422,-.259,4.01},},[25]={{-41.87,-1.64,.8795,.4595,-.1236,.26},{-41.45,-17.47,.8497,.4002,.3433,.27},{-41.11,-13.15,.8618,.4595,.2149,.52},{-42.76,2.59,.8809,.4002,-.2526,.55},{-42.76,-13.59,.8892,.4002,.2217,.55},{-44.21,-13.98,.9117,.3422,.2273,.57},{-41.87,-9.36,.883300000248,.459500000832,.0928,.77},{-43.56,-9.58,.9114,.4002,.0958,.82},{-45.04,-9.78,.9345,.3422,.0982,.86},{-42.120000000872,-5.5,.8876,.4595,-.031,1.030000000116},{-43.83,-5.5,.9159,.4002,-.032,1.09},{-43.56,-1.42,.9025,.4002,-.1591,1.36},},[26]={{-42.76,-5.59,.8892,.400200000335,.2217,.55},{-41.87,-1.36,.8833,.4595,.0928,.77},{-43.56,-1.58,.9114,.4002,.095800000324,.82},{-43.83,2.5,.9159,.4002,-.032,1.09},{-41.45,-9.47,.8612,.400200000196,.3134,1.36},{-41.11,-5.15,.8688,.4595,.1847,1.55},},[27]={{-40.93,-6.38,.8372,.4002,.3728,3.67}},[28]={{-42.07,-5.08,.8612,.4002,.3134,6.35}},},[7]={[1]={{12.68,-50.58,-.0691,-.1373,.9881,2.77},{12.68,-50.28,-.0691,-.1373,.9881,2.78},{12.68,-50.77,-.0685,-.1869,.98,2.78},{17.86,-50.24,-.2042,-.1869,.9609,3.13,},},[2]={{-7.26,-40.970000000756,.4912,-.1869,.8508,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{2.49,-44.47,.2578,-.0871,.9623,0},{22.88,-44.470000000637,-.2578,-.0871,.9623,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{-2.39,-42.81,.3812,-.0871,.9204,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{27.95,-43.27,-.3759,-.1869,.9076,0},},[3]={{-18.65,-30.65,.7416,-.2504,.6223,8.52},{10.08,-47.24,.1685,-.2419,.9556,8.54},{-5.75,-41.48,.4841,-.2504,.8384,8.52},{26.4,-44.28,-.3028,-.1994,.932,8.15},},[4]={{-12.68,-29.13,.6223,-.2504,.7416,8.52},{10.08,-39.74,.1685,-.2419,.9556,8.54,},},[5]={{10.08,-32.24,.1685,-.2419,.9556,8.54}},[6]={{-51.77,17.1,.9811,-.0871,-.173,1.72},{-52.07,17.14,.9755,-.1373,-.172,1.730000000614},{-52.27,17.16,.9675,-.1869,-.1706,1.74},{-51.37,17.04,.9811,-.0871,-.173,1.76},{-50.37,22.05,.9474,-.0871,-.3078,2.09},{-50.77,22.15,.942,-.1373,-.3061,2.09},{-51.77,6.81,.9938,-.0871,.0695,2.41},{-52.07,6.77,.9881,-.1373,.0691,2.42},{-51.37,6.87,.9938,-.0871,.0695,2.43},{-48.74,26.87,.883,-.1869,-.4306,2.57},{-52.11,11.96,.9938,-.0871,-.0695,2.75},},[7]={{-47.09,27.34,.8578,-.1373,-.4953,0},{-47.26,27.44,.8508,-.1869,-.4912,0},{-52.07,12.67,.9821,-.1373,-.1293,0},{-51.25,17.81,.9489,-.1869,-.2543,0},{-52.11,7.49,.9962,-.0871,0,0},{-49.39,22.68,.9151,-.1373,-.3791,0},{-49.11,22.56,.9204,-.0871,-.3812,0},{-49.57,22.76,.9076,-.1869,-.3759,0},{-52.27,12.7,.974,-.1869,-.1282,0},{-51.06,17.76,.9568,-.1373,-.2564,0},{-50.77,17.69,.9623,-.0871,-.2578,0},{-51.77,12.63,.9877,-.0871,-.13,0},},[8]={{-47.090000000664,19.7,.8578,-.1373,-.4953,0},{-43.97,-24.13,.7903,-.0871,.6064,0},{-44.36,24.14,.7794,-.1869,-.598,0},{-44.36,-24.43,.7794,-.1869,.598,0},{-47.09,-19.99,.8578,-.1373,.4953,0},{-47.26,-20.09,.8508,-.1869,.4912,0},{-44.21,24.02,.7858,-.1373,-.603,0},{-46.83,19.55,.8627,-.0871,-.4981,0},{-43.970000000731,23.84,.7903,-.0871,-.6064,0},{-40.92,-28.35,.6946,-.1869,.6946,0},},[9]={{2.36,-43.71,-.3812,-.0871,.9204,0},{-27.91,-43.99,.3791,-.1373,.9151,0},{-27.79,-43.71,.3812,-.0871,.920400000995,0},{-2.52,-45.37,-.2578,-.0871,.9623,0},{-47.09,-27.16,.8578,-.137300000841,.4953,0},{-47.26,-27.26,.8508,-.1869,.4912,0},{-27.98,-44.17,.3759,-.1869,.9076,0},{-23.04,-45.85,.2543,-.1869,.9489,0},{-22.910000000992,-45.37,.2578,-.0871,.9623,0},{-52.07,-12.5,.9821,-.1373,.1293,0},{-22.99,-45.660000000656,.2564,-.1373,.9568,0},{-51.25,-17.64,.9489,-.1869,.2543,0},},[10]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.740000000989},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.74,-25.8,.883,-.1869,.4306,2.57},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-52.41,-10.88,.988100000626,-.1373,.0691,2.77},{-12.72,-50.28,.069100000559,-.1373,.9881,2.78},},[11]={{12.68,-50.58,-.0691,-.1373,.9881,2.77},{12.680000000504,-50.28,-.0691,-.1373,.9881,2.78,},{12.68,-50.77,-.0685,-.1869,.98,2.78},{17.86,-50.24,-.2042,-.1869,.9609,3.13},},[12]={{-7.26,-40.97,.4912,-.1869,.8508,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{22.95,-44.76,-.2564,-.137300000125,.9568,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{2.49,-44.47,.2578,-.0871,.9623,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{-2.51,-43.09,.3791,-.1373,.9151,0},{-2.39,-42.81,.3812,-.0871,.9204,0},{-2.58,-43.27,.3759,-.1869,.9076,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{27.95,-43.27,-.3759,-.1869,.9076,0},},[13]={{-7.53,-45.5,.5506,.3502,.7578,8.33},{5.33,-50.65,.2606,.3256,.9089,5.89,},{18.5,-51.98,-.0662,.3173,.946,4.82},},[14]={{-7.53,-45.5,.5506,.3502,.7578,8.33},{5.33,-50.65,.2606,.3256,.9089,5.89},{18.5,-51.98,-.0662,.3173,.946,4.82},},[15]={{-7.53,-45.5,.5506,.3502,.7578,8.33},{5.33,-50.65,.2606,.3256,.9089,5.89},{18.5,-51.98,-.0662,.3173,.946,4.82},},[16]={{-51.77,-16.03,.9811,-.0871,.173,1.72},{-52.07,-16.06,.9755,-.1373,.172,1.73},{-52.27,-16.09,.9675,-.1869,.1706,1.740000000259},{-51.37,-15.97,.9811,-.0871,.173,1.76},{-50.37,-20.97,.9474,-.0871,.3078,2.09},{-50.77,-21.08,.942,-.1373,.3061,2.09},{-48.740000000906,-25.8,.883,-.1869,.4306,2.57},{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-52.41,-10.88,.9881,-.1373,.0691,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},},[17]={{2.36,-43.85,-.3812,-.0871,.9204,0,},{-27.91,-44.12,.3791,-.137300000167,.9151,0},{-27.79,-43.850000000369,.3812,-.0871,.9204,0},{-2.52,-45.5,-.2578,-.0871,.9623,0},{-47.09,-27.3,.8578,-.1373,.4953,0},{-47.26,-27.4,.8508,-.1869,.4912,0},{-27.98,-44.31,.3759,-.1869,.9076,0},{-23.04,-45.98,.2543,-.1869,.9489,0},{-22.91,-45.5,.2578,-.0871,.9623,0},{-52.07,-12.63,.9821,-.137300000389,.1293,0},{-22.99,-45.79,.2564,-.1373,.9568,0},{-51.25,-17.78,.9489,-.1869,.2543,0},},[18]={{-47.09,20.39,.8578,-.1373,-.4953,0},{-43.97,-23.43,.7903,-.0871,.6064,0},{-44.36,24.83,.7794,-.1869,-.598,0},{-44.36,-23.74,.7794,-.1869,.598,0},{-47.26,-19.4,.8508,-.1869,.4912,0},{-47.09,-19.3,.8578,-.1373,.4953,0},{-43.97,24.53,.7903,-.0871,-.6064,0},{-46.83,20.24,.8627,-.0871,-.4981,0},{-44.21,24.71,.7858,-.1373,-.603,0},{-49.11,15.62,.9204,-.0871,-.3812,0},{-40.92,-27.66,.6946,-.1869,.6946,0},},[19]={{-43.360000000973,-17.97,.883,.3422,.3214,25.78},{-43.56,-5.72,.9025,.4002,.1591,27.98},{-43.94,.02,.9164,.4002,-0,28.02},},[20]={{-43.36,-17.97,.883,.3422,.3214,25.26},{-43.94,.02,.9164,.4002,-0,26.17},{-43.56,-5.72,.9025,.4002,.1591,26.19},},[21]={{-43.94,.02,.9164,.4002,-0,25.42},{-43.56,-5.72,.9025,.4002,.1591,25.54},{-43.36,-17.97,.883,.3422,.3214,26.66},},[22]={{-43.94,.02,.9164,.4002,-0,27.11},{-43.56,-5.72,.9025,.4002,.1591,27.31},{-43.36,-17.97,.883,.3422,.3214,30.09},},[23]={{-43.94,.02,.9164,.4002,-0,28.02},{-43.56,-5.72,.9025,.4002,.1591,28.25},{-43.36,-17.97,.883,.3422,.3214,31.44},},[24]={{-42.83,.62,.8809,.4002,-.2526,3.93},{-44.04,1.12,.9032,.3422,-.259,4.01},},[25]={{-41.870000000877,-1.64,.8795,.4595,-.1236,.26},{-41.45,-17.47,.8497,.4002,.3433,.27},{-41.11,-13.15,.8618,.4595,.2149,.52},{-42.76,2.59,.8809,.4002,-.2526,.55},{-42.76,-13.59,.8892,.4002,.2217,.55},{-44.21,-13.98,.9117,.3422,.2273,.57},{-41.87,-9.36,.8833,.4595,.0928,.77},{-43.56,-9.58,.9114,.4002,.0958,.82},{-45.04,-9.78,.9345,.3422,.0982,.86},{-42.12,-5.5,.8876,.4595,-.031,1.03},{-43.83,-5.5,.9159,.4002,-.032,1.09},{-43.56,-1.42,.9025,.4002,-.1591,1.36},},[26]={{-42.76,-5.59,.8892,.4002,.2217,.55},{-43.56,-1.58,.9114,.4002,.0958,.82},{-43.83,2.5,.9159,.4002,-.032,1.09},{-41.45,-9.47,.8612,.4002,.3134,1.36},{-41.11,-5.15,.8688,.4595,.1847,1.55},},[27]={{-40.930000000429,-6.38,.8372,.4002,.3728,3.67}},[28]={{-42.07,-5.08,.8612,.4002,.3134,6.35}},},[8]={[1]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.070000000273,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.060000000425,-.9755,-.1373,.172,1.730000000285},{49.35,4.31,-.930800000753,-.1373,-.3388,1.73},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.74},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.73,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09,},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41},{52.03,-5.7,-.9881,-.1373,-.0691,2.42,},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[2]={{47.23,-26.36,-.8508,-.1869,.4912,0},{52.03,-11.6,-.9821,-.1373,.1293,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{52.03,-1.24,-.9821,-.1373,-.1293,0},{27.95,-43.27,-.3759,-.1869,.9076,0},{51.21,-16.74,-.9489,-.1869,.2543,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{47.06,-26.26,-.8578,-.1373,.4953,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{22.88,-44.470000000581,-.2578,-.0871,.9623,0},{52.23,-1.21,-.974,-.1869,-.1282,0},{52.57,-6.420000000543,-.9824,-.1869,0,0},{52.37,-6.42,-.9905,-.1373,0,0},{52.07,-6.42,-.9962,-.0871,0,0,},{51.74,-11.56,-.9877,-.0871,.13,0},},[3]={{44.33,-23.07,-.7794,-.1869,.598,0},{47.06,-18.63,-.8578,-.1373,.4953,0},{52.03,-3.96,-.9821,-.1373,.1293,0},{51.21,-9.11,-.9489,-.1869,.2543,0},{47.23,-18.730000000626,-.8508,-.1869,.4912,0},{51.02,-9.06,-.9568,-.1373,.2564,0},{36.66,-30.04,-.6064,-.0871,.7903,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{52.23,-3.99,-.974,-.1869,.1282,0},{51.74,-3.93,-.9877,-.0871,.13,0},{36.84,-30.27,-.603,-.1373,.7858,0,},{52.57,1.22,-.9824,-.1869,0,0},{49.07,-13.86,-.9204,-.0871,.3812,0},{36.97,-30.43,-.598,-.1869,.7794,0},{49.350000000395,-13.97,-.9151,-.1373,.3791,0},{43.93,-22.76,-.7903,-.0871,.6064,0},},[4]={{44.33,-15.9,-.7794,-.1869,.598,0},{51.21,-1.94,-.9489,-.1869,.2543,0,},{52.03,3.21,-.9821,-.1373,.1293,0},{32.53,-25.99,-.4953,-.1373,.8578,0,},{32.63,-26.16,-.4912,-.1869,.8508,0},{32.38,-25.73,-.4981,-.0871,.8627,0,},{47.06,-11.46,-.8578,-.1373,.4953,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{52.23,3.18,-.974,-.1869,.1282,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{36.66,-22.86,-.6064,-.0871,.7903,0},{49.54,-6.88,-.9076,-.1869,.3759,0},{36.84,-23.1,-.603,-.1373,.7858,0},{43.93,-15.59,-.7903,-.0871,.6064,0},},[5]={{46.44,31.45,-.8331,-.1869,-.5206,1.650000000295},{49.54,-3.31,-.9308,-.1373,.3388,1.75},{52.03,17.140000000383,-.9675,-.1869,-.1706,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.975500000467,-.1373,-.172,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.1373,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.73,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41,},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43},{52.23,6.75,-.98,-.1869,.0685,2.44,},},[6]={{30.89,-7.75,-.9606,-.0362,.2755,10.85},{31.71,-3.64,-.9896,-.0362,.1391,11.72},{31.98,.54,-.9993,-.0362,0,12.77},{33.79,-8.52,-.9606,-.0362,.2755,13.28},{32.32,-12.86,-.9266,-.0362,.3744,13.54},{34.68,-4.03,-.9896,-.0362,.1391,13.74},{31.71,4.71,-.9896,-.0362,-.1391,13.94},{34.98,.54,-.9993,-.0362,0,14.36},{34.68,5.1,-.9896,-.0362,-.1391,15.1},{30.89,8.82,-.9606,-.0362,-.2755,15.18},{36.69,-9.3,-.9606,-.0362,.2755,15.9,},{33.79,9.59,-.9606,-.0362,-.2755,15.92},{37.66,-4.42,-.9896,-.0362,.1391,16.080000000485},{32.89,-18.46,-.8655,-.0362,.4997,16.11},{35.09,-14.01,-.9266,-.0362,.3744,16.28},{37.98,.54,-.9993,-.0362,0,16.36},},[7]={{30.89,-7.75,-.9606,-.0362,.2755,7.6},{31.71,-3.64,-.9896,-.0362,.1391,8.15},{31.98,.54,-.9993,-.0362,0,9},{31.71,4.71,-.9896,-.0362,-.1391,10.06},{33.79,-8.52,-.9606,-.0362,.2755,10.45},{32.32,-12.86,-.9266,-.0362,.3744,10.58},{34.68,-4.03,-.9896,-.0362,.1391,10.7},{34.98,.54,-.9993,-.0362,0,11.15},{30.89,8.82,-.9606,-.0362,-.2755,11.24},{34.68,5.1,-.9896,-.0362,-.1391,11.76},{33.79,9.59,-.9606,-.0362,-.2755,12.5},{36.69,-9.3,-.9606,-.0362,.2755,13.37},{37.66,-4.42,-.9896,-.0362,.1391,13.44},{32.89,-18.46,-.8655,-.0362,.4997,13.49},{35.09,-14.01,-.9266,-.0362,.3744,13.54,},{35.09,15.08,-.9266,-.0362,-.3744,13.61},},[8]={{31.98,.54,-.9993,-.0362,0,5.75},{31.71,4.71,-.9896,-.0362,-.1391,5.85},{31.71,-3.64,-.9896,-.0362,.1391,6.13},{30.89,8.82,-.9606,-.0362,-.2755,6.39},{30.89,-7.75,-.9606,-.0362,.2755,6.89},{34.98,.54,-.9993,-.0362,0,8.74},{34.68,5.1,-.9896,-.0362,-.139100000224,8.79},{34.68,-4.03,-.9896,-.0362,.1391,8.93},{33.79,9.59,-.9606,-.0362,-.2755,9.09},{32.32,-12.86,-.9266,-.0362,.374400000677,9.09,},{33.79,-8.52,-.9606,-.0362,.2755,9.34},{35.09,15.08,-.9266,-.0362,-.3744,11.68},{35.09,-14.01,-.9266,-.0362,.3744,11.68},{37.98,.54,-.9993,-.0362,0,11.73},{37.66,5.5,-.9896,-.0362,-.139100000269,11.77},{37.66,-4.42,-.9896,-.0362,.1391,11.82},},[9]={{7.23,-41.860000000494,-.4912,-.1869,.8508,0},{-27.910000000679,-43.99,.3791,-.1373,.9151,0},{-22.99,-45.66,.256400000246,-.1373,.9568,0},{-22.91,-45.37,.2578,-.0871,.9623,0},{2.36,-43.71,-.3812,-.0871,.9204,0},{-2.52,-45.37,-.2578,-.0871,.9623,0},{2.55,-44.17,-.3759,-.1869,.9076,0},{2.47,-43.99,-.3791,-.1373,.9151,0,},{6.98,-41.43,-.4981,-.0871,.8627,0},{7.13,-41.69,-.4953,-.1373,.8578,0},{-27.79,-43.71,.3812,-.0871,.9204,0},{-23.04,-45.85,.2543,-.1869,.9489,0},{-27.98,-44.17,.3759,-.1869,.9076,0},},[10]={{-12.72,-50.58,.0691,-.1373,.9881,2.77},{-12.72,-50.28,.0691,-.1373,.9881,2.78},{-12.72,-50.77,.0685,-.1869,.98,2.78},{-17.9,-50.24,.2042,-.1869,.9609,3.13},},[11]={{51.74,-16.03,-.9811,-.0871,.173,1.72},{49.07,4.19,-.9361,-.0871,-.3407,1.72},{52.03,-16.06,-.9755,-.1373,.172,1.73},{49.35,4.31,-.9308,-.1373,-.3388,1.73},{49.54,4.38,-.9231,-.1869,-.336,1.74},{52.23,-16.09,-.9675,-.1869,.1706,1.740000000315},{51.33,-15.97,-.9811,-.0871,.173,1.76},{50.730000000228,-.69,-.9744,-.0871,-.2071,2.06},{51.02,-.61,-.9689,-.1373,-.2059,2.08},{51.21,-.56,-.9609,-.1869,-.2042,2.09},{50.34,-.79,-.9744,-.0871,-.2071,2.09},{50.34,-20.97,-.9474,-.0871,.3078,2.09},{50.73,-21.08,-.942,-.1373,.3061,2.09},{51.74,-5.74,-.9938,-.0871,-.0695,2.41,},{52.030000000448,-5.7,-.9881,-.1373,-.0691,2.420000000209},{51.33,-5.79,-.9938,-.0871,-.0695,2.43},},[12]={{47.23,-26.36,-.8508,-.1869,.4912,0},{52.03,-11.6,-.9821,-.1373,.1293,0},{27.87,-43.09,-.3791,-.1373,.9151,0},{52.03,-1.24,-.9821,-.1373,-.1293,0},{27.95,-43.27,-.3759,-.1869,.9076,0},{51.21,-16.74,-.9489,-.186900000906,.2543,0},{27.76,-42.81,-.3812,-.0871,.9204,0},{22.95,-44.76,-.2564,-.1373,.9568,0},{47.06,-26.260000000956,-.8578,-.1373,.4953,0},{23.01,-44.95,-.2543,-.1869,.9489,0},{22.88,-44.47,-.2578,-.0871,.9623,0},{52.23,-1.21,-.974,-.1869,-.1282,0},{52.57,-6.42,-.9824,-.1869,0,0},{52.37,-6.42,-.9905,-.1373,0,0},{52.07,-6.42,-.9962,-.0871,0,0},{51.74,-11.56,-.9877,-.0871,.13,0},},[13]={{44.33,-23.07,-.7794,-.1869,.598000000412,0},{47.06,-18.63,-.8578,-.1373,.4953,0},{52.03,-3.96,-.982100000396,-.1373,.1293,0},{51.21,-9.11,-.948900000618,-.1869,.2543,0},{47.23,-18.73,-.8508,-.1869,.4912,0},{51.02,-9.06,-.9568,-.1373,.2564,0},{36.66,-30.04,-.6064,-.0871,.7903,0},{50.73,-8.98,-.9623,-.0871,.2578,0},{52.23,-3.99,-.974,-.1869,.1282,0},{51.74,-3.93,-.9877,-.0871,.13,0,},{36.84,-30.27,-.603,-.1373,.7858,0},{52.57,1.22,-.9824,-.1869,0,0},{49.07,-13.86,-.920400000436,-.0871,.3812,0},{36.97,-30.43,-.598,-.1869,.7794,0},{49.35,-13.97,-.9151,-.1373,.3791,0},{43.93,-22.76,-.7903,-.0871,.6064,0},},[14]={{44.33,-15.9,-.7794,-.1869,.598,0},{51.21,-1.94,-.9489,-.1869,.2543,0},{52.03,3.21,-.9821,-.1373,.1293,0},{32.53,-25.99,-.4953,-.1373,.8578,0},{32.63,-26.16,-.4912,-.1869,.8508,0},{32.38,-25.73,-.4981,-.0871,.8627,0},{47.06,-11.46,-.8578,-.1373,.4953,0},{47.23,-11.56,-.8508,-.1869,.4912,0},{49.07,-6.69,-.9204,-.0871,.3812,0},{51.02,-1.89,-.9568,-.1373,.2564,0},{52.23,3.180000000764,-.974,-.1869,.1282,0},{50.73,-1.81,-.9623,-.0871,.2578,0},{36.66,-22.86,-.6064,-.0871,.7903,0},{49.54,-6.88,-.9076,-.1869,.375900000178,0},{36.84,-23.1,-.603,-.1373,.7858,0,},{43.93,-15.590000000227,-.7903,-.0871,.6064,0},},[15]={{46.44,31.45,-.8331,-.1869,-.5206,1.650000000106},{49.54,-3.31,-.9308,-.1373,.338800000319,1.75},{52.03,17.14,-.9675,-.1869,-.1706,1.75},{49.35,-3.23,-.9361,-.0871,.3407,1.75},{51.74,17.1,-.9755,-.1373,-.172,1.75},{51.33,17.04,-.9811,-.0871,-.173,1.76},{50.73,1.76,-.9744,-.0871,.2071,2.06},{51.02,1.68,-.9689,-.137300000297,.2059,2.08},{51.21,1.63,-.9609,-.1869,.2042,2.09},{50.34,1.86,-.9744,-.0871,.2071,2.09},{50.34,22.05,-.9474,-.0871,-.3078,2.09},{50.730000000493,22.15,-.942,-.1373,-.3061,2.09},{51.74,6.81,-.9938,-.0871,.0695,2.41},{52.03,6.77,-.9881,-.1373,.0691,2.42},{51.33,6.87,-.9938,-.0871,.0695,2.43,},{52.23,6.75,-.98,-.1869,.0685,2.440000000419},},[16]={{-12.72,-50.58,.0691,-.1373,.9881,2.770000000299},{-12.72,-50.28,.0691,-.1373,.9881,2.78},{-12.72,-50.77,.0685,-.1869,.98,2.78},{-17.9,-50.24,.2042,-.1869,.9609,3.13},},[17]={{7.23,-42,-.4912,-.1869,.8508,0},{-27.91,-44.12,.3791,-.1373,.9151,0},{-22.99,-45.79,.2564,-.1373,.9568,0},{-22.91,-45.5,.2578,-.0871,.9623,0},{2.36,-43.85,-.3812,-.0871,.9204,0},{-2.52,-45.5,-.2578,-.0871,.9623,0},{2.55,-44.31,-.3759,-.1869,.9076,0},{2.47,-44.12,-.3791,-.1373,.9151,0},{6.98,-41.57,-.4981,-.0871,.8627,0},{7.13,-41.83,-.4953,-.1373,.8578,0},{-27.79,-43.85,.3812,-.0871,.9204,0},{-23.04,-45.98,.2543,-.1869,.9489,0},{-27.980000000556,-44.31,.3759,-.1869,.9076,0},},[18]={{11.57,32.2,-.598,-.1869,-.7794,0,},},[19]={{39.760000000256,3.72,-.8114,.4595,-.3613,3.61},{42.95,.62,-.8809,.4002,-.2526,3.93},{44.16,1.12,-.9032,.3422,-.259,4.01},{41.57,.05,-.8618,.4595,-.2149,4.82},{39.72,8.83,-.7937,.4002,-.4582,5.11},},[20]={{39.76,-22.09,-.7937,.4002,.4582,0},{41.99,-2.59,-.8806,.4595,-.1159,0},{42.24,-6.45,-.888200000151,.4595,0,0},{44.33,2.03,-.9076,.3422,-.2432,0},{42.88,1.64,-.8852,.4002,-.2372,0},{41.57,5.51,-.8467,.4002,-.3507,0},{43.95,-6.45,-.9164,.4002,0,0},{41.57,-18.42,-.8467,.4002,.3507,0},{42.88,-14.54,-.8852,.4002,.2372,0},{44.33,-14.93,-.9076,.3422,.2432,0},{41.99,-10.31,-.8806,.4595,.1159,0},{43.68,-10.53,-.9086,.4002,.1196,0},{43.68,-2.37,-.9086,.4002,-.1196,0,},{39.76,9.18,-.7937,.4002,-.4582,0},},[21]={{39.76,-13.85,-.7937,.4002,.4582,0},{39.76,17.42,-.7937,.4002,-.4582,0},},[22]={{41.23,1.95,-.861800000184,.4595,.2149,.52},{41.23,17.25,-.8538,.459500000216,-.2448,.52},{42.88,17.69,-.8809,.4002,-.2526,.55},{42.88,1.51,-.8892,.4002,.221700000234,.550000000762},{44.33,1.12,-.9117,.3422,.2273,.57},{41.99,5.74,-.8833,.4595,.0928,.77},{39.99,20.91,-.8114,.4595,-.3613,.77},{41.57,21.570000000453,-.8372,.4002,-.3728,.82},{43.68,5.52,-.9114,.4002,.0958,.82},{45.16,5.32,-.9345,.3422,.0982,.86},{42.24,9.6,-.8876,.4595,-.031,1.03},{39.76,-6.03,-.8092,.4002,.4302,1.09},{43.95,9.6,-.9159,.4002,-.032,1.09},{39.99,-1.71,-.8346,.4595,.3038,1.29},{41.99,13.46,-.8747,.4595,-.1542,1.29},{41.57,-2.36,-.8612,.4002,.3134,1.36,},},[23]={{39.76,-3.68,-.8114,.4595,.3613,3.61},{41.05,-4.43,-.8372,.4002,.3728,3.67},{42.95,-.58,-.8809,.4002,.2526,3.93},{44.16,-1.09,-.9032,.3422,.259,4.01},{41.57,-.01,-.8618,.4595,.2149,4.82},{39.720000000745,-8.79,-.7937,.4002,.4582,5.11},},[24]={{43.48,-17.97,-.883,.3422,.3214,25.78},{40.71,-16.82,-.8346,.459500000508,.3038,26.02},{43.68,-5.72,-.9025,.4002,.1591,27.98,},{44.06,.02,-.9164,.4002,0,28.02},{43.68,5.76,-.9075,.4002,-.1275,28.58,},{40.71,16.86,-.8346,.4595,-.3038,31.6},},[25]={{43.48,-17.97,-.883,.3422,.3214,25.29},{40.71,-16.82,-.8346,.4595,.3038,25.52},{44.06,.02,-.9164,.4002,0,25.95},{43.68,-5.72,-.9025,.4002,.1591,25.98},{43.68,5.76,-.9075,.4002,-.1275,26.21},{40.71,16.860000000883,-.8346,.4595,-.3038,28.28},},[26]={{43.68,5.76,-.9075,.4002,-.1275,25.31},{44.06,.02,-.9164,.4002,0,25.48,},{43.68,-5.72,-.902500000355,.4002,.1591,25.61},{40.71,16.86,-.8346,.459500000944,-.3038,25.85,},{43.48,-17.97,-.883,.3422,.3214,26.9},{40.71,-16.82,-.8346,.4595,.3038,27.11},},[27]={{40.71,16.86,-.8346,.4595,-.3038,25.7},{43.68,5.76,-.907500000235,.4002,-.1275,26.7},{44.06,.02,-.9164,.4002,0,27.25},{43.68,-5.720000000208,-.9025,.4002,.1591,27.46},{43.48,-17.97,-.883,.3422,.3214,30.31},{40.71,-16.82,-.8346,.4595,.3038,30.48},},[28]={{40.71,16.86,-.8346,.4595,-.3038,26.02,},{43.68,5.76,-.9075,.4002,-.1275,27.39},{44.06,.02,-.9164,.4002,0,28.02},{43.68,-5.72,-.9025,.4002,.1591,28.25},{43.48,-17.97,-.883,.3422,.3214,31.44},{40.71,-16.82,-.8346,.4595,.3038,31.6},},},})
		end
	local ah=loadStandData()
	local aE,aG,aH=workspace,Players,LP
	local aA,aB=Vector3.new,CFrame.new
	local aQ,aY,aP=Vector3.new(1,0,1),Vector3.new(0,.4,0),Vector3.new(2.4,4.6,2.4)
	local aO=2.21
	local a9=RaycastParams.new();a9.FilterType=Enum.RaycastFilterType.Exclude;a9.RespectCanCollide=true;a9.IgnoreWater=true
	local overlap=OverlapParams.new();overlap.FilterType=Enum.RaycastFilterType.Exclude;overlap.RespectCanCollide=true;overlap.MaxParts=1
	local function Character()
		local c=LP.Character;return c,c and c:FindFirstChild("HumanoidRootPart"),c and c:FindFirstChildOfClass("Humanoid")
	end
	local function Lift()local _,r,h=Character();return r and h and h.HipHeight+r.Size.Y*.5 or 2.7 end
	local function RefreshFilter()
		local skip={};for _,p in ipairs(Players:GetPlayers())do if p.Character then skip[#skip+1]=p.Character end end
		a9.FilterDescendantsInstances=skip;overlap.FilterDescendantsInstances=skip
		local _,root=Character();if root then a9.CollisionGroup=root.CollisionGroup;overlap.CollisionGroup=root.CollisionGroup end
	end
	local function BodyClear(position)return#workspace:GetPartBoundsInBox(CFrame.new(position+aY),aP,overlap)==0 end
			local function StandWorld(j,k)
				RefreshFilter()
				local l=j:PointToWorldSpace(aA(k[1],aO,k[2]))
				local m=aE:Raycast(l+aA(0,2,0),aA(0,-8,0),a9)
				if not m or m.Normal.Y<.95 then
					return nil,nil
				end
				return m.Position+aA(0,Lift(),0),j:VectorToWorldSpace(aA(k[3],k[4],k[5])).Unit
			end
			local function PlayerNear(j)
				for k,l in aG:GetPlayers()do
					local m=l~=aH and l.Character and l.Character:FindFirstChild("HumanoidRootPart")
					if m and m:IsA("BasePart")and((m.Position-j)*aQ).Magnitude<3 then
						return true
					end
				end
				return false
			end
			local function Usable(j)
				return j~=nil and BodyClear(j)and not PlayerNear(j)
			end
			local function PickStand(j,k)
				local l=ah[j:GetAttribute("Order")]
				local m,n=Character()
				local o=j:FindFirstChild("MainRoot")
				if not l or not n or not o or not o:IsA("BasePart")then
					return nil,nil
				end
				local p=o.CFrame
				local q=p:PointToObjectSpace(n.Position)
				local r={}
				for s,u in k do
					for v,w in l[u]or{}do
						r[#r+1]={w,(w[1]-q.X)^2+(w[2]-q.Z)^2}
					end
				end
				table.sort(r,function(s,u)
					return s[2]<u[2]
				end)
				for s,u in r do
					local v,w=StandWorld(p,u[1])
					if v and Usable(v)then
						return v,w
					end
				end
				return nil,nil
			end
	_G.ElysiumDonorFlashStand=function(pet,position)
		local plots=workspace:FindFirstChild("Plots");local plot=plots and plots:FindFirstChild(tostring(pet.plot))
		local main=plot and plot:FindFirstChild("MainRoot")
		local slot=tonumber(pet.slot)
		if not main or not slot then return nil end
		local floor=slot<=10 and 1 or slot<=18 and 2 or 3
		local frame=main.CFrame
		local average,count=0,0
		for _,p in ipairs(plots:GetChildren())do local root=p:FindFirstChild("MainRoot");if root and root:IsA("BasePart")then average+=root.Position.X;count+=1 end end
		average=count>0 and average/count or-409.6
		local cross=(frame:PointToObjectSpace(position).X>=0)~=(frame:PointToObjectSpace(pet.position).X>=0)
			or(floor>=2 and(position.X>=average)~=(main.Position.X>=average))
		local under=_G.ElysiumGoApproachF2~=false
		if floor>=2 and not(under and floor==2)and(cross or not under)then
			local front={-1.15,-52.82,.0402,.3427,.9386}
			local side={{-52.6,-24.88,.925,.2057,.3194},{50.95,-28.8,-.8799,.1998,.4311}}
			local entry=_G.ElysiumFlashEntry or"Multi"
			local candidates=entry=="Front"and{front}or entry=="Side"and side or{front,side[1],side[2]}
			local best,aim,distance=nil,nil,math.huge
			for _,candidate in ipairs(candidates)do
				local point,direction=StandWorld(frame,candidate)
				if point and Usable(point)then local d=((point-position)*aQ).Magnitude;if d<distance then best,aim,distance=point,direction,d end end
			end
			return best,aim
		end
		return PickStand(plot,cross and{1,2,3,4,5,6,7,8,9,10}or{slot})
	end
end
function ElysiumToolInventory()
	local out={}
	local function scan(container,where)
		if not container then return end
		for _,item in ipairs(container:GetChildren())do
			if item:IsA("Tool")or item:IsA("Model")or item:IsA("Accessory")or item:IsA("Folder")then
				if item:IsA("Tool")or table.find(CARPET_NAMES or{},item.Name)or item.Name:lower():find("carpet",1,true)
					or item.Name:lower():find("waverider",1,true)then
					out[#out+1]=where..":"..item.ClassName..":"..item.Name
				end
			end
		end
	end
	scan(LP.Character,"char")
	scan(LP:FindFirstChild("Backpack"),"backpack")
	scan(LP:FindFirstChild("StarterGear"),"startergear")
	return table.concat(out,", ")
end
function ElysiumTPStartTrace(stage,detail)
	_G.ElysiumTPStartStage=stage
	local stages=_G.ElysiumTPStageLog
	if stage=="requested"or type(stages)~="table"then
		stages={}
		_G.ElysiumTPStageLog=stages
		_G.ElysiumTPStageFrom=os.clock()
	end
	if#stages<24 then
		stages[#stages+1]={stage=stage,at=os.clock()-(tonumber(_G.ElysiumTPStageFrom)or os.clock())}
	end
	local payload={
		stage=stage,detail=detail and tostring(detail)or nil,capturedAt=os.time(),
		stages=stages,
		movementStatus=tostring(_G.ElysiumTPMovementStatus),
		movementError=tostring(_G.ElysiumTPMovementError),
		gearError=tostring(_G.ElysiumCarpetRouteError),
		engage=tostring(_G.TPEngage),stop=_G.ElysiumTPStop==true,
		cloneClickError=tostring(_G.ElysiumCloneClickError),
		cloneClick=_G.ElysiumCloneClickDiag,
		cloneSettle=_G.ElysiumCloneSettleDiag,
		goToStatus=tostring(_G.ElysiumGoToStatus),goToDetail=tostring(_G.ElysiumGoToDetail),
		goStart=_G.ElysiumGoStartDiag,carpetPrep=_G.ElysiumCarpetPrepHistory,
		carpetEnabled=_G.ElysiumCarpetEnabledLog,cloneHold=_G.ElysiumCloneHoldDiag,
		carpetStowedAt=tonumber(_G.ElysiumCarpetStowedAt),carpetCooldownEnds=tonumber(_G.ElysiumCarpetCooldownEnds),
		carpetSelected=_G.ElysiumCarpetTool,carpetLastRoute=_G.ElysiumRouteFlightTool,
		tools=select(2,pcall(ElysiumToolInventory)),
		grabMode=tostring(_G.ElysiumSourceStealMode),grabActive=_G.ElysiumSourceStealActive==true,
		autoBuyBlocked=_G.ElysiumAutoBuyTPBlocked==true,retryAfter=tonumber(_G.ElysiumTPRetryAfter),now=os.clock(),
	}
	local ok,err=pcall(function()
		if type(writefile)=="function"then
			writefile("Elysium-TP-Start.json",ElysiumService("HttpService"):JSONEncode(payload))
		end
	end)
	if not ok then warn("[Elysium TP trace] "..tostring(err))end
	if stage=="error"then warn("[Elysium TP] "..tostring(detail))end
end
function doVelocityTP(forceGrapple,forcedPet)
	local useFlash=_G.ElysiumFlashTP==true
	if useFlash and not findTool("Flash Teleport")then
		_G.ElysiumFlashStatus="missing_flash_tool"
		return false
	end
	if _G.ElysiumAutoBuyTPBlocked or os.clock()<(tonumber(_G.ElysiumTPRetryAfter)or 0)then
		return false
	end
	if _G.ElysiumSourceStealActive and _G.ElysiumSourceStealMode~="priority"then
		return false
	end
	if isTeleporting or _G.ElysiumFlashTeleportRun or _G.ElysiumFlashTeleportActive then
		return
	end
	if LP:GetAttribute("Stealing")==true then
		return
	end
	local initialPets=forcedPet and{forcedPet}or scanForTP()
	if isTeleporting or _G.Elysium_IsResetting or _G.ElysiumAutoBuyTPBlocked then return false end
	if _G.ElysiumOptimizerMode=="default"and type(_G.ElysiumOptimizerOnScan)=="function"then
		local ok,err=pcall(_G.ElysiumOptimizerOnScan,initialPets)
		if not ok then _G.ElysiumOptimizerError=tostring(err)end
	end
	isTeleporting=true
	_G._cframeTPGen=(_G._cframeTPGen or 0)+1
	_G._cframeStartDone=false
	if _G.ElysiumDisarmSteal then
		_G.ElysiumDisarmSteal()
	end
	_G.ElysiumTPStop=false
	clearViz()
	if not NetModule then
		pcall(loadNet)
	end
	local char=LP.Character
	local hrp=char and char:FindFirstChild("HumanoidRootPart")
	local hum=char and char:FindFirstChildOfClass("Humanoid")
	if not hrp or not hum then
		isTeleporting=false
		return
	end
	pcall(function()
		hrp.AssemblyLinearVelocity=Vector3.new(0,0,0)
		hrp.AssemblyAngularVelocity=Vector3.new(0,0,0)
	end)
	if _inVoid(hrp)or hrp.AssemblyLinearVelocity.Y<-40 then
		_waitOutOfVoid(12)
		if _G.ElysiumTPStop then
			isTeleporting=false
			return
		end
		char=LP.Character
		hrp=char and char:FindFirstChild("HumanoidRootPart")
		hum=char and char:FindFirstChildOfClass("Humanoid")
		if not hrp or not hum then
			isTeleporting=false
			return
		end
	end
	local allPets=initialPets
	if not forcedPet and#allPets==0 then
		local _t0=os.clock()
		while#allPets==0 and os.clock()-_t0<(tonumber(_G.ElysiumTPScanWait)or 3)do
			task.wait(.03)
			allPets=scanForTP()
		end
	end
	if not forcedPet and roadAllowed()then
		local road=roadWinner(allPets)
		if road then
			local arrived=flyToRoad(road)
			isTeleporting=false
			restoreAnimations()
			if arrived and _G.ElysiumBuySelectedRoadTarget then
				local ok,err=pcall(_G.ElysiumBuySelectedRoadTarget,road)
				if not ok then
					_G.ElysiumRoadTPLastError=tostring(err)
				end
			end
			return
		end
	end
	if#allPets==0 then
		isTeleporting=false
		return
	end
	if not forcedPet and _G.ElysiumFullScanFirst~=false then
		local _fs0=os.clock()
		local _fcap=tonumber(_G.ElysiumFullScanWait)or .1
		local _stale=tonumber(_G.ElysiumScanStaleGap)or .2
		local _prev=tonumber(_G.ElysiumScanNoChan)or 0
		local _lastProg=os.clock()
		while(tonumber(_G.ElysiumScanNoChan)or 0)>0 and os.clock()-_fs0<_fcap do
			if _G.ElysiumTPStop then
				break
			end
			task.wait(.03)
			allPets=scanForTP()
			local _now=tonumber(_G.ElysiumScanNoChan)or 0
			if _now<_prev then
				_prev,_lastProg=_now,os.clock()
			elseif os.clock()-_lastProg>=_stale then
				break
			end
		end
		if(tonumber(_G.ElysiumScanNoChan)or 0)>0 then
		end
	end
	if not forcedPet and not(type(_G.ElysiumStealTargetUID)=="string"and _G.ElysiumStealTargetUID~="")then
		local pool,seen={},{}
		local function _absorb(list)
			if type(list)~="table"then
				return
			end
			for _,p in ipairs(list)do
				if not p.conveyor and p.plot and p.slot~=nil then
					local uid=tostring(p.plot).."_"..tostring(p.slot)
					local ex=seen[uid]
					if not ex then
						seen[uid]=p
						pool[#pool+1]=p
					elseif(p.mps or 0)>(ex.mps or 0)then
						for i=1,#pool do
							if pool[i]==ex then
								pool[i]=p
								break
							end
						end
						seen[uid]=p
					end
				end
			end
		end
		_absorb(allPets)
		for _=1,(tonumber(_G.ElysiumTPScans)or 1)do
			task.wait(tonumber(_G.ElysiumTPScanGap)or .03)
			local _ok,_more=pcall(scanForTP)
			if _ok then
				_absorb(_more)
			end
		end
		if#pool>0 then
			allPets=pool
		end
	end
	local pet
	if forcedPet then
		pet=forcedPet
	elseif type(_G.ElysiumStealTargetUID)=="string"and _G.ElysiumStealTargetUID~=""then
		pet=_findStealTarget(allPets)
		if not pet then
			isTeleporting=false
			return
		end
	else
		local prio,best
		for _,p in ipairs(allPets)do
			if not p.conveyor then
				if p._pri and(not prio or p._pri<prio._pri)then
					prio=p
				end
				if not best or(p.mps or 0)>(best.mps or 0)then
					best=p
				end
			end
		end
		pet=prio or best or allPets[1]
	end
	if not pet or typeof(pet.position)~="Vector3"then
		_G.ElysiumGoToStatus="target_not_available"
		isTeleporting=false
		return false
	end
	local petPos=pet.position
	local petName=pet.name
	if pet.plot and type(_G.ElysiumOptimizerFocusPlot)=="function"then
		pcall(_G.ElysiumOptimizerFocusPlot,pet.plot)
	end
	if _G.ElysiumArmSteal then
		pcall(_G.ElysiumArmSteal,pet)
	end
	if type(_G.ElysiumStealSay)=="function"then
		pcall(
			_G.ElysiumStealSay,
			string.format(
				"TP start -> %s [%s/%s] mps=%s pri=%s of %d",
				tostring(pet and pet.name),
				tostring(pet and pet.plot),
				tostring(pet and pet.slot),
				tostring(pet and pet.mps),
				tostring(pet and pet._pri),
				#allPets
			)
		)
	end
	_G.ElysiumStealHold=true
	local function mountFlightGear()
		ElysiumTPStartTrace("equipping")
		local flightGear=ElysiumPrepareCarpetRoute()
		ElysiumTPStartTrace("equipped",flightGear and flightGear.Name or"missing")
		if not flightGear then
			_G.ElysiumStealHold=false
			isTeleporting=false
			restoreAnimations()
			return false
		end
		return true
	end
	local adjY=petPos.Y
	if TALL_PETS[petName]then
		adjY=petPos.Y-TALL_OFFSET
	end
	local coordTable=adjY>23.15 and MK_UPPER or MK_LOWER
	if not useFlash and petPos.Y<=8.9 and isPlotUnlocked(pet.plot)then
		vZero(hrp)
		local _to=Vector3.new(petPos.X,-4,petPos.Z)
		local route=ElysiumTPBestRoute(char,hrp,_to,nil)
		if not route or#route==0 then
			route={_to}
		end
		local length,previous=0,hrp.Position
		for _,wp in ipairs(route)do
			length=length+(wp-previous).Magnitude
			previous=wp
		end
		local speed=elysiumTPRouteSpeed(length,_isStraightRoute(hrp.Position,route))
		if type(_G.ElysiumTPSpeedOverride)=="function"then
			local ok,value=pcall(_G.ElysiumTPSpeedOverride,speed)
			if ok and tonumber(value)then speed=tonumber(value)end
		end
		if type(_G.ElysiumTPBeforeGear)=="function"then
			local ok,err=pcall(_G.ElysiumTPBeforeGear,hrp,route)
			if not ok then _G.ElysiumTPBeforeGearError=tostring(err)end
		end
		if not mountFlightGear()then return false end
		ElysiumTPStartTrace("starting_ground_route")
		local arrived=velMoveThrough(hrp,route,speed,true,true,nil,petPos)
		if hrp and hrp.Parent then
			_vzL(hrp)
			_vzA(hrp)
		end
		_G.ElysiumStealHold=false
		isTeleporting=false
		if not arrived or _G.ElysiumTPStop then
			return
		end
		return
	end
	ElysiumTPStartTrace("selecting_destination")
	local closestData,skyKey=findClosest(petPos,coordTable)
	if not closestData or not skyKey then
		_G.ElysiumStealHold=false
		isTeleporting=false
		return
	end
	local destPos=closestData.coord
	vZero(hrp)
	local facingDir=closestData.facing=="NORTH"and Vector3.new(0,0,-1)or Vector3.new(0,0,1)
	local _frontApproach=false
	do
		local isUpper=(coordTable==MK_UPPER)
		local idx=getClosestBaseIdx(petPos)
		local frontCoord,frontFace=buildFrontCandidate(idx,isUpper,hrp.Position.Z)
		local bestCoord,bestFace=frontCoord,frontFace
		local bestDist=(hrp.Position-frontCoord).Magnitude
		local pickedFront=true
		local _entry=_G.ElysiumFlashEntry or"Multi"
		local _forceSide=(_entry=="Side")
		local _forceFront=(_entry=="Front")
		local _sideOnly=_forceSide or(not _forceFront and not isUpper and _G.ElysiumFirstFloorSideOnly==true)
		local _tb=BASES_LOW[idx]
		local _isWest=idx<=4
		local _rowBlocked=false
		local _dx,_dz=hrp.Position.X-_tb.X,hrp.Position.Z-_tb.Z
		local _distToBase=math.sqrt(_dx*_dx+_dz*_dz)
		local _sideRange=tonumber(_G.ElysiumSideTPRange)or 100
		if not _sideOnly and _G.ElysiumPreferFrontOnRow~=false and _distToBase>_sideRange then
			for i=1,8 do
				if i~=idx and(i<=4)==_isWest then
					local bz=BASES_LOW[i].Z
					if(bz-hrp.Position.Z)*(bz-_tb.Z)<0 then
						_rowBlocked=true
						break
					end
				end
			end
		end
		if _sideOnly then
			bestDist=math.huge
		end
		if not _rowBlocked and not _forceFront then
			for _,d in ipairs(plotSides(coordTable,idx))do
				local dd=(hrp.Position-d.coord).Magnitude
				if dd<bestDist then
					bestDist=dd
					bestCoord=d.coord
					bestFace=d.facing=="NORTH"and Vector3.new(0,0,-1)or Vector3.new(0,0,1)
					pickedFront=false
				end
			end
		end
		destPos=bestCoord
		facingDir=bestFace
		_frontApproach=pickedFront
		if _G.ElysiumTPDebug~=false then
			local _mode=pickedFront and"FRONT"or"SIDE"
			if _forceFront then _mode="FRONT(forced)"end
			if _sideOnly then
				_mode=pickedFront and"FRONT(sideonly-fallback)"or"SIDE(sideonly)"
			end
			warn(
				string.format(
					"[ElysiumTP] PICK baseIdx=%d %s floor=%s | pet=(%.0f,%.0f,%.0f) plot=%s | dest=(%.0f,%.0f,%.0f) | me=(%.0f,%.0f,%.0f) | sides=%d",
					idx,
					_mode,
					isUpper and"2nd"or"1st",
					petPos.X,
					petPos.Y,
					petPos.Z,
					tostring(pet.plot),
					destPos.X,
					destPos.Y,
					destPos.Z,
					hrp.Position.X,
					hrp.Position.Y,
					hrp.Position.Z,
					#plotSides(coordTable,idx)
				)
			)
		end
	end
	if facingDir and facingDir.Magnitude>.1 then
		local axis=facingDir.Unit
		local toPlayer=hrp.Position-destPos
		local sign=axis:Dot(toPlayer)>=0 and 1 or-1
		destPos=destPos+axis*sign*(tonumber(_G.ElysiumCloneBackoff)or 0)
	end
	if useFlash then
		local stand,aim=_G.ElysiumDonorFlashStand(pet,hrp.Position)
		if not stand or not aim then
			_G.ElysiumFlashStatus="no_usable_stand";_G.ElysiumStealHold=false;isTeleporting=false;restoreAnimations();return false
		end
		destPos,facingDir=stand,aim
	end
	local route,routeKind
	if useFlash then
		route,routeKind=ElysiumTPLiftRoute(char,hrp,destPos,facingDir,_G.ElysiumCrestRoute==true),"lift"
	else
		route,routeKind=ElysiumTPBestRoute(char,hrp,destPos,facingDir,_G.ElysiumCrestRoute==true)
	end
	if _G.ElysiumTPLowRoute==true and not useFlash then
		route={destPos}
	end
	if not route or#route==0 then
		route={destPos}
	end
	local stepped,previous={},hrp.Position
	for _,wp in ipairs(route)do
		local dy=wp.Y-previous.Y
		if dy>15 then
			local count=math.ceil(dy/10)
			for step=1,count-1 do
				local t=step/count
				stepped[#stepped+1]=Vector3.new(
					previous.X+(wp.X-previous.X)*t,
					previous.Y+dy*t,
					previous.Z+(wp.Z-previous.Z)*t
				)
			end
		end
		stepped[#stepped+1]=wp
		previous=wp
	end
	local routeLength=0
	previous=hrp.Position
	for _,wp in ipairs(route)do
		routeLength=routeLength+(wp-previous).Magnitude
		previous=wp
	end
	local mainSpeed=elysiumTPRouteSpeed(routeLength,false)
	if type(_G.ElysiumTPSpeedOverride)=="function"then
		local ok,value=pcall(_G.ElysiumTPSpeedOverride,mainSpeed)
		if ok and tonumber(value)then mainSpeed=tonumber(value)end
	end
	if type(_G.ElysiumTPBeforeGear)=="function"and not useFlash then
		local ok,err=pcall(_G.ElysiumTPBeforeGear,hrp,stepped)
		if not ok then _G.ElysiumTPBeforeGearError=tostring(err)end
	end
	if not mountFlightGear()then return false end
	ElysiumTPStartTrace("starting_main_route")
	_G.ElysiumSideWallReachedAt=nil
	local mainMotion={
		sideWallHandoff=not useFlash and not _frontApproach and _G.ElysiumFlashEntry=="Side",
		face=facingDir,
		settleTime=tonumber(_G.ElysiumTPSettleTime)or .1,
		stowCarpet=not useFlash,
		replanRoute=(routeKind=="profile"and not useFlash)and function()
			local c=LP.Character
			local r=c and c:FindFirstChild("HumanoidRootPart")
			if not r then return nil end
			return ElysiumTPOverRoute(c,r,destPos)
		end or nil,
	}
	local arrived=velMoveThrough(hrp,stepped,mainSpeed,true,true,.65,nil,mainMotion)
	local sideWallArrived=not useFlash and _G.ElysiumSideWallReachedAt~=nil
	if
		not arrived
		and _G.ElysiumTPMovementStatus=="route_stalled"
		and not _G.ElysiumTPStop
		and not _G.ElysiumAutoBuyTPBlocked
		and not _G.Elysium_IsResetting
		and LP.Character==char
		and hrp.Parent==char
		and hum.Health>0
		and LP:GetAttribute("Stealing")~=true
		and(tonumber(LP:GetAttribute("RagdollEndTime"))or 0)<=workspace:GetServerTimeNow()
	then
		vZero(hrp)
		local retryRoute
		if routeKind=="profile"or useFlash then
			retryRoute=ElysiumTPLiftRoute(char,hrp,destPos,facingDir,true)
		else
			retryRoute=ElysiumTPBestRoute(char,hrp,destPos,facingDir,true)
		end
		if retryRoute and#retryRoute>0 then
			arrived=velMoveThrough(hrp,retryRoute,math.max(50,mainSpeed*.7),true,true,.65,nil,mainMotion)
		end
	end
	sideWallArrived=not useFlash and _G.ElysiumSideWallReachedAt~=nil
	if not arrived or _G.ElysiumTPStop then
		if hrp and hrp.Parent then
			vZero(hrp)
		end
		pcall(function()hum.AutoRotate=true end)
		_G.ElysiumStealHold=false
		isTeleporting=false
		restoreAnimations()
		return
	end
	local horizontalFacing=Vector3.new(facingDir.X,0,facingDir.Z)
	local faceUnit=horizontalFacing.Magnitude>.01 and horizontalFacing.Unit or nil
	pcall(function()hum.AutoRotate=false end)
	if faceUnit then hrp.CFrame=CFrame.lookAlong(hrp.Position,faceUnit)end
	local arrivedAt=os.clock()
	local platform=Instance.new("Part")
	platform.Name="Part"
	platform.Size=Vector3.new(4,1,4)
	local platformCenter=sideWallArrived and hrp.Position or destPos
	platform.Position=Vector3.new(platformCenter.X,platformCenter.Y-3,platformCenter.Z)
	platform.Anchored,platform.CanCollide,platform.Transparency=true,true,1
	platform.CanQuery=false
	platform.Material=Enum.Material.SmoothPlastic
	platform.Parent=workspace
	if not useFlash and _G.ElysiumClonePreEquip~=false then
		local bp=LP:FindFirstChild("Backpack")
		local cloner=bp and bp:FindFirstChild("Quantum Cloner")
		if cloner then pcall(ElysiumHoldCloner,char,hum,cloner)end
	end
	local settleSpeed=tonumber(_G.ElysiumCloneSettleSpeed)or 60
	local settleStart,stable=os.clock(),0
	while not sideWallArrived and os.clock()-settleStart<.6 and not _G.ElysiumTPStop do
		if LP.Character~=char or not hrp.Parent then break end
		local delta=destPos-hrp.Position
		if delta.Magnitude>6 then break end
		if delta.Magnitude<=.65 then
			hrp.AssemblyLinearVelocity=Vector3.zero;stable+=1
			if stable>=1 then break end
		else
			stable=0
			hrp.AssemblyLinearVelocity=delta.Unit*math.min(settleSpeed,delta.Magnitude*8)
		end
		if faceUnit then hrp.CFrame=CFrame.lookAlong(hrp.Position,faceUnit)end
		hrp.AssemblyAngularVelocity=Vector3.zero
		RunService.Heartbeat:Wait()
	end
	if(not sideWallArrived and stable<1)or _G.ElysiumTPStop then
		pcall(function()hum.AutoRotate=true end)
		platform:Destroy()
		vZero(hrp);_G.ElysiumTPMovementStatus="landing_not_stable";_G.ElysiumTPRetryAfter=os.clock()+1.5
		_G.ElysiumStealHold=false;isTeleporting=false;restoreAnimations();return false
	end
	if faceUnit then hrp.CFrame=CFrame.lookAlong(hrp.Position,faceUnit)end
	vZero(hrp)
	_G.ElysiumStealHold=false
	local landUntil=arrivedAt+(tonumber(_G.ElysiumCloneLandHold)or .05)
	while os.clock()<landUntil and not _G.ElysiumTPStop do
		local live=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if live and faceUnit then
			live.CFrame=CFrame.lookAlong(live.Position,faceUnit)
			live.AssemblyAngularVelocity=Vector3.zero
		end
		RunService.Heartbeat:Wait()
	end
	do
		local live=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		if live and faceUnit then
			live.CFrame=CFrame.lookAlong(live.Position,faceUnit)
			_vzL(live)
			_vzA(live)
		end
	end
	local cloneOK=false
	local swapConfirmed=false
	if not _G.ElysiumTPStop then
		if useFlash then
			cloneOK=elysiumFireFlash(facingDir)
			swapConfirmed=cloneOK
		else
			cloneOK=doClone()
		end
	end
	local cloneWait=math.clamp(math.max(tonumber(_G.ElysiumCloneSettle)or 1.2,(_pingMs()/1000)*4+.6),1.2,4)
	if not useFlash then
		_G.ElysiumGoToStatus="waiting_clone"
		local pendingRequest=_G.ElysiumCloneRequest
		if cloneOK and type(pendingRequest)=="table"and _G.ElysiumGoEarlyCarpet~=false then
			pendingRequest.onRelocated=function()
				local c=LP.Character
				local h=c and c:FindFirstChildOfClass("Humanoid")
				if c and h and type(ElysiumEquipCarpetOnly)=="function"then
					ElysiumEquipCarpetOnly(c,h)
				end
			end
		end
		local cloneClickedAt=os.clock()
		swapConfirmed=cloneOK and waitCloneRelocation(_G.ElysiumCloneRequest,cloneWait)
		_G.ElysiumCloneToGoWaitSeconds=os.clock()-cloneClickedAt
		_G.ElysiumGoStartDiag={cloneClicked=cloneClickedAt,relocated=os.clock(),swapConfirmed=swapConfirmed==true}
		local request=_G.ElysiumCloneRequest
		local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		local diag=_G.ElysiumCloneClickDiag
		if diag and request and root then
			diag.displacement=tostring(root.Position-request.position)
			diag.velocity=tostring(root.AssemblyLinearVelocity)
			diag.confirmed=swapConfirmed==true
			diag.buttonVisible=request.button and request.button.Parent~=nil and request.button.Visible or false
		end
	end
	_G.isCloning=false
	if platform then
		platform:Destroy()
	end
	if cloneOK and not swapConfirmed then
		_G.ElysiumTPMovementStatus="clone_not_confirmed"
		_G.ElysiumGoToStatus="clone_not_confirmed"
		_G.ElysiumTPRetryAfter=os.clock()+1.5
	end
	pcall(function()
		local h=LP.Character and LP.Character:FindFirstChildOfClass("Humanoid")
		if h then
			h.AutoRotate=true
		end
	end)
	if not cloneOK or not swapConfirmed or _G.ElysiumTPStop then
		isTeleporting=false
		restoreAnimations()
		return
	end
	if pet and _G.ElysiumArmSteal then
		pcall(_G.ElysiumArmSteal,pet)
	end
	local relocatedCharacter=LP.Character
	local goAfter=os.clock()+0
	repeat
		local h=relocatedCharacter and relocatedCharacter:FindFirstChildOfClass("Humanoid")
		if
			LP.Character~=relocatedCharacter
			or not h
			or h.Health<=0
			or _G.ElysiumTPStop
			or _G.Elysium_IsResetting
			or _G.ElysiumAutoBuyTPBlocked
			or LP:GetAttribute("Stealing")==true
		then
			isTeleporting=false
			restoreAnimations()
			return
		end
		if os.clock()>=goAfter then
			break
		end
		RunService.Heartbeat:Wait()
	until false
	local targetPlot=pet and pet.plot and workspace:FindFirstChild("Plots")
	targetPlot=targetPlot and targetPlot:FindFirstChild(tostring(pet.plot))
	if targetPlot and pet and pet.slot then
		local ok,livePosition=pcall(getPetPosition,targetPlot,pet.slot,false)
		if ok and typeof(livePosition)=="Vector3"then
			petPos=livePosition
		end
	end
	_G.ElysiumGoInvokedAt=os.clock()
	_G.ElysiumCloneToGoFrameGap=_G.ElysiumCloneRelocationDetectedAt and(_G.ElysiumGoInvokedAt-_G.ElysiumCloneRelocationDetectedAt)or nil
	local goOK=goToBrainrot(petPos,{slot=pet and pet.slot,plot=pet and pet.plot,noJump=true,cloneRelocated=not useFlash})
	isTeleporting=false
	if goOK and not _G.ElysiumTPStop and _G.ElysiumArmSteal then
		pcall(_G.ElysiumArmSteal,pet)
	end
	restoreAnimations()
end
do
	local original=doVelocityTP
	doVelocityTP=function(...)
		if isTeleporting or _G.ElysiumFlashTeleportRun or _G.ElysiumFlashTeleportActive then return false end
		local args=table.pack(...)
		local release
		_G.ElysiumTPMovementError=nil
		ElysiumTPStartTrace("requested")
		local ok,result=xpcall(function()
			local acquire=_G.ElysiumExtrasAcquireMovement or _G.ElysiumExtrasAcquireFlash
			if type(acquire)=="function"then release=acquire()end
			return original(table.unpack(args,1,args.n))
		end,function(err)return debug.traceback(tostring(err),2)end)
		if release then pcall(release)end
		if ok then
			ElysiumTPStartTrace("returned","lastStage="..tostring(_G.ElysiumTPStartStage).."; result="..tostring(result))
		else
			_G.ElysiumTPMovementError=tostring(result)
			ElysiumTPStartTrace("error",result)
		end
		if not ok then
			_G.ElysiumTPMovementError=tostring(result)
			if _G.ElysiumFlashTP then _G.ElysiumFlashError=tostring(result)end
			if _G.ElysiumActiveMoveCancel then _G.ElysiumActiveMoveCancel()end
			isTeleporting=false
			restoreAnimations()
			return false
		end
		return result
	end
end
_manualTPBusy=false
function manualFullTP()
	if _G.ElysiumAutoBuyTPBlocked then
		return false
	end
	if _G.ElysiumSourceStealActive and _G.ElysiumSourceStealMode~="priority"then
		return false
	end
	if _manualTPBusy or isTeleporting then
		return
	end
	if LP:GetAttribute("Stealing")==true then
		return
	end
	_manualTPBusy=true
	local selectedUid=_G.ElysiumStealTargetUID
	if type(selectedUid)~="string"or selectedUid==""then
		selectedUid=nil
	end
	if _G.ElysiumScanProfile and _G.ElysiumScanMode=="fast"then
		_G.ElysiumScanProfile("normal")
	end
	local okAll,result=pcall(function()
		local _t0=os.clock()
		local _lastN,_lastTop=-1,nil
		local selectedPet
		repeat
			local ok,pets=pcall(scanForTP)
			if ok and pets and#pets>0 then
				if selectedUid then
					for _,candidate in ipairs(pets)do
						if not candidate.conveyor and candidate.position and _petUid(candidate)==selectedUid then
							selectedPet=candidate
							break
						end
					end
					if selectedPet then
						break
					end
				else
					break
				end
				task.wait(tonumber(_G.ElysiumScanSettle)or .06)
			else
				task.wait(.05)
			end
		until os.clock()-_t0>(tonumber(_G.ElysiumTPMaxWait)or 4)
		if selectedUid and not selectedPet then
			warn("[Elysium] Manual TP: selected brainrot is no longer available")
			return false
		end
		doVelocityTP(true,selectedPet)
		return true
	end)
	_manualTPBusy=false
	if not okAll then
		warn("[Elysium] Manual TP: "..tostring(result))
	end
	return okAll and result==true
end
_G.ElysiumStartSideTP=manualFullTP
if _G.ElysiumCamp and type(_G.ElysiumCamp.stop)=="function"then
	pcall(_G.ElysiumCamp.stop)
end
_G.ElysiumCamp=nil
if false then
	do
		if _G.ElysiumCamp and type(_G.ElysiumCamp.stop)=="function"then
			pcall(_G.ElysiumCamp.stop)
		end
		local TC={active=false,target=nil,plotName=nil,status="idle",arrived=false}
		_G.ElysiumCamp=TC
		local function notify(text)
			pcall(function()
				ElysiumService("StarterGui"):SetCore("SendNotification",{
					Title="Base CAMP",
					Text=tostring(text),
					Duration=4,
				})
			end)
		end
		local function plotOwnerName(plot)
			local sign=plot and plot:FindFirstChild("PlotSign")
			local gui=sign and sign:FindFirstChildWhichIsA("SurfaceGui",true)
			local label=gui and gui:FindFirstChildWhichIsA("TextLabel",true)
			local text=label and label.Text
			if type(text)~="string"then
				return nil
			end
			local owner=text:match("^(.-)'")or text
			owner=owner:gsub("%s+$","")
			return owner~=""and owner or nil
		end
		local function resolvePlayer(query)
			query=tostring(query or""):lower():gsub("%s+","")
			if query==""then
				return nil
			end
			local partial
			for _,plr in ipairs(Players:GetPlayers())do
				if plr~=LP then
					local name=plr.Name:lower()
					local display=(plr.DisplayName or""):lower()
					if name==query or display==query then
						return plr
					end
					if not partial and(name:find(query,1,true)or display:find(query,1,true))then
						partial=plr
					end
				end
			end
			return partial
		end
		local function findPlotFor(plr)
			local plots=workspace:FindFirstChild("Plots")
			if not plots then
				return nil
			end
			local name=plr.Name:lower()
			local display=(plr.DisplayName or""):lower()
			for _,plot in ipairs(plots:GetChildren())do
				local owner=plotOwnerName(plot)
				owner=owner and owner:lower()
				if owner==name or owner==display then
					return plot
				end
			end
			return nil
		end
		local function slotOccupied(slot)
			for _,obj in ipairs(slot:GetDescendants())do
				if obj:IsA("ProximityPrompt")and obj.Enabled and obj.ActionText=="Steal"then
					return true
				end
			end
			return false
		end
		local function campSlot(plot)
			local podiums=plot:FindFirstChild("AnimalPodiums")
			if not podiums then
				return nil,nil,false
			end
			local slots={}
			for _,slot in ipairs(podiums:GetChildren())do
				local base=slot:FindFirstChild("Base")
				local spawn=base and base:FindFirstChild("Spawn")
				if spawn and spawn:IsA("BasePart")then
					slots[#slots+1]=slot
				end
			end
			table.sort(slots,function(a,b)
				local an=tonumber(tostring(a.Name):match("%d+"))
				local bn=tonumber(tostring(b.Name):match("%d+"))
				if an and bn then
					return an<bn
				end
				return tostring(a.Name)<tostring(b.Name)
			end)
			local firstName,firstPos
			for _,slot in ipairs(slots)do
				local spawn=slot.Base.Spawn
				firstName=firstName or slot.Name
				firstPos=firstPos or spawn.Position
				if not slotOccupied(slot)then
					return slot.Name,spawn.Position,false
				end
			end
			return firstName,firstPos,#slots>0
		end
		local function campTarget()
			local ok,pets=pcall(scanAllPetsCached,.05)
			if not ok or type(pets)~="table"then
				ok,pets=pcall(scanAllPets)
			end
			if not ok or type(pets)~="table"then
				return nil
			end
			local char=LP.Character
			local hrp=char and char:FindFirstChild("HumanoidRootPart")
			local best,bestDist
			for _,pet in ipairs(pets)do
				if pet and pet.plot==TC.plotName and pet.position then
					local dist=hrp and(pet.position-hrp.Position).Magnitude or 0
					if not best or dist<bestDist then
						best,bestDist=pet,dist
					end
				end
			end
			return best
		end
		local function steer()
			if not(TC.active and TC.arrived)then
				return
			end
			local pet=campTarget()
			if pet then
				local uid=tostring(pet.plot).."_"..tostring(pet.slot)
				if TC._armedUid~=uid then
					TC._armedUid=uid
					TC._armedPet=pet
					if _G.ElysiumArmSteal then
						pcall(_G.ElysiumArmSteal,pet)
					end
				end
			elseif TC._armedUid then
				TC._armedUid,TC._armedPet=nil,nil
				if _G.ElysiumDisarmSteal then
					pcall(_G.ElysiumDisarmSteal)
				end
			end
		end
		TC.stop=function()
			TC.active=false
			TC.target=nil
			TC.plotName=nil
			TC.status="stopped"
			TC.arrived=false
			TC.entry=nil
			TC._armedUid,TC._armedPet=nil,nil
			if _G.ElysiumDisarmSteal then
				pcall(_G.ElysiumDisarmSteal)
			end
		end
		TC.start=function(query)
			local plr=resolvePlayer(query)
			if not plr then
				TC.status="player not found"
				return false,TC.status
			end
			local plot=findPlotFor(plr)
			if not plot then
				TC.status="base not found"
				return false,TC.status
			end
			if TC.active then
				TC.stop()
			end
			local slotName,pos,full=campSlot(plot)
			if not(slotName and pos)then
				TC.status="podium not found"
				return false,TC.status
			end
			TC.active=true
			TC.target=plr.Name
			TC.plotName=plot.Name
			TC.arrived=false
			TC.status=full and(plr.Name.."'s base is FULL")or("camping "..plr.Name)
			local entry={
				plot=plot.Name,
				slot=tostring(slotName),
				position=pos,
				uid=plot.Name.."_"..tostring(slotName),
				name="Camp",
				index="Camp",
				mps=0,
			}
			TC.entry=entry
			if full then
				notify(plr.Name.."'s base is full; using the first podium")
			end
			task.spawn(function()
				pcall(doVelocityTP,true,entry)
				if not TC.active or TC.entry~=entry then
					return
				end
				TC.entry=nil
				TC.arrived=true
				TC._armedUid,TC._armedPet=nil,nil
				if _G.ElysiumDisarmSteal then
					pcall(_G.ElysiumDisarmSteal)
				end
				pcall(steer)
			end)
			return true,TC.status
		end
		Players.PlayerRemoving:Connect(function(plr)
			if TC.active and TC.target==plr.Name then
				notify(plr.Name.." left; CAMP disabled")
				TC.stop()
			end
		end)
		task.spawn(function()
			while _G.ElysiumCamp==TC do
				task.wait(.1)
				if TC.active then
					if TC.target and not Players:FindFirstChild(TC.target)then
						TC.stop()
					else
						pcall(steer)
					end
				end
			end
		end)
	end
end
if type(_G.SHARED_PRIORITY_ITEMS)~="table"or#_G.SHARED_PRIORITY_ITEMS==0 then
	_G.SHARED_PRIORITY_ITEMS={"Headless Horseman","Strawberry Elephant","Signore Carapace","John Pork","Meowl","Elefanto Frigo","Arcadragon","Skibidi Toilet","Griffin","Antonio","Dragon Aquanini","Dragon Gingerini","Love Love Bear","Kalika Bros","Moby Bros","Grabatron","Jelly Moby","La Supreme Combinasion","Ginger Gerat","Digi Narwhal","Hydra Dragon Cannelloni","Hydra Bunny","Bunny and Eggy","Kraken","Fishino Clownino","Tirilikalika Tirilikalako","Pancake and Syrup","Dragon Cannelloni","Sammyni Cakini","Ketupat Bros","Bumbatron","Venuspino","Dug dug dug","La Casa Boo","Rico Dinero","Foxini Lanternini","Duggy Bros","Rosey and Teddy","Globa Steppa","Los Hackers","Cerberus","Fragrama and Chocrama","Cooki and Milki","La Secret Combinasion","Burguro and Fryuro","Capitano Moby","Spooky and Pumpky","Garama and Madundung","Popcuru and Fizzuru","Pizza and Ranch","Reinito Sleighito","Tenini Ballini","Fragola La La La","Ketchuru and Musturu","Tralaledon","Tictac Sahur","Ketupat Kepat","Tang Tang Keletang","Orcaledon","La Ginger Sekolah","Los Spaghettis","Lavadorito Spinito","Swaggy Bros","La Taco Combinasion","Los Primos","Los Chillis","Chillin Chili","Tuff Toucan","W or L","Chipso and Queso","Guest 666","Money Money Reindeer","Quackini Snackini","Los Sekolahs","Los Tacoritas","Los Amigos","Fortunu and Cashuru","Jolly Jolly Sahur","Boppin Bunny","Gym Bros","Los Cupids","Festive 67","Celularcini Viciosini","Cloverat Clapat","La Food Combinasion","Hopilikalika Hopilikalako","Celestial Pegasus","Sammyni Fattini","Money Money Bros","La Spooky Grande","Cash or Card","Swag Soda","Los Planitos","Lovin Rose","Tacorita Bicicleta","Los Jolly Combinasionas","La Romantic Grande","La Easter Grande","Los Hotspotsitos","Rosetti Tualetti","Los Bros","Gobblino Uniciclino","Chicleteira Cupideira","La Extinct Grande","Las Sis","Nacho Spyder","Gold Gold Gold","Los Mariachis","Snailo Clovero","La Jolly Grande","Los Candies","Churrito Bunnito","Bananito","Eviledon","Los 67","Los Sweethearts","Noo my Heart","La Lucky Grande","Ventoliero Pavonero","Baskito","Chimnino","Los Puggies","Camera Ramena","Los 25","Spinny Hammy","Money Money Puggy","Cigno Fulgoro","Los Spooky Combinasionas","Chicleteira Noelteira","Mariachi Corazoni","Tacorillo Crocodillo","Noo my Gold","Los Mobilis","Mieteteira Bicicleteira","DJ Panda","Los Combinasionas","Nuclearo Dinossauro","Bacuru and Egguru","Spaghetti Tualetti","La Grande Combinasion","Esok Sekolah",}
end
UIS.InputBegan:Connect(function(input,gameProcessed)
	if input.UserInputType~=Enum.UserInputType.Keyboard then
		return
	end
	if gameProcessed then
		return
	end
	local keyName=input.KeyCode.Name
	local resetKey=type(_G.ElysiumResetKeyName)=="string"and _G.ElysiumResetKeyName or"X"
	if keyName==resetKey and not _G.ElysiumManualTPBridgeActive then
		task.spawn(function()
			pcall(_G.ElysiumInstantReset)
		end)
		return
	end
	local cloneKey=type(_G.ElysiumCloneKeyName)=="string"and _G.ElysiumCloneKeyName or"V"
	if keyName==cloneKey and not _G.ElysiumManualTPBridgeActive then
		task.spawn(function()
			pcall(doClone)
		end)
	end
	local want=_G._stp_tpKeyName
	if type(want)~="string"or want==""then
		want="T"
	end
	if _G.ElysiumBindListening then
		return
	end
	local extrasKeys=_G.ElysiumTPControl and _G.ElysiumTPControl.extrasOwnsKeys
	if
		extrasKeys
		and(input.KeyCode.Name==_G.ElysiumAutoTPKeyName or input.KeyCode.Name==_G.ElysiumStopTPKeyName)
	then
		return
	end
	if not _G.ElysiumManualTPBridgeActive and input.KeyCode.Name==want then
		task.spawn(function()
			pcall(manualFullTP)
		end)
	end
end)
task.spawn(function()
	pcall(loadModules)
	pcall(loadNet)
end)
task.spawn(function()
	pcall(function()
		local R=ElysiumService("ReplicatedStorage")
		local d=R:FindFirstChild("Datas")or R:WaitForChild("Datas",3)
		if d then
			local a=d:FindFirstChild("Animals")or d:WaitForChild("Animals",3)
			if a then
				_AD=require(a)
			end
			local m=d:FindFirstChild("Mutations")or d:WaitForChild("Mutations",3)
			if m then
				_MD=require(m)
			end
			local t=d:FindFirstChild("Traits")or d:WaitForChild("Traits",3)
			if t then
				_TD=require(t)
			end
		end
	end)
end)
task.spawn(function()
	if not game:IsLoaded()then
		game.Loaded:Wait()
	end
	task.wait(.2)
	for _=1,8 do
		pcall(scanAllPetsCached,0)
		task.wait(.08)
	end
	while true do
		pcall(scanAllPetsCached,.3)
		task.wait(.2)
	end
end)
_G.ElysiumChannelsReady=false
local autoTPGeneration=0
local autoTPEnabled=_G.ElysiumAutoTP~=false
local function runAutoTP(generation)
	local function cancelled()
		return _G.ElysiumAutoTP==false or generation~=autoTPGeneration
	end
	local char=LP.Character or LP.CharacterAdded:Wait()
	char:WaitForChild("HumanoidRootPart",10)
	char:WaitForChild("Humanoid",10)
	pcall(loadModules)
	if cancelled()then
		return
	end
	local _carpetDone=false
	task.spawn(function()
		local _tw=os.clock()
		while os.clock()-_tw<12 do
			if cancelled()then
				return
			end
			for _,n in ipairs(CARPET_NAMES)do
				if findTool(n)then
					pcall(carpetEngage,_G.ElysiumJoinGrapple~=false)
					_carpetDone=true
					return
				end
			end
			task.wait(.05)
		end
		_carpetDone=true
	end)
	local _toolsReady=false
	task.spawn(function()
		if _G.ElysiumWaitForTools~=false and type(_G.ElysiumToolsReady)=="function"then
			local _tt0=os.clock()
			local _tcap=tonumber(_G.ElysiumToolWait)or 6
			while os.clock()-_tt0<_tcap do
				local ok,ready=pcall(_G.ElysiumToolsReady)
				if ok and ready then
					break
				end
				if cancelled()then
					return
				end
				task.wait(tonumber(_G.ElysiumToolPoll)or .02)
			end
		end
		_toolsReady=true
	end)
	local function _channelsProgress()
		local Plots=workspace:FindFirstChild("Plots")
		if not Plots then
			return 0,0
		end
		local kids=Plots:GetChildren()
		if#kids==0 then
			return 0,0
		end
		local ready=0
		for _,plot in ipairs(kids)do
			if getPlotChannel(plot.Name)then
				ready=ready+1
			end
		end
		return ready,#kids
	end
	local _bootT0=os.clock()
	local _wMax=tonumber(_G.ElysiumAutoTPWait)or 15
	local _chanGrace=tonumber(_G.ElysiumChanGrace)or 2
	local _petsFound=nil
	local _lastTop=nil
	while os.clock()-_bootT0<_wMax do
		if cancelled()then
			return
		end
		if LP:GetAttribute("Stealing")==true then
			return
		end
		local ready,total=_channelsProgress()
		local chanOk=(total>0 and ready>=total)
			or(total>0 and ready>=(total-_chanGrace)and(os.clock()-_bootT0)>_chanGrace)
		local ok,pets=pcall(scanForTP)
		if ok and pets and#pets>0 then
			_petsFound=pets
			local top=tostring(pets[1].plot).."_"..tostring(pets[1].slot)
			if chanOk and top==_lastTop then
				break
			end
			_lastTop=top
		end
		RunService.Heartbeat:Wait()
	end
	do
		local _d=tonumber(_G._stp_tpDelay)or tonumber(_G.TPDelay)or 0
		if _d>0 then
			task.wait(_d)
		end
	end
	if cancelled()then
		return
	end
	local _wt0=os.clock()
	while(not _carpetDone or not _toolsReady)and os.clock()-_wt0<3 do
		if cancelled()then
			return
		end
		task.wait(.03)
	end
	while isTeleporting do
		if cancelled()then
			return
		end
		task.wait(.05)
	end
	if cancelled()then
		return
	end
	local tpOk,tpError=pcall(doVelocityTP,true)
	if not tpOk then
		isTeleporting=false
		_manualTPBusy=false
		_G.ElysiumStealHold=false
		_G.ElysiumLastTPError=tostring(tpError)
		pcall(function()
			ElysiumService("StarterGui"):SetCore("SendNotification",{
				Title="Elysium TP",
				Text="TP error: "..tostring(tpError),
				Duration=8,
			})
		end)
	end
	if _G.ElysiumScanProfile then
		_G.ElysiumScanProfile("normal")
	end
end
task.spawn(function()
	while _G.ElysiumMainLoadedGame==game do
		task.wait(.4)
		if
			roadAllowed()
			and not isTeleporting
			and not _manualTPBusy
			and not LP:GetAttribute("Stealing")
			and not _G.ElysiumClickTPBusy
			and os.clock()>=(tonumber(_G.ElysiumTPRetryAfter)or 0)
		then
			local ok,road=pcall(function()
				return roadWinner(scanForTP())
			end)
			if ok and road then
				local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
				local pos=road.getPosition()
				if root and pos and(root.Position-(pos+Vector3.new(0,5,0))).Magnitude>8 then
					local moved,err=pcall(doVelocityTP,true)
					if not moved then
						isTeleporting=false
						_G.ElysiumRoadTPActive=false
						_G.ElysiumRoadTPLastError=tostring(err)
					end
				end
			elseif ok and not road and _G.ElysiumRoadResumeBase then
				_G.ElysiumRoadResumeBase=false
				local moved,err=pcall(doVelocityTP,true)
				if not moved then
					isTeleporting=false
					_G.ElysiumRoadTPActive=false
					_G.ElysiumRoadTPLastError=tostring(err)
				end
			end
		end
	end
end)
_G.ElysiumSetAutoTP=function(enabled)
	enabled=enabled==true
	if _G.ElysiumAutoBuyTPBlocked then
		enabled=false
	end
	local changed=autoTPEnabled~=enabled
	autoTPEnabled=enabled
	_G.ElysiumAutoTP,_G.ElysiumAutoTP=enabled,enabled
	if _G.ElysiumTPControl then
		_G.ElysiumTPControl.autoEnabled=enabled
	end
	if not enabled then
		autoTPGeneration=autoTPGeneration+1
	elseif changed then
		autoTPGeneration=autoTPGeneration+1
		task.spawn(runAutoTP,autoTPGeneration)
	end
	if _G.ElysiumRepaintAutoTP then
		pcall(_G.ElysiumRepaintAutoTP)
	end
	if _G.ElysiumSaveSettings then
		pcall(_G.ElysiumSaveSettings)
	end
end
_G.ElysiumStopTeleport=function()
	_G.ElysiumTPStop,_G.ElysiumTPStop=true,true
	_G.ElysiumClickTPPending=nil
	_G.ElysiumStealHold=false
	_G.ElysiumSetAutoTP(false)
end
if _G.ElysiumTPControl and type(_G.ElysiumTPControl.autoEnabled)=="boolean"then
	_G.ElysiumAutoTP=_G.ElysiumTPControl.autoEnabled
end
autoTPEnabled=_G.ElysiumAutoTP~=false
task.spawn(runAutoTP,autoTPGeneration)
do
	local Players=ElysiumService("Players")
	local RunService=ElysiumService("RunService")
	local LP=Players.LocalPlayer
	local PG=LP:FindFirstChild("PlayerGui")or LP:WaitForChild("PlayerGui",20)
	local GUIHOST=(gethui and gethui())or ElysiumService("CoreGui")
	local function diag()
		pcall(loadModules)
		local Plots=workspace:FindFirstChild("Plots")
		local nPlots=Plots and#Plots:GetChildren()or 0
		local nCh,nOwn,nAl=0,0,0
		if Plots then
			for _,plot in ipairs(Plots:GetChildren())do
				local ch=getPlotChannel(plot.Name)
				if ch then
					nCh=nCh+1
					if ownerInGame(ch)then
						nOwn=nOwn+1
					end
					if channelGet(ch,"AnimalList")then
						nAl=nAl+1
					end
				end
			end
		end
		local pets=scanAllPetsCached(.12)
		local ok=pets~=nil
		local nPets=(ok and pets and#pets)or 0
		local msg=string.format("plots=%d ch=%d owner=%d animals=%d PETS=%d",nPlots,nCh,nOwn,nAl,nPets)
		if nPets>0 and pets[1]then
		end
		return nPets
	end
	local _fspOverlap=OverlapParams.new()
	_fspOverlap.FilterType=Enum.RaycastFilterType.Exclude
	local function _promptWorldPos(p)
		local pp=p and p.Parent
		if not pp then
			return nil
		end
		if pp:IsA("Attachment")then
			return pp.WorldPosition
		end
		if pp:IsA("BasePart")then
			return pp.Position
		end
		return nil
	end
	local function findStealPrompt(pet,includeDisabled)
		if not pet then
			return nil
		end
		local podPrompt
		if pet.plot and pet.slot then
			local plots=workspace:FindFirstChild("Plots")
			local plot=plots and plots:FindFirstChild(pet.plot)
			local podiums=plot and plot:FindFirstChild("AnimalPodiums")
			local podium=podiums and podiums:FindFirstChild(tostring(pet.slot))
			if podium then
				local base=podium:FindFirstChild("Base")
				local spawn=base and base:FindFirstChild("Spawn")
				local attach=spawn and spawn:FindFirstChild("PromptAttachment")
				if attach then
					for _,p in ipairs(attach:GetChildren())do
						if
							p:IsA("ProximityPrompt")
							and(p.Enabled or includeDisabled)
							and tostring(p.ActionText or""):find("Steal")
						then
							podPrompt=p
							break
						end
					end
				end
				if not podPrompt then
					for _,candidate in ipairs(podium:GetDescendants())do
						if
							candidate:IsA("ProximityPrompt")
							and(candidate.Enabled or includeDisabled)
							and tostring(candidate.ActionText or""):find("Steal")
						then
							podPrompt=candidate
							break
						end
					end
				end
			end
		end
		if pet.plot and pet.slot then
			return podPrompt
		end
		if pet.position then
			local pp=podPrompt and _promptWorldPos(podPrompt)
			if(not podPrompt)or(pp and(pp-pet.position).Magnitude>15)then
				_fspOverlap.FilterDescendantsInstances=LP.Character and{LP.Character}or{}
				local okB,parts=pcall(workspace.GetPartBoundsInRadius,workspace,pet.position,14,_fspOverlap)
				if okB and parts then
					local best,bestD
					for _,part in ipairs(parts)do
						local pr=part:FindFirstChildOfClass("ProximityPrompt")
						if not pr then
							for _,ch in ipairs(part:GetChildren())do
								if ch:IsA("Attachment")then
									pr=ch:FindFirstChildOfClass("ProximityPrompt")
									if pr then
										break
									end
								end
							end
						end
						if pr and pr.Enabled and tostring(pr.ActionText or""):find("Steal")then
							local pos=_promptWorldPos(pr)
							local d=pos and(pos-pet.position).Magnitude or math.huge
							if not best or d<bestD then
								best,bestD=pr,d
							end
						end
					end
					if best then
						return best
					end
				end
			end
		end
		return podPrompt
	end
	local InternalStealCache={}
	local STEAL_HOLD_DURATION=1.3
	local STEAL_PROXIMITY=tonumber(_G.ElysiumStealProximity)or 31
	local _stealHoldStart,_stealHoldActive=0,false
	local _stealHoldGeneration,_stealHoldPetUid=0,nil
	local _stealHoldCarry,_stealHoldCarryUid=0,nil
	local _stealHoldCarryInherited=false
	local _stealHoldCarryPrecharged=false
	local _prechargeUid,_prechargeAt,_prechargeTouchedAt,_prechargeHeldSeenAt=nil,0,0,0
	local _prechargePulseAt=0
	local _clearPrecharge
	local showStealBar
	local _stealTarget,_stealArmedAt=nil,0
	local _lastTargetPick,_lastPickUid,_currentTargetName=0,nil,nil
	local _stealLastScan,_autoLastScan=0,0
	local _inRangeLast=0
	local _armCheckAt=0
	local _petsCache,_petsCacheAt=nil,0
	local function _scanCached(now,maxAge)
		if _petsCache and(now-_petsCacheAt)<=(maxAge or .1)then
			return _petsCache
		end
		local pets=scanAllPetsCached(.08)
		local ok=pets~=nil
		if ok and type(pets)=="table"then
			_petsCache,_petsCacheAt=pets,now
			return pets
		end
		return nil
	end
	local function _petListed(plot,slot)
		local ch=getPlotChannel(plot)
		local al=ch and channelGet(ch,"AnimalList")
		if type(al)~="table"then
			return true,false
		end
		local e=al[slot]
		if e==nil then
			e=al[tonumber(slot)or-1]
		end
		if e==nil then
			e=al[tostring(slot)]
		end
		return e~=nil,true
	end
	local function _prox()
		return tonumber(_G.ElysiumAutoGrabRadius)or tonumber(_G.ElysiumStealProximity)or 95
	end
	local STEAL_HOLD_MAX=2.6
	local function _holdDur()
		if _G.ElysiumStealHoldFull==true then
			return STEAL_HOLD_MAX
		end
		local h=tonumber(_G.ElysiumStealHoldDuration)or STEAL_HOLD_DURATION
		if h<STEAL_HOLD_DURATION then
			h=STEAL_HOLD_DURATION
		elseif h>STEAL_HOLD_MAX then
			h=STEAL_HOLD_MAX
		end
		return h
	end
	local _cooldownUntil=0
	local function _verifyFire(pet,path,judge)
		task.delay(tonumber(_G.ElysiumVerifyDelay)or .35,function()
			if not(pet and pet.plot and pet.slot~=nil)then
				return
			end
			local listed,known=true,false
			pcall(function()
				listed,known=_petListed(pet.plot,pet.slot)
			end)
			if not known then
				return
			end
			if not listed then
				_G.ElysiumStealFails=0
				_cooldownUntil=0
				return
			end
			if not judge then
				_cooldownUntil=0
				return
			end
		end)
	end
	_G.ElysiumNativeStealBusy=function()
		return _stealHoldActive==true
	end
	local function _holdBusy()
		return _stealHoldActive
	end
	local _armedPet,_armLostSince=nil,0
	local function _armLivePos(p)
		if not(p and p.plot and p.slot~=nil)then
			return nil
		end
		local plots=workspace:FindFirstChild("Plots")
		local plot=plots and plots:FindFirstChild(p.plot)
		if not plot then
			return nil
		end
		local ok,pos=pcall(getPetPosition,plot,p.slot)
		if ok then
			return pos
		end
		return nil
	end
	_G.ElysiumArmSteal=function(pet)
		if _G.ElysiumSourceStealActive then
			return
		end
		if type(pet)~="table"or type(pet.plot)~="string"or pet.slot==nil then
			return
		end
		local newUid=_petUid(pet)
		local previousUid=_armedPet and _petUid(_armedPet)or _stealHoldPetUid
		if _stealHoldActive and _stealHoldPetUid and newUid~=_stealHoldPetUid then
			local elapsed=math.max(0,tick()-_stealHoldStart)
			_stealHoldCarry=math.max(_stealHoldCarry,math.min(elapsed,STEAL_HOLD_MAX))
			_stealHoldCarryUid=newUid
			_stealHoldCarryInherited=true
			_stealHoldGeneration+=1
		elseif LP:GetAttribute("Stealing")==true and(not previousUid or newUid~=previousUid)then
			_stealHoldCarry=STEAL_HOLD_MAX
			_stealHoldCarryUid=newUid
			_stealHoldCarryInherited=false
		elseif _stealHoldCarry>0 and _stealHoldCarryUid~=newUid then
			_stealHoldCarryUid=newUid
		end
		_armedPet={
			name=pet.name,
			index=pet.index,
			mps=pet.mps,
			mutation=pet.mutation,
			_pri=pet._pri,
			plot=pet.plot,
			slot=tostring(pet.slot),
			position=pet.position,
		}
		_armLostSince=0
		_stealTarget=_armedPet
		_stealArmedAt=os.clock()
		if type(pet.name)=="string"and pet.name~=""then
			_currentTargetName=pet.name
		end
		if _stealHoldCarryUid==newUid and _stealHoldCarry>0 and showStealBar then
			showStealBar(pet.name,math.min(_stealHoldCarry/STEAL_HOLD_DURATION,1))
		end
	end
	_G.ElysiumDisarmSteal=function()
		if _stealHoldActive then
			_stealHoldGeneration+=1
		end
		_armedPet,_armLostSince=nil,0
		_stealTarget=nil
		_lastPickUid=nil
		_stealHoldCarry,_stealHoldCarryUid=0,nil
		_stealHoldCarryInherited=false
		_stealHoldCarryPrecharged=false
		if _clearPrecharge then
			_clearPrecharge(false)
		end
	end
	_G.ElysiumArmedName=function()
		return _armedPet and _armedPet.name or nil
	end
	local UIC={
		bg=Color3.fromRGB(18,18,18),
		bg2=Color3.fromRGB(28,28,28),
		card=Color3.fromRGB(35,35,35),
		track=Color3.fromRGB(45,45,45),
		line=Color3.fromRGB(60,60,60),
		acc=Color3.fromRGB(255,255,255),
		acc2=Color3.fromRGB(220,220,220),
		txt=Color3.fromRGB(240,240,240),
		dim=Color3.fromRGB(140,140,140),
	}
	local UIF,UIFB=Enum.Font.SourceSans,Enum.Font.SourceSansBold
	local function mk(class,parent,props)
		local o=Instance.new(class)
		for k,v in pairs(props or{})do
			o[k]=v
		end
		o.Parent=parent
		return o
	end
	local function corner(o,r)
		r=r or 8
		if r>=8 then
			r=4
		elseif r>=6 then
			r=6
		end
		mk("UICorner",o,{CornerRadius=UDim.new(0,r)})
		return o
	end
	local function stroke(o,col)
		mk("UIStroke",o,{Color=col or UIC.line,Thickness=1})
		return o
	end
	pcall(function()
		local _oldDbg=LP:FindFirstChild("PlayerGui")
		_oldDbg=_oldDbg and _oldDbg:FindFirstChild("ElysiumStealDbg")
		if _oldDbg then
			_oldDbg:Destroy()
		end
	end)
	local stealBarSg,stealBarWrap,stealBarFill,stealBarTitle,stealBarGen,stealBarStatus,stealBarSeconds
	local _lastFillX=-1
	local _ragdollShown=false
	local _ragdollStartedAt=0
	local _ragdollInitialRemaining=0
	local _ragdollEndSeen=0
	local STEAL_ACCENT=Color3.fromRGB(245,245,245)
	local STEAL_DONE=Color3.fromRGB(30,185,100)
	local STEAL_HOLD=Color3.fromRGB(255,190,60)
	local STEAL_RAG=Color3.fromRGB(235,110,60)
	local function shortMoney(value)
		value=tonumber(value)or 0
		local abs=math.abs(value)
		local suffix,div="",1
		if abs>=1e12 then
			suffix,div="T",1e12
		elseif abs>=1e9 then
			suffix,div="B",1e9
		elseif abs>=1e6 then
			suffix,div="M",1e6
		elseif abs>=1e3 then
			suffix,div="K",1e3
		end
		local scaled=value/div
		local text=(math.abs(scaled)>=100 or div==1)and string.format("%.0f",scaled)
			or string.format("%.1f",scaled)
		return text:gsub("%.0$","")..suffix
	end
	local function refreshStealTargetLabels(fallbackName)
		local pet=(_G.ElysiumSourceStealActive and _G.ElysiumExternalStealPet)or _armedPet or _stealTarget
		local name=fallbackName or(pet and pet.name)or _currentTargetName or"No Target"
		stealBarTitle.Text=tostring(name)
		local mps=pet and tonumber(pet.mps)
		stealBarGen.Text=mps and mps>0 and("$"..shortMoney(mps).."/s")or""
	end
	local function ensureStealBar()
		if stealBarSg and stealBarSg.Parent then
			return
		end
		for _,par in ipairs({GUIHOST,PG})do
			pcall(function()
				local old=par and par:FindFirstChild("ElysiumStealBar")
				if old then
					old:Destroy()
				end
				local legacyBar=par and par:FindFirstChild("MeerkoStealBar")
				if legacyBar then
					legacyBar:Destroy()
				end
			end)
		end
		stealBarSg=mk("ScreenGui",GUIHOST,{
			Name="ElysiumStealBar",
			ResetOnSpawn=false,
			IgnoreGuiInset=true,
			DisplayOrder=1000000,
		})
		local wrap=mk("Frame",stealBarSg,{
			Name="Wrap",
			AnchorPoint=Vector2.new(.5,1),
			Position=UDim2.new(.5,0,1,tonumber(_G._elysium_stealBarBottom)or-100),
			Size=UDim2.fromOffset(tonumber(_G._elysium_stealBarW)or 310,tonumber(_G._elysium_stealBarH)or 82),
			BackgroundColor3=Color3.fromRGB(16,16,18),
			BackgroundTransparency=.08,
			BorderSizePixel=0,
			ClipsDescendants=true,
		})
		stealBarWrap=wrap
		wrap.Visible=true
		mk("UICorner",wrap,{CornerRadius=UDim.new(0,10)})
		mk("UIGradient",wrap,{
			Rotation=135,
			Color=ColorSequence.new({
				ColorSequenceKeypoint.new(0,Color3.fromRGB(34,34,37)),
				ColorSequenceKeypoint.new(1,Color3.fromRGB(16,16,18)),
			}),
		})
		mk("UIStroke",wrap,{Color=Color3.fromRGB(65,65,70),Thickness=1,Transparency=.25})
		_G.ElysiumRepaintStealMode=function()end
		stealBarTitle=mk("TextLabel",wrap,{
			Size=UDim2.new(1,-96,0,18),
			Position=UDim2.fromOffset(12,9),
			BackgroundTransparency=1,
			Font=Enum.Font.GothamBold,
			TextSize=12,
			TextColor3=Color3.fromRGB(255,255,255),
			TextXAlignment=Enum.TextXAlignment.Left,
			TextTruncate=Enum.TextTruncate.AtEnd,
			Text="No Target",
		})
		stealBarGen=mk("TextLabel",wrap,{
			Size=UDim2.fromOffset(78,18),
			Position=UDim2.new(1,-90,0,9),
			BackgroundTransparency=1,
			Font=Enum.Font.GothamBold,
			TextSize=11,
			TextColor3=Color3.fromRGB(245,245,245),
			TextXAlignment=Enum.TextXAlignment.Right,
			Text="",
		})
		stealBarStatus=mk("TextLabel",wrap,{
			Size=UDim2.new(1,-112,0,15),
			Position=UDim2.fromOffset(12,31),
			BackgroundTransparency=1,
			Font=Enum.Font.GothamBold,
			TextSize=10,
			TextColor3=Color3.fromRGB(225,225,228),
			TextXAlignment=Enum.TextXAlignment.Left,
			Text="",
		})
		stealBarSeconds=mk("TextLabel",wrap,{
			Size=UDim2.fromOffset(92,15),
			Position=UDim2.new(1,-104,0,31),
			BackgroundTransparency=1,
			Font=Enum.Font.GothamMedium,
			TextSize=10,
			TextColor3=Color3.fromRGB(155,155,160),
			TextXAlignment=Enum.TextXAlignment.Right,
			Text="",
		})
		local track=mk("Frame",wrap,{
			Position=UDim2.new(0,12,1,-24),
			Size=UDim2.new(1,-24,0,14),
			BackgroundColor3=Color3.fromRGB(35,35,35),
			BackgroundTransparency=0,
			BorderSizePixel=0,
		})
		mk("UICorner",track,{CornerRadius=UDim.new(0,5)})
		stealBarFill=mk("Frame",track,{
			Size=UDim2.new(0,0,1,0),
			BackgroundColor3=STEAL_ACCENT,
			BorderSizePixel=0,
		})
		mk("UICorner",stealBarFill,{CornerRadius=UDim.new(0,5)})
		_lastFillX=-1
		stealBarSg.Enabled=true
	end
	local function _setFill(x)
		if math.abs(x-_lastFillX)<.002 then
			return
		end
		_lastFillX=x
		stealBarFill.Size=UDim2.new(x,0,1,0)
	end
	local function setStealBarPhase(phase,pct,seconds)
		if not stealBarSg or not stealBarSg.Enabled or _ragdollShown then
			return
		end
		pct=math.clamp(tonumber(pct)or 0,0,1)
		local color,status,timeText=STEAL_ACCENT,"READY",""
		if phase=="stealing"then
			status="STEALING  "..math.floor(pct*100).."%"
			timeText=string.format("%.1fs left",math.max(tonumber(seconds)or 0,0))
		elseif phase=="grabbing"then
			color,status,pct=STEAL_DONE,"IN RANGE  -  GRABBING",1
		elseif phase=="hold"then
			color,status,pct=STEAL_HOLD,"HOLD",1
			timeText=string.format("restart %.1fs",math.max(tonumber(seconds)or 0,0))
		elseif phase=="stolen"then
			color,status,pct=STEAL_DONE,"STOLEN",1
		else
			status,pct="READY",0
			timeText=string.format("%.1fs",math.max(tonumber(seconds)or STEAL_HOLD_DURATION,0))
		end
		stealBarFill.BackgroundColor3=color
		stealBarStatus.TextColor3=color
		stealBarStatus.Text=status
		stealBarSeconds.Text=timeText
		_setFill(pct)
	end
	_G.ElysiumSetStealBarPhase=setStealBarPhase
	_G.ElysiumRenderNearestProgress=function(name,pct)
		ensureStealBar()
		stealBarSg.Enabled=true
		refreshStealTargetLabels(name or"Nearest")
		setStealBarPhase(pct>0 and"stealing"or"ready",pct,1.2*(1-pct))
	end
	showStealBar=function(name,pct)
		pcall(function()
			ensureStealBar()
			pct=math.clamp(tonumber(pct)or 0,0,1)
			stealBarSg.Enabled=true
			refreshStealTargetLabels(name)
			if _ragdollShown then
				return
			end
			setStealBarPhase(pct>0 and"stealing"or"ready",pct,STEAL_HOLD_DURATION*(1-pct))
		end)
	end
	local function setStealBarPct(pct)
		if not stealBarSg or not stealBarSg.Enabled or _ragdollShown then
			return
		end
		pct=math.clamp(tonumber(pct)or 0,0,1)
		setStealBarPhase("stealing",pct,STEAL_HOLD_DURATION*(1-pct))
	end
	local function hideStealBar()
		pcall(function()
			ensureStealBar()
			if _ragdollShown then
				return
			end
			stealBarSg.Enabled=true
			refreshStealTargetLabels()
			setStealBarPhase("ready",0,STEAL_HOLD_DURATION)
		end)
	end
	_clearPrecharge=function(resetCarry)
		local oldUid=_prechargeUid
		_prechargeUid,_prechargeAt,_prechargeTouchedAt,_prechargeHeldSeenAt=nil,0,0,0
		_prechargePulseAt=0
		if resetCarry and _stealHoldCarryPrecharged and(not oldUid or _stealHoldCarryUid==oldUid)then
			_stealHoldCarry,_stealHoldCarryUid=0,nil
			_stealHoldCarryPrecharged=false
		end
		if resetCarry and not _holdBusy()then
			hideStealBar()
		end
	end
	task.defer(hideStealBar)
	;(function()
		local MUT_COLORS={
			gold="#FFD24A",
			diamond="#7FE6FF",
			rainbow="#FF6BD6",
			lava="#FF7A2E",
			bloodrot="#E0303A",
			candy="#FF8FCB",
			galaxy="#9B7BFF",
			yinyang="#E6E6E6",
			radioactive="#7CFF4A",
			cyber="#4AD8FF",
			divine="#FFF2A8",
			cursed="#B04AFF",
			celestial="#A8C8FF",
		}
		local function mutKey(m)
			return(tostring(m or""):lower():gsub("[%s%-_]",""))
		end
		local function hasMutation(m)
			return type(m)=="string"and m~=""and m~="None"and m~="Normal"
		end
		local function mutName(m)
			return mutKey(m)=="yinyang"and"Yin Yang"or tostring(m)
		end
		local function esc(s)
			return(tostring(s):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;"))
		end
		local function mutIcon(m)
			local icons=MUTATION_ICONS
			if not hasMutation(m)or type(icons)~="table"then
				return nil
			end
			if icons[m]then
				return icons[m]
			end
			local wanted=mutKey(m)
			for key,icon in pairs(icons)do
				if mutKey(key)==wanted then
					return icon
				end
			end
			return nil
		end
		local function bannerY()
			return tonumber(_G.ElysiumStealingBannerY)or 48
		end
		local BANNER_H=tonumber(_G.ElysiumStealingBannerH)or 86
		local BANNER_PAD=10
		local PREVIEW=BANNER_H-BANNER_PAD*2
		local sg,wrap,stroke,icon,title,sub
		local previewBox,previewStroke,viewport,vpCam
		local function build()
			if sg and sg.Parent then
				return
			end
			pcall(function()
				local old=GUIHOST:FindFirstChild("ElysiumStealingBanner")
				if old then
					old:Destroy()
				end
			end)
			sg=mk("ScreenGui",GUIHOST,{
				Name="ElysiumStealingBanner",
				ResetOnSpawn=false,
				IgnoreGuiInset=true,
				DisplayOrder=999998,
				Enabled=false,
			})
			wrap=mk("Frame",sg,{
				Name="Wrap",
				AnchorPoint=Vector2.new(.5,0),
				Position=UDim2.new(.5,0,0,bannerY()),
				Size=UDim2.fromOffset(0,BANNER_H),
				AutomaticSize=Enum.AutomaticSize.X,
				BackgroundColor3=Color3.fromRGB(9,9,9),
				BackgroundTransparency=.04,
				BorderSizePixel=0,
			})
			mk("UICorner",wrap,{CornerRadius=UDim.new(0,14)})
			stroke=mk("UIStroke",wrap,{Color=Color3.fromRGB(44,44,44),Thickness=1,Transparency=.2})
			mk("UIPadding",wrap,{
				PaddingLeft=UDim.new(0,BANNER_PAD),
				PaddingRight=UDim.new(0,24),
				PaddingTop=UDim.new(0,BANNER_PAD),
				PaddingBottom=UDim.new(0,BANNER_PAD),
			})
			mk("UIListLayout",wrap,{
				FillDirection=Enum.FillDirection.Horizontal,
				HorizontalAlignment=Enum.HorizontalAlignment.Left,
				VerticalAlignment=Enum.VerticalAlignment.Center,
				SortOrder=Enum.SortOrder.LayoutOrder,
				Padding=UDim.new(0,14),
			})
			previewBox=mk("Frame",wrap,{
				Name="Preview",
				LayoutOrder=1,
				Size=UDim2.fromOffset(PREVIEW,PREVIEW),
				BackgroundColor3=Color3.fromRGB(26,26,29),
				BackgroundTransparency=0,
				BorderSizePixel=0,
				ClipsDescendants=true,
			})
			mk("UICorner",previewBox,{CornerRadius=UDim.new(0,10)})
			mk("UIGradient",previewBox,{
				Rotation=90,
				Color=ColorSequence.new({
					ColorSequenceKeypoint.new(0,Color3.fromRGB(46,46,52)),
					ColorSequenceKeypoint.new(1,Color3.fromRGB(18,18,20)),
				}),
			})
			previewStroke=mk("UIStroke",previewBox,{
				Color=Color3.fromRGB(70,70,76),
				Thickness=1,
				Transparency=.2,
			})
			viewport=mk("ViewportFrame",previewBox,{
				Name="Model",
				Size=UDim2.fromScale(1,1),
				BackgroundTransparency=1,
				Ambient=Color3.fromRGB(175,175,180),
				LightColor=Color3.fromRGB(255,255,255),
				LightDirection=Vector3.new(-.55,-1,-.75),
			})
			mk("UICorner",viewport,{CornerRadius=UDim.new(0,10)})
			vpCam=Instance.new("Camera")
			vpCam.FieldOfView=32
			vpCam.Parent=viewport
			viewport.CurrentCamera=vpCam
			local col=mk("Frame",wrap,{
				Name="Text",
				LayoutOrder=2,
				BackgroundTransparency=1,
				Size=UDim2.fromOffset(0,PREVIEW),
				AutomaticSize=Enum.AutomaticSize.X,
			})
			mk("UIListLayout",col,{
				FillDirection=Enum.FillDirection.Vertical,
				HorizontalAlignment=Enum.HorizontalAlignment.Left,
				VerticalAlignment=Enum.VerticalAlignment.Center,
				SortOrder=Enum.SortOrder.LayoutOrder,
				Padding=UDim.new(0,4),
			})
			local row=mk("Frame",col,{
				Name="Row",
				LayoutOrder=1,
				BackgroundTransparency=1,
				Size=UDim2.fromOffset(0,28),
				AutomaticSize=Enum.AutomaticSize.X,
			})
			mk("UIListLayout",row,{
				FillDirection=Enum.FillDirection.Horizontal,
				HorizontalAlignment=Enum.HorizontalAlignment.Left,
				VerticalAlignment=Enum.VerticalAlignment.Center,
				SortOrder=Enum.SortOrder.LayoutOrder,
				Padding=UDim.new(0,7),
			})
			icon=mk("ImageLabel",row,{
				Name="MutationIcon",
				LayoutOrder=1,
				BackgroundTransparency=1,
				Size=UDim2.fromOffset(26,26),
				ScaleType=Enum.ScaleType.Fit,
				Visible=false,
			})
			title=mk("TextLabel",row,{
				Name="Title",
				LayoutOrder=2,
				BackgroundTransparency=1,
				Size=UDim2.fromOffset(0,28),
				AutomaticSize=Enum.AutomaticSize.X,
				Font=Enum.Font.GothamBold,
				TextSize=22,
				TextColor3=Color3.fromRGB(255,255,255),
				TextXAlignment=Enum.TextXAlignment.Left,
				RichText=true,
				Text="",
			})
			sub=mk("TextLabel",col,{
				Name="Sub",
				LayoutOrder=2,
				BackgroundTransparency=1,
				Size=UDim2.fromOffset(0,22),
				AutomaticSize=Enum.AutomaticSize.X,
				Font=Enum.Font.GothamBold,
				TextSize=17,
				TextColor3=Color3.fromRGB(215,215,215),
				TextXAlignment=Enum.TextXAlignment.Left,
				RichText=true,
				Text="",
			})
		end
		local function stolenPet()
			if _G.ElysiumSourceStealActive and type(_G.ElysiumExternalStealPet)=="table"then
				return _G.ElysiumExternalStealPet
			end
			local last=_G.ElysiumLastGrabPet
			if type(last)=="table"and os.clock()-(tonumber(_G.ElysiumLastGrabAt)or 0)<10 then
				return last
			end
			return _armedPet or _stealTarget
		end
		local RunService=game:GetService("RunService")
		local RS=game:GetService("ReplicatedStorage")
		local STRIP={
			Script=true,LocalScript=true,ModuleScript=true,
			BillboardGui=true,SurfaceGui=true,ScreenGui=true,
			ProximityPrompt=true,ClickDetector=true,Sound=true,
			ParticleEmitter=true,Beam=true,Trail=true,Fire=true,
			Smoke=true,Sparkles=true,Highlight=true,SelectionBox=true,
			Humanoid=true,AnimationController=true,ForceField=true,
		}
		local shownModel,shownKey,spinConn
		local spinAngle,camDist,camPitch=0,10,math.rad(14)
		local shownHeight=0
		local function normName(s)
			return(tostring(s or""):lower():gsub("[%s%-_]",""))
		end
		local function previewKeys(pet)
			local keys,seen={},{}
			local function add(v)
				if v~=nil and tostring(v)~=""and not seen[tostring(v)]then
					seen[tostring(v)]=true
					keys[#keys+1]=tostring(v)
				end
			end
			if pet then
				add(pet.index)
				add(pet.name)
			end
			add(LP:GetAttribute("StealingIndex"))
			if LP.Character then
				add(LP.Character:GetAttribute("StealingIndex"))
			end
			return keys
		end
		local function helperPart(d)
			local n=d.Name:lower()
			return n=="humanoidrootpart"
				or n=="rootpart"
				or n=="root"
				or n:find("hitbox",1,true)~=nil
				or n:find("collis",1,true)~=nil
				or n:find("collider",1,true)~=nil
				or n:find("bound",1,true)~=nil
		end
		local function visibleParts(model,maxTransparency)
			local list,all={},{}
			local limit=maxTransparency or .98
			for _,d in ipairs(model:GetDescendants())do
				if d:IsA("BasePart")then
					all[#all+1]=d
					if d.Transparency<limit and not helperPart(d)then
						list[#list+1]=d
					end
				end
			end
			return list,all
		end
		local function findSource(pet,keys)
			local wanted={}
			for _,k in ipairs(keys)do
				wanted[normName(k)]=true
			end
			local char=LP.Character
			if char then
				for _,ch in ipairs(char:GetChildren())do
					if ch:IsA("Model")and wanted[normName(ch.Name)]and#visibleParts(ch)>0 then
						return ch
					end
				end
			end
			if pet and pet.plot~=nil and pet.slot~=nil and type(_petModelCache)=="table"then
				local m=_petModelCache[tostring(pet.plot).."\0"..tostring(pet.slot)]
				if m and typeof(m)=="Instance"and m:IsA("Model")and#visibleParts(m)>0 then
					return m
				end
			end
			local folders={}
			pcall(function()
				local models=RS:FindFirstChild("Models")
				local a=models and models:FindFirstChild("Animals")
				if a then
					folders[#folders+1]=a
				end
				local b=RS:FindFirstChild("Animals")
				if b and not b:IsA("ModuleScript")then
					folders[#folders+1]=b
				end
			end)
			for _,k in ipairs(keys)do
				for _,folder in ipairs(folders)do
					local m=folder:FindFirstChild(k)
					if m and m:IsA("Model")then
						return m
					end
				end
			end
			for _,k in ipairs(keys)do
				local ok,m=pcall(function()
					return RS:FindFirstChild(k,true)
				end)
				if ok and m and m:IsA("Model")then
					return m
				end
			end
			return nil
		end
		local function cleanClone(src)
			local wasArch=src.Archivable
			if not wasArch then
				pcall(function()
					src.Archivable=true
				end)
			end
			local ok,c=pcall(function()
				return src:Clone()
			end)
			if not wasArch then
				pcall(function()
					src.Archivable=false
				end)
			end
			if not ok or not c then
				return nil
			end
			for _,d in ipairs(c:GetDescendants())do
				if STRIP[d.ClassName]then
					pcall(function()
						d:Destroy()
					end)
				elseif d:IsA("BasePart")then
					d.Anchored=true
					d.CanCollide=false
					d.CastShadow=false
					if d.Name=="HumanoidRootPart"then
						d.Transparency=1
					end
				end
			end
			return c
		end
		local function centreModel(model)
			local pivot=model:GetPivot()
			local inv=(pivot-pivot.Position):Inverse()
			local parts,all=visibleParts(model,.5)
			if#parts==0 then
				parts=visibleParts(model)
			end
			if#parts==0 then
				parts=all
			end
			if#parts==0 then
				return nil
			end
			local boxes,total={},0
			for _,p in ipairs(parts)do
				local cf=inv*p.CFrame
				local s=p.Size*.5
				local x,y,z=cf.XVector,cf.YVector,cf.ZVector
				local e=Vector3.new(
					math.abs(x.X)*s.X+math.abs(y.X)*s.Y+math.abs(z.X)*s.Z,
					math.abs(x.Y)*s.X+math.abs(y.Y)*s.Y+math.abs(z.Y)*s.Z,
					math.abs(x.Z)*s.X+math.abs(y.Z)*s.Y+math.abs(z.Z)*s.Z
				)
				local volume=math.max(p.Size.X*p.Size.Y*p.Size.Z,1e-4)
				total=total+volume
				boxes[#boxes+1]={lo=cf.Position-e,hi=cf.Position+e,c=cf.Position,v=volume}
			end
			table.sort(boxes,function(a,b)
				return a.v>b.v
			end)
			local coreShare=math.clamp(tonumber(_G.ElysiumStealingBannerCore)or .85,.3,1)
			local lo,hi,acc,coreCount=nil,nil,0,0
			for i,b in ipairs(boxes)do
				if acc>=total*coreShare and i>1 then
					break
				end
				lo=lo and lo:Min(b.lo)or b.lo
				hi=hi and hi:Max(b.hi)or b.hi
				acc=acc+b.v
				coreCount=i
			end
			local grow=(hi-lo)*.5
			local glo,ghi=lo-grow,hi+grow
			for i=coreCount+1,#boxes do
				local c=boxes[i].c
				if c.X>=glo.X and c.X<=ghi.X and c.Y>=glo.Y and c.Y<=ghi.Y and c.Z>=glo.Z and c.Z<=ghi.Z then
					lo=lo:Min(boxes[i].lo)
					hi=hi:Max(boxes[i].hi)
				end
			end
			local centre=(lo+hi)*.5
			model:PivotTo(CFrame.new(-centre)*inv*pivot)
			return hi-lo
		end
		local function placeCamera()
			if not vpCam then
				return
			end
			local yaw=spinAngle+math.rad(tonumber(_G.ElysiumStealingBannerYaw)or 0)
			local horiz=camDist*math.cos(camPitch)
			local aimY=-shownHeight*(tonumber(_G.ElysiumStealingBannerLift)or .06)
			local pos=Vector3.new(math.sin(yaw)*horiz,aimY+camDist*math.sin(camPitch),-math.cos(yaw)*horiz)
			vpCam.CFrame=CFrame.lookAt(pos,Vector3.new(0,aimY,0))
		end
		local function stopSpin()
			if spinConn then
				pcall(function()
					spinConn:Disconnect()
				end)
				spinConn=nil
			end
			_G.ElysiumStealingBannerSpinConn=nil
		end
		local function clearPreview()
			stopSpin()
			if shownModel then
				pcall(function()
					shownModel:Destroy()
				end)
			end
			shownModel,shownKey=nil,nil
		end
		local function startSpin()
			if spinConn then
				return
			end
			spinConn=RunService.RenderStepped:Connect(function(dt)
				local speed=tonumber(_G.ElysiumStealingBannerSpin)or 40
				if speed~=0 and shownModel then
					spinAngle=(spinAngle+math.rad(speed)*math.min(dt,.1))%(math.pi*2)
					placeCamera()
				end
			end)
			_G.ElysiumStealingBannerSpinConn=spinConn
		end
		local function updatePreview(pet)
			if not viewport then
				return
			end
			local keys=previewKeys(pet)
			local key=table.concat(keys,"|")
				.."|"..tostring(pet and pet.plot).."|"..tostring(pet and pet.slot)
			if shownModel and shownKey==key and shownModel.Parent==viewport then
				startSpin()
				return
			end
			clearPreview()
			local src=findSource(pet,keys)
			local clone=src and cleanClone(src)
			local size=clone and centreModel(clone)
			if not size then
				if clone then
					pcall(function()
						clone:Destroy()
					end)
				end
				return
			end
			clone.Parent=viewport
			shownModel,shownKey=clone,key
			local radius=math.sqrt(size.X*size.X+size.Z*size.Z)*.5
			local half=math.max(size.Y*.5,radius)
			shownHeight=size.Y
			camDist=half/math.tan(math.rad(vpCam.FieldOfView*.5))*1.06+radius
			spinAngle=0
			placeCamera()
			startSpin()
		end
		if _G.ElysiumStealingBannerSpinConn then
			pcall(function()
				_G.ElysiumStealingBannerSpinConn:Disconnect()
			end)
			_G.ElysiumStealingBannerSpinConn=nil
		end
		local showSerial=0
		local visible=false
		local TweenService=game:GetService("TweenService")
		local function paint(alpha,time,style,dir,pos)
			local props={
				[wrap]={BackgroundTransparency=.04+.96*alpha,Position=pos},
				[stroke]={Transparency=.2+.8*alpha},
				[title]={TextTransparency=alpha},
				[sub]={TextTransparency=alpha},
				[icon]={ImageTransparency=alpha},
				[previewBox]={BackgroundTransparency=alpha},
				[previewStroke]={Transparency=.2+.8*alpha},
				[viewport]={ImageTransparency=alpha},
			}
			for obj,goal in pairs(props)do
				pcall(function()
					if time then
						TweenService:Create(obj,TweenInfo.new(time,style,dir),goal):Play()
					else
						for key,value in pairs(goal)do
							obj[key]=value
						end
					end
				end)
			end
		end
		local function hide()
			if not(sg and sg.Enabled)then
				return
			end
			visible=false
			showSerial=showSerial+1
			local token=showSerial
			local time=tonumber(_G.ElysiumStealingBannerFade)or .45
			paint(1,time,Enum.EasingStyle.Quad,Enum.EasingDirection.In,UDim2.new(.5,0,0,bannerY()-14))
			task.delay(time+.02,function()
				if showSerial==token and sg then
					sg.Enabled=false
					clearPreview()
				end
			end)
		end
		local function show()
			build()
			local pet=stolenPet()
			local name=(pet and pet.name)or _currentTargetName or"Brainrot"
			local mutation=pet and pet.mutation
			if not hasMutation(mutation)and pet and pet.plot and pet.slot~=nil then
				pcall(function()
					local ch=getPlotChannel(pet.plot)
					local list=ch and channelGet(ch,"AnimalList")
					if type(list)=="table"then
						local e=list[pet.slot]or list[tonumber(pet.slot)or-1]or list[tostring(pet.slot)]
						if type(e)=="table"then
							mutation=e.Mutation
						end
					end
				end)
			end
			local image=mutIcon(mutation)
			icon.Image=image and tostring(image)or""
			icon.Visible=image~=nil and tostring(image)~=""
			title.Text='<font color="#BEBEBE">You Stealing:</font> '..esc(name)
			local parts={}
			if hasMutation(mutation)then
				parts[#parts+1]=string.format(
					'<font color="%s">%s</font>',
					MUT_COLORS[mutKey(mutation)]or"#FFFFFF",
					esc(mutName(mutation))
				)
			end
			local mps=pet and tonumber(pet.mps)
			if mps and mps>0 then
				parts[#parts+1]=esc(shortMoney(mps)).."/s"
			end
			sub.Text=table.concat(parts," ")
			sub.Visible=#parts>0
			pcall(updatePreview,pet)
			showSerial=showSerial+1
			if not visible then
				local y=bannerY()
				paint(1,nil,nil,nil,UDim2.new(.5,0,0,y-14))
				sg.Enabled=true
				paint(0,.3,Enum.EasingStyle.Quad,Enum.EasingDirection.Out,UDim2.new(.5,0,0,y))
				visible=true
			end
			local hold=tonumber(_G.ElysiumStealingBannerTime)
			if hold and hold>0 then
				local token=showSerial
				task.delay(hold,function()
					if showSerial==token then
						hide()
					end
				end)
			end
		end
		local function sync()
			if _G.ElysiumStealingBanner~=false and LP:GetAttribute("Stealing")==true then
				pcall(show)
			elseif sg then
				hide()
			end
		end
		if _G.ElysiumStealingBannerConn then
			pcall(function()
				_G.ElysiumStealingBannerConn:Disconnect()
			end)
		end
		if _G.ElysiumStealingBannerIdxConn then
			pcall(function()
				_G.ElysiumStealingBannerIdxConn:Disconnect()
			end)
		end
		_G.ElysiumStealingBannerConn=LP:GetAttributeChangedSignal("Stealing"):Connect(sync)
		_G.ElysiumStealingBannerIdxConn=LP:GetAttributeChangedSignal("StealingIndex"):Connect(function()
			if visible then
				sync()
			end
		end)
		task.defer(sync)
	end)()
	local _ragdollStates={
		[Enum.HumanoidStateType.Physics]=true,
		[Enum.HumanoidStateType.Ragdoll]=true,
		[Enum.HumanoidStateType.FallingDown]=true,
		[Enum.HumanoidStateType.PlatformStanding]=true,
	}
	local function ragdollRemainingNow()
		local now=workspace:GetServerTimeNow()
		local attrEnd=tonumber(LP:GetAttribute("RagdollEndTime"))or 0
		local observedEnd=tonumber(_G.ElysiumRagdollObservedUntil)or 0
		return math.max(0,math.max(attrEnd,observedEnd)-now)
	end
	local function ragdollActiveNow()
		if ragdollRemainingNow()>.02 then
			return true
		end
		local char=LP.Character
		local hum=char and char:FindFirstChildOfClass("Humanoid")
		return hum~=nil and _ragdollStates[hum:GetState()]==true
	end
	local function captureRagdollEnd()
		local serverNow=workspace:GetServerTimeNow()
		local attrEnd=tonumber(LP:GetAttribute("RagdollEndTime"))or 0
		if attrEnd>serverNow then
			_G.ElysiumRagdollObservedUntil=math.max(tonumber(_G.ElysiumRagdollObservedUntil)or 0,attrEnd)
		end
	end
	if _G.ElysiumRagdollAttrConn then
		pcall(function()
			_G.ElysiumRagdollAttrConn:Disconnect()
		end)
	end
	_G.ElysiumRagdollAttrConn=LP:GetAttributeChangedSignal("RagdollEndTime"):Connect(captureRagdollEnd)
	captureRagdollEnd()
	if _G.ElysiumRagdollBarConn then
		pcall(function()
			_G.ElysiumRagdollBarConn:Disconnect()
		end)
	end
	_G.ElysiumRagdollBarConn=RunService.RenderStepped:Connect(function()
		local serverNow=workspace:GetServerTimeNow()
		local attrEnd=tonumber(LP:GetAttribute("RagdollEndTime"))or 0
		local observedEnd=tonumber(_G.ElysiumRagdollObservedUntil)or 0
		local ragdollEnd=math.max(attrEnd,observedEnd)
		local remaining=math.max(0,ragdollEnd-serverNow)
		local char=LP.Character
		local hum=char and char:FindFirstChildOfClass("Humanoid")
		local stateRagdoll=hum and _ragdollStates[hum:GetState()]==true
		if stateRagdoll and remaining<=0 then
			ragdollEnd=serverNow+(tonumber(_G.ElysiumRagdollFallbackSeconds)or .75)
			_G.ElysiumRagdollObservedUntil=ragdollEnd
			remaining=ragdollEnd-serverNow
		end
		local active=remaining>0 or stateRagdoll
		if active then
			local enteredRagdoll=not _ragdollShown
			if enteredRagdoll or ragdollEnd>_ragdollEndSeen+.05 then
				_ragdollShown=true
				_ragdollStartedAt=os.clock()
				_ragdollInitialRemaining=math.max(remaining,.1)
				_ragdollEndSeen=ragdollEnd
			end
			if enteredRagdoll then
				_G.ElysiumInvisBlockedUntil=math.max(tonumber(_G.ElysiumInvisBlockedUntil)or 0,ragdollEnd)
				task.defer(function()
					if _G.ElysiumDisableInvisibleSteal then
						pcall(_G.ElysiumDisableInvisibleSteal,"ragdoll")
					elseif
						(_G.ElysiumInvisActive==true or _G.invisibleStealEnabled==true)
						and _G.toggleInvisibleSteal
					then
						pcall(_G.toggleInvisibleSteal)
					end
				end)
			end
			ensureStealBar()
			refreshStealTargetLabels()
			stealBarFill.BackgroundColor3=STEAL_RAG
			stealBarStatus.Text="RAGDOLLED"
			stealBarStatus.TextColor3=STEAL_RAG
			if remaining>0 then
				stealBarSeconds.Text=string.format("%.1fs",remaining)
				_setFill((_stealHoldActive or _stealTarget)and .9 or 0)
			else
				local elapsed=math.max(0,os.clock()-_ragdollStartedAt)
				stealBarSeconds.Text=string.format("%.1fs",elapsed)
				_setFill((_stealHoldActive or _stealTarget)and .9 or 0)
			end
		elseif _ragdollShown then
			_ragdollShown=false
			_ragdollStartedAt=0
			_ragdollInitialRemaining=0
			_ragdollEndSeen=0
			if observedEnd<=serverNow then
				_G.ElysiumRagdollObservedUntil=0
			end
			stealBarFill.BackgroundColor3=STEAL_ACCENT
			if _stealHoldActive then
				refreshStealTargetLabels()
				stealBarStatus.Text="STEALING"
				stealBarStatus.TextColor3=STEAL_ACCENT
				stealBarSeconds.Text=""
			else
				hideStealBar()
			end
		end
	end)
	local function buildStealCallbacks(prompt)
		if not prompt or not prompt.Parent then
			return
		end
		local actions=_G.ElysiumActions
		local shared=actions and actions.game==game and actions.GetPromptCallbacks(prompt)
		if shared then
			InternalStealCache[prompt]={holdCallbacks=shared.began,triggerCallbacks=shared.triggered,holdEndCallbacks=shared.ended,ready=true}
			return
		end
		if InternalStealCache[prompt]then return end
		local data={holdCallbacks={},triggerCallbacks={},holdEndCallbacks={},ready=true}
		local function grab(sig,into)
			local ok,conns=pcall(getconnections,sig)
			if ok and type(conns)=="table"then
				for _,c in ipairs(conns)do
					if type(c.Function)=="function"then
						table.insert(into,c.Function)
					end
				end
			end
		end
		grab(prompt.PromptButtonHoldBegan,data.holdCallbacks)
		grab(prompt.Triggered,data.triggerCallbacks)
		grab(prompt.PromptButtonHoldEnded,data.holdEndCallbacks)
		if#data.holdCallbacks>0 or#data.triggerCallbacks>0 or#data.holdEndCallbacks>0 then
			InternalStealCache[prompt]=data
		end
	end
	local _stealBegin
	local function _armRoseSteal(prompt)
		if not prompt or not prompt.Parent then
			return false
		end
		pcall(function()
			if prompt:GetAttribute("State")~=nil then
				prompt:SetAttribute("State","Steal")
			end
		end)
		pcall(_stealBegin)
		return true
	end
	local _rawFireServer=Instance.new("RemoteEvent").FireServer
	local _reBegin,_reCommit=nil,nil
	local _reState,_reRetryAt={},{}
	local function _re(cache,hash)
		if cache and cache.Parent then
			return cache
		end
		local st=_reState[hash]
		if typeof(st)=="Instance"then
			if st.Parent then
				return st
			end
			_reState[hash]=nil
			st=nil
		end
		if st=="pending"then
			return nil
		end
		if st=="failed"and os.clock()<(_reRetryAt[hash]or 0)then
			return nil
		end
		_reState[hash]="pending"
		task.spawn(function()
			local got
			pcall(function()
				if _G.ElysiumGetRemote then
					got=_G.ElysiumGetRemote("RemoteEvent",hash)
				end
			end)
			if typeof(got)=="Instance"then
				_reState[hash]=got
			else
				_reState[hash]="failed"
				_reRetryAt[hash]=os.clock()+(tonumber(_G.ElysiumRemoteRetry)or 5)
			end
		end)
		task.delay(tonumber(_G.ElysiumRemoteResolveWait)or 3,function()
			if _reState[hash]=="pending"then
				_reState[hash]="failed"
				_reRetryAt[hash]=os.clock()+(tonumber(_G.ElysiumRemoteRetry)or 5)
			end
		end)
		return nil
	end
	_stealBegin=function()
		local actions=_G.ElysiumActions
		if actions and actions.game==game and actions.version==23 then return true end
		_reBegin=_re(_reBegin,"f40f7d9e-2f0d-4167-b250-899273f46874")
		if not _reBegin then
			return false
		end
		local t=workspace:GetServerTimeNow()+124
		pcall(_rawFireServer,_reBegin,t,"68c86eb7-eb7e-4b4d-96ae-cf7cd847c5b0")
		pcall(function()
			_rawFireServer(_reBegin,t,"07b9cc25-2a1f-4a26-a0ec-f2fab578d8bd")
		end)
		return true
	end
	local function _stealCommit(plot,slot)
		local actions=_G.ElysiumActions
		if actions and actions.game==game and actions.version==23 then
			local prompt=findStealPrompt({plot=plot,slot=slot})
			return prompt and actions.Commit(prompt,plot,slot)or false
		end
		_reCommit=_re(_reCommit,"3ba148c9-7ed6-4675-93f8-9f7c356a2c54")
		if not _reCommit then
			return false
		end
		if type(plot)~="string"or slot==nil then
			return false
		end
		local sl=tonumber(slot)or slot
		local t=workspace:GetServerTimeNow()+31
		pcall(_rawFireServer,_reCommit,t,"cda5c764-d4e3-45c4-94e4-53a538347590",plot,sl)
		pcall(function()
			_rawFireServer(_reCommit,t,"8c852fbf-d542-4ef4-aa28-612e24db8d4a",plot,sl)
		end)
		return true
	end
	_G.ElysiumStealBegin,_G.ElysiumStealCommit=_stealBegin,_stealCommit
	local _roseActionPromptCache=setmetatable({},{__mode="k"})
	local _roseHoldEpoch=0
	local function _rosePromptDistance(prompt)
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return nil,nil
		end
		local parent=prompt and prompt.Parent
		local pos
		if parent then
			if parent:IsA("Attachment")then
				pos=parent.WorldPosition
			elseif parent:IsA("BasePart")then
				pos=parent.Position
			else
				local part=parent:FindFirstAncestorWhichIsA("BasePart")
				if part then
					pos=part.Position
				end
			end
		end
		if not pos then
			return nil,nil
		end
		local hp=hrp.Position
		local dx,dz=pos.X-hp.X,pos.Z-hp.Z
		return math.sqrt(dx*dx+dz*dz),(pos-hp).Magnitude
	end
	local function _roseActionPrompt(prompt,data)
		local cached=_roseActionPromptCache[prompt]
		if cached~=nil then
			return cached or nil
		end
		if debug and debug.getupvalues and data then
			for _,fn in ipairs(data.holdCallbacks or{})do
				local ok,upvalues=pcall(debug.getupvalues,fn)
				if ok and type(upvalues)=="table"then
					for _,value in pairs(upvalues)do
						if
							type(value)=="table"
							and rawget(value,"State")~=nil
							and rawget(value,"ProximityPrompt")~=nil
						then
							_roseActionPromptCache[prompt]=value
							return value
						end
					end
				end
			end
		end
		_roseActionPromptCache[prompt]=false
		return nil
	end
	local function _roseFireHold(prompt,data)
		if _G.ElysiumSourceStealActive then
			return false
		end
		if not data or#(data.holdCallbacks or{})==0 then
			return false
		end
		local actionPrompt=_roseActionPrompt(prompt,data)
		if actionPrompt and actionPrompt.State~="Steal"then
			local oldState=actionPrompt.State
			actionPrompt.State="Steal"
			for _,fn in ipairs(data.holdCallbacks)do
				pcall(fn)
			end
			actionPrompt.State=oldState
			return true
		end
		if not actionPrompt and prompt and prompt.Enabled==false then
			return false
		end
		for _,fn in ipairs(data.holdCallbacks)do
			task.spawn(fn)
		end
		return true
	end
	local function _roseFireTrigger(prompt,data)
		if _G.ElysiumSourceStealActive then
			return false
		end
		if not prompt then
			return false
		end
		if fireproximityprompt and _G.ElysiumStealUseFPP~=false then
			pcall(fireproximityprompt,prompt)
			return true
		end
		local fired=false
		for _,fn in ipairs(data and data.triggerCallbacks or{})do
			task.spawn(fn)
			fired=true
		end
		if not fired and fireproximityprompt then
			pcall(fireproximityprompt,prompt)
			fired=true
		end
		return fired
	end
	local function _roseRefreshCallbacks(prompt)
		if not prompt then
			return nil
		end
		_roseActionPromptCache[prompt]=nil
		InternalStealCache[prompt]=nil
		buildStealCallbacks(prompt)
		return InternalStealCache[prompt]
	end
	local function _roseHeldByOtherPlayer(pet)
		if not pet then
			return false
		end
		local wantedIndex=tostring(pet.index or""):lower():gsub("%s+","")
		local wantedName=tostring(pet.name or""):lower():gsub("%s+","")
		for _,player in ipairs(Players:GetPlayers())do
			if player~=LP then
				local index=player:GetAttribute("StealingIndex")
				if index==nil and player.Character then
					index=player.Character:GetAttribute("StealingIndex")
				end
				local held=tostring(index or""):lower():gsub("%s+","")
				if held~=""and(held==wantedIndex or held==wantedName)then
					return true
				end
			end
		end
		return false
	end
	local function _roseLivePetDistance(pet,prompt)
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return nil
		end
		local pos=_armLivePos(pet)
		if pos then
			pet.position=pos
			return(pos-hrp.Position).Magnitude
		end
		local _,distance3d=_rosePromptDistance(prompt)
		return distance3d
	end
	local function _roseTpBlocking(petUid)
		local moving=_G.ElysiumStealHold==true
		if not moving and type(_G.ElysiumIsTeleporting)=="function"then
			local ok,value=pcall(_G.ElysiumIsTeleporting)
			moving=ok and value==true
		end
		if not moving then
			return false
		end
		local currentUid=_stealTarget and _petUid(_stealTarget)
		return currentUid==nil or currentUid==petUid
	end
	local function executeStealAsync(prompt,petName,restoreMax,pet)
		if _holdBusy()or not(prompt and prompt.Parent)then
			return false
		end
		local data=InternalStealCache[prompt]or _roseRefreshCallbacks(prompt)
		if not data or not data.ready then
			return false
		end
		data.ready=false
		local petUid=_petUid(pet)
		local carried=0
		if _stealHoldCarryUid==petUid then
			carried=math.clamp(tonumber(_stealHoldCarry)or 0,0,STEAL_HOLD_MAX)
		end
		_stealHoldCarry,_stealHoldCarryUid=0,nil
		_stealHoldCarryInherited=false
		_stealHoldCarryPrecharged=false
		_stealHoldGeneration+=1
		local generation=_stealHoldGeneration
		_stealHoldPetUid=petUid
		_stealHoldActive=true
		_stealHoldStart=tick()-carried
		local initialPrompt=prompt
		local oldDuration
		pcall(function()
			oldDuration=prompt.HoldDuration
			prompt.HoldDuration=0
			prompt.MaxActivationDistance=math.huge
		end)
		showStealBar(petName,math.clamp(carried/STEAL_HOLD_DURATION,0,1))
		task.spawn(function()
			local activePrompt,activeData=prompt,data
			local touchedData={[data]=true}
			local touchedMax=setmetatable({[prompt]=restoreMax==nil and false or restoreMax},{__mode="k"})
			local function preparePrompt(nextPrompt)
				if touchedMax[nextPrompt]==nil then
					local previous
					pcall(function()
						previous=nextPrompt.MaxActivationDistance
					end)
					touchedMax[nextPrompt]=previous==nil and false or previous
				end
				pcall(function()
					nextPrompt.HoldDuration=0
					nextPrompt.MaxActivationDistance=math.huge
				end)
			end
			local duration=tonumber(_G.ElysiumStealDuration)
			if not duration then
				local serverDuration=(_G.ElysiumStealUsePromptHold==true)and tonumber(oldDuration)or nil
				duration=((serverDuration and serverDuration>.1 and serverDuration)or STEAL_HOLD_DURATION)
					+(tonumber(_G.ElysiumStealHoldPad)or 0)
			end
			local maxCycle=tonumber(_G.ElysiumStealMaxHold)or(duration+(tonumber(_G.ElysiumStealExtendWindow)or 1.3))
			local absoluteStart=tick()
			local beginAt=0
			local carryAge=_roseHoldEpoch>0 and(tick()-_roseHoldEpoch)or math.huge
			if carried>0 and carryAge<=(tonumber(_G.ElysiumStealCarryMax)or 1.25)then
				beginAt=_roseHoldEpoch
			elseif _roseFireHold(activePrompt,activeData)then
				beginAt=activePrompt.Enabled and tick()or 0
				if beginAt>0 then
					_roseHoldEpoch=beginAt
				end
			end
			local cycleAt=carried>0 and(tick()-math.min(carried,duration))or tick()
			_stealHoldStart=cycleAt
			local abort,grabbed,recycle=false,false,false
			local promptGoneAt,disabledAt=nil,nil
			local bankAt,eligibilityAt=0,0
			local commitCount,lastCommitAt=0,0
			local clearFireUntil,commitGraceUntil=0,0
			local wasTpBlocking=false
			local ok,runtimeError=pcall(function()
				while true do
					local now=tick()
					if generation~=_stealHoldGeneration then
						abort=true
						break
					end
					if LP:GetAttribute("Stealing")==true then
						grabbed=true
						setStealBarPhase("stolen",1,0)
						break
					end
					local currentUid=_stealTarget and _petUid(_stealTarget)
					if currentUid and petUid and currentUid~=petUid then
						abort=true
						break
					end
					if not(activePrompt and activePrompt.Parent and activePrompt:IsDescendantOf(workspace))then
						promptGoneAt=promptGoneAt or now
						local replacement=findStealPrompt(pet)
						if replacement and replacement.Parent then
							local replacementData=_roseRefreshCallbacks(replacement)
							if replacementData then
								activePrompt,activeData=replacement,replacementData
								touchedData[activeData]=true
								activeData.ready=false
								preparePrompt(activePrompt)
								if _roseFireHold(activePrompt,activeData)then
									bankAt,beginAt,_roseHoldEpoch=now,now,now
								end
								promptGoneAt,disabledAt=nil,nil
								cycleAt,commitCount,lastCommitAt,recycle=now,0,0,false
							else
								task.wait(tonumber(_G.ElysiumStealPoll)or .015)
								continue
							end
						else
							if bankAt==0 or now-bankAt>(tonumber(_G.ElysiumStealBankRefresh)or 2.5)then
								if _roseFireHold(activePrompt,activeData)then
									bankAt,_roseHoldEpoch=now,now
								end
							end
							if now-promptGoneAt>(tonumber(_G.ElysiumStealPromptGoneWait)or 6.5)then
								break
							end
							setStealBarPhase(
								"hold",
								1,
								math.max((tonumber(_G.ElysiumStealPromptGoneWait)or 6.5)-(now-promptGoneAt),0)
							)
							task.wait(tonumber(_G.ElysiumStealPoll)or .015)
							continue
						end
					end
					if activePrompt.Parent and not activePrompt.Enabled then
						disabledAt=disabledAt or now
						if bankAt==0 or now-bankAt>(tonumber(_G.ElysiumStealBankRefresh)or 2.5)then
							if _roseFireHold(activePrompt,activeData)then
								bankAt,_roseHoldEpoch=now,now
							end
						end
						if
							now-disabledAt>(tonumber(_G.ElysiumStealDisabledGrace)or 3)
							and not _roseHeldByOtherPlayer(pet)
						then
							break
						end
						cycleAt,commitCount,lastCommitAt,recycle=now,0,0,false
						_stealHoldStart=bankAt>0 and bankAt or now
						setStealBarPhase(
							"hold",
							1,
							math.max((tonumber(_G.ElysiumStealDisabledGrace)or 3)-(now-disabledAt),0)
						)
						task.wait(tonumber(_G.ElysiumStealPoll)or .015)
						continue
					elseif disabledAt then
						disabledAt=nil
						activeData=_roseRefreshCallbacks(activePrompt)or activeData
						touchedData[activeData]=true
						if bankAt>0 and now-bankAt<=(tonumber(_G.ElysiumStealBankUseMax)or 2.3)then
							beginAt,cycleAt,_stealHoldStart=bankAt,bankAt,bankAt
						elseif _roseFireHold(activePrompt,activeData)then
							beginAt,cycleAt,_stealHoldStart=now,now,now
							_roseHoldEpoch=now
						end
						bankAt,commitCount,lastCommitAt,recycle=0,0,0,false
						eligibilityAt=now-(tonumber(_G.ElysiumStealEntryDelay)or .15)
						clearFireUntil=math.max(clearFireUntil,now+(tonumber(_G.ElysiumStealDropSettle)or .5))
					end
					if#(activeData.holdCallbacks or{})==0 then
						activeData=_roseRefreshCallbacks(activePrompt)or activeData
						touchedData[activeData]=true
						if beginAt==0 and _roseFireHold(activePrompt,activeData)then
							beginAt,cycleAt,_stealHoldStart=now,now,now
							_roseHoldEpoch=now
						end
					end
					local ragBlocked=ragdollActiveNow()
					if
						commitCount==0
						and not ragBlocked
						and beginAt>0
						and now-beginAt>(tonumber(_G.ElysiumStealSrvHoldMax)or 2.5)
					then
						if _roseFireHold(activePrompt,activeData)then
							beginAt,cycleAt,_stealHoldStart=now,now,now
							_roseHoldEpoch=now
						end
					end
					local petDistance=_roseLivePetDistance(pet,activePrompt)
					local inRange=petDistance~=nil
						and petDistance<=(tonumber(_G.ElysiumStealCommitRange)or tonumber(_G.ElysiumStealGrabDist)or 10)
					local tpBlocking=_G.ElysiumStealTpGate~=false and _roseTpBlocking(petUid)
					if wasTpBlocking and not tpBlocking then
						clearFireUntil=math.max(clearFireUntil,now+(tonumber(_G.ElysiumStealTpRelGrace)or .75))
					end
					wasTpBlocking=tpBlocking
					if inRange and not tpBlocking then
						eligibilityAt=eligibilityAt>0 and eligibilityAt or now
					else
						eligibilityAt=0
					end
					local entryDelay=tonumber(_G.ElysiumStealEntryDelay)or .15
					local settled=eligibilityAt>0 and now-eligibilityAt>=entryDelay
					local holdDone=now-cycleAt>=duration
					local serverHold=tonumber(_G.ElysiumStealSrvHold)or duration
					local serverHoldMax=tonumber(_G.ElysiumStealSrvHoldMax)or 2.5
					local beginAge=beginAt>0 and(now-beginAt)or-1
					local canCommit=holdDone
						and not ragBlocked
						and inRange
						and not tpBlocking
						and settled
						and beginAge>=serverHold
						and beginAge<=serverHoldMax
					if canCommit and commitCount==0 then
						lastCommitAt,commitCount=now,1
						_roseFireTrigger(activePrompt,activeData)
					end
					if commitCount>0 and now-lastCommitAt>=(tonumber(_G.ElysiumStealCommitWait)or .3)then
						recycle=true
					end
					commitGraceUntil=0
					if _G.ElysiumStealHoldForSettle~=false and not grabbed and(eligibilityAt>0 or ragBlocked)then
						local margin=tonumber(_G.ElysiumStealCommitFireMargin)or .06
						if commitCount==0 then
							local due=cycleAt+duration+margin
							if eligibilityAt>0 and not settled then
								due=math.max(due,eligibilityAt+entryDelay+margin)
							end
							if beginAt>0 then
								due=math.max(due,beginAt+serverHold+margin)
							end
							commitGraceUntil=due
						else
							commitGraceUntil=lastCommitAt+(tonumber(_G.ElysiumStealCommitWait)or .3)
						end
					end
					local elapsed=now-cycleAt
					if canCommit or commitCount>0 then
						setStealBarPhase("grabbing",1,0)
					elseif holdDone then
						local restartIn=math.max(commitGraceUntil-now,maxCycle-elapsed,0)
						setStealBarPhase("hold",1,restartIn)
					else
						local pct=math.clamp(elapsed/math.max(duration,.01),0,1)
						setStealBarPhase("stealing",pct,math.max(duration-elapsed,0))
					end
					if
						(elapsed>=maxCycle or recycle)
						and now>=clearFireUntil
						and now>=commitGraceUntil
						and not tpBlocking
					then
						break
					end
					if now-absoluteStart>(tonumber(_G.ElysiumStealHoldMaxTotal)or 20)then
						break
					end
					task.wait(tonumber(_G.ElysiumStealPoll)or .015)
				end
			end)
			if activePrompt and activePrompt.Parent and not abort and not grabbed and commitCount==0 then
				local distance=_roseLivePetDistance(pet,activePrompt)
				local serverHold=tonumber(_G.ElysiumStealSrvHold)or duration
				local age=beginAt>0 and(tick()-beginAt)or-1
				if
					distance
					and distance<=(tonumber(_G.ElysiumStealCommitRange)or 10)
					and activePrompt.Enabled
					and age>=serverHold
					and age<=(tonumber(_G.ElysiumStealSrvHoldMax)or 2.5)
				then
					_roseFireTrigger(activePrompt,activeData)
				end
			end
			if activeData and activeData.holdEndCallbacks then
				for _,fn in ipairs(activeData.holdEndCallbacks)do
					task.spawn(fn)
				end
			end
			pcall(function()
				if initialPrompt and initialPrompt.Parent then
					initialPrompt.HoldDuration=oldDuration
				end
			end)
			if activePrompt~=initialPrompt then
				pcall(function()
					if activePrompt and activePrompt.Parent then
						activePrompt.HoldDuration=oldDuration
					end
				end)
			end
			for touchedPrompt,previousMax in pairs(touchedMax)do
				if touchedPrompt and touchedPrompt.Parent and previousMax~=false then
					pcall(function()
						touchedPrompt.MaxActivationDistance=previousMax
					end)
				end
			end
			for touched in pairs(touchedData)do
				touched.ready=true
			end
			if _stealHoldPetUid==petUid then
				_stealHoldActive=false
				_stealHoldPetUid=nil
			end
			if grabbed then
				setStealBarPhase("stolen",1,0)
			elseif not(_stealHoldCarryUid and _stealHoldCarryInherited)then
				hideStealBar()
			end
			if not ok then
				_G.ElysiumAutoGrabLastError=tostring(runtimeError)
			end
		end)
		return true
	end
	local function timeUntilCanSteal()
		if
			LP:GetAttribute("Stealing")
			or LP:GetAttribute("IsTrading")
			or LP:GetAttribute("IsDuelSelecting")
			or LP:GetAttribute("Web")
		then
			return-1
		end
		local ragdoll=LP:GetAttribute("RagdollEndTime")
		if ragdoll then
			local r=ragdoll-workspace:GetServerTimeNow()
			if r>0 then
				return r
			end
		end
		return 0
	end
	local stealOn=(_G.ElysiumStealMode~=nil)
	local _emptyScans=0
	local function _heldByOtherPlayer(pet)
		if not pet then
			return false
		end
		local function norm(v)
			return tostring(v or""):lower():gsub("%s+","")
		end
		local wantedIndex,wantedName=norm(pet.index),norm(pet.name)
		for _,plr in ipairs(Players:GetPlayers())do
			if plr~=LP then
				local idx=plr:GetAttribute("StealingIndex")
				if idx==nil and plr.Character then
					idx=plr.Character:GetAttribute("StealingIndex")
				end
				local held=norm(idx)
				local stealing=plr:GetAttribute("Stealing")==true
					or(plr.Character and plr.Character:GetAttribute("Stealing")==true)
				if stealing and held~=""and(held==wantedIndex or held==wantedName)then
					return true
				end
			end
		end
		return false
	end
	local function _primeUnavailableTarget(pet)
		local uid=_petUid(pet)
		local now=tick()
		local held=_heldByOtherPlayer(pet)
		if held then
			_prechargeHeldSeenAt=now
		end
		if _prechargeUid~=uid then
			local carried=(_stealHoldCarryUid==uid)and(tonumber(_stealHoldCarry)or 0)or 0
			_prechargeUid=uid
			_prechargeAt=now-math.clamp(carried,0,STEAL_HOLD_DURATION)
			_prechargeHeldSeenAt=held and now or 0
			pcall(_stealBegin)
		end
		if now-_prechargePulseAt>=(tonumber(_G.ElysiumPrechargePulse)or .18)then
			_prechargePulseAt=now
			pcall(_stealBegin)
		end
		_prechargeTouchedAt=now
		local elapsed=math.clamp(now-_prechargeAt,0,STEAL_HOLD_DURATION)
		_stealHoldCarry=elapsed
		_stealHoldCarryUid=uid
		_stealHoldCarryInherited=false
		_stealHoldCarryPrecharged=true
		showStealBar(pet.name,elapsed/STEAL_HOLD_DURATION)
		return true
	end
	local priorityTransport={remotes={},started=false}
	local PRIORITY_BUILDS={
		{
			Begin="b77dde61-dd74-4f18-b329-2ac7f7e48f0b",
			Grab="0c1792e6-3df9-46fd-8b46-be6e4e6df08f",
			BeginArgs={{79,"94fa9dee-cfa2-4cc2-ac2a-0659e5169fac"},{79,"173cd914-bfdd-4c77-80bc-86864bd1ecb4"},},
			GrabArgs={{141,"859270da-f6e7-4110-af2e-4c58fa259c75"},{141,"b231811b-fa22-4265-81fe-424ea71ddb92"},},
		},
		{
			Begin="f1a4d3a5-b97a-4622-8fd6-232663ff697e",
			Grab="f5f26af9-cb1b-4588-bcc9-12fd78f64599",
			BeginArgs={{50,"ba10cc43-8b93-4b7d-93b8-e1935730ebe3"},{50,"ed327974-0c39-423a-b9c7-467b8fdac46d"},},
			GrabArgs={{16,"7aae3e74-d52e-433a-83b1-9d5a507d2e80"},{16,"c3eb316e-a4cc-4dc9-8b0e-1a770a7d99fd"},},
		},
	}
	local function resolvePriorityTransport()
		if priorityTransport.started or os.clock()<(priorityTransport.retryAt or 0)then return end
		priorityTransport.started=true
		task.spawn(function()
			local ok,err=pcall(function()
				for _,build in ipairs(PRIORITY_BUILDS)do
					local begin=getRemote("RemoteEvent",build.Begin)
					local grab=getRemote("RemoteEvent",build.Grab)
					if begin and grab then
						priorityTransport.remotes[build.Begin]=begin
						priorityTransport.remotes[build.Grab]=grab
						priorityTransport.selected={Build=build,Begin=begin,Grab=grab}
						break
					end
				end
				priorityTransport.remotes["Tools/Flash/Effects"]=getRemote("RemoteEvent","Tools/Flash/Effects")
			end)
			priorityTransport.started=false
			priorityTransport.retryAt=os.clock()+5
			if not ok then _G.ElysiumPriorityGrabError=tostring(err)end
		end)
	end
	_G.ElysiumSpoofSteal=function(prompt,plotName,slot)
		if _G.ElysiumSpoofStealEnabled==false then return false end
		local selected=priorityTransport.selected
		if not(selected and selected.Begin.Parent and selected.Grab.Parent)then
			resolvePriorityTransport()
			return false
		end
		local plots=workspace:FindFirstChild("Plots")
		local plot=plots and plots:FindFirstChild(tostring(plotName))
		if not plot or not prompt or not prompt.Parent then return false end
		local character=LP.Character
		local function promptAt()
			local holder=prompt.Parent
			return holder and(holder:IsA("Attachment")and holder.WorldPosition or holder:IsA("BasePart")and holder.Position)or nil
		end
		local function close()
			local root=LP.Character==character and character and character:FindFirstChild("HumanoidRootPart")
			local at=promptAt()
			local reach=tonumber(prompt.MaxActivationDistance)or 0
			reach=math.min(12,reach>0 and reach or 10)
			return root~=nil and at~=nil and(root.Position-at).Magnitude<=reach
		end
		if not close()then return false end
		local build=selected.Build
		local slotArg=tonumber(slot)or slot
		local started=workspace:GetServerTimeNow()-1.6
		local function fire(remote,args,stamp,...)
			for _,arg in ipairs(args)do remote:FireServer(stamp+arg[1],arg[2],...)end
		end
		if not pcall(fire,selected.Begin,build.BeginArgs,started)then return false end
		_G.ElysiumSpoofStealSent=os.clock()
		task.delay(math.clamp(tonumber(_G.ElysiumSpoofGrabDelay)or .55,0,1.5),function()
			if LP:GetAttribute("Stealing")==true or not prompt.Parent or not close()then return end
			pcall(fire,selected.Grab,build.GrabArgs,started+2.1,plot.Name,slotArg)
		end)
		return true
	end
	resolvePriorityTransport()
	local activePriorityGrab
	local priorityRetryAt=0
	local function donorPriorityGrab(prompt,pet)
		if _G.ElysiumStealMode~="priority"or _G.ElysiumSourceStealActive or _holdBusy()
			or activePriorityGrab or os.clock()<priorityRetryAt then return false end
		local plots=workspace:FindFirstChild("Plots")
		local plot=plots and plots:FindFirstChild(tostring(pet.plot))
		if not plot or not prompt or not prompt.Parent then return false end
		do
			local root=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
			local holder=prompt.Parent
			local at=holder:IsA("Attachment")and holder.WorldPosition or holder:IsA("BasePart")and holder.Position or nil
			if root and at then
				local toPrompt=at-root.Position
				local dist=toPrompt.Magnitude
				local reach=10
				if dist>reach then
					local closing=root.AssemblyLinearVelocity:Dot(toPrompt)/dist
					local lead=tonumber(_G.ElysiumPriorityGrabLead)or .7
					if closing<=5 or(dist-reach)/closing>lead then return false end
				end
			end
		end
		local originalCharacter=LP.Character
		local uid=_petUid(pet)
		_stealHoldGeneration+=1
		local generation=_stealHoldGeneration
		_stealHoldActive=true;_stealHoldStart=tick();_stealHoldPetUid=uid
		local session={prompt=prompt,jobs={},timing={started=os.clock()},character=originalCharacter,uid=uid}
		activePriorityGrab=session
		_G.ElysiumPriorityGrabTiming=session.timing
		_G.ElysiumPriorityGrabError=nil
		_G.ElysiumPriorityGrabDetail=nil
		_stealHoldCarry,_stealHoldCarryUid=0,nil
		_stealHoldCarryInherited,_stealHoldCarryPrecharged=false,false
		local connections={}
		local function finish(status,err)
			if session.finished then return end
			session.finished=true
			for _,connection in ipairs(connections)do pcall(function()connection:Disconnect()end)end
			for _,thread in ipairs(session.jobs)do
				if coroutine.status(thread)~="dead"and thread~=coroutine.running()then pcall(task.cancel,thread)end
			end
			if not session.sent then
				local actions=_G.ElysiumActions
				if actions and actions.game==game and type(actions.Cancel)=="function"then pcall(actions.Cancel,prompt)end
				for _,callback in ipairs(session.endCallbacks or{})do
					local thread=task.spawn(function()pcall(callback)end)
					task.delay(.1,function()if coroutine.status(thread)~="dead"then pcall(task.cancel,thread)end end)
				end
			end
			if activePriorityGrab==session then
				activePriorityGrab=nil
				_stealHoldActive=false;_stealHoldPetUid=nil
				priorityRetryAt=os.clock()+(tonumber(_G.ElysiumPriorityRetryGap)or .08)
				pcall(hideStealBar)
				session.timing.finished=os.clock()
				_G.ElysiumPriorityGrabStatus=status
				if err then _G.ElysiumPriorityGrabError=tostring(err)end
				local runtime=_G.ElysiumRuntime
				if runtime and runtime.Log and(status~="cancelled"or err)then
					pcall(runtime.Log,"priority_grab_"..status,err and tostring(err)or _G.ElysiumPriorityGrabDetail)
				end
			end
		end
		session.finish=finish
		pcall(showStealBar,pet.name,0)
		task.delay(3.5,function()
			if session.finished then return end
			finish("attempt_timeout","hold attempt exceeded 3.5 seconds")
			if session.worker and coroutine.status(session.worker)~="dead"then pcall(task.cancel,session.worker)end
		end)
		session.worker=task.spawn(function()
			local function runAttempt()
			local function alive()
				return _G.ElysiumStealMode=="priority"and not _G.ElysiumSourceStealActive and not _G.Elysium_IsResetting
					and not session.finished and activePriorityGrab==session
					and generation==_stealHoldGeneration and LP.Character==originalCharacter
					and(_stealTarget==nil or _petUid(_stealTarget)==uid)
			end
			local aa=setmetatable({},{__index=function()return alive()end})
			local a6=setmetatable({Mode="Priority",Shield=false},{__index=function(_,k)if k=="Enabled"then return alive()end end})
			local aH,aE=LP,workspace
			local aG={PlayerRemoving={Connect=function(_,fn)local c=Players.PlayerRemoving:Connect(fn);connections[#connections+1]=c;return c end}}
			local af={Event=function(name)
				local remote=priorityTransport.remotes[name]
				if name=="Tools/Flash/Effects"and remote then
					return{OnClientEvent={Connect=function(_,fn)local c=remote.OnClientEvent:Connect(fn);connections[#connections+1]=c;return c end}}
				end
				return remote
			end}
			local aI,aJ,aK,aL,aM,aN=.55,3,1.6,2.1,10,math.clamp(tonumber(_G.ElysiumGrabInRangeDelay)or .05,0,.3)
			local aq,at,ar,av,ay=math.max,math.min,string.format,math.huge,task.spawn
			local aA=Vector3.new
			local function az(seconds)
				local deadline=os.clock()+(seconds or 0)
				repeat
					RunService.Heartbeat:Wait()
					setStealBarPct(math.clamp((tick()-_stealHoldStart)/aI,0,1))
				until os.clock()>=deadline or not alive()
			end
			local a2={Effects="Tools/Flash/Effects"}
			local bn,bd={},{}
			local function Note(s)_G.ElysiumPriorityGrabDetail=s end
			local function Character()local c=LP.Character;return c,c and c:FindFirstChild("HumanoidRootPart"),c and c:FindFirstChildOfClass("Humanoid")end
			local function PromptPosition(p)local v=p.Parent;if not v then return nil end;return v:IsA("Attachment")and v.WorldPosition or v:IsA("BasePart")and v.Position or nil end
			local function Inside(p,v)local q=p.CFrame:PointToObjectSpace(v);local s=p.Size*.5;return math.abs(q.X)<=s.X and math.abs(q.Y)<=s.Y and math.abs(q.Z)<=s.Z end
			local function SlotOf(e)return tonumber(e.Slot)or e.Slot end
			local function Carrying()return LP:GetAttribute("Stealing")==true end
			local function IsStealPrompt(p)return p.Name=="Steal"end
			local function RagdollLeft()return math.max(0,(tonumber(LP:GetAttribute("RagdollEndTime"))or 0)-workspace:GetServerTimeNow())end
			local function Ragdolled(h)return h.Health<=0 or ragdollActiveNow()end
			local function GummyLeft()local c=LP.Character;return(LP:GetAttribute("InGummy")or(c and c:GetAttribute("InGummy")))and .1 or 0 end
			local function PickSteal()return nil,nil end
			local function CampPrompt()return nil end
			local function Available()return false end
			local function Protect()end
			local function PromptCalls(p)
				buildStealCallbacks(p);local d=InternalStealCache[p]
				session.endCallbacks=d and d.holdEndCallbacks or{}
				return d and d.holdCallbacks or{},d and d.triggerCallbacks or{}
			end
			local function Run(callbacks)
				if#callbacks==0 then return false end
				local done,accepted=0,0
				local deadline=os.clock()+1
				for _,callback in ipairs(callbacks)do
					local thread=task.spawn(function()
						local ok,result=pcall(callback)
						if not session.finished then
							done+=1
							if ok and result~=false then accepted+=1
							elseif not ok then _G.ElysiumPriorityGrabError=tostring(result)end
						end
					end)
					session.jobs[#session.jobs+1]=thread
				end
				while done<#callbacks and alive()and os.clock()<deadline do az()end
				if not alive()or done<#callbacks then
					_G.ElysiumPriorityGrabDetail="callback_cancelled_or_timeout"
					return false
				end
				if accepted==0 then _G.ElysiumPriorityGrabDetail="callback_refused"end
				return accepted>0
			end
			local function StealRemotes()
				local actions=_G.ElysiumActions
				local shared=actions and actions.game==game and actions.GetPromptCallbacks(prompt)
				if shared and#shared.began>0 and#shared.triggered>0 then return nil,nil,nil end
				local selected=priorityTransport.selected
				if selected and selected.Begin.Parent and selected.Grab.Parent then
					return selected.Build,selected.Begin,selected.Grab
				end
				resolvePriorityTransport()
				return nil,nil,nil
			end
			local function Fire(bq,br,bs,...)
				for bt,bu in br do
					bq:FireServer(bs+bu[1],bu[2],...)
				end
			end
			local function FireSteal(br,bs,bt)
				if not bs.Parent or bn[bs]then
					return false,br
				end
				local bu,bv,c=StealRemotes()
				local e=0
				local f=aH.Character
				local g,h=aI,aJ
				local i=os.clock()
				local j,k=bs,br
				local l,m,n=false,0
				local o=br.Decoy==true
				bn[j]=true
				local function Distance()
					local p,q=Character()
					local r=PromptPosition(j)
					return if q and r then(q.Position-r).Magnitude else av
				end
				local function Hitbox()
					local p=k.Plot and k.Plot.Model:FindFirstChild("StealHitbox")
					if not p or not p:IsA("BasePart")then
						return true
					end
					local q,r=Character()
					return r~=nil and Inside(p,r.Position)
				end
				local function Charging()
					return bd.Plot~=nil and k.Plot==bd.Plot and SlotOf(k)==bd.Slot
				end
				local function Alive()
					if j.Parent==nil and Charging()then
						local p=CampPrompt()
						if p then
							Note("camp prompt was rebuilt, following it")
							bn[j]=nil
							j=p
							bn[j]=true
						end
					end
					return aa.Running and a6.Enabled and aH.Character==f and j.Parent~=nil and not Carrying()
				end
				local function Ready()
					if k.Decoy or Carrying()or not j.Parent or Distance()>aM or not Hitbox()then
						l=false
						return false
					end
					if os.clock()-i<g then
						l=true
					end
					if not(j.Enabled and IsStealPrompt(j))then
						l=true
						return false
					end
					if Charging()then
						l=true
						return true
					end
					if n then
						local p,q,r=Character()
						if os.clock()>m then
							n=nil
						elseif q and r then
							local s=q.Position-aA(0,r.HipHeight+q.Size.Y*.5,0)
							if(q.Position-n).Magnitude<=.5 or(s-n).Magnitude<=.5 then
								l,n=true,nil
							end
						end
					end
					return true
				end
				local p=af.Event(a2.Effects)
				local q=p
					and p.OnClientEvent:Connect(function(q,r,s)
						if q~=aH or not Alive()or typeof(r)~="CFrame"or typeof(s)~="CFrame"then
							return
						end
						if(s.Position-r.Position).Magnitude>.5 then
							n,m=s.Position,os.clock()+.300000000189
							Ready()
						end
					end)
				local r=aG.PlayerRemoving:Connect(function(r)
					if k.Plot and r==k.Plot.Owner and Alive()and Ready()then
						l=true
					end
				end)
				local function Trigger()
					while os.clock()-i<g do
						az(at(g-(os.clock()-i),.03))
						if not Alive()then
							return false
						end
					end
					while Alive()do
						local s=h-(os.clock()-i)
						local t,u,v=Character()
						if s<0 or not v then
							return false
						end
						if not j:IsDescendantOf(aE)then
							return false
						end
						if not j.Enabled or not IsStealPrompt(j)then
							if not Charging()then
								return false
							end
							az(.03)
							continue
						end
						local w=aH:GetAttribute("GiantPotion")~=nil
						local x=GummyLeft()
						local y=aH:GetAttribute("BlockTools")==true or x>0
						if not y and(w or not Ragdolled(v))then
							if Distance()>aM or not Hitbox()then
								return false
							end
							if Charging()then
								Note(ar("grab sent %.2fs into the hold",os.clock()-i))
							end
							local z="grab remote"
							if bu and c then
								Fire(c,bu.GrabArgs,e+aL,k.Plot.Model.Name,SlotOf(k))
							else
								local A,B=PromptCalls(j)
								if not Run(B)then
									return false
								end
								z="game prompt"
							end
							Note(ar("grab %s via %s, %.2fs",tostring(k.Index),z,os.clock()-i))
							return true
						end
						if aq(x,if w then 0 else RagdollLeft())>s then
							return false
						end
						az(at(s,.03))
					end
					return false
				end
				local function Retarget()
					if(l and Ready())or a6.Attempt or Charging()then
						return false
					end
					local s,u=PickSteal()
					if u==j and k.Decoy and s and not s.Decoy then
						k=s
						a6.Name=s.Index
						return true
					end
					if not s or not u or u==j or not u.Parent or bn[u]then
						return false
					end
					local v,w=Character()
					local x=PromptPosition(u)
					if not w or not x then
						return false
					end
					local y=(w.Position-x).Magnitude
					if
						not k.Decoy
						and not(a6.Busy and s==a6.Target)
						and(a6.Picked~=nil or(a6.Mode~="Highest"and y>=Distance()-2))
					then
						return false
					end
					bn[j]=nil
					j,k=u,s
					l,n=false,nil
					bn[j]=true
					a6.Name=s.Index
					return true
				end
				local function Finish(s)
					if q then
						q:Disconnect()
					end
					r:Disconnect()
					bn[j]=nil
					return s,k
				end
				if a6.Shield and not bt and not k.Decoy and Available(k)then
					Protect()
				end
				session.timing.holdStarted=os.clock()
				if bu and bv then
					e=aE:GetServerTimeNow()-aK
					Fire(bv,bu.BeginArgs,e)
				elseif not Run((PromptCalls(j)))then
					a6.Status="steal remotes not found"
					return Finish(false)
				end
				if not k.Decoy and Distance()<=aM and Hitbox()and(not Charging()or Ready())then
					local s=g-(os.clock()-i)
					if s>0 then
						az(s)
					end
					if Alive()and Hitbox()then
						return Finish(Trigger())
					end
				end
				local s,u=false
				while Alive()do
					if Retarget()then
						u=nil
					end
					if os.clock()-i>=h then
						if Ready()then
							s=Trigger()
						end
						break
					end
					if Ready()then
						u=u or os.clock()
						if l or o or a6.Camped or os.clock()-u>=aN then
							s=Trigger()
							break
						end
					else
						u=nil
					end
					az()
				end
				return Finish(s)
			end
			local channel=getPlotChannel(pet.plot)
			local entity={Index=pet.name,Slot=pet.slot,Plot={Model=plot,Owner=channelGet(channel,"Owner")}}
			return FireSteal(entity,prompt,false)
			end
			local ok,result=pcall(runAttempt)
			session.sent=ok and result==true
			if session.sent and not session.finished then
				pcall(setStealBarPhase,"grabbing",1,0)
				local pingOK,ping=pcall(function()return LP:GetNetworkPing()end)
				local deadline=os.clock()+math.clamp((pingOK and tonumber(ping)or .1)*4+.35,.35,1.2)
				while not session.finished and LP.Character==originalCharacter and LP:GetAttribute("Stealing")~=true
					and generation==_stealHoldGeneration and _G.ElysiumStealMode=="priority"and os.clock()<deadline do
					RunService.Heartbeat:Wait()
				end
			end
			local carrying=LP:GetAttribute("Stealing")==true
			finish(not ok and"error"or carrying and"carrying"or session.sent and"server_unconfirmed"or"cancelled",not ok and result or nil)
			if session.sent then
				_G.ElysiumLastFire=os.clock()
				pcall(_verifyFire,pet,"donor_priority",true)
			end
		end)
		return true
	end
	local function _fireSteal(pet)
		if _G.ElysiumSourceStealActive then
			return false
		end
		if not pet then
			return false
		end
		if _holdBusy()then
			return false
		end
		local _fhrp=LP.Character and LP.Character:FindFirstChild("HumanoidRootPart")
		local _fd=(_fhrp and pet.position)and(pet.position-_fhrp.Position).Magnitude or nil
		local _judge=(_fd~=nil)and(_fd<=_prox()+2)or false
		local _cd=_holdDur()+(tonumber(_G.ElysiumStealCycleGap)or 0)
		_G.ElysiumLastGrabPet,_G.ElysiumLastGrabAt=pet,os.clock()
		local prompt=findStealPrompt(pet)
		if _G.ElysiumStealMode=="priority"then return donorPriorityGrab(prompt,pet)end
		if not prompt or not prompt.Parent then
			_primeUnavailableTarget(pet)
			return false
		end
		local oldMax
		pcall(function()
			oldMax=prompt.MaxActivationDistance
		end)
		pcall(function()
			prompt.MaxActivationDistance=math.huge
		end)
		buildStealCallbacks(prompt)
		if InternalStealCache[prompt]then
			if executeStealAsync(prompt,pet.name,oldMax,pet)then
				_prechargeUid,_prechargeAt,_prechargeTouchedAt,_prechargeHeldSeenAt=nil,0,0,0
				_G.ElysiumLastFire=os.clock()
				_verifyFire(pet,"prompt",_judge)
				return true
			end
			if oldMax~=nil then
				pcall(function()
					prompt.MaxActivationDistance=oldMax
				end)
			end
			return false
		elseif fireproximityprompt then
			_clearPrecharge(false)
			_stealHoldCarryPrecharged=false
			pcall(function()
				prompt.MaxActivationDistance=math.huge
			end)
			showStealBar(pet.name,1)
			pcall(function()
				fireproximityprompt(prompt)
			end)
			_G.ElysiumLastFire=os.clock()
			_verifyFire(pet,"prompt",_judge)
			task.delay(.4,hideStealBar)
			pcall(function()
				if oldMax~=nil then
					prompt.MaxActivationDistance=oldMax
				end
			end)
			return true
		end
		return false
	end
	_G.ElysiumFireSteal=_fireSteal
	do
		if _G.ElysiumSlotPrechargeController then
			_G.ElysiumSlotPrechargeController.Destroy()
		end
		_G.ElysiumSlotPrechargeActive=false
		local context,serial=nil,0
		local function release(complete)
			local old=context
			context=nil
			serial+=1
			local token=serial
			_G.ElysiumSlotPrechargeActive=false
			if old then
				for _,thread in ipairs(old.jobs or{})do
					pcall(task.cancel,thread)
				end
				local function finish()
					if
						complete
						and serial==token
						and LP.Character==old.character
						and not _G.Elysium_IsResetting
						and LP:GetAttribute("Stealing")~=true
					then
						for _,fn in ipairs(old.callbacks.triggerCallbacks)do
							pcall(fn)
						end
					end
					for _,fn in ipairs(old.callbacks.holdEndCallbacks)do
						pcall(fn)
					end
				end
				if complete then
					task.spawn(finish)
				else
					finish()
				end
			end
		end
		local function selectIncoming(root)
			local best,distance
			for _,entry in pairs(_G.ElysiumIncomingSlots or{})do
				local anchor=entry.anchor
				if not anchor or not anchor.Parent then
					continue
				end
				local pos=anchor:IsA("Attachment")and anchor.WorldPosition or anchor.Position
				local gap=(root.Position-pos).Magnitude
				local uid=tostring(entry.plot).."_"..tostring(entry.slot)
				local pinned=_G.ElysiumStealTargetUID
				if gap<=12 and(not pinned or pinned==""or pinned==uid)and(not distance or gap<distance)then
					best=entry
					distance=gap
				end
			end
			return best
		end
		local connection=RunService.Heartbeat:Connect(function()
			local ok,err=pcall(function()
				local char=LP.Character
				local root=char and char:FindFirstChild("HumanoidRootPart")
				local hum=char and char:FindFirstChildOfClass("Humanoid")
				if
					(_G.ElysiumStealMode=="priority"or(_G.ElysiumStealMode==nil and not _G.ElysiumSourceStealActive))
					or _G.Elysium_IsResetting
					or _G.ElysiumAutoBuyTPBlocked
					or not root
					or not hum
					or hum.Health<=0
					or LP:GetAttribute("Stealing")==true
					or ragdollActiveNow()
					or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())
				then
					release()
					return
				end
				local incoming=selectIncoming(root)
				if not incoming then
					release()
					return
				end
				local uid=tostring(incoming.plot).."_"..tostring(incoming.slot)
				local channel=getPlotChannel(incoming.plot)
				if isMyPlot(channel)or not _ownerInGame(channelGet(channel,"Owner"))then
					release()
					return
				end
				local animals=channelGet(channel,"AnimalList")
				if type(animals)~="table"then
					release()
					return
				end
				local animal=animals[tostring(incoming.slot)]or animals[tonumber(incoming.slot)]
				local occupied=type(animal)=="table"and animal.Index~=nil
				if context and context.uid~=uid then
					release()
				end
				if not context then
					if occupied or _holdBusy()then
						return
					end
					local prompt=findStealPrompt(incoming,true)
					if not prompt or not prompt.Parent or not prompt.Enabled then
						return
					end
					buildStealCallbacks(prompt)
					local callbacks=InternalStealCache[prompt]
					if not callbacks or#callbacks.holdCallbacks==0 then
						return
					end
					if _G.ElysiumSourceStealRuntime and _G.ElysiumSourceStealRuntime.PauseHold then
						_G.ElysiumSourceStealRuntime.PauseHold()
					end
					serial+=1
					context=
						{uid=uid,prompt=prompt,callbacks=callbacks,at=tick(),character=char,jobs={}}
					local current=context
					_G.ElysiumSlotPrechargeActive=true
					_armRoseSteal(prompt)
					for _,fn in ipairs(callbacks.holdCallbacks)do
						local thread=task.spawn(function()
							if context==current then
								pcall(fn)
							end
						end)
						if thread then
							current.jobs[#current.jobs+1]=thread
						end
					end
				end
				if context.character~=char or not context.prompt.Parent or not context.prompt.Enabled then
					release()
					return
				end
				local elapsed=tick()-context.at
				local duration=math.max(tonumber(context.prompt.HoldDuration)or 0,_holdDur())
				local maxAge=math.max(duration+.25,tonumber(_G.ElysiumStealSrvHoldMax)or 2.5)
				if elapsed>=maxAge-.1 then
					release()
					return
				end
				local fraction=math.clamp(elapsed/math.max(duration,.01),0,1)*.95
				showStealBar(incoming.name or"Incoming",fraction)
				stealBarGen.Text=""
				if elapsed>=duration then
					stealBarStatus.Text="ГОТОВО · ОЖИДАНИЕ"
					stealBarSeconds.Text=""
				else
					stealBarStatus.Text="ПОДГОТОВКА  "..math.floor(fraction*100).."%"
				end
				if occupied and elapsed>=duration then
					if incoming.index and animal.Index~=incoming.index then
						release()
						return
					end
					release(true)
				end
			end)
			if not ok then
				release()
				_G.ElysiumSlotPrechargeError=tostring(err)
			end
		end)
		_G.ElysiumSlotPrechargeController={
			Destroy=function()
				connection:Disconnect()
				release()
			end,
		}
	end
	local function _stealTick()
		if _G.ElysiumSlotPrechargeActive then
			return
		end
		if _G.ElysiumSourceStealActive then
			return
		end
		if _G.ElysiumLaserGrabSession then
			return
		end
		_G.ElysiumTickN=(_G.ElysiumTickN or 0)+1
		stealOn=(_G.ElysiumStealMode~=nil)
		if not stealOn then
			return
		end
		local now=os.clock()
		if _prechargeUid and not _holdBusy()and(tick()-_prechargeTouchedAt)>.75 then
			_clearPrecharge(true)
		end
		local _lockUid=_G.ElysiumStealTargetUID
		local _lockChanged=(type(_lockUid)=="string"and _lockUid~=""and _lockUid~=_lastPickUid)
		local _needPick=(not _stealTarget)or _lockChanged
		if _armedPet then
			local _lp=_armLivePos(_armedPet)
			if _lp then
				_armedPet.position=_lp
				_armLostSince=0
			elseif _armLostSince==0 then
				_armLostSince=now
			end
			if _armedPet and(now-_armCheckAt)>=(tonumber(_G.ElysiumArmCheckGap)or .3)then
				_armCheckAt=now
				local okL,listed=pcall(_petListed,_armedPet.plot,_armedPet.slot)
				if okL and not listed then
					_armLostSince=_armLostSince==0 and now or _armLostSince
				end
			end
			if _armedPet then
				_stealTarget=_armedPet
				if type(_armedPet.name)=="string"then
					_currentTargetName=_armedPet.name
				end
				_needPick=false
			end
		end
		local _scanGap=(_emptyScans>=3)and(tonumber(_G.ElysiumStealIdleGap)or .2)or .01
		if not LP:GetAttribute("Stealing")and _needPick and(now-_autoLastScan)>=_scanGap then
			_autoLastScan=now
			_lastTargetPick=now
			local char=LP.Character
			local hrp=char and char:FindFirstChild("HumanoidRootPart")
			if hrp then
				local pets=_scanCached(now,.05)
				local ok=pets~=nil
				if ok and pets and#pets>0 then
					_emptyScans=0
				else
					_emptyScans=_emptyScans+1
				end
				if ok and pets and#pets>0 then
					local best
					local hasUidLock=type(_lockUid)=="string"and _lockUid~=""
					if hasUidLock then
						for _,p in ipairs(pets)do
							if not p.conveyor and _petUid(p)==_lockUid then
								best=p
								break
							end
						end
					end
					if not best and not hasUidLock and _G.ElysiumStealMode=="nearest"then
						local myPos=hrp.Position
						local bestD=math.huge
						for _,p in ipairs(pets)do
							if not p.conveyor and p.position then
								local d=(p.position-myPos).Magnitude
								if d<bestD then
									bestD=d
									best=p
								end
							end
						end
					elseif not best and not hasUidLock then
						for _,p in ipairs(pets)do
							if not p.conveyor then
								best=p
								break
							end
						end
					end
					if not hasUidLock then
						best=best or pets[1]
					end
					if best then
						_stealTarget=best
						_stealArmedAt=now
						_lastPickUid=_lockUid
						if type(best.name)=="string"and best.name~=""then
							_currentTargetName=best.name
						end
					end
				end
			end
		end
		if
			not _stealTarget
			and _G.ElysiumStealMode=="nearest"
			and not(type(_lockUid)=="string"and _lockUid~="")
		then
			local _c2=LP.Character
			local _h2=_c2 and _c2:FindFirstChild("HumanoidRootPart")
			if _h2 and(now-_inRangeLast)>=(tonumber(_G.ElysiumInRangeGap)or .15)then
				_inRangeLast=now
				local _pets2=_scanCached(now,.15)
				if _pets2~=nil and type(_pets2)=="table"then
					local _near,_nd=nil,math.huge
					local _mp=_h2.Position
					for _,p in ipairs(_pets2)do
						if not p.conveyor and p.position then
							local d=(p.position-_mp).Magnitude
							if d<_nd then
								_nd,_near=d,p
							end
						end
					end
					if _near then
						local _nu=_petUid(_near)
						if _nu~=_G.ElysiumLastNearUid then
							_G.ElysiumLastNearUid=_nu
						end
						_stealTarget=_near
						_armedPet,_armLostSince=nil,0
						_lastTargetPick=now
						if type(_near.name)=="string"then
							_currentTargetName=_near.name
						end
					end
				end
			end
		end
		local pet=_stealTarget
		if not pet then
			return
		end
		if now-_stealLastScan<.02 then
			_G.ElysiumThrN=(_G.ElysiumThrN or 0)+1
			return
		end
		_stealLastScan=now
		local t=timeUntilCanSteal()
		if t==-1 then
			if LP:GetAttribute("Stealing")then
				_stealTarget=nil
				_armedPet,_armLostSince=nil,0
			end
			return
		end
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return
		end
		if pet.position then
			local toPet=pet.position-hrp.Position
			local dist=toPet.Magnitude
			if(now-(_G.__elysiumTgtAt or 0))>=.15 then
				_G.__elysiumTgtAt=now
				_G.ElysiumStealTgt=tostring(pet.name)
					.." ["
					..tostring(pet.plot)
					.."/"
					..tostring(pet.slot)
					.."] d="
					..math.floor(dist)
			end
			local hold=_holdDur()
			local lead=tonumber(_G.ElysiumStealLead)or .6
			local closing=dist>.001 and(hrp.AssemblyLinearVelocity:Dot(toPet)/dist)or 0
			local _nearBase=false
			do
				local _bi=getClosestBaseIdx(pet.position)
				local _b=_bi and BASES_LOW[_bi]
				if _b then
					local _bx,_bz=hrp.Position.X-_b.X,hrp.Position.Z-_b.Z
					if math.sqrt(_bx*_bx+_bz*_bz)<=(tonumber(_G.ElysiumCloseBaseRange)or 100)then
						_nearBase=true
					end
				end
			end
			local _armed=_G.ElysiumStealQuick~=true
			local _mul=_armed and 1.5 or 1
			if _nearBase then
				if dist>(tonumber(_G.ElysiumNearBaseStealStart)or 80)*_mul then
					return
				end
			elseif closing>(tonumber(_G.ElysiumFastApproach)or 150)then
				if dist>(tonumber(_G.ElysiumStealLeadMax)or 420)*_mul then
					return
				end
				if(dist/closing)>hold*lead+(tonumber(_G.ElysiumStealEarly)or .35)*_mul then
					return
				end
			elseif closing>5 then
				if dist>(tonumber(_G.ElysiumCloseProximity)or 40)*_mul then
					return
				end
			else
				if dist>_prox()*_mul then
					return
				end
			end
		end
		_fireSteal(pet)
	end
	RunService.Heartbeat:Connect(function()
		local session=activePriorityGrab
		if not session or session.finished then return end
		local carrying=LP:GetAttribute("Stealing")==true
		local targetChanged=_stealTarget and _petUid(_stealTarget)~=session.uid
		local invalid=_G.ElysiumStealMode~="priority"or _G.ElysiumSourceStealActive or _G.Elysium_IsResetting
			or LP.Character~=session.character or targetChanged or session.prompt.Parent==nil
		if carrying or invalid then
			session.finish(carrying and"carrying"or"cancelled")
			if session.worker and coroutine.status(session.worker)~="dead"then pcall(task.cancel,session.worker)end
		end
	end)
	local _stealThrottle=0
	RunService.Heartbeat:Connect(function()
		_stealThrottle=_stealThrottle+1
		if _stealThrottle<(tonumber(_G.ElysiumStealTickEvery)or 1)then
			return
		end
		_stealThrottle=0
		pcall(_stealTick)
	end)
	task.spawn(function()
		while true do
			task.wait(tonumber(_G.ElysiumWatchdogTick)or .15)
			if
				not _G.ElysiumSourceStealActive
				and not _G.ElysiumLaserGrabSession
				and _G.ElysiumStealMode~=nil
				and _G.ElysiumStealWatchdog~=false
				and not LP:GetAttribute("Stealing")
				and not _holdBusy()
				and(os.clock()-(_G.ElysiumLastFire or 0))>(tonumber(_G.ElysiumWatchdogGap)or 1)
			then
				local c=LP.Character
				local h=c and c:FindFirstChild("HumanoidRootPart")
				if h then
					local pets=_scanCached(os.clock(),.15)
					local ok=pets~=nil
					if ok and type(pets)=="table"then
						local near,nd=nil,math.huge
						local mp=h.Position
						local want=_armedPet or _stealTarget
						local wuid=want and _petUid(want)
						if wuid then
							for _,p in ipairs(pets)do
								if not p.conveyor and p.position and _petUid(p)==wuid then
									near,nd=p,(p.position-mp).Magnitude
									break
								end
							end
						end
						if near and nd<=_prox()then
							pcall(_fireSteal,near)
						end
					end
				end
			end
		end
	end)
	do
		local animationConnection
		local animatorChildConnection
		local currentCharacter
		local function unwalkApply(char)
			if not char or _G.ElysiumUnwalk==false then return end
			local animate=char:FindFirstChild("Animate")
			if animate and not animate.Disabled then animate.Disabled=true end
			local humanoid=char:FindFirstChildOfClass("Humanoid")
			local animator=humanoid and humanoid:FindFirstChildOfClass("Animator")
			if animator then
				for _,track in ipairs(animator:GetPlayingAnimationTracks())do
					pcall(function()track:Stop(0)end)
				end
			end
		end
		local function attachAnimator(animator)
			if animationConnection then animationConnection:Disconnect();animationConnection=nil end
			if animator then
				animationConnection=animator.AnimationPlayed:Connect(function(track)
					if _G.ElysiumUnwalk~=false then
						pcall(function()track:Stop(0)end)
					end
				end)
			end
		end
		local function attachCharacter(char)
			currentCharacter=char
			if animatorChildConnection then animatorChildConnection:Disconnect();animatorChildConnection=nil end
			attachAnimator(nil)
			if not char then return end
			local humanoid=char:FindFirstChildOfClass("Humanoid")or char:WaitForChild("Humanoid",10)
			if not humanoid or LP.Character~=char then return end
			attachAnimator(humanoid:FindFirstChildOfClass("Animator"))
			animatorChildConnection=humanoid.ChildAdded:Connect(function(child)
				if child:IsA("Animator")then
					attachAnimator(child)
					unwalkApply(char)
				end
			end)
			unwalkApply(char)
		end
		if LP.Character then task.spawn(attachCharacter,LP.Character)end
		LP.CharacterAdded:Connect(function(char)task.spawn(attachCharacter,char)end)
		local lastCheck=0
		RunService.Heartbeat:Connect(function()
			local char=LP.Character
			if char~=currentCharacter then return end
			local now=os.clock()
			if now-lastCheck<.25 then return end
			lastCheck=now
			if _G.ElysiumUnwalk~=false then
				unwalkApply(char)
			else
				local animate=char and char:FindFirstChild("Animate")
				if animate and animate.Disabled then animate.Disabled=false end
			end
		end)
	end
	local HS=ElysiumService("HttpService")
	local UIS=ElysiumService("UserInputService")
	local CFG_FILE="SideTP.json"
	local function loadCfgTable()
		local t={}
		if readfile then
			pcall(function()
				local raw=readfile(CFG_FILE)
				if type(raw)=="string"and#raw>0 then
					local ok,d=pcall(HS.JSONDecode,HS,raw)
					if ok and type(d)=="table"then
						t=d
					end
				end
			end)
		end
		return t
	end
	local function saveTpSettings()
		if not writefile then
			return
		end
		local t=loadCfgTable()
		t.optimizerMode=_G.ElysiumOptimizerMode=="default"and"default"or"aa"
		t.dragHead=nil
		t.wiggle=nil
		t.tpVelocity=tonumber(_G.TPVelocity)or 200
		t.tpMotionDriver="carpet-speed-v1"
		t.climbSpeed=tonumber(_G.ElysiumClimb)or 160
		t.goSpeed=tonumber(_G.ElysiumGoSpeed)or 200
		t.cframeSpeed=tonumber(_G.ElysiumCFrameSpeed)or 450
		t.cframeTP=_G.ElysiumCFrameTP==true
		t.tweenTP=_G.ElysiumTweenTP==true
		t.flingTp=_G.ElysiumFlingTP==true
		t.tweenNear=tonumber(_G.ElysiumTweenNear)or 40
		t.tweenStage=tonumber(_G.ElysiumTweenStage)or 14
		t.unwalk=_G.ElysiumUnwalk~=false
		t.goMethod=_G.ElysiumGoMethod or"CFrame"
		t.flashEntry=_G.ElysiumFlashEntry or"Multi"
		t.brainrotSpeed=tonumber(_G.ElysiumGoSpeed)or 400
		t.brainrotDelay=0
		t.goEquipTimeout=.2
		t.flashTP=_G.ElysiumFlashTP==true
		t.goStyle=_G.ElysiumGoStyle or"source"
		t.goApproachF2=_G.ElysiumGoApproachF2==true
		t.goPlatformLife=tonumber(_G.trxPlatLife)or 2
		local origin=_G.ElysiumFlashOrigin
		t.flashOrigin=typeof(origin)=="Vector3"and{origin.X,origin.Y,origin.Z}or nil
		t.flashFire=tonumber(_G.ElysiumFlashGroundWait)or .12
		t.flashEquip=tonumber(_G.ElysiumFlashPreEquip)or 50
		t.cframeStart=tonumber(_G.ElysiumCFrameStart)or 30
		t.cframeEnd=tonumber(_G.ElysiumCFrameEnd)or 30
		t.landingDelay=tonumber(_G.LandingDelay)or .35
		t.closeSpeed=tonumber(_G.ElysiumCloseSpeed)or 80
		t.preCloneSpeed=tonumber(_G.ElysiumPreCloneSpeed)or 120
		t.problemBaseSpeed=tonumber(_G.ElysiumProblemBaseSpeed)or 60
		t.slowCrossRow=_G.ElysiumSlowCrossRow==true
		t.autoTp=_G.ElysiumAutoTP~=false
		t.autoKickOnSteal=_G.ElysiumAutoKickOnSteal==true
		t.kickToPS=_G.ElysiumKickToPS==true
		t.psLink=tostring(_G.ElysiumPrivateServerLink or"")
		t.priAlert=_G.ElysiumPriAlert==true
		t.alertSound=tostring(_G.ElysiumAlertSound or"111786441593851")
		t.alertMinGen=tonumber(_G.ElysiumAlertMinGen)or 80e6
		t.xray=_G.ElysiumXray~=false
		t.invisAuto=_G.ElysiumInvisAuto==true
		t.invisDepth=math.clamp(tonumber(_G.SinkSliderValue)or tonumber(_G.ElysiumInvisDepth)or 2.5,.5,10)
		t.invisAngle=tonumber(_G.InvisStealAngle)or tonumber(_G.ElysiumInvisAngle)or 233
		t.autoSteal=stealOn
		t.stealMode=_G.ElysiumStealMode
		t.stealLead=tonumber(_G.ElysiumStealLead)or .6
		t.autoGrabRadius=tonumber(_G.ElysiumAutoGrabRadius)or 95
		t.stealFireKey=type(_G.ElysiumStealFireKey)=="string"and _G.ElysiumStealFireKey or nil
		t.priorityList=_G.SHARED_PRIORITY_ITEMS
		t.mutationList=_G.SHARED_MUTATION_PRIORITY
		do
			local d={}
			for name,on in pairs(_G.SHARED_MUTATION_DISABLED)do
				if on then
					d[#d+1]=name
				end
			end
			t.mutationDisabled=d
		end
		t.traitList=_G.SHARED_TRAIT_PRIORITY
		t.panelX=tonumber(_G._stp_panelX)
		t.panelY=tonumber(_G._stp_panelY)
		t.panelPos=_G._stp_pos
		if type(_G.ElysiumCloneKeyName)=="string"then
			t.cloneKey=_G.ElysiumCloneKeyName
		else
			t.cloneKey=nil
		end
		if type(_G.ElysiumKickKeyName)=="string"then
			t.kickKey=_G.ElysiumKickKeyName
		else
			t.kickKey=nil
		end
		if type(_G.ElysiumStopTPKeyName)=="string"then
			t.stopTpKey=_G.ElysiumStopTPKeyName
		else
			t.stopTpKey=nil
		end
		if type(_G.ElysiumNearestKey)=="string"then
			t.nearestKey=_G.ElysiumNearestKey
		else
			t.nearestKey=nil
		end
		if type(_G.ElysiumDropKeyName)=="string"then
			t.dropKey=_G.ElysiumDropKeyName
		else
			t.dropKey=nil
		end
		if type(_G.ElysiumResetKeyName)=="string"then
			t.resetKey=_G.ElysiumResetKeyName
		else
			t.resetKey=nil
		end
		if type(_G.ElysiumCarpetSpeedKeyName)=="string"then
			t.carpetSpeedKey=_G.ElysiumCarpetSpeedKeyName
		else
			t.carpetSpeedKey=nil
		end
		if type(_G.ElysiumStealQuickKey)=="string"then
			t.stealQuickKey=_G.ElysiumStealQuickKey
		else
			t.stealQuickKey=nil
		end
		t.antiFlash=_G.ElysiumAntiFlash~=false
		t.faceAway=_G.ElysiumFaceAway==true
		t.faceAwayNearest=_G.ElysiumFaceAwayNearest==true
		t.faceAwayDelay=tonumber(_G.ElysiumFaceAwayDelay)or 2
		t.antiBee=_G.ElysiumAntiBee~=false
		t.infJump=_G.ElysiumInfJump~=false
		t.antiDie=_G.AntiDieDisabled~=true
		t.carpetSpeedValue=tonumber(_G.ElysiumCarpetSpeedValue)or 120
		if type(_G.ElysiumCarpetTool)=="string"then
			t.carpetTool=_G.ElysiumCarpetTool
		else
			t.carpetTool=nil
		end
		t.autoBuy=_G.ElysiumAutoBuy==true
		t.autoBuyRange=tonumber(_G.ElysiumAutoBuyRange)or 17
		t.autoBuyHover=tonumber(_G.ElysiumAutoBuyHover)or 9
		t.exX=tonumber(_G._elysium_exX)
		t.exY=tonumber(_G._elysium_exY)
		t.fX=tonumber(_G._elysium_fX)
		t.fY=tonumber(_G._elysium_fY)
		t.kX=tonumber(_G._elysium_kX)
		t.kY=tonumber(_G._elysium_kY)
		t.tgtX=tonumber(_G._elysium_tgtX)
		t.tgtY=tonumber(_G._elysium_tgtY)
		t.modeX=tonumber(_G._elysium_modeX)
		t.modeY=tonumber(_G._elysium_modeY)
		t.tgtW=tonumber(_G._elysium_tgtW)
		t.tgtH=tonumber(_G._elysium_tgtH)
		t.modeW=tonumber(_G._elysium_modeW)
		t.modeH=tonumber(_G._elysium_modeH)
		pcall(function()
			writefile(CFG_FILE,HS:JSONEncode(t))
		end)
	end
	_G.ElysiumSaveSettings=saveTpSettings
	if _G.TPVelocity==nil then
		_G.TPVelocity=200
	end
	if _G.ElysiumClimb==nil then
		_G.ElysiumClimb=160
	end
	if _G.ElysiumGoSpeed==nil then
		_G.ElysiumGoSpeed=400
	end
	if _G.ElysiumCFrameSpeed==nil then
		_G.ElysiumCFrameSpeed=450
	end
	if _G.LandingDelay==nil then
		_G.LandingDelay=.35
	end
	if _G.ElysiumCloseSpeed==nil then
		_G.ElysiumCloseSpeed=80
	end
	if _G.ElysiumPreCloneSpeed==nil then
		_G.ElysiumPreCloneSpeed=120
	end
	if _G.ElysiumCFrameTP==nil then
		_G.ElysiumCFrameTP=false
	end
	if _G.ElysiumCFrameStart==nil then
		_G.ElysiumCFrameStart=30
	end
	if _G.ElysiumCFrameEnd==nil then
		_G.ElysiumCFrameEnd=30
	end
	if _G.ElysiumProblemBaseSpeed==nil then
		_G.ElysiumProblemBaseSpeed=60
	end
	if _G.ElysiumSlowCrossRow==nil then
		_G.ElysiumSlowCrossRow=false
	end
	if _G.ElysiumInvisDepth==nil then
		_G.ElysiumInvisDepth=tonumber(_G.SinkSliderValue)or 2.5
	end
	if _G.ElysiumInvisAngle==nil then
		_G.ElysiumInvisAngle=tonumber(_G.InvisStealAngle)or 233
	end
	if _G.ElysiumAutoGrabRadius==nil then
		_G.ElysiumAutoGrabRadius=95
	end
	do
		local _gp=(gethui and gethui())or ElysiumService("CoreGui")
		for _,par in ipairs({_gp,PG})do
			pcall(function()
				local old=par and par:FindFirstChild("ElysiumTP")
				if old then
					old:Destroy()
				end
				local legacyPanel=par and par:FindFirstChild("MeerkoTP")
				if legacyPanel then
					legacyPanel:Destroy()
				end
				local oldBar=par and par:FindFirstChild("ElysiumTopBar")
				if oldBar then
					oldBar:Destroy()
				end
				local legacyBar=par and par:FindFirstChild("MeerkoTopBar")
				if legacyBar then
					legacyBar:Destroy()
				end
			end)
		end
	end
	if false then
		local TS=ElysiumService("TweenService")
		local EASE=TweenInfo.new(.16,Enum.EasingStyle.Quad,Enum.EasingDirection.Out)
		local function tween(o,props)
			TS:Create(o,EASE,props):Play()
		end
		local guiParent=(gethui and gethui())or ElysiumService("CoreGui")
		for _,par in ipairs({guiParent,PG})do
			pcall(function()
				local old=par:FindFirstChild("ElysiumTP")
				if old then
					old:Destroy()
				end
				local oldBar=par:FindFirstChild("ElysiumTopBar")
				if oldBar then
					oldBar:Destroy()
				end
			end)
		end
		local sg=mk("ScreenGui",nil,{
			Name="ElysiumTP",
			ResetOnSpawn=false,
			IgnoreGuiInset=true,
			DisplayOrder=999999,
			ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
		})
		pcall(function()
			sg.Parent=guiParent
		end)
		if not sg.Parent then
			pcall(function()
				sg.Parent=(gethui and gethui())or ElysiumService("CoreGui")
			end)
		end
		sg.Enabled=false
		do
			pcall(function()
				local oldBar=guiParent:FindFirstChild("ElysiumTopBar")
				if oldBar then
					oldBar:Destroy()
				end
			end)
			pcall(function()
				local oldBar2=PG:FindFirstChild("ElysiumTopBar")
				if oldBar2 then
					oldBar2:Destroy()
				end
			end)
		end
		local W,H,RAIL,PAD=460,320,130,16
		local root=mk("Frame",sg,{
			Name="Root",
			Active=true,
			BackgroundTransparency=1,
			Size=UDim2.fromOffset(W,H),
			Position=UDim2.fromOffset(tonumber(_G._stp_panelX)or 40,tonumber(_G._stp_panelY)or 160),
		})
		local card=corner(
			mk("Frame",root,{
				BackgroundColor3=UIC.bg,
				BorderSizePixel=0,
				Size=UDim2.fromScale(1,1),
				ZIndex=1,
			}),
			10
		)
		mk("UIGradient",card,{
			Rotation=135,
			Color=ColorSequence.new({ColorSequenceKeypoint.new(0,UIC.bg2),ColorSequenceKeypoint.new(1,UIC.bg)}),
		})
		mk("UIStroke",card,{Thickness=1,Transparency=.4,Color=UIC.line})
		local rail=mk("Frame",card,{
			Size=UDim2.new(0,RAIL,1,0),
			BackgroundTransparency=1,
			ZIndex=2,
		})
		mk("TextLabel",rail,{
			Size=UDim2.new(1,-PAD*2,0,20),
			Position=UDim2.fromOffset(PAD,28),
			BackgroundTransparency=1,
			Text="Sticky loves u",
			Font=UIFB,
			TextSize=15,
			TextColor3=UIC.txt,
			TextXAlignment=Enum.TextXAlignment.Left,
			ZIndex=2,
		})
		local body=mk("Frame",card,{
			Position=UDim2.fromOffset(RAIL,0),
			Size=UDim2.new(1,-RAIL,1,0),
			BackgroundTransparency=1,
			ZIndex=2,
		})
		local pages,tabs={},{}
		local tabOpenHook={}
		local function selectTab(name)
			local _h=tabOpenHook[name]
			if _h then
				tabOpenHook[name]=nil
				pcall(_h)
			end
			for n,p in pairs(pages)do
				p.Visible=(n==name)
			end
			for n,t in pairs(tabs)do
				local on=(n==name)
				tween(t.bg,{BackgroundTransparency=on and 0 or 1})
				tween(t.lbl,{TextColor3=on and UIC.txt or UIC.dim})
				tween(t.btn,{BackgroundTransparency=on and .2 or .5})
			end
		end
		local function tab(name,order)
			local b=corner(
				mk("TextButton",rail,{
					Size=UDim2.new(1,-PAD*2,0,32),
					Position=UDim2.fromOffset(PAD,72+(order-1)*38),
					BackgroundColor3=UIC.card,
					BackgroundTransparency=.5,
					Text="",
					AutoButtonColor=false,
					Active=true,
					ZIndex=2,
				}),
				6
			)
			local bg=mk("Frame",b,{
				Size=UDim2.fromScale(1,1),
				BackgroundColor3=UIC.acc,
				BackgroundTransparency=1,
				BorderSizePixel=0,
			})
			corner(bg,6)
			local lbl=mk("TextLabel",b,{
				Size=UDim2.new(1,0,1,0),
				Position=UDim2.fromOffset(0,0),
				BackgroundTransparency=1,
				Text=name,
				Font=UIFB,
				TextSize=11,
				TextColor3=UIC.dim,
				TextXAlignment=Enum.TextXAlignment.Left,
				ZIndex=3,
			})
			mk("UIPadding",lbl,{PaddingLeft=UDim.new(0,12)})
			local page=mk("ScrollingFrame",body,{
				Size=UDim2.fromScale(1,1),
				BackgroundTransparency=1,
				BorderSizePixel=0,
				Visible=false,
				ScrollBarThickness=0,
				ScrollBarImageColor3=UIC.line,
				CanvasSize=UDim2.new(),
				AutomaticCanvasSize=Enum.AutomaticSize.Y,
				ZIndex=2,
			})
			mk("UIPadding",page,{
				PaddingLeft=UDim.new(0,PAD),
				PaddingRight=UDim.new(0,PAD+4),
				PaddingTop=UDim.new(0,PAD+4),
				PaddingBottom=UDim.new(0,PAD),
			})
			mk("UIListLayout",page,{Padding=UDim.new(0,8),SortOrder=Enum.SortOrder.LayoutOrder})
			tabs[name],pages[name]={btn=b,bg=bg,lbl=lbl},page
			b.MouseButton1Click:Connect(function()
				selectTab(name)
			end)
			b.MouseEnter:Connect(function()
				if not pages[name].Visible then
					tween(b,{BackgroundTransparency=.3})
				end
			end)
			b.MouseLeave:Connect(function()
				if not pages[name].Visible then
					tween(b,{BackgroundTransparency=.5})
				end
			end)
			return page
		end
		local function label(parent,txt,first)
			local l=mk("TextLabel",parent,{
				Size=UDim2.new(1,0,0,first and 14 or 26),
				BackgroundTransparency=1,
				Text=string.upper(txt),
				Font=UIFB,
				TextSize=10,
				TextColor3=UIC.dim,
				TextXAlignment=Enum.TextXAlignment.Left,
				TextYAlignment=Enum.TextYAlignment.Bottom,
				ZIndex=2,
			})
			return l
		end
		local function shell(parent,h)
			local card=corner(
				mk("Frame",parent,{
					Size=UDim2.new(1,0,0,h),
					BackgroundColor3=UIC.card,
					BorderSizePixel=0,
					Active=true,
					ZIndex=2,
				}),
				6
			)
			local bg=mk("Frame",card,{
				Size=UDim2.fromScale(1,1),
				BackgroundColor3=UIC.acc,
				BackgroundTransparency=1,
				BorderSizePixel=0,
			})
			corner(bg,6)
			return card
		end
		local function action(parent,txt,fn)
			local card2=shell(parent,36)
			local b=mk("TextButton",card2,{
				Size=UDim2.fromScale(1,1),
				BackgroundTransparency=1,
				Text=txt,
				Font=UIFB,
				TextSize=12,
				TextColor3=UIC.txt,
				Active=true,
				AutoButtonColor=false,
				ZIndex=3,
			})
			b.MouseEnter:Connect(function()
				tween(card2:FindFirstChildOfClass("Frame"),{BackgroundTransparency=.3})
			end)
			b.MouseLeave:Connect(function()
				tween(card2:FindFirstChildOfClass("Frame"),{BackgroundTransparency=1})
			end)
			b.MouseButton1Click:Connect(fn)
		end
		local function toggle(parent,txt,get,fn)
			local card2=shell(parent,36)
			local hit=mk("TextButton",card2,{
				Size=UDim2.fromScale(1,1),
				BackgroundTransparency=1,
				Text="",
				Active=true,
				AutoButtonColor=false,
				ZIndex=4,
			})
			mk("TextLabel",card2,{
				Size=UDim2.new(1,-70,1,0),
				Position=UDim2.fromOffset(14,0),
				BackgroundTransparency=1,
				Text=txt,
				Font=UIFB,
				TextSize=12,
				TextColor3=UIC.txt,
				TextXAlignment=Enum.TextXAlignment.Left,
				ZIndex=3,
			})
			local pill=corner(
				mk("Frame",card2,{
					Size=UDim2.fromOffset(40,20),
					Position=UDim2.new(1,-52,.5,-10),
					BackgroundColor3=UIC.track,
					BorderSizePixel=0,
					ZIndex=3,
				}),
				10
			)
			local knob=corner(
				mk("Frame",pill,{
					Size=UDim2.fromOffset(16,16),
					Position=UDim2.fromOffset(2,2),
					BackgroundColor3=UIC.dim,
					BorderSizePixel=0,
					ZIndex=4,
				}),
				8
			)
			local function paint(instant)
				local v=get()
				local pc=v and UIC.acc or UIC.track
				local kc=v and UIC.txt or UIC.dim
				local kp=UDim2.fromOffset(v and 22 or 2,2)
				if instant then
					pill.BackgroundColor3,knob.BackgroundColor3,knob.Position=pc,kc,kp
				else
					tween(pill,{BackgroundColor3=pc})
					tween(knob,{BackgroundColor3=kc,Position=kp})
				end
			end
			hit.MouseButton1Click:Connect(function()
				fn()
				paint()
			end)
			paint(true)
			return paint
		end
		local function input(parent,txt,hint,get,set)
			local card2=shell(parent,52)
			mk("TextLabel",card2,{
				Size=UDim2.new(1,-24,0,12),
				Position=UDim2.fromOffset(14,8),
				BackgroundTransparency=1,
				Text=txt,
				Font=UIF,
				TextSize=11,
				TextColor3=UIC.dim,
				TextXAlignment=Enum.TextXAlignment.Left,
				ZIndex=3,
			})
			local box=mk("TextBox",card2,{
				Size=UDim2.new(1,-24,0,20),
				Position=UDim2.fromOffset(14,24),
				BackgroundTransparency=1,
				Font=UIFB,
				TextSize=12,
				TextColor3=UIC.txt,
				TextXAlignment=Enum.TextXAlignment.Left,
				PlaceholderText=hint,
				PlaceholderColor3=UIC.line,
				ClearTextOnFocus=false,
				Text=tostring(get()or""),
				TextTruncate=Enum.TextTruncate.AtEnd,
				Active=true,
				ZIndex=4,
			})
			box.FocusLost:Connect(function()
				set(box.Text)
			end)
			return box
		end
		local function slider(parent,txt,min,max,get,set,step)
			step=step or 1
			local card2=shell(parent,50)
			mk("TextLabel",card2,{
				Size=UDim2.new(1,-76,0,14),
				Position=UDim2.fromOffset(14,8),
				BackgroundTransparency=1,
				Text=txt,
				Font=UIF,
				TextSize=11,
				TextColor3=UIC.dim,
				TextXAlignment=Enum.TextXAlignment.Left,
				ZIndex=3,
			})
			local val=mk("TextLabel",card2,{
				Size=UDim2.fromOffset(52,14),
				Position=UDim2.new(1,-64,0,8),
				BackgroundTransparency=1,
				Font=UIFB,
				TextSize=12,
				TextColor3=UIC.txt,
				TextXAlignment=Enum.TextXAlignment.Right,
				ZIndex=3,
			})
			local track=corner(
				mk("TextButton",card2,{
					Size=UDim2.new(1,-24,0,6),
					Position=UDim2.fromOffset(14,32),
					BackgroundColor3=UIC.track,
					Text="",
					AutoButtonColor=false,
					Active=true,
					BorderSizePixel=0,
					ZIndex=3,
				}),
				3
			)
			local fill=corner(
				mk("Frame",track,{
					Size=UDim2.new(0,0,1,0),
					BackgroundColor3=UIC.acc,
					BorderSizePixel=0,
					ZIndex=4,
				}),
				3
			)
			local knob=corner(
				mk("Frame",track,{
					Size=UDim2.fromOffset(14,14),
					AnchorPoint=Vector2.new(.5,.5),
					Position=UDim2.new(0,0,.5,0),
					BackgroundColor3=UIC.txt,
					BorderSizePixel=0,
					ZIndex=5,
				}),
				7
			)
			local function refresh()
				local v=math.clamp(tonumber(get())or min,min,max)
				local rel=(v-min)/math.max(max-min,1e-6)
				fill.Size=UDim2.new(rel,0,1,0)
				knob.Position=UDim2.new(rel,0,.5,0)
				val.Text=step<1 and string.format("%.2f",v)or tostring(math.floor(v+.5))
			end
			local function applyAt(x)
				local rel=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
				set(math.clamp(math.floor((min+(max-min)*rel)/step+.5)*step,min,max))
				refresh()
			end
			local sliding=false
			track.InputBegan:Connect(function(i)
				if
					i.UserInputType==Enum.UserInputType.MouseButton1
					or i.UserInputType==Enum.UserInputType.Touch
				then
					sliding=true
					tween(knob,{Size=UDim2.fromOffset(14,14)})
					applyAt(i.Position.X)
				end
			end)
			UIS.InputChanged:Connect(function(i)
				if
					sliding
					and(
						i.UserInputType==Enum.UserInputType.MouseMovement
						or i.UserInputType==Enum.UserInputType.Touch
					)
				then
					applyAt(i.Position.X)
				end
			end)
			UIS.InputEnded:Connect(function(i)
				if
					sliding
					and(
						i.UserInputType==Enum.UserInputType.MouseButton1
						or i.UserInputType==Enum.UserInputType.Touch
					)
				then
					sliding=false
					tween(knob,{Size=UDim2.fromOffset(10,10)})
					saveTpSettings()
				end
			end)
			refresh()
		end
		do
			local dragging,dragStart,startPos,dragInput
			card.Active=true
			rail.Active,body.Active=true,true
			local function begin(i)
				if _G._ElysiumSliderDragging then
					return
				end
				local pointerY=i.UserInputType==Enum.UserInputType.Touch and i.Position.Y
					or UIS:GetMouseLocation().Y
				if pointerY>card.AbsolutePosition.Y+42 then
					return
				end
				if
					i.UserInputType~=Enum.UserInputType.MouseButton1
					and i.UserInputType~=Enum.UserInputType.Touch
				then
					return
				end
				dragging,dragStart,startPos=
					true,
					(
						i.UserInputType==Enum.UserInputType.Touch and Vector2.new(i.Position.X,i.Position.Y)
						or UIS:GetMouseLocation()
					),
					root.Position
				i.Changed:Connect(function()
					if i.UserInputState==Enum.UserInputState.End and dragging then
						dragging=false
						_G._stp_panelX=root.Position.X.Offset
						_G._stp_panelY=root.Position.Y.Offset
						saveTpSettings()
					end
				end)
			end
			local function track(i)
				if
					i.UserInputType==Enum.UserInputType.MouseMovement
					or i.UserInputType==Enum.UserInputType.Touch
				then
					dragInput=i
				end
			end
			for _,o in ipairs({card,rail,body})do
				o.InputBegan:Connect(begin)
				o.InputChanged:Connect(track)
			end
			UIS.InputChanged:Connect(function(i)
				if not dragging or i~=dragInput then
					return
				end
				local pointer=i.UserInputType==Enum.UserInputType.Touch and Vector2.new(i.Position.X,i.Position.Y)
					or UIS:GetMouseLocation()
				local d=pointer-dragStart
				root.Position=UDim2.fromOffset(startPos.X.Offset+d.X,startPos.Y.Offset+d.Y)
			end)
		end
		local home=tab("Home",1)
		local tune=tab("Tuning",2)
		label(home,"actions",true)
		action(home,"MANUAL TP",function()
			task.spawn(function()
				if diag()==0 then
					return
				end
				if _G.ElysiumStartSideTP then
					pcall(_G.ElysiumStartSideTP)
				else
					pcall(doVelocityTP,true)
				end
			end)
		end)
		label(home,"general")
		toggle(home,"FLASH TP (OFF = CLONE)",function()
			return _G.ElysiumFlashTP==true
		end,function()
			_G.ElysiumFlashTP=not _G.ElysiumFlashTP
			saveTpSettings()
		end)
		action(home,"FLASH: SAVE CURRENT START POSITION",function()
			local c=LP.Character
			local r=c and c:FindFirstChild("HumanoidRootPart")
			local h=c and c:FindFirstChildOfClass("Humanoid")
			if r and h and h.FloorMaterial~=Enum.Material.Air then
				_G.ElysiumFlashOrigin=r.Position
				saveTpSettings()
			else
				_G.ElysiumFlashStatus="stand_on_ground_to_save_origin"
			end
		end)
		action(home,"FLASH: AUTOMATIC START POSITION",function()
			_G.ElysiumFlashOrigin=nil
			saveTpSettings()
		end)
		_G.ElysiumRepaintAutoTP=toggle(home,"AUTO TP",function()
			return _G.ElysiumAutoTP~=false
		end,function()
			_G.ElysiumSetAutoTP(not(_G.ElysiumAutoTP~=false))
			saveTpSettings()
		end)
		label(tune,"movement",true)
		toggle(tune,"SOURCE GO TO (OFF = SMOOTH)",function()
			return _G.ElysiumGoStyle~="smooth"
		end,function()
			_G.ElysiumGoStyle=_G.ElysiumGoStyle=="smooth"and"source"or"smooth"
			saveTpSettings()
		end)
		toggle(tune,"GO TO: APPROACH FLOOR 2 FROM BELOW",function()
			return _G.ElysiumGoApproachF2==true
		end,function()
			_G.ElysiumGoApproachF2=not _G.ElysiumGoApproachF2
			saveTpSettings()
		end)
		slider(tune,"Go To Platform Lifetime",.5,10,function()
			return tonumber(_G.trxPlatLife)or 2
		end,function(v)_G.trxPlatLife=v end,.5)
		for _,s in ipairs({{"TP Velocity",50,750,"TPVelocity",5},{"Rise Speed",100,250,"ElysiumClimb",5},{"Go To Brainrot Speed",80,600,"ElysiumGoSpeed",5},{"Landing Delay",.01,1,"LandingDelay",.01},{"100 Studs Base Speed",20,400,"ElysiumCloseSpeed",5},{"Cross-Row Front Speed",20,400,"ElysiumProblemBaseSpeed",5},{"Pre-Clone Speed",40,250,"ElysiumPreCloneSpeed",5},})do
			local settingKey=s[4]
			slider(tune,s[1],s[2],s[3],function()
				return _G[settingKey]
			end,function(v)
				_G[settingKey]=v
			end,s[5])
		end
		label(tune,"cross-row front approach")
		toggle(tune,"SLOW BEHIND CROSS-ROW (FIRST FLOOR)",function()
			return _G.ElysiumSlowCrossRow==true
		end,function()
			_G.ElysiumSlowCrossRow=not(_G.ElysiumSlowCrossRow==true)
			saveTpSettings()
		end)
		local pri=tab("Priority",3)
		local refreshPri,currentPriTab=nil,"brainrot"
		local function mkSubTabs(parent)
			local tabsFrame=mk("Frame",parent,{
				Size=UDim2.new(1,0,0,26),
				BackgroundTransparency=1,
			})
			local names={"Brainrots","Mutations","Traits"}
			local w=1/#names
			for i,n in ipairs(names)do
				local b=corner(
					mk("TextButton",tabsFrame,{
						Size=UDim2.new(w,-4,1,0),
						Position=UDim2.new(w*(i-1),2,0,0),
						BackgroundColor3=UIC.acc,
						Text=n,
						Font=UIFB,
						TextSize=11,
						TextColor3=UIC.bg,
						AutoButtonColor=false,
						Active=true,
						ZIndex=3,
					}),
					6
				)
				b.MouseButton1Click:Connect(function()
					currentPriTab=n:lower():gsub("s$","")
					for _,c in ipairs(tabsFrame:GetChildren())do
						if c:IsA("TextButton")then
							c.BackgroundColor3=(c==b)and UIC.acc or UIC.track
							c.TextColor3=(c==b)and UIC.bg or UIC.txt
						end
					end
					if refreshPri then
						refreshPri()
					end
				end)
				if i==1 then
					b.BackgroundColor3,b.TextColor3=UIC.acc,UIC.bg
				else
					b.BackgroundColor3,b.TextColor3=UIC.track,UIC.txt
				end
			end
		end
		mkSubTabs(pri)
		local addBox
		do
			local card2=shell(pri,36)
			stroke(card2)
			addBox=mk("TextBox",card2,{
				Size=UDim2.new(1,-74,0,24),
				Position=UDim2.fromOffset(10,6),
				BackgroundColor3=UIC.track,
				BorderSizePixel=0,
				Font=UIF,
				TextSize=12,
				TextColor3=UIC.txt,
				TextXAlignment=Enum.TextXAlignment.Left,
				PlaceholderText="type a name, then Enter",
				PlaceholderColor3=UIC.dim,
				ClearTextOnFocus=false,
				Text="",
				Active=true,
				ZIndex=4,
			})
			corner(addBox,6)
			mk("UIPadding",addBox,{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)})
			local addBtn=corner(
				mk("TextButton",card2,{
					Size=UDim2.fromOffset(52,24),
					Position=UDim2.new(1,-60,0,6),
					BackgroundColor3=UIC.acc,
					Text="ADD",
					Font=UIFB,
					TextSize=11,
					TextColor3=UIC.bg,
					AutoButtonColor=false,
					Active=true,
					ZIndex=4,
				}),
				6
			)
			local function doAdd()
				local name=(addBox.Text or""):match("^%s*(.-)%s*$")
				if name and name~=""then
					if currentPriTab=="brainrot"then
						table.insert(_G.SHARED_PRIORITY_ITEMS,name)
					elseif currentPriTab=="mutation"then
						table.insert(_G.SHARED_MUTATION_PRIORITY,name)
					else
						table.insert(_G.SHARED_TRAIT_PRIORITY,name)
					end
					_G.ElysiumPriVersion=(_G.ElysiumPriVersion or 0)+1
					pcall(saveTpSettings)
					addBox.Text=""
					if refreshPri then
						refreshPri()
					end
				end
			end
			addBtn.MouseButton1Click:Connect(doAdd)
			addBtn.MouseEnter:Connect(function()
				tween(addBtn,{BackgroundColor3=UIC.txt})
			end)
			addBtn.MouseLeave:Connect(function()
				tween(addBtn,{BackgroundColor3=UIC.acc})
			end)
			addBox.FocusLost:Connect(function(enter)
				if enter then
					doAdd()
				end
			end)
		end
		label(pri,"priority  -  top = highest")
		local rowsHost=mk("Frame",pri,{
			Size=UDim2.new(1,0,0,0),
			BackgroundTransparency=1,
			AutomaticSize=Enum.AutomaticSize.Y,
			ZIndex=2,
		})
		mk("UIListLayout",rowsHost,{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
		local function getListAndIcon()
			if currentPriTab=="brainrot"then
				return _G.SHARED_PRIORITY_ITEMS,nil
			elseif currentPriTab=="mutation"then
				return _G.SHARED_MUTATION_PRIORITY,MUTATION_ICONS
			else
				return _G.SHARED_TRAIT_PRIORITY,TRAIT_ICONS
			end
		end
		refreshPri=function()
			for _,c in ipairs(rowsHost:GetChildren())do
				if c:IsA("GuiObject")then
					c:Destroy()
				end
			end
			local L,icons=getListAndIcon()
			for i=1,#L do
				local nm=tostring(L[i])
				local row=corner(
					mk("Frame",rowsHost,{
						Size=UDim2.new(1,0,0,30),
						BackgroundColor3=UIC.card,
						BorderSizePixel=0,
						LayoutOrder=i,
						ZIndex=2,
					}),
					6
				)
				stroke(row)
				local iconId=_iconForName(icons,nm)
				local textOff=12
				if iconId and type(iconId)=="string"then
					local icon=mk("ImageLabel",row,{
						Size=UDim2.fromOffset(22,22),
						Position=UDim2.fromOffset(10,4),
						BackgroundTransparency=1,
						Image=tostring(iconId),
						ZIndex=3,
					})
					textOff=40
				end
				mk("TextLabel",row,{
					Size=UDim2.new(1,(currentPriTab=="mutation")and-148 or-104,1,0),
					Position=UDim2.fromOffset(textOff,0),
					BackgroundTransparency=1,
					Text=i..".  "..((currentPriTab=="mutation")and _mutationDisplayName(nm)or nm),
					Font=UIF,
					TextSize=12,
					TextColor3=UIC.txt,
					TextXAlignment=Enum.TextXAlignment.Left,
					TextTruncate=Enum.TextTruncate.AtEnd,
					ZIndex=3,
				})
				local function commit()
					_G.ElysiumPriVersion=(_G.ElysiumPriVersion or 0)+1
					pcall(saveTpSettings)
					refreshPri()
				end
				local function mini(xoff,sym,act)
					local b=corner(
						mk("TextButton",row,{
							Size=UDim2.fromOffset(26,22),
							Position=UDim2.new(1,xoff,.5,-11),
							BackgroundColor3=UIC.track,
							Text=sym,
							Font=UIFB,
							TextSize=12,
							TextColor3=UIC.txt,
							AutoButtonColor=false,
							Active=true,
							ZIndex=3,
						}),
						6
					)
					b.MouseEnter:Connect(function()
						tween(b,{BackgroundColor3=UIC.line})
					end)
					b.MouseLeave:Connect(function()
						tween(b,{BackgroundColor3=UIC.track})
					end)
					b.MouseButton1Click:Connect(act)
					return b
				end
				mini(-98,"\u{25B2}",function()
					if i>1 then
						L[i],L[i-1]=L[i-1],L[i]
						commit()
					end
				end)
				mini(-68,"\u{25BC}",function()
					if i<#L then
						L[i],L[i+1]=L[i+1],L[i]
						commit()
					end
				end)
				mini(-36,"X",function()
					table.remove(L,i)
					commit()
				end)
				if currentPriTab=="mutation"then
					local D=_G.SHARED_MUTATION_DISABLED
					local off=D[nm]==true
					local tg=corner(
						mk("TextButton",row,{
							Size=UDim2.fromOffset(34,22),
							Position=UDim2.new(1,-136,.5,-11),
							BackgroundColor3=off and UIC.track or UIC.acc,
							Text=off and"OFF"or"ON",
							Font=UIFB,
							TextSize=10,
							TextColor3=off and UIC.dim or UIC.bg,
							AutoButtonColor=false,
							Active=true,
							ZIndex=3,
						}),
						6
					)
					tg.MouseButton1Click:Connect(function()
						if D[nm]then
							D[nm]=nil
						else
							D[nm]=true
						end
						commit()
					end)
					if off then
						for _,c in ipairs(row:GetChildren())do
							if c:IsA("TextLabel")then
								c.TextColor3=UIC.dim
							end
							if c:IsA("ImageLabel")then
								c.ImageTransparency=.6
							end
						end
					end
				end
			end
		end
		tabOpenHook["Priority"]=function()
			if refreshPri then
				refreshPri()
			end
		end
		local cfg=tab("Config",4)
		label(cfg,"config",true)
		label(cfg,"optimizer mode",true)
		do
			local row=shell(cfg,38)
			local buttons={}
			local function refresh()
				for mode,button in pairs(buttons)do
					local selected=_G.ElysiumOptimizerMode==mode
					button.BackgroundColor3=selected and UIC.acc or UIC.track
					button.TextColor3=selected and UIC.bg or UIC.txt
				end
			end
			for i,entry in ipairs({{"default","Default Mode"},{"aa","Aa Mode"}})do
				local mode=entry[1]
				local button=corner(
					mk("TextButton",row,{
						Size=UDim2.new(.5,-4,1,0),
						Position=UDim2.new((i-1)*.5,(i-1)*4,0,0),
						Text=entry[2],
						Font=UIFB,
						TextSize=12,
						BackgroundColor3=UIC.track,
						TextColor3=UIC.txt,
						AutoButtonColor=false,
						Active=true,
						ZIndex=3,
					}),
					8
				)
				buttons[mode]=button
				button.MouseButton1Click:Connect(function()
					if _G.ElysiumSetOptimizerMode then
						_G.ElysiumSetOptimizerMode(mode)
					else
						_G.ElysiumOptimizerMode=mode
					end
					saveTpSettings()
					refresh()
				end)
			end
			refresh()
		end
		do
			local exportBtn=corner(
				mk("TextButton",cfg,{
					Size=UDim2.new(1,0,0,34),
					BackgroundColor3=UIC.acc,
					Text="EXPORT TO CLIPBOARD",
					Font=UIFB,
					TextSize=12,
					TextColor3=UIC.bg,
					AutoButtonColor=false,
					Active=true,
					ZIndex=3,
				}),
				8
			)
			exportBtn.MouseButton1Click:Connect(function()
				pcall(function()
					local raw=readfile and readfile("SideTP.json")
					if type(raw)=="string"and#raw>0 then
						if type(setclipboard)=="function"then
							setclipboard(raw)
						end
					else
					end
				end)
			end)
			exportBtn.MouseEnter:Connect(function()
				tween(exportBtn,{BackgroundColor3=UIC.txt})
			end)
			exportBtn.MouseLeave:Connect(function()
				tween(exportBtn,{BackgroundColor3=UIC.acc})
			end)
		end
		do
			local card=shell(cfg,104)
			stroke(card)
			local importBox=mk("TextBox",card,{
				Size=UDim2.new(1,-10,0,56),
				Position=UDim2.fromOffset(5,5),
				BackgroundColor3=UIC.track,
				BorderSizePixel=0,
				Font=UIF,
				TextSize=10,
				TextColor3=UIC.txt,
				TextXAlignment=Enum.TextXAlignment.Left,
				TextYAlignment=Enum.TextYAlignment.Top,
				PlaceholderText="paste exported JSON here",
				PlaceholderColor3=UIC.dim,
				ClearTextOnFocus=false,
				Text="",
				MultiLine=true,
				Active=true,
				ZIndex=4,
			})
			corner(importBox,6)
			mk(
				"UIPadding",
				importBox,
				{
					PaddingLeft=UDim.new(0,6),
					PaddingRight=UDim.new(0,6),
					PaddingTop=UDim.new(0,6),
					PaddingBottom=UDim.new(0,6),
				}
			)
			local importBtn=corner(
				mk("TextButton",card,{
					Size=UDim2.new(1,-10,0,30),
					Position=UDim2.fromOffset(5,68),
					BackgroundColor3=UIC.acc,
					Text="IMPORT AND SAVE",
					Font=UIFB,
					TextSize=12,
					TextColor3=UIC.bg,
					AutoButtonColor=false,
					Active=true,
					ZIndex=4,
				}),
				6
			)
			importBtn.MouseButton1Click:Connect(function()
				pcall(function()
					local HS=ElysiumService("HttpService")
					local raw=importBox.Text or""
					local ok,t=pcall(HS.JSONDecode,HS,raw)
					if not(ok and type(t)=="table"and type(t.priorityList)=="table")then
						return
					end
					if writefile then
						writefile("SideTP.json",raw)
					end
					importBox.Text=""
				end)
			end)
			importBtn.MouseEnter:Connect(function()
				tween(importBtn,{BackgroundColor3=UIC.txt})
			end)
			importBtn.MouseLeave:Connect(function()
				tween(importBtn,{BackgroundColor3=UIC.acc})
			end)
		end
		do
			local resetBtn=corner(
				mk("TextButton",cfg,{
					Size=UDim2.new(1,0,0,34),
					BackgroundColor3=UIC.line,
					Text="RESET TO DEFAULT",
					Font=UIFB,
					TextSize=12,
					TextColor3=UIC.txt,
					AutoButtonColor=false,
					Active=true,
					ZIndex=3,
				}),
				8
			)
			resetBtn.MouseButton1Click:Connect(function()
				pcall(function()
					if writefile then
						writefile("SideTP.json",_G.TEK_DEFAULT_CONFIG_JSON)
					end
				end)
			end)
			resetBtn.MouseEnter:Connect(function()
				tween(resetBtn,{BackgroundColor3=UIC.acc})
			end)
			resetBtn.MouseLeave:Connect(function()
				tween(resetBtn,{BackgroundColor3=UIC.line})
			end)
		end
		selectTab("Home")
		_G.ElysiumToggleTPSettings=function()
			sg.Enabled=not sg.Enabled
		end
		_G.ElysiumTPGui=sg
		_G.ElysiumShowTPSettings=function(tab)
			sg.Enabled=true
			if type(tab)=="string"and pages[tab]then
				selectTab(tab)
			end
		end
		task.delay(1.5,diag)
	end
end
do
	local RunService=ElysiumService("RunService")
	local Lighting=ElysiumService("Lighting")
	local RS=ElysiumService("ReplicatedStorage")
	local LP=ElysiumService("Players").LocalPlayer
	local BAD={Blue=true,DiscoEffect=true,BeeBlur=true,ColorCorrection=true}
	local function nuke(o)
		if o and o.Parent and BAD[o.Name]then
			pcall(function()
				o:Destroy()
			end)
		end
	end
	local buzz
	local function muteBuzz()
		pcall(function()
			if not(buzz and buzz.Parent)then
				local ctl=RS:FindFirstChild("Controllers")
				local item=ctl and ctl:FindFirstChild("ItemController")
				local bee=item and item:FindFirstChild("BeeLauncherController")
				local s=bee and bee:FindFirstChild("Buzzing")
				if s and s:IsA("Sound")then
					buzz=s
				end
			end
			if buzz then
				buzz.Volume=0
				if buzz.IsPlaying then
					buzz:Stop()
				end
			end
		end)
	end
	task.spawn(function()
		LP:WaitForChild("PlayerScripts",8)
		_G.ElysiumBootWait()
		Lighting.DescendantAdded:Connect(nuke)
		do
			local n=0
			for _,o in ipairs(Lighting:GetDescendants())do
				n=n+1
				if n%150==0 then
					task.wait()
				end
				nuke(o)
			end
		end
		muteBuzz()
		local acc=0
		RunService.Heartbeat:Connect(function(dt)
			local cam=workspace.CurrentCamera
			if cam and math.abs(cam.FieldOfView-20)<.01 then
				cam.FieldOfView=tonumber(_G.ElysiumFOV)or 70
			end
			acc=acc+dt
			if acc>=1 then
				acc=0
				muteBuzz()
			end
		end)
	end)
end
(function()
	local C={
		bg=Color3.fromRGB(7,7,7),
		bg2=Color3.fromRGB(14,14,14),
		row=Color3.fromRGB(22,22,22),
		rowH=Color3.fromRGB(34,34,34),
		line=Color3.fromRGB(42,42,42),
		track=Color3.fromRGB(40,40,40),
		acc=Color3.fromRGB(201,201,201),
		acc2=Color3.fromRGB(224,224,224),
		txt=Color3.fromRGB(248,248,248),
		dim=Color3.fromRGB(159,159,159),
	}
	local FB,FR=Enum.Font.GothamBold,Enum.Font.GothamMedium
	local TS=ElysiumService("TweenService")
	local EASE=TweenInfo.new(.2,Enum.EasingStyle.Quart,Enum.EasingDirection.Out)
	local function tw(o,p)
		TS:Create(o,EASE,p):Play()
	end
	local function mk(cls,parent,props)
		local o=Instance.new(cls)
		for k,v in pairs(props or{})do
			o[k]=v
		end
		o.Parent=parent
		return o
	end
	local function round(o,r)
		r=r or 8
		mk("UICorner",o,{CornerRadius=UDim.new(0,r)})
		return o
	end
	local host=(gethui and gethui())or ElysiumService("CoreGui")
	pcall(function()
		local old=host:FindFirstChild("ElysiumTargets")
		if old then
			old:Destroy()
		end
	end)
	pcall(function()
		local legacy=host:FindFirstChild("MeerkoTargets")
		if legacy then
			legacy:Destroy()
		end
	end)
	local sg=mk("ScreenGui",nil,{
		Name="ElysiumTargets",
		ResetOnSpawn=false,
		IgnoreGuiInset=true,
		DisplayOrder=999998,
		ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
	})
	pcall(function()
		sg.Parent=host
	end)
	if not sg.Parent then
		pcall(function()
			sg.Parent=(gethui and gethui())or ElysiumService("CoreGui")
		end)
	end
	local root=round(
		mk("Frame",sg,{
			Name="Root",
			Active=true,
			BackgroundColor3=C.bg,
			BorderSizePixel=0,
			BackgroundTransparency=.04,
			Size=UDim2.fromOffset(260,320),
			Position=UDim2.fromOffset(tonumber(_G._elysium_tgtX)or 24,tonumber(_G._elysium_tgtY)or 250),
		}),
		10
	)
	mk("UIGradient",root,{
		Rotation=135,
		Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.bg2),ColorSequenceKeypoint.new(1,C.bg)}),
	})
	mk("UIStroke",root,{Thickness=1,Transparency=.4,Color=C.line})
	mk("TextLabel",root,{
		Position=UDim2.fromOffset(12,8),
		Size=UDim2.new(1,-48,0,18),
		BackgroundTransparency=1,
		Text="STICKY TARGET",
		Font=FB,
		TextSize=12,
		TextColor3=C.txt,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=4,
	})
	local tgtHeadBtn=mk("TextButton",root,{
		Size=UDim2.new(1,0,0,40),
		Position=UDim2.fromOffset(0,0),
		BackgroundTransparency=1,
		Text="-",
		Font=FB,
		TextSize=14,
		TextColor3=C.dim,
		TextXAlignment=Enum.TextXAlignment.Right,
		AutoButtonColor=false,
		Active=true,
		ZIndex=5,
	})
	mk("UIPadding",tgtHeadBtn,{PaddingRight=UDim.new(0,14)})
	if _G._elysium_tgtExpanded==nil then
		_G._elysium_tgtExpanded=true
	end
	local list=mk("ScrollingFrame",root,{
		Position=UDim2.fromOffset(12,44),
		Size=UDim2.new(1,-24,1,-56),
		BackgroundTransparency=1,
		BorderSizePixel=0,
		ScrollBarThickness=0,
		CanvasSize=UDim2.new(),
		AutomaticCanvasSize=Enum.AutomaticSize.Y,
	})
	mk("UIListLayout",list,{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
	if type(_G._elysium_tgtW)~="number"then
		_G._elysium_tgtW=260
	end
	if type(_G._elysium_tgtH)~="number"then
		_G._elysium_tgtH=320
	end
	local tgtGrip=mk("TextButton",root,{
		AnchorPoint=Vector2.new(1,1),
		Position=UDim2.new(1,-2,1,-2),
		Size=UDim2.fromOffset(22,22),
		BackgroundTransparency=1,
		Text="",
		AutoButtonColor=false,
		Active=true,
		ZIndex=10,
	})
	for _,o in ipairs({-2,3})do
		local ln=mk("Frame",tgtGrip,{
			Size=UDim2.new(0,20,0,2),
			AnchorPoint=Vector2.new(.5,.5),
			Position=UDim2.new(.5,0,.5,o),
			BackgroundColor3=C.dim,
			BorderSizePixel=0,
			ZIndex=11,
		})
		ln.Rotation=45
	end
	do
		local resizing,rStart,rW,rH=false,nil,0,0
		tgtGrip.InputBegan:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			resizing,rStart=true,i.Position
			rW,rH=root.Size.X.Offset,root.Size.Y.Offset
		end)
		UIS.InputChanged:Connect(function(i)
			if not resizing then
				return
			end
			if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			local d=i.Position-rStart
			_G._elysium_tgtW=math.clamp(rW+d.X,180,600)
			_G._elysium_tgtH=math.clamp(rH+d.Y,120,800)
			root.Size=UDim2.fromOffset(_G._elysium_tgtW,_G._elysium_tgtH)
		end)
		UIS.InputEnded:Connect(function(i)
			if
				resizing
				and(i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)
			then
				resizing=false
				pcall(function()
					if _G.ElysiumSaveSettings then
						_G.ElysiumSaveSettings()
					end
				end)
			end
		end)
	end
	local headerWasDragged=false
	local function applyTgtExpanded()
		local open=_G._elysium_tgtExpanded
		list.Visible=open
		local w=tonumber(_G._elysium_tgtW)or 260
		local h=tonumber(_G._elysium_tgtH)or 320
		root.Size=open and UDim2.fromOffset(w,h)or UDim2.fromOffset(w,40)
		tgtHeadBtn.Text=open and"-"or"+"
		tw(tgtHeadBtn,{TextColor3=open and C.dim or C.txt})
		tgtGrip.Visible=open
	end
	tgtHeadBtn.MouseButton1Click:Connect(function()
		if headerWasDragged then
			headerWasDragged=false
			return
		end
		_G._elysium_tgtExpanded=not _G._elysium_tgtExpanded
		applyTgtExpanded()
	end)
	applyTgtExpanded()
	do
		local on,from,base
		tgtHeadBtn.InputBegan:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			on,from,base=true,i.Position,root.Position
			headerWasDragged=false
			i.Changed:Connect(function()
				if i.UserInputState==Enum.UserInputState.End then
					on=false
					_G._elysium_tgtX=root.Position.X.Offset
					_G._elysium_tgtY=root.Position.Y.Offset
					pcall(function()
						if _G.ElysiumSaveSettings then
							_G.ElysiumSaveSettings()
						end
					end)
				end
			end)
		end)
		UIS.InputChanged:Connect(function(i)
			if not on then
				return
			end
			if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			local d=i.Position-from
			if d.Magnitude>=4 then
				headerWasDragged=true
			end
			root.Position=UDim2.fromOffset(base.X.Offset+d.X,base.Y.Offset+d.Y)
		end)
	end
	local function short(n)
		n=tonumber(n)or 0
		if n>=1e9 then
			return string.format("%.1fB",n/1e9)
		end
		if n>=1e6 then
			return string.format("%.1fM",n/1e6)
		end
		if n>=1e3 then
			return string.format("%.1fK",n/1e3)
		end
		return string.format("%d",n)
	end
	local MUTATION_COLORS={
		bloodrot=Color3.fromRGB(36,36,36),
		candy=Color3.fromRGB(147,147,147),
		crystal=Color3.fromRGB(209,209,209),
		cursed=Color3.fromRGB(67,67,67),
		cyber=Color3.fromRGB(183,183,183),
		diamond=Color3.fromRGB(200,200,200),
		divine=Color3.fromRGB(238,238,238),
		galaxy=Color3.fromRGB(116,116,116),
		gold=Color3.fromRGB(204,204,204),
		lava=Color3.fromRGB(122,122,122),
		phantom=Color3.fromRGB(206,206,206),
		radioactive=Color3.fromRGB(208,208,208),
		rainbow=Color3.fromRGB(255,255,255),
		yinyang=Color3.fromRGB(170,170,170),
	}
	local function mutationColor(mut)
		if type(mut)~="string"or mut==""or mut=="None"then
			return C.txt
		end
		local key=mut:lower():gsub("[%s%-_]","")
		return MUTATION_COLORS[key]or C.txt
	end
	local _CTP_TOL_X,_CTP_TOL_Z=62,58
	local function _ctpFloorFromY(y)
		if y>=-6.9 and y<=8.9 then
			return 1
		end
		if y>=11 and y<=23.15 then
			return 2
		end
		if y>23.15 then
			return 3
		end
		return nil
	end
	local function _ctpFloorFromSlot(slot,py)
		local s=tonumber(slot)
		if s then
			if s>=19 then
				return 3
			end
			if s>=11 then
				return 2
			end
			if s>=1 then
				return 1
			end
		end
		if py then
			return _ctpFloorFromY(py)
		end
		return nil
	end
	local function _ctpSameBase(petPos,myPos)
		local pIdx=getClosestBaseIdx(petPos)
		local mIdx=getClosestBaseIdx(myPos)
		if pIdx~=mIdx then
			return false
		end
		local b=BASES_LOW[mIdx]
		if not b then
			return false
		end
		return math.abs(myPos.X-b.X)<=_CTP_TOL_X and math.abs(myPos.Z-b.Z)<=_CTP_TOL_Z
	end
	local function _ctpAllowed(pet)
		if not pet or not pet.position then
			return false
		end
		local char=LP.Character
		local hrp=char and char:FindFirstChild("HumanoidRootPart")
		if not hrp then
			return false
		end
		local myPos=hrp.Position
		if not _ctpSameBase(pet.position,myPos)then
			return false
		end
		local myFloor=_ctpFloorFromY(myPos.Y)
		if not myFloor then
			return false
		end
		local tgtFloor=_ctpFloorFromSlot(pet.slot,pet.position.Y)
		if not tgtFloor then
			return false
		end
		local diff=tgtFloor-myFloor
		local up=tonumber(_G.ElysiumClickTPMaxUp)or 3
		local down=tonumber(_G.ElysiumClickTPMaxDown)or 3
		return diff<=up and diff>=-down
	end
	local function otherPlayersCarrying()
		local indices={}
		for _,player in ipairs(Players:GetPlayers())do
			if player~=LP then
				local char=player.Character
				local flag=player:GetAttribute("Stealing")
				local idx=player:GetAttribute("StealingIndex")
				if flag==nil and char then flag=char:GetAttribute("Stealing")end
				if idx==nil and char then idx=char:GetAttribute("StealingIndex")end
				if flag==true and idx~=nil and tostring(idx)~=""then
					indices[tostring(idx)]=(indices[tostring(idx)]or 0)+1
				end
			end
		end
		return indices
	end
	local function setStolenUI(r,stolen)
		if r.isStolen==stolen then return end
		r.isStolen=stolen
		r.stolenTag.Visible=stolen
		r.name.Size=UDim2.new(1,stolen and-149 or(r.mutationIcon.Visible and-110 or-86),0,15)
	end
	local rows={}
	local function rowFor(uid)
		local r=rows[uid]
		if r and r.card.Parent then
			return r
		end
		local card=round(
			mk("Frame",list,{
				Size=UDim2.new(1,-4,0,44),
				BackgroundColor3=C.row,
				BorderSizePixel=0,
				Active=true,
			}),
			6
		)
		local bg=mk("Frame",card,{
			Size=UDim2.fromScale(1,1),
			BackgroundColor3=C.acc,
			BackgroundTransparency=1,
			BorderSizePixel=0,
		})
		round(bg,6)
		local rank=mk("TextLabel",card,{
			Position=UDim2.fromOffset(6,0),
			Size=UDim2.fromOffset(20,44),
			BackgroundTransparency=1,
			Font=FB,
			TextSize=11,
			TextColor3=C.dim,
			TextXAlignment=Enum.TextXAlignment.Center,
			Text="",
			ZIndex=2,
			Visible=false,
		})
		local mutationIcon=mk("ImageLabel",card,{
			Position=UDim2.fromOffset(12,6),
			Size=UDim2.fromOffset(16,16),
			BackgroundTransparency=1,
			Image="",
			Visible=false,
			ZIndex=2,
			ScaleType=Enum.ScaleType.Fit,
		})
		local nm=mk("TextLabel",card,{
			Position=UDim2.fromOffset(12,7),
			Size=UDim2.new(1,-86,0,15),
			BackgroundTransparency=1,
			Font=FB,
			TextSize=12,
			TextColor3=C.txt,
			TextXAlignment=Enum.TextXAlignment.Left,
			TextTruncate=Enum.TextTruncate.AtEnd,
			Text="",
			ZIndex=2,
		})
		local stolenTag=mk("TextLabel",card,{
			AnchorPoint=Vector2.new(1,0),
			Position=UDim2.new(1,-75,0,7),
			Size=UDim2.fromOffset(59,15),
			BackgroundTransparency=1,
			Text="stealed",
			TextColor3=Color3.fromRGB(255,95,110),
			Font=FB,
			TextSize=10,
			TextXAlignment=Enum.TextXAlignment.Right,
			Visible=false,
			ZIndex=2,
		})
		local icons={}
		for k=1,4 do
			icons[k]=mk("ImageLabel",card,{
				Position=UDim2.fromOffset(30+(k-1)*16,24),
				Size=UDim2.fromOffset(13,13),
				BackgroundTransparency=1,
				Image="",
				Visible=false,
				ZIndex=2,
			})
		end
		local sub=mk("TextLabel",card,{
			Position=UDim2.fromOffset(30,24),
			Size=UDim2.new(1,-104,0,12),
			BackgroundTransparency=1,
			Font=FR,
			TextSize=9,
			TextColor3=C.dim,
			TextXAlignment=Enum.TextXAlignment.Left,
			TextTruncate=Enum.TextTruncate.AtEnd,
			Text="",
			ZIndex=2,
		})
		local mps=mk("TextLabel",card,{
			AnchorPoint=Vector2.new(1,0),
			Position=UDim2.new(1,-10,0,0),
			Size=UDim2.fromOffset(66,44),
			BackgroundTransparency=1,
			Font=FB,
			TextSize=11,
			TextColor3=C.acc,
			TextXAlignment=Enum.TextXAlignment.Right,
			Text="",
			ZIndex=2,
		})
		local hit=mk("TextButton",card,{
			Size=UDim2.fromScale(1,1),
			BackgroundTransparency=1,
			Text="",
			AutoButtonColor=false,
			Active=true,
			ZIndex=3,
		})
		r={
			card=card,
			bg=bg,
			rank=rank,
			mutationIcon=mutationIcon,
			name=nm,
			stolenTag=stolenTag,
			sub=sub,
			mps=mps,
			icons=icons,
			hit=hit,
			lastLocked=false,
		}
		rows[uid]=r
		return r
	end
	local function selectStealTarget(myUid,pet)
		if type(myUid)~="string"or myUid==""then
			return false
		end
		_G.ElysiumStealTargetUID=myUid
		do
			local okS,fresh=pcall(scanAllPets)
			if okS and type(fresh)=="table"then
				for _,fp in ipairs(fresh)do
					if not fp.conveyor and _petUid(fp)==myUid then
						pet=fp
						break
					end
				end
			end
		end
		if not pet then
			return false
		end
		_G.ElysiumStealTarget=pet
		if _G.ElysiumArmSteal then
			pcall(_G.ElysiumArmSteal,pet)
		end
		if LP:GetAttribute("Stealing")==true and _G.Elysium_DropBrainrot then
			pcall(_G.Elysium_DropBrainrot)
			local dropWaitUntil=os.clock()+1
			while LP:GetAttribute("Stealing")==true and os.clock()<dropWaitUntil do
				RunService.Heartbeat:Wait()
			end
			if _G.ElysiumStealTargetUID~=myUid then
				return false
			end
		end
		if pet.position and _G.ElysiumClickTPBusy and _ctpAllowed(pet)then
			_G.ElysiumClickTPPending=pet
			_G.ElysiumTPStop=true
		elseif pet.position and not isTeleporting and _ctpAllowed(pet)then
			_G.ElysiumClickTPBusy=true
			isTeleporting=true
			task.spawn(function()
				local target=pet
				while target do
					_G.ElysiumTPStop=false
					pcall(function()
						local position=target.position
						local plots=workspace:FindFirstChild("Plots")
						local plot=target.plot and plots and plots:FindFirstChild(tostring(target.plot))
						if plot and target.slot then
							local ok,live=pcall(getPetPosition,plot,target.slot,false)
							if ok and typeof(live)=="Vector3"then position=live end
						end
						goToBrainrot(position,{slot=target.slot,plot=target.plot})
					end)
					local pending=_G.ElysiumClickTPPending
					_G.ElysiumClickTPPending=nil
					if pending and _G.ElysiumStealTargetUID==_petUid(pending)then
						target=pending
					else
						target=nil
					end
				end
				isTeleporting=false
				_G.ElysiumClickTPBusy=false
			end)
		end
		return true
	end
	_G.ElysiumCycleStealTarget=function()
		local ok,pets=pcall(scanAllPets)
		if not ok or type(pets)~="table"then
			return false
		end
		local available={}
		for _,pet in ipairs(pets)do
			if not pet.conveyor then
				available[#available+1]=pet
			end
		end
		if#available==0 then
			return false
		end
		local currentUid=_G.ElysiumStealTargetUID
		local currentIndex=0
		for i,pet in ipairs(available)do
			if _petUid(pet)==currentUid then
				currentIndex=i
				break
			end
		end
		local nextPet=available[(currentIndex%#available)+1]
		return selectStealTarget(_petUid(nextPet),nextPet)
	end
	task.spawn(function()
		local _pd=tonumber(_G.ElysiumPanelStartDelay)or 0
		if not game:IsLoaded()then
			game.Loaded:Wait()
		end
		if _pd>0 then
			task.wait(_pd)
		end
		local _filled=false
		local _panelT0=os.clock()
		while sg.Parent do
			local _pw=os.clock()
			while
				_filled
				and(_G.ElysiumStealHold or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting()))
				and os.clock()-_pw<(tonumber(_G.ElysiumPanelPauseMax)or 3)
			do
				task.wait(.2)
			end
			local bootActive=_gameLoadAt and(os.clock()-_gameLoadAt)<4
			local pets=scanAllPetsCached(bootActive and .1 or .15)
			local ok=pets~=nil
			if ok and type(pets)=="table"then
				local holding=otherPlayersCarrying()
				local presentIndexCounts={}
				for _,pet in ipairs(pets)do
					if not pet.conveyor and pet.index~=nil then
						local idx=tostring(pet.index)
						presentIndexCounts[idx]=(presentIndexCounts[idx]or 0)+1
					end
				end
				local seen={}
				for i,p in ipairs(pets)do
					if not p.conveyor then
						local uid=_petUid(p)
						seen[uid]=true
						local r=rowFor(uid)
						r.pet=p
						r.lastSeenAt=os.clock()
						r.missingSince=nil
						local idx=tostring(p.index or"")
						setStolenUI(r,(holding[idx]or 0)>0 and(presentIndexCounts[idx]or 0)==1)
						if r.lastOrder~=i then
							r.lastOrder=i
							r.card.LayoutOrder=i
						end
						local nmTxt=tostring(p.name or"?")
						if r.lastName~=nmTxt then
							r.lastName=nmTxt
							r.name.Text=nmTxt
						end
						local mpsTxt="$"..short(p.mps or 0).."/s"
						if r.lastMps~=mpsTxt then
							r.lastMps=mpsTxt
							r.mps.Text=mpsTxt
						end
						local mutKey=tostring(p.mutation or"")
							.."\0"
							..tostring(p.traits and#p.traits or 0)
							.."\0"
							..tostring(_iconForName(MUTATION_ICONS,p.mutation)or"")
						if r.lastMut~=mutKey then
							r.lastMut=mutKey
							for _,ic in ipairs(r.icons)do
								ic.Visible=false
							end
							r.sub.Position=UDim2.fromOffset(12,24)
							r.sub.Size=UDim2.new(1,-86,0,12)
							if type(p.mutation)=="string"and p.mutation~=""and p.mutation~="None"then
								r.sub.Text=_mutationDisplayName(p.mutation)
								local mutationImage=_iconForName(MUTATION_ICONS,p.mutation)
								r.mutationIcon.Image=mutationImage and tostring(mutationImage)or""
								r.mutationIcon.Visible=mutationImage~=nil and tostring(mutationImage)~=""
								r.name.Position=r.mutationIcon.Visible and UDim2.fromOffset(36,7)
									or UDim2.fromOffset(12,7)
								r.name.Size=r.mutationIcon.Visible and UDim2.new(1,-110,0,15)
									or UDim2.new(1,-86,0,15)
							else
								r.sub.Text=""
								r.mutationIcon.Image=""
								r.mutationIcon.Visible=false
								r.name.Position=UDim2.fromOffset(12,7)
								r.name.Size=UDim2.new(1,-86,0,15)
							end
							r.name.TextColor3=mutationColor(p.mutation)
							if r.isStolen then r.name.Size=UDim2.new(1,-149,0,15)end
						end
						local locked=(_G.ElysiumStealTargetUID==uid)
						if locked~=r.lastLocked then
							r.lastLocked=locked
							tw(r.bg,{BackgroundTransparency=locked and 0 or 1})
							tw(r.card,{BackgroundColor3=locked and C.rowH or C.row})
						end
						if not r.wired then
							r.wired=true
							local myUid=uid
							local _crow=r
							r.hit.MouseButton1Click:Connect(function()
								if _G.ElysiumStealTargetUID==myUid then
									_G.ElysiumStealTargetUID=nil
									_G.ElysiumStealTarget=nil
									_G.ElysiumClickTPPending=nil
									if _G.ElysiumDisarmSteal then
										pcall(_G.ElysiumDisarmSteal)
									end
								else
									selectStealTarget(myUid,_crow.pet)
								end
							end)
							r.hit.MouseEnter:Connect(function()
								if _G.ElysiumStealTargetUID~=myUid then
									tw(r.card,{BackgroundColor3=C.rowH})
								end
							end)
							r.hit.MouseLeave:Connect(function()
								if _G.ElysiumStealTargetUID~=myUid then
									tw(r.card,{BackgroundColor3=C.row})
								end
							end)
						end
					end
				end
				local n=0
				for uid,r in pairs(rows)do
					if seen[uid]then
						n=n+1
					else
						local idx=r.pet and tostring(r.pet.index or"")or""
						local now=os.clock()
						r.missingSince=r.missingSince or now
						local held=idx~=""and(holding[idx]or 0)>0
						local retain=held and(now-r.missingSince)<=20
						if retain then
							setStolenUI(r,true)
							n=n+1
						else
							r.card:Destroy()
							rows[uid]=nil
						end
					end
				end
				if n>0 then
					_filled=true
				end
			end
			if not _filled and(os.clock()-_panelT0)<(tonumber(_G.ElysiumPanelRush)or 10)then
				task.wait(bootActive and .15 or(tonumber(_G.ElysiumPanelRushGap)or .15))
			else
				task.wait(tonumber(_G.ElysiumPanelScanGap)or .6)
			end
		end
	end)
	pcall(function()
		local oldMode=host:FindFirstChild("ElysiumMode")
		if oldMode then
			oldMode:Destroy()
		end
	end)
	pcall(function()
		local legacyMode=host:FindFirstChild("MeerkoMode")
		if legacyMode then
			legacyMode:Destroy()
		end
	end)
	local modeSg=mk("ScreenGui",nil,{
		Name="ElysiumMode",
		ResetOnSpawn=false,
		IgnoreGuiInset=true,
		DisplayOrder=999998,
		ZIndexBehavior=Enum.ZIndexBehavior.Sibling,
	})
	pcall(function()
		modeSg.Parent=host
	end)
	if not modeSg.Parent then
		pcall(function()
			modeSg.Parent=(gethui and gethui())or ElysiumService("CoreGui")
		end)
	end
	local modeRoot=round(
		mk("Frame",modeSg,{
			Name="Root",
			Active=true,
			BackgroundColor3=C.bg,
			BorderSizePixel=0,
			BackgroundTransparency=.04,
			Size=UDim2.fromOffset(260,440),
			Position=UDim2.fromOffset(tonumber(_G._elysium_modeX)or 24,tonumber(_G._elysium_modeY)or 190),
		}),
		10
	)
	mk("UIGradient",modeRoot,{
		Rotation=135,
		Color=ColorSequence.new({ColorSequenceKeypoint.new(0,C.bg2),ColorSequenceKeypoint.new(1,C.bg)}),
	})
	mk("UIStroke",modeRoot,{Thickness=1,Transparency=.4,Color=C.line})
	local modeTitle=mk("TextLabel",modeRoot,{
		Position=UDim2.fromOffset(12,7),
		Size=UDim2.new(1,-24,0,18),
		BackgroundTransparency=1,
		Text="AUTO STEAL",
		Font=FB,
		TextSize=13,
		TextColor3=C.txt,
		TextXAlignment=Enum.TextXAlignment.Left,
	})
	local modeContainer=mk("Frame",modeRoot,{
		Position=UDim2.fromOffset(12,31),
		Size=UDim2.new(1,-24,0,64),
		BackgroundTransparency=1,
	})
	mk("UIListLayout",modeContainer,{
		Padding=UDim.new(0,8),
		FillDirection=Enum.FillDirection.Vertical,
		HorizontalAlignment=Enum.HorizontalAlignment.Center,
		SortOrder=Enum.SortOrder.LayoutOrder,
	})
	local modeButtons={}
	local lastModeState=nil
	local function updateAllModes()
		local currentState=_G.ElysiumSourceStealActive and(_G.ElysiumSourceStealMode or"nearest")or _G.ElysiumStealMode
		if currentState==lastModeState then
			return
		end
		lastModeState=currentState
		for _,btnData in ipairs(modeButtons)do
			local on=currentState==btnData.mode
			tw(btnData.bg,{BackgroundTransparency=on and .82 or 1})
			tw(btnData.btn,{TextColor3=on and Color3.fromRGB(201,201,201)or C.dim})
		end
	end
	local function modeBtn(txt,mode)
		local btnBg=round(
			mk("Frame",modeContainer,{
				Size=UDim2.new(1,0,0,28),
				BackgroundColor3=C.row,
				BorderSizePixel=0,
				ZIndex=1,
			}),
			8
		)
		local bg=mk("Frame",btnBg,{
			Size=UDim2.fromScale(1,1),
			BackgroundColor3=Color3.fromRGB(201,201,201),
			BackgroundTransparency=1,
			BorderSizePixel=0,
			ZIndex=2,
		})
		round(bg,8)
		local btn=mk("TextButton",btnBg,{
			Size=UDim2.fromScale(1,1),
			BackgroundTransparency=1,
			Text=txt,
			Font=FB,
			TextSize=11,
			TextColor3=C.dim,
			AutoButtonColor=false,
			Active=true,
			ZIndex=3,
		})
		btn.MouseButton1Click:Connect(function()
			if mode=="priority"and _G.ElysiumSetPriorityGrab then
				_G.ElysiumSetPriorityGrab(not(_G.ElysiumSourceStealActive and _G.ElysiumSourceStealMode=="priority"))
				return
			end
			if mode=="nearest"and _G.ElysiumOpenSourceStealPanel then
				_G.ElysiumOpenSourceStealPanel()
				return
			end
			local leavingSource=_G.ElysiumSourceStealActive==true
			if leavingSource and _G.ElysiumDisableSourceStealPanel then
				_G.ElysiumDisableSourceStealPanel()
			end
			if leavingSource then
				_G.ElysiumStealMode=nil
			end
			if _G.ElysiumStealMode==mode then
				_G.ElysiumStealMode=nil
			else
				_G.ElysiumStealMode=mode
			end
			pcall(function()
				if _G.ElysiumSaveSettings then
					_G.ElysiumSaveSettings()
				end
			end)
			updateAllModes()
		end)
		btn.MouseEnter:Connect(function()
			if _G.ElysiumStealMode~=mode then
				tw(btnBg,{BackgroundColor3=C.rowH})
			end
		end)
		btn.MouseLeave:Connect(function()
			if _G.ElysiumStealMode~=mode then
				tw(btnBg,{BackgroundColor3=C.row})
			end
		end)
		table.insert(modeButtons,{btn=btn,bg=bg,mode=mode})
		return btn
	end
	modeBtn("PRIORITY","priority")
	modeBtn("NEAREST","nearest")
	mk("TextLabel",modeRoot,{
		Size=UDim2.new(1,-24,0,12),
		Position=UDim2.fromOffset(12,97),
		BackgroundTransparency=1,
		Font=FB,
		TextSize=9,
		TextColor3=C.dim,
		TextXAlignment=Enum.TextXAlignment.Center,
		Text="leaked at discord.gg/Z7vPrxecnJ",
		ZIndex=2,
	})
	local _stickyBtnRow=mk("Frame",modeRoot,{
		Position=UDim2.fromOffset(12,113),
		Size=UDim2.new(1,-24,0,30),
		BackgroundTransparency=1,
		BorderSizePixel=0,
		ZIndex=2,
	})
	local _sManualBtn=round(mk("TextButton",_stickyBtnRow,{
		Size=UDim2.new(.48,0,1,0),
		Position=UDim2.fromOffset(0,0),
		BackgroundColor3=C.row,
		Font=FB,
		TextSize=11,
		TextColor3=C.dim,
		Text="MANUAL TP",
		AutoButtonColor=false,
		Active=true,
		BorderSizePixel=0,
		ZIndex=3,
	}),6)
	_sManualBtn.MouseButton1Click:Connect(function()
		task.spawn(function()
			if _G.ElysiumStartSideTP then pcall(_G.ElysiumStartSideTP) end
		end)
	end)
	local _sResetBtn=round(mk("TextButton",_stickyBtnRow,{
		Size=UDim2.new(.48,0,1,0),
		Position=UDim2.new(.52,0,0,0),
		BackgroundColor3=C.row,
		Font=FB,
		TextSize=11,
		TextColor3=C.dim,
		Text="RESET",
		AutoButtonColor=false,
		Active=true,
		BorderSizePixel=0,
		ZIndex=3,
	}),6)
	_sResetBtn.MouseButton1Click:Connect(function()
		task.spawn(function()
			if _G.ElysiumInstantReset then
				pcall(_G.ElysiumInstantReset)
			else
				local c=LP.Character
				local h=c and c:FindFirstChildOfClass("Humanoid")
				if h then h.Health=0 end
			end
		end)
	end)
	mk("TextLabel",modeRoot,{
		Size=UDim2.new(1,-24,0,12),
		Position=UDim2.fromOffset(12,147),
		BackgroundTransparency=1,
		Font=FB,
		TextSize=9,
		TextColor3=C.dim,
		TextXAlignment=Enum.TextXAlignment.Center,
		Text="Sticky loves u",
		ZIndex=2,
	})
	local tpBtnBg=round(
		mk("Frame",modeRoot,{
			Name="TPSettingsBtn",
			BackgroundColor3=C.row,
			BorderSizePixel=0,
			ZIndex=1,
			Size=UDim2.new(1,-24,0,30),
			Position=UDim2.fromOffset(12,163),
		}),
		8
	)
	local tpBtnHl=mk("Frame",tpBtnBg,{
		Size=UDim2.fromScale(1,1),
		BackgroundColor3=Color3.fromRGB(201,201,201),
		BackgroundTransparency=1,
		BorderSizePixel=0,
		ZIndex=2,
	})
	round(tpBtnHl,8)
	local tpBtn=mk("TextButton",tpBtnBg,{
		Size=UDim2.fromScale(1,1),
		BackgroundTransparency=1,
		Text="TP SETTINGS",
		Font=FB,
		TextSize=10,
		TextColor3=C.dim,
		AutoButtonColor=false,
		Active=true,
		ZIndex=3,
	})
	if _G._elysium_modeExpanded==nil then
		_G._elysium_modeExpanded=false
	end
	local settingsScroll=mk("ScrollingFrame",modeRoot,{
		Position=UDim2.fromOffset(12,201),
		Size=UDim2.new(1,-24,1,-213),
		BackgroundTransparency=1,
		BorderSizePixel=0,
		ScrollBarThickness=0,
		CanvasSize=UDim2.new(),
		AutomaticCanvasSize=Enum.AutomaticSize.Y,
		ZIndex=1,
	})
	mk("UIListLayout",settingsScroll,{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
	if type(_G._elysium_modeW)~="number"then
		_G._elysium_modeW=260
	end
	if type(_G._elysium_modeH)~="number"then
		_G._elysium_modeH=500
	end
	local modeGrip=mk("TextButton",modeRoot,{
		AnchorPoint=Vector2.new(1,1),
		Position=UDim2.new(1,-2,1,-2),
		Size=UDim2.fromOffset(22,22),
		BackgroundTransparency=1,
		Text="",
		AutoButtonColor=false,
		Active=true,
		ZIndex=10,
	})
	for _,o in ipairs({-2,3})do
		local ln2=mk("Frame",modeGrip,{
			Size=UDim2.new(0,20,0,2),
			AnchorPoint=Vector2.new(.5,.5),
			Position=UDim2.new(.5,0,.5,o),
			BackgroundColor3=C.dim,
			BorderSizePixel=0,
			ZIndex=11,
		})
		ln2.Rotation=45
	end
	do
		local resizing,rStart,rW,rH=false,nil,0,0
		modeGrip.InputBegan:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			resizing,rStart=true,i.Position
			rW,rH=modeRoot.Size.X.Offset,modeRoot.Size.Y.Offset
		end)
		UIS.InputChanged:Connect(function(i)
			if not resizing then
				return
			end
			if i.UserInputType~=Enum.UserInputType.MouseMovement and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			local d=i.Position-rStart
			_G._elysium_modeW=math.clamp(rW+d.X,220,600)
			_G._elysium_modeH=math.clamp(rH+d.Y,200,800)
			modeRoot.Size=UDim2.fromOffset(_G._elysium_modeW,_G._elysium_modeH)
		end)
		UIS.InputEnded:Connect(function(i)
			if
				resizing
				and(i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)
			then
				resizing=false
				pcall(function()
					if _G.ElysiumSaveSettings then
						_G.ElysiumSaveSettings()
					end
				end)
			end
		end)
	end
	local function applyExpanded()
		settingsScroll.Visible=_G._elysium_modeExpanded
		local mw=tonumber(_G._elysium_modeW)or 260
		local mh=tonumber(_G._elysium_modeH)or 440
		modeRoot.Size=_G._elysium_modeExpanded and UDim2.fromOffset(mw,mh)or UDim2.fromOffset(mw,201)
		modeGrip.Visible=_G._elysium_modeExpanded
		tw(tpBtnHl,{BackgroundTransparency=_G._elysium_modeExpanded and .82 or 1})
		tw(tpBtn,{TextColor3=_G._elysium_modeExpanded and Color3.fromRGB(201,201,201)or C.dim})
	end
	tpBtn.MouseButton1Click:Connect(function()
		_G._elysium_modeExpanded=not _G._elysium_modeExpanded
		applyExpanded()
	end)
	tpBtn.MouseEnter:Connect(function()
		tw(tpBtnBg,{BackgroundColor3=C.rowH})
	end)
	tpBtn.MouseLeave:Connect(function()
		tw(tpBtnBg,{BackgroundColor3=C.row})
	end)
	local mOrder=0
	local function mNext()
		mOrder=mOrder+1
		return mOrder
	end
	local mRefreshers={}
	local function mSlider(txt,min,max,get,set,step)
		step=step or 1
		local card=round(
			mk("Frame",settingsScroll,{
				Size=UDim2.new(1,-4,0,50),
				BackgroundColor3=C.row,
				BorderSizePixel=0,
				Active=true,
				ZIndex=2,
				LayoutOrder=mNext(),
			}),
			6
		)
		mk("TextLabel",card,{
			Size=UDim2.new(1,-76,0,14),
			Position=UDim2.fromOffset(14,8),
			BackgroundTransparency=1,
			Text=txt,
			Font=FR,
			TextSize=11,
			TextColor3=C.dim,
			TextXAlignment=Enum.TextXAlignment.Left,
			ZIndex=3,
		})
		local val=mk("TextLabel",card,{
			Size=UDim2.fromOffset(52,14),
			Position=UDim2.new(1,-64,0,8),
			BackgroundTransparency=1,
			Font=FB,
			TextSize=12,
			TextColor3=C.txt,
			TextXAlignment=Enum.TextXAlignment.Right,
			ZIndex=3,
		})
		local track=mk("TextButton",card,{
			Size=UDim2.new(1,-24,0,6),
			Position=UDim2.fromOffset(14,32),
			BackgroundColor3=C.track,
			Text="",
			AutoButtonColor=false,
			Active=true,
			BorderSizePixel=0,
			ZIndex=3,
		})
		local fill=mk("Frame",track,{
			Size=UDim2.new(0,0,1,0),
			BackgroundColor3=C.acc,
			BorderSizePixel=0,
			ZIndex=4,
		})
		local knob=mk("Frame",track,{
			Size=UDim2.fromOffset(14,14),
			AnchorPoint=Vector2.new(.5,.5),
			Position=UDim2.new(0,0,.5,0),
			BackgroundColor3=C.txt,
			BorderSizePixel=0,
			ZIndex=5,
		})
		local lastV=nil
		local function refresh()
			local v=math.clamp(tonumber(get())or min,min,max)
			if v==lastV then
				return
			end
			lastV=v
			local rel=(v-min)/math.max(max-min,1e-6)
			fill.Size=UDim2.new(rel,0,1,0)
			knob.Position=UDim2.new(rel,0,.5,0)
			val.Text=step<1 and string.format("%.2f",v)or tostring(math.floor(v+.5))
		end
		local function applyAt(x)
			local rel=math.clamp((x-track.AbsolutePosition.X)/math.max(track.AbsoluteSize.X,1),0,1)
			set(math.clamp(math.floor((min+(max-min)*rel)/step+.5)*step,min,max))
			refresh()
		end
		local sliding=false
		track.InputBegan:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch then
				sliding=true
				applyAt(i.Position.X)
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if
				sliding
				and(i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch)
			then
				applyAt(i.Position.X)
			end
		end)
		UIS.InputEnded:Connect(function(i)
			if
				sliding
				and(i.UserInputType==Enum.UserInputType.MouseButton1 or i.UserInputType==Enum.UserInputType.Touch)
			then
				sliding=false
				pcall(function()
					if _G.ElysiumSaveSettings then
						_G.ElysiumSaveSettings()
					end
				end)
			end
		end)
		refresh()
		mRefreshers[#mRefreshers+1]=refresh
	end
	local function mToggle(txt,get,set)
		local card=round(
			mk("Frame",settingsScroll,{
				Size=UDim2.new(1,-4,0,36),
				BackgroundColor3=C.row,
				BorderSizePixel=0,
				Active=true,
				ZIndex=2,
				LayoutOrder=mNext(),
			}),
			6
		)
		local hit=mk("TextButton",card,{
			Size=UDim2.fromScale(1,1),
			BackgroundTransparency=1,
			Text="",
			Active=true,
			AutoButtonColor=false,
			ZIndex=4,
		})
		mk("TextLabel",card,{
			Size=UDim2.new(1,-70,1,0),
			Position=UDim2.fromOffset(14,0),
			BackgroundTransparency=1,
			Text=txt,
			Font=FB,
			TextSize=12,
			TextColor3=C.txt,
			TextXAlignment=Enum.TextXAlignment.Left,
			ZIndex=3,
		})
		local pill=round(
			mk("Frame",card,{
				Size=UDim2.fromOffset(40,20),
				Position=UDim2.new(1,-52,.5,-10),
				BackgroundColor3=C.track,
				BorderSizePixel=0,
				ZIndex=3,
			}),
			10
		)
		local knob=round(
			mk("Frame",pill,{
				Size=UDim2.fromOffset(16,16),
				Position=UDim2.fromOffset(2,2),
				BackgroundColor3=C.dim,
				BorderSizePixel=0,
				ZIndex=4,
			}),
			8
		)
		local function paint()
			local v=get()
			pill.BackgroundColor3=v and C.acc or C.track
			knob.BackgroundColor3=v and C.bg or C.dim
			knob.Position=v and UDim2.fromOffset(22,2)or UDim2.fromOffset(2,2)
		end
		hit.MouseButton1Click:Connect(function()
			set(not get())
			paint()
			pcall(function()
				if _G.ElysiumSaveSettings then
					_G.ElysiumSaveSettings()
				end
			end)
		end)
		paint()
		mRefreshers[#mRefreshers+1]=paint
	end
	do
		local modeCard=round(mk("Frame",settingsScroll,{
			Name="TeleportModeSelector",Size=UDim2.new(1,-4,0,58),
			BackgroundColor3=C.row,BorderSizePixel=0,ZIndex=2,LayoutOrder=mNext(),
		}),6)
		mk("TextLabel",modeCard,{
			Position=UDim2.fromOffset(10,4),Size=UDim2.new(1,-20,0,17),
			BackgroundTransparency=1,Text="TELEPORT MODE",Font=FB,TextSize=10,
			TextColor3=C.dim,TextXAlignment=Enum.TextXAlignment.Left,ZIndex=3,
		})
		local cloneButton=round(mk("TextButton",modeCard,{
			Name="Clone",Position=UDim2.new(0,8,0,25),Size=UDim2.new(.5,-12,0,25),
			Text="Clone",Font=FB,TextSize=12,BorderSizePixel=0,
			AutoButtonColor=false,Active=true,ZIndex=4,
		}),5)
		local flashButton=round(mk("TextButton",modeCard,{
			Name="FlashTP",Position=UDim2.new(.5,4,0,25),Size=UDim2.new(.5,-12,0,25),
			Text="Flash TP",Font=FB,TextSize=12,BorderSizePixel=0,
			AutoButtonColor=false,Active=true,ZIndex=4,
		}),5)
		local function persist()
			if type(_G.ElysiumSaveSettings)=="function"then pcall(_G.ElysiumSaveSettings)end
		end
		local function paintTeleportMode()
			local flash=_G.ElysiumFlashTP==true
			cloneButton.BackgroundColor3=flash and C.track or C.acc
			cloneButton.TextColor3=flash and C.dim or C.bg
			flashButton.BackgroundColor3=flash and C.acc or C.track
			flashButton.TextColor3=flash and C.bg or C.dim
		end
		cloneButton.Activated:Connect(function()
			_G.ElysiumFlashTP=false
			persist();paintTeleportMode()
		end)
		flashButton.Activated:Connect(function()
			_G.ElysiumFlashTP=true
			persist();paintTeleportMode()
		end)
		mRefreshers[#mRefreshers+1]=paintTeleportMode
		paintTeleportMode()
	end
	local function donorChoice(title,values,key,fallback)
		local button=round(mk("TextButton",settingsScroll,{
			Size=UDim2.new(1,-4,0,32),BackgroundColor3=C.row,BorderSizePixel=0,
			TextColor3=C.txt,Font=FB,TextSize=11,Active=true,AutoButtonColor=false,
			ZIndex=3,LayoutOrder=mNext(),Name=key,
		}),6)
		local function paint()button.Text=title..": "..tostring(_G[key]or fallback)end
		button.Activated:Connect(function()
			local index=table.find(values,_G[key]or fallback)or 1
			_G[key]=values[index%#values+1]
			if _G.ElysiumSaveSettings then pcall(_G.ElysiumSaveSettings)end
			paint()
		end)
		mRefreshers[#mRefreshers+1]=paint;paint()
	end
	donorChoice("GO TO BRAINROT",{"CFrame","Velocity"},"ElysiumGoMethod","CFrame")
	donorChoice("Tp Position",{"Multi","Front","Side"},"ElysiumFlashEntry","Multi")
	mToggle("2 From 1",function()return _G.ElysiumGoApproachF2~=false end,function(v)_G.ElysiumGoApproachF2=v end)
	mToggle("Unwalk (No Animations)",function()return _G.ElysiumUnwalk~=false end,function(v)_G.ElysiumUnwalk=v end)
	mSlider("Go To Brainrot",50,1000,function()return tonumber(_G.ElysiumGoSpeed)or 400 end,function(v)_G.ElysiumGoSpeed=v end,10)
	mSlider("TP VELOCITY",50,750,function()
		return tonumber(_G.TPVelocity)or 200
	end,function(v)
		_G.TPVelocity=v
	end,5)
	mSlider("RISE SPEED",100,250,function()
		return tonumber(_G.ElysiumClimb)or 160
	end,function(v)
		_G.ElysiumClimb=v
	end,5)
	mSlider("LANDING DELAY",.01,1,function()
		return tonumber(_G.LandingDelay)or .35
	end,function(v)
		_G.LandingDelay=v
	end,.01)
	mSlider("100 STUDS BASE SPEED",20,400,function()
		return tonumber(_G.ElysiumCloseSpeed)or 80
	end,function(v)
		_G.ElysiumCloseSpeed=v
	end,5)
	mSlider("PRE-CLONE SPEED",40,250,function()
		return tonumber(_G.ElysiumPreCloneSpeed)or 120
	end,function(v)
		_G.ElysiumPreCloneSpeed=v
	end,5)
	local priBtnBg=round(
		mk("Frame",settingsScroll,{
			Name="PriHeader",
			BackgroundColor3=C.row,
			BorderSizePixel=0,
			ZIndex=2,
			LayoutOrder=mNext(),
			Size=UDim2.new(1,-4,0,30),
		}),
		6
	)
	local priBtnHl=mk("Frame",priBtnBg,{
		Size=UDim2.fromScale(1,1),
		BackgroundColor3=C.acc,
		BackgroundTransparency=1,
		BorderSizePixel=0,
		ZIndex=2,
	})
	round(priBtnHl,6)
	local priBtn=mk("TextButton",priBtnBg,{
		Size=UDim2.fromScale(1,1),
		BackgroundTransparency=1,
		Text="PRIORITY",
		Font=FB,
		TextSize=10,
		TextColor3=C.dim,
		AutoButtonColor=false,
		Active=true,
		ZIndex=3,
	})
	priBtn.MouseEnter:Connect(function()
		tw(priBtnBg,{BackgroundColor3=C.rowH})
	end)
	priBtn.MouseLeave:Connect(function()
		tw(priBtnBg,{BackgroundColor3=C.row})
	end)
	if _G._elysium_modePriExpanded==nil then
		_G._elysium_modePriExpanded=false
	end
	local priHint=mk("TextLabel",settingsScroll,{
		Size=UDim2.new(1,-4,0,14),
		BackgroundTransparency=1,
		Text="TOP = HIGHEST",
		Font=FB,
		TextSize=9,
		TextColor3=C.dim,
		TextXAlignment=Enum.TextXAlignment.Left,
		ZIndex=2,
		LayoutOrder=mNext(),
	})
	local modePriTab="brainrot"
	local refreshModePri
	local subTabs=mk("Frame",settingsScroll,{
		Size=UDim2.new(1,-4,0,26),
		BackgroundTransparency=1,
		ZIndex=2,
		LayoutOrder=mNext(),
	})
	mk("UIListLayout",subTabs,{
		Padding=UDim.new(0,8),
		FillDirection=Enum.FillDirection.Horizontal,
		HorizontalAlignment=Enum.HorizontalAlignment.Center,
		SortOrder=Enum.SortOrder.LayoutOrder,
	})
	local subTabBtns={}
	local function paintSubTabs()
		for _,e in ipairs(subTabBtns)do
			local on=(e.key==modePriTab)
			e.btn.BackgroundColor3=on and C.acc or C.track
			e.btn.TextColor3=on and C.bg or C.txt
		end
	end
	for _,info in ipairs({{"Brainrots","brainrot"},{"Mutations","mutation"}})do
		local key=info[2]
		local b=round(
			mk("TextButton",subTabs,{
				Size=UDim2.fromOffset(100,26),
				BackgroundColor3=C.track,
				Text=info[1],
				Font=FB,
				TextSize=11,
				TextColor3=C.txt,
				AutoButtonColor=false,
				Active=true,
				ZIndex=3,
			}),
			6
		)
		b.MouseButton1Click:Connect(function()
			modePriTab=key
			paintSubTabs()
			if refreshModePri then
				refreshModePri()
			end
		end)
		subTabBtns[#subTabBtns+1]={btn=b,key=key}
	end
	local modeAddRow=round(
		mk("Frame",settingsScroll,{
			Size=UDim2.new(1,-4,0,36),
			BackgroundColor3=C.row,
			BorderSizePixel=0,
			ZIndex=2,
			LayoutOrder=mNext(),
		}),
		6
	)
	local modeAddBox=mk("TextBox",modeAddRow,{
		Size=UDim2.new(1,-74,0,24),
		Position=UDim2.fromOffset(10,6),
		BackgroundColor3=C.track,
		BorderSizePixel=0,
		Font=FR,
		TextSize=12,
		TextColor3=C.txt,
		TextXAlignment=Enum.TextXAlignment.Left,
		PlaceholderText="type a name, then Enter",
		PlaceholderColor3=C.dim,
		ClearTextOnFocus=false,
		Text="",
		Active=true,
		ZIndex=4,
	})
	mk("UIPadding",modeAddBox,{PaddingLeft=UDim.new(0,8),PaddingRight=UDim.new(0,8)})
	local modeAddBtn=round(
		mk("TextButton",modeAddRow,{
			Size=UDim2.fromOffset(52,24),
			Position=UDim2.new(1,-60,0,6),
			BackgroundColor3=C.acc,
			Text="ADD",
			Font=FB,
			TextSize=11,
			TextColor3=C.bg,
			AutoButtonColor=false,
			Active=true,
			ZIndex=4,
		}),
		6
	)
	local function modeDoAdd()
		local name=(modeAddBox.Text or""):match("^%s*(.-)%s*$")
		if name and name~=""then
			if modePriTab=="mutation"then
				if type(_G.SHARED_MUTATION_PRIORITY)~="table"then
					_G.SHARED_MUTATION_PRIORITY={}
				end
				table.insert(_G.SHARED_MUTATION_PRIORITY,name)
			else
				if type(_G.SHARED_PRIORITY_ITEMS)~="table"then
					_G.SHARED_PRIORITY_ITEMS={}
				end
				table.insert(_G.SHARED_PRIORITY_ITEMS,name)
			end
			_G.ElysiumPriVersion=(_G.ElysiumPriVersion or 0)+1
			pcall(function()
				if _G.ElysiumSaveSettings then
					_G.ElysiumSaveSettings()
				end
			end)
			modeAddBox.Text=""
			if refreshModePri then
				refreshModePri()
			end
		end
	end
	modeAddBtn.MouseButton1Click:Connect(modeDoAdd)
	modeAddBox.FocusLost:Connect(function(enter)
		if enter then
			modeDoAdd()
		end
	end)
	local modeRowsHost=mk("Frame",settingsScroll,{
		Size=UDim2.new(1,0,0,0),
		BackgroundTransparency=1,
		AutomaticSize=Enum.AutomaticSize.Y,
		ZIndex=2,
		LayoutOrder=mNext(),
	})
	mk("UIListLayout",modeRowsHost,{Padding=UDim.new(0,6),SortOrder=Enum.SortOrder.LayoutOrder})
	local function modeGetListAndIcon()
		if modePriTab=="mutation"then
			return _G.SHARED_MUTATION_PRIORITY,MUTATION_ICONS
		end
		return _G.SHARED_PRIORITY_ITEMS,nil
	end
	refreshModePri=function()
		for _,c in ipairs(modeRowsHost:GetChildren())do
			if c:IsA("GuiObject")then
				c:Destroy()
			end
		end
		if type(_G.SHARED_MUTATION_DISABLED)~="table"then
			_G.SHARED_MUTATION_DISABLED={}
		end
		local L,icons=modeGetListAndIcon()
		if type(L)~="table"then
			return
		end
		for i=1,#L do
			local nm=tostring(L[i])
			local row=round(
				mk("Frame",modeRowsHost,{
					Size=UDim2.new(1,0,0,30),
					BackgroundColor3=C.row,
					BorderSizePixel=0,
					LayoutOrder=i,
					ZIndex=2,
				}),
				6
			)
			local iconId=_iconForName(icons,nm)
			local textOff=12
			if iconId and type(iconId)=="string"then
				mk("ImageLabel",row,{
					Size=UDim2.fromOffset(22,22),
					Position=UDim2.fromOffset(10,4),
					BackgroundTransparency=1,
					Image=tostring(iconId),
					ZIndex=3,
				})
				textOff=40
			end
			mk("TextLabel",row,{
				Size=UDim2.new(1,(modePriTab=="mutation")and-148 or-104,1,0),
				Position=UDim2.fromOffset(textOff,0),
				BackgroundTransparency=1,
				Text=(modePriTab=="mutation")and _mutationDisplayName(nm)or nm,
				Font=FR,
				TextSize=12,
				TextColor3=C.txt,
				TextXAlignment=Enum.TextXAlignment.Left,
				TextTruncate=Enum.TextTruncate.AtEnd,
				ZIndex=3,
			})
			local function commit()
				_G.ElysiumPriVersion=(_G.ElysiumPriVersion or 0)+1
				pcall(function()
					if _G.ElysiumSaveSettings then
						_G.ElysiumSaveSettings()
					end
				end)
				refreshModePri()
			end
			local function mini(xoff,sym,act)
				local b=round(
					mk("TextButton",row,{
						Size=UDim2.fromOffset(26,22),
						Position=UDim2.new(1,xoff,.5,-11),
						BackgroundColor3=C.track,
						Text=sym,
						Font=FB,
						TextSize=12,
						TextColor3=C.txt,
						AutoButtonColor=false,
						Active=true,
						ZIndex=3,
					}),
					6
				)
				b.MouseEnter:Connect(function()
					tw(b,{BackgroundColor3=C.rowH})
				end)
				b.MouseLeave:Connect(function()
					tw(b,{BackgroundColor3=C.track})
				end)
				b.MouseButton1Click:Connect(act)
				return b
			end
			mini(-98,"\u{25B2}",function()
				if i>1 then
					L[i],L[i-1]=L[i-1],L[i]
					commit()
				end
			end)
			mini(-68,"\u{25BC}",function()
				if i<#L then
					L[i],L[i+1]=L[i+1],L[i]
					commit()
				end
			end)
			mini(-36,"X",function()
				table.remove(L,i)
				commit()
			end)
			if modePriTab=="mutation"then
				local D=_G.SHARED_MUTATION_DISABLED
				local off=D[nm]==true
				local tg=round(
					mk("TextButton",row,{
						Size=UDim2.fromOffset(34,22),
						Position=UDim2.new(1,-136,.5,-11),
						BackgroundColor3=off and C.track or C.acc,
						Text=off and"OFF"or"ON",
						Font=FB,
						TextSize=10,
						TextColor3=off and C.dim or C.bg,
						AutoButtonColor=false,
						Active=true,
						ZIndex=3,
					}),
					6
				)
				tg.MouseButton1Click:Connect(function()
					if D[nm]then
						D[nm]=nil
					else
						D[nm]=true
					end
					commit()
				end)
			end
		end
	end
	local function applyPriExpanded()
		local open=_G._elysium_modePriExpanded
		priHint.Visible=open
		subTabs.Visible=open
		modeAddRow.Visible=open
		modeRowsHost.Visible=open
		tw(priBtnHl,{BackgroundTransparency=open and 0 or 1})
		tw(priBtn,{TextColor3=open and C.bg or C.dim})
	end
	priBtn.MouseButton1Click:Connect(function()
		_G._elysium_modePriExpanded=not _G._elysium_modePriExpanded
		applyPriExpanded()
	end)
	paintSubTabs()
	refreshModePri()
	applyExpanded()
	applyPriExpanded()
	local lastModePriVer=-1
	task.spawn(function()
		while modeSg.Parent do
			updateAllModes()
			local pv=_G.ElysiumPriVersion or 0
			if pv~=lastModePriVer then
				lastModePriVer=pv
				pcall(refreshModePri)
			end
			for _,r in ipairs(mRefreshers)do
				pcall(r)
			end
			task.wait(.5)
		end
	end)
	do
		local on,from,base,tracked
		modeRoot.InputBegan:Connect(function(i)
			if i.UserInputType~=Enum.UserInputType.MouseButton1 and i.UserInputType~=Enum.UserInputType.Touch then
				return
			end
			local ok,relY=pcall(function()
				return i.Position.Y-modeRoot.AbsolutePosition.Y
			end)
			if ok and relY>120 then
				return
			end
			on,from,base=true,i.Position,modeRoot.Position
			i.Changed:Connect(function()
				if i.UserInputState==Enum.UserInputState.End then
					on=false
					_G._elysium_modeX=modeRoot.Position.X.Offset
					_G._elysium_modeY=modeRoot.Position.Y.Offset
					pcall(function()
						if _G.ElysiumSaveSettings then
							_G.ElysiumSaveSettings()
						end
					end)
				end
			end)
		end)
		modeRoot.InputChanged:Connect(function(i)
			if i.UserInputType==Enum.UserInputType.MouseMovement or i.UserInputType==Enum.UserInputType.Touch then
				tracked=i
			end
		end)
		UIS.InputChanged:Connect(function(i)
			if not on or i~=tracked then
				return
			end
			local d=i.Position-from
			modeRoot.Position=UDim2.fromOffset(base.X.Offset+d.X,base.Y.Offset+d.Y)
		end)
	end
	_G.ElysiumToggleTargets=function()
		sg.Enabled=not sg.Enabled
	end
	_G.ElysiumToggleMode=function()
		modeSg.Enabled=not modeSg.Enabled
	end
	pcall(function()
		local oldWm=host:FindFirstChild("ElysiumWatermark")
		if oldWm then
			oldWm:Destroy()
		end
	end)
	_G.ElysiumToggleWatermark=function() end
end)()
do
	local function createMessage72PromptGate(state,world,player,zones)
		local P,C,workspace=state,{RADIUS=12},world
		local game={Players={LocalPlayer=player}}
		local r=zones
		local function n(a)
			for e,x in ipairs(r)do
				if
					a.X>=math.min(x.min.X,x.max.X)
					and a.X<=math.max(x.min.X,x.max.X)
					and a.Z>=math.min(x.min.Z,x.max.Z)
					and a.Z<=math.max(x.min.Z,x.max.Z)
				then
					return e
				end
			end
		end
		local function r(a)
			local e=a.Parent
			if not e then
				return
			end
			if e:IsA("Attachment")and e.Parent then
				e=e.Parent
			end
			if e:IsA("BasePart")then
				return e.Position
			elseif e:IsA("Model")then
				return e:GetPivot().Position
			end
		end
		local function a(e)
			if not P then
				return false
			end
			local x=P.SelectedPetData
			if not x then
				return false
			end
			local Q=e:FindFirstAncestorOfClass("Model")
			if not Q then
				return false
			end
			if x.plot then
				local V=e:FindFirstAncestor(x.plot)
				if not V then
					return false
				end
			end
			if x.slot then
				local V=e:FindFirstAncestor(x.slot)
				if V then
					return true
				end
				if Q.Name==x.slot then
					return true
				end
				if Q.Parent and Q.Parent.Name==x.slot then
					return true
				end
			end
			if x.name then
				local e=string.lower(x.name)
				local x=Q
				while x do
					if x.Name and string.lower(x.Name)==e then
						return true
					end
					x=x.Parent
				end
			end
			return false
		end
		local function e(x,Q,nearestInstantMode)
			if not x or not x.Parent then
				return false
			end
			if not x.Enabled then
				return false
			end
			local V=r(x)
			if not V then
				return false
			end
			local r=x:FindFirstAncestorOfClass("Model")
			if r then
				local r=workspace:FindFirstChild("Plots")
				if r then
					local i=x:FindFirstAncestorWhichIsA("Model")
					while i and i.Parent~=r do
						i=i.Parent
					end
					if i then
						local r=i:FindFirstChild("PlotSign")
						if r then
							local i=r:FindFirstChildWhichIsA("SurfaceGui",true)
							local r=i and i:FindFirstChildWhichIsA("TextLabel",true)
							if r then
								local i=r.Text:lower()
								if
									i:find(game.Players.LocalPlayer.Name:lower(),1,true)
									or i:find(game.Players.LocalPlayer.DisplayName:lower(),1,true)
								then
									return false
								end
							end
						end
					end
				end
			end
			if nearestInstantMode==true then
				local r=n(Q)
				local i=n(V)
				if not r or r~=i then
					return false
				end
			end
			if nearestInstantMode~=true then
				if not a(x)then
					return false
				end
			end
			local r=typeof(x.MaxActivationDistance)=="number"
					and x.MaxActivationDistance>0
					and x.MaxActivationDistance
				or C.RADIUS
			local n=math.min(C.RADIUS,r)
			return(V-Q).Magnitude<=n
		end
		return function(prompt,root,mode)
			return e(prompt,root.Position,mode)
		end
	end
	local function createHeadlessGrabEngine(deps)
		local player,world,players,tween=deps.player,deps.world,deps.players,deps.tween
		local clock=deps.clock or os.clock
		local ZONES={
			{
				min=Vector3.new(-337.448303,-3.898971,-122.397758),
				max=Vector3.new(-328.004578,-3.898971,242.625626),
			},
			{
				min=Vector3.new(-327.25766,-3.899109,-122.228622),
				max=Vector3.new(-320.600891,-3.899109,242.612259),
			},
			{
				min=Vector3.new(-319.783386,-3.89897,-122.227089),
				max=Vector3.new(-312.908325,-3.89897,242.585617),
			},
			{
				min=Vector3.new(-312.445648,-3.899108,-122.389832),
				max=Vector3.new(-305.489899,-3.899108,242.456818),
			},
			{
				min=Vector3.new(-305.037048,-3.89897,-122.230743),
				max=Vector3.new(-293.957489,-3.89897,242.606873),
			},
			{
				min=Vector3.new(-491.448608,-3.898972,-122.253258),
				max=Vector3.new(-481.811737,-3.898972,242.615005),
			},
			{
				min=Vector3.new(-498.971069,-3.89897,-122.382767),
				max=Vector3.new(-491.74884,-3.89897,242.612061),
			},
			{
				min=Vector3.new(-506.436737,-3.898972,-122.411476),
				max=Vector3.new(-499.318542,-3.898972,242.615982),
			},
			{
				min=Vector3.new(-513.783569,-3.898972,-122.223297),
				max=Vector3.new(-506.801849,-3.898972,242.62709),
			},
			{
				min=Vector3.new(-525.236938,-3.898972,-122.409813),
				max=Vector3.new(-514.265015,-3.898972,242.608932),
			},
		}
		local api={
			enabled=false,
			nearest=true,
			instantWanted=true,
			instant=false,
			SelectedPetData=nil,
			AllAnimalsCache={},
			phase="off",
			progress=0,
			manualUid=nil,
		}
		local donorCanFire=createMessage72PromptGate(api,world,player,ZONES)
		local sync,animals,mutations,traits
		local connections,prompts,callbacks,lastBurst,lastFire={},{},{},{},{}
		local serial=0
		local hold,holdTween,holdSerial,holdContext
		local completeInstantHold
		local lastScan,lastCallbackScan,lastPulse,pulseUntil=-math.huge,-math.huge,0,nil
		local lastPoll=-math.huge
		local pollBoostUntil=0
		function api.GetSafePollRate()
			return clock()<pollBoostUntil and .27 or .1
		end
		function api.TriggerSafePollBoost()
			pollBoostUntil=clock()+3
		end
		local inRange=false
		local function cancelHold(reason)
			local previous=hold
			local instantCompletion=false
			if reason=="instant_refresh"and previous and completeInstantHold then
				instantCompletion=completeInstantHold(previous,holdContext)==true
			end
			holdSerial=(holdSerial or 0)+1
			hold=nil
			holdContext=nil
			if holdTween then
				pcall(function()
					holdTween:Cancel()
				end)
				holdTween=nil
			end
			local handlers=previous and callbacks[previous]
			if handlers and not instantCompletion then
				for _,callback in ipairs(handlers.ended)do
					pcall(callback)
				end
			end
			api.progress=0
		end
		local function channel(name)
			local env=type(getgenv)=="function"and getgenv()or _G
			local bridge=env.ElysiumDataBridge or _G.ElysiumDataBridge
			if bridge and bridge.game==game and bridge.workspace==world then
				return bridge.plots[tostring(name)]
			end
			local identity=deps.getIdentity and deps.getIdentity()
			local ok,result=pcall(function()
				if deps.setIdentity then
					deps.setIdentity(8)
				end
				return sync:GetTableFromChannel(name)
			end)
			if identity~=nil and deps.setIdentity then
				pcall(deps.setIdentity,identity)
			end
			return ok and type(result)=="table"and result or nil
		end
		local function own(owner)
			return owner==player or type(owner)=="string"and owner==player.Name
		end
		local function activeOwner(owner)
			if own(owner)or not owner then
				return false
			end
			if typeof(owner)=="Instance"then
				return players:FindFirstChild(owner.Name)==owner
			end
			return type(owner)=="string"and players:FindFirstChild(owner)~=nil
		end
		local function generation(index,mutation,list)
			local definition=animals[index]
			if not definition then
				return 0
			end
			local base=definition.Generation or(definition.Price or 0)*.1
			local multiplier,sleepy=1,false
			local modifier=mutations[mutation]
			if modifier and modifier.Modifier then
				multiplier+=modifier.Modifier
			end
			for _,name in ipairs(type(list)=="table"and list or{})do
				if name=="Sleepy"then
					sleepy=true
				elseif traits[name]and traits[name].MultiplierModifier then
					multiplier+=traits[name].MultiplierModifier
				end
			end
			local value=math.round(base*multiplier)
			return sleepy and math.round(value*.5)or value
		end
		local function spawnFor(entry)
			local plots=world:FindFirstChild("Plots")
			local plot=plots and plots:FindFirstChild(entry.plot)
			local podiums=plot and plot:FindFirstChild("AnimalPodiums")
			local podium=podiums and podiums:FindFirstChild(entry.slot)
			local base=podium and podium:FindFirstChild("Base")
			return base and(base:FindFirstChild("Spawn")or base:FindFirstChildWhichIsA("BasePart")),plot
		end
		function api.Scan()
			if not api.enabled then
				return
			end
			local result={}
			local plots=world:FindFirstChild("Plots")
			if plots then
				for _,plot in ipairs(plots:GetChildren())do
					local data=channel(plot.Name)
					if data and activeOwner(data.Owner)and type(data.AnimalList)=="table"then
						for slot,animal in pairs(data.AnimalList)do
							local definition=type(animal)=="table"and animals[animal.Index]
							if definition then
								local value=generation(animal.Index,animal.Mutation,animal.Traits)
								if value>=1 then
									result[#result+1]={
										name=definition.DisplayName or animal.Index,
										petName=definition.DisplayName or animal.Index,
										index=animal.Index,
										mutation=animal.Mutation or"None",
										traits=animal.Traits,
										genValue=value,
										genText=deps.money(value),
										owner=type(data.Owner)=="string"and data.Owner or data.Owner.Name,
										plot=plot.Name,
										slot=tostring(slot),
										uid=plot.Name.."_"..tostring(slot),
									}
								end
							end
						end
					end
				end
			end
			table.sort(result,function(a,b)
				if a.genValue~=b.genValue then
					return a.genValue>b.genValue
				end
				return a.uid<b.uid
			end)
			api.AllAnimalsCache=result
			lastScan=clock()
			if api.manualUid then
				local found=false
				for _,entry in ipairs(result)do
					if entry.uid==api.manualUid then
						found=true
						break
					end
				end
				if not found then
					api.manualUid=nil
				end
			end
		end
		local function eligibleCharacter()
			if not _G.ElysiumHoldingForPickup and(isTeleporting or _G.ElysiumStealHold or _G.ElysiumMovementLeaseActive)then return nil end
			if not api.enabled or _G.Elysium_IsResetting or _G.__elysiumResetBusy then
				return nil
			end
			if not api.nearest and not api.instantWanted and not api.manualUid then
				return nil
			end
			if player:GetAttribute("Stealing")==true then
				return nil
			end
			local character=player.Character
			local hum=character and character:FindFirstChildOfClass("Humanoid")
			if not hum or hum.Health<=0 then
				return nil
			end
			return character:FindFirstChild("HumanoidRootPart")
		end
		local function selectTarget(root)
			local selected,bestDistance=nil,math.huge
			if api.priority then
				local best=deps.priorityTarget(api.SelectedPetData)
				if best then
					for _,entry in ipairs(api.AllAnimalsCache)do
						if tostring(entry.plot)==tostring(best.plot)and tostring(entry.slot)==tostring(best.slot)
							and entry.index==best.index then
							selected=entry
							break
						end
					end
				end
			else
			for _,entry in ipairs(api.AllAnimalsCache)do
				if api.manualUid then
					if entry.uid==api.manualUid then
						selected=entry
						break
					end
				elseif api.nearest then
					local spawn=spawnFor(entry)
					local distance=spawn and(spawn.Position-root.Position).Magnitude or math.huge
					if distance<bestDistance then
						selected,bestDistance=entry,distance
					end
				else
					selected=entry
					break
				end
			end
			end
			local previous=api.SelectedPetData
			if(previous and previous.uid)~=(selected and selected.uid)then
				cancelHold()
			end
			api.SelectedPetData=selected
		end
		local function promptPosition(prompt)
			local object=prompt.Parent
			if object and object:IsA("Attachment")then
				object=object.Parent
			end
			if object and object:IsA("BasePart")then
				return object.Position
			end
			if object and object:IsA("Model")then
				return object:GetPivot().Position
			end
		end
		local function promptEntry(prompt)
			local plots=world:FindFirstChild("Plots")
			local node=prompt
			local podiums,slot
			while node and node~=plots do
				if node.Parent and node.Parent.Name=="AnimalPodiums"then
					podiums,slot=node.Parent,node.Name
					break
				end
				node=node.Parent
			end
			local plot=podiums and podiums.Parent
			if not plot or not plots or plot.Parent~=plots then
				return
			end
			return plot.Name,slot
		end
		local function canFire(prompt,root,selectedOnly)
			if not prompt or not prompt.Parent or not prompt.Enabled then
				return false
			end
			local plot,slot=promptEntry(prompt)
			local data=plot and channel(plot)
			if not data or not activeOwner(data.Owner)then
				return false
			end
			if api.priority then
				local selected=api.SelectedPetData
				if not selected or selected.plot~=plot or selected.slot~=slot then return false end
			end
			local unrestrictedNearest=not selectedOnly and not api.priority and api.nearest and api.instant and not api.manualUid
			return donorCanFire(prompt,root,unrestrictedNearest)
		end
		local function selectedHoldValid(prompt)
			if not prompt or not prompt.Parent or not prompt.Enabled then
				return false
			end
			local plot,slot=promptEntry(prompt)
			local selected=api.SelectedPetData
			local data=plot and channel(plot)
			return selected~=nil
				and selected.plot==plot
				and selected.slot==slot
				and data~=nil
				and activeOwner(data.Owner)
		end
		local function fire(prompt,count,interval)
			local now=clock()
			if lastFire[prompt]and now-lastFire[prompt]<interval then
				return
			end
			lastFire[prompt]=now
			for _=1,count do
				if not api.enabled then
					break
				end
				pcall(deps.firePrompt,prompt,0)
			end
		end
		local function cacheCallbacks(prompt,refresh)
			local actions=_G.ElysiumActions
			local shared=actions and actions.game==game and actions.GetPromptCallbacks(prompt)
			if shared then callbacks[prompt]=shared;return shared end
			if callbacks[prompt]and not refresh then
				return callbacks[prompt]
			end
			local found={began={},triggered={},ended={}}
			for field,signal in pairs({
				began=prompt.PromptButtonHoldBegan,
				triggered=prompt.Triggered,
				ended=prompt.PromptButtonHoldEnded,
			})do
				local ok,list=pcall(deps.getConnections,signal)
				if ok and type(list)=="table"then
					for _,connection in ipairs(list)do
						if type(connection.Function)=="function"then
							found[field][#found[field]+1]=connection.Function
						end
					end
				end
			end
			callbacks[prompt]=found
			return found
		end
		local function runCallbacks(list,token,uid)
			for _,callback in ipairs(list)do
				task.spawn(function()
					if not api.enabled or serial~=token then
						return
					end
					if
						uid and(not api.SelectedPetData or api.SelectedPetData.uid~=uid or not eligibleCharacter())
					then
						return
					end
					local ok=pcall(callback)
					if not ok then
						api.lastError="prompt callback failed"
					end
				end)
			end
		end
		completeInstantHold=function(prompt,context)
			if not context or context.serial~=serial or not api.instantWanted then
				return
			end
			local root=eligibleCharacter()
			local selected=api.SelectedPetData
			if not root or not selected or selected.uid~=context.uid or not selectedHoldValid(prompt)then
				return
			end
			local handlers=callbacks[prompt]
			if not handlers or#handlers.triggered==0 then
				api.lastError="Triggered callback unavailable"
				return
			end
			api.lastError=nil
			local token=serial
			task.spawn(function()
				local currentRoot=eligibleCharacter()
				local current=api.SelectedPetData
				if
					api.enabled
					and serial==token
					and api.instantWanted
					and currentRoot
					and current
					and current.uid==context.uid
					and selectedHoldValid(prompt)
				then
					api.instantAttempts=(api.instantAttempts or 0)+1
					for _,callback in ipairs(handlers.triggered)do
						if not api.enabled or serial~=token then
							break
						end
						local ok=pcall(callback)
						if not ok then
							api.lastError="instant Triggered callback failed"
						end
					end
				end
				for _,callback in ipairs(handlers.ended)do
					pcall(callback)
				end
			end)
			return true
		end
		local function normalHold(prompt,duration)
			if hold==prompt then
				return
			end
			cancelHold()
			local handlers=cacheCallbacks(prompt)
			if#handlers.began==0 and#handlers.triggered==0 then
				api.phase="callbacks unavailable"
				return
			end
			hold=prompt
			local token,holdToken=serial,holdSerial
			local uid=api.SelectedPetData and api.SelectedPetData.uid
			holdContext={serial=token,uid=uid}
			runCallbacks(handlers.began,token,uid)
			local progress=deps.progress
			progress.Size=UDim2.fromScale(0,1)
			holdTween=tween:Create(
				progress,
				TweenInfo.new(duration or 1.2,Enum.EasingStyle.Linear),
				{Size=UDim2.fromScale(1,1)}
			)
			local current=holdTween
			current:Play()
			task.spawn(function()
				local playback=current.Completed:Wait()
				local root=eligibleCharacter()
				if
					api.enabled
					and serial==token
					and holdSerial==holdToken
					and hold==prompt
					and playback==Enum.PlaybackState.Completed
					and root
					and selectedHoldValid(prompt)
					and api.SelectedPetData
					and api.SelectedPetData.uid==uid
				then
					runCallbacks(handlers.triggered,token,uid)
				end
				if hold==prompt and holdSerial==holdToken then
					hold=nil
					holdTween=nil
					holdContext=nil
				end
			end)
		end
		local function targetPrompt(entry)
			if not entry then
				return
			end
			local spawn,plot=spawnFor(entry)
			if not spawn then
				return
			end
			local attachment=spawn:FindFirstChild("PromptAttachment")
			if attachment then
				for _,prompt in ipairs(attachment:GetChildren())do
					if prompt:IsA("ProximityPrompt")and prompt.Enabled and prompt.ActionText=="Steal"then
						return prompt
					end
				end
			end
			local best,difference
			for _,prompt in ipairs(plot:GetDescendants())do
				if prompt:IsA("ProximityPrompt")and prompt.Enabled and prompt.ActionText=="Steal"then
					local position=promptPosition(prompt)
					if position then
						local minimumY=spawn.Position.Y
							-(entry.name:lower():find("la secret combinasion",1,true)and 5 or 0)
						local horizontal=
							math.sqrt((position.X-spawn.Position.X)^2+(position.Z-spawn.Position.Z)^2)
						local dy=position.Y-minimumY
						if horizontal<5 and dy>0 and(not difference or dy<difference)then
							best,difference=prompt,dy
						end
					end
				end
			end
			return best
		end
		local quick={uid=nil,untilAt=0,spoofs=0,holds=0,offUntil=0}
		local function holdLength(prompt)
			local length=tonumber(prompt.HoldDuration)or 0
			if length<=0 then
				length=tonumber(_G.ElysiumStealHoldDuration)or 1.3
			end
			return length+(tonumber(_G.ElysiumSourceHoldMargin)or .1)
		end
		local function quickTarget(root)
			if _G.ElysiumSourceQuickGrab==false then
				return nil
			end
			local selected=api.SelectedPetData
			if not selected then
				return nil
			end
			if quick.uid~=selected.uid then
				quick.uid,quick.untilAt,quick.spoofs,quick.holds,quick.offUntil=selected.uid,0,0,0,0
			end
			if clock()<quick.offUntil then
				return nil
			end
			local prompt=targetPrompt(selected)
			if not prompt or not selectedHoldValid(prompt)or not donorCanFire(prompt,root,false)then
				return nil
			end
			return prompt
		end
		local function quickGrab(prompt)
			local selected=api.SelectedPetData
			local now=clock()
			if hold==prompt or now<quick.untilAt then
				return
			end
			local spoof=_G.ElysiumSpoofSteal
			if quick.spoofs<2 and type(spoof)=="function"then
				local ok,started=pcall(spoof,prompt,selected.plot,selected.slot)
				if ok and started then
					cancelHold()
					quick.spoofs+=1
					local delay=math.clamp(tonumber(_G.ElysiumSpoofGrabDelay)or .55,0,1.5)
					quick.untilAt=now+delay+.8
					api.phase="Quick grab: "..tostring(selected.name)
					local progress=deps.progress
					progress.Size=UDim2.fromScale(0,1)
					holdTween=tween:Create(
						progress,
						TweenInfo.new(math.max(delay,.05),Enum.EasingStyle.Linear),
						{Size=UDim2.fromScale(1,1)}
					)
					holdTween:Play()
					return
				end
			end
			local handlers=cacheCallbacks(prompt)
			if#handlers.began==0 or#handlers.triggered==0 or quick.holds>=2 then
				quick.offUntil=now+4
				quick.holds,quick.untilAt=0,0
				return
			end
			local length=holdLength(prompt)
			quick.holds+=1
			quick.untilAt=now+length+.35
			api.phase="Holding: "..tostring(selected.name)
			normalHold(prompt,length)
		end
		local function watchPrompt(prompt)
			if
				prompts[prompt]
				or not prompt:IsA("ProximityPrompt")
				or not prompt:FindFirstAncestor("AnimalPodiums")
			then
				return
			end
			prompts[prompt]=true
			local function immediate()
				local root=eligibleCharacter()
				if
					root
					and canFire(prompt,root)
					and(not lastBurst[prompt]or clock()-lastBurst[prompt]>=.08)
				then
					lastBurst[prompt]=clock()
					fire(prompt,25,0)
				end
			end
			connections[#connections+1]=prompt:GetPropertyChangedSignal("Enabled"):Connect(function()
				if prompt.Enabled then
					immediate()
				end
			end)
			connections[#connections+1]=prompt.AncestryChanged:Connect(function()
				if not prompt:IsDescendantOf(world)then
					prompts[prompt]=nil
					callbacks[prompt]=nil
					lastFire[prompt]=nil
					lastBurst[prompt]=nil
				end
			end)
			immediate()
		end
		function api.Select(uid)
			if uid and api.manualUid==uid then
				uid=nil
			end
			api.manualUid=uid
			cancelHold()
			local root=eligibleCharacter()
			if root then
				selectTarget(root)
			end
		end
		function api.PauseHold()
			serial+=1
			cancelHold()
		end
		function api.SetModes(nearest,instant,priority)
			api.priority=priority==true
			api.lastError=nil
			api.nearest=nearest==true
			api.instantWanted=instant==true
			api.instant=api.enabled and api.instantWanted
			api.manualUid=nil
			pulseUntil=nil
			lastPulse=clock()
			serial+=1
			cancelHold()
		end
		function api.Tick()
			if not api.enabled then
				return
			end
			if clock()-lastScan>=.5 then
				api.Scan()
			end
			local root=eligibleCharacter()
			if not root then
				cancelHold()
				_G.NEAREST_INSTANT_MODE=false
				api.phase="waiting for character / pickup / reset"
				return
			end
			selectTarget(root)
			local closePrompt=quickTarget(root)
			if closePrompt then
				pulseUntil=nil
				lastPulse=clock()
				api.instant=api.instantWanted
				_G.NEAREST_INSTANT_MODE=false
				if clock()-lastCallbackScan>=2 then
					lastCallbackScan=clock()
					for prompt in pairs(prompts)do
						cacheCallbacks(prompt,true)
					end
				end
				quickGrab(closePrompt)
				return
			end
			if hold and quick.uid and clock()<quick.untilAt then
				cancelHold()
				quick.untilAt=0
			end
			if api.instantWanted and not pulseUntil and clock()-lastPulse>=1.5 then
				api.instant=false
				pulseUntil=clock()+.05
			elseif pulseUntil and clock()>=pulseUntil then
				api.instant=api.instantWanted
				pulseUntil=nil
				lastPulse=clock()
				cancelHold("instant_refresh")
			end
			_G.NEAREST_INSTANT_MODE=api.nearest and api.instant and not api.manualUid
			if clock()-lastPoll>=api.GetSafePollRate()then
				local any=false
				for prompt in pairs(prompts)do
					if canFire(prompt,root)then
						any=true
						if inRange then
							fire(prompt,3,.12)
						end
					end
				end
				inRange=any
				lastPoll=clock()
			end
			if clock()-lastCallbackScan>=2 then
				lastCallbackScan=clock()
				for prompt in pairs(prompts)do
					cacheCallbacks(prompt,true)
				end
			end
			local selected=api.SelectedPetData
			api.phase=selected and("Target: "..selected.name)or"No source targets"
			if api.instant then
				cancelHold()
				deps.progress.Size=UDim2.fromScale(1,1)
			else
				local prompt=targetPrompt(selected)
				if prompt and selectedHoldValid(prompt)then
					normalHold(prompt)
				else
					cancelHold()
				end
			end
		end
		function api.Disable()
			api.enabled=false
			api.instant=false
			serial+=1
			cancelHold()
			for _,connection in ipairs(connections)do
				pcall(function()
					connection:Disconnect()
				end)
			end
			table.clear(connections)
			table.clear(prompts)
			table.clear(callbacks)
			table.clear(lastFire)
			table.clear(lastBurst)
			api.SelectedPetData=nil
			api.AllAnimalsCache={}
			api.manualUid=nil
			inRange=false
			pollBoostUntil=0
			_G.NEAREST_INSTANT_MODE=false
			api.phase="off"
		end
		function api.Enable()
			if api.enabled then
				return true
			end
			local enableSerial=serial
			if type(deps.firePrompt)~="function"or type(deps.getConnections)~="function"then
				return false,"fireproximityprompt/getconnections unavailable"
			end
			if not sync then
				local ok,errorMessage=pcall(function()
					local modules=deps.load()
					sync,animals,mutations,traits=modules.sync,modules.animals,modules.mutations,modules.traits
					assert(
						type(sync)=="table"and type(sync.GetTableFromChannel)=="function",
						"Synchronizer unavailable"
					)
					assert(
						type(animals)=="table"and type(mutations)=="table"and type(traits)=="table",
						"Animals/Mutations/Traits unavailable"
					)
				end)
				if not ok then
					sync=nil
					return false,tostring(errorMessage)
				end
			end
			if serial~=enableSerial then
				return false,"initialization cancelled"
			end
			api.enabled=true
			serial+=1
			lastPulse=clock()
			lastScan=-math.huge
			lastCallbackScan=-math.huge
			lastPoll=-math.huge
			api.instant=api.instantWanted
			pulseUntil=nil
			api.Scan()
			local root=eligibleCharacter()
			if root then
				selectTarget(root)
			end
			local plots=world:FindFirstChild("Plots")
			if plots then
				for _,prompt in ipairs(plots:GetDescendants())do
					if prompt:IsA("ProximityPrompt")then
						watchPrompt(prompt)
					end
				end
			end
			local function rescanSoon(object)
				if object.ClassName=="Model"or object:IsA("ProximityPrompt")then
					local floor=tonumber(_G.ElysiumGrabRescanFloor)or .12
					lastScan=math.min(lastScan,clock()-.5+floor)
				end
			end
			connections[#connections+1]=world.DescendantAdded:Connect(function(object)
				if not api.enabled then
					return
				end
				rescanSoon(object)
				if object:IsA("ProximityPrompt")then
					watchPrompt(object)
				end
			end)
			if world.DescendantRemoving then
				connections[#connections+1]=world.DescendantRemoving:Connect(function(object)
					if api.enabled then
						rescanSoon(object)
					end
				end)
			end
			connections[#connections+1]=player.CharacterRemoving:Connect(function()
				cancelHold()
				api.SelectedPetData=nil
				inRange=false
			end)
			api.phase="source scanner active"
			return true
		end
		return api
	end
	local progress=Instance.new("Frame")
	local player=ElysiumService("Players").LocalPlayer
	local engine=createHeadlessGrabEngine({
		player=player,
		players=ElysiumService("Players"),
		world=workspace,
		tween=ElysiumService("TweenService"),
		progress=progress,
		priorityTarget=function(previous)
			local pets=scanAllPetsCached(.2)or{}
			local function listed(uid)
				for _,pet in ipairs(pets)do
					if not pet.conveyor and pet.plot and pet.slot and _petUid(pet)==uid then return pet end
				end
			end
			local lockUid=_G.ElysiumStealTargetUID
			if type(lockUid)=="string"and lockUid~=""then
				local pet=listed(lockUid)
				if pet then return pet end
				local locked=_G.ElysiumStealTarget
				if type(locked)=="table"and locked.plot and locked.slot and _petUid(locked)==lockUid then
					return locked
				end
			end
			local best
			for _,pet in ipairs(pets)do
				if not pet.conveyor and pet.plot and pet.slot then best=pet;break end
			end
			local prevUid=type(previous)=="table"and previous.uid or nil
			if prevUid and(not best or _petUid(best)~=prevUid)and not listed(prevUid)then
				local now=os.clock()
				if _G.ElysiumGrabStickUid~=prevUid then
					_G.ElysiumGrabStickUid,_G.ElysiumGrabStickSince=prevUid,now
				end
				if now-(tonumber(_G.ElysiumGrabStickSince)or now)<(tonumber(_G.ElysiumGrabStickTime)or 3)then
					return{plot=previous.plot,slot=previous.slot,index=previous.index}
				end
			else
				_G.ElysiumGrabStickUid=nil
			end
			return best
		end,
		money=function(v)
			return tostring(v)
		end,
		firePrompt=fireproximityprompt,
		getConnections=getconnections,
		getIdentity=getthreadidentity,
		setIdentity=setthreadidentity,
		load=function()
			local rs=ElysiumService("ReplicatedStorage")
			local env=type(getgenv)=="function"and getgenv()or _G
			local bridge=env.ElysiumDataBridge or _G.ElysiumDataBridge
			local sync
			if bridge and bridge.game==game and bridge.workspace==workspace then
				sync={GetTableFromChannel=function(_,name)return bridge.plots[tostring(name)]end}
			else
				sync=require(rs.Packages.Synchronizer)
			end
			return{
				sync=sync,
				animals=require(rs.Datas.Animals),
				mutations=require(rs.Datas.Mutations),
				traits=require(rs.Datas.Traits),
			}
		end,
	})
	local generation=0
	_G.ElysiumSourceStealRuntime=engine
	local function setSourceMode(mode)
		generation+=1
		local mine=generation
		engine.Disable()
		progress.Size=UDim2.fromScale(0,1)
		if _G.ElysiumDisarmSteal then _G.ElysiumDisarmSteal()end
		_G.ElysiumSourceStealMode=mode
		_G.ElysiumSourceStealActive=mode~=nil
		_G.ElysiumStealMode=mode=="priority"and"priority"or nil
		_G.ElysiumStealTargetUID,_G.ElysiumStealTarget,_G.ElysiumExternalStealPet=nil,nil,nil
		if _G.ElysiumSaveSettings then pcall(_G.ElysiumSaveSettings)end
		if not mode then return end
		task.spawn(function()
			if generation~=mine or not _G.ElysiumSourceStealActive then return end
			engine.SetModes(mode=="nearest",true,mode=="priority")
			local ok,ready,reason=pcall(engine.Enable)
			if generation~=mine then return end
			if not ok or not ready then
				engine.Disable()
				_G.ElysiumSourceStealActive=false
				_G.ElysiumSourceStealMode,_G.ElysiumStealMode=nil,nil
				warn("[Elysium] "..mode.." could not start: "..tostring(ok and reason or ready))
			end
		end)
	end
	_G.ElysiumSetPriorityGrab=function(on)
		setSourceMode(on and"priority"or nil)
	end
	_G.ElysiumSetNearest=function(on)
		setSourceMode(on and"nearest"or"priority")
	end
	_G.ElysiumDisableSourceStealPanel=function()setSourceMode(nil)end
	_G.ElysiumOpenSourceStealPanel=function()
		_G.ElysiumSetNearest(not(_G.ElysiumSourceStealActive and _G.ElysiumSourceStealMode=="nearest"))
	end
	if _G.ElysiumStealMode=="priority"then setSourceMode("priority")end
	local connection=ElysiumService("RunService").Heartbeat:Connect(function()
		if not _G.ElysiumSourceStealActive then
			return
		end
		if _G.ElysiumSlotPrechargeActive then
			return
		end
		local ok=pcall(engine.Tick)
		if not ok then
			setSourceMode(nil)
			warn("[Elysium] Shared Auto Grab stopped after a runtime error")
			return
		end
		if _G.ElysiumRenderNearestProgress then
			local pet=engine.SelectedPetData
			_G.ElysiumExternalStealPet=pet
			_G.ElysiumRenderNearestProgress(pet and pet.name or(_G.ElysiumSourceStealMode=="priority"and"Priority"or"Nearest"),progress.Size.X.Scale)
		end
	end)
	_G.ElysiumSourceStealPanelAPI={
		Destroy=function()
			setSourceMode(nil)
			connection:Disconnect()
			progress:Destroy()
		end,
	}
end
task.defer(function()
	local host=(gethui and gethui())or ElysiumService("CoreGui")
	local old=host:FindFirstChild("ElysiumDiscordBadge")
	if old then
		old:Destroy()
	end
	local gui=Instance.new("ScreenGui")
	gui.Name="ElysiumDiscordBadge"
	gui.ResetOnSpawn=false
	gui.IgnoreGuiInset=true
	gui.DisplayOrder=9994
	gui.Parent=host
	local card=Instance.new("TextButton",gui)
	card.Name="DiscordCard"
	card.AnchorPoint=Vector2.new(0,1)
	card.Position=UDim2.new(0,16,1,-30)
	card.Size=UDim2.fromOffset(300,90)
	card.BackgroundColor3=Color3.fromRGB(9,9,9)
	card.BackgroundTransparency=.04
	card.BorderSizePixel=0
	card.Text=""
	card.AutoButtonColor=false
	local corner=Instance.new("UICorner",card)
	corner.CornerRadius=UDim.new(0,10)
	local stroke=Instance.new("UIStroke",card)
	stroke.Color=Color3.fromRGB(201,201,201)
	stroke.Transparency=.25
	stroke.Thickness=1.5
	local gradient=Instance.new("UIGradient",card)
	gradient.Rotation=135
	gradient.Color=ColorSequence.new(Color3.fromRGB(19,19,19),Color3.fromRGB(6,6,6))
	local title=Instance.new("TextLabel",card)
	title.Position=UDim2.fromOffset(16,10)
	title.Size=UDim2.new(1,-100,0,20)
	title.BackgroundTransparency=1
	title.Text="leaked by Sticky"
	title.Font=Enum.Font.GothamBold
	title.TextSize=13
	title.TextColor3=Color3.fromRGB(198,198,198)
	title.TextXAlignment=Enum.TextXAlignment.Left
	local link=Instance.new("TextLabel",card)
	link.Position=UDim2.fromOffset(16,34)
	link.Size=UDim2.new(1,-32,0,24)
	link.BackgroundTransparency=1
	link.Text="discord.gg/Z7vPrxecnJ"
	link.Font=Enum.Font.GothamBold
	link.TextSize=16
	link.TextColor3=Color3.fromRGB(255,255,255)
	link.TextXAlignment=Enum.TextXAlignment.Left
	local copyBadge=Instance.new("TextLabel",card)
	copyBadge.Position=UDim2.new(1,-72,0,10)
	copyBadge.Size=UDim2.fromOffset(56,22)
	copyBadge.BackgroundColor3=Color3.fromRGB(201,201,201)
	copyBadge.BorderSizePixel=0
	copyBadge.Text="COPY"
	copyBadge.Font=Enum.Font.GothamBold
	copyBadge.TextSize=10
	copyBadge.TextColor3=Color3.fromRGB(15,15,15)
	local copyCorner=Instance.new("UICorner",copyBadge)
	copyCorner.CornerRadius=UDim.new(0,6)
	local hint=Instance.new("TextLabel",card)
	hint.Position=UDim2.fromOffset(16,63)
	hint.Size=UDim2.new(1,-32,0,16)
	hint.BackgroundTransparency=1
	hint.Text="Click to copy invite"
	hint.Font=Enum.Font.GothamMedium
	hint.TextSize=11
	hint.TextColor3=Color3.fromRGB(192,192,192)
	hint.TextXAlignment=Enum.TextXAlignment.Left
	local connection=card.MouseButton1Click:Connect(function()
		local copy=setclipboard or toclipboard
		if type(copy)~="function"then
			return
		end
		local ok=pcall(copy,"https://discord.gg/Z7vPrxecnJ")
		if ok then
			hint.Text="Invite copied!"
			task.delay(1.5,function()
				if hint.Parent then
					hint.Text="Click to copy invite"
				end
			end)
		end
	end)
	gui.Destroying:Connect(function()
		connection:Disconnect()
	end)
end)
do
	local busy=false
	_G.ElysiumRecoverMovement=function(reason)
		if busy then
			return
		end
		busy=true
		_G.ElysiumTPStop=true
		if _G.ElysiumSetAutoBuy then
			pcall(_G.ElysiumSetAutoBuy,false)
		end
		if _G.ElysiumSetAutoTP then
			pcall(_G.ElysiumSetAutoTP,false)
		end
		_G.ElysiumTPStop=true
		if _G.ElysiumPrepareMovementReset then
			pcall(_G.ElysiumPrepareMovementReset)
		end
		local p=ElysiumService("Players").LocalPlayer
		local c=p.Character
		if c then
			for _,v in ipairs(c:GetDescendants())do
				if v.Name=="ElysiumRunwayFollow"then
					v:Destroy()
				end
			end
			local h=c:FindFirstChildOfClass("Humanoid")
			if h then
				h:SetStateEnabled(Enum.HumanoidStateType.Dead,true)
			end
		end
		_G.ElysiumMovementFault=tostring(reason or"Movement stopped")
		busy=false
	end
end
do
	local realGlobals=_G
	local players=ElysiumService("Players")
	local active,requested,latestPets=nil,nil,nil
	local transitioning=false
	local incompleteSince=nil
	local function movementBusy()
		if realGlobals.Elysium_IsResetting then
			return true
		end
		if realGlobals.ElysiumHoldingForPickup==true then
			return false
		end
		return realGlobals.ElysiumIsTeleporting and realGlobals.ElysiumIsTeleporting()
	end
	local function restore()
		if active then
			active:Stop()
			active=nil
		end
	end
	local function groundName(object)
		local name=object.Name:lower()
		return name=="ground"
			or name=="ground_left"
			or name=="ground_right"
			or name:find("dig",1,true)~=nil
			or name:find("excavat",1,true)~=nil
			or name:find("admin",1,true)~=nil
	end
	local function holdsGround(inst)
		for _,child in ipairs(inst:GetDescendants())do
			if groundName(child)and(child:IsA("BasePart")or child:IsA("Model")or child:IsA("Folder"))then
				return true
			end
		end
		return false
	end
	local function plotBox(session,plot)
		local box=session.plotBoxes[plot]
		if box then
			return box
		end
		local ok,cf,size=pcall(function()
			return plot:GetBoundingBox()
		end)
		if ok and cf and size and size.X>1 and size.Z>1 and size.X<400 and size.Z<400 then
			box={cf=cf,size=size}
			session.plotBoxes[plot]=box
		end
		return box
	end
	local function standingInPlot(session,plot)
		if realGlobals.ElysiumKeepStandingPlot==false then
			return false
		end
		local lp=players.LocalPlayer
		local char=lp and lp.Character
		local root=char and char:FindFirstChild("HumanoidRootPart")
		if not root then
			return false
		end
		local okPivot,pivot=pcall(function()
			return plot:GetPivot()
		end)
		if okPivot and pivot and(pivot.Position-root.Position).Magnitude>320 then
			return false
		end
		local box=plotBox(session,plot)
		if not box then
			return false
		end
		local stealing=lp:GetAttribute("Stealing")==true
		local margin=stealing and(tonumber(realGlobals.ElysiumKeepPlotMarginSteal)or 14)
			or(tonumber(realGlobals.ElysiumKeepPlotMargin)or 6)
		local rel=box.cf:PointToObjectSpace(root.Position)
		local half=box.size*.5
		return math.abs(rel.X)<=half.X+margin
			and math.abs(rel.Z)<=half.Z+margin
			and rel.Y>=-half.Y-12
			and rel.Y<=half.Y+40
	end
	local MAX_DEFERRED=20000
	local function makeSession(mine,winner)
		local session={
			alive=true,
			hidden={},
			hiddenPlots={},
			spared={},
			plotBoxes=setmetatable({},{__mode="k"}),
			pending={},
			deferred={},
			connections={},
			properties={},
			mine=mine,
			winner=winner,
		}
		function session:Busy()
			return not self.alive or realGlobals.ElysiumOptimizerMode~="default"or movementBusy()
		end
		function session:Protected(inst,allowOwnPlot)
			local at=inst
			while at and at~=workspace do
				if
					at:IsA("Terrain")
					or at:GetAttribute("ElysiumLocalInvisVisual")==true
					or at:GetAttribute("ElysiumOptimizerMarker")==true
				then
					return true
				end
				local parent=at.Parent
				if not allowOwnPlot and parent and parent.Name=="Plots"and at.Name==self.mine then
					return true
				end
				if at==players.LocalPlayer.Character then
					return true
				end
				at=parent
			end
			return false
		end
		function session:Hide(inst,allowOwnPlot)
			if not self.alive or realGlobals.ElysiumOptimizerMode~="default"then
				return
			end
			if not inst or not inst.Parent or self.hidden[inst]then
				return
			end
			if movementBusy()then
				self.pending[inst]=allowOwnPlot and 2 or self.pending[inst]or 1
				return
			end
			if self:Protected(inst,allowOwnPlot)then
				return
			end
			local at=inst
			while at and at~=workspace do
				if groundName(at)then
					return
				end
				at=at.Parent
			end
			local parent=inst.Parent
			if parent.Name=="Plots"and plotBox(self,inst)and standingInPlot(self,inst)then
				self.spared[inst]=allowOwnPlot and 2 or 1
				return
			end
			if(parent==workspace or parent.Name=="Map")and holdsGround(inst)then
				self:HideAround(inst,allowOwnPlot)
				return
			end
			local ok=pcall(function()
				inst.Parent=nil
			end)
			if ok then
				self.hidden[inst]=parent
				if parent.Name=="Plots"then
					self.hiddenPlots[inst.Name]=inst
				end
			end
		end
		function session:HideAround(container,allowOwnPlot)
			for _,child in ipairs(container:GetChildren())do
				if groundName(child)then
				elseif holdsGround(child)then
					self:HideAround(child,allowOwnPlot)
				else
					self:Hide(child,allowOwnPlot)
				end
			end
		end
		function session:Show(inst)
			local parent=inst and self.hidden[inst]
			if parent==nil then
				return
			end
			self.hidden[inst]=nil
			if self.hiddenPlots[inst.Name]==inst then
				self.hiddenPlots[inst.Name]=nil
			end
			pcall(function()
				if inst.Parent==nil then
					inst.Parent=parent
				end
			end)
		end
		function session:KeepStandingPlot()
			if not self.alive or realGlobals.ElysiumOptimizerMode~="default"or movementBusy()then
				return
			end
			for _,inst in pairs(self.hiddenPlots)do
				if inst.Parent==nil and self.hidden[inst]~=nil and standingInPlot(self,inst)then
					self:Show(inst)
					self.spared[inst]=1
				end
			end
			for inst,kind in pairs(self.spared)do
				if inst.Parent==nil then
					self.spared[inst]=nil
				elseif not standingInPlot(self,inst)then
					self.spared[inst]=nil
					if inst.Name~=self.winner and inst.Name~=self.mine then
						self:Hide(inst,kind==2)
					end
				end
			end
		end
		function session:HideAnimal(inst)
			if self:Busy()or not inst or not inst.Parent or self.hidden[inst]then
				return
			end
			local parent=inst.Parent
			if pcall(function()
				inst.Parent=nil
			end)then
				self.hidden[inst]=parent
			end
		end
		function session:Set(inst,key,value)
			if self:Busy()or self:Protected(inst)then
				return
			end
			self.properties[inst]=self.properties[inst]or{}
			if self.properties[inst][key]==nil then
				self.properties[inst][key]={value=inst[key]}
			end
			pcall(function()
				inst[key]=value
			end)
		end
		function session:Connect(signal,callback)
			local connection=signal:Connect(function(...)
				if not self.alive or realGlobals.ElysiumOptimizerMode~="default"then
					return
				end
				if movementBusy()then
					local list=self.deferred
					if#list<MAX_DEFERRED then
						local item=table.pack(...)
						item.fn=callback
						list[#list+1]=item
					end
					return
				end
				callback(...)
			end)
			self.connections[#self.connections+1]=connection
			return connection
		end
		function session:Flush()
			if not self.alive or movementBusy()then
				return
			end
			local list=self.deferred
			if#list>0 then
				self.deferred={}
				for i=1,#list do
					local item=list[i]
					pcall(item.fn,table.unpack(item,1,item.n))
				end
			end
			if next(self.pending)then
				local pend=self.pending
				self.pending={}
				for inst,kind in pairs(pend)do
					local isWinnerPlot=self.winner~=nil and inst.Name==self.winner
						and inst.Parent~=nil and inst.Parent.Name=="Plots"
					if inst.Parent and not isWinnerPlot then
						self:Hide(inst,kind==2)
					end
				end
			end
		end
		function session:Stop()
			self.alive=false
			for _,connection in ipairs(self.connections)do
				connection:Disconnect()
			end
			for inst,parent in pairs(self.hidden)do
				pcall(function()
					if inst.Parent==nil then
						inst.Parent=parent
					end
				end)
			end
			for inst,props in pairs(self.properties)do
				for key,old in pairs(props)do
					pcall(function()
						inst[key]=old.value
					end)
				end
			end
			if self.zoneFolder then
				pcall(function()
					self.zoneFolder:Destroy()
				end)
				self.zoneFolder=nil
			end
			table.clear(self.hidden)
			table.clear(self.hiddenPlots)
			table.clear(self.spared)
			table.clear(self.pending)
			table.clear(self.deferred)
			table.clear(self.connections)
			table.clear(self.properties)
		end
		return session
	end
	local function startDonor(session)
		local _G=setmetatable(
			{__SXE_MyPlot=session.mine,__SXE_KeepPlot=session.winner},
			{__index=realGlobals}
		)
		local function applyDonor()
			local Players=ElysiumService("Players")
			local Lighting=ElysiumService("Lighting")
			local LP=Players.LocalPlayer
			local function kill(inst)
				session:Hide(inst)
			end
			local MACHINE_WORDS={"machine","craft","fuse","fusion","incubator","wheel","shop","beehive","portal","traders","board",}
			local function isMachineName(name)
				local lower=string.lower(tostring(name))
				if string.find(lower,"admin",1,true)then
					return false
				end
				for _,word in ipairs(MACHINE_WORDS)do
					if string.find(lower,word,1,true)then
						return true
					end
				end
				return false
			end
			local function footprint(root)
				local parts={}
				if root:IsA("BasePart")then
					parts[1]=root
				end
				for _,d in ipairs(root:GetDescendants())do
					if d:IsA("BasePart")then
						parts[#parts+1]=d
					end
				end
				local minX,minY,minZ,maxX,maxY,maxZ
				for _,part in ipairs(parts)do
					if part.CanCollide then
						local cf,s=part.CFrame,part.Size
						local x,y,z=cf.XVector,cf.YVector,cf.ZVector
						local ex=(math.abs(x.X)*s.X+math.abs(y.X)*s.Y+math.abs(z.X)*s.Z)/2
						local ey=(math.abs(x.Y)*s.X+math.abs(y.Y)*s.Y+math.abs(z.Y)*s.Z)/2
						local ez=(math.abs(x.Z)*s.X+math.abs(y.Z)*s.Y+math.abs(z.Z)*s.Z)/2
						local p=cf.Position
						minX=math.min(minX or math.huge,p.X-ex)
						maxX=math.max(maxX or-math.huge,p.X+ex)
						minY=math.min(minY or math.huge,p.Y-ey)
						maxY=math.max(maxY or-math.huge,p.Y+ey)
						minZ=math.min(minZ or math.huge,p.Z-ez)
						maxZ=math.max(maxZ or-math.huge,p.Z+ez)
					end
				end
				if not minX then
					return nil
				end
				return{minX=minX,minY=minY,minZ=minZ,maxX=maxX,maxY=maxY,maxZ=maxZ}
			end
			local zoneParams=RaycastParams.new()
			zoneParams.FilterType=Enum.RaycastFilterType.Exclude
			local function zoneFolder()
				local folder=session.zoneFolder
				if folder and folder.Parent then
					return folder
				end
				folder=Instance.new("Folder")
				folder.Name="ElysiumNoGoZones"
				folder:SetAttribute("ElysiumOptimizerMarker",true)
				folder.Parent=workspace
				session.zoneFolder=folder
				return folder
			end
			local function addZone(box)
				local sx,sz=box.maxX-box.minX,box.maxZ-box.minZ
				if sx<.5 or sz<.5 or sx>200 or sz>200 then
					return
				end
				local cx,cz=(box.minX+box.maxX)/2,(box.minZ+box.maxZ)/2
				local folder=zoneFolder()
				local ignore={folder}
				if LP and LP.Character then
					ignore[#ignore+1]=LP.Character
				end
				zoneParams.FilterDescendantsInstances=ignore
				local floorY=box.minY
				local hit=workspace:Raycast(
					Vector3.new(cx,box.maxY+2,cz),
					Vector3.new(0,-(box.maxY-box.minY)-40,0),
					zoneParams
				)
				if hit then
					floorY=hit.Position.Y
				end
				local part=Instance.new("Part")
				part.Name="NoGoZone"
				part.Anchored=true
				part.CanCollide=false
				part.CanTouch=false
				part.CanQuery=false
				part.CastShadow=false
				part.Material=Enum.Material.Neon
				part.Color=Color3.fromRGB(255,40,40)
				part.Transparency=.25
				part.Size=Vector3.new(sx,.2,sz)
				part.CFrame=CFrame.new(cx,floorY+.12,cz)
				part.Parent=folder
			end
			local zoned=setmetatable({},{__mode="k"})
			local function killMarked(inst,allowOwnPlot)
				if not(inst and inst.Parent)then
					return
				end
				local machines={}
				local function visit(x)
					if isMachineName(x.Name)and(x:IsA("Model")or x:IsA("BasePart")or x:IsA("Folder"))then
						if not zoned[x]then
							machines[#machines+1]={inst=x,box=footprint(x)}
						end
						return
					end
					for _,child in ipairs(x:GetChildren())do
						visit(child)
					end
				end
				visit(inst)
				session:Hide(inst,allowOwnPlot)
				for _,m in ipairs(machines)do
					local gone=not m.inst:IsDescendantOf(workspace)or session.pending[inst]~=nil
					if gone and m.box then
						zoned[m.inst]=true
						pcall(addZone,m.box)
					elseif gone then
						task.delay(3,function()
							if session.alive and not zoned[m.inst]then
								local box=footprint(m.inst)
								if box then
									zoned[m.inst]=true
									pcall(addZone,box)
								end
							end
						end)
					end
				end
			end
			session:Set(workspace.Terrain,"Decoration",false)
			local WS_KILL={
				FriendPanel=true,
				Cash=true,
				Unlock=true,
				Purchases=true,
				PlotSign=true,
				CashPad=true,
				InvisibleWalls=true,
				Multiplier=true,
				Slope=true,
				IncubatorMachine=true,
				FuseMachine=true,
				XzFusionMECircuit6zX=true,
				HalloweenFuseMachine=true,
				JumpLTMMachine=true,
				RobuxShop=true,
				SoccerScoreBoard=true,
				CrystalSpinWheel=true,
				EclipseWheel=true,
				EclipseSpinWheel=true,
				["Eclipse Wheel"]=true,
				Beehive=true,
				CraftingMachine=true,
				Shop=true,
				Road=true,
				EventBoard=true,
				TradePlazaPortal=true,
				LosTraders=true,
				RNGMachine=true,
				Present=true,
				StPatricksPot=true,
				ShopNPCRobuxIdle=true,
				RoadPanel=true,
				Honey=true,
				Trap=true,
				Events=true,
				Sounds=true,
				rods=true,
				Dev=true,
				ToolsAdds=true,
				__PROJECTILES=true,
				CrystalMap=true,
				SpawnLocation=true,
				UFO=true,
				Interacts=true,
			}
			local PLOT_KEEP={
				Skin=true,
				Laser=true,
				AnimalPodiums=true,
				DeliveryHitbox=true,
				StealHitbox=true,
				AnimalTarget=true,
				MainRoot=true,
				Floor=true,
				Spawn=true,
				Door=true,
				Hitbox=true,
				Base=true,
				Wall=true,
				Roof=true,
				SecondFloor=true,
				ThirdFloor=true,
				["structure base home"]=true,
				Unlock=true,
			}
			local PLOT_NUKE={
				FriendPanel=true,
				Cash=true,
				Purchases=true,
				PlotSign=true,
				CashPad=true,
				InvisibleWalls=true,
				Multiplier=true,
				LaserHitbox=true,
				Events=true,
				Sounds=true,
				Slope=true,
			}
			local BODY_PART={
				HumanoidRootPart=true,
				Head=true,
				Torso=true,
				UpperTorso=true,
				LowerTorso=true,
				LeftUpperArm=true,
				LeftLowerArm=true,
				LeftHand=true,
				RightUpperArm=true,
				RightLowerArm=true,
				RightHand=true,
				LeftUpperLeg=true,
				LeftLowerLeg=true,
				LeftFoot=true,
				RightUpperLeg=true,
				RightLowerLeg=true,
				RightFoot=true,
				["Left Arm"]=true,
				["Right Arm"]=true,
				["Left Leg"]=true,
				["Right Leg"]=true,
			}
			local CHAR_KEEP_CLASS={
				Humanoid=true,
				Animator=true,
				Attachment=true,
				Motor6D=true,
				AnimationConstraint=true,
				BallSocketConstraint=true,
				Weld=true,
				WeldConstraint=true,
			}
			local MAP_KEEP={Ground=true,Ground_Left=true,Ground_Right=true}
			local PART_CLASS={
				Part=true,
				MeshPart=true,
				UnionOperation=true,
				WedgePart=true,
				CornerWedgePart=true,
				TrussPart=true,
				SpawnLocation=true,
				Seat=true,
				VehicleSeat=true,
			}
			local function underUnlock(d)
				local x=d
				for _=1,12 do
					if not x then
						return false
					end
					if x.Name=="Unlock"then
						return true
					end
					if x==workspace then
						return false
					end
					x=x.Parent
				end
				return false
			end
			local function isMine(inst)
				if not(LP and inst)then
					return false
				end
				if inst==LP.Character or inst.Name==LP.Name then
					return true
				end
				return false
			end
			local function isVisualJunk(d)
				local cn=d.ClassName
				return cn=="Beam"
					or cn=="Trail"
					or cn=="ParticleEmitter"
					or cn=="PointLight"
					or cn=="SpotLight"
					or cn=="SurfaceLight"
					or cn=="Fire"
					or cn=="Smoke"
					or cn=="Sparkles"
					or cn=="BillboardGui"
					or cn=="SurfaceGui"
					or cn=="Highlight"
					or cn=="Decal"
					or cn=="Texture"
			end
			local function isSkinJunk(d)
				if not d then
					return false
				end
				if isVisualJunk(d)then
					return true
				end
				return PART_CLASS[d.ClassName]==true and not d.CanCollide
			end
			local function isPet(inst)
				if not inst or inst.ClassName~="Model"then
					return false
				end
				return inst:FindFirstChild("FakeRootPart")~=nil or inst:FindFirstChild("RootPart")~=nil
			end
			local function stripSkin(skin)
				if not(skin and skin.Parent)then
					return
				end
				local dd=skin:GetDescendants()
				local dump={}
				for i=1,#dd do
					if isSkinJunk(dd[i])then
						dump[#dump+1]=dd[i]
					end
				end
				for i=1,#dump do
					kill(dump[i])
				end
			end
			local function skipLaserStrip(plot)
				local keep=_G.__SXE_KeepPlot
				if not keep then
					return true
				end
				return plot and tostring(plot.Name)==tostring(keep)
			end
			local function skipTimerStrip(plot)
				return skipLaserStrip(plot)
			end
			local function plotOf(d)
				local x=d
				for _=1,16 do
					if not x then
						return nil
					end
					local p=x.Parent
					if p and p.Name=="Plots"then
						return x
					end
					x=p
				end
				return nil
			end
			local function isRemainingTimeGui(d)
				if not d then
					return false
				end
				local x=d
				for _=1,16 do
					if not x then
						break
					end
					if x.Name=="RemainingTime"then
						return true
					end
					x=x.Parent
				end
				local cn=d.ClassName
				if cn=="BillboardGui"or cn=="SurfaceGui"then
					local hit
					pcall(function()
						hit=d:FindFirstChild("RemainingTime",true)
					end)
					if hit then
						return true
					end
				end
				return false
			end
			local function stripPurchasesKeepTimer(purch)
				if not(purch and purch.Parent)then
					return
				end
				local kids=purch:GetChildren()
				for i=1,#kids do
					local ch=kids[i]
					if ch.Name~="PlotBlock"then
						kill(ch)
					else
						local dd=ch:GetDescendants()
						for j=1,#dd do
							local d=dd[j]
							local cn=d.ClassName
							if(cn=="BillboardGui"or cn=="SurfaceGui")and not isRemainingTimeGui(d)then
								kill(d)
							end
						end
					end
				end
			end
			local laserPend={}
			local function stripLaser(laser)
				if true then return end
				if not(laser and laser.Parent)then
					return
				end
				if skipLaserStrip(laser.Parent)then
					return
				end
				local bars={}
				local beamPart={}
				local dd=laser:GetDescendants()
				for i=1,#dd do
					local d=dd[i]
					if d.ClassName=="Beam"then
						local a0,a1=d.Attachment0,d.Attachment1
						local p0=a0 and a0.Parent
						local p1=a1 and a1.Parent
						if p0 and p0:IsA("BasePart")then
							beamPart[p0]=true
						end
						if p1 and p1:IsA("BasePart")then
							beamPart[p1]=true
						end
					elseif d:IsA("BasePart")then
						bars[#bars+1]=d
					end
				end
				if#bars>0 then
					local chosen={}
					for i=1,#bars do
						if beamPart[bars[i]]then
							chosen[#chosen+1]=bars[i]
						end
					end
					if#chosen==0 then
						for i=1,#bars do
							local d=bars[i]
							local s=d.Size
							local mx=math.max(s.X,s.Y,s.Z)
							local mn=math.min(s.X,s.Y,s.Z)
							local neon=false
							pcall(function()
								neon=d.Material==Enum.Material.Neon or d.Material==Enum.Material.ForceField
							end)
							if neon or(mn<=1.5 and mx>=3)then
								chosen[#chosen+1]=d
							end
						end
					end
					if#chosen==0 then
						chosen=bars
					end
					local keep=chosen[1]
					if keep then
						for i=1,#bars do
							if bars[i]~=keep then
								kill(bars[i])
							end
						end
						pcall(function()
							if PART_CLASS[laser.ClassName]then
								session:Set(laser,"CanCollide",false)
								session:Set(laser,"CanTouch",false)
							end
							session:Set(keep,"CanCollide",false)
							session:Set(keep,"CanTouch",false)
						end)
					end
				end
			end
			local function queueStripLaser(laser)
				if not laser or laserPend[laser]then
					return
				end
				laserPend[laser]=true
				task.defer(function()
					laserPend[laser]=nil
					stripLaser(laser)
				end)
			end
			local function stripPetVfx(pet)
				if not pet then
					return
				end
				local dd=pet:GetDescendants()
				local dump={}
				for i=1,#dd do
					local d=dd[i]
					local n=d.Name
					local cn=d.ClassName
					if
						n=="VfxInstance"
						or n=="_VfxInstance"
						or n=="AnimationController"
						or cn=="ParticleEmitter"
						or cn=="Beam"
						or cn=="Trail"
						or cn=="Fire"
						or cn=="Smoke"
						or cn=="Sparkles"
						or cn=="Animator"
						or cn=="AnimationController"
						or cn=="Bone"
						or cn=="BillboardGui"
						or cn=="SurfaceGui"
					then
						dump[#dump+1]=d
					end
				end
				for i=1,#dump do
					kill(dump[i])
				end
			end
			_G.SXE_StripPetVfx=stripPetVfx
			local function isCharJunk(d)
				if not d then
					return false
				end
				local cn=d.ClassName
				if cn=="PathfindingModifier"then
					return false
				end
				if cn=="WrapTarget"or cn=="WrapLayer"then
					return true
				end
				if cn=="Shirt"or cn=="ShirtGraphic"then
					return true
				end
				if cn=="NoCollisionConstraint"then
					return true
				end
				local nm=d.Name
				if nm=="__HITBOX"or nm=="OriginalPosition"or nm=="OriginalSize"then
					return true
				end
				if CHAR_KEEP_CLASS[cn]then
					return false
				end
				if BODY_PART[nm]then
					return false
				end
				return true
			end
			local function isUuidName(n)
				return type(n)=="string"
					and#n==36
					and string.match(
							n,
							"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$"
						)
						~=nil
			end
			local function isOtherAvatar(char)
				if not(char and char.ClassName=="Model")then
					return false
				end
				if isMine(char)then
					return false
				end
				if isPet(char)then
					return false
				end
				local n=char.Name
				if type(n)=="string"and string.sub(n,-6)=="_Clone"then
					return false
				end
				if Players:GetPlayerFromCharacter(char)then
					return true
				end
				if Players:FindFirstChild(n)then
					return true
				end
				return char:FindFirstChildOfClass("Humanoid")~=nil
			end
			local hookedChars={}
			local function stripOtherChar(char)
				if session:Busy()then
					return
				end
				if not(char and char.Parent)or isMine(char)or not isOtherAvatar(char)then
					return
				end
				local function sweep()
					local dd=char:GetDescendants()
					local dump={}
					for i=1,#dd do
						if isCharJunk(dd[i])then
							dump[#dump+1]=dd[i]
						end
					end
					for i=1,#dump do
						kill(dump[i])
					end
				end
				sweep()
				if hookedChars[char]then
					return
				end
				hookedChars[char]=true
				session:Connect(char.DescendantAdded,function(d)
					if session:Busy()then
						return
					end
					if d and d.Parent and not isMine(char)and isCharJunk(d)then
						kill(d)
					end
				end)
			end
			local strippedPlots={}
			_G.__SXE_StrippedPlots=strippedPlots
			local function near(a,b)
				return math.abs(a-b)<.2
			end
			local function isPlotPadPart(d)
				if not d or PART_CLASS[d.ClassName]~=true then
					return false
				end
				if d.Name=="structure base home"or d.Name=="Spawn"then
					return false
				end
				local s=d.Size
				if near(s.X,4)and near(s.Y,1)and near(s.Z,4)then
					return true
				end
				if near(s.X,2)and near(s.Y,.5)and near(s.Z,2)then
					return true
				end
				return false
			end
			local function isPodiumPlate(d)
				if not d or PART_CLASS[d.ClassName]~=true then
					return false
				end
				if d.Name=="Spawn"then
					return false
				end
				local s=d.Size
				if near(s.X,6)and near(s.Y,.2)and near(s.Z,6)then
					return true
				end
				if near(s.X,4)and near(s.Y,.2)and near(s.Z,4)then
					return true
				end
				return false
			end
			local function stripPlotDecor(dec)
				if not(dec and dec.Parent)then
					return
				end
				local dump={}
				local function walk(x)
					local kids=x:GetChildren()
					for i=1,#kids do
						local d=kids[i]
						local cn=d.ClassName
						local nm=d.Name
						if nm=="Spawn"or nm=="PromptAttachment"or cn=="ProximityPrompt"then
						elseif cn=="Model"and isPet(d)then
						elseif cn=="Beam"or cn=="PointLight"then
							dump[#dump+1]=d
						elseif isPlotPadPart(d)then
							dump[#dump+1]=d
						else
							walk(d)
						end
					end
				end
				walk(dec)
				for i=1,#dump do
					kill(dump[i])
				end
			end
			local function stripPodiumPlates(pods)
				if not(pods and pods.Parent)then
					return
				end
				local dump={}
				local function scan(folder)
					if not folder then
						return
					end
					local dd=folder:GetDescendants()
					for i=1,#dd do
						local d=dd[i]
						if
							d.Name~="Spawn"
							and d.Name~="PromptAttachment"
							and d.ClassName~="ProximityPrompt"
							and isPodiumPlate(d)
						then
							dump[#dump+1]=d
						end
					end
				end
				local slots=pods:GetChildren()
				for i=1,#slots do
					local slot=slots[i]
					local base=slot:FindFirstChild("Base")
					if base then
						scan(base:FindFirstChild("Decorations"))
					end
					scan(slot:FindFirstChild("Decorations"))
				end
				for i=1,#dump do
					kill(dump[i])
				end
			end
			local function handlePlotChild(plot,ch)
				if not(ch and ch.Parent)then
					return
				end
				local n=ch.Name
				if n=="Skin"then
					stripSkin(ch)
					return
				end
				if n=="Laser"then
					if not skipLaserStrip(plot)then
						stripLaser(ch)
					end
					return
				end
				if n=="AnimalPodiums"then
					stripPodiumPlates(ch)
					return
				end
				if n=="Decorations"then
					stripPlotDecor(ch)
					return
				end
				if n=="Purchases"then
					if skipTimerStrip(plot)then
						stripPurchasesKeepTimer(ch)
					else
						kill(ch)
					end
					return
				end
				if PLOT_KEEP[n]then
					return
				end
				if PLOT_NUKE[n]then
					kill(ch)
					return
				end
				if isMachineName(n)and not isPet(ch)then
					killMarked(ch)
					return
				end
				if isPet(ch)then
					local set=_G.SXE_PrioSet
					if type(set)=="table"and set[string.lower(n)]~=true then
						kill(ch)
					else
						stripPetVfx(ch)
					end
					return
				end
			end
			local function stripPlotInteriorFast(plot)
				if not(plot and plot.Parent)then
					return
				end
				if _G.__SXE_MyPlot and plot.Name==_G.__SXE_MyPlot then
					return
				end
				strippedPlots[plot.Name]=true
				local kids=plot:GetChildren()
				for i=1,#kids do
					local ch=kids[i]
					if ch and ch.Parent then
						local n=ch.Name
						if n=="Skin"or n=="Laser"or n=="AnimalPodiums"or n=="Decorations"then
						elseif n=="Purchases"and skipTimerStrip(plot)then
							stripPurchasesKeepTimer(ch)
						elseif PLOT_KEEP[n]then
						elseif PLOT_NUKE[n]then
							kill(ch)
						elseif isMachineName(n)and not isPet(ch)then
							killMarked(ch)
						elseif isPet(ch)then
							local set=_G.SXE_PrioSet
							if type(set)=="table"and set[string.lower(n)]~=true then
								kill(ch)
							end
						end
					end
				end
			end
			local function stripPlotVisual(plot)
				if not(plot and plot.Parent)then
					return
				end
				if _G.__SXE_MyPlot and plot.Name==_G.__SXE_MyPlot then
					return
				end
				local skin=plot:FindFirstChild("Skin")
				if skin then
					stripSkin(skin)
				end
				local laser=plot:FindFirstChild("Laser")
				if laser and not skipLaserStrip(plot)then
					stripLaser(laser)
				end
				local pods=plot:FindFirstChild("AnimalPodiums")
				if pods then
					stripPodiumPlates(pods)
				end
				local dec=plot:FindFirstChild("Decorations")
				if dec then
					stripPlotDecor(dec)
				end
				local kids=plot:GetChildren()
				for i=1,#kids do
					local ch=kids[i]
					if isPet(ch)then
						stripPetVfx(ch)
					end
				end
			end
			local function stripPlotInterior(plot)
				stripPlotInteriorFast(plot)
				stripPlotVisual(plot)
			end
			local connectedPlots={}
			local function connectPlot(plot)
				if not(plot and plot.Parent)or connectedPlots[plot]then
					return
				end
				connectedPlots[plot]=true
				session:Connect(plot.ChildAdded,function(ch)
					if session:Busy()then
						return
					end
					handlePlotChild(plot,ch)
				end)
				session:Connect(plot.DescendantAdded,function(d)
					if session:Busy()then
						return
					end
					if not d then
						return
					end
					if underUnlock(d)then
						return
					end
					local cn=d.ClassName
					if cn=="BillboardGui"or cn=="SurfaceGui"then
						if skipTimerStrip(plot)and isRemainingTimeGui(d)then
							return
						end
						kill(d)
						return
					end
					if d.Name=="Spawn"or d.Name=="PromptAttachment"or cn=="ProximityPrompt"then
						return
					end
					if d.Name=="Decorations"and d.Parent==plot then
						stripPlotDecor(d)
						return
					end
					local p=d.Parent
					if not p then
						return
					end
					if p.Name=="LaserHitbox"then
						kill(d)
						return
					end
					if PART_CLASS[d.ClassName]then
						if isPlotPadPart(d)then
							local x=p
							local inPlotDec,skip=false,false
							while x and x~=plot do
								if isPet(x)or x.Name=="Spawn"or x.Name=="AnimalPodiums"then
									skip=true
									break
								end
								if x.Name=="Decorations"and x.Parent==plot then
									inPlotDec=true
								end
								x=x.Parent
							end
							if inPlotDec and not skip then
								kill(d)
								return
							end
						elseif isPodiumPlate(d)then
							local x=p
							local inDec,skip=false,false
							while x and x~=plot do
								if x.Name=="Spawn"then
									skip=true
									break
								end
								if x.Name=="Decorations"then
									inDec=true
								end
								if x.Name=="AnimalPodiums"then
									if inDec and not skip then
										kill(d)
									end
									return
								end
								x=x.Parent
							end
						end
					end
					local sk=p
					while sk and sk~=plot do
						if sk.Name=="Skin"then
							if isSkinJunk(d)then
								kill(d)
							end
							return
						end
						sk=sk.Parent
					end
					local las=p
					while las and las~=plot do
						if las.Name=="Laser"then
							if skipLaserStrip(plot)then
								return
							end
							if PART_CLASS[d.ClassName]then
								pcall(function()
									session:Set(d,"CanCollide",false)
									session:Set(d,"CanTouch",false)
								end)
							end
							queueStripLaser(las)
							return
						end
						las=las.Parent
					end
				end)
			end
			local function plotIsMine(plot)
				if not plot then
					return false
				end
				if _G.__SXE_MyPlot and plot.Name==_G.__SXE_MyPlot then
					return true
				end
				local ch
				pcall(function()
					if _G.XenSyncGet then
						ch=_G.XenSyncGet(plot.Name)
					end
				end)
				if ch and _G.SXE_IsMyPlot and _G.SXE_IsMyPlot(ch)then
					_G.__SXE_MyPlot=plot.Name
					return true
				end
				return false
			end
			local function canDestroyPlot(plot)
				if not plot then
					return false
				end
				if plotIsMine(plot)then
					return false
				end
				local keep=_G.__SXE_KeepPlot
				if keep and plot.Name==keep then
					return false
				end
				if not _G.__SXE_MyPlot then
					return false
				end
				return plot.Name~=_G.__SXE_MyPlot
			end
			local ANIMAL_SKIP={Base=true,Claim=true,Decorations=true,Spawn=true}
			local function isAnimalModel(m)
				return m:IsA("Model")
					and(m:FindFirstChildWhichIsA("MeshPart",true)~=nil
						or m:FindFirstChildWhichIsA("AnimationController",true)~=nil
						or isPet(m))
			end
			local function sweepPodium(parent)
				for _,child in ipairs(parent:GetChildren())do
					if not ANIMAL_SKIP[child.Name]and child.ClassName~="ProximityPrompt"then
						if isAnimalModel(child)then
							session:HideAnimal(child)
						else
							sweepPodium(child)
						end
					end
				end
			end
			local podSweepQueued={}
			local function queuePodiumSweep(podium)
				if podSweepQueued[podium]then
					return
				end
				podSweepQueued[podium]=true
				task.defer(function()
					podSweepQueued[podium]=nil
					if podium.Parent and not session:Busy()then
						sweepPodium(podium)
					end
				end)
			end
			local hookedPods={}
			local function sweepAnimals(plot)
				if realGlobals.ElysiumHideAllBrainrots==false or not(plot and plot.Parent)then
					return
				end
				for _,ch in ipairs(plot:GetChildren())do
					if isPet(ch)then
						session:HideAnimal(ch)
					end
				end
				local pods=plot:FindFirstChild("AnimalPodiums")
				if not pods then
					return
				end
				for _,podium in ipairs(pods:GetChildren())do
					sweepPodium(podium)
				end
				if not hookedPods[pods]then
					hookedPods[pods]=true
					session:Connect(pods.DescendantAdded,function(d)
						local at=d
						while at and at.Parent~=pods do
							at=at.Parent
						end
						if at then
							queuePodiumSweep(at)
						end
					end)
				end
			end
			function session:SweepAnimals()
				local plots=workspace:FindFirstChild("Plots")
				if not plots or self:Busy()then
					return
				end
				for _,name in ipairs({self.mine,self.winner})do
					if name then
						sweepAnimals(plots:FindFirstChild(tostring(name)))
					end
				end
			end
			local hookedPlots
			local ownMachinesHooked={}
			local function stripOwnMachines(plot)
				for _,ch in ipairs(plot:GetChildren())do
					if isMachineName(ch.Name)and not isPet(ch)then
						killMarked(ch,true)
					end
				end
				if not ownMachinesHooked[plot]then
					ownMachinesHooked[plot]=true
					session:Connect(plot.ChildAdded,function(ch)
						if isMachineName(ch.Name)and not isPet(ch)then
							killMarked(ch,true)
						end
					end)
				end
			end
			local function hookPlot(plot)
				if canDestroyPlot(plot)then
					kill(plot)
				elseif not plotIsMine(plot)then
					stripPlotInterior(plot)
					connectPlot(plot)
				else
					stripOwnMachines(plot)
				end
			end
			local function hookPlots(folder)
				if not folder or hookedPlots==folder then
					return
				end
				hookedPlots=folder
				for _,plot in ipairs(folder:GetChildren())do
					hookPlot(plot)
				end
				session:Connect(folder.ChildAdded,hookPlot)
				session:SweepAnimals()
			end
			_G.SXE_LockPrioPlot=function(plotName)
				if not plotName then
					return
				end
				_G.__SXE_KeepPlot=tostring(plotName)
				local plots=workspace:FindFirstChild("Plots")
				if not plots then
					return
				end
				local kids=plots:GetChildren()
				for i=1,#kids do
					local plot=kids[i]
					if canDestroyPlot(plot)then
						kill(plot)
					end
				end
				local mine=_G.__SXE_MyPlot and plots:FindFirstChild(_G.__SXE_MyPlot)
				if mine and _G.SXE_NukePlotPodiums then
					pcall(_G.SXE_NukePlotPodiums,mine)
				end
				local keepPlot=_G.__SXE_KeepPlot and plots:FindFirstChild(_G.__SXE_KeepPlot)
				if keepPlot and _G.SXE_StripNonPrioPodiums then
					pcall(_G.SXE_StripNonPrioPodiums,keepPlot)
				end
			end
			function session:Retarget(newWinner)
				if newWinner==self.winner then
					return
				end
				local oldName=self.winner
				self.winner=newWinner
				_G.__SXE_KeepPlot=newWinner
				local plots=workspace:FindFirstChild("Plots")
				if not plots then
					return
				end
				if newWinner then
					local plot=plots:FindFirstChild(newWinner)or self.hiddenPlots[newWinner]
					if plot then
						self.pending[plot]=nil
					end
					if plot and plot.Parent==nil then
						self:Show(plot)
					end
					if plot and plot.Parent then
						hookPlot(plot)
					end
				end
				if oldName and oldName~=newWinner then
					local old=plots:FindFirstChild(oldName)
					if old and canDestroyPlot(old)then
						kill(old)
					end
				end
				self:SweepAnimals()
			end
			do
				local RS=ElysiumService("ReplicatedStorage")
				local RS_KILL={
					RNGMachineVFX=true,
					LuckIcons=true,
					GlossaryBackground=true,
					AnimationGraphEditor=true,
					ML=true,
					PlayWaveEvents=true,
				}
				local function dropKill(ch)
					if ch and RS_KILL[ch.Name]then
						kill(ch)
					end
				end
				for _,ch in ipairs(RS:GetChildren())do
					dropKill(ch)
				end
				session:Connect(RS.ChildAdded,dropKill)
			end
			local function stripMap(map)
				local function handle(x)
					if session:Busy()then
						return
					end
					if x and not MAP_KEEP[x.Name]then
						killMarked(x)
					end
				end
				local kids=map:GetChildren()
				for i=1,#kids do
					handle(kids[i])
				end
				session:Connect(map.ChildAdded,handle)
			end
			local hookedRma
			local rmaBoxDone=false
			local function hookRma(rma)
				if not rma then
					return
				end
				if rmaBoxDone then
					kill(rma)
					return
				end
				if hookedRma==rma then
					return
				end
				hookedRma=rma
				local function nuke()
					rmaBoxDone=false
				end
				nuke()
			end
			local function onWsChild(ch)
				if not ch then
					return
				end
				if session:Busy()then
					return
				end
				local n=ch.Name
				if ch.ClassName=="Camera"or ch.ClassName=="Terrain"then
					return
				end
				if n=="Plots"then
					hookPlots(ch)
					return
				end
				if n=="RenderedMovingAnimals"then
					hookRma(ch)
					return
				end
				if n=="Map"then
					stripMap(ch)
					return
				end
				if isMine(ch)then
					return
				end
				if isUuidName(n)then
					kill(ch)
					return
				end
				if isOtherAvatar(ch)then
					stripOtherChar(ch)
					return
				end
				if ch.ClassName=="Model"then
					session:Connect(ch.ChildAdded,function()
						if isOtherAvatar(ch)then
							stripOtherChar(ch)
						end
					end)
				end
				if string.sub(n,1,7)=="BeeHive"or string.sub(n,1,7)=="Sentry_"then
					killMarked(ch)
					return
				end
				if WS_KILL[n]or ch.ClassName=="Highlight"or(isMachineName(n)and not isPet(ch))then
					killMarked(ch)
					return
				end
				if string.find(string.lower(n),"eclipse",1,true)then
					killMarked(ch)
					return
				end
				if ch.ClassName=="Model"and string.find(n,"'s Rainbow",1,true)then
					kill(ch)
				end
			end
			local wsch=workspace:GetChildren()
			local plotsFolder,mapFolder,rmaFolder
			local rest={}
			for i=1,#wsch do
				local ch=wsch[i]
				local n=ch.Name
				if n=="Plots"then
					plotsFolder=ch
				elseif n=="Map"then
					mapFolder=ch
				elseif n=="RenderedMovingAnimals"then
					rmaFolder=ch
				else
					rest[#rest+1]=ch
				end
			end
			if mapFolder then
				stripMap(mapFolder)
			end
			if rmaFolder then
				hookRma(rmaFolder)
			end
			for i=1,#rest do
				onWsChild(rest[i])
			end
			if plotsFolder then
				hookPlots(plotsFolder)
			end
			session:Connect(workspace.ChildAdded,onWsChild)
			local function hookPlrChar(plr)
				if not plr or plr==LP then
					return
				end
				if plr.Character then
					stripOtherChar(plr.Character)
				end
				session:Connect(plr.CharacterAdded,stripOtherChar)
			end
			local plrs=Players:GetPlayers()
			for i=1,#plrs do
				hookPlrChar(plrs[i])
			end
			session:Connect(Players.PlayerAdded,hookPlrChar)
			local function onLit(x)
				if session:Busy()then
					return
				end
				if not x then
					return
				end
				local cn=x.ClassName
				if
					cn=="Sky"
					or cn=="Atmosphere"
					or cn=="Clouds"
					or cn=="SunRaysEffect"
					or cn=="ColorCorrectionEffect"
				then
					kill(x)
				end
			end
			local lit=Lighting:GetChildren()
			for i=1,#lit do
				onLit(lit[i])
			end
			session:Connect(Lighting.ChildAdded,onLit)
			local function stripCamFx(x)
				if not x then
					return
				end
				local cn=x.ClassName
				if cn=="ColorCorrectionEffect"or cn=="BlurEffect"then
					kill(x)
				end
			end
			local hookedCam
			local function hookCam(cam)
				if not cam or hookedCam==cam then
					return
				end
				hookedCam=cam
				local ck=cam:GetChildren()
				for i=1,#ck do
					stripCamFx(ck[i])
				end
				session:Connect(cam.ChildAdded,stripCamFx)
			end
			hookCam(workspace.CurrentCamera)
			session:Connect(workspace:GetPropertyChangedSignal("CurrentCamera"),function()
				hookCam(workspace.CurrentCamera)
			end)
			session:Connect(workspace.DescendantAdded,function(d)
				if not d then
					return
				end
				if session:Busy()then
					return
				end
				local cn=d.ClassName
				if cn=="BillboardGui"or cn=="SurfaceGui"or cn=="Decal"or cn=="Texture"then
					if underUnlock(d)then
						return
					end
					if
						(cn=="BillboardGui"or cn=="SurfaceGui")
						and skipTimerStrip(plotOf(d))
						and isRemainingTimeGui(d)
					then
						return
					end
					kill(d)
				end
			end)
			if mapFolder and mapFolder.Parent then
				local md=mapFolder:GetDescendants()
				for i=1,#md do
					local cn=md[i].ClassName
					if cn=="Decal"or cn=="Texture"then
						kill(md[i])
					end
				end
			end
			_G.__SXE_StripDone=true
		end
		applyDonor()
		if _G.SXE_LockPrioPlot then
			_G.SXE_LockPrioPlot(session.winner)
		end
	end
	local lastScanAt=0
	local focusPlot,focusUntil=nil,0
	local function pickWinner(pets)
		if focusPlot and os.clock()<focusUntil then
			return focusPlot
		end
		focusPlot=nil
		local best=pets and pets[1]
		return best and best.plot and tostring(best.plot)or nil
	end
	local function reconcile(pets)
		if transitioning or movementBusy()then
			return
		end
		if realGlobals.ElysiumOptimizerMode~="default"then
			restore()
			return
		end
		local mine=realGlobals.ElysiumMyPlot
		if not mine then
			restore()
			return
		end
		mine=tostring(mine)
		local winner=pickWinner(pets)
		if active and active.mine~=mine then
			restore()
		end
		if active then
			transitioning=true
			if winner and winner~=active.winner then
				local ok,err=pcall(active.Retarget,active,winner)
				if not ok then
					realGlobals.ElysiumOptimizerError=tostring(err)
				end
			end
			pcall(active.Flush,active)
			transitioning=false
			return
		end
		transitioning=true
		active=makeSession(mine,winner)
		local ok,err=pcall(startDonor,active)
		if ok then
			realGlobals.ElysiumOptimizerError=nil
		else
			restore()
			realGlobals.ElysiumOptimizerError=tostring(err)
		end
		transitioning=false
	end
	realGlobals.ElysiumOptimizerFocusPlot=function(plotName,seconds)
		if plotName==nil then
			return
		end
		local mine=realGlobals.ElysiumMyPlot
		if mine and tostring(mine)==tostring(plotName)then
			return
		end
		focusPlot=tostring(plotName)
		focusUntil=os.clock()+(tonumber(seconds)or tonumber(realGlobals.ElysiumOptimizerFocusTime)or 20)
		if active and active.alive and active.winner~=focusPlot and not transitioning
			and realGlobals.ElysiumOptimizerMode=="default"then
			transitioning=true
			local ok,err=pcall(active.Retarget,active,focusPlot)
			transitioning=false
			if not ok then
				realGlobals.ElysiumOptimizerError=tostring(err)
			end
		end
	end
	realGlobals.ElysiumOptimizerPlotInventory=function(folder)
		local plots=folder:GetChildren()
		if active then
			for _,inst in pairs(active.hiddenPlots)do
				if inst.Parent==nil and active.hidden[inst]==folder then
					plots[#plots+1]=inst
				end
			end
		end
		return plots
	end
	realGlobals.ElysiumOptimizerOnScan=function(pets)
		lastScanAt=os.clock()
		local best=pets and pets[1]
		local keep=best and best.plot or nil
		if keep~=realGlobals.ElysiumVisualKeepPlot then
			realGlobals.ElysiumVisualKeepPlot=keep
			if realGlobals.ElysiumImmediateVisualRefresh then
				pcall(realGlobals.ElysiumImmediateVisualRefresh)
			end
		end
		latestPets=pets
		reconcile(pets)
	end
	realGlobals.ElysiumSetOptimizerMode=function(mode)
		if mode~="default"and mode~="aa"then
			return false
		end
		realGlobals.ElysiumOptimizerMode=mode
		incompleteSince=nil
		requested=mode
		if not movementBusy()then
			realGlobals.ElysiumOptimizerMode=mode
			requested=nil
			if mode=="default"then
				task.spawn(function()
					local before=lastScanAt
					local ok,pets=pcall(realGlobals.ElysiumScanAllPets)
					if ok and type(pets)=="table"and lastScanAt==before then
						latestPets=pets
						reconcile(latestPets)
					end
				end)
			else
				reconcile(latestPets)
			end
		end
		task.spawn(function()
			pcall(realGlobals.ElysiumApplyOptimizerBase,mode)
			if _G.ElysiumRefreshBrainrotVisuals then pcall(_G.ElysiumRefreshBrainrotVisuals)end
			if _G.ElysiumApplyRoadVisibility then pcall(_G.ElysiumApplyRoadVisibility)end
		end)
		return true
	end
	task.spawn(function()
		local before=lastScanAt
		local ok,pets=pcall(realGlobals.ElysiumScanAllPets)
		if ok and type(pets)=="table"and lastScanAt==before then
			latestPets=pets
			reconcile(pets)
		end
		local wasBusy,lastSweep=false,0
		while realGlobals.ElysiumMainLoadedGame==game do
			task.wait(tonumber(realGlobals.ElysiumOptimizerTick)or .1)
			if movementBusy()then
				wasBusy=true
				continue
			end
			if requested then
				realGlobals.ElysiumOptimizerMode=requested
				requested=nil
			end
			if realGlobals.ElysiumOptimizerMode=="default"then
				local scanGap=active and 1.5 or(tonumber(realGlobals.ElysiumOptimizerStartScan)or .3)
				if os.clock()-lastScanAt>scanGap then
					local scanBefore=lastScanAt
					local scanned,list=pcall(realGlobals.ElysiumScanAllPets)
					if scanned and type(list)=="table"and lastScanAt==scanBefore then
						latestPets=list
						reconcile(list)
					end
				else
					reconcile(latestPets)
				end
				if active and active.SweepAnimals and(wasBusy
					or os.clock()-lastSweep>(tonumber(realGlobals.ElysiumAnimalSweepEvery)or .5))then
					lastSweep=os.clock()
					pcall(active.SweepAnimals,active)
				end
				if active and active.KeepStandingPlot then
					pcall(active.KeepStandingPlot,active)
				end
				wasBusy=false
			else
				restore()
			end
		end
		restore()
	end)
end
do
	local busy=function()
		return _G.ElysiumOptimizerMode=="default"or _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())
	end
	local function protectedPlot(inst)
		local at=inst
		while at and at~=workspace do
			if at.Name=="Plots"or at:GetAttribute("ElysiumLocalInvisVisual")==true then
				return true
			end
			at=at.Parent
		end
		return false
	end
	local function protectedGeometry(inst)
		if not inst then
			return false
		end
		if inst:IsA("BasePart")or inst:IsA("Model")or inst:IsA("Folder")or inst:IsA("Terrain")then
			return true
		end
		local at=inst
		while at and at~=workspace do
			if at:IsA("Terrain")or string.find(string.lower(at.Name),"admin",1,true)then
				return true
			end
			at=at.Parent
		end
		for _,child in ipairs(inst:GetDescendants())do
			if child:IsA("BasePart")or child:IsA("Terrain")then
				return true
			end
		end
		return false
	end
	local function kill(inst)
		if inst and not protectedPlot(inst)and not protectedGeometry(inst)and not busy()then
			inst:Destroy()
		end
	end
	_G.__SXE_KillQ={}
	function _G.SXE_Kill(inst)
		if _G.ElysiumOptimizerMode=="default"or not inst or protectedPlot(inst)or protectedGeometry(inst)then
			return
		end
		if _G.Elysium_IsResetting
			or(_G.ElysiumHoldingForPickup~=true and _G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
			_G.__SXE_KillQ[#_G.__SXE_KillQ+1]=inst
		else
			pcall(function()
				inst:Destroy()
			end)
		end
	end
	function _G.SXE_FlushKills()
		if _G.ElysiumOptimizerMode=="default"then
			return
		end
		local q=_G.__SXE_KillQ
		_G.__SXE_KillQ={}
		for _,inst in ipairs(q)do
			if inst and inst.Parent and not protectedPlot(inst)and not protectedGeometry(inst)then
				pcall(function()
					inst:Destroy()
				end)
			end
		end
	end
	local function __sxeStrip()
		local animalTags=ElysiumService("CollectionService")
		local function isRoadObject(object)
			local at=object
			while at and at~=workspace do
				if at.Name=="RenderedMovingAnimals"then
					return true
				end
				if animalTags:HasTag(at,"Animal")then
					return true
				end
				if at:GetAttribute("Index")~=nil then
					return true
				end
				at=at.Parent
			end
			return false
		end
		local Players=ElysiumService("Players")
		local Lighting=ElysiumService("Lighting")
		local LP=Players.LocalPlayer
		local function kill(inst)
			_G.SXE_Kill(inst)
		end
		pcall(function()
			workspace.Terrain.Decoration=false
		end)
		local WS_KILL={
			FriendPanel=true,
			Cash=true,
			Unlock=true,
			Purchases=true,
			PlotSign=true,
			CashPad=true,
			InvisibleWalls=true,
			Multiplier=true,
			Slope=true,
			IncubatorMachine=true,
			FuseMachine=true,
			XzFusionMECircuit6zX=true,
			HalloweenFuseMachine=true,
			JumpLTMMachine=true,
			RobuxShop=true,
			SoccerScoreBoard=true,
			CrystalSpinWheel=true,
			EclipseWheel=true,
			EclipseSpinWheel=true,
			["Eclipse Wheel"]=true,
			Beehive=true,
			CraftingMachine=true,
			Shop=true,
			Road=true,
			EventBoard=true,
			TradePlazaPortal=true,
			LosTraders=true,
			RNGMachine=true,
			Present=true,
			StPatricksPot=true,
			ShopNPCRobuxIdle=true,
			RoadPanel=true,
			Honey=true,
			Trap=true,
			Events=true,
			Sounds=true,
			rods=true,
			Dev=true,
			ToolsAdds=true,
			__PROJECTILES=true,
			CrystalMap=true,
			SpawnLocation=true,
			UFO=true,
			Interacts=true,
		}
		local PLOT_KEEP={
			Skin=true,
			Laser=true,
			AnimalPodiums=true,
			DeliveryHitbox=true,
			StealHitbox=true,
			AnimalTarget=true,
			MainRoot=true,
			Floor=true,
			Spawn=true,
			Door=true,
			Hitbox=true,
			Base=true,
			Wall=true,
			Roof=true,
			SecondFloor=true,
			ThirdFloor=true,
			["structure base home"]=true,
			Unlock=true,
		}
		local PLOT_NUKE={
			FriendPanel=true,
			Cash=true,
			Purchases=true,
			PlotSign=true,
			CashPad=true,
			InvisibleWalls=true,
			Multiplier=true,
			LaserHitbox=true,
			Events=true,
			Sounds=true,
			Slope=true,
		}
		local BODY_PART={
			HumanoidRootPart=true,
			Head=true,
			Torso=true,
			UpperTorso=true,
			LowerTorso=true,
			LeftUpperArm=true,
			LeftLowerArm=true,
			LeftHand=true,
			RightUpperArm=true,
			RightLowerArm=true,
			RightHand=true,
			LeftUpperLeg=true,
			LeftLowerLeg=true,
			LeftFoot=true,
			RightUpperLeg=true,
			RightLowerLeg=true,
			RightFoot=true,
			["Left Arm"]=true,
			["Right Arm"]=true,
			["Left Leg"]=true,
			["Right Leg"]=true,
		}
		local CHAR_KEEP_CLASS={
			Humanoid=true,
			Animator=true,
			Attachment=true,
			Motor6D=true,
			AnimationConstraint=true,
			BallSocketConstraint=true,
			Weld=true,
			WeldConstraint=true,
		}
		local MAP_KEEP={Ground=true,Ground_Left=true,Ground_Right=true}
		local PART_CLASS={
			Part=true,
			MeshPart=true,
			UnionOperation=true,
			WedgePart=true,
			CornerWedgePart=true,
			TrussPart=true,
			SpawnLocation=true,
			Seat=true,
			VehicleSeat=true,
		}
		local function underUnlock(d)
			local x=d
			for _=1,12 do
				if not x then
					return false
				end
				if x.Name=="Unlock"then
					return true
				end
				if x==workspace then
					return false
				end
				x=x.Parent
			end
			return false
		end
		local function isMine(inst)
			if not(LP and inst)then
				return false
			end
			if inst==LP.Character or inst.Name==LP.Name then
				return true
			end
			return false
		end
		local function isVisualJunk(d)
			local cn=d.ClassName
			return cn=="Beam"
				or cn=="Trail"
				or cn=="ParticleEmitter"
				or cn=="PointLight"
				or cn=="SpotLight"
				or cn=="SurfaceLight"
				or cn=="Fire"
				or cn=="Smoke"
				or cn=="Sparkles"
				or cn=="BillboardGui"
				or cn=="SurfaceGui"
				or cn=="Highlight"
				or cn=="Decal"
				or cn=="Texture"
		end
		local function isSkinJunk(d)
			if not d then
				return false
			end
			if isVisualJunk(d)then
				return true
			end
			return PART_CLASS[d.ClassName]==true and not d.CanCollide
		end
		local function isPet(inst)
			if not inst or inst.ClassName~="Model"then
				return false
			end
			return inst:FindFirstChild("FakeRootPart")~=nil or inst:FindFirstChild("RootPart")~=nil
		end
		local function stripSkin(skin)
			if not(skin and skin.Parent)then
				return
			end
			local dd=skin:GetDescendants()
			local dump={}
			for i=1,#dd do
				if isSkinJunk(dd[i])then
					dump[#dump+1]=dd[i]
				end
			end
			for i=1,#dump do
				kill(dump[i])
			end
		end
		local function skipLaserStrip(plot)
			local keep=_G.__SXE_KeepPlot
			if not keep then
				return true
			end
			return plot and tostring(plot.Name)==tostring(keep)
		end
		local function skipTimerStrip(plot)
			return skipLaserStrip(plot)
		end
		local function plotOf(d)
			local x=d
			for _=1,16 do
				if not x then
					return nil
				end
				local p=x.Parent
				if p and p.Name=="Plots"then
					return x
				end
				x=p
			end
			return nil
		end
		local function isRemainingTimeGui(d)
			if not d then
				return false
			end
			local x=d
			for _=1,16 do
				if not x then
					break
				end
				if x.Name=="RemainingTime"then
					return true
				end
				x=x.Parent
			end
			local cn=d.ClassName
			if cn=="BillboardGui"or cn=="SurfaceGui"then
				local hit
				pcall(function()
					hit=d:FindFirstChild("RemainingTime",true)
				end)
				if hit then
					return true
				end
			end
			return false
		end
		local function stripPurchasesKeepTimer(purch)
			if not(purch and purch.Parent)then
				return
			end
			local kids=purch:GetChildren()
			for i=1,#kids do
				local ch=kids[i]
				if ch.Name~="PlotBlock"then
					kill(ch)
				else
					local dd=ch:GetDescendants()
					for j=1,#dd do
						local d=dd[j]
						local cn=d.ClassName
						if(cn=="BillboardGui"or cn=="SurfaceGui")and not isRemainingTimeGui(d)then
							kill(d)
						end
					end
				end
			end
		end
		local laserPend={}
		local function stripLaser(laser)
			if true then return end
			if not(laser and laser.Parent)then
				return
			end
			if skipLaserStrip(laser.Parent)then
				return
			end
			local bars={}
			local beamPart={}
			local dd=laser:GetDescendants()
			for i=1,#dd do
				local d=dd[i]
				if d.ClassName=="Beam"then
					local a0,a1=d.Attachment0,d.Attachment1
					local p0=a0 and a0.Parent
					local p1=a1 and a1.Parent
					if p0 and p0:IsA("BasePart")then
						beamPart[p0]=true
					end
					if p1 and p1:IsA("BasePart")then
						beamPart[p1]=true
					end
				elseif d:IsA("BasePart")then
					bars[#bars+1]=d
				end
			end
			if#bars>0 then
				local chosen={}
				for i=1,#bars do
					if beamPart[bars[i]]then
						chosen[#chosen+1]=bars[i]
					end
				end
				if#chosen==0 then
					for i=1,#bars do
						local d=bars[i]
						local s=d.Size
						local mx=math.max(s.X,s.Y,s.Z)
						local mn=math.min(s.X,s.Y,s.Z)
						local neon=false
						pcall(function()
							neon=d.Material==Enum.Material.Neon or d.Material==Enum.Material.ForceField
						end)
						if neon or(mn<=1.5 and mx>=3)then
							chosen[#chosen+1]=d
						end
					end
				end
				if#chosen==0 then
					chosen=bars
				end
				local keep=chosen[1]
				if keep then
					for i=1,#bars do
						if bars[i]~=keep then
							kill(bars[i])
						end
					end
					pcall(function()
						if PART_CLASS[laser.ClassName]then
							laser.CanCollide=false
							laser.CanTouch=false
						end
						keep.CanCollide=false
						keep.CanTouch=false
					end)
				end
			end
		end
		local function queueStripLaser(laser)
			if not laser or laserPend[laser]then
				return
			end
			laserPend[laser]=true
			task.defer(function()
				laserPend[laser]=nil
				stripLaser(laser)
			end)
		end
		local function stripPetVfx(pet)
			if not pet then
				return
			end
			local dd=pet:GetDescendants()
			local dump={}
			for i=1,#dd do
				local d=dd[i]
				local n=d.Name
				local cn=d.ClassName
				if
					n=="VfxInstance"
					or n=="_VfxInstance"
					or n=="AnimationController"
					or cn=="ParticleEmitter"
					or cn=="Beam"
					or cn=="Trail"
					or cn=="Fire"
					or cn=="Smoke"
					or cn=="Sparkles"
					or cn=="Animator"
					or cn=="AnimationController"
					or cn=="Bone"
					or cn=="BillboardGui"
					or cn=="SurfaceGui"
				then
					dump[#dump+1]=d
				end
			end
			for i=1,#dump do
				kill(dump[i])
			end
		end
		_G.SXE_StripPetVfx=stripPetVfx
		local function isCharJunk(d)
			if not d then
				return false
			end
			local cn=d.ClassName
			if cn=="PathfindingModifier"then
				return false
			end
			if cn=="WrapTarget"or cn=="WrapLayer"then
				return true
			end
			if cn=="Shirt"or cn=="ShirtGraphic"then
				return true
			end
			if cn=="NoCollisionConstraint"then
				return true
			end
			local nm=d.Name
			if nm=="__HITBOX"or nm=="OriginalPosition"or nm=="OriginalSize"then
				return true
			end
			if CHAR_KEEP_CLASS[cn]then
				return false
			end
			if BODY_PART[nm]then
				return false
			end
			return true
		end
		local function isUuidName(n)
			return type(n)=="string"
				and#n==36
				and string.match(n,"^%x%x%x%x%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%-%x%x%x%x%x%x%x%x%x%x%x%x$")
					~=nil
		end
		local function isOtherAvatar(char)
			if not(char and char.ClassName=="Model")then
				return false
			end
			if isMine(char)then
				return false
			end
			if isPet(char)then
				return false
			end
			local n=char.Name
			if type(n)=="string"and string.sub(n,-6)=="_Clone"then
				return false
			end
			if Players:GetPlayerFromCharacter(char)then
				return true
			end
			if Players:FindFirstChild(n)then
				return true
			end
			return char:FindFirstChildOfClass("Humanoid")~=nil
		end
		local hookedChars={}
		local function stripOtherChar(char)
			if _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
				return
			end
			if not(char and char.Parent)or isMine(char)or not isOtherAvatar(char)then
				return
			end
			local function sweep()
				local dd=char:GetDescendants()
				local dump={}
				for i=1,#dd do
					if isCharJunk(dd[i])then
						dump[#dump+1]=dd[i]
					end
				end
				for i=1,#dump do
					kill(dump[i])
				end
			end
			sweep()
			if hookedChars[char]then
				return
			end
			hookedChars[char]=true
			char.DescendantAdded:Connect(function(d)
				if _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
					return
				end
				if d and d.Parent and not isMine(char)and isCharJunk(d)then
					kill(d)
				end
			end)
		end
		local strippedPlots={}
		_G.__SXE_StrippedPlots=strippedPlots
		local function near(a,b)
			return math.abs(a-b)<.2
		end
		local function isPlotPadPart(d)
			if not d or PART_CLASS[d.ClassName]~=true then
				return false
			end
			if d.Name=="structure base home"or d.Name=="Spawn"then
				return false
			end
			local s=d.Size
			if near(s.X,4)and near(s.Y,1)and near(s.Z,4)then
				return true
			end
			if near(s.X,2)and near(s.Y,.5)and near(s.Z,2)then
				return true
			end
			return false
		end
		local function isPodiumPlate(d)
			if not d or PART_CLASS[d.ClassName]~=true then
				return false
			end
			if d.Name=="Spawn"then
				return false
			end
			local s=d.Size
			if near(s.X,6)and near(s.Y,.2)and near(s.Z,6)then
				return true
			end
			if near(s.X,4)and near(s.Y,.2)and near(s.Z,4)then
				return true
			end
			return false
		end
		local function stripMap(map)
			local function handle(x)
				if _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
					return
				end
				if x and not MAP_KEEP[x.Name]then
					kill(x)
				end
			end
			local kids=map:GetChildren()
			for i=1,#kids do
				handle(kids[i])
			end
			map.ChildAdded:Connect(handle)
		end
		local hookedRma
		local rmaBoxDone=false
		local function hookRma(rma)
			if not rma then
				return
			end
			if hookedRma==rma then
				return
			end
			hookedRma=rma
			rmaBoxDone=false
		end
		local function onWsChild(ch)
			if not ch or isRoadObject(ch)then
				return
			end
			if ch.Name=="TrxTempPlatform"or ch.Name=="ElysiumTPPath"then
				return
			end
			if _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
				return
			end
			local n=ch.Name
			if ch.ClassName=="Camera"or ch.ClassName=="Terrain"then
				return
			end
			if n=="Plots"then
				return
			end
			if n=="RenderedMovingAnimals"then
				return
			end
			if n=="Map"then
				stripMap(ch)
				return
			end
			if isMine(ch)then
				return
			end
			if isUuidName(n)then
				if ch:IsA("Model")then
					return
				end
				task.delay(.5,function()
					if ch.Parent and not isRoadObject(ch)then
						kill(ch)
					end
				end)
				return
			end
			if isOtherAvatar(ch)then
				stripOtherChar(ch)
				return
			end
			if ch.ClassName=="Model"then
				ch.ChildAdded:Connect(function()
					if isOtherAvatar(ch)then
						stripOtherChar(ch)
					end
				end)
			end
			if string.sub(n,1,7)=="BeeHive"or string.sub(n,1,7)=="Sentry_"then
				kill(ch)
				return
			end
			if WS_KILL[n]or ch.ClassName=="Highlight"then
				kill(ch)
				return
			end
			if string.find(string.lower(n),"eclipse",1,true)then
				kill(ch)
				return
			end
			if ch.ClassName=="Model"and string.find(n,"'s Rainbow",1,true)then
				kill(ch)
			end
		end
		local wsch=workspace:GetChildren()
		local plotsFolder,mapFolder,rmaFolder
		local rest={}
		for i=1,#wsch do
			local ch=wsch[i]
			local n=ch.Name
			if n=="Plots"then
				plotsFolder=ch
			elseif n=="Map"then
				mapFolder=ch
			elseif n=="RenderedMovingAnimals"then
				rmaFolder=ch
			else
				rest[#rest+1]=ch
			end
		end
		local function stripBreathe()
			if _G.ElysiumStripNoYield~=true then
				task.wait()
			end
		end
		if mapFolder then
			stripMap(mapFolder)
			stripBreathe()
		end
		for i=1,#rest do
			onWsChild(rest[i])
			if i%8==0 then
				stripBreathe()
			end
		end
		workspace.ChildAdded:Connect(onWsChild)
		local function hookPlrChar(plr)
			if not plr or plr==LP then
				return
			end
			if plr.Character then
				stripOtherChar(plr.Character)
			end
			plr.CharacterAdded:Connect(stripOtherChar)
		end
		local plrs=Players:GetPlayers()
		for i=1,#plrs do
			hookPlrChar(plrs[i])
		end
		Players.PlayerAdded:Connect(hookPlrChar)
		local function onLit(x)
			if _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
				return
			end
			if not x then
				return
			end
			local cn=x.ClassName
			if
				cn=="Sky"
				or cn=="Atmosphere"
				or cn=="Clouds"
				or cn=="SunRaysEffect"
				or cn=="ColorCorrectionEffect"
			then
				kill(x)
			end
		end
		local lit=Lighting:GetChildren()
		for i=1,#lit do
			onLit(lit[i])
		end
		Lighting.ChildAdded:Connect(onLit)
		local function stripCamFx(x)
			if not x then
				return
			end
			local cn=x.ClassName
			if cn=="ColorCorrectionEffect"or cn=="BlurEffect"then
				kill(x)
			end
		end
		local hookedCam
		local function hookCam(cam)
			if not cam or hookedCam==cam then
				return
			end
			hookedCam=cam
			local ck=cam:GetChildren()
			for i=1,#ck do
				stripCamFx(ck[i])
			end
			cam.ChildAdded:Connect(stripCamFx)
		end
		hookCam(workspace.CurrentCamera)
		workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
			hookCam(workspace.CurrentCamera)
		end)
		workspace.DescendantAdded:Connect(function(d)
			if not d or protectedPlot(d)or isRoadObject(d)then
				return
			end
			if _G.Elysium_IsResetting or(_G.ElysiumIsTeleporting and _G.ElysiumIsTeleporting())then
				return
			end
			local cn=d.ClassName
			if cn=="BillboardGui"or cn=="SurfaceGui"or cn=="Decal"or cn=="Texture"then
				if underUnlock(d)then
					return
				end
				if
					(cn=="BillboardGui"or cn=="SurfaceGui")
					and skipTimerStrip(plotOf(d))
					and isRemainingTimeGui(d)
				then
					return
				end
				kill(d)
			end
		end)
		if mapFolder and mapFolder.Parent then
			local md=mapFolder:GetDescendants()
			for i=1,#md do
				local object=md[i]
				local cn=object.ClassName
				if(cn=="Decal"or cn=="Texture")and object.Parent then
					kill(object)
				end
				if i%2500==0 then
					stripBreathe()
				end
			end
		end
		_G.__SXE_StripDone=true
	end
	task.spawn(function()
		local started=false
		while _G.ElysiumMainLoadedGame==game do
			task.wait(started and .25 or .05)
			if _G.ElysiumOptimizerMode=="default"then
				continue
			end
			if busy()and _G.ElysiumHoldingForPickup~=true then
				continue
			end
			_G.SXE_FlushKills()
			if not started then
				local ok,err=pcall(__sxeStrip)
				if ok then
					started=true
					_G.ElysiumOptimizerWorldReady=true
					_G.ElysiumOptimizerFull=true
					_G.ElysiumOptimizerReady=true
					_G.ElysiumOptimizerError=nil
				else
					_G.ElysiumOptimizerError=tostring(err)
				end
			end
		end
	end)
end
_G.ElysiumIncomingSlots={}
do
	if _G.ElysiumThiefBaseVisibility then
		_G.ElysiumThiefBaseVisibility.Destroy()
	end
	local players=ElysiumService("Players")
	local world=ElysiumService("Workspace")
	local localPlayer=players.LocalPlayer
	local state={}
	local function predictDeliverySlot(plot,list)
		if type(list)~="table"then
			return nil
		end
		local podiums=plot:FindFirstChild("AnimalPodiums")
		if not podiums then
			return nil
		end
		local candidates={}
		for _,podium in ipairs(podiums:GetChildren())do
			local number=tonumber(podium.Name)
			if not number or podium:GetAttribute("Locked")==true then
				continue
			end
			local entry=list[podium.Name]
			if entry==nil then
				entry=list[number]
			end
			local empty=entry==nil or entry==false or entry=="Empty"or entry==""
			if not empty then
				continue
			end
			local base=podium:FindFirstChild("Base")
			local spawn=podium:FindFirstChild("Spawn")or(base and base:FindFirstChild("Spawn"))
			if spawn and(spawn:IsA("BasePart")or spawn:IsA("Attachment"))then
				candidates[#candidates+1]={slot=podium.Name,number=number,podium=podium,anchor=spawn}
			end
		end
		table.sort(candidates,function(a,b)
			return a.number<b.number
		end)
		return candidates[1]
	end
	local function ownerPlayer(owner)
		if typeof(owner)=="Instance"and owner:IsA("Player")then
			return owner
		end
		if type(owner)=="table"then
			owner=owner.UserId or owner.Name
		end
		for _,player in ipairs(players:GetPlayers())do
			if
				owner==player.UserId
				or tostring(owner)==tostring(player.UserId)
				or owner==player.Name
				or owner==player.DisplayName
			then
				return player
			end
		end
	end
	local function carried(player)
		if not player then
			return false,nil
		end
		local char=player.Character
		local flag=player:GetAttribute("Stealing")
		if flag==nil and char then
			flag=char:GetAttribute("Stealing")
		end
		local index=player:GetAttribute("StealingIndex")
		if index==nil and char then
			index=char:GetAttribute("StealingIndex")
		end
		if flag==false then
			return false,nil
		end
		if flag~=true and(index==nil or tostring(index)=="")then
			return false,nil
		end
		local name=index~=nil and tostring(index)or"название ещё не получено"
		local info=AnimalsData and AnimalsData[name]
		if type(info)=="table"then
			name=tostring(info.DisplayName or info.Name or name)
		end
		return true,name,index
	end
	local function clearMarker(data)
		if data.marker then
			data.marker:Destroy()
			data.marker=nil
			data.markerText=nil
		end
		if data.highlight then
			data.highlight:Destroy()
			data.highlight=nil
		end
	end
	local function markSlot(data,prediction,name,confirmed)
		if _G.ElysiumOptimizerMode=="default"then clearMarker(data);return end
		if not prediction or not prediction.anchor.Parent then
			clearMarker(data)
			return
		end
		if not data.marker then
			local gui=Instance.new("BillboardGui")
			gui.Name="ElysiumDeliveryPrediction"
			gui.Size=UDim2.fromOffset(180,34)
			gui.StudsOffsetWorldSpace=Vector3.new(0,4,0)
			gui.AlwaysOnTop=true
			gui.MaxDistance=600
			gui.Parent=localPlayer:FindFirstChildOfClass("PlayerGui")
			local text=Instance.new("TextLabel",gui)
			text.Size=UDim2.fromScale(1,1)
			text.BackgroundColor3=Color3.fromRGB(20,20,22)
			text.BackgroundTransparency=.15
			text.BorderSizePixel=0
			text.TextWrapped=true
			text.Font=Enum.Font.GothamBold
			text.TextSize=10
			text.TextColor3=Color3.fromRGB(255,218,90)
			Instance.new("UICorner",text).CornerRadius=UDim.new(0,7)
			local highlight=Instance.new("Highlight")
			highlight.Name="ElysiumDeliverySlot"
			highlight.FillColor=Color3.fromRGB(255,210,65)
			highlight.OutlineColor=Color3.fromRGB(255,235,145)
			highlight.FillTransparency=.8
			highlight.DepthMode=Enum.HighlightDepthMode.AlwaysOnTop
			highlight.Parent=gui
			data.marker=gui
			data.markerText=text
			data.highlight=highlight
		end
		data.marker.Adornee=prediction.anchor
		data.highlight.Adornee=prediction.podium
		local phase=confirmed and"ARRIVED"or"EXPECTED"
		data.markerText.Text=phase.." · SLOT #"..prediction.slot.."\n"..tostring(name)
	end
	local function clear(plot,data)
		_G.ElysiumIncomingSlots[plot.Name]=nil
		if data.gui then
			data.gui:Destroy()
		end
		clearMarker(data)
		state[plot]=nil
	end
	local function label(plot,data,text)
		if _G.ElysiumOptimizerMode=="default"then
			if data.gui then data.gui:Destroy();data.gui=nil;data.text=nil end
			return
		end
		local root=plot:FindFirstChild("MainRoot")
			or plot:FindFirstChild("Spawn")
			or plot.PrimaryPart
			or plot:FindFirstChildWhichIsA("BasePart",true)
		if not root or not root:IsA("BasePart")then
			return
		end
		if not data.gui then
			local gui=Instance.new("BillboardGui")
			gui.Name="ElysiumActiveThiefBase"
			gui.Size=UDim2.fromOffset(220,54)
			gui.StudsOffsetWorldSpace=Vector3.new(0,20,0)
			gui.AlwaysOnTop=true
			gui.MaxDistance=2500
			gui.Parent=localPlayer:FindFirstChildOfClass("PlayerGui")
			local textLabel=Instance.new("TextLabel",gui)
			textLabel.Size=UDim2.fromScale(1,1)
			textLabel.BackgroundColor3=Color3.fromRGB(15,15,17)
			textLabel.BackgroundTransparency=.15
			textLabel.BorderSizePixel=0
			textLabel.Font=Enum.Font.GothamBold
			textLabel.TextSize=10
			textLabel.TextColor3=Color3.fromRGB(255,255,255)
			textLabel.TextWrapped=true
			Instance.new("UICorner",textLabel).CornerRadius=UDim.new(0,8)
			data.gui=gui
			data.text=textLabel
		end
		data.gui.Adornee=root
		data.text.Text=text
	end
	local function tickBases()
		local plots=world:FindFirstChild("Plots")
		if not plots then
			return
		end
		for _,plot in ipairs(plots:GetChildren())do
			if not plot:IsA("Model")then
				continue
			end
			local data=state[plot]
			if not data then
				data={lastTheft=0}
				state[plot]=data
			end
			local channel=getPlotChannel(plot.Name)
			local owner=ownerPlayer(channelGet(channel,"Owner"))
			local stealing,name,index=carried(owner)
			local animals=channelGet(channel,"AnimalList")
			if stealing and(not data.wasStealing or data.carryIndex~=index)then
				data.prediction=nil
				data.carryIndex=index
			end
			local confirmed=false
			if data.prediction and type(animals)=="table"then
				local entry=animals[data.prediction.slot]or animals[tonumber(data.prediction.slot)]
				confirmed=type(entry)=="table"and entry.Index==data.carryIndex and data.carryIndex~=nil
			end
			if stealing and not confirmed then
				data.prediction=predictDeliverySlot(plot,animals)
			end
			data.wasStealing=stealing
			if stealing then
				data.lastTheft=os.clock()
				data.lastName=name
			end
			local recent=data.lastTheft>0 and os.clock()-data.lastTheft<8
			if stealing or recent then
				local ownerName=owner and owner.Name or"unknown"
				local phase=stealing and"CARRYING: "or"LAST CARRY: "
				local slotText=data.prediction
						and("\n"..(confirmed and"ARRIVED: #"or"EXPECTED SLOT: #")..data.prediction.slot)
					or(stealing and"\nSlot unknown"or"")
				label(
					plot,
					data,
					"BASE: @"..ownerName.."\n"..phase..tostring(name or data.lastName)..slotText
				)
				markSlot(data,data.prediction,name or data.lastName,confirmed)
				_G.ElysiumIncomingSlots[plot.Name]=data.prediction
						and{
							plot=plot.Name,
							slot=data.prediction.slot,
							anchor=data.prediction.anchor,
							name=name or data.lastName,
							index=data.carryIndex,
						}
					or nil
			else
				if data.gui then
					data.gui:Destroy()
					data.gui=nil
					data.text=nil
				end
				clearMarker(data)
				data.prediction=nil
				_G.ElysiumIncomingSlots[plot.Name]=nil
			end
		end
		for plot,data in pairs(state)do
			if not plot.Parent then
				clear(plot,data)
			end
		end
	end
	local elapsed=0
	local heartbeat=ElysiumService("RunService").Heartbeat:Connect(function(dt)
		elapsed+=dt
		if elapsed<.15 then
			return
		end
		elapsed=0
		local ok,err=pcall(tickBases)
		_G.ElysiumBaseVisibilityError=not ok and tostring(err)or nil
	end)
	_G.ElysiumThiefBaseVisibility={
		Destroy=function()
			heartbeat:Disconnect()
			for plot,data in pairs(state)do
				clear(plot,data)
			end
		end,
	}
end
do
	local saved=setmetatable({},{__mode="k"})
	local candidates=setmetatable({},{__mode="k"})
	local hooked=setmetatable({},{__mode="k"})
	local names,namesSource={},nil
	local seeded,lastSeed,seedGen=false,0,0
	local function remember(object,property,value)
		local properties=saved[object]
		if not properties then properties={};saved[object]=properties end
		if properties[property]==nil then
			properties[property]={old=object[property],hidden=value}
		elseif object[property]==value then
			return
		end
		object[property]=value
	end
	local function conceal(object)
		if object:IsA("BasePart")then
			remember(object,"Transparency",1)
			remember(object,"LocalTransparencyModifier",1)
		elseif object:IsA("Decal")or object:IsA("Texture")then
			remember(object,"Transparency",1)
		elseif object:IsA("ParticleEmitter")or object:IsA("Beam")or object:IsA("Trail")
			or object:IsA("Highlight")then remember(object,"Enabled",false)end
	end
	local function restore(object)
		local properties=saved[object]
		if not properties then return end
		for key,entry in pairs(properties)do
			pcall(function()if object[key]==entry.hidden then object[key]=entry.old end end)
		end
		saved[object]=nil
	end
	local function loadNames()
		if AnimalsData~=namesSource then
			namesSource=AnimalsData;names={}
			for key,info in pairs(type(AnimalsData)=="table"and AnimalsData or{})do
				names[tostring(key)]=true
				if type(info)=="table"and type(info.DisplayName)=="string"then names[info.DisplayName]=true end
			end
			seeded=false
		end
	end
	local function isCandidate(object)
		if object.ClassName~="Model"then return false end
		if names[object.Name]then return true end
		return names[tostring(object:GetAttribute("Index"))]==true
	end
	local function insideCharacter(object)
		local at=object
		while at and at~=workspace do
			if at:FindFirstChildOfClass("Humanoid")then return true end
			at=at.Parent
		end
		return false
	end
	local function live(model)
		return model.Parent~=nil and model:IsDescendantOf(workspace)and not insideCharacter(model)
	end
	local function concealModel(model)
		if hooked[model]then return end
		hooked[model]=model.DescendantAdded:Connect(function(child)
			if _G.ElysiumOptimizerMode=="default"then pcall(conceal,child)end
		end)
		for _,child in ipairs(model:GetDescendants())do pcall(conceal,child)end
	end
	local function releaseModel(model)
		local connection=hooked[model]
		hooked[model]=nil
		if connection then pcall(function()connection:Disconnect()end)end
		local ok,list=pcall(function()return model:GetDescendants()end)
		if ok then for _,child in ipairs(list)do restore(child)end end
	end
	local function track(model)
		candidates[model]=true
		if _G.ElysiumOptimizerMode=="default"and _G.ElysiumHideAllBrainrots~=false and live(model)then
			concealModel(model)
		end
	end
	local function seed()
		seedGen=seedGen+1
		local gen=seedGen
		seeded,lastSeed=true,os.clock()
		task.spawn(function()
			local step=math.max(50,tonumber(_G.ElysiumVisualSeedStep)or 400)
			local stack,count={workspace},0
			while#stack>0 do
				if gen~=seedGen or _G.ElysiumOptimizerMode~="default"then return end
				local node=table.remove(stack)
				local ok,kids=pcall(node.GetChildren,node)
				if ok then
					for i=1,#kids do
						local child=kids[i]
						if child.ClassName=="Model"and isCandidate(child)then
							pcall(track,child)
						elseif child.ClassName~="Terrain"and child.ClassName~="Camera"then
							stack[#stack+1]=child
						end
					end
				end
				count=count+1
				if count%step==0 then task.wait()end
			end
		end)
	end
	workspace.DescendantAdded:Connect(function(object)
		if object.ClassName=="Model"and _G.ElysiumOptimizerMode=="default"then
			pcall(function()
				if isCandidate(object)then track(object)end
			end)
		end
	end)
	local function releaseAll()
		for model in pairs(hooked)do releaseModel(model)end
		for object in pairs(saved)do restore(object)end
	end
	local function refresh()
		if _G.ElysiumOptimizerMode~="default"or _G.ElysiumHideAllBrainrots==false then
			if next(saved)or next(hooked)then releaseAll()end
			if _G.ElysiumOptimizerMode~="default"then
				seeded=false
				seedGen=seedGen+1
			end
			return
		end
		loadNames()
		if not seeded then seed()end
		local models=0
		for object in pairs(candidates)do
			if live(object)then
				models=models+1
				if not hooked[object]then concealModel(object)end
			else
				if hooked[object]then releaseModel(object)end
				if object.Parent==nil then candidates[object]=nil end
			end
		end
		_G.ElysiumVisualHiddenModels=models
	end
	local function reapply()
		for object,properties in pairs(saved)do
			for key,entry in pairs(properties)do
				if object[key]~=entry.hidden then pcall(function()object[key]=entry.hidden end)end
			end
		end
	end
	_G.ElysiumImmediateVisualRefresh=refresh
	task.spawn(function()
		local lastReapply=0
		while _G.ElysiumMainLoadedGame==game do
			if _G.ElysiumOptimizerMode=="default"then
				loadNames()
				if not seeded or os.clock()-lastSeed>(tonumber(_G.ElysiumVisualReseed)or 60)then seed()end
			end
			local ok,err=pcall(refresh)
			if not ok then _G.ElysiumImmediateVisualError=tostring(err)end
			if _G.ElysiumOptimizerMode=="default"and os.clock()-lastReapply>(tonumber(_G.ElysiumVisualReapply)or 1)then
				lastReapply=os.clock()
				pcall(reapply)
			end
			task.wait(tonumber(_G.ElysiumVisualTick)or .2)
		end
		seedGen=seedGen+1
		releaseAll()
	end)
end