require "relapse/builders/windows_builder"

module Relapse
  module Builders
    # Creates a completely standalone (self-extracting when run) Windows executable.
    class WindowsStandalone < WindowsBuilder
      Builders.register self

      DEFAULT_FOLDER_SUFFIX = "WIN32_EXE"

      # Self-extracting standalone executable.
      def generate_tasks
        directory folder

        file folder => project.files do
          Rake::FileUtilsExt.verbose project.verbose?

          project.exposed_files.each {|file| cp file, folder }

          create_link_files folder

          exec %[#{ocra_command} --output "#{folder}/#{executable_name}"]
        end

        desc "Build standalone exe #{project.version} [Ocra]"
        task "build:windows:standalone" => folder
      end

      protected
      def executable_name; "#{project.underscored_name}.exe"; end
    end
  end
end