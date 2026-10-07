#!/usr/bin/env python3
"""Verificación de exactitud de la documentación contra el código (solo lectura).

Uso:  python verificar_documentacion.py        (código de salida 1 si hay errores)

Comprueba:
  1. Enlaces markdown relativos / file:/// rotos.
  2. Archivos de lib/ sin ficha en los inventarios y filas de inventario de archivos inexistentes.
  3. Credenciales o API keys escritas en los documentos.
  4. Prefijo REQ- usado en SDD (reservado a las Epics).
  5. Tags @REQ-* en .feature que no existen en las Epics.
  6. Bases `buscobien_*` del código que no están en bases_de_datos_en_codigo.md.
"""
import os
import re
import sys
import urllib.parse

HERE = os.path.dirname(os.path.abspath(__file__))
DOC = os.path.abspath(os.path.join(HERE, '..'))
LIB = os.path.abspath(os.path.join(DOC, '..', 'lib'))
errores = []
avisos = []


def read(p):
    with open(p, encoding='utf-8', errors='replace') as f:
        return f.read()


def walk(root, exts):
    for r, _, fs in os.walk(root):
        for f in sorted(fs):
            if f.endswith(exts):
                yield os.path.join(r, f)


# 1. enlaces
for p in walk(DOC, ('.md',)):
    for m in re.finditer(r'\]\(((?!https?:|mailto:|#)[^)\s]+)\)', read(p)):
        u = urllib.parse.unquote(m.group(1)).split('#')[0]
        if u.startswith('file:///'):
            u = u[8:]
        if not u:
            continue
        t = u if re.match(r'^[A-Za-z]:', u) else os.path.normpath(os.path.join(os.path.dirname(p), u))
        if not os.path.exists(t):
            errores.append('enlace roto: %s -> %s' % (os.path.relpath(p, DOC), m.group(1)))

# 2. inventarios vs lib
lib = {}
for p in walk(LIB, ('.dart',)):
    n = os.path.basename(p)
    if not n.endswith(('.g.dart', '.freezed.dart')):
        lib[n] = p
inv_dir = os.path.join(DOC, '05_desarrollo_y_especificaciones_tecnicas')
mencionados = set()
for p in walk(inv_dir, ('.md',)):
    t = read(p)
    mencionados |= set(re.findall(r'([A-Za-z0-9_]+\.dart)\b', t))
    if 'inventario_' in p or 'elementos_' in p:
        for l in t.splitlines():
            if l.startswith('|'):
                for c in [x.strip() for x in l.split('|')][1:4]:
                    m = re.fullmatch(r'\[?`?([A-Za-z0-9_]+\.dart)`?\]?(\(.*\))?', c)
                    if m and m.group(1) not in lib and not m.group(1).endswith(('.g.dart', '.freezed.dart')):
                        errores.append('inventario menciona archivo inexistente: %s (%s)' % (m.group(1), os.path.relpath(p, DOC)))
for n, p in sorted(lib.items()):
    if n not in mencionados:
        errores.append('archivo sin inventariar: %s' % os.path.relpath(p, LIB))

# 3. credenciales
pat = [r'AIza[0-9A-Za-z_\-]{30,}', r'(?i)(password|passwd|secret)["\']?\s*[:=]\s*["\'][^"\'<>${}\s]{8,}["\']']
for p in walk(DOC, ('.md', '.feature')):
    t = read(p)
    for rx in pat:
        for m in re.finditer(rx, t):
            avisos.append('posible credencial en %s: %s' % (os.path.relpath(p, DOC), m.group(0)[:40]))

# 4. REQ- en SDD
for p in walk(os.path.join(DOC, '04_arquitectura_y_diseno', 'modulos_sdd'), ('.md',)):
    if re.search(r'\bREQ-[A-Z0-9]+-\d', read(p)):
        errores.append('SDD usa prefijo REQ- (usar DES-): %s' % os.path.relpath(p, DOC))

# 5. tags
epics = set()
for p in walk(os.path.join(DOC, '02_requerimientos', 'epics_ears'), ('.md',)):
    epics |= set(re.findall(r'^\| (REQ-[A-Z0-9]+-\d{2,3}[a-z]?) \|', read(p), re.M))
for p in walk(DOC, ('.feature',)):
    for tag in set(re.findall(r'@(REQ-[A-Z0-9]+-\d{2,3}[a-z]?)', read(p))):
        if tag not in epics:
            errores.append('tag sin Epic: @%s en %s' % (tag, os.path.relpath(p, DOC)))

# 6. bases
bd = os.path.join(DOC, '06_modelo_de_datos_y_bd', 'bases_de_datos_en_codigo.md')
doc_bd = read(bd) if os.path.exists(bd) else ''
codigo = set()
for p in lib.values():
    _t = read(p)
    codigo |= set(re.findall(r'buscobien_[a-z_]+(?![a-z_.])', _t)) | set(re.findall(r'direccionip/([a-z][a-z_0-9]+)', _t))
for d in sorted(codigo):
    if '`%s`' % d not in doc_bd:
        errores.append('base del código no inventariada: %s (regenerar bases_de_datos_en_codigo.md)' % d)

print('Errores: %d | Avisos: %d' % (len(errores), len(avisos)))
for e in errores:
    print('  ERROR', e)
for a in avisos:
    print('  AVISO', a)
sys.exit(1 if errores else 0)
