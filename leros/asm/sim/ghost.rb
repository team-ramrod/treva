require 'leros_sim.rb'

class Uart
    attr_accessor :data_stack

    def in thing_a, thing_b
        # I DON'T KNOW WHAT THESE ARE
        case thing_b
        when 2
            2
        when 3
            @data_stack.pop
        end
    end

    def out
    end
end

u = Uart.new
t = Treva.new("../ghost.asm", u)

u.data_stack = [3,3,   1,2,3,4,5,6,7,8,9,
                3,3,   9,10,11,12,13,14,15,16,17]


t.run
