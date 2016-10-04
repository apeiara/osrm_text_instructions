require 'yaml'
require 'osrm_text_instructions/version'
require 'osrm_text_instructions/utils'
require 'osrm_text_instructions/compiler'

module OSRMTextInstructions
  def self.compile(step, locale: 'en', version: 'v5')
    Compiler.new(load_instruction_yaml(locale), version).compile(step)
  end

  def self.load_instruction_yaml(locale)
    YAML.load_file(File.expand_path("#{__dir__}/../i18n/#{locale}.yml"))
  rescue Errno::ENOENT => e
    raise "Locale #{locale} not available"
  end
end
