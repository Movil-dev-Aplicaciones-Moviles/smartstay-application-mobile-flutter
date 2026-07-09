// ignore_for_file: avoid_web_libraries_in_flutter, deprecated_member_use

import 'dart:async';
import 'dart:html' as html;
import 'dart:ui_web' as ui_web;

import 'package:flutter/material.dart';

const Color _primaryDark = Color(0xFF35506B);
const Color _softBlue = Color(0xFFE8F1F8);
const Color _line = Color(0xFFE6E9ED);
const Color _muted = Color(0xFF6F7782);

class GoogleRouteMap extends StatefulWidget {
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
  State<GoogleRouteMap> createState() => _GoogleRouteMapState();
}

class _GoogleRouteMapState extends State<GoogleRouteMap> {
  late final String _viewType;
  late final html.IFrameElement _iframe;
  bool _requestingLocation = true;
  String _hint = 'Permite tu ubicación para calcular la ruta real.';

  @override
  void initState() {
    super.initState();
    _viewType = 'smartstay-google-route-map-${DateTime.now().microsecondsSinceEpoch}-${identityHashCode(this)}';
    _iframe = html.IFrameElement()
      ..style.border = '0'
      ..style.width = '100%'
      ..style.height = '100%'
      ..style.borderRadius = '28px'
      ..allowFullscreen = true
      ..referrerPolicy = 'no-referrer-when-downgrade';

    ui_web.platformViewRegistry.registerViewFactory(_viewType, (int viewId) => _iframe);
    _loadMap();
  }

  @override
  void didUpdateWidget(covariant GoogleRouteMap oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.destination != widget.destination) {
      _loadMap();
    }
  }

  Future<void> _loadMap() async {
    setState(() {
      _requestingLocation = true;
      _hint = 'Permite tu ubicación para calcular la ruta real.';
    });

    _iframe.src = _hotelOnlyUrl(widget.destination);

    try {
      final position = await html.window.navigator.geolocation.getCurrentPosition(
        enableHighAccuracy: true,
        timeout: const Duration(seconds: 8),
      );
      final latitude = position.coords?.latitude;
      final longitude = position.coords?.longitude;

      if (latitude != null && longitude != null) {
        _iframe.src = _routeUrl('$latitude,$longitude', widget.destination);
        if (mounted) {
          setState(() {
            _requestingLocation = false;
            _hint = 'Ruta calculada desde tu ubicación actual.';
          });
        }
      } else {
        _showDestinationOnly();
      }
    } catch (_) {
      _showDestinationOnly();
    }
  }

  void _showDestinationOnly() {
    _iframe.src = _hotelOnlyUrl(widget.destination);
    if (mounted) {
      setState(() {
        _requestingLocation = false;
        _hint = 'No se pudo usar tu ubicación. Mostrando el alojamiento en Google Maps.';
      });
    }
  }

  String _routeUrl(String origin, String destination) {
    final encodedOrigin = Uri.encodeComponent(origin);
    final encodedDestination = Uri.encodeComponent(destination);
    return 'https://maps.google.com/maps?saddr=$encodedOrigin&daddr=$encodedDestination&dirflg=d&output=embed';
  }

  String _hotelOnlyUrl(String destination) {
    final encodedDestination = Uri.encodeComponent(destination);
    return 'https://maps.google.com/maps?q=$encodedDestination&z=15&output=embed';
  }

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: widget.borderRadius,
      child: Container(
        height: widget.height,
        width: double.infinity,
        decoration: BoxDecoration(
          color: _softBlue,
          borderRadius: widget.borderRadius,
          border: Border.all(color: _line),
        ),
        child: Stack(
          children: [
            Positioned.fill(child: HtmlElementView(viewType: _viewType)),
            Positioned(
              top: 12,
              right: 12,
              child: _MapStatusChip(
                icon: _requestingLocation ? Icons.my_location : Icons.route_outlined,
                text: _requestingLocation ? 'Buscando ubicación' : 'Google Maps',
              ),
            ),
            Positioned(
              left: 14,
              right: 14,
              bottom: 14,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 11),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(242),
                  borderRadius: BorderRadius.circular(18),
                  boxShadow: [BoxShadow(color: Colors.black.withAlpha(22), blurRadius: 18, offset: const Offset(0, 8))],
                ),
                child: Row(
                  children: [
                    const Icon(Icons.near_me_outlined, color: _primaryDark),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Text(
                        _hint,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12.5),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _MapStatusChip extends StatelessWidget {
  final IconData icon;
  final String text;

  const _MapStatusChip({required this.icon, required this.text});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withAlpha(240),
        borderRadius: BorderRadius.circular(99),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(20), blurRadius: 16, offset: const Offset(0, 8))],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: _primaryDark),
          const SizedBox(width: 6),
          Text(text, style: const TextStyle(fontWeight: FontWeight.w900, fontSize: 12)),
        ],
      ),
    );
  }
}
