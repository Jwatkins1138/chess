class Board

  attr_accessor :spaces, :check_white, :check_mate_white, :check_black, :check_mate_black, :white_king, :black_king

  def initialize
    @spaces = Array.new(8)
    @spaces.map! { |x| x = Array.new(8) }
    @spaces.each { |x| x.map! { |y| y = Space.new } }
    @check_white = false
    @check_mate_white = false
    @check_black = false
    @check_mate_black = false
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
    @white_king = @spaces[7][4].occupant
  end

  def set_black_king
    self.set_space_black(0, 4, King)
    @black_king = @spaces[0][4].occupant
  end

  def white_king
    @white_king
  end

  def black_king
    @black_king
  end

  def draw_board
    @spaces.each_with_index { |x, i|
      print i 
      x.each { |y| print "|#{y.draw_space}"}
      print "|\n"}
      puts "  0 1 2 3 4 5 6 7"
  end

  def check_board
    @spaces.each { |x|
    x.each { |y|
      if @spaces[x][y].en_passant
        @spaces[x][y].counter_set
        if @spaces[x][y].en_passant_counter >= 2
          @spaces[x][y].set_en_passant(nil)
        end
      end
      if self.check_moves(x, y).include?(@white_king.position)
        self.set_white_check
      elsif self.check_moves(x, y).include?(@black_king.position)
        self.set_black_check
      end
    }}
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

  def move_piece(x, y, xd, yd)
    if @spaces[x][y].occupant.class == Pawn && @spaces[x][y].occupant.first_move
      @spaces[x][y].occupant.set_first_move
      if x - xd > 1
        @spaces[(x+xd)/2][y].set_en_passant(@spaces[x][y].occupant)
      # elsif @spaces[x][y].occupant.color == "black" && xd - x > 1
      #   self.set_space_black((x+xd)/2, y, EnPassant)
      end
    end 
    @spaces[xd][yd].occupant = @spaces[x][y].occupant
    @spaces[x][y].occupant = nil
    
  end

  def check_space(x, y)
    if @spaces[x][y].occupant
      return @spaces[x][y].occupant.color
    else
      return nil
    end
  end

  def check_moves(x, y)
    if @spaces[x][y].occupant
      @spaces[x][y].occupant.calculate_moves(@spaces)
    end
  end

  def spaces
    @spaces
  end

  def white_move
    awaiting_piece = true
    awaiting_move = true
    while awaiting_piece
      puts "white's move, enter the x value of piece to move: "
      x = gets.chomp.to_i
      puts "enter the y value of piece to move: "
      y = gets.chomp.to_i
      if @spaces[x][y].occupant && @spaces[x][y].occupant.color == "white"
        piece = @spaces[x][y].occupant
        awaiting_piece = false
      else
        puts "please enter a valid piece."
      end
    end
    while awaiting_move
      puts "#{piece.class} selected, enter x value of destination: "
      xd = gets.chomp.to_i
      puts "enter the y value of destination: "
      yd = gets.chomp.to_i
      if self.check_moves(x, y).include?([xd, yd])
        self.move_piece(x, y, xd, yd)
        awaiting_move = false
      else
        puts "please enter a valid destination."
      end
    end
  end

  def black_move
    awaiting_piece = true
    awaiting_move = true
    while awaiting_piece
      puts "black's move, enter the x value of piece to move: "
      x = gets.chomp.to_i
      puts "enter the y value of piece to move: "
      y = gets.chomp.to_i
      if @spaces[x][y].occupant && @spaces[x][y].occupant.color == "black"
        piece = @spaces[x][y].occupant
        awaiting_piece = false
      else
        puts "please enter a valid piece."
      end
    end
    while awaiting_move
      puts "#{piece.class} selected, enter x value of destination: "
      xd = gets.chomp.to_i
      puts "enter the y value of destination: "
      yd = gets.chomp.to_i
      if self.check_moves(x, y).include?([xd, yd])
        self.move_piece(x, y, xd, yd)
        awaiting_move = false
      else
        puts "please enter a valid destination."
      end
    end
  end

end

class Space

  attr_accessor :occupant, :en_passant, :passant_counter

  def initialize(occupant = nil)
    @occupant = occupant
    @en_passant = nil
    @passant_counter = 0
  end

  def draw_space
    if occupant.class == NilClass || occupant.class == EnPassant
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

  def set_en_passant(pawn)
    @en_passant = pawn
  end

  def en_passant_counter
    @en_passant_counter
  end

  def counter_set
    @en_passant_counter += 1
  end

  def en_passant
    @en_passant
  end

end

class Piece

  def check_space(x, y)

  end

  def initialize(color, position)
    @color = color
    @position = position
  end
  
  def color
    @color
  end

  def set_position(x, y)
    @position = [x, y]
  end

  def diagonal_path
    x = @position[0]
    y = @position[1]
    if spaces[x][y - 1] && spaces[x][y - 1].occupant == nil || spaces[x][y - 1].occupant.color != @color 
      moves.push([x, y -1])
    end
  end

end

class Pawn < Piece

  attr_accessor :color, :position, :first_move

  def initialize(color, position)
    @color = color
    @position = position
    @first_move = true
  end

  def calculate_moves(spaces)
    moves = Array.new
    x = @position[0]
    y = @position[1]
    if @color == "white"
      if spaces[x - 1][y] && spaces[x - 1][y].occupant == nil || spaces[x - 1][y].occupant.color != @color
        moves.push([x - 1, y])
      end
    end
    if @color == "black"
      if spaces[x + 1][y] && spaces[x + 1][y].occupant == nil || spaces[x + 1][y].occupant.color != @color
        moves.push([x + 1, y])
      end
    end
    if @first_move
      if @color == "white"
        if spaces[x - 2][y] && spaces[x - 2][y].occupant == nil || spaces[x - 2][y].occupant.color != @color
          moves.push([x - 2, y])
        end
      end
      if @color == "black"
        if spaces[x + 2][y] && spaces[x + 2][y].occupant == nil || spaces[x + 2][y].occupant.color != @color
          moves.push([x + 2, y])
        end
      end
    end
    moves
    
    
  end

  def first_move
    @first_move
  end

  def set_first_move
    @first_move = false
  end
  
end

class EnPassant < Piece

  attr_accessor :pawn, :position, :active, :round

  def initialize(pawn, position)
    @pawn = pawn
    @position = position
    @round = 0
    @active = true
  end

  def set_round
    @round += 1
  end

end

class Rook < Piece

  attr_accessor :color, :position
  
end

class Knight < Piece

  attr_accessor :color, :position
  
end

class Bishop < Piece

  attr_accessor :color, :position

end

class Queen < Piece

  attr_accessor :color, :position

end

class King < Piece

  attr_accessor :color, :position, :castled, :potential

  def calculate_moves(spaces)
    moves = Array.new
    x = @position[0]
    y = @position[1]
    if spaces[x][y - 1] && spaces[x][y - 1].occupant == nil || spaces[x][y - 1].occupant.color != @color 
      moves.push([x, y -1])
    end
    if spaces[x][y + 1] && spaces[x][y + 1].occupant == nil || spaces[x][y + 1].occupant.color != @color
      moves.push([x, y +1])
    end
    if spaces[x - 1]
      if spaces[x - 1][y - 1] && spaces[x - 1][y - 1].occupant == nil || spaces[x - 1][y - 1].occupant.color != @color
        moves.push([x - 1, y - 1])
      end
      if spaces[x - 1][y + 1] && spaces[x - 1][y + 1].occupant == nil || spaces[x - 1][y + 1].occupant.color != @color
        moves.push([x - 1, y + 1])
      end
      if spaces[x - 1][y] && spaces[x - 1][y].occupant == nil || spaces[x - 1][y].occupant.color != @color
        moves.push([x - 1, y])
      end
    end
    if spaces[x + 1]
      if spaces[x + 1][y + 1] && spaces[x + 1][y + 1].occupant == nil || spaces[x + 1][y + 1].occupant.color != @color
        moves.push([x + 1, y + 1])
      end
      if spaces[x + 1][y - 1] && spaces[x + 1][y - 1].occupant == nil || spaces[x + 1][y - 1].occupant.color != @color
        moves.push([x + 1, y - 1])
      end
      if spaces[x + 1][y] && spaces[x + 1][y].occupant == nil || spaces[x + 1][y].occupant.color != @color
        moves.push([x + 1, y])
      end
    end
    moves

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

# board.set_board
# i = 0
# while i < 10
#   board.draw_board
#   board.white_move
#   board.draw_board
#   board.black_move
#   i += 1
# end
