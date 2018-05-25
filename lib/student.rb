
require 'pry'
class Student
  attr_accessor :id, :name, :grade



  def self.new_from_db(row)
  students = self.new
  students.id = row[0]
  students.name =  row[1]
  students.grade = row[2]
  students
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
        SELECT *
        FROM students
        SQL
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end

    #   DB[:conn].execute(sql, name).map do |row|
    #   self.new_from_db(row)
    # end
  end

  def self.count_all_students_in_grade_9
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 9
        SQL
      DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
  end
  def self.students_below_12th_grade
    sql = <<-SQL

        SELECT *
        FROM students
        WHERE grade < 12
        SQL
        DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
        end
  end

  def self.first_X_students_in_grade_10(grade)
    sql = <<-SQL
      SELECT *
      FROM students
      WHERE grade = 10
      LIMIT 2
      SQL

     DB[:conn].execute(sql).map do |row|
        self.new_from_db(row)
      end
    #binding.pry
  end
  def self.first_student_in_grade_10
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = 10
        SQL
        DB[:conn].execute(sql).map do |row|
          self.new_from_db(row)
        end.first
  end
  def self.all_students_in_grade_X(grade)
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE grade = ?
        SQL

        DB[:conn].execute(sql, grade).map do |row|
          self.new_from_db(row)
        end

  end
  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
        SELECT *
        FROM students
        WHERE name = ?
        SQL

      DB[:conn].execute(sql, name).map do |row|
      self.new_from_db(row)
    end.first
      #the above code executes the SQL query and maps the rows
      #from a new instance of the class,DB.
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

  #binding.pry
end
