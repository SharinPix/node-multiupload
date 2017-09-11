fs = require 'fs'
async = require 'async'
sharinpix = require 'sharinpix'

infilename = 'Images.csv' # CSV file

contents = fs.readFileSync(infilename).toString()
lines = contents.split('\n')
uploads = []

lines.forEach((line)->
  if (line != null && line != '')
    line_parts = line.split(',')
    file_path = line_parts[0] # Valid image path
    album_id = line_parts[1]  # Valid Salesforce ID (18-character)

    if (file_path != null && file_path != undefined && album_id != null && album_id != undefined)
      uploads.push(
        (callback)->
          sharinpix.upload(file_path, album_id)
            .then((image)->
              console.log file_path + ' uploaded to ' + image.album_id
              callback(null, image)
            )
            .catch((err)->
              console.log(file_path + ' upload failed.')
              callback(err)
            )
      )
)

all_done = (images)->
  console.log('*** All done ! ***')

async.parallelLimit(uploads, 2, all_done)
