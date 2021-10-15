local LrDialogs = import 'LrDialogs'

local PicfairAPI = require 'PicfairAPI'

local exportServiceProvider = {}
local logger = import 'LrLogger'( 'PicfairLightroom' )
logger:enable( "print" )

exportServiceProvider.hideSections = { 'exportLocation' }
exportServiceProvider.allowFileFormats = { 'JPEG', 'JPG' }
exportServiceProvider.hidePrintResolution = true
exportServiceProvider.canExportVideo = false

function exportServiceProvider.processRenderedPhotos( functionContext, exportContext )

  local exportSession = exportContext.exportSession

  for i, rendition in exportSession:renditions() do

    local tags = rendition.photo:getFormattedMetadata('keywordTagsForExport')

    local tagsTable

    if tags then

      tagsTable = {}

      local keywordIter = string.gfind( tags, "[^,]+" )

      for keyword in keywordIter do
      
        if string.sub( keyword, 1, 1 ) == ' ' then
          keyword = string.sub( keyword, 2, -1 )
        end
        
        if string.find( keyword, ' ' ) ~= nil then
          keyword = '"' .. keyword .. '"'
        end
        
        tagsTable[ #tagsTable + 1 ] = keyword

      end
    
    end

    local success, pathOrMessage = rendition:waitForRender() -- Do something with the rendered photo.

    local picData = {
      title = rendition.photo:getFormattedMetadata('title'),
      caption = rendition.photo:getFormattedMetadata('caption'),
      tags = table.concat( tagsTable, ',' ),
      filePath = pathOrMessage
    }

    if success then
      -- when success is true, pathOrMessage contains path of rendered file 
      local uploadStatus, uploadMessage = PicfairAPI.uploadPic( picData ) 
        if not uploadStatus then
          rendition:uploadFailed( uploadMessage ) 
        end
      else
      -- Report waitForRender failure 
      rendition:uploadFailed( pathOrMessage ) 
    end
  end
    
end

return exportServiceProvider
