require 'gdbm'

module Musicality
class SampleDatabase
  def initialize db_path
    @db = GDBM.new(db_path)
  end
  
  def add_record sample_record
    yaml = sample_record.to_yaml
    @db[sample_record.id] = yaml
  end
  
  def retrieve_record id
    yaml = @db[sample_record.id]
    return YAML.load(yaml)
  end
  
  def del_record id
  end
end
end
