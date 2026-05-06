import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  bool _showIntro = true;

  final User user = User(
    id: 1,
    email: "abdellibenazzouz@yahoo.com",
    name: "Abdelli Benazzouz",
  );

  final List<Map<String, String>> orders = [
    {
      "title": "Commande #1",
      "date": "12/01/2025",
      "total": "45€",
    },
    {
      "title": "Commande #2",
      "date": "20/01/2025",
      "total": "120€",
    },
  ];

  @override
  void initState() {
    super.initState();
    _loadIntroPreference();
  }

  Future<void> _loadIntroPreference() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _showIntro = prefs.getBool("showIntro") ?? true;
    });
  }

  Future<void> _disableIntro() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("showIntro", false);
    setState(() {
      _showIntro = false;
    });
  }

  void _logout(BuildContext context) {
    Navigator.pushReplacementNamed(context, "/login");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Profil")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              // Écran d’accueil / présentation
              if (_showIntro)
                Card(
                  color: Colors.deepPurple.shade50,
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Bienvenue 👋",
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 8),
                        const Text(
                          "Bienvenue dans votre espace personnel. "
                          "Vous pouvez consulter vos commandes et gérer votre compte.",
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            TextButton(
                              onPressed: _disableIntro,
                              child: const Text("Ne plus afficher"),
                            ),
                            TextButton(
                              onPressed: () {
                                setState(() {
                                  _showIntro = false;
                                });
                              },
                              child: const Text("Fermer"),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),

              const SizedBox(height: 20),

              // Profil utilisateur
              Center(
                child: Column(
                  children: [
                    const CircleAvatar(
                      radius: 40,
                      child: Icon(Icons.person, size: 40),
                    ),
                    const SizedBox(height: 10),
                    Text(user.name,
                        style: const TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    Text(user.email),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // Historique des achats
              const Text(
                "Historique des achats",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 10),

              ...orders.map((order) {
                return Card(
                  child: ListTile(
                    leading: const Icon(Icons.receipt_long),
                    title: Text(order["title"]!),
                    subtitle: Text(order["date"]!),
                    trailing: Text(order["total"]!),
                  ),
                );
              }).toList(),

              const SizedBox(height: 30),

              // Déconnexion
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: () => _logout(context),
                  icon: const Icon(Icons.logout),
                  label: const Text("Se déconnecter"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}