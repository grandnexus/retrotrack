import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:retrotrack/core/index.dart';

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

  @override
  void initState() {
    super.initState();
    _controller = CameraController(widget.camera, ResolutionPreset.high);
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
        return 'Person';
      case Selection.temperature:
        return 'Temperature';
      default:
        return 'Save';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: FutureBuilder<void>(
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
                  if (path1 != null)
                    GestureDetector(
                      onTap: () => setState(() {
                        currentSelection = Selection.person;
                      }),
                      child: _FileDisplay(
                        path1,
                        'Person',
                        currentSelection == Selection.person,
                      ),
                    ),
                  if (path2 != null)
                    GestureDetector(
                      onTap: () => setState(() {
                        currentSelection = Selection.temperature;
                      }),
                      child: _FileDisplay(
                        path2,
                        'Temp.',
                        currentSelection == Selection.temperature,
                      ),
                    ),
                ],
              ),
            ],
          );
        },
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
            final String path = join(
                (await getApplicationSupportDirectory()).path,
                '${generateId()}.png');

            await _controller.takePicture(path);

            setState(() {
              if (currentSelection == Selection.person) {
                path1 = path;
                currentSelection = Selection.temperature;
              } else if (currentSelection == Selection.temperature) {
                path2 = path;
                currentSelection = Selection.done;
              }
            });
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
        border: isSelected ? Border.all(width: 2) : const Border(),
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
