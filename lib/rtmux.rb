#!/usr/bin/env ruby
# coding: UTF-8

# lib/rtmux.rb
# 
# help create/resume tmux sessions
# 
# created on : 2012.11.22
# last update: 2013.08.23
# 
# by meinside@gmail.com

# rtmux module
module RTmux

=begin
  tmux helper class

  @note example:
    tmux = TmuxHelper.new("some_session_name")

    tmux.create_window("window1")
    tmux.create_window("window2")
    tmux.create_window("logs", cmd: "cd /var/log; ls")

    tmux.split("window1")
    tmux.focus("window1", pane: 2)

    tmux.split("window2", vertical: false, percentage: 30)

    tmux.attach
=end
  class TmuxHelper
    # initializer
    # @param session_name [String] session name
    def initialize(session_name, &block)
      @session_name = session_name || `hostname`.strip

      yield self if block_given?
    end

    # check if session is already created or not
    # @return [true,false]
    def session_created?
      `tmux has-session -t #{@session_name} 2> /dev/null`
      $?.exitstatus != 1
    end

    # check if window is already created or not
    # @param window_name [String] window name
    # @return [true,false]
    def window_created?(window_name)
      window_name ? `tmux list-windows -t #{@session_name} -F \"\#{window_name}\" 2> /dev/null` =~ /^#{window_name}$/ : false
    end

    # create window with given name and options
    # @param name [String] window name
    # @param options [Hash] options
    def create_window(name = nil, options = {cmd: nil})
      if session_created?
        if !window_created?(name)
          `tmux new-window -t #{@session_name} #{name.nil? ? "" : "-n #{name}"}`
        else
          return  # don't create duplicated windows
        end
      else
        `tmux new-session -s #{@session_name} #{name.nil? ? "" : "-n #{name}"} -d`
      end
      cmd(options[:cmd], name) if options && options[:cmd]
    end

    # execute command
    # @param cmd [String] command
    # @param window [String] window
    # @param options [Hash] options
    def cmd(cmd, window, options = {pane: nil})
      `tmux send-keys -t #{@session_name}:#{window}#{options && options[:pane] ? ".#{options[:pane]}" : ""} '#{cmd}' C-m`
    end

    # focus on given window
    # @param window [String] window
    # @param options [Hash] options
    def focus(window, options = {pane: nil})
      `tmux select-window -t #{@session_name}:#{window}`
      `tmux select-pane -t #{options[:pane]}` if options && options[:pane]
    end

    # split given window
    # @param window [String] window
    # @param options [Hash] options
    def split(window, options = {vertical: true, percentage: 50, pane: nil})
      `tmux split-window #{options && options[:vertical] ? "-h" : "-v"} -p #{options[:percentage]} -t #{@session_name}:#{window}#{options && options[:pane] ? ".#{options[:pane]}" : ""}`
    end

    # attach to current session
    def attach
      `tmux attach -t #{@session_name}`
    end

    attr_reader :session_name
  end
end

