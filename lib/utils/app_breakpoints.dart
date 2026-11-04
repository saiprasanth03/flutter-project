enum AppBreakpoint { mobile, tablet, desktop }

abstract final class AppBreakpoints {
  static const mobileMaxWidth = 600.0;
  static const desktopMinWidth = 1024.0;

  static AppBreakpoint fromWidth(double width) {
    if (width < mobileMaxWidth) return AppBreakpoint.mobile;
    if (width < desktopMinWidth) return AppBreakpoint.tablet;
    return AppBreakpoint.desktop;
  }
}
