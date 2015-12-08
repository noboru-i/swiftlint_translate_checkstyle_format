require 'json'
require 'rexml/document'

module SwiftlintTranslateCheckstyleFormat
  module Translate
    def parse(str)
      JSON.load(str)
    end

    def trans(json)
      doc = REXML::Document.new
      doc << REXML::XMLDecl.new('1.0', 'UTF-8')

      checkstyle = doc.add_element('checkstyle')
      if json.empty?
        SwiftlintTranslateCheckstyleFormat::Translate.add_dummy(checkstyle)
        return doc
      end

      json.each do |result|
        file = checkstyle.add_element('file',
                                      'name' => result['file']
                                     )
        file.add_element('error',
                         'line' => result['line'],
                         'severity' => 'error',
                         'message' => SwiftlintTranslateCheckstyleFormat::Translate.create_message(result)
                        )
      end

      doc
    end

    def self.add_dummy(checkstyle)
      checkstyle.add_element('file',
                             'name' => ''
                            )

      checkstyle
    end

    def self.create_message(result)
      "[#{result['severity']}][#{result['rule_id']}] #{result['type']}\n#{result['reason']}"
    end
  end
end
