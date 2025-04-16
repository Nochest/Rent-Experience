import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tesis_airbnb_web/theme/colors.dart';
import 'package:tesis_airbnb_web/widgets/sign_up_dialog.dart';

//TODO: REFACTOR TO WIX MODEL
class MainWebPage extends StatefulWidget {
  const MainWebPage({super.key});

  @override
  State<MainWebPage> createState() => _MainWebPageState();
}

class _MainWebPageState extends State<MainWebPage> {
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
                  SizedBox(height: 32),
                  GridView(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 3,
                      crossAxisSpacing: 8.0,
                      mainAxisSpacing: 8.0,
                      childAspectRatio: 4 / 3,
                    ),
                    children: [
                      _buildCard(
                        imageUrl:
                            'assets/background-main.jpg', // Reemplázalo con tu imagen
                        title: "Casa en la playa",
                        distance: "5 km",
                        dates: "02/10/2025 - 05/10/2025",
                        price: "S/ 150.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Apartamento en la ciudad",
                        distance: "1.2 km",
                        dates: "10/12/2025 - 12/12/2025",
                        price: "S/ 120.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Cabaña en la montaña",
                        distance: "15 km",
                        dates: "20/11/2025 - 22/11/2025",
                        price: "S/ 200.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Villa de lujo",
                        distance: "3.5 km",
                        dates: "05/01/2025 - 07/01/2025",
                        price: "S/ 350.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Estudio en el centro",
                        distance: "2 km",
                        dates: "08/02/2025 - 10/02/2025",
                        price: "S/ 90.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Departamento con vista al mar",
                        distance: "12 km",
                        dates: "15/08/2025 - 18/08/2025",
                        price: "S/ 250.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                      _buildCard(
                        imageUrl: 'assets/background-main.jpg',
                        title: "Loft moderno",
                        distance: "7 km",
                        dates: "22/09/2025 - 25/09/2025",
                        price: "S/ 180.00 por noche",
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCard({
    required String imageUrl,
    required String title,
    required String distance,
    required String dates,
    required String price,
  }) {
    return Card(
      margin: EdgeInsets.all(8.0),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width /
            4, // 1/4 del ancho de la pantalla
        child: Column(
          children: [
            // Imagen de la tarjeta
            ClipRRect(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(10), topRight: Radius.circular(10)),
              child: Image.asset(
                imageUrl,
                height: 150, // Alto de la imagen
                width: double.infinity,
                fit: BoxFit.cover,
              ),
            ),
            // Contenido de la tarjeta
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Título
                  Text(
                    title,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                  SizedBox(height: 4),
                  // Distancia
                  Text("Distancia: $distance", style: TextStyle(fontSize: 14)),
                  // Fechas
                  Text("Fechas: $dates", style: TextStyle(fontSize: 14)),
                  // Precio
                  Text(price, style: TextStyle(fontSize: 14)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
