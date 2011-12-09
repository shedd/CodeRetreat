require "./game_of_life"

describe "game of life" do
  before(:each) do
    @isolated_cell                    = {:x => 100, :y => 100}

    c2                                = {:x => 1, :y => 1}
    @cell_that_will_continue_to_live  = {:x => 2, :y => 1}
    c4                                = {:x => 3, :y => 1}

    @overcrowded_cell                 = {:x => 50, :y => 50}
    c5                                = {:x => 51, :y => 50}
    c6                                = {:x => 49, :y => 50}
    c7                                = {:x => 50, :y => 51}
    c8                                = {:x => 50, :y => 49}

    c10                               = {:x => 25, :y => 26}
    c11                               = {:x => 26, :y => 25}
    c12                               = {:x => 24, :y => 25}
    @cell_that_will_be_resuscitated   = {:x => 25, :y => 25}

    @initial_live_cells = Set.new
    @initial_live_cells.merge [ @isolated_cell, @cell_that_will_continue_to_live, c2, c4, @overcrowded_cell, c5, c6, c7, c8, c10, c11, c12]

    @g = GameOfLife.new(@initial_live_cells)
  end

  it "can be initialized with a set of live cells" do
    @g.set_of_live_cells.should == @initial_live_cells
  end

  it "has a tick method that progresses the game state" do
    next_iteration_number = 1

    @g.tick.should == next_iteration_number
  end

  describe "tick" do
    it "progresses through the set of live cells and maintains cells that may stay alive" do
      @g.tick

      @g.set_of_live_cells.should include( @cell_that_will_continue_to_live )
    end

    it "progresses through the set of alive cells and cells which are isolated are killed off" do
      @g.tick

      @g.set_of_live_cells.should_not include( @isolated_cell )
    end

    it "progresses through the set of alive cells and cells which are overcrowded are killed off" do
      @g.tick

      @g.set_of_live_cells.should_not include( @overcrowded_cell )
    end

    it "determines if any dead cells should be brought back to life" do
      @g.tick

      @g.set_of_live_cells.should include( @cell_that_will_be_resuscitated )
    end

    it "progresses a blinker correctly" do
      b1 = {:x => 20, :y => 10}
      b2 = {:x => 20, :y => 11}
      b3 = {:x => 20, :y => 9}

      blinker = GameOfLife.new([b1,b2,b3])
      blinker.tick

      blinker.set_of_live_cells.should include( {:x => 19, :y => 10})
      blinker.set_of_live_cells.should include( {:x => 20, :y => 10})
      blinker.set_of_live_cells.should include( {:x => 21, :y => 10})
    end
  end
end
