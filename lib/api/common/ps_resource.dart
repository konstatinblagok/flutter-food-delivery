import 'package:fluttermultistoreflutter/api/common/ps_status.dart';

class PsResource<T> {
  PsResource(this.status, this.message, this.data);
  final PsStatus status;

  final String message;

  T data;

  // get length => null;
}
