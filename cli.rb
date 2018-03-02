require 'gli'
require 'yaml'
require 'nokogiri'

include GLI::App

program_desc 'A cli for managing bookmarks with tags'

pre do |global_options,command,options,args|
  bookmarks = YAML.load(File.read("bookmarks.yml"))
  bookmarks["bookmarks"] ||= []
  global_options[:bookmarks] = bookmarks
end

desc 'List current bookmarks'
command :list do |c|
  c.action do |global_options, options, args|
    puts YAML.dump(global_options[:bookmarks])
  end
end

desc 'Add a bookmark'
arg '<name>'
arg '<url>'
arg '<url>'
arg '<tags...>'
command :add do |c|
  c.action do |global_options, options, args|
    bookmarks = global_options[:bookmarks]
    name = args.shift
    url = args.shift
    tags = args
    add(bookmarks, name, url, *tags)
    save(bookmarks)
  end
end

desc 'Search for bookmarks'
arg 'search term'
command :search do |c|
  c.action do |global_options, options, args|
    bookmarks = global_options[:bookmarks]
    term = args.shift
    bookmarks["bookmarks"].select do |b|
      b["name"] == term || (b["tags"].include? (term))
    end.each { |b| puts YAML.dump(b) }
  end
end

#TODO: add folders as tags
desc 'Import bookmarks from Chrome HTML export'
arg '<path to export file>'
command :import do |c|
  c.action do |global_options, options, args|
    bookmarks = global_options[:bookmarks]
    export = args.shift
    import(export, bookmarks)
    save(bookmarks)
  end
end

def add(bookmarks, name, url, *tags)
  bookmarks["bookmarks"] << { "name" => name, "url" => url, "tags" => tags }
end

def import(path, bookmarks)
  str = File.read(path) 
  doc = Nokogiri::HTML::fragment(str)
  doc.xpath("./dl//a").each do |a|
    add(bookmarks, a.text, a["href"], [])
  end
end

def save(bookmarks)
  File.write("bookmarks.yml", YAML.dump(bookmarks))
end

exit run(ARGV)
