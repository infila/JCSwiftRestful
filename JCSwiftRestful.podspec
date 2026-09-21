Pod::Spec.new do |s|
  s.name             = 'JCSwiftRestful'
  s.version          = '2.0.0'
  s.summary          = 'A framework helps you pretty easy to implement as RESTful API style'

  s.description      = "This framework is for Restful APIs. It helps you focus more on handling object-oriented and structured data. To use this framework, you will have to write code using more standard RESTful semantics, both on iOS and server sides. Otherwise, the automatic serialization and deserialization functions within this framework will not work."

  s.homepage         = 'https://github.com/infila/JCSwiftRestful'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'James' => 'infilachen@gmail.com', 'Fanny' => 'fanfan.feng9@gmail.com'}
  s.source           = { :git => 'https://github.com/infila/JCSwiftRestful.git', :tag => '2.0.0' }
  s.social_media_url = 'https://www.linkedin.com/in/jameschen5428'

  s.ios.deployment_target = '13.0'
  s.swift_version    = '5.0'

  s.source_files = 'JCSwiftRestful/Classes/**/*'

  s.dependency 'JCSwiftCommon', '~> 2.0'
end
