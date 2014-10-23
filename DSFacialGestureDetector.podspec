Pod::Spec.new do |s|
  s.name         = "DSFacialGestureDetector"
  s.version      = "0.0.1"
  s.summary      = "CIDetector with streaming video"
  s.requires_arc = true
  s.description  = <<-DESC
                   Making Facial Gestures or, Using CIDetector with Streaming Video
                   DESC

  s.homepage     = "http://dannyshmueli.com/blog/2014/10/23/cidetector-with-live-video-uifacialgestuures/"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"

  s.license = { :type => 'MIT', :file => 'MIT-LICENSE' }
  s.author             = { "Danny Shmueli" => "" }
  s.social_media_url   = "http://twitter.com/dannyshmueli"

  s.platform     = :ios
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/dannyshmueli/DSFacialGestureDetector.git", :tag => "0.0.1" }

  s.source_files  = "Detector", "Classes/**/*.{h,m}"
  s.exclude_files = "DSFacialGestureDetectorExampleProject"

end
