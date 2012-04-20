# coding: utf-8
require_relative '../lib/listas/sessao'
require 'benchmark'
require 'shoulda'
require 'test/unit'

class TesteSessao < Test::Unit::TestCase
  context "login" do
    Benchmark.bm do |x|
      should "efetuar login" do
        #x.report("sem_thr: #{total}") { assert_equal(total, main(listas.agent,endereco,true)) }
        x.report { assert_no_match(/vlads@globo.com/, Listas::Sessao.new(true).to_s) }
      end
    end
  end
end
