library rating_bar;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feedback.dart';

/// A customizable rating bar widget that uses custom images for displaying ratings.

class RatingBarCustomImage extends StatefulWidget {

  /// feedback box UI
  final FeedbackUIType? feedbackUIType;

  /// Current rating value
  final double currentRating;

  /// List of active images for each rating point
  final List<ImageProvider<Object>> activeImages;

  /// List of inactive images for each rating point
  final List<ImageProvider<Object>> deActiveImages;

  /// Size of each rating image
  final double imageSize;

  /// Size of each rating image
  final ValueChanged<double> onRatingChanged;

  ///set it true if you want to use google fonts else false
  final bool? isGoogleFont;

  ///set your custom font family name or google font name
  final String? fontFamilyName;

  /// Title of the feedback box
  final String? feedbackBoxTitle;

  /// Threshold to show feedback box for low ratings
  final double? showFeedbackForRatingsLessThan;

  /// Title for low rating feedback section
  final String? lowRatingFeedbackTitle;

  /// List of feedback options for low ratings
  final List<String>? lowRatingFeedback;

  /// Flag to show input field for description
  final bool? showDescriptionInput;

  /// Title for the description input field
  final String? descriptionTitle;

  /// Placeholder text for the description input field
  final String? descriptionPlaceHolder;

  /// Maximum character limit for the description input
  final int? descriptionCharacterLimit;

  /// Callback when submit is tapped
  final String? submitButtonTitle;
  final Function(MapEntry<int, String>? selectedFeedback, String? description)?
      onSubmitTap;

  /// Threshold to redirect to the store for high ratings
  final double? showRedirectToStoreForRatingsGreaterThan;

  /// Package name for the Android app to redirect
  final String? androidPackageName;

  /// Bundle ID for the iOS app to redirect
  final String? iosBundleId;

  /// Border radius for the feedback dialog widgets.
  final double? innerWidgetsBorderRadius;

  /// Border radius for the alert dialog
  final double? alertDialogBorderRadius;

  const RatingBarCustomImage({
    super.key,
    this.feedbackUIType = FeedbackUIType.alertBox,
    required this.currentRating,
    required this.activeImages,
    required this.deActiveImages,
    this.imageSize = 24.0,
    required this.onRatingChanged,
    this.fontFamilyName = "",
    this.isGoogleFont = false,
    this.feedbackBoxTitle = "Give us feedback",
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
    this.showFeedbackForRatingsLessThan = 0.0,
    this.androidPackageName,
    this.iosBundleId,
    this.innerWidgetsBorderRadius = 6,
    this.alertDialogBorderRadius = 12,
  });
  @override
  RatingBarCustomImageState createState() => RatingBarCustomImageState();
}

class RatingBarCustomImageState extends State<RatingBarCustomImage> {
  double updatedRating = 0.0;
  final double maxRating = 5.0;

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

  /// Displays the feedback alert dialog based on the rating.
  funcShowAlert(
      {required BuildContext context,
      required TextStyle textStyle,
      required double fontSize}) {
    if (widget.showFeedbackForRatingsLessThan != 0) {
      if (updatedRating != 0.0) {
        if (updatedRating < widget.showFeedbackForRatingsLessThan!) {

          widget.feedbackUIType == FeedbackUIType.alertBox ?

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
                content: funcGetFeedback(textStyle: textStyle, fontSize: fontSize),
              );
            },
          )
          :
          showModalBottomSheet(
            context: context,
            isScrollControlled: true, // Allows the bottom sheet to take up the full height of the screen
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(widget.alertDialogBorderRadius!),
              ),
            ),
            builder: (BuildContext context) {
              return Padding(
                padding: EdgeInsets.only( bottom: MediaQuery.of(context).viewInsets.bottom),
                child: funcGetFeedback(textStyle: textStyle, fontSize: fontSize),
              );
            },
          );

        }
      }
    }
  }

  Widget funcGetFeedback({required TextStyle textStyle, required double fontSize}){

    return ClassFeedback(
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
    );

  }

  /// Builds each rating icon with touch capability.
  Widget _buildIcon(BuildContext context, int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 3),
      child: Image(
        image: (index < widget.currentRating.floor() &&
                widget.currentRating != 0.0)
            ? widget.activeImages[index]
            : widget.deActiveImages[index],
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
