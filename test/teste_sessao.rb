# coding: utf-8

=begin 

ruby -w test/teste_sessao.rb -n /RunTime/
ruby test/teste_sessao.rb

=end

require_relative '../lib/listas/sessao'
# require 'benchmark'
# require 'shoulda'
require "minitest/autorun"

describe "login" do
  
  it "deve efetuar login" do
    refute_match(/vlads@globo.com/, Listas::Sessao.new(true).to_s)  
    # email aparece quando login não é efetuado. 
    # email não aparece nos casos em o login é bem sucedido. 
  end
end

=begin
class TesteSessao < Test::Unit::TestCase
  context "login" do
    # Benchmark.bm do |x|
      should "efetuar login" do
        #x.report("sem_thr: #{total}") { assert_equal(total, main(listas.agent,endereco,true)) }
        x.report { assert_no_match(/vlads@globo.com/, Listas::Sessao.new(true).to_s) }
      end
    # end
  end
end
=end
