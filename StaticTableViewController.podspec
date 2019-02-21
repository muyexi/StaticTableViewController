Pod::Spec.new do |s|
  s.name         = 'StaticTableViewController'
  s.version      = '1.1.0'
  s.platform 	   = :ios, '8.0'
  s.summary      = 'Enabling animated hide/show of static cells for UITableView.'
  s.license      = 'MIT'
  s.homepage     = 'https://github.com/muyexi/StaticTableViewController'
  s.author       = { 'muyexi' => 'muyexi@gmail.com' }
  s.source       = { :git => 'https://github.com/muyexi/StaticTableViewController.git', :tag => s.version }
  s.source_files = 'Sources/*.swift'
  s.swift_version = '4.2'
end
