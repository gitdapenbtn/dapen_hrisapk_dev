class CustomException implements Exception {
  // ignore: prefer_typing_uninitialized_variables
  final _message;
  // ignore: prefer_typing_uninitialized_variables, unused_field
  final _prefix;

  CustomException([this._message, this._prefix]);

  @override
  String toString() {
    return "$_message";
  }
}

class FetchDataException extends CustomException {
  FetchDataException([String? message])
    : super(message, "Error During Communication: ");
}

class BadRequestException extends CustomException {
  BadRequestException([String? message]) : super(message, "Invalid Request: ");
}

class InvalidInputException extends CustomException {
  InvalidInputException([String? message]) : super(message, "Invalid Input: ");
}

class UnauthorizedException extends CustomException {
  UnauthorizedException([String? message]) : super(message, "Unauthorized: ");
}

class InternalServerErrorException extends CustomException {
  InternalServerErrorException([String? message])
    : super(message, "Bad Request");
}

class NotFoundException extends CustomException {
  NotFoundException([String? message]) : super(message, "Not Found");
}
