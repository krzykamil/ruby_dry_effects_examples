# frozen_string_literal: true
require 'rubygems'
require 'bundler/setup'
require 'dry/effects'

class Plate; end
class Stack
  def initialize(size)
    @stack = size.times.map{ |_| Plate.new }
  end

  private attr_reader :stack

  def push(value)
    stack.push(value)
  end

  def pop
    stack.tap(&:pop)
  end

  def peek
    stack.last
  end

  def stock
    stack.size
  end
end

class App
  include Dry::Effects::Handler.State(:stack)


  def initialize
    @stack = Stack.new(2)
  end

  def call
    with_stack(@stack) do
      Machine.new.call
      # If we put more machines here that also do operations on the stack, they will share the same stack.
      # If they run parallel, this will work as expected, all of them will have the same stack still, sharing the data.
      # But this requires other algebraic effects that run stuff in parallel.
    end
    puts "Bye!"
  end
end

class Machine
  include Dry::Effects.State(:stack)

  def call
    while stack.stock > 1
      puts "What do you want to do? (add, remove, see, count)"
      input = gets.chomp
      case input
      when "add" then puts stack.push(Plate.new)
      when "remove" then puts stack.pop
      when "see" then puts stack.peek
      when "count" then puts stack.stock
      else puts "Wrong input, allowed commands: add, remove, see, count"
      end
    end
  end
end

app = App.new.()
