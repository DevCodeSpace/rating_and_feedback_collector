library rating_and_feedback_collector;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feedback.dart';

class RatingBarEmoji extends StatefulWidget {
  /// Current rating value.
  final double currentRating;

  /// Size of image in the rating bar.
  final double imageSize;

  // Callback when the rating changes.
  final ValueChanged<double> onRatingChanged;

  ///set it true if you want to use google fonts else false
  final bool? isGoogleFont;

  ///set your custom font family name or google font name
  final String? fontFamilyName;

  /// Title displayed at the top of the feedback box.
  final String? feedbackBoxTitle;

  /// Threshold for showing feedback for low ratings.
  final double? showFeedbackForRatingsLessThan;

  /// Title for low rating feedback section.
  final String? lowRatingFeedbackTitle;

  /// Options for low rating feedback.
  final List<String>? lowRatingFeedback;

  /// Whether to show input box for additional feedback.
  final bool? showDescriptionInput;

  /// Title for the description input box.
  final String? descriptionTitle;

  /// Placeholder text for the description input box.
  final String? descriptionPlaceHolder;

  /// Maximum character limit for the description.
  final int? descriptionCharacterLimit;

  /// Title for the submit button.
  final String? submitButtonTitle;

  /// Callback for when feedback is submitted.
  final Function(MapEntry<int, String>? selectedFeedback, String? description)?
      onSubmitTap;

  /// Threshold for redirecting to the store for high ratings.
  final double? showRedirectToStoreForRatingsGreaterThan;

  /// Package name for the Android app.
  final String? androidPackageName;

  /// Bundle ID for the iOS app.
  final String? iosBundleId;

  /// Border radius for the feedback dialog widgets.
  final double? innerWidgetsBorderRadius;

  /// Border radius for the alert dialog
  final double? alertDialogBorderRadius;

  const RatingBarEmoji({
    super.key,
    required this.currentRating,
    this.imageSize = 24,
    required this.onRatingChanged,
    this.fontFamilyName = "",
    this.isGoogleFont = false,

    ///feedback box title
    this.feedbackBoxTitle = "Give us feedback",

    ///feedback box low ratings values
    this.showRedirectToStoreForRatingsGreaterThan = 0.0,
    this.lowRatingFeedbackTitle = "Share your experience",
    this.lowRatingFeedback = const [
      "Frequent bugs/crashes",
      "Poor user experience",
      "Lack of features",
      "Slow performance"
    ],
    this.showDescriptionInput = true,
    this.descriptionTitle = "Your Feedback",
    this.descriptionPlaceHolder = "Enter your feedback",
    this.descriptionCharacterLimit = 300,
    this.submitButtonTitle = "Send feedback",
    this.onSubmitTap,

    ///feedback box high rating redirects
    this.showFeedbackForRatingsLessThan = 0.0,
    this.androidPackageName,
    this.iosBundleId,
    this.innerWidgetsBorderRadius = 6,
    this.alertDialogBorderRadius = 12,
  });

  @override
  State<RatingBarEmoji> createState() => RatingBarEmojiState();
}

class RatingBarEmojiState extends State<RatingBarEmoji> {
  /// List of active rating icons.
  final List<ImageProvider<Object>> images = const [
    AssetImage('assets/Images/ic_angry.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_sad.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_neutral.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_happy.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_excellent.png',
        package: "rating_and_feedback_collector"),
  ];

  /// List of inactive (disabled) rating icons.
  final List<ImageProvider<Object>> imagesDisable = const [
    AssetImage('assets/Images/ic_angry_disable.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_sad_disable.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_neutral_disable.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_happy_disable.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_excellent_disable.png',
        package: "rating_and_feedback_collector"),
  ];

  /// List of inactive (disabled) rating icons - dark modes.
  final List<ImageProvider<Object>> imagesDisableDark = const [
    AssetImage('assets/Images/ic_angry_disable_dark.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_sad_disable_dark.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_neutral_disable_dark.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_happy_disable_dark.png',
        package: "rating_and_feedback_collector"),
    AssetImage('assets/Images/ic_excellent_disable_dark.png',
        package: "rating_and_feedback_collector"),
  ];

  /// Internal state to track the updated rating during interactions.
  double updatedRating = 0.0;
  double maxRating = 5.0;

  /// Updates the rating based on the user's touch position.
  void _updateRating(BuildContext context, Offset position) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(position);
    final newRating =
        (localPosition.dx / (widget.imageSize * maxRating)).clamp(0.0, 1.0) *
            maxRating;

    final fullRating =
        newRating.round().toDouble(); // Round to the nearest full
    widget.onRatingChanged(fullRating);
  }

  /// Function to show a custom alert dialog for rating feedback.
  funcShowAlert(
      {required BuildContext context,
      required TextStyle textStyle,
      required double fontSize}) {
    if (widget.showFeedbackForRatingsLessThan != 0) {
      if (updatedRating != 0.0) {
        if (updatedRating < widget.showFeedbackForRatingsLessThan!) {
          showDialog(
            barrierDismissible: false,
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                contentPadding: EdgeInsets.zero,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(widget.alertDialogBorderRadius!),
                ),
                content: ClassFeedback(
                  feedbackBoxTitle: widget.feedbackBoxTitle,
                  textStyle: textStyle,
                  lowRatingFeedbackTitle: widget.lowRatingFeedbackTitle,
                  lowRatingFeedback: widget.lowRatingFeedback,
                  showDescriptionInput: widget.showDescriptionInput,
                  descriptionTitle: widget.descriptionTitle,
                  descriptionPlaceHolder: widget.descriptionPlaceHolder,
                  descriptionCharacterLimit: widget.descriptionCharacterLimit,
                  submitButtonTitle: widget.submitButtonTitle,
                  onSubmitTap: (selectedFeedback, feedback) {
                    if (widget.onSubmitTap != null) {
                      widget.onSubmitTap!(selectedFeedback, feedback);
                    }
                  },
                  fontSize: fontSize,
                  innerWidgetsBorderRadius: widget.innerWidgetsBorderRadius,
                ),
              );
            },
          );
        }
      }
    }
  }

  /// Builds each icon in the rating bar.
  Widget _buildIcon(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Image(
        image: (index < widget.currentRating.floor() &&
                widget.currentRating != 0.0)
            ? images[index]
            : Theme.of(context).brightness == Brightness.dark
                ? imagesDisableDark[index]
                : imagesDisable[index],
        width: widget.imageSize,
        height: widget.imageSize,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    updatedRating = widget.currentRating;

    TextStyle textStyle = widget.isGoogleFont!
        ? GoogleFonts.getFont(widget.fontFamilyName!)
        : widget.fontFamilyName!.isEmpty
            ? const TextStyle()
            : TextStyle(fontFamily: widget.fontFamilyName!);

    double fontSize = 16;

    if (MediaQuery.of(context).size.width > 600) {
      fontSize = 18;
    } else if (MediaQuery.of(context).size.width > 400) {
      fontSize = 16;
    } else {
      fontSize = 16;
    }

    final stars = List<Widget>.generate(
      int.parse(maxRating.toStringAsFixed(0)),
      (index) => GestureDetector(
        onTap: () {
          updatedRating = (index.toDouble() + 1);
          widget.onRatingChanged(updatedRating);
          funcShowAlert(
              context: context, textStyle: textStyle, fontSize: fontSize);
        },
        child: _buildIcon(context, index),
      ),
    );

    return GestureDetector(
      onPanUpdate: (details) => _updateRating(context, details.globalPosition),
      onPanEnd: (details) => funcShowAlert(
          context: context, textStyle: textStyle, fontSize: fontSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: stars,
      ),
    );
  }
}
