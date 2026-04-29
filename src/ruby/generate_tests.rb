# frozen_string_literal: true

require 'logger-application'
require 'optparse'
require 'csv'
require 'digest'

class GenerateTests < Logger::Application

  def run
    options = {}
    OptionParser.new do |opts|
      opts.on('-g', '--graph GRAPH', 'graph to search') do |g|
        options[:graph] = g
      end
      opts.on('-p', '--path PATH', 'output path') do |p|
        options[:path] = p
      end
    end.parse!

    raise 'No graph specified' unless options[:graph]
    raise 'No output path specified' unless options[:path]

    Dir.mkdir(options[:path]) unless Dir.exist?(options[:path])

    log(INFO, "writing tests to #{options[:path]}")
    CSV.new(ARGF.read, headers: true, col_sep: "\t").each do |row|
      obj = row['?obj'] =~ /^<.*>$/ ? row['?obj'] : "\"#{row['?obj']}\""
      sparql = %Q(
        ASK {
          GRAPH #{options[:graph]} {
            #{row['?iri']}
              #{row['?pred']}
              #{obj}
          }
        }
      )
      filename = "test-#{Digest::MD5.hexdigest(row.inspect)}.sparql"
      log(INFO, "Generating #{filename}")
      File.open("#{options[:path]}/#{filename}", "w") do |f|
        f.write(sparql)
      end
    end

  end

end

GenerateTests.new('generate-tests').start
