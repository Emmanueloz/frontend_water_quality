import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/presentation/providers/user_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/profile_info_field.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatefulWidget {
  final User user;
  final double width;

  const UserInfoCard({
    super.key,
    required this.user,
    required this.width,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> with AutomaticKeepAliveClientMixin {
  final _formKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();

  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  late TextEditingController _passwordController;
  late TextEditingController _confirmPasswordController;

  bool _isLoadingUser = false;
  bool _isLoadingPassword = false;

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleResetUser() {
    _formKey.currentState?.reset();
    setState(() {
      _usernameController.text = widget.user.username ?? '';
      _emailController.text = widget.user.email;
      _phoneController.text = widget.user.phone ?? '';
    });
  }

  Future<void> _handleSaveUser() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    setState(() => _isLoadingUser = true);

    User updatedUser = widget.user.copyWith(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final provider = context.read<UserProvider>();
    final resultMessage = await provider.updateUser(updatedUser);

    if (mounted) {
      setState(() => _isLoadingUser = false);
      if (resultMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resultMessage)),
        );
      }
    }
  }

  Future<void> _handleUpdatePassword() async {
    if (!(_passwordFormKey.currentState?.validate() ?? false)) {
      return;
    }
    setState(() => _isLoadingPassword = true);

    final provider = context.read<UserProvider>();
    final resultMessage =
        await provider.updatePassword(_passwordController.text.trim());

    if (mounted) {
      setState(() => _isLoadingPassword = false);
      if (resultMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resultMessage)),
        );
        _passwordController.clear();
        _confirmPasswordController.clear();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      spacing: 10,
      children: [
        Form(
          key: _formKey,
          child: Container(
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              spacing: 20,
              children: [
                ProfileInfoField(
                  label: 'Nombre de usuario',
                  controller: _usernameController,
                  fieldType: FieldType.name,
                ),
                ProfileInfoField(
                  label: 'Correo electrónico',
                  controller: _emailController,
                  keyboardType: TextInputType.emailAddress,
                  fieldType: FieldType.email,
                ),
                ProfileInfoField(
                  label: 'Teléfono',
                  controller: _phoneController,
                  keyboardType: TextInputType.phone,
                  fieldType: FieldType.phone,
                ),
                Row(
                  spacing: 10,
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: _handleResetUser,
                        child: const Text('Resetear'),
                      ),
                    ),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () async => await _handleSaveUser(),
                        child: Text(
                          _isLoadingUser ? 'Guardando...' : 'Actualizar',
                        ),
                      ),
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
        Form(
          key: _passwordFormKey,
          child: Container(
            width: widget.width,
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
            child: Column(
              spacing: 20,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "Actualizar contraseña",
                  style: Theme.of(context)
                      .textTheme
                      .titleMedium
                      ?.copyWith(fontWeight: FontWeight.bold),
                ),
                ProfileInfoField(
                  label: 'Nueva contraseña',
                  controller: _passwordController,
                  obscureText: _obscurePassword,
                  keyboardType: TextInputType.visiblePassword,
                  fieldType: FieldType.password,
                  suffixIcon: IconButton(
                    icon: Icon(
                      _obscurePassword
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () {
                      setState(() => _obscurePassword = !_obscurePassword);
                    },
                  ),
                ),
                ProfileInfoField(
                  label: 'Confirmar contraseña',
                  controller: _confirmPasswordController,
                  obscureText: _obscureConfirmPassword,
                  keyboardType: TextInputType.visiblePassword,
                  fieldType: FieldType.confirmPassword,
                  passwordController: _passwordController,
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
                Align(
                  alignment: Alignment.centerRight,
                  child: ElevatedButton(
                    onPressed: () async {
                      await _handleUpdatePassword();
                    },
                    child: Text(
                        _isLoadingPassword ? 'Actualizando...' : 'Actualizar'),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
