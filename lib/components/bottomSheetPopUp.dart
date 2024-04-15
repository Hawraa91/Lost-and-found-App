import 'package:flutter/material.dart';

import '../screens/post/View/SearchResults.dart';

class bottomSheetPopUp {
  bottomSheetPopUp._(); // Private constructor to prevent instantiation

  static void show(
      BuildContext context, Future<List<String>> titlesFuture) async {
    final List<String> matched = await titlesFuture;
    showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20.0),
              topRight: Radius.circular(20.0),
            ),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min, // Adjusted to min
            children: <Widget>[
              Icon(
                Icons.manage_search_rounded,
                size: 145.0,
                color: Colors.green,
              ),
              Padding(
                padding: EdgeInsets.all(16.0), // Adjust padding as needed
                child: Text(
                  "We have found some possible matches",
                  style: TextStyle(
                    fontSize: 16, // Adjust font size as needed
                    fontWeight: FontWeight.bold, // Adjust font weight as needed
                  ),
                ),
              ),
              Padding(
                padding:
                EdgeInsets.symmetric(vertical: 16.0), // Adjusted padding
                child: Container(
                  width: 125,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(246, 245, 243, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => SearchResultsPage(matchedTitles: matched),
                        ),
                      );
                    },
                    child: Text(
                      'Show',
                      style: TextStyle(color: Colors.black),
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
