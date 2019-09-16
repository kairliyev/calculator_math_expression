import 'package:flutter/material.dart';
import 'dart:ui';
import 'dart:math';
import 'package:meta/meta.dart';

class CustomPlot extends StatelessWidget {
  final double height = 300;
  final List<Point> data;

  final PlotStyle style = new PlotStyle(
    axisStrokeWidth: 2.0,
    pointRadius: 3.0,
    outlineRadius: 1.0,
    primary: Colors.yellow,
    secondary: Colors.red,
    axis: Colors.blueGrey[600],
    gridline: Colors.blueGrey[100],
  );

  final Offset gridSize = new Offset(5.0, 5.0);

  final EdgeInsets padding = EdgeInsets.all(5);

  CustomPlot({
    @required this.data,
  });

  @override
  Widget build(BuildContext context) {
    return new Container(
      height: this.height,
      padding: this.padding,
      alignment: Alignment.center,
      child: new CustomPaint(
        size: Size.infinite,
        painter: new _PlotPainter(
          points: this.data,
          style: this.style,
          gridSize: this.gridSize,
        ),
      ),
    );
  }
}

class _PlotPainter extends CustomPainter {
  double get PI => 3.14;
  final List<Point> points;
  final PlotStyle style;
  final Offset gridSize;

  double minX, maxX, minY, maxY, windowWidth, windowHeight;

  _PlotPainter({
    this.points,
    this.style,
    this.gridSize,
  }) : super() {
    assert(this.points != null && points.length > 0);
    this.points.sort((a, b) => a.x.compareTo(b.x));
    minX =
        (this.points.first.x > 0.0) ? 0.0 : this.points.first.x - gridSize.dx;
    maxX = (this.points.last.x < 0.0) ? 0.0 : this.points.last.x + gridSize.dx;
    this.points.sort((a, b) => a.y.compareTo(b.y));
    minY =
        (this.points.first.y > 0.0) ? 0.0 : this.points.first.y - gridSize.dy;
    maxY = (this.points.last.y < 0.0) ? 0.0 : this.points.last.y + gridSize.dy;
    windowWidth = maxX.abs() + minX.abs();
    windowHeight = maxY.abs() + minY.abs();
  }

  @override
  void paint(Canvas canvas, Size size) {
    Offset origin = _scalePoint(const Point(0.0, 0.0), size);

    int xGridlineCount = (windowWidth / gridSize.dx).round();
    int yGridlineCount = (windowHeight / gridSize.dy).round();

    Paint gridPaint = new Paint();
    gridPaint.color = style.gridline ?? const Color(0x000000);
    gridPaint.style = PaintingStyle.stroke;
    gridPaint.strokeWidth = 1.0;

    for (int i = 0; i < xGridlineCount; i += 1) {
      drawLineAndLabel(double j) {
        Offset start = _scalePoint(new Point(j, 0), size);
        _drawXLabel((j).toString(), canvas, start.dx, origin.dy, size);
        if (style.gridline != null) {
          canvas.drawLine(new Offset(start.dx, 0.0),
              new Offset(start.dx, size.height), gridPaint);
        }
      }

      double x = i * gridSize.dx;
      if (-x >= minX && -x < 0) drawLineAndLabel(-x);
      if (x <= maxX && x >= 0) drawLineAndLabel(x);
    }

    for (int i = 0; i < yGridlineCount; i += 1) {
      drawLineAndLabel(double j) {
        Offset start = _scalePoint(new Point(minX, j), size);
        _drawYLabel((j).toString(), canvas, origin.dx, start.dy, size);
        if (style.gridline != null) {
          canvas.drawLine(new Offset(0.0, start.dy),
              new Offset(size.width, start.dy), gridPaint);
        }
      }

      double y = i * gridSize.dy;
      if (-y >= minY && -y < 0) drawLineAndLabel(-y);
      if (y <= maxY && y >= 0) drawLineAndLabel(y);
    }

    if (style.axis != null) {
      Paint axisPaint = new Paint();
      axisPaint.color = style.axis;
      axisPaint.style = PaintingStyle.stroke;
      axisPaint.strokeWidth = style.axisStrokeWidth;
      canvas.drawLine(new Offset(0.0, origin.dy),
          new Offset(size.width, origin.dy), axisPaint);
      canvas.drawLine(new Offset(origin.dx, 0.0),
          new Offset(origin.dx, size.height), axisPaint);
    }

    Paint circlePaint = new Paint();
    circlePaint.color = style.primary;
    circlePaint.style = PaintingStyle.fill;
    Paint outlinePaint = new Paint();
    outlinePaint.color = style.secondary;
    outlinePaint.style = PaintingStyle.stroke;
    outlinePaint.strokeWidth = style.outlineRadius;
    this.points.forEach((Point p) {
      Offset point = _scalePoint(p, size);
      canvas.drawCircle(point, style.pointRadius, circlePaint);
      if (style.outlineRadius > 0.0) {
        canvas.drawCircle(point, style.pointRadius, outlinePaint);
      }
    });
  }

  bool shouldRepaint(_PlotPainter oldDelegate) => true;

  Offset _scalePoint(Point p, Size size) {
    double scaledX = (size.width * (p.x - minX)) / (maxX - minX);
    double scaledY = size.height - (size.height * (p.y - minY)) / (maxY - minY);
    return new Offset(scaledX, scaledY);
  }

  void _drawXLabel(String text, Canvas canvas, double x, double y, Size size) {
    TextPainter label = new TextPainter(
        text: new TextSpan(
          text: text,
          style: new TextStyle(
            fontSize: 8.0,
            color: Colors.grey,
          ),
        ),
        textAlign: TextAlign.center,
        maxLines: 1,
        textDirection: TextDirection.ltr);
    label.layout(maxWidth: 20.0, minWidth: 10.0);
    Offset labelPos =
        new Offset(x - label.width / 2, size.height + label.height / 2);
    label.paint(canvas, labelPos);
  }

  void _drawYLabel(String text, Canvas canvas, double x, double y, Size size) {
    TextPainter label = new TextPainter(
        text: new TextSpan(
          text: text,
          style: new TextStyle(
            fontSize: 8.0,
            color: Colors.grey,
          ),
        ),
        textAlign: TextAlign.right,
        maxLines: 1,
        textDirection: TextDirection.ltr);
    label.layout(maxWidth: 20.0, minWidth: 10.0);
    Offset labelPos = new Offset(-label.width - 4.0, y - label.height / 2);
    label.paint(canvas, labelPos);
  }
}

class PlotStyle {
  final double pointRadius;
  final double outlineRadius;
  final Color primary;
  final Color secondary;
  final Color gridline;
  final Color axis;
  final double axisStrokeWidth;

  PlotStyle({
    this.pointRadius = 2.0,
    this.outlineRadius = 0.0,
    this.primary = const Color(0xFF0000FF),
    this.secondary = const Color(0xFFFF0000),
    this.gridline,
    this.axis,
    this.axisStrokeWidth = 1.0,
  });
}
