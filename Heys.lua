--[[
  LuaFree bootstrap v3 — fully readable
  Source: https://luafree.vercel.app/api/load/lf_LzVgzDXDjtbzPKyTZSe0CvvBX5cCn_8q3vUipmH0-Xo

  Note: the publicId in the URL must include the capital Z in "PKyTZSe0..."
  (without it the server returns 404 "could not start this public loader").
]]

return (function()
  local LF_BOOTSTRAP_VERSION = "v3"
  local BASE = "https://luafree.vercel.app"
  local publicId = "lf_LzVgzDXDjtbzPKyTZSe0CvvBX5cCn_8q3vUipmH0-Xo"

  local HttpService = game:GetService("HttpService")

  ------------------------------------------------------------------
  -- environment hardening (phase machine + frozen state table)
  ------------------------------------------------------------------
  local stateData = { phase = "initialized", deliveryStarted = false, executed = false }
  local state = setmetatable({}, {
    __index = stateData,
    __newindex = function()
      error("LuaFree detected an invalid runtime environment.")
    end,
  })
  pcall(function()
    if type(table.freeze) == "function" then table.freeze(state) end
  end)

  local function fail(msg)
    error(msg or "LuaFree detected an invalid runtime environment.")
  end

  local function transition(fromPhase, toPhase)
    if stateData.phase ~= fromPhase then fail() end
    stateData.phase = toPhase
  end

  ------------------------------------------------------------------
  -- HTTP adapter (executor-agnostic)
  ------------------------------------------------------------------
  local requestAdapter = "unknown"
  local function select_request()
    if type(request) == "function" then requestAdapter = "request"; return request end
    if type(http_request) == "function" then requestAdapter = "http_request"; return http_request end
    if type(syn) == "table" and type(syn.request) == "function" then requestAdapter = "syn.request"; return syn.request end
    if type(http) == "table" and type(http.request) == "function" then requestAdapter = "http.request"; return http.request end
    fail()
  end
  local requestFn = select_request()

  local traceId
  local function nonce()
    local ok, g = pcall(function() return HttpService:GenerateGUID(false) end)
    if ok and type(g) == "string" then return g end
    return tostring(os.clock()) .. "-" .. tostring(math.random(100000, 999999))
  end
  local function ensure_trace()
    if not traceId then
      traceId = ("lf_" .. nonce():gsub("[^A-Za-z0-9_-]", "")):sub(1, 48)
    end
    return traceId
  end
  local function ref_suffix()
    return " Ref: " .. ensure_trace() .. " Version: v3"
  end

  local function http_post(path, body)
    local ok, response = pcall(requestFn, {
      Url = BASE .. path,
      Method = "POST",
      Headers = {
        ["Content-Type"] = "application/json",
        ["X-LuaFree-Trace"] = traceId or "lf_pending",
        ["X-LuaFree-Adapter"] = requestAdapter,
      },
      Body = body,
    })
    if not ok then return 0, "", {}, true end
    -- normalize table/string responses from different executors
    if type(response) == "table" then
      local status = response.StatusCode or response.Status or response.status_code or 0
      local bodyOut = response.Body or response.body or response.Response or ""
      local headers = response.Headers or response.headers or {}
      return status, bodyOut, headers, false
    elseif type(response) == "string" then
      return 200, response, {}, false
    end
    return 0, "", {}, "unsupported_response"
  end

  local function fail_http(status, body, headers, networkError)
    if networkError == "unsupported_response" then fail("LuaFree executor returned an unsupported HTTP response." .. ref_suffix()) end
    if networkError then fail("LuaFree network request failed. Please try again." .. ref_suffix()) end
    if status == 403 then fail("LuaFree access denied." .. ref_suffix()) end
    if status == 404 then fail("LuaFree loader was not found. Use the latest loader." .. ref_suffix()) end
    if status == 429 then fail("LuaFree is rate limited. Wait and try again." .. ref_suffix()) end
    if status >= 500 then fail("LuaFree server error. Please try again." .. ref_suffix()) end
    fail("LuaFree download failed (HTTP " .. tostring(status) .. ")." .. ref_suffix())
  end

  ------------------------------------------------------------------
  -- device identity (HWID candidates)
  ------------------------------------------------------------------
  local function try_string(fn)
    local ok, value = pcall(fn)
    if ok and type(value) == "string" and value:gsub("%s+", "") ~= "" then return value end
  end

  local function device_identity()
    local candidates = {}
    local function add(source, value)
      if type(source) == "string" and type(value) == "string" and value:gsub("%s+", "") ~= "" then
        candidates[#candidates + 1] = { source = source, value = value }
      end
    end
    add("client_id", try_string(function()
      return game:GetService("RbxAnalyticsService"):GetClientId()
    end))
    if type(gethwid) == "function" then add("executor_hwid", try_string(gethwid)) end
    if type(get_hwid) == "function" then add("executor_hwid", try_string(get_hwid)) end
    if type(getfingerprint) == "function" then add("supported_fallback", try_string(getfingerprint)) end
    if type(get_fingerprint) == "function" then add("supported_fallback", try_string(get_fingerprint)) end
    if #candidates == 0 then return nil end
    return { candidates = candidates }
  end

  ------------------------------------------------------------------
  -- AUTH: POST /api/ffa-authorize
  ------------------------------------------------------------------
  transition("initialized", "authorizing")
  ensure_trace()
  local executionNonce = nonce()
  local authPayload = HttpService:JSONEncode({
    publicId = publicId,
    nonce = executionNonce,
    deviceIdentity = device_identity(),
  })
  local authStatus, authBody, authHeaders, _, authNetwork = http_post("/api/ffa-authorize", authPayload)
  if authStatus < 200 or authStatus >= 300 then fail_http(authStatus, authBody, authHeaders, authNetwork) end
  if authBody == "" then fail("LuaFree returned an empty authorization response." .. ref_suffix()) end

  local okAuth, auth = pcall(HttpService.JSONDecode, HttpService, authBody)
  if not okAuth or type(auth) ~= "table"
      or type(auth.ticket) ~= "string"
      or type(auth.challenge) ~= "string"
      or type(auth.sessionId) ~= "string" then
    fail("LuaFree could not verify this delivery.")
  end
  if not auth.ticket:match("^[A-Za-z0-9_-]+$")
      or not auth.challenge:match("^[A-Za-z0-9_-]+$")
      or not auth.sessionId:match("^[A-Za-z0-9_-]+$") then
    fail("LuaFree could not verify this delivery.")
  end
  transition("authorizing", "authorized")

  ------------------------------------------------------------------
  -- DELIVER: POST /api/ffa-deliver
  ------------------------------------------------------------------
  if stateData.deliveryStarted then fail() end
  stateData.deliveryStarted = true
  transition("authorized", "delivering")

  local deliveryPayload = HttpService:JSONEncode({
    ticket = auth.ticket,
    challenge = auth.challenge,
    nonce = executionNonce,
    sessionId = auth.sessionId,
  })
  local deliverStatus, source, headers, _, deliverNetwork = http_post("/api/ffa-deliver", deliveryPayload)
  if deliverStatus < 200 or deliverStatus >= 300 then fail_http(deliverStatus, source, headers, deliverNetwork) end
  if source == "" then fail("LuaFree returned an empty Script response." .. ref_suffix()) end

  -- integrity checks on the artifact
  local contentType = headers["content-type"] or headers["Content-Type"]
  if contentType and not tostring(contentType):lower():find("text/plain", 1, true) then
    fail("LuaFree could not verify this delivery.")
  end
  local expectedBytes = tonumber(headers["x-luafree-artifact-bytes"] or headers["content-length"] or "")
  if expectedBytes and expectedBytes > 0 and #source ~= expectedBytes then
    fail("LuaFree could not verify this delivery.")
  end
  if #source > 12582912 then fail("LuaFree could not verify this delivery.") end
  local prefix = source:sub(1, 32):lower()
  if prefix:find("<html", 1, true) or prefix:find("{\"error", 1, true) or prefix:find("<!doctype", 1, true) then
    fail("LuaFree could not verify this delivery.")
  end

  transition("delivering", "delivered")
  local chunk = loadstring(source)
  if not chunk then fail("LuaFree could not safely execute this Script.") end
  if stateData.executed then fail() end
  stateData.executed = true
  transition("delivered", "executing")
  local okRun, result = xpcall(chunk, function()
    return "LuaFree could not safely execute this Script."
  end)
  transition("executing", "completed")
  if not okRun then fail("LuaFree could not safely execute this Script.") end
  return result
end)()
]]