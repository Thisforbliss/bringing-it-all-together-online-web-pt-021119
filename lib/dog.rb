class Dog 
  
  attr_accessor :name, :breed 
  attr_reader :id
  
  def initialize (args)
    @id = args[:id]
    @name = args[:name]
    @breed = args[:breed]
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS dogs 
    (id INTEGER PRIMARY KEY,
    name TEXT
    breed TEXT)
    SQL
    DB[:conn].execute(sql)
  end

  def self.drop_table
    DB[:conn].execute("DROP TABLE IF EXISTS dogs")
  end
  
  def update
  sql = "update dogs SET name = ?, breed = ? WHERE id = ?"
  DB[:conn].execute(sql, self.name, self.name, self.breed, self.id)
  end
  
  
  def save
    if self.id
      self.update
    else
    sql = <<-SQL
    INSERT INTO dogs (name, breed)
    VALUES(?, ?)
    SQL
    
    DB[:conn].execute(sql, self.name, self.breed)
    @id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs")[0][0]
    new_from_db(self)
    end
  end
  
  def self.new_from_db(row)
    id = row[0]
    name = row[1]
    breed = row[2]
    dog = self.new(id, name, breed)
    dog
  end
  
  
  
end