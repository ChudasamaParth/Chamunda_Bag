import 'package:chamunda_bag/screens/main_screen.dart';
import 'package:flutter/material.dart';

class EmptyWishlist extends StatelessWidget {
  const EmptyWishlist({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.check_box_outline_blank,
              size: 90,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) {
                      return MainScreen();
                    },
                  ),
                );
              },
              child: const Text("Continue Shopping"),
            ),
          ],
        ),
      ),
    );
  }
}
