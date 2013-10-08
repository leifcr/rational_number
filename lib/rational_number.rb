##
# Rational Numbers (tree) in ruby
#
# Read about rational numbers in tree structures here: http://arxiv.org/pdf/0806.3115v1.pdf
#
# Please note that sibling and child will be identical if you are start at "root" level, with the default values
# (nv = 0, dv = 1, snv = 1, sdv = 0)
#
# Rational numbers always require a "root" at the bottom of the tree
#
# You can find child values, sibling values, see if a value is parent or child of a given rational number.
# It is possible to verify child/parent relationships without even checking with a database.
#

require 'bigdecimal'

class RationalNumber # < Object
  include Comparable
  attr_reader :nv, :dv, :snv, :sdv, :number

  ##
  # Compare to other (Comparable)
  # Returns 1 if greater than, -1 if less than, and 0 for equality
  #
  # @return [Integer] Integer stating the comparison.
  #
  def <=>(other)
    return 0 if (@nv === other.nv) and (@dv === other.dv) and (@snv == other.snv) and (@sdv == other.sdv)
    if @number < other.number
      -1
    elsif @number > other.number
      1
    end
  end

  ##
  # Convert to string
  #
  # @return [String] String describing the rational number.
  #
  def to_s
    "RationalNumber: number: #{@number} nv: #{@nv} dv: #{@dv} snv: #{@snv} sdv: #{@sdv}"
  end

  ##
  # Convert to Hash
  #
  # @return [Hash] hash containing the rational numbers
  #
  def to_hash
    {
      :nv => @nv,
      :dv => @dv,
      :snv => @snv,
      :sdv => @sdv,
      :number => @number
    }
  end

  ##
  # Initialize rational number
  #
  # @param [Integer/RationalNumber] The nominator value or a rational number, depending on number of given parameters
  # @param [Integer] The denominator value
  # @param [Integer] The SNV value
  # @param [Integer] The SDV Value
  #
  # @return [undefined]
  #
  def initialize(a = nil, b = nil, c = nil, d = nil)
    if a == nil and b == nil and c == nil and d == nil
      init_with_4_args()
    elsif b == nil and c == nil and d == nil
      init_with_1_arg(a)
    elsif c == nil and d == nil
      init_with_2_args(a,b)
    else
      init_with_4_args(a,b,c,d)
    end
  end

  ##
  # Initialize rational number with 1 argument
  #
  # @param [RationalNumber] The rational number to initialize with
  #
  # @return [undefined]
  #
  def init_with_1_arg(rational_number)
    raise ArgumentError, "given :rational_number in options is of wrong type, should be RationalNumber" unless rational_number.instance_of?(RationalNumber)
    set_values(rational_number.nv, rational_number.dv, rational_number.snv, rational_number.sdv)
  end

  ##
  # Initialize rational number with 2 arguments
  #
  # @param [Integer] The nominator value
  # @param [Integer] The denominator value
  #
  # @return [undefined]
  #
  def init_with_2_args(nv = 0, dv = 1)
    raise ArgumentError, ":nv and :dv must be kind_of?(Integer)." unless nv.kind_of?(Integer) and dv.kind_of?(Integer)
    # initial values needed when getting parent and position
    @nv = nv
    @dv = dv
    # calculate value
    val = value_from_parent_and_position(self.parent, self.position)
    raise ArgumentError, "Cannot set nv and dv values. verify the values for :nv and :dv" unless ((val.nv == nv) and (val.dv == dv))
    set_values(val.nv,val.dv,val.snv,val.sdv)
  end

  ##
  # Initialize rational number with 4 arguments
  #
  # @param [Integer] The nominator value
  # @param [Integer] The denominator value
  # @param [Integer] The SNV value
  # @param [Integer] The SDV Value
  #
  # @return [undefined]
  #
  def init_with_4_args(nv = 0, dv = 1, snv = 1, sdv = 0)
    unless nv.kind_of?(Integer) and dv.kind_of?(Integer) and snv.kind_of?(Integer) and sdv.kind_of?(Integer)
      raise ArgumentError, ":nv, :dv, :snv and :sdv must be kind_of?(Integer)."
    end
    set_values(nv, dv, snv, sdv)
  end

  ##
  # Set the values of nv,dv,snv and sdv directly
  #
  # @param [Integer] The nominator value
  # @param [Integer] The denominator value
  # @param [Integer] The SNV value
  # @param [Integer] The SDV Value
  #
  def set_values(nv, dv, snv, sdv)
    @nv = nv
    @dv = dv
    @snv = snv
    @sdv = sdv
    if nv == 0 and dv == 0
      @number = BigDecimal(0)
    else
      @number = BigDecimal(nv)/BigDecimal(dv)
    end
  end

  ##
  # Will set the values from another RationalNumber
  #
  # @param [RationalNumber]
  #
  # @return [undefined]
  #
  def set_from_other(other)
    set_values(other.nv, other.dv, other.snv, other.sdv)
  end

  ##
  # See if rational number is root
  #
  def root?
    (@nv === 0) and (@dv === 1) and (@snv === 1) and (@sdv === 0)
  end

  ##
  # Get the calculated postion at the current "level" for this rational number in a "tree"
  #
  # @return [Integer] The position
  #
  def position
    _parent = self.parent
    ((@nv - _parent.nv) / _parent.snv)
  end

  ##
  # Returns parent as a rational number
  #
  # @return [RationalNumber] The parent
  #
  def parent
    raise NoParentRationalNumberIsRootError if root?
    numerator   = @nv
    denominator = @dv
    _parent    = RationalNumber.new
    compare_key  = RationalNumber.new
    # make sure we break if we get root values! (numerator == 0 + denominator == 0)
    while ((compare_key.nv < @nv) && (compare_key.dv < @dv)) && ((numerator > 0) && (denominator > 0))
      div = numerator / denominator
      mod = numerator % denominator
      # set return values to previous values, as they are the parent values
      _parent.set_from_other(compare_key)

      # temporary calculations (needed)
      parent_nv = _parent.nv + (div * _parent.snv)
      parent_dv = _parent.dv + (div * _parent.sdv)

      compare_key.set_values( parent_nv ,  #nv
                              parent_dv ,  #dv
                              parent_nv + _parent.snv, #snv
                              parent_dv + _parent.sdv) #sdv
      numerator = mod
      if (numerator != 0)
        denominator = denominator % mod
        denominator = 1 if denominator == 0
      end
    end
    _parent
  end

  ##
  # Return the next sibling rational number
  #
  # Uses this RationalNumber parent values
  #
  # @return [RationalNumber] The sibling
  #
  def next_sibling
    # Raise error in case we are root
    raise RationalNumberIsRootNoSiblingsError if root?

    _parent = self.parent # Get parent already to avoid duplicate calculations
    _position = ((@nv - _parent.nv) / _parent.snv) + 1
    value_from_parent_and_position(_parent, _position)
  end

  ##
  # Return the sibling rational number from a given position.
  #
  # Uses this RationalNumber parent values
  #
  # @param [Integer] The position
  #
  # @return [RationalNumber] The sibling
  #
  def sibling_from_position(_position)
    raise RationalNumberIsRootNoSiblingsError if root?
    _parent = self.parent
    value_from_parent_and_position(_parent, _position)
  end

  ##
  # Return the rational number from parent and position
  #
  # @param [RationalNumber] The parents RationalNumber for a given RationalNumber and the new sibling
  # @param [Integer] The position
  #
  # @return [RationalNumber] The rational number
  #
  def value_from_parent_and_position(_parent, _position)
    sibling = RationalNumber.new(
      _parent.nv + (_position * _parent.snv), # nv
      _parent.dv + (_position * _parent.sdv), # dv
      _parent.nv + ((_position + 1) * _parent.snv), # snv
      _parent.dv + ((_position + 1) * _parent.sdv)  # sdv
      )
  end

  ##
  # Return the child rational number from given position
  #
  # @param [Integer] The position
  #
  # @return [RationalNumber] The child rational number
  #
  def child_from_position(_position)
    value_from_parent_and_position(self, _position)
  end

  ##
  # Check if the child is a immediate child of an parent
  #
  # @param [RationalNumber] The parents to verify against
  #
  # @return [Boolean] true if the parent to verify against is the same as the childs parent
  #
  def is_child_of?(_parent)
    return false if (self == _parent) or self.root?
    _parent == self.parent
  end

  ##
  # Check if the parent is a immediate parent of a child
  #
  # @param [RationalNumber] The parents to verify against
  #
  # @return [Boolean] true if the parent to verify against is the same as the childs parent
  #
  def is_parent_of?(_child)
    return false if self == _child
    _child.is_child_of?(self)
  end

  ##
  # Check if the child is a descendant of an parent (at any level)
  #
  # @param [RationalNumber] The parents to verify against
  #
  # @return [Boolean] true if the parent is any parent above in the hierarchy
  #
  def is_descendant_of?(_parent)
    return false if (self == _parent) or self.root?
    verify_parent = self # start with beeing self
    while !verify_parent.root? do
      verify_parent = verify_parent.parent
      return true if _parent == verify_parent
    end
    false
  end

end # class RationalNumber


##
# The rational number is root and therefore has no siblings
#
class RationalNumberIsRootNoSiblingsError < StandardError
end

##
# The rational number is root and therefore has no parent
#
class NoParentRationalNumberIsRootError < StandardError
end
