$:.unshift File.expand_path File.dirname __FILE__
require 'leros_sim.rb'

class Uart
    attr_accessor :data_stack

    def in thing_a, thing_b
        # I DON'T KNOW WHAT THESE ARE
        case thing_b.to_i
        when 2
            return 3
        when 3
            return @data_stack.pop
        else
            fail
        end
    end

    def out accu, alu, to
        puts "IO out: %d " % accu
    end
end

u = Uart.new
t = Treva.new("../ghost.asm", u)

u.data_stack = [3,3,   1,2,3,4,5,6,7,8,9,
                3,3,   9,10,11,12,13,14,15,16,17]
u.data_stack.reverse!


t.run
