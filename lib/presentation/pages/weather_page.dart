import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/responsive_screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/weather/molecules/weather_detail_card.dart';
import 'package:provider/provider.dart';
import 'package:frontend_water_quality/presentation/providers/weather_meter_provider.dart';

class WeatherPage extends StatefulWidget {
  final String id;
  final String idMeter;
  const WeatherPage({super.key, required this.id, required this.idMeter});

  @override
  State<WeatherPage> createState() => _WeatherPageState();
}

class _WeatherPageState extends State<WeatherPage> {
  WeatherMeterProvider? _weatherProvider;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _weatherProvider = Provider.of<WeatherMeterProvider>(context, listen: false);
  }

  @override
  void initState() {
    super.initState();
    // Cargar datos del clima cuando se inicializa la página
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_weatherProvider != null) {
        _weatherProvider!.fetchWeather(widget.id, "-OVnW46EjvIYWdpO8zPz");
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = ResponsiveScreenSize.getScreenSize(context);

    return Consumer<WeatherMeterProvider>(
      builder: (context, weatherProvider, _) {
        if (weatherProvider.isLoading) {
          return const Center(child: CircularProgressIndicator());
        }

        if (weatherProvider.errorMessage != null) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  'Error al cargar el clima',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(weatherProvider.errorMessage!),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () => weatherProvider.fetchWeather(widget.id, widget.idMeter),
                  child: const Text('Reintentar'),
                ),
              ],
            ),
          );
        }

        final weather = weatherProvider.weatherMeter;
        if (weather == null) {
          return const Center(child: Text('No hay datos del clima disponibles'));
        }

        return _buildMain(context, screenSize, weather);
      },
    );
  }

  Widget _buildMain(BuildContext context, ScreenSize screenSize, weather) {
    EdgeInsetsGeometry margin = EdgeInsets.zero;
    int crossAxisCount = 1;

    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      margin = const EdgeInsets.all(10);
    }

    if (screenSize == ScreenSize.tablet) {
      crossAxisCount = 2;
    } else if (screenSize == ScreenSize.smallDesktop) {
      crossAxisCount = 3;
    } else if (screenSize == ScreenSize.largeDesktop) {
      crossAxisCount = 4;
    }

    return BaseContainer(
      width: double.infinity,
      margin: margin,
      padding: const EdgeInsets.all(10),
      child: Column(
        spacing: 10,
        children: [
          Column(
            children: [
              Text(
                weather.location.name,
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text("${weather.location.region}, ${weather.location.country}"),
              Text(weather.current.lastUpdated)
            ],
          ),
          Wrap(
            alignment: WrapAlignment.center,
            spacing: 20,
            children: [
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "${weather.current.tempC}°C",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    weather.current.condition.text,
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Sensación térmica: ${weather.current.feelslikeC}°C",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
              Image.network(
                "https:${weather.current.condition.icon}",
                width: 100,
                height: 100,
                errorBuilder: (context, error, stackTrace) {
                  return const Icon(
                    Icons.image_not_supported,
                  );
                },
              ),
            ],
          ),
          Expanded(
            child: GridView.count(
              crossAxisCount: crossAxisCount,
              crossAxisSpacing: 10,
              mainAxisSpacing: 10,
              childAspectRatio: 1 / .5,
              shrinkWrap: true,
              children: [
                WeatherDetailCard(
                  label: "Humedad",
                  value: weather.current.humidity.toString(),
                  unit: "%",
                ),
                WeatherDetailCard(
                  label: "Viento",
                  value: weather.current.windKph.toString(),
                  unit: "km/h",
                ),
                WeatherDetailCard(
                  label: "Presión",
                  value: weather.current.pressureMb.toString(),
                  unit: "mb",
                ),
                WeatherDetailCard(
                  label: "Visibilidad",
                  value: weather.current.visKm.toString(),
                  unit: "km",
                ),
                WeatherDetailCard(
                  label: "Nubosidad",
                  value: weather.current.cloud.toString(),
                  unit: "%",
                ),
                WeatherDetailCard(
                  label: "Precipitación",
                  value: weather.current.precipMm.toString(),
                  unit: "mm",
                ),
                WeatherDetailCard(
                  label: "Punto de rocío",
                  value: weather.current.feelslikeC.toString(),
                  unit: "°C",
                ),
                WeatherDetailCard(
                  label: "Índice UV",
                  value: weather.current.uv.toString(),
                  unit: "",
                ),
                WeatherDetailCard(
                  label: "Ráfagas de viento",
                  value: weather.current.windKph.toString(),
                  unit: "km/h",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
