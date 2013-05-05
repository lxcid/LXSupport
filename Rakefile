desc 'Run the tests'
task :test do
  exec('src/Vendors/xctool/xctool.sh -project src/LXSupport/LXSupport.xcodeproj -scheme LXSupport test')
end

task :default => :test
