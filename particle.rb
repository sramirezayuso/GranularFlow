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

  def add_neighbor(particle)
    @neighbors.add(particle)
  end

  def reset_neighbors
    @neighbors = Set.new
  end

  def distance_to(other_particle)
    Math.hypot(x - other_particle.x, y - other_particle.y)
  end

  def overlap_with(other_particle)
    @radius + other_particle.radius - distance_to(other_particle)
  end

  def overlap_with_left_wall
    @radius - Math.hypot(x, 0)
  end

  def overlap_with_right_wall
    @radius - Math.hypot(x - W, 0)
  end

  def overlap_with_top_wall
    @radius - Math.hypot(y - L, 0)
  end

  def overlap_with_bottom_wall
    @radius - Math.hypot(y, 0)
  end

  # Movement made using Velocity-Verlet algorithm
  def move(time)
    f = force
    @position = @position + time * @v + (time**2/@mass) * f

    f_new = force
    @v = @v + (time / (2*@mass)) * (f + f_new)
  end

  # Force acting over the particle
  def force
    force_total = Vector[0, @mass * -9.8]

    # Find collisions with other particles
    neighbors.each do |other_particle|
      ξ = overlap_with(other_particle)
      if ξ > 0 then
        e = (@position - other_particle.position) / distance_to(other_particle)

        force_normal = KN * ξ
        force_tangent = -KT * ξ  * ((@v - other_particle.v).dot(Vector[-e[1], e[0]]))

        force_x = force_normal * e[0] + force_tangent * (-e[1])
        force_y = force_normal * e[1] + force_tangent * e[0]

        force_total += Vector[force_x, force_y]
      end
    end

    # Collision with walls
    ξ = overlap_with_left_wall
    if ξ > 0 then
      force_total += Vector[KN * ξ, -KT * ξ  * vy]
    end

    ξ = overlap_with_right_wall
    if ξ > 0 then
      force_total += Vector[-KN * ξ, -KT * ξ  * vy]
    end

    ξ = overlap_with_top_wall
    if ξ > 0 then
      force_total += Vector[-KT * ξ  * vx, -KN * ξ]
    end

    ξ = overlap_with_bottom_wall
    if ξ > 0 then
      force_total += Vector[-KT * ξ  * vx, KN * ξ]
    end

    return force_total
  end

  def angle
    w = Vector[1, 0]
    angle = Math.atan2(@v[1], @v[0]) - Math.atan2(w[1], w[0])
    angle += (2*Math::PI) if angle < 0
    return angle
  end

  # Color methods
  def red
    (2 / Math::PI) * angle - (angle**2 / (Math::PI ** 2))
  end

  def green
    1 - (angle / (2 * Math::PI))
  end

  def blue
    (angle / (2 * Math::PI))
  end

end