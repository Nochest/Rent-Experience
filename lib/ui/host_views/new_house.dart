import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:appwrite/appwrite.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/house.dart';
import 'package:tesis_airbnb_web/repository/impl/house_repository_impl.dart';
import 'package:tesis_airbnb_web/theme/colors.dart';
import 'package:path/path.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class NuevoAlojamientoForm extends StatefulWidget {
  final Future<void> Function() onSubmit;
  final String userId;

  const NuevoAlojamientoForm({
    super.key,
    required this.onSubmit,
    required this.userId,
  });

  @override
  State<NuevoAlojamientoForm> createState() => _NuevoAlojamientoFormState();
}

class _NuevoAlojamientoFormState extends State<NuevoAlojamientoForm> {
  List<Uint8List> imagenesSeleccionadas = [];
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final placeController = TextEditingController();
  String? _selectedType = 'Casa';
  bool isLoading = false;

  Future<void> _pickImage() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      allowMultiple: true,
      type: FileType.image,
      withData: true,
    );

    if (result != null) {
      setState(() {
        imagenesSeleccionadas.addAll(
          result.files
              .where((file) => file.bytes != null)
              .map((file) => file.bytes!)
              .toList(),
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      surfaceTintColor: Colors.transparent,
      backgroundColor: Colors.white,
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Nuevo alojamiento',
                style: TextStyle(
                  color: AppColors.primaryColor,
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    TextFormField(
                      controller: nameController,
                      decoration: const InputDecoration(labelText: 'Nombre'),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: _selectedType,
                      decoration: const InputDecoration(
                        labelText: 'Tipo de alojamiento',
                        border: OutlineInputBorder(),
                      ),
                      items: ['Casa', 'Cabaña', 'Bungalow']
                          .map((value) => DropdownMenuItem(
                                value: value,
                                child: Text(value),
                              ))
                          .toList(),
                      onChanged: (value) => setState(() {
                        _selectedType = value;
                      }),
                    ),
                    const SizedBox(height: 16),
                    TextFormField(
                      controller: placeController,
                      decoration: const InputDecoration(labelText: 'Ubicación'),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      children: [
                        Text(
                          'Galería de fotos',
                          style: TextStyle(
                            color: AppColors.primaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          onPressed: _pickImage,
                          icon: Icon(
                            Icons.add_a_photo_outlined,
                            color: AppColors.primaryColor,
                          ),
                        )
                      ],
                    ),
                    const SizedBox(height: 8),
                    SizedBox(
                      height: 400,
                      child: imagenesSeleccionadas.isEmpty
                          ? const Center(
                              child: Text('No se han agregado imágenes'))
                          : ListView.separated(
                              scrollDirection: Axis.horizontal,
                              itemCount: imagenesSeleccionadas.length,
                              separatorBuilder: (_, __) =>
                                  const SizedBox(width: 8),
                              itemBuilder: (context, i) => Card(
                                margin: const EdgeInsets.all(8.0),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                elevation: 5,
                                child: SizedBox(
                                  width: MediaQuery.of(context).size.width / 4,
                                  child: Column(
                                    children: [
                                      ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(10)),
                                        child: Image.memory(
                                          imagenesSeleccionadas[i],
                                          fit: BoxFit.cover,
                                          height: 342,
                                          width: double.infinity,
                                        ),
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                          'Foto ${i + 1}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                    ),
                    const SizedBox(height: 32),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ElevatedButton(
                          onPressed: () async {
                            setState(() {
                              isLoading = true;
                            });
                            try {
                              const bucketId = Constants.bucketHousesId;
                              List<String> fileIds = [];
                              await Future.wait(
                                imagenesSeleccionadas.map((bytes) async {
                                  final inputFile = InputFile.fromBytes(
                                    bytes: bytes,
                                    filename:
                                        'imagen_${DateTime.now().millisecondsSinceEpoch}.jpg',
                                  );

                                  final file = await AppwriteApiClient.storage
                                      .createFile(
                                    bucketId: bucketId,
                                    fileId: ID.unique(),
                                    file: inputFile,
                                  );
                                  fileIds.add(file.$id);

                                  return file.$id;
                                }),
                              );
                              final r = await HouseRepositoryImpl().add(House(
                                userId: widget.userId,
                                name: nameController.text,
                                type: _selectedType ?? 'Casa',
                                place: placeController.text,
                                imagesIds: fileIds,
                              ));
                              setState(() {
                                isLoading = false;
                              });
                              await widget.onSubmit();
                              Navigator.pop(context);
                            } catch (e, st) {
                              log('Error al subir imágenes: $e\n$st');
                            }
                          },
                          child: isLoading
                              ? CircularProgressIndicator()
                              : const Text('Enviar a revisión'),
                        ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Future<String> addImage(File imageFile, String bucketId) async {
    try {
      InputFile inFile = InputFile.fromPath(
        path: imageFile.path,
        filename: basename(imageFile.path),
      );
      final file = await AppwriteApiClient.storage
          .createFile(bucketId: bucketId, fileId: ID.unique(), file: inFile);
      return file.$id;
    } catch (e) {
      throw AppwriteException("Failed to add image: $e");
    }
  }
}
