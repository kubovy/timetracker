json.array!(@holidays) do |holiday|
  json.extract! holiday, :employer_id, :date
  json.url holiday_url(holiday, format: :json)
end