// Package imports:
import 'package:hooks_riverpod/hooks_riverpod.dart';

class RecordSummaryModeNotifier extends Notifier<RecordSummaryModeButtonMode> {
  @override
  RecordSummaryModeButtonMode build() {
    return .record;
  }

  void toggle() {
    state = switch (state) {
      .record => .summary,
      .summary => .record,
    };
  }
}

final recordSummaryModeProvider =
    NotifierProvider.autoDispose<RecordSummaryModeNotifier, RecordSummaryModeButtonMode>(
      RecordSummaryModeNotifier.new,
    );

enum RecordSummaryModeButtonMode { record, summary }
