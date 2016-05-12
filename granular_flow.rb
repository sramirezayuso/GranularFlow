#!/usr/bin/env ruby

require './particle.rb'

# Checks if two particles overlap
def particles_overlap?(particle1, particle2, d)
  particle1.distance_to(particle2) < d
end

# Generates the initial particles inside the silo
def generate_particles(d)
	until (info = gets.chomp).empty?
  		people += [Person.new(info)]
	end
	particles = []
	N.times do
		particles.push(Particle.new((rand * W), (rand * L), 1))
		# Run Cell Index Method and check against neighbors using particles_overlap?
	end
end

L = 4.0
W = 2.0
D = 1.0

d = D/10

N = 100

p1 = Particle.new(3, 2, Vector[1,2], Vector[0,0])
p2 = Particle.new(9, 7, Vector[1,2], Vector[0,0])

puts particles_overlap?(p1, p2, d)