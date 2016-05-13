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

  def overlap_with(other_particle)
    @radius + other_particle.radius - (@position - other_particle.position).magnitude
  end

  # Movement made using Velocity-Verlet algorithm
  def move(time)
    f = force
    @position = @position + time * @v + (time**2/@mass) * f

    f_new = force
    @v = @v + (time / (2*@mass)) * (f + f_new)
  end

  # Gravitational force
  def force
    force_x_total = 0
    force_y_total = @mass * -9.8

    neighbors.each do |other_particle|
      ξ = overlap_with(other_particle)
      if ξ > 0 then
        e_x = (x - other_particle.x) / (@position - other_particle.position).magnitude
        e_y = (y - other_particle.y) / (@position - other_particle.position).magnitude

        force_normal = -KN * ξ
        force_tangent = -KT * ξ  * (@v - other_particle.v).magnitude

        force_x = force_normal * e_x + force_tangent * (-e_y)
        force_y = force_normal * e_y + force_tangent * e_x

        force_x_total += force_x
        force_y_total += force_y
      end
    end

    return Vector[force_x_total, force_y_total]
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