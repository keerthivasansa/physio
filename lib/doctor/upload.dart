import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'package:physio/api/auth.dart';
import 'package:physio/doctor/api.dart';
import 'package:physio/nav/bar.dart';

class UploadSection extends StatefulWidget {
  final int totalDays;
  final String patientId;

  const UploadSection(
      {super.key, required this.totalDays, required this.patientId});

  @override
  _UploadSectionState createState() => _UploadSectionState();
}

class _UploadSectionState extends State<UploadSection> {
  List<List<String>> uploadedFiles = [];
  List<List<PlatformFile>> files = [];
  List<bool> hasChanges = [];

  @override
  void initState() {
    super.initState();
    hasChanges = List.filled(widget.totalDays, false);
    uploadedFiles = List.generate(widget.totalDays, (index) => []);
    files = List.generate(widget.totalDays, (idx) => []);

    fillState();
  }

  final api = locator.get<DoctorApi>();
  void fillState() async {
    final res = await api.getVideos(widget.patientId);
    setState(() {
      for (int day in res.keys) {
        print(day);
        uploadedFiles[day].addAll(res[day]?.map((ex) => ex.videoName) ?? []);
      }
    });
  }

  Future<void> _pickFile(int day) async {
    FilePickerResult? result = await FilePicker.platform
        .pickFiles(allowMultiple: true, type: FileType.video);
    if (result != null) {
      setState(() {
        for (var file in result.files) {
          files[day].add(file);
          uploadedFiles[day].add(file.name);
        }
        hasChanges[day] = true;
      });
    }
  }

  void _removeFile(int day, int index) {
    setState(() {
      String name = uploadedFiles[day].removeAt(index);
      files[day].removeWhere((file) => file.name == name);
      hasChanges[day] = true;
    });
  }

  void _reorderFiles(int day, int oldIndex, int newIndex) {
    setState(() {
      if (newIndex > oldIndex) {
        newIndex -= 1;
      }
      final String item = uploadedFiles[day].removeAt(oldIndex);
      uploadedFiles[day].insert(newIndex, item);
      hasChanges[day] = true;
    });
  }

  void _saveChanges(BuildContext ctx) async {
    // save days.
    List<Future<void>> promises = [];

    for (int day = 0; day < widget.totalDays; day++) {
      if (hasChanges[day]) {
        final p = api.saveVideos(
            day, widget.patientId, uploadedFiles[day], files[day]);
        promises.add(p);
      }
    }

    await Future.wait(promises);

    setState(() {
      hasChanges = hasChanges.map((e) => false).toList();
    });

    ScaffoldMessenger.of(ctx)
        .showSnackBar(const SnackBar(content: Text("Saved successfully!")));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: createAppBar(context),
      body: ListView.builder(
        itemCount: widget.totalDays,
        itemBuilder: (context, day) {
          return Card(
              margin: const EdgeInsets.all(12.0),
              shape: RoundedRectangleBorder(
                side: BorderSide(color: Colors.indigo, width: 1),
                borderRadius: BorderRadius.circular(10.0),
              ),
              child: Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Day ${day + 1}',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () => _pickFile(day),
                      child: Text('Add File'),
                    ),
                    if (uploadedFiles[day].isNotEmpty)
                      ReorderableListView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        children:
                            uploadedFiles[day].asMap().entries.map((entry) {
                          int index = entry.key;
                          String file = entry.value;
                          return ListTile(
                            key: ValueKey(file),
                            title: Text(file),
                            trailing: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () => _removeFile(day, index),
                            ),
                          );
                        }).toList(),
                        onReorder: (oldIndex, newIndex) =>
                            _reorderFiles(day, oldIndex, newIndex),
                      ),
                  ],
                ),
              ));
        },
      ),
      floatingActionButton: hasChanges.any((e) => e)
          ? IconButton(
              onPressed: () {
                _saveChanges(context);
              },
              style: const ButtonStyle(
                backgroundColor: WidgetStatePropertyAll(Colors.indigo),
                foregroundColor: WidgetStatePropertyAll(Colors.white),
              ),
              icon: const Icon(Icons.save))
          : null,
    );
  }
}
