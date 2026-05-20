extension DurationEx on Duration {
  String fmtTime() {
    late final String formatedMillseconds;
    try {
      // formatedMillseconds = inMilliseconds.toString().substring(0, 2);
      formatedMillseconds = extractSpecifiedLength(
        inMilliseconds.toString(),
        2,
        1,
      );
    } catch (e) {
      formatedMillseconds = inMilliseconds.toString();
    }

    final String formatedText = "$inMinutes:$inSeconds.$formatedMillseconds";
    return formatedText;
  }
}

String extractSpecifiedLength(String str, int n, int lastN) {
  if (n <= 0) throw Exception();
  if (lastN < 0) lastN = 0;
  final len = str.length;
  final start = (len - n - lastN).clamp(0, len);
  final end = (len - lastN).clamp(0, len);
  if (start >= end) throw Exception();
  return str.substring(start, end);
}
