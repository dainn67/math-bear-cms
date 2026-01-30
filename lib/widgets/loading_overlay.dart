import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/app_provider.dart';

/// Widget hiển thị loading overlay khi app đang xử lý
class LoadingOverlay extends StatelessWidget {
  final Widget child;

  const LoadingOverlay({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        child,
        Consumer<AppProvider>(
          builder: (context, appProvider, _) {
            if (!appProvider.isLoading) {
              return const SizedBox.shrink();
            }
            return Container(
              color: Colors.black.withValues(alpha: 0.5),
              child: const Center(
                child: CircularProgressIndicator(),
              ),
            );
          },
        ),
      ],
    );
  }
}
