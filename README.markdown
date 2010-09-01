ActiveLog
=========
You need ActiveLog when you want to automagically create changelog of all activerecord changes in your rails app, asynchronously. It will keep track of all changes on attributes and as a bonus it can also record which user (session's current_user) made the change.

Example
-------

add "records\_active_log" to all models which needs to be logged
<pre><code>
class User < ActiveRecord::Base

  records_active_log

end
</code></pre>

You can access logs either by the tracked model or all...

<pre>
	>>u = User.first
	>>u.active_logs
	=> [...]
	
	or
	
	>> ActiveLog.all

</pre>

If you want to log along with information of currently logged in user then you should consider adding a before filter to application controller which sets ActiveLog.current = current_user

Sample:
<pre><code>
class ApplicationController < ActionController::Base
  [...]
  before_filter :audit_log_by_user

  [...]

  private
  # Assign the current user so tracked changes can be saved and associated with the user.
  def audit_log_by_user
    ActiveLog.current = current_user
  end
end
</code></pre>

Migration
---------

A database migration is needed to support tracking the changes. A rake task can be used to setup the migration.
The migration is not run automatically because you may want to customize it. Review the migration and the comments
that can guide any customizations.

The rake task is "setup".
<pre>
$ rake active_log:setup 
</pre>

If a user model is being used to track the changing user, log entries can be listed by the changing user. An
administering user in a system might see the recent changes by specific users.
<pre><code>
user = User.find(1)
user.active_logs.all
</code></pre>

In order for this to work, the "has_many :active_logs" would need to be manually added to the User model.

Copyright (c) 2010 Abhishek Parolkar, released under the MIT license
Copyright (c) 2010 Mark Ericksen on modifications.