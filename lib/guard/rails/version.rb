module GuardRails
  module Version
    MAJOR,MINOR,TINY = File.read(File.join(File.dirname(__FILE__), '../../../VERSION')).split('.')
    FULL = [MAJOR, MINOR, TINY].join('.')
  end

  def self.version
    Version::FULL
  end
end
