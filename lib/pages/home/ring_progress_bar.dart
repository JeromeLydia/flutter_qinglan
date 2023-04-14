import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math';

class RingProgressBar extends StatefulWidget {
  /// 半径
  final double radius;

  /// 环颜色
  final Color? ringColor;

  /// 环背景颜色
  final Color? ringBgColor;

  /// 环中间文字
  final Color? textColor;

  /// 环中间文字大小
  final double? textSize;

  /// 环宽度
  final double strokeWidth;

  /// 是否显示环中间文本
  final bool isShowText;

  /// 环是否是倒计时，true：是倒计时，false：顺计时
  final bool? isCountDown;

  /// 计时截至值
  final int? maxProgress;

  final VoidCallback? callback;

  const RingProgressBar(
      {super.key,
      required this.radius,
      required this.strokeWidth,
      this.ringColor,
      this.ringBgColor,
      this.isShowText = false,
      this.textSize,
      this.textColor,
      this.isCountDown = true,
      this.maxProgress,
      this.callback});

  @override
  State<StatefulWidget> createState() => _RingProgressBarState();
}

class _RingProgressBarState extends State<RingProgressBar> {
  /// 进度条当前进度值
  double _value = 0;

  /// 进度条当前进度文本
  String _text = "0";

  /// 计时器
  Timer? timer;

  @override
  void initState() {
    super.initState();
    int count = 0;
    //计时器，每1毫秒执行一次
    const period = Duration(milliseconds: 1);
    timer = Timer.periodic(period, (timer) {
      count++;
      double max = (widget.maxProgress ?? 0) * 1000;
      //计时器结束条件
      if (widget.maxProgress == null ||
          widget.maxProgress == 0 ||
          count >= max) {
        timer.cancel();
        if (widget.callback != null) {
          //执行完成回调
          widget.callback!();
        }
      }
      //只有当widget状态为mounted时才执行setState防止内存泄露
      if (mounted) {
        setState(() {
          _value = count / max;
          _text = widget.isCountDown ?? true
              ? ((widget.maxProgress ?? 0) - (count ~/ 1000)).toString()
              : (count ~/ 1000).toString();
        });
      }
    });
  }

  @override
  void dispose() {
    //退出时关闭计时器防止内存泄露
    timer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        highlightColor: Colors.transparent,
        splashColor: Colors.transparent,
        onTap: () {
          if (widget.callback != null) {
            //点击控件回调
            widget.callback!();
          }
        },
        child: Container(
          width: widget.radius * 2,
          height: widget.radius * 2,
          color: Colors.transparent,
          child: Stack(
            alignment: Alignment.center,
            fit: StackFit.expand,
            children: [
              CustomPaint(
                size: Size(widget.radius * 2, widget.radius * 2),
                painter: _RingPrinter(this, _value),
              ),
              Center(
                widthFactor: widget.radius * 2,
                heightFactor: widget.radius * 2,
                child: widget.isShowText
                    ? Text(
                        _text,
                        style: TextStyle(
                            color: widget.textColor, fontSize: widget.textSize),
                      )
                    : Container(),
              ),
            ],
          ),
        ));
  }
}

class _RingPrinter extends CustomPainter {
  /// state对象
  final _RingProgressBarState state;

  /// 控制值:0.0->1.0，会控制绘制0.0*2*pi->1.0*2*pi即从0开始绘制一个完整的圆
  final double _value;

  _RingPrinter(this.state, this._value);

  @override
  void paint(Canvas canvas, Size size) {
    //画笔
    Paint paint = Paint()
      ..color = state.widget.ringColor ?? Colors.transparent
      ..style = PaintingStyle.stroke
      ..strokeWidth = state.widget.strokeWidth
      ..isAntiAlias = true;
    //圆心偏移值
    double offset = state.widget.radius;
    //以offset为圆形，画半径减边线宽度一半为半径的圆
    Rect rect = Rect.fromCircle(
        center: Offset(offset, offset),
        radius: state.widget.radius - state.widget.strokeWidth / 2);
    paint.color = state.widget.ringBgColor ?? Colors.grey;
    //画圆背景
    canvas.drawCircle(Offset(offset, offset),
        state.widget.radius - state.widget.strokeWidth / 2, paint);
    paint.color = state.widget.ringColor ?? Colors.blueAccent;
    //让边界有弧形过渡
    paint.strokeCap = StrokeCap.round;
    //画进度条
    canvas.drawArc(rect, -0.5 * pi, _value * 2 * pi, false, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) {
    return true;
  }
}
