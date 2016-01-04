class DropboxController < ApplicationController
  def authenticate

    session[:image_id_2upload] = params[:id]

    if session[:final_access_token] && session[:final_access_secret]
      redirect_to upload2db_path
    else
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      request_token = consumer.get_request_token
      # Store the token and secret so after redirecting we have the same request token
      session[:token] = request_token.token
      session[:token_secret] = request_token.secret
      redirect_to request_token.authorize_url(:oauth_callback => "http://localhost:3000/dropbox/upload/")
    end
  end

  def upload

    unless session[:final_access_token] && session[:final_access_secret]
      consumer = Dropbox::API::OAuth.consumer(:authorize)
      hash = { oauth_token: session[:token], oauth_token_secret: session[:token_secret]}
      request_token  = OAuth::RequestToken.from_hash(consumer, hash)
      result = request_token.get_access_token
      session[:final_access_token] = result.token
      session[:final_access_secret] = result.secret
    end
    client = Dropbox::API::Client.new :token => session[:final_access_token], :secret => session[:final_access_secret]
    @image = Image.find(session[:image_id_2upload])
    puts client.account.inspect
    #puts @image.data.original_filename
    #puts @image.data.path(:original)
    client.chunked_upload @image.data.original_filename, File.open(@image.data.path(:original))


    redirect_to root_path

  end
end
