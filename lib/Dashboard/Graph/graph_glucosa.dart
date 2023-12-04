import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:intl/intl.dart';

class LineChartWidget extends StatelessWidget {
  final String userId;

  const LineChartWidget({Key? key, required this.userId}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: ConstrainedBox(
          constraints: BoxConstraints(
            minWidth: MediaQuery.of(context).size.width * 0.953,
            maxWidth: MediaQuery.of(context).size.width * 0.953,
          ),
          child: FutureBuilder<QuerySnapshot>(
            future: FirebaseFirestore.instance
                .collection('users')
                .doc(userId)
                .collection('datos')
                .orderBy('timestamp')
                .get(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                // Muestra un indicador de carga mientras espera
                return Center(child: CircularProgressIndicator());
              }

              if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                return Center(
                  child: Text(
                    'No hay datos disponibles.\n\n¡Empieza tu seguimiento!',
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.red,
                    ),
                  ),
                );
              }

              List<FlSpot> spots = [];

              snapshot.data!.docs.reversed.take(10).where((doc) {
                var diferenciaMaxMinValue = doc['diferenciaMaxMinValue'];
                return diferenciaMaxMinValue != null &&
                    diferenciaMaxMinValue.isNotEmpty;
              }).forEach((doc) {
                Timestamp timestamp = doc['timestamp'];
                DateTime dateTime = timestamp.toDate();

                double xValue = dateTime.millisecondsSinceEpoch.toDouble();
                double yValue = double.parse(doc['diferenciaMaxMinValue']);
                spots.add(FlSpot(xValue, yValue));
              });

              return LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 32,
                      getTextStyles: (value, context) => const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                    ),
                    bottomTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 28,
                      margin: 10,
                      getTextStyles: (value, context) => const TextStyle(
                        color: Colors.grey,
                        fontSize: 14,
                      ),
                      getTitles: (value) {
                        DateTime dateTime =
                            DateTime.fromMillisecondsSinceEpoch(value.toInt());
                        final formatter = DateFormat('dd/MM', 'es');
                        return formatter.format(dateTime);
                      },
                      interval: 2500,
                    ),
                    rightTitles: SideTitles(showTitles: false),
                    topTitles: SideTitles(showTitles: false),
                  ),
                  borderData: FlBorderData(
                    show: true,
                    border:
                        Border.all(color: const Color(0xff37434d), width: 1),
                  ),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      belowBarData: BarAreaData(
                          show: true, colors: [Colors.teal.withOpacity(0.3)]),
                      colors: [Colors.blue],
                      barWidth: 4,
                      isStrokeCapRound: true,
                      dotData: FlDotData(show: false),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}
