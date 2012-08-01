#!/usr/bin/env ruby
# coding: utf-8
module Listas
  # Esta classe guarda _nome_, _telefone_ e _endereço_ do assinante.
  # Adicionalmente, a classe manipula estes campos e retorna mais informações, como: 
  # * numero_endereco
  # * CEP
  # E ainda recebe um número de endereço de referência e retorna o campo _dist_, contendo a distância entre o assinante e o número de endereço fornecido
  class Assinante
    attr_reader :nome, :telefone, :endereco, :numero_endereco, :dist
    DEFAULT_NUMERO_ENDERECO = 999999
    def initialize(nome,telefone,endereco)
      @nome = nome
      @telefone = telefone
      @endereco = endereco.gsub(/\u00a0/,"") #.delete 194.chr+160.chr #.gsub(/\xA0|\xC2/,"") # elimina non-breaking spaces
      # Distância entre o endereço do assinante e um número de endereço fornecido pelo método Assinante#inserir_distancia!
      @dist = nil
    end

    # Extrai o número do endereço do assinante (integer)
    def extrair_numero_endereco
      resp = /,.*?(\d{1,9})/.match(@endereco)[1] if /,.*?(\d{1,9})/.match(@endereco)
      is_numeric?(resp) ? @numero_endereco = Integer(resp) : @numero_endereco = DEFAULT_NUMERO_ENDERECO
    end

    # Informe um número de endereço em _numero_alvo_ e obtenha a distância entre o endereço do assinante e o número de endereço fornecido em _numero_alvo_. 
    # Serve para calcular quais são os vizinhos mais próximos na rua.
    def inserir_distancia!(numero_alvo)
      @dist = (extrair_numero_endereco - Integer(numero_alvo)).abs 
    end

    # Coloca em um string _nome_, _telefone_, _endereço_ e _dist_ (se houver) do assinante.
    def to_s
      str = "#{@telefone}\n#{@nome}\n#{@endereco.gsub(/\n|\s\s$/,' ')}".gsub(/\t|\s\s$/,' ').gsub(/^\s+|/,'')
      str = "#{@dist}\n" + str if @dist
      "#{str}\n---------\n"
    end

    # Verifica se _nome_, _telefone_ e _endereço_ de dois assinantes são iguais
    def ==(other)
      self.nome == other.nome && self.telefone == other.telefone && self.endereco == other.endereco
    end

  private  
    # Detecta se _obj_ é um número, para uso interno
    def is_numeric?(obj) 
       obj.to_s.match(/\A[+-]?\d+?(\.\d+)?\Z/) == nil ? false : true
    end
  end
end