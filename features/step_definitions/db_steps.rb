Given /^the following (.+) exist?$/ do |factory, table|
	model = factory.to_s.singularize.camelcase.constantize
	table.hashes.each do |hash|
		model.create hash
	end
end
