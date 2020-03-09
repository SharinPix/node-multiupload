fs = require "fs"
async = require "async"
sharinpix = require "sharinpix"
os = require "os"; EOL = os.EOL

infilename = "Images.csv" # CSV file

if process.argv[2] && process.argv[2].startsWith("sharinpix://")
  sharinpix.configure process.argv[2]
else
  if process.env.SHARINPIX_URL == null || process.env.SHARINPIX_URL == undefined
    console.log "SharinPix secret (SHARINPIX_URL env variable) has not been configured."
    return

unless fs.existsSync(infilename)
  console.log "No input file (" + infilename + ") found in script's root folder."
  return

contents = fs.readFileSync(infilename).toString()
lines = contents.split /\r?\n/
uploads = []

wstream = fs.createWriteStream "log-" + new Date().toJSON().replace(/[^a-z0-9-]/gi, "_") + ".txt"

logthis = (msg)->
  console.log msg
  wstream.write(msg + EOL)

lines.forEach((line)->
  if (line != null && line != "")
    line_parts = line.split ","
    if line_parts.length != 2
      logthis "ERR: file path in " + line + " is invalid. Please remove commas from the file path."
      return
    file_path = line_parts[0] # Valid image path
    album_id = line_parts[1]  # Valid Salesforce ID (18-character)

    if (file_path != null && file_path != undefined && album_id != null && album_id != undefined)
      uploads.push(
        (callback)->
          if fs.existsSync(file_path)
            sharinpix.upload(file_path, album_id)
              .then((image)->
                logthis file_path + " uploaded to " + image.album_id
                callback()
              )
              .catch((err)->
                logthis "ERR: " + file_path + " upload failed."
                callback()
              )
          else
            logthis "ERR: " + file_path + " does not exist."
            callback()
      )
)

all_done = (images)->
  logthis "*** Script run complete. ***"
  wstream.end()

async.parallelLimit uploads, 2, all_done
