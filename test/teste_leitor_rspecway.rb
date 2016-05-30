# coding: utf-8

=begin 

ruby -w test/teste_leitor.rb -n /RunTime/

=end

require_relative '../lib/listas/sessao'
require_relative '../lib/listas/leitor'
require_relative '../lib/listas/assinante'
require 'shoulda'
require 'mechanize'
require "minitest/autorun"
  
class MyTests < MiniTest::Test
    @cidades = {
      51000 => ["Porto Alegre"],
      51062 => ["Canoas"],
      51182 => ["Novo Hamburgo"],
      51612 => ["Capela de Santana"],
      51183 => ["Osorio"],
      11592 => ["Santos", "sp"],
      51009 => ["Alvorada"]
    }
  @cidade_default = 51000
  @cidades.each do |codigo, local|
    uf = "rs"
    uf = local[1] unless local[1].nil?

    define_method("test_cidades_retornar_o_codigo_#{codigo}_para_cidade_#{local}") do
      assert_equal(codigo, Listas::Leitor.new("").buscar_codigo_cidade(local[0], uf))
    end
  end
end

=begin
describe "my tests" do
  before do
    @cidades = {
      51000 => ["Porto Alegre"],
      51062 => ["Canoas"],
      51182 => ["Novo Hamburgo"],
      51612 => ["Capela de Santana"],
      51183 => ["Osorio"],
      11592 => ["Santos", "sp"],
      51009 => ["Alvorada"]
    }
  end
  @cidade_default = 51000
  @cidades.each do |codigo, local|
    uf = "rs"
    uf = local[1] unless local[1].nil?


    define_method("test_cidades_retornar_o_codigo_#{codigo}_para_cidade_#{local}") do
      assert_equal(codigo, Listas::Leitor.new("").buscar_codigo_cidade(local[0], uf))
    end

  end
end=end


=begin
describe "my tests" do
  before do
    @cidades = {
      51000 => ["Porto Alegre"],
      51062 => ["Canoas"],
      51182 => ["Novo Hamburgo"],
      51612 => ["Capela de Santana"],
      51183 => ["Osorio"],
      11592 => ["Santos", "sp"],
      51009 => ["Alvorada"]
    }
  end
  @cidade_default = 51000
  @cidades.each do |codigo, local|
    uf = "rs"
    uf = local[1] unless local[1].nil?

    it "#{phone_number} has 7 characters" do
      assert_equal(7, phone_number.length)
    end

    it "#{phone_number} starts with 1" do
      assert_equal('1', phone_number[0])
    end
  end
end=end


=begin
    CIDADES.each do |codigo, local|
      uf = "rs"
      uf = local[1] unless local[1].nil?
      should "retornar o codigo #{codigo} para a cidade #{local[0]} maiuscula ou minuscula" do
        assert_equal(codigo, Listas::Leitor.new("").buscar_codigo_cidade(local[0].downcase!, uf))
      end
    end
    should "retornar 51000 se não for fornecida a cidade" do
      assert_equal(CIDADE_DEFAULT, Listas::Leitor.new("").buscar_codigo_cidade(""))
      assert_equal(CIDADE_DEFAULT, Listas::Leitor.new("").buscar_codigo_cidade())
    end
    should "retornar RunTimeError para cidade inexistente" do
      assert_raises { Listas::Leitor.new("").buscar_codigo_cidade('Cidade Inexistente') }
    end
  end
  context "assinantes" do
    setup do
      @mutex = Mutex.new
      @leitor = Listas::Leitor.new("")
      @leitor.sem_mensagens = true
    end
    (1..5).each do |n|
      File.open("teste_node_#{n}.txt", 'r') do |f|
        node = Nokogiri::HTML(f.read)
        should "retornar 25 assinantes para a pagina-teste #{n}" do
          assert_equal(25, @leitor.extrair_assinantes(node, @mutex)) if n < 5
          assert_equal(20, @leitor.extrair_assinantes(node, @mutex)) if n == 5
        end
        should "esperar 120 assinantes para a pagina-teste #{n}" do
          assert_equal(120, @leitor.extrair_total_assinantes(node))
        end
      end
    end
#    File.open("C:/Users/Vla/Documents/Ruby/listas/test/teste_item.txt", 'r') do |f|
    File.open("teste_item.txt", 'r') do |f|
      node = Nokogiri::HTML(f.read)
      should "extrair assinante Gustavo para o item-teste" do
        assert_match(/gustavo/i, @leitor.extrair_assinante(node).nome)
      end
    end
  end
=end



