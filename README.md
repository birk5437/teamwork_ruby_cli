# Installation:

0. Get a Teamwork API key and figure out what your person_id is in Teamwork
1. ``git clone https://github.com/birk5437/teamwork_ruby_cli.git``
2. ``cp teamwork_ruby_cli/secrets.yml.example teamwork_ruby_cli/secrets.yml``
3. Open ``teamwork_ruby_cli/secrets.yml`` in a text editor and add your api_key and person_id
4. ``cd teamwork_ruby_cli``
5. ``bundle install``

6. Add this to your ``.bash_profile``
```bash
alias log_time="logTime"

function logTime(){
  cd teamwork_ruby_cli #modify this to point to your local ruby_teamwork_cli folder
  bundle exec ruby run_me.rb $1 $2 $3 $4 $5
  cd -
}
```

7. Open a new terminal window and try it out!
```bash
log_time <teamwork task number> <number of hours>
# example: log_time 9999 1.5
# example: log_time 9999 .5
```
