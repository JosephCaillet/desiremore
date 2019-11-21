#!/usr/bin/ruby

require 'optparse'
require 'find'
require 'fileutils'
require 'shellwords'

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
		exit
	end
end

opt_parser.parse!

# puts options

puts "Listing files..."
input_files = Dir.glob(options.input)


if input_files.length == 0
	puts "No files found for: " + options.input
	exit
end

#inspired by https://stackoverflow.com/a/1679963
class Numeric
	def duration
		secs  = self.to_int
		mins  = secs / 60
		hours = mins / 60
		days  = hours / 24

		if days > 0
			"#{days}d#{hours % 24}h"
		elsif hours > 0
			"#{hours}h#{mins % 60}m"
		elsif mins > 0
			"#{mins}m#{secs % 60}s"
		elsif secs >= 0
			"#{secs}s"
		end
	end
end

def get_output_path(input_path, options, full_path = true)
	return File.basename(input_path, '.*') + '.m4a' unless full_path
	output_file = options.output +
		'/' +	File.dirname(input_path.delete_prefix(options.base)) +
		'/' + File.basename(input_path, '.*') + '.m4a'
	output_file.squeeze('/')
end

current_dir = ''
start_time = Time.now

puts_with_progress = lambda do |message, index|
	duration = (Time.now - start_time).duration
	if options.preview
		puts "[#{index+1}/#{input_files.length}]\033[0m\t#{message}"
	else
		puts "\e[40m[#{index+1}/#{input_files.length} #{(index.+(1).to_f / input_files.length * 100).truncate()}% ][ #{duration} ]\t#{message}\033[0m"
	end
end

errors = []

input_files.each_with_index do |path, index|
	if File.basename(path)[0] == ?. or FileTest.symlink?(path)
		Find.prune
		next
	end

	next if FileTest.directory?(path)

	if current_dir != File.dirname(path)
		current_dir = File.dirname(path)
		puts_with_progress.("🖿 #{current_dir.delete_prefix(options.base)}", index)
	end

	output_path = get_output_path(path, options)

	if options.preview
		puts_with_progress.("\t♫ " + File.basename(path), index)
		puts_with_progress.("\t\t➜ " + output_path, index)
	else
		puts_with_progress.("\t♫ " + File.basename(path) + "\t➜\t" + get_output_path(path, options, false), index)
		FileUtils.mkdir_p File.dirname output_path

		conversion_options = "-c:a alac -c:v copy"
		logging_options = "-loglevel warning -stats -hide_banner"
		cli = "ffmpeg -i #{Shellwords.escape path} #{conversion_options} #{Shellwords.escape output_path} #{logging_options}"
		success = system(cli)
		if not success
			errors.push(path)
		end
	end
end

puts "\n🏳 Done!#{options.preview ? ' (preview mode)' : ''}"

if errors.any?
	puts "\n⚠ Encountered #{errors.length} conversion error#{errors.length > 1 ? 's' : ''}."
end

# TODO:
# refator with better consistant path/dir variables/parameters names
# create main function
# add ref to license
# add ref to github page
# show error at the end if user want it