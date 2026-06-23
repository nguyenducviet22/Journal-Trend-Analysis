import 'package:equatable/equatable.dart';

abstract class ReportState extends Equatable {
  const ReportState();

  @override
  List<Object?> get props => [];
}

class ReportInitial extends ReportState {}

class ReportGenerating extends ReportState {}

class ReportUploading extends ReportState {}

class ReportUploadSuccess extends ReportState {
  final String downloadUrl;
  const ReportUploadSuccess(this.downloadUrl);

  @override
  List<Object?> get props => [downloadUrl];
}

class ReportFailure extends ReportState {
  final String message;
  const ReportFailure(this.message);

  @override
  List<Object?> get props => [message];
}
