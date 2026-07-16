class CouchdbCodigo {
  int codigo = 0;
  String label = "";
  String description = "";

  CouchdbCodigo(this.codigo, this.label, this.description);
}

Map<int, CouchdbCodigo> codigoCouchDB = {
  200: listaCodigosCouchDB[0],
  201: listaCodigosCouchDB[1],
  202: listaCodigosCouchDB[2],
  304: listaCodigosCouchDB[3],
  400: listaCodigosCouchDB[4],
  401: listaCodigosCouchDB[5],
  403: listaCodigosCouchDB[6],
  404: listaCodigosCouchDB[7],
  405: listaCodigosCouchDB[8],
  406: listaCodigosCouchDB[8],
  409: listaCodigosCouchDB[10],
  412: listaCodigosCouchDB[11],
  413: listaCodigosCouchDB[12],
  415: listaCodigosCouchDB[13],
  416: listaCodigosCouchDB[14],
  417: listaCodigosCouchDB[15],
  500: listaCodigosCouchDB[16],
  503: listaCodigosCouchDB[17],
};

List<CouchdbCodigo> listaCodigosCouchDB = [
  CouchdbCodigo(200, "OK", "Solicitud completada correctamente."),
  CouchdbCodigo(201, "Creado", "Documento creado con éxito."),
  CouchdbCodigo(202, "Aceptado",
      "Request has been accepted, but the corresponding operation may not have completed. This is used for background operations, such as database compaction."),
  CouchdbCodigo(304, "No modificado",
      "El contenido adicional solicitado no ha sido modificado."),
  CouchdbCodigo(400, "Solicitud errónea",
      "Mala estructura de la solicitud. El código puede indicar la URL de la solicitud, la ruta o los encabezados."),
  CouchdbCodigo(401, "No autorizado",
      "El documento solicitado no estaba disponible con la autorización suministrada, o la autorización no se proporcionó."),
  CouchdbCodigo(
      403, "Prohibido", "El artículo u operación solicitada está prohibido."),
  CouchdbCodigo(
      404, "No encontrado", "No se pudo encontrar el contenido solicitado."),
  CouchdbCodigo(405, "Método no permitido",
      "Se realizó una solicitud utilizando un tipo de solicitud HTTP no válido para la URL solicitada."),
  CouchdbCodigo(406, "Not Acceptable",
      " requested content type is not supported by the server."),
  CouchdbCodigo(409, "Conflicto",
      "La solicitud resultó en un conflicto de actualización."),
  CouchdbCodigo(412, "Condición previa fallida",
      "Los encabezados de solicitud del cliente y las capacidades del servidor no coinciden."),
  CouchdbCodigo(413, "Entidad de solicitud demasiado grande",
      "Un documento supera el valor couchdb/max_document_size configurado o toda la solicitud supera el valor chttpd/max_http_request_size."),
  CouchdbCodigo(415, "Tipo de medio no admitido",
      "Los tipos de contenido admitidos y el tipo de contenido de la información que se solicita o envía indican que el tipo de contenido no es compatible."),
  CouchdbCodigo(416, "Rango solicitado no satisfactorio",
      "El servidor no puede satisfacer el rango especificado en el encabezado de la solicitud."),
  CouchdbCodigo(417, "Expectativa fallida",
      "Al enviar documentos en bloque, la operación de carga masiva falló."),
  CouchdbCodigo(500, "Código del servidor interno",
      "La solicitud no era válida, ya sea porque el JSON proporcionado no era válido o porque se proporcionó información no válida como parte de la solicitud."),
  CouchdbCodigo(503, "Servicio no disponible",
      "La solicitud no se puede atender en este momento, ya sea porque el servicio está sobrecargado, está en curso un mantenimiento o por alguna otra razón."),
];

List<CouchdbCodigo> listaCodigosCouchDBEn = [
  CouchdbCodigo(200, "OK", "Request completed successfully."),
  CouchdbCodigo(201, "Created", "Document created successfully."),
  CouchdbCodigo(202, "Accepted",
      "Request has been accepted, but the corresponding operation may not have completed. This is used for background operations, such as database compaction."),
  CouchdbCodigo(304, "Not Modified",
      "The additional content requested has not been modified. This is used with the ETag system to identify the version of information returned."),
  CouchdbCodigo(400, "Bad Request",
      "Bad request structure. The codigo can indicate an codigo with the request URL, path or headers. Differences in the supplied MD5 hash and content also trigger this codigo, as this may indicate message corruption."),
  CouchdbCodigo(401, "Unauthorized",
      "The item requested was not available using the supplied authorization, or authorization was not supplied."),
  CouchdbCodigo(
      403, "Forbidden", "The requested item or operation is forbidden."),
  CouchdbCodigo(404, "Not Found",
      "The requested content could not be found. The content will include further information, as a JSON object, if available. The structure will contain two keys, codigo and reason."),
  CouchdbCodigo(405, "Method Not Allowed",
      "A request was made using an invalid HTTP request type for the URL requested. For example, you have requested a PUT when a POST is required. Codigos of this type can also triggered by invalid URL strings."),
  CouchdbCodigo(406, "Not Acceptable",
      " requested content type is not supported by the server."),
  CouchdbCodigo(409, "Conflict", "Request resulted in an update conflict."),
  CouchdbCodigo(412, "Precondition Failed",
      "The request headers from the client and the capabilities of the server do not match."),
  // local.ini: max_http_request_size = 4,294,967,296 ; 4 GB
  CouchdbCodigo(413, "Request Entity Too Large",
      "A document exceeds the configured couchdb/max_document_size value or the entire request exceeds the chttpd/max_http_request_size value."),
  CouchdbCodigo(415, "Unsupported Media Type",
      "The content types supported, and the content type of the information being requested or submitted indicate that the content type is not supported."),
  CouchdbCodigo(416, "Requested Range Not Satisfiable",
      "The range specified in the request header cannot be satisfied by the server."),
  CouchdbCodigo(417, "Expectation Failed",
      "When sending documents in bulk, the bulk load operation failed."),
  CouchdbCodigo(500, "Internal Server Codigo",
      "The request was invalid, either because the supplied JSON was invalid, or invalid information was supplied as part of the request."),
  CouchdbCodigo(503, "Service Unavailable",
      "The request can’t be serviced at this time, either because the cluster is overloaded, maintenance is underway, or some other reason. The request may be retried without changes, perhaps in a couple of minutes."),
];
