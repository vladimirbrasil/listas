# coding: utf-8
require_relative '../lib/listas/sessao'
require_relative '../lib/listas/leitor'
require_relative '../lib/listas/assinante'
require 'shoulda'
require 'test/unit'
require 'mechanize'

class TesteLeitor < Test::Unit::TestCase
  CIDADES = {
    # 51000 => ["Porto Alegre"],
    # 51062 => ["Canoas"],
    # 51182 => ["Novo Hamburgo"],
    # 51612 => ["Capela de Santana"],
    # 51612 => ["Osório"]
    # 11592 => ["Santos", "sp"]
    51009 => ["Alvorada"],
  }

  context "cidades" do
    CIDADE_DEFAULT = 51000
    CIDADES.each do |codigo, local|
      uf = "rs"
      uf = local[1] unless local[1].nil?
      should "retornar o codigo #{codigo} para a cidade #{local[0]}" do
        assert_equal(codigo, Listas::Leitor.new("").buscar_codigo_cidade(local[0], uf))
      end
    end
    # should "retornar 51000 se não for fornecida a cidade" do
      # assert_equal(CIDADE_DEFAULT, Listas::Leitor.new("").buscar_codigo_cidade(""))
      # assert_equal(CIDADE_DEFAULT, Listas::Leitor.new("").buscar_codigo_cidade())
    # end
    # should "retornar RunTimeError para cidade inexistente" do
      # assert_raises { Listas::Leitor.new("").buscar_codigo_cidade('Cidade Inexistente') }
    # end
  end
end

# ruby -w teste_leitor.rb -n /RunTime/
