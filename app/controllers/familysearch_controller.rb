class FamilysearchController < ApplicationController

  # before_action :authenticate_user!

  require 'uri'

  def auth
    @user = current_user
    @auth = auth_hash
    @user.update_attribute(:keyfs, @auth[:credentials][:token])

    @params = request.env["omniauth.params"]

    if @params["controller"] == "postpic"
      redirect_to "/familysearch/post_pic/#{@params["id"]}/#{@params["filename"]}"
    elsif @params["controller"] == "createdescription"
      redirect_to "/familysearch/create_description/#{@params["id"]}/#{@params["title"]}/#{@params["note"]}"
    end

  end

  def post_pic
    @user = current_user
    @image = Image.find(params[:id])
    @rando = ('a'..'z').to_a.shuffle[0,4].join

    @code = HTTP.auth("Bearer #{@user.keyfs}")
      .headers('Content-Type' => 'image/jpeg', 'Content-Disposition' => "#{params[:filename]}")
      .post("https://sandbox.familysearch.org/platform/memories/memories",
        :form => { :type => 'Photo' },
        :params => { :title => "#{@rando}" },
        :body => "#{HTTP::FormData::File.new("#{@image.data.path(:original)}")}"
      ).code

      if @code == 401
        puts "Got the 401 code, redirecting"
        redirect_to URI("/auth/familysearch?controller=postpic&id=#{params[:id]}&filename=#{params[:filename]}").to_s
      else
        redirect_to root_path
      end

  end

  def create_description
    @user = current_user
    @title = params[:title]
    @note = params[:note]
    @url = "http://0.0.0.0:3000/images/#{params[:id]}"

    @code =  HTTP.auth("Bearer #{@user.keyfs}")
      .headers('Content-Type' => 'application/x-gedcomx-v1+json')
      .post("https://sandbox.familysearch.org/platform/sources/descriptions",
        :body => create_description_json("Here's a new citation, friends!", @url, @title, @note)
      ).code

    if @code == 401
      redirect_to "/auth/familysearch?controller=createdescription&id=#{params[:id]}&title=#{URI.encode_www_form_component(params[:title])}&note=#{URI.encode_www_form_component(params[:note])}"
    else
      redirect_to root_path
    end

  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
