#!/usr/bin/env ruby
# coding: utf-8
# Exemplo de uso: listas.rb camelias 56 "porto alegre"
# => retorna os assinantes da rua em vizinhos.txt
# => retorna os assinantes mais próximos da rua em vizinhos_proximos.txt
# Exemplo de uso em outro estado (fornecer uf): listas.rb "humberto de campos" 56 santos sp
#--
=begin
  Afazeres
    usar slim e sass ou haml e/ou css | nao funciona!
      http://ididitmyway.heroku.com/past/2011/7/18/current_pages/
    autenticar
      http://ididitmyway.heroku.com/past/2011/2/22/really_simple_authentication_in_sinatra/
=end
#++
require "rubygems"
require "bundler/setup"
require 'thin'
require 'sinatra'
#require 'slim'
#require 'sass'
require 'json'
require_relative '../lib/listas/runner'


  
get '/endereco' do

  max_vizinhos = params[:max_vizinhos].nil? ? 10 : Integer(params[:max_vizinhos])
  rua = params[:rua]
  numero = params[:numero].nil? ? 0 : Integer(params[:numero])
  cidade = params[:cidade].nil? ? "porto alegre" : params[:cidade]
  uf = params[:uf].nil? ? "rs" : params[:uf]

  if params[:rua].nil? then
    status 404
    return "Erro: parametros insuficientes para efetuar a consulta"
  end

  vizinhos = Listas::Runner.new.buscar_vizinhos(max_vizinhos, rua, numero, cidade, uf)
  if vizinhos.is_a? String
    return "Erro: #{vizinhos}" if vizinhos.is_a? String
  else
    status 200
    return "Nenhum assinante encontrado para max_vizinhos='#{max_vizinhos}', rua='#{rua}', numero='#{numero}', cidade='#{cidade}', uf='#{uf}'" if vizinhos.empty?
  
    str = ""
    vizinhos.each do |vizinho|
      str = str + "#{vizinho.dist}<br>#{vizinho.nome}<br><a href='#{vizinho.telefone}'>ver telefone</a><br>#{vizinho.endereco}<br><br>"
    end
    
    "#{str}"
  end
  
end
__END__
@@layout
!!! 5
%html
  %head
    %meta(charset="utf-8")
    %title Teste Titulo
  %body
    = yield
    
    
