import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:ota_update/ota_update.dart';
import 'package:package_info_plus/package_info_plus.dart';

class UpdateInfo {
  final String version; // mis. "1.1.0"
  final String apkUrl;
  final String notes;
  const UpdateInfo(
      {required this.version, required this.apkUrl, required this.notes});
}

/// Cek & pasang pembaruan dari GitHub Releases (sideload).
class UpdateService {
  static const _repo = 'devtya/uangku';

  /// Return UpdateInfo kalau ada rilis lebih baru dari versi terpasang,
  /// null kalau sudah terbaru / belum ada rilis.
  Future<UpdateInfo?> checkForUpdate() async {
    final res = await http.get(
      Uri.parse('https://api.github.com/repos/$_repo/releases/latest'),
      headers: const {
        'Accept': 'application/vnd.github+json',
        // GitHub API WAJIB User-Agent; tanpa ini dibalas 403.
        'User-Agent': 'uangku-app',
      },
    );
    if (res.statusCode == 404) return null; // belum ada rilis
    if (res.statusCode != 200) {
      throw Exception('GitHub API ${res.statusCode}');
    }
    final data = jsonDecode(res.body) as Map<String, dynamic>;

    final latest = _normalize(data['tag_name'] as String? ?? '');
    if (latest == null) return null;

    final info = await PackageInfo.fromPlatform();
    final current = _normalize(info.version);
    if (current == null || !_isNewer(latest, current)) return null;

    final assets = (data['assets'] as List? ?? []).cast<Map<String, dynamic>>();
    final apk = assets.firstWhere(
      (a) => (a['name'] as String?)?.toLowerCase().endsWith('.apk') ?? false,
      orElse: () => const {},
    );
    final url = apk['browser_download_url'] as String?;
    if (url == null) return null;

    return UpdateInfo(
      version: (data['tag_name'] as String).replaceFirst('v', ''),
      apkUrl: url,
      notes: (data['body'] as String?)?.trim() ?? '',
    );
  }

  Stream<OtaEvent> downloadAndInstall(String url) =>
      OtaUpdate().execute(url, destinationFilename: 'uangku-update.apk');

  List<int>? _normalize(String v) {
    final m = RegExp(r'(\d+)\.(\d+)\.(\d+)').firstMatch(v);
    if (m == null) return null;
    return [int.parse(m[1]!), int.parse(m[2]!), int.parse(m[3]!)];
  }

  bool _isNewer(List<int> a, List<int> b) {
    for (var i = 0; i < 3; i++) {
      if (a[i] != b[i]) return a[i] > b[i];
    }
    return false;
  }
}
