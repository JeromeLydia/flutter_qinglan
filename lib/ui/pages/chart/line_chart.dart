import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

import '../../../res/colors.dart';

class _CustomLineChart extends StatelessWidget {
  const _CustomLineChart();

  @override
  Widget build(BuildContext context) {
    return LineChart(
      data,
      swapAnimationDuration: const Duration(milliseconds: 250),
    );
  }

  LineChartData get data => LineChartData(
        lineTouchData: lineTouchData1,
        gridData: gridData,
        titlesData: titlesData1,
        borderData: borderData,
        lineBarsData: lineBarsData1,
        minX: 0,
        maxX: 6,
        maxY: 7,
        minY: 0,
      );

  LineTouchData get lineTouchData1 => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
        ),
      );

  FlTitlesData get titlesData1 => FlTitlesData(
        bottomTitles: AxisTitles(
          sideTitles: bottomTitles,
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        leftTitles: AxisTitles(
          sideTitles: leftTitles(),
        ),
      );

  List<LineChartBarData> get lineBarsData1 => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text;
    switch (value.toInt()) {
      case 0:
        text = '0';
        break;
      case 1:
        text = '50';
        break;
      case 2:
        text = '100';
        break;
      case 3:
        text = '150';
        break;
      case 4:
        text = '200';
        break;
      case 5:
        text = '250';
        break;
      case 6:
        text = '300';
        break;
      default:
        return Container();
    }

    return Text(text, style: style, textAlign: TextAlign.center);
  }

  SideTitles leftTitles() => SideTitles(
        getTitlesWidget: leftTitleWidgets,
        showTitles: true,
        interval: 1,
        reservedSize: 40,
      );

  Widget bottomTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 16,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('01', style: style);
        break;
      case 1:
        text = const Text('02', style: style);
        break;
      case 2:
        text = const Text('03', style: style);
        break;
      case 3:
        text = const Text('04', style: style);
        break;
      case 4:
        text = const Text('05', style: style);
        break;
      case 5:
        text = const Text('06', style: style);
        break;
      case 6:
        text = const Text('07', style: style);
        break;
      default:
        text = const Text('');
        break;
    }

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 10,
      child: text,
    );
  }

  SideTitles get bottomTitles => SideTitles(
        showTitles: true,
        reservedSize: 32,
        interval: 1,
        getTitlesWidget: bottomTitleWidgets,
      );

  FlGridData get gridData => FlGridData(
        show: true,
        drawVerticalLine: true,
        horizontalInterval: 1,
        verticalInterval: 1,
        getDrawingHorizontalLine: (value) {
          return FlLine(
            color: AppColors.contentColorWhite,
            strokeWidth: 0.3,
          );
        },
        getDrawingVerticalLine: (value) {
          return FlLine(
            color: AppColors.contentColorWhite,
            strokeWidth: 0.3,
          );
        },
      );

  FlBorderData get borderData => FlBorderData(
        show: true,
        border: Border.all(color: const Color(0xff37434d)),
      );

  LineChartBarData get lineChartBarData1_1 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorGreen,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(0, 1),
          FlSpot(1, 1.5),
          FlSpot(2, 1.4),
          FlSpot(3, 3.4),
          FlSpot(4, 2),
          FlSpot(5, 2.2),
          FlSpot(6, 1.8),
        ],
      );

  LineChartBarData get lineChartBarData1_2 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorPink,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(
          show: false,
          color: AppColors.contentColorPink.withOpacity(0),
        ),
        spots: const [
          FlSpot(0, 1),
          FlSpot(1, 2.8),
          FlSpot(2, 1.2),
          FlSpot(3, 2.8),
          FlSpot(4, 2.6),
          FlSpot(5, 3.9),
        ],
      );

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorCyan,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: const [
          FlSpot(0, 2.8),
          FlSpot(1, 1.9),
          FlSpot(2, 3),
          FlSpot(3, 1.3),
          FlSpot(4, 2.5),
        ],
      );
}

class ChartItem extends StatefulWidget {
  const ChartItem({super.key});

  @override
  State<StatefulWidget> createState() => ChartItemState();
}

class ChartItemState extends State<ChartItem> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1.23,
      child: Stack(
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Container(
                    width: 25.0,
                    height: 10,
                    color: AppColors.contentColorGreen,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                  ),
                  const Text("电压"),
                  Container(
                    width: 25.0,
                    height: 10,
                    color: AppColors.contentColorPink,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                  ),
                  const Text("电流"),
                  Container(
                    width: 25.0,
                    height: 10,
                    color: AppColors.contentColorCyan,
                    margin: const EdgeInsets.only(left: 10, right: 10),
                  ),
                  const Text("温度"),
                  const SizedBox(width: 15),
                ],
              ),
              const SizedBox(
                height: 17,
              ),
              const Expanded(
                child: Padding(
                  padding: EdgeInsets.only(right: 16, left: 6),
                  child: _CustomLineChart(),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
