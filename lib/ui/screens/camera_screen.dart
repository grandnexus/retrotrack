import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:retrotrack/core/models/person.dart';

import 'package:retrotrack/core/providers/camera_provider.dart';
import 'package:retrotrack/ui/index.dart';
import 'package:retrotrack/ui/widgets/image_card.dart';

class CameraScreen extends StatelessWidget {
  const CameraScreen();

  @override
  Widget build(BuildContext context) {
    final CameraProvider cameraProvider =
        Provider.of<CameraProvider>(context, listen: false);
    return Scaffold(
      key: cameraProvider.scaffoldKey,
      body: RetroBody(
        child: Stack(
          alignment: Alignment.bottomCenter,
          children: <Widget>[
            FutureBuilder<void>(
                future: cameraProvider.controller.initialize(),
                builder: (_, AsyncSnapshot<void> snapshot) {
                  if (snapshot.connectionState != ConnectionState.done) {
                    return const Center(child: CircularProgressIndicator());
                  }

                  return CameraPreview(cameraProvider.controller);
                }),
            // Preview

            Positioned(
              left: 0,
              bottom: 0,
              child: Consumer<CameraProvider>(
                builder: (_, CameraProvider cameraProvider, __) {
                  return Column(
                    children: <Widget>[
                      PeopleSection(cameraProvider),
                      TemperatureSection(cameraProvider),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: Consumer<CameraProvider>(
        builder: (_, CameraProvider cameraProvider, __) {
          return FloatingActionButton.extended(
            icon: cameraProvider.currentSelection != Selection.done
                ? const Icon(Icons.camera_alt)
                : const Icon(Icons.save),
            label: Text(
              cameraProvider.getFABText(cameraProvider.currentSelection),
            ),
            onPressed: () => cameraProvider.takePhoto(context),
          );
        },
      ),
    );
  }
}

class PeopleSection extends StatelessWidget {
  const PeopleSection(this.camera);

  final CameraProvider camera;

  @override
  Widget build(BuildContext context) {
    if (camera.logEntry == null) {
      return const SizedBox.shrink();
    }

    final List<Person> _people = camera.logEntry.people;

    return Row(
      children: List<ImageCard>.generate(
        _people.length,
        (int index) => ImageCard(
          _people[index].photo,
          camera.getFABText(Selection.person),
          camera.currentSelection == Selection.person,
        ),
      ),
    );
  }
}

class TemperatureSection extends StatelessWidget {
  const TemperatureSection(this.camera);

  final CameraProvider camera;

  @override
  Widget build(BuildContext context) {
    if (camera.logEntry == null) {
      return const SizedBox.shrink();
    }

    final List<Person> _people = camera.logEntry.people;

    return Row(
      children: List<ImageCard>.generate(
        _people.length,
        (int index) => ImageCard(
          _people[index].temperature.photo,
          camera.getFABText(Selection.temperature),
          camera.currentSelection == Selection.temperature,
        ),
      ),
    );
  }
}
