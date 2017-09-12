Pod::Spec.new do |s|
  s.name = 'LSPlayPauseButton'
  s.version = '1.0.0'
  s.license = 'MIT'
  s.summary = 'Video play button with animation style of iQiYi and YouKu'
  s.homepage = 'https://github.com/LaudyLaw/LSPlayPauseButton'
  s.description = <<-DESC
    This is a video play button with animation style of iQiYi and YouKu, which implement by Swift.
    DESC
  s.authors = { 'Luo Song' => 'luosongwork@163.com' }
  s.source = { :git => 'https://github.com/LaudyLaw/LSPlayPauseButton.git', :tag => s.version }
  s.platform = :ios, '9.0'

  s.source_files = 'Source/*.swift'
end
