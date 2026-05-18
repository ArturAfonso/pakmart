
import 'dart:convert';
import 'dart:io';

import 'package:pakmart/src/core/models/flathub_app_info_model.dart';


class InstalledAppApi {
    InstalledAppApi({HttpClient? httpClient}) : _httpClient = httpClient ?? HttpClient();

final HttpClient _httpClient;


  Future<FlathubAppInfo?> fetchAppInfo(String appId, {String locale = 'en'}) async {
    final uri = Uri.parse('https://flathub.org/api/v2/appstream/$appId?locale=$locale');
    final request = await _httpClient.getUrl(uri);
    request.headers.set(HttpHeaders.acceptHeader, 'application/json');

      final response = await request.close();

      if (response.statusCode == 404) return null;
        if (response.statusCode < 200 || response.statusCode >= 300) return null;

        final body = await utf8.decoder.bind(response).join();
        final map = jsonDecode(body) as Map<String, dynamic>;
      return FlathubAppInfo.fromJson(map);
}



}