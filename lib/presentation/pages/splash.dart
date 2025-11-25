import 'dart:math';
import 'package:flutter/material.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/services.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/theme_toggle_button.dart';

// Modelo de datos para los pasos del workflow
class WorkflowStep {
  final String title;
  final String image;
  final String description;

  const WorkflowStep({
    required this.title,
    required this.image,
    required this.description,
  });
}

// Datos del workflow
final List<WorkflowStep> workflowData = [
  const WorkflowStep(
    title: "Registro y Autenticación",
    image:
        "https://images.unsplash.com/photo-1504868584819-f8e8b4b6d7e3?w=800&h=600&fit=crop",
    description:
        "El usuario crea una cuenta personal mediante correo electrónico y contraseña para acceder a la plataforma de monitoreo.",
  ),
  const WorkflowStep(
    title: "Creación de Espacio de Trabajo",
    image:
        "https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&h=600&fit=crop",
    description:
        "Cada usuario crea un espacio de trabajo que representa un proyecto o zona de monitoreo, con diferentes niveles de acceso disponibles.",
  ),
  const WorkflowStep(
    title: "Configuración de Medidores",
    image:
        "https://images.unsplash.com/photo-1581091226825-a6a2a5aee158?w=800&h=600&fit=crop",
    description:
        "Se agregan y configuran medidores con sensores para medir pH, turbidez, temperatura, conductividad y otros parámetros ambientales del agua.",
  ),
  const WorkflowStep(
    title: "Transmisión de Datos",
    image:
        "https://images.unsplash.com/photo-1558494949-ef010cbdcc31?w=800&h=600&fit=crop",
    description:
        "Los dispositivos envían mediciones hacia el servidor en tiempo real, procesando y almacenando los datos de calidad del agua.",
  ),
  const WorkflowStep(
    title: "Visualización de Datos",
    image:
        "https://images.unsplash.com/photo-1551288049-bebda4e38f71?w=800&h=600&fit=crop",
    description:
        "Los usuarios visualizan gráficos interactivos y tablas con mediciones actuales e historial, disponibles en temas claro y oscuro.",
  ),
  const WorkflowStep(
    title: "Gestión de Alertas",
    image:
        "https://images.unsplash.com/photo-1614680376573-df3480f0c6ff?w=800&h=600&fit=crop",
    description:
        "El sistema genera alertas automáticas cuando los valores de calidad del agua superan los rangos seguros configurados, enviando notificaciones instantáneas.",
  ),
  const WorkflowStep(
    title: "Reportes y Exportación",
    image:
        "https://images.unsplash.com/photo-1554224155-6726b3ff858f?w=800&h=600&fit=crop",
    description:
        "Generación de reportes profesionales con gráficas, análisis estadísticos y promedios por periodo para descarga, compartir o presentación.",
  ),
];

class Splash extends StatefulWidget {
  const Splash({super.key});

  @override
  State<Splash> createState() => _SplashState();
}

class _SplashState extends State<Splash> with TickerProviderStateMixin {
  static const MethodChannel _channel = MethodChannel('aquaminds/deeplink');
  bool isDarkMode = false;
  int selectedWorkflowStep = 0;
  late AnimationController _waveController;
  late AnimationController _floatController;

  @override
  void initState() {
    super.initState();
    _setupDeepLinkHandling();

    _waveController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 15),
    )..repeat();

    _floatController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 8),
    )..repeat(reverse: true);
  }

  Future<void> _setupDeepLinkHandling() async {
    void handleUriString(String? uriString) {
      if (uriString == null || uriString.isEmpty) return;
      final uri = Uri.tryParse(uriString);
      if (uri == null) return;
      if (uri.scheme == 'aquaminds' &&
          (uri.host == 'login-success' || uri.path == '/login-success')) {
        final query = uri.query;
        if (!mounted) return;
        final target = query.isNotEmpty
            ? '${Routes.authCallback.path}?$query'
            : Routes.authCallback.path;
        context.go(target);
      }
    }

    try {
      final initial = await _channel.invokeMethod<String>('getInitialLink');
      handleUriString(initial);
    } catch (_) {}

    _channel.setMethodCallHandler((call) async {
      if (call.method == 'onDeepLink') {
        final uriString = call.arguments as String?;
        handleUriString(uriString);
      }
    });
  }

  @override
  void dispose() {
    _waveController.dispose();
    _floatController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    isDarkMode = brightness == Brightness.dark;
    final isDesktop = MediaQuery.of(context).size.width >= 900;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(kToolbarHeight),
        child: _buildAppBar(context, isDesktop),
      ),
      endDrawer: !isDesktop ? _buildDrawer(context) : null,
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildHeroSection(),
            _buildSectionDivider(),
            _buildPillarsSection(),
            _buildWorkflowSection(),
            _buildSectionDivider(),
            _buildMissionVisionSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildAppBar(BuildContext context, bool isDesktop) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return AppBar(
      backgroundColor: theme.scaffoldBackgroundColor,
      elevation: 0,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo_aquaminds.png',
            height: 50,
          ),
          const SizedBox(width: 12),
          Text(
            'Aqua Minds',
            style: theme.textTheme.titleLarge?.copyWith(
              color: isDark ? Colors.white : theme.colorScheme.primary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      actions: isDesktop
          ? [
              const ThemeToggleButton(),
              const SizedBox(width: 16),
              TextButton(
                onPressed: () => context.go(Routes.aboutUs.path),
                child: Text(
                  'Sobre Nosotros',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark ? Colors.white : theme.colorScheme.primary,
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
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                child: Text(
                  'Iniciar',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
            ]
          : null,
    );
  }

  Widget _buildDrawer(BuildContext context) {
    final theme = Theme.of(context);
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: BoxDecoration(
              color: theme.colorScheme.primary,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset(
                  'assets/images/logo_aquaminds.png',
                  height: 60,
                ),
                const SizedBox(height: 8),
                Text(
                  'Aqua Minds',
                  style: theme.textTheme.titleLarge?.copyWith(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ListTile(
            leading: Icon(Icons.info, color: theme.colorScheme.primary),
            title: const Text('Sobre Nosotros'),
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.aboutUs.path);
            },
          ),
          ListTile(
            leading: Icon(Icons.login, color: theme.colorScheme.primary),
            title: const Text('Iniciar'),
            onTap: () {
              Navigator.pop(context);
              context.go(Routes.login.path);
            },
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Text(
                  'Tema',
                  style: theme.textTheme.bodyMedium,
                ),
                const Spacer(),
                const ThemeToggleButton(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeroSection() {
    return Container(
      constraints: const BoxConstraints(minHeight: 400),
      child: Stack(
        children: [
          // Water waves background
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _waveController,
              builder: (context, child) {
                return CustomPaint(
                  painter: WaterWavesPainter(
                    animation: _waveController.value,
                    isDarkMode: isDarkMode,
                  ),
                );
              },
            ),
          ),
          // Floating elements
          Positioned(
            top: 90,
            left: 60,
            child: AnimatedBuilder(
              animation: _floatController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, -20 * _floatController.value),
                  child: Transform.rotate(
                    angle: 0.1 * _floatController.value,
                    child: Container(
                      width: 60,
                      height: 60,
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? const Color(0xFF66C2C2).withValues(alpha: 0.3)
                            : const Color(0xFF306B6B).withValues(alpha: 0.3),
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          // Hero content
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 1000),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1000),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Aqua Minds',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.headlineLarge?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.primary,
                                  height: 1.1,
                                ),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1200),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Monitoreo Inteligente de la Calidad del Agua',
                        textAlign: TextAlign.center,
                        style:
                            Theme.of(context).textTheme.displayMedium?.copyWith(
                                  color: isDarkMode
                                      ? Colors.white
                                      : Theme.of(context).colorScheme.primary,
                                ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1400),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: Text(
                        'Soluciones tecnológicas innovadoras para resolver desafíos ambientales y sociales mediante monitoreo inteligente del agua',
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              color:
                                  isDarkMode ? Colors.white : Colors.grey[600],
                              height: 1.6,
                            ),
                      ),
                    ),
                    const SizedBox(height: 48),
                    TweenAnimationBuilder(
                      duration: const Duration(milliseconds: 1600),
                      tween: Tween<double>(begin: 0, end: 1),
                      builder: (context, double value, child) {
                        return Opacity(
                          opacity: value,
                          child: Transform.translate(
                            offset: Offset(0, 30 * (1 - value)),
                            child: child,
                          ),
                        );
                      },
                      child: ElevatedButton(
                        onPressed: () => context.go(Routes.login.path),
                        style: ElevatedButton.styleFrom(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 48, vertical: 20),
                          backgroundColor:
                              Theme.of(context).colorScheme.tertiary,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(50)),
                          elevation: 8,
                          shadowColor: isDarkMode
                              ? const Color(0xFF66C2C2).withValues(alpha: 0.4)
                              : const Color(0xFF66BB6A).withValues(alpha: 0.4),
                        ),
                        child: Text(
                          'Comenzar Monitoreo',
                          style:
                              Theme.of(context).textTheme.bodyLarge?.copyWith(
                                    fontWeight: FontWeight.w600,
                                  ),
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
    );
  }

  Widget _buildPillarsSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: (isDarkMode ? const Color(0xFF66C2C2) : const Color(0xFF306B6B))
            .withValues(alpha: 0.1),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            children: [
              Text(
                'Nuestros Tres Pilares Fundamentales',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: isDarkMode
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                            child: _buildPillarCard(
                                'Medidores',
                                'Captura de datos de calidad del agua en tiempo real mediante sensores avanzados',
                                Icons.sensors)),
                        const SizedBox(width: 40),
                        Expanded(
                            child: _buildPillarCard(
                                'Visualización',
                                'Presentación de datos en dashboards intuitivos y fáciles de interpretar',
                                Icons.analytics)),
                        const SizedBox(width: 40),
                        Expanded(
                            child: _buildPillarCard(
                                'Acciones',
                                'Facilitar la toma de decisiones informadas para un futuro sostenible',
                                Icons.trending_up)),
                      ],
                    );
                  } else {
                    return Column(
                      children: [
                        _buildPillarCard(
                            'Medidores',
                            'Captura de datos de calidad del agua en tiempo real mediante sensores avanzados',
                            Icons.sensors),
                        const SizedBox(height: 40),
                        _buildPillarCard(
                            'Visualización',
                            'Presentación de datos en dashboards intuitivos y fáciles de interpretar',
                            Icons.analytics),
                        const SizedBox(height: 40),
                        _buildPillarCard(
                            'Acciones',
                            'Facilitar la toma de decisiones informadas para un futuro sostenible',
                            Icons.trending_up),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionDivider() {
    return Container(
      width: double.infinity,
      height: 1,
      color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
    );
  }

  Widget _buildPillarCard(String title, String description, IconData icon) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width <= 900;
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        child: Builder(
          builder: (context) {
            bool isHovered = false;
            return StatefulBuilder(
              builder: (context, setState) {
                return MouseRegion(
                  onEnter: (_) => setState(() => isHovered = true),
                  onExit: (_) => setState(() => isHovered = false),
                  child: AnimatedScale(
                    scale: (isHovered && !isMobile) ? 1.05 : 1.0,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeInOut,
                    child: Container(
                      height: 400,
                      padding: const EdgeInsets.all(40),
                      decoration: BoxDecoration(
                        color: isDarkMode
                            ? theme.colorScheme.surface.withValues(alpha: 0.4)
                            : Colors.white.withValues(alpha: 0.8),
                        border: Border.all(
                          color: theme.colorScheme.primary
                              .withValues(alpha: isDarkMode ? 0.2 : 0.1),
                          width: 2,
                        ),
                        borderRadius: BorderRadius.circular(24),
                        boxShadow: isHovered
                            ? [
                                BoxShadow(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.2),
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
                            width: 80,
                            height: 80,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary
                                  .withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Icon(
                              icon,
                              size: 40,
                              color: isDarkMode
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 24),
                          Text(
                            title,
                            textAlign: TextAlign.center,
                            style: theme.textTheme.displaySmall?.copyWith(
                              color: isDarkMode
                                  ? Colors.white
                                  : theme.colorScheme.primary,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Flexible(
                            child: Text(
                              description,
                              textAlign: TextAlign.center,
                              style: theme.textTheme.bodyMedium?.copyWith(
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                                height: 1.6,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildWorkflowSection() {
    return Container(
      width: double.infinity,
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1100),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
          child: Column(
            children: [
              Text(
                'Flujo de Trabajo',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: isDarkMode
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 40),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 1024) {
                    return _buildDesktopWorkflow();
                  } else {
                    return _buildMobileWorkflow();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDesktopWorkflow() {
    final theme = Theme.of(context);
    return Container(
      decoration: BoxDecoration(
        color: isDarkMode
            ? theme.colorScheme.surface.withValues(alpha: 0.3)
            : Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.primary.withValues(alpha: 0.08),
            blurRadius: 20,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(24),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Left sidebar - 320px
            Container(
              width: 320,
              decoration: BoxDecoration(
                color: isDarkMode
                    ? theme.colorScheme.surface.withValues(alpha: 0.1)
                    : theme.colorScheme.secondary.withValues(alpha: 0.3),
                border: Border(
                  right: BorderSide(
                    color: theme.colorScheme.primary.withValues(alpha: 0.1),
                    width: 1,
                  ),
                ),
              ),
              child: Column(
                children: List.generate(
                  workflowData.length,
                  (index) => InkWell(
                    onTap: () {
                      setState(() {
                        selectedWorkflowStep = index;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 18),
                      decoration: BoxDecoration(
                        color: selectedWorkflowStep == index
                            ? theme.colorScheme.tertiary.withValues(alpha: 0.15)
                            : Colors.transparent,
                        border: Border(
                          left: BorderSide(
                            color: selectedWorkflowStep == index
                                ? theme.colorScheme.tertiary
                                : Colors.transparent,
                            width: 4,
                          ),
                          bottom: index < workflowData.length - 1
                              ? BorderSide(
                                  color: theme.colorScheme.primary
                                      .withValues(alpha: 0.08),
                                  width: 1,
                                )
                              : BorderSide.none,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 36,
                            height: 36,
                            decoration: BoxDecoration(
                              color: theme.colorScheme.tertiary,
                              shape: BoxShape.circle,
                            ),
                            child: Center(
                              child: Text(
                                '${index + 1}',
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Text(
                              workflowData[index].title,
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: selectedWorkflowStep == index
                                    ? FontWeight.w600
                                    : FontWeight.normal,
                                color: theme.colorScheme.onSurface,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
            // Right content area
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(32),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.network(
                        workflowData[selectedWorkflowStep].image,
                        height: 320,
                        width: double.infinity,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 20),
                    Text(
                      workflowData[selectedWorkflowStep].description,
                      style: TextStyle(
                        fontSize: 16,
                        color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                        height: 1.6,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMobileWorkflow() {
    return Column(
      children: [
        // Horizontal pills
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(
              workflowData.length,
              (index) => GestureDetector(
                onTap: () {
                  setState(() {
                    selectedWorkflowStep = index;
                  });
                },
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: selectedWorkflowStep == index
                        ? Theme.of(context).colorScheme.tertiary
                        : Theme.of(context)
                            .colorScheme
                            .tertiary
                            .withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  transform: selectedWorkflowStep == index
                      ? Matrix4.identity().scaled(1.1)
                      : Matrix4.identity(),
                  child: Center(
                    child: Text(
                      '${index + 1}',
                      style: TextStyle(
                        color: selectedWorkflowStep == index
                            ? Colors.white
                            : Theme.of(context).colorScheme.primary,
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        // Content
        Container(
          decoration: BoxDecoration(
            color: isDarkMode
                ? Theme.of(context).colorScheme.surface.withValues(alpha: 0.3)
                : Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Theme.of(context)
                    .colorScheme
                    .primary
                    .withValues(alpha: 0.08),
                blurRadius: 20,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(
              children: [
                AspectRatio(
                  aspectRatio: 16 / 9,
                  child: Image.network(
                    workflowData[selectedWorkflowStep].image,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Column(
                    children: [
                      Text(
                        workflowData[selectedWorkflowStep].title,
                        textAlign: TextAlign.center,
                        style: Theme.of(context).textTheme.titleLarge?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: isDarkMode
                                  ? Colors.white
                                  : Theme.of(context).colorScheme.primary,
                            ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        workflowData[selectedWorkflowStep].description,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 15,
                          color: isDarkMode ? Colors.white : Colors.grey[700],
                          height: 1.6,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMissionVisionSection() {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: isDarkMode
            ? const Color(0xFF001a24).withValues(alpha: 0.4)
            : const Color(0xFF306B6B).withValues(alpha: 0.05),
      ),
      child: Align(
        alignment: Alignment.center,
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            children: [
              Text(
                'Acerca de Minds',
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.displayLarge?.copyWith(
                      color: isDarkMode
                          ? Colors.white
                          : Theme.of(context).colorScheme.primary,
                    ),
              ),
              const SizedBox(height: 60),
              LayoutBuilder(
                builder: (context, constraints) {
                  if (constraints.maxWidth > 900) {
                    return IntrinsicHeight(
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Expanded(child: _buildMissionCard()),
                          const SizedBox(width: 40),
                          Expanded(child: _buildVisionCard()),
                        ],
                      ),
                    );
                  } else {
                    return Column(
                      children: [
                        _buildMissionCard(),
                        const SizedBox(height: 40),
                        _buildVisionCard(),
                      ],
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMissionCard() {
    return _MissionVisionCard(
      icon: Icons.flag,
      title: 'Misión',
      description:
          'Desarrollar soluciones tecnológicas accesibles e innovadoras que faciliten el análisis y la resolución de desafíos sociales. Mediante el diseño de software, servicios digitales y el aprovechamiento de tecnologías emergentes, buscamos empoderar a las comunidades y promover el cambio social positivo. Nos comprometemos a colaborar con entidades públicas y privadas, ofreciendo soluciones personalizadas y efectivas que respondan a las necesidades de un mundo en constante evolución.',
      isDarkMode: isDarkMode,
    );
  }

  Widget _buildVisionCard() {
    return _MissionVisionCard(
      icon: Icons.visibility,
      title: 'Visión',
      description:
          'Ser reconocidos como líderes en la creación de soluciones tecnológicas transformadoras que conviertan desafíos en oportunidades de desarrollo. Aspiramos a inspirar la toma de decisiones basada en datos y a generar un impacto sostenible en la sociedad, adaptándonos a las necesidades de nuestros usuarios. Para lograrlo, cultivamos un equipo de profesionales apasionados, creativos y comprometidos con la innovación y el bienestar social.',
      isDarkMode: isDarkMode,
    );
  }
}

// Custom painter for water waves
class WaterWavesPainter extends CustomPainter {
  final double animation;
  final bool isDarkMode;

  WaterWavesPainter({required this.animation, required this.isDarkMode});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = (isDarkMode ? const Color(0xFF66C2C2) : const Color(0xFF306B6B))
          .withValues(alpha: 0.1)
      ..style = PaintingStyle.fill;

    final path1 = Path();
    final waveHeight = 40.0;
    final waveWidth = size.width * 2;

    for (var i = 0; i < waveWidth; i++) {
      final x = i.toDouble();
      final y = size.height * 0.7 +
          sin((x / size.width * 2 * pi) + (animation * 2 * pi)) * waveHeight;
      if (i == 0) {
        path1.moveTo(x, y);
      } else {
        path1.lineTo(x, y);
      }
    }
    path1.lineTo(waveWidth, size.height);
    path1.lineTo(0, size.height);
    path1.close();
    canvas.drawPath(path1, paint);
  }

  @override
  bool shouldRepaint(WaterWavesPainter oldDelegate) =>
      animation != oldDelegate.animation;
}

class _MissionVisionCard extends StatefulWidget {
  final IconData icon;
  final String title;
  final String description;
  final bool isDarkMode;

  const _MissionVisionCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.isDarkMode,
  });

  @override
  State<_MissionVisionCard> createState() => _MissionVisionCardState();
}

class _MissionVisionCardState extends State<_MissionVisionCard> {
  bool isHovered = false;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isMobile = MediaQuery.of(context).size.width <= 900;

    return MouseRegion(
      onEnter: (_) => setState(() => isHovered = true),
      onExit: (_) => setState(() => isHovered = false),
      child: AnimatedScale(
        scale: (isHovered && !isMobile) ? 1.05 : 1.0,
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeInOut,
        child: Container(
          height: double.infinity,
          padding: const EdgeInsets.all(48),
          decoration: BoxDecoration(
            color: widget.isDarkMode
                ? theme.colorScheme.surface.withValues(alpha: 0.3)
                : Colors.white.withValues(alpha: 0.9),
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
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Icon(
                  widget.icon,
                  size: 40,
                  color: widget.isDarkMode
                      ? Colors.white
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.title,
                style: theme.textTheme.displayLarge?.copyWith(
                  color: widget.isDarkMode
                      ? Colors.white
                      : theme.colorScheme.primary,
                ),
              ),
              const SizedBox(height: 24),
              Text(
                widget.description,
                style: theme.textTheme.bodyLarge?.copyWith(
                  color: widget.isDarkMode ? Colors.white : Colors.grey[600],
                  height: 1.8,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
