#!/usr/bin/env ruby

require "./solver.rb"

def test()
  hoge = Block.new(3)
  p hoge.value
  p hoge.cands
  fuga = Block.new(0)
  p fuga.value
  p fuga.cands
  fuga.setValue(4)
  p fuga.value
  p fuga.cands

  # -- @DEBUG : shoud raise exception
  #fuga.setValue(5)
  #p fuga.value
  #p fuga.cands

  stage = Stage.new("./dataset/question001.txt")
  print stage
end

if __FILE__ == $0
  stage = Stage.new(ARGV[0])
  puts "Question is :" if $DEBUG
  puts stage        if $DEBUG

  solved = stage.solve
  puts (solved ? "Answer is :" : "Not solved ... :") if $DEBUG
  print stage
end
