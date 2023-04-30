import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_qinglan/ui/pages/home/home_controller.dart';
import 'package:get/get.dart';

import '../../../res/colors.dart';
import '../../../utils/date_util.dart';

class _CustomLineChart extends StatelessWidget {
  HomeController get controller => Get.find<HomeController>();

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeController>(
      initState: (_) => controller.dataSize,
      builder: (_) => LineChart(
        data,
        swapAnimationDuration: const Duration(milliseconds: 250),
      ),
    );
  }

  LineChartData get data => LineChartData(
        lineTouchData: lineTouchData,
        gridData: gridData,
        titlesData: titlesData,
        borderData: borderData,
        lineBarsData: lineBarsData,
        minX: 0,
        maxX: 6,
        maxY: 7,
        minY: 0,
      );

  LineTouchData get lineTouchData => LineTouchData(
        handleBuiltInTouches: true,
        touchTooltipData: LineTouchTooltipData(
          tooltipBgColor: Colors.blueGrey.withOpacity(0.8),
          getTooltipItems: (touchedSpots) => touchedSpots
              .map(
                (LineBarSpot touchedSpot) => LineTooltipItem(
                  "${touchedSpot.y * 50}${(touchedSpot.barIndex == 2 ? "℃" : touchedSpot.barIndex == 1 ? "A" : "V")}",
                  const TextStyle(color: Colors.white),
                ),
              )
              .toList(),
        ),
      );

  FlTitlesData get titlesData => FlTitlesData(
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

  List<LineChartBarData> get lineBarsData => [
        lineChartBarData1_1,
        lineChartBarData1_2,
        lineChartBarData1_3,
      ];

  Widget leftTitleWidgets(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      fontSize: 10,
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
      fontSize: 10,
    );

    if (controller.mapList.isNotEmpty) {
      String text;
      var keys = controller.mapList.keys.toList();
      if (keys.length > value.toInt()) {
        if (keys.length > 7) {
          keys = keys.sublist(keys.length - 7, keys.length);
        }
        text = DateUtil.getFormatDataString(keys[value.toInt()], "HH:mm:ss");
      } else {
        return Container();
      }
      return SideTitleWidget(
        axisSide: meta.axisSide,
        space: 10,
        child: Text(text, style: style),
      );
    } else {
      return Container();
    }
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
        spots: getVArray(),
      );

  getVArray() {
    var data = <FlSpot>[];
    if (controller.mapList.isNotEmpty) {
      var list = controller.mapList.values.toList();
      if (list.length > 7) {
        list = list.sublist(list.length - 7, list.length);
      }
      for (var i = 0; i < list.length; i++) {
        data.add(FlSpot(i.toDouble(), list[i].voltage / 50));
      }
    }
    return data;
  }

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
        spots: getAArray(),
      );

  getAArray() {
    var data = <FlSpot>[];
    if (controller.mapList.isNotEmpty) {
      var list = controller.mapList.values.toList();
      if (list.length > 7) {
        list = list.sublist(list.length - 7, list.length);
      }
      for (var i = 0; i < list.length; i++) {
        data.add(FlSpot(i.toDouble(), list[i].current / 50));
      }
    }
    return data;
  }

  LineChartBarData get lineChartBarData1_3 => LineChartBarData(
        isCurved: true,
        color: AppColors.contentColorCyan,
        barWidth: 2,
        isStrokeCapRound: true,
        dotData: FlDotData(show: false),
        belowBarData: BarAreaData(show: false),
        spots: getTArray(),
      );

  getTArray() {
    var data = <FlSpot>[];
    if (controller.mapList.isNotEmpty) {
      var list = controller.mapList.values.toList();
      if (list.length > 7) {
        list = list.sublist(list.length - 7, list.length);
      }
      for (var i = 0; i < list.length; i++) {
        data.add(FlSpot(i.toDouble(), list[i].temperature / 50));
      }
    }
    return data;
  }
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
              Expanded(
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
