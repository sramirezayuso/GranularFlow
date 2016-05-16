#!/usr/bin/env ruby

require './particle.rb'
require './cell_index_method.rb'
require './initial_state.rb'

def simulation
  particles = generate_particles((D/10)/2)
  m = (5 * L / D) - 1
  state = State.new(L, L / m.to_f, particles.size, particles)
  print_next_state(particles, 'w', 0)

  actual_time = 0
  while actual_time < SIMULATION_END_TIME do
    cim_main(state, m, D/10)

    move(particles, SIMULATION_DELTA_TIME)
    actual_time += SIMULATION_DELTA_TIME

    if must_print_state(actual_time) then
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

def must_print_state(time)
  ((next_frame(time)*(10**SIMULATION_ORDER)) / (FRAME_DELTA_TIME*(10**SIMULATION_ORDER))) % 1 == 0
end

# Returns the next frame of a certain time
def next_frame(time)
  return (time.round(SIMULATION_ORDER) - time > 0 ? time.round(SIMULATION_ORDER) : time.round(SIMULATION_ORDER) + FRAME_DELTA_TIME).round(SIMULATION_ORDER)
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
  file.write("#{0} #{-1} 0 0 0 0 0 0\n")
  file.write("#{0} #{L} 0 0 0 0 0 0\n")
  file.write("#{W} #{-1} 0 0 0 0 0 0\n")
  file.write("#{W} #{L} 0 0 0 0 0 0\n")
  file.close
end

# Silo dimensions
L = 4.0
W = 2.0
D = 1.0

# Particles dimensions
d = D/10 # Diameter
M = 0.01 # Mass

# Physics dimensions
KN = 10**5
KT = 2 * KN

# Simulation dimensions
SIMULATION_ORDER = 5
SIMULATION_DELTA_TIME = 10**-SIMULATION_ORDER
SIMULATION_END_TIME = 3.0
K = 1000
FRAME_DELTA_TIME = K * SIMULATION_DELTA_TIME

raise ArgumentError, "The dimensions must be L > W > D" if L <= W || L <= D || W <= D

simulation