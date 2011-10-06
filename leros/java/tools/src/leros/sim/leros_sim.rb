#!/usr/bin/ruby
$NUM_REGISTERS = 1000

class Treva
    @attr_accessor :pc

    def initialize file
        @registers = Array.new($NUM_REGISTERS)
        @pc = 0
        @app = Array.new
        @labels = Hash.new
        File.open(file, 'r') do |f|
            while line = f.gets
                line.slice!(line.index('#')..-1) unless line.index('#').nil?
                line.strip!
                if line.index(':')
                    @labels[line[0..-2]] = @app.length
                else
                    @app.push(line)
                end unless line.empty?
            end
        end
    end

    def step
        chunks = @app[@pc].split
        @pc += 1
        send chunks[0].to_sym, chunks[1]
    end

    def run
        while @pc < @app.size
            step
        end
    end

    def get_value arg
        if arg.index('r')
            @registers[arg[1..-1].to_i]
        else
            arg.to_i
        end
    end

    def load arg
        @accu = get_value arg if ar.index('<').nil?
    end

    def store arg
        @registers[get_value arg] = @accu
    end

    def add arg
        @accu += get_value arg
    end

    def sub arg
        @accu -= get_value arg
    end

    def mult arg
        @accu *= get_value arg
    end

    def loadh arg
        @dest = arg[1..-1]
    end

    def jal arg
       @return_point = @pc
    end

    def brnz arg
        @pc = labels[arg] if @accu != 0
    end

    def brz arg
        @pc = labels[arg] unless @accu != 0
    end

    def nop arg
        #do nothing
    end
end


files = Array['asm/ghost.asm']

files.each do|a|
    Treva.new(a).run
end

ARGV.each do|a|
    Treva.new(a).run
end
