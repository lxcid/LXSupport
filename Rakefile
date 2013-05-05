desc 'Run the tests'
task :test do
  exec('cd src/LXSupport/ && ../Vendors/xctool/xctool.sh -project LXSupport.xcodeproj -scheme LXSupport test')
end

task :default => :test
