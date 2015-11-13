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
    puts "title is #{@rando}"
    puts "token is #{@user.keyfs}"
    puts "filename is #{params[:filename]}"
    puts "URL is #{@image.data.path}"
    puts HTTP.auth("Bearer #{@user.keyfs}")
      .headers('Content-Type' => 'image/jpeg', 'Content-Disposition' => "#{params[:filename]}")
      .post("https://sandbox.familysearch.org/platform/memories/memories",
        :form => { :type => 'Photo' },
        :params => { :title => "#{@rando}" },
        :body => "#{HTTP::FormData::File.new("#{@image.data.path(:original)}")}" ).to_s
    redirect_to root_path
  end

  protected

  def auth_hash
    request.env['omniauth.auth']
  end

end
