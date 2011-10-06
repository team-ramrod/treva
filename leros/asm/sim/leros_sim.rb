#!/usr/bin/env ruby
require 'readline'
$NUM_REGISTERS = 1000

$print_steps = false

if ARGV.length > 0
    $print_steps = true
end


class Treva
    attr_accessor :pc, :registers

    def initialize file, io = nil
        @accu = 0
        @io = io
        @registers = Array.new($NUM_REGISTERS, 0)
        @pc = 0
        @app = Array.new
        @labels = Hash.new
        @breakpoints = Array.new
        File.open(file, 'r') do |f|
            while line = f.gets
                line.slice!(line.index('#')..-1) unless line.index('#').nil?
                line.slice!(line.index("//")..-1) unless line.index("//").nil?
                line.strip!
                if line.index(':')
                    @labels[line[0..-2]] = @app.length
                else
                    @app.push(line)
                end unless line.empty?
            end
        end
        @LENGTH = @app.size
    end

    def step args
        if @pc >= @LENGTH
            puts "program end"
            return 
        end
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

    def help bad_command
        puts "unknown command" if bad_command == true
        puts "commands are:
        (h)elp
        (p)rint_source
        (s)tep
        (b)reakpoint lineno
        (c)ontinue
        (i)nspect register
        (d)ump up_to
        (a)ccumulator_print
        (q)uit"
    end

    def print_source args
        @app.each_with_index do |val, i|
            puts "%d: %s" %[i,val]
        end
    end

    def toggle_breakpoint lineno
        lineno = lineno[0].to_i
        index = @breakpoints.index lineno
        if index == nil 
            @breakpoints.push lineno
        else
            @breakpoints.delete_at index
        end
    end

    def continue args
        begin
            step nil
        end while !(@breakpoints.include? @pc or @pc >= @LENGTH)
    end

    def inspect register
        puts @registers[register[0].to_i]
    end

    def accumulator args
        puts @accu
    end

    def dump range
        max_reg = range[0].to_i
        @registers[0..max_reg].each_with_index do |val, i|
            puts "reg %d = %d" % [i,val]
        end
        puts "accumulator = %d" % @accu
    end

    def run
        dict = Hash.new
        dict['a'] = :accumulator
        dict['s'] = :step
        dict['h'] = :help
        dict['b'] = :toggle_breakpoint
        dict['c'] = :continue
        dict['i'] = :inspect
        dict['d'] = :dump
        dict['p'] = :print_source
        while line = Readline.readline('> ', true)
            tokens = line.split
            command = tokens[0][0].chr
            break if command == 'q'
            if dict.has_key? command
                send(dict[command], tokens[1..-1])
            else
                help true
            end
        end
    end

    def run_old
        5000.times do |i|
            if @pc < @app.size
                puts "%d: %s" % [@pc, @app[@pc]] if $print_steps
                step
                if $print_steps
                    @registers.each_with_index do |val, i|
                        puts "register %d = %d" % [i, val] unless val == 0
                    end
                    puts "accu = %d" % @accu
                    puts
                end
                #fail if @accu == nil
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
        if arg.kind_of?(Array)
            @accu = @registers[get_value(arg[0]) + (arg[1][1..-1]).to_i]
        else
            if arg.index('<').nil?
                @accu = get_value arg
            else
                @accu = @labels[arg[1..-1]]
            end
        end
    end

    def store arg
        if arg.kind_of?(Array)
            @registers[get_value(arg[0]) + (arg[1][1..-1]).to_i] = @accu
        else
            @registers[get_address arg] = @accu
        end
    end

    def add arg
        @accu += get_value arg
    end

    def sub arg
        @accu -= get_value arg
    end

    def shr
        @accu /= 2
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
        @registers[get_address arg] = @pc
        @pc = @accu
    end

    def brnz arg
        @pc = @labels[arg] if @accu != 0
    end

    def brz arg
        @pc = @labels[arg] unless @accu != 0
    end

    def branch arg
        @pc = @labels[arg]
    end

    def in args
        temp =
            @accu = @io.in(args[0], args[1])
    end

    def out arg
        @io.out @accu, arg[0], arg[1]
    end

    def nop
        #do nothing
    end
end
