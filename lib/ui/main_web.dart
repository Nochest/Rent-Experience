import 'dart:async';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/house.dart';
import 'package:tesis_airbnb_web/repository/impl/house_repository_impl.dart';
import 'package:tesis_airbnb_web/theme/colors.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';
import 'package:tesis_airbnb_web/widgets/sign_up_dialog.dart';

class MainWebPage extends StatefulWidget {
  const MainWebPage({super.key});

  @override
  State<MainWebPage> createState() => _MainWebPageState();
}

class _MainWebPageState extends State<MainWebPage> {
  bool loading = false;
  List<House> houses = [];
  final houseRepository = HouseRepositoryImpl();

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance.addPostFrameCallback((_) async {
      setState(() {
        loading = true;
      });

      final fetchedHouses = await houseRepository.getApprovedHouses();

      setState(() {
        houses = fetchedHouses;
        loading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Rent Experience',
          style: TextStyle(
            fontWeight: FontWeight.bold,
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
            onPressed: () => showDialog(
                context: context, builder: (context) => RegisterDialog()),
            child: Text(
              'Registrate!',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          SizedBox(width: 8),
          TextButton(
            onPressed: () => context.go('/login'),
            child: Text(
              'Iniciar Sesión',
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
        child: Column(
          mainAxisSize: MainAxisSize.min,
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
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 113, 174, 214),
                borderRadius: BorderRadius.circular(5),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 120, vertical: 16),
              margin: const EdgeInsets.all(16.0),
              child: Column(
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
            ),
            Column(
              children: [
                SizedBox(height: 32),
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
          ],
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
