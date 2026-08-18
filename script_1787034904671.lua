import pyautogui
import time
import random
import keyboard
import os

# Configuración
RUTA_ORIGEN = input("Ruta del archivo a leer: ")  # Ejemplo: "C:/Users/tu_usuario/Documentos/mi_texto.txt"
RUTA_DESTINO = input("Ruta del archivo de destino (o dejar vacío para escribir en el editor activo): ")  # Si se deja vacío, solo escribe en la ventana activa

# Parámetros de tiempo (en segundos)
PAUSA_MINIMA = 3   # pausa mínima entre letras
PAUSA_MAXIMA = 7   # pausa máxima entre letras
PAUSA_ENTRE_PALABRAS = 2  # pausa extra entre palabras (opcional)

def leer_archivo(ruta):
    """Lee el contenido de un archivo de texto."""
    try:
        with open(ruta, 'r', encoding='utf-8') as f:
            return f.read()
    except Exception as e:
        print(f"Error al leer el archivo: {e}")
        return None

def escribir_en_archivo(ruta_destino, contenido):
    """Escribe el contenido en un archivo de destino (rápido, sin simulación)."""
    try:
        with open(ruta_destino, 'w', encoding='utf-8') as f:
            f.write(contenido)
        print(f"Contenido escrito en {ruta_destino}")
    except Exception as e:
        print(f"Error al escribir en archivo: {e}")

def simular_escritura(texto):
    """Simula escritura letra por letra con pausas aleatorias."""
    print("Simulación de escritura comenzará en 5 segundos. Coloca el cursor donde quieras.")
    time.sleep(5)
    
    # Si se proporcionó ruta de destino, abrimos el archivo en el editor (opcional)
    # Nota: esto no es necesario si ya tienes el archivo abierto y el cursor en el lugar correcto.
    
    for i, caracter in enumerate(texto):
        # Verificar si se pulsó ESC para detener
        if keyboard.is_pressed('esc'):
            print("\nEscritura detenida por el usuario.")
            break
        
        # Escribir el carácter
        pyautogui.write(caracter)
        
        # Si es un espacio, hacemos una pausa extra (opcional)
        if caracter == ' ':
            time.sleep(PAUSA_ENTRE_PALABRAS)
        else:
            # Pausa aleatoria entre PAUSA_MINIMA y PAUSA_MAXIMA (en segundos)
            pausa = random.uniform(PAUSA_MINIMA, PAUSA_MAXIMA)
            time.sleep(pausa)
        
        # Opcional: mostrar progreso cada 100 caracteres
        if i % 100 == 0:
            print(f"Progreso: {i+1}/{len(texto)} caracteres")
    
    print("¡Escritura completada!")

def main():
    # Leer el contenido del archivo origen
    contenido = leer_archivo(RUTA_ORIGEN)
    if contenido is None:
        return
    
    # Si se proporcionó ruta de destino, escribir directamente (sin simulación)
    # pero si queremos simular la escritura en el archivo de destino, podemos hacerlo letra por letra en el editor.
    if RUTA_DESTINO:
        print(f"Se escribirá en el archivo: {RUTA_DESTINO}")
        # Opción 1: Escribir directamente (rápido) - no simula
        # escribir_en_archivo(RUTA_DESTINO, contenido)
        # Opción 2: Simular la escritura en el editor abierto con el archivo de destino
        # Para eso, asumimos que el archivo de destino ya está abierto y el cursor está donde debe ir.
        # Si no, podemos abrirlo con el editor predeterminado (pero eso complica).
        print("Asegúrate de tener el archivo de destino abierto en el editor y el cursor en la posición inicial.")
        simular_escritura(contenido)
    else:
        # Sin ruta de destino, escribe en la ventana activa (por ejemplo, un bloc de notas, navegador, etc.)
        print("Escribiendo en la ventana activa. Coloca el cursor en el lugar deseado.")
        simular_escritura(contenido)

if __name__ == "__main__":
    main()