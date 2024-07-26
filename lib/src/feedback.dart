import 'package:flutter/material.dart';
import 'riho_text_field.dart';

enum FeedbackUIType {
  alertBox,
  bottomSheet,
}

/// A StatefulWidget for gathering class feedback with dynamic form elements.
class ClassFeedback extends StatefulWidget {

  /// feedback alert box title
  final String? feedbackBoxTitle;

  ///set text style of font
  final TextStyle? textStyle;

  ///set font size
  final double? fontSize;

  /// Border radius for the feedback dialog widgets.
  final double? innerWidgetsBorderRadius;

  ///radio list for low ratings section title
  final String? lowRatingFeedbackTitle;

  ///radio list for low ratings section
  final List<String>? lowRatingFeedback;

  ///set true false value - whether you want to shoe description input or not
  final bool? showDescriptionInput;

  ///set description input box title
  final String? descriptionTitle;

  ///set placeholder text of description input
  final String? descriptionPlaceHolder;

  /// set input character limit in description input box
  final int? descriptionCharacterLimit;

  ///set submit button title
  final String? submitButtonTitle;

  ///on submit button click get low radio selected & get description input
  final Function(MapEntry<int, String>? selectedFeedback, String? description)?
      onSubmitTap;

  const ClassFeedback({
    super.key,
    this.feedbackBoxTitle,
    this.textStyle,
    this.fontSize,
    this.innerWidgetsBorderRadius,
    this.lowRatingFeedbackTitle,
    this.lowRatingFeedback,
    this.showDescriptionInput,
    this.descriptionTitle,
    this.descriptionPlaceHolder,
    this.descriptionCharacterLimit,
    this.submitButtonTitle,
    this.onSubmitTap,
  });

  @override
  State<ClassFeedback> createState() => _ClassFeedbackState();
}

/// The state class handling the behavior of the ClassFeedback widget.
class _ClassFeedbackState extends State<ClassFeedback> {
  /// Form key to manage form state.
  final formRatingFeedback = GlobalKey<FormState>();

  /// Controller for description input.
  final TextEditingController txtControllerLowRating = TextEditingController();

  /// check all validations are true or not
  bool isValidateFeedbackList = false;

  /// Stores the selected feedback entry radio reason & index also.
  MapEntry<int, String>? selectedFeedback;

  @override
  void dispose() {
    txtControllerLowRating.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: SingleChildScrollView(
        child: Form(
          key: formRatingFeedback,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    child: Text(
                      widget.feedbackBoxTitle!,
                      style: widget.textStyle!.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: widget.fontSize! + 2),
                    ),
                  ),
                  InkWell(
                      onTap: () => Navigator.of(context).pop(),
                      child: Container(
                        height: 35,
                        width: 35,
                        alignment: Alignment.center,
                        child: const Icon(
                          Icons.close_rounded,
                          color: Colors.grey,
                        ),
                      ))
                ],
              ),

              const Padding(
                padding: EdgeInsets.only(top: 5),
                child: Divider(
                  height: 0.5,
                ),
              ),

              /// Conditionally display content if there are low rating feedback options.
              widget.lowRatingFeedback!.isEmpty
                  ? const SizedBox()
                  : Padding(
                      padding: const EdgeInsets.only(top: 15),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          /// Title for the radio button list.
                          Text(
                            widget.lowRatingFeedbackTitle!,
                            style: widget.textStyle!
                                .copyWith(fontSize: widget.fontSize),
                          ),

                          /// List of radio buttons for selecting feedback.
                          Padding(
                            padding: const EdgeInsets.only(top: 5),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: widget.lowRatingFeedback!
                                  .asMap()
                                  .entries
                                  .map((entry) {
                                return InkWell(
                                  onTap: () {
                                    selectedFeedback = entry;
                                    setState(() {});
                                  },
                                  child: Container(
                                    padding: const EdgeInsets.only(
                                        top: 5, bottom: 5),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Icon(
                                          selectedFeedback == null
                                              ? Icons.radio_button_off_rounded
                                              : selectedFeedback!.key ==
                                                      entry.key
                                                  ? Icons
                                                      .radio_button_checked_rounded
                                                  : Icons
                                                      .radio_button_off_rounded,
                                          size: widget.fontSize! + 4,
                                          color: selectedFeedback == null
                                              ? const Color(0xffc2c2c2)
                                              : selectedFeedback!.key ==
                                                      entry.key
                                                  ? Theme.of(context)
                                                      .colorScheme
                                                      .primary
                                                  : const Color(0xffc2c2c2),
                                          // size: 20,
                                        ),
                                        const SizedBox(width: 5),
                                        Expanded(
                                          child: Text(
                                            entry.value,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodyMedium!
                                                .copyWith(
                                                    fontFamily: widget
                                                        .textStyle!.fontFamily),
                                            textAlign: TextAlign.start,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ],
                      ),
                    ),

              /// Error message if no feedback option is selected.
              !isValidateFeedbackList
                  ? const SizedBox()
                  : Text(
                      "Please select at least one option to proceed",
                      style: widget.textStyle!.copyWith(
                          color: Colors.redAccent,
                          fontSize: widget.fontSize! - 2),
                    ),

              /// Description input field, shown based on the `showDescriptionInput` flag.
              if (widget.showDescriptionInput!)
                Padding(
                  padding: const EdgeInsets.only(top: 15),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text(
                              widget.descriptionTitle!,
                              style: widget.textStyle!.copyWith(
                                  fontSize: widget.fontSize! - 2,
                                  fontWeight: FontWeight.w400,
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodySmall!
                                      .color),
                              textAlign: TextAlign.start,
                            ),
                          ),
                          // Text("0/${widget.descriptionCharacterLimit}",
                          //   style: Theme.of(context).textTheme.labelSmall!.copyWith(fontFamily: widget.textStyle!.fontFamily),
                          // ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 3),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RihoTextField(
                              // isFloating: false,
                              descriptionCharacterLimit:
                                  widget.descriptionCharacterLimit,
                              controller: txtControllerLowRating,
                              heading: widget.descriptionTitle!,
                              placeholder: widget.descriptionPlaceHolder!,
                              textStyle: widget.textStyle,
                              borderRadius: widget.innerWidgetsBorderRadius!,
                              maxLine: 3,
                              validator: (value) {
                                if (value == null || value.isEmpty) {
                                  return 'Please enter ${widget.descriptionTitle!.toLowerCase()}';
                                } else if (value.toString().length >
                                    widget.descriptionCharacterLimit!) {
                                  return 'Please enter up to ${widget.descriptionCharacterLimit!} characters only';
                                }
                                return null;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

              /// Submit button to finalize feedback submission.
              Padding(
                padding: const EdgeInsets.only(top: 15),
                child: InkWell(
                  onTap: () {
                    bool isError = false;
                    if (widget.lowRatingFeedback!.isNotEmpty) {
                      setState(() {
                        isValidateFeedbackList =
                            selectedFeedback == null ? true : false;
                        isError = selectedFeedback == null ? true : false;
                      });
                    }
                    if (!isError) {
                      if (formRatingFeedback.currentState!.validate()) {
                        widget.onSubmitTap!(
                            selectedFeedback, txtControllerLowRating.text);
                        Navigator.of(context).pop();
                      }
                    }
                  },
                  // width: MediaQuery.of(context).size.width,
                  child: Container(
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        borderRadius: BorderRadius.circular(
                            widget.innerWidgetsBorderRadius!)),
                    padding: const EdgeInsets.fromLTRB(10, 5, 10, 5),
                    child: Text(
                      widget.submitButtonTitle!,
                      style: widget.textStyle!.copyWith(
                          fontSize: widget.fontSize,
                          color: Theme.of(context).colorScheme.surface),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
