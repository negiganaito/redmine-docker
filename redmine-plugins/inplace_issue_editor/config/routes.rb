# Plugin's routes
# See: http://guides.rubyonrails.org/routing.html

get '/projects/:id/active_memberss' , to: 'issue_tables#fetch_active_members'

get '/issues/:id/allowed_status', to: 'issue_tables#fetch_issue_allowed_status'

get '/all_custom_fields', to: 'issue_tables#all_custom_fields'
get '/all_projects', to: 'issue_tables#all_projects'
get ':id/all_versions', to: 'issue_tables#all_versions'
get ':id/check_agile_board_enabled', to: 'issue_tables#check_agile_board_enabled'
# put '/projects/:id', to: 'issue_tables#create'
