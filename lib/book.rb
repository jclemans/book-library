class Book

  attr_reader :title, :author, :books, :id

  def initialize(attributes)
    @title  = attributes[:title]
    @author = attributes[:author]
    @id     = attributes[:id]
  end

  def self.create(attributes)
    new_book = Book.new(attributes)
    new_book.save
    new_book
  end

  def self.all
    books = []
    results = DB.exec("SELECT * FROM books;")
    results.each do |book|
      title = book['title']
      author = book['author']
      id = book['id'].to_i
      books << Book.new({ :title => title, :author => author, :id => id })
    end
    books
  end

  def self.fetch_by_title(title)
    book = []
    Book.all.each do |obj|
      if obj.title == title
        book << obj
      end
    end
    book
  end

  def self.fetch_by_author(author)
    book = []
    Book.all.each do |obj|
      if obj.author == author
        book << obj
      end
    end
    book
  end

  def save
    results = DB.exec("INSERT INTO books (title, author) VALUES ('#{@title}', '#{@author}') RETURNING id;")
    @id = results.first['id'].to_i
  end

  def ==(another_book)
    self.title == another_book.title && self.author == another_book.author && self.id == another_book.id
  end

  def burn
    DB.exec("DELETE FROM books WHERE id = #{self.id};")
  end

  def update(attributes)
    if attributes[:author].nil? then @author = @author else @author = attributes[:author] end
    @title = if attributes[:title].nil? then @title else attributes[:title] end
    updated_book = DB.exec("UPDATE books SET title = '#{@title}', author = '#{@author}' WHERE id = #{@id};")
    p @author
    p @title
  end

end











