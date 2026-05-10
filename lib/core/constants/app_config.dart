class AppConfig {
  // adb reverse tcp:3000 tcp:3000 tunnels the emulator's localhost to the host.
  // Works for both emulator and USB-connected real device (re-run adb reverse after each connect).
  // Real device on WiFi (no USB): replace with host machine's local IP e.g. http://192.168.1.5:3000
  static const String baseUrl = 'http://localhost:3000';
}
