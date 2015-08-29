interactor :off

guard :rspec, cmd: 'bundle exec rspec' do
  watch(%r{^lib\/(.+).rb$}) do |m|
    "spec/#{m[1]}_spec.rb"
  end

  watch(%r{^lib\/(.+)\/(.+).rb$}) do |m|
    "spec/#{m[1]}_#{m[2]}_spec.rb"
  end

  watch(%r{^spec\/(.+).rb$}) do |m|
    "spec/#{m[1]}.rb"
  end
end

# EOF
