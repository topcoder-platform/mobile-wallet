Pod::Spec.new do |s|
  s.name        = "MobileWallet"
  s.version     = "0.1.5"
  s.summary     = "Mobile Wallet framework"
  s.homepage    = "https://github.com/topcoder-platform/mobile-wallet"
  s.license     = { :type => "MIT" }
  s.authors     = { "Topcoder" => "support@topcoder.com", "seriyvolk83" => "volk[at]frgroup.ru" }

  s.requires_arc = true
  s.swift_version = "5.0"
  s.ios.deployment_target = "13.0"
  s.source   = { :git => "https://github.com/topcoder-platform/mobile-wallet.git", :tag => s.version }
  s.source_files = 'Source/*.swift'
  s.vendored_frameworks = 'Libraries/vcx.framework'

  s.default_subspec = "Core"

  s.subspec 'Core' do |cs|
    cs.source_files = "Source/*.swift"
    cs.xcconfig = {
      'OTHER_LDFLAGS' => '-ObjC'
    }
  end
end
