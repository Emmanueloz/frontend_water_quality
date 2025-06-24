import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout_meters.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/weather/molecules/weather_detail_card.dart';

class WeatherPage extends StatelessWidget {
  final String id;
  final String idMeter;
  const WeatherPage({super.key, required this.id, required this.idMeter});

  @override
  Widget build(BuildContext context) {
    return LayoutMeters(
      title: "Clima del medidor",
      id: id,
      idMeter: idMeter,
      selectedIndex: 5,
      builder: (context, screenSize) {
        if (screenSize == ScreenSize.smallDesktop ||
            screenSize == ScreenSize.largeDesktop) {
          return Expanded(child: _buildMain(context, screenSize));
        }
        return _buildMain(context, screenSize);
      },
    );
  }

  Widget _buildMain(BuildContext context, ScreenSize screenSize) {
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
                "Lequilum",
                style: Theme.of(context)
                    .textTheme
                    .displayLarge
                    ?.copyWith(fontWeight: FontWeight.bold),
              ),
              Text("Chiapas, México"),
              Text("2025-06-23 22:05")
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
                    "15.5°C",
                    style: Theme.of(context)
                        .textTheme
                        .displayMedium
                        ?.copyWith(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    "Patchy rain nearby",
                    style: Theme.of(context).textTheme.bodyLarge,
                  ),
                  Text(
                    "Sensación térmica: 16.0°C",
                    style: Theme.of(context).textTheme.bodyMedium,
                  )
                ],
              ),
              Image.network(
                "https://cdn.weatherapi.com/weather/64x64/night/176.png",
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
              physics: const NeverScrollableScrollPhysics(),
              children: [
                WeatherDetailCard(
                  label: "Humedad",
                  value: "60",
                  unit: "%",
                ),
                WeatherDetailCard(
                  label: "Viento",
                  value: "3.6",
                  unit: "km/h",
                ),
                WeatherDetailCard(
                  label: "Presión",
                  value: "1019.0",
                  unit: "mb",
                ),
                WeatherDetailCard(
                  label: "Visibilidad",
                  value: "10.0",
                  unit: "km",
                ),
                WeatherDetailCard(
                  label: "Nubosidad",
                  value: "72",
                  unit: "%",
                ),
                WeatherDetailCard(
                  label: "Precipitación",
                  value: "0.05",
                  unit: "mm",
                ),
                WeatherDetailCard(
                  label: "Punto de rocío",
                  value: "14.6",
                  unit: "°C",
                ),
                WeatherDetailCard(
                  label: "Índice UV",
                  value: "0",
                  unit: "",
                ),
                WeatherDetailCard(
                  label: "Ráfagas de viento",
                  value: "6.0",
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
