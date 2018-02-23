class Student
  attr_accessor :id, :name, :grade

  def self.new_from_db(row)
    student = new
    student.id, student.name, student.grade = row
    student
  end

  def self.all
    rows = DB[:conn].execute('SELECT * FROM students')
    rows.map { |row| self.new_from_db(row) }
  end

  def self.find_by_name(name)
    sql = <<-SQL
    SELECT *
    FROM students
    WHERE name = ?
    SQL

    row = DB[:conn].execute(sql, name).first
    new_from_db(row)
  end

  def save
    sql = <<-SQL
      INSERT INTO students (name, grade)
      VALUES (?, ?)
    SQL

    DB[:conn].execute(sql, self.name, self.grade)
  end

  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end

  def self.count_all_students_in_grade_9
    result = self.all
    puts
    puts
    print result
    puts 
    puts
    # .find_all { |student| student.grade == 9 }
  end
end
