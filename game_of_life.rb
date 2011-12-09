#!/usr/bin/env ruby
require "rubygems"
require "rspec"
require "set"

class GameOfLife
  attr_accessor :set_of_live_cells, :iteration

  def initialize( live_cells )
    @set_of_live_cells = live_cells
    @iteration = 0
  end

  def tick
    # the initial basis for the next state of live cells should be the current state
    next_state_set_of_live_cells = Set.new
    next_state_set_of_live_cells.merge( self.set_of_live_cells )
    # create an empty hash to maintain a list of cells near live cells -- if any of these positions have a count of 3, it means they have enough neighbors to come back to life
    hash_of_positions_neighboring_live_cells = Hash.new
    
    # puts "cells to check: #{ @set_of_live_cells.size }"

    # now, iterate through the set of living cells and determine which ones continue to live
    @set_of_live_cells.each do |cell|
      count_of_live_neighbors = 0
      
      # puts "checking cell #{ cell.inspect }"

      (-1..1).each do |x_offset|
        (-1..1).each do |y_offset|
          next if x_offset.zero? and y_offset.zero?

          position_to_check = {:x => cell[:x] + x_offset, :y => cell[:y] + y_offset}
          
          # puts "current state: #{ @set_of_live_cells.inspect }"
          # puts "next state: #{ next_state_set_of_live_cells.inspect }"
          # puts "checking #{ position_to_check.inspect }"

          count_of_live_neighbors += 1 if @set_of_live_cells.include?(position_to_check)

          # puts "count of live neighbors: #{ count_of_live_neighbors }"
          
          # record the check in the hash of neighboring cells
          hash_of_positions_neighboring_live_cells[ position_to_check ] = 0 if hash_of_positions_neighboring_live_cells[ position_to_check ].nil?
          hash_of_positions_neighboring_live_cells[ position_to_check ] += 1
        end
      end
      
      # cell will die because it's alone or overcrowded
      if count_of_live_neighbors < 2 or count_of_live_neighbors > 3
        # puts "deleting cell #{ cell.inspect }"
        next_state_set_of_live_cells.delete(cell)
      end
    end

    # puts "cells to check: #{ @set_of_live_cells.size }"

    # resuscitate any cells that have three neighbors
    hash_of_positions_neighboring_live_cells.each do |key, value|
      # puts "#{ key.inspect } has value of #{ value}"

      if value == 3
        # puts "adding #{ key.inspect }"
        next_state_set_of_live_cells << key 
      end
    end

    # advance the game
    @set_of_live_cells = next_state_set_of_live_cells
    @iteration += 1
  end

  def run
    (1..50).each do |tick|
      # clear screen
      print "\e[2J\e[f"

      puts "Iteration: #{ self.iteration }"

      (1..20).each do |y|
        (1..40).each do |x|
          if @set_of_live_cells.include?({:x => x, :y => y})
            print " X"
          else
            print " -"
          end
        end
        puts ""
      end

      self.tick

      sleep(0.5)
    end
  end
end

# Blinker
c1 = {:x => 20, :y => 10}
c2 = {:x => 20, :y => 11}
c3 = {:x => 20, :y => 9}

g = GameOfLife.new([c1,c2,c3])
g.run
