import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/core/models.dart';
import 'package:retrotrack/ui/index.dart';

enum Selection { person, temperature, done }

class CameraScreen extends StatefulWidget {
  const CameraScreen(this.camera);

  final CameraDescription camera;

  @override
  CameraScreenState createState() => CameraScreenState();
}

class CameraScreenState extends State<CameraScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  CameraController _controller;
  Future<void> _initializeControllerFuture;
  String path1;
  String path2;
  Selection currentSelection;
  LogEntry logEntry;
  Temperature temperature;

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.medium);
    _initializeControllerFuture = _controller.initialize();
    currentSelection = Selection.person;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  String _getFABText() {
    switch (currentSelection) {
      case Selection.person:
        return 'PERSON';
      case Selection.temperature:
        return 'TEMPERATURE';
      default:
        return 'SAVE';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: RetroBody(
        child: FutureBuilder<void>(
          future: _initializeControllerFuture,
          builder: (_, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState != ConnectionState.done) {
              return const Center(child: CircularProgressIndicator());
            }

            return Stack(
              alignment: Alignment.bottomCenter,
              children: <Widget>[
                CameraPreview(_controller),

                // Preview
                Row(
                  children: <Widget>[
                    if (logEntry != null)
                      GestureDetector(
                        onTap: () => setState(() {
                          currentSelection = Selection.person;
                        }),
                        child: _ImageDisplay(
                          logEntry,
                          'Person',
                          currentSelection == Selection.person,
                        ),
                      ),
                    if (temperature != null)
                      GestureDetector(
                        onTap: () => setState(() {
                          currentSelection = Selection.temperature;
                        }),
                        child: _TemperatureImageDisplay(
                          temperature,
                          temperature.temperature.toString(),
                          currentSelection == Selection.temperature,
                        ),
                      ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton.extended(
        icon: currentSelection != Selection.done
            ? const Icon(Icons.camera_alt)
            : const Icon(Icons.save),
        label: Text(_getFABText()),
        onPressed: () async {
          if (currentSelection == Selection.done) {
            Navigator.pop(context);
          }

          try {
            final String id = generateId();
            final String path =
                join((await getApplicationSupportDirectory()).path, '$id.jpg');

            await _controller.takePicture(path);

            if (currentSelection == Selection.person) {
              path1 = path;
              final File compressedFile = await compressImageFile(
                File(path1),
                path1.replaceAll(
                  id,
                  generateId(),
                ),
              );
              logEntry = await processCropFaceImage(compressedFile);
              currentSelection = Selection.temperature;
            } else if (currentSelection == Selection.temperature) {
              path2 = path;
              final File compressedFile = await compressImageFile(
                File(path2),
                path2.replaceAll(
                  id,
                  generateId(),
                ),
              );
              temperature = await processThermometerImage(compressedFile);
              currentSelection = Selection.done;
            }

            setState(() {});
          } catch (e) {
            _scaffoldKey.currentState.removeCurrentSnackBar();
            _scaffoldKey.currentState.showSnackBar(
              SnackBar(content: Text(e.toString())),
            );
          }
        },
      ),
    );
  }
}

class _FileDisplay extends StatelessWidget {
  const _FileDisplay(this.filePath, this.fileLabel, this.isSelected);

  final String filePath;
  final String fileLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    final Size screenSize = MediaQuery.of(context).size;

    return Container(
      height: screenSize.height * 0.2,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: isSelected
            ? Border.all(width: 2, color: Theme.of(context).primaryColor)
            : const Border(),
      ),
      child: Material(
        elevation: 4.0,
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            AspectRatio(
              aspectRatio: screenSize.width / screenSize.height,
              child: Image.file(File(filePath), fit: BoxFit.fill),
            ),
            Text(
              fileLabel,
              style: Theme.of(context).textTheme.caption,
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}

class _ImageDisplay extends StatelessWidget {
  const _ImageDisplay(this.logEntry, this.fileLabel, this.isSelected);

  final LogEntry logEntry;
  final String fileLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 65,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(width: 2) : const Border(),
      ),
      child: Material(
        elevation: 4.0,
        child: Column(
          children: <Widget>[
            if (logEntry.people.isNotEmpty)
              AspectRatio(
                aspectRatio: 1,
                child: logEntry.people[0].photo,
              ),
            Text(
              fileLabel,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}

class _TemperatureImageDisplay extends StatelessWidget {
  const _TemperatureImageDisplay(
      this.temperature, this.fileLabel, this.isSelected);

  final Temperature temperature;
  final String fileLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 65,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        border: isSelected ? Border.all(width: 2) : const Border(),
      ),
      child: Material(
        elevation: 4.0,
        child: Column(
          children: <Widget>[
            if (temperature.photo != null)
              AspectRatio(
                aspectRatio: 1,
                child: temperature.photo,
              ),
            Text(
              fileLabel,
              style: Theme.of(context).textTheme.caption.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              maxLines: 1,
              overflow: TextOverflow.fade,
            ),
          ],
        ),
      ),
    );
  }
}
