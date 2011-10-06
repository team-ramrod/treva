$NUM_REGISTERS = 1000

class Treva
    def init
        @registers = Array.new($NUM_REGISTERS)
        
    end
    
    def regnum regname
        regname[1..-1].to_i
    end
    
    def load arg
        if arg.is_a? Numeric
            @accu = arg
        elsif arg.is_a? String
            @accu = @registers[regnum arg]
        end
    end
    
    def store arg
        @registers[regnum arg] = @accu
    end
    
    def add arg
    
    end
    
    def sub arg
    
    end
    
    def mult arg
    
    end
    
    def load arg
    
    end
    
    def load arg
    
    end
    
    def loadh arg
    
    end
    
    def jal arg
    
    end
    
    def brnz arg
    
    end
    
    def brz arg
    
    end
    
    def nop arg
    
    end
end

class Simulation
    def init
        @app = Array.new
        @labels = Hash.new
        File.open(a, 'r') do |f|  
            while line = f.gets 
                line.slice!(line.index('#')..-1)
                line.strip!
                if line[-1] == ':'
                    @labels[line[0..-2]] = @app.length 
                else
                    @app.push(line) 
                end unless line.empty?
            end
        end  
        trev = Treva.new
    end
    
    def run
        @app.for_each do |line|
            print line
        end
        @labels.for_each do|key, value|
            print key + ' ' + value
        end
    end
    
end




ARGV.each do|a|
    Simulation.new(a).run
end