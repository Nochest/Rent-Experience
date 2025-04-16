import 'dart:developer';
import 'dart:convert';
import 'dart:html' as html;
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:go_router/go_router.dart';
import 'package:tesis_airbnb_web/data/appwrite_setting.dart';
import 'package:tesis_airbnb_web/models/house.dart';
import 'package:tesis_airbnb_web/models/user.dart';
import 'package:tesis_airbnb_web/repository/impl/house_repository_impl.dart';
import 'package:tesis_airbnb_web/theme/colors.dart';
import 'package:tesis_airbnb_web/ui/admin_views/review_house.dart';
import 'package:tesis_airbnb_web/ui/host_views/new_house.dart';
import 'package:tesis_airbnb_web/utils/cons.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  State<DashboardPage> createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  bool loading = false;

  User? user;
  List<Uint8List> imagenesSeleccionadas = [];
  List<House> houses = [];
  final nameController = TextEditingController();
  final placeController = TextEditingController();
  final houseRepository = HouseRepositoryImpl();

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
        final fetchedHouses = await houseRepository.getAllHouses();

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
        elevation: 4,
        actions: [
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
      body: loading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16.0),
              child: houses.isEmpty
                  ? const Center(
                      child: Text('No hay alojamientos registrados.'))
                  : ListView.builder(
                      itemCount: houses.length,
                      itemBuilder: (context, index) {
                        final house = houses[index];
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 8.0),
                          child: ListTile(
                            onTap: () {
                              showDialog(
                                context: context,
                                builder: (_) => VistaAlojamientoDialog(
                                  bucketId: Constants.bucketHousesId,
                                  house: house,
                                  onApproved: () async {
                                    setState(() {
                                      loading = true;
                                    });
                                    houses =
                                        await houseRepository.getAllHouses();
                                    setState(() {
                                      loading = false;
                                    });
                                  },
                                ),
                              );
                            },
                            leading: const Icon(Icons.home),
                            title: Text(house.name),
                            subtitle: Text(
                                'Tipo: ${house.type} - Ubicación: ${house.place}'),
                            trailing: Text(
                              house.status!,
                              style: TextStyle(
                                color: _getStatusColor(house.status!),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
    );
  }

  Color _getStatusColor(String status) {
    switch (status) {
      case 'pending':
        return Colors.amber;
      case 'aproved':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }
}
