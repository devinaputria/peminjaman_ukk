import 'package:flutter/material.dart';

class PetugasBerandaPage extends StatefulWidget {
  const PetugasBerandaPage({super.key});

  @override
  State<PetugasBerandaPage> createState() => _PetugasBerandaPageState();
}

class _PetugasBerandaPageState extends State<PetugasBerandaPage> {

  List<Map<String, String>> dataDummy = [
    {
      'nama': 'Depina',
      'kelas': 'XII TPM 1',
      'alat': 'Mesin Bor',
      'kategori': 'Mesin',
      'status': 'menunggu',
    },
    {
      'nama': 'Depina',
      'kelas': 'XII TPM 1',
      'alat': 'Mesin Bor',
      'kategori': 'Mesin',
      'status': 'menunggu',
    },
  ];

  void tolakPeminjaman(int index) {
    setState(() {
      dataDummy.removeAt(index);
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Peminjaman ditolak")),
    );
  }

  void setujuPeminjaman(int index) {
    setState(() {
      dataDummy[index]['status'] = 'disetujui';
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Peminjaman disetujui")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 248, 247, 242),

      body: dataDummy.isEmpty
          ? const Center(
              child: Text(
                "Belum ada pengajuan peminjaman",
                style: TextStyle(fontSize: 16),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: dataDummy.length,
              itemBuilder: (context, index) {
                final item = dataDummy[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 14),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
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

                        // ===== HEADER USER =====
                        Row(
                          children: [
                            const Icon(Icons.person, size: 28),

                            const SizedBox(width: 10),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  item['nama']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(item['kelas']!),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 10),

                        // ===== DETAIL ALAT =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Alat",
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                  item['alat']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),

                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Kategori",
                                    style: TextStyle(fontSize: 12)),
                                Text(
                                  item['kategori']!,
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),

                        const SizedBox(height: 12),

                        // ===== STATUS =====
                        Text(
                          "Status: ${item['status']}",
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: item['status'] == "disetujui"
                                ? Colors.green
                                : Colors.orange,
                          ),
                        ),

                        const SizedBox(height: 12),

                        // ===== TOMBOL =====
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [

                            OutlinedButton(
                              onPressed: () => tolakPeminjaman(index),
                              child: const Text("Tolak"),
                            ),

                            const SizedBox(width: 10),

                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2A5191),
                              ),
                              onPressed: () => setujuPeminjaman(index),
                              child: const Text("Setuju"),
                            ),
                          ],
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
