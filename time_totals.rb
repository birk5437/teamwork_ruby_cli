require "./teamwork_api_wrapper.rb"

config = YAML.load_file('./secrets.yml').symbolize_keys

tw = Teamwork.new(project_name: 'mobi', api_key: config[:api_key])
# task_ids_and_names = tw.tasks_for_person(config[:tw_person_id]).select{ |task| task["parentTaskId"].blank? }.map{ |task| [task["id"], task["content"]] }
tasks = tw.tasks_for_person(config[:tw_person_id]).select{ |task| task["parentTaskId"].blank? }.sort_by{ |t| DateTime.parse(t["last-changed-on"]) }
tasks.each do |task|

  task_id = task["id"]
  task_name = task["content"]
  updated_at = DateTime.parse(task["last-changed-on"])

  time_entries = tw.time_entries_for_task(task_id).select{ |te| te["person-id"].to_s == config[:tw_person_id].to_s }
  # binding.pry if task_id == 11394429
  total_minutes = 0
  total_hours = 0
  time_entries.each do |te|
    # binding.pry
    total_minutes += te["minutes"].to_i
    total_hours += te["hours"].to_i
  end
  puts "#{task_id} | #{total_hours.to_s.ljust(3, ' ')} | #{total_minutes.to_s.ljust(3, ' ')} | #{updated_at.strftime('%A %m/%e').ljust(15, ' ')} | #{task_name}"
  # binding.pry
  time_entries.sort_by{ |te| DateTime.parse(te["dateUserPerspective"]) }.each do |te|
    puts "    #{DateTime.parse(te['dateUserPerspective']).strftime('%A %m/%e').ljust(15, ' ')} | #{te['hours'].ljust(3, ' ')} | #{te['minutes'].ljust(3, ' ')}"
  end

end
