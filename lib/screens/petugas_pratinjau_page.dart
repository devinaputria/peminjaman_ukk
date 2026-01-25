import 'package:flutter/material.dart';

class PetugasPratinjauPage extends StatelessWidget {
  const PetugasPratinjauPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Pratinjau'),
        backgroundColor: Colors.blue,
      ),
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: 2,
        itemBuilder: (context, index) {
          return Card(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            margin: const EdgeInsets.only(bottom: 16),
            elevation: 3,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // USER
                  const Row(
                    children: [
                      Icon(Icons.person),
                      SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Depina',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('XII TPM 1'),
                        ],
                      )
                    ],
                  ),

                  const Divider(height: 24),

                  // ALAT & KATEGORI
                  const Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Alat',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Mesin Bor'),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Kategori',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                          Text('Mesin'),
                        ],
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: () {
                        // nanti isi API pengembalian
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Konfirmasi Pengembalian'),
                    ),
                  )
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
