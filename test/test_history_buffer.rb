#!/usr/bin/env ruby

module InLine
	TEST_HOME = File.dirname(File.expand_path(__FILE__))+'/..' unless const_defined?(:TEST_HOME)
end

require "#{InLine::TEST_HOME}/lib/history_buffer"

describe InLine::HistoryBuffer do

	before :each do
		@history = InLine::HistoryBuffer.new(5)
	end

	it "instantiates an empty array when created" do
 		@history.length.should == 0
	end

	it "allows items to be added to the history" do
		@history << "line #1"
		@history << "line #2"
		@history << "line #3"
		@history << "line #2"
		@history.should == ["line #1", "line #3", "line #2"]
	end

	it "does not overflow" do
		@history << "line #1"
		@history << "line #2"
		@history << "line #3"
		@history << "line #4"
		@history << "line #5"
		@history << "line #6"
		@history.length.should == 5
	end

	it "allows navigation back and forward" do
		@history.back
		@history.forward
		@history.position.should == nil
		@history << "line #1"
		@history << "line #2"
		@history << "line #3"
		@history << "line #4"
		@history << "line #5"
		@history.back
		@history.back
		@history.back
		@history.back
		@history.back
		@history.position.should == 0
		@history.back
		@history.position.should == 0
		@history.forward
		@history.position.should == 1
		@history.forward
		@history.forward
		@history.forward
		@history.forward
		@history.position.should == 4
		@history.forward
		@history.position.should == 4
	end

	it "can retrieve the last element or the element at @position via 'get'" do
		@history.get.should == nil
		@history << "line #1"
		@history << "line #2"
		@history << "line #3"
		@history << "line #4"
		@history << "line #5"
		@history.get.should == "line #5"
		@history.back
		@history.get.should == "line #4"
		@history.forward
		@history.get.should == "line #5"
	end

	it "can be cleared and resized" do
		@history << "line #1"
		@history << "line #2"
		@history << "line #3"
		@history << "line #4"
		@history << "line #5"
		@history.back
		@history.back
		@history.get.should == "line #4"
		@history.resize(6)
		@history.position.should == nil
		@history << "line #6"
		@history.get.should == "line #6"
		@history.clear
		@history.should == []
		@history.size.should == 6
		@history.position.should == nil
	end
 
end

