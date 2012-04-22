#!/usr/bin/env ruby
# coding: utf-8
# Exemplo de uso: listas.rb camelias 56 "porto alegre"
# => retorna os assinantes da rua em vizinhos.txt
# => retorna os assinantes mais próximos da rua em vizinhos_proximos.txt
# Exemplo de uso em outro estado (fornecer uf): listas.rb "humberto de campos" 56 santos sp
require "rubygems"
require "bundler/setup"
require 'thin'
require 'sinatra'
#require 'json'
require_relative '../lib/listas/runner'

get '/endereco' do

  max_vizinhos = params[:max_vizinhos].nil? ? 10 : Integer(params[:max_vizinhos])
  rua = params[:rua]
  numero = params[:numero].nil? ? 0 : Integer(params[:numero])
  cidade = params[:cidade].nil? ? "porto alegre" : params[:cidade]
  uf = params[:uf].nil? ? "rs" : params[:uf]

  vizinhos = Listas::Runner.new.buscar_vizinhos(max_vizinhos, rua, numero, cidade, uf)
  return "Erro: #{vizinhos}" if vizinhos.is_a? String
  return "Nenhum assinante encontrado para max_vizinhos='#{max_vizinhos}', rua='#{rua}', numero='#{numero}', cidade='#{cidade}', uf='#{uf}'" if vizinhos.empty?
  
  
  str = ""
  vizinhos.each do |vizinho|
    str = str + "#{vizinho.dist}<br>#{vizinho.nome}<br>#{vizinho.telefone}<br>#{vizinho.endereco}<br><br>"
  end
  
  "#{str}"
  
end