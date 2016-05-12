#!/usr/bin/env ruby

require 'set'
require 'matrix'

class Particle
  attr_reader :id, :radius, :neighbors, :mass
  attr_accessor :position, :v

  @@ids = 0

  def initialize(radius, mass, position, velocity)
    @id = @@ids
    @@ids += 1
    @radius = radius
    @mass = mass
    @position = position
    @v = velocity
    @neighbors = Set.new
  end

  def ==(other)
    self.id == other.id
  end

  def eql?(other)
    self.id == other.id
  end

  def hash
    id
  end

  def to_s
    "id: #{@id}, radius: #{@radius}, mass: #{@mass}, position: #{@position}"
  end

  def x
    @position[0]
  end

  def y
    @position[1]
  end

  def vx
    @v[0]
  end

  def vy
    @v[1]
  end

  def angular_momentum
    @v.magnitude * @mass * @position.magnitude
  end

  def add_neighbor(particle)
    @neighbors.add(particle)
  end

  def reset_neighbors
    @neighbors = Set.new
  end

  def distance_to(other_particle)
    Math.hypot(x - other_particle.x, y - other_particle.y)
  end

  def angle
    w = Vector[1, 0]
    angle = Math.atan2(@v[1], @v[0]) - Math.atan2(w[1], w[0])
    angle += (2*Math::PI) if angle < 0
    return angle
  end

  # Color methods
  def red
    if @id == 0 then
      255
    else
      (2 / Math::PI) * angle - (angle**2 / (Math::PI ** 2))
    end
  end

  def green
    if @id == 0 then
      255
    else
      1 - (angle / (2 * Math::PI))
    end
  end

  def blue
    if @id == 0 then
      0
    else
      (angle / (2 * Math::PI))
    end
  end

end