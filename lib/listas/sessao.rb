#!/usr/bin/env ruby
# coding: utf-8
#-- 
=begin
  Estudar possibilidade de tirar informações de login, senha e url para poder disponibilizar para o público criando uma gem
  Colocar estas informações no programa principal, ou como input do principal.
=end
#++
module Listas
  # Efetua login no site que disponibiliza informações
  class Sessao
    # Mechanize agent
    attr_reader :agent
    # Exibe/oculta mensagens no irb
    attr_accessor :sem_mensagens
    LOGIN_FORM_NAME = "formLoginAreaRestrita"
    URL_LOGIN = "http://www.telelistas.net/templates/form_login.aspx?search=endereco&returnurl=/?search=endereco"
    # Efetua login e devolve o mechanize _agent_ se login foi bem sucedido. 
    # Informa _fail_ e retorna _false_ se login foi mal sucedido
    def initialize(sem_mensagens = false)
      @sem_mensagens = sem_mensagens
      puts "Efetuando login..." unless @sem_mensagens
      require 'mechanize'
      @agent = Mechanize.new
      @agent.user_agent_alias = 'Windows Mozilla'
      @agent.follow_meta_refresh = true
      @agent.agent.http.verify_mode = OpenSSL::SSL::VERIFY_NONE
      @agent.get(URL_LOGIN)
      loginform = @agent.page.form_with(:name => LOGIN_FORM_NAME)
      if loginform
        loginform.email  = 'vlads@globo.com'
        loginform.senha  = 'cocacola'
        page2 = loginform.submit(loginform.buttons[0])	
        fail "Login mal-sucedido (usuario: '#{loginform.email}')" if page2.body.match(loginform.email)
        page2.body.to_s
      else
        fail "A pagina de login '#{LOGIN_FORM_NAME}' nao foi encontrada\nO site pode estar fora do ar"
        false
      end
    end
  end
end