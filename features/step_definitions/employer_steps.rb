When /^I (include|exclude) the user "(.+?)"$/ do |include, login|
	page.find(:xpath, "//table//td[contains(text(), '#{login}')]/../td[1]/input").set(include == 'include')
end

Then(/^I (should|should not) see the employer selection box$/) do |display|
	xpath = "//*[@id='selected_employer_id']"
	page.should have_xpath(xpath) if display == 'should'
	page.should_not have_xpath(xpath) if display == 'should not'
end

Then(/^the employer selection box (should|should not) contain "(.*?)"$/) do |display, employer|
	xpath = "//*[@id='selected_employer_id']/option[contains(text(), '#{employer}')]"
	page.should have_xpath(xpath) if display == 'should'
	page.should_not have_xpath(xpath) if display == 'should not'
end

