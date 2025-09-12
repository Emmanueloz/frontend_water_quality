import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sobre Nosotros', style: TextStyle(color: Colors.white)),
        backgroundColor: AppTheme.colorScheme.secondary,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => context.go("/"),
        ),
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
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Sobre Nosotros - Aqua Minds",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Innovando en el monitoreo de calidad del agua para un futuro más seguro",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),

                // Nuestra Historia
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nuestra Historia",
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: AppTheme.textColor,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Aqua Minds nació de la necesidad urgente de democratizar el acceso a información sobre la calidad del agua. "
                        "Fundada por un equipo de ingenieros y científicos especializados en tecnologías del agua, nuestra empresa "
                        "se estableció con la visión de crear soluciones tecnológicas innovadoras que permitan a las comunidades, "
                        "empresas y gobiernos monitorear la calidad del agua de manera precisa y en tiempo real.",
                        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                          color: AppTheme.textColor,
                        ),
                      ),
                    ],
                  ),
                ),

                // Nuestros Valores
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nuestros Valores",
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
                                    Icons.lightbulb,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Innovación",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Desarrollamos tecnologías de vanguardia",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textColor.withValues(alpha: 0.7),
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
                                    Icons.verified,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Calidad",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Mantenemos los más altos estándares",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textColor.withValues(alpha: 0.7),
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
                                    Icons.eco,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Sostenibilidad",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Promovemos prácticas responsables",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textColor.withValues(alpha: 0.7),
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
                                    Icons.accessibility,
                                    size: 30,
                                    color: AppTheme.colorScheme.secondary,
                                  ),
                                ),
                                const SizedBox(height: 12),
                                Text(
                                  "Accesibilidad",
                                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                    fontWeight: FontWeight.bold,
                                    color: AppTheme.textColor,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  "Hacemos la tecnología accesible",
                                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: AppTheme.textColor.withValues(alpha: 0.7),
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

                // Nuestro Equipo
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nuestro Equipo",
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
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.colorScheme.tertiary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.person,
                                        size: 40,
                                        color: AppTheme.colorScheme.secondary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "David Emmanuel Ozuna Navarro",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Ingeniero de Software",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textColor.withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              elevation: 4,
                              color: AppTheme.colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.colorScheme.tertiary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.engineering,
                                        size: 40,
                                        color: AppTheme.colorScheme.secondary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Angel Alfredo Ruiz Lopez",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Especialista en IoT",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textColor.withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
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
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.colorScheme.tertiary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.analytics,
                                        size: 40,
                                        color: AppTheme.colorScheme.secondary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Raul de Jesus Najera Jimenez",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Analista de Datos",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textColor.withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Card(
                              elevation: 4,
                              color: AppTheme.colorScheme.surface,
                              child: Padding(
                                padding: const EdgeInsets.all(24.0),
                                child: Column(
                                  children: [
                                    Container(
                                      width: 80,
                                      height: 80,
                                      decoration: BoxDecoration(
                                        color: AppTheme.colorScheme.tertiary,
                                        shape: BoxShape.circle,
                                      ),
                                      child: Icon(
                                        Icons.design_services,
                                        size: 40,
                                        color: AppTheme.colorScheme.secondary,
                                      ),
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      "Josue Daniel Sanchez Hernandez",
                                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                                        fontWeight: FontWeight.bold,
                                        color: AppTheme.textColor,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Diseñador UX/UI",
                                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                        color: AppTheme.textColor.withValues(alpha: 0.7),
                                      ),
                                      textAlign: TextAlign.center,
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

                // Call to Action
                Container(
                  height: 200,
                  margin: EdgeInsets.only(bottom: 10),
                  decoration: BoxDecoration(
                    color: AppTheme.colorScheme.primary,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "¿Listo para comenzar?",
                          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 10),
                        Text(
                          "Únete a nosotros en la revolución del monitoreo de calidad del agua",
                          style: Theme.of(context).textTheme.titleMedium?.copyWith(
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
