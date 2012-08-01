# coding: utf-8
require 'test/unit'
require 'shoulda'
require_relative '../lib/listas/assinante.rb'
class TesteAssinante < Test::Unit::TestCase
  ENDERECOS_SEM_NUMERO = [
    "",
    "rua",
    "rua cidade",
    "rua, cidade",
    "rua 123 cidade"
  ]
  ENDERECOS_COM_NUMERO = [
    "rua, 123",
    "rua, 123 cidade cep 12345-123",
    "rua, bl 123",
    "rua, bl 123, cidade",
    "rua, bl 123, 456 cidade",
    "rua, bl 123 cidade",
    "rua, bl 123 cidade cidade",
    "rua, bl 123 apto 321 cidade",
    "rua, bl 123/321 cidade"
  ]
  context "informando enderecos sem numero" do
    should "retornar default" do
      ENDERECOS_SEM_NUMERO.each do |endereco|
        assinante = Listas::Assinante.new("","",endereco)
        assert_equal(Listas::Assinante::DEFAULT_NUMERO_ENDERECO, assinante.extrair_numero_endereco)
      end
    end
  end
  context "informando enderecos com numero" do
    should "retornar o numero do endereco" do
      ENDERECOS_COM_NUMERO.each do |endereco|
        assinante = Listas::Assinante.new("","",endereco)
        assert_equal(123, assinante.extrair_numero_endereco)
      end
    end
  end
end