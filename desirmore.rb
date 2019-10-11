#!/usr/bin/ruby

require 'optparse'
require 'find'

Options = Struct.new(:input, :base, :output, :preview)
options = Options.new('.', '', 'out', false)

opt_parser = OptionParser.new do |opts|
	opts.on("-iPATTERN", "--input PATTERN", "Files to convert pattern/glob (default '#{options.input}')") do |i|
		options.input = i
	end

	opts.on("-bBASE", "--base BASE", "Beginning part of input path to remove in output file path (default '#{options.base}')") do |b|
		options.base = b
	end

	opts.on("-oOUTPUT", "--output OUTPUT", "Converted files folder (default '#{options.output}')") do |o|
		options.output = o
	end

	opts.on("-p", "--preview", "Preview mode (default '#{options.preview}')") do |p|
		options.preview = p
	end

	opts.on("-h", "--help", "Dispaly this help message") do
		puts opts
		# TODO add ref to license
		exit
	end
end

opt_parser.parse!

puts options

current_dir = ''

Dir.glob(options.input) do |path|
	if File.basename(path)[0] == ?. or FileTest.symlink?(path)
		Find.prune
		next
	end

	next if FileTest.directory?(path)

	if current_dir != File.dirname(path)
		current_dir = File.dirname(path)
		puts "\n🖿 #{current_dir}"
	end

	puts "\t🗎 " + File.basename(path)

	output_file = options.output +
		'/' +	File.dirname(path.delete_prefix(options.base)) +
		'/' + File.basename(path, '.*') + '.m4a'
	output_file.squeeze!('/')

	puts "\t\t➜ " + output_file
end

# TODO:
# ffmpeg -i test.flac -c:a alac -c:v copy test.m4a