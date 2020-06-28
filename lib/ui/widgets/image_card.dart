import 'package:flutter/material.dart';

class ImageCard extends StatelessWidget {
  const ImageCard(this.image, this.fileLabel, this.isSelected, this.onPressed);

  final Image image;
  final String fileLabel;
  final bool isSelected;
  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onPressed(),
      child: Container(
        width: 50,
        height: 65,
        margin: const EdgeInsets.all(8.0),
        decoration: BoxDecoration(
          color: Colors.green[300],
          border: isSelected
              ? Border.all(
                  width: 3.0,
                  color: Colors.green[300],
                )
              : Border.all(
                  width: 3.0,
                ),
        ),
        child: Material(
          elevation: 4.0,
          child: Column(
            children: <Widget>[
              AspectRatio(
                aspectRatio: 1,
                child: image ??
                    Placeholder(
                      color: Colors.grey[100].withOpacity(0.5),
                    ),
              ),
              Text(
                fileLabel ?? '',
                style: Theme.of(context).textTheme.caption.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                maxLines: 1,
                overflow: TextOverflow.fade,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
