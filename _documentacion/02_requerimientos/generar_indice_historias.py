#!/usr/bin/env python3
"""Genera user_stories/00_indice_user_stories.md a partir de las historias (US-*).

Uso:  python generar_indice_historias.py     (desde cualquier carpeta)
El índice no se edita a mano: se sobrescribe.
"""
import datetime
import os
import re

HERE = os.path.dirname(os.path.abspath(__file__))
U = os.path.join(HERE, 'user_stories')
E = os.path.join(HERE, 'epics_ears')
OUT = os.path.join(U, '00_indice_user_stories.md')
HDR = re.compile(r'^##+\s+(US-[A-Z0-9]+-\d{2,3}[a-z]?)\s*:?\s*(.*)$')
REQ = re.compile(r'\bREQ-[A-Z0-9]+-\d{2,3}[a-z]?\b')

rows, total = [], 0
for f in sorted(os.listdir(U)):
    if not f.endswith('.md') or f.startswith('00_'):
        continue
    hist, cur = [], None
    for line in open(os.path.join(U, f), encoding='utf-8').read().splitlines():
        m = HDR.match(line)
        if m:
            cur = [m.group(1), m.group(2).strip(), set()]
            hist.append(cur)
        elif cur:
            cur[2].update(REQ.findall(line))
    n_req = len(re.findall(r'(?m)^\| (REQ-[A-Z0-9-]+) \|', open(os.path.join(E, f), encoding='utf-8').read())) if os.path.exists(os.path.join(E, f)) else 0
    total += len(hist)
    rows.append((f, hist, n_req))

L = ['# Índice de historias de usuario', '',
     '**Generado:** %s por [`generar_indice_historias.py`](../generar_indice_historias.py) — no editar a mano.  ' % datetime.date.today().isoformat(),
     '**Total:** %d historias en %d archivos (uno por módulo de `lib/`). Cada módulo tiene su Epic en [`epics_ears/`](../epics_ears/).' % (total, len(rows)), '',
     '| Módulo | Archivo | Historias | REQ en la Epic |', '| :--- | :--- | ---: | ---: |']
for f, hist, n in rows:
    L.append('| `%s` | [%s](%s) | %d | %d |' % (f[:-3], f, f, len(hist), n))
L += ['', '## Detalle', '']
for f, hist, n in rows:
    L.append('### `%s`' % f[:-3])
    L.append('')
    for hid, title, reqs in hist:
        L.append('- **%s** — %s%s' % (hid, title, (' (cita: %s)' % ', '.join(sorted(reqs))) if reqs else ''))
    L.append('')
L += ['La relación historia ↔ requerimiento (citada y propuesta) está en [`matriz_trazabilidad_ears_bdd_sdd.md`](../../03_analisis_funcional/matriz_trazabilidad_ears_bdd_sdd.md).', '']
with open(OUT, 'w', encoding='utf-8', newline='\n') as fh:
    fh.write('\n'.join(L))
print('OK', total, 'historias')
