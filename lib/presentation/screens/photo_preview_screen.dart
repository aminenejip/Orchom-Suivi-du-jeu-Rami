import 'dart:io';
import 'package:flutter/material.dart';

class PhotoPreviewScreen extends StatelessWidget {
  final String imagePath;

  const PhotoPreviewScreen({required this.imagePath, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        foregroundColor: Colors.white,
        title: Text(
          imagePath.split('\\').last.split('/').last,
          overflow: TextOverflow.ellipsis,
        ),
      ),
      body: Center(
        child: File(imagePath).existsSync()
            ? InteractiveViewer(
                minScale: 0.5,
                maxScale: 4.0,
                child: Image.file(
                  File(imagePath),
                  fit: BoxFit.contain,
                  errorBuilder: (_, _, _) =>
                      const Text('Impossible d\'afficher l\'image'),
                ),
              )
            : const Text('Fichier introuvable'),
      ),
    );
  }
}
