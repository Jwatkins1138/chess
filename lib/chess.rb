

class Chess

  def new_game
    game_on = true
    board = Board.new
    board.set_board
    while game_on
      board.draw_board
      board.white_move
      board.check_board
      if board.check_mate_black
        board.draw_board
        game_on = false
        break
      end
      board.draw_board
      board.black_move
      board.check_board
      if board.check_mate_white
        board.draw_board
        game_on = false
        break
      end
    end
  end

  def save_game

  end

  def load_game
    game_on = true
    board = Board.new(spaces)
    board.set_board
    while game_on
      board.draw_board
      board.white_move
      board.check_board
      if board.check_mate_black
        board.draw_board
        game_on = false
        break
      end
      board.draw_board
      board.black_move
      board.check_board
      if board.check_mate_white
        board.draw_board
        game_on = false
        break
      end
    end
  end

  def run_chess
    puts" 
    ░█████╗░██╗░░██╗███████╗░██████╗░██████╗
    ██╔══██╗██║░░██║██╔════╝██╔════╝██╔════╝
    ██║░░╚═╝███████║█████╗░░╚█████╗░╚█████╗░
    ██║░░██╗██╔══██║██╔══╝░░░╚═══██╗░╚═══██╗
    ╚█████╔╝██║░░██║███████╗██████╔╝██████╔╝
    ░╚════╝░╚═╝░░╚═╝╚══════╝╚═════╝░╚═════╝░
                by Jason Watkins             "
    puts "1. new game"
    puts "2. load game"
    choice = gets.chomp.to_i
    until (1..2).include?(choice)
      puts "please enter a valid choice: "
      choice = gets.chomp.to_i
    end
    if choice == 1
      self.new_game
    end         
  end
end

class Board

  attr_accessor :spaces, :check_white, :check_mate_white, :check_black, :check_mate_black, :white_king, :black_king

  def initialize(spaces = Array.new(8))
    @spaces = spaces
    if @spaces[0].class != Array
      @spaces.map! { |x| x = Array.new(8) }
      @spaces.each { |x| x.map! { |y| y = Space.new } }
    end
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
    @spaces.each_with_index { |x, xi|
    x.each_with_index { |y, yi|
      if y.en_passant
        y.counter_set
        if y.en_passant_counter >= 2
          y.set_en_passant(nil)
        end
      end
      if @spaces[xi][yi].occupant && self.check_moves(xi, yi).include?(@white_king.position)
        self.set_check_white
        kings_moves = self.check_moves(@white_king.position[0], @white_king.position[1])
        i = 0
        safe_counter = 0
        unsafe_counter = 0
        while i < kings_moves.length
          if self.eval_checkmate(@white_king.position[0], @white_king.position[1], kings_moves[i][0], kings_moves[i][1])
            unsafe_counter += 1
          else
            safe_counter += 1
          end
          i += 1
        end
        if safe_counter == 0
          self.set_checkmate_white
          p "checkmate white, black wins"
        else
          p "white king is in check"
        end
      elsif @spaces[xi][yi].occupant && self.check_moves(xi, yi).include?(@black_king.position)
        self.set_check_black
        kings_moves = self.check_moves(@black_king.position[0], @black_king.position[1])
        i = 0
        safe_counter = 0
        unsafe_counter = 0
        while i < kings_moves.length
          if self.eval_checkmate(@black_king.position[0], @black_king.position[1], kings_moves[i][0], kings_moves[i][1])
            unsafe_counter += 1
          else
            safe_counter += 1
          end
          i += 1
        end
        if safe_counter == 0
          self.set_checkmate_black
          p "checkmate black, white wins"
        else
          p "black king is in check"
        end
      end
    }}
  end

  def clone_board
    clone_spaces = Array.new(8)
    clone_spaces.map! { |x| x = Array.new(8) }
    clone_spaces.each { |x| x.map! { |y| y = Space.new } }
    @spaces.each_with_index { |x, xi|
    x.each_with_index { |y, yi| 
      if y.occupant
        clone_type = y.occupant.class
        clone_color = y.occupant.color
        clone_spaces[xi][yi].set_occupant(clone_type.new(clone_color, [xi, yi]))
      end
    }}
    clone_spaces
  end

  def eval_checkmate(x, y, xd, yd)
    test_spaces = self.clone_board
    test_board = Board.new(test_spaces)
    test_board.move_piece(x, y, xd, yd)
    unsafe = 0
    test_board.spaces.each_with_index { |tx, txi|
      tx.each_with_index { |ty, tyi|
      if test_board.spaces[txi][tyi].occupant && test_board.check_moves(txi, tyi).include?([xd, yd])
        unsafe += 1
      end
    }}
    if unsafe > 0
      return true
    else
      return false
    end
  end


  def promotion(pawn)
    x = pawn.location[0]
    y = pawn.location[1]
    color = pawn.color
    puts "pawn has been promoted, select replacement: "
    puts "1. Queen"
    puts "2. Bishop"
    puts "3. Knight"
    puts "4. Rook"
    choice = gets.chomp.to_i
    until (1..4).include?(choice)
      puts "please enter a valid choice: "
      choice = gets.chomp.to_i
    end
    case choice
    when 1
      @spaces[x][y].set_occupant(Queen.new(color, [x, y]))
    when 2
      @spaces[x][y].set_occupant(Bishop.new(color, [x, y]))
    when 3
      @spaces[x][y].set_occupant(Knight.new(color, [x, y]))
    when 4
      @spaces[x][y].set_occupant(Rook.new(color, [x, y]))
    end

  end

  def capture_en_passant(pawn)
    x = pawn.location[0]
    y = pawn.location[1]
    @spaces[x][y].occupant = nil
  end

  def check_white
    @check_white
  end

  def check_mate_white
    @check_mate_white
  end

  def set_check_white
    @check_white = true
  end

  def set_checkmate_white
    @check_mate_white = true
  end

  def check_black
    @check_black
  end

  def check_mate_black
    @check_mate_black
  end

  def set_check_black
    @check_black = true
  end

  def set_checkmate_black
    @check_mate_black = true
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
    if @spaces[x][y].occupant.class == Pawn
      if @spaces[x][y].occupant.color == "black" && x == 7
        self.promotion(@spaces[x][y].occupant)
      end
      if @spaces[x][y].occupant.color == "white" && x == 0
        self.promotion(@spaces[x][y].occupant)
      end
      if @spaces[x][y].occupant.first_move
        @spaces[x][y].occupant.set_first_move
        if x - xd > 1
          @spaces[(x+xd)/2][y].set_en_passant(@spaces[x][y].occupant)
        end
      end
      if @spaces[xd][yd].en_passant
        self.capture_en_passant(@spaces[xd][yd].en_passant)
      end
    end 
    @spaces[xd][yd].occupant = @spaces[x][y].occupant
    @spaces[x][y].occupant = nil
    @spaces[xd][yd].occupant.set_position(xd, yd)
    if @spaces[xd][yd].occupant.class == King
      if @spaces[xd][yd].occupant.color == "white"
        @white_king = @spaces[xd][yd].occupant
      elsif @spaces[xd][yd].occupant.color == "black"
        @black_king = @spaces[xd][yd].occupant
      end
    end
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
    @passant_counter
  end

  def counter_set
    @passant_counter += 1
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

  def diagonal_path_one(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x - 1) && (0..7).include?(y - 1)
      if spaces[x - 1][y - 1].occupant == nil || spaces[x - 1][y - 1].occupant.color != @color 
        moves.push([x - 1, y - 1])
      end
      if spaces[x - 1][y - 1] && spaces[x - 1][y - 1].occupant == nil
        x -= 1
        y -= 1
      else
        break
      end
    end
    moves
  end

  def diagonal_path_two(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x + 1) && (0..7).include?(y - 1)
      if spaces[x + 1][y - 1].occupant == nil || spaces[x + 1][y - 1].occupant.color != @color 
        moves.push([x + 1, y - 1])
      end
      if spaces[x + 1][y - 1].occupant == nil
        x += 1
        y -= 1
      else
        break
      end
    end
    moves
  end

  def diagonal_path_three(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x + 1) && (0..7).include?(y + 1)
      if spaces[x + 1][y + 1].occupant == nil || spaces[x + 1][y + 1].occupant.color != @color 
        moves.push([x + 1, y + 1])
      end
      if spaces[x + 1][y + 1].occupant == nil
        x += 1
        y += 1
      else
        break
      end
    end
    moves
  end

  def diagonal_path_four(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x - 1) && (0..7).include?(y + 1)
      if spaces[x - 1][y + 1].occupant == nil || spaces[x - 1][y + 1].occupant.color != @color 
        moves.push([x - 1, y + 1])
      end
      if spaces[x - 1][y + 1].occupant == nil
        x -= 1
        y += 1
      else
        break
      end
    end
    moves
  end

  def vertical_path_one(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x) && (0..7).include?(y + 1)
      if spaces[x][y + 1].occupant == nil || spaces[x][y + 1].occupant.color != @color 
        moves.push([x, y + 1])
      end
      if spaces[x][y + 1].occupant == nil
        y += 1
      else
        break
      end
    end
    moves
  end

  def vertical_path_two(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x) && (0..7).include?(y - 1)
      if spaces[x][y - 1].occupant == nil || spaces[x][y - 1].occupant.color != @color 
        moves.push([x, y - 1])
      end
      if spaces[x][y - 1].occupant == nil
        y -= 1
      else
        break
      end
    end
    moves
  end

  def horizontal_path_one(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x + 1) && (0..7).include?(y)
      if spaces[x + 1][y].occupant == nil || spaces[x + 1][y].occupant.color != @color 
        moves.push([x + 1, y])
      end
      if spaces[x + 1][y].occupant == nil
        x += 1
      else
        break
      end
    end
    moves
  end

  def horizontal_path_two(spaces, moves)
    x = @position[0]
    y = @position[1]
    while (0..7).include?(x - 1) && (0..7).include?(y)
      if spaces[x - 1][y].occupant == nil || spaces[x - 1][y].occupant.color != @color 
        moves.push([x - 1, y])
      end
      if spaces[x - 1][y].occupant == nil
        x -= 1
      else
        break
      end
    end
    moves
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
      if spaces[x - 1] 
        if spaces[x - 1][y].occupant == nil 
          moves.push([x - 1, y])
        end
        if spaces[x - 1][y - 1] && spaces[x - 1][y - 1].occupant && spaces[x - 1][y - 1].occupant.color == "black" || spaces[x - 1][y - 1] && spaces[x - 1][y - 1].en_passant
          moves.push([x - 1, y - 1])
        end
        if spaces[x - 1][y + 1] && spaces[x - 1][y + 1].occupant && spaces[x - 1][y + 1].occupant.color == "black" || spaces[x - 1][y + 1] && spaces[x - 1][y + 1].en_passant
          moves.push([x - 1, y + 1])
        end
      end
    end
    if @color == "black"
      if spaces[x + 1]
        if spaces[x + 1][y].occupant == nil 
          moves.push([x + 1, y])
        end
        if spaces[x + 1][y - 1] && spaces[x + 1][y - 1].occupant && spaces[x + 1][y - 1].occupant.color == "white" || spaces[x + 1][y - 1] && spaces[x + 1][y - 1].en_passant
          moves.push([x + 1, y - 1])
        end
        if spaces[x + 1][y + 1] && spaces[x + 1][y + 1].occupant && spaces[x + 1][y + 1].occupant.color == "white" || spaces[x + 1][y + 1] && spaces[x + 1][y + 1].en_passant
          moves.push([x + 1, y + 1])
        end
      end
    end
    if @first_move
      if @color == "white"
        if spaces[x - 2] && spaces[x - 2][y].occupant == nil 
          moves.push([x - 2, y])
        end
      end
      if @color == "black"
        if spaces[x + 2] && spaces[x + 2][y].occupant == nil 
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

class Rook < Piece

  attr_accessor :color, :position, :first_move

  def calculate_moves(spaces)
    moves = Array.new
    moves = self.vertical_path_one(spaces, moves)
    moves = self.vertical_path_two(spaces, moves)
    moves = self.horizontal_path_one(spaces, moves)
    moves = self.horizontal_path_two(spaces, moves)
    moves

  end

  def first_move
    @first_move
  end

  def set_first_move
    @first_move = false
  end
  
end

class Knight < Piece

  attr_accessor :color, :position

  def calculate_moves(spaces)
    moves = Array.new
    x = position[0]
    y = position[1]
    if (0..7).include?(x + 2) && (0..7).include?(y - 1)
      if spaces[x + 2][y - 1].occupant == nil || spaces[x + 2][y - 1].occupant.color != @color
        moves.push([x + 2, y - 1])
      end
    end
    if (0..7).include?(x + 1) && (0..7).include?(y - 2)
      if spaces[x + 1][y - 2].occupant == nil || spaces[x + 1][y - 2].occupant.color != @color
        moves.push([x + 1, y - 2])
      end
    end
    if (0..7).include?(x - 2) && (0..7).include?(y - 1)
      if spaces[x - 2][y - 1].occupant == nil || spaces[x - 2][y - 1].occupant.color != @color
        moves.push([x - 2, y - 1])
      end
    end
    if (0..7).include?(x - 1) && (0..7).include?(y - 2)
      if spaces[x - 1][y - 2].occupant == nil || spaces[x - 1][y - 2].occupant.color != @color
        moves.push([x - 1, y - 2])
      end
    end
    if (0..7).include?(x + 2) && (0..7).include?(y + 1)
      if spaces[x + 2][y + 1].occupant == nil || spaces[x + 2][y + 1].occupant.color != @color
        moves.push([x + 2, y + 1])
      end
    end
    if (0..7).include?(x + 1) && (0..7).include?(y + 2)
      if spaces[x + 1][y + 2].occupant == nil || spaces[x + 1][y + 2].occupant.color != @color
        moves.push([x + 1, y + 2])
      end
    end
    if (0..7).include?(x - 2) && (0..7).include?(y + 1)
      if spaces[x - 2][y + 1].occupant == nil || spaces[x - 2][y + 1].occupant.color != @color
        moves.push([x - 2, y + 1])
      end
    end
    if (0..7).include?(x - 1) && (0..7).include?(y + 2)
      if spaces[x - 1][y + 2].occupant == nil || spaces[x - 1][y + 2].occupant.color != @color
        moves.push([x - 1, y + 2])
      end
    end
    moves
  end
  
end

class Bishop < Piece

  attr_accessor :color, :position

  def calculate_moves(spaces)
    moves = Array.new
    moves = self.diagonal_path_one(spaces, moves)
    moves = self.diagonal_path_two(spaces, moves)
    moves = self.diagonal_path_three(spaces, moves)
    moves = self.diagonal_path_four(spaces, moves)
    moves
  end

end

class Queen < Piece

  attr_accessor :color, :position

  def calculate_moves(spaces)
    moves = Array.new
    moves = self.diagonal_path_one(spaces, moves)
    moves = self.diagonal_path_two(spaces, moves)
    moves = self.diagonal_path_three(spaces, moves)
    moves = self.diagonal_path_four(spaces, moves)
    moves = self.vertical_path_one(spaces, moves)
    moves = self.vertical_path_two(spaces, moves)
    moves = self.horizontal_path_one(spaces, moves)
    moves = self.horizontal_path_two(spaces, moves)
    moves
  end


end

class King < Piece

  attr_accessor :color, :position, :first_move

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

  def first_move
    @first_move
  end

  def set_first_move
    @first_move = false
  end

end




chess = Chess.new
chess.run_chess



