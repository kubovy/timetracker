FactoryGirl.define do
  factory :user do
		name "foo"
		email "foo@test.com"
		remember_token SecureRandom.urlsafe_base64
	end
end