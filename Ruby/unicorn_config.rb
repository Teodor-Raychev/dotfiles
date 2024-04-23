
# Define your root directory.
root = "/home/deployer/apps/gifroll/current"

# Define worker directory for Unicorn.
working_directory "/path/to/app/current"

# Define number of workers processes.
# Each forked OS process consumes additional memory.
worker_processes 4

# Define timeout for hanging workers before they are restarted.
timeout 30

# Location of PID file.
pid "/path/to/app/shared/pids/unicorn.pid"

# Define Log paths:

# Allow redirecting $stderr to a given path. Unlike doing this from the shell,
# this allows the unicorn process to know the path its writing to and rotate
# the file if it is used for logging
stderr_path "#{root}/log/unicorn.log"

# Same as stderr_path, except for $stdout. Not many Rack applications write
# to $stdout, but any that do will have their output written here.
stdout_path "#{root}/log/unicorn.log"

# Loads rails before forking workers for better worker spawn time.
# Preloading your application reduces the startup time of individual
# Unicorn worker_processes and allows you to manage the external connections
# of each individual worker using the before_fork and after_fork calls.
#
# Please check if other external connections work properly with
# Unicorn forking. Many popular gems (dalli memcache client, Redis) will have
# compatibility confirmation with Unicorn and it's process model.
# Check your gem's documentation for more information.
preload_app true

# When enabled, unicorn will check the client connection by writing the
# beginning of the HTTP headers before calling the application. This will
# prevent calling the application for clients who have disconnected while
# their connection was queued.
check_client_connection false

# local variable to guard against running a hook (before_fork, after_fort)
# multiple times
run_once = true

# Example use of before_fork and after_fork:
#
# POSIX Signals are a form of interprocess communication, and are used for
# events or state chages.
# QUIT: used to signal a process to exit, but creates a  core dump.
# TERM: TERM is used to tell a process to terminate, but allows the process
# to clean up after itself.
#
# Unicorn uses the QUIT signal to indicate graceful shutdown.
# Master process receives it and sends it to all workers, telling them to
# shutdown after any in-fligth request.
before_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn master intercepting TERM and sending myself QUIT instead'
    Process.kill 'QUIT', Process.pid
  end

  # You may want to execute code in the master process, before the forking
  # begins, to deal with a operations that causes changes in state, but
  # you need them to run once:
  if run_once
    # do_something_once_here ...
    run_once = false # prevent from firing again
  end
end

after_fork do |server, worker|
  Signal.trap 'TERM' do
    puts 'Unicorn worker intercepting TERM and doing nothing. Wait for master to send QUIT'
  end
  # ...
end

# For more information you can check the Unicorn Configurator: https://msp-greg.github.io/unicorn/Unicorn/Configurator.html
