if isfunctionhooked(loadstring) then restorefunction(loadstring) end

local _ORIG_LS = clonefunction(loadstring)
local _ORIG_REQ = clonefunction(request or function() end)
local _ORIG_PRINT = clonefunction(print)
local _ORIG_WARN = clonefunction(warn)
local _ORIG_HTTPGET

local SESSION = tostring(math.floor(tick()))
local ROOT = "DUMP_" .. SESSION
local PAYLOADS = ROOT .. "/payloads"
local ENV_DIR = ROOT .. "/env"
local HTTP_DIR = ROOT .. "/http"
local WSS_DIR = ROOT .. "/wss"
local META_DIR = ROOT .. "/metamethods"
local UPVAL_DIR = ROOT .. "/upvalues"
local INSTANCE_DIR = ROOT .. "/instances"
local FFLAG_DIR = ROOT .. "/fflags"
local PRINT_DIR = ROOT .. "/prints"
local AI_DIR = ROOT .. "/ai_analysis"
local DECOMP_DIR = ROOT .. "/decompiled"
local STEPS_FILE = ROOT .. "/loader_steps.txt"
local README_FILE = ROOT .. "/README.txt"
local ENV_LOG = ROOT .. "/env_logger.txt"
local MASTER_LOG = ROOT .. "/master_log.txt"
local HTTPGET_LOG = ROOT .. "/httpget_chain.txt"

local DIRS = {ROOT,PAYLOADS,ENV_DIR,HTTP_DIR,WSS_DIR,META_DIR,UPVAL_DIR,INSTANCE_DIR,FFLAG_DIR,PRINT_DIR,AI_DIR,DECOMP_DIR}
for _,d in ipairs(DIRS) do
    if not isfolder(d) then makefolder(d) end
end

local function fw(p,c) pcall(writefile, p, tostring(c or "")) end
local function fa(p,c) pcall(appendfile, p, tostring(c or "") .. "\n") end
local function ts() return "[" .. tostring(math.floor(tick())) .. "] " end
local function ss(v) return tostring(v == nil and "nil" or v) end

fw(ENV_LOG,"") fw(STEPS_FILE,"") fw(MASTER_LOG,"") fw(README_FILE,"") fw(HTTPGET_LOG,"")

local idx = {m1=0,m2=0,m3=0,m4=0,m5=0,m6=0,m7=0,m8=0,m9=0,m10=0,total=0}
local step_n = 0
local detected_loader = "UNKNOWN"
local seen = {}
local payload_idx = 0
local http_idx = 0
local wss_idx = 0
local upval_idx = 0
local decomp_idx = 0
local logcache = {}
local logcount = 0

local function step(tag, detail)
    step_n += 1
    local line = ts() .. "[STEP " .. step_n .. "] [" .. ss(tag) .. "] " .. ss(detail)
    fa(STEPS_FILE, line)
    fa(MASTER_LOG, line)
end

local function mlog(tag, content)
    local key = ss(tag) .. ss(content)
    if logcache[key] then return end
    if logcount > 50000 then return end
    logcache[key] = true
    logcount += 1
    fa(ENV_LOG, ts() .. "[" .. ss(tag) .. "] " .. ss(content))
    fa(MASTER_LOG, ts() .. "[" .. ss(tag) .. "] " .. ss(content))
end

local function fmt(text)
    text = ss(text)
    return text:gsub("table: ",""):gsub("function: ",""):gsub("Ugc","game"):gsub("\n",""):gsub("%s%s+",";"):gsub('""',""):gsub("Workspace","workspace"):gsub("game.Players","Players")
end

local function tblf(tbl, depth)
    depth = depth or 0
    if depth > 4 then return "..." end
    if type(tbl) ~= "table" then
        local r = '"' .. ss(tbl) .. '"'
        return r == '"nil"' and "" or r
    end
    local res, first = "", true
    for i,v in pairs(tbl) do
        if not first then res = res .. ", " end
        first = false
        if type(i) == "string" then res = res .. ss(i) .. " = "
        elseif type(i) == "number" then res = res .. ss(i) .. " = "
        end
        res = res .. tblf(v, depth+1)
    end
    return res
end

local OPCODE_MAP = {
    [0]="MOVE",[1]="LOADNIL",[2]="LOADB",[3]="LOADN",[4]="LOADK",
    [5]="GETGLOBAL",[6]="SETGLOBAL",[7]="GETUPVAL",[8]="SETUPVAL",
    [9]="CLOSEUPVALS",[10]="GETIMPORT",[11]="GETTABLE",[12]="SETTABLE",
    [13]="GETTABLEKS",[14]="SETTABLEKS",[15]="GETTABLEN",[16]="SETTABLEN",
    [17]="NEWCLOSURE",[18]="NAMECALL",[19]="CALL",[20]="RETURN",
    [21]="JUMP",[22]="JUMPBACK",[23]="JUMPIF",[24]="JUMPIFNOT",
    [25]="JUMPIFEQ",[26]="JUMPIFLE",[27]="JUMPIFLT",[28]="JUMPIFNOTEQ",
    [29]="JUMPIFNOTLE",[30]="JUMPIFNOTLT",[31]="ADD",[32]="SUB",
    [33]="MUL",[34]="DIV",[35]="MOD",[36]="POW",[37]="ADDK",
    [38]="SUBK",[39]="MULK",[40]="DIVK",[41]="MODK",[42]="POWK",
    [43]="AND",[44]="OR",[45]="CONCAT",[46]="NOT",[47]="MINUS",
    [48]="LENGTH",[49]="NEWTABLE",[50]="DUPTABLE",[51]="SETLIST",
    [52]="FORNPREP",[53]="FORNLOOP",[54]="FORGLOOP",[55]="FORGPREP_INEXT",
    [56]="FORGLOOP_INEXT",[57]="FORGPREP_NEXT",[58]="FORGLOOP_NEXT",
    [59]="GETVARARGS",[60]="DUPCLOSURE",[61]="PREPVARARGS",[62]="LOADKX",
    [63]="JUMPX",[64]="FASTCALL",[65]="COVERAGE",[66]="CAPTURE",
    [67]="SUBRK",[68]="DIVRK",[69]="FASTCALL1",[70]="FASTCALL2",
    [71]="FASTCALL2K",[72]="FORGPREP",[73]="JUMPXEQKNIL",
    [74]="JUMPXEQKB",[75]="JUMPXEQKN",[76]="JUMPXEQKS",
    [77]="IDIV",[78]="IDIVK",
}

local function safe(fn, ...)
    local ok, r = pcall(fn, ...)
    if ok then return r end
    return nil
end

local function ind(n) return string.rep("  ", n or 0) end

local function repr(v, depth)
    depth = depth or 0
    local t = type(v)
    if t == "string" then
        if #v > 120 then return '"' .. v:sub(1,120) .. '...[' .. #v .. ']"' end
        return '"' .. v:gsub("\n","\\n"):gsub("\r","\\r"):gsub("\t","\\t") .. '"'
    elseif t == "number" then
        if v == math.floor(v) and math.abs(v) < 1e15 then return tostring(math.floor(v)) end
        return string.format("%.10g", v)
    elseif t == "boolean" then return tostring(v)
    elseif t == "nil" then return "nil"
    elseif t == "function" then return "<func:" .. tostring(v) .. ">"
    elseif t == "table" then
        if depth > 2 then return "<table>" end
        local parts, n = {}, 0
        for k,val in pairs(v) do
            n += 1
            if n > 10 then table.insert(parts,"...") break end
            table.insert(parts, ss(k) .. "=" .. repr(val, depth+1))
        end
        return "{" .. table.concat(parts,", ") .. "}"
    else return "<" .. t .. ":" .. ss(v) .. ">" end
end

local function extract_proto(fn)
    local proto = {info={},upvalues={},constants={},instructions={},inner_funcs={}}
    proto.info = safe(debug.getinfo, fn, "nSlu") or {}
    local uv_names = {}
    pcall(function()
        local names = debug.getupvaluenames and debug.getupvaluenames(fn) or {}
        for i,n in ipairs(names) do uv_names[i] = n end
    end)
    local uvs = safe(debug.getupvalues, fn)
    if uvs then
        for i,v in ipairs(uvs) do
            proto.upvalues[i] = {index=i, name=uv_names[i] or ("upval_"..i), type=type(v), value=repr(v), raw=v}
        end
    end
    local consts = safe(debug.getconstants, fn)
    if consts then
        for i,v in ipairs(consts) do
            proto.constants[i] = {index=i, type=type(v), value=repr(v), raw=v}
        end
    end
    local protos = safe(debug.getprotos, fn)
    if protos then
        for i,p in ipairs(protos) do
            if type(p) == "function" then proto.inner_funcs[i] = p end
        end
    end
    local code = safe(debug.getcode, fn)
    if code then
        for i,instr in ipairs(code) do
            if type(instr) == "number" then
                local op = instr % 256
                local a = math.floor(instr/256)%256
                local b = math.floor(instr/65536)%256
                local c = math.floor(instr/16777216)%256
                local d = math.floor(instr/65536)%65536
                proto.instructions[i] = {pc=i,raw=instr,op=op,opname=OPCODE_MAP[op] or ("OP_"..op),a=a,b=b,c=c,d=d}
            end
        end
    end
    return proto
end

local function reconstruct_source(proto, fn_name, depth)
    depth = depth or 0
    local i2 = ind(depth)
    local lines = {}
    local info = proto.info or {}
    local fname = ss(fn_name or info.name or "unknown_func")
    table.insert(lines, i2 .. "-- ==========================================")
    table.insert(lines, i2 .. "-- FUNCTION: " .. fname)
    table.insert(lines, i2 .. "-- SOURCE:   " .. ss(info.source))
    table.insert(lines, i2 .. "-- LINE:     " .. ss(info.linedefined))
    table.insert(lines, i2 .. "-- PARAMS:   " .. ss(info.nparams or info.numparams))
    table.insert(lines, i2 .. "-- WHAT:     " .. ss(info.what))
    table.insert(lines, i2 .. "-- ==========================================")
    local nparams = info.nparams or info.numparams or 0
    local is_vararg = info.isvararg or false
    local param_names = {}
    for p=1,nparams do param_names[p] = "arg"..p end
    if is_vararg then table.insert(param_names,"...") end
    table.insert(lines, i2 .. "local function " .. fname .. "(" .. table.concat(param_names,", ") .. ")")
    if #proto.upvalues > 0 then
        table.insert(lines, i2 .. "  -- [UPVALUES: " .. #proto.upvalues .. "]")
        for _,uv in ipairs(proto.upvalues) do
            table.insert(lines, i2 .. "  -- upval[" .. uv.index .. "] " .. ss(uv.name) .. " : " .. uv.type .. " = " .. uv.value)
        end
    end
    if #proto.constants > 0 then
        table.insert(lines, i2 .. "  -- [CONSTANTS: " .. #proto.constants .. "]")
        for _,c in ipairs(proto.constants) do
            table.insert(lines, i2 .. "  -- k[" .. c.index .. "] : " .. c.type .. " = " .. c.value)
        end
    end
    if #proto.instructions > 0 then
        table.insert(lines, i2 .. "  -- [DISASSEMBLY: " .. #proto.instructions .. " instructions]")
        for _, ins in ipairs(proto.instructions) do
            if ins then
                local op = ins.opname
                local a,b,c,d = ins.a, ins.b, ins.c, ins.d
                local ck_a = proto.constants[a] and proto.constants[a].value
                local ck_b = proto.constants[b] and proto.constants[b].value
                local ck_c = proto.constants[c] and proto.constants[c].value
                local line = ""
                if op=="LOADK" or op=="LOADKX" then
                    line = "local r"..a.." = "..(ck_b or ck_a or "k["..b.."]")
                elseif op=="LOADNIL" then line = "r"..a.."..r"..b.." = nil"
                elseif op=="LOADB" then line = "local r"..a.." = "..ss(b==1)
                elseif op=="LOADN" then line = "local r"..a.." = "..ss(d)
                elseif op=="MOVE" then line = "r"..a.." = r"..b
                elseif op=="GETGLOBAL" or op=="GETIMPORT" then
                    line = "local r"..a.." = "..(ck_b or "global["..b.."]"):gsub('"','')
                elseif op=="SETGLOBAL" then
                    line = (ck_b or "global["..b.."]"):gsub('"','').." = r"..a
                elseif op=="GETUPVAL" then
                    line = "local r"..a.." = "..(proto.upvalues[b] and proto.upvalues[b].name or "upval_"..b)
                elseif op=="SETUPVAL" then
                    line = (proto.upvalues[b] and proto.upvalues[b].name or "upval_"..b).." = r"..a
                elseif op=="GETTABLE" or op=="GETTABLEKS" then
                    line = "local r"..a.." = r"..b.."["..(ck_c or "r"..c).."]"
                elseif op=="SETTABLE" or op=="SETTABLEKS" then
                    line = "r"..a.."["..(ck_b or "r"..b).."] = "..(ck_c or "r"..c)
                elseif op=="GETTABLEN" then line = "local r"..a.." = r"..b.."["..(c+1).."]"
                elseif op=="SETTABLEN" then line = "r"..a.."["..(c+1).."] = r"..b
                elseif op=="CALL" then
                    local narg = b-1
                    local nret = c-1
                    local args = {}
                    for n=1,narg do args[n]="r"..(a+n) end
                    local rets = {}
                    for n=0,nret-1 do rets[n+1]="r"..(a+n) end
                    local rs = #rets>0 and "local "..table.concat(rets,", ").." = " or ""
                    line = rs.."r"..a.."("..table.concat(args,", ")..")"
                elseif op=="NAMECALL" then
                    line = "-- NAMECALL r"..a.." = r"..b..":"..(ck_c or "k["..c.."]"):gsub('"','').."(...)"
                elseif op=="RETURN" then
                    if b==1 then line="return"
                    elseif b==2 then line="return r"..a
                    else
                        local rets={}
                        for n=0,b-2 do rets[n+1]="r"..(a+n) end
                        line="return "..table.concat(rets,", ")
                    end
                elseif op=="JUMP" or op=="JUMPX" then line="goto pc_"..(ins.pc+d)
                elseif op=="JUMPBACK" then line="goto pc_"..(ins.pc-d)
                elseif op=="JUMPIF" then line="if r"..a.." then goto pc_"..(ins.pc+d+1).." end"
                elseif op=="JUMPIFNOT" then line="if not r"..a.." then goto pc_"..(ins.pc+d+1).." end"
                elseif op=="JUMPIFEQ" then line="if r"..a.."==r"..b.." then goto pc_"..(ins.pc+d+1).." end"
                elseif op=="JUMPIFNOTEQ" or op=="JUMPXEQKNIL" or op=="JUMPXEQKB" or op=="JUMPXEQKN" or op=="JUMPXEQKS" then
                    line="if r"..a.."~="..(ck_b or "r"..b).." then goto pc_"..(ins.pc+d+1).." end"
                elseif op=="JUMPIFLT" then line="if r"..a.."<r"..b.." then goto pc_"..(ins.pc+d+1).." end"
                elseif op=="JUMPIFLE" then line="if r"..a.."<=r"..b.." then goto pc_"..(ins.pc+d+1).." end"
                elseif op=="ADD" or op=="ADDK" then line="local r"..a.."=r"..b.."+"..(op=="ADDK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="SUB" or op=="SUBK" then line="local r"..a.."=r"..b.."-"..(op=="SUBK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="MUL" or op=="MULK" then line="local r"..a.."=r"..b.."*"..(op=="MULK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="DIV" or op=="DIVK" then line="local r"..a.."=r"..b.."/"..(op=="DIVK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="IDIV" or op=="IDIVK" then line="local r"..a.."=r"..b.."//"..(op=="IDIVK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="MOD" or op=="MODK" then line="local r"..a.."=r"..b.."%"..(op=="MODK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="POW" or op=="POWK" then line="local r"..a.."=r"..b.."^"..(op=="POWK" and (ck_c or "k["..c.."]") or "r"..c)
                elseif op=="AND" then line="local r"..a.."=r"..b.." and r"..c
                elseif op=="OR" then line="local r"..a.."=r"..b.." or r"..c
                elseif op=="NOT" then line="local r"..a.."=not r"..b
                elseif op=="MINUS" then line="local r"..a.."=-r"..b
                elseif op=="LENGTH" then line="local r"..a.."=#r"..b
                elseif op=="CONCAT" then
                    local parts={}
                    for n=b,c do parts[#parts+1]="r"..n end
                    line="local r"..a.."="..table.concat(parts," .. ")
                elseif op=="NEWTABLE" or op=="DUPTABLE" then line="local r"..a.." = {}"
                elseif op=="SETLIST" then line="-- SETLIST r"..a.."["..c.."..] = r"..(a+1).."..."
                elseif op=="FORNPREP" then line="-- for r"..a.."=r"..(a+2)..",r"..(a+1)..",r"..a.." do"
                elseif op=="FORNLOOP" then line="-- end (FORNLOOP)"
                elseif op=="FORGPREP" or op=="FORGPREP_INEXT" or op=="FORGPREP_NEXT" then line="-- for ... in r"..a.." do"
                elseif op=="FORGLOOP" or op=="FORGLOOP_INEXT" or op=="FORGLOOP_NEXT" then line="-- end (FORGLOOP)"
                elseif op=="NEWCLOSURE" or op=="DUPCLOSURE" then line="local r"..a.." = <closure_"..b..">"
                elseif op=="GETVARARGS" then line="local r"..a.." = ..."
                elseif op=="PREPVARARGS" then line="-- vararg frame"
                elseif op=="CAPTURE" then line="-- capture type="..a.." reg="..b
                elseif op=="FASTCALL" or op=="FASTCALL1" or op=="FASTCALL2" or op=="FASTCALL2K" then line="-- FASTCALL builtin="..a
                elseif op=="COVERAGE" then line="-- coverage"
                else line="-- ["..op.."] A="..a.." B="..b.." C="..c.." D="..d end
                table.insert(lines, i2.."  "..line)
            end
        end
    else
        table.insert(lines, i2.."  -- [NO BYTECODE - C FUNCTION OR PROTECTED]")
    end
    table.insert(lines, i2.."end -- "..fname)
    table.insert(lines, "")
    return lines
end

local function intel_report(proto, fn_name, out)
    local suspicious = {}
    for _,c in ipairs(proto.constants) do
        if c.type=="string" and c.raw then
            local r = c.raw
            if r:find("[Ll]uarmor") then table.insert(suspicious,"LUARMOR_REF: "..c.value) end
            if r:find("https?://") then table.insert(suspicious,"URL: "..c.value) end
            if r:find("loadstring") then table.insert(suspicious,"LOADSTRING_REF: "..c.value) end
            if r:find("getgenv") or r:find("getrenv") then table.insert(suspicious,"ENV_MANIP: "..c.value) end
            if r:find("WebSocket") then table.insert(suspicious,"WSS_REF: "..c.value) end
            if #r>50 and not r:find(" ") then table.insert(suspicious,"ENCODED_STR: "..c.value:sub(1,80)) end
        end
    end
    table.insert(out,"-- [INTEL: "..ss(fn_name).."]")
    if #suspicious>0 then
        table.insert(out,"-- !! SUSPICIOUS:")
        for _,s in ipairs(suspicious) do table.insert(out,"--   >> "..s) end
    end
    table.insert(out,"-- constants="..#proto.constants.." upvals="..#proto.upvalues.." instr="..#proto.instructions.." closures="..#proto.inner_funcs)
    table.insert(out,"-- [END INTEL]")
    table.insert(out,"")
end

local function full_decompile(fn, fn_name, depth, visited, all_lines)
    depth = depth or 0
    visited = visited or {}
    all_lines = all_lines or {}
    if depth>8 then table.insert(all_lines,ind(depth).."-- [MAX DEPTH]") return all_lines end
    local key = tostring(fn)
    if visited[key] then table.insert(all_lines,ind(depth).."-- [VISITED "..key.."]") return all_lines end
    visited[key]=true
    local proto = extract_proto(fn)
    local src = reconstruct_source(proto, fn_name, depth)
    for _,l in ipairs(src) do table.insert(all_lines,l) end
    intel_report(proto, fn_name, all_lines)
    for i,inner in pairs(proto.inner_funcs) do
        full_decompile(inner, ss(fn_name).."_inner"..i, depth+1, visited, all_lines)
    end
    for _,uv in ipairs(proto.upvalues) do
        if type(uv.raw)=="function" then
            full_decompile(uv.raw, uv.name.."_upval", depth+1, visited, all_lines)
        end
    end
    return all_lines
end

local function decompile_and_save(fn, label, trigger_method)
    decomp_idx += 1
    local did = ss(decomp_idx)
    local outfile = DECOMP_DIR.."/decomp_"..did.."_"..ss(label)..".txt"
    local header = {
        "-- ###################################################",
        "-- DECOMPILE #"..did,
        "-- LABEL:   "..ss(label),
        "-- METHOD:  "..ss(trigger_method),
        "-- TYPE:    "..type(fn),
        "-- TIME:    "..ss(tick()),
        "-- ###################################################","",
    }
    local ok, all_lines = pcall(full_decompile, fn, label, 0, {}, {})
    if not ok then all_lines={"-- [DECOMPILE ERROR: "..ss(all_lines).."]"} end
    local final={}
    for _,l in ipairs(header) do table.insert(final,l) end
    for _,l in ipairs(all_lines) do table.insert(final,l) end
    fw(outfile, table.concat(final,"\n"))
    step("DECOMP","#"..did.." "..ss(label).." -> "..outfile)
    return outfile
end

local function ai_classify(chunk)
    local flags,deob,loader={},{}, "UNKNOWN"
    if chunk:find("[Ll]uarmor") then
        loader="LUARMOR"
        table.insert(flags,"LUARMOR_SIG")
        table.insert(deob,"Hook WSS:CreateClient -> URL de validacion")
        table.insert(deob,"Interceptar request() -> endpoint auth")
        table.insert(deob,"Payload llega via loadstring post-auth -> capturado en /payloads")
    end
    if chunk:find("[Ll]uraph") then loader="LURAPH" table.insert(flags,"LURAPH_SIG") table.insert(deob,"VM custom -> dump bytecode via hookfunction(loadstring)") end
    if chunk:find("[Mm]oonveil") then loader="MOONVEIL" table.insert(flags,"MOONVEIL_SIG") end
    if chunk:find("WebSocket") then table.insert(flags,"WSS_AUTH") table.insert(deob,"URL en /wss") end
    if chunk:find("HttpGet") or chunk:find("http%.request") then table.insert(flags,"HTTP_FETCH") table.insert(deob,"URL en /http") end
    if chunk:find("getgenv") then table.insert(flags,"GENV_WRITE") end
    if chunk:find("newcclosure") then table.insert(flags,"NEWCCLOSURE") end
    if chunk:find("hookfunction") then table.insert(flags,"SELF_HOOK") end
    if chunk:find("string%.byte") or chunk:find("bit32") then table.insert(flags,"BYTECODE_OPS") end
    if #flags==0 then table.insert(flags,"CLEAN") table.insert(deob,"Sin firma -> payload legible directo") end
    return loader,flags,deob
end

local function dump_payload(chunk, method_tag)
    if seen[chunk] then return end
    seen[chunk]=true
    payload_idx+=1
    local pid=ss(payload_idx)
    local loader,flags,deob=ai_classify(chunk)
    if loader~="UNKNOWN" then detected_loader=loader end
    local pfile=PAYLOADS.."/payload_"..pid.."_"..ss(method_tag)..".txt"
    fw(pfile,chunk)
    local afile=AI_DIR.."/analysis_"..pid..".txt"
    local abuf="PAYLOAD: "..pid.."\nMETHOD: "..ss(method_tag).."\nLOADER: "..loader.."\nSIZE: "..#chunk.." chars\n\nFLAGS:\n"
    for _,f in ipairs(flags) do abuf=abuf.."  - "..f.."\n" end
    abuf=abuf.."\nDEOB STEPS:\n"
    for i,s in ipairs(deob) do abuf=abuf.."  "..i..". "..s.."\n" end
    abuf=abuf.."\nFILE: "..pfile.."\n"
    fw(afile,abuf)
    step(ss(method_tag),"payload #"..pid.." loader="..loader.." size="..#chunk)
    pcall(function()
        local ok2,fn2=pcall(_ORIG_LS,chunk)
        if ok2 and type(fn2)=="function" then
            decompile_and_save(fn2,"payload_"..pid.."_"..ss(method_tag),"POST_COMPILE")
        end
    end)
end

-- ================================================================
-- HTTPGET CHAIN INTERCEPTOR
-- Captura loadstring(game:HttpGet("URL"))() completo
-- ================================================================
pcall(function()
    local mt = getrawmetatable(game)
    local _nc = clonefunction(mt.__namecall)
    local httpget_pending = {}

    hookmetamethod(game,"__namecall",newcclosure(function(self,...)
        local method = getnamecallmethod()
        local args = {...}

        if method=="HttpGet" or method=="HttpGetAsync" then
            local url = ss(args[1])
            local ok,response = pcall(_nc, self, ...)
            if ok then
                http_idx+=1
                local hfile=HTTP_DIR.."/httpget_"..ss(http_idx)..".txt"
                local body = type(response)=="string" and response or ss(response)
                fw(hfile,"URL: "..url.."\nSIZE: "..#body.."\nBODY:\n"..body)
                fa(HTTPGET_LOG, ts().."HttpGet("..url..") -> "..#body.." chars -> "..hfile)
                step("HTTPGET","url="..url.." size="..#body)
                mlog("HTTPGET",url)
                if #body > 5 then
                    httpget_pending[body]=url
                    dump_payload(body,"HTTPGET_BODY")
                end
                return response
            end
        end

        if method=="loadstring" or method=="Loadstring" then
            local chunk = ss(args[1])
            local origin = httpget_pending[chunk] and ("from HttpGet("..httpget_pending[chunk]..") [CHAIN]") or "direct"
            fa(HTTPGET_LOG, ts().."loadstring via namecall | origin="..origin.." | size="..#chunk)
            dump_payload(chunk,"NAMECALL_LOADSTRING_"..origin:sub(1,30))
        end

        return _nc(self,...)
    end))
end)

-- ================================================================
-- LOADSTRING HOOKS (12 métodos simultáneos)
-- ================================================================
getgenv().__ls_m1 = clonefunction(loadstring)
getgenv().loadstring = newcclosure(function(src,...)
    if type(src)=="string" then dump_payload(src,"M1_NEWCCLOSURE") end
    return getgenv().__ls_m1(src,...)
end)

local _ls_m2=clonefunction(getgenv().loadstring)
hookfunction(getgenv().loadstring,newcclosure(function(src,...)
    if type(src)=="string" then dump_payload(src,"M2_HOOKFUNCTION") end
    return _ls_m2(src,...)
end))

local _ls_m3=clonefunction(loadstring)
_G["loadstring"]=newcclosure(function(src,...)
    if type(src)=="string" then dump_payload(src,"M3_G_OVERRIDE") end
    return _ls_m3(src,...)
end)

pcall(function()
    local renv=getrenv()
    local _ls_m4=clonefunction(renv.loadstring or loadstring)
    renv.loadstring=newcclosure(function(src,...)
        if type(src)=="string" then dump_payload(src,"M4_GETRENV") end
        return _ls_m4(src,...)
    end)
end)

pcall(function()
    local function scanupvals(fn,label)
        if type(fn)~="function" then return end
        local ok,uvs=pcall(debug.getupvalues,fn)
        if not ok or type(uvs)~="table" then return end
        upval_idx+=1
        local ufile=UPVAL_DIR.."/upvals_"..ss(upval_idx).."_"..ss(label)..".txt"
        local buf="FUNCTION: "..ss(label).."\n"
        for i,v in pairs(uvs) do
            local line=ss(i).." = "..ss(v)
            buf=buf..line.."\n"
            if type(v)=="string" and #v>20 then dump_payload(v,"M5_UPVALUE_"..ss(label)) end
        end
        fw(ufile,buf)
        step("M5_UPVALUE",ss(label).." -> "..ufile)
    end
    scanupvals(loadstring,"loadstring")
    scanupvals(request or function()end,"request")
end)

pcall(function()
    local _req=clonefunction(request or (http and http.request) or function()end)
    request=newcclosure(function(data)
        http_idx+=1
        local hfile=HTTP_DIR.."/request_"..ss(http_idx)..".txt"
        local meow=type(data.Body)=="string" and data.Body or ss(data.Body)
        local buf="URL: "..ss(data.Url).."\nMETHOD: "..ss(data.Method).."\nBODY: "..meow.."\n"
        if data.Headers then
            for k,v in pairs(data.Headers) do buf=buf..ss(k)..": "..ss(v).."\n" end
        end
        fw(hfile,buf)
        step("M6_REQUEST","url="..ss(data.Url))
        mlog("HTTP",ss(data.Url))
        local res=_req(data)
        if type(res)=="table" and type(res.Body)=="string" and #res.Body>5 then
            fw(HTTP_DIR.."/response_"..ss(http_idx)..".txt",res.Body)
            dump_payload(res.Body,"M6_HTTP_RESPONSE")
        end
        return res
    end)
end)

pcall(function()
    local wss=game:GetService("WebSocketService")
    local _wcc=clonefunction(wss.CreateClient)
    hookfunction(wss.CreateClient,newcclosure(function(self,url)
        wss_idx+=1
        local wfile=WSS_DIR.."/wss_"..ss(wss_idx)..".txt"
        fw(wfile,"URL: "..ss(url))
        step("M7_WSS","url="..ss(url))
        mlog("WSS",ss(url))
        local client=_wcc(self,url)
        if client then
            pcall(function()
                client.OnMessage:Connect(function(msg)
                    fa(wfile,"MSG: "..ss(msg))
                    if type(msg)=="string" and #msg>10 then dump_payload(msg,"M7_WSS_MSG") end
                end)
            end)
        end
        return client
    end))
end)

pcall(function()
    local _sf=clonefunction(setfflag)
    setfflag=newcclosure(function(flag,state)
        fw(FFLAG_DIR.."/"..ss(flag)..".txt","FLAG: "..ss(flag).."\nSTATE: "..ss(state))
        step("M8_FFLAG",ss(flag).."="..ss(state))
        return _sf(flag,state)
    end)
end)

pcall(function()
    local mt=getrawmetatable(game)
    local _idx=clonefunction(mt.__index)
    local _ni=clonefunction(mt.__newindex)
    hookmetamethod(game,"__index",newcclosure(function(self,k,...)
        if checkcaller() then
            local ok,v=pcall(_idx,self,k,...)
            if ok then
                mlog("META_IDX",ss(self):sub(1,60).."."..ss(k))
                fa(META_DIR.."/index.txt",ts()..ss(self):sub(1,60).."."..ss(k))
                return v
            end
        end
        return _idx(self,k,...)
    end))
    hookmetamethod(game,"__newindex",newcclosure(function(self,k,v)
        if checkcaller() then
            mlog("META_NEWIDX",ss(self):sub(1,40).."."..ss(k).."="..ss(v))
            fa(META_DIR.."/newindex.txt",ts()..ss(self):sub(1,40).."."..ss(k).."="..ss(v))
        end
        return _ni(self,k,v)
    end))
end)

print=newcclosure(function(...)
    if checkcaller() then
        local parts={}
        for i=1,select("#",...) do
            local v=select(i,...)
            parts[i]=type(v)=="table" and tblf(v) or ss(v)
        end
        local line=table.concat(parts,"\t")
        fa(PRINT_DIR.."/prints.txt",ts().."print: "..line)
        mlog("PRINT",line)
    end
    return _ORIG_PRINT(...)
end)

warn=newcclosure(function(...)
    if checkcaller() then
        local parts={}
        for i=1,select("#",...) do
            local v=select(i,...)
            parts[i]=type(v)=="table" and tblf(v) or ss(v)
        end
        local line=table.concat(parts,"\t")
        fa(PRINT_DIR.."/warns.txt",ts().."warn: "..line)
        mlog("WARN",line)
    end
    return _ORIG_WARN(...)
end)

local function scan_env(env,label,outfile)
    fw(outfile,"")
    for k,v in pairs(env) do
        local line=ss(label).."."..ss(k).." = "..tblf(v)
        fa(outfile,line)
        mlog("ENV",line)
    end
end
pcall(scan_env,getgenv(),"getgenv()",ENV_DIR.."/genv.txt")
pcall(scan_env,getrenv(),"getrenv()",ENV_DIR.."/renv.txt")
pcall(scan_env,_G,"_G",ENV_DIR.."/G.txt")

pcall(function()
    local Track={}
    local _inew=clonefunction(Instance.new)
    setreadonly(Instance,false)
    Instance.new=newcclosure(function(name,parent)
        if checkcaller() then
            local inst=_inew(name,parent)
            Track[inst]=ss(name)
            fa(INSTANCE_DIR.."/instances.txt",ts()..'Instance.new("'..ss(name)..'")')
            mlog("INSTANCE",ss(name))
            return inst
        end
        return _inew(name,parent)
    end)
    setreadonly(Instance,true)
    game.DescendantRemoving:Connect(function(a) Track[a]=nil end)
end)

task.spawn(function()
    task.wait(2)
    local n=0
    for k,v in pairs(getgenv()) do
        if type(v)=="function" and n<60 then
            pcall(decompile_and_save,v,"genv_"..ss(k),"GENV_SCAN")
            n+=1
        end
    end
    step("DECOMP_GENV","scanned "..n.." functions")
end)

task.spawn(function()
    task.wait(3)
    local n=0
    for k,v in pairs(_G) do
        if type(v)=="function" and n<60 then
            pcall(decompile_and_save,v,"_G_"..ss(k),"G_SCAN")
            n+=1
        end
    end
    step("DECOMP_G","scanned "..n.." functions")
end)

local function build_readme()
    local buf="ONYX DUMP - SESSION: "..SESSION.."\n"
    buf=buf.."LOADER: "..detected_loader.."\n"
    buf=buf.."PAYLOADS: "..ss(payload_idx).."\n"
    buf=buf.."HTTP: "..ss(http_idx).."\n"
    buf=buf.."WSS: "..ss(wss_idx).."\n"
    buf=buf.."DECOMPILATIONS: "..ss(decomp_idx).."\n"
    buf=buf.."STEPS: "..ss(step_n).."\n\n"
    buf=buf.."FOLDERS:\n"
    buf=buf.."  "..ROOT.."/\n"
    buf=buf.."  ├─ payloads/           chunks capturados\n"
    buf=buf.."  ├─ decompiled/         decompilacion completa por funcion\n"
    buf=buf.."  ├─ ai_analysis/        flags + pasos de deob por payload\n"
    buf=buf.."  ├─ http/               HttpGet URLs + responses\n"
    buf=buf.."  ├─ wss/                WebSocket URLs + mensajes\n"
    buf=buf.."  ├─ env/                genv / renv / _G scan\n"
    buf=buf.."  ├─ metamethods/        __index / __newindex logs\n"
    buf=buf.."  ├─ upvalues/           upvalue dumps\n"
    buf=buf.."  ├─ instances/          Instance.new tracker\n"
    buf=buf.."  ├─ fflags/             setfflag calls\n"
    buf=buf.."  ├─ prints/             print + warn\n"
    buf=buf.."  ├─ httpget_chain.txt   cadena HttpGet->loadstring completa\n"
    buf=buf.."  ├─ loader_steps.txt    timeline del loader\n"
    buf=buf.."  ├─ env_logger.txt      env logger\n"
    buf=buf.."  ├─ master_log.txt      todo unificado\n"
    buf=buf.."  └─ README.txt          este archivo\n\n"
    if detected_loader~="UNKNOWN" then
        buf=buf.."DEOB GUIDE -> ver decompiled/ + ai_analysis/\n"
        if payload_idx>0 then buf=buf.."PAYLOAD LEGIBLE -> payloads/payload_1_*.txt\n" end
    end
    fw(README_FILE,buf)
end

build_readme()
task.spawn(function() while task.wait(5) do build_readme() end end)
step("INIT","session="..SESSION.." root="..ROOT)