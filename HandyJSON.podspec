Pod::Spec.new do |s|
    s.watchos.deployment_target = '2.0'
    s.tvos.deployment_target = '9.0'

    s.pod_target_xcconfig = { 'SWIFT_VERSION' => '5.0' }
end
