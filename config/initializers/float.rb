# Restart required even in development mode when you modify this file.

class Float
  def to_one
    (self * 10).round().to_f / 10
  end
end
