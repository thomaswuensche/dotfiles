#!/usr/bin/env ruby

path = ARGV.first

dirname = File.dirname(path)
name = File.basename(path, '.*')
extname = File.extname(path)

name.downcase!
name.gsub!('ä', 'ae')
name.gsub!('ö', 'oe')
name.gsub!('ü', 'ue')
name.gsub!(/[\s-]/, '_')
name.gsub!(/\W/, '')
name.squeeze!('_')
name.delete_prefix!('_')
name.delete_suffix!('_')

new_name = "#{dirname}/#{name}#{extname}"

if File.exist?(new_name)
  puts "#{new_name} already exists"
else
  puts "#{path} -> #{new_name}"
  File.rename(path, new_name)
end
