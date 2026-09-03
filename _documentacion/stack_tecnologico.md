# Stack Tecnológico — Buscobien
**Fuente:** `pubspec.yaml`, `lib/main.dart`, `lib/07_routes/app_routes.dart`
**Fecha:** 2026-07-25

---

## 1. Framework y lenguaje
| Componente | Versión / detalle |
|------------|-------------------|
| Framework | Flutter SDK `>=3.2.3 <4.0.0` |
| SDK detectado | Flutter 3.44.6 (stable), Dart 3.12.2 |
| Diseño UI | Material Design 3 (`uses-material-design: true`) |
| Orientación | Portrait only (`portraitUp`, `portraitDown`) |

## 2. Gestión de estado y arquitectura
| Componente | Versión / detalle |
|------------|-------------------|
| Estado global | `flutter_riverpod: ^3.0.3` |
| Anotaciones Riverpod | `riverpod_annotation: ^4.0.2` |
| Generación código | `riverpod_generator: ^4.0.3`, `build_runner` |
| Lint Riverpod | `riverpod_lint: ^3.0.3` |
| Inyección de dependencias | `ProviderScope` en `main.dart` |

## 3. HTTP y backend
| Componente | Versión / detalle |
|------------|-------------------|
| Cliente HTTP principal | `dio: ^5.9.2` con interceptores |
| HTTP auxiliar | `http: ^1.6.0` |
| Backend | CouchDB (`https://citigov.cloud:6984`) |
| Autenticación | Basic Base64 (`username:password`) |
| Variables de entorno | `flutter_dotenv: ^5.1.0` (`.env`) |

## 4. Almacenamiento local y seguridad
| Componente | Versión / detalle |
|------------|-------------------|
| Token JWT Web/Windows | `shared_preferences: ^2.5.4` |
| Token JWT iOS/Android | `flutter_secure_storage: ^10.0.0` |
| Cifrado | `encrypt: ^5.0.3`, `crypto: ^3.0.7` |

## 5. Mapas y geolocalización
| Componente | Versión / detalle |
|------------|-------------------|
| Mapas Flutter | `google_maps_flutter: ^2.14.0` |
| Mapas Web | `google_maps_flutter_web: ^0.5.14+3` |
| GPS | `geolocator: ^14.0.2` |
| Geocoding | `geocoding: ^4.0.0` |

## 6. Imágenes y archivos adjuntos
| Componente | Versión / detalle |
|------------|-------------------|
| Cámara/galería | `image_picker: ^1.1.2` |
| Explorador archivos | `file_picker: ^10.3.8` |
| Compresión imágenes | `flutter_image_compress: ^2.4.0`, `image: 4.5.4` |
| Caché remota | `cached_network_image: ^3.4.1` |
| Rutas locales | `path_provider: ^2.1.5` |
| Apertura archivos | `open_filex: ^4.7.0` |

## 7. Notificaciones
| Componente | Versión / detalle |
|------------|-------------------|
| Notificaciones locales | `flutter_local_notifications: ^18.0.0` |

## 8. UI, íconos y utilidades de presentación
| Componente | Versión / detalle |
|------------|-------------------|
| SVG | `flutter_svg: ^2.0.10+1` |
| Fechas relativas | `timeago: ^3.6.1` |
| Internacionalización | `intl: ^0.19.0` |
| Skeleton loaders | `shimmer: ^3.0.0` |
| Carrusel | `carousel_slider: ^5.1.1` |
| Indicadores | `smooth_page_indicator: ^2.0.1` |
| Tabs | `buttons_tabbar: ^1.3.15` |
| Íconos Material Symbols | `material_symbols_icons: ^4.2928.1` |

## 9. Utilidades generales
| Componente | Versión / detalle |
|------------|-------------------|
| UUIDs | `uuid: ^4.5.1` |
| Conectividad | `connectivity_plus: ^7.0.0` |
| URLs externas | `url_launcher: ^6.3.2` |
| URL strategy Web | `url_strategy: ^0.3.0` |
| Deep links | `app_links: ^6.4.0` |
| JSON | `json_annotation: ^4.9.0`, `json_serializable: ^6.13.0` |
| Modelos inmutables | `freezed_annotation: ^3.1.0`, `freezed: ^3.2.5` |

## 10. PDF
| Componente | Versión / detalle |
|------------|-------------------|
| Generación PDF | `pdf: ^3.10.8` |
| Impresión/compartir | `printing: ^5.14.2` |

## 11. Tipografía
| Familia | Pesos incluidos |
|---------|-----------------|
| Urbanist | Light, Medium, Regular, SemiBold, Bold |
| Comfortaa | Light, Medium, Regular, SemiBold, Bold |

## 12. Navegación y enrutamiento
| Componente | Detalle |
|------------|---------|
| Rutas declaradas | `AppRoutes` en `lib/07_routes/app_routes.dart` |
| Navegación | `MaterialPageRoute` + `routeGenerate()` |
| Deep links | `initDeepLinkHandler(navigatorKey)` en `main.dart` |
| URL strategy | `setPathUrlStrategy()` en Web |

## 13. Multiplataforma
| Plataforma | Estado / notas |
|------------|----------------|
| Android | Soportado |
| iOS | Soportado |
| Web | Soportado con `google_maps_flutter_web` |
| Windows | Soportado |
| macOS | Soportado |
| Linux | Soportado |

## 14. Calidad de código
| Componente | Versión / detalle |
|------------|-------------------|
| Lints | `flutter_lints: ^5.0.0` |
| Riverpod lint | `riverpod_lint: ^3.0.3` |
| Pruebas | `flutter_test` |

---

## Resumen ejecutivo
Buscobien está construido sobre **Flutter + Material 3**, con **Riverpod** como backbone de estado, **Dio** como capa HTTP hacia **CouchDB**, y soporte nativo a 6 plataformas. Usa almacenamiento seguro diferenciado por plataforma para JWT, Google Maps como proveedor geoespacial, y generación PDF para exportación de propiedades. El flujo Web usa `url_strategy` y `app_links` para deep links.
