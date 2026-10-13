import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:url_launcher/url_launcher.dart';

/// Tap-to-contact actions shared by the footer and contact page.
///
/// Tries the platform handler first (mail app / dialer); if none is
/// available (e.g. desktop web without a handler), falls back to copying
/// the value so the tap never dead-ends.
class ContactLinks {
  ContactLinks._();

  static Future<void> email(BuildContext context, String address) =>
      _open(context, Uri(scheme: 'mailto', path: address), address, 'Email');

  static Future<void> phone(BuildContext context, String number) {
    final dialable = number.replaceAll(RegExp(r'[^\d+]'), '');
    return _open(
        context, Uri(scheme: 'tel', path: dialable), number, 'Phone number');
  }

  static Future<void> _open(BuildContext context, Uri uri, String value,
      String label) async {
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
      return;
    }
    await Clipboard.setData(ClipboardData(text: value));
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
            content: Text(
                'No mail/dialer app found — $label copied to clipboard')),
      );
    }
  }
}
