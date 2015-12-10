# Changelog
## Version 0
### Version 0.5.0
* Add support for all Weather Underground Planner APIs.

### Version 0.4.2
* No longer fails with an ArgumentError if the CLI is passed no arguments. Instead it outputs the usage information, so that it is actually a useful thing.

### Version 0.4.1
* Fix NameError

### Version 0.4.0
* New weatheruby executable.
* Fail when there are many results and it cannot get actual data.
* Many style fixes.

### Version 0.3.1
* Fix forecast names to 10day, and made it apparent in documentation that the non-10 day methods are only for the next 3 days.

### Version 0.3.0
* Proper error handling, with new initialization parameter verbose_errors.

### Version 0.2.0
* New complex_forecast_10day and simple_forecast_20day.
* New complex_forecast and simple_forecast methods. It's funny, complex_forecast uses the simpleforecast stuff from the API.
* New hurricane_data method.
* New record_low and record_high methods.

### Version 0.1.0
* Intial version. Includes #conditions, #moon_phase, and #alerts.
