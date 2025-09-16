import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateRangeFilter extends StatefulWidget {
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime? startDate, DateTime? endDate)? onApplyFilters;
  final VoidCallback? onPreviousPeriod;
  final VoidCallback? onNextPeriod;
  final bool isLoading;

  const DateRangeFilter({
    super.key,
    this.startDate,
    this.endDate,
    this.onApplyFilters,
    this.onPreviousPeriod,
    this.onNextPeriod,
    this.isLoading = false,
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _startDate ?? DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
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
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _endDate ?? DateTime.now(),
      firstDate: _startDate ?? DateTime(2020),
      lastDate: DateTime.now(),
      locale: const Locale('es', 'ES'),
    );
    if (picked != null && picked != _endDate) {
      setState(() {
        _endDate = picked;
      });
    }
  }

  void _applyFilters() {
    if (widget.onApplyFilters != null) {
      widget.onApplyFilters!(_startDate, _endDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenWidth = MediaQuery.of(context).size.width;
    final isMobile = screenWidth < 600;

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
        children: [
          if (isMobile) ...[
            // Layout móvil - vertical
            _buildDateField(
              context,
              'Fecha de inicio',
              _startDate,
              () => _selectStartDate(context),
              isMobile: true,
            ),
            const SizedBox(height: 16),
            _buildDateField(
              context,
              'Fecha de fin',
              _endDate,
              () => _selectEndDate(context),
              isMobile: true,
            ),
            const SizedBox(height: 16),
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
            color: theme.colorScheme.secondary,
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
              color: theme.colorScheme.surface,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(
                    date != null ? _dateFormat.format(date) : 'mm/dd/yyyy',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: date != null 
                          ? theme.colorScheme.secondary 
                          : theme.colorScheme.secondary.withValues(alpha: 0.6),
                    ),
                  ),
                ),
                Icon(
                  Icons.calendar_today,
                  size: 18,
                  color: theme.colorScheme.secondary.withValues(alpha: 0.7),
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
    final theme = Theme.of(context);
    
    return Container(
      width: 36,
      height: 36,
      decoration: BoxDecoration(
        color: theme.colorScheme.secondary,
        borderRadius: BorderRadius.circular(8),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(
          icon,
          color: theme.colorScheme.surface,
          size: 18,
        ),
      ),
    );
  }

  Widget _buildApplyButton(BuildContext context, {required bool isMobile}) {
    final theme = Theme.of(context);
    
    return SizedBox(
      height: 36,
      child: ElevatedButton(
        onPressed: widget.isLoading ? null : _applyFilters,
        style: ElevatedButton.styleFrom(
          backgroundColor: theme.colorScheme.secondary,
          foregroundColor: theme.colorScheme.surface,
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
                  color: theme.colorScheme.surface,
                  fontWeight: FontWeight.w600,
                ),
              ),
      ),
    );
  }
}
