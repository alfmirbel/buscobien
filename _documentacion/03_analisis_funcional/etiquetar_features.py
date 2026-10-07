#!/usr/bin/env python3
"""Escribe en los .feature los tags @REQ-* según mapeo_req_gherkin.csv (idempotente).

Se etiqueta una fila si estado=confirmado, o si estado=propuesto y confianza=alta
(con --incluir-media también confianza=media). Las filas con estado=rechazado nunca se etiquetan.
Los tags automáticos llevan además @mapeo-auto (quitarlo = «revisado»; mejor: marcar la fila como confirmado).

Uso:  python etiquetar_features.py [--incluir-media] [--quitar]
  --quitar  elimina todas las líneas de tags generadas por este script.
"""
import collections
import csv
import os
import re
import sys

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
CSV_GHK = os.path.join(HERE, 'mapeo_req_gherkin.csv')
SC_RE = re.compile(r'^(\s*)(?:Escenario|Esquema del escenario|Scenario(?: Outline)?)\s*:\s*(.*)$')
GEN_TAGS = re.compile(r'^\s*(@(?:REQ-[A-Z0-9]+-\d{2,3}[a-z]?|mapeo-auto)\s*)+$')

incluir_media = '--incluir-media' in sys.argv
quitar = '--quitar' in sys.argv

tags = collections.defaultdict(lambda: collections.defaultdict(list))  # feature -> titulo -> [(req, auto)]
if not quitar:
    with open(CSV_GHK, encoding='utf-8', newline='') as f:
        for r in csv.DictReader(f):
            if not r['req_id'] or r['estado'] == 'rechazado':
                continue
            ok = r['estado'] == 'confirmado' or (r['estado'] == 'propuesto' and (r['confianza'] == 'alta' or (incluir_media and r['confianza'] == 'media')))
            if ok:
                tags[r['feature']][r['escenario']].append((r['req_id'], r['estado'] == 'propuesto'))

changed = n_tag = 0
for r, _, fs in os.walk(ROOT):
    for fn in fs:
        if not fn.endswith('.feature'):
            continue
        path = os.path.join(r, fn)
        rel = os.path.relpath(path, ROOT).replace('\\', '/')
        raw = open(path, encoding='utf-8', newline='').read()
        eol = '\r\n' if '\r\n' in raw else '\n'
        lines = raw.split('\n')
        lines = [l[:-1] if l.endswith('\r') else l for l in lines]
        out = []
        for l in lines:
            m = SC_RE.match(l)
            if m:
                # Línea sin @mapeo-auto = tags firmes (a mano o confirmados): se conservan.
                # Línea con @mapeo-auto = sugerencias: se recalculan en cada ejecución.
                firmes = set()
                while out and GEN_TAGS.match(out[-1]):
                    prev = out.pop()
                    if '@mapeo-auto' not in prev:
                        firmes |= set(re.findall(r'@(REQ-[A-Z0-9]+-\d{2,3}[a-z]?)', prev))
                items = tags.get(rel, {}).get(m.group(2).strip()) or []
                firmes |= {x[0] for x in items if not x[1]}
                auto = sorted({x[0] for x in items if x[1]} - firmes)
                if firmes:
                    out.append(m.group(1) + ' '.join('@' + x for x in sorted(firmes)))
                    n_tag += 1
                if auto and not firmes:   # si el escenario ya tiene tags firmes, no se agregan sugerencias
                    out.append(m.group(1) + ' '.join('@' + x for x in auto) + ' @mapeo-auto')
                    n_tag += 1
            out.append(l)
        new = eol.join(out)
        if new != raw.replace('\r\n', '\n').replace('\n', eol):
            pass
        if new != raw:
            open(path, 'w', encoding='utf-8', newline='').write(new)
            changed += 1
print('archivos modificados:', changed, '| escenarios etiquetados:', n_tag)
