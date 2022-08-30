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

  # ウィンドウの大きさ
  Window.width = 320
  Window.height = 320

  # ブロック
  block = Image.new(20, 20, C_WHITE)            # 壁(白)
  player = Image.new(20, 20, C_BLUE)            # プレイヤー(青)
  start = Image.new(20, 20, C_RED)              # スタート地点(赤)
  goal = Image.new(20, 20, C_GREEN)             # ゴール地点(緑)
  pass = Image.new(20, 20, [192, 192, 192])     # 通った道(グレー)
  route = Image.new(20, 20, [255, 255, 165, 0]) # 最短経路(オレンジ)

  # 迷路を表示
  def draw_map(map, block, pass)   
      (0..15).each do |i|
          (0..15).each do |j|
              if map[i][j] == 1
                  Window.draw(j * 20, i * 20, block)
              elsif map[i][j] == 5
                  Window.draw(j * 20, i * 20, pass)
              end
          end
      end
  end

  # BFS(幅優先探索)
  def bfs(map, ar, short)
      dx = [1, -1, 0, 0]
      dy = [0, 0, 1, -1]
      queue = [[1, 1]]
      cnt = 0

      # スタート地点からの距離
      dis = Array.new(16){ Array.new(16) }
      dis[1][1] = 0  

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
      n = dis[12][12]  # ゴールまでの距離
      x = 12
      y = 12
      # 最短経路
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
  x = 1
  y = 1
  status = 0

  # 最短経路を表示
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
      draw_map(map, block, pass)              # 迷路
      Window.draw(1 * 20, 1 * 20, start)      # スタート地点
      Window.draw(12 * 20, 12 * 20, goal)     # ゴール地点
      case status
      when 0            # ゴールでないとき
          i = ar[0][0]
          j = ar[0][1]
          Window.draw(j * 20, i * 20, player)
          ar.shift
          map[i][j] = 5
          sleep(0.1)
          status = 1 if i == 12 && j == 12
      when 1            # ゴールに着いたら
          sleep(1)
          short_map(short, route)  # 最短経路
      end
  end
end
