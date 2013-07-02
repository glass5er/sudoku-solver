#!/usr/bin/env ruby

class Block
  attr_reader :value
  attr_reader :cands
  def initialize(val = 0)
    @value = val
    @cands = (1..9).to_a
    @cands = [val] if val > 0
  end

  def setValue(val)
    raise InvalidNumException unless @cands.find {|c| c == val}
    @value = val
    @cands = [val]
  end

  def update()
    raise NumNotFoundException if @cands.size <= 0 && @value <= 0

    flag = false
    if @cands.size == 1 then
      @value = @cands[0]
      flag = true
    end

    return @value, flag
  end

  def exclude(n)
    @cands.delete(n)
    #update()
  end
end

class Stage
  def initialize(filename="")
    @rows = 9
    @cols = 9

    @field = Array.new(@rows)

    @rows.times {|y|
      @field[y] = Array.new(@cols)
    }

    read(filename) if File.exist?(filename)

  end

  def read(filename)
    File.open(filename) {|f|
      y = 0
      while line = f.gets do
        x = 0
        line.chomp.chars { |c|
          @field[y][x] = Block.new(c.to_i)
          x += 1
        }
        y += 1
        break if y >= 9
      end
    }
  end

  def solve()
    begin
      updated = false
      @rows.times {|y|
        @cols.times {|x|

          n, flag = @field[y][x].update()
          if flag then
            @rows.times {|cy|  @field[cy][x].exclude(n) }
            @cols.times {|cx|  @field[y][cx].exclude(n) }
            area_x = x / 3
            area_y = y / 3
            3.times {|ay|
              3.times {|ax|
                @field[area_y * 3 + ay][area_x * 3 + ax].exclude(n)
              }
            }
            updated = true
          #else
            #puts "(#{y},#{x}) => #{n} : #{@field[y][x].cands}"
          end

        }
      }
    end while updated
  end

  def to_s()
    str = ""
    @rows.times {|y|
      @cols.times {|x|
        str += @field[y][x].value.to_s
      }
      str += "\n"
    }
    str
  end
end


