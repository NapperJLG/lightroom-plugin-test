local logger = import 'LrLogger'( 'PicfairLightroom' )
local LrErrors = import 'LrErrors'
local LrHttp = import 'LrHttp'
local LrPathUtils = import 'LrPathUtils'
logger:enable( "print" )

local PicfairAPI = {}

local postURL = 'http://localhost:3000/lightroom_upload'

function PicfairAPI.uploadPic(data)

  local contentData = {
    filePath = data.filePath,
    fileName = LrPathUtils.leafName( data.filePath ),
    value = data.filePath,
    contentType = 'application/octet-stream'
  }

  local mimeChunks = {
    contentData
  }

  local result, hdrs = LrHttp.postMultipart(postURL, mimeChunks)
  
end

return PicfairAPI
