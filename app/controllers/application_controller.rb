class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  def create_description_json(citation, url, title, note)
    return "{\"sourceDescriptions\":[{\"id\" : \"\",
\"citations\" : [ {
  \"value\" : \"#{citation}\"
} ],
\"about\" : \"#{url}\",
\"titles\" : [ {
  \"value\" : \"#{title}\"
} ],
\"notes\" : [ {
  \"text\" : \"#{note}\"
} ],
\"attribution\" : {
  \"contributor\" : {
    \"resource\" : \"\",
    \"resourceId\" : \"\"
  },
  \"modified\" : 1448037877207,
  \"changeMessage\" : \"\"
}
} ]
}"
  end  

end
