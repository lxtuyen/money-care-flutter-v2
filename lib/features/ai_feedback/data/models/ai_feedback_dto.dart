class AiFeedbackDto {
  final String recommendationType;
  final String recommendationId;
  final String? sourceModel;
  final String? sourceModelVersion;
  final String userAction;
  final Map<String, dynamic> sourcePayload;
  final Map<String, dynamic>? modifiedPayload;
  final Map<String, dynamic>? contextPayload;
  final String? reasonText;

  const AiFeedbackDto({
    required this.recommendationType,
    required this.recommendationId,
    required this.userAction,
    required this.sourcePayload,
    this.sourceModel,
    this.sourceModelVersion,
    this.modifiedPayload,
    this.contextPayload,
    this.reasonText,
  });

  Map<String, dynamic> toJson() {
    return {
      'recommendationType': recommendationType,
      'recommendationId': recommendationId,
      if (sourceModel != null) 'sourceModel': sourceModel,
      if (sourceModelVersion != null) 'sourceModelVersion': sourceModelVersion,
      'userAction': userAction,
      'sourcePayload': sourcePayload,
      if (modifiedPayload != null) 'modifiedPayload': modifiedPayload,
      if (contextPayload != null) 'contextPayload': contextPayload,
      if (reasonText != null) 'reasonText': reasonText,
    };
  }
}
