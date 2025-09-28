# DateRangeFilter Widget

Un widget personalizado para filtrar datos por rango de fechas, diseñado específicamente para el proyecto de calidad del agua.

## Características

- **Campos de fecha**: Fecha de inicio y fecha de fin con formato MM/dd/yyyy
- **Date picker integrado**: Selector de fechas nativo con tema personalizado
- **Botones de navegación**: Navegación rápida entre períodos
- **Botón de aplicar filtros**: Aplicar los filtros seleccionados
- **Diseño responsive**: Se adapta a móvil y desktop
- **Estilos consistentes**: Usa los colores y estilos del proyecto

## Uso Básico

```dart
import 'package:frontend_water_quality/presentation/widgets/common/molecules/date_range_filter.dart';

DateRangeFilter(
  startDate: _startDate,
  endDate: _endDate,
  isLoading: _isLoading,
  onApplyFilters: (startDate, endDate) {
    // Manejar la aplicación de filtros
    setState(() {
      _startDate = startDate;
      _endDate = endDate;
    });
  },
  onPreviousPeriod: () {
    // Navegar al período anterior
  },
  onNextPeriod: () {
    // Navegar al período siguiente
  },
)
```

## Parámetros

| Parámetro | Tipo | Descripción |
|-----------|------|-------------|
| `startDate` | `DateTime?` | Fecha de inicio del filtro |
| `endDate` | `DateTime?` | Fecha de fin del filtro |
| `onApplyFilters` | `Function(DateTime?, DateTime?)?` | Callback cuando se aplican los filtros |
| `onPreviousPeriod` | `VoidCallback?` | Callback para navegar al período anterior |
| `onNextPeriod` | `VoidCallback?` | Callback para navegar al período siguiente |
| `isLoading` | `bool` | Indica si está cargando (desactiva el botón) |

## Ejemplo Completo

```dart
class MyPage extends StatefulWidget {
  @override
  _MyPageState createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  DateTime? _startDate;
  DateTime? _endDate;
  bool _isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        DateRangeFilter(
          startDate: _startDate,
          endDate: _endDate,
          isLoading: _isLoading,
          onApplyFilters: (startDate, endDate) {
            setState(() {
              _isLoading = true;
              _startDate = startDate;
              _endDate = endDate;
            });
            
            // Simular carga de datos
            Future.delayed(Duration(seconds: 1), () {
              if (mounted) {
                setState(() {
                  _isLoading = false;
                });
              }
            });
          },
          onPreviousPeriod: () {
            _navigatePeriod(-1);
          },
          onNextPeriod: () {
            _navigatePeriod(1);
          },
        ),
        // Tu contenido aquí
      ],
    );
  }

  void _navigatePeriod(int direction) {
    if (_startDate != null && _endDate != null) {
      final duration = _endDate!.difference(_startDate!);
      setState(() {
        _startDate = _startDate!.add(Duration(days: duration.inDays * direction));
        _endDate = _endDate!.add(Duration(days: duration.inDays * direction));
      });
    }
  }
}
```

## Demo

Para ver el widget en acción, navega a `/date-filter-demo` en la aplicación.

## Estilos

El widget utiliza los siguientes colores del tema del proyecto:

- **Color primario**: `#5accc4` (teal claro)
- **Color secundario**: `#145c57` (teal oscuro)
- **Color de superficie**: `#f7fafa` (gris muy claro)
- **Color de texto**: `#004E49` (verde oscuro)

## Responsive Design

- **Móvil**: Layout vertical con campos apilados
- **Desktop**: Layout horizontal con campos lado a lado
