require "pairity/version"

class Pairity
  class KeyNotConfigured < StandardError
    attr_accessor :name

    def initialize(name)
      self.name = name
    end

    def message
      "Could not find a file or env var for #{name}"
    end
  end
  
  def self.home
    ENV['HOME'] || '/tmp'
  end

  def self.root
    @root ||= File.join(home, '.pairity')
  end

  def self.root=(path)
    @root = path
  end

  def self.with_key_paths(*key_names, &blk)
    keys = key_names.map { |name| new(name) }

    paths = keys.map(&:path)

    result = blk.call *paths

    keys.map(&:unlink_temp_file)

    result
  end

  def self.with_keys(*key_names, &blk)
    keys = key_names.map { |name| new(name) }

    contents = keys.map(&:content)

    result = blk.call *contents

    keys.map(&:unlink_temp_file)

    result
  end

  attr_accessor :name

  def initialize(name)
    self.name = name.upcase
  end

  def friendly_name
    name.downcase.gsub('_', '-')
  end

  def env
    ENV[name]
  end
  def path_env
    ENV["#{name}_PATH"]
  end

  def path
    if File.exist?(default_path)
      default_path
    elsif path_env
      path_env
    elsif env
      temp_path
    else
      raise KeyNotConfigured, name
    end
  end

  def content
    File.read path
  end

  def temp_path
    temp_file.path
  end

  def temp_file
    return @temp_file if @temp_file && File.exist?(@temp_file)

    file = Tempfile.new 'temp-key'
    file.write env
    file.close
    @temp_path = file
  end

  def default_path
    File.join(self.class.root, "#{friendly_name}.key")
  end

  def unlink_temp_file
    if path_env.nil? && env
      temp_file.unlink
    end
  end
end
