
import 'package:duple/database/artist_model.dart';
import 'package:flutter/material.dart';

class DataCard extends StatelessWidget {
  final ArtistModel dataModel;
  const DataCard({super.key, required this.dataModel});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.blue.shade100,
          borderRadius: BorderRadius.circular(8.0),
        ),
        padding: const EdgeInsets.all(8.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              dataModel.username,
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 17,
              ),
            ),
            Text(dataModel.email),
            const SizedBox(height: 8),
            Text("Genre: ${dataModel.genre1}"),
            Text("Genre: ${dataModel.genre2}"),
          ],
        ),
      ),
    );
  }
}