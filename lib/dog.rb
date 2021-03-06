class Dog

  attr_accessor :name, :breed
  attr_reader :id
  
  def initialize(name:, breed:, id:nil)
  	self.name = name
  	self.breed = breed
  	@id = id
  end

  def self.create_table
  	sql = <<-SQL
      CREATE TABLE IF NOT EXISTS dogs(
      	id INTEGER PRIMARY KEY,
      	name TEXT,
      	breed TEXT);
	  SQL

	DB[:conn].execute(sql)
  end

  def self.drop_table
  	sql = "DROP TABLE dogs;"

	DB[:conn].execute(sql)
  end

  def save
  	
 			sql = <<-SQL
 				INSERT INTO dogs(name, breed)
 				VALUES(?,?)
 			SQL

 			DB[:conn].execute(sql, self.name, self.breed)
 			@id = DB[:conn].execute("SELECT last_insert_rowid() FROM dogs;")[0][0]
 		
 	end

 	def self.create(name:,breed:)
 		new_dog = Dog.new(name:name,breed:breed)
 		new_dog.save
 		new_dog
 	end

 	def self.find_by_id(id)
 		sql = <<-SQL
 			SELECT * FROM dogs
 			WHERE id = ?;
 		SQL

 		row = DB[:conn].execute(sql,id).first
 		self.new_from_db(row) 
 	end

 	def self.new_from_db(row)
 		Dog.new(name: row[1], breed: row[2], id: row[0])
 	end

 	def self.find_or_create_by(name:, breed:)
 		sql = <<-SQL
 			SELECT * FROM dogs WHERE name = ? AND breed = ?;
 		SQL

 		result = DB[:conn].execute(sql, name, breed)

 		if result.empty?
 			self.create(name:name, breed:breed)
 		else
 			self.new_from_db(result.first)
 		end
 	end

 	def self.find_by_name(name)
 		row = DB[:conn].execute("SELECT * FROM dogs WHERE
 			name =?;", name).first
 		self.new_from_db(row)
 	end
 	













end
