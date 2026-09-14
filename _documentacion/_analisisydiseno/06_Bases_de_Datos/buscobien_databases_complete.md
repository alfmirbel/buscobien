# Bases de Datos CouchDB — BuscoBien (06_Bases_de_Datos)

**Directorio:** `documentacion/_analisisydiseno/06_Bases_de_Datos/`
**Fecha:** 2026-09-05
**Total de bases de datos:** 19
**Esquema:** `buscobien_*` (convención CouchDB)
**Acceso:** Flutter nunca se conecta directamente a CouchDB — todo el acceso va por el Node.js API (repo separado) con `nano` y JWT auth.

---

## Diccionario Completo de 19 Bases de Datos

| # | Nombre DB | Propósito | Doc ID Pattern | Indexes Mango | Vistas Secundarias |
|---|-----------|-----------|----------------|---------------|-------------------|
| 1 | `buscobien_usuarios` | Usuarios registrados (auth JWT) | `user:uuid` | - `type`: `"user"` <br> - `role`: `"user"` / `"admin"` | - `usuarios_por_rol` <br> - `ultimo_acceso` |
| 2 | `buscobien_propiedades` | Catálogo general de propiedades | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipotransaccion`: `"Venta"|"Renta"|"Venta/Renta"|"Traspaso"` <br> - `tipoespacio`: normal/destacado/superdestacado/oportunidad/remate <br> - `estado`: `"activo"|"inactivo"` | - `propiedades_por_tipo` <br> - `propiedades_por_vendedor` <br> - `propiedades_recientes` |
| 3 | `buscobien_listas_propiedades` | Listas de propiedades creadas por usuario | `lista:uuid` | - `type`: `"lista"` <br> - `dueño`: `user:uuid` <br> - `tipo`: `"mis_listas"|"compartidas"|"recibidas"` | - `listas_por_dueño` <br> - `listas_por_tipo` <br> - `elementos_por_lista` |
| 4 | `buscobien_invitaciones` | Invitaciones a conocidos/grupos | `invitacion:uuid` | - `type`: `"invitation"` <br> - `estado`: `"pendiente"|"aceptada"|"rechazada"` <br> - `categoria`: `"conocido"|"grupo"` | - `invitaciones_por_usuario` <br> - `invitaciones_por_estado` <br> - `expiracion_token` |
| 5 | `buscobien_grupos` | Grupos de comunidad / red social | `grupo:uuid` | - `type`: `"grupo"` <br> - `miembros`: `[user:uuid]` <br> - `rol_admin`: `user:uuid` <br> - `tipo`: `"público"|"privado"` | - `grupos_por_tipo` <br> - `grupos_por_admin` <br> - `miembros_por_grupo` |
| 6 | `buscobien_mensajes` | Mensajería 1:1 y grupal | `mensaje:uuid` | - `type`: `"mensaje"` <br> - `remitente`: `user:uuid` <br> - `destinatario`: `user:uuid` / `grupo:uuid` <br> - `tipo`: `"individual"|"grupal"` <br> - `leido`: `boolean` | - `mensajes_por_remitente` <br> - `mensajes_por_destinatario` <br> - `conversaciones_activas` |
| 7 | `buscobien_casas_comprados_normales` | Propiedades tipo "normal" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"normal"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_normales_captura` |
| 8 | `buscobien_publicados_normales` | Propiedades tipo "normal" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"normal"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_normales_publicadas` |
| 9 | `buscobien_casas_comprados_destacados` | Propiedades tipo "destacado" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"destacado"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_destacadas_captura` |
| 10 | `buscobien_publicados_destacados` | Propiedades tipo "destacado" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"destacado"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_destacadas_publicadas` |
| 11 | `buscobien_casas_comprados_superdestacados` | Propiedades tipo "superdestacado" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"superdestacado"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_superdestacadas_captura` |
| 12 | `buscobien_publicados_superdestacados` | Propiedades tipo "superdestacado" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"superdestacado"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_superdestacadas_publicadas` |
| 13 | `buscobien_casas_comprados_oportunidades` | Propiedades tipo "oportunidad" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"oportunidad"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_oportunidades_captura` |
| 14 | `buscobien_publicados_oportunidades` | Propiedades tipo "oportunidad" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"oportunidad"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_oportunidades_publicadas` |
| 15 | `buscobien_casas_comprados_remates` | Propiedades tipo "remate" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"remate"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_remates_captura` |
| 16 | `buscobien_publicados_remates` | Propiedades tipo "remate" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"remate"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_remates_publicadas` |
| 17 | `buscobien_configuracion` | Configuración global del sistema | `clave:uuid` | - `type`: `"config"` <br> - `categoria`: `"m3"|"colores"|"urls"` <br> - `clave`: `"theme_default"|"api_url"` | - `config_por_categoria` |
| 18 | `buscobien_parametros` | Parámetros de negocio y ajustes | `parametro:uuid` | - `type`: `"parametro"` <br> - `grupo`: `"cobranza"|"imagenes"|"seguridad"` <br> - `clave`: `"limite_fotos"|"tiempo_token"` | - `parametros_por_grupo` |
| 19 | `buscobien_auditoria` | Registro de eventos y cambios | `evento:uuid` | - `type`: `"audit"` <br> - `accion`: `"crear"|"actualizar"|"eliminar"` <br> - `tabla`: `"propiedad"|"usuario"|"lista"` <br> - `timestamp`: ISO8601 | - `audit_por_tabla` <br> - `audit_por_fecha` <br> - `audit_por_usuario` |

---

## Esquema JSON Ejemplo: `buscobien_propiedades`

```json
{
  "_id": "propiedad:550e8400-e29b-41d4-a716-446655440000",
  "_rev": "1-" + "a1b2c3d4",
  "type": "propiedad",
  "titulo": "Casa en Monterrey",
  "descripcion": "Hermosa propiedad residencial",
  "precioventa": 2500000,
  "preciorenta": 0,
  "moneda": "MXN",
  "tipotransaccion": "Venta",
  "tipoespacio": "normal",
  "estadopublicacion": "publicado",
  "id_usuario": "user:abc123",
  "fecha_creacion": "2024-03-15T10:30:00Z",
  "fecha_actualizacion": "2024-03-20T14:45:00Z",
  "ubicacion": {
    "cp": "64000",
    "ciudad": "Monterrey",
    "estado": "Nuevo León",
    "lat": 25.6750,
    "lng": -100.3185
  },
  "fotoprincipal": "https://cdn.buscobien.com/fotos/propiedad/123.jpg",
  "galeria": [
    "https://cdn.buscobien.com/fotos/propiedad/123-1.jpg",
    "https://cdn.buscobien.com/fotos/propiedad/123-2.jpg"
  ],
  "tags": ["residencial", "monterrey", "3hab"],
  "m2_construidos": 120,
  "m2_terreno": 350,
  "habitaciones": 3,
  "baños": 2,
  "estacionamientos": 1,
  "disponible": true,
  "verificado": false
}
```

---

## Consultas Mango (Nano) — Ejemplos Críticos

### 1. Obtener propiedad por tipo de transacción y estado

```json
{
  "selector": {
    "type": "propiedad",
    "tipotransaccion": "Venta",
    "estadopublicacion": "publicado"
  },
  "fields": ["_id", "titulo", "precioventa", "moneda", "fotoprincipal", "ubicacion"],
  "sort": [["fecha_creacion", "desc"]],
  "limit": 10
}
```

### 2. Propiedades de un usuario específico

```json
{
  "selector": {
    "type": "propiedad",
    "id_usuario": "user:abc123"
  },
  "fields": ["_id", "titulo", "precioventa", "tipotransaccion", "fecha_creacion"],
  "sort": [["fecha_creacion", "desc"]]
}
```

### 3. Listas propias de un usuario

```json
{
  "selector": {
    "type": "lista",
    "dueño": "user:abc123",
    "tipo": "mis_listas"
  },
  "fields": ["_id", "nombre", "total_elementos", "fecha_creacion"],
  "sort": [["fecha_creacion", "desc"]]
}
```

### 4. Propiedades por tipo de espacio (5 categorías × 2 modos = 10 DBs)

```json
{
  "selector": {
    "type": "propiedad",
    "tipoespacio": "destacado",
    "estadopublicacion": "captura"
  },
  "fields": ["_id", "titulo", "precioventa", "moneda", "fotoprincipal"],
  "limit": 50
}
```

### 5. Mensajes no leídos para un usuario

```json
{
  "selector": {
    "type": "mensaje",
    "destinatario": "user:abc123",
    "leido": false
  },
  "fields": ["_id", "remitente", "contenido", "fecha_creacion"],
  "sort": [["fecha_creacion", "desc"]]
}
```

### 6. Usuarios por rol (admin vs user)

```json
{
  "selector": {
    "type": "user",
    "role": {" "$gt": null } // todos los users
  },
  "fields": ["_id", "email", "role", "ultimo_acceso"],
  "limit": 20
}
```

### 7. Auditoría por tabla y fecha

```json
{
  "selector": {
    "type": "audit",
    "tabla": "propiedad",
    "timestamp": {" "$gte": "2024-01-01T00:00:00Z"}
  },
  "fields": ["_id", "accion", "usuario", "timestamp", "documento_id"],
  "sort": [["timestamp", "desc"]],
  "limit": 100
}
```

### 8. Configuración por categoría

```json
{
  "selector": {
    "type": "config",
    "categoria": "m3"
  },
  "fields": ["_id", "clave", "valor", "fecha_actualizacion"]
}
```

### 9. Parámetros por grupo

```json
{
  "selector": {
    "type": "parametro",
    "grupo": "imagenes"
  },
  "fields": ["_id", "clave", "valor", "descripcion"]
}
```

### 10. Propiedades recientes (últimas 20 cargadas)

```json
{
  "selector": {
    "type": "propiedad",
    "estadopublicacion": "publicado"
  },
  "fields": ["_id", "titulo", "precioventa", "moneda", "fotoprincipal", "fecha_creacion"],
  "sort": [["fecha_creacion", "desc"]],
  "limit": 20
}
```

---

## Vistas (Views) — Diseño por Base de Datos

### `buscobien_usuarios` — vista `usuarios_por_rol`

```
map function(doc) {
  if (doc.type === "user") {
    emit(doc.role, doc);
  }
}
```

Reduce: none (listado por rol)

### `buscobien_propiedades` — vista `propiedades_por_tipo`

```
map function(doc) {
  if (doc.type === "propiedad" && doc.estadopublicacion === "publicado") {
    emit([doc.tipotransaccion, doc.tipoespacio], doc);
  }
}
```

Reduce: none (listado filtrado por tipo transacción y tipo espacio)

### `buscobien_listas_propiedades` — vista `elementos_por_lista`

```
map function(doc) {
  if (doc.type === "lista") {
    emit([doc._id, doc.total_elementos], doc.total_elementos);
  }
}
```

Reduce: sum (total de elementos por lista)

### `buscobien_mensajes` — vista `conversaciones_activas`

```
map function(doc) {
  if (doc.type === "mensaje") {
    // Agrupa por par de usuarios (orden alfabético para consistencia)
    var participantes = [doc.remitente, doc.destinatario];
    participantes.sort();
    emit(participantes.join("-"), { ultimo: doc.fecha_creacion, leido: doc.leido });
  }
}
```

Reduce: `{ $last: "$ultimo", $last: "$leido" }` (último mensaje por conversación)

### `buscobien_configuracion` — vista `config_por_categoria`

```
map function(doc) {
  if (doc.type === "config") {
    emit(doc.categoria, { clave: doc.clave, valor: doc.valor });
  }
}
```

Reduce: none (una sola fila por categoría)

### `buscobien_auditoria` — vista `audit_por_tabla_fecha`

```
map function(doc) {
  if (doc.type === "audit") {
    emit([doc.tabla, doc.timestamp], doc);
  }
}
```

Reduce: none (listado completo — usar limit+skip en el API)

### `buscobien_parametros` — vista `parametros_por_grupo`

```
map function(doc) {
  if (doc.type === "parametro") {
    emit(doc.grupo, doc);
  }
}
```

Reduce: none (listado por grupo)

---

## Índices Compuestos (Recomendados para Performance)

| Base de Datos | Campo(s) | Tipo | Justificación |
|---------------|----------|------|---------------|
| `buscobien_propiedades` | `type`, `tipotransaccion`, `estadopublicacion` | Compound | Filtros principales en listado catálogo |
| `buscobien_propiedades` | `id_usuario`, `fecha_creacion` | Compound | Perfil de usuario → mis propiedades |
| `buscobien_mensajes` | `remitente`, `destinatario`, `leido` | Compound | Bandeja de entrada / conversaciones |
| `buscobien_listas_propiedades` | `dueño`, `tipo` | Compound | Listas filtradas por usuario |
| `buscobien_invitaciones` | `categoria`, `estado` | Compound | Invitaciones pendientes/por tipo |
| `buscobien_grupos` | `miembros`, `rol_admin` | Compound | Miembros y administración |
| `buscobien_auditoria` | `tabla`, `timestamp` | Compound | Reportes y auditoría |
| `buscobien_usuarios` | `role`, `ultimo_acceso` | Compound | Lista de usuarios activos |

---

## Convenciones y Consideraciones Adicionales

1. **Nunca se envían credenciales CouchDB desde Flutter** — todas las queries van through el Node.js API con nano + JWT en headers Authorization.
2. **Doc IDs semánticos:** `user:uuid`, `propiedad:uuid`, `lista:uuid`, `grupo:uuid`, `mensaje:uuid`, `invitacion:uuid`, `config:uuid`, `parametro:uuid`, `audit:uuid`.
3. **Mango sobre MapReduce:** Preferir siempre Mango queries (`selector`, `fields`, `sort`, `limit`) por performance.
4. **Indices:** Crear vistas Mango para queries frecuentes; vistas MapReduce solo para reportes ad-hoc.
5. **TTL / limpieza automática:** Base `buscobien_auditoria` debe tener policy de retención (ej. mantener 12 meses, purgar older).
6. **Validación side:** El API Node.js debe validar que el usuario JWT tiene permiso para acceder a la DB solicitada (RBAC por rol).
7. **Backups:** Programar daily backup de todas las 19 DBs; rotar cada 7 días un backup completo.
8. **Compaction:** Ejecutar compaction periódico en DBs de alto volumen (`buscobien_propiedades`, `buscobien_mensajes`) para mantener performance.