import 'dart:async';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pakmart/src/routes/app_routes.dart';

class AppBarSearchWidget extends StatefulWidget {
  const AppBarSearchWidget({super.key});

  @override
  State<AppBarSearchWidget> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppBarSearchWidget> {
  static const int _autoSearchMinLength = 4;
  static const Duration _pushGuardDuration = Duration(milliseconds: 500);

  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;
  Timer? _pushGuardTimer;
  bool _searchPushInFlight = false;

  @override
  void dispose() {
    _debounce?.cancel();
    _pushGuardTimer?.cancel();
    _controller.clear();
    _controller.dispose();
    super.dispose();
  }

  void _openOrUpdateSearch(BuildContext context, {required bool submitted}) {
    final query = _controller.text.trim();
    final routeState = GoRouterState.of(context);
    final currentUri = routeState.uri;
    final topMatchedLocation = routeState.matchedLocation;
    final isSearchRoute =
        topMatchedLocation == AppRoutes.searchPath ||
        currentUri.path == AppRoutes.searchPath;

    final params = <String, String>{};
    if (query.isNotEmpty) {
      params['q'] = query;
    }
    if (submitted) {
      params['run'] = '1';
      params['t'] = DateTime.now().microsecondsSinceEpoch.toString();
    }

    if (isSearchRoute) {
      _searchPushInFlight = false;
      final currentQuery = currentUri.queryParameters['q'] ?? '';
      if (!submitted && currentQuery == query) {
        return;
      }

      context.replaceNamed(AppRoutes.SEARCH, queryParameters: params);
      return;
    }

    if (_searchPushInFlight) {
      return;
    }

    _searchPushInFlight = true;
    context.pushNamed(AppRoutes.SEARCH, queryParameters: params);
    _pushGuardTimer?.cancel();
    _pushGuardTimer = Timer(_pushGuardDuration, () {
      _searchPushInFlight = false;
    });
  }

  void _handleChanged(BuildContext context, String value) {
    _debounce?.cancel();
    final query = value.trim();
    if (query.length < _autoSearchMinLength) {
      return;
    }

    _debounce = Timer(const Duration(milliseconds: 420), () {
      if (!mounted) {
        return;
      }
      _openOrUpdateSearch(context, submitted: false);
    });
  }

  void _handleSubmitted(BuildContext context) {
    _debounce?.cancel();
    _openOrUpdateSearch(context, submitted: true);
  }

  @override
  Widget build(BuildContext context) {
    final routeState = GoRouterState.of(context);
    final currentUri = routeState.uri;
    final currentPath = currentUri.path;
    final routeQuery = currentUri.queryParameters['q'] ?? '';

    if (currentPath != AppRoutes.searchPath && _controller.text.isNotEmpty) {
      _debounce?.cancel();
      _controller.value = const TextEditingValue(
        text: '',
        selection: TextSelection.collapsed(offset: 0),
      );
      _searchPushInFlight = false;
    }

    if (_controller.text != routeQuery) {
      _controller.value = TextEditingValue(
        text: routeQuery,
        selection: TextSelection.collapsed(offset: routeQuery.length),
      );
    }

    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4,
      height: 40,
      child: TextField(
        controller: _controller,
        textInputAction: TextInputAction.search,
        onChanged: (value) => _handleChanged(context, value),
        onSubmitted: (_) => _handleSubmitted(context),
        decoration: InputDecoration(
          hintText: 'Procurar aplicativos...',
          prefixIcon: IconButton(
            onPressed: () => _handleSubmitted(context),
            icon: const Icon(Icons.search, size: 20),
            tooltip: 'Buscar',
          ),
          suffixIcon: _controller.text.trim().isNotEmpty
              ? IconButton(
                  onPressed: () {
                    _debounce?.cancel();
                    _controller.clear();
                    _openOrUpdateSearch(context, submitted: false);
                    setState(() {});
                  },
                  icon: const Icon(Icons.close_rounded, size: 18),
                  tooltip: 'Limpar',
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 12,
            vertical: 10,
          ),
        ),
      ),
    );
  }
}
