#!/usr/bin/env python3
"""Genera bases_de_datos_en_codigo.md: bases CouchDB `buscobien_*` referenciadas en lib/.

Uso:  python generar_bases_de_datos_en_codigo.py
Compara contra el diccionario de buscobien_databases_complete.md. No editar el .md generado.
"""
import collections
import datetime
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
LIB = os.path.join(ROOT, 'lib')
DICT = os.path.join(HERE, 'buscobien_databases_complete.md')
OUT = os.path.join(HERE, 'bases_de_datos_en_codigo.md')

uses = collections.defaultdict(set)
for r, _, fs in os.walk(LIB):
    for f in fs:
        if f.endswith('.dart'):
            p = os.path.join(r, f)
            with open(p, encoding='utf-8', errors='ignore') as fh:
                txt = fh.read()
                for db in set(re.findall(r'buscobien_[a-z_]+(?![a-z_.])', txt)) | set(re.findall(r'direccionip/([a-z][a-z_0-9]+)', txt)):
                    uses[db].add(os.path.relpath(p, LIB).replace('\\', '/'))

with open(DICT, encoding='utf-8') as fh:
    text = fh.read()
dict_dbs = set(re.findall(r'^\| \d+ \| `(buscobien_[a-z_]+)`', text, re.M))

en_ambos = sorted(d for d in uses if d in dict_dbs)
solo_codigo = sorted(d for d in uses if d not in dict_dbs)
solo_dicc = sorted(d for d in dict_dbs if d not in uses)

L = []
a = L.append
a('# Bases de datos CouchDB referenciadas en el código (`lib/`)')
a('')
a('**Generado:** %s por [`generar_bases_de_datos_en_codigo.py`](generar_bases_de_datos_en_codigo.py) — no editar a mano.  ' % datetime.date.today().isoformat())
a('**Método:** búsqueda de cadenas `buscobien_*` y de rutas `$direccionip/<base>` en los `.dart` de `lib/`. Las bases construidas dinámicamente (concatenación) no se detectan.')
a('')
a('| Indicador | Valor |')
a('| :--- | ---: |')
a('| Bases referenciadas en el código | %d |' % len(uses))
a('| …que están en el diccionario de esquemas | %d |' % len(en_ambos))
a('| …que **faltan** en el diccionario | %d |' % len(solo_codigo))
a('| Del diccionario sin referencia en el código del cliente | %d |' % len(solo_dicc))
a('')
a('## Inventario')
a('')
a('| Base | En diccionario | Archivos | Módulos (`lib/`) | Archivos de código |')
a('| :--- | :---: | ---: | :--- | :--- |')
for db in sorted(uses):
    files = sorted(uses[db])
    mods = sorted({'/'.join(x.split('/')[:2]) if x.startswith('08_pantallas') else x.split('/')[0] for x in files})
    shown = ', '.join('`%s`' % x for x in files[:6]) + (' … (+%d)' % (len(files) - 6) if len(files) > 6 else '')
    a('| `%s` | %s | %d | %s | %s |' % (db, 'sí' if db in dict_dbs else '**no**', len(files), ', '.join('`%s`' % m for m in mods), shown))
a('')
if solo_dicc:
    a('## Del diccionario, sin referencia en el cliente')
    a('')
    a('Pueden existir en el servidor o usarse solo desde el backend; confirmar en CouchDB antes de darlas por vigentes.')
    a('')
    for d in solo_dicc:
        a('- `%s`' % d)
    a('')
with open(OUT, 'w', encoding='utf-8', newline='\n') as fh:
    fh.write('\n'.join(L))
print(len(uses), 'en código;', len(en_ambos), 'en ambos;', len(solo_codigo), 'solo código;', len(solo_dicc), 'solo diccionario')
