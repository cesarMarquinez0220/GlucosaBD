import 'package:flutter/material.dart';

class ImageScreen extends StatelessWidget {
  final Image image;

  const ImageScreen({required this.image});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Imagen Procesada'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Expanded(
            child: Container(
              margin: EdgeInsets.all(20),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey),
                borderRadius: BorderRadius.circular(10),
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: image,
              ),
            ),
          ),
          SizedBox(height: 20),
          ElevatedButton(style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Volver', style: TextStyle(color: Colors.white),),
          ),
        ],
      ),
    );
  }
}
