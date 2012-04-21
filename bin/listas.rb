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

get '/endereco/:rua/:numero/:cidade' do
  ARGV = [params[:rua],params[:numero],params[:cidade]]

  # if ARGV.empty? then File.open("alvo.txt","r") { |file| ARGV = file.gets.split(',') } end
  vizinhos = Listas::Runner.new.buscar_vizinhos(ARGV)
  
  return "Nenhum assinante encontrado." if vizinhos.empty?
  
  str = ""
  vizinhos.each do |vizinho|
    str = str + "#{vizinho.dist}<br>#{vizinho.nome}<br>#{vizinho.telefone}<br>#{vizinho.endereco}<br><br>"
  end
   
  "#{str}"
  
end