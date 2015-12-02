class FamilysearchController < ApplicationController

  # before_action :authenticate_user!

  def auth
    @user = current_user
    @hash = auth_hash
    @user.update_attribute(:keyfs, @hash[:credentials][:token])
    redirect_to root_path
  end

  def post_pic
    @user = current_user
    @image = Image.find(params[:id])
    @rando = ('a'..'z').to_a.shuffle[0,4].join
    HTTP.auth("Bearer #{@user.keyfs}")
      .headers('Content-Type' => 'image/jpeg', 'Content-Disposition' => "#{params[:filename]}")
      .post("https://sandbox.familysearch.org/platform/memories/memories",
        :form => { :type => 'Photo' },
        :params => { :title => "#{@rando}" },
        :body => "#{HTTP::FormData::File.new("#{@image.data.path(:original)}")}" )
    redirect_to root_path
  end

  def create_description
    @user = current_user
    @title = params[:title]
    @note = params[:note]
    @url = "http://0.0.0.0:3000/images/#{params[:id]}"

    puts HTTP.auth("Bearer #{@user.keyfs}")
      .headers('Content-Type' => 'application/x-gedcomx-v1+json')
      .post("https://sandbox.familysearch.org/platform/sources/descriptions",
        :body => create_description_json("Here's a new citation, friends!", @url, @title, @note)
        )

    redirect_to root_path

  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
