require 'spec_helper'
describe "RationalNumber" do

  describe "when initializing"  do
    describe "using 0 options" do
      it "should initialize properly" do
        a = RationalNumber.new
        a.nv.should == 0
        a.dv.should == 1
        a.snv.should == 1
        a.sdv.should == 0
      end
    end

    describe "using 1 option" do
      it "should initialize with a single RationalNumber as argument" do
        a = RationalNumber.new
        a.set_values(5,2,8,3)
        b = RationalNumber.new(a)
        b.nv.should == a.nv
        b.dv.should == a.dv
        b.snv.should == a.snv
        b.sdv.should == a.sdv
      end

      it "should raise an error if rational_number option has the wrong type/data" do
        expect {RationalNumber.new(4)}.to raise_error(ArgumentError)
      end
    end # describe 1 option

    describe "using 2 options" do
      it "should initialize with nv and dv values" do
        a = RationalNumber.new(5, 2)
        a.nv.should == 5
        a.dv.should == 2
        a.snv.should == 8
        a.sdv.should == 3
      end

      it "should raise an error if rational_number option has the wrong type/data" do
        expect {RationalNumber.new("cow", 2)}.to raise_error(ArgumentError)
      end
    end # describe 2 options

    describe "using 4 options" do
      it "should initialize with nv, dv, snv and sdv values" do
        a = RationalNumber.new(5, 2, 8, 3)
        a.nv.should == 5
        a.dv.should == 2
        a.snv.should == 8
        a.sdv.should == 3
      end

      it "should raise an error if rational_number option has the wrong type/data" do
        expect {RationalNumber.new(5, 2, 5, "cow" )}.to raise_error(ArgumentError)
      end
    end # describe 4 options
  end # describe when initializing

  describe "when using" do

    before(:each) do
      @root = RationalNumber.new
      @first_child = @root.child_from_position(1)
    end

    it "should verify that @root is @root" do
      @root.root?.should == true
    end

    it "should raise an error when trying to get parent rational number on @root" do
      expect {@root.parent}.to raise_error(NoParentRationalNumberIsRootError)
    end

    it "should raise an error when trying to get a sibling on @root" do
      expect {@root.next_sibling}.to raise_error(RationalNumberIsRootNoSiblingsError)
      expect {@root.sibling_from_position(0)}.to raise_error(RationalNumberIsRootNoSiblingsError)
    end

    it "should verify values" do
      @root.nv.should ==  0
      @root.dv.should ==  1
      @root.snv.should == 1
      @root.sdv.should == 0
      @root.number.should == BigDecimal(0)
    end

    it "should create a 0 based rational number without getting div by zero" do
      test = RationalNumber.new(0,0,0,0)
      test.number.should == BigDecimal(0)
    end

    it "should get the first child values" do
      @first_child.nv.should  == 1
      @first_child.dv.should  == 1
      @first_child.snv.should == 2
      @first_child.sdv.should == 1
      @first_child.number.should == BigDecimal(@first_child.nv)/BigDecimal(@first_child.dv)
    end

    it "should verify the parent values of the first child" do
      parent = @first_child.parent
      child = @first_child
      parent.should == child.parent
    end

    it "should verify the parent values of a child of the first child" do
      parent = @first_child
      child = @first_child.child_from_position(5)
      parent.should == child.parent
    end

    it "should get the child values from a given position" do
      fifth_child = @root.child_from_position(5)
      fifth_child.nv.should  == 5
      fifth_child.dv.should  == 1
      fifth_child.snv.should == 6
      fifth_child.sdv.should == 1
      fifth_child.number.should == BigDecimal(fifth_child.nv)/BigDecimal(fifth_child.dv)
    end

    it "should get the next sibling from first child" do
      next_sibling = @first_child.next_sibling
      next_sibling.nv.should  == 2
      next_sibling.dv.should  == 1
      next_sibling.snv.should == 3
      next_sibling.sdv.should == 1
      next_sibling.number.should == BigDecimal(next_sibling.nv)/BigDecimal(next_sibling.dv)
    end

    it "should get fifth sibling from first child" do
      fifth_sibling = @first_child.sibling_from_position(5)
      fifth_sibling.nv.should  == 5
      fifth_sibling.dv.should  == 1
      fifth_sibling.snv.should == 6
      fifth_sibling.sdv.should == 1
      fifth_sibling.number.should == BigDecimal(fifth_sibling.nv)/BigDecimal(fifth_sibling.dv)
    end

    it "should verify two children of the first child" do
      child_1_1 = @first_child.child_from_position(1)
      child_1_1.nv.should  == 3
      child_1_1.dv.should  == 2
      child_1_1.snv.should == 5
      child_1_1.sdv.should == 3
      child_1_1.number.should == BigDecimal(child_1_1.nv)/BigDecimal(child_1_1.dv)

      child_1_3 = @first_child.child_from_position(3)

      child_1_3.nv.should  == 7
      child_1_3.dv.should  == 4
      child_1_3.snv.should == 9
      child_1_3.sdv.should == 5
      child_1_3.number.should == BigDecimal(child_1_3.nv)/BigDecimal(child_1_3.dv)
    end

    it "should verify the position of three rational numbers" do
      child_1_1 = @first_child.child_from_position(1)
      child_1_1.position.should == 1
      child_1_3 = @first_child.child_from_position(3)
      child_1_3.position.should == 3
      fifth_child = @root.child_from_position(5)
      fifth_child.position.should == 5
    end

    it "should verify comparison of rational numbers" do
      child_1   = @first_child
      child_1_1 = @first_child.child_from_position(1)
      child_1_3 = @first_child.child_from_position(3)
      child_2   = @first_child.next_sibling

      child_1.should   < child_1_1
      child_1_1.should < child_1_3
      child_1_3.should < child_2
      child_2.should   > child_1
      child_2.should   > child_1_1
      child_2.should   > child_1_3
      child_1_1.should == child_1_1
      @root.should     == @root
      child_2.should   == child_2
      child_1_1.should_not == child_1_3
      child_1_1.should_not == child_1
      child_1_1.should_not == @root
      child_1.should_not   == child_2

    end

    it "should set values directoy" do
      a = RationalNumber.new
      b = @first_child.child_from_position(3)
      a.set_from_other(b)
      b.should == a
    end

    it "should set values from other RationalNumber" do
      a = RationalNumber.new
      b = @first_child.child_from_position(3)
      a.set_values(b.nv,b.dv,b.snv,b.sdv)
      b.should == a
    end

    it "should check if the RationalNumber resonds to being a child of an given parent" do
      child_1_4 = @first_child.child_from_position(4)
      @first_child.is_child_of?(@root).should     == true
      child_1_4.is_child_of?(@root).should        == false
      child_1_4.is_child_of?(@first_child).should == true
      child_1_4.is_child_of?(child_1_4).should    == false # should return false for same object
    end

    it "should check if the RationalNumber responds to being a parent of a given child" do
      child_1_4 = @first_child.child_from_position(4)
      @root.is_parent_of?(@first_child).should     == true
      @root.is_parent_of?(child_1_4).should        == false
      @first_child.is_parent_of?(child_1_4).should == true
      child_1_4.is_parent_of?(child_1_4).should    == false # should return false for same object
    end

    it "should respons if the RationalNumber is a descendant of given parent" do
      child_1_4   = @first_child.child_from_position(4)
      child_1_4_9 = child_1_4.child_from_position(9)
      child_1_4_9.is_descendant_of?(@root).should        == true
      child_1_4_9.is_descendant_of?(@first_child).should == true
      child_1_4_9.is_descendant_of?(child_1_4).should    == true

      child_1_4.is_descendant_of?(@root).should          == true
      child_1_4.is_descendant_of?(@first_child).should   == true
      child_1_4.is_descendant_of?(child_1_4_9).should    == false

      @first_child.is_descendant_of?(@root).should       == true
      @first_child.is_descendant_of?(child_1_4).should   == false

      @root.is_descendant_of?(@root).should               == false
      @first_child.is_descendant_of?(@first_child).should == false
      @root.is_descendant_of?(child_1_4_9).should         == false
    end

    it "should generate a Hash from the rational number" do
      child_1_4   = @first_child.child_from_position(4)
      child_1_4.to_hash.should == {
                                    :nv => child_1_4.nv,
                                    :dv => child_1_4.dv,
                                    :snv => child_1_4.snv,
                                    :sdv => child_1_4.sdv,
                                    :number => child_1_4.number
                                  }
    end

    it "should generate a nice printable string for debugging purposes" do
      child_1_4   = @first_child.child_from_position(4)
      child_1_4.to_s.should == "RationalNumber: number: #{child_1_4.number} nv: #{child_1_4.nv} dv: #{child_1_4.dv} snv: #{child_1_4.snv} sdv: #{child_1_4.sdv}"
    end

  end # describe when using
end  #describe RationalNumber
