#!/usr/bin/env python3
"""Genera matriz_trazabilidad_ears_bdd_sdd.md a partir de la documentación.

Uso:  python generar_matriz_trazabilidad.py
Fuentes:  02_requerimientos/epics_ears (REQ), 02_requerimientos/user_stories (US),
          03_analisis_funcional/features_analisis, 04_arquitectura_y_diseno/modulos_sdd,
          07_pruebas_y_calidad/gherkin_bdd_scenarios, 05_.../inventario_*.
No editar el .md generado a mano: se sobrescribe.
"""
import collections
import datetime
import os
import re
import urllib.parse

ROOT = os.path.abspath(os.path.join(os.path.dirname(__file__), '..'))
HERE = os.path.dirname(os.path.abspath(__file__))
OUT = os.path.join(HERE, 'matriz_trazabilidad_ears_bdd_sdd.md')
P = lambda *a: os.path.join(ROOT, *a)
EPICS = P('02_requerimientos', 'epics_ears')
STORIES = P('02_requerimientos', 'user_stories')
FEATS = P('03_analisis_funcional', 'features_analisis')
SDD = P('04_arquitectura_y_diseno', 'modulos_sdd')
GHK = P('07_pruebas_y_calidad', 'gherkin_bdd_scenarios')
INV_C = P('05_desarrollo_y_especificaciones_tecnicas', 'inventario_componentes')
INV_E = P('05_desarrollo_y_especificaciones_tecnicas', 'inventario_elementos')

REQ_RE = re.compile(r'\bREQ-[A-Z0-9]+-\d{2,3}[a-z]?\b')
US_HDR = re.compile(r'^##+\s+(US-[A-Z0-9]+-\d{2,3}[a-z]?)\b[:\s]*(.*)$')


def read(p):
    with open(p, encoding='utf-8') as f:
        return f.read()


def rel(p):
    """Ruta relativa (desde 03_analisis_funcional) lista para enlace markdown."""
    r = os.path.relpath(p, HERE).replace('\\', '/')
    return urllib.parse.quote(r, safe="/#._-~()")


def link(p, label=None):
    return '[%s](%s)' % (label or os.path.basename(p), rel(p))


def files_under(d, exts):
    out = []
    for r, _, fs in os.walk(d):
        out += [os.path.join(r, f) for f in sorted(fs) if f.endswith(exts)]
    return sorted(out)


def module_dirs(stem):
    """Subruta de módulo en SDD / Gherkin a partir del nombre de la Epic."""
    if stem.startswith('08_pantallas_tu_cuenta_'):
        return os.path.join('08_pantallas', 'tu_cuenta', stem[len('08_pantallas_tu_cuenta_'):])
    if stem.startswith('08_pantallas_'):
        return os.path.join('08_pantallas', stem[len('08_pantallas_'):])
    return stem


def short(t, n=110):
    t = re.sub(r'\s+', ' ', t.replace('|', '/')).strip()
    return t if len(t) <= n else t[:n - 1].rstrip() + '…'


# ---------- 1. Requerimientos (Epics) ----------
reqs = collections.OrderedDict()  # id -> dict
modules = []
for f in sorted(os.listdir(EPICS)):
    if not f.endswith('.md'):
        continue
    stem = f[:-3]
    modules.append(stem)
    for line in read(os.path.join(EPICS, f)).splitlines():
        if line.startswith('| REQ-'):
            c = [x.strip() for x in line.strip().strip('|').split('|')]
            if len(c) >= 5 and REQ_RE.fullmatch(c[0]):
                reqs[c[0]] = dict(mod=stem, tipo=c[1].replace('*', ''), texto=c[2], ev=c[3], estado=c[4])

# ---------- 2. User Stories ----------
us_of_req = collections.defaultdict(set)   # REQ -> {US}
us_info = {}                               # US -> (archivo, titulo, set(REQ))
us_by_mod = collections.defaultdict(list)
for f in sorted(os.listdir(STORIES)):
    if not f.endswith('.md') or f.startswith('00_'):
        continue
    stem = f[:-3]
    cur = None
    for line in read(os.path.join(STORIES, f)).splitlines():
        m = US_HDR.match(line)
        if m:
            cur = m.group(1)
            us_info.setdefault(cur, [os.path.join(STORIES, f), short(m.group(2), 60), set()])
            us_by_mod[stem].append(cur)
        elif cur:
            for r in REQ_RE.findall(line):
                us_info[cur][2].add(r)
                us_of_req[r].add(cur)

# Vínculos propuestos historia -> REQ (mapeo_req_historias.csv): alta/confirmado = firme; media = probable
us_prob = collections.defaultdict(set)
CSV_US = os.path.join(HERE, 'mapeo_req_historias.csv')
if os.path.exists(CSV_US):
    import csv as _csv
    with open(CSV_US, encoding='utf-8', newline='') as _f:
        for _r in _csv.DictReader(_f):
            if _r['estado'] == 'rechazado' or _r['us_id'] not in us_info:
                continue
            if _r['estado'] == 'confirmado' or _r['confianza'] == 'alta':
                us_of_req[_r['req_id']].add(_r['us_id'])
            else:
                us_prob[_r['req_id']].add(_r['us_id'])
for _k in list(us_prob):
    us_prob[_k] -= us_of_req.get(_k, set())

# ---------- 3. SDD ----------
# Vínculo REQ -> elemento de diseño (DES-*/SDD-*): se lee de mapeo_req_diseno.csv
# (propuesto por mapeo_trazabilidad.py y revisable a mano). 'alta'/confirmado = vínculo firme;
# 'media' = probable (se muestra con «~»).
import csv
sdd_of_req = collections.defaultdict(set)    # vínculo firme: REQ -> {documentos SDD}
sdd_media = collections.defaultdict(set)     # vínculo probable
dis_total = collections.Counter()            # documento -> elementos de diseño
dis_sin_req = collections.Counter()          # documento -> elementos sin REQ padre
dis_n = 0
CSV_DIS = os.path.join(HERE, 'mapeo_req_diseno.csv')
if os.path.exists(CSV_DIS):
    with open(CSV_DIS, encoding='utf-8', newline='') as fcsv:
        for row in csv.DictReader(fcsv):
            doc = os.path.join(ROOT, row['documento'].replace('/', os.sep))
            dis_n += 1
            dis_total[doc] += 1
            if row['estado'] == 'rechazado' or not row['req_id']:
                dis_sin_req[doc] += 1
            elif row['estado'] in ('confirmado', 'tabla') or row['confianza'] == 'alta':
                sdd_of_req[row['req_id']].add(doc)
            else:
                sdd_media[row['req_id']].add(doc)
for k in list(sdd_media):
    sdd_media[k] -= sdd_of_req.get(k, set())

# ---------- 4. Gherkin ----------
def count_scn(files):
    n = 0
    for p in files:
        n += len(re.findall(r'^\s*(?:Escenario|Esquema del escenario|Scenario)\b', read(p), re.M))
    return n


gk_of_req = collections.defaultdict(set)  # REQ -> {archivos .feature con tag @REQ-...}
for p in files_under(GHK, ('.feature',)) + files_under(FEATS, ('.feature',)):
    for r in set(re.findall(r'@(REQ-[A-Z0-9]+-\d{2,3}[a-z]?)\b', read(p))):
        gk_of_req[r].add(p)

# ---------- 5. Tabla por módulo ----------
rows_mod = []
tot = collections.Counter()
for stem in modules:
    sub = module_dirs(stem)
    epic = os.path.join(EPICS, stem + '.md')
    n_req = sum(1 for v in reqs.values() if v['mod'] == stem)
    story = os.path.join(STORIES, stem + '.md')
    us = us_by_mod.get(stem, [])
    fa_dir = os.path.join(FEATS, stem)
    fa = files_under(fa_dir, ('.feature',)) if os.path.isdir(fa_dir) else []
    gk_dir = os.path.join(GHK, sub)
    gk = files_under(gk_dir, ('.feature',)) if os.path.isdir(gk_dir) else []
    sd_dir = os.path.join(SDD, sub)
    sd = files_under(sd_dir, ('.md',)) if os.path.isdir(sd_dir) else []
    ic = os.path.join(INV_C, 'inventario_' + stem + '.md')
    ie = os.path.join(INV_E, 'elementos_' + stem + '.md')
    inv = [link(p, t) for p, t in ((ic, 'comp.'), (ie, 'elem.')) if os.path.exists(p)]
    rows_mod.append((stem, epic, n_req, story if os.path.exists(story) else None, len(us), fa, gk, count_scn(gk), sd, inv, sub))
    tot['gk'] += len(gk)
    tot['scn'] += count_scn(gk)

# ---------- 6. Estadísticas ----------
all_req = list(reqs)
sin_us = [r for r in all_req if r not in us_of_req]
sin_sdd = [r for r in all_req if r not in sdd_of_req]
sin_gk = [r for r in all_req if r not in gk_of_req]
sin_ambos = [r for r in all_req if r not in us_of_req and r not in sdd_of_req]
no_codigo = [r for r in all_req if reqs[r]['estado'].lower() != 'en código']
con_sdd_prob = [r for r in all_req if r in sdd_media and r not in sdd_of_req]
n_dis_sin_req = sum(dis_sin_req.values())
us_sin_req = [u for u, v in us_info.items() if not v[2]]

today = datetime.date.today().isoformat()
L = []
a = L.append
a('# Matriz de Trazabilidad: Requerimiento EARS → Historia de Usuario → SDD → Gherkin')
a('')
a('**Generada:** %s por [`generar_matriz_trazabilidad.py`](generar_matriz_trazabilidad.py) — no editar a mano; para actualizar, ejecutar `python generar_matriz_trazabilidad.py` desde esta carpeta.  ' % today)
a('**Fuente de requerimientos:** tablas `REQ-*` de [`02_requerimientos/epics_ears/`](../02_requerimientos/epics_ears/) (catálogo oficial).  ')
a('**Vínculos:** historias (`US-*`) = el ID `REQ-*` escrito en la historia · SDD = [`mapeo_req_diseno.csv`](mapeo_req_diseno.csv) (propuesta por similitud, revisable) · Gherkin = tags `@REQ-*` escritos por [`etiquetar_features.py`](etiquetar_features.py) desde [`mapeo_req_gherkin.csv`](mapeo_req_gherkin.csv). Detalle del método en [`reconciliacion_epics_sdd.md`](reconciliacion_epics_sdd.md).')
a('')
a('## 1. Resumen de cobertura')
a('')
a('| Indicador | Valor |')
a('| :--- | ---: |')
a('| Módulos documentados (Epics) | %d |' % len(modules))
a('| Requerimientos EARS (Epics) | %d |' % len(all_req))
a('| Con al menos una historia de usuario (citada o de confianza alta) | %d (%d %%) |' % (len(all_req) - len(sin_us), round(100 * (len(all_req) - len(sin_us)) / len(all_req))))
a('| …además con historia probable (media, «~») | %d |' % len([r for r in all_req if r not in us_of_req and r in us_prob]))
a('| Con elemento de diseño (SDD) de confianza alta o confirmado | %d (%d %%) |' % (len(all_req) - len(sin_sdd), round(100 * (len(all_req) - len(sin_sdd)) / len(all_req))))
a('| …además con elemento de diseño de confianza media (probable, «~») | %d |' % len(con_sdd_prob))
a('| Sin historia **ni** SDD | %d |' % len(sin_ambos))
a('| Con escenario Gherkin etiquetado `@REQ-*` | %d (%d %%) |' % (len(all_req) - len(sin_gk), round(100 * (len(all_req) - len(sin_gk)) / len(all_req))))
a('| Con estado distinto de «En código» (riesgo, parcial, deuda) | %d |' % len(no_codigo))
a('| Historias de usuario (`US-*`) | %d |' % len(us_info))
a('| Historias que no citan ningún `REQ-*` | %d |' % len(us_sin_req))
a('| Elementos de diseño (`DES-*`/`SDD-*`) / sin REQ padre | %d / %d |' % (dis_n, n_dis_sin_req))
a('| Archivos Gherkin detallados / escenarios | %d / %d |' % (tot['gk'], tot['scn']))
a('')
a('> **Lectura:** los requisitos propios de cada SDD ya no usan el prefijo `REQ-` (ahora `DES-*`, requisitos de diseño), de modo que `REQ-*` identifica únicamente a las Epics. Muchos elementos de diseño (errores, opcionales, rendimiento) no tienen un REQ padre y es normal: son decisiones de diseño, no requerimientos.')
a('')
a('## 2. Matriz por módulo')
a('')
a('| Módulo | Epic (REQ) | Historias | Feature análisis | Gherkin (archivos / escenarios) | SDD | Inventario |')
a('| :--- | :--- | :--- | :--- | :--- | :--- | :--- |')
for stem, epic, n_req, story, n_us, fa, gk, n_scn, sd, inv, sub in rows_mod:
    a('| `%s` | %s (%d) | %s (%d) | %s | %s | %s | %s |' % (
        stem, link(epic, 'Epic'), n_req,
        link(story, 'US') if story else '—', n_us,
        ', '.join(link(p) for p in fa) if fa else '—',
        ('[%d / %d](%s)' % (len(gk), n_scn, rel(os.path.join(GHK, sub)) + '/')) if gk else '—',
        ', '.join(link(p) for p in sd) if sd else '—',
        ' · '.join(inv) if inv else '—'))
a('')
a('## 3. Matriz por requerimiento')
a('')
a('Columnas: **Gherkin** = `.feature` con tag `@REQ-*` · **US** = historias que citan el REQ · **SDD** = documentos de diseño que lo citan · **Estado** según la Epic. Evidencia de código en la Epic correspondiente.')
a('')
cur = None
for rid, v in reqs.items():
    if v['mod'] != cur:
        cur = v['mod']
        a('')
        a('### %s' % cur)
        a('')
        a('| REQ | Tipo EARS | Requerimiento | Estado | US | SDD | Gherkin |')
        a('| :--- | :--- | :--- | :--- | :--- | :--- | :--- |')
    us = sorted(us_of_req.get(rid, []))
    usp = sorted(us_prob.get(rid, []))
    sd = sorted(sdd_of_req.get(rid, []))
    sdm = sorted(sdd_media.get(rid, []))
    gk = sorted(gk_of_req.get(rid, []))
    a('| `%s` | %s | %s | %s | %s | %s | %s |' % (
        rid, v['tipo'], short(v['texto']), v['estado'],
        ', '.join(['[%s](%s)' % (u, rel(us_info[u][0])) for u in us] + ['~[%s](%s)' % (u, rel(us_info[u][0])) for u in usp]) if (us or usp) else '—',
        ', '.join([link(p) for p in sd] + ['~' + link(p) for p in sdm]) if (sd or sdm) else '—',
        ', '.join(link(p) for p in gk) if gk else '—'))
a('')
a('## 4. Brechas y acciones')
a('')
a('### 4.0 Módulos sin SDD o sin Gherkin detallado')
a('')
falt = [(r[0], not r[8], not r[6]) for r in rows_mod if not r[8] or not r[6]]
if falt:
    a('| Módulo | Sin SDD | Sin Gherkin detallado |')
    a('| :--- | :---: | :---: |')
    for m, s, g in falt:
        a('| `%s` | %s | %s |' % (m, 'sí' if s else '', 'sí' if g else ''))
else:
    a('Todos los módulos tienen SDD y Gherkin detallado.')
a('')
a('### 4.1 Requerimientos sin historia de usuario (%d)' % len(sin_us))
a('')
by = collections.defaultdict(list)
for r in sin_us:
    by[reqs[r]['mod']].append(r)
a('| Módulo | REQ sin historia |')
a('| :--- | :--- |')
for m in modules:
    if by.get(m):
        a('| `%s` | %s |' % (m, ', '.join('`%s`' % r for r in by[m])))
a('')
a('### 4.2 Requerimientos sin cita en SDD (%d)' % len(sin_sdd))
a('')
by = collections.defaultdict(list)
for r in sin_sdd:
    by[reqs[r]['mod']].append(r)
a('| Módulo | REQ sin SDD |')
a('| :--- | :--- |')
for m in modules:
    if by.get(m):
        a('| `%s` | %s |' % (m, ', '.join('`%s`' % r for r in by[m])))
a('')
a('### 4.3 Requerimientos con riesgo o deuda (%d)' % len(no_codigo))
a('')
a('| REQ | Módulo | Estado | Requerimiento |')
a('| :--- | :--- | :--- | :--- |')
for r in no_codigo:
    a('| `%s` | `%s` | %s | %s |' % (r, reqs[r]['mod'], reqs[r]['estado'], short(reqs[r]['texto'], 90)))
a('')
a('### 4.4 Elementos de diseño sin REQ padre, por documento (%d en total)' % n_dis_sin_req)
a('')
a('| SDD | Sin REQ padre | Total elementos |')
a('| :--- | ---: | ---: |')
for p, n in sorted(dis_sin_req.items(), key=lambda x: -x[1]):
    a('| %s | %d | %d |' % (link(p), n, dis_total[p]))
a('')
a('### 4.5 Historias sin referencia a `REQ-*` (%d)' % len(us_sin_req))
a('')
if us_sin_req:
    a('| US | Archivo |')
    a('| :--- | :--- |')
    for u in sorted(us_sin_req):
        a('| `%s` | %s |' % (u, link(us_info[u][0])))
else:
    a('Todas las historias citan al menos un REQ.')
a('')
a('### 4.6 Acciones recomendadas')
a('')
a('1. **Revisar el mapeo propuesto** (`mapeo_req_diseno.csv`, `mapeo_req_gherkin.csv`): confirmar o corregir primero las filas de confianza media y los módulos nivel A; marcar `estado=confirmado`.')
a('2. **Cerrar §4.1 y §4.2** priorizando módulos nivel A (seguridad, auth, motor social, publicación).')
a('3. **Etiquetar más Gherkin**: `python etiquetar_features.py --incluir-media` tras revisar; escribir escenarios nuevos para los REQ sin tag (columna «Gherkin» de §3).')
a('4. Resolver los requerimientos de §4.3 (riesgo/deuda) o registrarlos como issues.')
a('')

with open(OUT, 'w', encoding='utf-8', newline='\n') as f:
    f.write('\n'.join(L))
print('OK', len(all_req), 'REQ;', len(sin_us), 'sin US;', len(sin_sdd), 'sin SDD;', len(sin_gk), 'sin Gherkin;', n_dis_sin_req, 'diseno sin REQ;', len(us_sin_req), 'US sin REQ')
