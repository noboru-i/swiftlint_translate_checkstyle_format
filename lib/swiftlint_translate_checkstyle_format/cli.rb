require 'thor'

module SwiftlintTranslateCheckstyleFormat
  class CLI < Thor
    include ::SwiftlintTranslateCheckstyleFormat::Translate
    desc 'translate', 'Exec Translate'
    option :data
    option :file
    def translate
      data = fetch_data(options)
      parsed_data = parse(data)
      checkstyle = trans(parsed_data)
      checkstyle.write(STDOUT, 2)
    end

    no_commands do
      def fetch_data(options)
        data = \
          if options[:data]
            options[:data]
          elsif options[:file]
            File.read(options[:file])
          elsif !$stdin.tty?
            ARGV.clear
            ARGF.read
          end

        fail NoInputError if !data || data.empty?

        data
      end
    end
  end
end
