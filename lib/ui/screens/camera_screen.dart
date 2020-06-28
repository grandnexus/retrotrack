import 'package:flutter/material.dart';
import 'package:camera/camera.dart';
import 'package:provider/provider.dart';
import 'package:retrotrack/core/index.dart';
import 'package:retrotrack/core/models/person.dart';
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

                return AspectRatio(
                  aspectRatio: cameraProvider.controller.value.aspectRatio,
                  child: CameraPreview(cameraProvider.controller),
                );
              },
            ),
            // Preview

            Positioned(
              left: 0,
              bottom: 0,
              child: Consumer<CameraProvider>(
                builder: (_, CameraProvider cameraProvider, __) {
                  return Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      children: <Widget>[
                        PreviewSection(cameraProvider),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: Consumer<CameraProvider>(
        builder: (_, CameraProvider cameraProvider, __) {
          return FloatingActionButton.extended(
            icon: cameraProvider.currentSelection != Selection.done
                ? const Icon(Icons.camera_alt)
                : const Icon(Icons.save),
            label: Text(
              cameraProvider.getFABText(cameraProvider.currentSelection),
            ),
            onPressed: () async {
              final bool dataTaken = await cameraProvider.takePhoto();
              if (dataTaken) {
                Navigator.pop(context, true);
                Provider.of<FeedProvider>(context, listen: false).refresh();
              }
            },
          );
        },
      ),
    );
  }
}

class PreviewSection extends StatelessWidget {
  const PreviewSection(this.camera);

  final CameraProvider camera;

  @override
  Widget build(BuildContext context) {
    if (camera.logEntry == null) {
      return const SizedBox.shrink();
    }

    final List<Person> _people = camera.logEntry.people;

    return Container(
      color: Colors.transparent,
      height: 165,
      margin: const EdgeInsets.all(10.0),
      child: ListView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        children: List<Column>.generate(
          _people.length,
          (int index) => Column(
            children: <Widget>[
              ImageCard(
                _people[index].photo,
                camera.getFABText(Selection.person),
                _people[index].isSelected,
                // () => camera.selectPerson(index),
                () => camera.selectAllPeople(),
              ),
              ImageCard(
                _people[index].temperature.photo,
                '${_people[index].temperature.temperature}',
                _people[index].temperature.isSelected,
                () => camera.selectTemperature(index),
              ),
            ],
          ),
        )..add(
            Column(
              children: const <Widget>[
                SizedBox(width: 30.0),
              ],
            ),
          ),
      ),
    );
  }
}
