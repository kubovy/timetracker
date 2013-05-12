class Report < ActiveRecord::Base
	TIME_PERIODS = {1 => 'this month', 2 => 'last month', 3 => 'this week', 4 => 'last week'}
	GROUPING_BY  = {1 => 'user', 2 => 'team', 3 => 'project', 4 => 'task'}
	GROUPING_PER = {1 => 'month', 2 => 'week', 3 => 'day'}
end
