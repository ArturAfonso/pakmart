


import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pakmart/src/di/injector.dart';

class AppBarSearchWidget extends StatefulWidget {
  const AppBarSearchWidget({super.key});

  @override
  State<AppBarSearchWidget> createState() => _AppSearchFieldState();
}

class _AppSearchFieldState extends State<AppBarSearchWidget> {
  
  final TextEditingController _controller = TextEditingController();

  @override
  void dispose() {
    
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: MediaQuery.of(context).size.width * 0.4, // Largura aproximada do seu design
      height: 40,
      child: TextField(
        controller: _controller,
        //focusNode: searchService.searchFocusNode,
        decoration: InputDecoration(
          hintText: 'Procurar aplicativos...',
          prefixIcon: const Icon(Icons.search, size: 20),
          
         /*  suffixIcon: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.withOpacity(0.3)),
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text('/', style: TextStyle(color: Colors.grey)),
            ),
          ), */
        ),
      ),
    );
  }
}