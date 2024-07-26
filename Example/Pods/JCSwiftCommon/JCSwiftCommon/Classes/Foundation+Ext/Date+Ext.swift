//
//  Date+Ext.swift
//  JCSwiftCommon
//
//  Created by James Chen on 2022/10/31.
//

import Foundation

public extension Date {
  struct FormatStyle {
    static let m2d2y4Splash = "MM/dd/yyyy" /// 12/31/1970
    static let m2d2y2Splash = "MM/dd/yy" /// 12/31/70
    static let m3d2y4Splash = "MMM/dd/yyyy" /// Dec/31/1970
    static let m3d2y4SQS = "MMM dd, yyyy" /// Dec 31, 1970
    static let y4m3d2Splash = "yyyy/MMM/dd" /// 1970/Dec/31
    static let y4m2d2Dash = "yyyy-MM-dd" /// 1970-12-31
    static let d2m2y2Splash = "dd/mm/yy" /// 31/12/70
    static let d2m2y4Splash = "dd/MM/yyyy" /// 31/12/1970
    static let d2m2y4Dot = "dd.MM.yyyy" /// 31.12.1970
    static let d2mMAXy2Space = "dd MMMM yyyy" /// 31 December 1970

    static let H2m2s2 = "HH:mm:ss" /// 01:59:59
    static let H1m2 = "H:mm" /// 1:59
    static let h2m2s2 = "hh:mm:ss a" /// 01:59:59 AM
    static let h1m2 = "h:mm a" /// 1:59 AM
  }

  init(string: String, withFormat style: String) {
    let formatter = DateFormatter()
    formatter.dateFormat = style
    let date = formatter.date(from: string)
    self.init(timeMillis: date?.timeMillis ?? 0)
  }

  ///
  func format2String(_ style: String) -> String {
    let formatter = DateFormatter()
    formatter.dateFormat = style
    return formatter.string(from: self)
  }

  /// Init with milliseconds
  init(timeMillis: Int) {
    self.init(timeIntervalSince1970: TimeInterval(timeMillis / 1000))
  }

  /// milliseconds for current date
  var timeMillis: Int {
    return Int(timeIntervalSince1970) * 1000
  }
}

public extension Date {
  /// Returns self.day - anotherDay.day
  /// Like today - yesterday = 1, yesterday - tomorrow = -2
  func compareDays(with anotherDay: Date) -> Int {
    guard let day = calendar.dateComponents([Calendar.Component.day], from: self, to: anotherDay).day else {
      return 0
    }
    return day
  }

  /// Returns the first moment of a given Date, as a Date.
  /// Depends on current time zone.
  func dayStartDate() -> Date {
    calendar.startOfDay(for: self)
  }
}

/// From this below is not written by James Chen.
/// But I'm sorry I don't remember where I copied this from, thanks to the Author at somewhere, cheers!
public extension Date {
  /// Create a new date form calendar components.
  ///
  ///     let date = Date(year: 2010, month: 1, day: 12) // "Jan 12, 2010, 7:45 PM"
  ///
  /// - Parameters:
  ///   - calendar: Calendar (default is current).
  ///   - timeZone: TimeZone (default is current).
  ///   - era: Era (default is current era).
  ///   - year: Year (default is current year).
  ///   - month: Month (default is current month).
  ///   - day: Day (default is today).
  ///   - hour: Hour (default is current hour).
  ///   - minute: Minute (default is current minute).
  ///   - second: Second (default is current second).
  ///   - nanosecond: Nanosecond (default is current nanosecond).
  init?(
    calendar: Calendar? = Calendar.current,
    timeZone: TimeZone? = NSTimeZone.default,
    era: Int? = Date().era,
    year: Int? = Date().year,
    month: Int? = Date().month,
    day: Int? = Date().day,
    hour: Int? = Date().hour,
    minute: Int? = Date().minute,
    second: Int? = Date().second,
    nanosecond: Int? = Date().nanosecond) {
    var components = DateComponents()
    components.calendar = calendar
    components.timeZone = timeZone
    components.era = era
    components.year = year
    components.month = month
    components.day = day
    components.hour = hour
    components.minute = minute
    components.second = second
    components.nanosecond = nanosecond

    guard let date = calendar?.date(from: components) else { return nil }
    self = date
  }

  ///  Era.
  ///
  ///        Date().era -> 1
  ///
  var era: Int {
    return calendar.component(.era, from: self)
  }

  var calendar: Calendar {
    return Calendar(identifier: Calendar.current.identifier)
  }

  var year: Int {
    get {
      return calendar.component(.year, from: self)
    }
    set {
      guard newValue > 0 else { return }
      let currentYear = calendar.component(.year, from: self)
      let yearsToAdd = newValue - currentYear
      if let date = calendar.date(byAdding: .year, value: yearsToAdd, to: self) {
        self = date
      }
    }
  }

  ///  Month.
  ///
  ///     Date().month -> 1
  ///
  ///     var someDate = Date()
  ///     someDate.month = 10 // sets someDate's month to 10.
  ///
  var month: Int {
    get {
      return calendar.component(.month, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .month, in: .year, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentMonth = calendar.component(.month, from: self)
      let monthsToAdd = newValue - currentMonth
      if let date = calendar.date(byAdding: .month, value: monthsToAdd, to: self) {
        self = date
      }
    }
  }

  ///  Day.
  ///
  ///     Date().day -> 12
  ///
  ///     var someDate = Date()
  ///     someDate.day = 1 // sets someDate's day of month to 1.
  ///
  var day: Int {
    get {
      return calendar.component(.day, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .day, in: .month, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentDay = calendar.component(.day, from: self)
      let daysToAdd = newValue - currentDay
      if let date = calendar.date(byAdding: .day, value: daysToAdd, to: self) {
        self = date
      }
    }
  }

  /// Weekday.
  ///
  ///     Date().weekday -> 5 // fifth day in the current week.
  ///
  var weekday: Int {
    return calendar.component(.weekday, from: self)
  }

  ///  Hour.
  ///
  ///     Date().hour -> 17 // 5 pm
  ///
  ///     var someDate = Date()
  ///     someDate.hour = 13 // sets someDate's hour to 1 pm.
  ///
  var hour: Int {
    get {
      return calendar.component(.hour, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .hour, in: .day, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentHour = calendar.component(.hour, from: self)
      let hoursToAdd = newValue - currentHour
      if let date = calendar.date(byAdding: .hour, value: hoursToAdd, to: self) {
        self = date
      }
    }
  }

  ///  Minutes.
  ///
  ///     Date().minute -> 39
  ///
  ///     var someDate = Date()
  ///     someDate.minute = 10 // sets someDate's minutes to 10.
  ///
  var minute: Int {
    get {
      return calendar.component(.minute, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .minute, in: .hour, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentMinutes = calendar.component(.minute, from: self)
      let minutesToAdd = newValue - currentMinutes
      if let date = calendar.date(byAdding: .minute, value: minutesToAdd, to: self) {
        self = date
      }
    }
  }

  ///  Seconds.
  ///
  ///     Date().second -> 55
  ///
  ///     var someDate = Date()
  ///     someDate.second = 15 // sets someDate's seconds to 15.
  ///
  var second: Int {
    get {
      return calendar.component(.second, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .second, in: .minute, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentSeconds = calendar.component(.second, from: self)
      let secondsToAdd = newValue - currentSeconds
      if let date = calendar.date(byAdding: .second, value: secondsToAdd, to: self) {
        self = date
      }
    }
  }

  /// Nanoseconds.
  ///
  ///     Date().nanosecond -> 981379985
  ///
  ///     var someDate = Date()
  ///     someDate.nanosecond = 981379985 // sets someDate's seconds to 981379985.
  ///
  var nanosecond: Int {
    get {
      return calendar.component(.nanosecond, from: self)
    }
    set {
      let allowedRange = calendar.range(of: .nanosecond, in: .second, for: self)!
      guard allowedRange.contains(newValue) else { return }

      let currentNanoseconds = calendar.component(.nanosecond, from: self)
      let nanosecondsToAdd = newValue - currentNanoseconds

      if let date = calendar.date(byAdding: .nanosecond, value: nanosecondsToAdd, to: self) {
        self = date
      }
    }
  }
}
