require "./teamwork_api_wrapper.rb"

config = YAML.load_file('./secrets.yml').symbolize_keys

if [ARGV[0], ARGV[1]].map(&:blank?).any?
  puts "USAGE: log_time <task_id> <hours> <minutes(optional)> <date(optional)> <time(optional)>"
else
  tw = Teamwork.new(project_name: 'mobi', api_key: config[:api_key])
  result = tw.log_time(person_id: config[:tw_person_id], task_id: ARGV[0], hours: ARGV[1], minutes: ARGV[2], date: ARGV[3], time: ARGV[4])
  puts result.body
end
