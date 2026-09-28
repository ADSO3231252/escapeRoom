import 'dart:async';

class TimerManager {
  Timer? _timer;

  int remainingSeconds = 0;

  bool get isRunning => _timer?.isActive ?? false;

  void start(int seconds) {
    stop();

    remainingSeconds = seconds;

    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (timer) {
        if (remainingSeconds > 0) {
          remainingSeconds--;
        } else {
          stop();
        }
      },
    );
  }

  void stop() {
    _timer?.cancel();
    _timer = null;
  }

  void reset() {
    stop();
    remainingSeconds = 0;
  }
}