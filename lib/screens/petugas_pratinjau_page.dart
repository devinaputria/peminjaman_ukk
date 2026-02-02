//pratinjau petugas
import 'package:flutter/material.dart';

class PetugasPratinjauPage extends StatelessWidget {
  const PetugasPratinjauPage({super.key});

  // Dummy data hanya 3 field
  final List<Map<String, String>> dataKembali = const [
    {'barang': 'Mesin Bor', 'oleh': 'Andi', 'status': 'Pengembalian'},
    {'barang': 'Gerinda', 'oleh': 'Budi', 'status': 'Dipinjam'},
    {'barang': 'Obeng Set', 'oleh': 'Cici', 'status': 'Pengembalian'},
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(12),
      itemCount: dataKembali.length,
      itemBuilder: (context, index) {
        final item = dataKembali[index];

        return Card(
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item['barang']!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text("Dipinjam oleh: ${item['oleh']}"),

                const SizedBox(height: 6),

                Text(
                  "Status: ${item['status']}",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: item['status'] == "Pengembalian"
                        ? Colors.orange
                        : Colors.blue,
                  ),
                ),

                const SizedBox(height: 10),

                if (item['status'] == "Pengembalian")
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.green,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pengembalian dikonfirmasi"),
                            ),
                          );
                        },
                        child: const Text("Konfirmasi"),
                      ),

                      const SizedBox(width: 8),

                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                        onPressed: () {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text("Pengembalian ditolak"),
                            ),
                          );
                        },
                        child: const Text("Tolak"),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
