import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ProfilePage(),
    );
  }
}

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xff7fb7a4),
        elevation: 0,
        actions: const [
          Icon(Icons.settings),
          SizedBox(width: 15),
          Icon(Icons.share),
          SizedBox(width: 15),
        ],
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [

            Container(
              color: const Color(0xff7fb7a4),
              padding: const EdgeInsets.all(20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  const CircleAvatar(
                    radius: 40,
                    backgroundColor: Color(0xffe7a6c5),
                    child: Icon(
                      Icons.person,
                      size: 45,
                      color: Colors.black,
                    ),
                  ),

                  const SizedBox(width: 15),

                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Text(
                          "Zara Larsson",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),

                        SizedBox(height: 10),

                        Text(
                          "Sou Zara Larsson, cantora pop sueca. "
                          "Comecei minha carreira aos dez anos "
                          "vencendo um show de talentos, alcancei "
                          "sucesso global com hits como 'Lush Life' "
                          "e hoje uso minha voz tanto para a música "
                          "quanto para a defesa dos direitos das mulheres.",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),

            const SizedBox(height: 20),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 25),
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xff7fb7a4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [

                  IconCard(icon: Icons.favorite_border),
                  IconCard(icon: Icons.person_outline),
                  IconCard(icon: Icons.star_border),

                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              width: 280,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xff7fb7a4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text("• Cantora", style: TextStyle(fontSize: 26)),
                  Text("• Suécia", style: TextStyle(fontSize: 26)),
                  Text("• Bilíngue", style: TextStyle(fontSize: 26)),
                  Text("• Bioquímica", style: TextStyle(fontSize: 26)),
                  Text("• midnight sun", style: TextStyle(fontSize: 26)),

                ],
              ),
            ),

            const SizedBox(height: 25),

            Container(
              margin: const EdgeInsets.symmetric(horizontal: 40),
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                color: const Color(0xff7fb7a4),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [

                  Icon(Icons.music_note, size: 35),
                  Icon(Icons.audiotrack, size: 35),
                  Icon(Icons.close, size: 35),

                ],
              ),
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),

      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Color(0xff7fb7a4),
        type: BottomNavigationBarType.fixed,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        items: [

          BottomNavigationBarItem(
            icon: Icon(Icons.menu),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.share),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: "",
          ),

          BottomNavigationBarItem(
            icon: Icon(Icons.calendar_today),
            label: "",
          ),
        ],
      ),
    );
  }
}

class IconCard extends StatelessWidget {
  final IconData icon;

  const IconCard({super.key, required this.icon});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 80,
      height: 80,
      decoration: BoxDecoration(
        color: const Color(0xff3a9b78),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        icon,
        size: 35,
        color: Colors.black,
      ),
    );
  }
}