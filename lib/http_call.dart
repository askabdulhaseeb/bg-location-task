import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class HttpCall {
  Future<Position?> updateLocation() async {
    var headers = {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
      'Authorization':
          'Bearer eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIzMSIsImp0aSI6IjkzZjEyMjcyZTIzZDM4NDhjZWJhMmYyNTA4NDE3M2MxNDU4YWI5ZDJlYmYxYTllODkyYzhkMGU3NTc3YTdjNjY2ZWIyM2E3Y2RlYjc0MDA0IiwiaWF0IjoxNzEyMzI2OTcyLjI5MjAzNiwibmJmIjoxNzEyMzI2OTcyLjI5MjAzOCwiZXhwIjoxNzQzODYyOTcyLjI4ODIsInN1YiI6IjEyMzEiLCJzY29wZXMiOltdfQ.KYr52CLST0dqksMmCBgmh8obHRd4Df1ezEj0GTz50cZotfocTL5CopHORwws0wkSfmm9tHV7l29dsACLw3l0hGHm3b9ccmakrAh3BPA_EYom_4cizIa5xavV1SwLg_JVGMmxjCjmR7YABDmFKJVAdwPqOPNEBoUTNQwmKfD8PtPnZC0F0j8QbRi4GFnZWvJX8Q-wxDl6O5CTNjKzJ2QoI899tKTHimsZNhtE8OBh_qYX2cFLKr8GwXsYEwL_OLybjHaxyNyHiDBxXm62NJ--htbbeH2MXoLIoFByihHUG1tJni_IkiT_vDSX05HbOymd-hMKq9XHmeTbAcRYR1nlgSEISZs87XS-j-glQb6BkAQg9I109N9QybV09f24IHUAjgwvZevn5QK0OEkkWuRGe5i3P1Bru4_E0pHd7M6unKflqNDndnQQxmymLpqi7TITzcDFIpOwkejwtUCWNfGYkWYDbx8XP6yHPtz02YzJRIHNLKuFeIruIOwWANBgavT242xlLWWEC1Nw46Yn9hQcVn3CIBvnRcnQXcoFZ-U_A13ntQ8en-IxwwYjbdc5Fd4hvCXOYqilxEe_z1WuSQwPBIYoYftoC9sk255V4XeVY6YD9MBLV34I82TbeqnqpuCobSG0K8hwK3W-wwKOSpoeM2eqYeVe_meIk6gHGWJl8Mk',
      'Cookie': 'zeizzu_session=L06wrPL9tvryM15FxXO4qSjpkYmB9YSwF2YM2bYm'
    };

    final Position position = await Geolocator.getCurrentPosition();

    final Map<String, dynamic> body = <String, dynamic>{
      'latitude': position.latitude,
      'longitude': position.longitude,
    };

    var request = http.Request(
      'POST',
      Uri.parse(
        'https://beta.zeizzu.com/api/v1/rides/user-save-current-location',
      ),
    );

    request.body = json.encode({
      "latitude": position.latitude,
      "longitude": position.longitude,
    });

    request.headers.addAll(headers);
    request.body = json.encode(body);

    http.StreamedResponse response = await request.send();

    if (response.statusCode >= 200 && response.statusCode < 300) {
      debugPrint('✅ Location updated successfully');
      return position;
    } else {
      debugPrint(
        '❌ Failed to update location: ${response.statusCode} - Reason: ${response.reasonPhrase}',
      );
      return null;
    }
  }
}
