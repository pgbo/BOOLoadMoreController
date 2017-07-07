Pod::Spec.new do |spec|
    spec.name                  = 'BOOLoadMoreController'
    spec.version               = '1.0.3'
    spec.summary               = 'Decoupled solution for DROP UP TO LOAD MORE'

    spec.description           = <<-DESC
                               DROP UP TO LOAD MORE is popular, but this is the best decoupled. 
                               DESC

    spec.homepage              = 'https://github.com/pgbo/BOOLoadMoreController.git'
    spec.license               = { :type => 'MIT', :file => 'LICENSE' }
    spec.author                = { 'pgbo' => '460667915@qq.com' }
    spec.platform              = :ios, '7.0'
    spec.source                = { :git => 'https://github.com/pgbo/BOOLoadMoreController.git', :tag => spec.version }
    spec.source_files          = 'Classes/*.{h,m}'
    spec.requires_arc          = true
    spec.frameworks            = 'UIKit', 'Foundation'

end