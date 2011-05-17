require 'gosu'
require 'texplay'
require 'activesupport'

class Building
  
  attr_accessor :points
  
  def initialize(points)
    @points = points
    @d = 200
  end
  
  def projection(hash)
    x0 = hash[:x]
    y0 = hash[:y]
    z0 = hash[:z]
    if (z0 + @d > 0)
      x = (x0 * @d) / (z0 + @d);
      y = (y0 * @d) / (z0 + @d);    
    end
    {:x => x0, :y => y0}
  end
  
  def paint_self(image)
    
  end
  
end


class Point3d

    attr_accessor :x, :y, :z
    
    def initialize(x = 0, y = 0, z = 0)
      @x = x
      @y = y
      @z = z
    end

    def rotateX(angle)
   #   """ Rotates the point around the X axis by the given angle in degrees. """
      rad = angle * Math::PI / 180
      cosa = Math::cos(rad)
      sina = Math::sin(rad)
      y = @y * cosa - @z * sina
      z = @y * sina + @z * cosa
      Point3d.new(x, y, z)
    end

    def rotateY(angle)
   #   """ Rotates the point around the Y axis by the given angle in degrees. """
      rad = angle * Math::PI / 180
      cosa = Math::cos(rad)
      sina = Math::sin(rad)
      z = @z * cosa - @x * sina
      x = @z * sina + @x * cosa
      Point3d.new(x, @y, z)
    end

    def rotateZ(angle)
    #  """ Rotates the point around the Z axis by the given angle in degrees. """
      rad = angle * Math::PI / 180
      cosa = Math::cos(rad)
      sina = Math::sin(rad)
      x = @x * cosa - @y * sina
      y = @x * sina + @y * cosa
      Point3d.new(x, y, @z)
    end

    def project(win_width, win_height, fov, viewer_distance)
   #   """ Transforms this 3D point to 2D using a perspective projection. """
      factor = fov / (viewer_distance + @z)
      x = @x * factor + win_width / 2
      y = -@y * factor + win_height / 2
      return Point3d.new(x, y, 1)
    end
end

class GameWindow < Gosu::Window
  def initialize
    super 640, 480, false
    self.caption = "Gosu Tutorial Game"
    @image = TexPlay.create_image(self, 640, 480, :color => Gosu::Color::BLUE) 
    @vertices = [
                Point3d.new(-1,1,-1),
                Point3d.new(1,1,-1),
                Point3d.new(1,-1,-1),
                Point3d.new(-1,-1,-1),
                Point3d.new(-1,1,1),
                Point3d.new(1,1,1),
                Point3d.new(1,-1,1),
                Point3d.new(-1,-1,1)
            ]
    @faces = [[0,1,2,3],[1,5,6,2],[5,4,7,6],[4,0,3,7],[0,4,5,1],[3,2,6,7]]
    @queue = []
  end

  def update
    if button_down? Gosu::KbLeft or button_down? Gosu::GpLeft then
      p "lewo!"
      @queue << "rotX"
    end
    if button_down? Gosu::KbRight or button_down? Gosu::GpRight then
      @queue << "rotY"
    end
    if button_down? Gosu::KbUp or button_down? Gosu::GpButton0 then
      @queue << "rotZ"
    end
  end

  def draw
        @image = TexPlay.create_image(self, 640, 480, :color => Gosu::Color::BLUE) 
 #   @building = Building.new([{:x => 0, :y => 0, :z => 0}, {:x => 100, :y => 0, :z => 0},{:x => 0, :y => 100, :z => 0},{:x => 100, :y => 100, :z => 0},
#      {:x => 0, :y => 0, :z => 100}, {:x => 100, :y => 0, :z => 100},{:x => 0, :y => 100, :z => 100},{:x => 100, :y => 100, :z => 100}])
  #  8.times do |n|
 #     eval("@projection#{n} = @building.projection(@building.points[#{n}])")
#    end
#    @image.paint {
 #       line @projection0[:x], @projection0[:x], @projection1[:x], @projection1[:y]
 #      line @projection1[:x], @projection1[:x], @projection2[:x], @projection2[:y]
  #      line @projection2[:x], @projection2[:x], @projection3[:x], @projection3[:y]
   #     line @projection3[:x], @projection3[:x], @projection4[:x], @projection4[:y]
    #    line @projection4[:x], @projection4[:x], @projection5[:x], @projection5[:y]
     #   line @projection5[:x], @projection5[:x], @projection6[:x], @projection6[:y]
      #  line @projection6[:x], @projection6[:x], @projection7[:x], @projection7[:y]
      #  line @projection7[:x], @projection7[:x], @projection0[:x], @projection0[:y]
  #  }
  t = []
  if @queue.blank?
    @vertices.each do |v|
      # Rotate the point around X axis, then around Y axis, and finally around Z axis.
      #  r = v.rotateX(self.angleX).rotateY(self.angleY).rotateZ(self.angleZ)
      # Transform the point from 3D to 2D
      p = v.project(640, 480, 256, 4)
      # Put the point in the list of transformed vertices
      t << p
    end
  else
    transform = @vertices
    @queue.each do |q|
      tr = []
      if q == "rotX"
        transform.each do |v|
          tr << v.rotateX(10)
        end
      elsif q == "rotY"
        transform.each do |v|
          tr << v.rotateY(10)
        end
        
      elsif q == "rotZ"
        transform.each do |v|
          tr << v.rotateZ(10)
        end    
      end
      transform = tr
    end
    transform.each do |v|
      p = v.project(640, 480, 256, 4)
      t << p
    end
    @vertices = transform
  end
    @queue = []
    @faces.each do |f|
      @image.paint {
        line t[f[0]].x, t[f[0]].y, t[f[1]].x, t[f[1]].y
        line t[f[1]].x, t[f[1]].y, t[f[2]].x, t[f[2]].y
        line t[f[2]].x, t[f[2]].y, t[f[3]].x, t[f[3]].y
        line t[f[3]].x, t[f[3]].y, t[f[0]].x, t[f[0]].y
      }
    end
    @image.draw(0, 0, 1)
  end
end

window = GameWindow.new
window.show