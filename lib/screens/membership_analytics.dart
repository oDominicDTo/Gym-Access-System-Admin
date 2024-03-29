import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

import '../main.dart';

class MembershipStatusChartPage extends StatefulWidget {
  const MembershipStatusChartPage({super.key});

  @override
  State createState() =>
      _MembershipStatusChartPageState();
}

class _MembershipStatusChartPageState extends State<MembershipStatusChartPage> {
  Map<String, Map<String, int>> membershipStatusData = {};

  @override
  void initState() {
    super.initState();
    fetchMembershipStatusData();
  }

  Future<void> fetchMembershipStatusData() async {
    final data = await objectbox.getMembershipStatusData();
    setState(() {
      membershipStatusData = data;
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Membership Status Chart'),
      ),
      body: membershipStatusData.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : SfCartesianChart(
        primaryXAxis: const CategoryAxis(),
        series: _getChartSeries(),
        legend: const Legend(isVisible: true),
      ),
    );
  }

  List<ColumnSeries<Map<String, String>, String>> _getChartSeries() {
    final List<ColumnSeries<Map<String, String>, String>> chartSeries = [];

    // Extract the status types (Active, Expired, Inactive)
    final statusTypes = membershipStatusData.values.first.keys.toList();

    for (var statusType in statusTypes) {
      final List<Map<String, String>> chartData = [];

      membershipStatusData.forEach((typeName, statusMap) {
        // Extract the count for the specific status type
        final count = statusMap[statusType] ?? 0;

        chartData.add({'Type': typeName, 'Status': count.toString()});
      });

      chartSeries.add(ColumnSeries<Map<String, String>, String>(
        dataSource: chartData,
        xValueMapper: (Map<String, String> data, _) => data['Type']!,
        yValueMapper: (Map<String, String> data, _) => int.parse(data['Status']!),
        name: statusType,
      ));
    }

    return chartSeries;
  }

}
