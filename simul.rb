class ConwayGrid
  def initialize(size)
    @size = size
    @cells = Array.new(size) {|index| Array.new(size, 0)}
  end

  def shuffle
    @cells = @cells.collect do |line|
      line.collect {rand 2}
    end
  end

  def getItem(x,y)
    if (0...@size).include? x and (0...@size).include? y
      return @cells[x][y]
    else
      return 0
    end
  end

  def setItem(x,y, val)
    @cells[x][y] = val
  end

  def getNeighbors(x,y)
    neighbors = []
    [-1,0,1].each do |i|
      [-1,0,1].each do |j|
        neighbors << [[x+i,y+j], self.getItem(x+i, y+j)]
      end
    end
    res = {:alive => [], :dead => []}
    neighbors.each do |item|
      if item[1] == 1
        res[:alive] << item[0]
      elsif item[1] == 3
        res[:dead] << item[0]
      end
    end
    return res
  end

  def getNeighborsAlive(x,y)
    return self.getNeighbors(x,y)[:alive].size
  end
    
  def getNeighborsDead(x,y)
    return self.getNeighbors(x,y)[:dead].size
  end

  def getStringGrid
    res = ""
    @cells.each do |line|
      res << line.join(" ") << "\n"
    end
    return res
  end

end


class RuleSolver 
  def initialize(rule)
    @rule = rule
  end

  def test_under_population(an)
    if an < @rule[:under_population]
      return 0
    else
      return nil
    end
  end

  def test_over_population(x, y, an)
    if an > @rule[:over_population]
      return 0
    else
      return nil
    end
  end

  def test_survive(x, y, an)
    if @rule[:survive].include? an
      return 1
    else
      return nil
    end
  end

  def test_reproduction(x, y, an)
    if an == @rule[:reproduction]
      return 1
    else
      return nil
    end
  end

  

  def run(x, y, grid)
    it = grid.getItem(x, y)
    an = grid.getNeighborsAlive(x, y)
    if it == 1
      [test_under_population, test_over_population, test_survive].each do |fn|
        res = fn x, y, an
        if res
          return res
        end
      end
    else
      res = test_reproduction x, y, an
      if res 
        return res
      else
        return 0
      end
    end
  end

end      


class ConwayGame
  attr_accessor :grid
  def initialize(size, rules)
    @grid = ConwayGrid.new size
    @grid.shuffle
    @rules = rules
    @size = size
  end

  def showGrid
    puts @grid.getStringGrid
  end

  def playRound
    #tempGrid = ConwayGrid.new @size
    tempGrid = @grid.clone
    (0...@size).each do |x|
      (0...@size).each do |y|
        if @grid.getItem(x,y) == 1
          if @grid.getNeighborsAlive(x,y) > @rules[:alive]
            tempGrid.setItem(x,y, 3)
          elsif @grid.getNeighborsDead(x,y) > @rules[:dead]
            tempGrid.setItem(x,y, 3)
          end
        elsif @grid.getItem(x,y) == 3
          if @grid.getNeighborsAlive(x,y) > @rules[:alive2]
            tempGrid.setItem(x,y, 1)
          end
        else
          if @grid.getNeighborsAlive(x,y) > @rules[:alive3]
            tempGrid.setItem(x,y, 1)
          end
        end
      end
    end
    @grid = tempGrid
  end
end

         

    
