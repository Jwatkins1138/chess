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

      it "returns pawns moves" do
        board.set_space_white(6, 4, Pawn)
        moves = board.check_moves(6, 4)
        expect(moves).to include([5, 4])
      end
    end

  end

end