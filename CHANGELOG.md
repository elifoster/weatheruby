# Changelog

## Version 1

### Version 1.0.0
* New `#sun_info` method for sunset/sunrise times
* Add `:image_url` to simple forecast return hash
* Add `:date`, `:weekday_name`, and `:image_url` to complex forecast return data
* Improve documentation across the library. The recommended place for docs is now 
[GitHub Pages](http://elifoster.github.io/weatheruby/) instead of RubyDocs.info
* `#get` is now private
* Remove `autoparse` parameter from `#get`
* Fix `#hurricane_data` by ignoring the `WeatherError` thrown by that API
* Return `Time` and `DateTime` objects instead of `String`s for timestamp values across the library.

## Version 0

### Version 0.6.1
* Update to StringUtility 3.0

### Version 0.6.0
* Error handling is much more generic now, with a single WeatherError which gets its message from the Weather 
Underground API. With this is also the removal of the `verbose` option. Lastly, no method will return an error 
silently, but actually `fail` with the WeatherError.
* `language_key` is now an attribute accessor.

### Version 0.5.3
* Update to HTTPClient 2.8
* Use pessimistic version requirements, and actually add version requirements for Rainbow and StringUtility.

### Version 0.5.2
* License as MIT

### Version 0.5.1
* Update to HTTPClient 2.7 and Ruby 2.3

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
