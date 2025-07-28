import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';

import '../../../../../common/widgets/appbar/appbar.dart';
import '../../../../../utlis/constants/size.dart';

class StatisticsScreen extends StatelessWidget {
  const StatisticsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: CustomAppBar(title: 'Statistics'),
      body: SafeArea(
        child: Padding(
          padding:  EdgeInsets.symmetric( horizontal: AppSizes.defaultPaddingHorizontal,
            vertical: AppSizes.defaultPaddingVertical,),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Stats summary box
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFFEAF2FF),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Row(
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 60,
                          height: 60,
                          child: CircularProgressIndicator(
                            value: 0.46,
                            strokeWidth: 6,
                            backgroundColor: Colors.white,
                            valueColor: AlwaysStoppedAnimation(Colors.blue),
                          ),
                        ),
                        const Text("46%"),
                      ],
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text("Views", style: TextStyle(fontSize: 16)),
                          const SizedBox(height: 4),
                          Text("+25%", style: TextStyle(color: Colors.green)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Orders Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text("Orders", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  DropdownButton<String>(
                    value: "Weekly",
                    underline: const SizedBox(),
                    items: const [
                      DropdownMenuItem(value: "Weekly", child: Text("Weekly")),
                      DropdownMenuItem(value: "Monthly", child: Text("Monthly")),
                    ],
                    onChanged: (val) {},
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Orders Bar Chart
              SizedBox(
                height: 140,
                child: BarChart(
                  BarChartData(
                    alignment: BarChartAlignment.spaceAround,
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
                            return Text(days[value.toInt()]);
                          },
                          interval: 1,
                        ),
                      ),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    barGroups: List.generate(7, (i) {
                      final heights = [20, 10, 30, 25, 40, 35, 5];
                      return BarChartGroupData(x: i, barRods: [
                        BarChartRodData(
                          toY: heights[i].toDouble(),
                          color: Colors.blueAccent,
                          width: 16,
                          borderRadius: BorderRadius.circular(6),
                          gradient: const LinearGradient(
                            colors: [Colors.blueAccent, Colors.transparent],
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                          ),
                        ),
                      ]);
                    }),
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Revenue Section
              const Text("Revenue", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 12),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Weekly", style: TextStyle(color: Colors.grey)),
                  const SizedBox(width: 16),
                  const Text("Monthly", style: TextStyle(color: Colors.blue, fontWeight: FontWeight.bold)),
                  const SizedBox(width: 16),
                  Text("Yearly", style: TextStyle(color: Colors.grey)),
                ],
              ),

              const SizedBox(height: 12),

              // Line Chart
              SizedBox(
                height: 150,
                child: LineChart(
                  LineChartData(
                    titlesData: FlTitlesData(
                      bottomTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          getTitlesWidget: (value, meta) {
                            const months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
                            return Text(months[value.toInt()]);
                          },
                          interval: 1,
                        ),
                      ),
                      leftTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                      rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    ),
                    lineBarsData: [
                      LineChartBarData(
                        spots: const [
                          FlSpot(0, 250),
                          FlSpot(1, 400),
                          FlSpot(2, 700),
                          FlSpot(3, 300),
                          FlSpot(4, 320),
                          FlSpot(5, 270),
                        ],
                        isCurved: true,
                        color: Colors.blue,
                        barWidth: 3,
                        dotData: FlDotData(show: true),
                      ),
                    ],
                    gridData: FlGridData(show: false),
                    borderData: FlBorderData(show: false),
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
