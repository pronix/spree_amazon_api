namespace :spree_amazon_api do
  desc "Copies all migrations and assets (NOTE: This will be obsolete with Rails 3.1)"

  task :install do
    Rake::Task['spree_amazon_api:install:migrations'].invoke
    Rake::Task['spree_amazon_api:install:assets'].invoke
    Rake::Task['spree_amazon_api:install:root_categories'].invoke
    Rake::Task['spree_amazon_api:install:amazon'].invoke
  end

  namespace :install do
    desc "Copies all migrations (NOTE: This will be obsolete with Rails 3.1)"
    task :migrations do
      source = File.join(File.dirname(__FILE__), '..', '..', 'db')
      destination = File.join(Rails.root, 'db')
      Spree::FileUtilz.mirror_files(source, destination)
    end

    desc "Copies all assets (NOTE: This will be obsolete with Rails 3.1)"
    task :assets do
      source = File.join(File.dirname(__FILE__), '..', '..', 'public')
      destination = File.join(Rails.root, 'public')
      puts "INFO: Mirroring assets from #{source} to #{destination}"
      Spree::FileUtilz.mirror_files(source, destination)
    end

    desc "Copies root amazon categories"
    task :root_categories do
      source = File.join(File.dirname(__FILE__), '..', '..', 'data', 'amazon_categories.yml')
      destination = File.join(Rails.root , 'db', 'amazon_categories.yml')
      Spree::FileUtilz.mirror_files(source, destination)
    end

    desc "Init amazon configure"
    task :amazon do
      source = File.join(File.dirname(__FILE__), '..', '..', 'config', 'amazon.yml')
      destination = File.join(Rails.root, 'config', 'amazon.yml')
      Spree::FileUtilz.mirror_files(source, destination)
    end

  end

end
