require 'rubygems'
require 'net/scp'
require 'yaml'

module SshKeyMan
  class UserCreate
    # creae the root privileges user 
    # user default "sa"
    def self.create_user group,user="sa"
      server_list_path = File.join(".", "server_list.yml")
      servers = YAML::load_file(server_list_path)[group]['servers']
      raise "No Server Group: #{group}" if servers.size == 0

      SshKeyMan::PublicKeyCombiner.combine group,user
      servers.each do |server_info|
        user_set server_info["host"],server_info["port"]||"22",server_info['user'],user
      end
      SshKeyMan::Uploader.upload_all_public_keys group,user
    end

    # crate user , set root privileges and remove app privileges
    def self.user_set host, port, user,created_user
      source = File.join File.dirname(__FILE__),'script','user_create.sh' 
      if user_exist(host, port, created_user)
        puts "#{created_user} not exist going create"
        `scp -P #{port} #{source} #{user}@#{host}:~/tmp` 
        `ssh -p #{port} #{user}@#{host} 'sudo sh ~/tmp/user_create.sh'`
        puts "#{host} user #{created_user} created , removed the app root privilege"
      else
        puts "#{host} #{created_user} user exist"
      end

    end

    def self.user_exist host, port, user
      exist = `ssh -p #{port} #{user}@#{host} whoami`
      return exist.empty?
    end

  end
end
