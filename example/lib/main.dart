import 'package:flutter/material.dart';
import 'package:rating_and_feedback_collector/rating_and_feedback_collector.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'rating_and_feedback_collector',
      theme: ThemeData.light(),
      darkTheme: ThemeData.dark(),
      themeMode: ThemeMode.light,
      home: const MyHomePage(title: 'rating_and_feedback_collector'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  double _rating = 0.0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.primary,
        title: Text(widget.title),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Center(child: Text("Current Rating : $_rating")),
          const Padding(
            padding: EdgeInsets.only(top: 25),
            child: Text(
              "Rating bar with icons",
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: RatingBar(
              iconSize: 40, // Size of the rating icons
              allowHalfRating: true, // Allows selection of half ratings
              filledIcon:
                  Icons.star, // Icon to display for a filled rating unit
              halfFilledIcon: Icons
                  .star_half, // Icon to display for a half-filled rating unit
              emptyIcon: Icons
                  .star_border, // Icon to display for an empty rating units
              filledColor: Colors.amber, // Color of filled rating units
              emptyColor: Colors.grey, // Color of empty rating units
              currentRating: _rating, // Set initial rating value
              onRatingChanged: (rating) {
                // Callback triggered when the rating is changed
                setState(() {
                  _rating = rating;
                });
              },
              showFeedbackForRatingsLessThan: 4,
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 25),
            child: Text("Rating bar with emoji's"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: RatingBarEmoji(
              imageSize: 45, // Size of image in the rating bar.
              currentRating: _rating, // Set initial rating value
              onRatingChanged: (rating) {
                // Callback triggered when the rating is changed
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(top: 25),
            child: Text("Rating bar with custom images"),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 25),
            child: RatingBarCustomImage(
              imageSize: 45, // Size of image in the rating bar.
              currentRating: _rating, // Set initial rating value
              activeImages: const [
                AssetImage('assets/Images/ic_angry.png'),
                AssetImage('assets/Images/ic_sad.png'),
                AssetImage('assets/Images/ic_neutral.png'),
                AssetImage('assets/Images/ic_happy.png'),
                AssetImage('assets/Images/ic_excellent.png'),
              ],
              deActiveImages: const [
                AssetImage('assets/Images/ic_angryDisable.png'),
                AssetImage('assets/Images/ic_sadDisable.png'),
                AssetImage('assets/Images/ic_neutralDisable.png'),
                AssetImage('assets/Images/ic_happyDisable.png'),
                AssetImage('assets/Images/ic_excellentDisable.png'),
              ],
              onRatingChanged: (rating) {
                // Callback triggered when the rating is changed
                setState(() {
                  _rating = rating;
                });
              },
            ),
          ),
        ],
      ),
    );
  }
}
