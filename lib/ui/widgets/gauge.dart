import 'package:flutter/material.dart'; import 'dart:math' as m;
class Gauge extends StatelessWidget{ final double cents; const Gauge({super.key,required this.cents});
  @override Widget build(BuildContext c)=>CustomPaint(size: const Size(double.infinity,180), painter: _P(cents:cents)); }
class _P extends CustomPainter{ final double cents; _P({required this.cents});
  @override void paint(Canvas canvas, Size size){ final w=size.width,h=size.height,center=Offset(w/2,h*0.9); final r=m.min(w/2-16,h*0.9-16);
    final p=Paint()..style=PaintingStyle.stroke..strokeWidth=6..color=const Color(0xFFB2DFDB);
    final rect=Rect.fromCircle(center:center,radius:r); canvas.drawArc(rect, m.pi, m.pi, false, p);
    p.strokeWidth=2; for(int i=-50;i<=50;i+=5){ final ang=m.pi+(i+50)/100*m.pi; final p1=Offset(center.dx+r*m.cos(ang),center.dy+r*m.sin(ang)); final r2=r-(i%25==0?18:10);
      final p2=Offset(center.dx+r2*m.cos(ang),center.dy+r2*m.sin(ang)); canvas.drawLine(p1,p2,p); }
    final c=cents.clamp(-50,50); final ang=m.pi+(c+50)/100*m.pi; final n=Paint()..color=const Color(0xFF00695C)..strokeWidth=4;
    final tip=Offset(center.dx+(r-24)*m.cos(ang), center.dy+(r-24)*m.sin(ang)); canvas.drawLine(center, tip, n); canvas.drawCircle(center, 6, n);
  }
  @override bool shouldRepaint(covariant _P o)=>o.cents!=cents;
}
