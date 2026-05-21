extension DurationEx on Duration {
  String fmtTime() {
    final int centiseconds = (inMilliseconds % 1000) ~/ 10;
    final String ms = centiseconds.toString().padLeft(2, '0');

    final int seconds = inSeconds % 60;
    final String ss = seconds.toString().padLeft(2, '0');

    final int minutes = inMinutes % 60;
    final String mm = minutes.toString().padLeft(2, '0');

    final formatedText = '$mm:$ss.$ms';

    if (inMinutes >= 60) return "$inHours:$formatedText";
    return formatedText;
  }
}
