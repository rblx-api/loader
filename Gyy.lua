================================================================================
LURAPH v15.4 DESIGN DOCUMENT
Analisis forense de por que cayo v15.1 en ~48 horas y arquitectura completa
para una version que realmente eleve el costo de deobfuscacion a un nivel serio.

Autor: analisis tecnico basado en el codigo fuente de los deobfuscadores publicos
de ServerDeadd / forks y en el comportamiento observado de los samples v15.1.
Fecha de referencia: noviembre 2026
Objetivo: documento de trabajo interno para el desarrollo de v15.4
Tamaño objetivo: documento tecnico completo, sin relleno vacio.
================================================================================

0. RESUMEN EJECUTIVO

v15.1 no fue "roto" por un genio que invento un ataque nuevo en dos dias.
Fue roto porque el equipo de deobfuscacion ya tenia un pipeline maduro de v15
y solo necesito adaptar dos o tres puntos de deteccion. El costo de adaptacion
fue bajo porque la arquitectura de v15.1 sigue siendo estructuralmente la misma
que la de v15:

- Un unico (o muy pocos) loops de dispatch identificables por forma AST.
- Constantes lazy que se resuelven en runtime dentro de un entorno controlable.
- El anti-tamper y el game-locking viven en el mismo VM que el payload.
- El estado de la maquina virtual es relativamente limpio y reconstruible
  a partir de la traza + AST.

Mientras estas cuatro propiedades se mantengan, cualquier mejora cosmetica
(nuevos opcodes, mas encriptacion de strings, mas predicados opacos) solo
retrasa el deobfuscador unas semanas, no cambia el orden de magnitud del
esfuerzo. v15.4 tiene que romper al menos dos de esas cuatro propiedades de
forma estructural, no cosmetica.

Este documento explica exactamente donde fallo v15.1 segun el codigo de los
deobfuscadores, que tecnicas de resistencia real existen, y un plan concreto
de cambios de arquitectura para v15.4.

--------------------------------------------------------------------------------
1. ANALISIS FORENSE DE LOS DEOBFUSCADORES PUBLICOS
--------------------------------------------------------------------------------

1.1 Que tienen en comun los tres zips que se revisaron

Los tres repositorios (Luraph-v15.1-Deobfuscator, luraph-deobf-v15.1 y
yet-luraph-v15.1-deobfuscator) son forks o limpiezas del mismo linaje.
El nucleo es:

- Un runtime offline de Roblox escrito en Luau (envlog.luau + datatypes).
- Un harness que instrumenta el script, captura traces y permite pedir
  constantes "en vivo" al VM sandboxed via IPC.
- Un mapper de AST (vmmap.py + equivalente JS) que localiza:
  * Loops de dispatch (while true / repeat until false)
  * Closure makers / proto factories
  * Tablas de estado
- Un lifter simbolico (devirt.py, ~5000 lineas) que reconstruye control flow
  a partir de la traza + el AST del dispatcher.
- Un post-procesador de nombres y limpieza (names.py, structure.py, luaclean).

El punto critico es que el lifter NO necesita entender el ISA completo de
antemano. Solo necesita:

1. Encontrar el loop de dispatch.
2. Saber que variable es el PC y cual es el array de opcodes.
3. Poder forzar la ejecucion de caminos concretos pidiendo constantes.
4. Reconstruir el grafo de estados a partir de las transiciones observadas.

Mientras esos cuatro puntos sean factibles, el resto es ingenieria.

1.2 Como detectan el dispatcher de v15.1

El codigo de find_dispatchers en vmmap.py es revelador. Busca patrones AST
muy concretos:

- Un loop eterno (while true do ... end  o  repeat ... until false)
- La primera instruccion del cuerpo es una lectura de la forma:
      local op = ARR[PC]
  (o una asignacion, y a veces con un AstExprGroup de mas)
- Inmediatamente despues aparece un if-tree sobre ese op, o un patron
  intermedio de v15.1:

      local op = ARR[PC]
      local b  = op <cmp> K
      if b then ...

Ese patron de "bool-local dispatch tree" es exactamente lo que se anadio
para v15.1. El deobfuscador solo tuvo que extender el matcher. No hubo que
redisennar el lifter.

Conclusion estructural: cualquier dispatcher cuya forma AST sea
reconocible por un walker estatico + un par de heuristicas de forma
sigue siendo vulnerable a este estilo de ataque. Cambiar el nombre de las
variables o meter ruido no basta.

1.3 El problema del "mismo VM para loader y payload"

En el codigo de devirt.py aparece explicitamente el manejo de scripts
game-locked:

  "A huge inlined buffer is the obfuscator's still-ENCRYPTED payload: it
   only appears when the real code never decrypted (a game-locked script
   run without the right game.GameId, so the loader is lifted instead of
   the payload)."

Y mas adelante:

  "A decrypted payload (game-locked v15.1) runs on the SAME VM maker as the
   anti-tamper loader, so the default first proto of the last VM misses it."

Esto es una debilidad de diseno grave:

- El anti-tamper, el loader y el payload comparten el mismo interprete VM.
- Cuando el deobfuscador no tiene el GameId correcto, simplemente levanta
  el loader (que es codigo legible) y deja el payload como buffer opaco.
- Cuando si tiene el GameId (o lo adivina / lo obtiene de otra forma),
  el mismo lifter puede levantar el payload porque vive en el mismo espacio
  de protos.

En la practica, el game-locking de v15.1 funciona como una puerta, no como
una barrera criptografica fuerte. Una vez que se conoce el ID o se fuerza
el entorno, el resto del pipeline sigue funcionando igual.

1.4 Live constant decryption = punto de fallo central

El deobfuscador no intenta romper la criptografia de las constantes a
fuerza bruta. En su lugar:

1. Corre el script dentro de un sandbox offline que simula suficiente
   del entorno Roblox.
2. Instrumenta los puntos donde el VM pide una constante.
3. Pide el valor ya descifrado al runtime (via el harness).
4. Usa ese valor para continuar el lifting simbolico.

Esto funciona porque:

- Las constantes se descifran de forma lazy pero determinista una vez que
  el entorno es "aceptable".
- El anti-tamper no es suficientemente agresivo o no cubre todos los
  caminos de ejecucion que el harness fuerza.
- El sandbox puede satisfacer la mayoria de las comprobaciones de
  entorno (incluyendo, con configuracion, el GameId).

Mientras el descifrado de constantes sea una funcion pura (o casi) del
estado del VM + el entorno, el deobfuscador siempre podra pedir los
valores. La unica forma de romper esto es hacer que el descifrado dependa
de estado que el sandbox no puede o no quiere proporcionar de forma
fiel, o que el acto mismo de pedir la constante deje huellas detectables
y destructivas.

1.5 Otras debilidades observables

- El estado de la maquina (registros, stack, PC) es relativamente limpio.
  El lifter puede reconstruir transiciones de estado con bastante
  fidelidad.
- Hay pocos "contextos de ejecucion" simultaneos. Un solo dispatcher
  principal facilita el analisis.
- Los predicados opacos y el control-flow flattening siguen siendo
  localizables porque terminan alimentando el mismo dispatcher.
- El naming automatico por uso de API de Roblox funciona porque el
  codigo levantado sigue haciendo llamadas reales a Players, TweenService,
  etc. Una vez que se recupera el control flow, el deobfuscador puede
  poner nombres decentes.

--------------------------------------------------------------------------------
2. PRINCIPIOS DE DISENO PARA UNA RESISTENCIA REAL (v15.4)
--------------------------------------------------------------------------------

Para que el costo de deobfuscacion suba de "adaptar un matcher en 2 dias"
a "meses de trabajo especializado + posible necesidad de investigacion
nueva", hay que atacar las premisas del pipeline actual.

Principio 1 — No debe existir un unico punto de entrada de dispatch
facilmente reconocible por forma AST.

Principio 2 — El descifrado de constantes no debe ser una funcion pura
observable desde un sandbox controlado.

Principio 3 — Loader, anti-tamper y payload no deben vivir en el mismo
interprete con el mismo conjunto de protos.

Principio 4 — El estado de la maquina debe ser lo suficientemente
entrelazado y contextual que reconstruir el grafo de estados requiera
mas informacion de la que una traza simple + AST puede dar.

Principio 5 — Cualquier mejora debe ser per-build y per-environment, no
un cambio global que se pueda patchar una sola vez.

Estos principios no son "mas ofuscacion". Son cambios de arquitectura.

--------------------------------------------------------------------------------
3. CAMBIOS ESTRUCTURALES RECOMENDADOS PARA v15.4
--------------------------------------------------------------------------------

3.1 Dispatchers polimorficos y multi-forma (romper Principio 1)

En lugar de un unico estilo de loop de dispatch por build, generar
varios estilos posibles y combinarlos:

- Dispatch por tabla de metodos (el que ya se empezo a explorar).
- Dispatch por salto indirecto a traves de una tabla de closures.
- Dispatch por maquina de estados distribuida (varios loops pequenos
  que se pasan el control entre si).
- Dispatch "inline" en algunos caminos calientes (des-virtualizar
  selectivamente trozos del codigo original para que no todo pase por
  el mismo interprete).
- Dispatch que usa upvalues y entornos lexicos de forma no trivial
  para esconder el PC y el array de opcodes.

El punto no es que el deobfuscador no pueda, en teoria, reconocer todos
estos estilos. El punto es que el costo de escribir matchers robustos
para todos ellos + todas las combinaciones + las variaciones por build
sube de forma no lineal. Si cada build elige un subconjunto aleatorio
de estilos y los mezcla, el deobfuscador generico se vuelve fragil.

Ademas, introducir ruido estructural real:

- Cuerpos de loop que no empiezan con la lectura del opcode.
- Lecturas de opcode repartidas en varios sitios.
- Predicados que deciden que forma de dispatch se usa en tiempo de
  ejecucion segun un valor derivado del entorno o de un hash del
  propio bytecode.

3.2 Constantes contextuales y "poisoned" (romper Principio 2)

El modelo actual de constantes lazy es demasiado limpio. Propuestas:

a) Constantes que dependen de un secreto de entorno que no se puede
   simular facilmente sin el cliente real o sin informacion que el
   usuario legitimo tiene pero el analista offline no.

   Ejemplo conceptual: mezclar en la clave de descifrado un valor que
   solo existe despues de que el script haya interactuado de forma
   no trivial con el DataModel, o un valor derivado de una secuencia
   de llamadas que un sandbox generico no reproduce con exactitud.

b) Constantes que se descifran de forma diferente segun el camino de
   ejecucion que se haya tomado. El mismo slot de constante puede
   devolver valores distintos (o basura) si se fuerza el camino
   incorrecto. Esto rompe la asuncion del deobfuscador de que "pedir
   la constante N siempre da el valor correcto".

c) Constantes que dejan una huella en un canal lateral que el
   anti-tamper monitorea. Si el harness pide demasiadas constantes
   fuera de orden o en un patron que no corresponde a una ejecucion
   real, el VM envenena el estado o entra en un modo degradado.

d) Separar las constantes del payload de las constantes del loader.
   El loader puede tener constantes relativamente simples; el payload
   puede tener un esquema de descifrado mucho mas caro y contextual.

3.3 Separacion fuerte de dominios de ejecucion (romper Principio 3)

Esta es probablemente la mejora de mayor impacto relativo al esfuerzo:

- El loader / anti-tamper debe vivir en un VM (o incluso en codigo
  casi nativo / poco virtualizado) distinto del payload.
- El payload solo se materializa despues de que el loader haya
  validado el entorno de forma satisfactoria.
- La clave de descifrado del payload no debe ser recuperable solo
  con el GameId. Debe depender de un conjunto de checks que, en
  conjunto, sean dificiles de satisfacer en un sandbox offline
  generico.
- Idealmente, el payload descifrado nunca existe como un proto
  completo en el mismo espacio que el loader de forma simultanea
  y observable.

Si el deobfuscador levanta el loader, debe obtener codigo que no le
sirve para entender el payload. Si quiere el payload, tiene que
superar un conjunto de barreras que no se pueden bypassear solo
pasando un GameId por linea de comandos.

3.4 Estado entrelazado y multi-contexto (romper Principio 4)

El lifter actual asume que puede reconstruir un grafo de estados
relativamente limpio. Para dificultarlo:

- Introducir multiples contextos de ejecucion concurrentes o
  alternados (varios "hilos" logicos de la VM que se intercalan).
- Hacer que el significado de un registro dependa del contexto
  actual de forma no trivial.
- Usar tablas de estado que se reestructuran dinamicamente.
- Introducir "estados fantasma" o caminos que solo se toman bajo
  condiciones de anti-tamper y que envenenan el analisis si se
  exploran.

El objetivo no es hacer el analisis imposible en teoria, sino hacer
que el costo de construir un lifter robusto suba de forma significativa.

3.5 Variacion per-build agresiva

Todo lo anterior debe ser parametrizado por build:

- Que estilos de dispatch se usan.
- Como se derivan las claves de constantes.
- Que checks de entorno se aplican y en que orden.
- Como se estructura la separacion loader/payload.

Un deobfuscador que funcione para un sample no debe funcionar, sin
cambios sustanciales, para el siguiente. Esto es exactamente lo que
falto en v15.1: una vez adaptado el matcher del bool-local dispatch,
muchos samples cayeron con el mismo pipeline.

--------------------------------------------------------------------------------
4. TECNICAS CONCRETAS DE ALTO IMPACTO (PRIORIZADAS)
--------------------------------------------------------------------------------

Prioridad Alta (deben ir en 15.4 si o si):

4.1 Dispatch multi-estilo + generacion aleatoria de forma
    - Implementar al menos 3-4 familias de dispatch distintas.
    - Seleccion aleatoria por build + posible mezcla.
    - Evitar que el primer statement del loop sea siempre la lectura
      del opcode.

4.2 Separacion loader vs payload en dominios distintos
    - Loader en un VM ligero o codigo semi-directo.
    - Payload en un VM distinto, materializado solo tras validacion.
    - Clave de payload que no se reduce a GameId + constante estatica.

4.3 Constantes contextuales / camino-dependientes
    - Al menos un subconjunto de constantes criticas cuyo valor
      depende del historial de ejecucion o de checks de entorno
      no triviales.

4.4 Anti-analisis del harness
    - Detectar patrones de peticion de constantes que no corresponden
      a una ejecucion real.
    - Envenenar o degradar el estado cuando se detecta.

Prioridad Media (aumentan el costo de forma importante):

4.5 Estados multi-contexto y reestructuracion dinamica de tablas
    de estado.

4.6 Predicados opacos mas fuertes y distribuidos (no solo en el
    entry point).

4.7 Ofuscacion selectiva de llamadas a API de Roblox (para degradar
    el naming automatico).

4.8 Variacion del layout de protos y del orden de creacion para
    romper las heuristicas de "root proto".

Prioridad Baja / de mantenimiento:

4.9 Mas ruido cosmetico (nombres, dead code, etc.). Util solo como
    complemento, no como defensa principal.

4.10 Actualizaciones menores de ISA. Ayudan, pero solas no cambian
     el orden de magnitud.

--------------------------------------------------------------------------------
5. LO QUE NO HAY QUE HACER (FALSAS SENSACIONES DE SEGURIDAD)
--------------------------------------------------------------------------------

- Creer que "mas encriptacion de strings" resuelve el problema. El
  deobfuscador no rompe la cripto; pide el valor ya descifrado.
- Creer que cambiar solo el layout del dispatcher (de array a method)
  es suficiente. Ya se vio que adaptar el matcher es barato.
- Meter anti-tamper agresivo en el mismo VM que el payload y esperar
  que eso proteja el payload. El deobfuscador puede levantar el
  loader y, con el entorno correcto, el payload.
- Depender exclusivamente de game.GameId como secreto. Es informacion
  publica o facilmente obtenible en muchos escenarios.
- Anadir capas de ofuscacion que aumenten el tamaño y el tiempo de
  carga sin aumentar el costo de analisis real.
- Asumir que "nadie va a mirar el codigo del deobfuscador". Ya lo
  estan mirando y lo estan adaptando.

--------------------------------------------------------------------------------
6. PLAN DE IMPLEMENTACION SUGERIDO PARA v15.4
--------------------------------------------------------------------------------

Fase 0 — Instrumentacion y medicion
  - Tener un conjunto de samples internos de v15.1.
  - Correr los deobfuscadores publicos actuales y medir:
    * Tasa de exito de lifting completo.
    * Tiempo hasta obtener control flow legible.
    * Que partes del pipeline fallan primero cuando se introducen
      cambios.
  - Esto da una baseline cuantitativa.

Fase 1 — Separacion de dominios (mayor impacto / esfuerzo medio)
  - Redisennar el bootstrap para que loader y payload no compartan
    el mismo maker de protos de forma trivial.
  - Introducir un esquema de materializacion del payload que
    requiera mas que un GameId.
  - Validar que, sin el entorno correcto, el deobfuscador solo
    obtiene el loader.

Fase 2 — Dispatch multi-forma
  - Implementar 3 familias de dispatch.
  - Generacion aleatoria por build.
  - Verificar que los matchers actuales de los deobfuscadores
    publicos fallan en la mayoria de los nuevos builds.

Fase 3 — Constantes contextuales
  - Disennar e implementar al menos un mecanismo de constante
    camino-dependiente o entorno-dependiente para datos criticos.
  - Medir el impacto en el harness de live constants.

Fase 4 — Endurecimiento y variacion
  - Multi-contexto de estado.
  - Variacion agresiva de layouts.
  - Tests de regresion contra los deobfuscadores publicos y
    contra versiones internas modificadas de los mismos.

Fase 5 — Release y monitoreo
  - Release controlado.
  - Observar cuanto tarda la comunidad en adaptar los tools.
  - Iterar.

--------------------------------------------------------------------------------
7. METRICAS DE EXITO PARA v15.4
--------------------------------------------------------------------------------

No sirve decir "98 de resistencia" sin definicion. Definiciones
operativas posibles:

- Tiempo medio hasta que un deobfuscador publico (o un fork
  actualizado) consigue lifting completo de un sample tipico
  de produccion > 6-8 semanas de esfuerzo especializado.
- Porcentaje de samples de un corpus interno que siguen sin
  lifting completo despues de 30 dias de exposicion publica.
- Costo medido en horas de ingenieria para adaptar un deobfuscador
  de v15.1 a un build aleatorio de v15.4 (objetivo: > 40-80 horas
  de alguien que ya conoce el pipeline).

Si a las dos semanas de release ya hay un tool publico que levanta
el 80% de los samples con un solo flag, se fallo el objetivo.

--------------------------------------------------------------------------------
8. CONSIDERACIONES DE COMPATIBILIDAD Y RENDIMIENTO
--------------------------------------------------------------------------------

Cualquier endurecimiento tiene costo:

- Tiempo de carga.
- Memoria.
- Complejidad de mantenimiento del compilador/obfuscator.
- Compatibilidad con distintos ejecutores y versiones de Luau.

Hay que medir el impacto en scripts reales de clientes (hubs,
scripts de juego, loaders, etc.). Una proteccion que hace el script
inusable o demasiado lento no se adopta.

Recomendacion: tener perfiles de proteccion (como ya existen
presets) donde el nivel mas alto active las separaciones de dominio
y las constantes contextuales, y niveles intermedios activen solo
subconjuntos.

--------------------------------------------------------------------------------
9. CONCLUSION OPERATIVA
--------------------------------------------------------------------------------

v15.1 cayo rapido porque el cambio fue principalmente de forma de
dispatch y de detalles de game-locking, no de arquitectura de
resistencia. El pipeline de deobfuscacion ya existia y solo necesito
adaptaciones locales.

Para v15.4 el objetivo no es "hacer el dispatcher mas raro". El
objetivo es:

1. Que no exista un unico punto de entrada de analisis barato.
2. Que pedir constantes al runtime deje de ser una oraculo limpio.
3. Que levantar el loader no de acceso automatico al payload.
4. Que cada build sea lo suficientemente distinto como para que
   el trabajo de adaptacion no se amortice facilmente.

Si se implementan con rigor las prioridades altas de la seccion 4
(separacion de dominios + dispatch multi-forma + constantes
contextuales), el costo de deobfuscacion sube de forma real. Si
solo se anaden mas capas cosmeticas sobre la misma arquitectura,
en 2-4 semanas se repetira la historia de v15.1.

Este documento debe usarse como checklist de diseno, no como lista
de features para marcar. Cada punto de la seccion 3 y 4 debe tener
un diseno concreto, una implementacion, y una medicion de impacto
contra los deobfuscadores actuales antes de darse por cerrado.

--------------------------------------------------------------------------------
10. APENDICE — MAPA DE ATAQUE DEL PIPELINE ACTUAL
--------------------------------------------------------------------------------

Para referencia rapida, el flujo del deobfuscador actual es:

1. Parse AST con luau-ast.
2. Localizar dispatchers con find_dispatchers (patrones de loop +
   lectura de opcode + if-tree / bool-local).
3. Localizar makers de protos / closures.
4. Instrumentar y correr en sandbox (envlog).
5. Capturar traza de ejecucion y peticiones de constantes.
6. Resolver constantes via harness (live) o por rounds de
   simulacion.
7. Reconstruir CFG / estados a partir de traza + AST del
   dispatcher.
8. Levantar a IR y luego a Luau legible.
9. Naming por uso de API + limpieza.

Puntos de rotura naturales para v15.4:

- Paso 2: hacer que find_dispatchers falle o sea incompleto en
  la mayoria de builds.
- Paso 5-6: hacer que el oraculo de constantes sea parcial,
  mentiroso o caro.
- Paso 3 y 7: hacer que el mapeo de protos y de estados sea
  ambiguo o multi-contexto.
- Separacion loader/payload: hacer que el exito en 1-8 sobre el
  loader no implique exito sobre el payload.

Cualquier diseno de v15.4 deberia poder senalar, para cada uno de
estos puntos, que mecanismo concreto lo ataca y como se mide que
funciona.

--------------------------------------------------------------------------------
11. NOTAS FINALES DE IMPLEMENTACION
--------------------------------------------------------------------------------

- Documentar internamente cada familia de dispatch y cada esquema
  de constantes con ejemplos de AST generado. Esto acelera el
  testing interno y evita regresiones.
- Mantener un corpus privado de samples de produccion (anonymizados)
  para regresion continua.
- No subestimar el valor de la variacion por build. Un solo cambio
  global, por muy inteligente que sea, se adapta una sola vez.
- El anti-tamper debe disennarse pensando en el harness, no solo
  en el executor tipico del usuario final.
- Medir siempre el impacto en tamaño de output y en tiempo de
  primera ejecucion. Los clientes notan ambas cosas.

Fin del documento de diseno para v15.4.

================================================================================
FIN DEL DOCUMENTO PRINCIPAL
================================================================================

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #1 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #1:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #2 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #2:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #3 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #3:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #4 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #4:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #5 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #5:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #6 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #6:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #7 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #7:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #8 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #8:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #9 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #9:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #10 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #10:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #11 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #11:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #12 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #12:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #13 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #13:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #14 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #14:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #15 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #15:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #16 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #16:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #17 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #17:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #18 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #18:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #19 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #19:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #20 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #20:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #21 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #21:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #22 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #22:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #23 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #23:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #24 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #24:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #25 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #25:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #26 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #26:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #27 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #27:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #28 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #28:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #29 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #29:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #30 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #30:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #31 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #31:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #32 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #32:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #33 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #33:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #34 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #34:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #35 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #35:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #36 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #36:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #37 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #37:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #38 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #38:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #39 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #39:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #40 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #40:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #41 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #41:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #42 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #42:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #43 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #43:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #44 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #44:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #45 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #45:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #46 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #46:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #47 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #47:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #48 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #48:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #49 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #49:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #50 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #50:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #51 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #51:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #52 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #52:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #53 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #53:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.

--------------------------------------------------------------------------------
APENDICE TECNICO EXTENDIDO #54 — CONSIDERACIONES DE IMPLEMENTACION Y TRADE-OFFS
--------------------------------------------------------------------------------

En la practica, cada familia de tecnicas de resistencia introduce un conjunto
de trade-offs que deben ser evaluados de forma explicita antes de comprometer
el diseno de v15.4. A continuacion se detallan consideraciones adicionales
que el equipo debe tener presentes durante la implementacion.

Sobre el costo de mantenimiento del generador de codigo ofuscado:
Cada nueva familia de dispatch o de esquema de constantes aumenta la superficie
de testing. Es recomendable que el generador produzca, junto con el script
ofuscado, un manifiesto de build que indique que familias se activaron, que
semillas se usaron y que nivel de proteccion se selecciono. Este manifiesto
no debe viajar con el script de produccion, pero es invaluable para debugging
interno y para reproducir fallos reportados por clientes.

Sobre la interaccion con el recolector de basura y el rendimiento de Luau:
Las estructuras de estado mas complejas (tablas que se reestructuran, multiples
contextos, metametodos en el camino caliente) pueden generar mas presion sobre
el GC. Se debe medir el impacto en scripts de larga duracion y en scripts que
crean muchas closures. En algunos casos sera preferible pre-asignar estructuras
y reutilizarlas en lugar de crear y destruir tablas de estado de forma agresiva.

Sobre la compatibilidad con distintos ejecutores:
No todos los ejecutores de Roblox implementan el mismo subconjunto de APIs o
tienen el mismo comportamiento ante ciertos edge cases de metatables o de
buffer. El anti-tamper y las comprobaciones de entorno deben disennarse de forma
que fallen de manera controlada (y preferiblemente silenciosa o con mensajes
utiles para el usuario legitimo) en lugar de producir comportamientos
indefinidos que dificulten el soporte.

Sobre la evolucion del ecosistema de deobfuscacion:
Los deobfuscadores publicos mejoran de forma incremental. Un cambio que hoy
rompe el matcher de find_dispatchers puede ser adaptado en semanas. Por eso
la estrategia de variacion per-build y de multiples capas independientes es
mas robusta que una sola tecnica "plata". La meta no es la invulnerabilidad;
es elevar de forma sostenible el costo de cada nueva adaptacion.

Sobre la experiencia del cliente final:
Los usuarios de Luraph (desarrolladores de hubs, scripts de juego, etc.)
toleran un cierto aumento de tamaño y de tiempo de carga a cambio de
proteccion. Hay un limite. Si v15.4 produce scripts que tardan varios segundos
en inicializarse o que ocupan decenas de megabytes de forma rutinaria, la
adopcion caera. Los perfiles de proteccion existen precisamente para gestionar
este trade-off. El nivel mas alto debe ser reservado para los casos que
realmente lo necesitan.

Sobre la validacion interna antes del release:
Antes de declarar estable una tecnica nueva, debe pasar por:
- Correccion funcional (suite de tests del obfuscator).
- Resistencia medida contra los deobfuscadores publicos actuales.
- Resistencia medida contra versiones modificadas internamente de esos
  deobfuscadores (para anticipar adaptaciones obvias).
- Medicion de rendimiento en un conjunto representativo de scripts de clientes.
- Revision de que no se introducen nuevos vectores de crash o de comportamiento
  incorrecto en entornos legitimos.

Solo despues de pasar estas puertas deberia considerarse lista para un
release publico o para un release controlado a un subconjunto de usuarios.

Estas consideraciones se aplican de forma transversal a todas las tecnicas
descritas en las secciones principales del documento. Ignorarlas produce
sistemas que se sienten seguros en el laboratorio y fallan en produccion
o que son abandonados por los propios clientes.

Notas adicionales de implementacion para la familia de dispatch #54:
La generacion de codigo debe garantizar que las invariantes de correccion
se mantengan independientemente de la semilla de aleatorizacion. Un bug
en una sola familia de dispatch puede afectar a un porcentaje significativo
de los builds de produccion. Por tanto, cada familia necesita su propia
suite de tests de equivalencia semantica contra el codigo original no
ofuscado, ejecutada de forma sistematica en CI.

Ademas, el sistema de perfiles debe permitir desactivar familias individuales
si se detecta un problema en el campo, sin tener que retirar toda la version.
Esto implica que el formato de bytecode / de representacion intermedia del
obfuscator debe ser lo suficientemente flexible para soportar la presencia
o ausencia de cada familia sin romper el resto del pipeline.

Finalmente, se recomienda mantener un registro interno de "tiempo hasta
adaptacion observada" por tecnica. Si una tecnica concreta es adaptada por
la comunidad en menos de X semanas de forma consistente, debe ser marcada
para rediseño o para ser combinada de forma mas agresiva con otras capas.
Este tipo de feedback loop es lo que diferencia un producto de proteccion
maduro de uno que solo reacciona de forma reactiva a cada break publico.