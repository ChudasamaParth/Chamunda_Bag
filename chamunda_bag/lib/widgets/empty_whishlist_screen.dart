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
              Icons.favorite_border_rounded,
              size: 90,
              color: Colors.grey.shade400,
            ),

            const SizedBox(height: 20),

            const Text(
              "Your Wishlist is Empty",
              style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Save your favourite bags\nand they'll appear here.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey.shade600, fontSize: 15),
            ),

            const SizedBox(height: 30),

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
