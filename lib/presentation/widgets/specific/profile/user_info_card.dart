import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/user.dart';
import 'package:frontend_water_quality/presentation/providers/user_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/action_button.dart';
import 'package:frontend_water_quality/presentation/widgets/specific/profile/profile_info_field.dart';
import 'package:provider/provider.dart';

class UserInfoCard extends StatefulWidget {
  final User user;
  final double width;
  final Future<void> Function(User)? onSave; // nuevo parámetro

  const UserInfoCard({
    super.key,
    required this.user,
    required this.width,
    this.onSave,
  });

  @override
  State<UserInfoCard> createState() => _UserInfoCardState();
}

class _UserInfoCardState extends State<UserInfoCard> {
  final _formKey = GlobalKey<FormState>();
  late TextEditingController _usernameController;
  late TextEditingController _emailController;
  late TextEditingController _phoneController;
  // ignore: unused_field
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _usernameController = TextEditingController(text: widget.user.username);
    _emailController = TextEditingController(text: widget.user.email);
    _phoneController = TextEditingController(text: widget.user.phone);
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  void _handleReset() {
    _formKey.currentState?.reset();
    setState(() {
      _usernameController.text = widget.user.username ?? '';
      _emailController.text = widget.user.email;
      _phoneController.text = widget.user.phone ?? '';
    });
  }

  Future<void> _handleSave() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _isLoading = true);

    final updatedUser = widget.user.copyWith(
      username: _usernameController.text.trim(),
      email: _emailController.text.trim(),
      phone: _phoneController.text.trim(),
    );

    final provider = context.read<UserProvider>();
    final resultMessage = await provider.updateUser(updatedUser);

    if (mounted) {
      setState(() => _isLoading = false);
      if (resultMessage != null) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(resultMessage)),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: _formKey,
      child: Container(
        width: widget.width,
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            ProfileInfoField(
                label: 'Nombre de usuario', controller: _usernameController),
            const SizedBox(height: 20),
            ProfileInfoField(
              label: 'Correo electrónico',
              controller: _emailController,
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),
            ProfileInfoField(
              label: 'Teléfono',
              controller: _phoneController,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                ActionButton(
                  onPressed: _handleReset,
                  label: 'Resetear',
                  style: ActionButtonStyle.outlined,
                  width: widget.width == double.infinity ? 150 : 200,
                ),
                ActionButton(
                  onPressed: () async {
                    await _handleSave();
                  },
                  label: 'Guardar',
                  style: ActionButtonStyle.filled,
                  width: widget.width == double.infinity ? 150 : 200,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
