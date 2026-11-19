local DEOB_DIR = ROOT .. "/deobfuscated"
if not isfolder(DEOB_DIR) then makefolder(DEOB_DIR) end

local deob_idx = 0

local AUDIO_ID   = "0"
local _audio_ref = nil

local function play_greengiant()
    task.spawn(function()
        pcall(function()

            if _audio_ref and _audio_ref.Parent then
                _audio_ref:Stop()
                _audio_ref:Destroy()
            end
            local ss = game:GetService("SoundService")
            local s  = Instance.new("Sound")
            s.SoundId   = "rbxassetid://" .. AUDIO_ID
            s.Volume    = 1
            s.Name      = "GreenGiantAudio"
            s.Parent    = ss
            _audio_ref  = s
            s:Play()
            step("AUDIO", "greengiant_audio -> rbxassetid://" .. AUDIO_ID)
            s.Ended:Connect(function()
                pcall(function() s:Destroy() end)
            end)
        end)
    end)
end

local function inject_compat_globals()
    local g = getgenv()

    if not g.getfenv then
        g.getfenv = function(f)

            if f == 0 or f == nil then return g end
            return g
        end
        step("COMPAT", "getfenv injected")
    end
    if not g.setfenv then
        g.setfenv = function(f, env)

            if type(env) == "table" then
                for k, v in pairs(env) do
                    if type(k) == "string" then g[k] = v end
                end
            end
            return env
        end
        step("COMPAT", "setfenv injected")
    end

    if not g.bit then
        g.bit = {
            band    = function(a, b) return a & b end,
            bor     = function(a, b) return a | b end,
            bxor    = function(a, b) return a ~ b end,
            bnot    = function(a)    return ~a    end,
            lshift  = function(a, b) return a << b end,
            rshift  = function(a, b) return a >> b end,
            arshift = function(a, b) return a >> b end,
            tobit   = function(a)    return a      end,
            tohex   = function(a, n)
                local fmt = n and ("%0" .. tostring(n) .. "x") or "%x"
                return string.format(fmt, a)
            end,
        }
        step("COMPAT", "bit library injected")
    end

    if not g.newproxy then
        g.newproxy = function(mt)
            local t = setmetatable({}, type(mt) == "table" and mt or nil)
            return t
        end
        step("COMPAT", "newproxy injected")
    end

    if not g.unpack then
        g.unpack = table.unpack
        step("COMPAT", "unpack injected")
    end
end

inject_compat_globals()
step("COMPAT", "globals OK")

local _orig_spawn = task.spawn
task.spawn = function(fn, ...)
    if type(fn) ~= "function" then
        return _orig_spawn(fn, ...)
    end
    return _orig_spawn(function(...)
        local ok, err = pcall(fn, ...)
        if not ok then
            step("SPAWN_ERR", tostring(err):sub(1, 120))
        end
    end, ...)
end
step("TASK_HOOK", "task.spawn wrapped")

local _real_ls = (type(getgenv()._ORIG_LS) == "function")
    and getgenv()._ORIG_LS
    or  loadstring

local _prev_ls = getgenv().loadstring

local _effective_ls = (type(_prev_ls) == "function" and _prev_ls ~= loadstring)
    and _prev_ls
    or  _real_ls

local _obf_count = 0

local function is_obf_chunkname(s)
    return type(s) == "string"
        and #s > 14
        and s:match("^[A-Za-z0-9]+$") ~= nil
        and s:match("[A-Z]") ~= nil
        and s:match("[a-z]") ~= nil
end

getgenv().loadstring = function(chunk, chunkname, ...)

    if type(chunk) ~= "string" or #chunk == 0 then
        step("LS_GUARD", "chunk invalido: " .. type(chunk) .. " | " .. tostring(chunkname))
        return nil, "DEOB_ENGINE: chunk invalido (" .. type(chunk) .. ")"
    end

    if is_obf_chunkname(chunkname) then
        _obf_count += 1
        step("LS_OBF", "#" .. _obf_count .. " | name=" .. chunkname)

        if _obf_count == 2 then
            step("AUDIO_TRIG", "2do script -> play greengiant")
            play_greengiant()
        end

        local ok, result = pcall(_effective_ls, chunk, chunkname, ...)
        if not ok or type(result) ~= "function" then
            step("LS_COMPILE_ERR", chunkname .. ": " .. tostring(result))
            return nil, tostring(result)
        end

        return function(...)
            local ok2, val = pcall(result, ...)
            if not ok2 then
                step("RT_ERR", "#" .. _obf_count .. " " .. chunkname
                    .. " -> " .. tostring(val))
                return nil
            end
            return val
        end, nil
    end

    return _effective_ls(chunk, chunkname, ...)
end

step("LS_HOOK", "activo | effective=" .. tostring(_effective_ls ~= _real_ls and "prev_hook" or "real_ls"))

local function try_decode_string(s)
    if type(s) ~= "string" or #s == 0 then return s, false end

    pcall(function()
        local decoded = base64decode and base64decode(s)
        if decoded and #decoded > 0 and decoded:find("[%a%d%s%p]") then
            local ratio = 0
            for _ in decoded:gmatch("[%a%d%s%p]") do ratio += 1 end
            if ratio / #decoded > 0.6 then
                return decoded, true
            end
        end
    end)

    if #s <= 4096 then
        for key = 1, 255 do
            local out = {}
            local valid = true
            for i = 1, #s do
                local b = string.byte(s, i) ~ key
                if b < 7 and b ~= 9 and b ~= 10 and b ~= 13 then valid = false break end
                out[i] = string.char(b)
            end
            if valid then
                local decoded = table.concat(out)
                local printable = 0
                for _ in decoded:gmatch("[%a%d%s%p]") do printable += 1 end
                if printable / #decoded > 0.75 and decoded:find("[%a]") then
                    return decoded, true, "XOR_KEY_" .. key
                end
            end
        end
    end

    if s:match("^{[%d,]+}$") then
        local bytes = {}
        for n in s:gmatch("%d+") do table.insert(bytes, string.char(tonumber(n))) end
        local out = table.concat(bytes)
        if out:find("[%a]") then return out, true, "BYTE_ARRAY" end
    end

    if s:match("^[0-9a-fA-F]+$") and #s % 2 == 0 and #s >= 4 then
        local bytes = {}
        for hex in s:gmatch("..") do table.insert(bytes, string.char(tonumber(hex,16))) end
        local out = table.concat(bytes)
        local printable = 0
        for _ in out:gmatch("[%a%d%s%p]") do printable += 1 end
        if printable / #out > 0.7 then return out, true, "HEX" end
    end

    return s, false
end

local function make_namer(proto)
    local names = {}
    local type_hints = {}

    for i, uv in ipairs(proto.upvalues) do
        local uname = uv.name
        if uname and uname ~= "" and not uname:match("^upval_%d+$") then
            type_hints["upval_" .. i] = uname
        end
    end

    local const_names = {}
    for i, c in ipairs(proto.constants) do
        if c.type == "string" and c.raw then
            local r = c.raw
            if r:match("^[%a_][%a%d_]*$") and #r <= 40 then
                const_names[i] = r
            end
        end
    end

    local counter = {}
    local function get_name(reg, hint, force)
        local key = "r" .. tostring(reg)
        if force then names[key] = force return force end
        if names[key] then return names[key] end
        hint = hint or type_hints[key] or "v"
        hint = hint:gsub("[^%a%d_]","_"):gsub("^%d","v%0")
        if #hint > 20 then hint = hint:sub(1,20) end
        counter[hint] = (counter[hint] or 0) + 1
        local n = counter[hint] > 1 and (hint .. counter[hint]) or hint
        names[key] = n
        return n
    end

    return get_name, names, const_names
end

local function analyze_flow(instructions)
    local blocks = {}
    local jump_targets = {}

    for i, ins in ipairs(instructions) do
        if ins then
            local op = ins.opname
            if op:find("JUMP") then
                local target = ins.pc + ins.d + 1
                jump_targets[target] = jump_targets[target] or {}
                table.insert(jump_targets[target], {from=i, op=op, cond=ins.a})
            end
        end
    end

    for pc, jumps in pairs(jump_targets) do
        for _, j in ipairs(jumps) do
            if j.from < pc then

                if j.op == "JUMPIFNOT" or j.op == "JUMPIF" or
                   j.op:find("^JUMPIF") or j.op:find("^JUMPXEQ") then
                    blocks[j.from] = {type="if_start", end_pc=pc-1, cond_reg=j.cond}
                elseif j.op == "JUMP" or j.op == "JUMPX" then
                    blocks[j.from] = {type="else_jump", end_pc=pc-1}
                end
            else

                if j.op == "JUMP" or j.op == "JUMPBACK" then
                    blocks[j.from] = {type="while_end", loop_start=pc}
                end
            end
        end
    end

    return blocks, jump_targets
end

local function reconstruct_lua(fn, fn_name, depth, visited)
    depth = depth or 0
    visited = visited or {}
    local key = tostring(fn)
    if visited[key] or depth > 6 then return "-- [skipped: depth/visited]" end
    visited[key] = true

    local function safe(f, ...) local ok,r = pcall(f,...) if ok then return r end return nil end

    local info = safe(debug.getinfo, fn, "nSlu") or {}
    local upvalues = {}
    local constants = {}
    local instructions = {}
    local inner_protos = {}

    local uv_names = {}
    pcall(function()
        local n = debug.getupvaluenames and debug.getupvaluenames(fn) or {}
        for i,v in ipairs(n) do uv_names[i]=v end
    end)
    local uvs = safe(debug.getupvalues, fn)
    if uvs then
        for i,v in ipairs(uvs) do
            upvalues[i] = {name=uv_names[i] or ("_uv"..i), type=type(v), value=tostring(v):sub(1,80), raw=v}
        end
    end
    local consts = safe(debug.getconstants, fn)
    if consts then
        for i,v in ipairs(consts) do
            local decoded, was_encoded, enc_type = try_decode_string(type(v)=="string" and v or "")
            constants[i] = {type=type(v), raw=v, value=decoded, was_encoded=was_encoded, enc_type=enc_type}
        end
    end
    local protos = safe(debug.getprotos, fn)
    if protos then
        for i,p in ipairs(protos) do if type(p)=="function" then inner_protos[i]=p end end
    end
    local code = safe(debug.getcode, fn)
    if code then
        for i,instr in ipairs(code) do
            if type(instr)=="number" then
                local op=instr%256
                local a=math.floor(instr/256)%256
                local b=math.floor(instr/65536)%256
                local c=math.floor(instr/16777216)%256
                local d=math.floor(instr/65536)%65536
                local OPCODE_MAP={[0]="MOVE",[1]="LOADNIL",[2]="LOADB",[3]="LOADN",[4]="LOADK",[5]="GETGLOBAL",[6]="SETGLOBAL",[7]="GETUPVAL",[8]="SETUPVAL",[9]="CLOSEUPVALS",[10]="GETIMPORT",[11]="GETTABLE",[12]="SETTABLE",[13]="GETTABLEKS",[14]="SETTABLEKS",[15]="GETTABLEN",[16]="SETTABLEN",[17]="NEWCLOSURE",[18]="NAMECALL",[19]="CALL",[20]="RETURN",[21]="JUMP",[22]="JUMPBACK",[23]="JUMPIF",[24]="JUMPIFNOT",[25]="JUMPIFEQ",[26]="JUMPIFLE",[27]="JUMPIFLT",[28]="JUMPIFNOTEQ",[29]="JUMPIFNOTLE",[30]="JUMPIFNOTLT",[31]="ADD",[32]="SUB",[33]="MUL",[34]="DIV",[35]="MOD",[36]="POW",[37]="ADDK",[38]="SUBK",[39]="MULK",[40]="DIVK",[41]="MODK",[42]="POWK",[43]="AND",[44]="OR",[45]="CONCAT",[46]="NOT",[47]="MINUS",[48]="LENGTH",[49]="NEWTABLE",[50]="DUPTABLE",[51]="SETLIST",[52]="FORNPREP",[53]="FORNLOOP",[54]="FORGLOOP",[55]="FORGPREP_INEXT",[56]="FORGLOOP_INEXT",[57]="FORGPREP_NEXT",[58]="FORGLOOP_NEXT",[59]="GETVARARGS",[60]="DUPCLOSURE",[61]="PREPVARARGS",[62]="LOADKX",[63]="JUMPX",[64]="FASTCALL",[65]="COVERAGE",[66]="CAPTURE",[67]="SUBRK",[68]="DIVRK",[69]="FASTCALL1",[70]="FASTCALL2",[71]="FASTCALL2K",[72]="FORGPREP",[73]="JUMPXEQKNIL",[74]="JUMPXEQKB",[75]="JUMPXEQKN",[76]="JUMPXEQKS",[77]="IDIV",[78]="IDIVK"}
                instructions[i]={pc=i,raw=instr,op=op,opname=OPCODE_MAP[op] or ("OP_"..op),a=a,b=b,c=c,d=d}
            end
        end
    end

    local proto = {info=info, upvalues=upvalues, constants=constants, instructions=instructions, inner_funcs=inner_protos}
    local get_name, names, const_names = make_namer(proto)
    local blocks, jump_targets = analyze_flow(instructions)

    local function cv(idx)
        local c = constants[idx]
        if not c then return "nil" end
        if c.type == "string" then
            local s = c.value or ""
            if c.was_encoded then
                return '"' .. s:gsub('"','\\"'):gsub("\n","\\n") .. '" --[[ decoded: ' .. (c.enc_type or "?") .. ' ]]'
            end
            return '"' .. s:gsub('"','\\"'):gsub("\n","\\n") .. '"'
        elseif c.type == "number" then
            local n = c.raw
            if n == math.floor(n) and math.abs(n) < 1e14 then return tostring(math.floor(n)) end
            return string.format("%.10g", n)
        elseif c.type == "boolean" then return tostring(c.raw)
        else return "nil" end
    end

    local function uv_name(i)
        return upvalues[i] and upvalues[i].name or ("_uv"..i)
    end

    local ind_str = string.rep("    ", depth)
    local lines = {}
    local function emit(s) table.insert(lines, ind_str .. s) end
    local function emit_raw(s) table.insert(lines, s) end

    local nparams = info.nparams or info.numparams or 0
    local is_vararg = info.isvararg or false
    local params = {}
    for i = 1, nparams do
        local n = get_name(i, "arg"..i, "arg"..i)
        params[i] = n
    end
    if is_vararg then table.insert(params, "...") end

    local source_note = ""
    if info.source and info.source ~= "" and info.source ~= "?" then
        source_note = " -- source: " .. tostring(info.source)
    end

    local fname = tostring(fn_name or info.name or "func_" .. tostring(math.floor(tick())))
    fname = fname:gsub("[^%a%d_]","_"):gsub("^%d","f%0")

    emit_raw("")
    emit("local function " .. fname .. "(" .. table.concat(params, ", ") .. ")" .. source_note)

    if #upvalues > 0 then
        for i, uv in ipairs(upvalues) do
            if uv.name and not uv.name:match("^_uv%d+$") then
                emit("    -- captures: " .. uv.name .. " (" .. uv.type .. ")")
            end
        end
    end

    if #instructions == 0 then
        emit("    -- [native/C function — no bytecode]")
        emit("end")
        return table.concat(lines, "\n")
    end

    local inner_source = {}
    for i, ip in pairs(inner_protos) do
        inner_source[i] = reconstruct_lua(ip, fname.."_closure"..i, depth+1, visited)
    end

    local scope_depth = 0
    local scope_ind = function() return string.rep("    ", scope_depth + 1) end
    local skip_until = nil
    local emitted_locals = {}
    local for_regs = {}
    local pc = 1

    while pc <= #instructions do
        local ins = instructions[pc]
        if not ins then pc += 1 continue end

        if skip_until and pc <= skip_until then pc += 1 continue end

        local op = ins.opname
        local a, b, c_reg, d = ins.a, ins.b, ins.c, ins.d
        local si = ind_str .. scope_ind()

        local function reg(r, hint)
            return get_name(r, hint)
        end

        local function decl(r, expr, hint)
            local n = reg(r, hint)
            if emitted_locals[r] then
                return n .. " = " .. expr
            else
                emitted_locals[r] = true
                return "local " .. n .. " = " .. expr
            end
        end

        if op == "JUMP" or op == "JUMPX" then
            local target = ins.pc + d + 1
            if target > pc then

            else

                emit_raw(si .. "end -- while")
                scope_depth = math.max(0, scope_depth - 1)
            end

        elseif op == "JUMPBACK" then
            emit_raw(si .. "end -- loop")
            scope_depth = math.max(0, scope_depth - 1)

        elseif op == "JUMPIF" then
            local cond = reg(a)
            emit_raw(si .. "if " .. cond .. " then")
            scope_depth += 1

        elseif op == "JUMPIFNOT" then
            local cond = reg(a)
            emit_raw(si .. "if not " .. cond .. " then")
            scope_depth += 1

        elseif op == "JUMPIFEQ" then
            emit_raw(si .. "if " .. reg(a) .. " == " .. reg(b) .. " then")
            scope_depth += 1

        elseif op == "JUMPIFNOTEQ" then
            emit_raw(si .. "if " .. reg(a) .. " ~= " .. reg(b) .. " then")
            scope_depth += 1

        elseif op == "JUMPIFLT" then
            emit_raw(si .. "if " .. reg(a) .. " < " .. reg(b) .. " then")
            scope_depth += 1

        elseif op == "JUMPIFLE" then
            emit_raw(si .. "if " .. reg(a) .. " <= " .. reg(b) .. " then")
            scope_depth += 1

        elseif op == "JUMPXEQKNIL" then
            emit_raw(si .. "if " .. reg(a) .. " == nil then")
            scope_depth += 1

        elseif op == "JUMPXEQKB" then
            emit_raw(si .. "if " .. reg(a) .. " == " .. tostring(b==1) .. " then")
            scope_depth += 1

        elseif op == "JUMPXEQKN" or op == "JUMPXEQKS" then
            emit_raw(si .. "if " .. reg(a) .. " == " .. cv(d) .. " then")
            scope_depth += 1

        elseif op == "FORNPREP" then
            local var = reg(a+2, "i")
            local limit = reg(a+1, "limit")
            local step_r = reg(a, "step")
            emitted_locals[a+2] = true
            emit_raw(si .. "for " .. var .. " = " .. reg(a+2) .. ", " .. limit .. ", " .. step_r .. " do")
            scope_depth += 1
            for_regs[a] = true

        elseif op == "FORNLOOP" then
            emit_raw(si .. "end")
            scope_depth = math.max(0, scope_depth - 1)

        elseif op == "FORGPREP" or op == "FORGPREP_INEXT" or op == "FORGPREP_NEXT" then

            local iter_vars = {}
            local nxt = instructions[pc+1]
            local nret = nxt and (nxt.c_reg or 2) or 2
            for n = 0, nret-1 do
                local vname = reg(a+3+n, "v"..n)
                emitted_locals[a+3+n] = true
                table.insert(iter_vars, vname)
            end
            emit_raw(si .. "for " .. table.concat(iter_vars, ", ") .. " in " .. reg(a) .. " do")
            scope_depth += 1

        elseif op == "FORGLOOP" or op == "FORGLOOP_INEXT" or op == "FORGLOOP_NEXT" then
            emit_raw(si .. "end")
            scope_depth = math.max(0, scope_depth - 1)

        elseif op == "RETURN" then
            if b == 1 then
                if pc < #instructions then emit_raw(si .. "return") end
            elseif b == 2 then
                emit_raw(si .. "return " .. reg(a))
            else
                local rets = {}
                for n = 0, b-2 do rets[n+1] = reg(a+n) end
                emit_raw(si .. "return " .. table.concat(rets, ", "))
            end

        elseif op == "LOADK" or op == "LOADKX" then
            emit_raw(si .. decl(a, cv(b), const_names[b]))

        elseif op == "LOADNIL" then
            for n = a, b do emit_raw(si .. decl(n, "nil")) end

        elseif op == "LOADB" then
            emit_raw(si .. decl(a, tostring(b==1)))

        elseif op == "LOADN" then
            emit_raw(si .. decl(a, tostring(d)))

        elseif op == "MOVE" then
            if emitted_locals[a] then
                emit_raw(si .. reg(a) .. " = " .. reg(b))
            else
                emitted_locals[a] = true
                emit_raw(si .. "local " .. reg(a) .. " = " .. reg(b))
            end

        elseif op == "GETGLOBAL" or op == "GETIMPORT" then
            local gname = const_names[b] or cv(b):gsub('"','')
            emit_raw(si .. decl(a, gname, gname))

        elseif op == "SETGLOBAL" then
            local gname = const_names[b] or cv(b):gsub('"','')
            emit_raw(si .. gname .. " = " .. reg(a))

        elseif op == "GETUPVAL" then
            emit_raw(si .. decl(a, uv_name(b), uv_name(b)))

        elseif op == "SETUPVAL" then
            emit_raw(si .. uv_name(b) .. " = " .. reg(a))

        elseif op == "GETTABLE" or op == "GETTABLEKS" then
            local key = op=="GETTABLEKS" and cv(c_reg) or reg(c_reg)
            local tname = reg(b)
            local field = key:gsub('"','')
            if field:match("^[%a_][%a%d_]*$") then
                emit_raw(si .. decl(a, tname .. "." .. field, field))
            else
                emit_raw(si .. decl(a, tname .. "[" .. key .. "]"))
            end

        elseif op == "SETTABLE" or op == "SETTABLEKS" then
            local key = op=="SETTABLEKS" and cv(b) or reg(b)
            local val = cv(c_reg):gsub('^"(.*)"$','%1') ~= cv(c_reg) and cv(c_reg) or reg(c_reg)
            local field = key:gsub('"','')
            if field:match("^[%a_][%a%d_]*$") then
                emit_raw(si .. reg(a) .. "." .. field .. " = " .. reg(c_reg))
            else
                emit_raw(si .. reg(a) .. "[" .. key .. "] = " .. reg(c_reg))
            end

        elseif op == "GETTABLEN" then
            emit_raw(si .. decl(a, reg(b) .. "[" .. (c_reg+1) .. "]"))

        elseif op == "SETTABLEN" then
            emit_raw(si .. reg(a) .. "[" .. (c_reg+1) .. "] = " .. reg(b))

        elseif op == "CALL" then
            local narg = b - 1
            local nret = c_reg - 1
            local args = {}
            for n = 1, narg do table.insert(args, reg(a+n)) end
            local call_expr = reg(a) .. "(" .. table.concat(args, ", ") .. ")"
            if nret == 0 then
                emit_raw(si .. call_expr)
            elseif nret == 1 then
                emit_raw(si .. decl(a, call_expr))
            else
                local rets = {}
                for n = 0, nret-1 do
                    emitted_locals[a+n] = true
                    rets[n+1] = reg(a+n)
                end
                emit_raw(si .. "local " .. table.concat(rets,", ") .. " = " .. call_expr)
            end

        elseif op == "NAMECALL" then
            local method = const_names[c_reg] or cv(c_reg):gsub('"','')

            local next_ins = instructions[pc+1]
            if next_ins and next_ins.opname == "CALL" then
                local narg = next_ins.b - 1
                local nret = next_ins.c - 1
                local args = {}
                for n = 1, narg-1 do table.insert(args, reg(a+n+1)) end
                local call_expr = reg(b) .. ":" .. method .. "(" .. table.concat(args, ", ") .. ")"
                if nret == 0 then
                    emit_raw(si .. call_expr)
                elseif nret == 1 then
                    emit_raw(si .. decl(a, call_expr, method))
                else
                    local rets = {}
                    for n = 0, nret-1 do
                        emitted_locals[a+n] = true
                        rets[n+1] = reg(a+n, method..n)
                    end
                    emit_raw(si .. "local " .. table.concat(rets,", ") .. " = " .. call_expr)
                end
                pc += 1
            else
                emit_raw(si .. decl(a, reg(b) .. ":" .. method .. "(...)"))
            end

        elseif op == "ADD" then emit_raw(si .. decl(a, reg(b) .. " + " .. reg(c_reg)))
        elseif op == "ADDK" then emit_raw(si .. decl(a, reg(b) .. " + " .. cv(c_reg)))
        elseif op == "SUB" then emit_raw(si .. decl(a, reg(b) .. " - " .. reg(c_reg)))
        elseif op == "SUBK" then emit_raw(si .. decl(a, reg(b) .. " - " .. cv(c_reg)))
        elseif op == "MUL" then emit_raw(si .. decl(a, reg(b) .. " * " .. reg(c_reg)))
        elseif op == "MULK" then emit_raw(si .. decl(a, reg(b) .. " * " .. cv(c_reg)))
        elseif op == "DIV" then emit_raw(si .. decl(a, reg(b) .. " / " .. reg(c_reg)))
        elseif op == "DIVK" then emit_raw(si .. decl(a, reg(b) .. " / " .. cv(c_reg)))
        elseif op == "IDIV" then emit_raw(si .. decl(a, reg(b) .. " // " .. reg(c_reg)))
        elseif op == "IDIVK" then emit_raw(si .. decl(a, reg(b) .. " // " .. cv(c_reg)))
        elseif op == "MOD" then emit_raw(si .. decl(a, reg(b) .. " % " .. reg(c_reg)))
        elseif op == "MODK" then emit_raw(si .. decl(a, reg(b) .. " % " .. cv(c_reg)))
        elseif op == "POW" then emit_raw(si .. decl(a, reg(b) .. " ^ " .. reg(c_reg)))
        elseif op == "POWK" then emit_raw(si .. decl(a, reg(b) .. " ^ " .. cv(c_reg)))
        elseif op == "AND" then emit_raw(si .. decl(a, reg(b) .. " and " .. reg(c_reg)))
        elseif op == "OR" then emit_raw(si .. decl(a, reg(b) .. " or " .. reg(c_reg)))
        elseif op == "NOT" then emit_raw(si .. decl(a, "not " .. reg(b)))
        elseif op == "MINUS" then emit_raw(si .. decl(a, "-" .. reg(b)))
        elseif op == "LENGTH" then emit_raw(si .. decl(a, "#" .. reg(b)))

        elseif op == "CONCAT" then
            local parts = {}
            for n = b, c_reg do parts[#parts+1] = reg(n) end
            emit_raw(si .. decl(a, table.concat(parts, " .. ")))

        elseif op == "NEWTABLE" or op == "DUPTABLE" then
            emit_raw(si .. decl(a, "{}"))

        elseif op == "SETLIST" then
            local items = {}
            for n = 1, b do items[n] = reg(a+n) end
            emit_raw(si .. reg(a) .. " = {" .. table.concat(items, ", ") .. "}")

        elseif op == "NEWCLOSURE" or op == "DUPCLOSURE" then
            local cname = fname .. "_closure" .. b
            if inner_source[b] then
                emit_raw("")
                emit_raw(inner_source[b])
                emit_raw("")
                emit_raw(si .. decl(a, cname, cname))
            else
                emit_raw(si .. decl(a, "function(...) end --[[ closure " .. b .. " ]]"))
            end

        elseif op == "GETVARARGS" then
            if b == 2 then
                emit_raw(si .. decl(a, "..."))
            else
                local rets = {}
                for n = 0, b-2 do rets[n+1] = reg(a+n) end
                emit_raw(si .. "local " .. table.concat(rets,", ") .. " = ...")
            end

        elseif op == "PREPVARARGS" then

        elseif op == "CLOSEUPVALS" or op == "CAPTURE" then

        elseif op == "FASTCALL" or op == "FASTCALL1" or op == "FASTCALL2" or op == "FASTCALL2K" then

        elseif op == "COVERAGE" then

        else
            emit_raw(si .. "-- [" .. op .. "] a=" .. a .. " b=" .. b .. " c=" .. c_reg .. " d=" .. d)
        end

        pc += 1
    end

    for _ = 1, scope_depth do emit_raw(ind_str .. "    end") end

    emit("end -- " .. fname)
    return table.concat(lines, "\n")
end

local function deob_save(fn, label, trigger)
    deob_idx += 1
    local did = tostring(deob_idx)
    local outfile = DEOB_DIR .. "/LEGIBLE_" .. did .. "_" .. tostring(label):sub(1,40) .. ".txt"

    local header = {
        "-- ============================================================",
        "-- DEOBFUSCATED SOURCE #" .. did,
        "-- LABEL:   " .. tostring(label),
        "-- TRIGGER: " .. tostring(trigger),
        "-- TIME:    " .. tostring(tick()),
        "-- NOTE:    Reconstruido desde bytecode en runtime.",
        "--          Variables renombradas, strings decodificadas,",
        "--          control flow recuperado (if/for/while).",
        "-- ============================================================",
        "",
    }

    local ok, source = pcall(reconstruct_lua, fn, label, 0, {})
    if not ok then source = "-- [RECONSTRUCTION ERROR: " .. tostring(source) .. "]" end

    local cleaned = {}
    local last_empty = false
    for line in source:gmatch("[^\n]*") do
        local is_empty = line:match("^%s*$")
        if is_empty and last_empty then
        else
            table.insert(cleaned, line)
        end
        last_empty = is_empty
    end

    local final = table.concat(header, "\n") .. "\n" .. table.concat(cleaned, "\n")
    fw(outfile, final)
    fa(MASTER_LOG, "[DEOB] " .. outfile .. " | lines=" .. #cleaned)
    step("DEOB", "#" .. did .. " " .. tostring(label) .. " -> " .. outfile)
    return outfile
end

local _orig_dp = dump_payload
dump_payload = function(chunk, method_tag)
    _orig_dp(chunk, method_tag)

    if type(chunk) ~= "string" or #chunk == 0 then
        step("DEOB_SKIP", "chunk nil/invalido para " .. tostring(method_tag))
        return
    end
    pcall(function()
        local ok, fn = pcall(_ORIG_LS, chunk)
        if ok and type(fn) == "function" then
            deob_save(fn, method_tag, "AUTO_FROM_LOADSTRING")
        end
    end)
end

task.spawn(function()
    task.wait(2.5)
    for k, v in pairs(getgenv()) do
        if type(v) == "function" and not DELTA_WHITELIST[k] then
            pcall(deob_save, v, "GENV_" .. tostring(k), "STARTUP_SCAN")
        end
    end
end)

getgenv().__DEOB_SAVE = deob_save
getgenv().__DEOB_RECONSTRUCT = reconstruct_lua

step("DEOB_ENGINE", "activo | output=" .. DEOB_DIR)