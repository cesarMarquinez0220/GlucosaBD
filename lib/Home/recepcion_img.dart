import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final Image image;
  final String detectedObject;
  final String preProcessTime;
  final String inferenceTime;
  final String nmsTime;
  final double confidenceUsed;

  const ImageScreen({
    Key? key,
    required this.image,
    required this.detectedObject,
    required this.preProcessTime,
    required this.inferenceTime,
    required this.nmsTime,
    required this.confidenceUsed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Imagen Procesada'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16.0),
                child: image,
              ),
            ),
            const SizedBox(height: 16.0),
            _buildInfoRow('Objeto Detectado:', detectedObject),
            const SizedBox(height: 8.0),
            _buildInfoRow('Tiempo de Pre-proceso:', '$preProcessTime ms'),
            const SizedBox(height: 8.0),
            _buildInfoRow('Tiempo de Inferencia:', '$inferenceTime ms'),
            const SizedBox(height: 8.0),
            _buildInfoRow('Tiempo de NMS:', '$nmsTime ms'),
            const SizedBox(height: 8.0),
            _buildInfoRow('Confianza Utilizada:', '$confidenceUsed %'),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16.0,
            color: Colors.deepPurple,
          ),
        ),
        const SizedBox(width: 8.0),
        Expanded(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 16.0,
              color: Colors.black87,
            ),
          ),
        ),
      ],
    );
  }
}
