import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrotrack/core/index.dart';

import 'package:retrotrack/core/models/index.dart' show LogEntry, Temperature;

enum Selection { person, temperature, done }

class CameraProvider extends ChangeNotifier {
  CameraProvider(this.cameraDescription) {
    init(cameraDescription);
  }

  final CameraDescription cameraDescription;

  LogEntry _logEntry;
  Temperature _temperature;

  String _peopleImagePath;
  String _thermometerImagePath;
  CameraController _controller;
  Selection _currentSelection;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  LogEntry get logEntry => _logEntry;
  Temperature get temperature => _temperature;
  String get peopleImagePath => _peopleImagePath;
  String get thermometerImagePath => _thermometerImagePath;
  CameraController get controller => _controller;
  Selection get currentSelection => _currentSelection;
  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;

  void init(CameraDescription cameraDescription) {
    _controller = CameraController(cameraDescription, ResolutionPreset.high);
    _currentSelection = Selection.person;
    notifyListeners();
  }

  void setPeopleImagePath(String imagePath) {
    _peopleImagePath = imagePath;
    notifyListeners();
  }

  void setThermometerImagePath(String imagePath) {
    _thermometerImagePath = imagePath;
    notifyListeners();
  }

  void setCurrentSelection(Selection selection) {
    _currentSelection = selection;
    notifyListeners();
  }

  void setLogEntry(LogEntry logEntry) {
    _logEntry = logEntry;
    notifyListeners();
  }

  void setTemperature(Temperature temperature) {
    _temperature = temperature;
    notifyListeners();
  }

  Future<void> takePhoto(BuildContext context) async {
    if (currentSelection == Selection.done) {
      Navigator.pop(context);
    }

    try {
      final String id = generateId();
      final String path =
          join((await getApplicationSupportDirectory()).path, '$id.jpg');

      await controller.takePicture(path);

      if (currentSelection == Selection.person) {
        setPeopleImagePath(path);
        final File compressedFile = await compressImageFile(
          File(peopleImagePath),
          peopleImagePath.replaceAll(
            id,
            generateId(),
          ),
        );
        setLogEntry(await processCropFaceImage(compressedFile));
        setCurrentSelection(Selection.temperature);
      } else if (currentSelection == Selection.temperature) {
        setThermometerImagePath(path);
        final File compressedFile = await compressImageFile(
          File(thermometerImagePath),
          thermometerImagePath.replaceAll(
            id,
            generateId(),
          ),
        );
        setTemperature(await processThermometerImage(compressedFile));
        logEntry.people[0].temperature.photo = temperature.photo;
        setCurrentSelection(Selection.done);
      }
    } catch (e) {
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
    notifyListeners();
  }

  String getFABText(Selection selection) {
    switch (selection) {
      case Selection.person:
        return 'PERSON';
      case Selection.temperature:
        return 'TEMPERATURE';
      default:
        return 'SAVE';
    }
  }
}
