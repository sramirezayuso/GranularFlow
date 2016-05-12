#!/usr/bin/env ruby

require 'pp'
require 'set'

class State
  attr_reader :grid_size, :cell_size
  attr_accessor :particles, :grid

  def initialize(grid_size, cell_size, particle_number, particles)
    @grid_size = grid_size
    @cell_size = cell_size
    @grid = {}
    @particle_number = particle_number
    @particles = particles
  end  
end

class Cell
  attr_reader :i, :j

  def initialize(i, j)
    @i = i
    @j = j
  end

  def eql?(other)
    self.i == other.i && self.j == other.j
  end

  def hash
    i.hash + j.hash
  end
end

# Places the particles in the grid
def align_grid(state)
  state.particles.each do |particle|
    x = particle.x
    y = particle.y
    radius = particle.radius

    state.grid = add_particle(state.grid, state.cell_size, x, y, particle)

    if radius != 0 then
      state.grid = add_particle(state.grid, state.cell_size, x - radius, y, particle)
      state.grid = add_particle(state.grid, state.cell_size, x, y - radius, particle)
      state.grid = add_particle(state.grid, state.cell_size, x + radius, y, particle)
      state.grid = add_particle(state.grid, state.cell_size, x, y + radius, particle)

      state.grid = add_particle(state.grid, state.cell_size, x + (0.5 * radius), y + (0.5 * radius), particle)
      state.grid = add_particle(state.grid, state.cell_size, x - (0.5 * radius), y - (0.5 * radius), particle)
      state.grid = add_particle(state.grid, state.cell_size, x - (0.5 * radius), y + (0.5 * radius), particle)
      state.grid = add_particle(state.grid, state.cell_size, x + (0.5 * radius), y - (0.5 * radius), particle)
    end
  end

  return state
end

# Adds a particle to its position on grid
def add_particle(grid, cell_size, x, y, particle)
  cell = Cell.new(grid_position(x, cell_size), grid_position(y, cell_size))
  grid[cell] = Set.new if grid[cell] == nil
  grid[cell].add(particle)
  return grid
end

# Position in the grid of a coordinate
def grid_position(pos, cell_size)
  return (pos/cell_size).floor
end

# Implementation of the Cell Index Method
def cell_index_method(state, rc, with_boundaries)
  grid = state.grid
  m = (state.grid_size / state.cell_size).round

  state.particles do |p|
    p.reset_neighbors
  end

  grid.keys.each do |cell|
    evaluate_neighbors(grid, cell, cell, rc)
    evaluate_neighbors(grid, cell, generate_neighbor_cell(cell.i, cell.j + 1, with_boundaries, m), rc)
    evaluate_neighbors(grid, cell, generate_neighbor_cell(cell.i + 1, cell.j - 1, with_boundaries, m), rc)
    evaluate_neighbors(grid, cell, generate_neighbor_cell(cell.i + 1, cell.j, with_boundaries, m), rc)
    evaluate_neighbors(grid, cell, generate_neighbor_cell(cell.i + 1, cell.j + 1, with_boundaries, m), rc)
  end

end

# Generates a cell based on i, j. Makes a cell around the grid if with_boundaries is true
def generate_neighbor_cell(i, j, with_boundaries, m)
  if with_boundaries
    j = m - 1 if j < 0
    j = 0 if j == m
    i = 0 if i == m
  end
  return Cell.new(i, j)
end

# Adds to close_particles all the particles of cell close to the ones of other_cell
def evaluate_neighbors(grid, cell, other_cell, rc)
  if grid.has_key?(other_cell)
    particles = grid[cell]
    other_particles = grid[other_cell]

    particles.each do |p1|
      other_particles.each do |p2|
        if are_particles_neighbors(p1, p2, rc)
          p1.add_neighbor(p2)
        end
      end
    end
  end
end

# True if the distance between two particles is less than rc
def are_particles_neighbors(p1, p2, rc)
  Math.hypot(p1.x - p2.x, p1.y - p2.y) - p1.radius - p2.radius < rc
end

# Main method
def cim_main(state, m, rc)
  raise ArgumentError, "The amount of cells and particle interaction radius are both required" if m == 0 || rc == 0

  rmax = state.particles.max {|a, b| a.radius <=> b.radius}.radius
  raise ArgumentError, "Wrong argument value: L/M > rc + 2*rmax" if state.cell_size <= rc + 2 * rmax

  state.grid = {}
  align_grid(state)
  cell_index_method(state, rc, false)

  return state
end