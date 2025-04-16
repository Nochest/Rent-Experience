import 'dart:developer';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/house.dart';
import 'package:tesis_airbnb_web/repository/impl/house_repository_impl.dart';

class VistaAlojamientoDialog extends StatelessWidget {
  final House house;
  final VoidCallback onApproved;
  final String bucketId;

  const VistaAlojamientoDialog({
    super.key,
    required this.house,
    required this.onApproved,
    required this.bucketId,
  });

  @override
  Widget build(BuildContext context) {
    final houseRepo = HouseRepositoryImpl();

    return Dialog(
      insetPadding: const EdgeInsets.all(24),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Container(
        constraints: const BoxConstraints(maxWidth: 500),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Detalles del Alojamiento',
              ),
              const SizedBox(height: 16),
              Text('Nombre: ${house.name}'),
              Text('Tipo: ${house.type}'),
              Text('Ubicación: ${house.place}'),
              Text('Estado actual: ${house.status}'),
              const SizedBox(height: 16),
              Text('Imágenes:',
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 8),
              SizedBox(
                height: 140,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: house.imagesIds?.length ?? 0,
                  separatorBuilder: (_, __) => const SizedBox(width: 12),
                  itemBuilder: (_, index) {
                    final imageId = house.imagesIds![index];
                    return FutureBuilder<Uint8List>(
                      future: AppwriteApiClient.storage.getFileView(
                        bucketId: bucketId,
                        fileId: imageId,
                      ),
                      builder: (context, snapshot) {
                        inspect(snapshot);
                        if (snapshot.connectionState ==
                            ConnectionState.waiting) {
                          return Container(
                            width: 120,
                            height: 120,
                            alignment: Alignment.center,
                            child: const CircularProgressIndicator(),
                          );
                        } else if (snapshot.hasData) {
                          return ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.memory(
                              snapshot.data!,
                              fit: BoxFit.cover,
                              width: 120,
                              height: 120,
                            ),
                          );
                        } else {
                          return Container(
                            width: 120,
                            height: 120,
                            color: Colors.grey.shade200,
                            child: const Icon(Icons.broken_image, size: 40),
                          );
                        }
                      },
                    );
                  },
                ),
              ),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: const Text('Cerrar'),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () async {
                      await houseRepo.approveHouse(house.id!);
                      onApproved();
                      Navigator.of(context).pop();
                    },
                    child: const Text('Aprobar'),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
