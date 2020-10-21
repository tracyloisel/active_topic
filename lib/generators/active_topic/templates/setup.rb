###### project_id is the id of your Google project
###### credentials is the json file obtained from your Google service accounts

ActiveTopic.configure do |config|
  config.project_id = 'Your Google Cloud project id'
  config.credentials = 'Your Google Cloud credentials'
end
