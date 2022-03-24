class Board

  attr_accessor :spaces

  def initialize
    @spaces = Array.new(8)
    @spaces.map! { |x| x = Array.new(8) }
    @spaces.each { |x| x.map! { |y| y = Space.new } }
  end

  def set_board
    i = 0
    while i < 8
      self.set_space_white(6, i, Pawn)
      i += 1
    end
  end

  def draw_board
    @spaces.each { |x| 
      x.each { |y| print "|#{y.draw_space}|"}
      print "\n"}
  end

  def draw_board_index
    @spaces.each { |x| 
      x.each_with_index { |y| print "| #{y.occupant.class}|"}
      print "\n"}
  end

  def set_space_white(x, y, occupant)
    @spaces[x][y].set_occupant(occupant.new("white", [x, y]))
  end

  def space(x, y)
    @spaces[x][y]
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
    if occupant.class == NilClass
      return " "
    elsif occupant.class == King
      return "♔"
    elsif occupant.class == Queen
      return "♕"
    elsif occupant.class == Bishop
      return "♗"
    elsif occupant.class == Knight
      return "♘"
    elsif occupant.class == Rook
      return "♖"
    elsif occupant.class == Pawn
      return "♙"
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

# queen = Queen.new("black", [2, 0])
# p queen.class
# nil_space = nil
# p nil_space.class
# board.set_space
# board.draw_board
# # p board.space(0, 0)
# # p board.spaces
# board.draw_board_index
# if board.space(0, 0).occupant.class == King
#   p "yes king"
# else
#   p "no king"
# end
# p board.space(0, 0).draw_space

board.set_board
board.draw_board

