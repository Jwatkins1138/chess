require '../lib/chess.rb'

describe Board do
  subject(:board) { described_class.new}
  
  describe "#set_board" do

    context "when board is unset" do
      it "returns nil for occupant of each space" do
        test_occupant = board.space(7, 0).occupant
        expect(test_occupant).to eq(nil)
      end
    end

    context "when board is set" do
      it "returns not nil for occupant of space with occupant" do
        board.set_board
        test_occupant = board.space(7, 0).occupant
        expect(test_occupant).to_not eq(nil)
      end
      it "sets @white_king to King object" do
        board.set_board
        white_king = board.white_king
        expect(white_king.class).to eq(King)
      end
      it "sets @black_king to King object" do
        board.set_board
        black_king = board.black_king
        expect(black_king.class).to eq(King)
      end
      it "sets enpassant correctly" do
        board.set_board
        board.move_piece(6, 1, 4, 1)
        expect(board.spaces[5][1].en_passant.class).to eq(Pawn)
      end
    end
  end


  describe "#check_moves" do

    context "with a single piece" do
      it "returns an array of moves" do
        board.set_space_white(4, 4, King)
        moves = board.check_moves(4, 4)
        expect(moves.class).to eq(Array)
      end

      it "returns the correct moves" do 
        board.set_space_white(4, 4, King)
        moves = board.check_moves(4, 4)
        expect(moves).to include([4, 5], [5, 5], [5, 4], [3, 5], [3, 4], [3, 3], [5, 3], [4, 3])
      end

      it "returns a bishops moves" do
        board.set_space_white(4, 4, Bishop)
        moves = board.check_moves(4, 4)
        expect(moves).to contain_exactly([5, 5], [6, 6], [7, 7], [3, 3], [2, 2], [1, 1], [0, 0], [5, 3], [6, 2], [7, 1], [3, 5], [2, 6], [1, 7])
      end

      it "returns a rooks moves" do
        board.set_space_white(4, 4, Rook)
        moves = board.check_moves(4, 4)
        expect(moves).to contain_exactly([4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0], [0, 4], [1, 4], [2, 4], [3, 4], [5, 4], [6, 4], [7, 4])
      end

      it "returns a rooks moves when a teammate is in the way" do
        board.set_space_white(4, 4, Rook)
        board.set_space_white(4, 5, Pawn)
        moves = board.check_moves(4, 4)
        expect(moves).to contain_exactly([4, 3], [4, 2], [4, 1], [4, 0], [0, 4], [1, 4], [2, 4], [3, 4], [5, 4], [6, 4], [7, 4])
      end

      it "returns a queens moves" do
        board.set_space_white(4, 4, Queen)
        moves = board.check_moves(4, 4)
        expect(moves).to contain_exactly([4, 5], [4, 6], [4, 7], [4, 3], [4, 2], [4, 1], [4, 0], [0, 4], [1, 4], [2, 4], [3, 4], [5, 4], [6, 4], [7, 4], [5, 5], [6, 6], [7, 7], [3, 3], [2, 2], [1, 1], [0, 0], [5, 3], [6, 2], [7, 1], [3, 5], [2, 6], [1, 7])
      end

      it "returns a pawns moves" do
        board.set_space_white(6, 4, Pawn)
        moves = board.check_moves(6, 4)
        expect(moves).to include([5, 4])
      end

      it "returns a knights moves" do
        board.set_space_white(4, 4, Knight)
        moves = board.check_moves(4, 4)
        expect(moves).to contain_exactly([5, 6], [6, 5], [5, 2], [6, 3], [2, 3], [3, 2], [2, 5], [3, 6])
      end

      it "sets occupant to nil at a space after move" do
        board.set_board
        board.move_piece(0, 4, 3, 4)
        occupant = board.spaces[0][4].occupant
        expect(occupant).to eq(nil)
      end

      it "triggers check when moves contain a kings position" do
        board.set_board
        board.move_piece(0, 4, 3, 4)
        board.move_piece(6, 4, 4, 4)
        board.check_board
        check_black = board.check_black
        expect(check_black).to eq(true)
      end
    end

  end

end