#!/usr/bin/ruby
$NUM_REGISTERS = 1000

class Treva
    attr_accessor :pc, :registers

    def initialize file, io = nil
        @accu = 0
        @io = io
        @registers = Array.new($NUM_REGISTERS, 0)
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
        case chunks.size
        when 1 #nop
            send chunks[0].to_sym
        when 2
            send chunks[0].to_sym, chunks[1]
        else
            send chunks[0].to_sym, chunks[1..-1]
        end

    end

    def run
        80.times do |i|
            if @pc < @app.size
                puts "%d: %s. Accu = %d" % [@pc, @app[@pc], @accu]
                step
                fail if @accu == nil
            end
        end
    end

    def get_value arg
        val =
            if arg.index('r') != nil
                @registers[arg[1..-1].to_i]
            else
                arg.to_i
            end
        fail if val == nil
        val
    end

    def get_address register
        register[1..-1].to_i
    end

    def load arg
        if arg.index('<').nil?
            @accu = get_value arg
        end
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

    def and arg
        @accu = @accu.to_i & (get_value arg).to_i
    end

    def mult arg
        @accu *= get_value arg
    end

    def loadh arg
        if arg.index('>')
            @accu = @labels[arg[1..-1]]
        else
            @accue = arg.to_i << 8
        end
    end

    def jal arg
        @registers[get_address arg] = @pc-1
        @pc = @accu + 1
    end

    def brnz arg
        @pc = @labels[arg] if @accu != 0
    end

    def brz arg
        @pc = @labels[arg] unless @accu != 0
    end

    def in args
        @accu = @io.in(args[0], args[1])
    end

    def out arg
    end

    def nop
        #do nothing
    end
end