json.array!(@timetables) do |timetable|
  json.extract! timetable, :employer_id, :user_id, :day, :hours
  json.url timetable_url(timetable, format: :json)
end