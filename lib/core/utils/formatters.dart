// Formatters — maandishi ya tarehe kwa UI.
//
// Tunatumia muundo mmoja kila mahali: `dd/MM/yyyy HH:mm`.
// `intl` ipo, lakini format hii ni rahisi na haitegemei locale ya
// DateTimeFormat — hivyo haivunjiki kwenye test.

String formatDateTime(DateTime? value) {
  if (value == null) return '—';
  final local = value.toLocal();
  final day = local.day.toString().padLeft(2, '0');
  final month = local.month.toString().padLeft(2, '0');
  final year = local.year.toString();
  final hour = local.hour.toString().padLeft(2, '0');
  final minute = local.minute.toString().padLeft(2, '0');
  return '$day/$month/$year $hour:$minute';
}
