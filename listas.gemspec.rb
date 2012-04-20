# source "http://rubygems.org"
# gem "nokogiri"
# gem "thin"
# gem "sinatra"

# require 'rake/gempackagetask'
# spec = Gem::Specification.new do |s|
	# s.name			  = "vizinhos"
	# s.summary		  = "Encontre vizinhos de um endereço fornecido"
	# s.description	= "Forneca um endereco e encontre os vizinhos deste endereco." # File.read(File.join(File.dirname(__FILE__), 'README'))
	# s.version		  = "0.0.1"
	# s.author		  = "Vladimir"
	# s.platform		= Gem::Platform::RUBY
	# s.required_ruby_version		= '>=1.9'
	# s.files		    = Dir['**/**']
	# s.executables	= [ 'listas' ]
	# s.test_files	= Dir["test/test*.rb"]
	# s.has_rdoc		= true
# end
# spec.add_dependency('nokogiri')
# spec.add_dependency('thin')
# spec.add_dependency('sinatra')
# Rake::GemPackageTask.new(spec).define	


Gem::Specification.new do |s|
 	s.name			  = "vizinhos"
	s.summary		  = "Encontre vizinhos de um endereço fornecido"
	s.description	= "Forneca um endereco e encontre os vizinhos deste endereco." # File.read(File.join(File.dirname(__FILE__), 'README'))
#	s.requirements	= ['']
	s.version		  = "0.0.1"
	s.author		  = "Vladimir"
#	s.email		    = "listas"
#	s.homepage		= "listas"
	s.platform		= Gem::Platform::RUBY
	s.required_ruby_version		= '>=1.9'
	s.files		    = Dir['**/**']
	s.executables	= [ 'listas.rb' ]
	s.test_files	= Dir["test/test*.rb"]
	s.has_rdoc		= false
  s.add_dependency('rubygems')
  s.add_dependency('bundler/setup')
  s.add_dependency('nokogiri')
  s.add_dependency('thin')
  s.add_dependency('sinatra')
end
