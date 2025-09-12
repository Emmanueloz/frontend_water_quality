import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class Information extends StatelessWidget {
  const Information({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Aqua Minds', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.colorScheme.secondary,
        foregroundColor: Colors.white,
        actions: [
          TextButton(
              onPressed: () {
                context.go(Routes.aboutUs.path);
              },
              child: const Text("Sobre nosotros",
                  style: TextStyle(color: Colors.white))),
          ElevatedButton(
            onPressed: () {
              context.go(Routes.login.path);
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.colorScheme.secondary,
            ),
            child: const Text("Iniciar"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Align(
          alignment: Alignment.topCenter,
          child: Container(
            constraints: BoxConstraints(maxWidth: 1024),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              spacing: 24,
              children: [
                // Hero Section
                Container(
                  height: 250,
                  margin: EdgeInsets.only(top: 10),
                  decoration: BoxDecoration(
                      color: AppTheme.colorScheme.secondary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Aqua Minds - Monitoreo inteligente de la calidad del agua",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () {
                                context.go(Routes.login.path);
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: AppTheme.colorScheme.secondary,
                              ),
                              child: const Text("Iniciar"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

                // Mission
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Visión",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Ser reconocidos como líderes en la creación de soluciones tecnológicas transformadoras que conviertan desafíos en oportunidades de desarrollo. Aspiramos a inspirar la toma de decisiones basada en datos y a generar un impacto sostenible en la sociedad, adaptándonos a las necesidades de nuestros usuarios. Para lograrlo, cultivamos un equipo de profesionales apasionados, creativos y comprometidos con la innovación y el bienestar social.",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      child: Column(
                        children: [
                          Text(
                            "Misión",
                            style: Theme.of(context)
                                .textTheme
                                .headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "Desarrollar soluciones tecnológicas accesibles e innovadoras que faciliten el análisis y la resolución de desafíos sociales. Mediante el diseño de software, servicios digitales y el aprovechamiento de tecnologías emergentes, buscamos empoderar a las comunidades y promover el cambio social positivo. Nos comprometemos a colaborar con entidades públicas y privadas, ofreciendo soluciones personalizadas y efectivas que respondan a las necesidades de un mundo en constante evolución.",
                            style:
                                Theme.of(context).textTheme.bodyLarge?.copyWith(
                                      color: AppTheme.textColor,
                                    ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                // How it works - Mejorado para parecerse más al Figma
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    children: [
                      Text(
                        "Como trabajamos",
                        style:
                            Theme.of(context).textTheme.headlineSmall?.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: AppTheme.textColor,
                                ),
                      ),
                      const SizedBox(height: 16),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.tertiary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.analytics,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Mediciones",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Sensores captura datos en tiempo real",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textColor
                                            .withValues(alpha: 0.7),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.tertiary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.visibility,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Visualization",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Datos presentados en dashboards",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textColor
                                            .withValues(alpha: 0.7),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Column(
                              children: [
                                Container(
                                  width: 60,
                                  height: 60,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.tertiary,
                                    shape: BoxShape.circle,
                                  ),
                                  child: Icon(
                                    Icons.trending_up,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Acciones",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Toma de decisiones",
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodySmall
                                      ?.copyWith(
                                        color: AppTheme.textColor
                                            .withValues(alpha: 0.7),
                                      ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                Text(
                  "Nuestros productos",
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: AppTheme.textColor,
                      ),
                ),
                Row(
                  children: [
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: AppTheme.colorScheme.surface,
                        child: Column(
                          spacing: 10,
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image: AssetImage('assets/images/meter.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            Text(
                              "Medidor de calidad de agua",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                            ),
                            Text(
                              "Dispositivo  de medición en tiempo real",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textColor
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Card(
                        elevation: 4,
                        color: AppTheme.colorScheme.surface,
                        child: Column(
                          children: [
                            Container(
                              height: 200,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(8),
                                image: const DecorationImage(
                                  image:
                                      AssetImage('assets/images/web_app.png'),
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),
                            const SizedBox(height: 16),
                            Text(
                              "Aplicaciones web",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                            ),
                            Text(
                              "Plataforma de Dashboard y analysis",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall
                                  ?.copyWith(
                                    color: AppTheme.textColor
                                        .withValues(alpha: 0.7),
                                  ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                // Call to Action
                Container(
                  height: 200,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                      color: AppTheme.colorScheme.primary,
                      borderRadius: BorderRadius.circular(10)),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Listo para comenzar?",
                          style: Theme.of(context)
                              .textTheme
                              .headlineMedium
                              ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Únete a nosotros en la revolución del monitoreo de calidad del agua",
                          style:
                              Theme.of(context).textTheme.titleMedium?.copyWith(
                                    color: Colors.white.withValues(alpha: 0.9),
                                  ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () => context.go(Routes.login.path),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            foregroundColor: AppTheme.colorScheme.primary,
                          ),
                          child: const Text("Comenzar Ahora"),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
