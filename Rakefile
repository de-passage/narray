#require "bundler/gem_tasks"
require "rake/testtask"

Rake::TestTask.new do |t|
	t.libs.push 'test'
	t.pattern = 'test/**/*_test.rb'
	t.warning = true
	t.verbose = true
	#t.test_files = FileList['test/**/*.rb']
end

desc "Run tests"

task default: :test
