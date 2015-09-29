#!/usr/bin/env ruby
# morea-watch.rb dport@hawaii.edu
# Adapted from watch.rb by Brett Terpstra, 2011 <http://brettterpstra.com>
# with credit to Carlo Zottmann <https://github.com/carlo/haml-sass-file-watcher>
#
# This file must be in the same directory as morea-run-local.sh
#
# *Warning* If you watch a folder (or subfolder) that jekyll generates files in when run in it may unpleasantly
# stop and re-start for each generated file since we don't check when output is completed
# after forking morea-run-local (probably should do this though...)
#

def fork_MOREA()
  pid = fork do
    exec "./morea-run-local.sh"
  end
  Process.detach(pid)
  sleep 5
  return pid
end

trap("SIGINT") { exit }

if ARGV.length < 1
  puts "Usage: #{$0} watch_folder"
  puts "Example: #{$0} ./master/src/morea"
  exit
end

filetypes = ['css','html','htm', 'js', 'md']
watch_folder = ARGV[0]
keyword = ARGV[1]

morea_pid = fork_MOREA

puts "Watching #{watch_folder} and subfolders for changes in project files..."

while true do
  files = []
  filetypes.each {|type|
    files += Dir.glob( File.join( watch_folder, "**", "*.#{type}" ) )
  }
  new_hash = files.collect {|f| [ f, File.stat(f).mtime.to_i ] }
  hash ||= new_hash
  diff_hash = new_hash - hash

  unless diff_hash.empty?
    hash = new_hash

    diff_hash.each do |df|
      puts "Detected change in #{df[0]}"
    end

    unless `pgrep -f .*morea-run-local.*` == ""

      base=Process.pid
      descendants = Hash.new{|ht,k| ht[k]=[k]}
      Hash[*`ps -eo pid,ppid`.scan(/\d+/).map{|x|x.to_i}].each{|pid,ppid|
        descendants[ppid] << descendants[pid]
      }
      descendants[base].flatten - [base]
      kills = descendants[base].flatten - [base]
      kills.each do |cpid|
        begin
          puts "killing pid #{cpid}"
          Process.kill("SIGTERM", cpid)
        rescue
          next
        end
      end

      Process.waitall
      puts "goodby pid #{morea_pid}, restarting MOREA"
      morea_pid = fork_MOREA
    end

  end
  sleep 1
end