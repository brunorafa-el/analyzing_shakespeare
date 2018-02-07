require 'nokogiri'
require 'open-uri'
require 'pry'
require_relative 'user'

class MacBethAnalyzer
  attr_reader :file_url

  def initialize(file_url)
    @file_url = file_url
  end

  # def count_speaks
  #   speakers_num = extract_content.each_with_object(Hash.new(0)) { |speaker, num| num[speaker] += 1 }
  #   speakers_num.each do |speaker, num|
  #     puts "#{num}: #{speaker}" unless speaker == "ALL"
  #   end
  # end

  # private

  def parsed_speakers
    doc = Nokogiri::HTML(open(file_url)).xpath('//speech')

    users = []
    speeches = []

    doc.each do |line|
      if line.css('speech')
        current_parser = User.new(
          line.css('speaker').text,
          speeches << line.to_a.css('line').text
        )
      end
      if line.css('/speech') && current_parser
        users << current_parser
        current_parser, speeches = nil
      end
    end
    binding.pry
  end

  # def extract_content
  #   parsed_speakers.map { |object| object.content }
  # end

end

mac_beth = MacBethAnalyzer.new("http://www.ibiblio.org/xml/examples/shakespeare/macbeth.xml")
mac_beth.parsed_speakers
