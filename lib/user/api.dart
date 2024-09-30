import 'package:physio/api/auth.dart';
import 'package:physio/api/client.dart';

class PatientApi {
  ApiClient api = locator.get<ApiClient>();

  Future<List<String>> getVideos() async {
    final videos = await api.get("/patient/videos", {});
    return List<String>.from(videos.data);
  }

  Future<void> saveEntry(
      int heart, int lung, int oxygen, String remarks) async {
    await api.post("/patient/entry", {
      "parameters": {
        "heart": heart,
        "lung": lung,
        "oxygen": oxygen,
      },
      "remarks": remarks,
    });
  }
}
