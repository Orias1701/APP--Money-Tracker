import 'package:flutter/services.dart';

/// Format tiền tệ, ngày tháng (dùng chung toàn app).
class FormatHelpers {
  static String currency(num value) {
    return value
        .toStringAsFixed(0)
        .replaceAllMapped(
          RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  static String date(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }

  static String dateShort(DateTime d) {
    return '${d.day.toString().padLeft(2, '0')}/${d.month.toString().padLeft(2, '0')}/${d.year}';
  }
}

/// TextInputFormatter: nhập số tiền với dấu phẩy ngàn (tối đa 2 chữ số thập phân).
class AmountInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    if (newValue.text.isEmpty) return newValue;
    final raw = newValue.text.replaceAll(RegExp(r'[^\d.]'), '');
    final parts = raw.split('.');
    final intPart = parts[0];
    String decPart = parts.length > 1 ? parts.sublist(1).join('') : '';
    if (decPart.length > 2) decPart = decPart.substring(0, 2);
    final formatted = intPart.replaceAllMapped(
      RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
      (m) => '${m[1]},',
    );
    final result = decPart.isEmpty ? formatted : '$formatted.$decPart';
    int newCursor = newValue.selection.baseOffset;
    if (result != newValue.text) {
      newCursor = (newCursor + (result.length - newValue.text.length))
          .clamp(0, result.length);
    }
    return TextEditingValue(
      text: result,
      selection: TextSelection.collapsed(offset: newCursor),
    );
  }
}
