// ignore_for_file: use_super_parameters

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HistorialRegistro extends StatefulWidget {
  const HistorialRegistro({Key? key}) : super(key: key);

  @override
  State<HistorialRegistro> createState() => _HistorialRegistroState();
}

class _HistorialRegistroState extends State<HistorialRegistro> {
  final List<Map<String, String>> registros = [
    {'fecha': '2024-01-01'},
    {'fecha': '2024-01-02'},
    {'fecha': '2024-01-03'},
    {'fecha': '2024-01-04'},
  ];
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color.fromARGB(255, 46, 46, 46),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              size: 31,
              color: Colors.white,
            ),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: Text(
                  "Historial",
                  style: GoogleFonts.nunitoSans(
                    color: Colors.white,
                    fontSize: 23,
                  ),
                ),
              ),
            ],
          ),
        ),
        body: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          decoration: const BoxDecoration(
            color: (Color.fromRGBO(242, 242, 242, 0.753)),
          ),
          child: SingleChildScrollView(
            child: Table(
              border: const TableBorder(
                horizontalInside: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                verticalInside: BorderSide(
                  width: 5.0,
                  color: Colors.white,
                  style: BorderStyle.solid,
                ),
                top: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                bottom: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                left: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
                right: BorderSide(
                  width: 2.0,
                  color: Colors.transparent,
                  style: BorderStyle.solid,
                ),
              ),
              columnWidths: const <int, TableColumnWidth>{
                0: FlexColumnWidth(1),
                1: FlexColumnWidth(4),
              },
              defaultVerticalAlignment: TableCellVerticalAlignment.middle,
              children: [
                // Header Row
                TableRow(
                  decoration: BoxDecoration(
                    color: Colors.grey[600],
                  ),
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'No.',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Center(
                        child: Text(
                          'Fecha de registro',
                          style: GoogleFonts.nunitoSans(
                            color: Colors.white,
                            fontSize: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                // Data Rows
                ...registros.asMap().entries.map((entry) {
                  int idx = entry.key;
                  String fecha = entry.value['fecha']!;
                  return TableRow(
                    decoration: BoxDecoration(
                      color: idx % 2 == 0 ? Colors.white : Colors.grey[500],
                    ),
                    children: [
                      Center(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text(
                            (idx + 1).toString(),
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 25.0, top: 12.0),
                        child: SizedBox(
                          height: 40, // Specify the desired height
                          child: Text(
                            fecha,
                            style: GoogleFonts.nunitoSans(
                              color: Colors.black,
                              fontSize: 22,
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
