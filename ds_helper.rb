# require 'file'

class DSHelper
  def self.create_private_key_temp_file
    @@path = File.join(
        File.dirname(File.dirname(File.absolute_path(__FILE__))),
        'pk.txt'
    )
    return path
  end

  def self.readContent(path)
    # code here
  end
end