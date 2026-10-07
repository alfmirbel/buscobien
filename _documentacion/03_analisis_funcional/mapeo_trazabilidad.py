#!/usr/bin/env python3
"""Propone el mapeo de trazabilidad por similitud de texto (TF-IDF + coseno).

Genera (o actualiza) dos CSV revisables por humanos:
  mapeo_req_diseno.csv   : elemento de diseño (DES-* / SDD-*) -> REQ-* de las Epics
  mapeo_req_gherkin.csv  : escenario Gherkin -> REQ-* de las Epics

Columnas comunes: ..., req_id, score, confianza (alta|media|baja|ninguna), estado.
`estado` = propuesto (lo recalcula el script) | tabla (viene de mapeo_manual_diseno.csv, revisado) | confirmado | rechazado (los fija una persona;
el script los respeta y no los sobrescribe).  Corregir un mapeo = editar `req_id` y poner
`estado=confirmado`.

Uso:  python mapeo_trazabilidad.py [--estadisticas]
Luego: python etiquetar_features.py   y   python generar_matriz_trazabilidad.py
"""
import collections
import csv
import math
import os
import re
import sys
import unicodedata

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
P = lambda *a: os.path.join(ROOT, *a)
EPICS = P('02_requerimientos', 'epics_ears')
SDD = P('04_arquitectura_y_diseno', 'modulos_sdd')
GHK = P('07_pruebas_y_calidad', 'gherkin_bdd_scenarios')
FEATS = P('03_analisis_funcional', 'features_analisis')
CSV_DIS = os.path.join(HERE, 'mapeo_req_diseno.csv')
CSV_GHK = os.path.join(HERE, 'mapeo_req_gherkin.csv')
CSV_US = os.path.join(HERE, 'mapeo_req_historias.csv')
STORIES = P('02_requerimientos', 'user_stories')

T_ALTA, T_MEDIA = 0.34, 0.22   # umbrales de coseno (calibrados con revisión manual de muestras)

STOP = set('''para como cuando mientras donde entonces dado cada pero este esta esto estos estas debera deberan sistema
usuario ser sera seran tiene tienen puede pueden desde hasta sobre entre cual cuales mediante cualquier todo todos todas
solo sino tambien segun otro otra otros otras hacia ante bajo contra durante son los las del una uno unos unas que con por
sin hay esta estan fue han its the and for with when then given'''.split())

REQ_RE = re.compile(r'\bREQ-[A-Z0-9]+-\d{2,3}[a-z]?\b')


def read(p):
    with open(p, encoding='utf-8') as f:
        return f.read()


def norm(s):
    return ''.join(c for c in unicodedata.normalize('NFD', s.lower()) if unicodedata.category(c) != 'Mn')


def tokens(text):
    out = []
    for ident in re.findall(r'`([^`]+)`', text):          # identificadores de código pesan doble
        for w in re.split(r'[^A-Za-z0-9]+|(?<=[a-z])(?=[A-Z])', ident):
            if w and len(w) > 2:
                out += [norm(w)[:6]] * 2
    t = norm(re.sub(r'`[^`]*`', ' ', text))
    for w in re.findall(r'[a-z0-9]{3,}', t):
        if w not in STOP:
            out.append(w[:6])
    return out


class Index:
    def __init__(self, docs):
        df = collections.Counter()
        for toks in docs:
            df.update(set(toks))
        n = max(len(docs), 1)
        self.idf = {w: math.log((n + 1) / (c + 0.5)) for w, c in df.items()}

    def vec(self, toks):
        tf = collections.Counter(toks)
        v = {w: (1 + math.log(c)) * self.idf.get(w, math.log(60)) for w, c in tf.items()}
        norm_ = math.sqrt(sum(x * x for x in v.values())) or 1.0
        return {w: x / norm_ for w, x in v.items()}


def cos(a, b):
    if len(a) > len(b):
        a, b = b, a
    return sum(x * b.get(w, 0.0) for w, x in a.items())


def confianza(s):
    return 'alta' if s >= T_ALTA else 'media' if s >= T_MEDIA else 'baja'


# ---------- Epics ----------
epic = {}
for f in sorted(os.listdir(EPICS)):
    stem = f[:-3]
    for line in read(os.path.join(EPICS, f)).splitlines():
        if line.startswith('| REQ-'):
            c = [x.strip() for x in line.strip().strip('|').split('|')]
            if len(c) >= 5 and REQ_RE.fullmatch(c[0]):
                epic[c[0]] = dict(mod=stem, text=c[2] + ' ' + c[3])
by_mod = collections.defaultdict(list)
for rid, v in epic.items():
    by_mod[v['mod']].append(rid)


def sdd_module(relpath):
    parts = relpath.replace('\\', '/').split('/')
    if parts[0] == '08_pantallas':
        if parts[1] == 'tu_cuenta':
            return '08_pantallas_tu_cuenta_' + parts[2]
        return '08_pantallas_' + parts[1]
    return parts[0]


# ---------- Elementos de diseño ----------
design = []   # dict(id, doc, mod, text)
for r, _, fs in os.walk(SDD):
    for f in sorted(fs):
        p = os.path.join(r, f)
        mod = sdd_module(os.path.relpath(p, SDD))
        lines = read(p).splitlines()
        seccion = ''
        for i, l in enumerate(lines):
            if l.startswith('#'):
                seccion = l.lstrip('#').strip()
            m = re.match(r'\s*[-*]\s*\*\*(DES-[A-Z0-9-]+\d):?\*\*:?\s*(.*)', l)
            if m:
                design.append(dict(id=m.group(1), doc=os.path.relpath(p, ROOT).replace('\\', '/'), mod=mod, text=m.group(2), sec=seccion))
                continue
            m = re.match(r'\*\*(SDD-[A-Z0-9-]+\d)\*\*\s*$', l)
            if m:
                body = []
                for nxt in lines[i + 1:i + 6]:
                    if not nxt.strip():
                        if body:
                            break
                        continue
                    body.append(nxt.strip())
                design.append(dict(id=m.group(1), doc=os.path.relpath(p, ROOT).replace('\\', '/'), mod=mod, text=' '.join(body), sec=seccion))


# ---------- Escenarios Gherkin ----------
FILE_MOD = {  # features_analisis/08_pantallas/*.feature y transversales/*.feature
    'inicio': ['08_pantallas_inicio'], 'perfil': ['08_pantallas_perfil'], 'propiedades': ['08_pantallas_propiedades'],
    'tu_cuenta_compra_espacios': ['08_pantallas_tu_cuenta_tus_espacios'], 'tu_cuenta_conocidos': ['08_pantallas_tu_cuenta_conocidos'],
    'tu_cuenta_grupos': ['08_pantallas_tu_cuenta_grupos'], 'tu_cuenta_tus_espacios': ['08_pantallas_tu_cuenta_tus_espacios'],
    'ubicacion': ['08_pantallas_ubicacion'], 'widgets_comunes': ['08_pantallas_widgets_comunes'],
    'conectividad_offline': ['41_connectivity'], 'detalle_propiedad_pdf': ['08_pantallas_propiedades'],
    'imagenes_fotos': ['22_imagenes'], 'listas_favoritos_compartir': ['03_listas'],
    'localidades': ['12_localidades_user', '08_pantallas_ubicacion'], 'login': ['10_user_login'],
    'recuperar_password': ['10_user_login'], 'splash': ['01_splash_screen'],
    'tema_preferencias': ['04_provider', '20_var_globales'],
    'general_usabilidad': [],
    'enrutamiento_y_deep_links': ['07_routes', 'main'], 'tema_y_estilos': ['20_var_globales', '04_provider'],
    'integracion_riverpod_y_globales': ['04_provider', '20_var_globales', 'main'], 'configuracion_material_app': ['20_var_globales', 'main'],
}


def feature_modules(path):
    rel = os.path.relpath(path, ROOT).replace('\\', '/')
    stem = os.path.splitext(os.path.basename(path))[0]
    if stem in FILE_MOD:
        return FILE_MOD[stem]
    if '/gherkin_bdd_scenarios/' in rel:
        sub = rel.split('/gherkin_bdd_scenarios/')[1].split('/')
    else:
        sub = rel.split('/features_analisis/')[1].split('/')
    if sub[0] == '08_pantallas' and len(sub) > 2:
        return ['08_pantallas_tu_cuenta_' + sub[2] if sub[1] == 'tu_cuenta' else '08_pantallas_' + sub[1]]
    return [sub[0]]


SC_RE = re.compile(r'^(\s*)(?:Escenario|Esquema del escenario|Scenario(?: Outline)?)\s*:\s*(.*)$')
STEP_KW = re.compile(r'^\s*(Dado que|Dado|Cuando|Entonces|Y|Pero|E|Given|When|Then|And|But)\b\s*', re.I)
scenarios = []   # dict(file, title, text, mods)
all_features = []
for root in (GHK, FEATS):
    for r, _, fs in os.walk(root):
        for f in sorted(fs):
            if f.endswith('.feature'):
                all_features.append(os.path.join(r, f))
for p in all_features:
    mods = feature_modules(p)
    cur = None
    head = []
    for l in read(p).splitlines():
        m = SC_RE.match(l)
        if m:
            cur = dict(file=os.path.relpath(p, ROOT).replace('\\', '/'), title=m.group(2).strip(), body=[], mods=mods)
            scenarios.append(cur)
        elif cur is not None:
            s = l.strip()
            if s and not s.startswith(('#', '@', '|')):
                cur['body'].append(STEP_KW.sub('', s))
for s in scenarios:
    s['text'] = s['title'] + ' ' + s['title'] + ' ' + ' '.join(s['body'])

# ---------- Historias de usuario ----------
stories = []   # dict(id, file, mod, title, text, citados)
for f in sorted(os.listdir(STORIES)):
    if not f.endswith('.md') or f.startswith('00_'):
        continue
    cur = None
    for l in read(os.path.join(STORIES, f)).splitlines():
        m = re.match(r'^##+\s+(US-[A-Z0-9]+-\d{2,3}[a-z]?)\b[:\s]*(.*)$', l)
        if m:
            cur = dict(id=m.group(1), file=f[:-3], title=m.group(2).strip(), lines=[])
            stories.append(cur)
        elif cur is not None:
            cur['lines'].append(l)
for s in stories:
    body = ' '.join(s['lines'])
    s['citados'] = set(REQ_RE.findall(body))
    s['text'] = s['title'] + ' ' + s['title'] + ' ' + body

# ---------- Índice y puntuación ----------
epic_tok = {rid: tokens(v['text']) for rid, v in epic.items()}
corpus = list(epic_tok.values()) + [tokens(d['text']) for d in design] + [tokens(s['text']) for s in scenarios] + [tokens(s['text']) for s in stories]
IDX = Index(corpus)
epic_vec = {rid: IDX.vec(t) for rid, t in epic_tok.items()}


def best(text, mods, k=2):
    v = IDX.vec(tokens(text))
    cand = [rid for m in mods for rid in by_mod.get(m, [])]
    sc = sorted(((cos(v, epic_vec[rid]), rid) for rid in cand), reverse=True)
    return sc[:k]


def load_existing(path, keycols):
    keep = {}
    if os.path.exists(path):
        with open(path, encoding='utf-8', newline='') as f:
            for row in csv.DictReader(f):
                if row.get('estado') in ('confirmado', 'rechazado'):
                    keep.setdefault(tuple(row[c] for c in keycols), []).append(row)
    return keep


def write_csv(path, cols, rows):
    with open(path, 'w', encoding='utf-8', newline='') as f:
        w = csv.DictWriter(f, fieldnames=cols, lineterminator='\n')
        w.writeheader()
        w.writerows(rows)


# ---- diseño ----
cols = ['diseno_id', 'documento', 'modulo', 'seccion', 'req_id', 'score', 'confianza', 'estado', 'texto_diseno']
keep = load_existing(CSV_DIS, ['diseno_id', 'documento'])
rows = []
for d in design:
    key = (d['id'], d['doc'])
    if key in keep:
        rows += keep[key]
        continue
    sc = best(d['text'], [d['mod']], 1)
    s, rid = sc[0] if sc else (0.0, '')
    conf = confianza(s) if sc else 'ninguna'
    rows.append(dict(diseno_id=d['id'], documento=d['doc'], modulo=d['mod'], seccion=d['sec'][:80], req_id=rid if conf in ('alta', 'media') else '',
                     score='%.2f' % s, confianza=conf, estado='propuesto', texto_diseno=re.sub(r'\s+', ' ', d['text'])[:140]))

# segunda pasada: mapeo por sección (todos los elementos de una sección de un SDD comparten REQ padre probable)
T_GRUPO = 0.25
secs = collections.defaultdict(list)
for d in design:
    secs[(d['doc'], d['sec'], d['mod'])].append(d)
gscore = {}
for (doc, sec, mod), items in secs.items():
    txt = sec + ' ' + ' '.join(i['text'] for i in items)
    sc = best(txt, [mod], 1)
    if sc:
        gscore[(doc, sec)] = sc[0]
for r in rows:
    if r['estado'] != 'propuesto' or r['confianza'] == 'alta':
        continue
    g = gscore.get((r['documento'], r['seccion']))
    if not g:
        # la sección se guardó recortada a 80 caracteres
        g = next((v for (dc, s), v in gscore.items() if dc == r['documento'] and s[:80] == r['seccion']), None)
    if g and g[0] >= T_GRUPO and g[0] > float(r['score']):
        r['req_id'], r['score'], r['confianza'] = g[1], '%.2f' % g[0], 'grupo'
# tercera pasada: tabla manual revisada (mapeo_manual_diseno.csv): selector = id exacto o prefijo de sección
manual = []
CSV_MAN = os.path.join(HERE, 'mapeo_manual_diseno.csv')
if os.path.exists(CSV_MAN):
    with open(CSV_MAN, encoding='utf-8', newline='') as f:
        manual = list(csv.DictReader(f))
for r in rows:
    if r['estado'] in ('confirmado', 'rechazado'):
        continue
    hit = None
    for m in manual:
        if r['documento'].endswith(m['documento_sufijo']) and r['diseno_id'] == m['selector']:
            hit = m
            break
    if hit is None:
        for m in manual:
            if r['documento'].endswith(m['documento_sufijo']) and not re.match(r'(DES|SDD)-', m['selector']) and r['seccion'].startswith(m['selector']):
                hit = m
                break
    if hit:
        r['req_id'], r['score'], r['confianza'], r['estado'] = hit['req_id'], '1.00', 'alta', 'tabla'
write_csv(CSV_DIS, cols, rows)
cd = collections.Counter(r['confianza'] for r in rows)

# ---- gherkin ----
cols = ['feature', 'escenario', 'req_id', 'score', 'confianza', 'estado']
keep = load_existing(CSV_GHK, ['feature', 'escenario'])
rows = []
for s in scenarios:
    key = (s['file'], s['title'])
    if key in keep:
        rows += keep[key]
        continue
    sc = best(s['text'], s['mods'], 2)
    if not sc:
        rows.append(dict(feature=s['file'], escenario=s['title'], req_id='', score='0.00', confianza='ninguna', estado='propuesto'))
        continue
    top = sc[0]
    picked = [x for x in sc if confianza(x[0]) in ('alta', 'media') and (x is top or x[0] >= 0.85 * top[0])]
    if not picked:
        rows.append(dict(feature=s['file'], escenario=s['title'], req_id='', score='%.2f' % top[0], confianza='baja', estado='propuesto'))
    for sco, rid in picked:
        rows.append(dict(feature=s['file'], escenario=s['title'], req_id=rid, score='%.2f' % sco, confianza=confianza(sco), estado='propuesto'))
write_csv(CSV_GHK, cols, rows)
cg = collections.Counter(r['confianza'] for r in rows)

# ---- historias ----
cols = ['us_id', 'archivo', 'req_id', 'score', 'confianza', 'estado']
keep = load_existing(CSV_US, ['us_id', 'req_id'])
rows = []
for s in stories:
    sc = best(s['text'], [s['file']], 3)
    picked = [x for x in sc if x[0] >= T_MEDIA and x[0] >= 0.8 * sc[0][0] and x[1] not in s['citados']]
    for sco, rid in picked:
        key = (s['id'], rid)
        if key in keep:
            rows += keep[key]
            continue
        rows.append(dict(us_id=s['id'], archivo=s['file'] + '.md', req_id=rid, score='%.2f' % sco, confianza=confianza(sco), estado='propuesto'))
    for ks, v in keep.items():
        pass
write_csv(CSV_US, cols, rows)

print('Epics REQ:', len(epic), '| elementos de diseño:', len(design), dict(cd), '| escenarios:', len(scenarios), '| filas gherkin:', dict(cg))
if '--estadisticas' in sys.argv:
    reqs_con_dis = {r['req_id'] for r in csv.DictReader(open(CSV_DIS, encoding='utf-8')) if r['req_id']}
    reqs_con_gk = {r['req_id'] for r in csv.DictReader(open(CSV_GHK, encoding='utf-8')) if r['req_id']}
    print('REQ con diseño:', len(reqs_con_dis), '| REQ con gherkin:', len(reqs_con_gk))
