#
# Be sure to run `pod lib lint ConstraintBuilder.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ConstraintBuilder'
  s.version          = '1.0.2'
  s.summary          = 'UIKit constraint builder with activate, deactivate and update methods'
  s.homepage         = 'https://github.com/umobi/ConstraintBuilder'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'brennobemoura' => 'brenno@umobi.com.br' }
  s.source           = { :git => 'https://github.com/umobi/ConstraintBuilder.git', :tag => s.version.to_s }

  s.ios.deployment_target = '10.0'
  s.tvos.deployment_target = '10.0'
  s.swift_version = '5.1'

  s.description      = <<-DESC
  TODO: Add long description of the pod here.
                         DESC

  s.source_files = 'Sources/ConstraintBuilder/**/*'

end
