import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeFilter extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? startDate, DateTime? endDate)? onApplyFilters;
  final VoidCallback? onPreviousPeriod;
  final VoidCallback? onNextPeriod;
  final void Function()? onClear;
  final bool isMobile;
  final bool isLoading;

  const DateRangeFilter({
    super.key,
    this.startDate,
    this.endDate,
    this.onApplyFilters,
    this.onPreviousPeriod,
    this.onNextPeriod,
    this.isLoading = false,
    this.onClear,
    required this.isMobile,
  });

  @override
  State<DateRangeFilter> createState() => _DateRangeFilterState();
}

class _DateRangeFilterState extends State<DateRangeFilter> {
  late DateTime? _startDate;
  late DateTime? _endDate;
  final DateFormat _dateFormat = DateFormat('MM/dd/yyyy');

  @override
  void initState() {
    super.initState();
    _startDate = widget.startDate;
    _endDate = widget.endDate;
  }

  @override
  void didUpdateWidget(DateRangeFilter oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDate != oldWidget.startDate) {
      _startDate = widget.startDate;
    }
    if (widget.endDate != oldWidget.endDate) {
      _endDate = widget.endDate;
    }
  }

  Future<void> _selectStartDate(BuildContext context) async {
    final DateTime? picked = await _showCustomDatePicker(
      context,
      _startDate ?? DateTime.now(),
    );
    if (picked != null && picked != _startDate) {
      setState(() {
        _startDate = picked;
        if (_endDate != null && _startDate!.isAfter(_endDate!)) {
          _endDate = _startDate;
        }
      });
    }
  }

  Future<void> _selectEndDate(BuildContext context) async {
    final DateTime? picked = await _showCustomDatePicker(
      context,
      _endDate ?? DateTime.now(),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  Future<DateTime?> _showCustomDatePicker(
      BuildContext context, DateTime initialDate) async {
    return await showDialog<DateTime>(
      context: context,
      builder: (context) {
        return Dialog(
          child: Container(
            width: 300,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.all(16),
            child: _CustomDatePicker(
              initialDate: initialDate,
              onDateSelected: (date) {
                Navigator.of(context).pop(date);
              },
            ),
          ),
        );
      },
    );
  }

  void _applyFilters() {
    if (widget.onApplyFilters != null) {
      widget.onApplyFilters!(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: theme.colorScheme.primary.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        spacing: 10,
        children: [
          if (widget.isMobile) ...[
            // Layout móvil - vertical
            _buildDateField(
              context,
              'Fecha de inicio',
              _startDate,
              () => _selectStartDate(context),
              isMobile: true,
            ),
            _buildDateField(
              context,
              'Fecha de fin',
              _endDate,
              () => _selectEndDate(context),
              isMobile: true,
            ),
            if (widget.onClear != null)
              IconButton(
                onPressed: widget.onClear,
                icon: const Icon(Icons.clear_all),
                tooltip: 'Quitar filtros',
              ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _buildNavigationButtons(context),
                _buildApplyButton(context, isMobile: true),
              ],
            ),
          ] else ...[
            // Layout desktop - horizontal con separación
            Row(
              children: [
                // Campos de fecha a la izquierda
                SizedBox(
                  width: 140,
                  child: _buildDateField(
                    context,
                    'Fecha de inicio',
                    _startDate,
                    () => _selectStartDate(context),
                    isMobile: false,
                  ),
                ),
                const SizedBox(width: 16),
                SizedBox(
                  width: 140,
                  child: _buildDateField(
                    context,
                    'Fecha de fin',
                    _endDate,
                    () => _selectEndDate(context),
                    isMobile: false,
                  ),
                ),
                // Espaciador para empujar los botones a la derecha
                const Spacer(),
                // Botones a la derecha
                _buildNavigationButtons(context),
                const SizedBox(width: 16),
                _buildApplyButton(context, isMobile: false),
                if (widget.onClear != null)
                  IconButton(
                    onPressed: widget.onClear,
                    icon: const Icon(Icons.clear),
                    tooltip: 'Quitar filtros',
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDateField(
    BuildContext context,
    String label,
    DateTime? date,
    VoidCallback onTap, {
    required bool isMobile,
  }) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: theme.textTheme.titleSmall?.copyWith(
            color: theme.colorScheme.onPrimary,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        InkWell(
          onTap: onTap,
          child: Container(
            height: 40,
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
            decoration: BoxDecoration(
              
              border: Border.all(
                color: theme.colorScheme.primary,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(10),
              color: theme.colorScheme.primary.withValues(alpha: 0.12),
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? _dateFormat.format(date) : 'mm/dd/yyyy',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: date != null
                          ? theme.colorScheme.onPrimary
                          : theme.colorScheme.onPrimary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: theme.colorScheme.tertiary.withValues(alpha: 0.7),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildNavigationButtons(BuildContext context) {
    return Row(
      children: [
        _buildNavButton(
          context,
          Icons.chevron_left,
          widget.onPreviousPeriod,
        ),
        const SizedBox(width: 8),
        _buildNavButton(
          context,
          Icons.chevron_right,
          widget.onNextPeriod,
        ),
      ],
    );
  }

  Widget _buildNavButton(
    BuildContext context,
    IconData icon,
    VoidCallback? onPressed,
  ) {
    return IconButton(
      onPressed: onPressed,
      icon: Icon(
        icon,
        size: 30,
        color: Theme.of(context).colorScheme.tertiary,
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, {required bool isMobile}) {
    final theme = Theme.of(context);

    return ElevatedButton(
      onPressed: widget.isLoading ? null : _applyFilters,
      style: ElevatedButton.styleFrom(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: isMobile ? 16 : 20,
          vertical: 6,
        ),
      ),
      child: widget.isLoading
          ? SizedBox(
              width: 16,
              height: 16,
              child: CircularProgressIndicator(
                strokeWidth: 2,
                valueColor: AlwaysStoppedAnimation<Color>(
                  theme.colorScheme.surface,
                ),
              ),
            )
          : Text(
              'Aplicar filtros',
              style: theme.textTheme.bodyMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
    );
  }
}

class _CustomDatePicker extends StatefulWidget {
  final DateTime initialDate;
  final Function(DateTime) onDateSelected;

  const _CustomDatePicker({
    required this.initialDate,
    required this.onDateSelected,
  });

  @override
  State<_CustomDatePicker> createState() => _CustomDatePickerState();
}

class _CustomDatePickerState extends State<_CustomDatePicker> {
  late DateTime _currentDate;
  late DateTime _selectedDate;

  @override
  void initState() {
    super.initState();
    _currentDate = widget.initialDate;
    _selectedDate = widget.initialDate;
  }

  void _previousMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month - 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentDate = DateTime(_currentDate.year, _currentDate.month + 1);
    });
  }

  void _selectDate(DateTime date) {
    setState(() {
      _selectedDate = date;
    });
    widget.onDateSelected(date);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final monthNames = [
      'Enero',
      'Febrero',
      'Marzo',
      'Abril',
      'Mayo',
      'Junio',
      'Julio',
      'Agosto',
      'Septiembre',
      'Octubre',
      'Noviembre',
      'Diciembre'
    ];

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Header con mes y año
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            IconButton(
              onPressed: _previousMonth,
              icon:
                  Icon(Icons.chevron_left, color: theme.colorScheme.secondary),
            ),
            Text(
              '${monthNames[_currentDate.month - 1]} ${_currentDate.year}',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.bold,
              ),
            ),
            IconButton(
              onPressed: _nextMonth,
              icon:
                  Icon(Icons.chevron_right, color: theme.colorScheme.secondary),
            ),
          ],
        ),
        const SizedBox(height: 16),
        // Días de la semana
        Row(
          children: ['L', 'M', 'X', 'J', 'V', 'S', 'D'].map((day) {
            return Expanded(
              child: Center(
                child: Text(
                  day,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            );
          }).toList(),
        ),
        const SizedBox(height: 8),
        // Calendario
        _buildCalendar(theme),
        const SizedBox(height: 16),
        // Botones
        Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.secondary.withAlpha(72),
                foregroundColor: theme.colorScheme.secondary,
              ),
              child: Text('Cancelar', style: theme.textTheme.bodyMedium),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: () => Navigator.of(context).pop(_selectedDate),
              style: ElevatedButton.styleFrom(
                backgroundColor: theme.colorScheme.tertiary.withAlpha(112),
                foregroundColor: theme.colorScheme.surface,
              ),
              child: Text('Seleccionar', style: theme.textTheme.bodyMedium),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildCalendar(ThemeData theme) {
    final firstDayOfMonth = DateTime(_currentDate.year, _currentDate.month, 1);
    final lastDayOfMonth =
        DateTime(_currentDate.year, _currentDate.month + 1, 0);
    final firstWeekday = firstDayOfMonth.weekday;
    final daysInMonth = lastDayOfMonth.day;

    List<Widget> dayWidgets = [];

    // Días del mes anterior
    for (int i = 1; i < firstWeekday; i++) {
      dayWidgets.add(Container());
    }

    // Días del mes actual
    for (int day = 1; day <= daysInMonth; day++) {
      final date = DateTime(_currentDate.year, _currentDate.month, day);
      final isSelected = _selectedDate.year == date.year &&
          _selectedDate.month == date.month &&
          _selectedDate.day == date.day;
      final isToday = date.year == DateTime.now().year &&
          date.month == DateTime.now().month &&
          date.day == DateTime.now().day;

      dayWidgets.add(
        GestureDetector(
          onTap: () => _selectDate(date),
          child: Container(
            height: 32,
            width: 32,
            decoration: BoxDecoration(
              color: isSelected
                  ? theme.colorScheme.tertiary
                  : isToday
                      ? theme.colorScheme.primary.withValues(alpha: 0.3)
                      : Colors.transparent,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Center(
              child: Text(
                day.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isSelected
                      ? theme.colorScheme.surface
                      : theme.colorScheme.onPrimary,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                ),
              ),
            ),
          ),
        ),
      );
    }

    return Wrap(
      children: dayWidgets,
    );
  }
}
