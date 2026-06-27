import 'package:url_launcher/url_launcher.dart';

class UrlLaunchService {
  UrlLaunchService._();

  static Future<bool> launchExternal(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return false;
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication);
  }

  static Future<bool> launchInNewTab(String url) async {
    final uri = Uri.tryParse(url.trim());
    if (uri == null) return false;
    if (!await canLaunchUrl(uri)) return false;
    return launchUrl(uri, mode: LaunchMode.externalApplication, webOnlyWindowName: '_blank');
  }
}
