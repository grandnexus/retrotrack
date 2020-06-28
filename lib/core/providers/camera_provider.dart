import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
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

  bool _isLoading = false;

  LogEntry _logEntry;
  Temperature _temperature;

  int _currentPersonIndex = 0;
  int _currentTemperatureIndex = 0;
  String _peopleImagePath;
  String _thermometerImagePath;

  CameraController _controller;
  Selection _currentSelection;

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  bool get isLoading => _isLoading;
  LogEntry get logEntry => _logEntry;
  Temperature get temperature => _temperature;
  int get currentPersonIndex => _currentPersonIndex;
  int get currentTemperatureIndex => _currentTemperatureIndex;
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

  void setIsLoading(bool loading) {
    _isLoading = loading;
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

  void selectAllPeople() {
    setCurrentSelection(Selection.person);

    for (int i = 0; i < logEntry.people.length; i++) {
      logEntry.people[i].isSelected = true;
      logEntry.people[i].temperature.isSelected = false;
    }

    notifyListeners();
  }

  void selectPerson(int index) {
    setCurrentSelection(Selection.person);
    _currentPersonIndex = index;
    for (int i = 0; i < logEntry.people.length; i++) {
      logEntry.people[i].isSelected = false;
      logEntry.people[i].temperature.isSelected = false;
    }

    logEntry.people[_currentPersonIndex].isSelected = true;
    notifyListeners();
  }

  void selectTemperature(int index) {
    setCurrentSelection(Selection.temperature);
    _currentTemperatureIndex = index;

    for (int i = 0; i < logEntry.people.length; i++) {
      logEntry.people[i].isSelected = false;
      logEntry.people[i].temperature.isSelected = false;
    }
    logEntry.people[_currentTemperatureIndex].temperature.isSelected = true;
    notifyListeners();
  }

  void reset() {
    _currentPersonIndex = 0;
    _currentTemperatureIndex = 0;

    for (int i = 0; i < logEntry.people.length; i++) {
      logEntry.people[i].isSelected = false;
      logEntry.people[i].temperature.isSelected = false;
    }

    notifyListeners();
  }

  Future<void> addLogEntry(LogEntry logEntry) async {
    final Box<LogEntry> logEntryBox = await Hive.openBox('log_entries');

    logEntryBox.add(logEntry);
  }

  Future<bool> takePhoto() async {
    setIsLoading(true);
    if (currentSelection == Selection.done) {
      addLogEntry(logEntry);
      return true;
    }

    try {
      final String id = generateId();
      final String path =
          join((await getExternalStorageDirectory()).path, '$id.jpg');

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
        logEntry.people[_currentTemperatureIndex].temperature.photo =
            temperature.photo;
        logEntry.people[_currentTemperatureIndex].temperature.temperature =
            temperature.temperature;
        if (_currentTemperatureIndex < logEntry.people.length) {
          _currentTemperatureIndex++;
          if (_currentTemperatureIndex < logEntry.people.length) {
            selectTemperature(_currentTemperatureIndex);
          }
        }
        if (_currentTemperatureIndex == logEntry.people.length) {
          reset();
          setCurrentSelection(Selection.done);
        }
      }
    } catch (e) {
      if (logEntry != null) {
        if (logEntry.people == null) {
          setCurrentSelection(Selection.person);
        }
      }
      _scaffoldKey.currentState.removeCurrentSnackBar();
      _scaffoldKey.currentState.showSnackBar(
        SnackBar(
          content: Text(e.toString()),
          duration: const Duration(hours: 1),
        ),
      );
      setIsLoading(false);
    }
    setIsLoading(false);

    return false;
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
