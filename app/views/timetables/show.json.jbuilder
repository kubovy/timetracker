json.array!(@timetables) do |timetable|
  json.extract! timetable, :employer_id, :employee_id, :day, :hours
  json.url timetable_url(timetable, format: :json)
end