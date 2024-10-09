import 'dart:io';
import 'package:web_scraper/web_scraper.dart';

class DriveApi {
  static Future<String?> getDirectLinkFromDrive(String driveId) async {
    try {
      final videoBigUrl = await getDriveDirectLinkBigVideo(driveId);
      if (videoBigUrl != null) {
        return videoBigUrl;
      }

      return (await getDriveDirectLinkSmallVideo(driveId))!;
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getDriveDirectLinkBigVideo(String driveId) async {
    try {
      var baseUrl = 'https://drive.usercontent.google.com';

      var driveUrl = '/download?id=$driveId&export=download&authuser=0';

      final iSafeyCheck = await () async {
        final request = await HttpClient().getUrl(Uri.parse(baseUrl + driveUrl));
        final response = await request.close();

        final headers = response.headers;

        if (headers.value('accept-ranges') == 'bytes') return false;

        return true;
      }();

      if (iSafeyCheck == false) return null;

      final webScraper = WebScraper(baseUrl);

      if (await webScraper.loadWebPage(driveUrl)) {
        var elements = webScraper.getElement('input[name="uuid"]', ['value']);

        var uuid = elements.first['attributes']['value'];

        var downloadUrl = 'https://drive.usercontent.google.com/download?id=$driveId&export=download&authuser=0&confirm=t&uuid=$uuid';

        return downloadUrl;
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<String?> getDriveDirectLinkSmallVideo(String driveId) async {
    try {
      var baseUrl = 'https://drive.usercontent.google.com';

      var driveUrl = '/download?id=$driveId&export=download&authuser=0';

      return baseUrl + driveUrl;
    } catch (e) {
      return null;
    }
  }

  static String? getFileId(String url) {
    final RegExp regExp = RegExp(r'/d/([^/]+)/');
    final match = regExp.firstMatch(url);
    return match?.group(1);
  }
}
