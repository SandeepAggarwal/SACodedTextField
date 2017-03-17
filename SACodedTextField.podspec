@version = "0.0.1"

Pod::Spec.new do |s|

  s.name         = "SACodedTextField"
  s.version      = @version
  s.summary      = "A simple text field for building activation code text field like [WhatsApp](https://www.whatsapp.com/) for iOS"

  # This description is used to generate tags and improve search results.
  #   * Think: What does it do? Why did you write it? What is the focus?
  #   * Try to keep it short, snappy and to the point.
  #   * Write the description between the DESC delimiters below.
  #   * Finally, don't worry about the indent, CocoaPods strips it!
  s.description  = <<-DESC
A simple text field for building activation code text field like [WhatsApp](https://www.whatsapp.com/)
                   DESC

  s.homepage     = "https://github.com/SandeepAggarwal/SACodedTextField"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"


  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Sandeep Aggarwal" => "smartsandeep1129@gmail.com" }
  s.social_media_url   = "https://twitter.com/sandeepCool77"
  s.platform     = :ios, "8.0"
  s.source       = { :git => "https://github.com/SandeepAggarwal/SACodedTextField.git", :tag => "#{s.version}" }


  s.source_files  = "ActivationCodeTextField.{h,m}"
  s.requires_arc = true

end
