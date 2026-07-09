import 'package:flutter/material.dart';

const Color _primaryDark = Color(0xFF35506B);
const Color _softBlue = Color(0xFFE8F1F8);
const Color _line = Color(0xFFE6E9ED);
const Color _muted = Color(0xFF6F7782);

class GoogleRouteMap extends StatelessWidget {
  final String destination;
  final double height;
  final BorderRadius borderRadius;

  const GoogleRouteMap({
    super.key,
    required this.destination,
    required this.height,
    required this.borderRadius,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: _softBlue,
        borderRadius: borderRadius,
        border: Border.all(color: _line),
      ),
      child: Padding(
        padding: const EdgeInsets.all(18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.map_outlined, color: _primaryDark, size: 44),
            const SizedBox(height: 10),
            Text(
              'Google Maps disponible en Flutter Web',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w900),
            ),
            const SizedBox(height: 6),
            Text(
              destination,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: _muted),
            ),
          ],
        ),
      ),
    );
  }
}
