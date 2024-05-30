## Overview

This coding challenge involves building a simple scheduling application for a clinic. It allows patients to book different types of appointments and enables practitioners to view scheduled appointments for the current day.

### Business Rules

1. The clinic operates from 9am to 5pm.
2. Appointment types and durations:
   - Initial consultation: 90 minutes
   - Standard appointment: 60 minutes
   - Check-in: 30 minutes
3. Appointments must start on the hour or half-hour.
4. Appointments cannot overlap.
5. Bookings can only be made for appointments that start and end within clinic hours.
6. Bookings cannot be made within 2 hours of the appointment start time.

### Application Structure

- `app/models/appointment.rb`: Defines the `Appointment` class, representing an appointment.
- `app/models/schedule.rb`: Defines the `Schedule` class, which manages the collection of appointments.
- `app/services/availability_service.rb`: Defines the `AvailabilityService` class, which determines available appointment slots based on existing bookings and clinic rules.
- `app/app.rb`: Main application class that provides the interface for booking and querying appointments.

### Setup

1. Clone the repository

```sh
git clone <repository-url>
cd <repository-directory>
```

2. Install dependencies

```sh
bundle install
```

3. Run tests

```sh
rspec
```

### Usage

The application can be interacted with through the App class. Here is an example of how to use the class:

1. Start IRB

```sh
irb -r './app/app.rb'
```

2. Create an instance of the application

```ruby
app = App.new
```

3. Get available times

```ruby
type = :standard
date = Date.today + 1 # Tomorrow
available_times = app.available_times(type, date)
```

4. Book an appointment

```ruby
start_time = available_times.first
app.book_appointment(type, start_time)
```

5. View today's appointments:

```ruby
app.todays_appointments
```
