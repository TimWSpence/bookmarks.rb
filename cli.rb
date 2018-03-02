require 'gli'
require 'yaml'
require 'nokogiri'
require 'iniparse'

include GLI::App

program_desc 'A cli for managing bookmarks with tags'


pre do |global_options,command,options,args|
  $file = file()
  $bookmarks = YAML.load(File.read($file))
  $bookmarks["bookmarks"] ||= []
end

desc 'List current bookmarks'
command :list do |c|
  c.action do |global_options, options, args|
    puts YAML.dump($bookmarks)
  end
end

desc 'Edit the bookmark file'
command :edit do |c|
  c.action do |global_options, options, args|
    exec "#{ENV['EDITOR']} #{$file}"
  end
end

desc 'Add a bookmark'
arg '<name>'
arg '<url>'
arg '<url>'
arg '<tags...>'
command :add do |c|
  c.action do |global_options, options, args|
    name = args.shift
    url = args.shift
    tags = args
    add(name, url, *tags)
    save
  end
end

desc 'Search for bookmarks'
arg 'search term'
command :search do |c|
  c.action do |global_options, options, args|
    term = args.shift
    $bookmarks["bookmarks"].select do |b|
      b["name"] == term || (b["tags"].include? (term))
    end.each { |b| puts YAML.dump(b) }
  end
end

#TODO: add folders as tags
desc 'Import bookmarks from Chrome HTML export'
arg '<path to export file>'
command :import do |c|
  c.action do |global_options, options, args|
    export = args.shift
    import(export)
    save
  end
end

def add(name, url, *tags)
  $bookmarks["bookmarks"] << { "name" => name, "url" => url, "tags" => tags }
end

def import(path)
  str = File.read(path) 
  doc = Nokogiri::HTML::fragment(str)
  doc.xpath("./dl//a").each do |a|
    add(a.text, a["href"], [])
  end
end

def save
  File.write($file, YAML.dump($bookmarks))
end

def file
  config_file = File.expand_path(".bookmarks", File.dirname(__FILE__))
  default = File.expand_path("bookmarks.yml", File.dirname(__FILE__))
  if File.exists? config_file
    config = IniParse.parse(File.read(config_file))
    config["global"]["bookmarks_file"] || default
  else
    default
  end
end

exit run(ARGV)
