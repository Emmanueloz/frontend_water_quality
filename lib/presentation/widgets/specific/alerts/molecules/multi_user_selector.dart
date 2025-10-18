import 'package:flutter/material.dart';
import 'package:frontend_water_quality/domain/models/guests.dart';

class MultiUserSelector extends StatefulWidget {
  final List<Guest> availableUsers;
  final List<String> selectedUserIds; 
  final Function(List<String>) onSelectionChanged;
  final bool isLoading;

  const MultiUserSelector({
    super.key,
    required this.availableUsers,
    required this.selectedUserIds, 
    required this.onSelectionChanged,
    this.isLoading = false,
  });

  @override
  State<MultiUserSelector> createState() => _MultiUserSelectorState();
}

class _MultiUserSelectorState extends State<MultiUserSelector> {
  late List<String> _selectedIds; 
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _selectedIds = List.from(widget.selectedUserIds); 
  }

  @override
  void didUpdateWidget(MultiUserSelector oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.selectedUserIds != widget.selectedUserIds) { 
      _selectedIds = List.from(widget.selectedUserIds); 
    }
  }

  void _toggleUser(String userId) {
    setState(() {
      if (_selectedIds.contains(userId)) { 
        _selectedIds.remove(userId);
      } else {
        _selectedIds.add(userId);
      }
    });
    widget.onSelectionChanged(_selectedIds); 
  }

  void _selectAll() {
    setState(() {
      _selectedIds = widget.availableUsers.map((u) => u.id).toList(); 
    });
    widget.onSelectionChanged(_selectedIds); 
  }

  void _clearAll() {
    setState(() {
      _selectedIds.clear(); 
    });
    widget.onSelectionChanged(_selectedIds); 
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (widget.isLoading) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16.0),
          child: Center(
            child: CircularProgressIndicator(),
          ),
        ),
      );
    }

    if (widget.availableUsers.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: [
              Icon(Icons.people_outline, size: 48, color: Colors.grey[400]),
              const SizedBox(height: 8),
              Text(
                'No hay usuarios con permisos suficientes', 
                style: TextStyle(color: Colors.grey[600]),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 4),
              Text(
                'Solo managers y administradores pueden recibir alertas',
                style: TextStyle(
                  color: Colors.grey[500],
                  fontSize: 12,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Header
          InkWell(
            onTap: () => setState(() => _isExpanded = !_isExpanded),
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Icon(
                    Icons.notifications_active,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Notificar a usuarios',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          _selectedIds.isEmpty // CAMBIO
                              ? 'Ningún usuario seleccionado'
                              : '${_selectedIds.length} usuario${_selectedIds.length != 1 ? 's' : ''} seleccionado${_selectedIds.length != 1 ? 's' : ''}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    _isExpanded ? Icons.expand_less : Icons.expand_more,
                  ),
                ],
              ),
            ),
          ),

          // Expandable content
          if (_isExpanded) ...[
            const Divider(height: 1),

            // Action buttons
            Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton.icon(
                    onPressed: _selectAll,
                    icon: const Icon(Icons.check_box, size: 18),
                    label: const Text('Todos'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                  const SizedBox(width: 8),
                  TextButton.icon(
                    onPressed: _clearAll,
                    icon: const Icon(Icons.clear, size: 18),
                    label: const Text('Ninguno'),
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                    ),
                  ),
                ],
              ),
            ),

            // User list
            Container(
              constraints: const BoxConstraints(maxHeight: 300),
              child: ListView.builder(
                shrinkWrap: true,
                itemCount: widget.availableUsers.length,
                itemBuilder: (context, index) {
                  final user = widget.availableUsers[index];
                  final isSelected = _selectedIds.contains(user.id); 

                  return CheckboxListTile(
                    value: isSelected,
                    onChanged: (bool? value) => _toggleUser(user.id),
                    title: Text(
                      user.name,
                      style: const TextStyle(fontWeight: FontWeight.w500),
                    ),
                    subtitle: Row(
                      children: [
                        Expanded(
                          child: Text(
                            user.email,
                            style: TextStyle(
                              fontSize: 12,
                              color: Colors.grey[600],
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: user.role.toLowerCase() == 'administrator'
                                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                                : theme.colorScheme.secondary.withValues(alpha: 0.1),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            user.role.toLowerCase() == 'administrator'
                                ? 'Admin'
                                : 'Manager',
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                              color: user.role.toLowerCase() == 'administrator'
                                  ? theme.primaryColor
                                  : theme.colorScheme.secondary,
                            ),
                          ),
                        ),
                      ],
                    ),
                    secondary: CircleAvatar(
                      backgroundColor: isSelected
                          ? theme.primaryColor.withValues(alpha: 0.2)
                          : Colors.grey[200],
                      child: Text(
                        user.name.isNotEmpty ? user.name[0].toUpperCase() : '?',
                        style: TextStyle(
                          color:
                              isSelected ? theme.primaryColor : Colors.grey[600],
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    dense: true,
                  );
                },
              ),
            ),
            const SizedBox(height: 8),
          ],
        ],
      );
  }
}