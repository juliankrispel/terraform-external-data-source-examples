const https = require('https');
const fs = require('fs');

const file = fs.createWriteStream("lambda_layer.zip");
const options = { headers: { 'User-Agent': 'node-script' }}

https.get(
  // github's api for getting the latest releases of a repository
  "https://api.github.com/repos/hayd/deno-lambda/releases/latest",
  options,
  (res) => {
    res.setEncoding('utf8');

    let rawData = '';

    // since we're using the standard node interface
    res.on('data', (chunk) => { rawData += chunk; });
    res.on('end', () => {
      const parsedData = JSON.parse(rawData);

      const { browser_download_url } = parsedData.assets.find((asset) => 
        asset.name === 'deno-lambda-layer.zip'
      )

      https.get(
        browser_download_url,
        options,
      (res) => {
        // follow redirect
        if (res.statusCode === 302) {
        https.get(
          res.headers.location,
          options,
          (res) => {
            res.pipe(file)
            res.on('end', () => {
              console.log(JSON.stringify({ file: 'lambda_layer.zip' }))
            })
          })
      } else {
          res.pipe(file)
          res.on('end', () => {
            console.log(JSON.stringify({ file: 'lambda_layer.zip' }))
          })
        }
      });
    });
  }
)

