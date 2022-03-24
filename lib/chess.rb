class Board

  attr_accessor :spaces

  def initialize
    @spaces = Array.new(8)
    @spaces.map! { |x| x = Array.new(8) }
    @spaces.each { |x| x.map! { |y| y = Space.new } }
  end

  def draw_board
    @spaces.each { |x| 
      x.each { |y| print "| #{y.draw_space}|"}
      print "\n"}
  end

  def set_space
    @spaces[0][0].set_occupant(King.new("black", [0, 0]))
  end

  def space(x, y)
    @spaces[x, y]
  end

  def spaces
    @spaces
  end

end

class Space

  attr_accessor :occupant

  def initialize(occupant = nil)
    @occupant = occupant
  end

  def draw_space
    case @occupant.class
    when NilClass
      return " "
    when King
      p "♔"
      return "♔"
    end
  end

  def set_occupant(occupant)
    @occupant = occupant
  end

  def occupant
    @occupant
  end

end

class Pawn

  attr_accessor :color, :position

  def initialize(color, position)
    @color = color
    @position = position
  end

end

class Rook

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

end

class Knight

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

end

class Bishop 

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end
  
end

class Queen

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

end

class King

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

  

end


board = Board.new
board.draw_board

queen = Queen.new("black", [2, 0])
p queen.class
nil_space = nil
p nil_space.class
board.set_space
board.draw_board
p board.space(0, 0)
p board.spaces