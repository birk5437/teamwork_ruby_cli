require 'faraday'
require 'faraday_middleware'
require 'json'
# require 'date'
require 'active_support/all'
require 'pry'

# Special thanks to https://github.com/ehalferty/teamwork
class Teamwork

  def initialize(project_name:, api_key:)
    @project_name = project_name
    @api_key = api_key
    @api_conn = Faraday.new(url: "http://#{project_name}.teamworkpm.net/") do |c|
      c.request :multipart
      c.request :json
      c.request :url_encoded
      c.response :json, content_type: /\bjson$/
      c.adapter :net_http
    end

    @api_conn.headers[:cache_control] = 'no-cache'
    @api_conn.basic_auth(api_key, '')
  end


  def tasks_for_person(person_id, params={})
    raise "person_id required" if person_id.blank?
    result = @api_conn.get("tasks.json", { :"responsible-party-ids" => person_id, :"includeCompletedTasks" => true, :"includeCompletedSubtasks" => false, :"completedAfterDate" => 1.month.ago.strftime("%Y%m%d") })
    # result2 = @api_conn.get("tasks.json", { :"responsible-party-ids" => person_id, :"completedAfterDate" => 1.month.ago.strftime("%Y%m%d") })
    result = result.body["todo-items"]
    # result2 = result2.body["todo-items"]
    # return result + result2
    return result
  end

  def time_entries_for_task(task_id)
    result = @api_conn.get("tasks/#{task_id}/time_entries.json")
    result.body["time-entries"]
  end


  # https://developer.teamwork.com/projects/time-tracking/create-a-time-entry-for-a-task-todo-item
  def log_time(person_id:, task_id:, hours:, tags: nil, date: nil, time: nil)
    tags ||= "development"
    minutes ||= 0
    if date.present?
      date = DateTime.parse(date)
    else
      # date = Date.today
      date = DateTime.now.beginning_of_day
    end
    time ||= (DateTime.now - hours.to_d.hours - minutes.to_i.minutes).strftime("%H:%M")
    @api_conn.post("tasks/#{task_id}/time_entries.json", {
      "time-entry": {
        "person-id": person_id.to_s,
        date: date.strftime("%Y%m%d"),
        time: time,
        hours: hours.to_s,
        # minutes: minutes.to_s,
        tags: tags.to_s
      }
    })
  end

end
