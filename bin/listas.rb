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
require_relative '../lib/listas/runner'

get '/endereco' do
  
  max_vizinhos = params[:max_vizinhos].nil? ? 10 : Integer(params[:max_vizinhos])
  rua = params[:rua]
  numero = params[:numero].nil? ? 0 : Integer(params[:numero])
  cidade = params[:cidade].nil? ? "porto alegre" : Integer(params[:cidade])
  uf = params[:uf].nil? ? "rs" : Integer(params[:uf])

  # if ARGV.empty? then File.open("alvo.txt","r") { |file| ARGV = file.gets.split(',') } end
  vizinhos = Listas::Runner.new.buscar_vizinhos(max_vizinhos, rua, numero, cidade, uf)
  
  return "Nenhum assinante encontrado." if vizinhos.empty?
  
  str = ""
  vizinhos.each do |vizinho|
    str = str + "#{vizinho.dist}<br>#{vizinho.nome}<br>#{vizinho.telefone}<br>#{vizinho.endereco}<br><br>"
  end
   
  "#{str}"
  
end