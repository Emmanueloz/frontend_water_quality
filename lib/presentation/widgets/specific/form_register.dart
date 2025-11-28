import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/mobile_field.dart';
import 'package:frontend_water_quality/router/routes.dart';
import 'package:go_router/go_router.dart';
import 'package:intl_mobile_field/mobile_number.dart';

class RegisterForm extends StatefulWidget {
  final bool isLoading;
  final String errorMessage;
  final Future<void> Function(User user)? onRegister;
  const RegisterForm({
    super.key,
    required this.isLoading,
    required this.errorMessage,
    this.onRegister,
  });

  @override
  State<RegisterForm> createState() => _RegisterFormState();
}

class _RegisterFormState extends State<RegisterForm> {
  final formKey = GlobalKey<FormState>();

  final usernameController = TextEditingController();
  final emailController = TextEditingController();
  final phoneController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  MobileNumber? number;
  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;
  bool _acceptedTerms = false;

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }

  InputDecoration inputDecoration(String label, IconData icon) {
    return InputDecoration(
      labelText: label,
      suffixIcon: Icon(icon),
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Form(
        key: formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          spacing: 20,
          children: [
            Icon(Icons.person_add_alt, size: 50),
            Text(
              'Crear cuenta',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            TextFormField(
              controller: usernameController,
              keyboardType: TextInputType.text,
              decoration:
                  inputDecoration('Nombre de usuario', Icons.person_outline),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu nombre de usuario';
                } else if (value.length < 3) {
                  return 'El nombre de usuario debe tener al menos 3 caracteres';
                } else if (value.length > 20) {
                  return 'El nombre de usuario no puede tener más de 20 caracteres';
                }
                return null;
              },
            ),
            TextFormField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              decoration:
                  inputDecoration('Correo electrónico', Icons.email_outlined),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Por favor, ingresa tu correo electrónico';
                } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
                  return 'Por favor, ingresa un correo electrónico válido';
                }
                return null;
              },
            ),
            MobileField(
              controller: phoneController,
              inputDecoration: inputDecoration("Telefono", Icons.phone),
              onChanged: (value) {
                number = value;
              },
            ),
            TextFormField(
              controller: passwordController,
              obscureText: _obscurePassword,
              decoration:
                  inputDecoration('Contraseña', Icons.lock_outline).copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility_off : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() => _obscurePassword = !_obscurePassword);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Porfavor ingresa una contraseña';
                } else if (value.length < 6) {
                  return 'La contraseña es muy corta';
                }
                return null;
              },
            ),
            TextFormField(
              controller: confirmPasswordController,
              obscureText: _obscureConfirmPassword,
              decoration: inputDecoration(
                      'Confirmar contraseña', Icons.lock_reset_outlined)
                  .copyWith(
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscureConfirmPassword
                        ? Icons.visibility_off
                        : Icons.visibility,
                  ),
                  onPressed: () {
                    setState(() =>
                        _obscureConfirmPassword = !_obscureConfirmPassword);
                  },
                ),
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Porfavor confirma tu contraseña';
                } else if (value != passwordController.text) {
                  return 'La contraseña no coincide';
                }
                return null;
              },
            ),
            // Terms and Conditions checkbox
            FormField<bool>(
              initialValue: _acceptedTerms,
              validator: (value) {
                if (value != true) {
                  return 'Debes aceptar los términos y condiciones para continuar';
                }
                return null;
              },
              builder: (state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: state.value ?? false,
                          onChanged: (value) {
                            setState(() {
                              _acceptedTerms = value ?? false;
                              state.didChange(value);
                            });
                          },
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => showDialog(
                              context: context,
                              builder: (context) => _TermsDialog(),
                            ),
                            child: const Text.rich(
                              TextSpan(
                                text: 'He leído y acepto los ',
                                children: [
                                  TextSpan(
                                    text: 'términos y condiciones',
                                    style: TextStyle(
                                        decoration: TextDecoration.underline,
                                        color: Colors.blue),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    if (state.hasError)
                      Padding(
                        padding: const EdgeInsets.only(left: 12.0),
                        child: Text(
                          state.errorText ?? '',
                          style: const TextStyle(color: Colors.red),
                        ),
                      ),
                  ],
                );
              },
            ),

            ElevatedButton(
              onPressed: widget.isLoading
                  ? null
                  : () async {
                      print(number);
                      if (formKey.currentState!.validate() &&
                          widget.onRegister != null) {
                        final user = User(
                          username: usernameController.text.trim(),
                          email: emailController.text.trim(),
                          phone: "${number?.countryCode}${number?.number}",
                          password: passwordController.text.trim(),
                        );
                        print(user.toJson());
                        await widget.onRegister!(user);
                      }
                    },
              child: widget.isLoading
                  ? const CircularProgressIndicator(
                      color: Colors.white,
                    )
                  : const Text('Registrarse'),
            ),
            if (widget.errorMessage.isNotEmpty)
              Center(
                child: Text(
                  widget.errorMessage,
                  style: const TextStyle(color: Colors.red),
                ),
              ),
            TextButton(
              onPressed: () => context.goNamed(Routes.login.name),
              child: const Text(
                '¿Ya tienes una cuenta? Inicia sesión',
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TermsDialog extends StatelessWidget {
  const _TermsDialog({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Text('Términos y condiciones - Aqua Minds'),
      content: SingleChildScrollView(
        child: SelectableText(
          r'''Contrato de términos y condiciones de uso del software
Última actualización: Noviembre de 2025

1. INTRODUCCIÓN Y ACEPTACIÓN
El presente contrato describe los términos y condiciones aplicables al uso del software, aplicación móvil, plataforma web y hardware IoT denominados "Aqua Minds", propiedad de la empresa Mentes que Impulsan Nuevas Direcciones en Software, S.A. DE C.V. (en adelante "MINDS" o "El Proveedor").
Al descargar, instalar, registrarse o utilizar el sistema, el usuario (en adelante "El Cliente" o "El Usuario") acepta vincularse legalmente por estos términos. Si no está de acuerdo, deberá abstenerse de utilizar el servicio.

2. TIPO DE LICENCIA
De acuerdo con el modelo de negocio establecido, MINDS otorga al Usuario una licencia con las siguientes características:
Licencia de Uso Limitado: El software no se vende, se licencia bajo la modalidad de suscripción (SaaS). El Usuario adquiere el derecho al uso, no la propiedad del código fuente.
No Exclusiva: MINDS se reserva el derecho de otorgar licencias similares a otros clientes (Gobiernos, ONGs, Particulares).
Intransferible: La licencia está vinculada a la cuenta del Usuario y no puede ser cedida, subarrendada o vendida a terceros sin consentimiento escrito.
Revocable: MINDS puede terminar la licencia si el Usuario incumple estos términos o falta al pago de la suscripción correspondiente.

3. DESCRIPCIÓN DEL SERVICIO Y ALCANCE
El servicio "Aqua Minds" es una solución integral que combina:
Hardware IoT: Dispositivo físico de medición de calidad del agua (pH, TDS, turbidez, temperatura, etc.).
Plataforma Digital: Aplicación Web y Móvil (desarrolladas en Flutter y FastAPI) para la visualización de datos en tiempo real.
Inteligencia Artificial: Módulo de análisis predictivo y recomendaciones automatizadas.

4. PLANES DE SUSCRIPCIÓN Y PAGOS
El acceso al software se rige por los siguientes niveles de servicio (SaaS), cuyos costos y características se detallan a continuación:
Plan Gratuito ($0 MXN): Incluye acceso al panel, 2 espacios de trabajo, 2 medidores, reporte en PDF y funciones limitadas de IA (2 resúmenes/mes).
Plan Básico ($60 MXN/mes): Aumenta a 5 espacios de trabajo, 5 medidores, 6 resúmenes con IA y 6 predicciones futuras.
Plan Profesional ($100 MXN/mes): Aumenta a 8 espacios de trabajo, 15 usuarios invitados y 20 consultas de IA al mes.
Condiciones de Pago:
Las suscripciones se renuevan automáticamente de forma mensual o anual (con un 20% de descuento en pago anual).
El incumplimiento de pago resultará en la degradación de la cuenta al Plan Gratuito o la suspensión del servicio.

5. HARDWARE Y PROPIEDAD DEL DISPOSITIVO
Venta de Hardware: El dispositivo IoT se vende por separado a un costo de $2,499 MXN (pago único).
Garantía: El hardware es propiedad del Cliente tras la compra. El software necesario para su operación (firmware) se licencia bajo los términos de este contrato.
Conectividad: El Cliente es responsable de proveer la conexión a internet (WiFi) y suministro eléctrico necesarios para el funcionamiento del dispositivo.

6. USO DE DATOS E INTELIGENCIA ARTIFICIAL
Recolección de Datos: El sistema recolecta datos personales (nombre, correo, teléfono) y métricas ambientales. El tratamiento de estos datos se rige por nuestro Aviso de Privacidad.
Descargo de Responsabilidad sobre IA: Las predicciones, análisis y propuestas de mejora generadas por la Inteligencia Artificial son herramientas de apoyo a la decisión. MINDS no se hace responsable por decisiones de salud pública o infraestructura tomadas únicamente con base en estas predicciones sin validación técnica adicional, ya que el producto se encuentra en fase de validación de campo.

7. LIMITACIÓN DE RESPONSABILIDAD
El servicio se ofrece "tal cual". MINDS no garantiza que el servicio será ininterrumpido o libre de errores, aunque se compromete a realizar mantenimientos preventivos y actualizaciones de software. MINDS no será responsable por daños indirectos derivados del uso incorrecto del dispositivo o la interpretación errónea de los datos de calidad del agua.
''',
          style: const TextStyle(fontSize: 14),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Cerrar'),
        ),
      ],
    );
  }
}
