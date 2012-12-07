module Musicality
module Optimization

# Leverages the Array class to make a very useful Vector class
# (I think better than the Ruby built-in).
# 
# Straight from the Internet, found posted on:
# http://www.manybody.org/wiki/index.php/MSA-A_Complete_Vector_Class-Ruby
class Vector < Array
  def +(a)
    sum = Vector.new
    self.each_index{|k| sum[k] = self[k]+a[k]}
    sum
  end
  
  def -(a)
    diff = Vector.new
    self.each_index{|k| diff[k] = self[k]-a[k]}
    diff
  end
  
  def +@
    self
  end
  
  def -@
    self.map{|x| -x}.to_v
  end
  
  def *(a)
    if a.class == Vector              # inner product
      product = 0
      self.each_index{|k| product += self[k]*a[k]}
    else
      product = Vector.new            # scalar product
      self.each_index{|k| product[k] = self[k]*a}
    end
    product
  end
  
  def /(a)
    if a.class == Vector
      raise
    else
      quotient = Vector.new           # scalar quotient
      self.each_index{|k| quotient[k] = self[k]/a}
    end
    quotient
  end
end

end
end

class Array
  def to_v
    Vector[*self]
  end
end

class Fixnum
  alias :original_mult :*
  def *(a)
    if a.class == Musicality::Optimization::Vector
      a*self
    else
      original_mult(a)
    end
  end
end

class Float
  alias :original_mult :*

  def *(a)
    if a.class == Musicality::Optimization::Vector
      a*self
    else
      original_mult(a)
    end
  end
end
