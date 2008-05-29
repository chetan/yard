require File.dirname(__FILE__) + '/spec_helper'

describe YARD::Handlers::ClassHandler do
  before { parse_file :class_handler_001, __FILE__ }
  
  it "should parse a class block with docstring" do
    P("A").docstring.should == "Docstring"
  end
  
  it "should handle complex class names" do
    P("A::B::C").should_not == nil
  end
  
  it "should handle the subclassing syntax" do
    P("A::B::C").superclass.path.should == "String"
    P("A::X").superclass.should == Registry.at("A::B::C")
  end
  
  it "should interpret class << self as a class level block" do
    P("A::classmethod1").should_not == nil
  end
  
  it "should interpret class << ClassName as a class level block in ClassName's namespace" do
    P("A::B::C::Hello").should be_instance_of(CodeObjects::MethodObject)
  end
  
  it "should make visibility public when parsing a block" do
    P("A::B::C#method1").visibility.should == :public
  end
  
  it "should raise an UndocumentableError if the class is invalid" do
    ["CallMethod('test')", "VSD^#}}", 'not.aclass', 'self'].each do |klass|
      s = "class #{klass}; end"
      c = ClassHandler.new(nil, StatementList.new(s).first)
      lambda { c.process }.should raise_error(UndocumentableError)
    end
  end
  
  it "should raise an UndocumentableError if the superclass is invalid" do
    ["CallMethod('test')", "VSD^#}}", 'not.aclass', 'self'].each do |klass|
      s = "class A < #{klass}; end"
      c = ClassHandler.new(nil, StatementList.new(s).first)
      lambda { c.process }.should raise_error(UndocumentableError)
    end
  end
end