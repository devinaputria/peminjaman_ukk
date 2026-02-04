import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'petugas_laporan_page.dart'; // pastikan file laporan sudah dibuat

class PetugasPratinjauPage extends StatefulWidget {
  const PetugasPratinjauPage({super.key});

  @override
  State<PetugasPratinjauPage> createState() => _PetugasPratinjauPageState();
}

class _PetugasPratinjauPageState extends State<PetugasPratinjauPage> {
  // ===== DATA DUMMY =====
  List<Map<String, dynamic>> peminjamanList = [
    {
      'kode': 'PMJ001',
      'namaAlat': 'Mesin Bor',
      'namaUser': 'Andi',
      'status': 'Pengembalian',
      'tglPinjam': DateTime(2026, 2, 1),
      'tglKembali': DateTime(2026, 2, 3),
      'tglPengembalian': DateTime(2026, 2, 5),
      'dendaPerHari': 5000,
      'dendaPerHariManual': 5000,
    },
    {
      'kode': 'PMJ002',
      'namaAlat': 'Gerinda',
      'namaUser': 'Budi',
      'status': 'Dipinjam',
      'tglPinjam': DateTime(2026, 2, 2),
      'tglKembali': DateTime(2026, 2, 4),
      'tglPengembalian': null,
      'dendaPerHari': 5000,
      'dendaPerHariManual': 5000,
    },
  ];

  // ===== WARNA STATUS =====
  Color warnaStatus(String status) {
    if (status == 'Pengembalian') return Colors.orange;
    if (status == 'Dipinjam') return Colors.blue;
    if (status == 'Dikembalikan') return Colors.green;
    return Colors.grey;
  }

  // ===== FORMAT TANGGAL =====
  String formatTanggal(DateTime? tgl) {
    if (tgl == null) return "-";
    return DateFormat("dd-MM-yyyy").format(tgl);
  }

  // ===== HITUNG HARI TERLAMBAT =====
  int hitungHariTerlambat(Map<String, dynamic> item) {
    if (item['tglPengembalian'] == null) return 0;
    int selisih = item['tglPengembalian'].difference(item['tglKembali']).inDays;
    return selisih > 0 ? selisih : 0;
  }

  // ===== HITUNG TOTAL DENDA BERDASARKAN MANUAL INPUT =====
  int totalDenda(Map<String, dynamic> item) {
    int dendaPerHari = item['dendaPerHariManual'] is int
        ? item['dendaPerHariManual']
        : int.tryParse(item['dendaPerHariManual']?.toString() ?? '0') ?? 0;
    int hariTerlambat = hitungHariTerlambat(item);
    return dendaPerHari * hariTerlambat;
  }

  // ===== DETAIL & KONFIRMASI =====
  void bukaDetail(Map<String, dynamic> item) {
    final dendaController =
        TextEditingController(text: item['dendaPerHariManual'].toString());

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text("Detail Pengembalian"),
        content: StatefulBuilder(
          builder: (context, setStateDialog) => Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text("Kode: ${item['kode']}"),
              Text("Alat: ${item['namaAlat']}"),
              Text("User: ${item['namaUser']}"),
              Text("Tanggal Pinjam: ${formatTanggal(item['tglPinjam'])}"),
              Text("Tanggal Kembali: ${formatTanggal(item['tglKembali'])}"),
              Text(
                  "Tanggal Dikembalikan: ${formatTanggal(item['tglPengembalian'])}"),
              const SizedBox(height: 10),

              // Input Denda Per Hari Manual
              TextField(
                controller: dendaController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Denda Per Hari (Rp)',
                  border: OutlineInputBorder(),
                ),
                onChanged: (val) {
                  setStateDialog(() {
                    item['dendaPerHariManual'] = int.tryParse(val) ?? 0;
                  });
                },
              ),

              const SizedBox(height: 10),

              // Total Denda Otomatis
              Text(
                "Total Denda: Rp ${totalDenda(item)}",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: totalDenda(item) > 0 ? Colors.red : Colors.green,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Tutup")),
          if (item['status'] == 'Pengembalian')
            ElevatedButton(
              onPressed: () {
                setState(() {
                  item['status'] = 'Dikembalikan';
                  if (item['tglPengembalian'] == null) {
                    item['tglPengembalian'] = DateTime.now();
                  }
                });
                Navigator.pop(context);

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                      content: Text(totalDenda(item) > 0
                          ? "Dikembalikan (Total Denda: Rp ${totalDenda(item)})"
                          : "Dikembalikan")),
                );

                // Navigasi ke halaman laporan
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (_) => const PetugasLaporanPage()));
              },
              child: const Text("Konfirmasi"),
            ),
        ],
      ),
    );
  }

  // ===== UI =====
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: peminjamanList.length,
        itemBuilder: (context, index) {
          final item = peminjamanList[index];
          final statusColor = warnaStatus(item['status']);
          final denda = totalDenda(item);

          return Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            margin: const EdgeInsets.only(bottom: 14),
            elevation: 3,
            child: ListTile(
              onTap: () => bukaDetail(item),
              leading: CircleAvatar(
                backgroundColor: statusColor.withOpacity(0.2),
                child: Icon(Icons.inventory, color: statusColor),
              ),
              title: Text(item['kode'],
                  style: const TextStyle(fontWeight: FontWeight.bold)),
              subtitle: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Alat: ${item['namaAlat']}'),
                  Text('User: ${item['namaUser']}'),
                  Text('Total Denda: Rp $denda',
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: denda > 0 ? Colors.red : Colors.green)),
                ],
              ),
              trailing: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                    color: statusColor.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12)),
                child: Text(item['status'],
                    style: TextStyle(
                        color: statusColor, fontWeight: FontWeight.bold)),
              ),
            ),
          );
        },
      ),
    );
  }
}
