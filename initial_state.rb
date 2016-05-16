#!/usr/bin/env ruby

require 'set'
require 'matrix'
require './particle.rb'

# Generate the random particles and the sun
def generate_particles(radius)
  particles = Set.new
  N.times do
    position = random_position(particles, radius)
    new_particle = Particle.new(radius, M, position, Vector[0,0])
    particles.add(new_particle)
  end
  return particles
end

# Return a new position for a new particle
def random_position(particles, radius)
  x = nil
  y = nil

  loop do 
    x = rand(0..W-radius)
    y = rand(0..L-radius)
    break if verify_new_position(x, y, radius, particles)
  end 

  return Vector[x,y]
end

def verify_new_position(x, y, r, particles)
  # Check if particle is in the box
  return false if x - r < 0 || x + r > W || y - r < 0 || y + r > L

  # Check if the potential new position overlaps with the other particles
  particles.each do |particle|
    if (x - particle.x)**2 + (y - particle.y)**2 <= (r + particle.radius)**2 then
      return false
    end
  end

  return true
end