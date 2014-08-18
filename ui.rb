require 'active_record'
require 'pry'

require './lib/event'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  puts "\n"
  puts " -- Calendar--  "
  puts "\n"
  puts " '1' to create event."
  puts " '2' to delete event."
  puts " '3' to update event."
  puts " 'x' to exit program."

  case gets.chomp
  when '1'
    create_event
  when '2'
    delete_event
  when '3'
    update_event
  when 'x'
    exit
  else
    puts "Invalid."
    menu
  end
end

def create_event
  puts "Enter new event name:"
  new_event = gets.chomp
  puts "Enter location of event:"
  new_location = gets.chomp
  puts "Enter event start date and time 'YYYY-MM-DD 00:00':"
  start_time = gets.chomp
  puts "Enter date when event ends 'YYYY-MM-DD 00:00':"
  end_time = gets.chomp
  event = Event.new(:description => new_event, :location => new_location, :start => start_time, :end => end_time)
  event.save
  puts "#{event.description} has been added to your calendar."
end

menu
