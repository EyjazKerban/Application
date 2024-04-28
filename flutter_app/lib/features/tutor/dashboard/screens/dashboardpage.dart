import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_app/features/auth/services/auth_service.dart';
import 'package:flutter_app/features/tutor/test/services/test_service.dart';
import 'package:flutter_app/models/test.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter_app/models/user.dart';

class DashboardPage extends StatefulWidget {
  const DashboardPage({super.key});

  @override
  _DashboardPageState createState() => _DashboardPageState();
}

class _DashboardPageState extends State<DashboardPage> {
  List<Test> tests = [];
  bool isLoading = true, isScorerLoading = false;
  List<String> testNames = [];
  int currentIndex = 0; // Current test index
  User? highestScorer;
  User? lowestScorer;
  int? highestScore;
  int? lowestScore;

  List<PieChartSectionData> sections = [];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    try {
      List<Test> fetchedTests = await TestService.fetchTests(context);
      // Filter tests to include only those with non-empty results
      tests =
          fetchedTests.where((test) => test.testResults.isNotEmpty).toList();
      if (tests.isNotEmpty) {
        calculateSections(tests[0]);
        currentIndex = 0; // Reset to the first test after filtering
      }
      setState(() {
        isLoading = false;
      });
    } catch (e) {
      print("Failed to fetch tests: ${e.toString()}");
      setState(() {
        isLoading = false;
      });
    }
  }

  List<FlSpot> _getSpots() {
    List<FlSpot> spots = [];
    double index = 0;
    testNames = tests
        .map((test) => test.name)
        .toList(); // Direct mapping from tests to names

    for (var test in tests) {
      final total = test.testResults
          .fold<int>(0, (sum, item) => sum + int.parse(item.grade));
      final averageScore = total / test.testResults.length;
      final averagePercentage = (averageScore / test.total) * 100;
      spots.add(FlSpot(index, averagePercentage));
      index++;
    }
    return spots;
  }

  Future<void> calculateSections(Test test) async {
    setState(() {
      isScorerLoading = true;
    });
    int range1 = 0, range2 = 0, range3 = 0, range4 = 0;
    double tempHighestScore = -1;
    String highestScorerId = '';
    double tempLowestScore = 10000;
    String lowestScorerId = '';

    for (var result in test.testResults) {
      double score = double.parse(result.grade);
      double percentage = (score / test.total) * 100;

      if (percentage < 40) range1++;
      if (percentage < 60) range2++;
      if (percentage < 80) range3++;
      if (percentage >= 80) range4++;

      if (score > tempHighestScore) {
        tempHighestScore = score;
        highestScorerId = result.userID;
      }
      if (score < tempLowestScore) {
        tempLowestScore = score;
        lowestScorerId = result.userID;
      }
    }

    sections = [
      PieChartSectionData(
          value: range1.toDouble(),
          color: Colors.red,
          title: '$range1',
          radius: 50),
      PieChartSectionData(
          value: range2.toDouble(),
          color: Colors.orange,
          title: '$range2',
          radius: 50),
      PieChartSectionData(
          value: range3.toDouble(),
          color: Colors.yellow,
          title: '$range3',
          radius: 50),
      PieChartSectionData(
          value: range4.toDouble(),
          color: Colors.green,
          title: '$range4',
          radius: 50),
    ];
    highestScorer = await AuthService.fetchUserById(highestScorerId);
    lowestScorer = await AuthService.fetchUserById(lowestScorerId);
    setState(() {
      highestScore = tempHighestScore.toInt(); 
      lowestScore = tempLowestScore.toInt(); 
      isScorerLoading = false;
    });
  }

  void changeTest(int index) {
    if (index < 0 || index >= tests.length) return;
    currentIndex = index;
    calculateSections(tests[currentIndex]);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Dashboard",
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ), // Use the classroom name here
        centerTitle: true,
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      extendBodyBehindAppBar: true,
      body: Container(
        padding: const EdgeInsets.all(16),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              Color.fromARGB(255, 42, 166, 254),
              Color.fromARGB(255, 147, 223, 255),
              Color.fromARGB(255, 201, 236, 255),
            ],
          ),
        ),
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : tests.isEmpty
                ? const Center(child: Text("No test data available"))
                : Column(
                    children: [
                      const SizedBox(height: 60),
                      if (tests.isNotEmpty) LineChartContainer(),
                      const SizedBox(height: 40),
                      PieChartContainer(),
                    ],
                  ),
      ),
    );
  }

  Widget LineChartContainer() {
    List<FlSpot> spots = _getSpots();
    double minY = spots.isNotEmpty ? spots.map((s) => s.y).reduce(min) : 0;
    double maxY = spots.isNotEmpty ? spots.map((s) => s.y).reduce(max) : 100;

    return Container(
      height: MediaQuery.of(context).size.height * 0.3,
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Padding(
            padding: EdgeInsets.only(bottom: 8.0),
            child: Text(
              "Test Marks",
              style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black),
              textAlign: TextAlign.center,
            ),
          ),
          const SizedBox(height: 25),
          Expanded(
            child: LineChart(
              LineChartData(
                minY: calculateMinY(minY).toDouble(),
                maxY: calculateMaxY(maxY).toDouble(),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: true,
                  drawHorizontalLine: true,
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: Color.fromARGB(255, 147, 223, 255),
                      strokeWidth: 1,
                    );
                  },
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: Color.fromARGB(255, 147, 223, 255),
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 70,
                      getTitlesWidget: (value, meta) {
                        return Padding(
                          padding: const EdgeInsets.only(top: 50.0),
                          child: Transform.rotate(
                            angle: -90 * (3.14159 / 180),
                            child: Text(
                              testNames[value.toInt()],
                              style: const TextStyle(
                                  color: Colors.black, fontSize: 14),
                            ),
                          ),
                        );
                      },
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      reservedSize: 40,
                      interval: 10,
                      getTitlesWidget: (value, meta) =>
                          Text(value.toInt().toString()),
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(show: false),
                lineBarsData: [
                  LineChartBarData(
                    spots: spots,
                    isCurved: false,
                    barWidth: 2,
                    color: const Color.fromARGB(255, 21, 74, 133),
                    dotData: const FlDotData(show: true),
                  ),
                ],
                lineTouchData: LineTouchData(
                  enabled: true,
                  touchCallback:
                      (FlTouchEvent event, LineTouchResponse? touchResponse) {
                    if (touchResponse != null &&
                        touchResponse.lineBarSpots != null) {
                      int index = touchResponse.lineBarSpots!.first.x.toInt();
                      setState(() {
                        currentIndex = index;
                        calculateSections(tests[currentIndex]);
                      });
                    }
                  },
                  handleBuiltInTouches: true,
                  getTouchedSpotIndicator: (barData, indicators) {
                    return indicators.map((int index) {
                      return TouchedSpotIndicatorData(
                        const FlLine(color: Colors.blue, strokeWidth: 4),
                        FlDotData(
                          show: true,
                          getDotPainter: (spot, percent, barData, index) =>
                              FlDotCirclePainter(
                            radius: 5,
                            color: Colors.white,
                            strokeWidth: 5,
                            strokeColor: Colors.blue,
                          ),
                        ),
                      );
                    }).toList();
                  },
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget PieChartContainer() {
    return Center(
      child: Container(
        height: MediaQuery.of(context).size.height *
            0.50, // 50% of the screen height
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(tests[currentIndex].name,
                  style: const TextStyle(
                      fontSize: 20, fontWeight: FontWeight.bold)),
            ),
            Expanded(child: buildPieChart()),
            buildLegend(),
            scorerInfo(),
          ],
        ),
      ),
    );
  }

  Widget buildPieChart() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        IconButton(
            icon: const Icon(Icons.arrow_left),
            onPressed:
                currentIndex > 0 ? () => changeTest(currentIndex - 1) : null),
        Expanded(
          child: tests[currentIndex].testResults.isEmpty
              ? const Center(child: Text("No valid test results available"))
              : PieChart(PieChartData(
                  sections: sections, centerSpaceRadius: 30, sectionsSpace: 2)),
        ),
        IconButton(
            icon: const Icon(Icons.arrow_right),
            onPressed: currentIndex < tests.length - 1
                ? () => changeTest(currentIndex + 1)
                : null),
      ],
    );
  }

  Widget scorerInfo() {
    return SizedBox(
      height: 120, // Fixed height for scorer info
      child: isScorerLoading
          ? const Center(child: LinearProgressIndicator())
          : Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Highest Scorer: ${highestScorer?.firstname} ${highestScorer?.lastname} ($highestScore)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 52, 138, 55), fontSize: 18),
                ),
                Text(
                  'Lowest Scorer: ${lowestScorer?.firstname} ${lowestScorer?.lastname} ($lowestScore)',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                      color: Color.fromARGB(255, 184, 65, 57), fontSize: 18),
                ),
              ],
            ),
    );
  }

  Widget buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          _buildIndicator(color: Colors.red, text: '0-40%'),
          _buildIndicator(color: Colors.orange, text: '40-60%'),
          _buildIndicator(color: Colors.yellow, text: '60-80%'),
          _buildIndicator(color: Colors.green, text: '80-100%'),
        ],
      ),
    );
  }

  Widget _buildIndicator({required Color color, required String text}) {
    return Row(
      children: [
        CircleAvatar(radius: 5, backgroundColor: color),
        const SizedBox(width: 8),
        Text(text),
      ],
    );
  }

  int calculateMinY(double minY) {
    return (minY / 10).floor() * 10; // Round down to nearest multiple of 10
  }

  int calculateMaxY(double maxY) {
    return (maxY / 10).ceil() * 10; // Round up to nearest multiple of 10
  }
}
