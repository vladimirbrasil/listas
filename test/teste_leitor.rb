# coding: utf-8
require_relative '../lib/listas/sessao'
require_relative '../lib/listas/leitor'
require_relative '../lib/listas/assinante'
# require 'shoulda'
require 'mechanize'
require "minitest/autorun"
  

describe "teste de cidades" do
  before do
    @cidade_default = 51000
  end

  @cidades = {
    51000 => ["Porto Alegre"],
    51062 => ["Canoas"],
    51182 => ["Novo Hamburgo"],
    51612 => ["Capela de Santana"],
    51183 => ["Osorio"],
    11592 => ["Santos", "sp"],
    51009 => ["Alvorada"]
  }

  @cidades.each do |codigo, local|
    uf = local[1] || "rs"

    it "deve retornar o codigo #{codigo} para cidade #{local}" do
      assert_equal(codigo, Listas::Leitor.new("").buscar_codigo_cidade(local[0], uf))      
    end

    it "deve retornar o codigo #{codigo} para a cidade #{local[0]} maiuscula ou minuscula" do
      assert_equal(codigo, Listas::Leitor.new("").buscar_codigo_cidade(local[0].downcase!, uf))
    end
  end

  it "deve retornar 51000 se não for fornecida a cidade" do
    # assert_equal(51000, Listas::Leitor.new("").buscar_codigo_cidade(""))
    assert_equal(@cidade_default, Listas::Leitor.new("").buscar_codigo_cidade())
  end

  it "deve retornar RunTimeError para cidade inexistente" do
    assert_raises(ArgumentError) { Listas::Leitor.new("").buscar_codigo_cidade('Cidade Inexistente') }
  end

end


describe "assinantes" do
  before do
    @mutex = Mutex.new
    @leitor = Listas::Leitor.new("")
    @leitor.sem_mensagens = true
  end

  (1..5).each do |n|
    File.open( File.join(Dir.pwd,"test/teste_node_#{n}.txt"), 'r') do |f|
    # File.open("teste_node_#{n}.txt", 'r') do |f|
      node = Nokogiri::HTML(f.read)

      it "deve retornar 25 assinantes para a pagina-teste #{n}" do
        assert_equal(25, @leitor.extrair_assinantes(node, @mutex)) if n < 5
        assert_equal(20, @leitor.extrair_assinantes(node, @mutex)) if n == 5
      end

      it "deve esperar 120 assinantes para a pagina-teste #{n}" do
        assert_equal(120, @leitor.extrair_total_assinantes(node))
      end
    end
  end

  File.open( File.join(Dir.pwd,"test/teste_item.txt"), 'r') do |f|
#  File.open("teste_item.txt", 'r') do |f|
    node = Nokogiri::HTML(f.read)

    it "deve extrair assinante Gustavo para o item-teste" do
      assert_match(/gustavo/i, @leitor.extrair_assinante(node).nome)
    end    

  end

end


# ruby -w teste_leitor.rb -n /RunTime/
