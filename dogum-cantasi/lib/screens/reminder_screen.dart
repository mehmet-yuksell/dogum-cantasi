import 'package:flutter/material.dart';

import '../services/notification_service.dart';
import '../theme/design_tokens.dart';

/// EKRAN 3 — Hatırlatıcı.
///
/// "Kullanıcı bir hafta seçer, o hafta geldiğinde bildirim gelir"
/// gereksinimini karşılamak için bir referans tarihe ihtiyaç vardır:
/// burada tahmini doğum tarihi (EDD) kullanılır. Seçilen gebelik
/// haftasının takvim tarihi = EDD - (40 - seçilenHafta) hafta olarak
/// hesaplanır. EDD girilmezse hafta seçimi anlamsız kalacağından bu
/// alan zorunludur.
class ReminderScreen extends StatefulWidget {
  const ReminderScreen({super.key});

  @override
  State<ReminderScreen> createState() => _ReminderScreenState();
}

class _ReminderScreenState extends State<ReminderScreen> {
  DateTime? _dueDate;
  int _selectedWeek = 34;
  bool _saving = false;
  String? _confirmationText;

  Future<void> _pickDueDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now.add(const Duration(days: 60)),
      firstDate: now,
      lastDate: now.add(const Duration(days: 300)),
      helpText: 'Tahmini doğum tarihini seç',
    );
    if (picked != null) setState(() => _dueDate = picked);
  }

  DateTime? get _triggerDate {
    if (_dueDate == null) return null;
    final weeksBefore = 40 - _selectedWeek;
    return _dueDate!.subtract(Duration(days: weeksBefore * 7));
  }

  Future<void> _confirm() async {
    final trigger = _triggerDate;
    if (trigger == null) return;

    setState(() => _saving = true);
    final granted = await NotificationService.instance.requestPermission();
    if (!granted) {
      setState(() {
        _saving = false;
        _confirmationText = 'Bildirim izni verilmedi. Hatırlatıcı ayarlanamadı.';
      });
      return;
    }

    // Seçilen tarih geçmişteyse (kullanıcı zaten o haftayı geçmişse)
    // hemen değil, 5 saniye sonra tetiklenen bir "gecikmiş" bildirim
    // gösterilir; ileri tarihliyse normal şekilde planlanır.
    final effectiveTrigger =
        trigger.isBefore(DateTime.now()) ? DateTime.now().add(const Duration(seconds: 5)) : trigger;

    await NotificationService.instance.scheduleWeekReminder(
      week: _selectedWeek,
      triggerDate: effectiveTrigger,
    );

    setState(() {
      _saving = false;
      _confirmationText =
          '$_selectedWeek. hafta için hatırlatıcı ayarlandı (${_formatDate(effectiveTrigger)}).';
    });
  }

  String _formatDate(DateTime d) =>
      '${d.day.toString().padLeft(2, '0')}.${d.month.toString().padLeft(2, '0')}.${d.year}';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Hatırlatıcı')),
      body: ListView(
        padding: const EdgeInsets.all(AppSpacing.md),
        children: [
          const Text('Tahmini doğum tarihi (EDD)', style: AppTypography.sectionHeader),
          const SizedBox(height: AppSpacing.sm),
          OutlinedButton.icon(
            onPressed: _pickDueDate,
            icon: const Icon(Icons.calendar_today_outlined),
            label: Text(_dueDate == null ? 'Tarih seç' : _formatDate(_dueDate!)),
          ),
          const SizedBox(height: AppSpacing.lg),
          const Text('Hangi haftada hatırlatılsın?', style: AppTypography.sectionHeader),
          const SizedBox(height: AppSpacing.sm),
          Row(
            children: [
              Expanded(
                child: Slider(
                  value: _selectedWeek.toDouble(),
                  min: 28,
                  max: 40,
                  divisions: 12,
                  label: '$_selectedWeek. hafta',
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _selectedWeek = v.round()),
                ),
              ),
              SizedBox(
                width: 56,
                child: Text('$_selectedWeek. hf', style: AppTypography.body),
              ),
            ],
          ),
          const SizedBox(height: AppSpacing.md),
          if (_triggerDate != null)
            Text(
              'Bildirim tarihi: ${_formatDate(_triggerDate!)}',
              style: AppTypography.caption,
            ),
          const SizedBox(height: AppSpacing.xl),
          FilledButton(
            onPressed: (_dueDate == null || _saving) ? null : _confirm,
            child: _saving
                ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Text('Hatırlatıcıyı ayarla'),
          ),
          if (_confirmationText != null) ...[
            const SizedBox(height: AppSpacing.md),
            Text(_confirmationText!, style: AppTypography.body),
          ],
        ],
      ),
    );
  }
}
