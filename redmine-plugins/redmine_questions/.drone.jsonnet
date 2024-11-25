local Pipeline(rubyVer, db, license, redmine, dependents) = {
  kind: "pipeline",
  name: rubyVer + "-" + db + "-" + redmine + "-" + license + "-" + dependents,
  steps: [
    {
      name: "tests",
      image: "redmineup/redmineup_ci",
      commands: [
        "service postgresql start && service mysql start && sleep 5",
        "export PATH=~/.rbenv/shims:$PATH",
        "export CODEPATH=`pwd`",
        "/root/run_for.sh redmine_questions+" + license + " ruby-" + rubyVer + " " + db + " redmine-" + redmine + " " + dependents
      ]
    }
  ]
};

[
  Pipeline("3.2.2", "mysql", "pro", "trunk", ""),
  Pipeline("3.2.2", "pg", "pro", "5.1", ""),
  Pipeline("3.0.6", "mysql", "pro",  "5.0", "redmineup_tags"),
  Pipeline("2.7.8", "mysql", "light", "4.2", ""),
  Pipeline("2.7.8", "pg", "pro", "4.2", ""),
  Pipeline("2.3.8", "mysql", "pro", "4.0", ""),
  Pipeline("2.3.8", "pg", "pro", "4.0", "")
]
