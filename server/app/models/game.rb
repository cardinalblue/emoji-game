class Game < ActiveRecord::Base
  QA = <<-TEXT.split(/\n/).map(&:strip).map(&:presence).compact.map{|s| s.split(/\//)}
_/Lion
_/Pirates of the Caribbean
_/Michael Jackson
_/Katy Perry
_/Lady Gaga
_/Taiwan
_/Ching-Mei
_/Mica
_/Dix
_/Ruby
_/Free Willy
_/Hangover
_/Titanic
_/Alien
_/The Godfather
_/Life of Pi
_/Iron Man
_/Lord of the Rings
_/Shrek
_/Inception
_/The Devil Wears Prada
_/The Matrix
_/The Lion King
_/Aladdin
_/The Little Mermaid
_/The Wizard of Oz
_/The Dark Knight
_/Home Alone
_/Forrest Gump
_/Breaking Bad
_/Friends
_/The Simpsons
_/Game of Thrones
_/Family Guy
_/Lost
_/the IT crowd
_/how I met your mother
_/wipeout
_/suits
_/house md
_/mythbusters
_/survivor
_/harry potter
_/narnia
_/gone with the wind
_/nineteen eighty-four
_/charlotte's web
_/the hitchhiker's guide to the galaxy
_/charlie and the chocolate factory
_/the cat in the hat
_/the secret
_/the hobbit
_/spiderman
_/the fantastic four
_/batman
_/the joker
  TEXT


  def self.create!
    question, answer = QA.sample.map(&:strip)

    # Special question is answer
    if question == '_'
      question = answer
    end

    Game.create question: question,
                answer: answer
  end

  def to_jsonable
    attributes
  end

end
