import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/theme/theme.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/theme_toggle_button.dart';

class AboutUsPage extends StatefulWidget {
  const AboutUsPage({super.key});

  @override
  State<AboutUsPage> createState() => _AboutUsPageState();
}

class _AboutUsPageState extends State<AboutUsPage> {
  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);
    return Scaffold(
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeader(),
            // Hero Section
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 650),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? theme.colorScheme.surface.withValues(alpha: 0.4)
                    : theme.colorScheme.primary.withValues(alpha: 0.1),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "Sobre Nosotros - Aqua Minds",
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Innovando en el monitoreo de calidad del agua para un futuro más seguro",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Nuestra Historia
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 550),
              color: theme.scaffoldBackgroundColor,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        "Nuestra Historia",
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 40),
                      _HistoryCard(
                        description:
                            "Aqua Minds nació de la necesidad urgente de democratizar el acceso a información sobre la calidad del agua. "
                            "Fundada por un equipo de ingenieros y científicos especializados en tecnologías del agua, nuestra empresa "
                            "se estableció con la visión de crear soluciones tecnológicas innovadoras que permitan a las comunidades, "
                            "empresas y gobiernos monitorear la calidad del agua de manera precisa y en tiempo real.",
                        isDarkMode: isDarkMode,
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Nuestros Valores
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 650),
              decoration: BoxDecoration(
                color: (isDarkMode
                        ? const Color(0xFF66C2C2)
                        : const Color(0xFF306B6B))
                    .withValues(alpha: 0.1),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nuestros Valores",
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        spacing: 16,
                        children: [
                          Expanded(
                            child: _ValueCard(
                              icon: Icons.lightbulb,
                              title: "Innovación",
                              description:
                                  "Desarrollamos tecnologías de vanguardia",
                            ),
                          ),
                          Expanded(
                            child: _ValueCard(
                              icon: Icons.verified,
                              title: "Calidad",
                              description:
                                  "Mantenemos los más altos estándares",
                            ),
                          ),
                          Expanded(
                            child: _ValueCard(
                              icon: Icons.eco,
                              title: "Sostenibilidad",
                              description: "Promovemos prácticas responsables",
                            ),
                          ),
                          Expanded(
                            child: _ValueCard(
                              icon: Icons.accessibility,
                              title: "Accesibilidad",
                              description: "Hacemos la tecnología accesible",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Nuestro Equipo
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 750),
              color: theme.scaffoldBackgroundColor,
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Nuestro Equipo",
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                        ),
                      ),
                      const SizedBox(height: 40),
                      Row(
                        children: [
                          Expanded(
                            child: _TeamCard(
                              icon: Icons.person,
                              name: "David Emmanuel Ozuna Navarro",
                              role: "Ingeniero de Software",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _TeamCard(
                              icon: Icons.engineering,
                              name: "Angel Alfredo Ruiz Lopez",
                              role: "Especialista en IoT",
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: _TeamCard(
                              icon: Icons.analytics,
                              name: "Raul de Jesus Najera Jimenez",
                              role: "Analista de Datos",
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: _TeamCard(
                              icon: Icons.design_services,
                              name: "Josue Daniel Sanchez Hernandez",
                              role: "Diseñador UX/UI",
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),

            // Call to Action
            Container(
              width: double.infinity,
              constraints: const BoxConstraints(minHeight: 650),
              decoration: BoxDecoration(
                color: isDarkMode
                    ? const Color(0xFF001a24).withValues(alpha: 0.4)
                    : const Color(0xFF306B6B).withValues(alpha: 0.05),
              ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 1200),
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 120),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "¿Listo para comenzar?",
                        style: theme.textTheme.displayLarge?.copyWith(
                          color: theme.colorScheme.primary,
                          fontWeight: FontWeight.bold,
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        "Únete a nosotros en la revolución del monitoreo de calidad del agua",
                        style: theme.textTheme.titleLarge?.copyWith(
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 32),
                      ElevatedButton(
                        onPressed: () => context.go(Routes.login.path),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: theme.colorScheme.tertiary,
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 32,
                            vertical: 16,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(50),
                          ),
                        ),
                        child: Text(
                          "Comenzar Ahora",
                          style: theme.textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Align(
      alignment: Alignment.center,
      child: Container(
        constraints: const BoxConstraints(maxWidth: 1200),
        margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const _LogoHeader(),
            Row(
              children: [
                const ThemeToggleButton(),
                const SizedBox(width: 16),
                TextButton(
                  onPressed: () => context.go("/"),
                  child: Text(
                    'Principal',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                const SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () => context.go(Routes.login.path),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.tertiary,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 24, vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(50),
                    ),
                  ),
                  child: Text('Iniciar',
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      )),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _HistoryCard extends StatefulWidget {
  final String description;
  final bool isDarkMode;

  const _HistoryCard({
    required this.description,
    required this.isDarkMode,
  });

  @override
  State<_HistoryCard> createState() => _HistoryCardState();
}

class _HistoryCardState extends State<_HistoryCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.02 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? theme.colorScheme.surface.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.8),
            border: Border.all(
              color: theme.colorScheme.primary
                  .withValues(alpha: widget.isDarkMode ? 0.2 : 0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(24),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Text(
            widget.description,
            style: theme.textTheme.bodyLarge?.copyWith(
              color: widget.isDarkMode ? Colors.grey[300] : Colors.grey[600],
              height: 1.8,
              fontSize: 18,
            ),
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}

class _ValueCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;

  const _ValueCard({
    required this.icon,
    required this.title,
    required this.description,
  });

  @override
  State<_ValueCard> createState() => _ValueCardState();
}

class _ValueCardState extends State<_ValueCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          height: 220,
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: isDarkMode
                ? theme.colorScheme.surface.withValues(alpha: 0.4)
                : Colors.white.withValues(alpha: 0.8),
            border: Border.all(
              color: theme.colorScheme.primary
                  .withValues(alpha: isDarkMode ? 0.2 : 0.1),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(16),
            boxShadow: isHovered
                ? [
                    BoxShadow(
                      color: theme.colorScheme.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ]
                : [],
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 60,
                height: 60,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
                  shape: BoxShape.circle,
                ),
                child: Icon(
                  widget.icon,
                  size: 30,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                widget.title,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 4),
              Flexible(
                child: Text(
                  widget.description,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDarkMode ? Colors.grey[400] : Colors.grey[600],
                  ),
                  textAlign: TextAlign.center,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TeamCard extends StatefulWidget {
  final IconData icon;
  final String name;
  final String role;

  const _TeamCard({
    required this.icon,
    required this.name,
    required this.role,
  });

  @override
  State<_TeamCard> createState() => _TeamCardState();
}

class _TeamCardState extends State<_TeamCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: isHovered ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
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
                    widget.icon,
                    size: 40,
                    color: AppTheme.colorScheme.secondary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  widget.name,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: AppTheme.textColor,
                  ),
                  textAlign: TextAlign.center,
                ),
                Text(
                  widget.role,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppTheme.textColor.withValues(alpha: 0.7),
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _LogoHeader extends StatefulWidget {
  const _LogoHeader();

  @override
  State<_LogoHeader> createState() => _LogoHeaderState();
}

class _LogoHeaderState extends State<_LogoHeader> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: GestureDetector(
        onTap: () => context.go("/"),
        child: AnimatedScale(
          scale: isHovered ? 1.05 : 1.0,
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          child: Row(
            children: [
              Image.asset(
                'assets/images/logo_aquaminds.png',
                height: 90,
              ),
              const SizedBox(width: 12),
              Text(
                'Aqua Minds',
                style: theme.textTheme.displaySmall?.copyWith(
                  color: theme.colorScheme.primary,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
