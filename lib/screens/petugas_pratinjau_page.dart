import 'package:flutter/material.dart';

class PetugasPratinjauPage extends StatefulWidget {
  const PetugasPratinjauPage({super.key});

  @override
  State<PetugasPratinjauPage> createState() => _PetugasPratinjauPageState();
}

class _PetugasPratinjauPageState extends State<PetugasPratinjauPage> {

  List<Map<String, String>> dataKembali = [
    {'barang': 'Mesin Bor', 'oleh': 'Andi', 'status': 'Pengembalian'},
    {'barang': 'Gerinda', 'oleh': 'Budi', 'status': 'Dipinjam'},
    {'barang': 'Obeng Set', 'oleh': 'Cici', 'status': 'Pengembalian'},
  ];

  Color warnaStatus(String status) {
    if (status == "Pengembalian") {
      return Colors.orange;
    } else {
      return Colors.blue;
    }
  }

  // ===== FUNGSI KONFIRMASI =====
  void konfirmasi(int index) {
    setState(() {
      dataKembali.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pengembalian dikonfirmasi")),
    );

    // NANTI:
    // → kirim ke halaman laporan (status = Dikembalikan)
  }

  // ===== FUNGSI TOLAK =====
  void tolak(int index) {
    setState(() {
      dataKembali[index]['status'] = "Dipinjam";
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pengembalian ditolak")),
    );

    // NANTI:
    // → balikin ke status dipinjam
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),

      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: dataKembali.length,
        itemBuilder: (context, index) {
          final item = dataKembali[index];

          return Container(
            margin: const EdgeInsets.only(bottom: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                )
              ],
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
                      color: warnaStatus(item['status']!),
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
                          onPressed: () => konfirmasi(index),
                          child: const Text("Konfirmasi"),
                        ),

                        const SizedBox(width: 8),

                        ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          onPressed: () => tolak(index),
                          child: const Text("Tolak"),
                        ),
                      ],
                    ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
