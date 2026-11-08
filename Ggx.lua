==========================================================================================
  0. DIAGNÓSTICO DEL FILESYSTEM
==========================================================================================


--------------------------------------------------------------------------------
--- Funciones de filesystem
--------------------------------------------------------------------------------

writefile       :: function [[C]:?]
appendfile      :: function [[C]:?]
readfile        :: function [[C]:?]
isfile          :: function [[C]:?]
makefolder      :: function [[C]:?]
delfile         :: function [[C]:?]
listfiles       :: function [[C]:?]

--------------------------------------------------------------------------------
--- Test de límite de writefile
--------------------------------------------------------------------------------

1 KB     :: ✅ OK
10 KB    :: ✅ OK
25 KB    :: ✅ OK
50 KB    :: ✅ OK
100 KB   :: ✅ OK
500 KB   :: ✅ OK
1 MB     :: ✅ OK
2 MB     :: ✅ OK

Límite detectado: ~2048.0 KB
PART_SIZE configurado: 900 KB

==========================================================================================
  1. IDENTIFICACIÓN DEL EJECUTOR
==========================================================================================

identifyexecutor: Delta v1.0.745.1142
isluau():         N/A

--------------------------------------------------------------------------------
--- Fingerprint loadstring/loadfile/dofile
--------------------------------------------------------------------------------

loadstring :: NO DISPONIBLE
loadfile :: NO DISPONIBLE
dofile :: NO DISPONIBLE
load :: NO DISPONIBLE
require :: NO DISPONIBLE

==========================================================================================
  2. VERSIÓN DE LUAU DETECTADA
==========================================================================================

tipos_base                | ✅ | (>=0.500)
tipo_opcional             | ✅ | (>=0.510)
tipo_union                | ✅ | (>=0.510)
tipo_interseccion         | ✅ | (>=0.510)
genericos                 | ✅ | (>=0.510)
generic_packs             | ✅ | (>=0.510)
cast_::                   | ✅ | (>=0.510)
typeof_en_tipo            | ✅ | (>=0.510)
tipo_nunca                | ✅ | (>=0.530)
export_type               | ✅ | (>=0.530)
tipo_singleton            | ✅ | (>=0.540)
function_type             | ✅ | (>=0.540)
interpolacion             | ✅ | (>=0.560)
if_expresion              | ✅ | (>=0.560)
continue_loop             | ✅ | (>=0.560)
compound_add              | ✅ | (>=0.560)
generalized_iter          | ✅ | (>=0.560)
floordiv                  | ✅ | (>=0.560)
bitwise                   | ❌ | (>=0.560)
numero_binario            | ✅ | (>=0.560)
buffer_library            | ✅ | (>=0.600)
vector_library            | ✅ | (>=0.600)
read_write_types          | ✅ | (>=0.640)

=== VERSIÓN MÍNIMA: >= 0.640 ===

==========================================================================================
  3. MATRIX DE SINTAXIS LUAU
==========================================================================================

TEST                                   | OK   | DETALLE
--------------------------------------------------------------------------------------------------------------
B/ and                                 | ❌  | INecxmevYKqFDyvNkSsaCbqjx:1: Expected identifier when parsing expression, got '&'
B/ lshift                              | ❌  | INecxuCZsFzsUmZWCQGzzcHNY:1: Expected identifier when parsing expression, got '<'
B/ not                                 | ❌  | INecxWWLNNuyVrgDzgyXRNFPw:1: Expected identifier when parsing expression, got '~'
B/ or                                  | ❌  | INecxwHmyTmRzSfXowwdsPjTC:1: Expected identifier when parsing expression, got '|'
B/ rshift                              | ❌  | INecxHSNAhcirjwHTDRgrCitV:1: Expected identifier when parsing expression, got '>'
B/ xor                                 | ❌  | INecxVegkqKcuBTrTEgvRyfpk:1: Expected identifier when parsing expression, got '~'
E/ continue fuera de bucle             | ❌  | INecxuvicbSQhNJAzQAtorudR:1: continue statement must be inside a loop
E/ if sin end                          | ❌  | INecxlLEeRKXBfVAFDNevGfLO:1: Expected 'end' (to close 'then' at column 9), got <eof>
E/ tipo erroneo                        | ✅  | OK
EXT/ etiqueta #                        | ❌  | INecxlgUQXliHftLtNdwxnKQi:1: Expected identifier when parsing expression, got '#'
EXT/ macro @                           | ❌  | INecxcGbmWdMjdZZcBpnpcjvq:1: Expected identifier when parsing variable name, got 'x'
EXT/ prefijo $                         | ❌  | INecxmrImlZFDNmRXRfBmsajF:1: Expected identifier when parsing expression, got '$'
F/ continue for                        | ✅  | OK
F/ continue while                      | ✅  | OK
F/ goto label                          | ❌  | INecxEARbhUhZXPObrBiLqcbz:1: Expected identifier when parsing expression, got '::'
G/ iter array                          | ✅  | OK
G/ iter dict                           | ✅  | OK
I/ interpolacion                       | ✅  | OK
I/ interpolacion anidada               | ✅  | OK
IF/ if elseif                          | ✅  | OK
IF/ if expresion                       | ✅  | OK
L51/ <close> (5.4, NO Luau)            | ❌  | INecxyftfqcSUNIjtmfMiRppN:1: Expected identifier when parsing expression, got '<'
L51/ <const> (5.4, NO Luau)            | ❌  | INecxyNiQNHCMisbfqRyetdkP:1: Expected identifier when parsing expression, got '<'
N/ binario                             | ✅  | OK
N/ exponente                           | ✅  | OK
N/ hex                                 | ✅  | OK
N/ underscores                         | ✅  | OK
O/ %=                                  | ✅  | OK
O/ &=                                  | ❌  | INecxzDYMWvxvcpcwLNtKIrvp:1: Incomplete statement: expected assignment or a function call
O/ *=                                  | ✅  | OK
O/ +=                                  | ✅  | OK
O/ -=                                  | ✅  | OK
O/ ..=                                 | ✅  | OK
O/ //=                                 | ✅  | OK
O/ /=                                  | ✅  | OK
O/ <<=                                 | ❌  | INecxXIsxtxhrDYQMfhDdiJYe:1: Incomplete statement: expected assignment or a function call
O/ >>=                                 | ❌  | INecxEzfolOwnmTKBXgDsFOEI:1: Incomplete statement: expected assignment or a function call
O/ ^=                                  | ✅  | OK
O/ |=                                  | ❌  | INecxVMpklsuYuNidYXmVmfKO:1: Incomplete statement: expected assignment or a function call
S/ \u escape                           | ✅  | OK
S/ \x escape                           | ✅  | OK
S/ \z escape                           | ✅  | OK
S/ long bracket                        | ✅  | OK
T/ cast ::                             | ✅  | OK
T/ export type                         | ✅  | OK
T/ function type                       | ✅  | OK
T/ generic packs                       | ✅  | OK
T/ generico                            | ✅  | OK
T/ interseccion                        | ✅  | OK
T/ local anotado                       | ✅  | OK
T/ opcional                            | ✅  | OK
T/ param anotado                       | ✅  | OK
T/ read/write (0.64+)                  | ✅  | OK
T/ singleton string                    | ✅  | OK
T/ tipo never                          | ✅  | OK
T/ typeof en tipo                      | ✅  | OK
T/ union                               | ✅  | OK

==========================================================================================
  4. FINGERPRINT DEL COMPILADOR
==========================================================================================

operador desconocido           :: INecxcVQjiswtWBasHLLGHMrj:1: Attribute name is missing
variable sin tipo              :: INecxdhLHtjNzpOAdyMshzJNH:1: Expected type, got '='
if sin then                    :: INecxRcbhPbrvCdeIGfpkBPsv:1: Expected 'then' when parsing if statement, got 'end'
string sin cerrar              :: INecxZmxfFWSUhunlXRdhIIOQ:1: Malformed string; did you forget to finish it?
local sin nombre               :: INecxjuxOKpKuirMqcxByumzn:1: Expected identifier when parsing variable name, got '='
end extra                      :: INecxBPEBFloqNgkCsINjmAFL:1: Expected <eof>, got 'end'
falta paréntesis              :: INecxvbFLoMlOtKNKvLuebxNQ:1: Expected identifier when parsing function name, got '('

==========================================================================================
  5. LÍMITES DEL PARSER
==========================================================================================


--------------------------------------------------------------------------------
--- Anidamiento paréntesis
--------------------------------------------------------------------------------

100 paréntesis :: ❌
500 paréntesis :: ❌
1000 paréntesis :: ❌
5000 paréntesis :: ❌

--------------------------------------------------------------------------------
--- Anidamiento bloques do
--------------------------------------------------------------------------------

100 bloques do :: ✅
500 bloques do :: ✅
1000 bloques do :: ✅
5000 bloques do :: ❌

--------------------------------------------------------------------------------
--- Unicode y BOM
--------------------------------------------------------------------------------

byte > 127           :: ✅ OK
\u{1F600}            :: ✅ OK
shebang #!           :: ❌ INecxosjSuxzhOtAprVfoHKJY:1: Expected identifier when parsing expression, got '#'
BOM UTF-8            :: ❌ INecxoSdiCNldgXWEfkdNYkOG:1: Expected identifier when parsing expression, got Unicode character U+feff
emoji directo        :: ✅ OK

==========================================================================================
  6. APIs DEL EJECUTOR
==========================================================================================

FUNCIÓN                                 | OK  | TIPO         | DÓNDE
--------------------------------------------------------------------------------------------------------------
writefile                                | ✅ | function     | getgenv
readfile                                 | ✅ | function     | getgenv
appendfile                               | ✅ | function     | getgenv
isfile                                   | ✅ | function     | getgenv
isfolder                                 | ✅ | function     | getgenv
makefolder                               | ✅ | function     | getgenv
delfile                                  | ✅ | function     | getgenv
delfolder                                | ✅ | function     | getgenv
listfiles                                | ✅ | function     | getgenv
getcustomasset                           | ✅ | function     | getgenv
loadfile                                 | ✅ | function     | getgenv
dofile                                   | ✅ | function     | getgenv
loadstring                               | ✅ | function     | getgenv
require                                  | ❌ | nil          | -
getgenv                                  | ✅ | function     | getgenv
getrenv                                  | ✅ | function     | getgenv
getreg                                   | ✅ | function     | getgenv
getgc                                    | ✅ | function     | getgenv
getloadedmodules                         | ✅ | function     | getgenv
getnilinstances                          | ✅ | function     | getgenv
getinstances                             | ✅ | function     | getgenv
getscripts                               | ✅ | function     | getgenv
getrunningscripts                        | ✅ | function     | getgenv
getcallingscript                         | ✅ | function     | getgenv
getsenv                                  | ✅ | function     | getgenv
getscriptclosure                         | ✅ | function     | getgenv
getscriptbytecode                        | ✅ | function     | getgenv
getscripthash                            | ✅ | function     | getgenv
getfunctionhash                          | ✅ | function     | getgenv
getscriptfromthread                      | ✅ | function     | getgenv
getthreadidentity                        | ✅ | function     | getgenv
setthreadidentity                        | ✅ | function     | getgenv
setidentity                              | ✅ | function     | getgenv
checkcaller                              | ✅ | function     | getgenv
islclosure                               | ✅ | function     | getgenv
iscclosure                               | ✅ | function     | getgenv
hookfunction                             | ✅ | function     | getgenv
hookmetamethod                           | ✅ | function     | getgenv
getnamecallmethod                        | ✅ | function     | getgenv
setreadonly                              | ✅ | function     | getgenv
isreadonly                               | ✅ | function     | getgenv
getrawmetatable                          | ✅ | function     | getgenv
setmetatable                             | ❌ | nil          | -
newcclosure                              | ✅ | function     | getgenv
newproxy                                 | ❌ | nil          | -
make_writeable                           | ✅ | function     | getgenv
replaceclosure                           | ✅ | function     | getgenv
cloneref                                 | ✅ | function     | getgenv
compareinstances                         | ✅ | function     | getgenv
getconnections                           | ✅ | function     | getgenv
firesignal                               | ✅ | function     | getgenv
fireclickdetector                        | ✅ | function     | getgenv
firetouchinterest                        | ✅ | function     | getgenv
fireproximityprompt                      | ✅ | function     | getgenv
gethui                                   | ✅ | function     | getgenv
get_hidden_gui                           | ✅ | function     | getgenv
protect_gui                              | ❌ | nil          | -
unprotect_gui                            | ❌ | nil          | -
mouse1click                              | ✅ | function     | getgenv
mouse1press                              | ✅ | function     | getgenv
mouse1release                            | ✅ | function     | getgenv
mouse2click                              | ✅ | function     | getgenv
mouse2press                              | ✅ | function     | getgenv
mouse2release                            | ✅ | function     | getgenv
mousemoveabs                             | ✅ | function     | getgenv
mousemoverel                             | ✅ | function     | getgenv
mousescroll                              | ✅ | function     | getgenv
keypress                                 | ✅ | function     | getgenv
keyrelease                               | ✅ | function     | getgenv
request                                  | ✅ | function     | getgenv
http_request                             | ✅ | function     | getgenv
httpget                                  | ✅ | function     | getgenv
httppost                                 | ✅ | function     | getgenv
syn_request                              | ❌ | nil          | -
rconsoleprint                            | ✅ | function     | getgenv
rconsoleinfo                             | ✅ | function     | getgenv
rconsolewarn                             | ✅ | function     | getgenv
rconsoleerr                              | ✅ | function     | getgenv
rconsolename                             | ✅ | function     | getgenv
rconsoleclear                            | ✅ | function     | getgenv
rconsolecreate                           | ✅ | function     | getgenv
rconsoleinput                            | ✅ | function     | getgenv
rconsoleclose                            | ❌ | nil          | -
setfpscap                                | ✅ | function     | getgenv
queue_on_teleport                        | ✅ | function     | getgenv
queueonteleport                          | ✅ | function     | getgenv
decompile                                | ✅ | function     | getgenv
saveinstance                             | ❌ | nil          | -
crypt                                    | ✅ | table        | getgenv
base64encode                             | ✅ | function     | getgenv
base64decode                             | ✅ | function     | getgenv
base64_encode                            | ✅ | function     | getgenv
base64_decode                            | ✅ | function     | getgenv
is_sirhurt_closure                       | ❌ | nil          | -
issirhurt                                | ❌ | nil          | -
is_synapse_function                      | ❌ | nil          | -
setclipboard                             | ✅ | function     | getgenv
messagebox                               | ✅ | function     | getgenv
toclipboard                              | ✅ | function     | getgenv
wrap                                     | ❌ | nil          | -
secure_call                              | ❌ | nil          | -
getfenv                                  | ✅ | function     | getgenv
setfenv                                  | ❌ | nil          | -
sethiddenproperty                        | ✅ | function     | getgenv
gethiddenproperty                        | ✅ | function     | getgenv
setsimulationradius                      | ✅ | function     | getgenv
getsimulationradius                      | ✅ | function     | getgenv
getspecialinfo                           | ❌ | nil          | -
setrbxclipboard                          | ✅ | function     | getgenv
getrbxclipboard                          | ❌ | nil          | -
isnetworkowner                           | ✅ | function     | getgenv
getnetworkowner                          | ❌ | nil          | -
is_protosmasher_closure                  | ❌ | nil          | -
is_sentinel_closure                      | ❌ | nil          | -
is_krnl_closure                          | ❌ | nil          | -
getcallbackvalue                         | ✅ | function     | getgenv
setcallbackvalue                         | ❌ | nil          | -
gethiddenprop                            | ❌ | nil          | -
sethiddenprop                            | ✅ | function     | getgenv
getstack                                 | ✅ | function     | getgenv
getmenv                                  | ✅ | function     | getgenv
gettenv                                  | ❌ | nil          | -
identifyexecutor                         | ✅ | function     | getgenv
getexecutorname                          | ✅ | function     | getgenv
isluau                                   | ❌ | nil          | -

--------------------------------------------------------------------------------
--- Tablas del ejecutor
--------------------------------------------------------------------------------

syn :: nil (nil) :: -
Krnl :: nil (nil) :: -
kernal :: nil (nil) :: -
Debug :: nil (nil) :: -
debug :: table [28 keys] :: getgenv
    debug :: table [28 claves]
      dumpcodesize :: function [[C]:?]
      dumpheap :: function [[C]:?]
      dumprefs :: function [[C]:?]
      getcallstack :: function [[C]:?]
      getconstant :: function [[C]:?]
      getconstants :: function [[C]:?]
      getinfo :: function [[C]:?]
      getmemorycategory :: function [[C]:?]
      getmetatable :: function [[C]:?]
      getproto :: function [[C]:?]
      getprotos :: function [[C]:?]
      getregistry :: function [[C]:?]
      getstack :: function [[C]:?]
      getupvalue :: function [[C]:?]
      getupvalues :: function [[C]:?]
      info :: function [[C]:?]
      isvalidlevel :: function [[C]:?]
      loadmodule :: function [[C]:?]
      profilebegin :: function [[C]:?]
      profileend :: function [[C]:?]
      resetmemorycategory :: function [[C]:?]
      setconstant :: function [[C]:?]
      setmemorycategory :: function [[C]:?]
      setmetatable :: function [[C]:?]
      setstack :: function [[C]:?]
      setupvalue :: function [[C]:?]
      traceback :: function [[C]:?]
      validlevel :: function [[C]:?]
WebSocket :: table [1 keys] :: getgenv
    WebSocket :: table [1 claves]
      connect :: function [[C]:?]

==========================================================================================
  7. getgenv()
==========================================================================================

getgenv :: table [293 claves]
  DELTA_VERSION_NUM :: number (74500)
  Delta :: table [11 claves]
    architecture :: function [[C]:?]
    architecture_str :: function [[C]:?]
    get_platform :: function [[C]:?]
    is_android :: function [[C]:?]
    is_ios :: function [[C]:?]
    is_mac :: function [[C]:?]
    is_vng :: function [[C]:?]
    roblox_version :: function [[C]:?]
    version :: function [[C]:?]
    version_hash :: function [[C]:?]
    version_num :: function [[C]:?]
  DeltaSignal :: table [1 claves]
    new :: function [[C]:?]
  Drawing :: table [3 claves]
    Fonts :: table [4 claves]
      Monospace :: number (3)
      Plex :: number (2)
      System :: number (1)
      UI :: number (0)
    clear :: function [[C]:?]
    new :: function [[C]:?]
  Duration :: table [10 claves]
    FromDays :: function [[C]:?]
    FromHours :: function [[C]:?]
    FromMicroseconds :: function [[C]:?]
    FromMilliseconds :: function [[C]:?]
    FromMinutes :: function [[C]:?]
    FromMonths :: function [[C]:?]
    FromNanoseconds :: function [[C]:?]
    FromSeconds :: function [[C]:?]
    FromYears :: function [[C]:?]
    TimeSinceEpoch :: function [[C]:?]
  LuaStateProxy :: table [1 claves]
    new :: function [[C]:?]
  RakNet :: table [2 claves]
    desync :: function [[C]:?]
    is_enabled :: function [[C]:?]
  Raknet :: table [2 claves]
    desync :: function [[C]:?]
    is_enabled :: function [[C]:?]
  Regex :: table [2 claves]
    Escape :: function [[C]:?]
    new :: function [[C]:?]
  Signal :: table [1 claves]
    new :: function [[C]:?]
  Stopwatch :: table [1 claves]
    new :: function [[C]:?]
  WebSocket :: table [1 claves]
    connect :: function [[C]:?]
  _G :: table [0 claves]
  appendfile :: function [[C]:?]
  base64 :: table [2 claves]
    decode :: function [[C]:?]
    encode :: function [[C]:?]
  base64_decode :: function [[C]:?]
  base64_encode :: function [[C]:?]
  base64decode :: function [[C]:?]
  base64encode :: function [[C]:?]
  bit :: table [15 claves]
    arshift :: function [[C]:?]
    band :: function [[C]:?]
    bnot :: function [[C]:?]
    bor :: function [[C]:?]
    btest :: function [[C]:?]
    bxor :: function [[C]:?]
    byteswap :: function [[C]:?]
    countlz :: function [[C]:?]
    countrz :: function [[C]:?]
    extract :: function [[C]:?]
    lrotate :: function [[C]:?]
    lshift :: function [[C]:?]
    replace :: function [[C]:?]
    rrotate :: function [[C]:?]
    rshift :: function [[C]:?]
  cache :: table [3 claves]
    invalidate :: function [[C]:?]
    iscached :: function [[C]:?]
    replace :: function [[C]:?]
  cansignalreplicate :: function [[C]:?]
  checkcaller :: function [[C]:?]
  checkclosure :: function [[C]:?]
  checkparallel :: function [[C]:?]
  clear_teleport_queue :: function [[C]:?]
  cleardrawcache :: function [[C]:?]
  clearqueue_on_teleport :: function [[C]:?]
  clearqueueonteleport :: function [[C]:?]
  clearteleportqueue :: function [[C]:?]
  clonefunc :: function [[C]:?]
  clonefunction :: function [[C]:?]
  cloneref :: function [[C]:?]
  clonereference :: function [[C]:?]
  compareinstances :: function [[C]:?]
  consoleclear :: function [[C]:?]
  consolecreate :: function [[C]:?]
  consoledestroy :: function [[C]:?]
  consoleinput :: function [[C]:?]
  consoleprint :: function [[C]:?]
  consolesettitle :: function [[C]:?]
  create_comm_channel :: function [[C]:?]
  crypt :: table [14 claves]
    base64 :: table [2 claves]
      decode :: function [[C]:?]
      encode :: function [[C]:?]
    base64_decode :: function [[C]:?]
    base64_encode :: function [[C]:?]
    base64decode :: function [[C]:?]
    base64encode :: function [[C]:?]
    decrypt :: function [[C]:?]
    encrypt :: function [[C]:?]
    generatebytes :: function [[C]:?]
    generatekey :: function [[C]:?]
    hash :: function [[C]:?]
    hmac :: function [[C]:?]
    lz4compress :: function [[C]:?]
    lz4decompress :: function [[C]:?]
    random :: function [[C]:?]
  debug :: table [28 claves]
    dumpcodesize :: function [[C]:?]
    dumpheap :: function [[C]:?]
    dumprefs :: function [[C]:?]
    getcallstack :: function [[C]:?]
    getconstant :: function [[C]:?]
    getconstants :: function [[C]:?]
    getinfo :: function [[C]:?]
    getmemorycategory :: function [[C]:?]
    getmetatable :: function [[C]:?]
    getproto :: function [[C]:?]
    getprotos :: function [[C]:?]
    getregistry :: function [[C]:?]
    getstack :: function [[C]:?]
    getupvalue :: function [[C]:?]
    getupvalues :: function [[C]:?]
    info :: function [[C]:?]
    isvalidlevel :: function [[C]:?]
    loadmodule :: function [[C]:?]
    profilebegin :: function [[C]:?]
    profileend :: function [[C]:?]
    resetmemorycategory :: function [[C]:?]
    setconstant :: function [[C]:?]
    setmemorycategory :: function [[C]:?]
    setmetatable :: function [[C]:?]
    setstack :: function [[C]:?]
    setupvalue :: function [[C]:?]
    traceback :: function [[C]:?]
    validlevel :: function [[C]:?]
  decompile :: function [[C]:?]
  deletefolder :: function [[C]:?]
  delfile :: function [[C]:?]
  delfolder :: function [[C]:?]
  detour_function :: function [[C]:?]
  detourfunction :: function [[C]:?]
  dofile :: function [[C]:?]
  dumpbytecode :: function [[C]:?]
  dumpstring :: function [[C]:?]
  filtergc :: function [[C]:?]
  fireclickdetector :: function [[C]:?]
  fireproximityprompt :: function [[C]:?]
  firesignal :: function [[C]:?]
  firetouchinterest :: function [[C]:?]
  get_actors :: function [[C]:?]
  get_callback_value :: function [[C]:?]
  get_comm_channel :: function [[C]:?]
  get_current_actor :: function [[C]:?]
  get_deleted_actors :: function [[C]:?]
  get_destroyed_actors :: function [[C]:?]
  get_fps_cap :: function [[C]:?]
  get_hidden_gui :: function [[C]:?]
  get_hidden_properties :: function [[C]:?]
  get_nil_instances :: function [[C]:?]
  get_original_thread :: function [[C]:?]
  get_properties :: function [[C]:?]
  get_renderstepped_list :: function [[C]:?]
  get_signal_cons :: function [[C]:?]
  get_thread_context :: function [[C]:?]
  get_thread_identity :: function [[C]:?]
  getactors :: function [[C]:?]
  getactorstates :: function [[C]:?]
  getallactors :: function [[C]:?]
  getallthreads :: function [[C]:?]
  getbspval :: function [[C]:?]
  getcallbackmember :: function [[C]:?]
  getcallbackvalue :: function [[C]:?]
  getcallingscript :: function [[C]:?]
  getcallstack :: function [[C]:?]
  getcbvalue :: function [[C]:?]
  getconnectionfunction :: function [[C]:?]
  getconnections :: function [[C]:?]
  getconnectionthread :: function [[C]:?]
  getconstant :: function [[C]:?]
  getconstants :: function [[C]:?]
  getcurrentactor :: function [[C]:?]
  getcustomasset :: function [[C]:?]
  getdeletedactors :: function [[C]:?]
  getdestroyedactors :: function [[C]:?]
  getexecutorname :: function [[C]:?]
  getfenv :: function [[C]:?]
  getfflag :: function [[C]:?]
  getfpscap :: function [[C]:?]
  getfunctionbytecode :: function [[C]:?]
  getfunctionhash :: function [[C]:?]
  getgamestate :: function [[C]:?]
  getgc :: function [[C]:?]
  getgenv :: function [[C]:?]
  gethiddenproperties :: function [[C]:?]
  gethiddenproperty :: function [[C]:?]
  gethiddenprops :: function [[C]:?]
  gethui :: function [[C]:?]
  gethwid :: function [[C]:?]
  getidentity :: function [[C]:?]
  getinfo :: function [[C]:?]
  getinstancecache :: function [[C]:?]
  getinstances :: function [[C]:?]
  getloadedmodules :: function [[C]:?]
  getluastate :: function [[C]:?]
  getmenv :: function [[C]:?]
  getmousepos :: function [[C]:?]
  getnamecallmethod :: function [[C]:?]
  getnilinstances :: function [[C]:?]
  getobjects :: function [[C]:?]
  getpcd :: function [[C]:?]
  getpcdprop :: function [[C]:?]
  getproperties :: function [[C]:?]
  getprops :: function [[C]:?]
  getproto :: function [[C]:?]
  getprotos :: function [[C]:?]
  getproximitypromptduration :: function [[C]:?]
  getrawmetatable :: function [[C]:?]
  getreg :: function [[C]:?]
  getrenderproperty :: function [[C]:?]
  getrenderstepcallbacks :: function [[C]:?]
  getrendersteppedlist :: function [[C]:?]
  getrenv :: function [[C]:?]
  getrunningscripts :: function [[C]:?]
  getscriptbytecode :: function [[C]:?]
  getscriptclosure :: function [[C]:?]
  getscriptfromthread :: function [[C]:?]
  getscriptfunction :: function [[C]:?]
  getscripthash :: function [[C]:?]
  getscripts :: function [[C]:?]
  getscriptsthatrun :: function [[C]:?]
  getscriptthread :: function [[C]:?]
  getsenv :: function [[C]:?]
  getsignalarguments :: function [[C]:?]
  getsignalargumentsinfo :: function [[C]:?]
  getsignalwhitelist :: function [[C]:?]
  getsimulationradius :: function [[C]:?]
  getstack :: function [[C]:?]
  getthreadcontext :: function [[C]:?]
  getthreadidentity :: function [[C]:?]
  getupvalue :: function [[C]:?]
  getupvalues :: function [[C]:?]
  glooperror :: function [[C]:?]
  hookfunc :: function [[C]:?]
  hookfunction :: function [[C]:?]
  hookmetamethod :: function [[C]:?]
  hookproto :: function [[C]:?]
  http :: table [1 claves]
    request :: function [[C]:?]
  http_request :: function [[C]:?]
  httpget :: function [[C]:?]
  httppost :: function [[C]:?]
  identifyexecutor :: function [[C]:?]
  is_c_closure :: function [[C]:?]
  is_delta_closure :: function [[C]:?]
  is_executor_closure :: function [[C]:?]
  is_function_hooked :: function [[C]:?]
  is_l_closure :: function [[C]:?]
  is_our_closure :: function [[C]:?]
  iscclosure :: function [[C]:?]
  isconnectionenabled :: function [[C]:?]
  iscustomcclosure :: function [[C]:?]
  isdeltafunction :: function [[C]:?]
  isexecutorclosure :: function [[C]:?]
  isexecutorthread :: function [[C]:?]
  isfile :: function [[C]:?]
  isfolder :: function [[C]:?]
  isfunctionhooked :: function [[C]:?]
  isgameactive :: function [[C]:?]
  isgamescriptconnection :: function [[C]:?]
  ishooked :: function [[C]:?]
  islclosure :: function [[C]:?]
  isluaconnection :: function [[C]:?]
  isnetworkowner :: function [[C]:?]
  isnewcclosure :: function [[C]:?]
  isourclosure :: function [[C]:?]
  isourthread :: function [[C]:?]
  isparallel :: function [[C]:?]
  isprotohooked :: function [[C]:?]
  isrbxactive :: function [[C]:?]
  isreadonly :: function [[C]:?]
  isrenderobj :: function [[C]:?]
  isscriptable :: function [[C]:?]
  isvalidlevel :: function [[C]:?]
  iswaitingconnection :: function [[C]:?]
  iswindowactive :: function [[C]:?]
  iswritable :: function [[C]:?]
  keyclick :: function [[C]:?]
  keypress :: function [[C]:?]
  keyrelease :: function [[C]:?]
  keytap :: function [[C]:?]
  listfiles :: function [[C]:?]
  loadfile :: function [[C]:?]
  loadstring :: function [[C]:?]
  lz4_compress :: function [[C]:?]
  lz4_decompress :: function [[C]:?]
  lz4compress :: function [[C]:?]
  lz4decompress :: function [[C]:?]
  make_readonly :: function [[C]:?]
  make_writeable :: function [[C]:?]
  makefolder :: function [[C]:?]
  makereadonly :: function [[C]:?]
  makewritable :: function [[C]:?]
  messagebox :: function [[C]:?]
  mouse1click :: function [[C]:?]
  mouse1press :: function [[C]:?]
  mouse1release :: function [[C]:?]
  mouse2click :: function [[C]:?]
  mouse2press :: function [[C]:?]
  mouse2release :: function [[C]:?]
  mousemoveabs :: function [[C]:?]
  mousemoverel :: function [[C]:?]
  mousescroll :: function [[C]:?]
  newcclosure :: function [[C]:?]
  newlclosure :: function [[C]:?]
  oth :: table [5 claves]
    get_original_thread :: function [[C]:?]
    get_root_callback :: function [[C]:?]
    hook :: function [[C]:?]
    is_hook_thread :: function [[C]:?]
    unhook :: function [[C]:?]
  pibble :: table [5 claves]
    getpibbles :: function [[C]:?]
    gmail :: function [[C]:?]
    is_detected :: function [[C]:?]
    is_pibble :: function [[C]:?]
    washington :: function [[C]:?]
  queue_on_teleport :: function [[C]:?]
  queueonteleport :: function [[C]:?]
  raknet :: table [2 claves]
    desync :: function [[C]:?]
    is_enabled :: function [[C]:?]
  rconsoleclear :: function [[C]:?]
  rconsolecreate :: function [[C]:?]
  rconsoledestroy :: function [[C]:?]
  rconsoleerr :: function [[C]:?]
  rconsolehide :: function [[C]:?]
  rconsoleinfo :: function [[C]:?]
  rconsoleinput :: function [[C]:?]
  rconsolename :: function [[C]:?]
  rconsoleprint :: function [[C]:?]
  rconsolesettitle :: function [[C]:?]
  rconsoleshow :: function [[C]:?]
  rconsolewarn :: function [[C]:?]
  readbinarystring :: function [[C]:?]
  readbinarystringpropertyvalue :: function [[C]:?]
  readbspval :: function [[C]:?]
  readfile :: function [[C]:?]
  replaceclosure :: function [[C]:?]
  replacefunc :: function [[C]:?]
  replacefunction :: function [[C]:?]
  replicatesignal :: function [[C]:?]
  request :: function [[C]:?]
  restoreclosure :: function [[C]:?]
  restorefunc :: function [[C]:?]
  restorefunction :: function [[C]:?]
  restoreproto :: function [[C]:?]
  rnet :: table [2 claves]
    desync :: function [[C]:?]
    is_enabled :: function [[C]:?]
  run_on_actor :: function [[C]:?]
  runonactor :: function [[C]:?]
  server :: table [1 claves]
    has_authority :: function [[C]:?]
  set_clipboard :: function [[C]:?]
  set_fps_cap :: function [[C]:?]
  set_hidden_property :: function [[C]:?]
  set_raw_metatable :: function [[C]:?]
  set_rbx_clipboard :: function [[C]:?]
  set_thread_context :: function [[C]:?]
  set_thread_identity :: function [[C]:?]
  setclipboard :: function [[C]:?]
  setconnectionenabled :: function [[C]:?]
  setconstant :: function [[C]:?]
  setfflag :: function [[C]:?]
  setfpscap :: function [[C]:?]
  sethiddenprop :: function [[C]:?]
  sethiddenproperty :: function [[C]:?]
  setidentity :: function [[C]:?]
  setnamecallmethod :: function [[C]:?]
  setproximitypromptduration :: function [[C]:?]
  setrawmetatable :: function [[C]:?]
  setrbxclipboard :: function [[C]:?]
  setreadonly :: function [[C]:?]
  setrenderproperty :: function [[C]:?]
  setscriptable :: function [[C]:?]
  setsimulationradius :: function [[C]:?]
  setstack :: function [[C]:?]
  setstackhidden :: function [[C]:?]
  setthreadcontext :: function [[C]:?]
  setthreadidentity :: function [[C]:?]
  setupvalue :: function [[C]:?]
  shared :: table [0 claves]
  toclipboard :: function [[C]:?]
  validlevel :: function [[C]:?]
  websocket :: table [1 claves]
    connect :: function [[C]:?]
  writefile :: function [[C]:?]
  zstd_compress :: function [[C]:?]
  zstd_decompress :: function [[C]:?]
  zstdcompress :: function [[C]:?]
  zstddecompress :: function [[C]:?]

==========================================================================================
  8. _G
==========================================================================================

_G :: table [0 claves]

==========================================================================================
  9. shared
==========================================================================================

shared :: table [0 claves]

==========================================================================================
  10. getrenv()
==========================================================================================

getrenv :: table [113 claves]
  AdReward :: table [0 claves]
  Axes :: table [1 claves]
    new :: function [[C]:?]
  BrickColor :: table [13 claves]
    Black :: function [[C]:?]
    Blue :: function [[C]:?]
    DarkGray :: function [[C]:?]
    Gray :: function [[C]:?]
    Green :: function [[C]:?]
    New :: function [[C]:?]
    Random :: function [[C]:?]
    Red :: function [[C]:?]
    White :: function [[C]:?]
    Yellow :: function [[C]:?]
    new :: function [[C]:?]
    palette :: function [[C]:?]
    random :: function [[C]:?]
  CFrame :: table [12 claves]
    Angles :: function [[C]:?]
    fromAxisAngle :: function [[C]:?]
    fromEulerAngles :: function [[C]:?]
    fromEulerAnglesXYZ :: function [[C]:?]
    fromEulerAnglesYXZ :: function [[C]:?]
    fromMatrix :: function [[C]:?]
    fromOrientation :: function [[C]:?]
    fromRotationBetweenVectors :: function [[C]:?]
    identity :: userdata
    lookAlong :: function [[C]:?]
    lookAt :: function [[C]:?]
    new :: function [[C]:?]
  CatalogSearchParams :: table [1 claves]
    new :: function [[C]:?]
  CellId :: table [1 claves]
    new :: function [[C]:?]
  Color3 :: table [5 claves]
    fromHSV :: function [[C]:?]
    fromHex :: function [[C]:?]
    fromRGB :: function [[C]:?]
    new :: function [[C]:?]
    toHSV :: function [[C]:?]
  ColorSequence :: table [1 claves]
    new :: function [[C]:?]
  ColorSequenceKeypoint :: table [1 claves]
    new :: function [[C]:?]
  Content :: table [4 claves]
    fromAssetId :: function [[C]:?]
    fromObject :: function [[C]:?]
    fromUri :: function [[C]:?]
    none :: userdata
  DateTime :: table [6 claves]
    fromIsoDate :: function [[C]:?]
    fromLocalTime :: function [[C]:?]
    fromUniversalTime :: function [[C]:?]
    fromUnixTimestamp :: function [[C]:?]
    fromUnixTimestampMillis :: function [[C]:?]
    now :: function [[C]:?]
  Delay :: function [[C]:?]
  DockWidgetPluginGuiInfo :: table [1 claves]
    new :: function [[C]:?]
  ElapsedTime :: function [[C]:?]
  Enum :: userdata
  Faces :: table [1 claves]
    new :: function [[C]:?]
  FloatCurveKey :: table [1 claves]
    new :: function [[C]:?]
  Font :: table [4 claves]
    fromEnum :: function [[C]:?]
    fromId :: function [[C]:?]
    fromName :: function [[C]:?]
    new :: function [[C]:?]
  Game :: userdata <DataModel>
  Instance :: table [2 claves]
    fromExisting :: function [[C]:?]
    new :: function [[C]:?]
  InstanceHandle :: table [1 claves]
    new :: function [[C]:?]
  NumberRange :: table [1 claves]
    new :: function [[C]:?]
  NumberSequence :: table [1 claves]
    new :: function [[C]:?]
  NumberSequenceKeypoint :: table [1 claves]
    new :: function [[C]:?]
  OverlapParams :: table [1 claves]
    new :: function [[C]:?]
  Path2DControlPoint :: table [1 claves]
    new :: function [[C]:?]
  PathWaypoint :: table [1 claves]
    new :: function [[C]:?]
  PhysicalProperties :: table [1 claves]
    new :: function [[C]:?]
        up[1] 0 :: nil (nil)
  PluginDrag :: table [1 claves]
    new :: function [[C]:?]
  PluginManager :: function [[C]:?]
  Random :: table [1 claves]
    new :: function [[C]:?]
  Ray :: table [1 claves]
    new :: function [[C]:?]
  RaycastParams :: table [1 claves]
    new :: function [[C]:?]
  Rect :: table [1 claves]
    new :: function [[C]:?]
  Region3 :: table [1 claves]
    new :: function [[C]:?]
  Region3int16 :: table [1 claves]
    new :: function [[C]:?]
  RotationCurveKey :: table [1 claves]
    new :: function [[C]:?]
  SecurityCapabilities :: table [2 claves]
    fromCurrent :: function [[C]:?]
    new :: function [[C]:?]
  SharedTable :: table [8 claves]
    clear :: function [[C]:?]
    clone :: function [[C]:?]
    cloneAndFreeze :: function [[C]:?]
    increment :: function [[C]:?]
    isFrozen :: function [[C]:?]
    new :: function [[C]:?]
    size :: function [[C]:?]
    update :: function [[C]:?]
  Spawn :: function [[C]:?]
  Stats :: function [[C]:?]
  TweenInfo :: table [1 claves]
    new :: function [[C]:?]
  UDim :: table [1 claves]
    new :: function [[C]:?]
  UDim2 :: table [3 claves]
    fromOffset :: function [[C]:?]
    fromScale :: function [[C]:?]
    new :: function [[C]:?]
  User :: table [2 claves]
    fromId :: function [[C]:?]
    fromString :: function [[C]:?]
  UserSettings :: function [[C]:?]
  ValueCurveKey :: table [1 claves]
    new :: function [[C]:?]
  Vector2 :: table [7 claves]
    max :: function [[C]:?]
    min :: function [[C]:?]
    new :: function [[C]:?]
    one :: userdata
    xAxis :: userdata
    yAxis :: userdata
    zero :: userdata
  Vector2int16 :: table [1 claves]
    new :: function [[C]:?]
  Vector3 :: table [12 claves]
    FromAxis :: function [[C]:?]
    FromNormalId :: function [[C]:?]
    fromAxis :: function [[C]:?]
    fromNormalId :: function [[C]:?]
    max :: function [[C]:?]
    min :: function [[C]:?]
    new :: function [[C]:?]
    one :: vector
    xAxis :: vector
    yAxis :: vector
    zAxis :: vector
    zero :: vector
  Vector3int16 :: table [1 claves]
    new :: function [[C]:?]
  Version :: function [[C]:?]
  Wait :: function [[C]:?]
  WebViewParams :: table [1 claves]
    new :: function [[C]:?]
  Workspace :: userdata <Workspace>
  _G :: table [0 claves]
  _VERSION :: string ("Luau")
  assert :: function [[C]:?]
  bit32 :: table [15 claves]
    arshift :: function [[C]:?]
    band :: function [[C]:?]
    bnot :: function [[C]:?]
    bor :: function [[C]:?]
    btest :: function [[C]:?]
    bxor :: function [[C]:?]
    byteswap :: function [[C]:?]
    countlz :: function [[C]:?]
    countrz :: function [[C]:?]
    extract :: function [[C]:?]
    lrotate :: function [[C]:?]
    lshift :: function [[C]:?]
    replace :: function [[C]:?]
    rrotate :: function [[C]:?]
    rshift :: function [[C]:?]
  buffer :: table [26 claves]
    copy :: function [[C]:?]
    create :: function [[C]:?]
    fill :: function [[C]:?]
    fromstring :: function [[C]:?]
    len :: function [[C]:?]
    readbits :: function [[C]:?]
    readf32 :: function [[C]:?]
    readf64 :: function [[C]:?]
    readi16 :: function [[C]:?]
    readi32 :: function [[C]:?]
    readi8 :: function [[C]:?]
    readstring :: function [[C]:?]
    readu16 :: function [[C]:?]
    readu32 :: function [[C]:?]
    readu8 :: function [[C]:?]
    tostring :: function [[C]:?]
    writebits :: function [[C]:?]
    writef32 :: function [[C]:?]
    writef64 :: function [[C]:?]
    writei16 :: function [[C]:?]
    writei32 :: function [[C]:?]
    writei8 :: function [[C]:?]
    writestring :: function [[C]:?]
    writeu16 :: function [[C]:?]
    writeu32 :: function [[C]:?]
    writeu8 :: function [[C]:?]
  collectgarbage :: function [[C]:?]
  coroutine :: table [9 claves]
    close :: function [[C]:?]
    create :: function [[C]:?]
    finally :: function [[C]:?]
    isyieldable :: function [[C]:?]
    resume :: function [[C]:?]
    running :: function [[C]:?]
    status :: function [[C]:?]
    wrap :: function [[C]:?]
    yield :: function [[C]:?]
  debug :: table [12 claves]
    dumpcodesize :: function [[C]:?]
    dumpheap :: function [[C]:?]
    dumprefs :: function [[C]:?]
    getmemorycategory :: function [[C]:?]
    info :: function [[C]:?]
    loadmodule :: function [[C]:?]
    profilebegin :: function [[C]:?]
    profileend :: function [[C]:?]
    resetmemorycategory :: function [[C]:?]
    setmemorycategory :: function [[C]:?]
    traceback :: function [[C]:?]
    tracerefs :: function [[C]:?]
  delay :: function [[C]:?]
  elapsedTime :: function [[C]:?]
  error :: function [[C]:?]
  game :: userdata <DataModel>
  gcinfo :: function [[C]:?]
  getfenv :: function [[C]:?]
  getmetatable :: function [[C]:?]
  ipairs :: function [[C]:?]
      up[1] function: 0x1ec086f7d73dfcb8 :: nil (nil)
  loadstring :: function [[C]:?]
  math :: table [44 claves]
    abs :: function [[C]:?]
    acos :: function [[C]:?]
    asin :: function [[C]:?]
    atan :: function [[C]:?]
    atan2 :: function [[C]:?]
    ceil :: function [[C]:?]
    clamp :: function [[C]:?]
    cos :: function [[C]:?]
    cosh :: function [[C]:?]
    deg :: function [[C]:?]
    e :: number (2.718281828459045)
    exp :: function [[C]:?]
    floor :: function [[C]:?]
    fmod :: function [[C]:?]
    frexp :: function [[C]:?]
    huge :: number (inf)
    isfinite :: function [[C]:?]
    isinf :: function [[C]:?]
    isnan :: function [[C]:?]
    ldexp :: function [[C]:?]
    lerp :: function [[C]:?]
    log :: function [[C]:?]
    log10 :: function [[C]:?]
    map :: function [[C]:?]
    max :: function [[C]:?]
    min :: function [[C]:?]
    modf :: function [[C]:?]
    nan :: number (nan)
    noise :: function [[C]:?]
    phi :: number (1.618033988749895)
    pi :: number (3.141592653589793)
    pow :: function [[C]:?]
    rad :: function [[C]:?]
    random :: function [[C]:?]
    randomseed :: function [[C]:?]
    round :: function [[C]:?]
    sign :: function [[C]:?]
    sin :: function [[C]:?]
    sinh :: function [[C]:?]
    sqrt :: function [[C]:?]
    sqrt2 :: number (1.4142135623730951)
    tan :: function [[C]:?]
    tanh :: function [[C]:?]
    tau :: number (6.283185307179586)
  newproxy :: function [[C]:?]
  next :: function [[C]:?]
  os :: table [4 claves]
    clock :: function [[C]:?]
    date :: function [[C]:?]
    difftime :: function [[C]:?]
    time :: function [[C]:?]
  pairs :: function [[C]:?]
      up[1] function: 0x01ce96e235596543 :: nil (nil)
  pcall :: function [[C]:?]
  print :: function [[C]:?]
  printidentity :: function [[C]:?]
  rawequal :: function [[C]:?]
  rawget :: function [[C]:?]
  rawlen :: function [[C]:?]
  rawset :: function [[C]:?]
  require :: function [[C]:?]
  select :: function [[C]:?]
  setfenv :: function [[C]:?]
  setmetatable :: function [[C]:?]
  settings :: function [[C]:?]
  shared :: table [0 claves]
  spawn :: function [[C]:?]
  stats :: function [[C]:?]
  string :: table [17 claves]
    byte :: function [[C]:?]
    char :: function [[C]:?]
    find :: function [[C]:?]
    format :: function [[C]:?]
    gmatch :: function [[C]:?]
    gsub :: function [[C]:?]
    len :: function [[C]:?]
    lower :: function [[C]:?]
    match :: function [[C]:?]
    pack :: function [[C]:?]
    packsize :: function [[C]:?]
    rep :: function [[C]:?]
    reverse :: function [[C]:?]
    split :: function [[C]:?]
    sub :: function [[C]:?]
    unpack :: function [[C]:?]
    upper :: function [[C]:?]
  table :: table [17 claves]
    clear :: function [[C]:?]
    clone :: function [[C]:?]
    concat :: function [[C]:?]
    create :: function [[C]:?]
    find :: function [[C]:?]
    foreach :: function [[C]:?]
    foreachi :: function [[C]:?]
    freeze :: function [[C]:?]
    getn :: function [[C]:?]
    insert :: function [[C]:?]
    isfrozen :: function [[C]:?]
    maxn :: function [[C]:?]
    move :: function [[C]:?]
    pack :: function [[C]:?]
    remove :: function [[C]:?]
    sort :: function [[C]:?]
    unpack :: function [[C]:?]
  task :: table [7 claves]
    cancel :: function [[C]:?]
    defer :: function [[C]:?]
    delay :: function [[C]:?]
    desynchronize :: function [[C]:?]
    spawn :: function [[C]:?]
    synchronize :: function [[C]:?]
    wait :: function [[C]:?]
  tick :: function [[C]:?]
  time :: function [[C]:?]
  tonumber :: function [[C]:?]
  tostring :: function [[C]:?]
  type :: function [[C]:?]
  typeof :: function [[C]:?]
  unpack :: function [[C]:?]
  utf8 :: table [9 claves]
    char :: function [[C]:?]
    charpattern :: string ("[ -�-�][�-�]*")
    codepoint :: function [[C]:?]
    codes :: function [[C]:?]
    graphemes :: function [[C]:?]
    len :: function [[C]:?]
    nfcnormalize :: function [[C]:?]
    nfdnormalize :: function [[C]:?]
    offset :: function [[C]:?]
  vector :: table [16 claves]
    abs :: function [[C]:?]
    angle :: function [[C]:?]
    ceil :: function [[C]:?]
    clamp :: function [[C]:?]
    create :: function [[C]:?]
    cross :: function [[C]:?]
    dot :: function [[C]:?]
    floor :: function [[C]:?]
    lerp :: function [[C]:?]
    magnitude :: function [[C]:?]
    max :: function [[C]:?]
    min :: function [[C]:?]
    normalize :: function [[C]:?]
    one :: vector
    sign :: function [[C]:?]
    zero :: vector
  version :: function [[C]:?]
  wait :: function [[C]:?]
  warn :: function [[C]:?]
  workspace :: userdata <Workspace>
  xpcall :: function [[C]:?]
  ypcall :: function [[C]:?]
  userdata: 0x1e8c195140af19c8 :: function [[C]:?]
      up[1] userdata: 0x1e8c195140af19c8 :: nil (nil)
  userdata: 0x93d6e9a5833e3c64 :: function [[C]:?]
      up[1] userdata: 0x93d6e9a5833e3c64 :: nil (nil)
  userdata: 0xfd124a3b8aaaad52 :: function [[C]:?]
      up[1] userdata: 0xfd124a3b8aaaad52 :: nil (nil)

==========================================================================================
  11. getreg()
==========================================================================================

getreg :: table [1685 claves]
  1 :: thread
  2 :: table [0 claves]
  3 :: thread
  4 :: table [0 claves]
  5 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0xac13fb37f15eb1ec :: nil (nil)
      up[2] function: 0xd6afd0b4aa4f1b2f :: nil (nil)
  6 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  7 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
  8 :: table [7 claves]
    __index :: [CICLO]
    _startBoundFn :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
    _stopBoundFn :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
    bindRoot :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
        up[1] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
    destroy :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
        up[1] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
    new :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
        up[1] function: 0xe22ae5c6bdf8418f :: nil (nil)
        up[2] table: 0x52e47b996ed20756 :: nil (nil)
    unbindRoot :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
        up[1] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
  9 :: thread
  10 :: thread
  11 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  12 :: thread
  13 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  14 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 01_server :: nil (nil)
  15 :: thread
  16 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x7d0d15993057b8c1 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x4ca06fb071c8b3c0 :: nil (nil)
  17 :: thread
  18 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x85231c1e4cf27ecb :: nil (nil)
      up[2] table: 0x84d2a2e8b6b5855a :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  19 :: thread
  20 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x28974e27ed33ebcd :: nil (nil)
      up[2] function: 0xf96f9bb5cd776550 :: nil (nil)
  21 :: thread
  22 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x28974e27ed33ebcd :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] jphuot2 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0xcd3f4362bce60c18 :: nil (nil)
      up[6] jphuot2 :: nil (nil)
      up[7] function: 0xf96f9bb5cd776550 :: nil (nil)
  23 :: thread
  24 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  25 :: thread
  26 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  27 :: thread
  28 :: thread
  29 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xe36065e14b9c789f :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0xbe8c9dc3a0906405 :: nil (nil)
  30 :: thread
  31 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x079d6a49271619bb :: nil (nil)
      up[2] table: 0xd9c934e79bfbddd0 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  32 :: thread
  33 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x173ba6dbbd68599e :: nil (nil)
      up[2] function: 0xed3f77fec189056e :: nil (nil)
  34 :: thread
  35 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x173ba6dbbd68599e :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] whisperingstarwars :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x6733c13de6a33e72 :: nil (nil)
      up[6] whisperingstarwars :: nil (nil)
      up[7] function: 0xed3f77fec189056e :: nil (nil)
  36 :: thread
  37 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  38 :: thread
  39 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  40 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] bar :: nil (nil)
  41 :: thread
  42 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x509eae106f114e8b :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x79020c2614cbba3e :: nil (nil)
  43 :: thread
  44 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x564bb5a131b5dc21 :: nil (nil)
      up[2] table: 0x9d214b67ab39255b :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  45 :: thread
  46 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x3f20830aa7ca13dc :: nil (nil)
      up[2] function: 0x3844ddcccedc1dc0 :: nil (nil)
  47 :: thread
  48 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x3f20830aa7ca13dc :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] fowascnd :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x2f94d90630eb99b3 :: nil (nil)
      up[6] fowascnd :: nil (nil)
      up[7] function: 0x3844ddcccedc1dc0 :: nil (nil)
  49 :: thread
  50 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  51 :: thread
  52 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  53 :: thread
  54 :: thread
  55 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xb01bfa9e17060949 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x6b6ec3720420f40d :: nil (nil)
  56 :: thread
  57 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xb3e2326b30e34163 :: nil (nil)
      up[2] table: 0x86f4eefb1e9a1480 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  58 :: thread
  59 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x479042140547fdb8 :: nil (nil)
      up[2] function: 0x0751a8ae7ad54961 :: nil (nil)
  60 :: thread
  61 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x479042140547fdb8 :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] Marox_140 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0xfa5c116d86619368 :: nil (nil)
      up[6] Marox_140 :: nil (nil)
      up[7] function: 0x0751a8ae7ad54961 :: nil (nil)
  62 :: thread
  63 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  64 :: thread
  65 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  66 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] bar :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
  67 :: thread
  68 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xabb71f813f6babee :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x482f92b2e51bb563 :: nil (nil)
  69 :: thread
  70 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xdfcbcb466c48a0ec :: nil (nil)
      up[2] table: 0xb3cab45e383b87e6 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  71 :: thread
  72 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0xf0ceee8ab946561d :: nil (nil)
      up[2] function: 0x13c2d8c20181a3bd :: nil (nil)
  73 :: thread
  74 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0xf0ceee8ab946561d :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] Tophat_906 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x6a61a05b0b1e66d4 :: nil (nil)
      up[6] Tophat_906 :: nil (nil)
      up[7] function: 0x13c2d8c20181a3bd :: nil (nil)
  75 :: thread
  76 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  77 :: thread
  78 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  79 :: thread
  80 :: thread
  81 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x9d97f6a727f102b4 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x49332b7e294c3c18 :: nil (nil)
  82 :: thread
  83 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x16b96f8a9d3d3c13 :: nil (nil)
      up[2] table: 0x5ea732c5d4b04e8e :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  84 :: thread
  85 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x1e8445c7f98581b0 :: nil (nil)
      up[2] function: 0x7a754c2eaad2e930 :: nil (nil)
  86 :: thread
  87 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x1e8445c7f98581b0 :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] abobus22909 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x448c5ca8b8af90c6 :: nil (nil)
      up[6] abobus22909 :: nil (nil)
      up[7] function: 0x7a754c2eaad2e930 :: nil (nil)
  88 :: thread
  89 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  90 :: thread
  91 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  92 :: table [90 claves]
    Destroy :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    __index :: [CICLO]
    _setToggleItemsVisible :: function [ReplicatedStorage.bar.Icon:?]
    _updateSelectionInstances :: function [ReplicatedStorage.bar.Icon:?]
    addToJanitor :: function [ReplicatedStorage.bar.Icon:?]
    align :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    autoDeselect :: function [ReplicatedStorage.bar.Icon:?]
    baseDisplayOrder :: number (10)
    baseDisplayOrderChanged :: table [1 claves]
      _handlerListHead :: table [4 claves]
        _connected :: boolean (true)
        _fn :: function [ReplicatedStorage.bar.Icon.Elements.Container:?]
            up[1] TopbarCenteredClipped :: nil (nil)
            up[2] table: 0x972c3e92ce52a519 :: nil (nil)
        _next :: table [4 claves]
          _connected :: boolean (true)
          _fn :: function [ReplicatedStorage.bar.Icon.Elements.Container:?]
              up[1] TopbarStandardClipped :: nil (nil)
              up[2] table: 0x972c3e92ce52a519 :: nil (nil)
          _next :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Container:?]
                up[1] TopbarCentered :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon.Elements.Container:?]
                  up[1] TopbarStandard :: nil (nil)
                  up[2] table: 0x972c3e92ce52a519 :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
          _signal :: [CICLO]
        _signal :: [CICLO]
    baseTheme :: table [42 claves]
      1 :: table [3 claves]
        1 :: string ("IconCorners")
        2 :: string ("CornerRadius")
        3 :: userdata
      2 :: table [3 claves]
        1 :: string ("Selection")
        2 :: string ("RotationSpeed")
        3 :: number (1)
      3 :: table [3 claves]
        1 :: string ("Selection")
        2 :: string ("Size")
        3 :: userdata
      4 :: table [3 claves]
        1 :: string ("Selection")
        2 :: string ("Position")
        3 :: userdata
      5 :: table [3 claves]
        1 :: string ("SelectionGradient")
        2 :: string ("Color")
        3 :: userdata
      6 :: table [4 claves]
        1 :: string ("IconImage")
        2 :: string ("Image")
        3 :: string ("")
        4 :: string ("Deselected")
      7 :: table [4 claves]
        1 :: string ("IconLabel")
        2 :: string ("Text")
        3 :: string ("")
        4 :: string ("Deselected")
      8 :: table [4 claves]
        1 :: string ("IconLabel")
        2 :: string ("Position")
        3 :: userdata
        4 :: string ("Deselected")
      9 :: table [4 claves]
        1 :: string ("Widget")
        2 :: string ("DesiredWidth")
        3 :: number (44)
        4 :: string ("Deselected")
      10 :: table [4 claves]
        1 :: string ("Widget")
        2 :: string ("MinimumWidth")
        3 :: number (44)
        4 :: string ("Deselected")
      11 :: table [4 claves]
        1 :: string ("Widget")
        2 :: string ("MinimumHeight")
        3 :: number (44)
        4 :: string ("Deselected")
      12 :: table [4 claves]
        1 :: string ("Widget")
        2 :: string ("BorderSize")
        3 :: number (4)
        4 :: string ("Deselected")
      13 :: table [4 claves]
        1 :: string ("IconButton")
        2 :: string ("BackgroundColor3")
        3 :: userdata
        4 :: string ("Deselected")
      14 :: table [4 claves]
        1 :: string ("IconButton")
        2 :: string ("BackgroundTransparency")
        3 :: number (0.08)
        4 :: string ("Deselected")
      15 :: table [4 claves]
        1 :: string ("IconImageScale")
        2 :: string ("Value")
        3 :: number (0.5)
        4 :: string ("Deselected")
      16 :: table [4 claves]
        1 :: string ("IconImageCorner")
        2 :: string ("CornerRadius")
        3 :: userdata
        4 :: string ("Deselected")
      17 :: table [4 claves]
        1 :: string ("IconImage")
        2 :: string ("ImageColor3")
        3 :: userdata
        4 :: string ("Deselected")
      18 :: table [4 claves]
        1 :: string ("IconImage")
        2 :: string ("ImageTransparency")
        3 :: number (0)
        4 :: string ("Deselected")
      19 :: table [4 claves]
        1 :: string ("IconImageRatio")
        2 :: string ("AspectRatio")
        3 :: number (1)
        4 :: string ("Deselected")
      20 :: table [4 claves]
        1 :: string ("IconLabel")
        2 :: string ("FontFace")
        3 :: userdata
        4 :: string ("Deselected")
      21 :: table [4 claves]
        1 :: string ("IconLabel")
        2 :: string ("TextSize")
        3 :: number (16)
        4 :: string ("Deselected")
      22 :: table [4 claves]
        1 :: string ("IconSpot")
        2 :: string ("BackgroundTransparency")
        3 :: number (1)
        4 :: string ("Deselected")
      23 :: table [4 claves]
        1 :: string ("IconOverlay")
        2 :: string ("BackgroundTransparency")
        3 :: number (0.85)
        4 :: string ("Deselected")
      24 :: table [4 claves]
        1 :: string ("IconSpotGradient")
        2 :: string ("Enabled")
        3 :: boolean (false)
        4 :: string ("Deselected")
      25 :: table [4 claves]
        1 :: string ("IconGradient")
        2 :: string ("Enabled")
        3 :: boolean (false)
        4 :: string ("Deselected")
      26 :: table [4 claves]
        1 :: string ("ClickRegion")
        2 :: string ("Active")
        3 :: boolean (true)
        4 :: string ("Deselected")
      27 :: table [4 claves]
        1 :: string ("Menu")
        2 :: string ("Active")
        3 :: boolean (false)
        4 :: string ("Deselected")
      28 :: table [4 claves]
        1 :: string ("ContentsList")
        2 :: string ("HorizontalAlignment")
        3 :: userdata
        4 :: string ("Deselected")
      29 :: table [4 claves]
        1 :: string ("Dropdown")
        2 :: string ("BackgroundColor3")
        3 :: userdata
        4 :: string ("Deselected")
      30 :: table [4 claves]
        1 :: string ("Dropdown")
        2 :: string ("BackgroundTransparency")
        3 :: number (0.08)
        4 :: string ("Deselected")
      31 :: table [4 claves]
        1 :: string ("Dropdown")
        2 :: string ("MaxIcons")
        3 :: number (4.5)
        4 :: string ("Deselected")
      32 :: table [4 claves]
        1 :: string ("Menu")
        2 :: string ("MaxIcons")
        3 :: number (4)
        4 :: string ("Deselected")
      33 :: table [4 claves]
        1 :: string ("Notice")
        2 :: string ("Position")
        3 :: userdata
        4 :: string ("Deselected")
      34 :: table [4 claves]
        1 :: string ("Notice")
        2 :: string ("Size")
        3 :: userdata
        4 :: string ("Deselected")
      35 :: table [4 claves]
        1 :: string ("NoticeLabel")
        2 :: string ("TextSize")
        3 :: number (13)
        4 :: string ("Deselected")
      36 :: table [4 claves]
        1 :: string ("PaddingLeft")
        2 :: string ("Size")
        3 :: userdata
        4 :: string ("Deselected")
      37 :: table [4 claves]
        1 :: string ("PaddingRight")
        2 :: string ("Size")
        3 :: userdata
        4 :: string ("Deselected")
      38 :: table [4 claves]
        1 :: string ("IconSpot")
        2 :: string ("BackgroundTransparency")
        3 :: number (0.7)
        4 :: string ("Selected")
      39 :: table [4 claves]
        1 :: string ("IconSpot")
        2 :: string ("BackgroundColor3")
        3 :: userdata
        4 :: string ("Selected")
      40 :: table [4 claves]
        1 :: string ("IconSpotGradient")
        2 :: string ("Enabled")
        3 :: boolean (true)
        4 :: string ("Selected")
      41 :: table [4 claves]
        1 :: string ("IconSpotGradient")
        2 :: string ("Rotation")
        3 :: number (45)
        4 :: string ("Selected")
      42 :: table [4 claves]
        1 :: string ("IconSpotGradient")
        2 :: string ("Color")
        3 :: userdata
        4 :: string ("Selected")
    bindEvent :: function [ReplicatedStorage.bar.Icon:?]
    bindToggleItem :: function [ReplicatedStorage.bar.Icon:?]
    bindToggleKey :: function [ReplicatedStorage.bar.Icon:?]
    call :: function [ReplicatedStorage.bar.Icon:?]
    captionLastClosedClock :: number (550.4800865710004)
    clearNotices :: function [ReplicatedStorage.bar.Icon:?]
    clipOutside :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0xfe6178e3233d03d9 :: nil (nil)
    container :: table [4 claves]
      TopbarCentered :: userdata <ScreenGui>
      TopbarCenteredClipped :: userdata <ScreenGui>
      TopbarStandard :: userdata <ScreenGui>
      TopbarStandardClipped :: userdata <ScreenGui>
    convertLabelToNumberSpinner :: function [ReplicatedStorage.bar.Icon:?]
    debounce :: function [ReplicatedStorage.bar.Icon:?]
    deselect :: function [ReplicatedStorage.bar.Icon:?]
    destroy :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    disableOverlay :: function [ReplicatedStorage.bar.Icon:?]
    disableStateOverlay :: function [ReplicatedStorage.bar.Icon:?]
    freezeMenu :: function [ReplicatedStorage.bar.Icon:?]
    getCollective :: function [ReplicatedStorage.bar.Icon:?]
    getDropdown :: function [ReplicatedStorage.bar.Icon:?]
        up[1] Elements :: nil (nil)
    getIcon :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
        up[2] table: 0xe27087d7e27658d5 :: nil (nil)
    getIconByUID :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    getIcons :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    getInstance :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    getInstanceOrCollective :: function [ReplicatedStorage.bar.Icon:?]
    getStateGroup :: function [ReplicatedStorage.bar.Icon:?]
    highlightIcon :: boolean (false)
    highlightKey :: userdata
    iconAdded :: table [1 claves]
      _handlerListHead :: table [4 claves]
        _connected :: boolean (true)
        _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            up[1] true :: nil (nil)
            up[2] true :: nil (nil)
        _next :: boolean (false)
        _signal :: [CICLO]
    iconChanged :: table [1 claves]
      _handlerListHead :: table [4 claves]
        _connected :: boolean (true)
        _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            up[1] true :: nil (nil)
            up[2] true :: nil (nil)
        _next :: boolean (false)
        _signal :: [CICLO]
    iconRemoved :: table [1 claves]
      _handlerListHead :: table [4 claves]
        _connected :: boolean (true)
        _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            up[1] true :: nil (nil)
            up[2] true :: nil (nil)
        _next :: boolean (false)
        _signal :: [CICLO]
    iconsDictionary :: table [3 claves]
      03Vow4j{ :: table [64 claves]
        UID :: string ("03Vow4j{")
        activeState :: string ("Deselected")
        alignment :: string ("Left")
        alignmentChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
                up[1] ClickRegion :: nil (nil)
                up[2] TopbarStandardClipped :: nil (nil)
                up[3] table: 0x4f075753b0bba0ec :: nil (nil)
                up[4] Caption :: nil (nil)
                up[5] table: 0xfe6178e3233d03d9 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                  up[1] MenuUIListLayout :: nil (nil)
                  up[2] Widget :: nil (nil)
                  up[3] table: 0xe174e6d8ceba7991 :: nil (nil)
                  up[4] IconSpot :: nil (nil)
                  up[5] Menu :: nil (nil)
                  up[6] MenuGap :: nil (nil)
                  up[7] function: 0x9448e89d4653f507 :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        alignmentHolder :: userdata <ScrollingFrame>
        appearance :: table [3 claves]
          Deselected :: table [39 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [4 claves]
              1 :: string ("IconOverlay")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.85)
              4 :: string ("Deselected")
            3 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            4 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            5 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundTransparency")
              3 :: number (1)
              4 :: string ("Deselected")
            6 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            7 :: table [4 claves]
              1 :: string ("IconImageRatio")
              2 :: string ("AspectRatio")
              3 :: number (1)
              4 :: string ("Deselected")
            8 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            9 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("DesiredWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            10 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("http://www.roblox.com/asset/?id=6031265976")
              4 :: string ("Deselected")
              5 :: string ("3M]EM]Mo")
            11 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("FontFace")
              3 :: userdata
              4 :: string ("Deselected")
            12 :: table [4 claves]
              1 :: string ("IconImageScale")
              2 :: string ("Value")
              3 :: number (0.5)
              4 :: string ("Deselected")
            13 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("")
              4 :: string ("Deselected")
            14 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            15 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            16 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            17 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            18 :: table [4 claves]
              1 :: string ("IconGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            19 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (102)
              4 :: string ("Deselected")
              5 :: string ("BEJX#{]b")
            20 :: table [4 claves]
              1 :: string ("PaddingRight")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            21 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (102)
              4 :: string ("Deselected")
              5 :: string ("DiglCD>o")
            22 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            23 :: table [4 claves]
              1 :: string ("PaddingLeft")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            24 :: table [4 claves]
              1 :: string ("ContentsList")
              2 :: string ("HorizontalAlignment")
              3 :: userdata
              4 :: string ("Deselected")
            25 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageColor3")
              3 :: userdata
              4 :: string ("Deselected")
            26 :: table [4 claves]
              1 :: string ("NoticeLabel")
              2 :: string ("TextSize")
              3 :: number (13)
              4 :: string ("Deselected")
            27 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("MaxIcons")
              3 :: number (4.5)
              4 :: string ("Deselected")
            28 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            29 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            30 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("MaxIcons")
              3 :: number (4)
              4 :: string ("Deselected")
            31 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            32 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("Active")
              3 :: boolean (false)
              4 :: string ("Deselected")
            33 :: table [4 claves]
              1 :: string ("ClickRegion")
              2 :: string ("Active")
              3 :: boolean (true)
              4 :: string ("Deselected")
            34 :: table [4 claves]
              1 :: string ("IconImageCorner")
              2 :: string ("CornerRadius")
              3 :: userdata
              4 :: string ("Deselected")
            35 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageTransparency")
              3 :: number (0)
              4 :: string ("Deselected")
            36 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumHeight")
              3 :: number (44)
              4 :: string ("Deselected")
            37 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("TextSize")
              3 :: number (16)
              4 :: string ("Deselected")
            38 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            39 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("BorderSize")
              3 :: number (4)
              4 :: string ("Deselected")
          Selected :: table [43 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [4 claves]
              1 :: string ("IconOverlay")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.85)
              4 :: string ("Deselected")
            3 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            4 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            5 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.7)
              4 :: string ("Selected")
            6 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            7 :: table [4 claves]
              1 :: string ("IconImageRatio")
              2 :: string ("AspectRatio")
              3 :: number (1)
              4 :: string ("Deselected")
            8 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Enabled")
              3 :: boolean (true)
              4 :: string ("Selected")
            9 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("DesiredWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            10 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Selected")
            11 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("")
              4 :: string ("Deselected")
            12 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("FontFace")
              3 :: userdata
              4 :: string ("Deselected")
            13 :: table [4 claves]
              1 :: string ("IconImageScale")
              2 :: string ("Value")
              3 :: number (0.5)
              4 :: string ("Deselected")
            14 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("")
              4 :: string ("Deselected")
            15 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Rotation")
              3 :: number (45)
              4 :: string ("Selected")
            16 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            17 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            18 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            19 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            20 :: table [4 claves]
              1 :: string ("IconGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            21 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (102)
              4 :: string ("Selected")
              5 :: string ("mN8v~c>Q")
            22 :: table [4 claves]
              1 :: string ("PaddingRight")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            23 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (102)
              4 :: string ("Selected")
              5 :: string ("G)n8TMl>")
            24 :: table [4 claves]
              1 :: string ("ClickRegion")
              2 :: string ("Active")
              3 :: boolean (true)
              4 :: string ("Deselected")
            25 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            26 :: table [4 claves]
              1 :: string ("PaddingLeft")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            27 :: table [4 claves]
              1 :: string ("ContentsList")
              2 :: string ("HorizontalAlignment")
              3 :: userdata
              4 :: string ("Deselected")
            28 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageColor3")
              3 :: userdata
              4 :: string ("Deselected")
            29 :: table [4 claves]
              1 :: string ("NoticeLabel")
              2 :: string ("TextSize")
              3 :: number (13)
              4 :: string ("Deselected")
            30 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("MaxIcons")
              3 :: number (4.5)
              4 :: string ("Deselected")
            31 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            32 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            33 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("MaxIcons")
              3 :: number (4)
              4 :: string ("Deselected")
            34 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            35 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("Active")
              3 :: boolean (false)
              4 :: string ("Deselected")
            36 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Color")
              3 :: userdata
              4 :: string ("Selected")
            37 :: table [4 claves]
              1 :: string ("IconImageCorner")
              2 :: string ("CornerRadius")
              3 :: userdata
              4 :: string ("Deselected")
            38 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageTransparency")
              3 :: number (0)
              4 :: string ("Deselected")
            39 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumHeight")
              3 :: number (44)
              4 :: string ("Deselected")
            40 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("TextSize")
              3 :: number (16)
              4 :: string ("Deselected")
            41 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            42 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("BorderSize")
              3 :: number (4)
              4 :: string ("Deselected")
            43 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("http://www.roblox.com/asset/?id=6031265976")
              4 :: string ("Selected")
              5 :: string ("3M]EM]Mo")
          Viewing :: table [6 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            3 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            4 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            5 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            6 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("http://www.roblox.com/asset/?id=6031265976")
              4 :: string ("Viewing")
              5 :: string ("3M]EM]Mo")
        appliedTheme :: table [42 claves]
          1 :: table [3 claves]
            1 :: string ("IconCorners")
            2 :: string ("CornerRadius")
            3 :: userdata
          2 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("RotationSpeed")
            3 :: number (1)
          3 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("Size")
            3 :: userdata
          4 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("Position")
            3 :: userdata
          5 :: table [3 claves]
            1 :: string ("SelectionGradient")
            2 :: string ("Color")
            3 :: userdata
          6 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("Image")
            3 :: string ("")
            4 :: string ("Deselected")
          7 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("Text")
            3 :: string ("")
            4 :: string ("Deselected")
          8 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("Position")
            3 :: userdata
            4 :: string ("Deselected")
          9 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("DesiredWidth")
            3 :: number (44)
            4 :: string ("Deselected")
          10 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("MinimumWidth")
            3 :: number (44)
            4 :: string ("Deselected")
          11 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("MinimumHeight")
            3 :: number (44)
            4 :: string ("Deselected")
          12 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("BorderSize")
            3 :: number (4)
            4 :: string ("Deselected")
          13 :: table [4 claves]
            1 :: string ("IconButton")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Deselected")
          14 :: table [4 claves]
            1 :: string ("IconButton")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.08)
            4 :: string ("Deselected")
          15 :: table [4 claves]
            1 :: string ("IconImageScale")
            2 :: string ("Value")
            3 :: number (0.5)
            4 :: string ("Deselected")
          16 :: table [4 claves]
            1 :: string ("IconImageCorner")
            2 :: string ("CornerRadius")
            3 :: userdata
            4 :: string ("Deselected")
          17 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("ImageColor3")
            3 :: userdata
            4 :: string ("Deselected")
          18 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("ImageTransparency")
            3 :: number (0)
            4 :: string ("Deselected")
          19 :: table [4 claves]
            1 :: string ("IconImageRatio")
            2 :: string ("AspectRatio")
            3 :: number (1)
            4 :: string ("Deselected")
          20 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("FontFace")
            3 :: userdata
            4 :: string ("Deselected")
          21 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("TextSize")
            3 :: number (16)
            4 :: string ("Deselected")
          22 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundTransparency")
            3 :: number (1)
            4 :: string ("Deselected")
          23 :: table [4 claves]
            1 :: string ("IconOverlay")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.85)
            4 :: string ("Deselected")
          24 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Enabled")
            3 :: boolean (false)
            4 :: string ("Deselected")
          25 :: table [4 claves]
            1 :: string ("IconGradient")
            2 :: string ("Enabled")
            3 :: boolean (false)
            4 :: string ("Deselected")
          26 :: table [4 claves]
            1 :: string ("ClickRegion")
            2 :: string ("Active")
            3 :: boolean (true)
            4 :: string ("Deselected")
          27 :: table [4 claves]
            1 :: string ("Menu")
            2 :: string ("Active")
            3 :: boolean (false)
            4 :: string ("Deselected")
          28 :: table [4 claves]
            1 :: string ("ContentsList")
            2 :: string ("HorizontalAlignment")
            3 :: userdata
            4 :: string ("Deselected")
          29 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Deselected")
          30 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.08)
            4 :: string ("Deselected")
          31 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("MaxIcons")
            3 :: number (4.5)
            4 :: string ("Deselected")
          32 :: table [4 claves]
            1 :: string ("Menu")
            2 :: string ("MaxIcons")
            3 :: number (4)
            4 :: string ("Deselected")
          33 :: table [4 claves]
            1 :: string ("Notice")
            2 :: string ("Position")
            3 :: userdata
            4 :: string ("Deselected")
          34 :: table [4 claves]
            1 :: string ("Notice")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          35 :: table [4 claves]
            1 :: string ("NoticeLabel")
            2 :: string ("TextSize")
            3 :: number (13)
            4 :: string ("Deselected")
          36 :: table [4 claves]
            1 :: string ("PaddingLeft")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          37 :: table [4 claves]
            1 :: string ("PaddingRight")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          38 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.7)
            4 :: string ("Selected")
          39 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Selected")
          40 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Enabled")
            3 :: boolean (true)
            4 :: string ("Selected")
          41 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Rotation")
            3 :: number (45)
            4 :: string ("Selected")
          42 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Color")
            3 :: userdata
            4 :: string ("Selected")
        bindedEvents :: table [1 claves]
          deselected :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] function: 0xfa8c313a947edbca :: nil (nil)
                up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon:?]
                  up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
                  up[2] StarterGui :: nil (nil)
              _next :: table [4 claves]
                _connected :: boolean (true)
                _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                    up[1] IconButton :: nil (nil)
                    up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
                _next :: boolean (false)
                _signal :: table [1 claves]
                  _handlerListHead :: [CICLO]
              _signal :: table [1 claves]
                _handlerListHead :: [CICLO]
            _signal :: table [1 claves]
              _handlerListHead :: [CICLO]
        bindedToggleKeys :: table [0 claves]
        cachedCollectives :: table [6 claves]
          Dropdown :: table [0 claves]
          IconCorners :: table [4 claves]
            1 :: userdata <UICorner>
            2 :: userdata <UICorner>
            3 :: userdata <UICorner>
            4 :: userdata <UICorner>
          Notice :: table [0 claves]
          NoticeLabel :: table [0 claves]
          Selection :: table [0 claves]
          SelectionGradient :: table [0 claves]
        cachedInstances :: table [39 claves]
          Box :: boolean (true)
          Caption :: boolean (true)
          CaptionCorner :: boolean (true)
          Caret :: boolean (true)
          ClickRegion :: boolean (true)
          ClippedClone :: boolean (true)
          Contents :: boolean (true)
          ContentsList :: boolean (true)
          DropShadow :: boolean (true)
          Header :: boolean (true)
          Hotkeys :: boolean (true)
          IconButton :: boolean (true)
          IconGradient :: boolean (true)
          IconImage :: boolean (true)
          IconImageCorner :: boolean (true)
          IconImageRatio :: boolean (true)
          IconImageScale :: boolean (true)
          IconLabel :: boolean (true)
          IconLabelContainer :: boolean (true)
          IconOverlay :: boolean (true)
          IconSpot :: boolean (true)
          IconSpotGradient :: boolean (true)
          Inset :: boolean (true)
          Key1 :: boolean (true)
          LabelContent :: boolean (true)
          Layout :: boolean (true)
          Layout1 :: boolean (true)
          Menu :: boolean (true)
          MenuGap :: boolean (true)
          MenuUIListLayout :: boolean (true)
          OverlayUICorner :: boolean (true)
          Padding :: boolean (true)
          PaddingCenter :: boolean (true)
          PaddingLeft :: boolean (true)
          PaddingRight :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
          Widget :: boolean (true)
        cachedNamesToInstances :: table [37 claves]
          Box :: userdata <Frame>
          Caption :: userdata <CanvasGroup>
          CaptionCorner :: userdata <UICorner>
          Caret :: userdata <ImageLabel>
          ClickRegion :: userdata <TextButton>
          ClippedClone :: userdata <ObjectValue>
          Contents :: userdata <Frame>
          ContentsList :: userdata <UIListLayout>
          DropShadow :: userdata <ImageLabel>
          Header :: userdata <TextLabel>
          Hotkeys :: userdata <Frame>
          IconButton :: userdata <Frame>
          IconGradient :: userdata <UIGradient>
          IconImage :: userdata <ImageLabel>
          IconImageCorner :: userdata <UICorner>
          IconImageRatio :: userdata <UIAspectRatioConstraint>
          IconImageScale :: userdata <NumberValue>
          IconLabel :: userdata <TextLabel>
          IconLabelContainer :: userdata <Frame>
          IconOverlay :: userdata <Frame>
          IconSpot :: userdata <Frame>
          IconSpotGradient :: userdata <UIGradient>
          Inset :: userdata <UIPadding>
          Key1 :: userdata <ImageLabel>
          LabelContent :: userdata <TextLabel>
          Layout :: userdata <UIListLayout>
          Layout1 :: userdata <UIListLayout>
          Menu :: userdata <ScrollingFrame>
          MenuGap :: userdata <Frame>
          MenuUIListLayout :: userdata <UIListLayout>
          OverlayUICorner :: userdata <UICorner>
          Padding :: userdata <UIPadding>
          PaddingCenter :: userdata <Frame>
          PaddingLeft :: userdata <Frame>
          PaddingRight :: userdata <Frame>
          UICorner :: userdata <UICorner>
          Widget :: userdata <Frame>
        caption :: userdata <CanvasGroup>
        captionJanitor :: table [7 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0x4204172f66462a99 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:268\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          table: 0xe5023e01ac910881 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:263\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          table: 0xf23982f20c94792b :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:299\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          Caption :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:258\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:159\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
        captionText :: string ("shop")
        childIconsDict :: table [0 claves]
        childThemeModified :: table [1 claves]
          _handlerListHead :: boolean (false)
        creationTime :: number (550.3335852629989)
        customBehaviours :: table [13 claves]
          ContentsList-HorizontalAlignment :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconButton-BackgroundTransparency :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] GuiService :: nil (nil)
          IconImage-Image :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] IconImage :: nil (nil)
              up[2] function: 0x9448e89d4653f507 :: nil (nil)
          IconImageRatio-AspectRatio :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconLabel-FontFace :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] IconLabel :: nil (nil)
              up[2] function: 0x9448e89d4653f507 :: nil (nil)
          IconLabel-Text :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconSpot-Visible :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] Widget :: nil (nil)
              up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
              up[3] IconSpot :: nil (nil)
              up[4] Menu :: nil (nil)
              up[5] MenuGap :: nil (nil)
              up[6] MenuUIListLayout :: nil (nil)
              up[7] function: 0x9448e89d4653f507 :: nil (nil)
          Indicator-Visible :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-BorderSize :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] Widget :: nil (nil)
              up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
              up[3] IconSpot :: nil (nil)
              up[4] Menu :: nil (nil)
              up[5] MenuGap :: nil (nil)
              up[6] MenuUIListLayout :: nil (nil)
              up[7] function: 0x9448e89d4653f507 :: nil (nil)
          Widget-DesiredWidth :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-MinimumHeight :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-MinimumWidth :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-Visible :: function [ReplicatedStorage.bar.Icon.Utility:?]
        deselectWhenOtherIconSelected :: boolean (true)
        deselected :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] function: 0xfa8c313a947edbca :: nil (nil)
                up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon:?]
                  up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
                  up[2] StarterGui :: nil (nil)
              _next :: table [4 claves]
                _connected :: boolean (true)
                _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                    up[1] IconButton :: nil (nil)
                    up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
                _next :: boolean (false)
                _signal :: [CICLO]
              _signal :: [CICLO]
            _signal :: [CICLO]
        dropdownChildAdded :: table [1 claves]
          _handlerListHead :: boolean (false)
        dropdownIcons :: table [0 claves]
        dropdownJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        dropdownSet :: table [1 claves]
          _handlerListHead :: boolean (false)
        enabled :: boolean (true)
        endNotices :: table [1 claves]
          _handlerListHead :: boolean (false)
        fakeToggleKeyChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
                up[1] UserInputService :: nil (nil)
                up[2] Caption :: nil (nil)
                up[3] table: 0xe174e6d8ceba7991 :: nil (nil)
                up[4] Header :: nil (nil)
                up[5] LabelContent :: nil (nil)
                up[6] Hotkeys :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        iconModule :: userdata <ModuleScript>
        indicatorSet :: table [1 claves]
          _handlerListHead :: boolean (false)
        isEnabled :: boolean (true)
        isSelected :: boolean (false)
        isViewing :: boolean (false)
        janitor :: table [40 claves]
          function: 0xdb2164f25fef3a73 :: table [2 claves]
            1 :: boolean (true)
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:197 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          CurrentlyCleaning :: boolean (false)
          table: 0x086c7a0560e6780c :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:215 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x1ba881b6818ae81e :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:211 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x1e20ae62b11bf2a2 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:212 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x3d56add613eee55e :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:204 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x41cc1c52f6bec7b7 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:220 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x5b9318a244704ad7 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:208 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x5bd623033c60eaca :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:225 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x622d6935c54cc543 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:224 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x7233352f34e3c4dd :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:191 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x80ad0ac7a005ac8a :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:189 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x87181f3920b676aa :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:190 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x964c0d278b823128 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:192 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x981154f803d5aa0a :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:214 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0x99935b3ba6fd2bf4 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:205 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xa4ec2e59d08549ca :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:207 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xa510eeaf0e95bd8e :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:187 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xa9c13ab6120899a3 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:222 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xc0e87f4029faaa6f :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:203 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xc521bd4e9cc1008a :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:223 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xd593018e41821632 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:188 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xd9379aa0a724a667 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:219 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xdcc3fa5bb7af0aa4 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:210 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xe2c1bcfbd50bdb03 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:213 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xe5cea502ac92724d :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:217 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xebaac19cecabad65 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:221 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xef2f60ea3c3b1838 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:216 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xef4ad16fe9011e3b :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:206 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xf4e365e07ffb7595 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:218 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xf597acaea0106300 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:209 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xfbe3890b6ffc8ed8 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Utility:152 function clipOutside\nReplicatedStorage.bar.Icon:1076 function clipOutside\nReplicatedStorage.bar.Icon.Elements.Caption:153\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          table: 0xfec56cabf4b37dc6 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:202 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          table: 0xfee85c2bfa77a6ec :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:378 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          Caption :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Utility:156 function clipOutside\nReplicatedStorage.bar.Icon:1076 function clipOutside\nReplicatedStorage.bar.Icon.Elements.Caption:153\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:543\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:309 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Widget:401\nReplicatedStorage.bar.Icon:257 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Widget:44\nReplicatedStorage.bar.Icon:257 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:349 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
          Widget :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:257 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
        joinJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        joinedFrame :: boolean (false)
        joinedParent :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        menuChildAdded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
                up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        menuIcons :: table [0 claves]
        menuJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        menuSet :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
                up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        noticeChanged :: table [1 claves]
          _handlerListHead :: boolean (false)
        noticeStarted :: table [1 claves]
          _handlerListHead :: boolean (false)
        notices :: table [0 claves]
        notified :: table [1 claves]
          _handlerListHead :: boolean (false)
        oneClickEnabled :: boolean (true)
        originalAlignment :: string ("Left")
        parentIconUID :: boolean (false)
        resizingComplete :: table [1 claves]
          _handlerListHead :: boolean (false)
        screenGui :: userdata <ScreenGui>
        selected :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon:?]
                  up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
                  up[2] StarterGui :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        singleClickJanitor :: table [2 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0xaa4a78a5222cb536 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:980 function oneClick\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:542\n")
        startMenuUpdate :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            _next :: boolean (false)
            _signal :: [CICLO]
        stateChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
                up[1] table: 0x972c3e92ce52a519 :: nil (nil)
                up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
                up[3] function: 0x32357d4a06a11945 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
                  up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
                  up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        themesJanitor :: table [2 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0xc2a1b860a6e89515 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Features.Themes:265 function set\nReplicatedStorage.bar.Icon:673 function setTheme\nReplicatedStorage.bar.Icon:269 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:537\n")
        toggleItems :: table [0 claves]
        toggleKeyAdded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
                up[1] UserInputService :: nil (nil)
                up[2] Caption :: nil (nil)
                up[3] table: 0xe174e6d8ceba7991 :: nil (nil)
                up[4] Header :: nil (nil)
                up[5] LabelContent :: nil (nil)
                up[6] Hotkeys :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        toggled :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        totalNotices :: number (0)
        updateMenu :: table [1 claves]
          _handlerListHead :: boolean (false)
        updateSize :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            _next :: boolean (false)
            _signal :: [CICLO]
        viewingEnded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] IconOverlay :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        viewingStarted :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] IconOverlay :: nil (nil)
                up[2] table: 0xe174e6d8ceba7991 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        widget :: userdata <Frame>
      AfeopQg7 :: table [63 claves]
        UID :: string ("AfeopQg7")
        activeState :: string ("Selected")
        alignment :: string ("Left")
        alignmentChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                up[1] MenuUIListLayout :: nil (nil)
                up[2] OverflowLeft :: nil (nil)
                up[3] table: 0x676da3c7e2ca2273 :: nil (nil)
                up[4] IconSpot :: nil (nil)
                up[5] Menu :: nil (nil)
                up[6] MenuGap :: nil (nil)
                up[7] function: 0x22433fd040801cb2 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        alignmentHolder :: userdata <ScrollingFrame>
        appearance :: table [3 claves]
          Deselected :: table [39 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [4 claves]
              1 :: string ("IconOverlay")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.85)
              4 :: string ("Deselected")
            3 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            4 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            5 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundTransparency")
              3 :: number (1)
              4 :: string ("Deselected")
            6 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            7 :: table [4 claves]
              1 :: string ("IconImageRatio")
              2 :: string ("AspectRatio")
              3 :: number (1)
              4 :: string ("Deselected")
            8 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            9 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("DesiredWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            10 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: number (6069276526)
              4 :: string ("Deselected")
              5 :: string ("A)DJN9TH")
            11 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("FontFace")
              3 :: userdata
              4 :: string ("Deselected")
            12 :: table [4 claves]
              1 :: string ("IconImageScale")
              2 :: string ("Value")
              3 :: number (0.5)
              4 :: string ("Deselected")
            13 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("")
              4 :: string ("Deselected")
            14 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            15 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            16 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            17 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            18 :: table [4 claves]
              1 :: string ("IconGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            19 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (-999999900)
              4 :: string ("Deselected")
              5 :: string ("qJzi2+0N")
            20 :: table [4 claves]
              1 :: string ("PaddingRight")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            21 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (-999999900)
              4 :: string ("Deselected")
              5 :: string ("u}b)@=cK")
            22 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            23 :: table [4 claves]
              1 :: string ("PaddingLeft")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            24 :: table [4 claves]
              1 :: string ("ContentsList")
              2 :: string ("HorizontalAlignment")
              3 :: userdata
              4 :: string ("Deselected")
            25 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageColor3")
              3 :: userdata
              4 :: string ("Deselected")
            26 :: table [4 claves]
              1 :: string ("NoticeLabel")
              2 :: string ("TextSize")
              3 :: number (13)
              4 :: string ("Deselected")
            27 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("MaxIcons")
              3 :: number (4.5)
              4 :: string ("Deselected")
            28 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            29 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            30 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("MaxIcons")
              3 :: number (4)
              4 :: string ("Deselected")
            31 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            32 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("Active")
              3 :: boolean (false)
              4 :: string ("Deselected")
            33 :: table [4 claves]
              1 :: string ("ClickRegion")
              2 :: string ("Active")
              3 :: boolean (true)
              4 :: string ("Deselected")
            34 :: table [4 claves]
              1 :: string ("IconImageCorner")
              2 :: string ("CornerRadius")
              3 :: userdata
              4 :: string ("Deselected")
            35 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageTransparency")
              3 :: number (0)
              4 :: string ("Deselected")
            36 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumHeight")
              3 :: number (44)
              4 :: string ("Deselected")
            37 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("TextSize")
              3 :: number (16)
              4 :: string ("Deselected")
            38 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            39 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("BorderSize")
              3 :: number (4)
              4 :: string ("Deselected")
          Selected :: table [42 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [4 claves]
              1 :: string ("IconOverlay")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.85)
              4 :: string ("Deselected")
            3 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            4 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            5 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.7)
              4 :: string ("Selected")
            6 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            7 :: table [4 claves]
              1 :: string ("IconImageRatio")
              2 :: string ("AspectRatio")
              3 :: number (1)
              4 :: string ("Deselected")
            8 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Enabled")
              3 :: boolean (true)
              4 :: string ("Selected")
            9 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("DesiredWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            10 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Selected")
            11 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("")
              4 :: string ("Deselected")
            12 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("FontFace")
              3 :: userdata
              4 :: string ("Deselected")
            13 :: table [4 claves]
              1 :: string ("IconImageScale")
              2 :: string ("Value")
              3 :: number (0.5)
              4 :: string ("Deselected")
            14 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("")
              4 :: string ("Deselected")
            15 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Rotation")
              3 :: number (45)
              4 :: string ("Selected")
            16 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            17 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            18 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            19 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            20 :: table [4 claves]
              1 :: string ("IconGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            21 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (-999999900)
              4 :: string ("Selected")
              5 :: string ("qJzi2+0N")
            22 :: table [4 claves]
              1 :: string ("PaddingRight")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            23 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (-999999900)
              4 :: string ("Selected")
              5 :: string ("u}b)@=cK")
            24 :: table [4 claves]
              1 :: string ("ClickRegion")
              2 :: string ("Active")
              3 :: boolean (true)
              4 :: string ("Deselected")
            25 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            26 :: table [4 claves]
              1 :: string ("PaddingLeft")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            27 :: table [4 claves]
              1 :: string ("ContentsList")
              2 :: string ("HorizontalAlignment")
              3 :: userdata
              4 :: string ("Deselected")
            28 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageColor3")
              3 :: userdata
              4 :: string ("Deselected")
            29 :: table [4 claves]
              1 :: string ("NoticeLabel")
              2 :: string ("TextSize")
              3 :: number (13)
              4 :: string ("Deselected")
            30 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("MaxIcons")
              3 :: number (4.5)
              4 :: string ("Deselected")
            31 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            32 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            33 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("MaxIcons")
              3 :: number (4)
              4 :: string ("Deselected")
            34 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            35 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("Active")
              3 :: boolean (false)
              4 :: string ("Deselected")
            36 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Color")
              3 :: userdata
              4 :: string ("Selected")
            37 :: table [4 claves]
              1 :: string ("IconImageCorner")
              2 :: string ("CornerRadius")
              3 :: userdata
              4 :: string ("Deselected")
            38 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageTransparency")
              3 :: number (0)
              4 :: string ("Deselected")
            39 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumHeight")
              3 :: number (44)
              4 :: string ("Deselected")
            40 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("TextSize")
              3 :: number (16)
              4 :: string ("Deselected")
            41 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            42 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("BorderSize")
              3 :: number (4)
              4 :: string ("Deselected")
          Viewing :: table [7 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            3 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            4 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            5 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            6 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (-999999900)
              4 :: string ("Viewing")
              5 :: string ("qJzi2+0N")
            7 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (-999999900)
              4 :: string ("Viewing")
              5 :: string ("u}b)@=cK")
        appliedTheme :: table [42 claves]
          1 :: table [3 claves]
            1 :: string ("IconCorners")
            2 :: string ("CornerRadius")
            3 :: userdata
          2 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("RotationSpeed")
            3 :: number (1)
          3 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("Size")
            3 :: userdata
          4 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("Position")
            3 :: userdata
          5 :: table [3 claves]
            1 :: string ("SelectionGradient")
            2 :: string ("Color")
            3 :: userdata
          6 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("Image")
            3 :: string ("")
            4 :: string ("Deselected")
          7 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("Text")
            3 :: string ("")
            4 :: string ("Deselected")
          8 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("Position")
            3 :: userdata
            4 :: string ("Deselected")
          9 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("DesiredWidth")
            3 :: number (44)
            4 :: string ("Deselected")
          10 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("MinimumWidth")
            3 :: number (44)
            4 :: string ("Deselected")
          11 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("MinimumHeight")
            3 :: number (44)
            4 :: string ("Deselected")
          12 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("BorderSize")
            3 :: number (4)
            4 :: string ("Deselected")
          13 :: table [4 claves]
            1 :: string ("IconButton")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Deselected")
          14 :: table [4 claves]
            1 :: string ("IconButton")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.08)
            4 :: string ("Deselected")
          15 :: table [4 claves]
            1 :: string ("IconImageScale")
            2 :: string ("Value")
            3 :: number (0.5)
            4 :: string ("Deselected")
          16 :: table [4 claves]
            1 :: string ("IconImageCorner")
            2 :: string ("CornerRadius")
            3 :: userdata
            4 :: string ("Deselected")
          17 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("ImageColor3")
            3 :: userdata
            4 :: string ("Deselected")
          18 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("ImageTransparency")
            3 :: number (0)
            4 :: string ("Deselected")
          19 :: table [4 claves]
            1 :: string ("IconImageRatio")
            2 :: string ("AspectRatio")
            3 :: number (1)
            4 :: string ("Deselected")
          20 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("FontFace")
            3 :: userdata
            4 :: string ("Deselected")
          21 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("TextSize")
            3 :: number (16)
            4 :: string ("Deselected")
          22 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundTransparency")
            3 :: number (1)
            4 :: string ("Deselected")
          23 :: table [4 claves]
            1 :: string ("IconOverlay")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.85)
            4 :: string ("Deselected")
          24 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Enabled")
            3 :: boolean (false)
            4 :: string ("Deselected")
          25 :: table [4 claves]
            1 :: string ("IconGradient")
            2 :: string ("Enabled")
            3 :: boolean (false)
            4 :: string ("Deselected")
          26 :: table [4 claves]
            1 :: string ("ClickRegion")
            2 :: string ("Active")
            3 :: boolean (true)
            4 :: string ("Deselected")
          27 :: table [4 claves]
            1 :: string ("Menu")
            2 :: string ("Active")
            3 :: boolean (false)
            4 :: string ("Deselected")
          28 :: table [4 claves]
            1 :: string ("ContentsList")
            2 :: string ("HorizontalAlignment")
            3 :: userdata
            4 :: string ("Deselected")
          29 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Deselected")
          30 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.08)
            4 :: string ("Deselected")
          31 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("MaxIcons")
            3 :: number (4.5)
            4 :: string ("Deselected")
          32 :: table [4 claves]
            1 :: string ("Menu")
            2 :: string ("MaxIcons")
            3 :: number (4)
            4 :: string ("Deselected")
          33 :: table [4 claves]
            1 :: string ("Notice")
            2 :: string ("Position")
            3 :: userdata
            4 :: string ("Deselected")
          34 :: table [4 claves]
            1 :: string ("Notice")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          35 :: table [4 claves]
            1 :: string ("NoticeLabel")
            2 :: string ("TextSize")
            3 :: number (13)
            4 :: string ("Deselected")
          36 :: table [4 claves]
            1 :: string ("PaddingLeft")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          37 :: table [4 claves]
            1 :: string ("PaddingRight")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          38 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.7)
            4 :: string ("Selected")
          39 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Selected")
          40 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Enabled")
            3 :: boolean (true)
            4 :: string ("Selected")
          41 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Rotation")
            3 :: number (45)
            4 :: string ("Selected")
          42 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Color")
            3 :: userdata
            4 :: string ("Selected")
        bindedEvents :: table [0 claves]
        bindedToggleKeys :: table [0 claves]
        cachedCollectives :: table [6 claves]
          Dropdown :: table [0 claves]
          IconCorners :: table [4 claves]
            1 :: userdata <UICorner>
            2 :: userdata <UICorner>
            3 :: userdata <UICorner>
            4 :: userdata <UICorner>
          Notice :: table [0 claves]
          NoticeLabel :: table [0 claves]
          Selection :: table [0 claves]
          SelectionGradient :: table [0 claves]
        cachedInstances :: table [25 claves]
          ClickRegion :: boolean (true)
          Contents :: boolean (true)
          ContentsList :: boolean (true)
          IconButton :: boolean (true)
          IconGradient :: boolean (true)
          IconImage :: boolean (true)
          IconImageCorner :: boolean (true)
          IconImageRatio :: boolean (true)
          IconImageScale :: boolean (true)
          IconLabel :: boolean (true)
          IconLabelContainer :: boolean (true)
          IconOverlay :: boolean (true)
          IconSpot :: boolean (true)
          IconSpotGradient :: boolean (true)
          Menu :: boolean (true)
          MenuGap :: boolean (true)
          MenuUIListLayout :: boolean (true)
          OverflowLeft :: boolean (true)
          OverlayUICorner :: boolean (true)
          PaddingCenter :: boolean (true)
          PaddingLeft :: boolean (true)
          PaddingRight :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
        cachedNamesToInstances :: table [23 claves]
          ClickRegion :: userdata <TextButton>
          Contents :: userdata <Frame>
          ContentsList :: userdata <UIListLayout>
          IconButton :: userdata <Frame>
          IconGradient :: userdata <UIGradient>
          IconImage :: userdata <ImageLabel>
          IconImageCorner :: userdata <UICorner>
          IconImageRatio :: userdata <UIAspectRatioConstraint>
          IconImageScale :: userdata <NumberValue>
          IconLabel :: userdata <TextLabel>
          IconLabelContainer :: userdata <Frame>
          IconOverlay :: userdata <Frame>
          IconSpot :: userdata <Frame>
          IconSpotGradient :: userdata <UIGradient>
          Menu :: userdata <ScrollingFrame>
          MenuGap :: userdata <Frame>
          MenuUIListLayout :: userdata <UIListLayout>
          OverlayUICorner :: userdata <UICorner>
          PaddingCenter :: userdata <Frame>
          PaddingLeft :: userdata <Frame>
          PaddingRight :: userdata <Frame>
          UICorner :: userdata <UICorner>
          Widget :: userdata <Frame>
        captionJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        childIconsDict :: table [0 claves]
        childThemeModified :: table [1 claves]
          _handlerListHead :: boolean (false)
        creationTime :: number (551.2217979559991)
        customBehaviours :: table [13 claves]
          ContentsList-HorizontalAlignment :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconButton-BackgroundTransparency :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] GuiService :: nil (nil)
          IconImage-Image :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] IconImage :: nil (nil)
              up[2] function: 0x22433fd040801cb2 :: nil (nil)
          IconImageRatio-AspectRatio :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconLabel-FontFace :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] IconLabel :: nil (nil)
              up[2] function: 0x22433fd040801cb2 :: nil (nil)
          IconLabel-Text :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconSpot-Visible :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] OverflowLeft :: nil (nil)
              up[2] table: 0x676da3c7e2ca2273 :: nil (nil)
              up[3] IconSpot :: nil (nil)
              up[4] Menu :: nil (nil)
              up[5] MenuGap :: nil (nil)
              up[6] MenuUIListLayout :: nil (nil)
              up[7] function: 0x22433fd040801cb2 :: nil (nil)
          Indicator-Visible :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-BorderSize :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] OverflowLeft :: nil (nil)
              up[2] table: 0x676da3c7e2ca2273 :: nil (nil)
              up[3] IconSpot :: nil (nil)
              up[4] Menu :: nil (nil)
              up[5] MenuGap :: nil (nil)
              up[6] MenuUIListLayout :: nil (nil)
              up[7] function: 0x22433fd040801cb2 :: nil (nil)
          Widget-DesiredWidth :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-MinimumHeight :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-MinimumWidth :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-Visible :: function [ReplicatedStorage.bar.Icon.Utility:?]
        deselectWhenOtherIconSelected :: boolean (false)
        deselected :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
                up[2] StarterGui :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                  up[1] IconButton :: nil (nil)
                  up[2] table: 0x676da3c7e2ca2273 :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        dropdownChildAdded :: table [1 claves]
          _handlerListHead :: boolean (false)
        dropdownIcons :: table [0 claves]
        dropdownJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        dropdownSet :: table [1 claves]
          _handlerListHead :: boolean (false)
        enabled :: boolean (false)
        endNotices :: table [1 claves]
          _handlerListHead :: boolean (false)
        fakeToggleKeyChanged :: table [1 claves]
          _handlerListHead :: boolean (false)
        iconModule :: userdata <ModuleScript>
        indicatorSet :: table [1 claves]
          _handlerListHead :: boolean (false)
        isAnOverflow :: boolean (true)
        isEnabled :: boolean (false)
        isSelected :: boolean (true)
        isViewing :: boolean (false)
        janitor :: table [38 claves]
          function: 0x1ba4c6d33e5f27ee :: table [2 claves]
            1 :: boolean (true)
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:197 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          CurrentlyCleaning :: boolean (false)
          table: 0x08ac2e6d40be4516 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:214 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x0cb03e95c94c09d9 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:217 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x16b415723ee1129f :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:207 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x18fa2488f9e69302 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:210 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x217e12b83cf6d846 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:190 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x23aa64837c3991c5 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:192 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x303a3d134ae7af2a :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:209 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x42ef66918d88688a :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:222 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x44f2f2e862cc1107 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:378 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x49c7cefc6f3280a6 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:191 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x4ae97f5dd9589a46 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:216 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x4c435762ea938add :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:206 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x50528940cfcbd48c :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:215 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x54c6d26063661807 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:203 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x57b91df53ae4a8b7 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:202 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x5a428ce0e8ed82e9 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:224 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x5f6cba23148e316f :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:187 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x72f50e4c2652df1c :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:188 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x8113884853f3f477 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:212 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0x9db15cdb1375ad88 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:219 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xa79fe0d0fafe51fd :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:204 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xadbc01df1db3c955 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:208 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xc52bac9273afcc21 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:213 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xc7d72e335dc8a1b2 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:211 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xcacd94b7eef48738 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:220 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xd5af85ede2c78654 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:218 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xd6c064c14077c332 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:223 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xe56504005e59eaee :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:205 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xe59ad906c8f5edda :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:221 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xeedf8a0c943237e0 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:189 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          table: 0xf650ffd92499af08 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:225 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Widget:44\nReplicatedStorage.bar.Icon:257 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:309 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Widget:401\nReplicatedStorage.bar.Icon:257 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:349 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
          OverflowLeft :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:257 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
        joinJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        joinedFrame :: boolean (false)
        joinedParent :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        menuChildAdded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
                up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        menuIcons :: table [0 claves]
        menuJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        menuSet :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
                up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        name :: string ("OverflowLeft")
        noticeChanged :: table [1 claves]
          _handlerListHead :: boolean (false)
        noticeStarted :: table [1 claves]
          _handlerListHead :: boolean (false)
        notices :: table [0 claves]
        notified :: table [1 claves]
          _handlerListHead :: boolean (false)
        originalAlignment :: string ("Left")
        parentIconUID :: boolean (false)
        resizingComplete :: table [1 claves]
          _handlerListHead :: boolean (false)
        screenGui :: userdata <ScreenGui>
        selected :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
                up[2] StarterGui :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        singleClickJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        startMenuUpdate :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            _next :: boolean (false)
            _signal :: [CICLO]
        stateChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
                up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
                up[2] table: 0x676da3c7e2ca2273 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        themesJanitor :: table [2 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0x358aaa785edce34e :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Features.Themes:265 function set\nReplicatedStorage.bar.Icon:673 function setTheme\nReplicatedStorage.bar.Icon:269 function new\nReplicatedStorage.bar.Icon.Features.Overflow:195 function updateBoundary\nReplicatedStorage.bar.Icon.Features.Overflow:50\nReplicatedStorage.bar.Icon.Utility:41\n")
        toggleItems :: table [0 claves]
        toggleKeyAdded :: table [1 claves]
          _handlerListHead :: boolean (false)
        toggled :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        totalNotices :: number (0)
        updateMenu :: table [1 claves]
          _handlerListHead :: boolean (false)
        updateSize :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            _next :: boolean (false)
            _signal :: [CICLO]
        viewingEnded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] IconOverlay :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        viewingStarted :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] IconOverlay :: nil (nil)
                up[2] table: 0x676da3c7e2ca2273 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        widget :: userdata <Frame>
      sbZnFtNO :: table [66 claves]
        ResetOnSpawn :: boolean (false)
        UID :: string ("sbZnFtNO")
        activeState :: string ("Deselected")
        alignment :: string ("Left")
        alignmentChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
                up[1] ClickRegion :: nil (nil)
                up[2] TopbarStandardClipped :: nil (nil)
                up[3] table: 0x4f075753b0bba0ec :: nil (nil)
                up[4] Caption :: nil (nil)
                up[5] table: 0xfe6178e3233d03d9 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                  up[1] MenuUIListLayout :: nil (nil)
                  up[2] Widget :: nil (nil)
                  up[3] table: 0x4f81edc7a348b696 :: nil (nil)
                  up[4] IconSpot :: nil (nil)
                  up[5] Menu :: nil (nil)
                  up[6] MenuGap :: nil (nil)
                  up[7] function: 0x4996214e45035d14 :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        alignmentHolder :: userdata <ScrollingFrame>
        appearance :: table [3 claves]
          Deselected :: table [40 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [4 claves]
              1 :: string ("IconOverlay")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.85)
              4 :: string ("Deselected")
            3 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            4 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            5 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundTransparency")
              3 :: number (1)
              4 :: string ("Deselected")
            6 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            7 :: table [4 claves]
              1 :: string ("IconImageRatio")
              2 :: string ("AspectRatio")
              3 :: number (1)
              4 :: string ("Deselected")
            8 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            9 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("DesiredWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            10 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("http://www.roblox.com/asset/?id=6031280882")
              4 :: string ("Deselected")
              5 :: string ("X5jyKGwr")
            11 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("FontFace")
              3 :: userdata
              4 :: string ("Deselected")
            12 :: table [4 claves]
              1 :: string ("IconImageScale")
              2 :: string ("Value")
              3 :: number (0.5)
              4 :: string ("Deselected")
            13 :: table [5 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("options")
              4 :: string ("Deselected")
              5 :: string ("7iV=WrV~")
            14 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            15 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            16 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            17 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            18 :: table [4 claves]
              1 :: string ("IconGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            19 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (101)
              4 :: string ("Deselected")
              5 :: string ("7!d]z{+8")
            20 :: table [4 claves]
              1 :: string ("PaddingRight")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            21 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (101)
              4 :: string ("Deselected")
              5 :: string ("4slJtvUB")
            22 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            23 :: table [4 claves]
              1 :: string ("PaddingLeft")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            24 :: table [4 claves]
              1 :: string ("ContentsList")
              2 :: string ("HorizontalAlignment")
              3 :: userdata
              4 :: string ("Deselected")
            25 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageColor3")
              3 :: userdata
              4 :: string ("Deselected")
            26 :: table [4 claves]
              1 :: string ("NoticeLabel")
              2 :: string ("TextSize")
              3 :: number (13)
              4 :: string ("Deselected")
            27 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("MaxIcons")
              3 :: number (4.5)
              4 :: string ("Deselected")
            28 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            29 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            30 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("MaxIcons")
              3 :: number (4)
              4 :: string ("Deselected")
            31 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            32 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("Active")
              3 :: boolean (false)
              4 :: string ("Deselected")
            33 :: table [4 claves]
              1 :: string ("ClickRegion")
              2 :: string ("Active")
              3 :: boolean (true)
              4 :: string ("Deselected")
            34 :: table [4 claves]
              1 :: string ("IconImageCorner")
              2 :: string ("CornerRadius")
              3 :: userdata
              4 :: string ("Deselected")
            35 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageTransparency")
              3 :: number (0)
              4 :: string ("Deselected")
            36 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumHeight")
              3 :: number (44)
              4 :: string ("Deselected")
            37 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("TextSize")
              3 :: number (16)
              4 :: string ("Deselected")
            38 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            39 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("BorderSize")
              3 :: number (4)
              4 :: string ("Deselected")
            40 :: table [5 claves]
              1 :: string ("Indicator")
              2 :: string ("Visible")
              3 :: boolean (false)
              4 :: string ("Deselected")
              5 :: string (")Gg1GS(e")
          Selected :: table [43 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [4 claves]
              1 :: string ("IconOverlay")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.85)
              4 :: string ("Deselected")
            3 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            4 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            5 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.7)
              4 :: string ("Selected")
            6 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            7 :: table [4 claves]
              1 :: string ("IconImageRatio")
              2 :: string ("AspectRatio")
              3 :: number (1)
              4 :: string ("Deselected")
            8 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Enabled")
              3 :: boolean (true)
              4 :: string ("Selected")
            9 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("DesiredWidth")
              3 :: number (44)
              4 :: string ("Deselected")
            10 :: table [4 claves]
              1 :: string ("IconSpot")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Selected")
            11 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("http://www.roblox.com/asset/?id=6031280882")
              4 :: string ("Selected")
              5 :: string ("X5jyKGwr")
            12 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("FontFace")
              3 :: userdata
              4 :: string ("Deselected")
            13 :: table [4 claves]
              1 :: string ("IconImageScale")
              2 :: string ("Value")
              3 :: number (0.5)
              4 :: string ("Deselected")
            14 :: table [5 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("options")
              4 :: string ("Selected")
              5 :: string ("7iV=WrV~")
            15 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Rotation")
              3 :: number (45)
              4 :: string ("Selected")
            16 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            17 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            18 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundColor3")
              3 :: userdata
              4 :: string ("Deselected")
            19 :: table [4 claves]
              1 :: string ("IconButton")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            20 :: table [4 claves]
              1 :: string ("IconGradient")
              2 :: string ("Enabled")
              3 :: boolean (false)
              4 :: string ("Deselected")
            21 :: table [5 claves]
              1 :: string ("IconSpot")
              2 :: string ("LayoutOrder")
              3 :: number (101)
              4 :: string ("Selected")
              5 :: string ("~+AfMr~A")
            22 :: table [4 claves]
              1 :: string ("PaddingRight")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            23 :: table [5 claves]
              1 :: string ("Widget")
              2 :: string ("LayoutOrder")
              3 :: number (101)
              4 :: string ("Selected")
              5 :: string ("dOSsyiQ1")
            24 :: table [4 claves]
              1 :: string ("ClickRegion")
              2 :: string ("Active")
              3 :: boolean (true)
              4 :: string ("Deselected")
            25 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("BackgroundTransparency")
              3 :: number (0.08)
              4 :: string ("Deselected")
            26 :: table [4 claves]
              1 :: string ("PaddingLeft")
              2 :: string ("Size")
              3 :: userdata
              4 :: string ("Deselected")
            27 :: table [4 claves]
              1 :: string ("ContentsList")
              2 :: string ("HorizontalAlignment")
              3 :: userdata
              4 :: string ("Deselected")
            28 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageColor3")
              3 :: userdata
              4 :: string ("Deselected")
            29 :: table [4 claves]
              1 :: string ("NoticeLabel")
              2 :: string ("TextSize")
              3 :: number (13)
              4 :: string ("Deselected")
            30 :: table [4 claves]
              1 :: string ("Dropdown")
              2 :: string ("MaxIcons")
              3 :: number (4.5)
              4 :: string ("Deselected")
            31 :: table [4 claves]
              1 :: string ("Notice")
              2 :: string ("Position")
              3 :: userdata
              4 :: string ("Deselected")
            32 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            33 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("MaxIcons")
              3 :: number (4)
              4 :: string ("Deselected")
            34 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            35 :: table [4 claves]
              1 :: string ("Menu")
              2 :: string ("Active")
              3 :: boolean (false)
              4 :: string ("Deselected")
            36 :: table [4 claves]
              1 :: string ("IconSpotGradient")
              2 :: string ("Color")
              3 :: userdata
              4 :: string ("Selected")
            37 :: table [4 claves]
              1 :: string ("IconImageCorner")
              2 :: string ("CornerRadius")
              3 :: userdata
              4 :: string ("Deselected")
            38 :: table [4 claves]
              1 :: string ("IconImage")
              2 :: string ("ImageTransparency")
              3 :: number (0)
              4 :: string ("Deselected")
            39 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("MinimumHeight")
              3 :: number (44)
              4 :: string ("Deselected")
            40 :: table [4 claves]
              1 :: string ("IconLabel")
              2 :: string ("TextSize")
              3 :: number (16)
              4 :: string ("Deselected")
            41 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            42 :: table [4 claves]
              1 :: string ("Widget")
              2 :: string ("BorderSize")
              3 :: number (4)
              4 :: string ("Deselected")
            43 :: table [5 claves]
              1 :: string ("Indicator")
              2 :: string ("Visible")
              3 :: boolean (false)
              4 :: string ("Selected")
              5 :: string (")Gg1GS(e")
          Viewing :: table [8 claves]
            1 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("RotationSpeed")
              3 :: number (1)
            2 :: table [5 claves]
              1 :: string ("IconLabel")
              2 :: string ("Text")
              3 :: string ("options")
              4 :: string ("Viewing")
              5 :: string ("7iV=WrV~")
            3 :: table [5 claves]
              1 :: string ("IconImage")
              2 :: string ("Image")
              3 :: string ("http://www.roblox.com/asset/?id=6031280882")
              4 :: string ("Viewing")
              5 :: string ("X5jyKGwr")
            4 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Size")
              3 :: userdata
            5 :: table [3 claves]
              1 :: string ("SelectionGradient")
              2 :: string ("Color")
              3 :: userdata
            6 :: table [3 claves]
              1 :: string ("IconCorners")
              2 :: string ("CornerRadius")
              3 :: userdata
            7 :: table [3 claves]
              1 :: string ("Selection")
              2 :: string ("Position")
              3 :: userdata
            8 :: table [5 claves]
              1 :: string ("Indicator")
              2 :: string ("Visible")
              3 :: boolean (false)
              4 :: string ("Viewing")
              5 :: string (")Gg1GS(e")
        appliedTheme :: table [42 claves]
          1 :: table [3 claves]
            1 :: string ("IconCorners")
            2 :: string ("CornerRadius")
            3 :: userdata
          2 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("RotationSpeed")
            3 :: number (1)
          3 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("Size")
            3 :: userdata
          4 :: table [3 claves]
            1 :: string ("Selection")
            2 :: string ("Position")
            3 :: userdata
          5 :: table [3 claves]
            1 :: string ("SelectionGradient")
            2 :: string ("Color")
            3 :: userdata
          6 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("Image")
            3 :: string ("")
            4 :: string ("Deselected")
          7 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("Text")
            3 :: string ("")
            4 :: string ("Deselected")
          8 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("Position")
            3 :: userdata
            4 :: string ("Deselected")
          9 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("DesiredWidth")
            3 :: number (44)
            4 :: string ("Deselected")
          10 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("MinimumWidth")
            3 :: number (44)
            4 :: string ("Deselected")
          11 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("MinimumHeight")
            3 :: number (44)
            4 :: string ("Deselected")
          12 :: table [4 claves]
            1 :: string ("Widget")
            2 :: string ("BorderSize")
            3 :: number (4)
            4 :: string ("Deselected")
          13 :: table [4 claves]
            1 :: string ("IconButton")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Deselected")
          14 :: table [4 claves]
            1 :: string ("IconButton")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.08)
            4 :: string ("Deselected")
          15 :: table [4 claves]
            1 :: string ("IconImageScale")
            2 :: string ("Value")
            3 :: number (0.5)
            4 :: string ("Deselected")
          16 :: table [4 claves]
            1 :: string ("IconImageCorner")
            2 :: string ("CornerRadius")
            3 :: userdata
            4 :: string ("Deselected")
          17 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("ImageColor3")
            3 :: userdata
            4 :: string ("Deselected")
          18 :: table [4 claves]
            1 :: string ("IconImage")
            2 :: string ("ImageTransparency")
            3 :: number (0)
            4 :: string ("Deselected")
          19 :: table [4 claves]
            1 :: string ("IconImageRatio")
            2 :: string ("AspectRatio")
            3 :: number (1)
            4 :: string ("Deselected")
          20 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("FontFace")
            3 :: userdata
            4 :: string ("Deselected")
          21 :: table [4 claves]
            1 :: string ("IconLabel")
            2 :: string ("TextSize")
            3 :: number (16)
            4 :: string ("Deselected")
          22 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundTransparency")
            3 :: number (1)
            4 :: string ("Deselected")
          23 :: table [4 claves]
            1 :: string ("IconOverlay")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.85)
            4 :: string ("Deselected")
          24 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Enabled")
            3 :: boolean (false)
            4 :: string ("Deselected")
          25 :: table [4 claves]
            1 :: string ("IconGradient")
            2 :: string ("Enabled")
            3 :: boolean (false)
            4 :: string ("Deselected")
          26 :: table [4 claves]
            1 :: string ("ClickRegion")
            2 :: string ("Active")
            3 :: boolean (true)
            4 :: string ("Deselected")
          27 :: table [4 claves]
            1 :: string ("Menu")
            2 :: string ("Active")
            3 :: boolean (false)
            4 :: string ("Deselected")
          28 :: table [4 claves]
            1 :: string ("ContentsList")
            2 :: string ("HorizontalAlignment")
            3 :: userdata
            4 :: string ("Deselected")
          29 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Deselected")
          30 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.08)
            4 :: string ("Deselected")
          31 :: table [4 claves]
            1 :: string ("Dropdown")
            2 :: string ("MaxIcons")
            3 :: number (4.5)
            4 :: string ("Deselected")
          32 :: table [4 claves]
            1 :: string ("Menu")
            2 :: string ("MaxIcons")
            3 :: number (4)
            4 :: string ("Deselected")
          33 :: table [4 claves]
            1 :: string ("Notice")
            2 :: string ("Position")
            3 :: userdata
            4 :: string ("Deselected")
          34 :: table [4 claves]
            1 :: string ("Notice")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          35 :: table [4 claves]
            1 :: string ("NoticeLabel")
            2 :: string ("TextSize")
            3 :: number (13)
            4 :: string ("Deselected")
          36 :: table [4 claves]
            1 :: string ("PaddingLeft")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          37 :: table [4 claves]
            1 :: string ("PaddingRight")
            2 :: string ("Size")
            3 :: userdata
            4 :: string ("Deselected")
          38 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundTransparency")
            3 :: number (0.7)
            4 :: string ("Selected")
          39 :: table [4 claves]
            1 :: string ("IconSpot")
            2 :: string ("BackgroundColor3")
            3 :: userdata
            4 :: string ("Selected")
          40 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Enabled")
            3 :: boolean (true)
            4 :: string ("Selected")
          41 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Rotation")
            3 :: number (45)
            4 :: string ("Selected")
          42 :: table [4 claves]
            1 :: string ("IconSpotGradient")
            2 :: string ("Color")
            3 :: userdata
            4 :: string ("Selected")
        bindedEvents :: table [1 claves]
          deselected :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] function: 0x0e190355d8cbc1e0 :: nil (nil)
                up[2] table: 0x4f81edc7a348b696 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon:?]
                  up[1] table: 0x4f81edc7a348b696 :: nil (nil)
                  up[2] StarterGui :: nil (nil)
              _next :: table [4 claves]
                _connected :: boolean (true)
                _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                    up[1] IconButton :: nil (nil)
                    up[2] table: 0x4f81edc7a348b696 :: nil (nil)
                _next :: boolean (false)
                _signal :: table [1 claves]
                  _handlerListHead :: [CICLO]
              _signal :: table [1 claves]
                _handlerListHead :: [CICLO]
            _signal :: table [1 claves]
              _handlerListHead :: [CICLO]
        bindedToggleKeys :: table [0 claves]
        cachedCollectives :: table [6 claves]
          Dropdown :: table [0 claves]
          IconCorners :: table [4 claves]
            1 :: userdata <UICorner>
            2 :: userdata <UICorner>
            3 :: userdata <UICorner>
            4 :: userdata <UICorner>
          Notice :: table [0 claves]
          NoticeLabel :: table [0 claves]
          Selection :: table [0 claves]
          SelectionGradient :: table [0 claves]
        cachedInstances :: table [43 claves]
          Box :: boolean (true)
          Caption :: boolean (true)
          CaptionCorner :: boolean (true)
          Caret :: boolean (true)
          ClickRegion :: boolean (true)
          ClippedClone :: boolean (true)
          Contents :: boolean (true)
          ContentsList :: boolean (true)
          DropShadow :: boolean (true)
          Header :: boolean (true)
          Hotkeys :: boolean (true)
          IconButton :: boolean (true)
          IconGradient :: boolean (true)
          IconImage :: boolean (true)
          IconImageCorner :: boolean (true)
          IconImageRatio :: boolean (true)
          IconImageScale :: boolean (true)
          IconLabel :: boolean (true)
          IconLabelContainer :: boolean (true)
          IconOverlay :: boolean (true)
          IconSpot :: boolean (true)
          IconSpotGradient :: boolean (true)
          ImageLabel :: boolean (true)
          Indicator :: boolean (true)
          IndicatorButton :: boolean (true)
          Inset :: boolean (true)
          Key1 :: boolean (true)
          LabelContent :: boolean (true)
          Layout :: boolean (true)
          Layout1 :: boolean (true)
          Menu :: boolean (true)
          MenuGap :: boolean (true)
          MenuUIListLayout :: boolean (true)
          OverlayUICorner :: boolean (true)
          Padding :: boolean (true)
          PaddingCenter :: boolean (true)
          PaddingLeft :: boolean (true)
          PaddingRight :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
          UICorner :: boolean (true)
          Widget :: boolean (true)
        cachedNamesToInstances :: table [40 claves]
          Box :: userdata <Frame>
          Caption :: userdata <CanvasGroup>
          CaptionCorner :: userdata <UICorner>
          Caret :: userdata <ImageLabel>
          ClickRegion :: userdata <TextButton>
          ClippedClone :: userdata <ObjectValue>
          Contents :: userdata <Frame>
          ContentsList :: userdata <UIListLayout>
          DropShadow :: userdata <ImageLabel>
          Header :: userdata <TextLabel>
          Hotkeys :: userdata <Frame>
          IconButton :: userdata <Frame>
          IconGradient :: userdata <UIGradient>
          IconImage :: userdata <ImageLabel>
          IconImageCorner :: userdata <UICorner>
          IconImageRatio :: userdata <UIAspectRatioConstraint>
          IconImageScale :: userdata <NumberValue>
          IconLabel :: userdata <TextLabel>
          IconLabelContainer :: userdata <Frame>
          IconOverlay :: userdata <Frame>
          IconSpot :: userdata <Frame>
          IconSpotGradient :: userdata <UIGradient>
          ImageLabel :: userdata <ImageLabel>
          Indicator :: userdata <Frame>
          IndicatorButton :: userdata <Frame>
          Inset :: userdata <UIPadding>
          Key1 :: userdata <ImageLabel>
          LabelContent :: userdata <TextLabel>
          Layout :: userdata <UIListLayout>
          Layout1 :: userdata <UIListLayout>
          Menu :: userdata <ScrollingFrame>
          MenuGap :: userdata <Frame>
          MenuUIListLayout :: userdata <UIListLayout>
          OverlayUICorner :: userdata <UICorner>
          Padding :: userdata <UIPadding>
          PaddingCenter :: userdata <Frame>
          PaddingLeft :: userdata <Frame>
          PaddingRight :: userdata <Frame>
          UICorner :: userdata <UICorner>
          Widget :: userdata <Frame>
        caption :: userdata <CanvasGroup>
        captionJanitor :: table [7 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0xa637e10ffd1395bb :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:263\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          table: 0xe44da75652bec03c :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:299\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          table: 0xf1515bd74730fe54 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:268\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          Caption :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:258\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Caption:159\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
        captionText :: string ("options")
        childIconsDict :: table [0 claves]
        childThemeModified :: table [1 claves]
          _handlerListHead :: boolean (false)
        creationTime :: number (550.3227064940002)
        customBehaviours :: table [13 claves]
          ContentsList-HorizontalAlignment :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconButton-BackgroundTransparency :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] GuiService :: nil (nil)
          IconImage-Image :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] IconImage :: nil (nil)
              up[2] function: 0x4996214e45035d14 :: nil (nil)
          IconImageRatio-AspectRatio :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconLabel-FontFace :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] IconLabel :: nil (nil)
              up[2] function: 0x4996214e45035d14 :: nil (nil)
          IconLabel-Text :: function [ReplicatedStorage.bar.Icon.Utility:?]
          IconSpot-Visible :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] Widget :: nil (nil)
              up[2] table: 0x4f81edc7a348b696 :: nil (nil)
              up[3] IconSpot :: nil (nil)
              up[4] Menu :: nil (nil)
              up[5] MenuGap :: nil (nil)
              up[6] MenuUIListLayout :: nil (nil)
              up[7] function: 0x4996214e45035d14 :: nil (nil)
          Indicator-Visible :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-BorderSize :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
              up[1] Widget :: nil (nil)
              up[2] table: 0x4f81edc7a348b696 :: nil (nil)
              up[3] IconSpot :: nil (nil)
              up[4] Menu :: nil (nil)
              up[5] MenuGap :: nil (nil)
              up[6] MenuUIListLayout :: nil (nil)
              up[7] function: 0x4996214e45035d14 :: nil (nil)
          Widget-DesiredWidth :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-MinimumHeight :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-MinimumWidth :: function [ReplicatedStorage.bar.Icon.Utility:?]
          Widget-Visible :: function [ReplicatedStorage.bar.Icon.Utility:?]
        deselectWhenOtherIconSelected :: boolean (true)
        deselected :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] function: 0x0e190355d8cbc1e0 :: nil (nil)
                up[2] table: 0x4f81edc7a348b696 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon:?]
                  up[1] table: 0x4f81edc7a348b696 :: nil (nil)
                  up[2] StarterGui :: nil (nil)
              _next :: table [4 claves]
                _connected :: boolean (true)
                _fn :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
                    up[1] IconButton :: nil (nil)
                    up[2] table: 0x4f81edc7a348b696 :: nil (nil)
                _next :: boolean (false)
                _signal :: [CICLO]
              _signal :: [CICLO]
            _signal :: [CICLO]
        dropdownChildAdded :: table [1 claves]
          _handlerListHead :: boolean (false)
        dropdownIcons :: table [0 claves]
        dropdownJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        dropdownSet :: table [1 claves]
          _handlerListHead :: boolean (false)
        enabled :: boolean (true)
        endNotices :: table [1 claves]
          _handlerListHead :: boolean (false)
        fakeToggleKeyChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
                up[1] UserInputService :: nil (nil)
                up[2] Caption :: nil (nil)
                up[3] table: 0x4f81edc7a348b696 :: nil (nil)
                up[4] Header :: nil (nil)
                up[5] LabelContent :: nil (nil)
                up[6] Hotkeys :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        iconModule :: userdata <ModuleScript>
        indicator :: userdata <Frame>
        indicatorSet :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Indicator:?]
                up[1] ImageLabel :: nil (nil)
                up[2] UserInputService :: nil (nil)
                up[3] function: 0x26fb114a35a630e5 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        isEnabled :: boolean (true)
        isSelected :: boolean (false)
        isViewing :: boolean (false)
        janitor :: table [43 claves]
          function: 0x4278ea992e421898 :: table [2 claves]
            1 :: boolean (true)
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:197 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          CurrentlyCleaning :: boolean (false)
          table: 0x187e0fd7549d99b0 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:211 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x1ee581eecdd93530 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:219 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x227f65ebae71fe31 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:221 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x248bd21f0d452434 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:216 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x28f7cd9f907bfac2 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:222 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x34b85c35b508408f :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:188 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x3f1b99a743dad3ed :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:213 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x5601dd9120af1aa6 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:189 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x601509ebe3d748b3 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:209 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x6c7b04575762ead6 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:210 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x7a15385490735805 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:208 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x8173907e2d732e7d :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:378 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x86b7093b5b9d3130 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:212 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x8b62bdb30ab19ed7 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:192 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0x9365ef95c16cbc70 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:220 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xa54c550c9d20c93f :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:217 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xa7d4145c8c145746 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:205 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xa8c7c9c651841010 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:218 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xab79ea78606d97bb :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:207 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xac28509e48439c3e :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:224 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xad6f8136d4ef30cd :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:223 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xb0a226c7a51254d9 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:203 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xb140dcc1ff471540 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:187 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xb221d652658ed4a0 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Utility:152 function clipOutside\nReplicatedStorage.bar.Icon:1076 function clipOutside\nReplicatedStorage.bar.Icon.Elements.Caption:153\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          table: 0xb631754963311214 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:214 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xb716d41a7e670f68 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:202 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xc8ee601c5db066ca :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:215 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xcbf79b525bc5ef1a :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:206 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xcd3c782aa2dd0bec :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:225 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xdbbe7427ff80705d :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:190 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xede430b42e36c692 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:191 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          table: 0xfae1737856f905df :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:204 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          Caption :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Utility:156 function clipOutside\nReplicatedStorage.bar.Icon:1076 function clipOutside\nReplicatedStorage.bar.Icon.Elements.Caption:153\nReplicatedStorage.bar.Icon:999 function setCaption\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:513\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Indicator:40\nReplicatedStorage.bar.Icon:1087 function setIndicator\nReplicatedStorage.bar.Icon.Features.Gamepad:86 function updateSelectedObject\nReplicatedStorage.bar.Icon.Features.Gamepad:101\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Widget:44\nReplicatedStorage.bar.Icon:257 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Widget:401\nReplicatedStorage.bar.Icon:257 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Elements.Indicator:73\nReplicatedStorage.bar.Icon:1087 function setIndicator\nReplicatedStorage.bar.Icon.Features.Gamepad:86 function updateSelectedObject\nReplicatedStorage.bar.Icon.Features.Gamepad:101\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:349 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          Connection :: table [2 claves]
            1 :: string ("Disconnect")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:309 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
          Indicator :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:1087 function setIndicator\nReplicatedStorage.bar.Icon.Features.Gamepad:86 function updateSelectedObject\nReplicatedStorage.bar.Icon.Features.Gamepad:101\n")
          Widget :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:257 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
        joinJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        joinedFrame :: boolean (false)
        joinedParent :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x4f81edc7a348b696 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        menuChildAdded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
                up[1] table: 0x4f81edc7a348b696 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        menuIcons :: table [0 claves]
        menuJanitor :: table [1 claves]
          CurrentlyCleaning :: boolean (false)
        menuSet :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
                up[1] table: 0x4f81edc7a348b696 :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        noticeChanged :: table [1 claves]
          _handlerListHead :: boolean (false)
        noticeStarted :: table [1 claves]
          _handlerListHead :: boolean (false)
        notices :: table [0 claves]
        notified :: table [1 claves]
          _handlerListHead :: boolean (false)
        oneClickEnabled :: boolean (true)
        originalAlignment :: string ("Left")
        parentIconUID :: boolean (false)
        resizingComplete :: table [1 claves]
          _handlerListHead :: boolean (false)
        screenGui :: userdata <ScreenGui>
        selected :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x4f81edc7a348b696 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon:?]
                  up[1] table: 0x4f81edc7a348b696 :: nil (nil)
                  up[2] StarterGui :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        singleClickJanitor :: table [2 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0x94e661e2d111fb55 :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon:980 function oneClick\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:512\n")
        startMenuUpdate :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            _next :: boolean (false)
            _signal :: [CICLO]
        stateChanged :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
                up[1] table: 0x972c3e92ce52a519 :: nil (nil)
                up[2] table: 0x4f81edc7a348b696 :: nil (nil)
                up[3] function: 0x17aca112431f0103 :: nil (nil)
            _next :: table [4 claves]
              _connected :: boolean (true)
              _fn :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
                  up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
                  up[2] table: 0x4f81edc7a348b696 :: nil (nil)
              _next :: boolean (false)
              _signal :: [CICLO]
            _signal :: [CICLO]
        themesJanitor :: table [2 claves]
          CurrentlyCleaning :: boolean (false)
          table: 0xc1b9acc4e1e12e5d :: table [2 claves]
            1 :: string ("Destroy")
            2 :: string ("\nReplicatedStorage.bar.Icon.Packages.Janitor:95 function Add\nReplicatedStorage.bar.Icon.Features.Themes:265 function set\nReplicatedStorage.bar.Icon:673 function setTheme\nReplicatedStorage.bar.Icon:269 function new\nPlayers.roblox1234dieg.PlayerGui.MainGui.LocalScript:506\n")
        toggleItems :: table [0 claves]
        toggleKeyAdded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
                up[1] UserInputService :: nil (nil)
                up[2] Caption :: nil (nil)
                up[3] table: 0x4f81edc7a348b696 :: nil (nil)
                up[4] Header :: nil (nil)
                up[5] LabelContent :: nil (nil)
                up[6] Hotkeys :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        toggled :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] table: 0x4f81edc7a348b696 :: nil (nil)
                up[2] table: 0x972c3e92ce52a519 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        totalNotices :: number (0)
        updateMenu :: table [1 claves]
          _handlerListHead :: boolean (false)
        updateSize :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon.Utility:?]
            _next :: boolean (false)
            _signal :: [CICLO]
        viewingEnded :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] IconOverlay :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        viewingStarted :: table [1 claves]
          _handlerListHead :: table [4 claves]
            _connected :: boolean (true)
            _fn :: function [ReplicatedStorage.bar.Icon:?]
                up[1] IconOverlay :: nil (nil)
                up[2] table: 0x4f81edc7a348b696 :: nil (nil)
            _next :: boolean (false)
            _signal :: [CICLO]
        widget :: userdata <Frame>
    insetHeightChanged :: table [1 claves]
      _handlerListHead :: boolean (false)
    isOldTopbar :: boolean (false)
    joinDropdown :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0xfe6178e3233d03d9 :: nil (nil)
    joinMenu :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0xfe6178e3233d03d9 :: nil (nil)
    leave :: function [ReplicatedStorage.bar.Icon:?]
    lock :: function [ReplicatedStorage.bar.Icon:?]
    modifyBaseTheme :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
        up[2] table: 0x972c3e92ce52a519 :: nil (nil)
        up[3] table: 0xe27087d7e27658d5 :: nil (nil)
    modifyChildTheme :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    modifyTheme :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    new :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
        up[2] table: 0xba48cbcf43f5e1b7 :: nil (nil)
        up[3] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[4] table: 0xe27087d7e27658d5 :: nil (nil)
        up[5] table: 0xc9ec33e052cbbe41 :: nil (nil)
        up[6] Icon :: nil (nil)
        up[7] Elements :: nil (nil)
        up[8] 3 :: nil (nil)
        up[9] UserInputService :: nil (nil)
        up[10] table: 0x2f8010ca713e8d8e :: nil (nil)
        up[11] table: 0x6ff5f1191905e791 :: nil (nil)
        up[12] StarterGui :: nil (nil)
    notify :: function [ReplicatedStorage.bar.Icon:?]
        up[1] Elements :: nil (nil)
        up[2] table: 0x972c3e92ce52a519 :: nil (nil)
    oneClick :: function [ReplicatedStorage.bar.Icon:?]
    refresh :: function [ReplicatedStorage.bar.Icon:?]
    refreshAppearance :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    removeModification :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    removeModificationWith :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    select :: function [ReplicatedStorage.bar.Icon:?]
    setAlignment :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    setBehaviour :: function [ReplicatedStorage.bar.Icon:?]
    setCaption :: function [ReplicatedStorage.bar.Icon:?]
        up[1] Elements :: nil (nil)
    setCaptionHint :: function [ReplicatedStorage.bar.Icon:?]
    setCornerRadius :: function [ReplicatedStorage.bar.Icon:?]
    setDisplayOrder :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    setDropdown :: function [ReplicatedStorage.bar.Icon:?]
    setEnabled :: function [ReplicatedStorage.bar.Icon:?]
    setFixedMenu :: function [ReplicatedStorage.bar.Icon:?]
    setFrozenMenu :: function [ReplicatedStorage.bar.Icon:?]
    setImage :: function [ReplicatedStorage.bar.Icon:?]
        up[1] ContentProvider :: nil (nil)
    setImageRatio :: function [ReplicatedStorage.bar.Icon:?]
    setImageScale :: function [ReplicatedStorage.bar.Icon:?]
    setIndicator :: function [ReplicatedStorage.bar.Icon:?]
        up[1] Elements :: nil (nil)
        up[2] table: 0x972c3e92ce52a519 :: nil (nil)
    setLabel :: function [ReplicatedStorage.bar.Icon:?]
    setLeft :: function [ReplicatedStorage.bar.Icon:?]
    setMenu :: function [ReplicatedStorage.bar.Icon:?]
    setMid :: function [ReplicatedStorage.bar.Icon:?]
    setName :: function [ReplicatedStorage.bar.Icon:?]
    setOrder :: function [ReplicatedStorage.bar.Icon:?]
    setRight :: function [ReplicatedStorage.bar.Icon:?]
    setState :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[2] table: 0x6ff5f1191905e791 :: nil (nil)
    setTextColor :: function [ReplicatedStorage.bar.Icon:?]
    setTextFont :: function [ReplicatedStorage.bar.Icon:?]
    setTextSize :: function [ReplicatedStorage.bar.Icon:?]
    setTheme :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    setTopbarEnabled :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    setWidth :: function [ReplicatedStorage.bar.Icon:?]
    topbarEnabled :: boolean (true)
    unbindEvent :: function [ReplicatedStorage.bar.Icon:?]
    unbindToggleItem :: function [ReplicatedStorage.bar.Icon:?]
    unbindToggleKey :: function [ReplicatedStorage.bar.Icon:?]
    unlock :: function [ReplicatedStorage.bar.Icon:?]
    updateParent :: function [ReplicatedStorage.bar.Icon:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
  93 :: thread
  94 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x3e04eff914b9716b :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0xb9c89be0b833ce70 :: nil (nil)
  95 :: thread
  96 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x1785a1fb4c35598e :: nil (nil)
      up[2] table: 0x1e87bd19ecd62dad :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  97 :: thread
  98 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x6bc14ba5dcfe7c9b :: nil (nil)
      up[2] function: 0x299714a18039ef7a :: nil (nil)
  99 :: thread
  100 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x6bc14ba5dcfe7c9b :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] DisfigureOfficial :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0xafbcd3b8f1e367d2 :: nil (nil)
      up[6] DisfigureOfficial :: nil (nil)
      up[7] function: 0x299714a18039ef7a :: nil (nil)
  101 :: thread
  102 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  103 :: thread
  104 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  105 :: thread
  106 :: thread
  107 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x3126788b3e19bd7f :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x3ed70d2e03112f90 :: nil (nil)
  108 :: thread
  109 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x845da74e43a0b700 :: nil (nil)
      up[2] table: 0xce8abb2077d9df73 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  110 :: thread
  111 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x69004028a4b132b5 :: nil (nil)
      up[2] function: 0x225c592187cf7a4e :: nil (nil)
  112 :: thread
  113 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x69004028a4b132b5 :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] lpx8729 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x5f716c5ba0879996 :: nil (nil)
      up[6] lpx8729 :: nil (nil)
      up[7] function: 0x225c592187cf7a4e :: nil (nil)
  114 :: thread
  115 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  116 :: thread
  117 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  118 :: thread
  119 :: thread
  120 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x15a9848c8008c567 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0xf165ea67add95135 :: nil (nil)
  121 :: thread
  122 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x0489e537e37c6d8b :: nil (nil)
      up[2] table: 0x2ad8a0bb882bdd24 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  123 :: thread
  124 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x2d2bbf367f341bfa :: nil (nil)
      up[2] function: 0x5fbc05984baeb107 :: nil (nil)
  125 :: thread
  126 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x2d2bbf367f341bfa :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] BTC_651 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x43f3f55f1fa1f3ed :: nil (nil)
      up[6] BTC_651 :: nil (nil)
      up[7] function: 0x5fbc05984baeb107 :: nil (nil)
  127 :: thread
  128 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  129 :: thread
  130 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  131 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IndicatorButton :: nil (nil)
      up[3] IndicatorButton :: nil (nil)
  132 :: thread
  133 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x987624cc0c9ef54a :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0xc870faccd13855ee :: nil (nil)
  134 :: thread
  135 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xa18fd7b1d166f623 :: nil (nil)
      up[2] table: 0x2f47ea53b3917244 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  136 :: thread
  137 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x81d8a448894d232b :: nil (nil)
      up[2] function: 0xc056d6b930589cc2 :: nil (nil)
  138 :: thread
  139 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x81d8a448894d232b :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] lIllIllIIllIllIlIII :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x2c09ecfc117e0084 :: nil (nil)
      up[6] lIllIllIIllIllIlIII :: nil (nil)
      up[7] function: 0xc056d6b930589cc2 :: nil (nil)
  140 :: thread
  141 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  142 :: thread
  143 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  144 :: thread
  145 :: thread
  146 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x29ebe872deb74666 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x625e1070592ec0cb :: nil (nil)
  147 :: thread
  148 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x09d97241020f5d45 :: nil (nil)
      up[2] table: 0x3acf0712ba07c386 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  149 :: thread
  150 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x860d200414ae93d1 :: nil (nil)
      up[2] function: 0x1c93079b6e206420 :: nil (nil)
  151 :: thread
  152 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x860d200414ae93d1 :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] apriliscute35 :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x7aa9b7fc7d34a789 :: nil (nil)
      up[6] apriliscute35 :: nil (nil)
      up[7] function: 0x1c93079b6e206420 :: nil (nil)
  153 :: thread
  154 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  155 :: thread
  156 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  157 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  158 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] PaddingCenter :: nil (nil)
      up[3] PaddingCenter :: nil (nil)
  159 :: thread
  160 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] PaddingLeft :: nil (nil)
      up[3] PaddingLeft :: nil (nil)
  161 :: thread
  162 :: thread
  163 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  164 :: thread
  165 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  166 :: thread
  167 :: thread
  168 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x38509ce087b89b28 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0xd4093caec41c9fa0 :: nil (nil)
  169 :: thread
  170 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xbde160288dd8f318 :: nil (nil)
      up[2] table: 0x7f735347ad12a24c :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  171 :: thread
  172 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x19cda98989c895cd :: nil (nil)
      up[2] function: 0x8a938ebb13fd7a6e :: nil (nil)
  173 :: thread
  174 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0x19cda98989c895cd :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] Ffggfiffkfj :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x6714d24ef91f36d4 :: nil (nil)
      up[6] Ffggfiffkfj :: nil (nil)
      up[7] function: 0x8a938ebb13fd7a6e :: nil (nil)
  175 :: thread
  176 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  177 :: thread
  178 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x2dd28ea342c8df92 :: nil (nil)
  179 :: thread
  180 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x5d86a6936084540e :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] function: 0xb19875be2ef8a502 :: nil (nil)
      up[4] function: 0x7cf277c031b8c17f :: nil (nil)
  181 :: thread
  182 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x5d86a6936084540e :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
  183 :: thread
  184 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  185 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  186 :: table [6 claves]
    __index :: [CICLO]
    disconnect :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
    disconnectAll :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
        up[1] table: 0xfa3845683a5992bf :: nil (nil)
    trackBoundFunction :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
    trackConnection :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
  187 :: thread
  188 :: table [1 claves]
    getUserFlag :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.FlagUtil:?]
  189 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  190 :: table [18 claves]
    ConvertCameraModeEnumToStandard :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    GamepadLinearToCurve :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    GetAngleBetweenXZVectors :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    IsFinite :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    IsFiniteVector3 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
    RotateVectorByAngleAndRound :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    Round :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    Spring :: table [3 claves]
      __index :: [CICLO]
      new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
          up[1] table: 0x3438bb1670ed706b :: nil (nil)
      step :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    getLooseBoundingSphere :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    map :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    mapClamp :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    restoreMouseBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] UserInputService :: nil (nil)
        up[2] Enum.MouseBehavior.LockCurrentPosition :: nil (nil)
        up[3] Enum.MouseBehavior.Default :: nil (nil)
    restoreMouseIcon :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] Players :: nil (nil)
    restoreRotationType :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] GameSettings :: nil (nil)
    sanitizeAngle :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
    setMouseBehaviorOverride :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] UserInputService :: nil (nil)
        up[2] Enum.MouseBehavior.LockCurrentPosition :: nil (nil)
        up[3] Enum.MouseBehavior.Default :: nil (nil)
    setMouseIconOverride :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] Players :: nil (nil)
    setRotationTypeOverride :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUtils:?]
        up[1] GameSettings :: nil (nil)
  191 :: thread
  192 :: thread
  193 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] Event :: nil (nil)
  194 :: thread
  195 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] Event :: nil (nil)
  196 :: thread
  197 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0xeb12f4d686b402de :: nil (nil)
      up[2] table: 0xc9d2fba664a21203 :: nil (nil)
      up[3] table: 0x0153d63bcd9571dd :: nil (nil)
      up[4] table: 0xc61fa59528c55272 :: nil (nil)
      up[5] 1 :: nil (nil)
  198 :: thread
  199 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0xeb12f4d686b402de :: nil (nil)
      up[2] table: 0xc9d2fba664a21203 :: nil (nil)
      up[3] table: 0x0153d63bcd9571dd :: nil (nil)
      up[4] table: 0xc61fa59528c55272 :: nil (nil)
      up[5] 1 :: nil (nil)
  200 :: thread
  201 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0xeb12f4d686b402de :: nil (nil)
      up[2] table: 0xc9d2fba664a21203 :: nil (nil)
      up[3] table: 0x0153d63bcd9571dd :: nil (nil)
      up[4] table: 0xc61fa59528c55272 :: nil (nil)
      up[5] 1 :: nil (nil)
  202 :: table [14 claves]
    disableCameraToggleInput :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
    enableCameraToggleInput :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
    gamepadReset :: userdata
    gamepadZoomPress :: userdata
    getHoldPan :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
    getInputEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
        up[1] true :: nil (nil)
    getPanning :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
    getRotation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
        up[1] GameSettings :: nil (nil)
        up[2] table: 0xc9d2fba664a21203 :: nil (nil)
        up[3] true :: nil (nil)
        up[4] table: 0xeb12f4d686b402de :: nil (nil)
        up[5] table: 0x0153d63bcd9571dd :: nil (nil)
        up[6] function: 0x06ea61e03fd00a3e :: nil (nil)
        up[7] table: 0xc61fa59528c55272 :: nil (nil)
        up[8] 4.18879032, 3.2253685 :: nil (nil)
        up[9] 0.00872664619, 0.00671951752 :: nil (nil)
        up[10] 0.122173049, 0.0940732434 :: nil (nil)
        up[11] 0.0174532924, 0.0115191732 :: nil (nil)
    getRotationActivated :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
        up[1] true :: nil (nil)
        up[2] 1 :: nil (nil)
        up[3] table: 0xeb12f4d686b402de :: nil (nil)
    getTogglePan :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
    getZoomDelta :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
        up[1] table: 0xc9d2fba664a21203 :: nil (nil)
        up[2] table: 0x0153d63bcd9571dd :: nil (nil)
        up[3] table: 0xc61fa59528c55272 :: nil (nil)
    resetInputForFrameEnd :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
        up[1] table: 0x0153d63bcd9571dd :: nil (nil)
        up[2] table: 0xc61fa59528c55272 :: nil (nil)
    setInputEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
        up[1] true :: nil (nil)
        up[2] function: 0xbf1a6d761d1cc0de :: nil (nil)
        up[3] function: 0x21b0bcfdf0389ce8 :: nil (nil)
        up[4] ContextActionService :: nil (nil)
        up[5] function: 0x8c0472c90c626367 :: nil (nil)
        up[6] 2000 :: nil (nil)
        up[7] true :: nil (nil)
        up[8] function: 0xafcd717c1a30be48 :: nil (nil)
        up[9] function: 0xe8d9ef463ab3a335 :: nil (nil)
        up[10] VRService :: nil (nil)
        up[11] function: 0x710ad957402eda96 :: nil (nil)
        up[12] function: 0x777b3c0bdc95b8c4 :: nil (nil)
        up[13] table: 0xa1c9fc5e83d5a727 :: nil (nil)
        up[14] UserInputService :: nil (nil)
        up[15] function: 0xe6c313525d24412c :: nil (nil)
        up[16] function: 0xb2767a8e8759a1b3 :: nil (nil)
        up[17] function: 0xdcdfbca5a0a33e1a :: nil (nil)
        up[18] function: 0x2f245ce4a494f21c :: nil (nil)
        up[19] GuiService :: nil (nil)
    setTogglePan :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
  203 :: table [6 claves]
    getAvailableIcons :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
        up[1] table: 0x98d0c8545ec56e1d :: nil (nil)
        up[2] table: 0x4de4d9403aac3f90 :: nil (nil)
    getRealXPositions :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
        up[1] table: 0x9036bc93dba07947 :: nil (nil)
        up[2] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[3] table: 0x4de4d9403aac3f90 :: nil (nil)
    getWidth :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
    start :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
        up[2] table: 0xe27087d7e27658d5 :: nil (nil)
        up[3] table: 0x9036bc93dba07947 :: nil (nil)
        up[4] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[5] table: 0x4de4d9403aac3f90 :: nil (nil)
        up[6] true :: nil (nil)
        up[7] Camera :: nil (nil)
    updateAvailableIcons :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
        up[1] table: 0xe27087d7e27658d5 :: nil (nil)
        up[2] table: 0x3d169833d23b11ca :: nil (nil)
        up[3] table: 0x98d0c8545ec56e1d :: nil (nil)
    updateBoundary :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
        up[1] table: 0x9036bc93dba07947 :: nil (nil)
        up[2] table: 0x4de4d9403aac3f90 :: nil (nil)
        up[3] table: 0xe6ef277983b2ead9 :: nil (nil)
        up[4] table: 0x972c3e92ce52a519 :: nil (nil)
        up[5] table: 0x3d169833d23b11ca :: nil (nil)
  204 :: thread
  205 :: function [ReplicatedStorage.bar.Icon.Elements.Container:?]
      up[1] GuiService :: nil (nil)
  206 :: thread
  207 :: thread
  208 :: table [8 claves]
    Connect :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
    Disable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
    Disconnect :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
    __index :: [CICLO]
    _connectCallbacks :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
    getCamera :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
        up[1] table: 0xfa3845683a5992bf :: nil (nil)
        up[2] table: 0x760ffcac582009b6 :: nil (nil)
  209 :: thread
  210 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CameraWrapper:?]
      up[1] table: 0xde2d21730b18b1b6 :: nil (nil)
  211 :: thread
  212 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0xde2d21730b18b1b6 :: nil (nil)
      up[2] function: 0x46696b61bc4e2d51 :: nil (nil)
      up[3] 1.4004150764194194 :: nil (nil)
      up[4] function: 0xcb8aa44d998a4c2b :: nil (nil)
      up[5] 2.809443878191554 :: nil (nil)
  213 :: thread
  214 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0xde2d21730b18b1b6 :: nil (nil)
      up[2] function: 0x46696b61bc4e2d51 :: nil (nil)
      up[3] 1.4004150764194194 :: nil (nil)
      up[4] function: 0xcb8aa44d998a4c2b :: nil (nil)
      up[5] 2.809443878191554 :: nil (nil)
  215 :: thread
  216 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] -0.10000000149011612 :: nil (nil)
      up[2] table: 0xde2d21730b18b1b6 :: nil (nil)
  217 :: thread
  218 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] table: 0x5ac07721175a7d91 :: nil (nil)
      up[3] true :: nil (nil)
      up[4] table: 0x7777d26bf890b439 :: nil (nil)
  219 :: thread
  220 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] table: 0x5ac07721175a7d91 :: nil (nil)
      up[3] true :: nil (nil)
      up[4] table: 0x7777d26bf890b439 :: nil (nil)
  221 :: thread
  222 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  223 :: thread
  224 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  225 :: thread
  226 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] jphuot2 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  227 :: thread
  228 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] jphuot2 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  229 :: thread
  230 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] whisperingstarwars :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  231 :: thread
  232 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] whisperingstarwars :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  233 :: thread
  234 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] fowascnd :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  235 :: thread
  236 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] fowascnd :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  237 :: thread
  238 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] Marox_140 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  239 :: thread
  240 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] Marox_140 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  241 :: thread
  242 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] Tophat_906 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  243 :: thread
  244 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] Tophat_906 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  245 :: thread
  246 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] abobus22909 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  247 :: thread
  248 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] abobus22909 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  249 :: thread
  250 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] DisfigureOfficial :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  251 :: thread
  252 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] DisfigureOfficial :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  253 :: thread
  254 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] lpx8729 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  255 :: thread
  256 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] lpx8729 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  257 :: thread
  258 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] BTC_651 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  259 :: thread
  260 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] BTC_651 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  261 :: thread
  262 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] lIllIllIIllIllIlIII :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  263 :: thread
  264 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] lIllIllIIllIllIlIII :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  265 :: thread
  266 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] apriliscute35 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  267 :: thread
  268 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] apriliscute35 :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  269 :: thread
  270 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] G4lantamine :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  271 :: thread
  272 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] G4lantamine :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  273 :: thread
  274 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] Ffggfiffkfj :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  275 :: thread
  276 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0x51377cc5d1d5f9b5 :: nil (nil)
      up[2] Ffggfiffkfj :: nil (nil)
      up[3] table: 0x5ac07721175a7d91 :: nil (nil)
  277 :: thread
  278 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
      up[1] table: 0xde2d21730b18b1b6 :: nil (nil)
      up[2] HumanoidRootPart :: nil (nil)
  279 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController.Popper:?]
  280 :: thread
  281 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController:?]
      up[1] 0.5 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
      up[3] 128 :: nil (nil)
  282 :: thread
  283 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController:?]
      up[1] 0.5 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
      up[3] 128 :: nil (nil)
  284 :: table [4 claves]
    GetZoomRadius :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController:?]
        up[1] table: 0xf165412d9eea85bc :: nil (nil)
    ReleaseSpring :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController:?]
        up[1] table: 0xf165412d9eea85bc :: nil (nil)
    SetZoomParameters :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController:?]
        up[1] table: 0xf165412d9eea85bc :: nil (nil)
        up[2] 0 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ZoomController:?]
        up[1] table: 0xf165412d9eea85bc :: nil (nil)
        up[2] 0 :: nil (nil)
        up[3] 0.5 :: nil (nil)
        up[4] 128 :: nil (nil)
        up[5] function: 0xaa96f88f2c4f20b5 :: nil (nil)
        up[6] function: 0xadafcb81c2e76ffd :: nil (nil)
        up[7] function: 0xc5f6efc92ba26be5 :: nil (nil)
        up[8] function: 0x91ea4e85caee970f :: nil (nil)
  285 :: function [ReplicatedStorage.bar.Icon.Elements.Container:?]
  286 :: thread
  287 :: table [2 claves]
    setCameraModeToastEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUI:?]
    setCameraModeToastOpen :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraUI:?]
  288 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraToggleStateController:?]
      up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
  289 :: table [46 claves]
    CalculateNewLookCFrameFromArg :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    CalculateNewLookVectorFromArg :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    CalculateNewLookVectorVRFromArg :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    Cleanup :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    EnterFirstPerson :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GamepadZoomPress :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] roblox1234dieg :: nil (nil)
    GetBodyPartToFollow :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetCameraHeight :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] VRService :: nil (nil)
    GetCameraLookVector :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetCameraMovementMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetCameraToSubjectDistance :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetCameraType :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetHumanoid :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] roblox1234dieg :: nil (nil)
    GetHumanoidPartToFollow :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetHumanoidRootPart :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] roblox1234dieg :: nil (nil)
    GetIsMouseLocked :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetMeasuredDistanceToFocus :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetModuleName :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetMouseLockOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetSubjectCFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetSubjectPosition :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetSubjectRotVelocity :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    GetSubjectVelocity :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    InFirstPerson :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    InputTranslationToCameraAngleChange :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    IsInFirstPerson :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    LeaveFirstPerson :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    OnCharacterAdded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    OnCurrentCameraChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    OnEnabledChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[2] roblox1234dieg :: nil (nil)
    OnNewCameraSubject :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    OnPlayerCameraPropertyChange :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    SetCameraMovementMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    SetCameraToSubjectDistance :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] roblox1234dieg :: nil (nil)
        up[2] table: 0xa7cd7d4fe0d1e45d :: nil (nil)
    SetCameraType :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    SetIsMouseLocked :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    SetMouseLockOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    StepZoom :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[2] table: 0xa7cd7d4fe0d1e45d :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    UpdateForDistancePropertyChange :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
    UpdateMouseBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] GameSettings :: nil (nil)
        up[2] table: 0x23b89348a8e78648 :: nil (nil)
        up[3] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[4] function: 0x48bc58ef639838da :: nil (nil)
        up[5] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
    __index :: [CICLO]
    _setUpConfigurations :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] roblox1234dieg :: nil (nil)
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0xfa3845683a5992bf :: nil (nil)
        up[3] roblox1234dieg :: nil (nil)
        up[4] GameSettings :: nil (nil)
  290 :: table [5 claves]
    GetCameraToggleOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ClassicCamera:?]
        up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[2] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
    SetCameraMovementMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ClassicCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ClassicCamera:?]
        up[1] 0, 0, 0, 1, -0, 0, 0, 0.965925813, 0.258819044, -0, -0.258819044, 0.965925813 :: nil (nil)
        up[2] Players :: nil (nil)
        up[3] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[4] 0 :: nil (nil)
        up[5] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
        up[6] true :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.ClassicCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0xf5ef28f67269e5dd :: nil (nil)
        up[3] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
  291 :: thread
  292 :: table [13 claves]
    CalculateNewLookVector :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    GetCameraToSubjectDistance :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    GetModuleName :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    LoadNumberValueParameters :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
        up[1] true :: nil (nil)
    LoadOrCreateNumberValueParameter :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    SetAndBoundsCheckAzimuthValues :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    SetAndBoundsCheckDistanceValues :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    SetAndBoundsCheckElevationValues :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
    SetCameraToSubjectDistance :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
        up[1] Players :: nil (nil)
    SetInitialOrientation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
        up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[2] Players :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.OrbitalCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0x54f705a11c144be3 :: nil (nil)
  293 :: table [3 claves]
    getIconToHighlight :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
    registerButton :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
        up[1] UserInputService :: nil (nil)
        up[2] GamepadService :: nil (nil)
        up[3] GuiService :: nil (nil)
    start :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
        up[1] table: 0x972c3e92ce52a519 :: nil (nil)
        up[2] Enum.KeyCode.DPadUp :: nil (nil)
        up[3] GuiService :: nil (nil)
        up[4] UserInputService :: nil (nil)
        up[5] Enum.PreferredInput.Gamepad :: nil (nil)
        up[6] table: 0x48fe16bf299a5fbd :: nil (nil)
        up[7] GamepadService :: nil (nil)
  294 :: table [5 claves]
    GetModuleName :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.LegacyCamera:?]
    SetCameraToSubjectDistance :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.LegacyCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.LegacyCamera:?]
        up[1] Players :: nil (nil)
        up[2] table: 0x6dc91e87c8b553a5 :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.LegacyCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0x771fc65c0d962633 :: nil (nil)
  295 :: table [42 claves]
    1 :: table [3 claves]
      1 :: string ("IconCorners")
      2 :: string ("CornerRadius")
      3 :: userdata
    2 :: table [3 claves]
      1 :: string ("Selection")
      2 :: string ("RotationSpeed")
      3 :: number (1)
    3 :: table [3 claves]
      1 :: string ("Selection")
      2 :: string ("Size")
      3 :: userdata
    4 :: table [3 claves]
      1 :: string ("Selection")
      2 :: string ("Position")
      3 :: userdata
    5 :: table [3 claves]
      1 :: string ("SelectionGradient")
      2 :: string ("Color")
      3 :: userdata
    6 :: table [4 claves]
      1 :: string ("IconImage")
      2 :: string ("Image")
      3 :: string ("")
      4 :: string ("Deselected")
    7 :: table [4 claves]
      1 :: string ("IconLabel")
      2 :: string ("Text")
      3 :: string ("")
      4 :: string ("Deselected")
    8 :: table [4 claves]
      1 :: string ("IconLabel")
      2 :: string ("Position")
      3 :: userdata
      4 :: string ("Deselected")
    9 :: table [4 claves]
      1 :: string ("Widget")
      2 :: string ("DesiredWidth")
      3 :: number (44)
      4 :: string ("Deselected")
    10 :: table [4 claves]
      1 :: string ("Widget")
      2 :: string ("MinimumWidth")
      3 :: number (44)
      4 :: string ("Deselected")
    11 :: table [4 claves]
      1 :: string ("Widget")
      2 :: string ("MinimumHeight")
      3 :: number (44)
      4 :: string ("Deselected")
    12 :: table [4 claves]
      1 :: string ("Widget")
      2 :: string ("BorderSize")
      3 :: number (4)
      4 :: string ("Deselected")
    13 :: table [4 claves]
      1 :: string ("IconButton")
      2 :: string ("BackgroundColor3")
      3 :: userdata
      4 :: string ("Deselected")
    14 :: table [4 claves]
      1 :: string ("IconButton")
      2 :: string ("BackgroundTransparency")
      3 :: number (0.08)
      4 :: string ("Deselected")
    15 :: table [4 claves]
      1 :: string ("IconImageScale")
      2 :: string ("Value")
      3 :: number (0.5)
      4 :: string ("Deselected")
    16 :: table [4 claves]
      1 :: string ("IconImageCorner")
      2 :: string ("CornerRadius")
      3 :: userdata
      4 :: string ("Deselected")
    17 :: table [4 claves]
      1 :: string ("IconImage")
      2 :: string ("ImageColor3")
      3 :: userdata
      4 :: string ("Deselected")
    18 :: table [4 claves]
      1 :: string ("IconImage")
      2 :: string ("ImageTransparency")
      3 :: number (0)
      4 :: string ("Deselected")
    19 :: table [4 claves]
      1 :: string ("IconImageRatio")
      2 :: string ("AspectRatio")
      3 :: number (1)
      4 :: string ("Deselected")
    20 :: table [4 claves]
      1 :: string ("IconLabel")
      2 :: string ("FontFace")
      3 :: userdata
      4 :: string ("Deselected")
    21 :: table [4 claves]
      1 :: string ("IconLabel")
      2 :: string ("TextSize")
      3 :: number (16)
      4 :: string ("Deselected")
    22 :: table [4 claves]
      1 :: string ("IconSpot")
      2 :: string ("BackgroundTransparency")
      3 :: number (1)
      4 :: string ("Deselected")
    23 :: table [4 claves]
      1 :: string ("IconOverlay")
      2 :: string ("BackgroundTransparency")
      3 :: number (0.85)
      4 :: string ("Deselected")
    24 :: table [4 claves]
      1 :: string ("IconSpotGradient")
      2 :: string ("Enabled")
      3 :: boolean (false)
      4 :: string ("Deselected")
    25 :: table [4 claves]
      1 :: string ("IconGradient")
      2 :: string ("Enabled")
      3 :: boolean (false)
      4 :: string ("Deselected")
    26 :: table [4 claves]
      1 :: string ("ClickRegion")
      2 :: string ("Active")
      3 :: boolean (true)
      4 :: string ("Deselected")
    27 :: table [4 claves]
      1 :: string ("Menu")
      2 :: string ("Active")
      3 :: boolean (false)
      4 :: string ("Deselected")
    28 :: table [4 claves]
      1 :: string ("ContentsList")
      2 :: string ("HorizontalAlignment")
      3 :: userdata
      4 :: string ("Deselected")
    29 :: table [4 claves]
      1 :: string ("Dropdown")
      2 :: string ("BackgroundColor3")
      3 :: userdata
      4 :: string ("Deselected")
    30 :: table [4 claves]
      1 :: string ("Dropdown")
      2 :: string ("BackgroundTransparency")
      3 :: number (0.08)
      4 :: string ("Deselected")
    31 :: table [4 claves]
      1 :: string ("Dropdown")
      2 :: string ("MaxIcons")
      3 :: number (4.5)
      4 :: string ("Deselected")
    32 :: table [4 claves]
      1 :: string ("Menu")
      2 :: string ("MaxIcons")
      3 :: number (4)
      4 :: string ("Deselected")
    33 :: table [4 claves]
      1 :: string ("Notice")
      2 :: string ("Position")
      3 :: userdata
      4 :: string ("Deselected")
    34 :: table [4 claves]
      1 :: string ("Notice")
      2 :: string ("Size")
      3 :: userdata
      4 :: string ("Deselected")
    35 :: table [4 claves]
      1 :: string ("NoticeLabel")
      2 :: string ("TextSize")
      3 :: number (13)
      4 :: string ("Deselected")
    36 :: table [4 claves]
      1 :: string ("PaddingLeft")
      2 :: string ("Size")
      3 :: userdata
      4 :: string ("Deselected")
    37 :: table [4 claves]
      1 :: string ("PaddingRight")
      2 :: string ("Size")
      3 :: userdata
      4 :: string ("Deselected")
    38 :: table [4 claves]
      1 :: string ("IconSpot")
      2 :: string ("BackgroundTransparency")
      3 :: number (0.7)
      4 :: string ("Selected")
    39 :: table [4 claves]
      1 :: string ("IconSpot")
      2 :: string ("BackgroundColor3")
      3 :: userdata
      4 :: string ("Selected")
    40 :: table [4 claves]
      1 :: string ("IconSpotGradient")
      2 :: string ("Enabled")
      3 :: boolean (true)
      4 :: string ("Selected")
    41 :: table [4 claves]
      1 :: string ("IconSpotGradient")
      2 :: string ("Rotation")
      3 :: number (45)
      4 :: string ("Selected")
    42 :: table [4 claves]
      1 :: string ("IconSpotGradient")
      2 :: string ("Color")
      3 :: userdata
      4 :: string ("Selected")
  296 :: table [15 claves]
    apply :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    change :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    getClippedClone :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
    getInstanceValue :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
    getModifications :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
    getRealInstance :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
    getThemeValue :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
    merge :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    modify :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[2] table: 0x0c5b2c275505ab91 :: nil (nil)
    rebuild :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
        up[2] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[3] table: 0x7864be3ed430b0c4 :: nil (nil)
    refresh :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    remove :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    removeWith :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    set :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
        up[1] table: 0x0c5b2c275505ab91 :: nil (nil)
    statesMatch :: function [ReplicatedStorage.bar.Icon.Features.Themes:?]
  297 :: thread
  298 :: table [18 claves]
    autocorrectDelay :: number (1)
    autocorrectMaxCarSpeed :: number (32)
    autocorrectMinCarSpeed :: number (16)
    autocorrectResponse :: number (0.5)
    cutoffMaxAngularVelPitch :: number (60)
    cutoffMaxAngularVelYaw :: number (180)
    cutoffMinAngularVelPitch :: number (15)
    cutoffMinAngularVelYaw :: number (60)
    firstPersonResponseMul :: number (10)
    pitchBaseAngle :: number (18)
    pitchDeadzoneAngle :: number (12)
    pitchReponseDampingRising :: number (1)
    pitchResponseDampingFalling :: number (3)
    pitchStiffness :: number (0.5)
    verticalCenterOffset :: number (0.33)
    yawReponseDampingRising :: number (1)
    yawResponseDampingFalling :: number (3)
    yawStiffness :: number (2.5)
  299 :: table [4 claves]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore:?]
        up[1] table: 0x912696c47dee3659 :: nil (nil)
        up[2] table: 0xd6fc3e8873c31a56 :: nil (nil)
    setTransform :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore:?]
    step :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera.VehicleCameraCore:?]
  300 :: thread
  301 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
      up[1] 0.03333333507180214 :: nil (nil)
  302 :: table [8 claves]
    ApplyVRTransform :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
    Reset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
        up[1] table: 0xd6fc3e8873c31a56 :: nil (nil)
        up[2] table: 0x3438bb1670ed706b :: nil (nil)
        up[3] table: 0x89160e1d975cd6d3 :: nil (nil)
        up[4] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
        up[5] table: 0xf7e64c364d36aea9 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
        up[1] 0.03333333507180214 :: nil (nil)
        up[2] function: 0x59cb20af008d5475 :: nil (nil)
    _GetFirstPersonLocalOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
        up[1] roblox1234dieg :: nil (nil)
    _GetThirdPersonLocalOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
        up[1] table: 0x89160e1d975cd6d3 :: nil (nil)
    _StepRotation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
        up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[2] function: 0x4acfedb964c16a56 :: nil (nil)
        up[3] table: 0x89160e1d975cd6d3 :: nil (nil)
        up[4] function: 0x59cb20af008d5475 :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VehicleCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0x62144b87939d32c9 :: nil (nil)
  303 :: table [11 claves]
    clipOutside :: function [ReplicatedStorage.bar.Icon.Utility:?]
        up[1] table: 0xba48cbcf43f5e1b7 :: nil (nil)
        up[2] table: 0xfe6178e3233d03d9 :: nil (nil)
        up[3] GuiService :: nil (nil)
    copyTable :: function [ReplicatedStorage.bar.Icon.Utility:?]
        up[1] table: 0xfe6178e3233d03d9 :: nil (nil)
    createStagger :: function [ReplicatedStorage.bar.Icon.Utility:?]
    formatStateName :: function [ReplicatedStorage.bar.Icon.Utility:?]
    generateUID :: function [ReplicatedStorage.bar.Icon.Utility:?]
        up[1] table: 0x8f91419bb703b6c4 :: nil (nil)
    getClippedContainer :: function [ReplicatedStorage.bar.Icon.Utility:?]
    joinFeature :: function [ReplicatedStorage.bar.Icon.Utility:?]
    localPlayerRespawned :: function [ReplicatedStorage.bar.Icon.Utility:?]
        up[1] roblox1234dieg :: nil (nil)
    reverseTable :: function [ReplicatedStorage.bar.Icon.Utility:?]
    round :: function [ReplicatedStorage.bar.Icon.Utility:?]
    setVisible :: function [ReplicatedStorage.bar.Icon.Utility:?]
        up[1] table: 0x9e528d4dceb82729 :: nil (nil)
  304 :: thread
  305 :: table [4 claves]
    DEBOUNCE_SECONDS :: number (0.25)
    JUMP_STUDS :: number (4)
    SETTLED_STUDS :: number (1)
    shouldRecenter :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCameraTeleportDetector:?]
        up[1] table: 0xf76a735ee8e7b897 :: nil (nil)
  306 :: thread
  307 :: table [20 claves]
    GamepadReset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    GamepadZoomPress :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
    GetCameraHeight :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    GetModuleName :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    GetSubjectCFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
    GetSubjectPosition :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
    GetVRFocus :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    HandleSubjectDistance :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    OnCurrentCameraChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
    OnEnabledChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[3] VRService :: nil (nil)
        up[4] Lighting :: nil (nil)
    OnHeadScaleChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    Reset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    ResetZoom :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0xa7cd7d4fe0d1e45d :: nil (nil)
    StartFadeFromBlack :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] GameSettings :: nil (nil)
        up[2] Lighting :: nil (nil)
    StartVREdgeBlur :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] GameSettings :: nil (nil)
        up[2] Run Service :: nil (nil)
        up[3] VRService :: nil (nil)
    UpdateEdgeBlur :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
    UpdateFadeFromBlack :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] Lighting :: nil (nil)
    __index :: [CICLO]
    getRotation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[2] GameSettings :: nil (nil)
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRBaseCamera:?]
        up[1] table: 0x7d43e3a4f7366528 :: nil (nil)
        up[2] table: 0xb7eabbbfd2c1f0bf :: nil (nil)
  308 :: table [12 claves]
    GetAvatarFeetWorldYValue :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
    LeaveFirstPerson :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] table: 0xb7eabbbfd2c1f0bf :: nil (nil)
    OnEnabledChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] table: 0xb7eabbbfd2c1f0bf :: nil (nil)
    Reset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] table: 0xb7eabbbfd2c1f0bf :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] Players :: nil (nil)
        up[2] VRService :: nil (nil)
    UpdateFirstPersonTransform :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
    UpdateImmersionCamera :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] Players :: nil (nil)
        up[2] true :: nil (nil)
    UpdateThirdPersonComfortTransform :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] Players :: nil (nil)
        up[2] VRService :: nil (nil)
    UpdateThirdPersonFollowTransform :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] VRService :: nil (nil)
        up[2] Players :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] table: 0xb7eabbbfd2c1f0bf :: nil (nil)
        up[2] table: 0xcffe80da3b5d438c :: nil (nil)
        up[3] Players :: nil (nil)
    updateImmersionAutoRotate :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRCamera:?]
        up[1] VRService :: nil (nil)
  309 :: thread
  310 :: table [8 claves]
    Reset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
        up[2] table: 0x8835a088ad90e7c1 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] 0.016666666666666666 :: nil (nil)
        up[2] roblox1234dieg :: nil (nil)
    __index :: [CICLO]
    _getFirstPersonLocalOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] roblox1234dieg :: nil (nil)
    _getThirdPersonLocalOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] table: 0x89160e1d975cd6d3 :: nil (nil)
    _updateStepRotation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] function: 0x59cb20af008d5475 :: nil (nil)
        up[2] table: 0x6dc91e87c8b553a5 :: nil (nil)
        up[3] table: 0x89160e1d975cd6d3 :: nil (nil)
        up[4] function: 0x716e599ca37c5d40 :: nil (nil)
    _vrOccludeVignette :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] function: 0xe0ae545f7e013e52 :: nil (nil)
        up[2] Lighting :: nil (nil)
        up[3] roblox1234dieg :: nil (nil)
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.VRVehicleCamera:?]
        up[1] table: 0xb7eabbbfd2c1f0bf :: nil (nil)
        up[2] table: 0xea77a67a2ab6a38c :: nil (nil)
        up[3] Run Service :: nil (nil)
        up[4] 0.016666666666666666 :: nil (nil)
  311 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x216e6f5fd8fe95b3 :: nil (nil)
      up[2] Enum.HumanoidStateType.FallingDown :: nil (nil)
      up[3] table: 0xa46dfa1b468f1b20 :: nil (nil)
  312 :: table [7 claves]
    ClassName :: string ("Janitor")
    IGNORE_MEMORY_DEBUG :: boolean (true)
    Is :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
        up[1] table: 0xba48cbcf43f5e1b7 :: nil (nil)
    __call :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
        up[1] IndicesReference :: nil (nil)
    __index :: table [28 claves]
      Add :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
          up[2] table: 0x5c9b7dfb66d3d96d :: nil (nil)
      AddObject :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      AddPromise :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      Clean :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      Cleanup :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      CurrentlyCleaning :: boolean (true)
      Destroy :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      Get :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      Give :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
          up[2] table: 0x5c9b7dfb66d3d96d :: nil (nil)
      GiveObject :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      GivePromise :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      LinkToInstance :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] LinkToInstanceIndex :: nil (nil)
          up[2] table: 0x7d7fe7f5991954b6 :: nil (nil)
          up[3] Signal Heartbeat :: nil (nil)
      LinkToInstances :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] table: 0xba48cbcf43f5e1b7 :: nil (nil)
      Remove :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      add :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
          up[2] table: 0x5c9b7dfb66d3d96d :: nil (nil)
      addObject :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      addPromise :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      clean :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      cleanup :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      currentlyCleaning :: boolean (true)
      destroy :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      get :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
      give :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
          up[2] table: 0x5c9b7dfb66d3d96d :: nil (nil)
      giveObject :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      givePromise :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
      linkToInstance :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] LinkToInstanceIndex :: nil (nil)
          up[2] table: 0x7d7fe7f5991954b6 :: nil (nil)
          up[3] Signal Heartbeat :: nil (nil)
      linkToInstances :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] table: 0xba48cbcf43f5e1b7 :: nil (nil)
      remove :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
          up[1] IndicesReference :: nil (nil)
    is :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
        up[1] table: 0xba48cbcf43f5e1b7 :: nil (nil)
    new :: function [ReplicatedStorage.bar.Icon.Packages.Janitor:?]
        up[1] IndicesReference :: nil (nil)
        up[2] table: 0xba48cbcf43f5e1b7 :: nil (nil)
  313 :: table [8 claves]
    CharacterAdded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
    CharacterRemoving :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
    GetOcclusionMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
    OnCameraSubjectChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseOcclusion:?]
        up[1] table: 0x7380dd50a135c195 :: nil (nil)
  314 :: table [17 claves]
    CharacterAdded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] Players :: nil (nil)
        up[2] table: 0x9bbd19166af431b6 :: nil (nil)
    CharacterOutlineBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] true :: nil (nil)
        up[2] RaycastParams{IgnoreWater=false, Margin=0, SizeGradient=0, BruteForceAllSlow=false, RespectCanCollide=false, CollisionGroup=Default, FilterDescendantsInstances={}} :: nil (nil)
    CheckTorsoReference :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    CircleBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] table: 0xe545a95863c17c05 :: nil (nil)
    Cleanup :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    CornerBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] table: 0x91ae94b86a0a1cb4 :: nil (nil)
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    GetObscuredParts :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    GetOcclusionMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    LimbBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    LimbMoveBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    MoveBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    SetMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] function: 0x766f92569ed8fb22 :: nil (nil)
        up[2] table: 0xe545a95863c17c05 :: nil (nil)
    SmartCircleBehavior :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] true :: nil (nil)
        up[2] RaycastParams{IgnoreWater=false, Margin=0, SizeGradient=0, BruteForceAllSlow=false, RespectCanCollide=false, CollisionGroup=Default, FilterDescendantsInstances={}} :: nil (nil)
        up[3] function: 0x579acbd03d81b8f6 :: nil (nil)
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Invisicam:?]
        up[1] table: 0x7380dd50a135c195 :: nil (nil)
        up[2] table: 0x977b1d366974b9c3 :: nil (nil)
        up[3] table: 0xe545a95863c17c05 :: nil (nil)
  315 :: table [8 claves]
    Connect :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
        up[1] table: 0x4de49f02d74868e9 :: nil (nil)
    Destroy :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
    DisconnectAll :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
    Fire :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
        up[1] thread: 0xc37a9831bdafb61e :: nil (nil)
        up[2] function: 0x714d320d5ec1b15e :: nil (nil)
    Once :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
    Wait :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
    __index :: [CICLO]
    new :: function [ReplicatedStorage.bar.Icon.Packages.GoodSignal:?]
        up[1] table: 0xc9ec33e052cbbe41 :: nil (nil)
  316 :: table [8 claves]
    CharacterAdded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
    CharacterRemoving :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
    GetOcclusionMode :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
    OnCameraSubjectChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
        up[1] true :: nil (nil)
        up[2] table: 0xa7cd7d4fe0d1e45d :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.Poppercam:?]
        up[1] table: 0x7380dd50a135c195 :: nil (nil)
        up[2] table: 0x8d97a021943bcdd8 :: nil (nil)
        up[3] table: 0x5a27a3f538199da0 :: nil (nil)
  317 :: thread
  318 :: table [10 claves]
    CachePartsRecursive :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
    HasToolAncestor :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
    IsValidPartToModify :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
        up[1] table: 0xfdfa16ad4b75ce71 :: nil (nil)
    SetSubject :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
    SetupTransparency :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
    TeardownTransparency :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
        up[2] VRService :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
        up[1] table: 0xcd2ac3adda351d81 :: nil (nil)
  319 :: table [3 claves]
    addToReplicatedStorage :: function [ReplicatedStorage.bar.Icon.Reference:?]
        up[1] ReplicatedStorage :: nil (nil)
        up[2] table: 0x9f6d3c0d41d74b56 :: nil (nil)
    getObject :: function [ReplicatedStorage.bar.Icon.Reference:?]
        up[1] ReplicatedStorage :: nil (nil)
        up[2] table: 0x9f6d3c0d41d74b56 :: nil (nil)
    objectName :: string ("TopbarPlusReference")
  320 :: table [13 claves]
    BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
        up[1] ContextActionService :: nil (nil)
        up[2] 2000 :: nil (nil)
    DoMouseLockSwitch :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
    EnableMouseLock :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
        up[2] true :: nil (nil)
    GetBindableToggleEvent :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
    GetIsMouseLocked :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
    GetMouseLockOffset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
    IsMouseLocked :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
    OnBoundKeysObjectChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
    OnMouseLockToggled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
        up[1] table: 0xdd2ffb3e5afc7c25 :: nil (nil)
    UnbindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
        up[1] ContextActionService :: nil (nil)
    UpdateMouseLockAvailability :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
        up[1] Players :: nil (nil)
        up[2] GameSettings :: nil (nil)
        up[3] UserInputService :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
        up[1] table: 0x167adc2e6db6a7db :: nil (nil)
        up[2] GameSettings :: nil (nil)
        up[3] Players :: nil (nil)
        up[4] UserInputService :: nil (nil)
  321 :: thread
  322 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
  323 :: thread
  324 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
  325 :: thread
  326 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] jphuot2 :: nil (nil)
  327 :: thread
  328 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] jphuot2 :: nil (nil)
  329 :: thread
  330 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] whisperingstarwars :: nil (nil)
  331 :: thread
  332 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] whisperingstarwars :: nil (nil)
  333 :: thread
  334 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] fowascnd :: nil (nil)
  335 :: thread
  336 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] fowascnd :: nil (nil)
  337 :: thread
  338 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Marox_140 :: nil (nil)
  339 :: thread
  340 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Marox_140 :: nil (nil)
  341 :: thread
  342 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Tophat_906 :: nil (nil)
  343 :: thread
  344 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Tophat_906 :: nil (nil)
  345 :: thread
  346 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] abobus22909 :: nil (nil)
  347 :: thread
  348 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] abobus22909 :: nil (nil)
  349 :: thread
  350 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DisfigureOfficial :: nil (nil)
  351 :: thread
  352 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DisfigureOfficial :: nil (nil)
  353 :: thread
  354 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] lpx8729 :: nil (nil)
  355 :: thread
  356 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] lpx8729 :: nil (nil)
  357 :: thread
  358 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] BTC_651 :: nil (nil)
  359 :: thread
  360 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] BTC_651 :: nil (nil)
  361 :: thread
  362 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] lIllIllIIllIllIlIII :: nil (nil)
  363 :: thread
  364 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] lIllIllIIllIllIlIII :: nil (nil)
  365 :: thread
  366 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] apriliscute35 :: nil (nil)
  367 :: thread
  368 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] apriliscute35 :: nil (nil)
  369 :: thread
  370 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] G4lantamine :: nil (nil)
  371 :: thread
  372 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] G4lantamine :: nil (nil)
  373 :: thread
  374 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Ffggfiffkfj :: nil (nil)
  375 :: thread
  376 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Ffggfiffkfj :: nil (nil)
  377 :: thread
  378 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  379 :: thread
  380 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  381 :: thread
  382 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
      up[1] table: 0xec769e875be19ed8 :: nil (nil)
  383 :: table [0 claves]
  384 :: thread
  385 :: thread
  386 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
      up[1] table: 0xec769e875be19ed8 :: nil (nil)
  387 :: thread
  388 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
      up[1] table: 0xec769e875be19ed8 :: nil (nil)
  389 :: thread
  390 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
      up[1] table: 0xec769e875be19ed8 :: nil (nil)
  391 :: thread
  392 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.MouseLockController:?]
      up[1] table: 0xec769e875be19ed8 :: nil (nil)
  393 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x38ec93f8b3d38952 :: nil (nil)
      up[2] table: 0x57359975220bc86f :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  394 :: thread
  395 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  396 :: thread
  397 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconImageCorner :: nil (nil)
      up[3] IconImageCorner :: nil (nil)
  398 :: thread
  399 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  400 :: thread
  401 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  402 :: thread
  403 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  404 :: thread
  405 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  406 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  407 :: thread
  408 :: thread
  409 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  410 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconLabelContainer :: nil (nil)
      up[3] IconLabelContainer :: nil (nil)
  411 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  412 :: thread
  413 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  414 :: thread
  415 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  416 :: thread
  417 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  418 :: thread
  419 :: thread
  420 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  421 :: thread
  422 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  423 :: thread
  424 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  425 :: thread
  426 :: thread
  427 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0x889c9f0cccba8738 :: nil (nil)
  428 :: thread
  429 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  430 :: thread
  431 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] Camera :: nil (nil)
  432 :: thread
  433 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  434 :: thread
  435 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] CameraMinZoomDistance :: nil (nil)
  436 :: thread
  437 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] CameraMaxZoomDistance :: nil (nil)
  438 :: thread
  439 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] CameraMode :: nil (nil)
  440 :: thread
  441 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DevCameraOcclusionMode :: nil (nil)
  442 :: thread
  443 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DevComputerCameraMode :: nil (nil)
  444 :: thread
  445 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DevTouchCameraMode :: nil (nil)
  446 :: thread
  447 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DevComputerMovementMode :: nil (nil)
  448 :: thread
  449 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DevTouchMovementMode :: nil (nil)
  450 :: thread
  451 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] DevEnableMouseLock :: nil (nil)
  452 :: thread
  453 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] ComputerCameraMovementMode :: nil (nil)
  454 :: thread
  455 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] ComputerMovementMode :: nil (nil)
  456 :: thread
  457 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] ControlMode :: nil (nil)
  458 :: thread
  459 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] GamepadCameraSensitivity :: nil (nil)
  460 :: thread
  461 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] MouseSensitivity :: nil (nil)
  462 :: thread
  463 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] RotationType :: nil (nil)
  464 :: thread
  465 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] TouchCameraMovementMode :: nil (nil)
  466 :: thread
  467 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
      up[2] TouchMovementMode :: nil (nil)
  468 :: thread
  469 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  470 :: thread
  471 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule:?]
      up[1] table: 0x467c10c24c70fbf8 :: nil (nil)
  472 :: table [0 claves]
  473 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  474 :: thread
  475 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v27:?]
      up[1] roblox1234dieg :: nil (nil)
      up[2] warning :: nil (nil)
  476 :: table [6 claves]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController:?]
    GetIsJumping :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController:?]
    GetMoveVector :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController:?]
    IsMoveVectorCameraRelative :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.BaseCharacterController:?]
        up[1] table: 0x282fe203369422d1 :: nil (nil)
        up[2] 0, 0, 0 :: nil (nil)
        up[3] table: 0xfa3845683a5992bf :: nil (nil)
  477 :: table [7 claves]
    BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Keyboard:?]
        up[1] ContextActionService :: nil (nil)
    ConnectFocusEventListeners :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Keyboard:?]
        up[1] 0, 0, 0 :: nil (nil)
        up[2] UserInputService :: nil (nil)
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Keyboard:?]
        up[1] 0, 0, 0 :: nil (nil)
    UpdateJump :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Keyboard:?]
    UpdateMovement :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Keyboard:?]
        up[1] 0, 0, 0 :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Keyboard:?]
        up[1] table: 0x282fe203369422d1 :: nil (nil)
        up[2] table: 0x6a8d41b5ce0a0996 :: nil (nil)
  478 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v55:?]
      up[1] Players :: nil (nil)
  479 :: table [11 claves]
    BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] Enum.UserInputType.None :: nil (nil)
        up[2] true :: nil (nil)
        up[3] ContextActionService :: nil (nil)
    ConnectGamepadConnectionListeners :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] UserInputService :: nil (nil)
    DisconnectGamepadConnectionListeners :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] Enum.UserInputType.None :: nil (nil)
    GetHighestPriorityGamepad :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] UserInputService :: nil (nil)
        up[2] Enum.UserInputType.None :: nil (nil)
    OnCurrentGamepadDisconnected :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] Enum.UserInputType.None :: nil (nil)
        up[2] ContextActionService :: nil (nil)
    OnNewGamepadConnected :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] Enum.UserInputType.None :: nil (nil)
    UnbindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] Enum.UserInputType.None :: nil (nil)
        up[2] ContextActionService :: nil (nil)
        up[3] true :: nil (nil)
    UpdateMovement :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.Gamepad:?]
        up[1] table: 0x282fe203369422d1 :: nil (nil)
        up[2] table: 0xbd4ae68cdde353d4 :: nil (nil)
        up[3] Enum.UserInputType.None :: nil (nil)
  480 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v55:?]
      up[1] box :: nil (nil)
      up[2] table: 0xeca242f2a1dc4c9f :: nil (nil)
      up[3] roblox1234dieg :: nil (nil)
      up[4] function: 0x5bdfe931da5429ec :: nil (nil)
  481 :: thread
  482 :: table [2 claves]
    GetEnabledChangedSignal :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.AvatarAbilitiesInterface:?]
        up[1] true :: nil (nil)
        up[2] Players :: nil (nil)
        up[3] function: 0xf09ff37daae4c6f1 :: nil (nil)
        up[4] Event :: nil (nil)
    isEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.AvatarAbilitiesInterface:?]
        up[1] true :: nil (nil)
        up[2] Players :: nil (nil)
        up[3] function: 0xf09ff37daae4c6f1 :: nil (nil)
  483 :: table [15 claves]
    BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] TweenService :: nil (nil)
        up[2] ContextActionService :: nil (nil)
        up[3] 3000 :: nil (nil)
        up[4] UserInputService :: nil (nil)
    Create :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] true :: nil (nil)
        up[2] true :: nil (nil)
        up[3] 7 :: nil (nil)
        up[4] table: 0x524f3086ffd2cb40 :: nil (nil)
        up[5] true :: nil (nil)
        up[6] table: 0x2c951632dc2d7e53 :: nil (nil)
        up[7] Run Service :: nil (nil)
        up[8] UserInputService :: nil (nil)
        up[9] GuiService :: nil (nil)
        up[10] roblox1234dieg :: nil (nil)
    DoFadeInBackground :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] roblox1234dieg :: nil (nil)
    DoMove :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    FadeThumbstick :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] TweenService :: nil (nil)
        up[2] Time:0.15 DelayTime:0 RepeatCount:0 Reverses:False EasingDirection:InOut EasingStyle:Quad :: nil (nil)
        up[3] table: 0x524f3086ffd2cb40 :: nil (nil)
    FadeThumbstickFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    GetIsJumping :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    InputInFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    LayoutMiddleImages :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] 7 :: nil (nil)
    MoveStick :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    OnInputEnded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
    UnbindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] ContextActionService :: nil (nil)
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        up[1] table: 0x282fe203369422d1 :: nil (nil)
        up[2] table: 0x61cf561c79f03e07 :: nil (nil)
  484 :: thread
  485 :: table [5 claves]
    Create :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchThumbstick:?]
        up[1] true :: nil (nil)
        up[2] table: 0x2c951632dc2d7e53 :: nil (nil)
        up[3] UserInputService :: nil (nil)
        up[4] GuiService :: nil (nil)
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchThumbstick:?]
    OnInputEnded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchThumbstick:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchThumbstick:?]
        up[1] table: 0x282fe203369422d1 :: nil (nil)
        up[2] table: 0x21eb4edc45d4713d :: nil (nil)
  486 :: thread
  487 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v55:?]
      up[1] function: 0x5bdfe931da5429ec :: nil (nil)
  488 :: table [13 claves]
    CancelFailureAnimation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
    CreateEndWaypoint :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] table: 0x8dd28a748cf7de77 :: nil (nil)
    CreatePathDisplay :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] 0 :: nil (nil)
        up[2] function: 0x674c718aa3643488 :: nil (nil)
        up[3] Run Service :: nil (nil)
        up[4] Workspace :: nil (nil)
        up[5] 1.5, 1.5 :: nil (nil)
    DisplayFailureWaypoint :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
    GetEndWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] rbxasset://textures/ui/waypoint.png :: nil (nil)
    GetWaypointRadius :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] 1.5, 1.5 :: nil (nil)
    GetWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] rbxasset://textures/ui/traildot.png :: nil (nil)
    GetWaypointsAlwaysOnTop :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
    PlayFailureAnimation :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] roblox1234dieg :: nil (nil)
    SetEndWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] rbxasset://textures/ui/waypoint.png :: nil (nil)
        up[2] TrailDot :: nil (nil)
        up[3] EndWaypoint :: nil (nil)
        up[4] FailureWaypoint :: nil (nil)
        up[5] function: 0x6f5ac0ef5963df71 :: nil (nil)
    SetWaypointRadius :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] 1.5, 1.5 :: nil (nil)
        up[2] TrailDot :: nil (nil)
        up[3] EndWaypoint :: nil (nil)
        up[4] FailureWaypoint :: nil (nil)
        up[5] function: 0x6f5ac0ef5963df71 :: nil (nil)
    SetWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
        up[1] rbxasset://textures/ui/traildot.png :: nil (nil)
        up[2] TrailDot :: nil (nil)
        up[3] EndWaypoint :: nil (nil)
        up[4] FailureWaypoint :: nil (nil)
        up[5] function: 0x6f5ac0ef5963df71 :: nil (nil)
    SetWaypointsAlwaysOnTop :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveDisplay:?]
  489 :: table [38 claves]
    CleanupPath :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    DisconnectEvents :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] roblox1234dieg :: nil (nil)
    GetAgentSizeIncreaseFactor :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] 1 :: nil (nil)
    GetEndWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    GetFailureAnimationEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] true :: nil (nil)
    GetIgnoredPartsTag :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    GetShowPath :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] true :: nil (nil)
    GetUnreachableWaypointTimeout :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] 8 :: nil (nil)
    GetUseDirectPath :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    GetUserJumpEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    GetWaypointRadius :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    GetWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    GetWaypointsAlwaysOnTop :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    MoveTo :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] roblox1234dieg :: nil (nil)
        up[2] function: 0x32c062ad54ea4f4f :: nil (nil)
        up[3] function: 0xe65d69e016c36919 :: nil (nil)
    OnCharacterAdded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] UserInputService :: nil (nil)
        up[2] table: 0xefef29d0d887d772 :: nil (nil)
    OnPreferredInputChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] roblox1234dieg :: nil (nil)
        up[2] UserInputService :: nil (nil)
    OnRenderStepped :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    OnTouchBegan :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    OnTouchChanged :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    OnTouchEnded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    SetAgentSizeIncreaseFactor :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] 1 :: nil (nil)
    SetEndWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    SetFailureAnimationEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] true :: nil (nil)
    SetIgnoredPartsTag :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] function: 0x4af364d30e2711cc :: nil (nil)
    SetShowPath :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] true :: nil (nil)
    SetUnreachableWaypointTimeout :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] 8 :: nil (nil)
    SetUseDirectPath :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    SetUserJumpEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    SetWaypointRadius :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    SetWaypointTexture :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    SetWaypointsAlwaysOnTop :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0xc33fee77b72bc638 :: nil (nil)
    Start :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    Stop :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    UpdateJump :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    UpdateMovement :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.ClickToMoveController:?]
        up[1] table: 0x6a8d41b5ce0a0996 :: nil (nil)
        up[2] table: 0xb65cd005b77041fb :: nil (nil)
  490 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v46:?]
      up[1] roblox1234dieg :: nil (nil)
      up[2] Humanoid :: nil (nil)
      up[3] function: 0x8599d8d678b5acb8 :: nil (nil)
  491 :: thread
  492 :: table [9 claves]
    _boundEvents :: table [3 claves]
      CHARACTER_ADDED :: userdata <BindableEvent>
      CHARACTER_CHILD_ADDEDHumanoidHumanoid :: userdata <BindableEvent>
      LOCAL_PLAYER :: userdata <BindableEvent>
    _connectionUtil :: table [1 claves]
      _connections :: table [5 claves]
        CHARACTER_ADDED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
            up[1] Connection :: nil (nil)
        CHARACTER_CHILD_ADDED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
            up[1] Connection :: nil (nil)
        LOCAL_PLAYER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
            up[1] Connection :: nil (nil)
        ON_CHARACTER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
            up[1] Connection :: nil (nil)
        ON_LOCAL_PLAYER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
            up[1] Connection :: nil (nil)
    _getOrCreateBoundEvent :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    getCharacter :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    getChild :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    getLocalPlayer :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] Players :: nil (nil)
    onCharacter :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    onChild :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    onLocalPlayer :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
        up[2] Players :: nil (nil)
  493 :: table [8 claves]
    Create :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
        up[1] true :: nil (nil)
        up[2] table: 0x2c951632dc2d7e53 :: nil (nil)
        up[3] table: 0x3a38f5c026d4f48f :: nil (nil)
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
    EnableButton :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
        up[1] GuiService :: nil (nil)
    UpdateEnabled :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    __index :: [CICLO]
    _reset :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
        up[1] true :: nil (nil)
        up[2] table: 0x2c951632dc2d7e53 :: nil (nil)
        up[3] table: 0x3a38f5c026d4f48f :: nil (nil)
    _setupConfigurations :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
        up[1] table: 0xc3378097ca8ed510 :: nil (nil)
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
        up[1] table: 0x282fe203369422d1 :: nil (nil)
        up[2] table: 0xc1d16dfb969c59c6 :: nil (nil)
        up[3] table: 0xfa3845683a5992bf :: nil (nil)
  494 :: thread
  495 :: table [12 claves]
    BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
        up[1] ContextActionService :: nil (nil)
    ComputeSteer :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    ComputeThrottle :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
        up[1] ContextActionService :: nil (nil)
    OnSteerLeft :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    OnSteerRight :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    OnThrottleAccel :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    OnThrottleDeccel :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    SetupAutoPilot :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    Update :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
    __index :: [CICLO]
    new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.VehicleController:?]
        up[1] table: 0x648d168ca18d347c :: nil (nil)
  496 :: thread
  497 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  498 :: thread
  499 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  500 :: thread
  501 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  502 :: thread
  503 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  504 :: thread
  505 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  506 :: thread
  507 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  508 :: thread
  509 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  510 :: thread
  511 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  512 :: thread
  513 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  514 :: table [14 claves]
    activeControlModule :: table [15 claves]
      BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] TweenService :: nil (nil)
          up[2] ContextActionService :: nil (nil)
          up[3] 3000 :: nil (nil)
          up[4] UserInputService :: nil (nil)
      Create :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] true :: nil (nil)
          up[2] true :: nil (nil)
          up[3] 7 :: nil (nil)
          up[4] table: 0x524f3086ffd2cb40 :: nil (nil)
          up[5] true :: nil (nil)
          up[6] table: 0x2c951632dc2d7e53 :: nil (nil)
          up[7] Run Service :: nil (nil)
          up[8] UserInputService :: nil (nil)
          up[9] GuiService :: nil (nil)
          up[10] roblox1234dieg :: nil (nil)
      DoFadeInBackground :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] roblox1234dieg :: nil (nil)
      DoMove :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      FadeThumbstick :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] TweenService :: nil (nil)
          up[2] Time:0.15 DelayTime:0 RepeatCount:0 Reverses:False EasingDirection:InOut EasingStyle:Quad :: nil (nil)
          up[3] table: 0x524f3086ffd2cb40 :: nil (nil)
      FadeThumbstickFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      GetIsJumping :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      InputInFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      LayoutMiddleImages :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] 7 :: nil (nil)
      MoveStick :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      OnInputEnded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      UnbindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] ContextActionService :: nil (nil)
      __index :: [CICLO]
      new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
          up[1] table: 0x282fe203369422d1 :: nil (nil)
          up[2] table: 0x61cf561c79f03e07 :: nil (nil)
    activeController :: table [29 claves]
      TouchMovedCon :: userdata
      _connectionUtil :: table [1 claves]
        _connections :: table [0 claves]
      absoluteSizeChangedConn :: userdata
      avatarAbilitiesEnabledChangedConn :: userdata
      enabled :: boolean (true)
      endImage :: userdata <ImageLabel>
      fadeInAndOutBalance :: number (0.05)
      fadeInAndOutHalfDuration :: number (2.5)
      hasFadedBackgroundInLandscape :: boolean (false)
      hasFadedBackgroundInPortrait :: boolean (false)
      isFirstTouch :: boolean (true)
      isJumping :: boolean (false)
      middleImageFadeTweens :: table [0 claves]
      middleImages :: table [7 claves]
        1 :: userdata <ImageLabel>
        2 :: userdata <ImageLabel>
        3 :: userdata <ImageLabel>
        4 :: userdata <ImageLabel>
        5 :: userdata <ImageLabel>
        6 :: userdata <ImageLabel>
        7 :: userdata <ImageLabel>
      middleSize :: number (10)
      middleSpacing :: number (14)
      moveTouchFirstChanged :: boolean (false)
      moveTouchLockedIn :: boolean (false)
      moveVector :: vector
      moveVectorIsCameraRelative :: boolean (true)
      onRenderSteppedConn :: userdata
      onTouchEndedConn :: userdata
      radiusOfDeadZone :: number (2)
      radiusOfMaxSpeed :: number (20)
      startImage :: userdata <ImageLabel>
      thumbstickFrame :: userdata <Frame>
      thumbstickRingSize :: number (20)
      thumbstickSize :: number (45)
      tweenOutAlphaStart :: number (1794133588.7437618)
    controllers :: table [3 claves]
      table: 0x61cf561c79f03e07 :: table [29 claves]
        TouchMovedCon :: userdata
        _connectionUtil :: table [1 claves]
          _connections :: table [0 claves]
        absoluteSizeChangedConn :: userdata
        avatarAbilitiesEnabledChangedConn :: userdata
        enabled :: boolean (true)
        endImage :: userdata <ImageLabel>
        fadeInAndOutBalance :: number (0.05)
        fadeInAndOutHalfDuration :: number (2.5)
        hasFadedBackgroundInLandscape :: boolean (false)
        hasFadedBackgroundInPortrait :: boolean (false)
        isFirstTouch :: boolean (true)
        isJumping :: boolean (false)
        middleImageFadeTweens :: table [0 claves]
        middleImages :: table [7 claves]
          1 :: userdata <ImageLabel>
          2 :: userdata <ImageLabel>
          3 :: userdata <ImageLabel>
          4 :: userdata <ImageLabel>
          5 :: userdata <ImageLabel>
          6 :: userdata <ImageLabel>
          7 :: userdata <ImageLabel>
        middleSize :: number (10)
        middleSpacing :: number (14)
        moveTouchFirstChanged :: boolean (false)
        moveTouchLockedIn :: boolean (false)
        moveVector :: vector
        moveVectorIsCameraRelative :: boolean (true)
        onRenderSteppedConn :: userdata
        onTouchEndedConn :: userdata
        radiusOfDeadZone :: number (2)
        radiusOfMaxSpeed :: number (20)
        startImage :: userdata <ImageLabel>
        thumbstickFrame :: userdata <Frame>
        thumbstickRingSize :: number (20)
        thumbstickSize :: number (45)
        tweenOutAlphaStart :: number (1794133588.7437618)
      table: 0xb65cd005b77041fb :: table [19 claves]
        CONTROL_ACTION_PRIORITY :: number (2000)
        _connectionUtil :: table [1 claves]
          _connections :: table [0 claves]
        backwardValue :: number (0)
        enabled :: boolean (false)
        fingerTouches :: table [0 claves]
        forwardValue :: number (0)
        isJumping :: boolean (false)
        jumpEnabled :: boolean (true)
        keyboardMoveVector :: vector
        leftValue :: number (0)
        mouse2DownPos :: userdata
        mouse2DownTime :: number (1794133588.2893682)
        mouse2UpTime :: number (1794133588.28937)
        moveVector :: vector
        moveVectorIsCameraRelative :: boolean (true)
        numUnsunkTouches :: number (0)
        rightValue :: number (0)
        running :: boolean (false)
        wasdEnabled :: boolean (false)
      table: 0xc1d16dfb969c59c6 :: table [11 claves]
        _active :: boolean (true)
        _connectionUtil :: table [1 claves]
          _connections :: table [6 claves]
            HUMANOID :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            HUMANOID_JUMP_HEIGHT :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            HUMANOID_JUMP_POWER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            HUMANOID_STATE_ENABLED_CHANGED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            JUMP_INPUT_ENDED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            MENU_OPENED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
        absoluteSizeChangedConn :: userdata
        avatarAbilitiesEnabledChangedConn :: userdata
        enabled :: boolean (false)
        externallyEnabled :: boolean (true)
        isJumping :: boolean (false)
        jumpButton :: userdata <ImageButton>
        moveVector :: vector
        moveVectorIsCameraRelative :: boolean (true)
        parentUIFrame :: userdata <Frame>
    controlsEnabled :: boolean (true)
    currentTorsoAngle :: number (0)
    humanoid :: userdata <Humanoid>
    humanoidSeatedConn :: userdata
    inputMoveVector :: vector
    moveFunction :: function [[C]:?]
        up[1] userdata: 0x93d6e9a5833e3c64 :: nil (nil)
    playerGui :: userdata <PlayerGui>
    touchControlFrame :: userdata <Frame>
    touchGui :: userdata <ScreenGui>
    touchJumpController :: table [11 claves]
      _active :: boolean (true)
      _connectionUtil :: table [1 claves]
        _connections :: table [6 claves]
          HUMANOID :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
              up[1] Connection :: nil (nil)
          HUMANOID_JUMP_HEIGHT :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
              up[1] Connection :: nil (nil)
          HUMANOID_JUMP_POWER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
              up[1] Connection :: nil (nil)
          HUMANOID_STATE_ENABLED_CHANGED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
              up[1] Connection :: nil (nil)
          JUMP_INPUT_ENDED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
              up[1] Connection :: nil (nil)
          MENU_OPENED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
              up[1] Connection :: nil (nil)
      absoluteSizeChangedConn :: userdata
      avatarAbilitiesEnabledChangedConn :: userdata
      enabled :: boolean (false)
      externallyEnabled :: boolean (true)
      isJumping :: boolean (false)
      jumpButton :: userdata <ImageButton>
      moveVector :: vector
      moveVectorIsCameraRelative :: boolean (true)
      parentUIFrame :: userdata <Frame>
    vehicleController :: table [10 claves]
      CONTROL_ACTION_PRIORITY :: number (2000)
      acceleration :: number (0)
      autoPilot :: table [2 claves]
        MaxSpeed :: number (0)
        MaxSteeringAngle :: number (0)
      decceleration :: number (0)
      enabled :: boolean (false)
      steer :: number (0)
      throttle :: number (0)
      turningLeft :: number (0)
      turningRight :: number (0)
      vehicleMoveVector :: vector
  515 :: table [2 claves]
    cameras :: table [0 claves]
    controls :: table [14 claves]
      activeControlModule :: table [15 claves]
        BindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] TweenService :: nil (nil)
            up[2] ContextActionService :: nil (nil)
            up[3] 3000 :: nil (nil)
            up[4] UserInputService :: nil (nil)
        Create :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] true :: nil (nil)
            up[2] true :: nil (nil)
            up[3] 7 :: nil (nil)
            up[4] table: 0x524f3086ffd2cb40 :: nil (nil)
            up[5] true :: nil (nil)
            up[6] table: 0x2c951632dc2d7e53 :: nil (nil)
            up[7] Run Service :: nil (nil)
            up[8] UserInputService :: nil (nil)
            up[9] GuiService :: nil (nil)
            up[10] roblox1234dieg :: nil (nil)
        DoFadeInBackground :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] roblox1234dieg :: nil (nil)
        DoMove :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        Enable :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        FadeThumbstick :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] TweenService :: nil (nil)
            up[2] Time:0.15 DelayTime:0 RepeatCount:0 Reverses:False EasingDirection:InOut EasingStyle:Quad :: nil (nil)
            up[3] table: 0x524f3086ffd2cb40 :: nil (nil)
        FadeThumbstickFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        GetIsJumping :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        InputInFrame :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        LayoutMiddleImages :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] 7 :: nil (nil)
        MoveStick :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        OnInputEnded :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
        UnbindContextActions :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] ContextActionService :: nil (nil)
        __index :: [CICLO]
        new :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
            up[1] table: 0x282fe203369422d1 :: nil (nil)
            up[2] table: 0x61cf561c79f03e07 :: nil (nil)
      activeController :: table [29 claves]
        TouchMovedCon :: userdata
        _connectionUtil :: table [1 claves]
          _connections :: table [0 claves]
        absoluteSizeChangedConn :: userdata
        avatarAbilitiesEnabledChangedConn :: userdata
        enabled :: boolean (true)
        endImage :: userdata <ImageLabel>
        fadeInAndOutBalance :: number (0.05)
        fadeInAndOutHalfDuration :: number (2.5)
        hasFadedBackgroundInLandscape :: boolean (false)
        hasFadedBackgroundInPortrait :: boolean (false)
        isFirstTouch :: boolean (true)
        isJumping :: boolean (false)
        middleImageFadeTweens :: table [0 claves]
        middleImages :: table [7 claves]
          1 :: userdata <ImageLabel>
          2 :: userdata <ImageLabel>
          3 :: userdata <ImageLabel>
          4 :: userdata <ImageLabel>
          5 :: userdata <ImageLabel>
          6 :: userdata <ImageLabel>
          7 :: userdata <ImageLabel>
        middleSize :: number (10)
        middleSpacing :: number (14)
        moveTouchFirstChanged :: boolean (false)
        moveTouchLockedIn :: boolean (false)
        moveVector :: vector
        moveVectorIsCameraRelative :: boolean (true)
        onRenderSteppedConn :: userdata
        onTouchEndedConn :: userdata
        radiusOfDeadZone :: number (2)
        radiusOfMaxSpeed :: number (20)
        startImage :: userdata <ImageLabel>
        thumbstickFrame :: userdata <Frame>
        thumbstickRingSize :: number (20)
        thumbstickSize :: number (45)
        tweenOutAlphaStart :: number (1794133588.7437618)
      controllers :: table [3 claves]
        table: 0x61cf561c79f03e07 :: table [29 claves]
          TouchMovedCon :: userdata
          _connectionUtil :: table [1 claves]
            _connections :: table [0 claves]
          absoluteSizeChangedConn :: userdata
          avatarAbilitiesEnabledChangedConn :: userdata
          enabled :: boolean (true)
          endImage :: userdata <ImageLabel>
          fadeInAndOutBalance :: number (0.05)
          fadeInAndOutHalfDuration :: number (2.5)
          hasFadedBackgroundInLandscape :: boolean (false)
          hasFadedBackgroundInPortrait :: boolean (false)
          isFirstTouch :: boolean (true)
          isJumping :: boolean (false)
          middleImageFadeTweens :: table [0 claves]
          middleImages :: table [7 claves]
            1 :: userdata <ImageLabel>
            2 :: userdata <ImageLabel>
            3 :: userdata <ImageLabel>
            4 :: userdata <ImageLabel>
            5 :: userdata <ImageLabel>
            6 :: userdata <ImageLabel>
            7 :: userdata <ImageLabel>
          middleSize :: number (10)
          middleSpacing :: number (14)
          moveTouchFirstChanged :: boolean (false)
          moveTouchLockedIn :: boolean (false)
          moveVector :: vector
          moveVectorIsCameraRelative :: boolean (true)
          onRenderSteppedConn :: userdata
          onTouchEndedConn :: userdata
          radiusOfDeadZone :: number (2)
          radiusOfMaxSpeed :: number (20)
          startImage :: userdata <ImageLabel>
          thumbstickFrame :: userdata <Frame>
          thumbstickRingSize :: number (20)
          thumbstickSize :: number (45)
          tweenOutAlphaStart :: number (1794133588.7437618)
        table: 0xb65cd005b77041fb :: table [19 claves]
          CONTROL_ACTION_PRIORITY :: number (2000)
          _connectionUtil :: table [1 claves]
            _connections :: table [0 claves]
          backwardValue :: number (0)
          enabled :: boolean (false)
          fingerTouches :: table [0 claves]
          forwardValue :: number (0)
          isJumping :: boolean (false)
          jumpEnabled :: boolean (true)
          keyboardMoveVector :: vector
          leftValue :: number (0)
          mouse2DownPos :: userdata
          mouse2DownTime :: number (1794133588.2893682)
          mouse2UpTime :: number (1794133588.28937)
          moveVector :: vector
          moveVectorIsCameraRelative :: boolean (true)
          numUnsunkTouches :: number (0)
          rightValue :: number (0)
          running :: boolean (false)
          wasdEnabled :: boolean (false)
        table: 0xc1d16dfb969c59c6 :: table [11 claves]
          _active :: boolean (true)
          _connectionUtil :: table [1 claves]
            _connections :: table [6 claves]
              HUMANOID :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                  up[1] Connection :: nil (nil)
              HUMANOID_JUMP_HEIGHT :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                  up[1] Connection :: nil (nil)
              HUMANOID_JUMP_POWER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                  up[1] Connection :: nil (nil)
              HUMANOID_STATE_ENABLED_CHANGED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                  up[1] Connection :: nil (nil)
              JUMP_INPUT_ENDED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                  up[1] Connection :: nil (nil)
              MENU_OPENED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                  up[1] Connection :: nil (nil)
          absoluteSizeChangedConn :: userdata
          avatarAbilitiesEnabledChangedConn :: userdata
          enabled :: boolean (false)
          externallyEnabled :: boolean (true)
          isJumping :: boolean (false)
          jumpButton :: userdata <ImageButton>
          moveVector :: vector
          moveVectorIsCameraRelative :: boolean (true)
          parentUIFrame :: userdata <Frame>
      controlsEnabled :: boolean (true)
      currentTorsoAngle :: number (0)
      humanoid :: userdata <Humanoid>
      humanoidSeatedConn :: userdata
      inputMoveVector :: vector
      moveFunction :: function [[C]:?]
          up[1] userdata: 0x93d6e9a5833e3c64 :: nil (nil)
      playerGui :: userdata <PlayerGui>
      touchControlFrame :: userdata <Frame>
      touchGui :: userdata <ScreenGui>
      touchJumpController :: table [11 claves]
        _active :: boolean (true)
        _connectionUtil :: table [1 claves]
          _connections :: table [6 claves]
            HUMANOID :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            HUMANOID_JUMP_HEIGHT :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            HUMANOID_JUMP_POWER :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            HUMANOID_STATE_ENABLED_CHANGED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            JUMP_INPUT_ENDED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
            MENU_OPENED :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.ConnectionUtil:?]
                up[1] Connection :: nil (nil)
        absoluteSizeChangedConn :: userdata
        avatarAbilitiesEnabledChangedConn :: userdata
        enabled :: boolean (false)
        externallyEnabled :: boolean (true)
        isJumping :: boolean (false)
        jumpButton :: userdata <ImageButton>
        moveVector :: vector
        moveVectorIsCameraRelative :: boolean (true)
        parentUIFrame :: userdata <Frame>
      vehicleController :: table [10 claves]
        CONTROL_ACTION_PRIORITY :: number (2000)
        acceleration :: number (0)
        autoPilot :: table [2 claves]
          MaxSpeed :: number (0)
          MaxSteeringAngle :: number (0)
        decceleration :: number (0)
        enabled :: boolean (false)
        steer :: number (0)
        throttle :: number (0)
        turningLeft :: number (0)
        turningRight :: number (0)
        vehicleMoveVector :: vector
  516 :: thread
  517 :: thread
  518 :: thread
  519 :: thread
  520 :: thread
  521 :: thread
  522 :: thread
  523 :: thread
  524 :: thread
  525 :: thread
  526 :: thread
  527 :: thread
  528 :: thread
  529 :: thread
  530 :: thread
  531 :: thread
  532 :: thread
  533 :: thread
  534 :: thread
  535 :: thread
  536 :: thread
  537 :: thread
  538 :: thread
  539 :: thread
  540 :: thread
  541 :: thread
  542 :: thread
  543 :: thread
  544 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconButton :: nil (nil)
  545 :: thread
  546 :: function [ReplicatedStorage.bar.Icon.Elements.Menu:?]
  547 :: thread
  548 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
  549 :: thread
  550 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
  551 :: thread
  552 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
      up[1] Connection :: nil (nil)
  553 :: thread
  554 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] roblox1234dieg :: nil (nil)
      up[2] es-es :: nil (nil)
      up[3] table: 0x4f81edc7a348b696 :: nil (nil)
  555 :: thread
  556 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] IconImage :: nil (nil)
      up[2] IconImageScale :: nil (nil)
  557 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  558 :: thread
  559 :: thread
  560 :: thread
  561 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Widget :: nil (nil)
      up[3] Widget :: nil (nil)
  562 :: thread
  563 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  564 :: thread
  565 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] MenuUIListLayout :: nil (nil)
      up[3] MenuUIListLayout :: nil (nil)
  566 :: thread
  567 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] MenuGap :: nil (nil)
      up[3] MenuGap :: nil (nil)
  568 :: thread
  569 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  570 :: thread
  571 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] OverlayUICorner :: nil (nil)
      up[3] OverlayUICorner :: nil (nil)
  572 :: thread
  573 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconOverlay :: nil (nil)
      up[3] IconOverlay :: nil (nil)
  574 :: thread
  575 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  576 :: thread
  577 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] ClickRegion :: nil (nil)
      up[3] ClickRegion :: nil (nil)
  578 :: thread
  579 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] ContentsList :: nil (nil)
      up[3] ContentsList :: nil (nil)
  580 :: thread
  581 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] PaddingLeft :: nil (nil)
      up[3] PaddingLeft :: nil (nil)
  582 :: thread
  583 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] PaddingCenter :: nil (nil)
      up[3] PaddingCenter :: nil (nil)
  584 :: thread
  585 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] PaddingRight :: nil (nil)
      up[3] PaddingRight :: nil (nil)
  586 :: thread
  587 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconLabel :: nil (nil)
      up[3] IconLabel :: nil (nil)
  588 :: thread
  589 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconLabelContainer :: nil (nil)
      up[3] IconLabelContainer :: nil (nil)
  590 :: thread
  591 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconImageCorner :: nil (nil)
      up[3] IconImageCorner :: nil (nil)
  592 :: thread
  593 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconImageScale :: nil (nil)
      up[3] IconImageScale :: nil (nil)
  594 :: thread
  595 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconImageRatio :: nil (nil)
      up[3] IconImageRatio :: nil (nil)
  596 :: thread
  597 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconImage :: nil (nil)
      up[3] IconImage :: nil (nil)
  598 :: thread
  599 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Contents :: nil (nil)
      up[3] Contents :: nil (nil)
  600 :: thread
  601 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconSpotGradient :: nil (nil)
      up[3] IconSpotGradient :: nil (nil)
  602 :: thread
  603 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconSpot :: nil (nil)
      up[3] IconSpot :: nil (nil)
  604 :: thread
  605 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Menu :: nil (nil)
      up[3] Menu :: nil (nil)
  606 :: thread
  607 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconGradient :: nil (nil)
      up[3] IconGradient :: nil (nil)
  608 :: thread
  609 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] IconButton :: nil (nil)
      up[3] IconButton :: nil (nil)
  610 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  611 :: thread
  612 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  613 :: thread
  614 :: thread
  615 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  616 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  617 :: thread
  618 :: thread
  619 :: thread
  620 :: function [ReplicatedStorage.bar.Icon:?]
  621 :: thread
  622 :: function [ReplicatedStorage.bar.Icon:?]
  623 :: thread
  624 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] 0 :: nil (nil)
  625 :: thread
  626 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] UserInputService :: nil (nil)
      up[2] table: 0x2f8010ca713e8d8e :: nil (nil)
      up[3] table: 0x4f81edc7a348b696 :: nil (nil)
  627 :: thread
  628 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
  629 :: thread
  630 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
  631 :: thread
  632 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
  633 :: thread
  634 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
  635 :: thread
  636 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] UserInputService :: nil (nil)
      up[3] table: 0x2f8010ca713e8d8e :: nil (nil)
      up[4] 0 :: nil (nil)
  637 :: thread
  638 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] 0 :: nil (nil)
  639 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  640 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  641 :: thread
  642 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] PaddingRight :: nil (nil)
      up[3] PaddingRight :: nil (nil)
  643 :: thread
  644 :: thread
  645 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  646 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] 0.152941, 0.160784, 0.188235 :: nil (nil)
  647 :: thread
  648 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] DropShadow :: nil (nil)
      up[2] Box :: nil (nil)
  649 :: thread
  650 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] table: 0xb221d652658ed4a0 :: nil (nil)
  651 :: thread
  652 :: function [ReplicatedStorage.bar.Icon.Utility:?]
  653 :: thread
  654 :: thread
  655 :: thread
  656 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] table: 0x9e528d4dceb82729 :: nil (nil)
      up[2] Caption :: nil (nil)
  657 :: thread
  658 :: function [ReplicatedStorage.bar.Icon.Utility:?]
  659 :: thread
  660 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] function: 0x68bdae5001b662fb :: nil (nil)
  661 :: thread
  662 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] true :: nil (nil)
  663 :: thread
  664 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] function: 0x68bdae5001b662fb :: nil (nil)
  665 :: thread
  666 :: function [ReplicatedStorage.bar.Icon.Utility:?]
  667 :: thread
  668 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] Caption :: nil (nil)
      up[2] Caption :: nil (nil)
  669 :: thread
  670 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] Caption :: nil (nil)
      up[2] Caption :: nil (nil)
  671 :: thread
  672 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] UserInputService :: nil (nil)
      up[2] Caption :: nil (nil)
      up[3] table: 0x4f81edc7a348b696 :: nil (nil)
      up[4] Header :: nil (nil)
      up[5] LabelContent :: nil (nil)
      up[6] Hotkeys :: nil (nil)
  673 :: thread
  674 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] function: 0x661d669631725662 :: nil (nil)
  675 :: thread
  676 :: thread
  677 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  678 :: thread
  679 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconButton :: nil (nil)
  680 :: thread
  681 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
  682 :: thread
  683 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
  684 :: thread
  685 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
      up[1] Connection :: nil (nil)
  686 :: thread
  687 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] roblox1234dieg :: nil (nil)
      up[2] es-es :: nil (nil)
      up[3] table: 0xe174e6d8ceba7991 :: nil (nil)
  688 :: thread
  689 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] IconImage :: nil (nil)
      up[2] IconImageScale :: nil (nil)
  690 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  691 :: thread
  692 :: thread
  693 :: thread
  694 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Widget :: nil (nil)
      up[3] Widget :: nil (nil)
  695 :: thread
  696 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  697 :: thread
  698 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] MenuUIListLayout :: nil (nil)
      up[3] MenuUIListLayout :: nil (nil)
  699 :: thread
  700 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] MenuGap :: nil (nil)
      up[3] MenuGap :: nil (nil)
  701 :: thread
  702 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  703 :: thread
  704 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] OverlayUICorner :: nil (nil)
      up[3] OverlayUICorner :: nil (nil)
  705 :: thread
  706 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconOverlay :: nil (nil)
      up[3] IconOverlay :: nil (nil)
  707 :: thread
  708 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  709 :: thread
  710 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] ClickRegion :: nil (nil)
      up[3] ClickRegion :: nil (nil)
  711 :: thread
  712 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] ContentsList :: nil (nil)
      up[3] ContentsList :: nil (nil)
  713 :: thread
  714 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] PaddingLeft :: nil (nil)
      up[3] PaddingLeft :: nil (nil)
  715 :: thread
  716 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] PaddingCenter :: nil (nil)
      up[3] PaddingCenter :: nil (nil)
  717 :: thread
  718 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] PaddingRight :: nil (nil)
      up[3] PaddingRight :: nil (nil)
  719 :: thread
  720 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconLabel :: nil (nil)
      up[3] IconLabel :: nil (nil)
  721 :: thread
  722 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconLabelContainer :: nil (nil)
      up[3] IconLabelContainer :: nil (nil)
  723 :: thread
  724 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconImageCorner :: nil (nil)
      up[3] IconImageCorner :: nil (nil)
  725 :: thread
  726 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconImageScale :: nil (nil)
      up[3] IconImageScale :: nil (nil)
  727 :: thread
  728 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconImageRatio :: nil (nil)
      up[3] IconImageRatio :: nil (nil)
  729 :: thread
  730 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconImage :: nil (nil)
      up[3] IconImage :: nil (nil)
  731 :: thread
  732 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Contents :: nil (nil)
      up[3] Contents :: nil (nil)
  733 :: thread
  734 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconSpotGradient :: nil (nil)
      up[3] IconSpotGradient :: nil (nil)
  735 :: thread
  736 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconSpot :: nil (nil)
      up[3] IconSpot :: nil (nil)
  737 :: thread
  738 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Menu :: nil (nil)
      up[3] Menu :: nil (nil)
  739 :: thread
  740 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconGradient :: nil (nil)
      up[3] IconGradient :: nil (nil)
  741 :: thread
  742 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] IconButton :: nil (nil)
      up[3] IconButton :: nil (nil)
  743 :: thread
  744 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  745 :: thread
  746 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  747 :: thread
  748 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
  749 :: thread
  750 :: function [ReplicatedStorage.bar.Icon.Elements.Indicator:?]
  751 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  752 :: thread
  753 :: function [ReplicatedStorage.bar.Icon:?]
  754 :: thread
  755 :: function [ReplicatedStorage.bar.Icon:?]
  756 :: thread
  757 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] 0 :: nil (nil)
  758 :: thread
  759 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] UserInputService :: nil (nil)
      up[2] table: 0x2f8010ca713e8d8e :: nil (nil)
      up[3] table: 0xe174e6d8ceba7991 :: nil (nil)
  760 :: thread
  761 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
  762 :: thread
  763 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
  764 :: thread
  765 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
  766 :: thread
  767 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
  768 :: thread
  769 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] UserInputService :: nil (nil)
      up[3] table: 0x2f8010ca713e8d8e :: nil (nil)
      up[4] 0 :: nil (nil)
  770 :: thread
  771 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] 0 :: nil (nil)
  772 :: thread
  773 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  774 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  775 :: thread
  776 :: thread
  777 :: thread
  778 :: thread
  779 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] DropShadow :: nil (nil)
      up[2] Box :: nil (nil)
  780 :: thread
  781 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] table: 0xfbe3890b6ffc8ed8 :: nil (nil)
  782 :: thread
  783 :: function [ReplicatedStorage.bar.Icon.Utility:?]
  784 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  785 :: thread
  786 :: thread
  787 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] table: 0x9e528d4dceb82729 :: nil (nil)
      up[2] Caption :: nil (nil)
  788 :: thread
  789 :: function [ReplicatedStorage.bar.Icon.Utility:?]
  790 :: thread
  791 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] function: 0xc016cdd371d23d6c :: nil (nil)
  792 :: thread
  793 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] true :: nil (nil)
  794 :: thread
  795 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] function: 0xc016cdd371d23d6c :: nil (nil)
  796 :: thread
  797 :: function [ReplicatedStorage.bar.Icon.Utility:?]
  798 :: thread
  799 :: function [ReplicatedStorage.bar.Icon.Utility:?]
      up[1] Caption :: nil (nil)
      up[2] Caption :: nil (nil)
  800 :: thread
  801 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] Caption :: nil (nil)
      up[2] Caption :: nil (nil)
  802 :: thread
  803 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] UserInputService :: nil (nil)
      up[2] Caption :: nil (nil)
      up[3] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[4] Header :: nil (nil)
      up[5] LabelContent :: nil (nil)
      up[6] Hotkeys :: nil (nil)
  804 :: thread
  805 :: function [ReplicatedStorage.bar.Icon.Elements.Caption:?]
      up[1] function: 0xa27035b74a80ef1f :: nil (nil)
  806 :: thread
  807 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tos :: nil (nil)
  808 :: thread
  809 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  810 :: thread
  811 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  812 :: thread
  813 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  814 :: thread
  815 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0xe2d137fb11d3bea5 :: nil (nil)
  816 :: thread
  817 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  818 :: thread
  819 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  820 :: thread
  821 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] maps :: nil (nil)
      up[2] main :: nil (nil)
  822 :: thread
  823 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  824 :: thread
  825 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  826 :: thread
  827 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0xc0bad27d6f873d3c :: nil (nil)
  828 :: thread
  829 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  830 :: thread
  831 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  832 :: thread
  833 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x7f8f7498b4bd874c :: nil (nil)
  834 :: thread
  835 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  836 :: thread
  837 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  838 :: thread
  839 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0xab4a5424b683f258 :: nil (nil)
  840 :: thread
  841 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  842 :: thread
  843 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  844 :: thread
  845 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  846 :: thread
  847 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  848 :: thread
  849 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  850 :: thread
  851 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] baseplate :: nil (nil)
      up[2] main :: nil (nil)
  852 :: thread
  853 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  854 :: thread
  855 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  856 :: thread
  857 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x00f8886865ad4745 :: nil (nil)
  858 :: thread
  859 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  860 :: thread
  861 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  862 :: thread
  863 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x8556613e807cc622 :: nil (nil)
  864 :: thread
  865 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  866 :: thread
  867 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  868 :: thread
  869 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0xc23a914771a75456 :: nil (nil)
  870 :: thread
  871 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  872 :: thread
  873 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  874 :: thread
  875 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0xdf1de7b1f3b65599 :: nil (nil)
  876 :: thread
  877 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  878 :: thread
  879 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  880 :: thread
  881 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x5c18b82c5bcbe364 :: nil (nil)
  882 :: thread
  883 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  884 :: thread
  885 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  886 :: thread
  887 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x8c30281ddbb6de8c :: nil (nil)
  888 :: thread
  889 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  890 :: thread
  891 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  892 :: thread
  893 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x614a32bca65f9740 :: nil (nil)
  894 :: thread
  895 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  896 :: thread
  897 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  898 :: thread
  899 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] lighting :: nil (nil)
      up[2] main :: nil (nil)
  900 :: thread
  901 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  902 :: thread
  903 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  904 :: thread
  905 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0xed16c5d1e9b017de :: nil (nil)
  906 :: thread
  907 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  908 :: thread
  909 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  910 :: thread
  911 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x604b623151f09974 :: nil (nil)
  912 :: thread
  913 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  914 :: thread
  915 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  916 :: thread
  917 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x17116e235b5f7bbf :: nil (nil)
  918 :: thread
  919 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  920 :: thread
  921 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  922 :: thread
  923 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x17cafbed2a0b0fbe :: nil (nil)
  924 :: thread
  925 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  926 :: thread
  927 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  928 :: thread
  929 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] function: 0x4a7e4b13769a8366 :: nil (nil)
  930 :: thread
  931 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  932 :: thread
  933 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] Tween :: nil (nil)
  934 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconLabel :: nil (nil)
      up[3] IconLabel :: nil (nil)
  935 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] ContentsList :: nil (nil)
      up[3] ContentsList :: nil (nil)
  936 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  937 :: thread
  938 :: thread
  939 :: thread
  940 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule:?]
      up[1] table: 0xabf3ebd682b499bd :: nil (nil)
  941 :: thread
  942 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.AvatarAbilitiesInterface:?]
  943 :: thread
  944 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.AvatarAbilitiesInterface:?]
      up[1] Event :: nil (nil)
  945 :: thread
  946 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
      up[2] true :: nil (nil)
      up[3] table: 0x2c951632dc2d7e53 :: nil (nil)
      up[4] table: 0x3a38f5c026d4f48f :: nil (nil)
  947 :: thread
  948 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
      up[2] true :: nil (nil)
      up[3] table: 0x2c951632dc2d7e53 :: nil (nil)
      up[4] table: 0x3a38f5c026d4f48f :: nil (nil)
  949 :: thread
  950 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
      up[2] true :: nil (nil)
      up[3] table: 0x2c951632dc2d7e53 :: nil (nil)
      up[4] table: 0x3a38f5c026d4f48f :: nil (nil)
  951 :: thread
  952 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
  953 :: thread
  954 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
  955 :: thread
  956 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
  957 :: thread
  958 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
  959 :: thread
  960 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
  961 :: thread
  962 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
      up[1] Humanoid :: nil (nil)
      up[2] Humanoid :: nil (nil)
      up[3] table: 0xc3378097ca8ed510 :: nil (nil)
  963 :: thread
  964 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
      up[1] table: 0xc3378097ca8ed510 :: nil (nil)
  965 :: thread
  966 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
      up[1] table: 0xc3378097ca8ed510 :: nil (nil)
  967 :: thread
  968 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
      up[1] table: 0xc3378097ca8ed510 :: nil (nil)
      up[2] function: 0xbf960b91223bd29d :: nil (nil)
  969 :: thread
  970 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CommonUtils.CharacterUtil:?]
      up[1] table: 0xc3378097ca8ed510 :: nil (nil)
      up[2] Humanoid :: nil (nil)
      up[3] Humanoid :: nil (nil)
      up[4] function: 0x427907ed50860396 :: nil (nil)
  971 :: thread
  972 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.TouchJump:?]
      up[1] table: 0xb88a969376d93282 :: nil (nil)
      up[2] function: 0x72d25906dcb7d61e :: nil (nil)
  973 :: thread
  974 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] TouchControlFrame :: nil (nil)
      up[2] true :: nil (nil)
      up[3] true :: nil (nil)
      up[4] table: 0x2c951632dc2d7e53 :: nil (nil)
      up[5] table: 0x44ed4954ac5e709c :: nil (nil)
      up[6] 100 :: nil (nil)
  975 :: thread
  976 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] TouchControlFrame :: nil (nil)
      up[2] true :: nil (nil)
      up[3] true :: nil (nil)
      up[4] table: 0x2c951632dc2d7e53 :: nil (nil)
      up[5] table: 0x44ed4954ac5e709c :: nil (nil)
      up[6] 100 :: nil (nil)
  977 :: thread
  978 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] Connection :: nil (nil)
      up[2] function: 0xb1cacf9dd513a59f :: nil (nil)
  979 :: thread
  980 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] Camera :: nil (nil)
      up[2] function: 0xb1cacf9dd513a59f :: nil (nil)
  981 :: thread
  982 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] table: 0x44ed4954ac5e709c :: nil (nil)
  983 :: thread
  984 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] table: 0x44ed4954ac5e709c :: nil (nil)
  985 :: thread
  986 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] table: 0x44ed4954ac5e709c :: nil (nil)
  987 :: thread
  988 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] true :: nil (nil)
      up[2] PlayerGui :: nil (nil)
      up[3] Connection :: nil (nil)
      up[4] table: 0x44ed4954ac5e709c :: nil (nil)
  989 :: thread
  990 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] function: 0xaf092fb6cac9c3a7 :: nil (nil)
      up[2] table: 0x44ed4954ac5e709c :: nil (nil)
  991 :: thread
  992 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.ControlModule.DynamicThumbstick:?]
      up[1] function: 0x28b381aed2e514de :: nil (nil)
  993 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  994 :: thread
  995 :: thread
  996 :: thread
  997 :: thread
  998 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0x0dc21049be7f5e25 :: nil (nil)
      up[2] Enum.HumanoidStateType.Running :: nil (nil)
      up[3] table: 0x43524c0c0faab15e :: nil (nil)
  999 :: thread
  1000 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds:?]
      up[1] table: 0xa1c2b9a04fe81944 :: nil (nil)
      up[2] table: 0xb91a8941eed1e2c5 :: nil (nil)
      up[3] HumanoidRootPart :: nil (nil)
  1001 :: thread
  1002 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0xde6e2c037f44001f :: nil (nil)
      up[2] function: 0x443a551d08774ca4 :: nil (nil)
  1003 :: thread
  1004 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0xde6e2c037f44001f :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] roblox1234dieg :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x7bd665a78deb4a6e :: nil (nil)
      up[6] roblox1234dieg :: nil (nil)
      up[7] function: 0x443a551d08774ca4 :: nil (nil)
  1005 :: thread
  1006 :: thread
  1007 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
      up[1] table: 0x20d679cb11e8ff99 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
  1008 :: thread
  1009 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.TransparencyController:?]
      up[1] table: 0x20d679cb11e8ff99 :: nil (nil)
  1010 :: thread
  1011 :: thread
  1012 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1013 :: thread
  1014 :: thread
  1015 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1016 :: thread
  1017 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1018 :: thread
  1019 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1020 :: thread
  1021 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1022 :: thread
  1023 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0xeb12f4d686b402de :: nil (nil)
      up[2] function: 0xe969faff37c66e64 :: nil (nil)
  1024 :: thread
  1025 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0xeb12f4d686b402de :: nil (nil)
      up[2] function: 0xe969faff37c66e64 :: nil (nil)
  1026 :: thread
  1027 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0xc9d2fba664a21203 :: nil (nil)
  1028 :: thread
  1029 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] Event :: nil (nil)
  1030 :: thread
  1031 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] function: 0x6e9500c40c9ece50 :: nil (nil)
      up[2] 1 :: nil (nil)
  1032 :: thread
  1033 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] function: 0x2534cb95358d50c7 :: nil (nil)
      up[2] table: 0x0153d63bcd9571dd :: nil (nil)
  1034 :: thread
  1035 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] function: 0x00648b3bda8d5498 :: nil (nil)
      up[2] 1 :: nil (nil)
  1036 :: thread
  1037 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0x0153d63bcd9571dd :: nil (nil)
  1038 :: thread
  1039 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.CameraInput:?]
      up[1] table: 0x61ec7252da065266 :: nil (nil)
  1040 :: thread
  1041 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1042 :: thread
  1043 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1044 :: thread
  1045 :: function [Players.roblox1234dieg.PlayerScripts.PlayerModule.CameraModule.BaseCamera:?]
      up[1] table: 0xaf3574809b297910 :: nil (nil)
  1046 :: thread
  1047 :: thread
  1048 :: thread
  1049 :: thread
  1050 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Connection :: nil (nil)
  1051 :: thread
  1052 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] table: 0x40cb17fbbf654afc :: nil (nil)
  1053 :: thread
  1054 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] table: 0x40cb17fbbf654afc :: nil (nil)
  1055 :: thread
  1056 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toollunge :: nil (nil)
      up[2] table: 0x6092f1c1593b7a92 :: nil (nil)
  1057 :: thread
  1058 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toollunge :: nil (nil)
      up[2] table: 0x6092f1c1593b7a92 :: nil (nil)
  1059 :: thread
  1060 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toollunge :: nil (nil)
      up[2] table: 0x6092f1c1593b7a92 :: nil (nil)
  1061 :: thread
  1062 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toollunge :: nil (nil)
      up[2] table: 0x6092f1c1593b7a92 :: nil (nil)
  1063 :: thread
  1064 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toollunge :: nil (nil)
      up[2] table: 0x6092f1c1593b7a92 :: nil (nil)
  1065 :: thread
  1066 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] climb :: nil (nil)
      up[2] table: 0xe5e51487f8acea4c :: nil (nil)
  1067 :: thread
  1068 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] climb :: nil (nil)
      up[2] table: 0xe5e51487f8acea4c :: nil (nil)
  1069 :: thread
  1070 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] climb :: nil (nil)
      up[2] table: 0xe5e51487f8acea4c :: nil (nil)
  1071 :: thread
  1072 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] climb :: nil (nil)
      up[2] table: 0xe5e51487f8acea4c :: nil (nil)
  1073 :: thread
  1074 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] climb :: nil (nil)
      up[2] table: 0xe5e51487f8acea4c :: nil (nil)
  1075 :: thread
  1076 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] cheer :: nil (nil)
      up[2] table: 0xf2bb490255949924 :: nil (nil)
  1077 :: thread
  1078 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] cheer :: nil (nil)
      up[2] table: 0xf2bb490255949924 :: nil (nil)
  1079 :: thread
  1080 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] cheer :: nil (nil)
      up[2] table: 0xf2bb490255949924 :: nil (nil)
  1081 :: thread
  1082 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] cheer :: nil (nil)
      up[2] table: 0xf2bb490255949924 :: nil (nil)
  1083 :: thread
  1084 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] cheer :: nil (nil)
      up[2] table: 0xf2bb490255949924 :: nil (nil)
  1085 :: thread
  1086 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1087 :: thread
  1088 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1089 :: thread
  1090 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1091 :: thread
  1092 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1093 :: thread
  1094 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1095 :: thread
  1096 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1097 :: thread
  1098 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1099 :: thread
  1100 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1101 :: thread
  1102 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1103 :: thread
  1104 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1105 :: thread
  1106 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance3 :: nil (nil)
      up[2] table: 0x59b2af8c0055a6fa :: nil (nil)
  1107 :: thread
  1108 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolnone :: nil (nil)
      up[2] table: 0x4f6d2ced79f4b901 :: nil (nil)
  1109 :: thread
  1110 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolnone :: nil (nil)
      up[2] table: 0x4f6d2ced79f4b901 :: nil (nil)
  1111 :: thread
  1112 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolnone :: nil (nil)
      up[2] table: 0x4f6d2ced79f4b901 :: nil (nil)
  1113 :: thread
  1114 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolnone :: nil (nil)
      up[2] table: 0x4f6d2ced79f4b901 :: nil (nil)
  1115 :: thread
  1116 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolnone :: nil (nil)
      up[2] table: 0x4f6d2ced79f4b901 :: nil (nil)
  1117 :: thread
  1118 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1119 :: thread
  1120 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1121 :: thread
  1122 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1123 :: thread
  1124 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1125 :: thread
  1126 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1127 :: thread
  1128 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1129 :: thread
  1130 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1131 :: thread
  1132 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1133 :: thread
  1134 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1135 :: thread
  1136 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1137 :: thread
  1138 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance :: nil (nil)
      up[2] table: 0xd77357309ad43042 :: nil (nil)
  1139 :: thread
  1140 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swimidle :: nil (nil)
      up[2] table: 0xef659a046f805ea6 :: nil (nil)
  1141 :: thread
  1142 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swimidle :: nil (nil)
      up[2] table: 0xef659a046f805ea6 :: nil (nil)
  1143 :: thread
  1144 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swimidle :: nil (nil)
      up[2] table: 0xef659a046f805ea6 :: nil (nil)
  1145 :: thread
  1146 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swimidle :: nil (nil)
      up[2] table: 0xef659a046f805ea6 :: nil (nil)
  1147 :: thread
  1148 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swimidle :: nil (nil)
      up[2] table: 0xef659a046f805ea6 :: nil (nil)
  1149 :: thread
  1150 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] fall :: nil (nil)
      up[2] table: 0x43e9bef844b53cb4 :: nil (nil)
  1151 :: thread
  1152 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] fall :: nil (nil)
      up[2] table: 0x43e9bef844b53cb4 :: nil (nil)
  1153 :: thread
  1154 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] fall :: nil (nil)
      up[2] table: 0x43e9bef844b53cb4 :: nil (nil)
  1155 :: thread
  1156 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] fall :: nil (nil)
      up[2] table: 0x43e9bef844b53cb4 :: nil (nil)
  1157 :: thread
  1158 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] fall :: nil (nil)
      up[2] table: 0x43e9bef844b53cb4 :: nil (nil)
  1159 :: thread
  1160 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] laugh :: nil (nil)
      up[2] table: 0xcde1fafa45e344bb :: nil (nil)
  1161 :: thread
  1162 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] laugh :: nil (nil)
      up[2] table: 0xcde1fafa45e344bb :: nil (nil)
  1163 :: thread
  1164 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] laugh :: nil (nil)
      up[2] table: 0xcde1fafa45e344bb :: nil (nil)
  1165 :: thread
  1166 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] laugh :: nil (nil)
      up[2] table: 0xcde1fafa45e344bb :: nil (nil)
  1167 :: thread
  1168 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] laugh :: nil (nil)
      up[2] table: 0xcde1fafa45e344bb :: nil (nil)
  1169 :: thread
  1170 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1171 :: thread
  1172 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1173 :: thread
  1174 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1175 :: thread
  1176 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1177 :: thread
  1178 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1179 :: thread
  1180 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1181 :: thread
  1182 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1183 :: thread
  1184 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
      up[2] table: 0x444f7bb8af11877b :: nil (nil)
  1185 :: thread
  1186 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] jump :: nil (nil)
      up[2] table: 0x25443524d0b31fe0 :: nil (nil)
  1187 :: thread
  1188 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] jump :: nil (nil)
      up[2] table: 0x25443524d0b31fe0 :: nil (nil)
  1189 :: thread
  1190 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] jump :: nil (nil)
      up[2] table: 0x25443524d0b31fe0 :: nil (nil)
  1191 :: thread
  1192 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] jump :: nil (nil)
      up[2] table: 0x25443524d0b31fe0 :: nil (nil)
  1193 :: thread
  1194 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] jump :: nil (nil)
      up[2] table: 0x25443524d0b31fe0 :: nil (nil)
  1195 :: thread
  1196 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] sit :: nil (nil)
      up[2] table: 0x1cb5eff523f14e3d :: nil (nil)
  1197 :: thread
  1198 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] sit :: nil (nil)
      up[2] table: 0x1cb5eff523f14e3d :: nil (nil)
  1199 :: thread
  1200 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] sit :: nil (nil)
      up[2] table: 0x1cb5eff523f14e3d :: nil (nil)
  1201 :: thread
  1202 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] sit :: nil (nil)
      up[2] table: 0x1cb5eff523f14e3d :: nil (nil)
  1203 :: thread
  1204 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] sit :: nil (nil)
      up[2] table: 0x1cb5eff523f14e3d :: nil (nil)
  1205 :: thread
  1206 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] run :: nil (nil)
      up[2] table: 0x8955c1a527d10974 :: nil (nil)
  1207 :: thread
  1208 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] run :: nil (nil)
      up[2] table: 0x8955c1a527d10974 :: nil (nil)
  1209 :: thread
  1210 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] run :: nil (nil)
      up[2] table: 0x8955c1a527d10974 :: nil (nil)
  1211 :: thread
  1212 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] run :: nil (nil)
      up[2] table: 0x8955c1a527d10974 :: nil (nil)
  1213 :: thread
  1214 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] run :: nil (nil)
      up[2] table: 0x8955c1a527d10974 :: nil (nil)
  1215 :: thread
  1216 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swim :: nil (nil)
      up[2] table: 0xc375dbb679507874 :: nil (nil)
  1217 :: thread
  1218 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swim :: nil (nil)
      up[2] table: 0xc375dbb679507874 :: nil (nil)
  1219 :: thread
  1220 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swim :: nil (nil)
      up[2] table: 0xc375dbb679507874 :: nil (nil)
  1221 :: thread
  1222 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swim :: nil (nil)
      up[2] table: 0xc375dbb679507874 :: nil (nil)
  1223 :: thread
  1224 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] swim :: nil (nil)
      up[2] table: 0xc375dbb679507874 :: nil (nil)
  1225 :: thread
  1226 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] wave :: nil (nil)
      up[2] table: 0xd1ae622fc9209a19 :: nil (nil)
  1227 :: thread
  1228 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] wave :: nil (nil)
      up[2] table: 0xd1ae622fc9209a19 :: nil (nil)
  1229 :: thread
  1230 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] wave :: nil (nil)
      up[2] table: 0xd1ae622fc9209a19 :: nil (nil)
  1231 :: thread
  1232 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] wave :: nil (nil)
      up[2] table: 0xd1ae622fc9209a19 :: nil (nil)
  1233 :: thread
  1234 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] wave :: nil (nil)
      up[2] table: 0xd1ae622fc9209a19 :: nil (nil)
  1235 :: thread
  1236 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolslash :: nil (nil)
      up[2] table: 0x80ce5ba8c9f98a41 :: nil (nil)
  1237 :: thread
  1238 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolslash :: nil (nil)
      up[2] table: 0x80ce5ba8c9f98a41 :: nil (nil)
  1239 :: thread
  1240 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolslash :: nil (nil)
      up[2] table: 0x80ce5ba8c9f98a41 :: nil (nil)
  1241 :: thread
  1242 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolslash :: nil (nil)
      up[2] table: 0x80ce5ba8c9f98a41 :: nil (nil)
  1243 :: thread
  1244 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] toolslash :: nil (nil)
      up[2] table: 0x80ce5ba8c9f98a41 :: nil (nil)
  1245 :: thread
  1246 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1247 :: thread
  1248 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1249 :: thread
  1250 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1251 :: thread
  1252 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1253 :: thread
  1254 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1255 :: thread
  1256 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1257 :: thread
  1258 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1259 :: thread
  1260 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1261 :: thread
  1262 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1263 :: thread
  1264 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1265 :: thread
  1266 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] dance2 :: nil (nil)
      up[2] table: 0x7d144c85b7ebe6e8 :: nil (nil)
  1267 :: thread
  1268 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] point :: nil (nil)
      up[2] table: 0x9a1d8f63b2ec82d0 :: nil (nil)
  1269 :: thread
  1270 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] point :: nil (nil)
      up[2] table: 0x9a1d8f63b2ec82d0 :: nil (nil)
  1271 :: thread
  1272 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] point :: nil (nil)
      up[2] table: 0x9a1d8f63b2ec82d0 :: nil (nil)
  1273 :: thread
  1274 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] point :: nil (nil)
      up[2] table: 0x9a1d8f63b2ec82d0 :: nil (nil)
  1275 :: thread
  1276 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] point :: nil (nil)
      up[2] table: 0x9a1d8f63b2ec82d0 :: nil (nil)
  1277 :: thread
  1278 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] walk :: nil (nil)
      up[2] table: 0x92ac62c812358e48 :: nil (nil)
  1279 :: thread
  1280 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] walk :: nil (nil)
      up[2] table: 0x92ac62c812358e48 :: nil (nil)
  1281 :: thread
  1282 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] walk :: nil (nil)
      up[2] table: 0x92ac62c812358e48 :: nil (nil)
  1283 :: thread
  1284 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] walk :: nil (nil)
      up[2] table: 0x92ac62c812358e48 :: nil (nil)
  1285 :: thread
  1286 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] walk :: nil (nil)
      up[2] table: 0x92ac62c812358e48 :: nil (nil)
  1287 :: thread
  1288 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
  1289 :: thread
  1290 :: function [Workspace.roblox1234dieg.Animate:?]
  1291 :: thread
  1292 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Humanoid :: nil (nil)
      up[2] 0 :: nil (nil)
      up[3] Standing :: nil (nil)
  1293 :: thread
  1294 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Humanoid :: nil (nil)
      up[2] Standing :: nil (nil)
  1295 :: thread
  1296 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
  1297 :: thread
  1298 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] 0 :: nil (nil)
      up[2] Humanoid :: nil (nil)
      up[3] Standing :: nil (nil)
  1299 :: thread
  1300 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
  1301 :: thread
  1302 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
  1303 :: thread
  1304 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
  1305 :: thread
  1306 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Humanoid :: nil (nil)
      up[2] Standing :: nil (nil)
  1307 :: thread
  1308 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
      up[2] table: 0x1ca80c945c247d48 :: nil (nil)
      up[3] Humanoid :: nil (nil)
  1309 :: thread
  1310 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] Standing :: nil (nil)
      up[2] table: 0x1ca80c945c247d48 :: nil (nil)
      up[3] Humanoid :: nil (nil)
      up[4] Animation2 :: nil (nil)
  1311 :: thread
  1312 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  1313 :: thread
  1314 :: thread
  1315 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  1316 :: number (1370)
  1317 :: thread
  1318 :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
      up[1] function: 0x8238247c27722ccc :: nil (nil)
  1319 :: thread
  1320 :: function [ReplicatedStorage.bar.Icon.Features.Overflow:?]
      up[1] function: 0x8238247c27722ccc :: nil (nil)
  1321 :: thread
  1322 :: thread
  1323 :: table [0 claves]
  1324 :: function [ReplicatedStorage.bar.Icon.Elements.Indicator:?]
      up[1] Widget :: nil (nil)
      up[2] Indicator :: nil (nil)
  1325 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1326 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1327 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1328 :: thread
  1329 :: thread
  1330 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1331 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] Contents :: nil (nil)
      up[3] Contents :: nil (nil)
  1332 :: thread
  1333 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1334 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1335 :: thread
  1336 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  1337 :: thread
  1338 :: thread
  1339 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1340 :: thread
  1341 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconImageScale :: nil (nil)
      up[3] IconImageScale :: nil (nil)
  1342 :: thread
  1343 :: thread
  1344 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1345 :: thread
  1346 :: thread
  1347 :: thread
  1348 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1349 :: thread
  1350 :: thread
  1351 :: thread
  1352 :: thread
  1353 :: thread
  1354 :: table [4 claves]
    appVersion :: string ("v3.4.0")
    getAppVersion :: function [ReplicatedStorage.bar.Icon.VERSION:?]
        up[1] table: 0xe89d116d886fa079 :: nil (nil)
    getLatestVersion :: function [ReplicatedStorage.bar.Icon.VERSION:?]
        up[1] table: 0xe89d116d886fa079 :: nil (nil)
    isUpToDate :: function [ReplicatedStorage.bar.Icon.VERSION:?]
        up[1] table: 0xe89d116d886fa079 :: nil (nil)
  1355 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconSpotGradient :: nil (nil)
      up[3] IconSpotGradient :: nil (nil)
  1356 :: thread
  1357 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
      up[1] Connection :: nil (nil)
  1358 :: thread
  1359 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1360 :: thread
  1361 :: thread
  1362 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconButton :: nil (nil)
  1363 :: thread
  1364 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1365 :: thread
  1366 :: thread
  1367 :: number (1528)
  1368 :: thread
  1369 :: thread
  1370 :: number (1554)
  1371 :: thread
  1372 :: thread
  1373 :: thread
  1374 :: thread
  1375 :: function [Workspace.roblox1234dieg.Animate:?]
      up[1] idle :: nil (nil)
  1376 :: thread
  1377 :: thread
  1378 :: thread
  1379 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v46:?]
      up[1] table: 0x4a207a071aed0602 :: nil (nil)
      up[2] roblox1234dieg :: nil (nil)
  1380 :: thread
  1381 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v46:?]
      up[1] roblox1234dieg :: nil (nil)
      up[2] Humanoid :: nil (nil)
      up[3] health :: nil (nil)
  1382 :: thread
  1383 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript.Folder.v46:?]
      up[1] Humanoid :: nil (nil)
  1384 :: thread
  1385 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  1386 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  1387 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] Widget :: nil (nil)
      up[3] OverflowLeft :: nil (nil)
  1388 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1389 :: thread
  1390 :: thread
  1391 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1392 :: thread
  1393 :: thread
  1394 :: thread
  1395 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1396 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] IconImage :: nil (nil)
      up[2] IconImageScale :: nil (nil)
  1397 :: function [ReplicatedStorage.bar.Icon.Elements.Widget:?]
      up[1] roblox1234dieg :: nil (nil)
      up[2] es-es :: nil (nil)
      up[3] table: 0x676da3c7e2ca2273 :: nil (nil)
  1398 :: thread
  1399 :: thread
  1400 :: thread
  1401 :: thread
  1402 :: thread
  1403 :: function [[string "INecx"]:?]
      up[1] function: 0x635e0af0de11f9e7 :: nil (nil)
  1404 :: thread
  1405 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1406 :: number (1592)
  1407 :: number (1584)
  1408 :: thread
  1409 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Header :: nil (nil)
      up[3] Header :: nil (nil)
  1410 :: thread
  1411 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Layout :: nil (nil)
      up[3] Layout :: nil (nil)
  1412 :: thread
  1413 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] CaptionCorner :: nil (nil)
      up[3] CaptionCorner :: nil (nil)
  1414 :: thread
  1415 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Padding :: nil (nil)
      up[3] Padding :: nil (nil)
  1416 :: thread
  1417 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Layout1 :: nil (nil)
      up[3] Layout1 :: nil (nil)
  1418 :: thread
  1419 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Inset :: nil (nil)
      up[3] Inset :: nil (nil)
  1420 :: thread
  1421 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] LabelContent :: nil (nil)
      up[3] LabelContent :: nil (nil)
  1422 :: thread
  1423 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Key1 :: nil (nil)
      up[3] Key1 :: nil (nil)
  1424 :: thread
  1425 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Hotkeys :: nil (nil)
      up[3] Hotkeys :: nil (nil)
  1426 :: thread
  1427 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Box :: nil (nil)
      up[3] Box :: nil (nil)
  1428 :: thread
  1429 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Caret :: nil (nil)
      up[3] Caret :: nil (nil)
  1430 :: thread
  1431 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] DropShadow :: nil (nil)
      up[3] DropShadow :: nil (nil)
  1432 :: thread
  1433 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] ClippedClone :: nil (nil)
      up[3] ClippedClone :: nil (nil)
  1434 :: thread
  1435 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Caption :: nil (nil)
      up[3] Caption :: nil (nil)
  1436 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
  1437 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1438 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1439 :: thread
  1440 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconImageRatio :: nil (nil)
      up[3] IconImageRatio :: nil (nil)
  1441 :: thread
  1442 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  1443 :: thread
  1444 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Header :: nil (nil)
      up[3] Header :: nil (nil)
  1445 :: thread
  1446 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Layout :: nil (nil)
      up[3] Layout :: nil (nil)
  1447 :: thread
  1448 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] CaptionCorner :: nil (nil)
      up[3] CaptionCorner :: nil (nil)
  1449 :: thread
  1450 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Padding :: nil (nil)
      up[3] Padding :: nil (nil)
  1451 :: thread
  1452 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Layout1 :: nil (nil)
      up[3] Layout1 :: nil (nil)
  1453 :: thread
  1454 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Inset :: nil (nil)
      up[3] Inset :: nil (nil)
  1455 :: thread
  1456 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] LabelContent :: nil (nil)
      up[3] LabelContent :: nil (nil)
  1457 :: thread
  1458 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Key1 :: nil (nil)
      up[3] Key1 :: nil (nil)
  1459 :: thread
  1460 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Hotkeys :: nil (nil)
      up[3] Hotkeys :: nil (nil)
  1461 :: thread
  1462 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Box :: nil (nil)
      up[3] Box :: nil (nil)
  1463 :: thread
  1464 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Caret :: nil (nil)
      up[3] Caret :: nil (nil)
  1465 :: thread
  1466 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] DropShadow :: nil (nil)
      up[3] DropShadow :: nil (nil)
  1467 :: thread
  1468 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] ClippedClone :: nil (nil)
      up[3] ClippedClone :: nil (nil)
  1469 :: thread
  1470 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0xe174e6d8ceba7991 :: nil (nil)
      up[2] Caption :: nil (nil)
      up[3] Caption :: nil (nil)
  1471 :: thread
  1472 :: thread
  1473 :: thread
  1474 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1475 :: thread
  1476 :: thread
  1477 :: thread
  1478 :: thread
  1479 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconImage :: nil (nil)
      up[3] IconImage :: nil (nil)
  1480 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  1481 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1482 :: thread
  1483 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1484 :: thread
  1485 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1486 :: thread
  1487 :: thread
  1488 :: thread
  1489 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] 0 :: nil (nil)
  1490 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
  1491 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] buy :: nil (nil)
  1492 :: thread
  1493 :: thread
  1494 :: function [Players.roblox1234dieg.PlayerGui.MainGui.LocalScript:?]
      up[1] tools :: nil (nil)
      up[2] buy :: nil (nil)
  1495 :: thread
  1496 :: thread
  1497 :: function [Players.roblox1234dieg.PlayerScripts.RbxCharacterSounds.AtomicBinding:?]
      up[1] table: 0xac13fb37f15eb1ec :: nil (nil)
      up[2] table: 0x2dd28ea342c8df92 :: nil (nil)
      up[3] G4lantamine :: nil (nil)
      up[4] function: 0x99feb4f4a9b6e8e8 :: nil (nil)
      up[5] table: 0x74b4c2c07618fa23 :: nil (nil)
      up[6] G4lantamine :: nil (nil)
      up[7] function: 0xd6afd0b4aa4f1b2f :: nil (nil)
  1498 :: thread
  1499 :: thread
  1500 :: thread
  1501 :: thread
  1502 :: thread
  1503 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] ClickRegion :: nil (nil)
      up[3] ClickRegion :: nil (nil)
  1504 :: thread
  1505 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  1506 :: thread
  1507 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconOverlay :: nil (nil)
      up[3] IconOverlay :: nil (nil)
  1508 :: thread
  1509 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] OverlayUICorner :: nil (nil)
      up[3] OverlayUICorner :: nil (nil)
  1510 :: thread
  1511 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] UICorner :: nil (nil)
      up[3] UICorner :: nil (nil)
  1512 :: thread
  1513 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] MenuGap :: nil (nil)
      up[3] MenuGap :: nil (nil)
  1514 :: thread
  1515 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] MenuUIListLayout :: nil (nil)
      up[3] MenuUIListLayout :: nil (nil)
  1516 :: thread
  1517 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconSpot :: nil (nil)
      up[3] IconSpot :: nil (nil)
  1518 :: thread
  1519 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] Menu :: nil (nil)
      up[3] Menu :: nil (nil)
  1520 :: thread
  1521 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconGradient :: nil (nil)
      up[3] IconGradient :: nil (nil)
  1522 :: thread
  1523 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] IconButton :: nil (nil)
      up[3] IconButton :: nil (nil)
  1524 :: thread
  1525 :: number (1557)
  1526 :: number (1525)
  1527 :: thread
  1528 :: number (1569)
  1529 :: number (1526)
  1530 :: thread
  1531 :: number (1618)
  1532 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
      up[1] GuiService :: nil (nil)
      up[2] table: 0xe27087d7e27658d5 :: nil (nil)
      up[3] UserInputService :: nil (nil)
      up[4] Enum.PreferredInput.Gamepad :: nil (nil)
      up[5] function: 0x39b4bbf4a5c79174 :: nil (nil)
      up[6] table: 0x972c3e92ce52a519 :: nil (nil)
      up[7] table: 0x4f81edc7a348b696 :: nil (nil)
  1533 :: thread
  1534 :: function [ReplicatedStorage.bar.Icon:?]
  1535 :: thread
  1536 :: function [ReplicatedStorage.bar.Icon:?]
  1537 :: thread
  1538 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] 0 :: nil (nil)
  1539 :: thread
  1540 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] UserInputService :: nil (nil)
      up[2] table: 0x2f8010ca713e8d8e :: nil (nil)
      up[3] table: 0x676da3c7e2ca2273 :: nil (nil)
  1541 :: thread
  1542 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
  1543 :: thread
  1544 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
  1545 :: thread
  1546 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
  1547 :: thread
  1548 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
  1549 :: thread
  1550 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x676da3c7e2ca2273 :: nil (nil)
      up[2] UserInputService :: nil (nil)
      up[3] table: 0x2f8010ca713e8d8e :: nil (nil)
      up[4] 0 :: nil (nil)
  1551 :: thread
  1552 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] 0 :: nil (nil)
  1553 :: number (1529)
  1554 :: number (1571)
  1555 :: thread
  1556 :: thread
  1557 :: number (0)
  1558 :: number (1622)
  1559 :: thread
  1560 :: thread
  1561 :: thread
  1562 :: thread
  1563 :: number (1607)
  1564 :: thread
  1565 :: thread
  1566 :: number (1598)
  1567 :: number (1599)
  1568 :: number (1367)
  1569 :: number (1406)
  1570 :: thread
  1571 :: number (1558)
  1572 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
      up[1] UserInputService :: nil (nil)
      up[2] Enum.PreferredInput.Gamepad :: nil (nil)
  1573 :: function [ReplicatedStorage.bar.Icon.Elements.Indicator:?]
      up[1] GuiService :: nil (nil)
      up[2] ClickRegion :: nil (nil)
      up[3] IndicatorButton :: nil (nil)
  1574 :: thread
  1575 :: thread
  1576 :: thread
  1577 :: function [ReplicatedStorage.bar.Icon.Elements.Indicator:?]
      up[1] Indicator :: nil (nil)
      up[2] GamepadService :: nil (nil)
      up[3] table: 0x4f81edc7a348b696 :: nil (nil)
  1578 :: thread
  1579 :: number (1316)
  1580 :: function [ReplicatedStorage.bar.Icon.Elements.Selection:?]
  1581 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] ImageLabel :: nil (nil)
      up[3] ImageLabel :: nil (nil)
  1582 :: thread
  1583 :: thread
  1584 :: number (1590)
  1585 :: thread
  1586 :: function [ReplicatedStorage.bar.Icon:?]
      up[1] table: 0x4f81edc7a348b696 :: nil (nil)
      up[2] Indicator :: nil (nil)
      up[3] Indicator :: nil (nil)
  1587 :: number (1567)
  1588 :: number (1553)
  1589 :: number (1588)
  1590 :: number (1589)
  1591 :: thread
  1592 :: number (1612)
  1593 :: thread
  1594 :: thread
  1595 :: function [ReplicatedStorage.bar.Icon.Features.Gamepad:?]
      up[1] GuiService :: nil (nil)
      up[2] table: 0xe27087d7e27658d5 :: nil (nil)
      up[3] table: 0x972c3e92ce52a519 :: nil (nil)
      up[4] table: 0x48fe16bf299a5fbd :: nil (nil)
      up[5] GamepadService :: nil (nil)
  1596 :: thread
  1597 :: number (1610)
  1598 :: number (1620)
  1599 :: number (1568)
  1600 :: function [[C]:?]
  1601 :: thread
  1602 :: thread
  1603 :: thread
  1604 :: thread
  1605 :: number (1566)
  1606 :: number (1597)
  1607 :: number (1606)
  1608 :: thread
  1609 :: userdata <LocalScript>
  1610 :: number (1531)
  1611 :: thread
  1612 :: number (1563)
  1613 :: userdata <LocalScript>
  1614 :: thread
  1615 :: number (1579)
  1616 :: thread
  1617 :: thread
  1618 :: number (1615)
  1619 :: thread
  1620 :: number (1587)
  1621 :: thread
  1622 :: number (1407)
  AdReward :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("AdReward")
  Axes :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Axes")
  BrickColor :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("BrickColor")
  CFrame :: table [10 claves]
    __add :: function [[C]:?]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __mul :: function [[C]:?]
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __sub :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("CFrame")
  CatalogSearchParams :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("CatalogSearchParams")
  CellId :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("CellId")
  CollectionHandle :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("CollectionHandle")
  Color3 :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Color3")
  ColorSequence :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("ColorSequence")
  ColorSequenceKeypoint :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("ColorSequenceKeypoint")
  Content :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Content")
  DateTime :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("DateTime")
  DockWidgetPluginGuiInfo :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("DockWidgetPluginGuiInfo")
  Enum :: table [5 claves]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Enum")
  EnumItem :: table [5 claves]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("EnumItem")
  Enums :: table [5 claves]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Enums")
  Faces :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Faces")
  FloatCurveKey :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("FloatCurveKey")
  Font :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Font")
  GenericFunction :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("GenericFunction")
  Instance :: table [6 claves]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Instance")
  InstanceHandle :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("InstanceHandle")
  NumberRange :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("NumberRange")
  NumberSequence :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("NumberSequence")
  NumberSequenceKeypoint :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("NumberSequenceKeypoint")
  Object :: table [6 claves]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Object")
  OverlapParams :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("OverlapParams")
  Path2DControlPoint :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Path2DControlPoint")
  PathWaypoint :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("PathWaypoint")
  PhysicalProperties :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("PhysicalProperties")
  PluginDrag :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("PluginDrag")
  RBXScriptConnection :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("RBXScriptConnection")
  RBXScriptSignal :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("RBXScriptSignal")
  Random :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Random")
  Ray :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Ray")
  RaycastParams :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("RaycastParams")
  RaycastResult :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("RaycastResult")
  Rect :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Rect")
  Region3 :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Region3")
  Region3int16 :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Region3int16")
  RotationCurveKey :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("RotationCurveKey")
  Secret :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Secret")
  SecurityCapabilities :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("SecurityCapabilities")
  SharedTable :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __iter :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __type :: string ("SharedTable")
  SharedTableIterator :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("SharedTableIterator")
  TweenInfo :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("TweenInfo")
  UDim :: table [9 claves]
    __add :: function [[C]:?]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __sub :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("UDim")
    __unm :: function [[C]:?]
  UDim2 :: table [10 claves]
    __add :: function [[C]:?]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __sub :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("UDim2")
    __unm :: function [[C]:?]
  User :: table [7 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("User")
  ValueCurveKey :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("ValueCurveKey")
  Vector2 :: table [13 claves]
    __add :: function [[C]:?]
    __div :: function [[C]:?]
    __eq :: function [[C]:?]
    __idiv :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __mul :: function [[C]:?]
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __sub :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Vector2")
    __unm :: function [[C]:?]
  Vector2int16 :: table [11 claves]
    __add :: function [[C]:?]
    __div :: function [[C]:?]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __mul :: function [[C]:?]
    __newindex :: function [[C]:?]
    __sub :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Vector2int16")
    __unm :: function [[C]:?]
  Vector3 :: table [5 claves]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __namecall :: function [[C]:?]
    __newindex :: function [[C]:?]
    __type :: string ("Vector3")
  Vector3int16 :: table [11 claves]
    __add :: function [[C]:?]
    __div :: function [[C]:?]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __mul :: function [[C]:?]
    __newindex :: function [[C]:?]
    __sub :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("Vector3int16")
    __unm :: function [[C]:?]
  WeakThreadRef::Node :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("WeakThreadRef::Node")
  WebViewParams :: table [6 claves]
    __eq :: function [[C]:?]
    __index :: function [[C]:?]
    __metatable :: string ("The metatable is locked")
    __newindex :: function [[C]:?]
    __tostring :: function [[C]:?]
    __type :: string ("WebViewParams")
  _LOADED :: table [55 claves]
    AdReward :: table [0 claves]
    Axes :: table [1 claves]
      new :: function [[C]:?]
    BrickColor :: table [13 claves]
      Black :: function [[C]:?]
      Blue :: function [[C]:?]
      DarkGray :: function [[C]:?]
      Gray :: function [[C]:?]
      Green :: function [[C]:?]
      New :: function [[C]:?]
      Random :: function [[C]:?]
      Red :: function [[C]:?]
      White :: function [[C]:?]
      Yellow :: function [[C]:?]
      new :: function [[C]:?]
      palette :: function [[C]:?]
      random :: function [[C]:?]
    CFrame :: table [12 claves]
      Angles :: function [[C]:?]
      fromAxisAngle :: function [[C]:?]
      fromEulerAngles :: function [[C]:?]
      fromEulerAnglesXYZ :: function [[C]:?]
      fromEulerAnglesYXZ :: function [[C]:?]
      fromMatrix :: function [[C]:?]
      fromOrientation :: function [[C]:?]
      fromRotationBetweenVectors :: function [[C]:?]
      identity :: userdata
      lookAlong :: function [[C]:?]
      lookAt :: function [[C]:?]
      new :: function [[C]:?]
    CatalogSearchParams :: table [1 claves]
      new :: function [[C]:?]
    CellId :: table [1 claves]
      new :: function [[C]:?]
    Color3 :: table [5 claves]
      fromHSV :: function [[C]:?]
      fromHex :: function [[C]:?]
      fromRGB :: function [[C]:?]
      new :: function [[C]:?]
      toHSV :: function [[C]:?]
    ColorSequence :: table [1 claves]
      new :: function [[C]:?]
    ColorSequenceKeypoint :: table [1 claves]
      new :: function [[C]:?]
    Content :: table [4 claves]
      fromAssetId :: function [[C]:?]
      fromObject :: function [[C]:?]
      fromUri :: function [[C]:?]
      none :: userdata
    DateTime :: table [6 claves]
      fromIsoDate :: function [[C]:?]
      fromLocalTime :: function [[C]:?]
      fromUniversalTime :: function [[C]:?]
      fromUnixTimestamp :: function [[C]:?]
      fromUnixTimestampMillis :: function [[C]:?]
      now :: function [[C]:?]
    DockWidgetPluginGuiInfo :: table [1 claves]
      new :: function [[C]:?]
    Faces :: table [1 claves]
      new :: function [[C]:?]
    FloatCurveKey :: table [1 claves]
      new :: function [[C]:?]
    Font :: table [4 claves]
      fromEnum :: function [[C]:?]
      fromId :: function [[C]:?]
      fromName :: function [[C]:?]
      new :: function [[C]:?]
    Instance :: table [2 claves]
      fromExisting :: function [[C]:?]
      new :: function [[C]:?]
    InstanceHandle :: table [1 claves]
      new :: function [[C]:?]
    NumberRange :: table [1 claves]
      new :: function [[C]:?]
    NumberSequence :: table [1 claves]
      new :: function [[C]:?]
    NumberSequenceKeypoint :: table [1 claves]
      new :: function [[C]:?]
    OverlapParams :: table [1 claves]
      new :: function [[C]:?]
    Path2DControlPoint :: table [1 claves]
      new :: function [[C]:?]
    PathWaypoint :: table [1 claves]
      new :: function [[C]:?]
    PhysicalProperties :: table [1 claves]
      new :: function [[C]:?]
          up[1] 0 :: nil (nil)
    PluginDrag :: table [1 claves]
      new :: function [[C]:?]
    Random :: table [1 claves]
      new :: function [[C]:?]
    Ray :: table [1 claves]
      new :: function [[C]:?]
    RaycastParams :: table [1 claves]
      new :: function [[C]:?]
    Rect :: table [1 claves]
      new :: function [[C]:?]
    Region3 :: table [1 claves]
      new :: function [[C]:?]
    Region3int16 :: table [1 claves]
      new :: function [[C]:?]
    RotationCurveKey :: table [1 claves]
      new :: function [[C]:?]
    SecurityCapabilities :: table [2 claves]
      fromCurrent :: function [[C]:?]
      new :: function [[C]:?]
    SharedTable :: table [8 claves]
      clear :: function [[C]:?]
      clone :: function [[C]:?]
      cloneAndFreeze :: function [[C]:?]
      increment :: function [[C]:?]
      isFrozen :: function [[C]:?]
      new :: function [[C]:?]
      size :: function [[C]:?]
      update :: function [[C]:?]
    TweenInfo :: table [1 claves]
      new :: function [[C]:?]
    UDim :: table [1 claves]
      new :: function [[C]:?]
    UDim2 :: table [3 claves]
      fromOffset :: function [[C]:?]
      fromScale :: function [[C]:?]
      new :: function [[C]:?]
    User :: table [2 claves]
      fromId :: function [[C]:?]
      fromString :: function [[C]:?]
    ValueCurveKey :: table [1 claves]
      new :: function [[C]:?]
    Vector2 :: table [7 claves]
      max :: function [[C]:?]
      min :: function [[C]:?]
      new :: function [[C]:?]
      one :: userdata
      xAxis :: userdata
      yAxis :: userdata
      zero :: userdata
    Vector2int16 :: table [1 claves]
      new :: function [[C]:?]
    Vector3 :: table [12 claves]
      FromAxis :: function [[C]:?]
      FromNormalId :: function [[C]:?]
      fromAxis :: function [[C]:?]
      fromNormalId :: function [[C]:?]
      max :: function [[C]:?]
      min :: function [[C]:?]
      new :: function [[C]:?]
      one :: vector
      xAxis :: vector
      yAxis :: vector
      zAxis :: vector
      zero :: vector
    Vector3int16 :: table [1 claves]
      new :: function [[C]:?]
    WebViewParams :: table [1 claves]
      new :: function [[C]:?]
    _G :: table [111 claves]
      AdReward :: table [0 claves]
      Axes :: table [1 claves]
        new :: function [[C]:?]
      BrickColor :: table [13 claves]
        Black :: function [[C]:?]
        Blue :: function [[C]:?]
        DarkGray :: function [[C]:?]
        Gray :: function [[C]:?]
        Green :: function [[C]:?]
        New :: function [[C]:?]
        Random :: function [[C]:?]
        Red :: function [[C]:?]
        White :: function [[C]:?]
        Yellow :: function [[C]:?]
        new :: function [[C]:?]
        palette :: function [[C]:?]
        random :: function [[C]:?]
      CFrame :: table [12 claves]
        Angles :: function [[C]:?]
        fromAxisAngle :: function [[C]:?]
        fromEulerAngles :: function [[C]:?]
        fromEulerAnglesXYZ :: function [[C]:?]
        fromEulerAnglesYXZ :: function [[C]:?]
        fromMatrix :: function [[C]:?]
        fromOrientation :: function [[C]:?]
        fromRotationBetweenVectors :: function [[C]:?]
        identity :: userdata
        lookAlong :: function [[C]:?]
        lookAt :: function [[C]:?]
        new :: function [[C]:?]
      CatalogSearchParams :: table [1 claves]
        new :: function [[C]:?]
      CellId :: table [1 claves]
        new :: function [[C]:?]
      Color3 :: table [5 claves]
        fromHSV :: function [[C]:?]
        fromHex :: function [[C]:?]
        fromRGB :: function [[C]:?]
        new :: function [[C]:?]
        toHSV :: function [[C]:?]
      ColorSequence :: table [1 claves]
        new :: function [[C]:?]
      ColorSequenceKeypoint :: table [1 claves]
        new :: function [[C]:?]
      Content :: table [4 claves]
        fromAssetId :: function [[C]:?]
        fromObject :: function [[C]:?]
        fromUri :: function [[C]:?]
        none :: userdata
      DateTime :: table [6 claves]
        fromIsoDate :: function [[C]:?]
        fromLocalTime :: function [[C]:?]
        fromUniversalTime :: function [[C]:?]
        fromUnixTimestamp :: function [[C]:?]
        fromUnixTimestampMillis :: function [[C]:?]
        now :: function [[C]:?]
      Delay :: function [[C]:?]
      DockWidgetPluginGuiInfo :: table [1 claves]
        new :: function [[C]:?]
      ElapsedTime :: function [[C]:?]
      Enum :: userdata
      Faces :: table [1 claves]
        new :: function [[C]:?]
      FloatCurveKey :: table [1 claves]
        new :: function [[C]:?]
      Font :: table [4 claves]
        fromEnum :: function [[C]:?]
        fromId :: function [[C]:?]
        fromName :: function [[C]:?]
        new :: function [[C]:?]
      Game :: userdata <DataModel>
      Instance :: table [2 claves]
        fromExisting :: function [[C]:?]
        new :: function [[C]:?]
      InstanceHandle :: table [1 claves]
        new :: function [[C]:?]
      NumberRange :: table [1 claves]
        new :: function [[C]:?]
      NumberSequence :: table [1 claves]
        new :: function [[C]:?]
      NumberSequenceKeypoint :: table [1 claves]
        new :: function [[C]:?]
      OverlapParams :: table [1 claves]
        new :: function [[C]:?]
      Path2DControlPoint :: table [1 claves]
        new :: function [[C]:?]
      PathWaypoint :: table [1 claves]
        new :: function [[C]:?]
      PhysicalProperties :: table [1 claves]
        new :: function [[C]:?]
            up[1] 0 :: nil (nil)
      PluginDrag :: table [1 claves]
        new :: function [[C]:?]
      PluginManager :: function [[C]:?]
      Random :: table [1 claves]
        new :: function [[C]:?]
      Ray :: table [1 claves]
        new :: function [[C]:?]
      RaycastParams :: table [1 claves]
        new :: function [[C]:?]
      Rect :: table [1 claves]
        new :: function [[C]:?]
      Region3 :: table [1 claves]
        new :: function [[C]:?]
      Region3int16 :: table [1 claves]
        new :: function [[C]:?]
      RotationCurveKey :: table [1 claves]
        new :: function [[C]:?]
      SecurityCapabilities :: table [2 claves]
        fromCurrent :: function [[C]:?]
        new :: function [[C]:?]
      SharedTable :: table [8 claves]
        clear :: function [[C]:?]
        clone :: function [[C]:?]
        cloneAndFreeze :: function [[C]:?]
        increment :: function [[C]:?]
        isFrozen :: function [[C]:?]
        new :: function [[C]:?]
        size :: function [[C]:?]
        update :: function [[C]:?]
      Spawn :: function [[C]:?]
      Stats :: function [[C]:?]
      TweenInfo :: table [1 claves]
        new :: function [[C]:?]
      UDim :: table [1 claves]
        new :: function [[C]:?]
      UDim2 :: table [3 claves]
        fromOffset :: function [[C]:?]
        fromScale :: function [[C]:?]
        new :: function [[C]:?]
      User :: table [2 claves]
        fromId :: function [[C]:?]
        fromString :: function [[C]:?]
      UserSettings :: function [[C]:?]
      ValueCurveKey :: table [1 claves]
        new :: function [[C]:?]
      Vector2 :: table [7 claves]
        max :: function [[C]:?]
        min :: function [[C]:?]
        new :: function [[C]:?]
        one :: userdata
        xAxis :: userdata
        yAxis :: userdata
        zero :: userdata
      Vector2int16 :: table [1 claves]
        new :: function [[C]:?]
      Vector3 :: table [12 claves]
        FromAxis :: function [[C]:?]
        FromNormalId :: function [[C]:?]
        fromAxis :: function [[C]:?]
        fromNormalId :: function [[C]:?]
        max :: function [[C]:?]
        min :: function [[C]:?]
        new :: function [[C]:?]
        one :: vector
        xAxis :: vector
        yAxis :: vector
        zAxis :: vector
        zero :: vector
      Vector3int16 :: table [1 claves]
        new :: function [[C]:?]
      Version :: function [[C]:?]
      Wait :: function [[C]:?]
      WebViewParams :: table [1 claves]
        new :: function [[C]:?]
      Workspace :: userdata <Workspace>
      _VERSION :: string ("Luau")
      assert :: function [[C]:?]
      bit32 :: table [15 claves]
        arshift :: function [[C]:?]
        band :: function [[C]:?]
        bnot :: function [[C]:?]
        bor :: function [[C]:?]
        btest :: function [[C]:?]
        bxor :: function [[C]:?]
        byteswap :: function [[C]:?]
        countlz :: function [[C]:?]
        countrz :: function [[C]:?]
        extract :: function [[C]:?]
        lrotate :: function [[C]:?]
        lshift :: function [[C]:?]
        replace :: function [[C]:?]
        rrotate :: function [[C]:?]
        rshift :: function [[C]:?]
      buffer :: table [26 claves]
        copy :: function [[C]:?]
        create :: function [[C]:?]
        fill :: function [[C]:?]
        fromstring :: function [[C]:?]
        len :: function [[C]:?]
        readbits :: function [[C]:?]
        readf32 :: function [[C]:?]
        readf64 :: function [[C]:?]
        readi16 :: function [[C]:?]
        readi32 :: function [[C]:?]
        readi8 :: function [[C]:?]
        readstring :: function [[C]:?]
        readu16 :: function [[C]:?]
        readu32 :: function [[C]:?]
        readu8 :: function [[C]:?]
        tostring :: function [[C]:?]
        writebits :: function [[C]:?]
        writef32 :: function [[C]:?]
        writef64 :: function [[C]:?]
        writei16 :: function [[C]:?]
        writei32 :: function [[C]:?]
        writei8 :: function [[C]:?]
        writestring :: function [[C]:?]
        writeu16 :: function [[C]:?]
        writeu32 :: function [[C]:?]
        writeu8 :: function [[C]:?]
      collectgarbage :: function [[C]:?]
      coroutine :: table [9 claves]
        close :: function [[C]:?]
        create :: function [[C]:?]
        finally :: function [[C]:?]
        isyieldable :: function [[C]:?]
        resume :: function [[C]:?]
        running :: function [[C]:?]
        status :: function [[C]:?]
        wrap :: function [[C]:?]
        yield :: function [[C]:?]
      debug :: table [12 claves]
        dumpcodesize :: function [[C]:?]
        dumpheap :: function [[C]:?]
        dumprefs :: function [[C]:?]
        getmemorycategory :: function [[C]:?]
        info :: function [[C]:?]
        loadmodule :: function [[C]:?]
        profilebegin :: function [[C]:?]
        profileend :: function [[C]:?]
        resetmemorycategory :: function [[C]:?]
        setmemorycategory :: function [[C]:?]
        traceback :: function [[C]:?]
        tracerefs :: function [[C]:?]
      delay :: function [[C]:?]
      elapsedTime :: function [[C]:?]
      error :: function [[C]:?]
      game :: userdata <DataModel>
      gcinfo :: function [[C]:?]
      getfenv :: function [[C]:?]
      getmetatable :: function [[C]:?]
      ipairs :: function [[C]:?]
          up[1] function: 0x1ec086f7d73dfcb8 :: nil (nil)
      loadstring :: function [[C]:?]
      math :: table [44 claves]
        abs :: function [[C]:?]
        acos :: function [[C]:?]
        asin :: function [[C]:?]
        atan :: function [[C]:?]
        atan2 :: function [[C]:?]
        ceil :: function [[C]:?]
        clamp :: function [[C]:?]
        cos :: function [[C]:?]
        cosh :: function [[C]:?]
        deg :: function [[C]:?]
        e :: number (2.718281828459045)
        exp :: function [[C]:?]
        floor :: function [[C]:?]
        fmod :: function [[C]:?]
        frexp :: function [[C]:?]
        huge :: number (inf)
        isfinite :: function [[C]:?]
        isinf :: function [[C]:?]
        isnan :: function [[C]:?]
        ldexp :: function [[C]:?]
        lerp :: function [[C]:?]
        log :: function [[C]:?]
        log10 :: function [[C]:?]
        map :: function [[C]:?]
        max :: function [[C]:?]
        min :: function [[C]:?]
        modf :: function [[C]:?]
        nan :: number (nan)
        noise :: function [[C]:?]
        phi :: number (1.618033988749895)
        pi :: number (3.141592653589793)
        pow :: function [[C]:?]
        rad :: function [[C]:?]
        random :: function [[C]:?]
        randomseed :: function [[C]:?]
        round :: function [[C]:?]
        sign :: function [[C]:?]
        sin :: function [[C]:?]
        sinh :: function [[C]:?]
        sqrt :: function [[C]:?]
        sqrt2 :: number (1.4142135623730951)
        tan :: function [[C]:?]
        tanh :: function [[C]:?]
        tau :: number (6.283185307179586)
      newproxy :: function [[C]:?]
      next :: function [[C]:?]
      os :: table [4 claves]
        clock :: function [[C]:?]
        date :: function [[C]:?]
        difftime :: function [[C]:?]
        time :: function [[C]:?]
      pairs :: function [[C]:?]
          up[1] function: 0x01ce96e235596543 :: nil (nil)
      pcall :: function [[C]:?]
      print :: function [[C]:?]
      printidentity :: function [[C]:?]
      rawequal :: function [[C]:?]
      rawget :: function [[C]:?]
      rawlen :: function [[C]:?]
      rawset :: function [[C]:?]
      require :: function [[C]:?]
      select :: function [[C]:?]
      setfenv :: function [[C]:?]
      setmetatable :: function [[C]:?]
      settings :: function [[C]:?]
      spawn :: function [[C]:?]
      stats :: function [[C]:?]
      string :: table [17 claves]
        byte :: function [[C]:?]
        char :: function [[C]:?]
        find :: function [[C]:?]
        format :: function [[C]:?]
        gmatch :: function [[C]:?]
        gsub :: function [[C]:?]
        len :: function [[C]:?]
        lower :: function [[C]:?]
        match :: function [[C]:?]
        pack :: function [[C]:?]
        packsize :: function [[C]:?]
        rep :: function [[C]:?]
        reverse :: function [[C]:?]
        split :: function [[C]:?]
        sub :: function [[C]:?]
        unpack :: function [[C]:?]
        upper :: function [[C]:?]
      table :: table [17 claves]
        clear :: function [[C]:?]
        clone :: function [[C]:?]
        concat :: function [[C]:?]
        create :: function [[C]:?]
        find :: function [[C]:?]
        foreach :: function [[C]:?]
        foreachi :: function [[C]:?]
        freeze :: function [[C]:?]
        getn :: function [[C]:?]
        insert :: function [[C]:?]
        isfrozen :: function [[C]:?]
        maxn :: function [[C]:?]
        move :: function [[C]:?]
        pack :: function [[C]:?]
        remove :: function [[C]:?]
        sort :: function [[C]:?]
        unpack :: function [[C]:?]
      task :: table [7 claves]
        cancel :: function [[C]:?]
        defer :: function [[C]:?]
        delay :: function [[C]:?]
        desynchronize :: function [[C]:?]
        spawn :: function [[C]:?]
        synchronize :: function [[C]:?]
        wait :: function [[C]:?]
      tick :: function [[C]:?]
      time :: function [[C]:?]
      tonumber :: function [[C]:?]
      tostring :: function [[C]:?]
      type :: function [[C]:?]
      typeof :: function [[C]:?]
      unpack :: function [[C]:?]
      utf8 :: table [9 claves]
        char :: function [[C]:?]
        charpattern :: string ("[ -�-�][�-�]*")
        codepoint :: function [[C]:?]
        codes :: function [[C]:?]
        graphemes :: function [[C]:?]
        len :: function [[C]:?]
        nfcnormalize :: function [[C]:?]
        nfdnormalize :: function [[C]:?]
        offset :: function [[C]:?]
      vector :: table [16 claves]
        abs :: function [[C]:?]
        angle :: function [[C]:?]
        ceil :: function [[C]:?]
        clamp :: function [[C]:?]
        create :: function [[C]:?]
        cross :: function [[C]:?]
        dot :: function [[C]:?]
        floor :: function [[C]:?]
        lerp :: function [[C]:?]
        magnitude :: function [[C]:?]
        max :: function [[C]:?]
        min :: function [[C]:?]
        normalize :: function [[C]:?]
        one :: vector
        sign :: function [[C]:?]
        zero :: vector
      version :: function [[C]:?]
      wait :: function [[C]:?]
      warn :: function [[C]:?]
      workspace :: userdata <Workspace>
      xpcall :: function [[C]:?]
      ypcall :: function [[C]:?]
      userdata: 0x1e8c195140af19c8 :: function [[C]:?]
          up[1] userdata: 0x1e8c195140af19c8 :: nil (nil)
      userdata: 0x93d6e9a5833e3c64 :: function [[C]:?]
          up[1] userdata: 0x93d6e9a5833e3c64 :: nil (nil)
      userdata: 0xfd124a3b8aaaad52 :: function [[C]:?]
          up[1] userdata: 0xfd124a3b8aaaad52 :: nil (nil)
    bit32 :: table [15 claves]
      arshift :: function [[C]:?]
      band :: function [[C]:?]
      bnot :: function [[C]:?]
      bor :: function [[C]:?]
      btest :: function [[C]:?]
      bxor :: function [[C]:?]
      byteswap :: function [[C]:?]
      countlz :: function [[C]:?]
      countrz :: function [[C]:?]
      extract :: function [[C]:?]
      lrotate :: function [[C]:?]
      lshift :: function [[C]:?]
      replace :: function [[C]:?]
      rrotate :: function [[C]:?]
      rshift :: function [[C]:?]
    buffer :: table [26 claves]
      copy :: function [[C]:?]
      create :: function [[C]:?]
      fill :: function [[C]:?]
      fromstring :: function [[C]:?]
      len :: function [[C]:?]
      readbits :: function [[C]:?]
      readf32 :: function [[C]:?]
      readf64 :: function [[C]:?]
      readi16 :: function [[C]:?]
      readi32 :: function [[C]:?]
      readi8 :: function [[C]:?]
      readstring :: function [[C]:?]
      readu16 :: function [[C]:?]
      readu32 :: function [[C]:?]
      readu8 :: function [[C]:?]
      tostring :: function [[C]:?]
      writebits :: function [[C]:?]
      writef32 :: function [[C]:?]
      writef64 :: function [[C]:?]
      writei16 :: function [[C]:?]
      writei32 :: function [[C]:?]
      writei8 :: function [[C]:?]
      writestring :: function [[C]:?]
      writeu16 :: function [[C]:?]
      writeu32 :: function [[C]:?]
      writeu8 :: function [[C]:?]
    coroutine :: table [9 claves]
      close :: function [[C]:?]
      create :: function [[C]:?]
      finally :: function [[C]:?]
      isyieldable :: function [[C]:?]
      resume :: function [[C]:?]
      running :: function [[C]:?]
      status :: function [[C]:?]
      wrap :: function [[C]:?]
      yield :: function [[C]:?]
    debug :: table [12 claves]
      dumpcodesize :: function [[C]:?]
      dumpheap :: function [[C]:?]
      dumprefs :: function [[C]:?]
      getmemorycategory :: function [[C]:?]
      info :: function [[C]:?]
      loadmodule :: function [[C]:?]
      profilebegin :: function [[C]:?]
      profileend :: function [[C]:?]
      resetmemorycategory :: function [[C]:?]
      setmemorycategory :: function [[C]:?]
      traceback :: function [[C]:?]
      tracerefs :: function [[C]:?]
    math :: table [44 claves]
      abs :: function [[C]:?]
      acos :: function [[C]:?]
      asin :: function [[C]:?]
      atan :: function [[C]:?]
      atan2 :: function [[C]:?]
      ceil :: function [[C]:?]
      clamp :: function [[C]:?]
      cos :: function [[C]:?]
      cosh :: function [[C]:?]
      deg :: function [[C]:?]
      e :: number (2.718281828459045)
      exp :: function [[C]:?]
      floor :: function [[C]:?]
      fmod :: function [[C]:?]
      frexp :: function [[C]:?]
      huge :: number (inf)
      isfinite :: function [[C]:?]
      isinf :: function [[C]:?]
      isnan :: function [[C]:?]
      ldexp :: function [[C]:?]
      lerp :: function [[C]:?]
      log :: function [[C]:?]
      log10 :: function [[C]:?]
      map :: function [[C]:?]
      max :: function [[C]:?]
      min :: function [[C]:?]
      modf :: function [[C]:?]
      nan :: number (nan)
      noise :: function [[C]:?]
      phi :: number (1.618033988749895)
      pi :: number (3.141592653589793)
      pow :: function [[C]:?]
      rad :: function [[C]:?]
      random :: function [[C]:?]
      randomseed :: function [[C]:?]
      round :: function [[C]:?]
      sign :: function [[C]:?]
      sin :: function [[C]:?]
      sinh :: function [[C]:?]
      sqrt :: function [[C]:?]
      sqrt2 :: number (1.4142135623730951)
      tan :: function [[C]:?]
      tanh :: function [[C]:?]
      tau :: number (6.283185307179586)
    os :: table [4 claves]
      clock :: function [[C]:?]
      date :: function [[C]:?]
      difftime :: function [[C]:?]
      time :: function [[C]:?]
    string :: table [17 claves]
      byte :: function [[C]:?]
      char :: function [[C]:?]
      find :: function [[C]:?]
      format :: function [[C]:?]
      gmatch :: function [[C]:?]
      gsub :: function [[C]:?]
      len :: function [[C]:?]
      lower :: function [[C]:?]
      match :: function [[C]:?]
      pack :: function [[C]:?]
      packsize :: function [[C]:?]
      rep :: function [[C]:?]
      reverse :: function [[C]:?]
      split :: function [[C]:?]
      sub :: function [[C]:?]
      unpack :: function [[C]:?]
      upper :: function [[C]:?]
    table :: table [17 claves]
      clear :: function [[C]:?]
      clone :: function [[C]:?]
      concat :: function [[C]:?]
      create :: function [[C]:?]
      find :: function [[C]:?]
      foreach :: function [[C]:?]
      foreachi :: function [[C]:?]
      freeze :: function [[C]:?]
      getn :: function [[C]:?]
      insert :: function [[C]:?]
      isfrozen :: function [[C]:?]
      maxn :: function [[C]:?]
      move :: function [[C]:?]
      pack :: function [[C]:?]
      remove :: function [[C]:?]
      sort :: function [[C]:?]
      unpack :: function [[C]:?]
    utf8 :: table [9 claves]
      char :: function [[C]:?]
      charpattern :: string ("[ -�-�][�-�]*")
      codepoint :: function [[C]:?]
      codes :: function [[C]:?]
      graphemes :: function [[C]:?]
      len :: function [[C]:?]
      nfcnormalize :: function [[C]:?]
      nfdnormalize :: function [[C]:?]
      offset :: function [[C]:?]
    vector :: table [16 claves]
      abs :: function [[C]:?]
      angle :: function [[C]:?]
      ceil :: function [[C]:?]
      clamp :: function [[C]:?]
      create :: function [[C]:?]
      cross :: function [[C]:?]
      dot :: function [[C]:?]
      floor :: function [[C]:?]
      lerp :: function [[C]:?]
      magnitude :: function [[C]:?]
      max :: function [[C]:?]
      min :: function [[C]:?]
      normalize :: function [[C]:?]
      one :: vector
      sign :: function [[C]:?]
      zero :: vector
  userdata: 0x39463587b05b1092 :: table [2 claves]
    0bW��df�Sp�"�\[�o    :: function [Workspace.roblox1234dieg.Animate:?]
    __mode :: string ("kvs")
  userdata: 0x3d234fae0a455d64 :: table [61 claves]
    userdata: 0x064894f17d68804e :: userdata
    userdata: 0x094aa147bc9a5380 :: userdata
    userdata: 0x0c007245d0c30891 :: userdata
    userdata: 0x158e0474c5ccf998 :: userdata
    userdata: 0x22197f68cc123dd7 :: userdata
    userdata: 0x25532c2db217f096 :: userdata
    userdata: 0x264707d40ce73405 :: userdata
    userdata: 0x2a3f73a3177b6880 :: userdata
    userdata: 0x2ca16e9e130ae2b6 :: userdata
    userdata: 0x2df10826ef5a3ad5 :: userdata
    userdata: 0x3201a62eded2a702 :: userdata
    userdata: 0x3a88aad33d284c8c :: userdata
    userdata: 0x3aa5b61738579711 :: userdata
    userdata: 0x3b01a2a5354152b6 :: userdata
    userdata: 0x3d159fe399dc0bfa :: userdata
    userdata: 0x3dd3a1d0f6177e75 :: userdata
    userdata: 0x41cf423958519bd7 :: userdata
    userdata: 0x43253379bed438e9 :: userdata
    userdata: 0x4e3418bb7dd6dac5 :: userdata
    userdata: 0x5331a226af094aa3 :: userdata
    userdata: 0x5478f763d29b4da6 :: userdata
    userdata: 0x54d3dc73860d8d27 :: userdata
    userdata: 0x54e95da78f205834 :: userdata
    userdata: 0x56b9e8af9f084929 :: userdata
    userdata: 0x5a94edebc11f9663 :: userdata
    userdata: 0x5c7eafc3597005a2 :: userdata
    userdata: 0x683f84d3cba78b55 :: userdata
    userdata: 0x74b6e3174c640434 :: userdata
    userdata: 0x7983967f904b59ca :: userdata
    userdata: 0x820aa2f582247211 :: userdata
    userdata: 0x8466617f52ff4833 :: userdata
    userdata: 0x84ac919f676ef012 :: userdata
    userdata: 0x85fd7fd410d7a6cc :: userdata
    userdata: 0x8b02b29d91c3dec2 :: userdata
    userdata: 0x8efc3ecd455c0fe8 :: userdata
    userdata: 0x91fe86481519476b :: userdata
    userdata: 0xa2d53551a10a3101 :: userdata
    userdata: 0xb1e2a19ffafb40e3 :: userdata
    userdata: 0xb606e99093cb4deb :: userdata
    userdata: 0xbf1bcd4ae984a190 :: userdata
    userdata: 0xc2625f2cb6fd3676 :: userdata
    userdata: 0xc2c38b2c4de39324 :: userdata
    userdata: 0xc3122ccd418a8339 :: userdata
    userdata: 0xc81046ecc53951e7 :: userdata
    userdata: 0xc83ba9ca57568ac7 :: userdata
    userdata: 0xcce189d537606b5a :: userdata
    userdata: 0xcfaa763d2aca8dba :: userdata
    userdata: 0xcfe9ce33947cbad0 :: userdata
    userdata: 0xd2533d59e30eef50 :: userdata
    userdata: 0xdaf7197354c86cd1 :: userdata
    userdata: 0xdd3f1c552e4b6110 :: userdata
    userdata: 0xe1a1e7260e5f2ee0 :: userdata
    userdata: 0xe26096ff84748a39 :: userdata
    userdata: 0xe498dc0933af5950 :: userdata
    userdata: 0xecc860864e95f557 :: userdata
    userdata: 0xeccd56ce8395b0cb :: userdata
    userdata: 0xf353e71c145a53b1 :: userdata
    userdata: 0xf570409508eae7fb :: userdata
    userdata: 0xf59fd6d68836de57 :: userdata
    userdata: 0xfe33e176fd2431ab :: userdata
    userdata: 0xfed3e0e6bef7bfbb :: userdata
  userdata: 0x7e50e5f04c3d82e5 :: table [564 claves]
    __mode :: string ("kvs")
    userdata: 0x00011e3c0e34bd5f :: userdata <Sound>
    userdata: 0x007795a011cbe181 :: userdata <GamepadService>
    userdata: 0x00f72397f9631722 :: userdata <ImageLabel>
    userdata: 0x015f1d8d2d89c7fa :: userdata <MeshPart>
    userdata: 0x0174b33f740ab22d :: userdata <Frame>
    userdata: 0x01b9355856f888c7 :: userdata <Part>
    userdata: 0x0229e515d3ac1c61 :: userdata <Sound>
    userdata: 0x02575cabba648399 :: userdata <Sound>
    userdata: 0x02fab3ec6c9eb5fd :: userdata <UICorner>
    userdata: 0x0312243faf1db779 :: userdata <Frame>
    userdata: 0x03f5dacdeaa7b384 :: userdata <Model>
    userdata: 0x045bbbd9e3b3b8aa :: userdata <ScrollingFrame>
    userdata: 0x0485dcfe38474ef7 :: userdata <ModuleScript>
    userdata: 0x04cdcbb2dbca1c2e :: userdata <UIAspectRatioConstraint>
    userdata: 0x04df8910189e61d3 :: userdata <TextButton>
    userdata: 0x0515ea760c8835c4 :: userdata <Animation>
    userdata: 0x0572e711480eac59 :: userdata <MeshPart>
    userdata: 0x05ae139cd8b1a32a :: userdata <Animation>
    userdata: 0x0623944da1f3cfd1 :: userdata <ScrollingFrame>
    userdata: 0x062dc3775d5854b5 :: userdata <Sound>
    userdata: 0x062f075d505650c8 :: userdata <ModuleScript>
    userdata: 0x06bd8a4ddbb7a6b6 :: userdata <Tween>
    userdata: 0x06f51d8df15b0f35 :: userdata <Frame>
    userdata: 0x06f83aa5b0012c6a :: userdata <Lighting>
    userdata: 0x07b904dcb1c7f641 :: userdata <Sound>
    userdata: 0x07bde86b9f208ca4 :: userdata <ModuleScript>
    userdata: 0x07f7c13445d7b10f :: userdata <Sound>
    userdata: 0x0870da76831a67e2 :: userdata <ModuleScript>
    userdata: 0x087e56e9c2e0ef3f :: userdata <RemoteEvent>
    userdata: 0x0882229baf9054ba :: userdata <TextButton>
    userdata: 0x08ec34dd614795b1 :: userdata <Tween>
    userdata: 0x09751ae1f9733e9a :: userdata <Player>
    userdata: 0x09db6636bf93d6b2 :: userdata <ScrollingFrame>
    userdata: 0x0a9814efdc2e84e1 :: userdata <Humanoid>
    userdata: 0x0ae30e918b401860 :: userdata <UIGradient>
    userdata: 0x0af41d2348f31e71 :: userdata <Player>
    userdata: 0x0b2281c5a1bce35e :: userdata <NumberValue>
    userdata: 0x0b33c40d7a2f4c6d :: userdata <ModuleScript>
    userdata: 0x0bedb7bd14834958 :: userdata <ModuleScript>
    userdata: 0x0d0a66f12ff007e9 :: userdata <UIGradient>
    userdata: 0x0d1743c3962e4225 :: userdata <Sound>
    userdata: 0x0d4e89ccd778b33b :: userdata <Sound>
    userdata: 0x0d95c061a81d3593 :: userdata <ObjectValue>
    userdata: 0x0e4f6d607dfe32fb :: userdata <Part>
    userdata: 0x0e939d25aebf2816 :: userdata <Tween>
    userdata: 0x0ede07bfa03b0af8 :: userdata <Player>
    userdata: 0x0f06d0b4e98d0d25 :: userdata <Sound>
    userdata: 0x0f2ebf0c4abd8408 :: userdata <Sound>
    userdata: 0x0f6d4873a84c0f53 :: userdata <BindableEvent>
    userdata: 0x0fb0c257d22502ef :: userdata <Animation>
    userdata: 0x0fd7400159a0c4e2 :: userdata <Sound>
    userdata: 0x1034c6c0578b26fe :: userdata <Model>
    userdata: 0x10a24af681a87c5d :: userdata <Frame>
    userdata: 0x1101e97fd51b1170 :: userdata <ModuleScript>
    userdata: 0x1146af271b5c5ca8 :: userdata <ModuleScript>
    userdata: 0x119de0f88e02ff98 :: userdata <UIListLayout>
    userdata: 0x11b443781e1a8ace :: userdata <Sound>
    userdata: 0x120d7231ba80c385 :: userdata <ModuleScript>
    userdata: 0x12c046b5533a98a3 :: userdata <UIListLayout>
    userdata: 0x1307429cb97a6e3c :: userdata <NumberValue>
    userdata: 0x138177fb4c247dd4 :: userdata <UICorner>
    userdata: 0x13e2331fd4783446 :: userdata <ImageLabel>
    userdata: 0x1422ecd00d52baf7 :: userdata <Frame>
    userdata: 0x150578836bc87e6e :: userdata <Sound>
    userdata: 0x1575d71810cd14c8 :: userdata <Frame>
    userdata: 0x15c20039d9632bda :: userdata <Sound>
    userdata: 0x15f2b661336000b5 :: userdata <Player>
    userdata: 0x164fe9e427995fc6 :: userdata <Tween>
    userdata: 0x16ee36cfb855a2a4 :: userdata <ImageLabel>
    userdata: 0x17671d0dfb1738ba :: userdata <Tween>
    userdata: 0x176cbaf5d38c989c :: userdata <Tween>
    userdata: 0x1a70f8dc960aa9f8 :: userdata <Animation>
    userdata: 0x1be662e198e01357 :: userdata <ModuleScript>
    userdata: 0x1c5582013a0e1378 :: userdata <Sound>
    userdata: 0x1d1ffb717020c4d3 :: userdata <ModuleScript>
    userdata: 0x1d5ba4ddb869e737 :: userdata <Frame>
    userdata: 0x1d82c0f62185ee9c :: userdata <Part>
    userdata: 0x1dd7c0428a7daee7 :: userdata <Tween>
    userdata: 0x1e561d2cd461b3cc :: userdata <Sound>
    userdata: 0x1e6204cca6c99450 :: userdata <Sound>
    userdata: 0x1e747408dfbf10c2 :: userdata <Frame>
    userdata: 0x1ee2cc177cfb298e :: userdata <BindableEvent>
    userdata: 0x1f23cb89705df1c5 :: userdata <ModuleScript>
    userdata: 0x20ce97f3ea920c1c :: userdata <Tween>
    userdata: 0x218d6143a2ed17a9 :: userdata <ModuleScript>
    userdata: 0x224df5afd9ff5119 :: userdata <Sound>
    userdata: 0x229b12050d85187c :: userdata <ScreenGui>
    userdata: 0x22bdb5801a7d1cc4 :: userdata <Players>
    userdata: 0x2392c99de126ee26 :: userdata <ImageLabel>
    userdata: 0x23f6f34788b5cc3d :: userdata <Sound>
    userdata: 0x243c756a56a882ba :: userdata <NumberValue>
    userdata: 0x2495a36926e4f312 :: userdata <UICorner>
    userdata: 0x251faab2fa66aac5 :: userdata <Sound>
    userdata: 0x2571f01bfd49e4c2 :: userdata <ModuleScript>
    userdata: 0x25b4be9326966e86 :: userdata <UIListLayout>
    userdata: 0x25e9651b06b6e18b :: userdata <Sound>
    userdata: 0x25f04dca74cff146 :: userdata <ScreenGui>
    userdata: 0x26d2becc2c98891f :: userdata <ModuleScript>
    userdata: 0x26df6f24c73623f4 :: userdata <Sound>
    userdata: 0x26f75d1204c56c1e :: userdata <Sound>
    userdata: 0x2777dc3a07c84139 :: userdata <Sound>
    userdata: 0x28a64dce6742c546 :: userdata <Frame>
    userdata: 0x28c4f5cd554dc203 :: userdata <TextButton>
    userdata: 0x28cf8c6c595a6ada :: userdata <ScrollingFrame>
    userdata: 0x28ff9e429aae1394 :: userdata <Frame>
    userdata: 0x2952c80135729642 :: userdata <UIPadding>
    userdata: 0x2a3102e747b5ecc4 :: userdata <Model>
    userdata: 0x2a457080a53371b1 :: userdata <ImageLabel>
    userdata: 0x2ae5d65fd5ec7a1b :: userdata <MeshPart>
    userdata: 0x2b166fb6680bfde0 :: userdata <LocalScript>
    userdata: 0x2b67d3a108b6791b :: userdata <UICorner>
    userdata: 0x2b99e6246ffe5cd5 :: userdata <Part>
    userdata: 0x2bfb63a8ccebb800 :: userdata <Tween>
    userdata: 0x2c5cdf4f9d9c3266 :: userdata <LocalScript>
    userdata: 0x2ce6e8c793345558 :: userdata <Tween>
    userdata: 0x2d774e5854905776 :: userdata <ImageLabel>
    userdata: 0x2e060b59ba4ddd9a :: userdata <Tween>
    userdata: 0x2e3251759bf7f56f :: userdata <ObjectValue>
    userdata: 0x2e5eb292246fc89d :: userdata <Player>
    userdata: 0x2f34db984db3265c :: userdata <ImageLabel>
    userdata: 0x2fa461e92df093d7 :: userdata <ModuleScript>
    userdata: 0x3033c85b2502f24a :: userdata <ImageLabel>
    userdata: 0x3039cdb25303bac5 :: userdata <Player>
    userdata: 0x30a0d51475428880 :: userdata <Model>
    userdata: 0x30c3bb12d7215e60 :: userdata <Sound>
    userdata: 0x31297339d592ef7c :: userdata <UIGradient>
    userdata: 0x31666d3ed407dbe7 :: userdata <ModuleScript>
    userdata: 0x317d8358dc5a63b9 :: userdata <RunService>
    userdata: 0x31a270af4a1aa352 :: userdata <Frame>
    userdata: 0x3204ca5bc930ae3a :: userdata <Sound>
    userdata: 0x3308ae8e8daba182 :: userdata <Player>
    userdata: 0x3351e74e9372b539 :: userdata <UIListLayout>
    userdata: 0x33efd958870d7a76 :: userdata <Frame>
    userdata: 0x3536726f076c6d34 :: userdata <Tween>
    userdata: 0x3560170a84be048d :: userdata <Frame>
    userdata: 0x35e8e9ff6a4abf1a :: userdata <Sound>
    userdata: 0x368b0e62baaf6ff6 :: userdata <Tween>
    userdata: 0x369a23d64b46a256 :: userdata <Model>
    userdata: 0x36e6f9d589fdb32c :: userdata <Sound>
    userdata: 0x370987954e3f9275 :: userdata <Sound>
    userdata: 0x377cdf3c97aa6c1c :: userdata <Model>
    userdata: 0x3780316064f20c39 :: userdata <LocalScript>
    userdata: 0x383d87e10efca388 :: userdata <UIListLayout>
    userdata: 0x38b47ca215e150dc :: userdata <Frame>
    userdata: 0x39210f51a3a6a0be :: userdata <Player>
    userdata: 0x3993d244325c08c4 :: userdata <Animation>
    userdata: 0x3a932416cca62b7e :: userdata <Part>
    userdata: 0x3b6c1f1b5a0a2699 :: userdata <Camera>
    userdata: 0x3b9253692a7fea6b :: userdata <Sound>
    userdata: 0x3c115366b382121f :: userdata <TextLabel>
    userdata: 0x3caf383af86a90fd :: userdata <Frame>
    userdata: 0x3cc85eb2371af8bd :: userdata <MeshPart>
    userdata: 0x3e75305f7c83d1b8 :: userdata <Frame>
    userdata: 0x3edf8dc41241f053 :: userdata <Tween>
    userdata: 0x3eff60c607de5ce6 :: userdata <LocalScript>
    userdata: 0x3f9d29068e937c5d :: userdata <Sound>
    userdata: 0x4009c42ef5b2d02b :: userdata <DataModel>
    userdata: 0x402095a70fbf198f :: userdata <Tween>
    userdata: 0x40a754d8bae0f117 :: userdata <UIGradient>
    userdata: 0x40db347cf71b2124 :: userdata <TextButton>
    userdata: 0x412e612c40813a3b :: userdata <Model>
    userdata: 0x422facf5a8ed2f6e :: userdata <Sound>
    userdata: 0x4247bc505bb88ae1 :: userdata <Part>
    userdata: 0x4254bd30fde5e27c :: userdata <Sound>
    userdata: 0x42ec16908f6e08b5 :: userdata <Animation>
    userdata: 0x434e21060cabffd1 :: userdata <MeshPart>
    userdata: 0x43769cd669786db6 :: userdata <Sound>
    userdata: 0x4404d065a6798f41 :: userdata <Sound>
    userdata: 0x45ac0b8d02a6fbc2 :: userdata <ScrollingFrame>
    userdata: 0x45ad5d0c86f946d3 :: userdata <NumberValue>
    userdata: 0x45d8bdabcb7638b5 :: userdata <ImageButton>
    userdata: 0x47017ce40b6836fe :: userdata <Sound>
    userdata: 0x49b5314cd2d0aed1 :: userdata <Sound>
    userdata: 0x49b5bde72abbb9c2 :: userdata <Tween>
    userdata: 0x4a4211155a860365 :: userdata <Player>
    userdata: 0x4a50b3471ffde2fb :: userdata <Sound>
    userdata: 0x4b25a825a2f04ebd :: userdata <BindableEvent>
    userdata: 0x4b4479eec1568d61 :: userdata <Part>
    userdata: 0x4b5bb7e51e805f45 :: userdata <MeshPart>
    userdata: 0x4c10161a34feefd1 :: userdata <Sound>
    userdata: 0x4c165ff9c074b7e4 :: userdata <Frame>
    userdata: 0x4da1f95d86886337 :: userdata <MeshPart>
    userdata: 0x4dae617b6a66d19a :: userdata <Animation>
    userdata: 0x4e25618c9304f107 :: userdata <Part>
    userdata: 0x4eb9cbca941fdd8d :: userdata <Sound>
    userdata: 0x4ef865c741b437e9 :: userdata <Animation>
    userdata: 0x4f05a12d7119ad98 :: userdata <ScreenGui>
    userdata: 0x517fca023df1855a :: userdata <TextLabel>
    userdata: 0x5258d10f46096685 :: userdata <Sound>
    userdata: 0x5265bf2d97932ae1 :: userdata <TextButton>
    userdata: 0x526e28dbf974a2d0 :: userdata <Frame>
    userdata: 0x53a7165184add9fa :: userdata <Sound>
    userdata: 0x53f66ee6def68d4b :: userdata <Sound>
    userdata: 0x54d9e1b114ef31ff :: userdata <ModuleScript>
    userdata: 0x554d48c8c763f8ec :: userdata <Humanoid>
    userdata: 0x55cfc9acb02ee84b :: userdata <Sound>
    userdata: 0x567602f679587ceb :: userdata <GuiService>
    userdata: 0x588fa82d93ed7eca :: userdata <Frame>
    userdata: 0x58a6fda029761c4c :: userdata <TextButton>
    userdata: 0x59946158c57e5bf0 :: userdata <Sound>
    userdata: 0x5ab22aa53842ebac :: userdata <ModuleScript>
    userdata: 0x5b26dd4c971c8ba4 :: userdata <Sound>
    userdata: 0x5b5614f2b78ff32c :: userdata <MeshPart>
    userdata: 0x5b67cfa1c34569a2 :: userdata <Animation>
    userdata: 0x5b7300e58ea19db0 :: userdata <MeshPart>
    userdata: 0x5ba80b876af764cf :: userdata <Player>
    userdata: 0x5c7543941d029c2b :: userdata <UserInputService>
    userdata: 0x5cb7bfd830e5f011 :: userdata <Sound>
    userdata: 0x5ea5463a315fc150 :: userdata <Sound>
    userdata: 0x5efba5cb63809598 :: userdata <Sound>
    userdata: 0x5f9781da7bfb5ac4 :: userdata <Player>
    userdata: 0x5fbe069a0c1b3777 :: userdata <CollectionService>
    userdata: 0x60e43bbc0bbb7e22 :: userdata <ContextActionService>
    userdata: 0x6172470b564e6d39 :: userdata <UIPadding>
    userdata: 0x61a755ce902d1060 :: userdata <ModuleScript>
    userdata: 0x62bc2319c0e3a21d :: userdata <Tween>
    userdata: 0x6344487196730a5f :: userdata <TextButton>
    userdata: 0x635bdadb0085d3f7 :: userdata <Tween>
    userdata: 0x639733c41ad4a69f :: userdata <ImageLabel>
    userdata: 0x639f99929b6090e6 :: userdata <ScrollingFrame>
    userdata: 0x63af3377f35a1569 :: userdata <UIListLayout>
    userdata: 0x63af59fc1542da0d :: userdata <Sound>
    userdata: 0x63b2c16cd242c197 :: userdata <Tween>
    userdata: 0x642d7dd22b82fd6a :: userdata <Sound>
    userdata: 0x64a7f68ff384ed66 :: userdata <MeshPart>
    userdata: 0x64ffb88832c82243 :: userdata <Sound>
    userdata: 0x65a3d4d223c6c485 :: userdata <Sound>
    userdata: 0x66b98fef4a18ba64 :: userdata <Sound>
    userdata: 0x670b8678b6b1c700 :: userdata <Frame>
    userdata: 0x671b08f58e10e1e4 :: userdata <Frame>
    userdata: 0x671e93f393358ba8 :: userdata <Tween>
    userdata: 0x675f3b16c112e96d :: userdata <Frame>
    userdata: 0x6770b6be54a10dd6 :: userdata <Sound>
    userdata: 0x68527586db90d18f :: userdata <ScrollingFrame>
    userdata: 0x69539ec115ff9fe4 :: userdata <Frame>
    userdata: 0x695a25151f7a96a9 :: userdata <ScreenGui>
    userdata: 0x69cb6045a3bb54ba :: userdata <Part>
    userdata: 0x69fee9393deb3d07 :: userdata <Animation>
    userdata: 0x6a11924afaf6a8e3 :: userdata <TextButton>
    userdata: 0x6b1740eed2b40175 :: userdata <ImageLabel>
    userdata: 0x6bfc8db80dcfe1fd :: userdata <Frame>
    userdata: 0x6c627ce392bdb685 :: userdata <TextButton>
    userdata: 0x6c70da07b1494fd2 :: userdata <UICorner>
    userdata: 0x6ca6fb6fb6b40946 :: userdata <Sound>
    userdata: 0x6e06d3fa3bc25c11 :: userdata <Sound>
    userdata: 0x6e48a9eec47e1adf :: userdata <Sound>
    userdata: 0x6f53e06a92a7f46d :: userdata <Sound>
    userdata: 0x6f5459867c815dca :: userdata <UIAspectRatioConstraint>
    userdata: 0x6f58d75e6aa43fac :: userdata <Sound>
    userdata: 0x6f8d329603d8403b :: userdata <Sound>
    userdata: 0x6fc0a1f51ee20c81 :: userdata <Frame>
    userdata: 0x70348c914b0e01cd :: userdata <Tween>
    userdata: 0x709c44024e2f287d :: userdata <Animation>
    userdata: 0x70d5a35910d0f4d9 :: userdata <UICorner>
    userdata: 0x70d6192c5c1dfe57 :: userdata <UICorner>
    userdata: 0x70ed2cd86369f172 :: userdata <Tween>
    userdata: 0x7108914cbc5030bd :: userdata <VRService>
    userdata: 0x71173fee76dc5bb3 :: userdata <UIPadding>
    userdata: 0x71343b9eac9b0b72 :: userdata <Sound>
    userdata: 0x7202828595548fd0 :: userdata <Frame>
    userdata: 0x727ed0ea67cb0f50 :: userdata <TextButton>
    userdata: 0x72fbfbf4de1a60a9 :: userdata <Part>
    userdata: 0x73b2c6fbd04ea98c :: userdata <ModuleScript>
    userdata: 0x760c231ee9f3ed31 :: userdata <Sound>
    userdata: 0x7629ad46885683bc :: userdata <Humanoid>
    userdata: 0x7660ed77c5271f6b :: userdata <Part>
    userdata: 0x77f8082d48a3f9f9 :: userdata <PlayerGui>
    userdata: 0x78ddac4c3cada74b :: userdata <Tween>
    userdata: 0x798f8cfe3931ebe7 :: userdata <Animation>
    userdata: 0x79acf2e312485f65 :: userdata <TextButton>
    userdata: 0x7a1f9a54845a5885 :: userdata <TextButton>
    userdata: 0x7a5015d2b9404011 :: userdata <Humanoid>
    userdata: 0x7a7216206db7a771 :: userdata <ImageLabel>
    userdata: 0x7a7b1cbad2433b6e :: userdata <Sound>
    userdata: 0x7aa9852e1026c216 :: userdata <Part>
    userdata: 0x7b51ca2a953956cf :: userdata <Tween>
    userdata: 0x7b6e744855afde9d :: userdata <Part>
    userdata: 0x7bcd4993ce1b9747 :: userdata <Tween>
    userdata: 0x7c5226dbe1da6cb3 :: userdata <Sound>
    userdata: 0x7ca98af58e04ced0 :: userdata <Sound>
    userdata: 0x7caf00ca56ce6dba :: userdata <Sound>
    userdata: 0x7dd08d91a4d16e4b :: userdata <Frame>
    userdata: 0x7e95fe2d7a28dfe9 :: userdata <Frame>
    userdata: 0x805fe55984a7932f :: userdata <Model>
    userdata: 0x806d410c8132a637 :: userdata <Sound>
    userdata: 0x809afa273a9d377c :: userdata <Animation>
    userdata: 0x80c7f11c10e55b3f :: userdata <TextButton>
    userdata: 0x80d29dcf983e889b :: userdata <MeshPart>
    userdata: 0x821e9465f7eacc5e :: userdata <Sound>
    userdata: 0x8258f29f91bca04e :: userdata <Frame>
    userdata: 0x8283d1c02e2bed96 :: userdata <ScrollingFrame>
    userdata: 0x8298a9a0dac09259 :: userdata <ModuleScript>
    userdata: 0x82fd6c61d7f1e5a2 :: userdata <Sound>
    userdata: 0x835666912fe918a0 :: userdata <Frame>
    userdata: 0x837e68f3b71f75b1 :: userdata <RemoteFunction>
    userdata: 0x839a378355459523 :: userdata <LocalScript>
    userdata: 0x842571968f240b2e :: userdata <Tween>
    userdata: 0x859196f821162480 :: userdata <Frame>
    userdata: 0x86a9c8e791c2354f :: userdata <Frame>
    userdata: 0x8749cebfa22fbeac :: userdata <Animation>
    userdata: 0x87d00b2a0c925ba1 :: userdata <Sound>
    userdata: 0x884678c3c185c089 :: userdata <UICorner>
    userdata: 0x88b156e9c941840d :: userdata <Animation>
    userdata: 0x894cc4e38827d5ec :: userdata <Tween>
    userdata: 0x89816945e1c546ec :: userdata <AnimationTrack>
    userdata: 0x89bcc41927a55dfb :: userdata <UIListLayout>
    userdata: 0x89f876601682a860 :: userdata <ImageLabel>
    userdata: 0x8a061855f6364183 :: userdata <Animation>
    userdata: 0x8a940be3221d4c0a :: userdata <Sound>
    userdata: 0x8aeab16d1f762854 :: userdata <Sound>
    userdata: 0x8b0653e3cf4c17bb :: userdata <ModuleScript>
    userdata: 0x8bae3f4ff1b302d1 :: userdata <ModuleScript>
    userdata: 0x8bee4ac1b9687cc7 :: userdata <TextLabel>
    userdata: 0x8c79ad1e70d99a32 :: userdata <Frame>
    userdata: 0x8ca9e69e50fa8b3a :: userdata <ModuleScript>
    userdata: 0x8dc0cd42548dc5a8 :: userdata <Sound>
    userdata: 0x8de8709b02a046ca :: userdata <Sound>
    userdata: 0x8ea6ac6c4f3bad5e :: userdata <Part>
    userdata: 0x8ef1207c4372f4eb :: userdata <Tween>
    userdata: 0x8f2de1bb9f7d0c93 :: userdata <Tween>
    userdata: 0x8f52ef08040a9b49 :: userdata <Sound>
    userdata: 0x8fcc976f6ab7ff09 :: userdata <Sound>
    userdata: 0x8ff5018779b22bc1 :: userdata <Sound>
    userdata: 0x90c1ae3ef0d3dd75 :: userdata <Animation>
    userdata: 0x911ece8730bdcf63 :: userdata <UICorner>
    userdata: 0x927dbcfba4c0ac13 :: userdata <ModuleScript>
    userdata: 0x92a1a193c794f2a9 :: userdata <Humanoid>
    userdata: 0x92d8e1822fa95c43 :: userdata <BindableEvent>
    userdata: 0x930502506c7614e1 :: userdata <MeshPart>
    userdata: 0x93309770dd098652 :: userdata <Sound>
    userdata: 0x9444ceb230af87f1 :: userdata <Folder>
    userdata: 0x9518d5d10b10e5fa :: userdata <Sound>
    userdata: 0x95b27d24742cf9af :: userdata <Sound>
    userdata: 0x95e222f9507d5e1f :: userdata <Tween>
    userdata: 0x95e6e8aab8ef99fe :: userdata <Model>
    userdata: 0x96119023ffa1c7b5 :: userdata <Humanoid>
    userdata: 0x9699220bb6b1c42e :: userdata <TweenService>
    userdata: 0x97273fa41b8ee371 :: userdata <Part>
    userdata: 0x9a060fdb36f1fd02 :: userdata <Tween>
    userdata: 0x9a113bb4c735ab31 :: userdata <BindableEvent>
    userdata: 0x9a442ef8a7854454 :: userdata <UserGameSettings>
    userdata: 0x9a6f873dc6ad3203 :: userdata <ModuleScript>
    userdata: 0x9ac08fe084fd3798 :: userdata <TextButton>
    userdata: 0x9acae1314294112f :: userdata <ModuleScript>
    userdata: 0x9ad32a0040ce9420 :: userdata <Model>
    userdata: 0x9ade90eb8b050122 :: userdata <BindableEvent>
    userdata: 0x9cff8f2dae06f750 :: userdata <Frame>
    userdata: 0x9ed5c0ee5f6f7525 :: userdata <Frame>
    userdata: 0x9ee28efe248c4f82 :: userdata <Sound>
    userdata: 0x9efd28229196faa9 :: userdata <Animation>
    userdata: 0x9f7c1f56315841b2 :: userdata <Frame>
    userdata: 0x9feb95759a4356ab :: userdata <Tween>
    userdata: 0xa01f5ca932154a1b :: userdata <ModuleScript>
    userdata: 0xa14ed0e1f4e02f09 :: userdata <Frame>
    userdata: 0xa22c55e161adbc3e :: userdata <Frame>
    userdata: 0xa247a4f8c2e83e1b :: userdata <TextLabel>
    userdata: 0xa290fff391e6b403 :: userdata <Sound>
    userdata: 0xa2923a3a6fefa6c6 :: userdata <Frame>
    userdata: 0xa293798e2fb0b25d :: userdata <Model>
    userdata: 0xa3a907d8d7aca421 :: userdata <LocalScript>
    userdata: 0xa3d239ffa1936323 :: userdata <ImageLabel>
    userdata: 0xa4fc3b9456e955a6 :: userdata <Tween>
    userdata: 0xa54902d3aa103c56 :: userdata <Sound>
    userdata: 0xa5f0f10388bea9f2 :: userdata <ModuleScript>
    userdata: 0xa6524a17a1dc5ae9 :: userdata <ModuleScript>
    userdata: 0xa6bcb597f9176cdd :: userdata <AvatarEditorService>
    userdata: 0xa7b5a29a5108d165 :: userdata <TextButton>
    userdata: 0xa86df6c9f5d3c8a9 :: userdata <StarterGui>
    userdata: 0xa98ed7131db0e97d :: userdata <Animation>
    userdata: 0xa99a6a1550757359 :: userdata <Sound>
    userdata: 0xaa4e6dfc64f06841 :: userdata <CanvasGroup>
    userdata: 0xaa60e74f692642c9 :: userdata <TextLabel>
    userdata: 0xab17185f503aaaac :: userdata <Sound>
    userdata: 0xaca3bd846a88346a :: userdata <Humanoid>
    userdata: 0xacf7e73d438b5e86 :: userdata <Animation>
    userdata: 0xaee24f92f7116273 :: userdata <Sound>
    userdata: 0xaf2318fa48de7105 :: userdata <UICorner>
    userdata: 0xaf496d04e4f3270a :: userdata <PathfindingService>
    userdata: 0xaf9f34c2dbbbc626 :: userdata <Frame>
    userdata: 0xafe141e57c9c4666 :: userdata <Part>
    userdata: 0xb0b9164105dadfb4 :: userdata <ImageLabel>
    userdata: 0xb2bb207963d0832b :: userdata <ModuleScript>
    userdata: 0xb342dd68ad11ede5 :: userdata <MeshPart>
    userdata: 0xb46869331a100d15 :: userdata <Sound>
    userdata: 0xb51dbea542e71b75 :: userdata <Sound>
    userdata: 0xb570bc10e67b434d :: userdata <Model>
    userdata: 0xb5b1f502dc1fe913 :: userdata <ScrollingFrame>
    userdata: 0xb6e951d14358de2f :: userdata <Sound>
    userdata: 0xb773a1f1c902d892 :: userdata <ModuleScript>
    userdata: 0xb79a39ef40f7507a :: userdata <MeshPart>
    userdata: 0xb8017302889213c4 :: userdata <Humanoid>
    userdata: 0xb807537a614c8357 :: userdata <Player>
    userdata: 0xb96714b3443a8f4f :: userdata <BindableEvent>
    userdata: 0xb9863748b84d1a5d :: userdata <ModuleScript>
    userdata: 0xbadc79c74a11f517 :: userdata <Sound>
    userdata: 0xbb02c4ed4de5de4e :: userdata <Sound>
    userdata: 0xbb58232feadf64d6 :: userdata <Animation>
    userdata: 0xbb9a38a35e2e88a9 :: userdata <Sound>
    userdata: 0xbc3a085c0c77234c :: userdata <Sound>
    userdata: 0xbd9ba0bb576dc6e7 :: userdata <Sound>
    userdata: 0xbdcf2159a5aeaf02 :: userdata <ImageLabel>
    userdata: 0xbdeb46ed6a3c7f81 :: userdata <Frame>
    userdata: 0xbdfd59224740f428 :: userdata <ScrollingFrame>
    userdata: 0xbe3da6ef10a9f368 :: userdata <Sound>
    userdata: 0xbe753491b1c7b05b :: userdata <BoolValue>
    userdata: 0xbebcc2058d17b503 :: userdata <Sound>
    userdata: 0xbecea60c675e6424 :: userdata <UIListLayout>
    userdata: 0xbff68dee1b6051f3 :: userdata <Sound>
    userdata: 0xc0b00cbcdb8eba46 :: userdata <TextButton>
    userdata: 0xc127105deb2940b5 :: userdata <Player>
    userdata: 0xc12bc63bcd09410c :: userdata <ModuleScript>
    userdata: 0xc162f2b1d5383b25 :: userdata <Humanoid>
    userdata: 0xc1a39a3b7bea1503 :: userdata <MeshPart>
    userdata: 0xc1a9793753ee5dab :: userdata <ModuleScript>
    userdata: 0xc2c6019e4bb5ced3 :: userdata <Tween>
    userdata: 0xc39807f7a3280250 :: userdata <ImageLabel>
    userdata: 0xc3b6b4dbf655c08b :: userdata <Sound>
    userdata: 0xc3d815c629a66ea5 :: userdata <UIPadding>
    userdata: 0xc4bebb7d84ae4f06 :: userdata <LocalScript>
    userdata: 0xc4d001f525aadccc :: userdata <Humanoid>
    userdata: 0xc50cd4fc9ac68b14 :: userdata <Frame>
    userdata: 0xc52b7c3a9b80f320 :: userdata <Sound>
    userdata: 0xc575fdec4f59f108 :: userdata <UIListLayout>
    userdata: 0xc6a178992249e4ff :: userdata <Workspace>
    userdata: 0xc6cd26061950372b :: userdata <Sound>
    userdata: 0xc73299eacc51b84e :: userdata <Tween>
    userdata: 0xc7d844dfd18d1f33 :: userdata <Sound>
    userdata: 0xc80c2bba9b771b8f :: userdata <Frame>
    userdata: 0xc8357fa8c23930fb :: userdata <ModuleScript>
    userdata: 0xc871fe6af64e24a1 :: userdata <CanvasGroup>
    userdata: 0xc87987a906601e1c :: userdata <Sound>
    userdata: 0xc95e77a6b2169b47 :: userdata <ModuleScript>
    userdata: 0xca4b749a7f661de0 :: userdata <Part>
    userdata: 0xcab931bcbfce3f31 :: userdata <Model>
    userdata: 0xcaf0c13886aceacc :: userdata <Sound>
    userdata: 0xcb2c8437b9525a0c :: userdata <SoundService>
    userdata: 0xcbadbe6e28456090 :: userdata <Sound>
    userdata: 0xcbff334af2fabddd :: userdata <ModuleScript>
    userdata: 0xccfb7ce5390a788e :: userdata <Sound>
    userdata: 0xcd5f13fd45911e01 :: userdata <Frame>
    userdata: 0xcda19dd114f2a6c7 :: userdata <TextLabel>
    userdata: 0xcef3846e9b6a0f9d :: userdata <BindableEvent>
    userdata: 0xcf6b88ab4d9d9efe :: userdata <MeshPart>
    userdata: 0xcfe998355da71018 :: userdata <ScreenGui>
    userdata: 0xd0885021015ce404 :: userdata <ModuleScript>
    userdata: 0xd0e8c5e6b6f21c41 :: userdata <Frame>
    userdata: 0xd126379919a74e45 :: userdata <Frame>
    userdata: 0xd1f68d88544aeb4a :: userdata <ReplicatedStorage>
    userdata: 0xd21a03d7bbef3a5b :: userdata <Animation>
    userdata: 0xd23aff6e7b1d7680 :: userdata <Tween>
    userdata: 0xd3235bc9686ea3ff :: userdata <ImageLabel>
    userdata: 0xd3582fa7450b473d :: userdata <ModuleScript>
    userdata: 0xd377a0dc6e5185e1 :: userdata <Sound>
    userdata: 0xd37b829fab11e761 :: userdata <Tween>
    userdata: 0xd3b8231321da017a :: userdata <ImageLabel>
    userdata: 0xd3f7e19ce0ccda8d :: userdata <Player>
    userdata: 0xd48770f506ddad13 :: userdata <Frame>
    userdata: 0xd52c429c318332d4 :: userdata <ModuleScript>
    userdata: 0xd55f57d2eccc3d38 :: userdata <Sound>
    userdata: 0xd6a7dd02c25f0cad :: userdata <Tween>
    userdata: 0xd6ac16d7f56bcb57 :: userdata <Frame>
    userdata: 0xd737617034b5a5e9 :: userdata <Frame>
    userdata: 0xd8957351bba7c048 :: userdata <BindableEvent>
    userdata: 0xd92833d21a3d2aed :: userdata <Frame>
    userdata: 0xd93b7482e174585c :: userdata <Tween>
    userdata: 0xd97f3892702f667c :: userdata <UICorner>
    userdata: 0xd98e7e3cc63253c0 :: userdata <Sound>
    userdata: 0xd992c5c5a74ebbfd :: userdata <Sound>
    userdata: 0xd996efaa28975869 :: userdata <Sound>
    userdata: 0xda4c33e514e40269 :: userdata <ImageLabel>
    userdata: 0xda9f8614c0782007 :: userdata <TextButton>
    userdata: 0xdaab9414c6ddb354 :: userdata <ModuleScript>
    userdata: 0xdab2e97cd03b94c4 :: userdata <Tween>
    userdata: 0xdac20e00b3d109cb :: userdata <MeshPart>
    userdata: 0xdb3dfc5bc99d7b4e :: userdata <Frame>
    userdata: 0xdbb0ad855c7cf564 :: userdata <ModuleScript>
    userdata: 0xdc09eb2f0d286fd1 :: userdata <ImageLabel>
    userdata: 0xdc24460625f38875 :: userdata <MeshPart>
    userdata: 0xdc7ed17cffb86c7e :: userdata <Humanoid>
    userdata: 0xdcc9c090a1f5f434 :: userdata <Frame>
    userdata: 0xdd43e36be1fcde76 :: userdata <Model>
    userdata: 0xdd8a7a0a997d5162 :: userdata <UIListLayout>
    userdata: 0xdda7168722fc692f :: userdata <TextButton>
    userdata: 0xddcccf3dd4a8bcca :: userdata <Folder>
    userdata: 0xde2bc68aaddb3858 :: userdata <Animation>
    userdata: 0xde3e27228675f776 :: userdata <UICorner>
    userdata: 0xde6e898708c984ff :: userdata <Animation>
    userdata: 0xde7200efd621f32f :: userdata <Frame>
    userdata: 0xdebd646810339241 :: userdata <Frame>
    userdata: 0xdf5f57772e25efb8 :: userdata <Frame>
    userdata: 0xdff5b98013022173 :: userdata <Frame>
    userdata: 0xe0523f8b160d632c :: userdata <Frame>
    userdata: 0xe124a11918516580 :: userdata <Part>
    userdata: 0xe1769cc8a698fb05 :: userdata <Frame>
    userdata: 0xe27c804af6a5840a :: userdata <Sound>
    userdata: 0xe282416cd97b7d97 :: userdata <Frame>
    userdata: 0xe2f461e69cc92f6f :: userdata <ModuleScript>
    userdata: 0xe3b5d76ce5566c6e :: userdata <ImageLabel>
    userdata: 0xe557fa413c31f9b4 :: userdata <ModuleScript>
    userdata: 0xe716a68837a3a2d5 :: userdata <Tween>
    userdata: 0xe728513433b72522 :: userdata <UICorner>
    userdata: 0xe7ae9bf04433adfd :: userdata <MeshPart>
    userdata: 0xe7c89e2822396dc6 :: userdata <UIAspectRatioConstraint>
    userdata: 0xe84e48b59341a411 :: userdata <TextLabel>
    userdata: 0xe8719c95a2c283e9 :: userdata <ModuleScript>
    userdata: 0xe8cb855467247807 :: userdata <TextButton>
    userdata: 0xe94b1756e70781da :: userdata <Sound>
    userdata: 0xe96253f28295f5dc :: userdata <UICorner>
    userdata: 0xe9e6563866fd0192 :: userdata <ScreenGui>
    userdata: 0xe9f0e94df14c886c :: userdata <Sound>
    userdata: 0xea0783c75bb4b872 :: userdata <UICorner>
    userdata: 0xeab4731664b88b96 :: userdata <NumberValue>
    userdata: 0xeaba22d8f408e0c6 :: userdata <Sound>
    userdata: 0xeb1781ffec88840e :: userdata <UICorner>
    userdata: 0xeb999118b12a5127 :: userdata <MeshPart>
    userdata: 0xebcc52f72814481c :: userdata <MeshPart>
    userdata: 0xebf7324dfcd3192b :: userdata <MeshPart>
    userdata: 0xedcde9f965a0eec8 :: userdata <Sound>
    userdata: 0xf00fc05d81580fe9 :: userdata <TextButton>
    userdata: 0xf04a98765c08d526 :: userdata <UICorner>
    userdata: 0xf054ea2f61e96115 :: userdata <ModuleScript>
    userdata: 0xf0d247ca15195b1c :: userdata <Frame>
    userdata: 0xf1d0cd2335ba313a :: userdata <Humanoid>
    userdata: 0xf1e7c02e0ccee5d0 :: userdata <Sound>
    userdata: 0xf38a85dcfda9b6ea :: userdata <Sound>
    userdata: 0xf3cd89b8b500612b :: userdata <Sound>
    userdata: 0xf477944599b54391 :: userdata <Animation>
    userdata: 0xf4c2d9cfb9e59a9d :: userdata <UIGradient>
    userdata: 0xf4e15b42ed8c12f0 :: userdata <Sound>
    userdata: 0xf4e2912e6bb81fad :: userdata <ImageLabel>
    userdata: 0xf570134d11a26207 :: userdata <MeshPart>
    userdata: 0xf5ab34ceef25e6e5 :: userdata <Sound>
    userdata: 0xf5d8ff747435534e :: userdata <Sound>
    userdata: 0xf617f71e274953b7 :: userdata <ModuleScript>
    userdata: 0xf6287c62f61f2cad :: userdata <Frame>
    userdata: 0xf6f12a296792720e :: userdata <Frame>
    userdata: 0xf72367ac723d8397 :: userdata <Animation>
    userdata: 0xf745db2b5be58004 :: userdata <ModuleScript>
    userdata: 0xf7591da3959abff5 :: userdata <ModuleScript>
    userdata: 0xf770b344faaa0834 :: userdata <UIGradient>
    userdata: 0xf77ae4ce91a48f89 :: userdata <Frame>
    userdata: 0xf7d3c27aab31f42c :: userdata <Sound>
    userdata: 0xf8b4937a6b048d2c :: userdata <MeshPart>
    userdata: 0xf8b8101c13860ba5 :: userdata <Sound>
    userdata: 0xf8d3f819852e0a88 :: userdata <InputObject>
    userdata: 0xf9bc16be13d3a150 :: userdata <ModuleScript>
    userdata: 0xf9fdea8bca4b896f :: userdata <ScrollingFrame>
    userdata: 0xfb280acf5d9b67c1 :: userdata <Sound>
    userdata: 0xfb46f0cf65f9f91a :: userdata <LocalScript>
    userdata: 0xfbb2141890e1a702 :: userdata <UICorner>
    userdata: 0xfbd5ffdd108f1a49 :: userdata <Humanoid>
    userdata: 0xfc93af09ba6ff5bd :: userdata <Humanoid>
    userdata: 0xfca33f545debb1a7 :: userdata <Frame>
    userdata: 0xfcb15079bd898fca :: userdata <UIListLayout>
    userdata: 0xfd6b792a9c21d41b :: userdata <Tween>
    userdata: 0xfdf80bd04985dc4c :: userdata <ContentProvider>
    userdata: 0xfe455b068e248282 :: userdata <Sound>
    userdata: 0xfe513338b3aab46f :: userdata <Animation>
    userdata: 0xfed96bb00e4d4eb6 :: userdata <ScreenGui>
    userdata: 0xff0a564dda9cfd28 :: userdata <Frame>
    userdata: 0xff3eedf169e3618e :: userdata <ModuleScript>
    userdata: 0xff550096dc9e7cc3 :: userdata <Frame>
    userdata: 0xffc27661d17912a9 :: userdata <ModuleScript>
  userdata: 0x8a4c49b26fd65cdf :: table [1 claves]
    __mode :: string ("kvs")
  userdata: 0xc95798cdaf494329 :: table [1 claves]
    userdata: 0xfb339930e728b16a :: userdata
  userdata: 0xe383f70078e55553 :: table [456 claves]
    userdata: 0x0028b5a72d5342b8 :: userdata
    userdata: 0x012c574e8d065d42 :: userdata
    userdata: 0x04108ebab184f626 :: userdata
    userdata: 0x046fa7aa23d1d530 :: userdata
    userdata: 0x0485ec2030b53a73 :: userdata
    userdata: 0x0493165006b04f56 :: userdata
    userdata: 0x081e8b8ecc8b67cc :: userdata
    userdata: 0x086a4a2eaa4c46cf :: userdata
    userdata: 0x08a4f45c70406110 :: userdata
    userdata: 0x08aedc48777ff083 :: userdata
    userdata: 0x09c3dc847ed97bdc :: userdata
    userdata: 0x09f2e4718299daec :: userdata
    userdata: 0x0a2c07d36ab51973 :: userdata
    userdata: 0x0b62762894fe83ed :: userdata
    userdata: 0x0c680855f599123b :: userdata
    userdata: 0x0cae93b9e7e97ee2 :: userdata
    userdata: 0x0cc3ac76aff90f41 :: userdata
    userdata: 0x0ce0ea9363107202 :: userdata
    userdata: 0x0d7015100cfae586 :: userdata
    userdata: 0x0dc12ed8abb29218 :: userdata
    userdata: 0x0dc7720497629d0d :: userdata
    userdata: 0x0ddde6dfcf762bfe :: userdata
    userdata: 0x0efa3af363912c1d :: userdata
    userdata: 0x0f6f37ec2ed72c90 :: userdata
    userdata: 0x0f7aac135ecb8b3b :: userdata
    userdata: 0x102adfee1d28871c :: userdata
    userdata: 0x106c7b3da32a8635 :: userdata
    userdata: 0x10d72f66ec29af87 :: userdata
    userdata: 0x11a1a854c950b91f :: userdata
    userdata: 0x11c3f920d49a3402 :: userdata
    userdata: 0x126b571986917274 :: userdata
    userdata: 0x12dfbf9ba768ba4c :: userdata
    userdata: 0x138a94de2d9f8ab5 :: userdata
    userdata: 0x1408556676dd6b30 :: userdata
    userdata: 0x1493c2bdb4cbea1c :: userdata
    userdata: 0x14eda215dbe66ff2 :: userdata
    userdata: 0x16caabedb6f2e4ef :: userdata
    userdata: 0x16f599fbee9f63b4 :: userdata
    userdata: 0x1733727dd7bf208f :: userdata
    userdata: 0x1775d2b344e6134b :: userdata
    userdata: 0x1987e0caa1f85274 :: userdata
    userdata: 0x19aa9f694b24e108 :: userdata
    userdata: 0x1a0d8ce9894f3c38 :: userdata
    userdata: 0x1a9e24cbfaec3b01 :: userdata
    userdata: 0x1aaf47d7746a5788 :: userdata
    userdata: 0x1b0ee9ae2bb83966 :: userdata
    userdata: 0x1c596f2ea1e08c04 :: userdata
    userdata: 0x1c8199b9cf0741f6 :: userdata
    userdata: 0x1d05fee8c1c6ef31 :: userdata
    userdata: 0x1e79f0aa1695b705 :: userdata
    userdata: 0x1f9035918470da18 :: userdata
    userdata: 0x2059ebc1ef774b5b :: userdata
    userdata: 0x209c23001ea6515b :: userdata
    userdata: 0x215684f279ee3320 :: userdata
    userdata: 0x21a7d3fe6612b858 :: userdata
    userdata: 0x233c14f5ea9d95b6 :: userdata
    userdata: 0x23b2aad9b18e9c7f :: userdata
    userdata: 0x240d73be3a2d42ac :: userdata
    userdata: 0x24fb9ab4c150e11b :: userdata
    userdata: 0x2612970c16bd260f :: userdata
    userdata: 0x26235d5c64db2e31 :: userdata
    userdata: 0x26795fd9eee7cf02 :: userdata
    userdata: 0x276592824c2f996a :: userdata
    userdata: 0x283d4f9df5725b14 :: userdata
    userdata: 0x28ed0f7f2627db1d :: userdata
    userdata: 0x2927e5c933c041c4 :: userdata
    userdata: 0x294fe2e81c13c1e7 :: userdata
    userdata: 0x29d9c8e194523615 :: userdata
    userdata: 0x2a86ed30fdc81d8c :: userdata
    userdata: 0x2b016ccd10e31d15 :: userdata
    userdata: 0x2bcdbb2ea65d7287 :: userdata
    userdata: 0x2c2184ad7c5f5316 :: userdata
    userdata: 0x2c2984e355eb28ac :: userdata
    userdata: 0x2c4f133a45cc6d44 :: userdata
    userdata: 0x2cbb359276eacf9e :: userdata
    userdata: 0x2e0caaadcb8edc3a :: userdata
    userdata: 0x2ee6c4312ff20e90 :: userdata
    userdata: 0x2ef7972cb681780f :: userdata
    userdata: 0x2f10c4b9531f2457 :: userdata
    userdata: 0x2f424b1f0bf439e0 :: userdata
    userdata: 0x2f5f0640a6e75ac5 :: userdata
    userdata: 0x30001db409cddb79 :: userdata
    userdata: 0x318e0da752219d95 :: userdata
    userdata: 0x31b581924c0f3fca :: userdata
    userdata: 0x320bdef060755e94 :: userdata
    userdata: 0x32270cc088cdfc25 :: userdata
    userdata: 0x32e639a8facf68b7 :: userdata
    userdata: 0x33b9da20b9e56756 :: userdata
    userdata: 0x343c622064252c35 :: userdata
    userdata: 0x34be472b7e5b76b5 :: userdata
    userdata: 0x34fe5fc8941fb44d :: userdata
    userdata: 0x353049f8ffaba3f4 :: userdata
    userdata: 0x3551ed91bef3e093 :: userdata
    userdata: 0x36713768495d2166 :: userdata
    userdata: 0x3714ae064f5bdffc :: userdata
    userdata: 0x37b0b4f5fc9b3f67 :: userdata
    userdata: 0x37d188862fd62c4b :: userdata
    userdata: 0x38802a3130d4f63a :: userdata
    userdata: 0x38f6e2248a083946 :: userdata
    userdata: 0x3900d6c701ba8885 :: userdata
    userdata: 0x3903c4db8057e3f3 :: userdata
    userdata: 0x3920e3167b8a9fd3 :: userdata
    userdata: 0x3983d16859948be8 :: userdata
    userdata: 0x3a47dc385d82ddb7 :: userdata
    userdata: 0x3aa959ca3a717ff0 :: userdata
    userdata: 0x3abb2f6da19714ac :: userdata
    userdata: 0x3b0d0b12de2d0ec7 :: userdata
    userdata: 0x3d881cfbbe86e6c0 :: userdata
    userdata: 0x3e7d9d7692027337 :: userdata
    userdata: 0x3edf27b14abdbf80 :: userdata
    userdata: 0x40285ea37d7cf69d :: userdata
    userdata: 0x41c613ba96d9b319 :: userdata
    userdata: 0x42509fc689ef82c0 :: userdata
    userdata: 0x433a1c7e54bbccc9 :: userdata
    userdata: 0x43fe9a52bed2d9ee :: userdata
    userdata: 0x442907a398194e7e :: userdata
    userdata: 0x44d01fae8e439147 :: userdata
    userdata: 0x46a3811629612d3b :: userdata
    userdata: 0x46bdab5940ab7f16 :: userdata
    userdata: 0x472bcafeab044cf2 :: userdata
    userdata: 0x4764199358551d0e :: userdata
    userdata: 0x47990841d0ab2b08 :: userdata
    userdata: 0x47be33efea32085e :: userdata
    userdata: 0x48acc75588eddaec :: userdata
    userdata: 0x49444f9e79899f1f :: userdata
    userdata: 0x49b1ca46f1d184f9 :: userdata
    userdata: 0x49bb895058df4312 :: userdata
    userdata: 0x49f9235a4f4049ae :: userdata
    userdata: 0x4a9577b05e4a5d74 :: userdata
    userdata: 0x4b169125fd87965e :: userdata
    userdata: 0x4cb6d95a1fe9d995 :: userdata
    userdata: 0x4cf8c8c820120739 :: userdata
    userdata: 0x4e71d3da57b25b44 :: userdata
    userdata: 0x4f06b6121ffd16e3 :: userdata
    userdata: 0x4f417ccb461041b3 :: userdata
    userdata: 0x4f6c90d3165b5d3a :: userdata
    userdata: 0x4f84d4d00ef747d0 :: userdata
    userdata: 0x50d71fa33f2175df :: userdata
    userdata: 0x50e37d50915b2170 :: userdata
    userdata: 0x50ff1122092ef1b8 :: userdata
    userdata: 0x514aac9242f4db06 :: userdata
    userdata: 0x51d2f934805ef5a6 :: userdata
    userdata: 0x5359d91161a5ffac :: userdata
    userdata: 0x53a987cd641bc1e7 :: userdata
    userdata: 0x540a1bf1de7bcf5f :: userdata
    userdata: 0x562753114c6dce05 :: userdata
    userdata: 0x56d2163e1e26af5b :: userdata
    userdata: 0x5940b1c4e52c14d3 :: userdata
    userdata: 0x5a29d4a3e443c4f5 :: userdata
    userdata: 0x5a2c7a2f72667c7c :: userdata
    userdata: 0x5a5494eedff25193 :: userdata
    userdata: 0x5a8a5c81cb027152 :: userdata
    userdata: 0x5af6bec9d8d22879 :: userdata
    userdata: 0x5b5f4ee916b073fd :: userdata
    userdata: 0x5b66fe06609e77e4 :: userdata
    userdata: 0x5b7820cdb70a94c7 :: userdata
    userdata: 0x5bde80dfe8d159fc :: userdata
    userdata: 0x5cc88090391860aa :: userdata
    userdata: 0x5d4b5ab6323ba6a8 :: userdata
    userdata: 0x5e472595c6290f15 :: userdata
    userdata: 0x5e68c2f7adbd417d :: userdata
    userdata: 0x5f55039431e78225 :: userdata
    userdata: 0x5f84864f93263953 :: userdata
    userdata: 0x5fd1c4e34ea1d9eb :: userdata
    userdata: 0x601f5d3fae0d97ec :: userdata
    userdata: 0x61d7da986cd66e60 :: userdata
    userdata: 0x620ae0be0a6a4df0 :: userdata
    userdata: 0x62d6a3cd7693dff8 :: userdata
    userdata: 0x6309f5fb32b8d54e :: userdata
    userdata: 0x6350453a181cc3d9 :: userdata
    userdata: 0x641ed4162ed11c30 :: userdata
    userdata: 0x64e3d4c77f16566a :: userdata
    userdata: 0x65011c6a66877ee7 :: userdata
    userdata: 0x652095f53edc785c :: userdata
    userdata: 0x65347be54cb93cd7 :: userdata
    userdata: 0x662f8820cd9c0fd4 :: userdata
    userdata: 0x672ada7190f84266 :: userdata
    userdata: 0x6764e263e6e9255c :: userdata
    userdata: 0x67f8e4cb6115d940 :: userdata
    userdata: 0x68247554919bcb03 :: userdata
    userdata: 0x68f4159195083075 :: userdata
    userdata: 0x6be99bff1098c54c :: userdata
    userdata: 0x6c30cfbdbfa1bc67 :: userdata
    userdata: 0x6ca48c51a7e23309 :: userdata
    userdata: 0x6d10f01137d28302 :: userdata
    userdata: 0x6d5f37291932478b :: userdata
    userdata: 0x6d8b0320350821f9 :: userdata
    userdata: 0x6dd0ad0d43385134 :: userdata
    userdata: 0x6e0dcf612afaa64b :: userdata
    userdata: 0x6e898aaa2e32a7d9 :: userdata
    userdata: 0x6edc28511a17925e :: userdata
    userdata: 0x6fd62eebb5e11ecf :: userdata
    userdata: 0x70570f9862b14d66 :: userdata
    userdata: 0x70e51e6cdb183ad6 :: userdata
    userdata: 0x71554c9af9fafbb8 :: userdata
    userdata: 0x71e0770275ef0546 :: userdata
    userdata: 0x7204d47160853020 :: userdata
    userdata: 0x7208dc49304aa070 :: userdata
    userdata: 0x738adad63111a1bb :: userdata
    userdata: 0x73b57384fb3e6bf0 :: userdata
    userdata: 0x74a13ecaf2ba10fd :: userdata
    userdata: 0x7521e6d67326a55d :: userdata
    userdata: 0x75c4adb728695d42 :: userdata
    userdata: 0x75cb3dd36aa65786 :: userdata
    userdata: 0x75ebc53bb4338dcc :: userdata
    userdata: 0x75ff0d8be515186a :: userdata
    userdata: 0x76a316ffc6267ec5 :: userdata
    userdata: 0x76c1a73a805d91b3 :: userdata
    userdata: 0x77ef56539ef2e5c0 :: userdata
    userdata: 0x77f64612cb2c3806 :: userdata
    userdata: 0x7865dc8a62877f44 :: userdata
    userdata: 0x79b1b422573116e9 :: userdata
    userdata: 0x7a0673c5da6895a5 :: userdata
    userdata: 0x7a0b7bc8c8d834ea :: userdata
    userdata: 0x7a2f164876eceb0f :: userdata
    userdata: 0x7c14a1b21df7f2d6 :: userdata
    userdata: 0x7c4a5acad0004d14 :: userdata
    userdata: 0x7c6332cbaf8cc48d :: userdata
    userdata: 0x7d43f346b4ec15dc :: userdata
    userdata: 0x7d8cce079f56975c :: userdata
    userdata: 0x7dff5c8ecfcaba04 :: userdata
    userdata: 0x7e478c8dc020d7af :: userdata
    userdata: 0x7e758f68b5d99d31 :: userdata
    userdata: 0x7ec5bfc7743617e1 :: userdata
    userdata: 0x80949c5f0c2c8d1b :: userdata
    userdata: 0x81c823c5eefda118 :: userdata
    userdata: 0x81cccd0c960ac427 :: userdata
    userdata: 0x824d2bff28724ee3 :: userdata
    userdata: 0x82629f599e92a365 :: userdata
    userdata: 0x8289dc15468c354a :: userdata
    userdata: 0x83d77ddf84e12400 :: userdata
    userdata: 0x8402327224e4a9ab :: userdata
    userdata: 0x845b8b564cd4b235 :: userdata
    userdata: 0x84c2f785af0c25f0 :: userdata
    userdata: 0x85652a7d7b43bfe7 :: userdata
    userdata: 0x8640e6a67f01d40a :: userdata
    userdata: 0x869bdb434fde1cb9 :: userdata
    userdata: 0x878c270442e7ffd8 :: userdata
    userdata: 0x8884c50993c47e5e :: userdata
    userdata: 0x899f3e6cb911e952 :: userdata
    userdata: 0x8a905f6470b28ecb :: userdata
    userdata: 0x8abeee509f6ba157 :: userdata
    userdata: 0x8bf5b03998fa60b0 :: userdata
    userdata: 0x8ccfeaa586b99e00 :: userdata
    userdata: 0x8ce829f38c0c4817 :: userdata
    userdata: 0x8d8837a4463c0ed9 :: userdata
    userdata: 0x8d89beb16f744538 :: userdata
    userdata: 0x8dceb318abf173f9 :: userdata
    userdata: 0x8e4171b925712bfe :: userdata
    userdata: 0x8e59134889d28fad :: userdata
    userdata: 0x8f320faab507a523 :: userdata
    userdata: 0x90e8c328ea4f86ac :: userdata
    userdata: 0x91fe546a073b9695 :: userdata
    userdata: 0x92b49a8473a824a2 :: userdata
    userdata: 0x92fa6f70add7bda2 :: userdata
    userdata: 0x934f4163ed20390b :: userdata
    userdata: 0x9365e3b904444d12 :: userdata
    userdata: 0x9370dc09bce8366d :: userdata
    userdata: 0x93dff63fda5cc8c5 :: userdata
    userdata: 0x944cf483b0733ca1 :: userdata
    userdata: 0x9460211913df1999 :: userdata
    userdata: 0x946506b53503236e :: userdata
    userdata: 0x9482d5da3ba2cd34 :: userdata
    userdata: 0x953a2208a03f3bc5 :: userdata
    userdata: 0x960af6850ed83ece :: userdata
    userdata: 0x96958777aaabed7a :: userdata
    userdata: 0x96b3ec4823c3f473 :: userdata
    userdata: 0x971929e194da76e6 :: userdata
    userdata: 0x97ffc6e3fbfbdf1d :: userdata
    userdata: 0x98163044afcdc5bd :: userdata
    userdata: 0x9831fc1f8f9febea :: userdata
    userdata: 0x9a3d9a08c16fe551 :: userdata
    userdata: 0x9a3ef23aa43b7187 :: userdata
    userdata: 0x9ac7ac52c92775ae :: userdata
    userdata: 0x9af2d2328a8874e4 :: userdata
    userdata: 0x9b568a174f369f6e :: userdata
    userdata: 0x9b654644c4068275 :: userdata
    userdata: 0x9bba7aeaecf267f6 :: userdata
    userdata: 0x9bf43f778560d282 :: userdata
    userdata: 0x9d5c91bedfca08f9 :: userdata
    userdata: 0x9e89c7efd4062c8b :: userdata
    userdata: 0x9edfdbf25bdf0cd6 :: userdata
    userdata: 0x9fdb72b3b2926c10 :: userdata
    userdata: 0x9fee7ae07f91b186 :: userdata
    userdata: 0xa0779910ded5178c :: userdata
    userdata: 0xa0786ce716dd4329 :: userdata
    userdata: 0xa07ff5f6e601cfec :: userdata
    userdata: 0xa0bf99a38c3a6a88 :: userdata
    userdata: 0xa1528d5c7004e6a1 :: userdata
    userdata: 0xa1d53aea4574e3e1 :: userdata
    userdata: 0xa1f0960cbc47d20d :: userdata
    userdata: 0xa201e6749e5f2236 :: userdata
    userdata: 0xa20426b49d8848ea :: userdata
    userdata: 0xa4cf691f1080cce2 :: userdata
    userdata: 0xa5ac6f343fa286f6 :: userdata
    userdata: 0xa63f9fa397dc7007 :: userdata
    userdata: 0xa7495e5e48c983b8 :: userdata
    userdata: 0xa74cb88babe4f66b :: userdata
    userdata: 0xa77ab9c7deb9e55e :: userdata
    userdata: 0xa7897a5a9dd26bf7 :: userdata
    userdata: 0xa7a0850e7255918c :: userdata
    userdata: 0xa825255cc21b5134 :: userdata
    userdata: 0xa92c935aa7269360 :: userdata
    userdata: 0xa97824a279894893 :: userdata
    userdata: 0xaae9fc15f62c139a :: userdata
    userdata: 0xab1f25784a402915 :: userdata
    userdata: 0xab2bfff13b2b659e :: userdata
    userdata: 0xabc54ff08be62451 :: userdata
    userdata: 0xacd6f07e327f16bb :: userdata
    userdata: 0xae468c9e5acf6974 :: userdata
    userdata: 0xaece2de3652951b0 :: userdata
    userdata: 0xaee6011b0bfdb090 :: userdata
    userdata: 0xaef73ff404a4dbd2 :: userdata
    userdata: 0xaf19f1e00d0c2c50 :: userdata
    userdata: 0xaf19fc80cbe1ce84 :: userdata
    userdata: 0xafdb53863d0e8746 :: userdata
    userdata: 0xafe073c464a67a0c :: userdata
    userdata: 0xafe7f54a2ce0bf3a :: userdata
    userdata: 0xb08db7583bf58fe0 :: userdata
    userdata: 0xb14f179ef9649fe3 :: userdata
    userdata: 0xb4f12233e8d1ba17 :: userdata
    userdata: 0xb52dcc716da2f86d :: userdata
    userdata: 0xb544b42005ad3a0e :: userdata
    userdata: 0xb54973b0d467f0f7 :: userdata
    userdata: 0xb5b69c559b33dcea :: userdata
    userdata: 0xb5bde8e7c19e7834 :: userdata
    userdata: 0xb622c0dc8e8b799e :: userdata
    userdata: 0xb673827885f163df :: userdata
    userdata: 0xb7c18434801e7a0a :: userdata
    userdata: 0xb89664bde11ca9d3 :: userdata
    userdata: 0xb8b512e9f01d0b87 :: userdata
    userdata: 0xb995b2f00e946e12 :: userdata
    userdata: 0xbae27803ee5f7802 :: userdata
    userdata: 0xbae34c30917b9035 :: userdata
    userdata: 0xbbc5d7a0d4046e1e :: userdata
    userdata: 0xbc878a603473d351 :: userdata
    userdata: 0xbc8c5b7ecb4b71bb :: userdata
    userdata: 0xbc8e675e2e5a1bd8 :: userdata
    userdata: 0xbd1e1fa91e1b3c5a :: userdata
    userdata: 0xbd58106215d1b20d :: userdata
    userdata: 0xbf46b3b40959b89d :: userdata
    userdata: 0xc09b46e4a5e2eea0 :: userdata
    userdata: 0xc178cfdfe46382ac :: userdata
    userdata: 0xc23fc3355b54f260 :: userdata
    userdata: 0xc2479190dbdcb407 :: userdata
    userdata: 0xc33a6eeb2804bfb5 :: userdata
    userdata: 0xc51bb9ad2427fe89 :: userdata
    userdata: 0xc56e90c412198d85 :: userdata
    userdata: 0xc62a98a1e092489d :: userdata
    userdata: 0xc725ce9aa088316a :: userdata
    userdata: 0xc762e3793786af96 :: userdata
    userdata: 0xc82aaa22a23fb587 :: userdata
    userdata: 0xc8795a8eb4fe5dec :: userdata
    userdata: 0xc900d8a80d65a88d :: userdata
    userdata: 0xc90c4a268dc688db :: userdata
    userdata: 0xc91d0c9114107512 :: userdata
    userdata: 0xc9942f4dfcd49440 :: userdata
    userdata: 0xc9ced478a33c184c :: userdata
    userdata: 0xca2a96da2d76f47a :: userdata
    userdata: 0xcb16f5a9fe4aa69a :: userdata
    userdata: 0xcc46d96bd1b03583 :: userdata
    userdata: 0xcc54de722d32b27c :: userdata
    userdata: 0xccdd889b0624ab1c :: userdata
    userdata: 0xcd10f2a1ca84c9f8 :: userdata
    userdata: 0xce02b30e88fae179 :: userdata
    userdata: 0xce79c695d0548ac8 :: userdata
    userdata: 0xceefd01a343603da :: userdata
    userdata: 0xcf141b11b88fe65a :: userdata
    userdata: 0xcf447960be1fb6fb :: userdata
    userdata: 0xcff2fe8b1c92c532 :: userdata
    userdata: 0xd039f99675dc576d :: userdata
    userdata: 0xd054436781898686 :: userdata
    userdata: 0xd1005cd273d739ad :: userdata
    userdata: 0xd11087439167d38c :: userdata
    userdata: 0xd133be21444d9cb3 :: userdata
    userdata: 0xd1d9a2ac55f22c4a :: userdata
    userdata: 0xd308f46b23b8d497 :: userdata
    userdata: 0xd4a020829d264447 :: userdata
    userdata: 0xd4d66ccaf12cc6f1 :: userdata
    userdata: 0xd4d6d59f81a38ca8 :: userdata
    userdata: 0xd5995dd0b372d97d :: userdata
    userdata: 0xd60c4216007de1c3 :: userdata
    userdata: 0xd682d99909a370f2 :: userdata
    userdata: 0xd6b2a6c19d2635a3 :: userdata
    userdata: 0xd6beb6408018de72 :: userdata
    userdata: 0xd765c89dfc6f9341 :: userdata
    userdata: 0xd7dda41d5801ab86 :: userdata
    userdata: 0xd9f5c3dd0828cb82 :: userdata
    userdata: 0xda618d785b5d689a :: userdata
    userdata: 0xda9e06e48f2a7197 :: userdata
    userdata: 0xdc208c3f0cef8627 :: userdata
    userdata: 0xdc89ccb0f024e322 :: userdata
    userdata: 0xdcdba9bcd7d40f10 :: userdata
    userdata: 0xdd6199f6f732bf41 :: userdata
    userdata: 0xde35ed415e62c82a :: userdata
    userdata: 0xdef54b749c27668d :: userdata
    userdata: 0xe0dca2efd602a6f1 :: userdata
    userdata: 0xe12a9468421d4ee9 :: userdata
    userdata: 0xe2b7155d725d50dd :: userdata
    userdata: 0xe2c74ef52fd2301f :: userdata
    userdata: 0xe370ab1db38a1a47 :: userdata
    userdata: 0xe3955c40a2afb6ec :: userdata
    userdata: 0xe488c607bc4d1376 :: userdata
    userdata: 0xe4e9c6971dbacaa3 :: userdata
    userdata: 0xe4f7beff1360d73a :: userdata
    userdata: 0xe584bfd5aaad9d38 :: userdata
    userdata: 0xe78e670faaa774e1 :: userdata
    userdata: 0xe7bd9a4c27074f91 :: userdata
    userdata: 0xe858279a7602ee6e :: userdata
    userdata: 0xe89a5dc38f42b64c :: userdata
    userdata: 0xe9aad10d77633c2b :: userdata
    userdata: 0xeaba707118fbf45b :: userdata
    userdata: 0xeaf3b6b2674c9b97 :: userdata
    userdata: 0xeb847ef404295f14 :: userdata
    userdata: 0xed20ddd3d6a01196 :: userdata
    userdata: 0xed4b5448e01d05d9 :: userdata
    userdata: 0xed5ffc1375e944ca :: userdata
    userdata: 0xee4912b34bb72463 :: userdata
    userdata: 0xee744cbac400f416 :: userdata
    userdata: 0xeece344eb52e846c :: userdata
    userdata: 0xef40f35bdbf27c69 :: userdata
    userdata: 0xef45229c459d3fe1 :: userdata
    userdata: 0xf010491df9aa2460 :: userdata
    userdata: 0xf0628ea4c891bf91 :: userdata
    userdata: 0xf08645a3daead9c3 :: userdata
    userdata: 0xf0c2704dd59d3bfb :: userdata
    userdata: 0xf25386b575c0531c :: userdata
    userdata: 0xf269f19c95cfdc1f :: userdata
    userdata: 0xf3023926d187c18f :: userdata
    userdata: 0xf32def0386f0e84f :: userdata
    userdata: 0xf42cde28e2bda029 :: userdata
    userdata: 0xf5333414c614a451 :: userdata
    userdata: 0xf5cf5ee328d1ea16 :: userdata
    userdata: 0xf5d278ed21ca755c :: userdata
    userdata: 0xf5f51e66d6cb3084 :: userdata
    userdata: 0xf65eb63f6afcd096 :: userdata
    userdata: 0xf6706ece955e7f21 :: userdata
    userdata: 0xf7044e203951ae02 :: userdata
    userdata: 0xf77cb841a8614f42 :: userdata
    userdata: 0xf952ec8a29d19220 :: userdata
    userdata: 0xf9828dc2f5f367b0 :: userdata
    userdata: 0xf9a07f0a1adeac7b :: userdata
    userdata: 0xfad1d95ab1648bb1 :: userdata
    userdata: 0xfb49f519520f3238 :: userdata
    userdata: 0xfb56f473e0c2e955 :: userdata
    userdata: 0xfbb8426a4fa04c6d :: userdata
    userdata: 0xfbfaf2c149eab036 :: userdata
    userdata: 0xfc12ee0eb2e95df2 :: userdata
    userdata: 0xfd0505b91b74e61b :: userdata
    userdata: 0xfd058e1c8fca008f :: userdata
    userdata: 0xfd91c0f63ab70f9e :: userdata
    userdata: 0xfd9b334c7903ce79 :: userdata
    userdata: 0xfe0273101a9ebcdd :: userdata
    userdata: 0xfe07835223e0545d :: userdata
    userdata: 0xfece014fc1f7ae73 :: userdata
    userdata: 0xffc4e1d13fa773b1 :: userdata

==========================================================================================
  12. LIBRERÍAS DEL RUNTIME
==========================================================================================


--------------------------------------------------------------------------------
--- _G.math  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.string  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.table  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.os  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.io  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.coroutine  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.debug  ::  table [28 keys]
--------------------------------------------------------------------------------

  debug :: table [28 claves]
    dumpcodesize :: function [[C]:?]
    dumpheap :: function [[C]:?]
    dumprefs :: function [[C]:?]
    getcallstack :: function [[C]:?]
    getconstant :: function [[C]:?]
    getconstants :: function [[C]:?]
    getinfo :: function [[C]:?]
    getmemorycategory :: function [[C]:?]
    getmetatable :: function [[C]:?]
    getproto :: function [[C]:?]
    getprotos :: function [[C]:?]
    getregistry :: function [[C]:?]
    getstack :: function [[C]:?]
    getupvalue :: function [[C]:?]
    getupvalues :: function [[C]:?]
    info :: function [[C]:?]
    isvalidlevel :: function [[C]:?]
    loadmodule :: function [[C]:?]
    profilebegin :: function [[C]:?]
    profileend :: function [[C]:?]
    resetmemorycategory :: function [[C]:?]
    setconstant :: function [[C]:?]
    setmemorycategory :: function [[C]:?]
    setmetatable :: function [[C]:?]
    setstack :: function [[C]:?]
    setupvalue :: function [[C]:?]
    traceback :: function [[C]:?]
    validlevel :: function [[C]:?]

--------------------------------------------------------------------------------
--- _G.utf8  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.bit32  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.buffer  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.vector  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.task  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.DateTime  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.Random  ::  nil (nil)
--------------------------------------------------------------------------------


--------------------------------------------------------------------------------
--- _G.typeof  ::  nil (nil)
--------------------------------------------------------------------------------


==========================================================================================
  13. HILO Y METATABLES
==========================================================================================

Thread identity: 8

--------------------------------------------------------------------------------
--- debug library
--------------------------------------------------------------------------------

  debug :: table [28 claves]
    dumpcodesize :: function [[C]:?]
    dumpheap :: function [[C]:?]
    dumprefs :: function [[C]:?]
    getcallstack :: function [[C]:?]
    getconstant :: function [[C]:?]
    getconstants :: function [[C]:?]
    getinfo :: function [[C]:?]
    getmemorycategory :: function [[C]:?]
    getmetatable :: function [[C]:?]
    getproto :: function [[C]:?]
    getprotos :: function [[C]:?]
    getregistry :: function [[C]:?]
    getstack :: function [[C]:?]
    getupvalue :: function [[C]:?]
    getupvalues :: function [[C]:?]
    info :: function [[C]:?]
    isvalidlevel :: function [[C]:?]
    loadmodule :: function [[C]:?]
    profilebegin :: function [[C]:?]
    profileend :: function [[C]:?]
    resetmemorycategory :: function [[C]:?]
    setconstant :: function [[C]:?]
    setmemorycategory :: function [[C]:?]
    setmetatable :: function [[C]:?]
    setstack :: function [[C]:?]
    setupvalue :: function [[C]:?]
    traceback :: function [[C]:?]
    validlevel :: function [[C]:?]

--------------------------------------------------------------------------------
--- Metatable: string  ::  string ("The metatable is locked")
--------------------------------------------------------------------------------


==========================================================================================
  14. RESUMEN FINAL
==========================================================================================

Executor                       : Delta
Versión                       : 1.0.745.1142
_VERSION                       : Luau
isluau()                       : N/A
Luau mínimo                   : 0.640
Límite writefile              : 2097152 bytes
_G == getgenv()                : false

==========================================================================================
  FIN DEL DIAGNÓSTICO DELTA
==========================================================================================