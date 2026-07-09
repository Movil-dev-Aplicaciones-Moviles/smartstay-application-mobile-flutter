import 'package:flutter/material.dart';
import '../core/google_route_map.dart';

const Color kPrimary = Color(0xFF6F93B8);
const Color kPrimaryDark = Color(0xFF35506B);
const Color kSecondary = Color(0xFF1F2933);
const Color kMuted = Color(0xFF6F7782);
const Color kError = Color(0xFFD93025);
const Color kSurface = Color(0xFFF7F8FA);
const Color kCardSurface = Colors.white;
const Color kSoftPink = Color(0xFFEAF3FA);
const Color kSoftBlue = Color(0xFFE8F1F8);
const Color kLine = Color(0xFFE6E9ED);


class SmartLogoMark extends StatelessWidget {
  final double size;
  final bool framed;

  const SmartLogoMark({super.key, this.size = 34, this.framed = true});

  @override
  Widget build(BuildContext context) {
    final logo = Image.asset(
      'assets/images/logo.png',
      width: size,
      height: size,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => Icon(Icons.hotel_class_rounded, color: kPrimaryDark, size: size * 0.66),
    );

    if (!framed) return logo;

    return Container(
      width: size + 14,
      height: size + 14,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [BoxShadow(color: Colors.black.withAlpha(18), blurRadius: 12, offset: const Offset(0, 6))],
      ),
      alignment: Alignment.center,
      child: logo,
    );
  }
}

class SmartScaffold extends StatelessWidget {
  final String title;
  final Widget child;
  final List<Widget> actions;
  final Widget? floatingActionButton;
  final Widget? bottomNavigationBar;

  const SmartScaffold({
    super.key,
    required this.title,
    required this.child,
    this.actions = const [],
    this.floatingActionButton,
    this.bottomNavigationBar,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kSurface,
      appBar: AppBar(
        title: Text(title, style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w800)),
        backgroundColor: kSurface,
        surfaceTintColor: kSurface,
        actions: actions,
      ),
      body: child,
      floatingActionButton: floatingActionButton,
      bottomNavigationBar: bottomNavigationBar,
    );
  }
}

class SmartCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  final EdgeInsetsGeometry padding;
  final EdgeInsetsGeometry margin;

  const SmartCard({
    super.key,
    required this.child,
    this.onTap,
    this.padding = const EdgeInsets.all(16),
    this.margin = const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      color: kCardSurface,
      shadowColor: Colors.black.withAlpha(20),
      margin: margin,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(26),
        side: const BorderSide(color: kLine),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(26),
        onTap: onTap,
        child: Padding(padding: padding, child: child),
      ),
    );
  }
}

class SmartButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool loading;
  final bool dark;

  const SmartButton({
    super.key,
    required this.text,
    this.onPressed,
    this.icon,
    this.loading = false,
    this.dark = false,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: FilledButton.icon(
        style: FilledButton.styleFrom(
          backgroundColor: dark ? kSecondary : kPrimary,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
          textStyle: const TextStyle(fontWeight: FontWeight.w800),
        ),
        onPressed: loading ? null : onPressed,
        icon: loading
            ? const SizedBox(
                height: 20,
                width: 20,
                child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
              )
            : Icon(icon ?? Icons.arrow_forward),
        label: Text(text),
      ),
    );
  }
}

class EmptyState extends StatelessWidget {
  final String message;
  final String buttonText;
  final VoidCallback onPressed;

  const EmptyState({
    super.key,
    required this.message,
    required this.buttonText,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(28),
            boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 28, offset: const Offset(0, 12))],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.hotel_outlined, color: kPrimary, size: 42),
              const SizedBox(height: 14),
              Text(message, textAlign: TextAlign.center, style: Theme.of(context).textTheme.bodyLarge),
              const SizedBox(height: 16),
              TextButton(onPressed: onPressed, child: Text(buttonText)),
            ],
          ),
        ),
      ),
    );
  }
}

class LoadingView extends StatelessWidget {
  final String message;
  const LoadingView({super.key, this.message = 'Cargando...'});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(26),
          boxShadow: [BoxShadow(color: Colors.black.withAlpha(10), blurRadius: 24, offset: const Offset(0, 12))],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const SizedBox(
              width: 42,
              height: 42,
              child: CircularProgressIndicator(strokeWidth: 3, color: kPrimary),
            ),
            const SizedBox(height: 16),
            Text(message, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kMuted)),
          ],
        ),
      ),
    );
  }
}

class AppImage extends StatelessWidget {
  final String url;
  final double height;
  final BorderRadius borderRadius;
  final IconData fallbackIcon;

  const AppImage({
    super.key,
    required this.url,
    required this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(16)),
    this.fallbackIcon = Icons.image_outlined,
  });

  @override
  Widget build(BuildContext context) {
    final fallback = Container(
      height: height,
      width: double.infinity,
      decoration: BoxDecoration(
        color: kSoftBlue,
        borderRadius: borderRadius,
      ),
      child: Icon(fallbackIcon, color: kPrimary, size: 44),
    );

    if (url.trim().isEmpty) return fallback;

    return ClipRRect(
      borderRadius: borderRadius,
      child: Image.network(
        url,
        height: height,
        width: double.infinity,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return fallback;
        },
        errorBuilder: (_, __, ___) => fallback,
      ),
    );
  }
}

class RoomIllustration extends StatelessWidget {
  const RoomIllustration({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 112,
      width: double.infinity,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: const LinearGradient(
          colors: [Color(0xFFE8F1F8), Color(0xFFF5FAFD)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: const Center(
        child: Icon(Icons.king_bed_outlined, color: kPrimary, size: 48),
      ),
    );
  }
}


Future<void> showRoutePreviewSheet(
  BuildContext context, {
  required String title,
  required String destination,
  required String subtitle,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(95),
    builder: (sheetContext) {
      return Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 560),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: SafeArea(
            top: false,
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(22, 16, 22, 26),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 42,
                        height: 5,
                        decoration: BoxDecoration(color: Colors.black26, borderRadius: BorderRadius.circular(99)),
                      ),
                      const Spacer(),
                      IconButton(
                        tooltip: 'Cerrar',
                        onPressed: () => Navigator.pop(sheetContext),
                        icon: const Icon(Icons.close, size: 28),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 6),
                  Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kMuted)),
                  const SizedBox(height: 18),
                  RoutePreviewCard(destination: destination),
                ],
              ),
            ),
          ),
        ),
      );
    },
  );
}

class RoutePreviewCard extends StatelessWidget {
  final String destination;
  final double height;
  final bool showDetails;

  const RoutePreviewCard({
    super.key,
    required this.destination,
    this.height = 230,
    this.showDetails = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        GoogleRouteMap(
          destination: destination,
          height: height,
          borderRadius: BorderRadius.circular(28),
        ),
        if (showDetails) ...[
          const SizedBox(height: 16),
          Text(
            'A dónde irás',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 8),
          Text(
            destination,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(fontWeight: FontWeight.w700),
          ),
        ],
      ],
    );
  }
}

void showSmartSnack(BuildContext context, String message) {
  ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
}

class SectionHeader extends StatelessWidget {
  final String title;
  final String subtitle;
  final Widget? trailing;

  const SectionHeader({
    super.key,
    required this.title,
    required this.subtitle,
    this.trailing,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(2, 8, 2, 16),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w900)),
                const SizedBox(height: 6),
                Text(subtitle, style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: kMuted)),
              ],
            ),
          ),
          if (trailing != null) trailing!,
        ],
      ),
    );
  }
}

class AuthRequiredCard extends StatelessWidget {
  final String title;
  final String message;
  final VoidCallback onLogin;

  const AuthRequiredCard({
    super.key,
    required this.title,
    required this.message,
    required this.onLogin,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(22, 40, 22, 120),
        child: Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(color: Colors.black.withAlpha(14), blurRadius: 28, offset: const Offset(0, 12)),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: const BoxDecoration(shape: BoxShape.circle, color: kSoftBlue),
                child: const Icon(Icons.lock_outline, color: kPrimaryDark, size: 30),
              ),
              const SizedBox(height: 16),
              Text(title, style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              Text(message, style: const TextStyle(color: kMuted)),
              const SizedBox(height: 18),
              SmartButton(text: 'Iniciar sesión', icon: Icons.login, onPressed: onLogin),
            ],
          ),
        ),
      ),
    );
  }
}

Future<void> showAuthPromptSheet(
  BuildContext context, {
  required String title,
  required String message,
  required VoidCallback onLogin,
  String? maskedEmail,
}) {
  return showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    barrierColor: Colors.black.withAlpha(95),
    builder: (sheetContext) => _AuthPromptSheet(
      title: title,
      message: message,
      maskedEmail: maskedEmail,
      onLogin: () {
        Navigator.pop(sheetContext);
        onLogin();
      },
    ),
  );
}

class _AuthPromptSheet extends StatelessWidget {
  final String title;
  final String message;
  final String? maskedEmail;
  final VoidCallback onLogin;

  const _AuthPromptSheet({
    required this.title,
    required this.message,
    required this.onLogin,
    this.maskedEmail,
  });

  @override
  Widget build(BuildContext context) {
    final bottom = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width: double.infinity,
          constraints: const BoxConstraints(maxWidth: 560),
          padding: const EdgeInsets.fromLTRB(26, 22, 26, 28),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(36)),
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Spacer(),
                    IconButton(
                      tooltip: 'Cerrar',
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(Icons.close, size: 30),
                    ),
                  ],
                ),
                const SizedBox(height: 18),
                Container(
                  width: 118,
                  height: 118,
                  decoration: const BoxDecoration(shape: BoxShape.circle, color: Color(0xFFDDEEEA)),
                  child: const Center(
                    child: Text(
                      'S',
                      style: TextStyle(color: Color(0xFF2F665D), fontSize: 50, fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(height: 28),
                Text(
                  title,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.w900),
                ),
                if (maskedEmail != null) ...[
                  const SizedBox(height: 16),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.mail_outline, size: 24),
                      const SizedBox(width: 10),
                      Text(maskedEmail!, style: Theme.of(context).textTheme.titleMedium),
                    ],
                  ),
                ],
                const SizedBox(height: 26),
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(color: kMuted, height: 1.35),
                ),
                const SizedBox(height: 26),
                SmartButton(text: 'Iniciar sesión', icon: Icons.login, dark: true, onPressed: onLogin),
                const SizedBox(height: 18),
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Seguir explorando'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
