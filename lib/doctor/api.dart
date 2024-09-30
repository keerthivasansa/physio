import 'package:file_picker/file_picker.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/api/client.dart';
import 'package:physio/api/common.dart';
import 'package:physio/utils.dart';
import 'package:rest_api_client/rest_api_client.dart';
import 'package:tuple/tuple.dart';

class DoctorApi {
  ApiClient client = locator.get<ApiClient>();

  Future<void> saveVideos(int day, String patient, List<String> filenames,
      List<PlatformFile> files) async {
    final multipart = await Future.wait(files
        .map((f) => MultipartFile.fromFile(f.path!, filename: f.name))
        .toList());
    print(multipart);
    FormData formData = FormData.fromMap({
      "exercises": filenames,
      "day": day,
      "patient": patient,
      "videos": multipart,
    });

    await client.post("/doctor/videos/save", formData);
  }

  Future<Tuple2<Patient, List<PatientEntry>>> getPatientInfo(
      String patient) async {
    final res = await client.get("/doctor/patient", {"patientId": patient});
    final info = Patient.fromJson(res.data['info']);
    final entries =
        convertJsonToList(PatientEntry.fromJson, res.data['entries']);
    return Tuple2(info, entries);
  }

  Future<List<Patient>> getPatients() async {
    final res = await client.get("/doctor/patients", {});
    return convertJsonToList(Patient.fromJson, res.data);
  }

  Future<Map<int, List<Exercise>>> getVideos(String patientId) async {
    final res =
        await client.get("/doctor/patient/videos", {"patientId": patientId});
    Map<String, dynamic> m = res.data;
    Map<int, List<Exercise>> result = Map();

    for (String key in m.keys) {
      result[int.parse(key) - 1] = convertJsonToList(Exercise.fromJson, m[key]);
    }

    return result;
  }
}
