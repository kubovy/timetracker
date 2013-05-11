require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Given /^I am logged in as (user|manager|administrator) "(.*)"$/ do |role,login|
	@user = User.create(
			:login=>login,
			:email => "#{login}@test.com",
  		:is_admin => role == 'administrator',
			:is_manager => role == 'manager')

	step "I log in as \"#{login}\""
end

When /^I log in as "(.*?)"$/ do |login|
	visit send(:login_path)
	fill_in("Login", :with => login)
	click_button("Login")
end

Then /^I should successfully log in$/ do
	true
end