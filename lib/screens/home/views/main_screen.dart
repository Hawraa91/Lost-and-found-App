import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({Key? key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0, vertical: 10),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Container(
                            width: 50,
                            height: 50,
                            decoration: const BoxDecoration(
                              shape: BoxShape.circle,
                              // Blue green
                              color: Color.fromRGBO(22, 19, 85, 1.0),
                            ),
                          ),
                          const Icon(
                            CupertinoIcons.person_fill,
                            color: Colors.white,
                          ),
                        ],
                      ),
                      const SizedBox(
                        width: 8,
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Report your lost or found item",
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: Theme.of(context).colorScheme.outline,
                            ),
                          ),
                          Text(
                            "Welcome to FindMyThing",
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).colorScheme.onBackground,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  SizedBox(
                    width: 40, // Adjust width as needed
                    child: IconButton(
                      onPressed: () {},
                      icon: const Icon(CupertinoIcons.bell),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                   Text(
                    "Categories",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              Row(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: [
                          cardIcon(Icons.key,
                              const Color.fromRGBO(237, 245, 246, 1.0)),
                          cardIcon(Icons.headset,
                              const Color.fromRGBO(237, 245, 246, 1.0)),
                          cardIcon(Icons.diamond,
                              const Color.fromRGBO(237, 245, 246, 1.0)),
                          cardIcon(Icons.book,
                              const Color.fromRGBO(237, 245, 246, 1.0)),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              const Row(
                children: [
                  Text(
                    "Lost Items",
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 30),
              //the blue container
              containerPost(context),
              const SizedBox(height: 30),
              containerPost(context),
              const SizedBox(height: 30),
              containerPost(context),
            ],
          ),
        ),
      ),
    );
  }
}

//The category icons method
Widget cardIcon(IconData icon, Color backgroundColor) {
  return Container(
    height: 50,
    width: 100,
    child: Card(
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              color: backgroundColor,
              child: Icon(icon),
            ),
          )
        ],
      ),
    ),
  );
}

Widget containerPost(BuildContext context) {
  return Container(
    width: MediaQuery.of(context).size.width,
    height: MediaQuery.of(context).size.width / 2,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(30),
      boxShadow: [
        BoxShadow(
          blurRadius: 4,
          color: Colors.grey.shade300,
          offset: const Offset(5, 5),
        )
      ],
      // Dark blue
      color: const Color.fromRGBO(96, 173, 183, 1.0),
    ),
  );
}
