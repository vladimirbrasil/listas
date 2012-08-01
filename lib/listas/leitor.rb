#!/usr/bin/env ruby
# coding: utf-8
require_relative 'assinante'
require 'nokogiri'
require 'yaml'

module Listas
  #-- 
  # Estudar possibilidade de tirar informações de url para poder disponibilizar para o público criando uma gem
  # Colocar estas informações no programa principal, ou como input do principal.
  #++
  # Lê informações de _nome_, _telefone_ e _endereço_ em uma página web que disponibiliza estas informações.
  class Leitor
    include Enumerable
    # Agente mechanize a ser utilizado nas buscas. Fornecido em initialize.
    attr_reader :agent
    # Vetor contendo os assinantes encontrados (objetos da classe Assinante)
    attr_reader :assinantes
#--
=begin
    # Total de assinantes esperados informado pela própria página web
    attr_reader :total_assinantes_esperados
    # Total de assinantes efetivamente encontrados após contagem dos vetores de _assinantes_ e de _assinantes_duplicados_
    attr_reader :total_assinantes_encontrados
=end
#++
    # Exibe/oculta mensagens no irb
    attr_accessor :sem_mensagens
    # Permite/não permite o uso de threads. Pode facilitar a utilização no Heroku ou EngineYard.
    attr_accessor :sem_threads
    # Número máximo de assinantes que cabem em cada página web que disponibiliza as informações
    MAX_ASS_POR_PAGINA = 25
    # Css que rastreia os assinantes na página web que disponibiliza as informações
    CSS_ASSINANTES = "div#Content_Regs table tr td table"
    # Css que rastreia o total de assinantes encontrados na página web que disponibiliza as informações
    CSS_TOTAL_ASSINANTES = "div#Content_LocaGeo table tr td h1 span.texto_caminho_registro"
    # Css utilizada para rastrear o _nome_ do assinante dentre os assinantes disponibilizados
    CSS_STR_LEFT = "td[align='left']"
    # Css utilizada para rastrear o _telefone_ do assinante dentre os assinantes disponibilizados
    CSS_STR_RIGHT = "td[align='right']"
    # Css utilizada para rastrear _nome_ e _telefone_ do assinante dentre os assinantes disponibilizados
    CSS_STR_RESULTADO = "td[class='text_resultado_ib']"
    # Css utilizada para rastrear o _endereço_ do assinante dentre os assinantes disponibilizados
    CSS_STR_ENDERECO = "td[class='text_endereco_ib']"
    # Hash contendo partes que montam as urls utilizadas para buscar os assinantes na página web que disponibiliza as informações
    URLS = {
      inicio: "http://www.telelistas.net/templates/resultado_busca.aspx?orgm=8",
      cod_localidade: "&cod_localidade=",
      rua: "&endereco=", 
      numero: "&numero=",
      uf: "&uf_busca=",
      localidade_select: "&end_localidade_select=",
      fim: "&x=0&y=0"
    }
    # Cria o objeto que irá buscar os assinantes. 
    # O agente mechanize deve ser fornecido já logado na página web se for necessário efetuar login prévio.
    def initialize(agent)
      @agent = agent
      @assinantes = []
      @assinantes_duplicados = []
      @sem_threads ||= false
      @sem_mensagens ||= false
    end
    # Procura todos os assinantes da rua, utilizando o endereço informado.
    #--
    # _numero_ é utilizado no método Leitor#filtrar_vizinhos
    # Sugestão: Eliminar necessidade de informar o número ou utlizar neste método.
    #++
    # Fornecer _rua_ omitindo o termo 'rua', 'av', etc.
    def buscar_por_endereco(rua = "camelias",numero = "",cidade = "Porto Alegre",uf = "rs")
      @numero_alvo = numero
      url = montar_url_endereco(rua,"",cidade,uf) #omitindo o número, busca a rua toda
      buscar_assinantes(url)
    end
    # Retorna um vetor conendo os _num_vizinhos_ vizinhos mais próximos do número informado utilizando o método Leitor#buscar_por_endereco.
    # Este método também ordena todo o vetor de assinantes pelo número de endereço.
    def filtrar_vizinhos(num_vizinhos)
      vizinhos = []
      @assinantes.each { |vizinho| vizinho.inserir_distancia!(@numero_alvo) }
      @assinantes = @assinantes.sort_by { |vizinho| vizinho.numero_endereco }
      vizinhos = @assinantes.sort_by { |vizinho| vizinho.dist }.first(num_vizinhos)
    end
    def each
      @assinantes.each { |assinante| yield assinante }
    end
    def to_s
      @assinantes.each { |assinante| assinante.to_s }
    end
#  private
    # Gerencia a busca pelos assinantes, abrindo cada página contendo as respostas.
    # * Abre um total de páginas igual a _total_assinantes_esperados_/_MAX_ASS_POR_PAGINA_ 
    # * Usa/não usa threads de acordo com _sem_threads_ (por default, usa threads)
    # * A primeira página é aberta separadamente, para obter _total_assinantes_esperados_ e calcular quantas páginas resta abrir
    # * Demais páginas são abertas simultaneamente utilizando threads (default), ou individualmente sem usar threads
    # Cada página é aberta usando Leitor#abrir_pagina
    def buscar_assinantes(url) 
      threads = []
      @mutex = Mutex.new
      abrir_pagina(url, 1)
      if @total_assinantes_esperados then total_paginas = 1 + @total_assinantes_esperados/MAX_ASS_POR_PAGINA
      else fail "Não foi encontrado o numero total de assinantes. Revisar seletor css: \n'#{CSS_TOTAL_ASSINANTES}'\n" end
      (2..total_paginas).each do |pagina|
        if @sem_threads
          abrir_pagina(url, pagina)
        else
          threads << Thread.new(pagina) do |pag_thread| 
            Thread.current["minha_pagina"] = pag_thread
            abrir_pagina(url, pag_thread)
          end
        end
      end
      threads.each { |thr| thr.join }
      @total_assinantes_encontrados = @assinantes.length + @assinantes_duplicados.length
=begin
      # Colocar isto como warning, e mesmo assim devolver a resposta. Por enquanto, desabilitar
      if @total_assinantes_encontrados != @total_assinantes_esperados
        fail "#{@total_assinantes_encontrados} assinantes encontrados porem eram esperados #{@total_assinantes_esperados} assinantes"
      end
=end      
      @total_assinantes_encontrados
    end

    # Abre cada página solicitada pelo método Leitor#buscar_assinantes, e 
    # * Adiciona ao vetor de _assinantes_ os assinantes encontrados na página (no máximo _MAX_ASS_POR_PAGINA_).
    # * Ignora os assinantes duplicados, separando-os no vetor de _assinantes_duplicados_. 
    # * _assinantes_duplicados_ será utilizado para contar o total de assinantes encontrados e guardar em _total_assinantes_encontrados_. 
    # * _total_assinantes_encontrados_ permitirá checar se todos os assinantes foram encontrados satisfazendo a condição _total_assinantes_encontrados_ == _total_assinantes_esperados_
    # Mutex garante que múltiplas threads atualizem corretamente os vetores _assinantes_  e _assinantes_duplicados_
    #--
    # Criar váriavel @url para conter a url montada no método Leitor#buscar_por_, sem precisar passar a url montada em cadeia por todas as funções?
    #++
    def abrir_pagina(url, pagina)
      puts "Abrindo pagina #{pagina}...\n" unless @sem_mensagens
      page = @agent.get("#{url}&pagina=#{pagina}")
      node = Nokogiri::HTML(page.body)
      @total_assinantes_esperados = extrair_total_assinantes(node) unless @total_assinantes_esperados ||= nil
      extrair_assinantes(node, @mutex)
    end

    def extrair_assinantes(node, mutex_local)
      node_assinantes = extrair_tabela_assinantes(node)
      node_assinantes.each do |item| 
        if novo_assinante = extrair_assinante(item)
          puts novo_assinante.to_s unless @sem_mensagens
          mutex_local.synchronize do
            @assinantes_duplicados ||= []
            if @assinantes.any? {|ass| ass == novo_assinante} then @assinantes_duplicados << novo_assinante
            else @assinantes << novo_assinante end
          end
        end
      end
      @assinantes.length + @assinantes_duplicados.length
    end

    
    # Extrai o nó contendo os assinantes em cada página web
    def extrair_tabela_assinantes(node)
      extrair_node(node, CSS_ASSINANTES)
    end

    # Extrai o total de assinantes encontrados na consulta à internet
    def extrair_total_assinantes(node)
      res = extrair_node(node, CSS_TOTAL_ASSINANTES)
      if res.to_s.match(/\((\d{1,10})\)/) then Integer(res.to_s.match(/\((\d{1,10})\)/)[1])
      else 0
      end
    end
    
    # Extrai o nó de acordo com o css fornecido 
    # Algumas paginas respondem ao css iniciando em "div#*", outras respondem ao css iniciando em "div#ctl00_*"
    # _extrair_node_ verifica qual css está sendo utilizado e retorna a página correta
    def extrair_node(node, css_str)
      #algumas paginas respondem ao css iniciando em "div#*", outras respondem ao css iniciando em "div#ctl00_*"
      res = node.css(css_str) unless node.css(css_str).empty?
      res ||= node.css(css_str.gsub(/div#/,'div#ctl00_'))
    end

    # Extrai o assinante utilizando cada item do nó contendo todos os asinantes da página.
    # Para ser utilizada em <tt>node.each { |item| extrair_assinante(item) }</tt>
    # Retorna o objeto da classe _Assinante_
    def extrair_assinante(item)
      if not item.css(CSS_STR_LEFT).css(CSS_STR_RESULTADO).text.gsub(/^\s+|\s+$/,'').empty?
        nome = item.css(CSS_STR_LEFT).css(CSS_STR_RESULTADO).text.gsub(/^\s+|\s+$/,'') 
        telefone = item.css(CSS_STR_RIGHT).css(CSS_STR_RESULTADO).css('a')[0]['href'] unless item.css(CSS_STR_RIGHT).css(CSS_STR_RESULTADO).css('a').empty?
        endereco = item.css(CSS_STR_ENDERECO).text.gsub(/^\s+|\s+$/,'')
        Listas::Assinante.new(nome, telefone, endereco)
      else
        false
      end
      
    end

    # Monta a url de busca por endereço utlizada no método Leitor#busca_por_endereco. 
    # Fornece ao método genérico Leitor#montar_url uma hash contendo as partes de url necessárias para efetuar uma busca por endereço. 
    def montar_url_endereco(rua = "camelias",numero = "",cidade = "Porto Alegre",uf = "rs")
      #endereço =>  http://www.telelistas.net/templates/resultado_busca.aspx?orgm=8&cod_localidade=51000&endereco=camelias&numero=&uf_busca=RS&end_localidade_select=51000&x=0&y=0
      cod_localidade = buscar_codigo_cidade(cidade, uf)
      montar_url(
        :endereco, 
        cod_localidade: cod_localidade, 
        rua: rua, 
        numero: numero, 
        uf: uf, 
        localidade_select: cod_localidade
      )
    end

    # Monta uma string url recebendo o símbolo _tipo_ e uma hash de parâmetros. Esta hash de parâmetros fornecida é utilizada na hash _URL_ para montar a url, que é retornada como string.
    #--
    #endereço =>  http://www.telelistas.net/templates/resultado_busca.aspx?orgm=8&cod_localidade=51000&endereco=camelias&numero=&uf_busca=RS&end_localidade_select=51000&x=0&y=0
    #pessoa =>    http://www.telelistas.net/templates/resultado_busca.aspx?orgm=8&cod_localidade=51000&cod_bairro=&residencial=1&nome=vladimir+bergier&uf_busca=rs&pes_localidade_select=51000&pes_bairro_select=&x=0&y=0
    #++
    def montar_url(tipo, params)
      #if tipo == :endereco
      url =   "#{URLS[:inicio]}"
      params.each { |key, value| url +=  "#{URLS[key]}#{value}" }
      url +=  "#{URLS[:fim]}"
      #end
      url
    end
    
    # Busca o código da cidade fornecida. Possui alguns códigos armazenados, os demais códigos são consultados na web via ajax.
    #--
    # Não funciona em cidades com acentuação!
    # <?xml version="1.0"?>
    # <option value="51479">Almirante Tamandar&#x9824;o Sul</option>
    # <option value="51001">Acegu</option>
    # &#x67;ua Branca
    # S&#x3BE0;Valentim do Sul
    # Cap&#x3BE0;da Canoa
    # Arco-&#x372;is
    # Balne&#x1CA9;o Ponte do Arame
    #++
    def buscar_codigo_cidade(cidade = "Porto Alegre", uf = "rs")
      cidade = cidade.split.each { |x| x.capitalize! unless x.length <= 2}.join(" ")
      hash_cidades = {}
      if File.exists?("cidades.yml") # only works with Heroku
        File.open("cidades.yml") { |f| hash_cidades = YAML.load(f) }
      elsif File.exists?("../cidades.yml") # only works with Sinatra local host
        File.open("../cidades.yml") { |f| hash_cidades = YAML.load(f) }
      else
        fail "nao encontrou o arquivo cidades.yml"
      end
      return Integer(hash_cidades[cidade]) if hash_cidades.has_key?(cidade)

      local_agent = Mechanize.new
      page_cidades = local_agent.post('http://www.telelistas.net/AjaxHandler.ashx', {'state'=>uf, 'style'=>'busca_interna', 'selectedcidade'=>'Porto Alegre', 'clientId'=>'end_localidade_select', 'method'=>'GetSearchCitiesNamed'})
      xml_doc = Nokogiri::XML(page_cidades.body)
#--
=begin
      puts "encoding-- #{xml_doc.encoding}"
      File.open("C:/Users/Vla/Documents/Ruby/listas/test/xml_cidades.txt", 'w:ascii-8bit') do |f| 
      puts "extern encod-- #{f.external_encoding}" 
      f.puts xml_doc
      end
=end
#++
      hash_cidades = {}
      xml_doc.xpath("//option").each { |item|	hash_cidades[item.text] = item["value"] }
      if hash_cidades.has_key?(cidade) then Integer(hash_cidades[cidade])
      else fail "cidade '#{cidade}' nao foi encontrada"
      end
    end		
  end
end