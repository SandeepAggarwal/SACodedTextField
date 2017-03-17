@version = "0.0.3"

Pod::Spec.new do |s|

  s.name         = "SACodedTextField"
  s.version      = @version
  s.summary      = "A simple text field for building 'activation code text field' like [WhatsApp](https://www.whatsapp.com/) for iOS"

  s.description  = <<-DESC
                    SACodedTextField is a simple text field for building 'activation code text field' like [WhatsApp](https://www.whatsapp.com/). It is highly customizable.
                   DESC

  s.homepage     = "https://github.com/SandeepAggarwal/SACodedTextField"
  s.screenshots  = "https://github.com/SandeepAggarwal/SACodedTextField/raw/master/Previews/SACodedTF2.gif", "https://github.com/SandeepAggarwal/SACodedTextField/raw/master/Previews/SACodedTF1.gif"


  s.license      = { :type => "MIT", :file => "LICENSE" }

  s.author             = { "Sandeep Aggarwal" => "smartsandeep1129@gmail.com" }
  s.social_media_url   = "https://twitter.com/sandeepCool77"
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/SandeepAggarwal/SACodedTextField.git", :tag => "#{s.version}" }


  s.source_files  = "ActivationCodeTextField/ActivationCodeTextField.{h,m}"
  s.framework  = "UIKit"
  s.requires_arc = true

end
