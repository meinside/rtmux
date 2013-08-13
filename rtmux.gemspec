Gem::Specification.new do |s|
  s.name        = 'rtmux'
  s.version     = '0.0.1'
  s.platform    = Gem::Platform::RUBY
  s.date        = '2013-08-13'
  s.summary     = "tmux helper"
  s.description = "help create/resume tmux sessions"
  s.authors     = ["Sungjin Han"]
  s.email       = "meinside@gmail.com"
  s.files       = Dir["lib/*.rb"] + Dir["bin/*"]
  s.executables << "rtmux"
  s.add_dependency("thor", ">= 0")
  s.homepage    = "http://github.com/meinside/rtmux"
  s.license     = 'MIT'
end
