import 'package:flutter/material.dart';

class DashBoardScreen extends StatefulWidget {
  const DashBoardScreen({Key? key, required this.t}) : super(key: key);
  static const routeName = '/dashboard';
  final String t;
  @override
  State<DashBoardScreen> createState() => _DashBoardScreenState();
}

class _DashBoardScreenState extends State<DashBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('${widget.t}'),
    );
  }
}
