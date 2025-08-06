import 'package:flutter/material.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class ErrorPage extends StatelessWidget {
  const ErrorPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Layout(
      title: "Aqua Minds",
      body: Center(
        child: Container(
          margin: EdgeInsets.all(10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            spacing: 10,
            children: [
              Text(
                "404",
                style: Theme.of(context).textTheme.headlineLarge,
              ),
              Text(
                "Página no encontrada",
                style: Theme.of(context).textTheme.displayLarge,
              ),
              Text(
                  "La página que intentas ver no existe o fue movida. Revisa la URL o regresa al panel."),
              ElevatedButton(
                  onPressed: () => context.goNamed(Routes.splash.name),
                  child: Text("Inicio"))
            ],
          ),
        ),
      ),
    );
  }
}
