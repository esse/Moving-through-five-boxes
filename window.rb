require 'gosu'
require 'texplay'
require 'active_support'

class Point3d
    attr_accessor :x, :y, :z
    
    def initialize(x = 0, y = 0, z = 0)
      @x = x
      @y = y
      @z = z
    end

    def rotateX(angle)
      rad = angle * Math::PI / 180
      cosa = Math::cos(rad)
      sina = Math::sin(rad)
      y = @y * cosa - @z * sina
      z = @y * sina + @z * cosa
      Point3d.new(@x, y, z)
    end

    def rotateY(angle)
      rad = angle * Math::PI / 180
      cosa = Math::cos(rad)
      sina = Math::sin(rad)
      z = @z * cosa - @x * sina
      x = @z * sina + @x * cosa
      Point3d.new(x, @y, z)
    end

    def rotateZ(angle)
      rad = angle * Math::PI / 180
      cosa = Math::cos(rad)
      sina = Math::sin(rad)
      x = @x * cosa - @y * sina
      y = @x * sina + @y * cosa
      Point3d.new(x, y, @z)
    end

    def project(win_width, win_height, fov, viewer_distance)
      factor = fov / (viewer_distance + @z)
      x = @x * factor + win_width / 2
      y = -@y * factor + win_height / 2
      return nil if @z > 9.99999999999
      return Point3d.new(x, y, 1)
    end
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Ruby Gosu Graphics"
    @image = TexPlay.create_image(self, 640, 480, :color => Gosu::Color::BLUE) 
    @vertices =
    [
      #first cube
                Point3d.new(11.987708,-1.000000,1.000000),
                Point3d.new(11.987708,-1.000000,3.000000),
                Point3d.new(9.243792,-1.000000,3.000000),
                Point3d.new(9.243793,-1.000000,1.000000),
                Point3d.new(11.987709,1.000000,1.000000),
                Point3d.new(11.987707,1.000000,3.000000),
                Point3d.new(9.243792,1.000000,3.000000),
                Point3d.new(9.243793,1.000000,1.000000),
      #second cube
                Point3d.new(-2.956952,-0.000000,-7.195473),
                Point3d.new(-2.956952,-0.000000,-5.195473),
                Point3d.new(3.043049,-0.000000,-5.195473), 
                Point3d.new(3.043047,-0.000000,-7.195474), 
                Point3d.new(-2.956953,2.000000,-7.195473), 
                Point3d.new(-2.956950,2.000000,-5.195473), 
                Point3d.new(3.043049,2.000000,-5.195474),
                Point3d.new(3.043048,2.000000,-7.195473),
        #third cube
                Point3d.new(4.600000,-1.600000,3.400000),
                Point3d.new(4.600000,-1.600000,6.600000),
                Point3d.new(1.400000,-1.600000,6.600000),
                Point3d.new(1.400001,-1.600000,3.400000),
                Point3d.new(4.600001,1.600000,3.400001),
                Point3d.new(4.599999,1.600000,6.600001),
                Point3d.new(1.399999,1.600000,6.599999),
                Point3d.new(1.400000,1.600000,3.400000),
          #fourth cube
              Point3d.new(7.987709,-1.000000,-5.000000),
              Point3d.new(7.987709,-1.000000,-3.000000),
              Point3d.new(5.243792,-1.000000,-3.000000),
              Point3d.new(5.243793,-1.000000,-5.000000),
              Point3d.new(7.987709,1.000000,-5.000000),
              Point3d.new(7.987708,1.000000,-3.000000),
              Point3d.new(5.243792,1.000000,-3.000000),
              Point3d.new(5.243793,1.000000,-5.000000),
          #fifth cube
              Point3d.new(-3.000000,-1.000000,-1.000000),
              Point3d.new(-3.000000,-1.000000,1.000000),
              Point3d.new(3.000000,-1.000000,1.000000),
              Point3d.new(2.999999,-1.000000,-1.000000),
              Point3d.new(-3.000001,1.000000,-1.000000),
              Point3d.new(-2.999998,1.000000,1.000001),
              Point3d.new(3.000001,1.000000,1.000000),
              Point3d.new(3.000000,1.000000,-1.000000)
    ]
    @faces =
      [
      [0, 1, 2, 3], [4, 7, 6, 5], [0, 4, 5, 1], [1, 5, 6, 2], [2, 6, 7, 3], [4, 0, 3, 7],
      [8, 9, 10, 11], [12, 15, 14, 13], [8, 12, 13, 9], [9, 13, 14, 10], [10, 14, 15, 11], [12, 8, 11, 15],
      [16, 17, 18, 19], [20, 23, 22, 21], [16, 20, 21, 17], [17, 21, 22, 18], [18, 22, 23, 19], [20, 16, 19, 23],
      [24, 25, 26, 27], [28, 31, 30, 29], [24, 28, 29, 25], [25, 29, 30, 26], [26, 30, 31, 27], [28, 24, 27, 31],
      [32, 33, 34, 35], [36, 39, 38, 37], [32, 36, 37, 33], [33, 37, 38, 34], [34, 38, 39, 35], [36, 32, 35, 39]
      ]
    @distance = -10
   @colors = [:red, :green, :blue, :yellow, :white, :black, :orange]
  end

  def update
    if button_down? Gosu::KbE then
      @vertices = @vertices.map do |v|
        v.rotateX(2)
      end
    end
    if button_down? Gosu::KbD then
      @vertices = @vertices.map do |v|
        v.rotateX(-2)
      end
    end
    if button_down? Gosu::KbQ then
      @vertices = @vertices.map do |v|
        v.rotateY(2)
      end
    end
    if button_down? Gosu::KbW then
      @vertices = @vertices.map do |v|
        v.rotateY(-2)
      end
    end 
    if button_down? Gosu::KbC then
      @vertices = @vertices.map do |v|
        v.rotateZ(2)
      end
    end
    if button_down? Gosu::KbV then
      @vertices = @vertices.map do |v|
        v.rotateZ(-2)
      end
    end
    if button_down? Gosu::KbUp then
      @vertices = @vertices.map do |v|
          Point3d.new(v.x, v.y, v.z+0.2)
      end
    end
    if button_down? Gosu::KbDown then
      @vertices = @vertices.map do |v|
        Point3d.new(v.x, v.y, v.z-0.2)
      end

    end
    if button_down? Gosu::KbLeft then
      @vertices = @vertices.map do |v|
        Point3d.new(v.x - 0.2, v.y, v.z)
      end
    end
    if button_down? Gosu::KbRight then
      @vertices = @vertices.map do |v|
        Point3d.new(v.x + 0.2, v.y, v.z)
      end
    end
    if button_down? Gosu::KbO then
      @vertices = @vertices.map do |v|
        Point3d.new(v.x, v.y+0.1, v.z)
      end
    end
    if button_down? Gosu::KbL then
      @vertices = @vertices.map do |v|
        Point3d.new(v.x, v.y-0.1, v.z)
      end
    end
    if button_down? Gosu::KbEscape then
      close
    end
  end

  def draw
    @image = TexPlay.create_image(self, 640, 480, :color => Gosu::Color::BLUE) 
    t = []
    @vertices.each do |v|
      t << v.project(640, 480, 256, @distance)
    end
    avg_z = []
    @faces.each_with_index do |f,i|
      if [t[f[0]], t[f[1]], t[f[2]], t[f[3]]].include? nil
       next
      end
      z = (@vertices[f[0]].z + @vertices[f[1]].z + @vertices[f[2]].z + @vertices[f[3]].z) / 4.0
      avg_z << [i,z]
    end
    avg_z.sort! { |x,y| y[1] <=> x[1] }
  avg_z.each do |tmp|  
    face_index = tmp[0]
    f = @faces[face_index]
    center_x = (t[f[0]].x + t[f[1]].x + t[f[2]].x + t[f[3]].x)/4.0
    center_y = (t[f[0]].y + t[f[1]].y + t[f[2]].y + t[f[3]].y)/4.0
    @image.paint {
    polyline [t[f[0]].x, t[f[0]].y, t[f[1]].x, t[f[1]].y,
           t[f[1]].x, t[f[1]].y, t[f[2]].x, t[f[2]].y,
           t[f[2]].x, t[f[2]].y, t[f[3]].x, t[f[3]].y,
           t[f[3]].x, t[f[3]].y, t[f[0]].x, t[f[0]].y], :closed => true, :color => :red
           if ARGV.include? "color"
                fill center_x, center_y, :color => :red
                fill (t[f[2]].x - t[f[0]].x)*1/8 + t[f[0]].x, (t[f[2]].y - t[f[0]].y)*1/8 + t[f[0]].y, :color => :red
                fill (t[f[3]].x - t[f[1]].x)*1/8 + t[f[1]].x, (t[f[3]].y - t[f[1]].y)*1/8 + t[f[1]].y, :color => :red
                fill (t[f[2]].x - t[f[0]].x)*7/8 + t[f[0]].x, (t[f[2]].y - t[f[0]].y)*7/8 + t[f[0]].y, :color => :red
                fill (t[f[3]].x - t[f[1]].x)*7/8 + t[f[1]].x, (t[f[3]].y - t[f[1]].y)*7/8 + t[f[1]].y, :color => :red
           else
           end
    }
  end
      @image.draw(0, 0, 1)
    end
  end

window = GameWindow.new
window.show