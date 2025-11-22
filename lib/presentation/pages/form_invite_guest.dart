import 'package:flutter/material.dart';
import 'package:frontend_water_quality/core/enums/screen_size.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';
import 'package:frontend_water_quality/presentation/providers/guest_provider.dart';
import 'package:frontend_water_quality/presentation/widgets/common/atoms/base_container.dart';
import 'package:frontend_water_quality/presentation/widgets/layout/layout.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

class FormInviteGuestPage extends StatefulWidget {
  final String workspaceId;
  final String workspaceTitle;
  final Guest? guest; // Si es null, es modo agregar; si tiene valor, es modo detalles

  const FormInviteGuestPage({
    super.key,
    required this.workspaceId,
    required this.workspaceTitle,
    this.guest,
  });

  @override
  State<FormInviteGuestPage> createState() => _FormInviteGuestPageState();
}

class _FormInviteGuestPageState extends State<FormInviteGuestPage> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  String _selectedRole = 'visitor';
  bool _isLoading = false;
  bool get _isEditMode => widget.guest != null;

  // Lista de roles disponibles (se puede obtener del backend)
  final List<Map<String, String>> _availableRoles = [
    {'value': 'visitor', 'label': 'VISITANTE'},
    {'value': 'manager', 'label': 'GERENTE'},
    {'value': 'administrator', 'label': 'ADMINISTRADOR'},
  ];

  @override
  void initState() {
    super.initState();
    if (_isEditMode) {
      _emailController.text = widget.guest!.email;
      _selectedRole = widget.guest!.role;
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final String title = _isEditMode ? "Editar invitado" : "Crear invitado";
    
    return Layout(
      title: title,
      builder: (context, screenSize) {
        return _buildMain(context, screenSize);
      },
    );
  }

  Widget _buildMain(BuildContext context, ScreenSize screenSize) {
    if (screenSize == ScreenSize.mobile || screenSize == ScreenSize.tablet) {
      return BaseContainer(
        margin: const EdgeInsets.all(10),
        width: double.infinity,
        height: double.infinity,
        child: _buildForm(context, screenSize),
      );
    }

    return BaseContainer(
      margin: const EdgeInsets.all(10),
      child: Align(
        alignment: Alignment.topCenter,
        child: _buildForm(context, screenSize),
      ),
    );
  }

  Widget _buildForm(BuildContext context, ScreenSize screenSize) {
    return Container(
      width: screenSize == ScreenSize.mobile ? double.infinity : 600,
      height: screenSize == ScreenSize.mobile ? double.infinity : 600,
      margin: const EdgeInsets.all(10),
      padding: const EdgeInsets.all(10),
      child: Form(
        key: _formKey,
        child: Column(
          children: [
            // Título
            Text(
              _isEditMode ? 'Detalles del Invitado' : 'Agregar Invitado',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 10),
            // Campo de email
            TextFormField(
              controller: _emailController,
              enabled: true, // Always editable
              decoration: const InputDecoration(
                labelText: 'Correo electrónico',
                hintText: 'ejemplo@correo.com',
                prefixIcon: Icon(Icons.email_outlined),
                border: OutlineInputBorder(),
              ),
              keyboardType: TextInputType.emailAddress,
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El correo electrónico es obligatorio';
                }
                if (!value.contains('@')) {
                  return 'Ingrese un correo electrónico válido';
                }
                return null;
              },
            ),
            const SizedBox(height: 10),
            // Campo de rol
            DropdownButtonFormField<String>(
              initialValue: _selectedRole,
              decoration: const InputDecoration(
                labelText: 'Rol',
                prefixIcon: Icon(Icons.security),
                border: OutlineInputBorder(),
              ),
              items: _availableRoles.map((role) {
                return DropdownMenuItem(
                  value: role['value'],
                  child: Text(role['label']!),
                );
              }).toList(),
              onChanged: (value) {
                if (value != null) {
                  setState(() {
                    _selectedRole = value;
                  });
                }
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'El rol es obligatorio';
                }
                return null;
              },
            ),
            const SizedBox(height: 20),
            // Botones
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                OutlinedButton(
                  onPressed: _isLoading ? null : () => context.pop(),
                  child: const Text('Cancelar'),
                ),
                if (!_isEditMode)
                  ElevatedButton(
                    onPressed: _isLoading ? null : _inviteGuest,
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2))
                        : const Text('Invitar'),
                  ),
                if (_isEditMode) ...[
                  ElevatedButton(
                    onPressed: _isLoading ? null : _saveChanges,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xff145c57),
                      foregroundColor: Colors.white,
                    ),
                    child: _isLoading
                        ? const SizedBox(height: 20, width: 20, child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white))
                        : const Text('Guardar'),
                  ),
                  ElevatedButton(
                    onPressed: _isLoading ? null : _deleteGuest,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red[600],
                      foregroundColor: Colors.white,
                    ),
                    child: const Text('Eliminar'),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _inviteGuest() async {
    print('FormInviteGuestPage: _inviteGuest called');
    print('FormInviteGuestPage: email=${_emailController.text}, role=$_selectedRole');

    if (!_formKey.currentState!.validate()) {
      print('FormInviteGuestPage: form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final guestProvider = context.read<GuestProvider>();
      print('FormInviteGuestPage: calling guestProvider.inviteGuest');

      await guestProvider.inviteGuest(widget.workspaceId, _emailController.text, _selectedRole);

      print('FormInviteGuestPage: inviteGuest completed');

      if (mounted) {
        if (guestProvider.errorMessage == null) {
          print('FormInviteGuestPage: inviteGuest successful, closing page');
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invitado agregado exitosamente'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          print('FormInviteGuestPage: inviteGuest failed, showing error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(guestProvider.errorMessage ?? 'Error al invitar al invitado'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('FormInviteGuestPage: inviteGuest exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _saveChanges() async {
    print('FormInviteGuestPage: _saveChanges called');
    print('FormInviteGuestPage: email=${_emailController.text}, role=$_selectedRole');

    if (!_formKey.currentState!.validate()) {
      print('FormInviteGuestPage: form validation failed');
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final guestProvider = context.read<GuestProvider>();
      print('FormInviteGuestPage: calling guestProvider.updateGuestRole');

      await guestProvider.updateGuestRole(widget.workspaceId, widget.guest!.id, _selectedRole);

      print('FormInviteGuestPage: updateGuestRole completed');

      if (mounted) {
        if (guestProvider.errorMessage == null) {
          print('FormInviteGuestPage: updateGuestRole successful, closing page');
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Cambios guardados exitosamente'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          print('FormInviteGuestPage: updateGuestRole failed, showing error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(guestProvider.errorMessage ?? 'Error al guardar los cambios'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('FormInviteGuestPage: updateGuestRole exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  Future<void> _deleteGuest() async {
    print('FormInviteGuestPage: _deleteGuest called');

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Confirmar eliminación'),
        content: const Text('¿Estás seguro de que quieres eliminar este invitado?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancelar'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(true),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red[600],
              foregroundColor: Colors.white,
            ),
            child: const Text('Eliminar'),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isLoading = true;
    });

    try {
      final guestProvider = context.read<GuestProvider>();
      print('FormInviteGuestPage: calling guestProvider.deleteGuest');

      await guestProvider.deleteGuest(widget.workspaceId, widget.guest!.id);

      print('FormInviteGuestPage: deleteGuest completed');

      if (mounted) {
        if (guestProvider.errorMessage == null) {
          print('FormInviteGuestPage: deleteGuest successful, closing page');
          context.pop();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: const Text('Invitado eliminado exitosamente'),
              backgroundColor: Colors.green[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else {
          print('FormInviteGuestPage: deleteGuest failed, showing error');
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(guestProvider.errorMessage ?? 'Error al eliminar el invitado'),
              backgroundColor: Colors.red[600],
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      }
    } catch (e) {
      print('FormInviteGuestPage: deleteGuest exception: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error inesperado: $e'),
            backgroundColor: Colors.red[600],
            behavior: SnackBarBehavior.floating,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }
} 