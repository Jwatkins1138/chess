class Board

  attr_accessor :spaces

  def initialize
    @spaces = Array.new(8)
    @spaces.map! { |x| x = Array.new(8) }
    @spaces.each { |x| x.map! { |y| y = Space.new } }
  end

  def set_board
    self.set_white_pawn
    self.set_black_pawn
    self.set_white_rook
    self.set_black_rook
    self.set_white_knight
    self.set_black_knight
    self.set_white_bishop
    self.set_black_bishop
    self.set_white_queen
    self.set_black_queen
    self.set_white_king
    self.set_black_king
  end

  def set_white_pawn
    i = 0
    while i < 8
      self.set_space_white(6, i, Pawn)
      i += 1
    end
  end

  def set_black_pawn
    i = 0
    while i < 8
      self.set_space_black(1, i, Pawn)
      i += 1
    end
  end

  def set_white_rook
    self.set_space_white(7, 0, Rook)
    self.set_space_white(7, 7, Rook)
  end

  def set_black_rook
    self.set_space_black(0, 0, Rook)
    self.set_space_black(0, 7, Rook)
  end

  def set_white_knight
    self.set_space_white(7, 1, Knight)
    self.set_space_white(7, 6, Knight)
  end

  def set_black_knight
    self.set_space_black(0, 1, Knight)
    self.set_space_black(0, 6, Knight)
  end

  def set_white_bishop 
    self.set_space_white(7, 2, Bishop)
    self.set_space_white(7, 5, Bishop)
  end

  def set_black_bishop 
    self.set_space_black(0, 2, Bishop)
    self.set_space_black(0, 5, Bishop)
  end

  def set_white_queen
    self.set_space_white(7, 3, Queen)
  end

  def set_black_queen
    self.set_space_black(0, 3, Queen)
  end

  def set_white_king
    self.set_space_white(7, 4, King)
  end

  def set_black_king
    self.set_space_black(0, 4, King)
  end

  def draw_board
    @spaces.each_with_index { |x, i|
      print i 
      x.each { |y| print "|#{y.draw_space}"}
      print "|\n"}
      puts "  0 1 2 3 4 5 6 7"
  end

  def set_space_white(x, y, occupant)
    @spaces[x][y].set_occupant(occupant.new("white", [x, y]))
  end

  def set_space_black(x, y, occupant)
    @spaces[x][y].set_occupant(occupant.new("black", [x, y]))
  end

  def space(x, y)
    @spaces[x][y]
  end

  def check_space(x, y)
    if @spaces[x][y].occupant
      return @spaces[x][y].occupant.color
    else
      return nil
    end
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
    end
    if occupant.color == "white"
      if occupant.class == King
        return "♚"
      elsif occupant.class == Queen
        return "♛"
      elsif occupant.class == Bishop
        return "♝"
      elsif occupant.class == Knight
        return "♞"
      elsif occupant.class == Rook
        return "♜"
      elsif occupant.class == Pawn
        return "♟"
      end
    end
    if occupant.color == "black"
      if occupant.class == King
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
  end

  def set_occupant(occupant)
    @occupant = occupant
  end

  def occupant
    @occupant
  end

end

class Piece

  def check_space(x, y)

  end

end

class Pawn < Piece

  attr_accessor :color, :position, :first_move

  def initialize(color, position)
    @color = color
    @position = position
  end

  def color
    @color
  end

end

class EnPassant < Piece

  attr_accessor :pawn, :position, :active

  def initialize(pawn, position)
    @pawn = pawn
    @position = position
    @active = true
  end

end

class Rook < Piece

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

  def color
    @color
  end

end

class Knight < Piece

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

  def color
    @color
  end

end

class Bishop < Piece

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end
  
  def color
    @color
  end

end

class Queen < Piece

  attr_accessor :color, :position
  
  def initialize(color, position)
    @color = color
    @position = position
  end

  def color
    @color
  end

end

class King < Piece

  attr_accessor :color, :position, :potential
  
  def initialize(color, position)
    @color = color
    @position = position
  end

  def color
    @color
  end

  def calculate_moves

  end

end


board = Board.new
# board.draw_board

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

