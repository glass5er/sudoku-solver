#!/usr/bin/env ruby

# -- N for stage size
# -- only N = 3 available currently : 9x9 sudoku
N = 3
STAGE_WH = N ** 2
BLOCK_WH = N

# -- exception classes
class InvalidInputFormatException < Exception; end
class NumNotFoundException        < Exception; end

class Block
  attr_reader :value
  attr_reader :cands
  def initialize(val = 0)
    @value = val
    @cands = (1..STAGE_WH).to_a
    @cands = [val] if val > 0
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
    @rows = STAGE_WH
    @cols = STAGE_WH

    @field = Array.new(@rows)

    @rows.times {|y|
      @field[y] = Array.new(@cols)
    }

    begin
      read(filename)
    rescue InvalidInputFormatException => e
      # -- InvalidInputFormatException : add error message
      raise e, "Input txt file should be #{STAGE_WH}x#{STAGE_WH} matrix format."
      # -- FileNotFoundException : send to default error handler
    end

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
        raise InvalidInputFormatException if x != STAGE_WH
        y += 1
        break if y >= STAGE_WH
      end
    }
  end

  def solve()
    begin
      updated = false

      @rows.times {|y|
        @cols.times {|x|

          # -- n    = @field[y][x].value
          # -- flag = @field[y][x].updted?
          n, flag = @field[y][x].update()

          if flag then
            # -- exclude n from candidate

            # -- h-line, v-line
            @rows.times {|cy|  @field[cy][x].exclude(n) }
            @cols.times {|cx|  @field[y][cx].exclude(n) }

            # -- square-block
            area_x = x / BLOCK_WH
            area_y = y / BLOCK_WH
            BLOCK_WH.times {|ay|
              BLOCK_WH.times {|ax|
                @field[area_y * BLOCK_WH + ay][area_x * BLOCK_WH + ax].exclude(n)
              }
            }

            updated = true
          else
            puts "(#{y},#{x}) => #{n} : #{@field[y][x].cands}" if $DEBUG
          end

        }
      }
    end while updated
    # -- can finish anyway when impossible questions
    return check()
  end

  def check()
    @rows.times {|y|
      @cols.times {|x|
        # -- simple check (not perfect...)
        return false if @field[y][x].value == 0
      }
    }
    true
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


