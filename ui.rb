require 'active_record'
require 'chronic'
require 'pry'

require './lib/event'

database_configuration = YAML::load(File.open('./db/config.yml'))
development_configuration = database_configuration["development"]
ActiveRecord::Base.establish_connection(development_configuration)

def menu
  input = nil
  until input == 'x'
    puts "\n"
    puts " -- Calendar--  "
    puts "\n"
    puts " '1' to create event."
    puts " '2' to delete event."
    puts " '3' to update event."
    puts " '4' to list events by date"
    puts " 'x' to exit program."
    input = gets.chomp
    case input
    when '1'
      create_event
    when '2'
      delete_event
    when '3'
      update_event
    when '4'
      list_by_date
    when 'x'
      exit
    else
      puts "Invalid."
      menu
    end
  end
end

def create_event
  puts "Enter new event name:"
  new_event = gets.chomp
  puts "Enter location of event:"
  new_location = gets.chomp
  puts "Enter event start date and time 'YYYY-MM-DD 00:00':"
  start_time = Time.parse(gets.chomp)
  puts "Enter date when event ends 'YYYY-MM-DD 00:00':"
  end_time = Time.parse(gets.chomp)
  event = Event.new(:description => new_event, :location => new_location, :start => start_time, :end => end_time)
  event.save
  puts "#{event.description} has been added to your calendar."
end

def delete_event
  list
  puts "Enter the number of the event you wish to delete:"
  input = gets.chomp.to_i
  event = Event.find_by(id: input)
  event.destroy
  puts "#{event.description} has been removed!"
end

def list
  puts "-------------"
  Event.all.each {|x| puts "#{x.id}. #{x.description}"}
  puts "-------------"
end

def update_event
  list
  puts "Enter the number of the event you wish to update:"
  input = gets.chomp.to_i
  event = Event.find_by(id: input)
  puts "Enter the new description:"
  new_description = gets.chomp
  puts "Enter the new location:"
  new_location = gets.chomp
  puts "Enter the new start date and time 'YYYY-MM-DD 00:00':"
  new_start_time = gets.chomp
  puts "Enter the new end time 'YYYY-MM-DD 00:00':"
  new_end_time = gets.chomp
  event.update(description: new_description)
  event.update(location: new_location)
  event.update(start: new_start_time)
  event.update(:end => new_end_time)
  puts "#{event.description} has been updated."
end

def list_by_date
  Event.all.order(start: :desc).each do |event|
    if event.start > Time.now
      puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
    end
  end
  puts "\n"
  puts " '1' to view events for today."
  puts " '2' to view events for this week."
  puts " '3' to view events for this month."
  puts " '4' to view all expired events"
  case gets.chomp
  when '1'
    view_by_day
  when '2'
    view_by_week
  when '3'
    view_by_month
  when '4'
    expired_events
  else
    puts "Invalid."
    list_by_date
  end
end

def view_by_day
  Event.all.order(start: :desc).each do |event|
    if event.start.strftime("%d/") == Time.now.strftime("%d/")
      puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
    end
  end

  input = nil
  today = Date.today
  until input == '4'
    puts "\n"
    puts " '1' view yesterday's event"
    puts " '2' view tomorrow's event"
    puts " '3' return to menu"
    case gets.chomp
    when '1'
    today -= 1
    Event.all.order(start: :desc).each do |event|
      if event.start.strftime("%d/") == (today).strftime("%d/")
       puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
      end
    end
    when '2'
    today += 1
    Event.all.order(start: :desc).each do |event|
      if event.start.strftime("%d/") == (today).strftime("%d/")
        puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
      end
    end
  end
end
end

def view_by_week
  Event.all.order(start: :desc).each do |event|
    if event.start.strftime("%w/") == Time.now.strftime("%w/")
      puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
    end
  end
end

def view_by_month
  Event.all.order(start: :desc).each do |event|
    if event.start.strftime("%m/") == Time.now.strftime("%m/")
      puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
    end
  end
end

def expired_events
  Event.all.order(start: :desc).each do |event|
    if event.start < Time.now
      puts "#{event.description} @ #{event.start.strftime("%m/%d/%Y %I:%M%p")}"
    end
  end
end

menu
