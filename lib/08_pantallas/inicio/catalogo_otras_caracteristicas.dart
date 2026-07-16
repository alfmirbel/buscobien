Map<String, bool> checklistAdicionales = {
  "panelessolares": false,
  "jardin": false,
  "alberca": false,
  "calefaccion": false,
  "aireacondicionado": false,
  "seguridad": false,
  "enfraccionamiento": false,
  "casasenelconjunto": false,
  "casaclub": false,
  "salondeeventos": false,
  "centrodenegocios": false,
  "gimnacio": false,
  "cisterna": false,
  "almacenamientodeagua": false,
  "tratamientodeaguas": false,
  "otrascaracteristicas": false,
};

//------------------------------------------------------------------------------
List<String> listaOtrasCaracteristicas = [
  "Aire acondicionado",
  "Alberca",
  "Almacenamiento de agua",
  "Amenidades",
  "Calefacción",
  "Casa club",
  "Centro de negocios",
  "Cisterna",
  "En fraccionamiento",
  "Gimnasio",
  "Jardín",
  "Casas en el conjunto",
  "Paneles solares",
  "Salón de eventos",
  "Seguridad",
  "Tratamiento de aguas",
];

List<String> listaCamposCaracteristicas = [
  "panelessolares",
  "jardin",
  "alberca",
  "calefaccion",
  "aireacondicionado",
  "seguridad",
  "enfraccionamiento",
  "casasenelconjunto",
  "casaclub",
  "salondeeventos",
  "centrodenegocios",
  "gimnacio",
  "cisterna",
  "almacenamientodeagua",
  "tratamientodeaguas",
  "otrascaracteristicas",
];

List<String> listaAdicionales = listaCamposCaracteristicas;

void resetchecklistAdicionales() {
  checklistAdicionales["panelessolares"] = false;
  checklistAdicionales["jardin"] = false;
  checklistAdicionales["alberca"] = false;
  checklistAdicionales["calefaccion"] = false;
  checklistAdicionales["aireacondicionado"] = false;
  checklistAdicionales["seguridad"] = false;
  checklistAdicionales["enfraccionamiento"] = false;
  checklistAdicionales["casasenelconjunto"] = false;
  checklistAdicionales["casaclub"] = false;
  checklistAdicionales["salondeeventos"] = false;
  checklistAdicionales["centrodenegocios"] = false;
  checklistAdicionales["gimnacio"] = false;
  checklistAdicionales["cisterna"] = false;
  checklistAdicionales["almacenamientodeagua"] = false;
  checklistAdicionales["tratamientodeaguas"] = false;
  checklistAdicionales["otrascaracteristicas"] = false;
}

String setAdicionales(String nombreDelCampo, bool valor) {
  checklistAdicionales[nombreDelCampo] = valor;
  return valor ? "si" : "";
}
