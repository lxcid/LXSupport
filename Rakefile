class String
  def self.colorize(text, color_code)
    "\e[#{color_code}m#{text}\e[0m"
  end

  def red
    self.class.colorize(self, 31)
  end

  def green
    self.class.colorize(self, 32)
  end
end

def test_scheme(scheme, verbose = false)
  command = "xcodebuild -project src/LXSupport/LXSupport.xcodeproj -target LXSupportTests -sdk iphonesimulator -configuration Debug TEST_AFTER_BUILD=YES 2>&1"
  IO.popen(command) do |io|
    out = 0
    while line = io.gets do
      if verbose
        puts line
      else
        if line =~ /Started tests for architectures/
          out = out + 1
        elsif line =~ /Completed tests for architectures/
          out = out - 1
        end
        
        puts line if out > 0
      end
      
      if line == "** BUILD SUCCEEDED **\n"
        return 0
      elsif line == "** BUILD FAILED **\n"
        return 1
      end
    end
  end
end

desc 'Run the tests'
task :test do
  verbose = ENV['VERBOSE']
  ios = test_scheme('LXSupport', verbose)

  puts "\n\n\n" if verbose
  puts "iOS: #{ios == 0 ? 'PASSED'.green : 'FAILED'.red}"
  exit(ios)
end

task :default => :test
