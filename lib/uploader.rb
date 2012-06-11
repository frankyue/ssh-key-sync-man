require 'rubygems'
require 'net/scp'
require 'yaml'

module SshKeyMan
  class Uploader
    # upload authorized_keys for a specific group
    #
    def self.upload_all_public_keys group,user=nil
      authorized_keys = File.join(".", "authorized_keys")
      upload_to_all_servers authorized_keys, "~/.ssh/", group,user
    end

    # upload file to a group of servers
    #
    def self.upload_to_all_servers source, dest, group,user
      server_list_path = File.join(".", "server_list.yml")
      servers = YAML::load_file(server_list_path)[group]['servers']
      raise "No Server Group: #{group}" if servers.size == 0
      servers.each do |server_info|
        username = user || server_info["user"]
        upload! server_info["host"], server_info["port"]||"22", username,source, dest
      end
    end

    # upload a file to a remote server
    #
    def self.upload! host, port, user, source, dest
      puts "coping file from #{source} to #{user}@#{host}:#{dest}"

      `scp -P #{port} #{source} #{user}@#{host}:#{dest}`
      raise "upload failed" if $?.exitstatus != 0
    end
  end
end
