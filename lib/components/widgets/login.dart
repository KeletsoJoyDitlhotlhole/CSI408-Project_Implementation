import 'package:flutter/material.dart';

/// A widget that displays an image with rounded corners.
///
/// This widget maintains an aspect ratio of 0.45 and has rounded corners
/// with a radius of 25.
class InputDesign extends StatelessWidget {
  /// The URL of the image to display.
  final String imageUrl;

  /// Creates an [InputDesign] widget.
  ///
  /// The [imageUrl] parameter is required and specifies the URL of the image to display.
  const InputDesign({super.key, required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxWidth: 360, // Equivalent to maxWidth: "360px" in CSS
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(
          25,
        ), // Equivalent to borderRadius: "25px" in CSS
        child: AspectRatio(
          aspectRatio: 0.45, // Maintaining the specified aspect ratio
          child: Image.network(
            imageUrl,
            fit: BoxFit.contain, // Equivalent to objectFit: "contain" in CSS
            alignment:
                Alignment
                    .center, // Equivalent to objectPosition: "center" in CSS
            width: double.infinity, // Equivalent to width: "100%" in CSS
            errorBuilder: (context, error, stackTrace) {
              return Container(
                color: Colors.grey[200],
                child: const Center(
                  child: Icon(Icons.error_outline, color: Colors.grey),
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) {
                return child;
              }
              return Container(
                color: Colors.grey[100],
                child: Center(
                  child: CircularProgressIndicator(
                    value:
                        loadingProgress.expectedTotalBytes != null
                            ? loadingProgress.cumulativeBytesLoaded /
                                loadingProgress.expectedTotalBytes!
                            : null,
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
