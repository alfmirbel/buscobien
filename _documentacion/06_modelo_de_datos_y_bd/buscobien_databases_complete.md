# Bases de Datos CouchDB — BuscoBien (07_data_base)

**Directorio:** `_documentacion/06_modelo_de_datos_y_bd/`
**Fecha:** 2026-09-05
**Bases del diccionario:** 19 (de diseño). **Bases referenciadas en el código del cliente:** 35 — ver [bases_de_datos_en_codigo.md](bases_de_datos_en_codigo.md)
**Esquema:** `buscobien_*` (convención CouchDB)
**Acceso (estado real):** el cliente Flutter accede **directamente** a CouchDB con Basic Auth (paquete `http`); el API Node.js con `nano` + JWT es el objetivo, aún no implementado en el cliente.

---

## Diccionario de esquemas (19 bases de diseño)

> Los nombres de las bases de propiedades se corrigieron para coincidir con el código (`..._normal`, `_destacado`, `_super`, `_oportunidad`, `_remate`). Las bases 17–19 (`buscobien_configuracion`, `buscobien_parametros`, `buscobien_auditoria`) **no aparecen en el código del cliente**; su existencia debe confirmarse en el servidor. Faltan en este diccionario 19 bases (sección «Bases usadas por el cliente que faltaban en el diccionario») que el cliente sí usa (ver el inventario verificado).

| # | Nombre DB | Propósito | Doc ID Pattern | Indexes Mango | Vistas Secundarias |
|---|-----------|-----------|----------------|---------------|-------------------|
| 1 | `buscobien_usuarios` | Usuarios registrados (auth JWT) | `user:uuid` | - `type`: `"user"` <br> - `role`: `"user"` / `"admin"` | - `usuarios_por_rol` <br> - `ultimo_acceso` |
| 2 | `buscobien_propiedades` | Catálogo general de propiedades | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipotransaccion`: `"Venta"|"Renta"|"Venta/Renta"|"Traspaso"` <br> - `tipoespacio`: normal/destacado/superdestacado/oportunidad/remate <br> - `estado`: `"activo"|"inactivo"` | - `propiedades_por_tipo` <br> - `propiedades_por_vendedor` <br> - `propiedades_recientes` |
| 3 | `buscobien_listas_propiedades` | Listas de propiedades creadas por usuario | `lista:uuid` | - `type`: `"lista"` <br> - `dueño`: `user:uuid` <br> - `tipo`: `"mis_listas"|"compartidas"|"recibidas"` | - `listas_por_dueño` <br> - `listas_por_tipo` <br> - `elementos_por_lista` |
| 4 | `buscobien_invitaciones` | Invitaciones a conocidos/grupos | `invitacion:uuid` | - `type`: `"invitation"` <br> - `estado`: `"pendiente"|"aceptada"|"rechazada"` <br> - `categoria`: `"conocido"|"grupo"` | - `invitaciones_por_usuario` <br> - `invitaciones_por_estado` <br> - `expiracion_token` |
| 5 | `buscobien_grupos` | Grupos de comunidad / red social | `grupo:uuid` | - `type`: `"grupo"` <br> - `miembros`: `[user:uuid]` <br> - `rol_admin`: `user:uuid` <br> - `tipo`: `"público"|"privado"` | - `grupos_por_tipo` <br> - `grupos_por_admin` <br> - `miembros_por_grupo` |
| 6 | `buscobien_mensajes` | Mensajería 1:1 y grupal | `mensaje:uuid` | - `type`: `"mensaje"` <br> - `remitente`: `user:uuid` <br> - `destinatario`: `user:uuid` / `grupo:uuid` <br> - `tipo`: `"individual"|"grupal"` <br> - `leido`: `boolean` | - `mensajes_por_remitente` <br> - `mensajes_por_destinatario` <br> - `conversaciones_activas` |
| 7 | `buscobien_casas_comprados_normal` | Propiedades tipo "normal" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"normal"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_normales_captura` |
| 8 | `buscobien_publicados_normal` | Propiedades tipo "normal" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"normal"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_normales_publicadas` |
| 9 | `buscobien_casas_comprados_destacado` | Propiedades tipo "destacado" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"destacado"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_destacadas_captura` |
| 10 | `buscobien_publicados_destacado` | Propiedades tipo "destacado" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"destacado"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_destacadas_publicadas` |
| 11 | `buscobien_casas_comprados_super` | Propiedades tipo "superdestacado" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"superdestacado"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_superdestacadas_captura` |
| 12 | `buscobien_publicados_super` | Propiedades tipo "superdestacado" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"superdestacado"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_superdestacadas_publicadas` |
| 13 | `buscobien_casas_comprados_oportunidad` | Propiedades tipo "oportunidad" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"oportunidad"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_oportunidades_captura` |
| 14 | `buscobien_publicados_oportunidad` | Propiedades tipo "oportunidad" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"oportunidad"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_oportunidades_publicadas` |
| 15 | `buscobien_casas_comprados_remate` | Propiedades tipo "remate" — captura | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"remate"` <br> - `estadopublicacion`: `"captura"` | - `propiedades_remates_captura` |
| 16 | `buscobien_publicados_remate` | Propiedades tipo "remate" — publicados | `propiedad:uuid` | - `type`: `"propiedad"` <br> - `tipoespacio`: `"remate"` <br> - `estadopublicacion`: `"publicado"` | - `propiedades_remates_publicadas` |
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

## Bases usadas por el cliente que faltaban en el diccionario

Propósito deducido del código de `lib/` (nombre, vistas y módulo que las usa). Los esquemas exactos de documento deben confirmarse en el servidor. Inventario con archivos: [`bases_de_datos_en_codigo.md`](bases_de_datos_en_codigo.md).

| Base | Propósito (según el código) | Módulo |
| :--- | :--- | :--- |
| `buscobien_usuarios_promotores` | Usuarios con perfil Promotor (login, registro, recuperación) | `10_user_login`, `08_pantallas/tu_cuenta` |
| `buscobien_usuarios_propietarios` | Usuarios con perfil Propietario (recuperación de contraseña) | `10_user_login` |
| `codigospostales` | Catálogo SEPOMEX; vista `vistaCP` (`_design/DDCP`) por código postal | `12_localidades_user` |
| `buscobien_user_localidad` | Localidades guardadas por usuario; vistas `vistaUserID` y `vistaUserAsentamiento` (`_design/DDUL`) | `12_localidades_user` |
| `buscobien_avatares` | Avatar del usuario como adjunto; vista `vistaUserID` (`_design/DDUSER`) | `10_user_login`, `22_imagenes` |
| `buscobien_propiedades_casas_fotos` | Fotos de las propiedades (consulta de ids y contenido) | `22_imagenes` |
| `buscobien_fotos_ordenadas` | Orden guardado de las fotos por propiedad; vista `idpropiedad` (`_design/DDLISTAFOTOS`) | `22_imagenes` |
| `buscobien_usuarios_listas` | Listas de propiedades de cada usuario | `03_listas` |
| `buscobien_megusta_propiedades` | Marcas «Me gusta» (`usuarioId`, `propiedadId`, `timestamp`) | `03_listas` |
| `buscobien_listas_compartidas_usuarios` | Listas compartidas entre usuarios (origen, destino, `listaNombre`) | `03_listas` |
| `buscobien_listas_prop_compartidas` | Copias de propiedades de una lista compartida | `03_listas` |
| `buscobien_propiedades_compartidas_conocidos` | Propiedades compartidas con un conocido | `03_listas` |
| `buscobien_grupos_invitaciones` | Invitaciones a grupos (estado pendiente/accepted/rejected) | `08_pantallas/tu_cuenta/grupos` |
| `buscobien_grupos_mensajes` | Mensajes del chat de grupo (con `_changes` en tiempo real) | `08_pantallas/tu_cuenta/grupos` |
| `buscobien_grupos_publicaciones` | Propiedades compartidas en un grupo (paginadas de 10 en 10) | `08_pantallas/tu_cuenta/grupos` |
| `buscobien_grupos_avisos` | Avisos del grupo (máx. 250 caracteres) | `08_pantallas/tu_cuenta/grupos` |
| `buscobien_compra_espacios` | Registro de compras de espacios publicitarios | `08_pantallas/tu_cuenta/tus_espacios` |
| `buscobien_espacios` | Consulta de una propiedad por id desde los chats (conocidos y grupos) | `08_pantallas/tu_cuenta` |
| `buscobien_social` | Invitaciones del proveedor heredado `social_providers.dart` (la pantalla actual usa `buscobien_invitaciones`) | `08_pantallas/tu_cuenta/conocidos` |

Notas: `buscobien_terminos_condiciones.pdf` y `buscobien_aviso_privacidad.pdf` son nombres de archivo del registro, no bases de datos.

## Convenciones y Consideraciones Adicionales

1. **Estado real:** el cliente envía credenciales CouchDB (Basic Auth) en cada petición. **Objetivo:** que las queries pasen por el API Node.js con `nano` + JWT.
2. **Doc IDs semánticos:** `user:uuid`, `propiedad:uuid`, `lista:uuid`, `grupo:uuid`, `mensaje:uuid`, `invitacion:uuid`, `config:uuid`, `parametro:uuid`, `audit:uuid`.
3. **Mango sobre MapReduce:** Preferir siempre Mango queries (`selector`, `fields`, `sort`, `limit`) por performance.
4. **Indices:** Crear vistas Mango para queries frecuentes; vistas MapReduce solo para reportes ad-hoc.
5. **TTL / limpieza automática:** Base `buscobien_auditoria` debe tener policy de retención (ej. mantener 12 meses, purgar older).
6. **Validación side:** El API Node.js debe validar que el usuario JWT tiene permiso para acceder a la DB solicitada (RBAC por rol).
7. **Backups:** Programar daily backup de todas las DBs; rotar cada 7 días un backup completo.
8. **Compaction:** Ejecutar compaction periódico en DBs de alto volumen (`buscobien_propiedades`, `buscobien_mensajes`) para mantener performance.

---

## Apéndice

Los archivos de `lib/` que referencian cada base se listan, generados desde el código, en [`bases_de_datos_en_codigo.md`](bases_de_datos_en_codigo.md).
