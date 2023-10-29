# Forecaster 2.0

- **Ruby Version**: 3.2.2
- **Rails Version**: 7.1.1
- **Dependencies**: Tailwind, Geocoder, RestClient

TODO: link here when it is ready

## Development

- `bin/dev` - stands up the application for development
- `bin/rspec` - runs specs

### Other Notes

- Javascript is managed by the new Rails importmaps introduced in Rails 7.
- Testing is done via rspec. While there are some existing tests, more testing is needed for a production ready application.
- The project does not need a database to function. Caching is achieved in memory utilizing the low level caching that Rails provides out of the box.

## Requirements

- ✅ Must be done in Ruby on Rails 
- ✅ Accept an address as input
- ✅ Retrieve forecast data for the given zip code. This should include, at minimum, the current temperature (Bonus points - Retrieve high/low and/or extended forecast)
- ✅ Display the requested forecast details to the user 
- ✅ Cache the forecast details for 30 minutes for all subsequent requests by zip codes. Display indicator if result is pulled from cache.

**Note**: This project is open to interpretation. Functionality is a priority over form.

