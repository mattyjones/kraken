#! /usr/bin/env ruby
# require 'erb'
#
# weekday = Time.now.strftime('%A')
# simple_template = "Today is <%= weekday %>."
#
# renderer = ERB.new(simple_template)
# puts output = renderer.result()

require "erb"




  name = "matt"
  @template = File.read('./index.erb')
  info = ERB.new(@template).result( binding )

file_to_write = "./matt.txt"
begin
  file = File.open(file_to_write, "w")
  file.write("your text")
rescue IOError => e
  #some error occur, dir not writable etc.
ensure
  file.close unless file.nil?
end
