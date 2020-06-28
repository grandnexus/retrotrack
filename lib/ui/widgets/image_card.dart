import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard(this.image, this.fileLabel, this.isSelected);

  final Image image;
  final String fileLabel;
  final bool isSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 65,
      margin: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: Theme.of(context).primaryColor,
        border: isSelected ? Border.all(width: 2) : const Border(),
      ),
      child: Material(
        elevation: 4.0,
        child: Column(
          children: <Widget>[
            if (image != null)
              AspectRatio(
                aspectRatio: 1,
                child: image,
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
