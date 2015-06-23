# coding: utf-8
require_relative '../lib/listas/sessao'
require_relative '../lib/listas/runner'
require_relative '../lib/listas/leitor'
# require 'benchmark'
# require 'shoulda'
# require 'test/unit'
require "minitest/autorun"

describe "teste de cidades" do
  before do
    @max_vizinhos = 10
    @runner = Listas::Runner.new(sem_mensagens = true)
    @runner.sem_threads = false
  end

  @enderecos = {
#    83 =>   ['camelias',  '56', 'porto alegre'],
#    0 =>    ['camelias',  '56', 'novo hamburgo'],
#    1509 => ['anita garibaldi',  '1160', 'porto alegre'],
#    83 => ['alberto bacarat',  '54', 'santos', 'sp'],
    117 =>   ['camelias',  '56', 'canoas']
  }

  @enderecos.each do |total, endereco|

    it "encontrar #{total} assinantes para o endereco #{endereco.join(", ")}" do
      vizinhos = @runner.buscar_vizinhos(@max_vizinhos, *endereco)
      puts vizinhos
      assert_equal(@max_vizinhos, vizinhos.length)
    end
  end

end

=begin
class TesteRunner < Test::Unit::TestCase
  MAX_VIZINHOS = 10
  ENDERECOS = {
#    83 =>   ['camelias',  '56', 'porto alegre'],
#    0 =>    ['camelias',  '56', 'novo hamburgo'],
#    1509 => ['anita garibaldi',  '1160', 'porto alegre'],
#    83 => ['alberto bacarat',  '54', 'santos', 'sp'],
    117 =>   ['camelias',  '56', 'canoas']
  }

  context "main" do
    setup do 
      @runner = Listas::Runner.new(sem_mensagens = true)
      @runner.sem_threads = false
    end
    Benchmark.bm do |x|
      ENDERECOS.each do |total, endereco|
        should "encontrar #{total} assinantes para o endereco #{endereco.join(", ")}" do
          #x.report("sem_thr: #{total}") { assert_equal(total, main(listas.agent,endereco,true)) }
          x.report("#{total}: ") { assert_equal(MAX_VIZINHOS, @runner.buscar_vizinhos(MAX_VIZINHOS, *endereco).length) }
        end
      end
    end
  end
end
=end

# ruby -w teste_runner.rb -n /RunTime/

=begin
  manual
  sem_thr com_thr regs  endereco                            data
  16.6    13.4    92    Camelias 56 porto alegre            20120409 12h15  
  8.7     5.2     92    Camelias 56 porto alegre            20120409 12h16  
  183.4   67.2    2153  anita garibaldi,1160,Porto Alegre   20120409 12h22

  benchmark
  user          system      total        real
  sem_thr: 2153 42.141000   1.250000     43.391000 (181.179687)
  com_thr: 2153 45.421000   2.094000     47.515000 ( 54.086914)
=end
