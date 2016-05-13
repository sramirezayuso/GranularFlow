#!/usr/bin/env ruby

require './particle.rb'
require './cell_index_method.rb'
require './initial_state.rb'

def simulation
  particles = generate_particles((D/10)/2)
  m = 1 # Change this
  state = State.new(L, L / m.to_f, particles.size, particles)
  print_next_state(particles, 'w', 0)

  actual_time = 0
  while actual_time < SIMULATION_END_TIME do
    #cim_main(state, m, D/10)

    move(particles, SIMULATION_DELTA_TIME)
    actual_time += SIMULATION_DELTA_TIME

    if ((next_frame(actual_time)*1000) / (FRAME_DELTA_TIME*1000)) % 1 == 0 then # To avoid float error
      print_next_state(particles, 'a', next_frame(actual_time))
    end
  end
end

# Moves all the particles a certain time
def move(particles, time)
  particles.each do |p|
    p.move(time)
    particles.delete(p) if p.y < -1
  end
end

# Returns the next frame of a certain time
def next_frame(time)
  return (time.round(3) - time > 0 ? time.round(3) : time.round(3) + FRAME_DELTA_TIME).round(3)
end

# Prints each particle at a given time
def print_next_state(particles, mode, second)
  Dir.mkdir("out") unless File.exists?("out")
  file = File.open("./out/particles.txt", mode)
  file.write("#{particles.size + 4}\n") # 4 for the invisible ones at the corners
  file.write("#{second}\n")
  particles.each do |particle|
    file.write("#{particle.x} #{particle.y} #{particle.vx} #{particle.vy} #{particle.radius} #{particle.red} #{particle.green} #{particle.blue}\n")
  end
  file.write("#{0} #{0} 0 0 0 0 0 0\n")
  file.write("#{0} #{L} 0 0 0 0 0 0\n")
  file.write("#{W} #{0} 0 0 0 0 0 0\n")
  file.write("#{W} #{L} 0 0 0 0 0 0\n")
  file.close
end

# Generates the initial particles inside the silo
#def generate_particles(d)
#	until (info = gets.chomp).empty?
#  		people += [Person.new(info)]
#	end
#	particles = []
#	N.times do
#		particles.push(Particle.new((rand * W), (rand * L), 1))
#		# Run Cell Index Method and check against neighbors using particles_overlap?
#	end
#end

# Silo dimensions
L = 4.0
W = 2.0
D = 1.0

# Particles dimensions
d = D/10 # Diameter
M = 0.01 # Mass
N = 10 # Amount

# Simulation dimensions
SIMULATION_DELTA_TIME = 0.0001
SIMULATION_END_TIME = 1.5
K = 100
FRAME_DELTA_TIME = K * SIMULATION_DELTA_TIME

raise ArgumentError, "The dimensions must be L > W > D" if L <= W || L <= D || W <= D

simulation