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
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Hero Section
            Container(
              height: 300,
              decoration: BoxDecoration(
                color: AppTheme.colorScheme.secondary,
              ),
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 100,
                      height: 100,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.2),
                        borderRadius: BorderRadius.circular(25),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.2),
                            blurRadius: 25,
                            offset: const Offset(0, 10),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        size: 50,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      "Sobre Nosotros",
                      style: Theme.of(context).textTheme.headlineLarge?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 32,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Innovando en el monitoreo de calidad del agua para un futuro más seguro",
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 18,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
            ),

            // Nuestra Historia
            _buildSection(
              context,
              "Nuestra Historia",
              Icons.history_edu,
              "Aqua Minds nació de la necesidad urgente de democratizar el acceso a información sobre la calidad del agua. "
              "Fundada por un equipo de ingenieros y científicos especializados en tecnologías del agua, nuestra empresa "
              "se estableció con la visión de crear soluciones tecnológicas innovadoras que permitan a las comunidades, "
              "empresas y gobiernos monitorear la calidad del agua de manera precisa y en tiempo real.",
            ),

            // Misión y Visión
            _buildMissionVisionSection(context),

            // Valores
            _buildValuesSection(context),

            // Nuestro Equipo
            _buildTeamSection(context),

            // Call to Action
            _buildCallToActionSection(context),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, String title, IconData icon, String content) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: AppTheme.colorScheme.primary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Expanded(
            child: _buildMissionVisionCard(
              context,
              "Nuestra Misión",
              Icons.flag,
              "Proporcionar soluciones tecnológicas innovadoras y accesibles para el monitoreo de la calidad del agua, "
              "empoderando a las comunidades y organizaciones para tomar decisiones informadas que protejan la salud "
              "pública y el medio ambiente.",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _buildMissionVisionCard(
              context,
              "Nuestra Visión",
              Icons.visibility,
              "Ser líderes globales en tecnología de monitoreo de calidad del agua, contribuyendo a un mundo donde "
              "el acceso a agua limpia y segura sea una realidad para todas las comunidades.",
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMissionVisionCard(BuildContext context, String title, IconData icon, String content) {
    return Container(
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.colorScheme.secondary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.colorScheme.secondary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  icon,
                  color: AppTheme.colorScheme.secondary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Text(
                  title,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    color: AppTheme.colorScheme.secondary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Text(
            content,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
              height: 1.6,
              color: Colors.grey[700],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildValuesSection(BuildContext context) {
    final values = [
      {
        'title': 'Innovación',
        'description': 'Desarrollamos tecnologías de vanguardia para el monitoreo del agua.',
        'icon': Icons.lightbulb,
      },
      {
        'title': 'Calidad',
        'description': 'Mantenemos los más altos estándares en todos nuestros productos y servicios.',
        'icon': Icons.verified,
      },
      {
        'title': 'Sostenibilidad',
        'description': 'Promovemos prácticas responsables con el medio ambiente.',
        'icon': Icons.eco,
      },
      {
        'title': 'Accesibilidad',
        'description': 'Hacemos la tecnología accesible para todas las comunidades.',
        'icon': Icons.accessibility,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.colorScheme.tertiary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.colorScheme.tertiary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.star,
                  color: AppTheme.colorScheme.tertiary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "Nuestros Valores",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildValueItem(context, values[0]),
                    const SizedBox(height: 16),
                    _buildValueItem(context, values[1]),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildValueItem(context, values[2]),
                    const SizedBox(height: 16),
                    _buildValueItem(context, values[3]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildValueItem(BuildContext context, Map<String, dynamic> value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppTheme.colorScheme.tertiary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(
            value['icon'] as IconData,
            color: AppTheme.colorScheme.tertiary,
            size: 20,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                value['title'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.colorScheme.tertiary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                value['description'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                  height: 1.4,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTeamSection(BuildContext context) {
    final teamMembers = [
      {
        'name': 'David Emmanuel Ozuna Navarro',
        'role': 'Ingeniero de Software',
        'icon': Icons.person,
      },
      {
        'name': 'Angel Alfredo Ruiz Lopez',
        'role': 'Especialista en IoT',
        'icon': Icons.engineering,
      },
      {
        'name': 'Raul de Jesus Najera Jimenez',
        'role': 'Analista de Datos',
        'icon': Icons.analytics,
      },
      {
        'name': 'Josue Daniel Sanchez Hernandez',
        'role': 'Diseñador UX/UI',
        'icon': Icons.design_services,
      },
    ];

    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(24.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withValues(alpha: 0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
        border: Border.all(
          color: AppTheme.colorScheme.primary.withValues(alpha: 0.1),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: AppTheme.colorScheme.primary.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  Icons.people,
                  color: AppTheme.colorScheme.primary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 16),
              Text(
                "Nuestro Equipo",
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: AppTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              Expanded(
                child: Column(
                  children: [
                    _buildTeamMember(context, teamMembers[0]),
                    const SizedBox(height: 16),
                    _buildTeamMember(context, teamMembers[1]),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  children: [
                    _buildTeamMember(context, teamMembers[2]),
                    const SizedBox(height: 16),
                    _buildTeamMember(context, teamMembers[3]),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(BuildContext context, Map<String, dynamic> member) {
    return Row(
      children: [
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppTheme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25),
          ),
          child: Icon(
            member['icon'] as IconData,
            color: AppTheme.colorScheme.primary,
            size: 24,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                member['name'] as String,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: AppTheme.colorScheme.primary,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                member['role'] as String,
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildCallToActionSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(16.0),
      padding: const EdgeInsets.all(32),
      decoration: BoxDecoration(
        color: AppTheme.colorScheme.primary,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppTheme.colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(
            Icons.rocket_launch,
            size: 48,
            color: Colors.white,
          ),
          const SizedBox(height: 20),
          Text(
            "¿Listo para comenzar?",
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 12),
          Text(
            "Únete a nosotros en la revolución del monitoreo de calidad del agua",
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              color: Colors.white.withValues(alpha: 0.9),
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: () => context.go(Routes.login.path),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: AppTheme.colorScheme.primary,
              padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(25),
              ),
            ),
            child: const Text(
              "Comenzar Ahora",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
