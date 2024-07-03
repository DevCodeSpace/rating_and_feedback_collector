library rating_and_feedback_collector;

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'feedback.dart';

class RatingBar extends StatefulWidget {
  /// current rating value.
  final double currentRating;

  ///Icon to display for a filled rating unit.
  final IconData filledIcon;

  /// Icon to display for a half-filled rating unit.
  final IconData halfFilledIcon;

  /// Icon to display for an empty rating unit.s
  final IconData emptyIcon;

  /// Color of filled rating units.
  final Color filledColor;

  /// Color of empty rating units.
  final Color emptyColor;

  /// Size of the rating icons.
  final double iconSize;

  /// Callback triggered when the rating is changed.
  final ValueChanged<double> onRatingChanged;

  /// Allows selection of half ratings.
  final bool allowHalfRating;

  ///set it true if you want to use google fonts else false
  final bool? isGoogleFont;

  ///set your custom font family name or google font name
  final String? fontFamilyName;

  /// Title for the feedback box (appears after rating submission).
  final String? feedbackBoxTitle;

  /// Threshold rating value below which feedback box is shown.
  final double? showFeedbackForRatingsLessThan;

  /// Title for feedback options in the low rating feedback box.
  final String? lowRatingFeedbackTitle;

  /// List of feedback strings for low ratings.
  final List<String>? lowRatingFeedback;

  /// Option to show input box for user descriptions in the feedback dialog.
  final bool? showDescriptionInput;

  /// Title for the description input box in the feedback dialog.
  final String? descriptionTitle;

  /// Placeholder text for the description input box.
  final String? descriptionPlaceHolder;

  /// Character limit for the description input.
  final int? descriptionCharacterLimit;

  /// Title for the submit button in the feedback dialog.
  final String? submitButtonTitle;

  /// Callback function triggered on submission of feedback.
  final Function(MapEntry<int, String>? selectedFeedback, String? description)?
      onSubmitTap;

  /// Threshold rating value above which the app redirects to the store for a review.
  final double? showRedirectToStoreForRatingsGreaterThan;

  /// Android package name for the app, used in the store redirect.
  final String? androidPackageName;

  /// iOS bundle ID for the app, used in the store redirect.
  final String? iosBundleId;

  /// Border radius for the feedback dialog widgets.
  final double? innerWidgetsBorderRadius;

  /// Border radius for the alert dialog
  final double? alertDialogBorderRadius;

  const RatingBar({
    super.key,
    this.currentRating = 0.0,
    this.filledIcon = Icons.star,
    this.halfFilledIcon = Icons.star_half,
    this.emptyIcon = Icons.star_border,
    this.filledColor = Colors.amber,
    this.emptyColor = Colors.grey,
    this.iconSize = 24.0,
    required this.onRatingChanged,
    this.allowHalfRating = false,
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
    this.descriptionTitle = "Your feedback",
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
  State<RatingBar> createState() => RatingBarState();
}

class RatingBarState extends State<RatingBar> {
  /// Tracks the updated rating based on user interaction.
  double updatedRating = 0.0;
  final double maxRating = 5.0;

  /// Updates the rating based on user's touch interaction.
  void _updateRating(BuildContext context, Offset position, bool isPanEnds) {
    final RenderBox renderBox = context.findRenderObject() as RenderBox;
    final localPosition = renderBox.globalToLocal(position);

    final newRating =
        (localPosition.dx / (widget.iconSize * maxRating)).clamp(0.0, 1.0) *
            maxRating;

    if (widget.allowHalfRating) {
      updatedRating =
          (newRating * 2).round() / 2.0; // Round to the nearest half
      widget.onRatingChanged(updatedRating);
    } else {
      updatedRating = newRating.round().toDouble(); // Round to the nearest full
      widget.onRatingChanged(updatedRating);
    }
  }

  /// Shows a custom alert dialog after rating interaction based on the updated rating.
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

  /// Builds individual icons for the rating bar, handling full, half, and empty states.
  Widget _buildIcon(BuildContext context, int index) {
    return (index < widget.currentRating.floor())
        ? Icon(
            widget.filledIcon,
            color: widget.filledColor,
            size: widget.iconSize,
          )
        : (widget.allowHalfRating && index < widget.currentRating)
            ? Icon(
                widget.halfFilledIcon,
                color: widget.filledColor,
                size: widget.iconSize,
              )
            : Icon(
                widget.emptyIcon,
                color: widget.emptyColor,
                size: widget.iconSize,
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
          updatedRating =
              widget.allowHalfRating ? (index + 1.0) : (index.toDouble() + 1);
          widget.onRatingChanged(updatedRating);
          funcShowAlert(
              context: context, textStyle: textStyle, fontSize: fontSize);
        },
        child: _buildIcon(context, index),
      ),
    );

    return GestureDetector(
      onPanUpdate: (details) =>
          _updateRating(context, details.globalPosition, false),
      onPanEnd: (details) => funcShowAlert(
          context: context, textStyle: textStyle, fontSize: fontSize),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: stars,
      ),
    );
  }
}
