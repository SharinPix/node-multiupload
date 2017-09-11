To upload images, you need a CSV file containing a valid image path and the Salesforce album ID
  to which each image will be uploaded to.

This file should follow the example of the included Images.csv , i.e. the lines should be like:
Path/to/Image1.jpg,00158000003NLMyAAO
Path/to/Image2.jpg,00158000003NLNyAAO

The program uploads images 2 by 2 until all files specified in the CSV are uploaded.

To run the program, open the multiupload folder (where index.js is located) on your terminal.
Then run the command below.
Make sure you replace sharinpix://SECRET_ID:SECRET_SECRET@api.sharinpix.com/api/v1
  by a valid secret generated from your SharinPix organization (SharinPix Admin > Secrets).

SHARINPIX_URL=sharinpix://SECRET_ID:SECRET_SECRET@api.sharinpix.com/api/v1 node index.js