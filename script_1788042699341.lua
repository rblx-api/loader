--[[ v1.0.0 Srick VM ]]
return(function(...)
local _n,_q,_z=select,pcall,type
local _j1,_j2=0,false
local n={"\107\044\214\159\036\180\043\072\107\044\214\159\036\180\043\072\107\044\214\159\036"}
local K={25,94,164,237,86,198,89,58}
local char,byte,concat=string.char,string.byte,table.concat
local bxor
if bit32 and bit32.bxor then
 bxor=bit32.bxor
elseif bit and bit.bxor then
 bxor=bit.bxor
else
 bxor=function(a,b)
  local r,p=0,1
  a=a%256
  b=b%256
  for _=1,8 do
   local x,y=a%2,b%2
   if x~=y then r=r+p end
   a=(a-x)/2
   b=(b-y)/2
   p=p*2
  end
  return r
 end
end
local function dec(s)
 local o={}
 for i=1,#s do
  o[i]=char(bxor(byte(s,i),K[((i-1)%#K)+1]))
 end
 return concat(o)
end
local buf={}
for i=1,#n do
 buf[i]=dec(n[i])
end
local src=concat(buf)
local loader=loadstring or load
if not loader then
 error("este ejecutor no tiene loadstring/load")
end
local fn,err=loader(src)
if not fn then
 error(err or "error al cargar el script")
end
if setfenv and getfenv then
 pcall(setfenv,fn,getfenv())
end
return fn()
end)()
