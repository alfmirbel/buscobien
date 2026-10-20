import os
import mammoth
from pathlib import Path

def convertir_docx_a_md(directorio_entrada, directorio_salida=None):
    """
    Convierte todos los archivos .docx de un directorio a .md
    
    :param directorio_entrada: Ruta del subdirectorio con los archivos Word.
    :param directorio_salida: Ruta donde se guardarán los .md (opcional). 
                              Si no se provee, se guardan en el mismo lugar.
    """
    ruta_entrada = Path(directorio_entrada)
    
    # Validar que el directorio de entrada exista
    if not ruta_entrada.is_dir():
        print(f"❌ Error: El directorio '{directorio_entrada}' no existe.")
        return

    # Configurar directorio de salida
    if directorio_salida:
        ruta_salida = Path(directorio_salida)
        ruta_salida.mkdir(parents=True, exist_ok=True)
    else:
        ruta_salida = ruta_entrada

    # Buscar todos los archivos DOCX en el directorio
    archivos_docx = list(ruta_entrada.glob("*.docx"))

    if not archivos_docx:
        print(f"⚠️ No se encontraron archivos .docx en: {directorio_entrada}")
        return

    print(f"🔍 Se encontraron {len(archivos_docx)} archivo(s) .docx. Iniciando conversión...\n")

    for docx in archivos_docx:
        print(f"⏳ Convirtiendo: {docx.name} ...")
        try:
            # Abrir el archivo Word en modo binario
            with open(docx, "rb") as archivo_word:
                # Convertir a Markdown usando mammoth
                resultado = mammoth.convert_to_markdown(archivo_word)
                md_texto = resultado.value
                
                # Mostrar advertencias si hubieron problemas de formato
                if resultado.messages:
                    for mensaje in resultado.messages:
                        print(f"  ⚠️ Advertencia con {docx.name}: {mensaje}")

            # Crear el nombre del nuevo archivo cambiando la extensión a .md
            nombre_md = docx.with_suffix('.md').name
            ruta_md = ruta_salida / nombre_md
            
            # Guardar el archivo Markdown
            ruta_md.write_text(md_texto, encoding='utf-8')
            print(f"  ✅ Guardado con éxito: {ruta_md}")
            
        except Exception as e:
            print(f"  ❌ Error al convertir {docx.name}: {e}")

if __name__ == "__main__":
    # --- CONFIGURACIÓN ---
    # Cambia esta ruta por el nombre de tu subdirectorio donde están los Word
    SUBDIRECTORIO_DOCX = "./" 
    
    # Si quieres que los .md se guarden en otra carpeta, pon la ruta aquí. 
    # Si dejas None o la misma ruta, se guardarán junto a los DOCX.
    CARPETA_DESTINO = "./" 
    
    convertir_docx_a_md(SUBDIRECTORIO_DOCX, CARPETA_DESTINO)
    print("\n🎉 Proceso finalizado.")