#!/bin/bash
# Setup CouchDB para recuperación de contraseña
# Ejecutar en el servidor: bash setup_couchdb_propietarios.sh
# Requiere: COUCHDB_PASSWORD en el entorno o editar la variable abajo

COUCHDB_URL="https://citigov.cloud:6984"
COUCHDB_USER="admin"
COUCHDB_PASS="${COUCHDB_PASSWORD:-EDITA_ESTE_VALOR}"

echo "=== Creando base de datos buscobien_usuarios_propietarios ==="
curl -X PUT "$COUCHDB_URL/buscobien_usuarios_propietarios" \
  -u "$COUCHDB_USER:$COUCHDB_PASS"
echo ""

echo "=== Creando Design Document DDUSER en buscobien_usuarios_propietarios ==="
curl -X PUT "$COUCHDB_URL/buscobien_usuarios_propietarios/_design/DDUSER" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{
    "views": {
      "vistaNOMBRE": {
        "map": "function(doc) { if(doc.usuario) emit(doc.usuario.nombreusuario, doc); }"
      },
      "vistaUserID": {
        "map": "function(doc) { if(doc.usuario) emit(doc.usuario.id_usuario, { \"userID\": doc.usuario.id_usuario, \"userName\": doc.usuario.nombreusuario, \"userPass\": doc.usuario.claveacceso, \"idFoto\": doc.usuario.claveacceso }); }"
      },
      "vistaIdUserPassByNAME": {
        "map": "function(doc) { if(doc.usuario) emit(doc.usuario.nombreusuario, { \"userId\": doc.usuario.id_usuario, \"userName\": doc.usuario.nombreusuario, \"userPass\": doc.usuario.claveacceso, \"idFoto\": doc.usuario.claveacceso }); }"
      },
      "vistaUserPass": {
        "map": "function(doc) { if(doc.usuario) emit(doc.usuario.id_usuario, { \"userID\": doc.usuario.id_usuario, \"userName\": doc.usuario.nombreusuario, \"userPass\": doc.usuario.claveacceso }); }"
      }
    }
  }'
echo ""

echo "=== Creando índice Mango: correo en buscobien_usuarios_propietarios ==="
curl -X POST "$COUCHDB_URL/buscobien_usuarios_propietarios/_index" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{"index": {"fields": ["usuario.correoelectronico"]}, "name": "idx-correo", "type": "json"}'
echo ""

echo "=== Creando índice Mango: reset_token en buscobien_usuarios_propietarios ==="
curl -X POST "$COUCHDB_URL/buscobien_usuarios_propietarios/_index" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{"index": {"fields": ["usuario.reset_token"]}, "name": "idx-reset-token", "type": "json"}'
echo ""

echo "=== Creando índice Mango: correo en buscobien_usuarios ==="
curl -X POST "$COUCHDB_URL/buscobien_usuarios/_index" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{"index": {"fields": ["usuario.correoelectronico"]}, "name": "idx-correo", "type": "json"}'
echo ""

echo "=== Creando índice Mango: reset_token en buscobien_usuarios ==="
curl -X POST "$COUCHDB_URL/buscobien_usuarios/_index" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{"index": {"fields": ["usuario.reset_token"]}, "name": "idx-reset-token", "type": "json"}'
echo ""

echo "=== Creando índice Mango: correo en buscobien_usuarios_promotores ==="
curl -X POST "$COUCHDB_URL/buscobien_usuarios_promotores/_index" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{"index": {"fields": ["usuario.correoelectronico"]}, "name": "idx-correo", "type": "json"}'
echo ""

echo "=== Creando índice Mango: reset_token en buscobien_usuarios_promotores ==="
curl -X POST "$COUCHDB_URL/buscobien_usuarios_promotores/_index" \
  -u "$COUCHDB_USER:$COUCHDB_PASS" \
  -H "Content-Type: application/json" \
  -d '{"index": {"fields": ["usuario.reset_token"]}, "name": "idx-reset-token", "type": "json"}'
echo ""

echo "=== Setup completo ==="
