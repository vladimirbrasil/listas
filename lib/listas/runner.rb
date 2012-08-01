#!/usr/bin/env ruby
# coding: utf-8
#--
=begin
  C:/Users/Vla/Documents/Ruby/listas/test
  Afazeres
    Resolver UTF-8
    Gravar cookie e não precisar fazer login (executa mais rápido)
    Capturar imagem (e ocr?)
    Colocar online (Sinatra ou Rails, Heroku ou Google A.Engine)
=end
#++

module Listas
  # Efetua login na página web que disponibiliza as informações
  require_relative 'sessao'
  # Busca assinantes na página web que disponibiliza as informações
  require_relative 'leitor'
  # Executa o programa que busca assinantes na página web que disponibiliza as informações
  class Runner
    # dados de entrada para efetuar a busca
    attr_reader :argv
    # Exibe/oculta mensagens no irb
    attr_accessor :sem_mensagens
    # Permite/não permite o uso de threads. Pode facilitar a utilização no Heroku ou EngineYard.
    attr_accessor :sem_threads
    # Carrega os dados de entrada do arquivo bin/alvo.txt
    def self.from_file(file_name = "../bin/alvo.txt")
      
    end
    # Efetua login na página web que disponibiliza as informações
    def initialize(sem_mensagens = false)
      begin
        @sem_threads = false
        @sem_mensagens = sem_mensagens
        sessao_listas = Listas::Sessao.new(@sem_mensagens)
        if sessao_listas
          @leitor = Listas::Leitor.new(sessao_listas.agent)
          @leitor.sem_mensagens = sem_mensagens
        end
      rescue
        raise
      ensure
      end
    end
    # Busca vizinhos do endereço fornecido contendo _rua_, _numero_ e _cidade_ (_uf_ = 'rs')
#--
=begin
    Permitir informar uf (diferente do default 'rs'). Basta ler uf em argv_local, pois funções internas repassam uf lida.
    Além de trazer vizinhos mais próximos, permitir trazer: 'mercadinhos', 'padarias' e afins, se houver. Estes tipos de comércio podem conhecer o alvo.
=end
#++
    def buscar_vizinhos(max_vizinhos, rua, numero = 0, cidade = "porto alegre", uf = "rs")
#      puts "captar os argumentos max_vizinhos='#{max_vizinhos}', rua='#{rua}', numero='#{numero}', cidade='#{cidade}', uf='#{uf}' para o endereco passado como argumento"
      begin
        @leitor.buscar_por_endereco(rua,numero,cidade,uf)
        puts "#{@leitor.assinantes.length} assinantes diferentes encontrados." unless @sem_mensagens
        vizinhos = []
        vizinhos = @leitor.filtrar_vizinhos(Integer(max_vizinhos))
        #File.open("../bin/vizinhos.txt", 'w'){|f| f.puts @leitor.assinantes}
        #File.open("../bin/vizinhos_mais_proximos.txt", 'w'){|f| f.puts vizinhos}
        #return @leitor.assinantes.length
        return vizinhos
      rescue
        return "#{$!}"
      ensure
      end
    end
  end
end