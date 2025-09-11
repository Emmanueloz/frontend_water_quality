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
            child: const Text("Get Started"),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
// Hero Section
            Container(
              height: 250,
              color: AppTheme.colorScheme.secondary,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Aqua Minds - Smart Water Quality Monitoring",
                      style:
                          Theme.of(context).textTheme.headlineMedium?.copyWith(
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
                          child: const Text("Get Your Device"),
                        ),
                        const SizedBox(width: 10),
                        OutlinedButton(
                          onPressed: () {
                            context.go(Routes.login.path);
                          },
                          style: OutlinedButton.styleFrom(
                            side: const BorderSide(color: Colors.white),
                            foregroundColor: Colors.white,
                          ),
                          child: const Text("See Demo"),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),

// Mission
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "Our Mission",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "At Aqua Minds, we are dedicated to providing innovative solutions for real-time water quality monitoring. Our smart devices help you track, analyze, and maintain the highest standards of water quality for your home, business, or community.",
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textColor,
                        ),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),

// How it works - Mejorado para parecerse más al Figma
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                children: [
                  Text(
                    "How It Works",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
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
                              "Measure",
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
                              "Sensors capture real-time data",
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
                              "Visualize",
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
                              "Data presented in dashboards",
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
                              "Act",
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
                              "Make informed decisions",
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

// Products - Con imágenes
            Padding(
              padding: const EdgeInsets.all(24.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Our Products",
                    style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                  ),
                  const SizedBox(height: 16),
                  Row(
                    children: [
                      Expanded(
                        child: Card(
                          elevation: 4,
                          color: AppTheme.colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image:
                                          AssetImage('assets/images/agua.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Water Quality Meter",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                ),
                                Text(
                                  "Real-time monitoring device",
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
                      ),
                      const SizedBox(width: 24),
                      Expanded(
                        child: Card(
                          elevation: 4,
                          color: AppTheme.colorScheme.surface,
                          child: Padding(
                            padding: const EdgeInsets.all(24.0),
                            child: Column(
                              children: [
                                Container(
                                  height: 200,
                                  decoration: BoxDecoration(
                                    color: AppTheme.colorScheme.tertiary,
                                    borderRadius: BorderRadius.circular(8),
                                    image: const DecorationImage(
                                      image: AssetImage(
                                          'assets/images/meters.png'),
                                      fit: BoxFit.contain,
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 16),
                                Text(
                                  "Web Application",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                ),
                                Text(
                                  "Dashboard and analytics platform",
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
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
