require 'dxopal'
include DXOpal
Window.load_resources do
  Window.bgcolor = C_BLACK
  

  # 1: block(while)
  # 2: start(red)
  # 3: goal(green)
  # 9: already(grey)
  map = [
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 1, 1, 1, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 1, 1, 1, 1, 0, 0, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 0, 0, 1, 0, 1, 1, 0, 1, 0, 1, 0, 1],
      [1, 0, 1, 0, 1, 1, 1, 0, 1, 1, 0, 1, 0, 1, 1, 1],
      [1, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 0, 1, 1, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 1],
      [1, 1, 1, 1, 1, 0, 1, 0, 1, 0, 1, 1, 1, 1, 0, 1],
      [1, 0, 0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1],
      [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
  ]

  Window.width = 320
  Window.height = 320

  block = Image.new(20, 20, C_WHITE)
  player = Image.new(20, 20, C_BLUE)
  start = Image.new(20, 20, C_RED)
  goal = Image.new(20, 20, C_GREEN)
  already = Image.new(20, 20, [192, 192, 192])
  route = Image.new(20, 20, [255, 255, 165, 0])

  def draw_map(map, block, start, goal, already)   
      (0..15).each do |i|
          (0..15).each do |j|
              if map[i][j] == 1
                  Window.draw(j * 20, i * 20, block)
              elsif map[i][j] == 2
                  Window.draw(j * 20, i * 20, start)
              elsif map[i][j] == 3
                  Window.draw(j * 20, i * 20, goal)
              elsif map[i][j] == 5
                  Window.draw(j * 20, i * 20, already)
              end
          end
      end
  end

  def bfs(map, ar, short)
      dx = [1, -1, 0, 0]
      dy = [0, 0, 1, -1]
      dis = Array.new(16){ Array.new(16) }
      dis[1][1] = 0
      queue = [[1, 1]]
      cnt = 0  
      until queue.empty?
          fx, fy = queue[0]
          x, y = queue.shift
          ar << [x, y]
          map[x][y] = 9
          4.times do |i|
              newx = x + dx[i]
              newy = y + dy[i]
              next if map[newx][newy] == 1 || map[newx][newy] == 9
              queue << [newx, newy]
              dis[newx][newy] = dis[fx][fy] + 1
          end
      end
      n = dis[12][12]
      x = 12
      y = 12
      while n > 0
          n -= 1
          4.times do |i|
              nx = x + dx[i]
              ny = y + dy[i]
              if dis[nx][ny] == n
                  short[nx][ny] = 1
                  x, y = nx, ny
              end
          end
      end
  end

  ar = []
  short = Array.new(16){ Array.new(16, 0) }
  bfs(map, ar, short)
  # p ar
  # p short
  x = 1
  y = 1
  status = 0

  def short_map(short, route)
      (0..15).each do |i|
          (0..15).each do |j|
              if short[i][j] == 1
                  Window.draw(j * 20, i * 20, route)
              end
          end
      end
  end

  Window.loop do
      draw_map(map, block, start, goal, already)  
      Window.draw(1 * 20, 1 * 20, start)
      Window.draw(12 * 20, 12 * 20, goal)
      case status
      when 0
          i = ar[0][0]
          j = ar[0][1]
          Window.draw(j * 20, i * 20, player)
          ar.shift
          map[i][j] = 5
          sleep(0.1)
          status = 1 if i == 12 && j == 12
      when 1
          short_map(short, route)
      end
  end
end
