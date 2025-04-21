import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/house.dart';
import 'package:tesis_airbnb_web/models/reservation.dart';
import 'package:tesis_airbnb_web/models/user.dart';
import 'package:tesis_airbnb_web/repository/impl/house_repository_impl.dart';
import 'package:tesis_airbnb_web/repository/impl/reservation_repositry_impl.dart';
import 'package:tesis_airbnb_web/theme/colors.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class MainGuestWebPage extends StatefulWidget {
  const MainGuestWebPage({super.key});

  @override
  State<MainGuestWebPage> createState() => _MainGuestWebPageState();
}

class _MainGuestWebPageState extends State<MainGuestWebPage> {
  bool loading = false;
  User? user;
  final houseRepository = HouseRepositoryImpl();
  List<House> houses = [];
  final TextEditingController _initDateController = TextEditingController();
  final TextEditingController _endDateController = TextEditingController();
  final TextEditingController _personsController = TextEditingController();
  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        loading = true;
      });
      String? jsonUsuario = html.window.localStorage['usuario'];
      if (jsonUsuario != null) {
        final data = jsonDecode(jsonUsuario);
        final usuario = User.fromJson(data);
        final fetchedHouses = await houseRepository.getApprovedHouses();

        setState(() {
          user = usuario;
          houses = fetchedHouses;
          loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    inspect(houses);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Bienvenido, ${user?.name}',
          style: TextStyle(
            color: AppColors.primaryColor,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text(
              'Alojamientos',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () {
              html.window.localStorage.remove('usuario');
              AppwriteApiClient.account.deleteSessions();
              context.go('/');
            },
            child: Text(
              'Cerrar Sesión',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Image.asset(
                    'assets/logo.jpeg',
                    fit: BoxFit.cover,
                  ),
                  SizedBox(width: 10),
                  Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '¡Desconecta para conectar!',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 72,
                        ),
                      ),
                      Text(
                        'Descubre nuevas formas de adquirir experiencia de bienestar en un solo lugar.',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Colors.blueGrey,
                          fontSize: 20,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 32),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color.fromARGB(255, 113, 174, 214),
                  borderRadius: BorderRadius.circular(5),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 240, vertical: 16),
                margin: const EdgeInsets.symmetric(vertical: 16.0),
                child: Column(
                  children: [
                    Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          'Sugerencias de alojamientos',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryColor,
                            fontSize: 36,
                          ),
                        ),
                        Text(
                          'Lugares más visitados',
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Intensión de alojamiento',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.primaryColor,
                  fontSize: 20,
                ),
              ),
              const Divider(color: Colors.grey, thickness: 1),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _initDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha inicio',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _initDateController.text =
                              picked.toIso8601String().split('T')[0];
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      readOnly: true,
                      controller: _endDateController,
                      decoration: const InputDecoration(
                        labelText: 'Fecha fin',
                        border: OutlineInputBorder(),
                        suffixIcon: Icon(Icons.calendar_today),
                      ),
                      onTap: () async {
                        DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate:
                              DateTime.now().add(const Duration(days: 1)),
                          firstDate: DateTime(2020),
                          lastDate: DateTime(2100),
                        );
                        if (picked != null) {
                          _endDateController.text =
                              picked.toIso8601String().split('T')[0];
                        }
                      },
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: TextFormField(
                      controller: _personsController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Personas',
                        border: OutlineInputBorder(),
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ListView.separated(
                padding: const EdgeInsets.symmetric(horizontal: 32),
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemBuilder: (context, i) {
                  return FutureBuilder<List<Uint8List>>(
                    future: _loadImages(houses[i].imagesIds),
                    builder: (context, snapshot) {
                      if (!snapshot.hasData) {
                        return const SizedBox.shrink();
                      }

                      return _buildCard(
                        house: houses[i],
                        imagesBytes: snapshot.data!,
                      );
                    },
                  );
                },
                separatorBuilder: (_, __) =>
                    const Divider(color: Colors.grey, thickness: 1),
                itemCount: houses.length,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCard({
    required House house,
    required List<Uint8List> imagesBytes,
  }) {
    return Container(
      padding: const EdgeInsets.only(right: 16),
      decoration: BoxDecoration(
          color: Colors.grey.shade200, borderRadius: BorderRadius.circular(12)),
      child: Row(
        children: [
          ImageCarousel(images: imagesBytes),
          const SizedBox(width: 16),
          Expanded(
              child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    house.name,
                    style: const TextStyle(
                        fontWeight: FontWeight.bold,
                        color: AppColors.primaryColor,
                        fontSize: 32),
                  ),
                  Spacer(),
                  if (house.price != null)
                    Text(
                      'PEN ${house.price} por noche',
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: AppColors.primaryColor,
                          fontSize: 24),
                    ),
                ],
              ),
              if (house.description != null)
                Text(
                  house.description!,
                  style: const TextStyle(color: Colors.grey),
                ),
              Row(
                children: [
                  Icon(Icons.place, color: Colors.grey),
                  Text(
                    house.place,
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.grey,
                      fontSize: 24,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: const [
                  _ServicioItem(icon: Icons.wifi, label: 'WiFi'),
                  _ServicioItem(icon: Icons.shower, label: 'Ducha caliente'),
                  _ServicioItem(icon: Icons.tv, label: 'TV'),
                  _ServicioItem(icon: Icons.ac_unit, label: 'Aire Acond.'),
                  _ServicioItem(icon: Icons.kitchen, label: 'Cocina'),
                  _ServicioItem(icon: Icons.local_parking, label: 'Parking'),
                ],
              ),
              SizedBox(height: 72),
              Align(
                alignment: Alignment.bottomRight,
                child: SizedBox(
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primaryColor,
                    ),
                    onPressed: () async {
                      showDialog(
                          context: context,
                          builder: (context) {
                            final init =
                                DateTime.parse(_initDateController.text);
                            final end = DateTime.parse(_endDateController.text);
                            final diff = end.difference(init).inDays;

                            return Dialog(
                              child: SizedBox(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      const Text('Confirmar reserva',
                                          style: TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 32,
                                            color: AppColors.primaryColor,
                                          )),
                                      const Divider(),
                                      const SizedBox(height: 16),
                                      Text('Desde: ${_initDateController.text}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 8),
                                      Text('Hasta: ${_endDateController.text}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Personas: ${_personsController.text}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 8),
                                      Text('Dias: $diff',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 8),
                                      Text('precio por noche: ${house.price!}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 8),
                                      Text(
                                          'Comision de Rent Experience (20%): ${(house.price! * diff) * 0.2}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 8),
                                      Text(
                                          'PRECIO TOTAL: ${house.price! * diff}',
                                          style: const TextStyle(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 16,
                                            color: AppColors.primaryColor,
                                          )),
                                      const SizedBox(height: 32),
                                      TextButton(
                                        onPressed: () async {
                                          final _repo =
                                              ReservationRepositryImpl();
                                          await _repo.createReservation(
                                            Reservation(
                                              userId: user!.userId,
                                              houseId: house.id!,
                                              initDate:
                                                  _initDateController.text,
                                              endDate: _endDateController.text,
                                              persons: int.parse(
                                                  _personsController.text),
                                            ),
                                          );
                                          Navigator.pop(context);
                                          ScaffoldMessenger.of(context)
                                              .showSnackBar(
                                            const SnackBar(
                                              content: Text(
                                                  'Intensión de reserva realizada con exito'),
                                              backgroundColor: Colors.green,
                                            ),
                                          );
                                        },
                                        child: Text('Confirmar'),
                                      )
                                    ]),
                              ),
                            );
                          });
                    },
                    child: const Text(
                      'Reservar',
                      style: TextStyle(
                        fontSize: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ))
        ],
      ),
    );
  }

  Future<List<Uint8List>> _loadImages(List<String>? imageIds) async {
    if (imageIds == null) return [];
    return Future.wait(imageIds.map((id) => getImageBytes(id)));
  }

  Future<Uint8List> getImageBytes(String fileId) async {
    final response = await AppwriteApiClient.storage.getFileView(
      bucketId: Constants.bucketHousesId,
      fileId: fileId,
    );
    return response;
  }
}

class ImageCarousel extends StatefulWidget {
  final List<Uint8List> images;

  const ImageCarousel({super.key, required this.images});

  @override
  State<ImageCarousel> createState() => _ImageCarouselState();
}

class _ImageCarouselState extends State<ImageCarousel> {
  late final PageController _controller;
  late final Timer _timer;
  int _currentPage = 0;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: 0);

    _timer = Timer.periodic(const Duration(seconds: 3), (_) {
      if (_controller.hasClients && widget.images.isNotEmpty) {
        _currentPage = (_currentPage + 1) % widget.images.length;
        _controller.animateToPage(
          _currentPage,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final containerWidth = screenWidth / 3;

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        width: containerWidth,
        height: 300,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
        child: PageView.builder(
          controller: _controller,
          itemCount: widget.images.length,
          itemBuilder: (context, index) {
            return Image.memory(
              widget.images[index],
              fit: BoxFit.cover,
              width: containerWidth,
              height: 200,
            );
          },
        ),
      ),
    );
  }
}

class _ServicioItem extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ServicioItem({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Icon(
          icon,
          size: 28,
          color: Colors.grey,
        ),
        SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey,
            fontWeight: FontWeight.w500,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
