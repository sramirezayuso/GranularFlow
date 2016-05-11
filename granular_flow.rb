#!/usr/bin/env ruby

L = 4.0
W = 2.0
D = 1.0

d = D/10

N = 100

class Particle
  attr_reader :id, :color
  attr_accessor :x, :y

  @@ids = 0

  def initialize(x, y, color)
      @@ids += 1
      @id = @@ids
      @color = color
      @x = x
      @y = y
  end

  def to_s()
    "id: #{@id}, color: #{@color}, x: #{@x}, y: #{@y}"
  end
end

# Checks if two particles overlap
def particles_overlap?(particle1, particle2, d)
	dist = Math.sqrt((particle1.x - particle2.x)**2 + (particle1.y - particle2.y)**2)
	return dist < d
end

# Generates the initial particles inside the silo
def generate_particles(N, d)
	until (info = gets.chomp).empty?
  		people += [Person.new(info)]
	end
	particles = []
	N.times do
		particles.push(Particle.new((rand * W), (rand * L), 1)
		# Run Cell Index Method and check against neighbors using particles_overlap?
	end
end

p1 = Particle.new(3, 2, 1)
p2 = Particle.new(9, 7, 2)

puts particles_overlap?(p1, p2, d)