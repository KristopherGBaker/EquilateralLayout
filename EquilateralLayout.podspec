Pod::Spec.new do |s|

  s.name         = "EquilateralLayout"
  s.version      = "0.1.0"
  s.summary      = "Custom UICollectionViewLayout that uses equilateral triangles for positioning cells."

  s.description  = <<-DESC
                   Custom UICollectionViewLayout that uses equilateral triangles for positioning cells.
                   DESC

  s.homepage     = "https://github.com/KristopherGBaker/EquilateralLayout"
  s.license      = { :type => "MIT", :file => "LICENSE" }
  s.author       = { "Kristopher Baker" => "kris+github@krisbaker.com" }

  s.ios.deployment_target = "8.0"

  s.source = { :git => "https://github.com/KristopherGBaker/EquilateralLayout.git", :tag => "#{s.version}" }
  s.source_files  = "EquilateralLayout/*.swift"

  s.requires_arc = true

end
