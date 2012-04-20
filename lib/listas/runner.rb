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
    def buscar_vizinhos(argv_local = false)
      begin
        if argv_local then @rua, @numero, @cidade, @uf = argv_local
        else @rua, @numero, @cidade, @uf = @argv end
        @uf = "rs" if @uf.nil? 
        @leitor.buscar_por_endereco(@rua,@numero,@cidade,@uf)
      rescue
        raise
      ensure
        puts "#{@leitor.assinantes.length} assinantes diferentes encontrados." unless @sem_mensagens
        vizinhos = []
        vizinhos = @leitor.filtrar_vizinhos(10)
        #File.open("../bin/vizinhos.txt", 'w'){|f| f.puts @leitor.assinantes}
        #File.open("../bin/vizinhos_mais_proximos.txt", 'w'){|f| f.puts vizinhos}
        #return @leitor.assinantes.length
        return vizinhos
      end
    end
  end
end